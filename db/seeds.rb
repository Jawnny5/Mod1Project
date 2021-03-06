
CharacterStat.destroy_all
Avatar.destroy_all
Player.destroy_all
Weapon.destroy_all
Spell.destroy_all

###Accessing the API and assigning it a variable

class_result = RestClient.get('https://www.dnd5eapi.co/api/classes')
race_result = RestClient.get('https://www.dnd5eapi.co/api/races')
class_data = JSON.parse(class_result)
race_data = JSON.parse(race_result)
#all class names from api class_data["results"].map {|entry| entry["name"]}
#all race names from api race_data["results"].map {|entry| entry["name"]}


jay = Player.create(
    username: "Jay"
)


raes = Avatar.create(
    name: "Raes",
    gender: "M",
    race: "Elf",
    job: "Bard",
    player_id: jay.id
)


bard_spells = Spell.create(
    name: "Dancing Lights"
)

bard_weapons = Weapon.create(
    name: "Dagger"
)

raes = Avatar.create(
    name: "Bo",
    gender: "M",
    race: "Elf",
    job: "Bard",
    player_id: jay.id,
    strength: rand(10..18),
    dexterity: rand(10..18),
    constitution: rand(10..18),
    intelligence: rand(10..18),
    wisdom: rand(10..18),
    charisma: rand(10..18),
    hit_points: 5,
    level: 1
)
new_weapon = Weapon.create(
    name: "axe"
)

CharacterStat.create(
    avatar_id: raes.id,
    weapon_id: bard_weapons.id,
    spell_id: bard_spells.id
)
