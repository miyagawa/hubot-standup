# Post log to Yammer
#
# requires following environment variable
#   HUBOT_STANDUP_YAMMER_TOKEN: OAuth2 access token

module.exports = (robot) ->
  robot.brain.on 'standupLog', (group, room, response, messages) ->
    postYammer robot, group, room, response, messages

  robot.respond /post (.*) standup logs? to (\d*) *$/i, (msg) ->
    group = msg.match[1]
    group_id = msg.match[2]
    robot.brain.data.yammerGroups or= {}
    robot.brain.data.yammerGroups[group] = group_id
    if buff = robot.brain.data.tempYammerBuffer?[group]
      postYammer(robot, group, msg.message.user.room, msg, buff)
      delete robot.brain.data.tempYammerBuffer[group]

querystring = require 'querystring'

postYammer = (robot, group, room, response, messages) ->
  group_id = getYammerGroup robot, group
  if group_id is undefined
    response.send "Tell me which Yammer group to post. Say 'hubot post #{group} standup logs to <GROUP_ID>'"
    robot.brain.data.tempYammerBuffer or= {}
    robot.brain.data.tempYammerBuffer[group] = messages
  else
    body = makeBody robot, group, messages
    console.log body
    response.http('https://www.yammer.com/api/v1/messages.json')
      .header('Authorization', "Bearer #{process.env.HUBOT_STANDUP_YAMMER_TOKEN}")
      .post(querystring.stringify { 'group_id': group_id, 'body': body }) (err, res, body) ->
        console.log body
        if err
          response.send "Posting to the group #{group_id} FAILED: #{body}"
        else
          data = JSON.parse body
          response.send "Posted to Yammer: #{data['messages'][0]['url']}"

getYammerGroup = (robot, group) ->
  robot.brain.data.yammerGroups or= {}
  robot.brain.data.yammerGroups[group]

makeBody = (robot, group, messages) ->
  # TODO templatize?
  console.log messages
  date = new Date(messages[0].time)
  body = "Standup log for #{group}: #{date.toLocaleDateString()}\n"
  prev = undefined
  for m in messages
    if m.message.user.name isnt prev
      body += "\n#{m.message.user.name}:\n"
    body += "#{m.message.text} (#{new Date(m.time).toLocaleTimeString()})\n"
    prev = m.message.user.name
  body
