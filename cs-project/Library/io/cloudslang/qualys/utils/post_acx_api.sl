########################################################################################################################
#!!
#! @description: This operation gets a list of QIDs, it makes sure there are only unique values and it splits by "," a x number of elements. This is done to prepare the ids input for the get vulnerabilities API when used in a parallel construct. In order for this to work, you'll need to replace the ";" by comma when using it in the ids input. - this is a limitation on the parallel loop we can use only comma delimiter so we shoud use semm
#!!#
########################################################################################################################
namespace: io.cloudslang.qualys.utils
operation:
  name: post_acx_api
  inputs:
    - url
    - body
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(url, body):
        import urllib.request
        from requests.auth import HTTPBasicAuth
        import time
        
        error_message = ""
        max_retries = 20
        wait_time = 10
        
        data = body
        
        proxy_dict = None
        if not (proxy_host == '' or proxy_port == ''):
          proxy_dict = {
          "https": '"'+ proxy_host + ':' + proxy_port +'"'
          }

        verify_bool = False
        if (verify.lower() == "true"):
          verify_bool = True

        headers_dict = {
          'Content-Type': 'application/json'
        }
        for attempt in range(max_retries):
          try:
            with request.Request(url, data, timeout,  headers=headers_dict, method='POST') as response:
              response.raise_for_status()  # Ensure we notice bad responses
            with open(output_file, 'wb') as file:
              for chunk in response.iter_content(chunk_size=8192):
                file.write(chunk)
            return { "response_code": str(response.status_code), "error_message":error_message }

          except HTTPError as e:
            if e.code == 409:
              if attempt < max_retries - 1:
                time.sleep(wait_time)  # Wait for 5 seconds before retrying
                continue
              else:
                error_message = f"Error after max retries: { e }"
                           return {"response_code": "", "error_message": error_message + ' HEADERS:' + str(e.response.headers)}
            else:
              error_message = f"HTTP error: { e }"
                       return {"response_code": "", "error_message": error_message}
          except URLError as e:
            error_message = f"Error: { e.reason }"
                               return {"response_code": "", "error_message": error_message}
          except Exception as e:
            error_message = f"Error: { e }"
                   return {"response_code": "", "error_message": error_message}
  outputs:
    - response_code
    - error_message
  results:
    - SUCCESS
