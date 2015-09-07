# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Creator for table Stations
Station.create([{ name: 'Scanner Metall', costMineral: 4, costCristal: 1, costFuel: 0, initialLevel: 0,
	description: 'dient zur kontinuierlichen Metallgewinnung',
	condition: , tier: '1', icons: 'Metallscanner.png'},
	{ name: 'Scanner Kristall', costMineral: 2, costCristal: 2, costFuel: 0, initialLevel: 0,
		description: 'dient zur kontinuierlichen Kristallgewinnung',
	condition: , tier: 1, icons: 'Kristallscanner.png'},
	{ name: 'Scanner Treibstoff', costMineral: 2, costCristal: 0, costFuel: 1, initialLevel: 0,
		description: 'dient zur kontinuierlichen Treibstoffgewinnung',
	condition: , tier: 1, icons: 'Treibstoffscanner.png'},
	{ name: 'Energiegenerator', costMineral: 0, costCristal: 1, costFuel: 1, initialLevel: 0,
		description: 'erzeugt Energie',
	condition: , tier: 1, icons: 'Energiegenerator.png'},
	{ name: 'Verbrennungsgenerator', costMineral: 4, costCristal: 0, costFuel: 1, initialLevel: 0,
		description: 'verbraucht Treibstoff zur Energiegewinnung',
	condition: 99, tier: 2, icons: 'Verbrennungsgenerator.png'},
	{ name: 'Baugebäude', costMineral: 2, costCristal: 1, costFuel: 0, initialLevel: 0,
		description: 'baut Gebäude',
	condition: , tier: 1, icons: 'Baugebaeude.png'},
	{ name: 'Werf', costMineral: 4, costCristal: 0, costFuel: 1, initialLevel: 0,
		description: 'baut defensive und offensive Einheiten',
	condition: 99, tier: 2, icons: 'Werft.png'},
	{ name: 'Forschungsstation', costMineral: 0, costCristal: 2, costFuel: 1, initialLevel: 0,
		description: 'dient zur Erforschung neuer Technologien',
	condition: 99, tier: 2, icons: 'Forschungsstation.png'},
	{ name: 'Erweiterungsplattform', costMineral: 8, costCristal: 0, costFuel: 2, initialLevel: 0,
		description: 'erweitert die Grundfläche des Mutterschiffes',
	condition: 99, tier: 3, icons: 'Erweiterungsplattform.png'},
	{ name: 'Reparaturgebäude', costMineral: 8, costCristal: 4, costFuel: 0, initialLevel: 0,
		description: 'repariert defensive Einheiten',
	condition: 99, tier: 3, icons: 'Reparaturgebaeude.png'},
	{ name: 'Ressourcenlager Metall', costMineral: 3, costCristal: 1, costFuel: 0, initialLevel: 0,
		description: 'lagert Metall',
	condition: , tier: 1, icons: 'Metalllager.png'},
	{ name: 'Ressourcenlager Kristall', costMineral: 1, costCristal: 2, costFuel: 0, initialLevel: 0,
		description: 'lagert Kristall',
	condition: , tier: 1, icons: 'Kristalllager.png'},
	{ name: 'Ressourcenlager Treibstoff', costMineral: 1, costCristal: 0, costFuel: 1, initialLevel: 0,
		description: 'lagert Treibstoff',
	condition: , tier: 1, icons: 'Treibstofflager.png'},
	{ name: 'Ressourcentresor Metall', costMineral: 6, costCristal: 2, costFuel: 0, initialLevel: 0,
		description: 'sicheres Metalllager',
	condition: 99, tier: 2, icons: 'Metalltresor.png'},
	{ name: 'Ressourcentresor Kristall', costMineral: 2, costCristal: 4, costFuel: 0, initialLevel: 0,
		description: 'sicheres Kristalllager',
	condition: 99, tier: 2, icons: 'Kristalltresor.png'},
	{ name: 'Ressourcentresor Treibstoff', costMineral: 2, costCristal: 0, costFuel: 2, initialLevel: 0,
		description: 'sicheres Treibstofflager',
	condition: 99, tier: 2, icons: 'Treibstofftresor.png'}])
