class Personne
  attr_accessor :nom, :points_de_vie, :en_vie

  def initialize(nom)
    @nom = nom
    @points_de_vie = 100
    @en_vie = true
  end

  def info
    # FAIT :
    # - Renvoie le nom et les points de vie si la personne est en vie
    if en_vie
      return "#{nom} (#{points_de_vie}/100pv)"
    # - Renvoie le nom et "vaincu" si la personne a été vaincue
      else
        return "(vaincu)"
    end

  end

  def attaque(personne)
    # FAIT :
    # - Fait subir des dégats à la personne passée en paramètre
    personne.subit_attaque(degats)
    # - Affiche ce qu'il s'est passé
    puts "#{nom} a attaqué #{personne.nom}  !\n"
  end

  def subit_attaque(degats_recus)
    # FAIT :
    # - Réduit les points de vie en fonction des dégats reçus
    @points_de_vie = points_de_vie - degats_recus
    # - Affiche ce qu'il s'est passé
    puts "\n-#{degats_recus}pv pour : #{nom}"
    # - Détermine si la personne est toujours en_vie ou non
    if points_de_vie <= 0
      @en_vie = false
    end
  end
end

class Joueur < Personne
  attr_accessor :degats_bonus

  def initialize(nom)
    # Par défaut le joueur n'a pas de dégats bonus
    @degats_bonus = 10

    # Appelle le "initialize" de la classe mère (Personne)
    super(nom)
  end

  def degats
    # FAIT :
    # - Calculer les dégats
    degats = @degats_bonus + 10
    # - Affiche ce qu'il s'est passé
    puts "#{nom} bénéficie de #{degats_bonus} pts de dégats bonus"
    return degats
  end

  def soin
    # FAIT :
    # - Gagner de la vie
    @points_de_vie += 10
    # - Affiche ce qu'il s'est passé
    puts "Les Points de vie de #{nom} augmente !"
  end

  def ameliorer_degats
    # FAIT :
    # - Augmenter les dégats bonus
    @degats_bonus += 10
    # - Affiche ce qu'il s'est passé
    puts "La Puissance de #{nom} augmente !"
  end
end

class Ennemi < Personne
  def degats
    # FAIT :
    # - Calculer les dégats
    degats = 10
    return degats
  end
end

class Jeu
  def self.actions_possibles(monde)
    puts "ACTIONS POSSIBLES :"

    puts "0 - Se soigner"
    puts "1 - Améliorer son attaque"

    # On commence à 2 car 0 et 1 sont réservés pour les actions
    # de soin et d'amélioration d'attaque
    i = 2
    monde.ennemis.each do |ennemi|
      puts "#{i} - Attaquer #{ennemi.info}"
      i = i + 1
    end
    puts "99 - Quitter"
  end

  def self.est_fini(joueur, monde)
    # FAIT :
    # - Déterminer la condition de fin du jeu
    if joueur.en_vie == true && monde.ennemis_en_vie.size == 0
      return true
    elsif joueur.en_vie == false
      return true
    end
  end
end

class Monde
  attr_accessor :ennemis

  def ennemis_en_vie
    # FAIT :
    # - Ne retourner que les ennemis en vie
    result = []
    ennemis.each do |ennemis|
      if ennemis.en_vie
        result << ennemis
      end
    end
    return result
  end
end

##############

# Initialisation du monde
monde = Monde.new

# Ajout des ennemis
monde.ennemis = [
  Ennemi.new("Balrog"),
  Ennemi.new("Goblin"),
  Ennemi.new("Squelette")
]

# Initialisation du joueur
joueur = Joueur.new("Jean-Michel Paladin")

# Message d'introduction. \n signifie "retour à la ligne"
puts "\n\nAinsi débutent les aventures de #{joueur.nom}\n\n"

# Boucle de jeu principale
100.times do |tour|
  puts "\n------------------ Tour numéro #{tour} ------------------"

  # Affiche les différentes actions possibles
  Jeu.actions_possibles(monde)

  puts "\nQUELLE ACTION FAIRE ?"
  # On range dans la variable "choix" ce que l'utilisateur renseigne
  choix = gets.chomp.to_i

  # En fonction du choix on appelle différentes méthodes sur le joueur
  if choix == 0
    joueur.soin
  elsif choix == 1
    joueur.ameliorer_degats
  elsif choix == 99
    # On quitte la boucle de jeu si on a choisi
    # 99 qui veut dire "quitter"
    break
  else
    # Choix - 2 car nous avons commencé à compter à partir de 2
    # car les choix 0 et 1 étaient réservés pour le soin et
    # l'amélioration d'attaque
    ennemi_a_attaquer = monde.ennemis[choix - 2]
    joueur.attaque(ennemi_a_attaquer)
  end

  puts "\nLES ENNEMIS RIPOSTENT !"
  # Pour tous les ennemis en vie ...
  monde.ennemis_en_vie.each do |ennemi|
    # ... le héro subit une attaque.
    ennemi.attaque(joueur)
  end

  puts "\nEtat du héro: #{joueur.info}\n"

  # Si le jeu est fini, on interompt la boucle
  break if Jeu.est_fini(joueur, monde)
end

puts "\nGame Over!\n"

# FAIT :
# - Afficher le résultat de la partie

if joueur.en_vie
  puts "Vous avez gagné !"
else
  puts "Vous avez perdu !"
end
