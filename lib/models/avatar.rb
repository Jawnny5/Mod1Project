class Avatar < ActiveRecord::Base
    has_many :character_stats
    has_many :stats, through: :character_stats
    belongs_to :player

    def self.create_new_avatar(player)
        result = RestClient.get('https://www.dnd5eapi.co/api/classes')
        dnd_data = JSON.parse(result)
        prompt = TTY::Prompt.new
        race_choices = (["Elf","Human","Dwarf"])
        job_choices = (dnd_data["results"].map{|job| job["name"]})
        avatar_name = prompt.ask("What is your Avatar's name?", default: ENV["USER"])
        avatar_gender = prompt.ask("Does your Avatar have a gender?", default: ENV["USER"])
        avatar_race = prompt.select("What is their race?", race_choices)
        avatar_job = prompt.select("What is their job?", job_choices)

        new_avatar = Avatar.create(
            name: avatar_name,
            gender: avatar_gender,
            race: avatar_race,
            job: avatar_job,
            player_id: player.id
            )

        puts "great here is your new avatar"
        pp new_avatar
        puts "next we will build their starting equipment!"
        Stat.get_avatar(new_avatar)
    end

    # def stats
    #     avatar_stats = CharacterStat.all.select {|statlist| statlist.stat.}
    #     avatar_stats.map
    # end

    def create_character_stat (stat)
        CharacterStat.create(stat_id: stat, avatar_id: self)
    end

    def self.editor
        puts "stuff to edit"
    end


    def self.find_avatar_by_name(name)
    @avatar_by_name = all.find_by(name: name)
    end



end

