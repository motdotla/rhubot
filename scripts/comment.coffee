# Description:
#   Gives a comment about subject
#
# Commands:
#   hubot comment on <query> - Sends back a string

module.exports = (robot) ->
  robot.respond /comment( on)? (.*)/i , (msg) ->
    topPost msg, (id) ->
      if id
        topComment msg, id, (comment) ->
          msg.send comment
      else
        msg.send 'Please choose something less boring'

#grab a top post on reddit
topPost = (msg, cb) ->
  q = msg.match[2].replace(' ', '%20')
  url = 'http://www.reddit.com/search.json?limit=1&q=' + q
  msg.http(url)
  .get() (err, res, body) ->
    firstPost = JSON.parse(body)
    if firstPost.data.children.length > 0
      if firstPost.data.children[0].data.num_comments is 0
        ##no comments
        id = null
      else
        id = firstPost.data.children[0].data.id
    else
      ##no post
      id = null
    #pass back id of post
    cb(id);

#grab top comment on post
topComment = (msg, id, cb) ->
  id = id
  url = 'http://www.reddit.com/comments/' + id + '.json?limit=1'
  msg.http(url)
  .get() (err, res, body) ->
    firstComment = JSON.parse(body);
   
    #passback first comment
    cb(firstComment[1].data.children[0].data.body); 