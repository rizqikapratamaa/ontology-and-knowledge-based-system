# Naruto Ontology & Knowledge-Based System 🍥

![Prolog](https://img.shields.io/badge/Prolog-SWI--Prolog-red) ![Ontology](https://img.shields.io/badge/Ontology-OWL%2FRDF-blue) ![Protege](https://img.shields.io/badge/Tool-Protégé-green)

> **IF4070 Knowledge Representation and Reasoning Project** > Department of Informatics, School of Electrical Engineering and Informatics, Institut Teknologi Bandung (ITB).

This project implements a **Knowledge-Based System (KBS)** centered on the **Naruto Universe**. It integrates an ontology designed using **Protégé** (exported as RDF/XML) with an inference engine built using **SWI-Prolog**. The system performs complex reasoning tasks, such as combat simulation, threat analysis, and lineage tracking using Description Logic and procedural rules.

---

## 📋 Table of Contents
- [Domain Description](#-domain-description)
- [Ontology Design](#-ontology-design)
- [System Architecture](#-system-architecture)
- [Installation & Usage](#-installation--usage)
- [File Structure](#-file-structure)
- [Authors](#-authors)

---

## 🌏 Domain Description

The domain focuses on the fictional universe of **Naruto** (created by Masashi Kishimoto). The knowledge base captures the intricate relationships between Shinobi, Villages, Clans, Jutsu, and Tailed Beasts (Bijuu).

**Scope & Limitations:**
* **Temporal:** Covers the *Naruto Shippuden* era up to the beginning of *Boruto*.
* **Entities:** Approximately 50 significant characters.
* **Canon:** Based strictly on Manga/Wiki canon (no anime-only filler).
* **Status:** Simplified into `Alive`, `Deceased`, or `Sealed`.

---

## 🦉 Ontology Design

The ontology is built using **Description Logic (DL)** principles to define the hierarchy and constraints of the world.

### 1. Main Classes (`TBox`)
* **Shinobi:** Subclassed by Rank (Genin, Chuunin, Jounin, Kage, Sennin, Nukenin).
* **Village:** Divided into `Big_Village` (e.g., Konoha) and `Small_Village`.
* **Jutsu:** Ninjutsu, Taijutsu, Genjutsu, and Kekkei Genkai.
* **Eye (Dojutsu):** Sharingan, Rinnegan, Byakugan, NormalEye.
* **Elemental:** The 5 nature types (Katon, Suiton, Doton, Futon, Raiton) + Mokuton.
* **Organization:** Akatsuki, Seven Swordsmen of the Mist.
* **Bijuu:** Tailed beasts (1-9 tails).

### 2. Properties
* **Object Properties:** `hasElement`, `hasEye`, `hasTeacher`/`hasStudent`, `isFrom`, `isClanMemberOf`, `isJinchuurikiOf`.
* **Data Properties:** `status` (string), `tailNumber` (integer).

---

## 🏗 System Architecture

The system follows the **Baader (2003)** architecture, separating the Terminological Box (TBox) and Assertional Box (ABox).

1.  **Knowledge Base:** `naruto.rdf` (The exported ontology containing facts).
2.  **Inference Engine:** SWI-Prolog (using the `semweb` library).
3.  **Rule Base:**
    * `rules_basic.pl`: Data retrieval.
    * `rules_combat.pl`: Combat logic (e.g., Fire > Wind).
    * `rules_inference.pl`: High-level reasoning (e.g., Threat assessment).


## 💻 Installation & Usage

### Prerequisites
* **SWI-Prolog** (Ensure it is installed and added to your PATH).

### Steps
1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/rizqikapratamaa/ontology-and-knowledge-based-system.git](https://github.com/rizqikapratamaa/ontology-and-knowledge-based-system.git)
    cd ontology-and-knowledge-based-system
    ```

2.  **Run SWI-Prolog** from the root directory:
    ```bash
    swipl
    ```

3.  **Load the Main File:**
    Inside the Prolog console `?-`, type:
    ```prolog
    ['src/main'].
    ```
    *Note: Ensure the path to `data/naruto.rdf` in `config.pl` is correct relative to where you run the command.*

4.  **Start the Interface:**
    ```prolog
    start.
    ```
    This will display the menu of available commands.

---

## 📂 File Structure

```text
.
├── data/
│   └── naruto.rdf            # The Ontology file (Knowledge Base)
├── doc/
│   └── Laporan Tugas Proyek 1 IF4070 - Kelompok J.pdf     # Project Report
├── src/
│   ├── config.pl             # RDF Loading & Namespace configuration
│   ├── main.pl               # Entry point & Menu interface
│   ├── rules_basic.pl        # Level 1 Rules
│   ├── rules_combat.pl       # Level 2 Rules
│   └── rules_inference.pl    # Level 3 Rules
└── README.md