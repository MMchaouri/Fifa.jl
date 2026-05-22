using DataFrames, Statistics, Clustering

const CORE_ATTRS = [:pace, :shooting, :passing, :dribbling, :defending, :physic]
const GK_ATTRS   = [:goalkeeping_diving, :goalkeeping_handling, :goalkeeping_kicking,
                    :goalkeeping_positioning, :goalkeeping_reflexes]

# Weights: [pace, shooting, passing, dribbling, defending, physic]
const POSITION_ATTR_WEIGHTS = Dict{String, Vector{Float64}}(
    "GK"   => [0.05, 0.00, 0.05, 0.00, 0.10, 0.15],
    "CB"   => [0.10, 0.05, 0.15, 0.05, 0.50, 0.15],
    "LCB"  => [0.10, 0.05, 0.15, 0.05, 0.50, 0.15],
    "RCB"  => [0.10, 0.05, 0.15, 0.05, 0.50, 0.15],
    "LB"   => [0.20, 0.05, 0.15, 0.10, 0.35, 0.15],
    "RB"   => [0.20, 0.05, 0.15, 0.10, 0.35, 0.15],
    "LWB"  => [0.25, 0.10, 0.15, 0.15, 0.20, 0.15],
    "RWB"  => [0.25, 0.10, 0.15, 0.15, 0.20, 0.15],
    "CDM"  => [0.10, 0.10, 0.20, 0.10, 0.35, 0.15],
    "LCDM" => [0.10, 0.10, 0.20, 0.10, 0.35, 0.15],
    "RCDM" => [0.10, 0.10, 0.20, 0.10, 0.35, 0.15],
    "CM"   => [0.10, 0.15, 0.30, 0.15, 0.15, 0.15],
    "LCM"  => [0.10, 0.15, 0.30, 0.15, 0.15, 0.15],
    "RCM"  => [0.10, 0.15, 0.30, 0.15, 0.15, 0.15],
    "LM"   => [0.20, 0.15, 0.20, 0.20, 0.10, 0.15],
    "RM"   => [0.20, 0.15, 0.20, 0.20, 0.10, 0.15],
    "CAM"  => [0.10, 0.20, 0.30, 0.25, 0.05, 0.10],
    "LW"   => [0.30, 0.20, 0.10, 0.30, 0.05, 0.05],
    "RW"   => [0.30, 0.20, 0.10, 0.30, 0.05, 0.05],
    "ST"   => [0.25, 0.40, 0.05, 0.10, 0.05, 0.15],
    "CF"   => [0.20, 0.35, 0.10, 0.20, 0.05, 0.10],
    "LCF"  => [0.20, 0.35, 0.10, 0.20, 0.05, 0.10],
    "RCF"  => [0.20, 0.35, 0.10, 0.20, 0.05, 0.10],
)

const ATTR_ARCHETYPE_NAMES = Dict(
    1 => "Pacey Attacker",
    2 => "Clinical Finisher",
    3 => "Deep-Lying Playmaker",
    4 => "Technical Dribbler",
    5 => "Defensive Rock",
    6 => "Physical Enforcer"
)

function position_fit_score(player_row::DataFrameRow, position::String)::Float64
    if position == "GK"
        vals = [Float64(coalesce(player_row[c], 0)) for c in GK_ATTRS]
        return mean(vals) / 100.0
    end
    weights = get(POSITION_ATTR_WEIGHTS, position, fill(1.0/6.0, 6))
    attrs = [Float64(coalesce(player_row[c], 0)) for c in CORE_ATTRS]
    return sum(w * a for (w, a) in zip(weights, attrs)) / 100.0
end

function cluster_players(df::DataFrame, k::Int=6)
    attrs = [Float64(coalesce(df[i, c], 0)) for i in 1:nrow(df), c in CORE_ATTRS]
    col_min = minimum(attrs, dims=1)
    col_max = maximum(attrs, dims=1)
    col_range = col_max .- col_min
    col_range[col_range .== 0] .= 1.0
    normalized = (attrs .- col_min) ./ col_range   # n_players × 6

    result = kmeans(normalized', k; maxiter=300)    # Clustering.jl expects features × samples
    labels = assignments(result)                     # Vector{Int} length n_players

    centers = result.centers'                        # k × 6
    archetype_names = [
        ATTR_ARCHETYPE_NAMES[argmax(centers[i, :])]
        for i in 1:k
    ]

    return labels, archetype_names
end

function find_similar_players(name::String, df::DataFrame, n::Int=5)::DataFrame
    idx = findfirst(==(name), df.short_name)
    isnothing(idx) && error("Player '$name' not found")

    attrs = [Float64(coalesce(df[i, c], 0)) for i in 1:nrow(df), c in CORE_ATTRS]
    target = attrs[idx, :]
    dists = [sqrt(sum((attrs[i, :] .- target).^2)) for i in 1:nrow(df)]
    dists[idx] = Inf

    sorted_idx = sortperm(dists)[1:n]
    cols = vcat([:short_name, :overall, :player_positions], CORE_ATTRS)
    return df[sorted_idx, cols]
end

function player_archetype(name::String, df::DataFrame, labels::Vector{Int}, archetype_names::Vector{String})::String
    idx = findfirst(==(name), df.short_name)
    isnothing(idx) && return "Unknown"
    return archetype_names[labels[idx]]
end
