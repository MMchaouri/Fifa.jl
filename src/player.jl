using Vizagrams, PlutoUI, Markdown, DataFrames

struct Player
    name::String
    initial_rating::Float64
    preferred_position::String
    current_position::String
    Player(name, rating, pref_pos, cur_pos) = new(
        String(name),
        isa(rating, Number) ? Float64(rating) : parse(Float64, string(rating)),
        String(pref_pos),
        String(cur_pos)
    )
end

struct Team
    name::String
    player::Vector{Player}
end

struct Formation
    nom::Int64
    postes::Vector{String}
end

function find_position_category(position::String)
    for (category, positions) in POSITION_GROUPS
        for i in 1:length(positions)
            if contains(position, positions[i])
                return category
            end
        end
    end
    return "Unknown"
end

function adjust_rating(player::Player)
    preferred_category = find_position_category(player.preferred_position)
    current_category = find_position_category(player.current_position)

    if contains(player.preferred_position, player.current_position)
        return player.initial_rating
    elseif preferred_category == current_category
        return player.initial_rating * 0.9
    else
        return player.initial_rating * 0.6
    end
end

function find_player_by_name(name::String, list_players::Vector{Player})
    for player in list_players
        if cmp(player.name, name) == 0
            return player
        end
    end
    print("Player not found")
end

function calcul_team_score(team::Team)
    rate = [adjust_rating(i) for i in team.player]
    return sum(rate) / length(rate)
end

function creation_formation(form::Formation, side::Int64, team::Team)
    i = 0
    if side == 1
        i = 1; col = :blue
    elseif side == 2
        i = -1; col = :red
    end

    players = S(:fill => col)*Rectangle(w=4, h=4, c=dict_postes["GK"].coordonnees*i) +
              S(:fill => :black)*TextMark(text=team.player[1].name, fontsize=3, pos=dict_postes["GK"].coordonnees*i + i*[0,5]) +
              S(:fill => :white)*TextMark(text=1, fontsize=3, pos=dict_postes["GK"].coordonnees*i)
    num = 2
    for j in form.postes
        rect = S(:fill => col)*Rectangle(w=4, h=4, c=dict_postes[j].coordonnees*i)
        text = S(:fill => :black)*TextMark(text=team.player[num].name, fontsize=3, pos=dict_postes[j].coordonnees*i + i*[0, -5]) +
               S(:fill => :white)*TextMark(text=num, fontsize=3, pos=dict_postes[j].coordonnees*i)
        players += rect + text
        num += 1
    end
    return players
end

const _SLOT_POSITIONS = ["GK", "CB", "LB", "RB", "CDM", "CM", "LM", "RM", "LW", "ST", "RW"]

function _default_player(df::DataFrame, pos::String, skip::Int)
    matches = filter(r -> contains(String(r.player_positions), pos), df)
    isempty(matches) && return String(df[1, :short_name])
    return String(matches[min(skip + 1, nrow(matches)), :short_name])
end

function build_team(name::String, selections, formation::Formation, df::DataFrame)::Team
    slots = ["GK"; formation.postes]
    players = [
        Player(
            getfield(selections, Symbol("P$i")),
            df[findfirst(==(getfield(selections, Symbol("P$i"))), String.(df.short_name)), :overall],
            df[findfirst(==(getfield(selections, Symbol("P$i"))), String.(df.short_name)), :player_positions],
            slots[i]
        )
        for i in 1:11
    ]
    return Team(name, players)
end

function player_input(df::DataFrame, team::Int=1)
    skip = team - 1
    options = String.(df.short_name[1:200])
    defaults = [_default_player(df, pos, skip) for pos in _SLOT_POSITIONS]
    return PlutoUI.combine() do Child
        inputs = [
            md""" $(name): $(Child(name, Select(options, default=def)))"""
            for (name, def) in zip(["P1","P2","P3","P4","P5","P6","P7","P8","P9","P10","P11"], defaults)
        ]
        md"""$(inputs)"""
    end
end
