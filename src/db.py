import os
from neo4j import GraphDatabase
from dotenv import load_dotenv

load_dotenv()  # baca file .env

NEO4J_URI = os.getenv("NEO4J_URI")
NEO4J_USER = os.getenv("NEO4J_USER")
NEO4J_PASSWORD = os.getenv("NEO4J_PASSWORD")

print("URI    :", NEO4J_URI)
print("USER   :", NEO4J_USER)
driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))

def test_connection():
    with driver.session() as session:
        result = session.run("MATCH (n) RETURN count(n) AS cnt")
        print("Total node:", result.single()["cnt"])

def get_shinobi_info(name: str):
    cypher = """
    MATCH (s:ns0__Shinobi)
    WITH s, split(coalesce(s.uri, s.id, ""), "#") AS parts
    WITH s, (CASE WHEN size(parts) > 1 THEN parts[1] ELSE parts[0] END) AS localName
    WHERE toLower(localName) CONTAINS toLower($name)
    OPTIONAL MATCH (s)-[:ns0__isFrom]->(v)
    OPTIONAL MATCH (s)-[:ns0__masterJutsu]->(j)
    RETURN s, collect(DISTINCT v) AS villages, collect(DISTINCT j) AS jutsus
    LIMIT 5
    """
    with driver.session() as session:
        records = list(session.run(cypher, name=name))
        if not records:
            return None

        rec = records[0]
        s = rec["s"]
        villages = rec["villages"]
        jutsus = rec["jutsus"]

        def node_name(n):
            if not n:
                return None
            name = n.get("displayName") or n.get("name")
            if name:
                return name
            uri = n.get("uri") or n.get("id")
            if uri and "#" in uri:
                return uri.split("#")[-1]
            return uri

        data = {
            "name": node_name(s),
            "villages": [node_name(v) for v in villages if v],
            "jutsus": [node_name(j) for j in jutsus if j],
        }
        return data



def get_clan_members(clan_name: str):
    cypher = """
    MATCH (c:ns0__Clan)
    WHERE toLower(coalesce(c.name, c.uri, "")) CONTAINS toLower($clan)
    OPTIONAL MATCH (s)-[:ns0__isClanMemberOf]-(c)
    RETURN c, collect(DISTINCT s) AS members
    """
    with driver.session() as session:
        rec = session.run(cypher, clan=clan_name).single()
        if not rec:
            return None

        c = rec["c"]
        members = rec["members"]

        def node_name(n):
            if not n:
                return None
            name = n.get("displayName") or n.get("name")
            if name:
                return name
            uri = n.get("uri") or n.get("id")
            if uri and "#" in uri:
                return uri.split("#")[-1]
            return uri

        return {
            "clan": node_name(c),
            "members": [node_name(m) for m in members if m],
        }



def get_jutsu_users(jutsu_name: str):
    cypher = """
    MATCH (u)-[:ns0__masterJutsu]->(j)
    WITH u, j, split(coalesce(j.name, j.uri, ""), "#") AS parts
    WITH u, j,
         CASE
             WHEN size(parts) > 1 THEN parts[1]
             ELSE parts[0]
         END AS localName
    WHERE toLower(localName) CONTAINS toLower($jutsu)
    RETURN j, collect(DISTINCT u) AS users
    """
    with driver.session() as session:
        rec = session.run(cypher, jutsu=jutsu_name).single()
        if not rec:
            return None

        j = rec["j"]
        users = rec["users"]

        def node_name(n):
            if not n:
                return None
            name = n.get("name")
            if name:
                return name
            uri = n.get("uri")
            if uri and "#" in uri:
                return uri.split("#")[-1]
            return uri

        return {
            "jutsu": node_name(j),
            "users": [node_name(u) for u in users if u],
        }




if __name__ == "__main__":
    test_connection()
    print(get_shinobi_info("Chojuro"))
    print(get_clan_members("Uchiha"))
    print(get_jutsu_users("Rasengan"))