########################################################################################################################
#!!
#! @input truncation_limit: (Optional) Maximum number of host records processed per request.
#!!#
########################################################################################################################
namespace: io.cloudslang.qualys.ace
flow:
  name: get_vulnerabilities_from_files
  inputs:
    - elements:
        default: '500'
        required: false
    - truncation_limit:
        default: '15'
        required: false
    - parallel_throttle:
        default: '7'
        required: false
  workflow:
    - download_host_detection:
        do:
          io.cloudslang.qualys.vm.download_host_detection:
            - truncation_limit: '${truncation_limit}'
            - id_min: '${id_min}'
            - output_file: "${'C:\\host_detection_' + run_id + '.xml'}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: qualys_vuln_status_xml_to_ace_json
    - qualys_vuln_status_xml_to_ace_json:
        do:
          io.cloudslang.qualys.utils.qualys_vuln_status_xml_to_ace_json:
            - xml_input: "${'C:\\host_detection_'+ run_id + '.xml'}"
            - unique_qids: "${get('unique_qid_list', \"\")}"
        publish:
          - hosts
          - id_min
          - unique_qid_list
        navigate:
          - HAS_MORE: split_qid_list_1
          - SUCCESS: split_qid_list
          - FAILURE: on_failure
    - get_vulnerabilities_details_from_file:
        parallel_loop:
          for: qids in formatted_list
          max_throttle: '${parallel_throttle}'
          do:
            io.cloudslang.qualys.ace.get_vulnerabilities_details_from_file:
              - ids: '${qids.replace(";",",")}'
              - output_file: "${'C:\\\\vulnerabilities' + qids[1:6].replace(\",\",\"_\") + '_' + run_id +'.xml'}"
        navigate:
          - SUCCESS: download_host_detection
          - FAILURE: on_failure
    - get_vulnerabilities_details_from_file_1:
        parallel_loop:
          for: qids in formatted_list
          max_throttle: '${parallel_throttle}'
          do:
            io.cloudslang.qualys.ace.get_vulnerabilities_details_from_file:
              - ids: '${qids.replace(";",",")}'
              - output_file: "${'C:\\\\vulnerabilities' + qids[1:6].replace(\",\",\"_\") + '_' + run_id + '.xml'}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - split_qid_list:
        do:
          io.cloudslang.qualys.utils.split_qid_list:
            - qid_list: '${unique_qid_list}'
            - elements: '${elements}'
        publish:
          - formatted_list
        navigate:
          - SUCCESS: get_vulnerabilities_details_from_file_1
    - split_qid_list_1:
        do:
          io.cloudslang.qualys.utils.split_qid_list:
            - qid_list: '${unique_qid_list}'
            - elements: '${elements}'
        publish:
          - formatted_list
        navigate:
          - SUCCESS: get_vulnerabilities_details_from_file
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      download_host_detection:
        x: 40
        'y': 80
      qualys_vuln_status_xml_to_ace_json:
        x: 240
        'y': 80
      get_vulnerabilities_details_from_file:
        x: 40
        'y': 320
      get_vulnerabilities_details_from_file_1:
        x: 680
        'y': 80
        navigate:
          82520e2a-9411-2508-6369-877934d969ed:
            targetId: 033890f0-e671-2c61-71b2-fdd806805c97
            port: SUCCESS
      split_qid_list:
        x: 480
        'y': 80
      split_qid_list_1:
        x: 240
        'y': 320
    results:
      SUCCESS:
        033890f0-e671-2c61-71b2-fdd806805c97:
          x: 920
          'y': 80
