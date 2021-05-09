Number of server threads: 2

command run: 
ruby http_client.rb http://127.0.1.1 get 'q=none' [NUMBER_OF_THREADS] 10 response-codes-aggregation

# case 1
Number of threads: 2

output: 
200: 20

# case 2
Number of threads: 10

output: 
200: 100

# case 3
Number of threads: 50

output: 
200: 500

# case 4
Number of threads: 100

output: 
200: 1000

# case 5
Number of threads: 500

output: 
200: 5000

# case 6
Number of threads: 1000

output: 
200: 10000

# case 7
Number of threads: 5000

output (error): 
execution expired (Net::OpenTimeout)
