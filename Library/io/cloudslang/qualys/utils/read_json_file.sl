########################################################################################################################
#!!
#! @description: This operation gets a list of QIDs, it makes sure there are only unique values and it splits by "," a x number of elements. This is done to prepare the ids input for the get vulnerabilities API when used in a parallel construct. In order for this to work, you'll need to replace the ";" by comma when using it in the ids input. - this is a limitation on the parallel loop we can use only comma delimiter so we shoud use semm
#!!#
########################################################################################################################
namespace: io.cloudslang.qualys.utils
operation:
  name: read_json_file
  inputs:
    - json_file_name
  python_action:
    use_jython: false
    script: "def execute(json_file_name):\n    # read file content\n    import json\n    with open(json_file_name, 'r') as acx_data:\n        file_content=json.load(acx_data)\n    return {\"file_content\":file_content}"
  outputs:
    - file_content
  results:
    - SUCCESS
