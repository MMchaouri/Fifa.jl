using Fifa
using Test
using DataFrames

function make_test_df()
    DataFrame(
        short_name = ["Striker A", "Keeper B", "Defender C", "Winger D", "Midfielder E",
                      "Striker F", "Keeper G", "Defender H", "Winger I", "Midfielder J",
                      "Fullback K"],
        overall = [85, 82, 80, 78, 77, 75, 73, 72, 70, 68, 66],
        player_positions = ["ST", "GK", "CB", "LW", "CM", "ST", "GK", "CB", "RW", "CDM", "LB"],
        pace       = [90, 40, 50, 88, 65, 85, 38, 52, 86, 60, 78],
        shooting   = [88, 15, 25, 70, 60, 82, 12, 22, 68, 55, 30],
        passing    = [70, 55, 60, 72, 80, 65, 50, 58, 70, 78, 65],
        dribbling  = [80, 30, 45, 85, 70, 75, 28, 42, 82, 65, 60],
        defending  = [30, 45, 85, 35, 65, 28, 42, 88, 32, 72, 80],
        physic     = [75, 70, 80, 65, 72, 72, 68, 82, 62, 70, 74],
        goalkeeping_diving      = [10, 82, 10, 10, 10, 10, 80, 10, 10, 10, 10],
        goalkeeping_handling    = [10, 80, 10, 10, 10, 10, 78, 10, 10, 10, 10],
        goalkeeping_kicking     = [10, 75, 10, 10, 10, 10, 73, 10, 10, 10, 10],
        goalkeeping_positioning = [10, 82, 10, 10, 10, 10, 80, 10, 10, 10, 10],
        goalkeeping_reflexes    = [10, 84, 10, 10, 10, 10, 82, 10, 10, 10, 10],
        goalkeeping_speed       = [10, 50, 10, 10, 10, 10, 48, 10, 10, 10, 10]
    )
end

@testset "Fifa.jl" begin

    @testset "adjust_rating" begin
        p_exact    = Player("Test", 80.0, "ST", "ST")
        p_same_cat = Player("Test", 80.0, "ST", "CF")
        p_diff_cat = Player("Test", 80.0, "ST", "GK")
        @test adjust_rating(p_exact)    == 80.0
        @test adjust_rating(p_same_cat) == 80.0 * 0.9
        @test adjust_rating(p_diff_cat) == 80.0 * 0.6
    end

    @testset "calcul_team_score" begin
        players = [Player("A", 80.0, "ST", "ST"), Player("B", 80.0, "GK", "GK")]
        t = Team("T", players)
        @test calcul_team_score(t) == 80.0
    end

    @testset "position_fit_score" begin
        df = make_test_df()
        gk_row = df[2, :]
        st_row = df[1, :]
        @test position_fit_score(gk_row, "GK") > position_fit_score(gk_row, "ST")
        @test position_fit_score(st_row, "ST") > position_fit_score(st_row, "GK")
        @test 0.0 <= position_fit_score(gk_row, "GK") <= 1.0
        @test 0.0 <= position_fit_score(st_row, "ST") <= 1.0
    end

    @testset "find_similar_players" begin
        df = make_test_df()
        result = find_similar_players("Striker A", df, 3)
        @test nrow(result) == 3
        @test !("Striker A" in result.short_name)
        # Striker F is the most similar to Striker A (same archetype, close stats)
        result1 = find_similar_players("Striker A", df, 1)
        @test result1.short_name[1] == "Striker F"
    end

    @testset "cluster_players" begin
        df = make_test_df()
        labels, archetype_names = cluster_players(df, 3)
        @test length(labels) == nrow(df)
        @test length(archetype_names) == 3
        @test all(1 .<= labels .<= 3)
    end

    @testset "player_archetype" begin
        df = make_test_df()
        labels, archetype_names = cluster_players(df, 3)
        arch = player_archetype("Striker A", df, labels, archetype_names)
        @test arch in archetype_names
        @test player_archetype("nonexistent", df, labels, archetype_names) == "Unknown"
    end

    @testset "optimal_squad" begin
        df = make_test_df()
        pool = df.short_name
        form = Formation(433, ["LB", "LCB", "RCB", "RB", "CDM", "LCM", "RCM", "LW", "RW", "ST"])
        team = optimal_squad(pool, form, df)
        @test length(team.player) == 11
        @test all(p.name in pool for p in team.player)
        names = [p.name for p in team.player]
        @test length(unique(names)) == 11
    end

end
