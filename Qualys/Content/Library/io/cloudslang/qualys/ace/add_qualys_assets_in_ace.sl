namespace: io.cloudslang.qualys.ace
flow:
  name: add_qualys_assets_in_ace
  workflow:
    - get_host_list:
        do:
          io.cloudslang.qualys.vm.get_host_list:
            - truncation_limit: '10'
            - id_min: '${id_min}'
        publish:
          - return_result
          - status_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: check_status
    - check_status:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '200'
        navigate:
          - SUCCESS: qualys_xml_to_ace_json
          - FAILURE: on_failure
    - qualys_xml_to_ace_json:
        do:
          io.cloudslang.qualys.utils.qualys_xml_to_ace_json:
            - xml_input: '${return_result}'
            - base_url: "${get_sp('io.cloudslang.qualys.base_url')}"
        publish:
          - ace_json
          - warning_code
          - warning_url
          - id_min
        navigate:
          - HAS_MORE: dummy_call_to_ace_1
          - SUCCESS: dummy_call_to_ace
    - dummy_call_to_ace:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: ''
            - text: "${'{ \"assets\":' + ace_json  +  '}'}"
        navigate:
          - SUCCESS: SUCCESS
    - dummy_call_to_ace_1:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: ''
            - text: "${'{ \"assets\":' + ace_json  +  '}'}"
        navigate:
          - SUCCESS: get_host_list
  outputs:
    - warning: '${warning}'
    - warning_code: '${warning_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_host_list:
        x: 80
        'y': 120
      check_status:
        x: 280
        'y': 120
      qualys_xml_to_ace_json:
        x: 480
        'y': 280
      dummy_call_to_ace:
        x: 680
        'y': 400
        navigate:
          830ecaa1-0c2a-c843-e437-35777251cb42:
            targetId: c0d334bf-247a-2a4e-2a36-7a3b8903b49f
            port: SUCCESS
      dummy_call_to_ace_1:
        x: 240
        'y': 400
    results:
      SUCCESS:
        c0d334bf-247a-2a4e-2a36-7a3b8903b49f:
          x: 920
          'y': 400
