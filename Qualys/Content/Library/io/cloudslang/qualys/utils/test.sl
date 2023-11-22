namespace: io.cloudslang.qualys.utils
flow:
  name: test
  workflow:
    - host_list_inputs_to_json:
        do:
          io.cloudslang.qualys.utils.host_list_inputs_to_json:
            - action: list
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      host_list_inputs_to_json:
        x: 200
        'y': 160
        navigate:
          0a3c84ee-beae-f4dc-2767-bd13250420cb:
            targetId: a121157d-0c11-b33a-6fa7-9cb57d0ef63e
            port: SUCCESS
    results:
      SUCCESS:
        a121157d-0c11-b33a-6fa7-9cb57d0ef63e:
          x: 440
          'y': 160
