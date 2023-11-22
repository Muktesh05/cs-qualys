namespace: io.cloudslang.qualys.utils
flow:
  name: test
  workflow:
    - host_list_inputs_to_json:
        do:
          io.cloudslang.qualys.utils.host_list_inputs_to_json: []
        navigate:
          - SUCCESS: qualys_host_detection_query_params
    - qualys_host_detection_query_params:
        do:
          io.cloudslang.qualys.utils.qualys_host_detection_query_params:
            - action: list
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      host_list_inputs_to_json:
        x: 40
        'y': 240
      qualys_host_detection_query_params:
        x: 160
        'y': 80
        navigate:
          c3f07393-bbcf-1c75-d001-0ef31ce2dffe:
            targetId: a121157d-0c11-b33a-6fa7-9cb57d0ef63e
            port: SUCCESS
    results:
      SUCCESS:
        a121157d-0c11-b33a-6fa7-9cb57d0ef63e:
          x: 440
          'y': 160
