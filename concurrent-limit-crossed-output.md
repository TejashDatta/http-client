# apache server settings 1:

StartServers			 1
MinSpareThreads		 1
MaxSpareThreads		 1
ThreadLimit			 1
ThreadsPerChild		 1
MaxRequestWorkers	  1
MaxConnectionsPerChild   1

## command run:
ruby http_client.rb http://127.0.1.1 post 'q=none' 3 4 response-codes-aggregation

## output:
200: 2
408: 10

# apache server settings 2:

StartServers			 1
MinSpareThreads		 5
MaxSpareThreads		 5
ThreadLimit			 5
ThreadsPerChild		 5
MaxRequestWorkers	  5
MaxConnectionsPerChild   5

## command run:
ruby http_client.rb http://127.0.1.1 get 'q=none' 10 10 response-codes-aggregation

## output:
200: 5
408: 95
