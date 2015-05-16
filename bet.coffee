fs = require 'fs'
Helpers = require './helpers'
Bitcore = require 'bitcore'

class Bet
  @fromObject: (obj) ->
    bet = new Bet(obj.at, false)
    bet.id = obj.id
    bet.address = obj.address
    bet.keyFilename = obj.keyFilename
    bet

  constructor: (@at, createAddress = true) ->
    @id = Helpers.randomString(5)

    @address = @keyFilename = null
    if createAddress
      privateKey = new Bitcore.PrivateKey()
      @address = privateKey.toAddress().toString()
      @keyFilename = "./private/#{@id}.key"
      fs.writeFileSync @keyFilename, privateKey.toWIF()

module.exports = Bet
