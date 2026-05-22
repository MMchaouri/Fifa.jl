using DataFrames

function optimal_squad(player_pool::Vector{String}, formation::Formation, df::DataFrame)::Team
    pool_df = filter(row -> row.short_name in player_pool, df)
    positions = ["GK"; formation.postes]
    assigned = Player[]
    used = Set{String}()

    for pos in positions
        best_player = nothing
        best_score  = -Inf
        for row in eachrow(pool_df)
            row.short_name in used && continue
            score = position_fit_score(row, pos) * Float64(coalesce(row.overall, 0))
            if score > best_score
                best_score  = score
                best_player = Player(
                    row.short_name,
                    Float64(coalesce(row.overall, 0)),
                    row.player_positions,
                    pos
                )
            end
        end
        if !isnothing(best_player)
            push!(assigned, best_player)
            push!(used, best_player.name)
        end
    end

    return Team("Optimal Squad", assigned)
end
