namespace: io.cloudslang.qualys.ace
flow:
  name: add_qualys_assets_in_ace
  workflow:
    - get_host_list:
        do:
          io.cloudslang.qualys.vm.get_host_list:
            - truncation_limit: '30'
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
            - base_url: "${get_sp('base_url')}"
        publish:
          - ace_json
          - warning_code
          - warning_url
        navigate:
          - SUCCESS: dummy_call_to_ace
    - dummy_call_to_ace:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: ''
            - text: "${'{ \"assets\":' + ace_json  +  '}'}"
        navigate:
          - SUCCESS: is_warning_1980
    - is_warning_1980:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${warning_code}'
            - second_string: '1980'
        navigate:
          - SUCCESS: http_client_post
          - FAILURE: SUCCESS
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: '${warning_url}'
            - auth_type: Basic
            - username: "${get_sp('username')}"
            - password:
                value: "${get_sp('password')}"
                sensitive: true
            - headers: 'X-Requested-With: ACE'
        publish:
          - return_result
        navigate:
          - SUCCESS: qualys_xml_to_ace_json
          - FAILURE: on_failure
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
        'y': 120
      dummy_call_to_ace:
        x: 640
        'y': 120
      is_warning_1980:
        x: 800
        'y': 240
        navigate:
          08d6a575-b6f0-a633-b6e0-0b11e641df53:
            targetId: c0d334bf-247a-2a4e-2a36-7a3b8903b49f
            port: FAILURE
      http_client_post:
        x: 800
        'y': 480
    results:
      SUCCESS:
        c0d334bf-247a-2a4e-2a36-7a3b8903b49f:
          x: 960
          'y': 120
