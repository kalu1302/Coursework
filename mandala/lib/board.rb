class Board
  attr_accessor :cups
  attr_reader :player1, :player2

  def initialize(name1, name2)
    @cups = Array.new(14) { Array.new }
    place_stones
    @player1 = name1
    @player2 = name2
  end

  def place_stones
    @cups.each_with_index do |_, index|
      next if index == 6 || index == 13
      4.times { cups[index] << :stone }
    end
  end

  def valid_move?(start_pos)
    if start_pos.between?(1, 14)
      raise 'Empty cup!' if @cups[start_pos].empty?
      return false
    else
      raise 'Invalid starting cup'
      return false
    end
    true
  end

  PLAY_CUPS = {
    "player1" => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    "player2" => [7, 8, 9, 10, 11, 12, 13, 1, 2, 3, 4, 5]
  }

  def make_move(start_pos, current_player_name)
    player = current_player_name == player1 ? "player1" : "player2"
    moveset = PLAY_CUPS[player]
    turns = cups[start_pos].length
    moveset_ind_start = moveset.index(start_pos)
    last_ind = nil
    
    turns.times do |turn|
      cups_pos = (moveset_ind_start + turn) % moveset.length
      curr_cup = cups[cups_pos]
      
      if turn == 0
        curr_cup.pop until curr_cup.length == 0
        next
      end
      
      curr_cup << :stone
      last_ind = cups_pos
    end
    render
    
    return :prompt if player == next_turn(last_ind)
    return :switch if @cups[last_ind].empty?
    last_ind + 1
  end

  def next_turn(ending_cup_idx)
    # helper method to determine what #make_move returns
    return "player1" if ending_cup_idx == 6
    return "player2" if ending_cup_idx == 13
    ""
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    @cups[7..12].all? {|cup| cup.empty?} || @cups[0..6].all? {|cup| cup.empty?}
  end

  def winner
    if one_side_empty?
      return @player1 if @cups[0..6].all? {|cup| cup.empty?}
      @player2
    else
      :draw
    end
  end
  
end
