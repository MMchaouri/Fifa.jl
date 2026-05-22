### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 7bb9ca61-2b2d-42af-8205-c19b1389f031
using Main.Fifa

# ╔═╡ aa000001-0001-0001-0001-000000000001
data = load_data("data/players_22.csv")

# ╔═╡ aa000002-0002-0002-0002-000000000002
terrain = Terrain(90, 120, 16)

# ╔═╡ 1b4d32d5-b3d3-44ff-a0c1-1a9577436ccd
md" Formation équipe 1 :  $(@bind form1_input Select([0, 442, 433, 4231, 222, 111], default=442))"

# ╔═╡ 7c4aa36b-577d-4993-be6f-6d12614e3e67
@bind team1 player_input(data)

# ╔═╡ 298808b1-9ffc-4431-8c4f-746ab28c419c
md" Formation équipe 2 :  $(@bind form2_input Select([0, 442, 433, 4231, 222, 111], default=442))"

# ╔═╡ 624ca9cf-ecc9-401b-98ce-19a894da6131
@bind team2 player_input(data)

# ╔═╡ b9bce6c2-2759-41c9-b7ab-1fcb311c2acd
begin
	P1 = Player(team1.P1,
			data[data.short_name .== team1.P1, :overall][1],
			data[data.short_name .== team1.P1, :player_positions][1],
			"GK")
	
	P2 = Player(team1.P2,
			data[data.short_name .== team1.P2, :overall][1],
			data[data.short_name .== team1.P2, :player_positions][1],
			dict_postes[dict_formations[form1_input].postes[1]].nom)
	
	P3 = Player(team1.P3,
			data[data.short_name .== team1.P3, :overall][1],
			data[data.short_name .== team1.P3, :player_positions][1],
			dict_postes[dict_formations[form1_input].postes[2]].nom)
	
	P4 = Player(team1.P4,
			data[data.short_name .== team1.P4, :overall][1],
			data[data.short_name .== team1.P4, :player_positions][1],
			dict_postes[dict_formations[form1_input].postes[3]].nom)
	
	
	P5 = Player(team1.P5,
			data[data.short_name .== team1.P5, :overall][1],
			data[data.short_name .== team1.P5, :player_positions][1],
			dict_postes[dict_formations[form1_input].postes[4]].nom)
	
	P6 = Player(team1.P6,
			data[data.short_name .== team1.P6, :overall][1],
			data[data.short_name .== team1.P6, :player_positions][1],
			dict_postes[dict_formations[form1_input].postes[5]].nom)
	
	P7 = Player(team1.P7,
			data[data.short_name .== team1.P7, :overall][1],
			data[data.short_name .== team1.P7, :player_positions][1],
			dict_postes[dict_formations[form1_input].postes[6]].nom)
	
	P8 = Player(team1.P8,
			data[data.short_name .== team1.P8, :overall][1],
			data[data.short_name .== team1.P8, :player_positions][1],
			dict_postes[dict_formations[form1_input].postes[7]].nom)
	
	P9 = Player(team1.P9,
			data[data.short_name .== team1.P9, :overall][1],
			data[data.short_name .== team1.P9, :player_positions][1],
			dict_postes[dict_formations[form1_input].postes[8]].nom)
	
	P10 = Player(team1.P10,
			data[data.short_name .== team1.P10, :overall][1],
			data[data.short_name .== team1.P10, :player_positions][1],
			dict_postes[dict_formations[form1_input].postes[9]].nom)
	
	P11 = Player(team1.P11,
			data[data.short_name .== team1.P11, :overall][1],
			data[data.short_name .== team1.P11, :player_positions][1],
			dict_postes[dict_formations[form1_input].postes[10]].nom)
	
	J1 = Player(team2.P1,
			data[data.short_name .== team2.P1, :overall][1],
			data[data.short_name .== team2.P1, :player_positions][1],
			"GK")
	
	J2 = Player(team2.P2,
			data[data.short_name .== team2.P2, :overall][1],
			data[data.short_name .== team2.P2, :player_positions][1],
			dict_postes[dict_formations[form2_input].postes[1]].nom)

	J3 = Player(team2.P3,
			data[data.short_name .== team2.P3, :overall][1],
			data[data.short_name .== team2.P3, :player_positions][1],
			dict_postes[dict_formations[form2_input].postes[2]].nom)

	J4 = Player(team2.P4,
			data[data.short_name .== team2.P4, :overall][1],
			data[data.short_name .== team2.P4, :player_positions][1],
			dict_postes[dict_formations[form2_input].postes[3]].nom)

	J5 = Player(team2.P5,
			data[data.short_name .== team2.P5, :overall][1],
			data[data.short_name .== team2.P5, :player_positions][1],
			dict_postes[dict_formations[form2_input].postes[4]].nom)

	J6 = Player(team2.P6,
			data[data.short_name .== team2.P6, :overall][1],
			data[data.short_name .== team2.P6, :player_positions][1],
			dict_postes[dict_formations[form2_input].postes[5]].nom)

	J7 = Player(team2.P7,
			data[data.short_name .== team2.P7, :overall][1],
			data[data.short_name .== team2.P7, :player_positions][1],
			dict_postes[dict_formations[form2_input].postes[6]].nom)

	J8 = Player(team2.P8,
			data[data.short_name .== team2.P8, :overall][1],
			data[data.short_name .== team2.P8, :player_positions][1],
			dict_postes[dict_formations[form2_input].postes[7]].nom)

	J9 = Player(team2.P9,
			data[data.short_name .== team2.P9, :overall][1],
			data[data.short_name .== team2.P9, :player_positions][1],
			dict_postes[dict_formations[form2_input].postes[8]].nom)

	J10 = Player(team2.P10,
			data[data.short_name .== team2.P10, :overall][1],
			data[data.short_name .== team2.P10, :player_positions][1],
			dict_postes[dict_formations[form2_input].postes[9]].nom)

	J11 = Player(team2.P11,
			data[data.short_name .== team2.P11, :overall][1],
			data[data.short_name .== team2.P11, :player_positions][1],
			dict_postes[dict_formations[form2_input].postes[10]].nom)
	
	
	barca = Team("Barca", [P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11])
	real = Team("Real", [J1,J2,J3,J4,J5,J6,J7,J8,J9,J10,J11])
	
	score1 = round(calcul_team_score(barca), digits=2)
	score2 = round(calcul_team_score(real), digits=2)
