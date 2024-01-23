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
          - SUCCESS: qualys_hosts_xml_to_ace_json
          - FAILURE: on_failure
    - qualys_hosts_xml_to_ace_json:
        do:
          io.cloudslang.qualys.utils.qualys_hosts_xml_to_ace_json:
            - xml_input: '${return_result}'
            - base_url: "${get_sp('io.cloudslang.qualys.base_url')}"
        publish:
          - acx_json_chunks
        navigate:
          - HAS_MORE: dummy_call_to_ace_1
          - SUCCESS: get_post_body
    - get_post_body:
        loop:
          for: json_file in acx_json_chunks
          do:
            read_json_file:
              - json_file
          publish:
            - body: file_content
          navigate:
            - SUCCESS: post_acx_call
            - FAILURE: on_failure
    - post_acx_call:
        do:
          io.cloudslang.qualys.utils.post_acx_api:
            - url: http://16.166.49.126:8000/api/2.0/ACX/asset/host
            - body: '${body}'
        publish:
          Response: response_code
        navigate:
          - SUCCESS: '${Response == "200"}'
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
      qualys_hosts_xml_to_ace_json:
        x: 480
        'y': 280
      get_post_body:
        x: 680
        'y': 400
        navigate:
          830ecaa1-0c2a-c843-e437-35777251cb42:
            targetId: c0d334bf-247a-2a4e-2a36-7a3b8903b49f
            port: SUCCESS
      post_acx_call:
        x: 240
        'y': 400
    results:
      SUCCESS:
        c0d334bf-247a-2a4e-2a36-7a3b8903b49f:
          x: 920
          'y': 400
