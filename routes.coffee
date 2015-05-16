# A function that takes an express app object and adds routes to it
module.exports = (app) ->
  app.get '/', (req, res) ->
    res.render 'landing'
