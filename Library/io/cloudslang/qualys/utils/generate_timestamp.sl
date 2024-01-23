namespace: io.cloudslang.qualys.utils
operation:
  name: generate_timestamp
  python_action:
    use_jython: false
    script: |-
      def execute():
          from datetime import datetime
          # Get the current UTC time
          utc_now = datetime.utcnow()
          # Format the time in the specified format
          timestamp = utc_now.strftime("%Y-%m-%dT%H:%M:%SZ")
          return {"timestamp":timestamp}
  outputs:
    - timestamp
  results:
    - SUCCESS
