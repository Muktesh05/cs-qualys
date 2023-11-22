namespace: io.cloudslang.qualys.vm
flow:
  name: get_host_list
  inputs:
    - flow_input_0
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post: []
        navigate:
          - FAILURE: on_failure
  results:
    - FAILURE
extensions:
  graph:
    steps:
      http_client_post:
        x: 120
        'y': 160
