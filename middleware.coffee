exports.adderrors = (req, res, next) ->
  res.errors = []
  next()
