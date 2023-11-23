namespace: io.cloudslang.qualys.utils
operation:
  name: qualys_vuln_status_xml_to_ace_json
  inputs:
    - xml_input
    - unique_qids:
        required: false
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(xml_input, unique_qids):\n    import xml.etree.ElementTree as ET\n    import re\n    \n    # Parse the XML content\n    \n    path_pattern = r'^(/[^/ ]*)+/?$|^([a-zA-Z]:\\\\[^\\\\/:*?\"<>|\\r\\n]+\\\\?)*$'\n    is_path = re.match(path_pattern, xml_input) is not None\n    \n    if is_path:\n        tree = ET.parse(xml_input)\n        root = tree.getroot()\n    else:\n        root = ET.fromstring(xml_input)\n    \n    output = {\"devices\": []}\n    unique_qids = set(unique_qids.split(','))\n\n    # Iterate over each device or asset in the XML\n    for device in root.findall('.//HOST'):  # Adjust the path as per the actual XML structure\n        device_data = {\n            \"sourceId\": device.find('ID').text,  # Adjust these as per actual XML tags\n            \"endpointId\": device.find('IP').text,\n            \"vulnerabilities\": []\n        }\n\n        # Iterate over each vulnerability in the device\n        for vuln in device.findall('.//DETECTION'):  # Adjust the path as per the actual XML structure\n            vuln_data = {\n                \"sourceId\": vuln.find('QID').text,  # Adjust these as per actual XML tags\n                \"type\": vuln.find('TYPE').text,\n                \"status\": vuln.find('STATUS').text,\n                \"firstDetected\": vuln.find('FIRST_FOUND_DATETIME').text,\n                \"lastDetected\": vuln.find('LAST_FOUND_DATETIME').text\n            }\n\n            # Extracting the CVSS score from QDS_FACTORS\n            cvss = vuln.find(\".//QDS_FACTOR[@name='CVSS']\")\n            if cvss is not None:\n                vuln_data['CVSS'] = cvss.text\n            else:\n                vuln_data['CVSS'] = ''\n\n            # Adding QID to the unique set\n            qid = vuln.find('QID').text  # Adjust this as per actual XML tags\n            unique_qids.add(qid)\n\n            device_data[\"vulnerabilities\"].append(vuln_data)\n\n        output[\"devices\"].append(device_data)\n\n    # Convert unique QIDs to a string\n    qids_string = ','.join(unique_qids)\n    \n    #fixing a issue with the qid list starting with , because we want to consider initial lists for external iterators\n    if qids_string.startswith(','):\n        qids_string = qids_string[1:]\n    \n    # Extract warnings\n    warning_code = ''\n    warning_text= ''\n    warning_url = ''\n    id_min = ''\n    for warning in root.findall('.//WARNING'):\n        warning_code = int(warning.find('CODE').text) if warning.find('CODE') is not None else None\n        warning_text = warning.find('TEXT').text if warning.find('TEXT') is not None else None\n        warning_url = warning.find('URL').text if warning.find('URL') is not None else None\n        \n    if (warning_url is not ''):\n        match = re.search(r'id_min=(\\d+)', warning_url)\n         # Extract and return the value if found\n        if match:\n            id_min = match.group(1)\n    \n    # Creating the final object\n    return {\"hosts\": output, \"unique_qid_list\":qids_string, \"warning_code\":warning_code, \"warning_text\":warning_text, \"warning_url\":warning_url, \"id_min\":id_min }\n\n# you can add additional helper methods below."
  outputs:
    - hosts
    - unique_qid_list
    - warning_code
    - warning_text
    - warning_url
    - id_min
  results:
    - HAS_MORE: '${warning_code == "1980"}'
    - SUCCESS
