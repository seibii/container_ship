# container_ship
[![Gem Version](https://badge.fury.io/rb/container_ship.svg)](https://badge.fury.io/rb/container_ship)
[![Circle CI](https://circleci.com/gh/seibii/container_ship.svg?style=shield)](https://circleci.com/gh/seibii/container_ship)
[![Code Climate](https://codeclimate.com/github/seibii/container_ship/badges/gpa.svg)](https://codeclimate.com/github/seibii/container_ship)
[![Libraries.io dependency status for GitHub repo](https://img.shields.io/librariesio/github/seibii/container_ship.svg)](https://libraries.io/github/seibii/container_ship)
![](http://ruby-gem-downloads-badge.herokuapp.com/container_ship?type=total)
![GitHub](https://img.shields.io/github/license/seibii/container_ship.svg)

`container_ship` is yet another ECS deployment tool.

## Key features

- Using raw `task_definition.json` file instead of a template file with complex state or variables
- Convention over configuration 

## Installation
```ruby
gem 'container_ship'
```

## Usage
### Prepare Dockerfile
You need to put `Dockerfile` in your app root directory.
And all the services/tasks will use the image built with that.

### Prepare task_definition.json and Dockerfile

```sh
container_ship init YOUR_CLUSTER_NAME
```

will create empty directory for you. And you must put `task_definition.json` file in directories like below. 

``` 
your_app
|-- .container_ship
|    |-- your_cluster_name
|    |    |-- services // ECS services 
|    |    |    |-- your_service_name // like server or api
|    |    |    |    |-- your_envrionment_name // like production or staging
|    |    |    |    |    |-- task_definition.json
|    |    |    |    |
|    |    |    |    +-- your_other_environment_name
|    |    |    |         |-- task_definition.json
|    |    |    |    
|    |    |    +-- your_other_service_name
|    |    |
|    |    |
|    |    +-- tasks // ECS tasks
|    |         |-- your_task_name ( like db-migrate or 
|    |         |    |-- your_envrionment_name // like production or staging
|    |         |    |    |-- task_definition.json
|    |         |    |
|    |         |    +-- your_other_environment_name
|    |         |         |-- task_definition.json   
|    |         +-- your_task_name ( like db-migrate or
|    |
|    +-- your_other_cluster_name
|--...
```

### Prepare ECS resources
You must obey `convention over configuration` concept. So, naming convention is presented below.   

- ECS cluster: `"#{cluster_name}-#{environment}"`
- ECS service: `"#{cluster_name}-#{service_name}-#{environment}"`
- ECS task:    `"#{cluster_name}-#{task_name}-#{environment}"`

And export your ECR repository root uri.

```sh
export ECR_REPOSITORY=xxxxxxxxxxxxx.dkr.ecr.ap-northeast-1.amazonaws.com/
```

### Deploy a service
```sh
container_ship ship CLUSTER_NAME SERVICE_NAME ENVIRONMENT BUILD_NUMBER
```

will deploy a service in `.container_ship/CLUSTER_NAME/services/SERVICE_NAME/ENVIRONMENT/task_definition.json`

### Run a task
```sh
container_ship exec CLUSTER_NAME TASK_NAME ENVIRONMENT BUILD_NUMBER
```
will run a task in `.container_ship/CLUSTER_NAME/tasks/TASK_NAME/ENVIRONMENT/task_definition.json`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/seibii/container_ship. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ContainerShip project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/seibii/container_ship/blob/master/CODE_OF_CONDUCT.md).