end

# ╔═╡ 7bd9d0eb-1363-4cf8-8c58-fe3cddfa6834
draw(terrain, 500, dict_formations[form1_input], barca, dict_formations[form2_input], real )

# ╔═╡ 323aad99-7e5e-40ba-9cc6-8db240a2f4d6
md" Score équipe 1: $score1"

# ╔═╡ d94ddfbf-da6e-4d8f-b886-01bb9947163f
md" Score équipe 2: $score2"

# ╔═╡ Cell order:
# ╠═7bb9ca61-2b2d-42af-8205-c19b1389f031
# ╠═aa000001-0001-0001-0001-000000000001
# ╠═aa000002-0002-0002-0002-000000000002
# ╠═7bd9d0eb-1363-4cf8-8c58-fe3cddfa6834
# ╠═1b4d32d5-b3d3-44ff-a0c1-1a9577436ccd
# ╠═7c4aa36b-577d-4993-be6f-6d12614e3e67
# ╠═323aad99-7e5e-40ba-9cc6-8db240a2f4d6
# ╠═298808b1-9ffc-4431-8c4f-746ab28c419c
# ╠═624ca9cf-ecc9-401b-98ce-19a894da6131
# ╠═d94ddfbf-da6e-4d8f-b886-01bb9947163f
# ╠═b9bce6c2-2759-41c9-b7ab-1fcb311c2acd