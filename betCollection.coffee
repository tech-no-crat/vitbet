fs = require 'fs' 
Bet = require './bet'
Helpers = require './helpers'

class BetCollection
  constructor: (@filename, @balanceCheckInterval = 60000) ->
    @bets = {}
    @load()
    self = this
    setInterval ->
      self.updateBalances()
    , @balanceCheckInterval
    @updateBalances()

  load: ->
    try
      @bets = require @filename
    catch err
      console.log "Warning: could not load bets from file #{@filename}"

    for id, obj of @bets
      @bets[id] = Bet.fromObject(obj)

  save: (filename) ->
    fs.writeFileSync @filename, JSON.stringify(@bets)
    console.log "Bets saved successfully to #{@filename}"
    true

  add: (bet) ->
    if @bets[bet.id]
      console.log "Warning: Tried to add bet #{bet.id}, but bet exists already"
      return false

    @bets[bet.id] = bet
    @save()

  get: (id) -> @bets[id]

  updateBalances: () ->
    console.log "Updating balances"
    for id, bet of @bets
      getCallback = (bet, id) ->
        return (err, balance) ->
          console.log "Balance of #{id} is #{balance}"
          bet.balance = balance if balance
      Helpers.getBitcoinAddressBalance bet.address, getCallback(bet, id)

module.exports = BetCollection
