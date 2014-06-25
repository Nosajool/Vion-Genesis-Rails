module ChampionsHelper
	def non_roster_hash(champs)
		champs_hash = Hash.new
		champs.each do |champ|
			champs_hash["#{champ.table_champion.name} Level: #{champ.level} ID: #{champ.id} Position: #{champ.position}"] = champ.id
		end
		champs_hash
	end

	def champ_list_hash
		champs_hash = Hash.new
		TableChampion.all.each do |champ|
			champs_hash["##{champ.id} #{champ.name}"] = champ.id
		end
		champs_hash
	end

	# Images
	def champ_img_square(champion)
		key = champion.table_champion.key
		image_tag("champions/#{key}/#{key}_Square_0.png", alt: "Champion Face", class: "champion_face")		
	end

	def champ_img_square_table(table_champion)
		key = table_champion.key
		image_tag("champions/#{key}/#{key}_Square_0.png", alt: "Champion Face", class: "champion_face")	
	end

	def champ_img_battle(champion)
		key = champion.table_champion.key
		image_tag("champions/#{key}/#{key}_#{champion.active_skin}.jpg")
	end

	def champ_img_splash(champion)
		key = champion.table_champion.key
		image_tag("champions/#{key}/#{key}_Splash_#{champion.active_skin}.jpg")
	end


	# Champion Statistics. Will calculate all stat boost (pros, buffs, roles) using the following methods

	def champ_hp(champion)
		base = champion.table_champion.hp
		f_base = f_role(champion).hp_base
		s_base = s_role(champion).hp_base
		level = champion.level * champion.table_champion.hp_per_level
		per = 1
		f_per = f_role(champion).hp_per
		s_per = s_role(champion).hp_per
		health = base + f_base + s_base + level
		health = health * (per + f_per + s_per)
	end

	def champ_ad(champion)
		base = champion.table_champion.attack_damage
		f_base = f_role(champion).ad_base
		s_base = s_role(champion).ad_base
		level = champion.level * champion.table_champion.attack_damage_per_level
		per = 1
		f_per = f_role(champion).ad_per
		s_per = s_role(champion).ad_per
		health = base + f_base + s_base + level
		health = health * (per + f_per + s_per)
	end

	def champ_ap(champion)
		# Ability power uses the same base attack damage
		base = champion.table_champion.attack_damage
		f_base = f_role(champion).ap_base
		s_base = s_role(champion).ap_base
		level = champion.level * champion.table_champion.attack_damage_per_level
		per = 1
		f_per = f_role(champion).ap_per
		s_per = s_role(champion).ap_per
		health = base + f_base + s_base + level
		health = health * (per + f_per + s_per)		
	end



	def champ_armor(champion)
		base = champion.table_champion.armor
		f_base = f_role(champion).ar_base
		s_base = s_role(champion).ar_base
		level = champion.level * champion.table_champion.armor_per_level
		per = 1
		f_per = f_role(champion).ar_per
		s_per = s_role(champion).ar_per
		health = base + f_base + s_base + level
		health = health * (per + f_per + s_per)
	end

	def champ_mr(champion)
		base = champion.table_champion.magic_resist
		f_base = f_role(champion).mr_base
		s_base = s_role(champion).mr_base
		level = champion.level * champion.table_champion.magic_resist_per_level
		per = 1
		f_per = f_role(champion).mr_per
		s_per = s_role(champion).mr_per
		health = base + f_base + s_base + level
		health = health * (per + f_per + s_per)	
	end

	def champ_ms(champion)
		base = champion.table_champion.movespeed
		f_base = f_role(champion).ms_base
		s_base = s_role(champion).ms_base
		per = 1
		f_per = f_role(champion).ms_per
		s_per = s_role(champion).ms_per
		health = base + f_base + s_base
		health = health * (per + f_per + s_per)
	end

	private
		def f_role(champion)
			Role.where(name: champion.table_champion.f_role).first
		end

		def s_role(champion)
			Role.where(name: champion.table_champion.s_role).first
		end
end
