class Personne
  attr_accessor :nom, :points_de_vie, :en_vie

  def initialize(nom)
    @nom = nom
    @points_de_vie = 100
    @en_vie = true
  end

  def info
    # - Renvoie le nom et les points de vie si la personne est en vie
    if @en_vie
      puts "     #{@nom} : #{@points_de_vie} points de vie"
    # - Renvoie le nom et "vaincu" si la personne a été vaincue
    else
      puts "     #{@nom} est vaincu .."
    end
  end

  def attaque(personne)

    # - Fait subir des dégats à la personne passée en paramètre 
    puts "\n     #{@nom} ==[ATTAQUE]==> #{personne.nom}"
       degats_recus = degats
       personne.points_de_vie -= degats_recus
       # - Affiche ce qu'il s'est passé"
    puts "     #{personne.nom} à subit #{degats_recus} degats"
    puts "     #{personne.points_de_vie} points de vie restants"                          
    
  end

  def subit_attaque(degats_recus)
 
    # - Réduit les points de vie en fonction des dégats reçus
    # - Affiche ce qu'il s'est passé
    # - Détermine si la personne est toujours en_vie ou non
      @points_de_vie -= degats_recus
         puts "     #{@nom} a perdu #{degats_recus} points de vie"
    if @points_de_vie > 0
      @en_vie = true
    else
      @en_vie = false
    end
  end
end

class Joueur < Personne
  attr_accessor :degats_bonus

  def initialize(nom)
    # Par défaut le joueur n'a pas de dégats bonus
    @degats_bonus = 0
    # Appelle le "initialize" de la classe mère (Personne)
    super(nom)
  end

  def degats
  	
    # - Calculer les dégats
    # - Affiche ce qu'il s'est passé
    degat = rand(15..45)
    degat += @degats_bonus # On rajoute les dégats bonus aux dégats de base
    puts "     #{@nom} inflige #{degat} points de dégats"
    return degat
  end

  def soin

    # - Gagner de la vie
    # - Affiche ce qu'il s'est passé
    @points_de_vie = 100
    puts "     #{@nom} s'est soigné et à récupéré ses 100 points de vie"
  end

  def ameliorer_degats

    # - Augmenter les dégats bonus
    # - Affiche ce qu'il s'est passé
    @degats_bonus += 20
    puts "     #{@nom} a maintenant #{@degats_bonus} points supplémentaires de dégats"
  end
end

class Ennemi < Personne
  def degats
    # - Calculer les dégats
    degat = rand(5..25)
  end
end

class Jeu
  def self.actions_possibles(monde)
    puts "     ACTIONS POSSIBLES :"
    sleep(0.25)
    puts "\n   0 - Se soigner"
    sleep(0.25)
    puts "\n   1 - Améliorer son attaque"
    sleep(0.25)
    puts " "

    # On commence à 2 car 0 et 1 sont réservés pour les actions
    # de soin et d'amélioration d'attaque
    i = 2
    monde.ennemis.each do |ennemi|
      puts "   #{i} - ATTAQUER \n"
      puts "   #{ennemi.info} "
      
      i = i + 1
      sleep(0.25)
    end
    puts "                                            99 - Quitter"
  end

  def self.est_fini(joueur, monde)

    # - Déterminer la condition de fin du jeu
    if monde.ennemis.size == 0 || joueur.points_de_vie <= 0
      puts "Partie terminée"
      return true
    end
  end
end

class Monde
  attr_accessor :ennemis

  def ennemis_en_vie

    # - Ne retourner que les ennemis en vie
    ennemis.each do |ennemi|
      if ennemi.points_de_vie <= 0
        puts "     \n #{ennemi.nom} :ÉLIMINÉ "
        ennemis.delete(ennemi)
      end
    end
  end
end

##############

# Initialisation du monde
monde = Monde.new

# Ajout des ennemis
monde.ennemis = [
  Ennemi.new("  Balrog"),
  Ennemi.new("  Goblin"),
  Ennemi.new("  Squelette"),
  Ennemi.new("  Zombie"),
  Ennemi.new(" Sorcière")
]

# Initialisation du joueur
joueur = Joueur.new("Jean-Michel Paladin")

# Message d'introduction. \n signifie "retour à la ligne"
puts "\n\nAinsi débutent les aventures de #{joueur.nom}\n\n"

# Boucle de jeu principale
100.times do |tour|

 #ajout d'un délai afin de laiser le temps à l'utilisateur de lire.
  sleep(2)

  puts "\n------------------ Tour numéro #{tour} ------------------"

  # Affiche les différentes actions possibles
  Jeu.actions_possibles(monde)

  puts "\n        QUELLE ACTION FAIRE ?"
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
    # Amélioration de l'attaque du joueur
    ennemi_a_attaquer = monde.ennemis[choix - 2]
    joueur.attaque(ennemi_a_attaquer)
  end

  sleep(2)


  puts "\nLES ENNEMIS RIPOSTENT !"
  # Pour tous les ennemis en vie ...
  monde.ennemis_en_vie.each do |ennemi|
    # ... le héro subit une attaque.
    sleep(1)
    ennemi.attaque(joueur)
  end

    sleep(1)

  puts "\nEtat du héro: #{joueur.nom} : #{joueur.points_de_vie} \n"
  # Si le jeu est fini, on interompt la boucle
  break if Jeu.est_fini(joueur, monde)
end

puts " "

# - Afficher le résultat de la partie
if joueur.points_de_vie >= 0
  puts "Vous avez gagné !"
else
  puts "Vous avez perdu !"
end

sleep(10)