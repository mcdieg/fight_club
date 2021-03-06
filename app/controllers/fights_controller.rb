class FightsController < ApplicationController
  def index
    @champions = Champion.all.first(2)
    @weapons = Weapon.all
    @shields = Shield.all
    @champion_player = Champion.new
  end

  def initialize_fight
    champion_enemy = Dwarf.new(name: "Yeti", picture: '/images/yeti.png')
    shield_enemy = Shield.find_by(name: 'Bouclier des 1001 Griffes')
    weapon_enemy = Weapon.find_by(name: 'Arc déroutant')
    champion_enemy.shield = shield_enemy
    champion_enemy.weapon = weapon_enemy # here put the randomly initiated instance

    champion_id = fight_params[:id]
    weapon_id = fight_params[:weapon_name]
    shield_id = fight_params[:shield_name]

    champion_type = Champion.find_by(id: champion_id)[:type]

    if champion_type == 'Dwarf'
      champion_player = Dwarf.new
      picture_player = '/images/champion_1.png' 
    else
      champion_player = Witch.new
      picture_player = '/images/champion_2.png' 
    end

    shield_player = Shield.find_by(id: shield_id)
    weapon_player = Weapon.find_by(id: weapon_id)
    name_player = Champion.find_by(id: champion_id).name
    champion_player.picture = picture_player
    champion_player.shield = shield_player
    champion_player.weapon = weapon_player
    champion_player.name = name_player
    champion_player.save

    fight = Fight.create!(champion_1: champion_player, champion_2: champion_enemy)

    @fight = fight
    @result = fight.result
    @sequence = fight.fight_sequence
    @fights = Fight.last(5)
  end

  private

  def fight_params
    params.require(:champion).permit(:id, :weapon_name, :shield_name)
  end
end
