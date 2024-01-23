########################################################################################################################
#!!
#! @input ids: (Optional) Show only certain host IDs/ranges.
#! @input id_min: (Optional) Show only hosts with a minimum host ID value.
#!!#
########################################################################################################################
namespace: io.cloudslang.qualys.ace
flow:
  name: get_vulnerabilities_details
  inputs:
    - ids:
        default: 256117-374891
        required: false
    - id_min:
        required: false
    - id_max:
        required: false
  workflow:
    - get_knowledge_base:
        do:
          io.cloudslang.qualys.vm.get_knowledge_base:
            - ids: '${ids}'
            - id_min: '${id_min}'
            - details: Basic
            - id_max: '${id_max}'
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
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - vulnerabilities: '${vulnerabilities}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_knowledge_base:
        x: 40
        'y': 80
      qualys_vuln_xml_to_ace_json:
        x: 360
        'y': 80
        navigate:
          c8a9f511-963a-6fe6-87a8-4bc79fa4b485:
            targetId: 91b938f9-6074-0c2e-5498-e06ec49208ec
            port: SUCCESS
    results:
      SUCCESS:
        91b938f9-6074-0c2e-5498-e06ec49208ec:
          x: 680
          'y': 80
