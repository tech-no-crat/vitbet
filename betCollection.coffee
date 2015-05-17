fs = require 'fs' 
Bet = require './bet'
Helpers = require './helpers'
_ = require 'underscore'

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
    count = Object.keys(@bets).length
    console.log "Updating balances for #{count} bets"

    self = this
    updateStats = _.after count, -> self.updateStats()

    for id, bet of @bets
      getCallback = (id) ->
        return (err, balance) ->
          console.log "Balance of #{id} is #{balance}"
          self.bets[id].balance = balance unless isNaN(balance)
          updateStats()
          
      Helpers.getBitcoinAddressBalance bet.address, getCallback(id)

  updateStats: () ->
    @activeBets = 0
    @totalBalance = 0
    sum = 0
    weightedSum = 0
    for id, bet of @bets
      if bet.balance > 0
        @activeBets += 1
        @totalBalance += Number(bet.balance)
        sum += Number(bet.at)
        weightedSum += Number(bet.at) * Number(bet.balance)

    @average = sum/@activeBets
    @weightedAverage = weightedSum/@totalBalance
    console.log "Currently #{@activeBets} bets active with at total balance of #{Math.floor(@totalBalance / 100000)} mBTC, average bet is at #{Math.floor(@average)}, weighted average #{Math.floor(@weightedAverage)}"

  getAverage: () -> @average
  getWeightedAverage: () -> @weightedAverage
  getTotalBalance: () -> @totalBalance
  getActiveBetsCount: () -> @activeBets
  getActiveBets: () -> _.filter @bets, (x) ->
    x.balance > 0

    
module.exports = BetCollection
