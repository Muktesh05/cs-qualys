########################################################################################################################
#!!
#! @description: This operation gets a list of QIDs, it makes sure there are only unique values and it splits by "," a x number of elements. This is done to prepare the ids input for the get vulnerabilities API when used in a parallel construct. In order for this to work, you'll need to replace the ";" by comma when using it in the ids input. - this is a limitation on the parallel loop we can use only comma delimiter so we shoud use semm
#!!#
########################################################################################################################
namespace: io.cloudslang.qualys.utils
operation:
  name: split_qid_list
  inputs:
    - qid_list
    - elements
  python_action:
    use_jython: false
    script: "def execute(qid_list, elements):\n    # Split the string into elements and remove duplicates by converting to a set\n    int_elements = int(elements)\n    \n    unique_elements = list(set(qid_list.split(',')))\n\n    # Sort the elements to retain some order (optional)\n    unique_elements.sort(key=int)\n\n    # Use list comprehension for efficient processing\n    formatted_elements = [\n        element + (',' if (index + 1) % int_elements == 0 else ';') \n        for index, element in enumerate(unique_elements)\n    ]\n\n    # Create the final string and remove the last separator\n    formatted_string = ''.join(formatted_elements).rstrip(';,')\n    \n    return {\"formatted_list\":formatted_string}"
  outputs:
    - formatted_list
  results:
    - SUCCESS
