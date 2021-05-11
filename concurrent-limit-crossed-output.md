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

5000 threads x 10 iterations で 24891 正常 response を受けるので、平均5000スレッドにつき2489正常responseを受ける。
よって、正常にレスポンスを受け取ることができる並行処理数の限界値は2489以下です。
