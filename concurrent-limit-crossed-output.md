command run: 
ruby http_client.rb http://127.0.1.1 get 'q=none' [NUMBER_OF_THREADS] 10 response-codes-aggregation

# case 1
Number of threads: 1000

output: 
200: 10000

# case 2
Number of threads: 5000

output: 
200: 24891

# case 3
Number of threads: 3000

output: 
200: 28594
