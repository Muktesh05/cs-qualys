namespace: io.cloudslang.qualys.utils
operation:
  name: qualys_hosts_xml_to_ace_json
  inputs:
    - xml_input
    - base_url
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(xml_input, base_url):\n    import xml.etree.ElementTree as ET\n    import re\n    \n    # Parse the XML data\n    root = ET.fromstring(xml_input)\n\n    # Extract hosts\n    hosts = []\n    for host in root.findall('.//HOST'):\n        host_data = {\n            'id': int(host.find('ID').text) if host.find('ID') is not None else None,\n            'ip': host.find('IP').text if host.find('IP') is not None else None,\n            'fqdn': host.find('FQDN').text if host.find('FQDN') is not None else None,\n            'scanner': base_url\n        }\n        hosts.append(host_data)\n\n    # Extract warnings\n    warning_code = None\n    warning_text= None\n    warning_url = None\n    id_min = None\n    for warning in root.findall('.//WARNING'):\n        warning_code = int(warning.find('CODE').text) if warning.find('CODE') is not None else None\n        warning_text = warning.find('TEXT').text if warning.find('TEXT') is not None else None\n        warning_url = warning.find('URL').text if warning.find('URL') is not None else None\n    \n    if (warning_url is not None):\n        match = re.search(r'id_min=(\\d+)', warning_url)\n         # Extract and return the value if found\n        if match:\n            id_min = match.group(1)\n    \n    return {\"ace_json\": hosts, \"warning_code\": warning_code, \"warning_text\":warning_text, \"warning_url\":warning_url, \"id_min\":id_min}"
  outputs:
    - ace_json
    - warning_code
    - warning_text
    - warning_url
    - id_min
  results:
    - HAS_MORE: '${warning_code == "1980"}'
    - SUCCESS
