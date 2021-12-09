
def runAnalysis(input_file, output_file, file_type): 
      headers = {
    # Request headers
    'Content-Type': file_type,
    'Ocp-Apim-Subscription-Key': apim_key
  }
  
    try:
        with open(input_file, "rb") as f:
            data_bytes = f.read()
    except IOError:
    print("Inputfile not accessible.")
    
    try:
        print('Initiating analysis...')
        resp = post(url = post_url, data = data_bytes, headers = headers, params = params)
        if resp.status_code != 202:
            print("POST analyze failed:\n%s" % json.dumps(resp.json()))
            quit()
            print("POST analyze succeeded:\n%s" % resp.headers)
            get_url = resp.headers["operation-location"]
    except Exception as e:
        print("POST analyze failed:\n%s" % str(e))
  
    n_tries = 30
    n_try = 0
    wait_sec = 1
    max_wait_sec = 180
    print('Getting analysis results...')
  
    while n_try < n_tries:
        print(n_try)
    try:
        resp = get(url = get_url, headers = {"Ocp-Apim-Subscription-Key": apim_key})
        resp_json = resp.json()
        if resp.status_code != 200:
            print("GET analyze results failed:\n%s" % json.dumps(resp_json))
            quit()
        status = resp_json["status"]
        if status == "succeeded":
        print("Succeded")
        if output_file:
            with open(output_file, 'w') as outfile:
            json.dump(resp_json, outfile, indent=2, sort_keys=True)  #Guarda los JSON con la extraccion de cada pagina de las facturas
            print("Analysis succeeded ",input_file)
            n_try=30
            return
        if status == "failed":
            print("Analysis failed:\n%s",input_file)
      # Analysis still running. Wait and retry.
        time.sleep(wait_sec)
        n_try += 1
        wait_sec = min(2*wait_sec, max_wait_sec)
    except Exception as e:
        msg = "GET analyze results failed:\n%s" % str(e)
        print(msg,input_file)
        print("Analyze operation did not complete within the allocated time.")

