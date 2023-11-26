########################################################################################################################
#!!
#! @input truncation_limit: (Optional) Maximum number of host records processed per request.
#!!#
########################################################################################################################
namespace: io.cloudslang.qualys.ace
flow:
  name: get_vulnerabilities
  inputs:
    - elements:
        default: '100'
        required: false
    - truncation_limit:
        default: '40'
        required: false
    - parallel_throttle:
        default: '7'
        required: false
  workflow:
    - get_host_detection_list:
        do:
          io.cloudslang.qualys.vm.get_host_detection_list:
            - id_min: '${id_min}'
            - truncation_limit: '${truncation_limit}'
        publish:
          - return_result
        navigate:
          - FAILURE: on_failure
          - SUCCESS: qualys_vuln_status_xml_to_ace_json
    - qualys_vuln_status_xml_to_ace_json:
        do:
          io.cloudslang.qualys.utils.qualys_vuln_status_xml_to_ace_json:
            - xml_input: '${return_result}'
        publish:
          - vulnerabilities
          - id_min
          - unique_qid_list
        navigate:
          - HAS_MORE: split_qid_list_1
          - SUCCESS: split_qid_list
          - FAILURE: on_failure
    - get_knowledge_base:
        parallel_loop:
          for: qids in formatted_list
          max_throttle: '${parallel_throttle}'
          do:
            io.cloudslang.qualys.vm.get_knowledge_base:
              - ids: '${qids.replace(";",",")}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_knowledge_base_1:
        parallel_loop:
          for: qids in formatted_list
          max_throttle: '${parallel_throttle}'
          do:
            io.cloudslang.qualys.vm.get_knowledge_base:
              - ids: '${qids.replace(";",",")}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_host_detection_list
    - split_qid_list:
        do:
          io.cloudslang.qualys.utils.split_qid_list:
            - qid_list: '${unique_qid_list}'
            - elements: '${elements}'
        publish:
          - formatted_list
        navigate:
          - SUCCESS: get_knowledge_base
    - split_qid_list_1:
        do:
          io.cloudslang.qualys.utils.split_qid_list:
            - qid_list: '${unique_qid_list}'
            - elements: '${elements}'
        publish:
          - formatted_list
        navigate:
          - SUCCESS: get_knowledge_base_1
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_host_detection_list:
        x: 40
        'y': 80
      qualys_vuln_status_xml_to_ace_json:
        x: 240
        'y': 80
      get_knowledge_base_1:
        x: 40
        'y': 320
      get_knowledge_base:
        x: 640
        'y': 80
        navigate:
          6a907616-4ce1-0f1c-c027-8af61938e844:
            targetId: 033890f0-e671-2c61-71b2-fdd806805c97
            port: SUCCESS
      split_qid_list:
        x: 440
        'y': 80
      split_qid_list_1:
        x: 240
        'y': 320
    results:
      SUCCESS:
        033890f0-e671-2c61-71b2-fdd806805c97:
          x: 920
          'y': 80
