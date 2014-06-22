require 'csv'
require 'json'

puts "Inputting Table Champion Data"
champion_stats_data = 'app/data/champion_stats.json'
file = File.read(champion_stats_data)
champions = JSON.parse(file)["data"]
champions.each do |key,val|
    TableChampion.create!({
        name: val["name"],
        hp: val["stats"]["hp"],
        attack_damage: val["stats"]["attackdamage"],
        armor: val["stats"]["armor"],
        magic_resist: val["stats"]["spellblock"],
        attack_range: val["stats"]["attackrange"],
        riot_id: val["id"],
        key: val["key"],
        title: val["title"],
        f_role: val["tags"][0],
        s_role: val["tags"][1],
        lore: val["lore"],
        hp_per_level: val["stats"]["hpperlevel"],
        attack_damage_per_level: val["stats"]["attackdamageperlevel"],
        armor_per_level: val["stats"]["armorperlevel"],
        magic_resist_per_level: val["stats"]["spellblockperlevel"],
        movespeed: val["stats"]["movespeed"]
        } )
    puts "#{val["name"]} added to the Champion table"
end

# The empty table champion
TableChampion.create!({
    id: 999,
    name: "Empty",
    hp: 0,
    attack_damage: 0,
    armor: 0,
    magic_resist: 0,
    attack_range: 1,
    riot_id: 999,
    key: "Empty",
    title: "the Empty One",
    f_role: "None",
    s_role: "None",
    lore: "The empty champion was born somewhere in Valoran.",
    hp_per_level: 0,
    attack_damage_per_level: 0,
    armor_per_level: 0,
    magic_resist_per_level: 0,
    movespeed: 0
})
puts
puts "placeholder champion added"
puts

puts "Inputting Map Data"
# Map Data
File.open("app/data/maps.txt").each do |line|
    utfGood = line.encode( line.encoding, "binary", :invalid => :replace, :undef => :replace)
    stuff = utfGood.split("\t")
    Map.create!({
        map_name: stuff[0].chomp,
        description: stuff[1].chomp
    })
    puts "#{stuff[0]} added"
end

# Map Champion Data

puts
puts "Inputting Map Champion Data"

map_champion_data = 'app/data/map_champions.csv'
CSV.foreach(map_champion_data) do |row|
    a = Map.find(row[0])
    a.map_champions.create!( {
    champ_id: row[1],
    probability: row[2]
    })
  puts "#{row[1]} added with probability #{row[2]}"
end