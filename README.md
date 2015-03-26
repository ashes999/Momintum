# Momintum: Mass Collaboration for the Ummah

Momintum accelerates your social entrepreneurship into action. It loves visionaries, ideas, and the people in the trenches who actually do the work.

You may wish to look at:
- [Our Blog](http://momintum.com)
- [The Current Momintum](http://worx.momintum.com)

# Setup Notes

This only works in Cloud9. We depend on certain envrionment variables that they set up, in order to function.

Please make sure you do the following:

- Define the environment variable `ENV['admin_email']` for the admin dashboard
- Define `ENV['C9_HOSTNAME']` for test automation and other stuff
- Install the required `apt-get` packages for `capybara-webkit`. See [this blog post](http://rubyandrails.herokuapp.com/2015/capybara-and-capybara-webkit-in-cloud9/).

# Main Reasons to Switch to Rails

- Trade for a high-velocity dev stack (+ dynamic languages in general)
- More mature web decelopment framework and ecosystem
- More scalable hosting (Heroku)
