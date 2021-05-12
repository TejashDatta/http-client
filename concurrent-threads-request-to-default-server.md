command run: 
ruby http_client.rb http://127.0.1.1 get 'q=none' [NUMBER_OF_THREADS] 1 response-codes-aggregation

# case 1
Number of threads: 5000

output: 
200: 5000

time taken: 10.5s

# case 2
Number of threads: 50000

output: 
200: 50000

time taken: 3m0.634s

# case 3
Number of threads: 70000

output: 
200: 70000

time taken: 4m39.935s

# case 4
Number of threads: 80000

output: 
200: 80000

time taken: 5m31.906s

# case 5
Number of threads: 90000

output: 
200: 90000

time taken: 6m53.395s

# case 6
Number of threads: 120000

output: 
200: 120000

time taken: 10m29.795s

# case 6
Number of threads: 200000

output: 
200: 200000

time taken: 22m29.218s

