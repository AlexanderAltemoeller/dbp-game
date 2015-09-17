class FacilityInstance < ActiveRecord::Base
  belongs_to :facility
  belongs_to :ship

  def check_conditions
    return ship.user.check_condition(self.facility.condition) && ship.check_condition(self.facility.condition)
  end

  def get_duration()
    return self.facility.duration / (1 + 0.1 * ShipsStation.find_by(:ship_id => ship_id, :station_id => 2006).level)
  end

  def is_hidden
    if self.facility.facility_condition_id == 21
      return !self.check_conditions
    end
    return false
  end

  def get_max_buy_amount()
    s = self.ship
    f = self.facility
    amounts = []

    if(f.get_metal_cost!=0)
      amounts << s.metal/f.get_metal_cost
    end
    if(f.get_crystal_cost!=0)
      amounts << s.cristal/f.get_crystal_cost
    end
    if(f.get_fuel_cost!=0)
      amounts << s.fuel/f.get_fuel_cost
    end
    
    return amounts.min.to_i
  end

  def get_ratio
    if self.start_time == nil
      return 1.0
    else
      duration = self.get_duration().to_f
      past = Time.now - self.start_time
      ratio = 1.0 - (past / duration)
      if(ratio >= 0.1)
        return ratio
      else
        return 0.0
      end
    end
  end

  def get_refund
    facility = self.facility
    amount = self.create_amount

    ratio = self.get_ratio
    reMetal = facility.get_metal_cost_ratio(ratio + amount - 1)
    reCrystal = facility.get_crystal_cost_ratio(ratio + amount - 1)
    reFuel = facility.get_fuel_cost_ratio(ratio + amount - 1)

    back = ""
    back = back + "Rückzahlung beim Abbruch [" + self.ship.name + "]: <br>"
    back = back + "- Metall: "+reMetal.to_i.to_s + "<br>"
    back = back + "- Kristalle: "+reCrystal.to_i.to_s + "<br>"
    back = back + "- Treibstoff: "+reFuel.to_i.to_s + "<br>"

    return back.html_safe
  end

  def get_conditions()
  	info = self.facility.condition
  	conds = info.split(",")

    back = ""

  	if(ship.capped_facilities)
      back = back + "Aktuell werden schon zu viele Anlagentypen gebaut...<br>"
  	end;
  	if (conds.length==0)
  	  return back.html_safe;
  	end
    user = self.ship.user_ship.user;
  	back = back + "Voraussetzung: <br>"
  	conds.each do |cond|
  		c_info = cond.split(":")
  		typ = c_info[0]
  		id_geb = c_info[1].to_i
  		lvl = c_info[2]
      case typ
      when 'f'
  		  science = Science.find_by(:science_condition_id => id_geb)
        if not(user.has_min_science_level(science, lvl))
          back = back+"- Forschung: "+science.name+" "+lvl.to_s+"<br>"
        end
      when 'g'
        station = Station.find_by(:station_condition_id => id_geb)
        if not(self.ship.has_min_station_level(station, lvl))
          back = back+"- Gebäude: "+station.name+" "+lvl.to_s+"<br>"
        end
      else
      end
  	end

  	return back.html_safe
  end

  def reset_build
    update = true
    if self.start_time == nil
      update = false
    end
    self.start_time = nil
    self.create_count = nil
    self.save
    b = BuildList.find_by(typeSign: 'f', instance_id: self.id)
    if b != nil
      b.destroy
    end
    if update
      ship.update_builds('f')
    end
  end




end
