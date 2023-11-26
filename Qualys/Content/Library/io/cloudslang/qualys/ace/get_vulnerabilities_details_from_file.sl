########################################################################################################################
#!!
#! @input ids: (Optional) Show only certain host IDs/ranges.
#! @input output_file: Path to the file to save the response.
#!!#
########################################################################################################################
namespace: io.cloudslang.qualys.ace
flow:
  name: get_vulnerabilities_details_from_file
  inputs:
    - ids:
        default: 11-124535
        required: false
    - output_file: "${'C:\\\\vulnerabilities' + run_id + \"_\" + ids +\".xml\"}"
  workflow:
    - download_vulnerabilities:
        do:
          io.cloudslang.qualys.vm.download_vulnerabilities:
            - ids: '${ids}'
            - details: Basic
            - output_file: '${output_file}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: qualys_vuln_xml_to_ace_json
    - qualys_vuln_xml_to_ace_json:
        do:
          io.cloudslang.qualys.utils.qualys_vuln_xml_to_ace_json:
            - xml_input: '${output_file}'
        publish:
          - vulnerabilities
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - vulnerabilities: '${vulnerabilities}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      download_vulnerabilities:
        x: 40
        'y': 80
      qualys_vuln_xml_to_ace_json:
        x: 280
        'y': 80
        navigate:
          6e3fb4e1-4c1d-2b03-18f1-4e64d5a5208c:
            targetId: 91b938f9-6074-0c2e-5498-e06ec49208ec
            port: SUCCESS
    results:
      SUCCESS:
        91b938f9-6074-0c2e-5498-e06ec49208ec:
          x: 680
          'y': 80
