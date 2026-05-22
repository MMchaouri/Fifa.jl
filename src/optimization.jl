using DataFrames

function optimal_squad(player_pool::AbstractVector{<:AbstractString}, formation::Formation, df::DataFrame)::Team
    pool_df = filter(row -> row.short_name in player_pool, df)
    positions = ["GK"; formation.postes]
    assigned = Player[]
    used = Set{String}()

    for pos in positions
        best_player = nothing
        best_score  = -Inf
        for row in eachrow(pool_df)
            String(row.short_name) in used && continue
            score = position_fit_score(row, pos) * _to_f64(coalesce(row.overall, "0"))
            if score > best_score
                best_score  = score
                best_player = Player(
                    String(row.short_name),
                    _to_f64(coalesce(row.overall, "0")),
                    String(row.player_positions),
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
