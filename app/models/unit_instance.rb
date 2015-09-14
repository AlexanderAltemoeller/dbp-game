require 'TimeFormatter'

class UnitInstance < ActiveRecord::Base
  belongs_to :unit
  belongs_to :ship

  def get_time_since_build
    return (Time.now - self.updated_at).to_i
  end

 def get_duration()
  	return unit.get_duration(amount, ship)
  end


 def get_duration()
 	station_2006 = Station.find_by(code: 2006)
  	return (self.unit.duration * amount) / (1 + 0.1 * ship.ships_stations.find_by(station: station_2006).level)
  	return (self.unit.duration * amount) / (1 + 0.1 * ShipsStation.find_by(:ship_id => ship.id, :station_id => 2006).level)
  end

   def get_unit_ratio
    duration = self.unit.get_duration(self.build_amount, self.ship).to_f
    past = self.get_time_since_build.to_f
    return 1.0 - (past / duration).to_f
  end

  def get_refund
    unit = self.unit
    amount = self.build_amount

    ratio = self.get_unit_ratio
    reMetal = unit.get_metal_cost_ratio(ratio) * amount
    reCrystal = unit.get_crystal_cost_ratio(ratio) * amount
    reFuel = unit.get_fuel_cost_ratio(ratio) * amount

    back = ""
    if not(self.ship.nil?)
      back = back + "Rückzahlung beim Abbruch [" + self.ship.name + "]: <br>"
    end
    back = back + "- Metall: "+reMetal.to_i.to_s + "<br>"
    back = back + "- Kristalle: "+reCrystal.to_i.to_s + "<br>"
    back = back + "- Treibstoff: "+reFuel.to_i.to_s + "<br>"

    return back.html_safe
  end

  def get_conditions
  	info = self.unit.conditions
  	conds = info.split(",")
  	user = self.ship.user_ship.user;
    back = ""

  	conds.each do |cond|
      c_info = cond.split(":")
      typ = c_info[0]
      id_geb = c_info[1].to_i
      lvl = c_info[2]

      case typ
      when "f"
        science = Science.find_by(:science_condition_id => id_geb)

        if not(user.has_min_science_level(science, lvl))
          back = back+"- Forschung: "+science.name+" "+lvl.to_s+"<br>"
        end
      when "g"
        station = Station.find_by(:station_condition_id => id_geb)

        if not(user.has_min_station_level(station, lvl))
          back = back+"- Gebäude: "+station.name+" "+lvl.to_s+"<br>"
        end
      end
  	end

    leftMetal = unit.get_metal_cost - user.get_metal
    leftCrystal = unit.get_crystal_cost - user.get_crystal
    leftFuel = unit.get_fuel_cost - user.get_fuel

    if(leftMetal > 0)
      back = back + "- Fehlendes Metall: " + leftMetal.to_s + "<br>"
    end

    if(leftCrystal > 0)
      back = back + "- Fehlende Kristalle: " + leftCrystal.to_s + "<br>"
    end

    if(leftFuel > 0)
      back = back + "- Fehlender Treibstoff: " + leftFuel.to_s + "<br>"
    end

    if(back.length != 0)
      back = "Voraussetzung: <br>"+back
    end

  	return back.html_safe
  end

  def update_time(format)
    unit = Unit.find_by(id: self.unit_id)
    ship = self.ship
    durationInSeconds = unit.get_duration(1, ship)

    if(self.start_time)
      build_amount =  self.build_amount
      timeSinceBuild = self.get_time_since_build
      restTime = durationInSeconds - timeSinceBuild
      delta = 1;

      if(restTime + durationInSeconds < 0)
        delta = -1 * (restTime / durationInSeconds);

        if(build_amount < delta)
          delta = build_amount
        end
      end
      delta = delta.to_i

      if(restTime <= 0)
        self.amount = self.amount + delta;
        self.build_amount = build_amount - delta
        self.start_time = Time.now;
        self.save

        if(build_amount - delta <= 0)
          self.start_time = nil
          self.build_amount = nil
          self.save
        end

        if not(format)
          return durationInSeconds;
        else
          return format_count_time(durationInSeconds)
        end
      else
        if not(format)
          return restTime;
        else
          return format_count_time(restTime)
        end
      end
    else
      if not(format)
        return durationInSeconds;
      else
        return format_count_time(durationInSeconds)
      end
    end
  end
end