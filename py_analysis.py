# %%

df.head(5)

# %%
# # if there's no locationlatitude and longitude, fill it with NaN
df['LocationLatitude'] = df['LocationLatitude'].fillna(0)
df['LocationLongitude'] = df['LocationLongitude'].fillna(0)

# combine incident from date with incident from time to get the date and time
df['DateTime'] = df['IncidentFromDate'] + ' ' + df['IncidentFromTime']


# move incident fromdate to the datetime value 
df['IncidentFromDate'] = df['DateTime']
df.drop(['IncidentFromTime'], axis=1, inplace=True)
df.drop(['DateTime'], axis=1, inplace=True)

# %%
df.head(5)

# %%
#convert incidentfromdate to datetime

df['IncidentFromDate'] = pd.to_datetime(df['IncidentFromDate'])

#replace Offense Description value 1 with no offense description

df['Offense Description'] = df['Offense Description'].replace(1, 'no offense description')




#using plotly, plot the bar graph of the number of crimes per year, and count 

fig = px.histogram(df, x=df['IncidentFromDate'].dt.year, text_auto=True, color_discrete_sequence=['#1f77b4'])

fig.update_layout(bargap=0.2 )

fig.write_image('CrimePerYear.png')

# %%
# filter by crime type received from 'Offense Description

df['Offense Description'] = df['Offense Description'].str.lower()

# change nan with no offense description
df.loc[df['Offense Description'].isna(), 'Offense Description'] = 'no offense description'

# replace specials with - 
df['Offense Description'] = df['Offense Description'].str.replace('�', '-')


Crime_Type_List = sorted(list(set(df['Offense Description'].values.tolist())))

print(Crime_Type_List)

# %%
# map year 2021 based on crimetype

# for this data to be valuable, get rid of the crimetype 'non-crime', no offense description 


df1 = df[df['Offense Description'] != 'non-crime (not reported to state)']
df1= df1[df1['Offense Description'] != 'no offense description']
df1= df1[df1['Offense Description'] != 'non-crime']
df1= df1[df1['Offense Description'] != 'all other offenses']
df1 = df1[df1['Offense Description'] != 'miscellaneous offenses']

fig2 = px.histogram(df1, x=df1['Offense Description'], color_discrete_sequence=['#000000'], width = 800, height=800)

fig2.update_layout(
    margin=dict(l=20, r=20, t=20, b=20),
    paper_bgcolor="LightSteelBlue",
)

fig2.write_image('OffenseType.png')

# %% [markdown]
# ![](./OffenseType.png)
# 
# ![](CrimePerYear.png)


