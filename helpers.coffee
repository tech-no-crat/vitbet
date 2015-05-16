request = require 'request'
# Helper methods
module.exports =
  # Generates a string of a specific length from a certain set of characters
  # which defaults to all alphanumeric characters
  # Adapted version of http://stackoverflow.com/questions/1349404
  randomString: (length, chars) ->
    chars = chars || 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    result = ''
    i = length
    while i > 0
      result += chars[Math.round(Math.random() * (chars.length - 1))]
      --i
    result

  getBitcoinAddressBalance: (address, callback) ->
    request "https://blockchain.info/address/#{address}?format=json", (err, resp, body) ->
      if !err and resp.statusCode == 200
        try
          obj = JSON.parse(body) 
          balance = obj.final_balance
        catch e
          callback(e, null) if typeof callback == 'function'
        callback(null, balance) if typeof callback == 'function'
      else
        callback(err, null) if typeof callback == 'function'

