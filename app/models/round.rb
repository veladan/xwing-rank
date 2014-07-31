class Round < ActiveRecord::Base
	belongs_to :tourney
	has_many :matches, :dependent => :destroy
  
  validates :order, presence: true
  validates :order, uniqueness: true
  validate :orderValue
  
  default_scope { order('2 ASC') }
  
  def isFirstRound?
    self.order == 1
  end
  
  def seedRound
    if self.isFirstRound?
      self.seedFirstRound
    else
      self.seedNormalRound
    end
  end


  def seedFirstRound
    # Create pairings using random method
    players = self.tourney.players
    players = players.map.to_a
    
    while players.count > 0
      index = rand(players.count)
      player1 = players.delete_at(index)
      match = Match.new
      match.player1 = player1
      if (players.count == 0)
        match.player2 = nil
      else
        index = rand(players.count)
        player2 = players.delete_at(index)
        match.player2 = player2
      end
      match.round = self
      match.save
    end
  end
  
  def seedNormalRound
  end
  
private
  def orderValue
    if !self.order.nil? and self.order <= 0
      errors.add(:points1, "El orden debe ser un número positivo mayor o igual a 1.")
    end
  end
  
end
