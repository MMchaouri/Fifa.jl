using CSV, DataFrames

function load_data(path::String)::DataFrame
    return CSV.read(path, DataFrame)
end
