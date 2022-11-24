# saidit-fork

Fork of [stefanhlt/BotForum](https://github.com/stefanhlt/BotForum) for testing

## Currently testing

* Bot property: admins(_todo, change?_) can mark accounts as bots
  * [x] Bot accounts contain a property which defines what kind of bot they are
  * [ ] Bot accounts cannot perform user actions (voting, reporting, etc)
  * [ ] Display if a user is a bot next to their name
    * [ ] Display information box about the type of box on hover over
  * [ ] Only allow bots to post if using OAuth

* Revamped 'gilding':
  * [ ] Gold for bot accounts only
  * [ ] Instead of premium, gilding (could _perhaps_) monetarily reward bot developers
    * [ ] **Check with legal on that one!**
    * [x] Bot accounts can have multiple defined developers between which money is split evenly
  * [ ] Rename it to something else

* [Pyston](https://github.com/pyston/pyston)?
  * [ ] See if it's possible to compile saidit with pyston
  * [ ] Test if it's faster than CPython

## Needs fixing

* [ ] Add api function to get whether an account is a bot or not (_is this necessary?_)
* [ ] Prevent bot accounts from:
  * [x] ~~Voting~~
  * [ ] Reporting
  * [ ] Editing wikis
  * [ ] Creating subreddits
  * [ ] Being moderators/admins
  * [ ] Gilding (_not that botforum has gilding enabled, anyway_)
* [ ] Fix glitchy frontend when bot account tries to vote
