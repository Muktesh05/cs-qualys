########################################################################################################################
#!!
#! @input url: The URL to send the POST request to.
#! @input output_file: Path to the file to save the response.
#! @input verify: Whether to verify the server's TLS certificate or the path to a CA bundle to use.
#! @input cert_path: Path to ssl client cert file (.pem) or ('cert', 'key') pair.
#!!#
########################################################################################################################
namespace: io.cloudslang.qualys.vm
operation:
  name: download_host_detection_stream
  inputs:
    - url
    - query_params:
        required: false
    - headers:
        required: false
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - output_file:
        required: true
    - timeout:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - verify:
        required: false
        default: 'true'
    - cert_path:
        required: false
  python_action:
    use_jython: false
    script: "def execute(url, query_params, headers, username, password, output_file, proxy_host, proxy_port, timeout, verify, cert_path):\n    import requests\n    from requests.auth import HTTPBasicAuth\n    \n    error_message = \"\"\n    \n    key_value_pairs = query_params.split('&')\n    data = {pair.split('=')[0]: pair.split('=')[1] for pair in key_value_pairs if '=' in pair} \n\n    \n    proxy_dict = None\n    if not (proxy_host == '' or proxy_port == ''):\n        proxy_dict = {\n            \"https\": '\"'+ proxy_host + ':' + proxy_port +'\"'\n        }\n    \n    verify_bool = False\n    if (verify.lower() == \"true\"):\n        verify_bool = True  \n    \n    headers_dict = {}\n    # Split the string into lines\n    lines = headers.strip().split('\\n')\n    # Process each line\n    for line in lines:\n        # Split the line into key and value based on the delimiter\n        parts = line.split(':')\n        if len(parts) == 2:\n            key, value = parts\n            # Add the key-value pair to the dictionary\n            headers_dict[key.strip()] = value.strip()\n\n    try:\n        with requests.post(url, data, timeout,  headers=headers_dict, verify=verify_bool, cert=cert_path, auth=HTTPBasicAuth(username, password), \n                           proxies=proxy_dict, stream=True) as response:\n            response.raise_for_status()  # Ensure we notice bad responses\n            with open(output_file, 'wb') as file:\n                for chunk in response.iter_content(chunk_size=8192): \n                    file.write(chunk)\n            return { \"response_code\" : str(response.status_code), \"error_message\":error_message }\n    \n    except requests.exceptions.RequestException as e:\n        error_message = f\"Error: {e}\"\n        return {\"response_code\": \"\", \"error_message\" : error_message}"
  outputs:
    - response_code
    - error_message
  results:
    - SUCCESS: '${error_message == ""}'
    - FAILURE
