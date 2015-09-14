class Expedition < ActiveRecord::Base

   has_one :fighting_fleet
   has_one :expedition_instance, dependent: :destroy
   has_one :user, :through => :expedition_instances

   def explore
      @value = 0
      @fleet_storeroom = 0
      @exp_storeroom = 0
      fighting_fleet.ship_groups.all.each do |g|
        @value += g.unit.total_cost * g.number
        @fleet_storeroom += g.unit.cargo * g.number
        if(g.unit.name == "Expeditionsschiff")
           @exp_storeroom += g.unit.cargo * g.number
        end
      end
      event = rand(100)
      happen = 1.0-(1.0/(1.0 + (explore_time * 0.2)))
      happen = happen * 100
      if(happen>event)
         return occurance
      else
         return nothing
      end
   end

   def self.shipamount(shiptype)
         #Ships.find(user.activeShip).#Befehl um stationierte Schiffe abzufragen
         return amount=1
   end

   def occurance
      occ = rand(100)
      case occ
      when 0..20
         return destruction
      when 20..40
         return fight
      when 40..80
         return ressource
      when 80..100
         return salvage
      end
   end

   def nothing
   	nothing_id = rand(5001..5006)
      self.expedition_instance.user.notifications.create(message: Message.find_by_code(nothing_id))
   end

   def destruction
      fighting_fleet.ship_groups.all.each do |g|
         g.number = 0
      end
      destruction_id = rand(5201..5211)
      self.expedition_instance.user.notifications.create(message: Message.find_by_code(destruction_id))
   end

   def fight
      random = rand(70..130)
      limit = random * @value/100.0
      kreuzer_amount = 0
      jaeger_amount = 0
      fregatte_amount = 0
      schild_amount = 0
      enemy_strength = 0
      until(limit<enemy_strength)
         ship_got = rand(100)
         case ship_got
         when 0..10
            enemy_strength += 100
            kreuzer_amount += 1
         when 10..30
            enemy_strength += 40
            fregatte_amount += 1
         when 30..60
            enemy_strength += 8
            schild_amount += 1
         when 60..100
            enemy_strength += 4
            jaeger_amount += 1
         end
      end

      gegner_flotte = FightingFleet.create(user: User.find_by_username("dummy"))
      gegner_flotte.ship_groups.find_by(:unit_id => 7).number += kreuzer_amount
      gegner_flotte.ship_groups.find_by(:unit_id => 5).number += jaeger_amount
      gegner_flotte.ship_groups.find_by(:unit_id => 6).number += fregatte_amount
      gegner_flotte.ship_groups.find_by(:unit_id => 12).number += schild_amount
      gegner_flotte.save

      fight_id = rand(5101..5106)
      self.expedition_instance.user.notifications.create(message: Message.find_by_code(fight_id))
      #TODO Kampf starten

      gegner_flotte.destroy
   end

   def ressource
      first = rand(100)
      second = rand(100)
      if(first>second)
         crystal = first - second
         metal = second
         fuel = 100 - first
      elsif (second>first)
         crystal = second - first
         metal = first
         fuel = 100 - second
      else
         metal = first
         crystal = 0;
         fuel = 100 - first
      end
      relative_amount = rand(30..200)
      absolute_amount = @exp_storeroom * relative_amount/10000.0
      final_amount = [absolute_amount, @fleet_storeroom].min
      metal_got = final_amount * metal
      crystal_got = final_amount * crystal
      fuel_got = final_amount * fuel
      
      resi_id = rand(5401..5406)
      self.expedition_instance.user.notifications.create(message: Message.find_by_code(resi_id))
      
      ship = Ship.find(self.expedition_instance.user.activeShip)
      ship.metal += metal_got
      ship.cristal += crystal_got
      ship.fuel += fuel_got
      ship.save
      
   end

   def salvage
      threshold = @value/10.0
      gain = 0.0
      kreuzer_amount = 0
      jaeger_amount = 0
      fregatte_amount = 0
      schild_amount = 0
      until(threshold<gain)
         ship_got = rand(100)
         case ship_got
         when 0..10
            gain += 100
            kreuzer_amount += 1
         when 10..30
            gain += 40
            fregatte_amount += 1
         when 30..60
            gain += 8
            schild_amount += 1
         when 60..100
            gain += 4
            jaeger_amount += 1
         end
      end
      
	  salvage_id = rand(5301..5307)
      self.expedition_instance.user.notifications.create(message: Message.find_by_code(salvage_id))

      fighting_fleet.ship_groups.all.each do |g|
         case g.unit.name
         when "Kreuzer"
            g.number += kreuzer_amount
            kreuzer_amount = 0
         when "Fregatte"
            g.number += fregatte_amount
         when "mobiler Schild"
            g.number += schild_amount
         when "Jäger"
            g.number += jaeger_amount
         end
      end


      fighting_fleet = FightingFleet.create(user: User.find_by_username("dummy"))
      fighting_fleet.ship_groups.find_by(:unit_id => 7).number += kreuzer_amount
      fighting_fleet.ship_groups.find_by(:unit_id => 5).number += jaeger_amount
      fighting_fleet.ship_groups.find_by(:unit_id => 6).number += fregatte_amount
      fighting_fleet.ship_groups.find_by(:unit_id => 12).number += schild_amount

      fighting_fleet.save

   end
end
