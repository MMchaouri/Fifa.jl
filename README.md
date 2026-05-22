# Fifa.jl — FIFA 22 Sports Analytics Toolkit

[![Build Status](https://github.com/MMchaouri/Fifa.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/MMchaouri/Fifa.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Julia 1.10](https://img.shields.io/badge/Julia-1.10-blue.svg)](https://julialang.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Fifa.jl** is a Julia sports analytics library for exploring, clustering, and optimizing football squads using the FIFA 22 player dataset. It combines interactive pitch visualization with data-driven player analysis — position fit scoring from attribute profiles, unsupervised player archetype discovery, nearest-neighbour similarity search, and formation-aware squad optimization.

Built in Julia for high-performance data processing on 19,000+ player records.

---

## Features

- **Interactive pitch visualization** — render any formation on an SVG football pitch via [Vizagrams.jl](https://github.com/davibarreira/Vizagrams.jl) and [Pluto.jl](https://plutojl.org) reactive notebooks
- **Position fit scoring** — data-driven suitability model using weighted attribute profiles (pace, shooting, passing, dribbling, defending, physic, goalkeeping) for all 24 positions
- **Player archetype clustering** — unsupervised k-means clustering over the 6 core FIFA attributes to identify latent player archetypes (Pacey Attacker, Clinical Finisher, Defensive Rock, etc.)
- **Similarity search** — find the *n* most similar players to any player in the dataset using Euclidean distance in normalized attribute space
- **Optimal squad builder** — greedy assignment algorithm that selects the best 11 players from a pool for a given formation, maximising position-fit-weighted overall rating
- **Formation comparison** — visualize and score two custom teams head-to-head on the same pitch

---

## Installation

```julia
using Pkg
Pkg.add(url="https://github.com/MMchaouri/Fifa.jl")
```

---

## Quick Start

```julia
using Fifa

# Load the FIFA 22 dataset
df = load_data("data/players_22.csv")

# Discover player archetypes via unsupervised clustering
labels, archetypes = cluster_players(df, 6)

# Find players most similar to a target
find_similar_players("L. Messi", df, 5)

# Check a player's fit score at a given position
gk_row = df[findfirst(==("Alisson"), df.short_name), :]
position_fit_score(gk_row, "GK")   # => ~0.82
position_fit_score(gk_row, "ST")   # => ~0.12

# Build the optimal squad from a player pool
pool = df.short_name[1:50]
best = optimal_squad(pool, dict_formations[433], df)
```

---

## How It Works

### Position Fit Scoring

Each of the 24 positions maps to a weighted attribute profile over pace, shooting, passing, dribbling, defending, and physic (plus dedicated goalkeeping attributes for GK). A player's fit score at any position is the weighted dot product of their normalized attributes against that profile — replacing arbitrary heuristic penalties with an interpretable, data-grounded measure.

### Player Archetype Discovery

K-means clustering over the 6 normalized core attributes groups the 19,000+ player dataset into *k* archetypes. Each cluster is labelled by its dominant attribute (highest centroid component), producing named archetypes like "Clinical Finisher" or "Defensive Rock". This enables squad-level analysis: are you fielding a balanced team or over-indexed on one archetype?

### Squad Optimization

Given a formation and a player pool, the greedy assignment algorithm iterates over positions (GK first, then outfield) and assigns the highest-scoring available player to each slot, where score = `position_fit_score × overall_rating`. O(n·p) complexity, fully explainable, no external solver required.

---

## Interactive Demo

Run the Pluto notebook for the full interactive experience:

```julia
using Pluto
Pluto.run(notebook="examples/examples.jl")
```

Select players from dropdowns, choose formations, and instantly see:
- Both squads visualized on a pitch
- Per-player archetype labels
- Team scores based on position fit
- The algorithmically optimal 4-3-3 from the top 200 players

<!-- Add screenshots here after running the notebook -->

---

## Contributors

Originally co-developed with **Okado Kento** ([@japstok](https://github.com/japstok)) as a Master's university project. Extended, restructured, and published by **M. Mchaouri** — adding the analytics layer (position fit scoring, clustering, similarity search, squad optimization) and package architecture.

---

## License

MIT — see [LICENSE](LICENSE).
