# hubot-standup

Agile style standup bot for [hubot](https://github.com/github/hubot) ala [tender](https://github.com/markpasc/tender).

## How to use

Create a room (or channel on IRC) for standup (existing one is okay) and invite hubot to the room if necessary.

### Setup

First, you tell hubot who is a member for a particular team for the standup, using the `roles` commands with "(who) is a (team) member".

Let's take "engineering" team for example.

```
miyagawa: hubot miyagawa is an engineering member
hubot: Ok, miyagawa is an engineering member
miyagawa: hubot john is an engineering member
hubot: Ok, john is an engineering member
miyagawa: hubot davidlee is an engineering member
hubot: Ok, davidlee is an engineering member
```
Or if using [hubot-auth](https://www.npmjs.com/package/hubot-auth):

```
miyagawa: hubot miyagawa has engineering role
hubot: OK, miyagawa has the engineering role
```

You can create as many teams as you want.

**Note**: This setup process hopefully won't be necessary in the future, when Hubot properly implements an API to get the list of online users in a room. So that everyone in a standup room == standup participants.

### Start the standup

Hubot won't schedule the standup for you (yet), you have to start it by yourself when it's time.

```
miyagawa: hubot standup for engineering
hubot: Ok, let's start the standup: miyagawa, john, davidlee
hubot: john: your turn
```

Hubot remembers who should participate the standup, and will tell whose turn is the next. Tell what you did yesterday, will do today, anything blocked. and say "next" (or "done" or "that's it") when you're done.

```
john: Done some pretty nice hack yesterday.
john: I will work on another cool stuff today.
john: I'm not blocked
john: hubot next
hubot: davidlee: your turn
```

When the user is offline or away for a second, tell hubot to skip the user.

```
miyagawa: hubot skip davidlee
hubot: Will skip davidlee
hubot: miyagawa: your turn
```

Once the last user is done, hubot will tell you how long the standup was.

```
miyagawa: I'm working on some nice stuff, and will continue doing so today.
miyagawa: hubot next
hubot: All done! Standup was 5 minutes and 24 seconds.
```

## Installation

This hubot script depends on `roles.coffee` script. You're recommended to use `redis-brain.coffee` to persist the team information.

You can use the [hubot-auth](https://www.npmjs.com/package/hubot-auth) module to manage roles as well.

In your project directory, run the following:

```bash
npm install hubot-standup --save
```

Then add `hubot-standup` to `external-scripts.json`, e.g.

```
["hubot-standup"]
```

### Yammer

The bot can also post the standup archive to Yammer. You need to set a valid Yammer OAuth2 token to `HUBOT_STANDUP_YAMMER_TOKEN` environment variable.

Here's how to get a valid Yammer OAuth2 token with the standard OAuth2 authorization flow.

See [Yammer documentation](https://developer.yammer.com/api/oauth2.html) for more details.

* Register a new application on Yammer at `https://www.yammer.com/<DOMAIN>/client_applications/new`. Leave the callback URLs empty
* Take notes of your `consumer_key` and `consumer_secret`
* Make a new bot user on Yammer (optional). This is the user who will post archives as.
* Sign in as the new bot user on Yammer if necessary
* Go to `https://www.yammer.com/dialog/oauth?client_id=<consumer_key>`
* There's an authorization dialog. Authorize the app
* Look at the URL bar and there's a `code=<CODE>` query parameter in there, copy that.
* `curl https://www.yammer.com/oauth2/access_token?code=<CODE>&client_id=<consumer_key>&client_secret=<consumer_secret>`
* you'll get a big JSON that contains `access_token` -> `token`

Now set the token to `HUBOT_STANDUP_YAMMER_TOKEN` and Hubot will ask which group ID the log should be posted to. Use the group ID 0 to turn off the feature for a group.

## Author

[Tatsuhiko Miyagawa](https://github.com/miyagawa)

## License

MIT License
