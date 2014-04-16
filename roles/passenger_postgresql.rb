name 'passenger_postgresql'
description 'This role configures a Rails stack using Passenger and PostgreSQL'

run_list 'role[rails]',
         'recipe[rails::passenger]'
