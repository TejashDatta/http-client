ruby http_client.rb http://0.0.0.0:8080 get 'q=none' 4 1000 response-codes-aggregation
ruby http_client.rb http://0.0.0.0:8080 get 'a = abc efg, b= 20,c=3' 1 1 response-codes-aggregation
ruby http_client.rb http://0.0.0.0:8080 post 'q=none' 100 100 response-codes-aggregation
ruby http_client.rb http://127.0.1.1 get 'q=none' 10 10 response-codes-aggregation
