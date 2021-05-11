command run: 
ruby http_client.rb http://127.0.1.1 get 'q=none' [NUMBER_OF_THREADS] 1 response-codes-aggregation

# case 1
Number of threads: 5000

output: 
200: 3114

# case 2
Number of threads: 3000

output: 
200: 3000

# case 3
Number of threads: 3500

output: 
200: 3500

# case 4
Number of threads: 4000

output: 
200: 4000

# case 5
Number of threads: 4500

output: 
200: 4500

# case 6
Number of threads: 4800

output: 
200: 1824

# case 7
Number of threads: 4650

output: 
200: 4650

# case 8
Number of threads: 4750

output: 
200: 2659

# case 8
Number of threads: 4700

output: 
200: 3004

正常にレスポンスを受け取ることができる並行処理数の限界値は4650です。
