namespace: io.cloudslang.qualys.ace
flow:
  name: get_vulnerabilities
  workflow:
    - get_host_detection_list:
        do:
          io.cloudslang.qualys.vm.get_host_detection_list: []
        publish:
          - return_result
        navigate:
          - FAILURE: on_failure
          - SUCCESS: qualys_vuln_xml_to_ace_json
    - qualys_vuln_xml_to_ace_json:
        do:
          io.cloudslang.qualys.utils.qualys_vuln_xml_to_ace_json:
            - xml_input: '${return_result}'
        publish:
          - vulnerabilities
          - qid_list
        navigate: []
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_host_detection_list:
        x: 120
        'y': 160
      qualys_vuln_xml_to_ace_json:
        x: 360
        'y': 160
    results:
      SUCCESS:
        033890f0-e671-2c61-71b2-fdd806805c97:
          x: 600
          'y': 400
