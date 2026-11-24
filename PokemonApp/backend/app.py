from flask import Flask, jsonify
from flask_cors import CORS
import requests
import random

app = Flask(__name__)

CORS(app)


# LISTA DE POKÉMON
@app.route("/pokemons", methods=["GET"])
def listar_pokemons():

    resposta = requests.get(
        "https://pokeapi.co/api/v2/pokemon?limit=30"
    )

    dados = resposta.json()

    pokemons = []

    for pokemon in dados["results"]:

        detalhes = requests.get(
            pokemon["url"]
        ).json()

        pokemon_formatado = {
            "id": detalhes["id"],
            "nome": detalhes["name"],
            "imagem": detalhes["sprites"]["front_default"],
            "tipo": detalhes["types"][0]["type"]["name"]
        }

        pokemons.append(
            pokemon_formatado
        )

    return jsonify(pokemons)


# FORMATA OS DADOS DE UM POKÉMON (usada por todas as rotas de detalhes)
def formatar_pokemon(dados):

    tipos = []

    for tipo in dados["types"]:
        tipos.append(
            tipo["type"]["name"]
        )


    habilidades = []

    for habilidade in dados["abilities"]:
        habilidades.append(
            habilidade["ability"]["name"]
        )


    return {
        "id": dados["id"],
        "nome": dados["name"],
        "imagem": dados["sprites"]["front_default"],
        "altura": dados["height"],
        "peso": dados["weight"],
        "experiencia": dados["base_experience"],
        "tipos": tipos,
        "habilidades": habilidades,
        "hp": dados["stats"][0]["base_stat"],
        "ataque": dados["stats"][1]["base_stat"],
        "defesa": dados["stats"][2]["base_stat"],
        # PARTE 2: novas informações
        "ataque_especial": dados["stats"][3]["base_stat"],
        "velocidade": dados["stats"][5]["base_stat"]
    }


# BUSCA NA POKÉAPI (id ou nome) E DEVOLVE O JSON FORMATADO
def buscar_pokemon(identificador):

    resposta = requests.get(
        f"https://pokeapi.co/api/v2/pokemon/{identificador}"
    )

    if resposta.status_code != 200:
        return jsonify({
            "erro": "Pokémon não encontrado"
        }), 404

    return jsonify(
        formatar_pokemon(resposta.json())
    )


# DETALHES DE UM POKÉMON (por id)
@app.route("/pokemons/<int:id>", methods=["GET"])
def detalhes_pokemon(id):

    return buscar_pokemon(id)


# PARTE 1: BUSCAR POR NOME
@app.route("/pokemons/nome/<nome>", methods=["GET"])
def pokemon_por_nome(nome):

    return buscar_pokemon(
        nome.strip().lower()
    )


# PARTE 3: POKÉMON ALEATÓRIO
@app.route("/pokemons/aleatorio", methods=["GET"])
def pokemon_aleatorio():

    return buscar_pokemon(
        random.randint(1, 1025)
    )


if __name__ == "__main__":

    app.run(
        host="0.0.0.0",
        port=5001,
        debug=True
    )