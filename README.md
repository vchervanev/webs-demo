_Test project using Ruby, Sinatra, AngularJS and Redis_ 
[![Code Climate](https://codeclimate.com/github/vchervanev/webs-demo/badges/gpa.svg)](https://codeclimate.com/github/vchervanev/webs-demo)

This README describes how to run the project and general details about the solution. 

## Running the application

The simplest way to look at this running is to open http://webs-demo.herokuapp.com/. 
Otherwise additional steps are needed as described below. 

### Prerequisites 
The app requires Ruby 2.3 and a Redis server instance. If you have any problem 
installing it I can create a Docker file to simplify local deployment.

The following environment variables can be set:

- `REDIS_URL` - a connection URL for non-local Redis instance
- `PORT` - a port for a web server

### Getting the app and installing libraries

```
cd destination_folder
git clone git@github.com:vchervanev/webs-demo.git
# or git clone https://github.com/vchervanev/webs-demo.git
cd webs-demo
gem install bundler
bundle install
```

### Data loading
To convert the sample CSV data into database run the loader as follows:

```
cd data
ruby loader.rb
```

### Starting the server
From the project's folder run:

```
foreman start
```

Using `bash` shell on Linux or Mac machines environment variables can be passed inline, e.g.:

```
PORT=3456 foreman start
```

## Solution description

The solution follows the described requirements and based on some assumptions:

- Targeted speakers queue mixed with general queue is not ended when there is no more targeted speakers to mix with.
It means at some point only non-targeted speakers will appear in the output list.
- Input data is not being updated (or is updated rarely) so pre-processing is feasible.
- Input size allows to do in-memory data processing of entire data array at once.

Additional features:

- Data loading is important part of the solution, so the 
[loader](data/loader.rb) is supposed to be run on every data changes and has inline tests for requirement compliance
- the main application page provides responsive design, to test it just shrink the window or 
open its [internet version](http://webs-demo.herokuapp.com/) from mobile device.

