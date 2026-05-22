### A Pluto.jl notebook ###
# v0.20.27

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 7bb9ca61-2b2d-42af-8205-c19b1389f031
begin
    import Pkg
    Pkg.activate(joinpath(@__DIR__, ".."))
    using Fifa
    using PlutoUI
end

# ╔═╡ aa000001-0001-0001-0001-000000000001
begin
    data = load_data(joinpath(@__DIR__, "..", "data", "players_22.csv"))
    terrain = Terrain(90, 120, 16)
    cluster_labels, archetype_names = cluster_players(data)
    md"**Dataset loaded** — $(size(data, 1)) players · archetypes: $(join(unique(archetype_names), \", \"))"
end

# ╔═╡ cc000001-0001-0001-0001-000000000001
md"""
# ⚽ FIFA 22 Squad Analytics

Build two squads, compare them head-to-head, and explore data-driven archetypes, position fit scores, and similarity search.
"""

# ╔═╡ 1b4d32d5-b3d3-44ff-a0c1-1a9577436ccd
md"""
---
## Team 1
**Formation:** $(@bind form1_input Select([442, 433, 4231], default=442))
"""

# ╔═╡ 7c4aa36b-577d-4993-be6f-6d12614e3e67
@bind team1 player_input(data, 1)

# ╔═╡ 298808b1-9ffc-4431-8c4f-746ab28c419c
md"""
---
## Team 2
**Formation:** $(@bind form2_input Select([442, 433, 4231], default=433))
"""

# ╔═╡ 624ca9cf-ecc9-401b-98ce-19a894da6131
@bind team2 player_input(data, 2)

# ╔═╡ b9bce6c2-2759-41c9-b7ab-1fcb311c2acd
begin
    barca  = build_team("Team 1", team1, dict_formations[form1_input], data)
    real   = build_team("Team 2", team2, dict_formations[form2_input], data)
    score1 = round(calcul_team_score(barca), digits=2)
    score2 = round(calcul_team_score(real),  digits=2)
    nothing
end

# ╔═╡ dd000001-0001-0001-0001-000000000001
md"""
---
## Pitch View
"""

# ╔═╡ 7bd9d0eb-1363-4cf8-8c58-fe3cddfa6834
draw(terrain, 500, dict_formations[form1_input], barca, dict_formations[form2_input], real)

# ╔═╡ ee000001-0001-0001-0001-000000000001
md"""
---
## Head-to-Head Scores
| Team | Formation | Score |
|------|-----------|-------|
| **$(barca.name)** | $(form1_input) | $score1 |
| **$(real.name)**  | $(form2_input) | $score2 |

> Score = average position-adjusted player rating across all 11 slots.
"""

# ╔═╡ ff000001-0001-0001-0001-000000000001
begin
    arch1_lines = join(
        ["- **$(p.name)** ($(p.current_position)) — *$(player_archetype(p.name, data, cluster_labels, archetype_names))*  fit: $(round(position_fit_score(data[findfirst(==(p.name), String.(data.short_name)), :], p.current_position), digits=2))"
         for p in barca.player],
        "\n"
    )
    md"""
    ---
    ## Archetypes & Position Fit — Team 1
    $arch1_lines
    """
end

# ╔═╡ ff000002-0002-0002-0002-000000000002
begin
    arch2_lines = join(
        ["- **$(p.name)** ($(p.current_position)) — *$(player_archetype(p.name, data, cluster_labels, archetype_names))*  fit: $(round(position_fit_score(data[findfirst(==(p.name), String.(data.short_name)), :], p.current_position), digits=2))"
         for p in real.player],
        "\n"
    )
    md"""
    ---
    ## Archetypes & Position Fit — Team 2
    $arch2_lines
    """
end

# ╔═╡ aa000002-0002-0002-0002-000000000002
md"""
---
## Similarity Search
Find the *n* most similar players to any target in normalized attribute space.

**Player:** $(@bind sim_target Select(String.(data.short_name[1:200]), default="L. Messi"))
"""

# ╔═╡ aa000003-0003-0003-0003-000000000003
begin
    sim_df   = find_similar_players(sim_target, data, 5)
    sim_rows = join(
        ["- **$(String(r.short_name))** ($(String(r.player_positions))) — overall $(r.overall)"
         for r in eachrow(sim_df)],
        "\n"
    )
    md"""
    **5 players most similar to $(sim_target):**

    $sim_rows
    """
end

# ╔═╡ bb000003-0003-0003-0003-000000000003
begin
    top200    = data.short_name[1:200]
    best_team = optimal_squad(top200, dict_formations[433], data)
    best_lines = join(
        ["- **$(p.current_position)**: $(p.name) — overall $(round(Int, p.initial_rating))  fit: $(round(position_fit_score(data[findfirst(==(p.name), String.(data.short_name)), :], p.current_position), digits=2))"
         for p in best_team.player],
        "\n"
    )
    md"""
    ---
    ## Optimal XI (4-3-3) · Top 200 Players
    > Greedy assignment maximising `position_fit_score × overall` per slot.

    $best_lines
    """
end

# ╔═╡ Cell order:
# ╠═7bb9ca61-2b2d-42af-8205-c19b1389f031
# ╠═aa000001-0001-0001-0001-000000000001
# ╟─cc000001-0001-0001-0001-000000000001
# ╟─1b4d32d5-b3d3-44ff-a0c1-1a9577436ccd
# ╠═7c4aa36b-577d-4993-be6f-6d12614e3e67
# ╟─298808b1-9ffc-4431-8c4f-746ab28c419c
# ╠═624ca9cf-ecc9-401b-98ce-19a894da6131
# ╟─b9bce6c2-2759-41c9-b7ab-1fcb311c2acd
# ╟─dd000001-0001-0001-0001-000000000001
# ╠═7bd9d0eb-1363-4cf8-8c58-fe3cddfa6834
# ╟─ee000001-0001-0001-0001-000000000001
# ╠═ff000001-0001-0001-0001-000000000001
# ╠═ff000002-0002-0002-0002-000000000002
# ╟─aa000002-0002-0002-0002-000000000002
# ╠═aa000003-0003-0003-0003-000000000003
# ╠═bb000003-0003-0003-0003-000000000003
