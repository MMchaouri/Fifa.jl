using Vizagrams, Colors

struct Terrain
    largeur::Int64
    longueur::Int64
    nb_bandes::Int64
end

function creation_terrain(terrain::Terrain)
    global pelouse = nothing
    for i in (0:terrain.nb_bandes-1)
        if isnothing(pelouse)
            global pelouse = S(:fill => :green)*Rectangle(w=terrain.largeur, h=terrain.longueur/terrain.nb_bandes, c=[0,-terrain.longueur/2+terrain.longueur/(2*terrain.nb_bandes)])
        else
            if (i%2==0)
                global pelouse += S(:fill => colorant"green4")*Rectangle(w=terrain.largeur, h=terrain.longueur/terrain.nb_bandes, c=[0,-terrain.longueur/2+terrain.longueur/(2*terrain.nb_bandes)+terrain.longueur*i/terrain.nb_bandes])
            else
                global pelouse += S(:fill => colorant"green3")*Rectangle(w=terrain.largeur, h=terrain.longueur/terrain.nb_bandes, c=[0,-terrain.longueur/2+terrain.longueur/(2*terrain.nb_bandes)+terrain.longueur*i/terrain.nb_bandes])
            end
        end
    end

    central = S(:stroke => :white, :strokeWidth => 2)*Line([[-terrain.largeur/2, 0], [terrain.largeur/2, 0]]) +
              S(:fillOpacity => 0, :stroke => :white, :strokeWidth => 2)*Vizagrams.Circle(r=9.15) +
              S(:fill => :white)*Vizagrams.Circle(r=0.5)

    global surface = nothing
    for i in [-1,1]
        global surface
        surface_reparation = S(:stroke => :white, :strokeWidth => 2)*Line([[-(40.3/2),-(terrain.longueur/2-16.5)*i],[40.3/2,-(terrain.longueur/2-16.5)*i]]) +
                             S(:stroke => :white, :strokeWidth => 2)*Line([[-40.3/2,-terrain.longueur*i/2],[-40.3/2,-(terrain.longueur/2-16.5)*i]]) +
                             S(:stroke => :white, :strokeWidth => 2)*Line([[40.3/2,-terrain.longueur*i/2],[40.3/2,-(terrain.longueur/2-16.5)*i]]) +
                             S(:fillOpacity => 0, :stroke => :white, :strokeWidth => 2)*Vizagrams.Arc(rx=9.15, ry=9.15, c=[0,-(terrain.longueur/2-11)*i],initangle=pi*i/2-0.93,finalangle=pi*i/2+0.93)
        surface_but = S(:stroke => :white, :strokeWidth => 2)*Line([[-9.1,-(terrain.longueur/2-5.5)*i],[9.1,-(terrain.longueur/2-5.5)*i]]) +
                      S(:stroke => :white, :strokeWidth => 2)*Line([[-9.1,-(terrain.longueur/2)*i],[-9.1,-(terrain.longueur/2-5.5)*i]]) +
                      S(:stroke => :white, :strokeWidth => 2)*Line([[9.1,-(terrain.longueur/2)*i],[9.1,-(terrain.longueur/2-5.5)*i]])
        point_penalty = S(:fill => :white)*Vizagrams.Circle(r=0.5, c=[0, -(terrain.longueur/2-11)*i])
        if isnothing(surface)
            surface = surface_reparation + surface_but + point_penalty
        else
            surface += surface_reparation + surface_but + point_penalty
        end
    end

    coin = S(:fillOpacity => 0, :stroke => :white, :strokeWidth =>2)*Vizagrams.Arc(rx=1.5, ry=1.5, c=[-terrain.largeur/2,-terrain.longueur/2], initangle=0, finalangle=pi/2) +
           S(:fillOpacity => 0, :stroke => :white, :strokeWidth =>2)*Vizagrams.Arc(rx=1.5, ry=1.5, c=[terrain.largeur/2,-terrain.longueur/2], initangle=pi/2, finalangle=pi) +
           S(:fillOpacity => 0, :stroke => :white, :strokeWidth =>2)*Vizagrams.Arc(rx=1.5, ry=1.5, c=[-terrain.largeur/2,terrain.longueur/2], initangle=-pi/2, finalangle=2*pi) +
           S(:fillOpacity => 0, :stroke => :white, :strokeWidth =>2)*Vizagrams.Arc(rx=1.5, ry=1.5, c=[terrain.largeur/2,terrain.longueur/2], initangle=pi, finalangle=-pi/2)

    limitation = S(:fillOpacity => 0, :stroke => :white)*Rectangle(w=terrain.largeur, h=terrain.longueur)

    return pelouse + central + surface + coin + limitation
end
