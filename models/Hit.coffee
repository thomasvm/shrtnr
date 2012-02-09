mongoose = require "mongoose"
helpers  = require "./helpers"
Schema   = mongoose.Schema

Hit = new Schema
  url_id: Schema.ObjectId,
  referer: String,
  created: Date
Hit.pre 'save', helpers.setCreated

# Collecting Hit statistics
Hit.statics.generateHitStats = (id = null) ->
  map = ->
    emit(@url_id, { count: 1 })
  
  reduce = (key, values) ->
    result =
      count: 0,
      dates: []
  
    for v in values
      result.count += v.count
    return result

  query = {}
  if id
    query = { url_id: id }

  @collection.mapReduce(
    map,
    reduce,
    { out: { merge: "hitstats" }, query: query },
    (err, db) ->
      console.log "Index updated"
    )

module.exports = mongoose.model 'Hit', Hit

