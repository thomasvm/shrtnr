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
    date = new Date @created.getUTCFullYear(), @created.getUTCMonth(), @created.getUTCDate(), 0, 0, 0

    emit @url_id,
      count: 1,
      dates: [
        created: date,
        count: 1
      ]
  
  reduce = (key, values) ->
    result =
      count: 0,
      dates: []

    # has to be inline: is deployed to mongodb
    findDate = (date) ->
      for d in result.dates
        return d if d.created = date
      return null
  
    for v in values
      result.count += v.count

      # Group by date
      for d in v.dates
        match = findDate d.created
        if match
          match.count += d.count
        else
          result.dates.push d
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

