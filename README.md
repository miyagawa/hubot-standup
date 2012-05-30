# hubot-standup

Agile style standup bot for [hubot](https://github.com/github/hubot) ala [tender](https://github.com/markpasc/tender).

## Installation

This hubot script depends on `roles.coffee` script. You're recommended to use `redis-brain.coffee` to persist the team information.

In your `package.json`, add the following line to the dependencies:

```
   "hubot-standup": "git://github.com/miyagawa/hubot-standup.git"
```

Then run `npm install` and create a symbolic link from `scripts` directory:

```
ln -s ./node_modules/hubot-standup/src/scripts/hubot-standup.coffee scripts/
```

Add the symlink file to the git repository if necessary (for Heroku deployment).


## How to use

Create a room (or channel on IRC) for standup (existing one is okay) and invite hubot to the room if necessary.

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

You can create as many teams as you want.

Hubot won't schedule the standup for you (yet), you have to start it by yourself when it's time.

```
miyagawa: hubot standup for engineering
hubot: Ok, let's start the standup: miyagawa, john, davidlee
hubot: john: your turn
```

Hubot remembers who should participate the standup, and will tell who's turn is the next. Tell what you did yesterday, will do today, anything blocked. and say "next" (or "done" or "that's it")

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

## Author

[Tatsuhiko Miyagawa](https://github.com/miyagawa)

## License

MIT License



