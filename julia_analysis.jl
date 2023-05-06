# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.14.5
#   kernelspec:
#     display_name: Julia 1.8.5
#     language: julia
#     name: julia-1.8
# ---

# + id="q7Mbcm00lnxO"
using Pkg;
Pkg.add("Plots");Pkg.add("CSV"); Pkg.add("DataFrames"); Pkg.add("Dates"); Pkg.add("StatsBase");Pkg.add("PlotlyJS");
using CSV;
using DataFrames; 
using Dates;
using PlotlyJS;

# + colab={"base_uri": "https://localhost:8080/", "height": 348} id="RMHRbF5J-vmW" outputId="a5816411-8070-4528-e216-97aaca2bdf8d"
df = CSV.read("combined.csv", DataFrame)

first(df, 5)

# + colab={"base_uri": "https://localhost:8080/", "height": 348} id="UW9DNEnLuySw" outputId="94f7e05b-8b05-4f80-887c-866aa72cd2f2"
select!(df, Not([:OffenseCode, :LocationStreetNumber, :LocationDirectional, :CaseStatus, :OCANumber]))


first(df, 5)

# + colab={"base_uri": "https://localhost:8080/", "height": 348} id="uemsADuZvlKe" outputId="fc110838-8aa0-4e6e-e9ef-143180685964"
# converting IncidentFromDate to DateTime
df.IncidentFromDate = string.(df.IncidentFromDate)


for i in 1:length(df.IncidentFromDate)-1
    if length(df.IncidentFromDate[i]) < 7
        delete!(df, i)
    end
    if df.IncidentFromDate[i][2] == '/'
        df.IncidentFromDate[i] = "0"*df.IncidentFromDate[i]
    end
    if df.IncidentFromDate[i][5] == '/'
        df.IncidentFromDate[i] = df.IncidentFromDate[i][1:3]*"0"*df.IncidentFromDate[i][4:end]
    end
end

for i in 1:length(df.IncidentFromDate)-1
    # if the IncidentFromDate contains missing 
    if occursin("missing", df.IncidentFromDate[i])
        delete!(df, i)
    end
end


# convert IncidentFromDate to DateTime
df.IncidentFromDate = DateTime.(df.IncidentFromDate, DateFormat("mm/dd/yyyy"))

first(df, 5)
# -

df1 = filter(row -> !(ismissing(row["Offense Description"]) ||
                      row["Offense Description"] in ["Non-Crime (not reported to state)","no offense description","non-crime","All Other Offenses","Miscellaneous Offenses", "NULL"]), 
             df)
first(df1, 5)


# + colab={"base_uri": "https://localhost:8080/", "height": 123} id="8cp9Maq8vrvT" outputId="1d9976b1-b941-42c3-cd08-c818bef5d729"
plot(PlotlyJS.histogram(df1, x=df1[!,"Offense Description"], 
                           marker_color="#000000", width=800, height=800))
