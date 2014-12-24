# Description:
#   Post standup log to Yammer
#
# Configuration:
#   HUBOT_STANDUP_YAMMER_TOKEN
#
# Commands:
#   hubot post <group> standup logs to <group id>
#   hubot forget me on yammer
#   hubot i am <username> on yammer
#
# Author:
#   @miyagawa

module.exports = (robot) ->
  robot.brain.on 'standupLog', (group, room, response, logs) ->
    postYammer robot, group, room, response, logs

  robot.respond /post (.*) standup logs? to (\d*) *$/i, (msg) ->
    group = msg.match[1]
    group_id = msg.match[2]
    robot.brain.data.yammerGroups or= {}
    robot.brain.data.yammerGroups[group] = group_id
    if buff = robot.brain.data.tempYammerBuffer?[group]
      postYammer(robot, group, msg.message.user.room, msg, buff)
      delete robot.brain.data.tempYammerBuffer[group]

  robot.respond /i am \@?([a-z0-9-]+) on yammer/i, (msg) ->
    yammerName = msg.match[1]
    msg.message.user.yammerName = yammerName
    msg.send "Ok, you are " + yammerName + " on Yammer"

  robot.respond /forget me on yammer/i, (msg) ->
    user = msg.message.user
    user.yammerName = null
    msg.reply("Ok, I have no idea who you are anymore.")

querystring = require 'querystring'

postYammer = (robot, group, room, response, logs) ->
  group_id = getYammerGroup robot, group
  if group_id is undefined
    response.send "Tell me which Yammer group to post archives. Say 'hubot post #{group} standup logs to <GROUP_ID>'. Use Group ID 0 if you don't need archives."
    robot.brain.data.tempYammerBuffer or= {}
    robot.brain.data.tempYammerBuffer[group] = logs
  else if group_id is 0
    # do nothing
  else
    body = makeBody robot, group, logs
    response.http('https://www.yammer.com/api/v1/messages.json')
      .header('Authorization', "Bearer #{process.env.HUBOT_STANDUP_YAMMER_TOKEN}")
      .post(querystring.stringify { 'group_id': group_id, 'body': body, 'topic0': 'standup' }) (err, res, body) ->
        console.log body
        if err
          response.send "Posting to the group #{group_id} FAILED: #{err}"
        else
          data = JSON.parse body
          if data['messages']
            response.send "Posted to Yammer: #{data['messages'][0]['web_url']}"
          else
            response.send "Posting to the group #{group_id} FAILED: #{body}"

getYammerGroup = (robot, group) ->
  robot.brain.data.yammerGroups or= {}
  robot.brain.data.yammerGroups[group]

makeBody = (robot, group, logs) ->
  # TODO templatize?
  date = new Date(logs[0].time)
  body = "Standup log for #{group}: #{date.toLocaleDateString()}\n==================================\n"

  prev = undefined
  for log in logs
    if log.message.user.name isnt prev
      name = log.message.user.name
      if log.message.user.yammerName
        name = '@' + log.message.user.yammerName
      body += "\n#{name}:\n"
    body += "#{log.message.text} (#{new Date(log.time).toLocaleTimeString()})\n"
    prev = log.message.user.name

  body
