namespace: io.cloudslang.qualys.utils
operation:
  name: qualys_xml_to_ace_json
  inputs:
    - xml_input
    - base_url
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(xml_input, base_url):\n    import xml.etree.ElementTree as ET\n    # Parse the XML data\n    root = ET.fromstring(xml_input)\n\n    # Extract hosts\n    hosts = []\n    for host in root.findall('.//HOST'):\n        host_data = {\n            'id': int(host.find('ID').text) if host.find('ID') is not None else None,\n            'ip': host.find('IP').text if host.find('IP') is not None else None,\n            'fqdn': host.find('FQDN').text if host.find('FQDN') is not None else None,\n            'scanner': base_url\n        }\n        hosts.append(host_data)\n\n    # Extract warnings\n    warning_code = None\n    warning_text= None\n    warning_url = None\n    for warning in root.findall('.//WARNING'):\n        warning_code = int(warning.find('CODE').text) if warning.find('CODE') is not None else None\n        warning_text = warning.find('TEXT').text if warning.find('TEXT') is not None else None\n        warning_url = warning.find('URL').text if warning.find('URL') is not None else None\n        \n\n    return {\"ace_json\": hosts, \"warning_code\": warning_code, \"warning_text\":warning_text, \"warning_url\":warning_url}"
  outputs:
    - ace_json
    - warning_code
    - warning_text
    - warning_url
  results:
    - SUCCESS
