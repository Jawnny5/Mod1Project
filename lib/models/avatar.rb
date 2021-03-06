class Avatar < ActiveRecord::Base
    has_many :character_stats
    has_many :spells, through: :character_stats
    has_many :weapons, through: :character_stats
    belongs_to :player

    def self.create_new_avatar(player)
        class_result = RestClient.get('https://www.dnd5eapi.co/api/classes')
        race_result = RestClient.get('https://www.dnd5eapi.co/api/races')

        class_data = JSON.parse(class_result)
        race_data = JSON.parse(race_result)
        prompt = TTY::Prompt.new
        race_choices = (race_data["results"].map {|race| race["name"]})
        job_choices = (class_data["results"].map{|job| job["name"]})
        avatar_name = prompt.ask("What is your Avatar's name?".red, default: "Enter a character name")
        avatar_gender = prompt.select("Does your Avatar have a gender?".red, ["Male", "Female", "Nonbinary"], symbols: { marker: "⚔️"})
        avatar_race = prompt.select("What is their race?".red, race_choices, symbols: { marker: "⚔️"})
        avatar_job = prompt.select("What is their job?".red, job_choices, symbols: { marker: "⚔️"})

            Avatar.create(
            name: avatar_name,
            gender: avatar_gender,
            race: avatar_race,
            job: avatar_job,
            player_id: player.id, 
            strength: rand(10..18),
            dexterity: rand(10..18),
            constitution: rand(10..18),
            intelligence: rand(10..18),
            wisdom: rand(10..18),
            charisma: rand(10..18),
            hit_points: rand(8..15),
            level: 1
            )
        system 'clear'
        puts "\n✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩".red.on_black
        puts " "
        puts "  Behold!!! Our newest Champion!".red
        puts " "
        puts "  Name: #{avatar_name}".red
        puts "  Gender: #{avatar_gender}".red
        puts "  Race: #{avatar_race}".red
        puts "  Job: #{avatar_job}".red
        puts "  Player: #{player.username}".red
        puts " "
        puts "✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩".red.on_black
        sleep 4.0

    end

    def change_name
    prompt = TTY::Prompt.new
    system 'clear'
        new_name = prompt.ask("What would you like to change #{self.name}'s name to?".red, default: "enter new name")
        self.update(name: new_name)
        puts "ok, #{self.name} it is!".red
        sleep 1.0
    end

    def new_character_stat (avatar, weapon, spell)
        CharacterStat.create(avatar_id: avatar.id, weapon_id: weapon, spell_id: spell)
    end

    def stats
    prompt = TTY::Prompt.new
    system 'clear'
    puts "✩✩✩✩✩✩✩✩✩✩✩✩✩✩ #{self.name} ✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩".black.on_red
    puts " "
    puts "      Name: #{self.name.red}"
    puts "      Gender: #{self.gender.red}"
    puts "      Race: #{self.race.red}"
    puts "      Job: #{self.job.red}"
    puts "      Level: #{self.level.to_s.red}"
    puts " "
    puts "  ✩✩✩✩✩✩✩✩✩✩✩✩✩ Stats ✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩".black.on_red
    puts " "
    puts "      Strength #{self.strength.to_s.green}"
    puts "      Dexterity #{self.dexterity.to_s.green}"
    puts "      Constitution #{self.constitution.to_s.green}"
    puts "      Intelligence #{self.intelligence.to_s.green}"
    puts "      Wisdom #{self.wisdom.to_s.green}"
    puts "      Charisma #{self.charisma.to_s.green}" 
    puts "      Hit Points #{self.hit_points.to_s.green}"
    puts " "
    puts "  ✩✩✩✩✩✩✩✩✩✩✩✩✩ Gear ✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩".black.on_red
    puts " "
    puts "      Weapons: #{self.weapons.map(&:name).uniq.join(", ")}"
    puts "      Spells: #{self.spells.map(&:name).uniq.join", "}"
    puts " "
    puts "✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩✩".black.on_red
    prompt.keypress("Press any key to continue")
    end

    def give_weapon(avatar_job)
        prompt = TTY::Prompt.new
        job_name = avatar_job
        weapon_list = Weapon.weapons(job_name)
        weapon_choice = prompt.select("Which weapon do you want to equip? 🗡".red, weapon_list, symbols: { marker: "⚔️"})
        new_weapon = Weapon.new_weapon(weapon_choice)
        system 'clear'
        puts "Ok, #{weapon_choice} is added to your inventory".red
        new_character_stat(self, new_weapon.id, new_spell=nil)
        sleep 2.5
    end

    def give_spell(avatar_job)
        prompt = TTY::Prompt.new
        job_name = avatar_job
        spell_list = Spell.spells(job_name)
        spell_choice = prompt.select("Which Spell are you taking?".red, spell_list, symbols: { marker: "⚡️"})
        new_spell = Spell.new_spell(spell_choice)
        system 'clear'
        puts "Ok, #{spell_choice} is added to your spellbook 📖".red
        new_character_stat(self, weapon=nil, new_spell.id)
        sleep 2.5
    end
    
    def level_up(avatar_job)
        str = self.strength
        dex = self.dexterity
        con = self.constitution
        int = self.intelligence
        wis = self.wisdom
        cha = self.charisma
        hp = self.hit_points
        lvl = self.level
        job_name = avatar_job
        case job_name
        when "Barbarian"
        self.update(
            strength: str + 2,
            dexterity: dex + 1,
            constitution: con + 2,
            intelligence: int + 0,
            wisdom: wis + 0,
            charisma: cha + 1,
            hit_points: hp + 7,
            level: lvl + 1
            )
        when "Bard"
        self.update(
                strength: str + 0,
                dexterity: dex + 2,
                constitution: con + 0,
                intelligence: int + 1,
                wisdom: wis + 1,
                charisma: cha + 3,
                hit_points: hp + 5,
                level: lvl + 1
        )
        when "Cleric"
        self.update(
            strength: str + 1,
            dexterity: dex + 0,
            constitution: con + 1,
            intelligence: int + 0,
            wisdom: wis + 2,
            charisma: cha + 1,
            hit_points: hp + 5,
            level: lvl + 1,
            )

        when "Druid"
        self.update(
            strength: str + 1,
            dexterity: dex + 0,
            constitution: con + 1,
            intelligence: int + 0,
            wisdom: wis + 2,
            charisma: cha + 0,
            hit_points: hp + 5,
            level: lvl + 1
            )
        when "Fighter"
        self.update(
            strength: str + 2,
            dexterity: dex + 1,
            constitution: con + 2,
            intelligence: int + 0,
            wisdom: wis + 0,
            charisma: cha + 1,
            hit_points: hp + 6,
            level: lvl + 1
            )
        when "Monk"
        self.update(
            strength: str + 1,
            dexterity: dex + 2,
            constitution: con + 2,
            intelligence: int + 0,
            wisdom: wis + 1,
            charisma: cha + 0,
            hit_points: hp + 6,
            level: lvl + 1
            )
        when "Paladin"
        self.update(
            strength: str + 2,
            dexterity: dex + 0,
            constitution: con + 1,
            intelligence: int + 0,
            wisdom: wis + 2,
            charisma: cha + 1,
            hit_points: hp + 6,
            level: lvl + 1,
            )
        when "Ranger"
            self.update(
                strength: str + 1,
                dexterity: dex + 2,
                constitution: con + 1,
                intelligence: int + 0,
                wisdom: wis + 2,
                charisma: cha + 0,
                hit_points: hp + 6,
                level: lvl + 1,
                )
        when "Rogue"
        self.update(
            strength: str + 0,
            dexterity: dex + 3,
            constitution: con + 0,
            intelligence: int + 1,
            wisdom: wis + 0,
            charisma: cha + 2,
            hit_points: hp + 5,
            level: lvl + 1
            )
        when "Sorcerer"
            self.update(
                strength: str + 0,
                dexterity: dex + 0,
                constitution: con + 1,
                intelligence: int + 2,
                wisdom: wis + 1,
                charisma: cha + 2,
                hit_points: hps + 4,
                level: lvl + 1
                )
        when "Warlock"
        self.update(
            strength: str + 0,
            dexterity: dex + 0,
            constitution: con + 1,
            intelligence: int + 1,
            wisdom: wis + 2,
            charisma: cha + 2,
            hit_points: hp + 5,
            level: lvl + 1
            )
        when "Wizard"
        self.update(
            strength: str + 0,
            dexterity: dex + 0,
            constitution: con + 1,
            intelligence: int + 2,
            wisdom: wis + 2,
            charisma: cha + 0,
            hit_points: hp + 4,
            level: lvl + 1
            )
        end
    system 'clear'
    
    
    puts "Congratulations! You leveled up 💪💪💪!!!".red
    sleep 3.00


    end


    def self.find_avatar_by_name(name)
    @avatar_by_name = all.find_by(name: name)
    end



end
