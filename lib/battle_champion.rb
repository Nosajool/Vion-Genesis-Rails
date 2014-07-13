class BattleChampion
	include ChampionsHelper
	include SkinsHelper

	attr_reader :hp
	attr_reader :ad
	attr_reader :ap
	attr_reader :armor
	attr_reader :mr
	attr_reader :ms
	attr_reader :level
	attr_reader :experience
	attr_reader :name
	attr_reader :range
	attr_reader :id

		def initialize(champion,battle_id)
			@hp = champ_hp(champion)
			@ad = champ_ad(champion)
			@ap = champ_ap(champion)
			@armor = champ_armor(champion)
			@mr = champ_mr(champion)
			@ms = champ_ms(champion)
			@level = champion.level
			@id = champion.id
			@dead = false
			@experience = champion.experience
			@name = skin_title(champion)
			@range = champ_range(champion)
			@battle_id = battle_id
		end

		def is_dead
			if @hp <= 0
				@hp = 0
				@dead = true
			end
			@dead
		end

		def exp_reward(event_num)
			reward = ((@hp + @ad + @ap + @armor + @mr) /5).round
			BattleLog.create!({
				battle_id: @battle_id,
				event_num: event_num,
				event: "determine exp",
				champion_id: @id,
				extra: reward
			})
			return reward
		end

		def gain_exp(exp,event_num)
			old_exp = @experience
			@experience += exp
			BattleLog.create!({
				battle_id: @battle_id,
				event_num: event_num,
				event: "exp gain",
				champion_id: @id,
				extra: @experience,
				champ1: old_exp
			})
			event_num += 1
			update_level(event_num)
		end

		def take_physical_damage(opp_ad)
			# Actual Battle
			# multiplier = 100 / (100 + @armor)
			#damage =  (multiplier * opp_ad).ceil
			
			# Simplified Battle
			Rails.logger.debug "opp_ad: #{opp_ad} type: #{opp_ad.class}"
			damage = opp_ad
			Rails.logger.debug "health: #{@hp} type: #{@hp.class}"
			@hp = @hp - damage
			return damage
		end

		def take_magic_damage(opp_ap)
			# Actual Battle
			# multiplier = 100 / (100 + @mr)
			# damage = (multiplier * opp_ap).ceil
			
			# Simplified Battle 
			Rails.logger.debug "opp_ap: #{opp_ap} type: #{opp_ap.class}"
			damage = opp_ap
			Rails.logger.debug "health: #{@hp} type: #{@hp.class}"
			@hp = (@hp - damage).round
			return damage
		end

		def update_champion_stats(event_num)
			update_exp_level(event_num)			
		end

		private
			def update_level(event_num)
				new_level = Math.cbrt(@experience)
				Rails.logger.debug "Name: #{@name} Update Level Check: #{new_level.round} from level #{@level}"
				BattleLog.create!({
					battle_id: @battle_id,
					event_num: event_num,
					event: "level compare",
					champion_id: @id,
					extra: new_level,
					champ1: @level
				})
				event_num += 1
				if(new_level.round != @level)
					Rails.logger.debug "Name: #{@name} grew to #{new_level.round} from level #{@level}"
					BattleLog.create!({
						battle_id: @battle_id,
						event_num: event_num,
						event: "grow level",
						champion_id: @id,
						extra: new_level.round,
						champ1: @level
					})
					@level = new_level.round
				else
					BattleLog.create!({
						battle_id: @battle_id,
						event_num: event_num,
						event: "did not grow level",
						champion_id: @id,
						extra: new_level.round,
						champ1: @level
					})
					Rails.logger.debug "#{@name} did not grow a level"					
				end
			end

			def update_exp_level(event_num)
					@champion = Champion.find(@id)
					BattleLog.create!({
						battle_id: @battle_id,
						event_num: event_num,
						event: "post exp",
						champion_id: @id,
						extra: @experience
					})
					@champion.experience = @experience
					event_num += 1
					BattleLog.create!({
						battle_id: @battle_id,
						event_num: event_num,
						event: "post level",
						champion_id: @id,
						extra: @level
					})
					@champion.level = @level
					@champion.save
			end
end