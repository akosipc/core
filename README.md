# OpenBudget Core

[![Build Status](https://travis-ci.org/obudget/core.svg?branch=master)](https://travis-ci.org/obudget/core) [![Coverage Status](https://coveralls.io/repos/github/obudget/core/badge.svg?branch=master)](https://coveralls.io/github/obudget/core?branch=master) [![Code Climate](https://codeclimate.com/github/obudget/core/badges/gpa.svg)](https://codeclimate.com/github/obudget/core) [![Inline docs](http://inch-ci.org/github/obudget/core.svg)](http://inch-ci.org/github/obudget/core) [![Gitter chat](https://badges.gitter.im/obudget.png)](https://gitter.im/obudget) [![Patreon donate button](https://img.shields.io/badge/patreon-donate-yellow.svg)](https://patreon.com/terenceponce "Donate to this project using Patreon")

[![Sponsor](https://app.codesponsor.io/embed/FtXSUnEDZhz4wUWaXdYz3wdD/obudget/core.svg)](https://app.codesponsor.io/link/FtXSUnEDZhz4wUWaXdYz3wdD/obudget/core)

## Overview

* [OpenBudget](https://openbudget.xyz) is an open source envelope budgeting platform inspired by popular budgeting apps like [YNAB](https://youneedabudget.com) and [GoodBudget](https://goodbudget.com).
* This is an API backend that powers [OpenBudget UI](https://github.com/obudget/ui), which is also an open source project.
* A public deployment of this code is maintained at [api.openbudget.xyz/api](https://api.openbudget.xyz/api)

## Why Open Source?

* I started this project as a way for me to learn Elixir and ReactJS.
* I've been a fan of envelope budgeting since 2011 and I always found it a challenge to share my passion for budgeting with other people because a lot of the best budgeting apps are locked behind a paywall.
* Being open source ensures that anyone who uses this software will know what's going on under the hood. e.g. Prevent unethical situations or enforcing transparency.
* Another benefit of being open source is that anyone can contribute and improve OpenBudget for everyone.
* This project was inspired by [OpenDota](https://www.opendota.com), which is an open source project for viewing data related to the popular game Dota 2. The reason why it's big and successful is because it's open source. I want to emulate what they did for this project.
* Honestly, this endeavor is too big for 1 person to do. I want to encourage other developers who are better skilled than I am to help out in this project by going all-in on open source.

## Tech Stack

* Language: [Elixir](https://elixir-lang.org/)
* Web Framework: [Phoenix](http://phoenixframework.org/)
* Database: [PostgreSQL](https://www.postgresql.org/)

## How to contribute

* Fork this repository
* Write your awesome feature/fix/refactor
* Create a pull request
* Wait for your PR to be reviewed and merged
* You're now a contributor!

For more information, check out our [guidelines for contributing](CONTRIBUTING.md).

## Quick Start

```
git clone https://github.com/obudget/core.git # or clone your own fork
cd core
mix deps.get
mix ecto.create
mix ecto.migrate
mix phx.server
```

Afterwards, open your favorite REST client and go to [localhost:4000/api](http://localhost:4000/api)
