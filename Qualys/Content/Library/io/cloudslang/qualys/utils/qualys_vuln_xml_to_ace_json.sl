namespace: io.cloudslang.qualys.utils
operation:
  name: qualys_vuln_xml_to_ace_json
  inputs:
    - xml_input
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(xml_input):\n    import xml.etree.ElementTree as ET\n    import re\n    \n    # Parse the XML content\n    \n    path_pattern = r'^(/[^/ ]*)+/?$|^([a-zA-Z]:\\\\[^\\\\/:*?\"<>|\\r\\n]+\\\\?)*$'\n    is_path = re.match(path_pattern, xml_input) is not None\n    \n    if is_path:\n        tree = ET.parse(xml_input)\n        root = tree.getroot()\n    else:\n        root = ET.fromstring(xml_input)\n    \n    vulnerabilities = root.findall('.//VULN')\n\n    # List to store extracted data\n    extracted_data = []\n\n    # Extracting required details for each vulnerability\n    for vuln in vulnerabilities:\n        source_id = vuln.find('QID').text if vuln.find('QID') is not None else None\n        title = vuln.find('TITLE').text if vuln.find('TITLE') is not None else None\n\n        # Extracting CVE IDs from CVE_LIST\n        cve_list_element = vuln.find('CVE_LIST')\n        cve_ids = []\n        if cve_list_element is not None:\n            for cve in cve_list_element.findall('.//CVE/ID'):\n                cve_ids.append(cve.text.strip())\n        cve_list = \",\".join(cve_ids)\n\n        solution = vuln.find('SOLUTION').text if vuln.find('SOLUTION') is not None else None\n        impact = vuln.find('CONSEQUENCE').text if vuln.find('CONSEQUENCE') is not None else None\n\n        # Constructing the JSON object\n        vuln_data = {\n            \"sourceId\": source_id,\n            \"title\": title,\n            \"cveList\": cve_list,\n            \"solution\": solution,\n            \"impact\": impact\n        }\n        extracted_data.append(vuln_data)\n    \n    # Creating the final object\n    return {\"vulnerabilities\": extracted_data}\n\n# you can add additional helper methods below."
  outputs:
    - vulnerabilities
  results:
    - SUCCESS
