from transformers import AutoModelForCausalLM, AutoTokenizer
import torch
from db import get_clan_members, get_jutsu_users, get_shinobi_info, test_connection

QWEN_MODEL_NAME = "Qwen/Qwen2.5-1.5B-Instruct"

print("Loading Qwen model...")
tokenizer = AutoTokenizer.from_pretrained(QWEN_MODEL_NAME)
model = AutoModelForCausalLM.from_pretrained(
    QWEN_MODEL_NAME,
    torch_dtype=torch.float16 if torch.cuda.is_available() else torch.float32,
    device_map="auto",  # otomatis ke GPU/CPU
)

import textwrap

def format_shinobi_info(info: dict) -> str:
    if not info:
        return ""

    lines = []

    name = info.get("name") or "Shinobi tidak dikenal"
    lines.append(f"Nama: {name}")

    if info.get("villages"):
        villages = ", ".join(info["villages"])
        lines.append(f"Asal desa: {villages}")

    if info.get("jutsus"):
        jutsus = ", ".join(info["jutsus"])
        lines.append(f"Jutsu yang dikuasai: {jutsus}")
    else:
        lines.append("Jutsu yang dikuasai: (tidak tercatat di graf)")

    return "\n".join(lines)


def format_clan_info(info: dict) -> str:
    if not info:
        return ""

    clan = info.get("clan") or "(nama klan tidak diketahui)"
    members = info.get("members") or []

    lines = [f"Klan: {clan}"]
    if members:
        lines.append("Anggota klan:")
        for m in members:
            lines.append(f"- {m}")
    else:
        lines.append("Belum ada anggota yang tercatat di graf.")

    return "\n".join(lines)


def format_jutsu_info(info: dict) -> str:
    if not info:
        return ""

    jutsu = info.get("jutsu") or "(nama jutsu tidak diketahui)"
    users = info.get("users") or []

    lines = [f"Jutsu: {jutsu}"]
    if users:
        lines.append("Pengguna jutsu ini:")
        for u in users:
            lines.append(f"- {u}")
    else:
        lines.append("Belum ada pengguna yang tercatat di graf.")

    return "\n".join(lines)



def generate_answer_with_llm(context: str, question: str) -> str:
    """
    Generator LLM untuk RAG, menggunakan Qwen 1B (chat-style).
    """

    system_prompt = (
        "Kamu adalah asisten yang ahli di dunia Naruto dan hanya boleh "
        "menjawab berdasarkan informasi yang diberikan di bawah. "
        "Jika informasi tidak lengkap, katakan dengan jujur bahwa data di graf tidak cukup. "
        "Jawab dalam bahasa Indonesia yang jelas dan singkat."
    )

    user_prompt = f"""
Berikut ini adalah informasi dari knowledge graph (Neo4j):

{context}

Pertanyaan pengguna:
{question}

Jawablah berdasarkan informasi di atas.
"""

    # Format chat untuk Qwen-style prompt (model chat)
    full_prompt = (
        f"<|im_start|>system\n{system_prompt}<|im_end|>\n"
        f"<|im_start|>user\n{user_prompt.strip()}<|im_end|>\n"
        f"<|im_start|>assistant\n"
    )

    print(full_prompt)

    inputs = tokenizer(full_prompt, return_tensors="pt").to(model.device)

    with torch.no_grad():
        outputs = model.generate(
            **inputs,
            max_new_tokens=256,
            do_sample=True,
            top_p=0.9,
            temperature=0.7,
            eos_token_id=tokenizer.eos_token_id,
        )

    generated = tokenizer.decode(outputs[0], skip_special_tokens=False)

    # Ambil hanya bagian setelah tag assistant terakhir
    if "<|im_start|>assistant" in generated:
        generated = generated.split("<|im_start|>assistant")[-1]
    if "<|im_end|>" in generated:
        generated = generated.split("<|im_end|>")[0]

    return generated.strip()

def build_context_from_question(question: str) -> str:
    q = question.lower()

    context_parts = []

    if "clan" in q or "klan" in q:
        clan_name = question.split()[-1]
        clan_info = get_clan_members(clan_name)
        formatted = format_clan_info(clan_info)
        if formatted:
            context_parts.append("=== Informasi Klan ===")
            context_parts.append(formatted)

    if "jutsu" in q:
        jutsu_name = question.replace("jutsu", "").replace("Jutsu", "").strip()
        jutsu_name = jutsu_name or question
        jutsu_info = get_jutsu_users(jutsu_name)
        formatted = format_jutsu_info(jutsu_info)
        if formatted:
            context_parts.append("=== Informasi Jutsu ===")
            context_parts.append(formatted)

    tokens = question.split()
    if tokens:
        shinobi_name = tokens[-1]
        shinobi_info = get_shinobi_info(shinobi_name)
        formatted = format_shinobi_info(shinobi_info)
        if formatted:
            context_parts.append("=== Informasi Shinobi ===")
            context_parts.append(formatted)

    if not context_parts:
        return "Graf tidak mengembalikan informasi apa pun untuk pertanyaan ini."

    return "\n\n".join(context_parts)


def answer_question(question: str) -> str:
    context = build_context_from_question(question)
    answer = generate_answer_with_llm(context, question)
    return answer


if __name__ == "__main__":
    test_connection()

    print("\n=== RAG Chat (Qwen 1B) ===")
    while True:
        q = input("\nPertanyaan (ketik 'exit' untuk keluar): ")
        if q.lower() in ["exit", "quit"]:
            break
        jawaban = answer_question(q)
        print("\n=== Jawaban RAG ===")
        print(jawaban)
