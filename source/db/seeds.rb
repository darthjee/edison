# frozen_string_literal: true

# This file should contain all the record creation
# needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed
# command (or created alongside the database with db:setup).
#

u = User.find_or_initialize_by(
  name: 'User',
  login: 'darthjee',
  email: 'darthjee@srv.com'
)
u.password = 'password'
u.save
