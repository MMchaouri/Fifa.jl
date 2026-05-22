module Fifa

using Vizagrams, Colors, PlutoUI, CSV, DataFrames, Markdown, InteractiveUtils, Statistics, Clustering

export load_data
export Terrain, creation_terrain
export Player, adjust_rating, find_player_by_name
export Team, calcul_team_score
export Formation, creation_formation
export player_input, find_position_category
export dict_postes, dict_formations, POSITION_GROUPS, POSITION_CATEGORIES
export position_fit_score, cluster_players, find_similar_players, player_archetype
export optimal_squad

include("player.jl")
include("positions.jl")
include("pitch.jl")
include("data.jl")
include("analytics.jl")
include("optimization.jl")

end
