# R Microservice

This microservice is part of the microservice pipline in [inseri](https://github.com/nie-ine/inseri). The service provides the possibility to use/create R code, use it to transform a response received by an API call into the needed data structure and pass the result to another inseri app.

## Run and Develop Locally

### Dependencies
- Python 3
- R

### Install and Run
1. Create a virtual environment
1. Activate your created virtual environment
1. ``pip3 install -r requirements.txt``
1. Run with ``python3 r-task.py``
1. Go to http://localhost:50002

## Run with Docker

1. Build the image: ``[sudo] docker build -t nieine/microservice-r-task .``
1. Run the container: ``[sudo] docker run -p 50002:50002 nieine/microservice-r-task``
1. Go to http://localhost:50002

## Call the Service in a RESTful Way

If the service is running, you can POST a body with JSON data from any application. 

Body:
```
{
	"datafile": "[The name of the JSON file]",
	"data": "[The content of the JSON file]",
	"codefile": "[The name of the R file]",
	"code": "[The content of the R file]"
}
```
Response:
```
{
	"output": "...", 
}
```

E.g.: 
```
{
	"datafile":"yourData.json",
	"data":"{\n    \"message\": \"Hello World!\"\n}\n",
	"codefile":"yourCode.R",
	"code":"library(\"rjson\")\n\nreadJson <- function(inputFile) {\n    json <- fromJSON(file = inputFile)\n    dataFrame <- as.data.frame(json)\n    as.character(dataFrame$message)\n}\n\nreadJson(\"yourData.json\")\n"
}

```

```
{
	"output": "Hello World!"
}
```

## Publish on Dockerhub

1. Build the image: ``[sudo] docker build -t nieine/microservice-r-task:YYYY-MM-DD .``
1. Push the image: ``[sudo] docker push nieine/microservice-r-task:YYYY-MM-DD``