BetCollection= require './betCollection'
Bet = require './bet'
config = require './config'

# A function that takes an express app object and adds routes to it
module.exports = (app) ->
  bets = new BetCollection(config.betsFilename)

  app.get '/', (req, res) ->
    res.render 'landing'

  app.get '/rules', (req, res) ->
    res.render 'rules'

  app.post '/bets', (req, res) ->
    where = req.body.where
    bet = new Bet(where)

    success = bets.add bet
    if success
      res.redirect "/bets/#{bet.id}"
    else
      res.status 500
      res.send "HTTP 500 - Internal server error: could not create bet."

  app.get '/bets/:id', (req, res) ->
    bet = bets.get req.params.id

    if bet
      res.render 'bet', {balance: bet.balance || 0, at: bet.at, address: bet.address}
    else
      res.status 404
      res.send "HTTP 404 - Bet not found"
