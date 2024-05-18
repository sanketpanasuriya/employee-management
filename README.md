# Employee Management System

## Overview
The project aims to develop a straightforward Ruby on Rails application designed for employee management. Users will have the capability to perform fundamental CRUD (Create, Read, Update, Delete) operations on employee records. Furthermore, the application will incorporate functionality to seamlessly import employee data from an external API and execute background processing for enhanced efficiency and scalability.

## Key Feature
1. Access a list of all employees.
2. Ability to add a new employee.
3. Modify existing employee information.
4. Remove an employee record.
5. Import employees from an external API source.
 
## Prerequisite
- Ruby - 3.3.1
- Rails - 7.1.3.3
- SQLite
- Redis (Redis 6+)

## Setup
1. Clone the repository
    ```bash
    git clone git@github.com:sanketpanasuriya/employee-management.git
    ```
2. bundle install
3. rails db:create
4. rails db:migrate
5. rails server
6. bundle exec sidekiq (start the sidekiq in new terminal for background jobs)

## Run test cases
- bundle exec rspec 
