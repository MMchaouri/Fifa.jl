struct Position
    nom::String
    coordonnees::Vector{Float64}
end

const _terrain_ref = (largeur=90, longueur=120)

const dict_postes = Dict{String, Position}(
    "GK"   => Position("GK",   [0, -(_terrain_ref.longueur/2-3)]),
    "LB"   => Position("LB",   [-(_terrain_ref.largeur/2-10), -(2*(_terrain_ref.longueur/2-6)/3+3)]),
    "CB"   => Position("CB",   [0, -(2*(_terrain_ref.longueur/2-6)/3+3)]),
    "LCB"  => Position("CB",   [-(_terrain_ref.largeur/2-10-(_terrain_ref.largeur-20)/3), -(2*(_terrain_ref.longueur/2-6)/3+3)]),
    "RCB"  => Position("CB",   [_terrain_ref.largeur/2-10-(_terrain_ref.largeur-20)/3, -(2*(_terrain_ref.longueur/2-6)/3+3)]),
    "RB"   => Position("RB",   [_terrain_ref.largeur/2-10, -(2*(_terrain_ref.longueur/2-6)/3+3)]),
    "CM"   => Position("CM",   [0, -((_terrain_ref.longueur/2-6)/3+3)]),
    "CDM"  => Position("CDM",  [0, -((_terrain_ref.longueur/2-6)/3+3)-(-((_terrain_ref.longueur/2-6)/3+3)+2*(_terrain_ref.longueur/2-6)/3+3)/2]),
    "LCDM" => Position("CDM",  [-(_terrain_ref.largeur/2-10-(_terrain_ref.largeur-20)/3), -((_terrain_ref.longueur/2-6)/3+3)-(-((_terrain_ref.longueur/2-6)/3+3)+(2*(_terrain_ref.longueur/2-6)/3+3))/2]),
    "RCDM" => Position("CDM",  [_terrain_ref.largeur/2-10-(_terrain_ref.largeur-20)/3, -((_terrain_ref.longueur/2-6)/3+3)-(-((_terrain_ref.longueur/2-6)/3+3)+(2*(_terrain_ref.longueur/2-6)/3+3))/2]),
    "CAM"  => Position("CAM",  [0, -((_terrain_ref.longueur/2-6)/3+3)+(-((_terrain_ref.longueur/2-6)/3+3)+(2*(_terrain_ref.longueur/2-6)/3+3))/2]),
    "LWB"  => Position("LWB",  [-(_terrain_ref.largeur/2-10), -((_terrain_ref.longueur/2-6)/3+3)-(-((_terrain_ref.longueur/2-6)/3+3)+2*(_terrain_ref.longueur/2-6)/3+3)/2]),
    "RWB"  => Position("RWB",  [_terrain_ref.largeur/2-10, -((_terrain_ref.longueur/2-6)/3+3)-(-((_terrain_ref.longueur/2-6)/3+3)+2*(_terrain_ref.longueur/2-6)/3+3)/2]),
    "LCM"  => Position("CM",   [-(_terrain_ref.largeur/2-10-(_terrain_ref.largeur-20)/3), -((_terrain_ref.longueur/2-6)/3+3)]),
    "RCM"  => Position("CM",   [_terrain_ref.largeur/2-10-(_terrain_ref.largeur-20)/3, -((_terrain_ref.longueur/2-6)/3+3)]),
    "LM"   => Position("LM",   [-(_terrain_ref.largeur/2-10), -((_terrain_ref.longueur/2-6)/3+3)]),
    "RM"   => Position("RM",   [_terrain_ref.largeur/2-10, -((_terrain_ref.longueur/2-6)/3+3)]),
    "LW"   => Position("LW",   [-(_terrain_ref.largeur/2-10), -((_terrain_ref.longueur/2-6)/3+3)+(-((_terrain_ref.longueur/2-6)/3+3)+(2*(_terrain_ref.longueur/2-6)/3+3))/2]),
    "RW"   => Position("RW",   [_terrain_ref.largeur/2-10, -((_terrain_ref.longueur/2-6)/3+3)+(-((_terrain_ref.longueur/2-6)/3+3)+(2*(_terrain_ref.longueur/2-6)/3+3))/2]),
    "CF"   => Position("CF",   [0, -3]),
    "ST"   => Position("ST",   [0, -3]),
    "LCF"  => Position("CF",   [-(_terrain_ref.largeur/2-10-(_terrain_ref.largeur-20)/3), -3]),
    "RCF"  => Position("CF",   [_terrain_ref.largeur/2-10-(_terrain_ref.largeur-20)/3, -3])
)

# Bug fix: was Dict{Int64, Formation} with Symbol keys (:442 etc.) — now uses Int64 keys (442)
const dict_formations = Dict{Int64, Formation}(
    0    => Formation(0,   ["LB", "LCB", "CB", "RCB", "RB", "LWB", "RWB", "CDM", "LCM", "CM", "RCM", "CAM", "LM", "RM", "LW", "RW", "LCF", "RCF", "ST"]),
    442  => Formation(442, ["LB", "LCB", "RCB", "RB", "LM", "LCM", "RCM", "RM", "LCF", "RCF"]),
    433  => Formation(433, ["LB", "LCB", "RCB", "RB", "CDM", "LCM", "RCM", "LW", "RW", "ST"]),
    4231 => Formation(4231, ["LB", "LCB", "RCB", "RB", "LCM", "RCM", "CAM", "LW", "RW", "ST"]),
    111  => Formation(111, ["CM", "RCM", "CAM", "LM", "RM", "LW", "RW", "LCF", "RCF", "ST"]),
    222  => Formation(222, ["LB", "LCB", "CB", "RCB", "RB", "LWB", "RWB", "CDM", "LCM", "CM"])
)

const POSITION_CATEGORIES = Dict(
    "GK"  => "Goalkeeper",
    "LB"  => "Left Back",
    "CB"  => "Center Back",
    "RB"  => "Right Back",
    "LWB" => "Left Wing Back",
    "RWB" => "Right Wing Back",
    "CDM" => "Central Defensive Midfield",
    "CM"  => "Central Midfield",
    "CAM" => "Central Attacking Midfield",
    "LM"  => "Left Midfield",
    "RM"  => "Right Midfield",
    "LW"  => "Left Wing",
    "RW"  => "Right Wing",
    "ST"  => "Striker",
    "CF"  => "Center Forward"
)

const POSITION_GROUPS = Dict(
    "Goalkeeper" => ["GK"],
    "Defense"    => ["LB", "CB", "RB", "LWB", "RWB"],
    "Midfield"   => ["CDM", "CM", "CAM", "LM", "RM"],
    "Forward"    => ["LW", "RW", "ST", "CF"]
)
