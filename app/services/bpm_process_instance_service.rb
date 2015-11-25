class BpmProcessInstanceService < ActivitiBpmService

  def self.process_instance(process_instance_id)
    hash_bpm_processes = get(
      '/runtime/process-instances/' + process_instance_id,
      basic_auth: @@auth
    )
    BpmProcessInstance.new(hash_bpm_processes)
  end

  def self.historic_process_instance(process_instance_id)
    hash_bpm_process = get(
      '/history/historic-process-instances/' + process_instance_id.to_s,
      basic_auth: @@auth
    )
    BpmProcessInstance.new(hash_bpm_process)
  end

  def self.process_instance_list
    process_list = get(
      '/runtime/process-instances/',
      basic_auth: @@auth
    )["data"]

    process_list.each do |p|
      processes << BpmProcessInstance.new(p)
    end

    return processes
  end

  def self.process_instance_image(process_instance)
    # binding.pry
    id = process_instance.process_instance_id.to_s
    if (process_instance.completed == true) 
      get(
        'http://localhost:8080/bpm/service/repository/deployments/2509/resourcedata/RackMultipart20151125-8296-bpqlug.myProcess.png',
        basic_auth: @@auth
      ).body
    
     else 
      get(
        '/runtime/process-instances/' + id + '/diagram',
        basic_auth: @@auth
      ).body
    end     
  end

  def self.start_process(process_key, business_key, form)
    hash_process_instance = post(
      '/runtime/process-instances',
      basic_auth: @@auth,
      body: start_process_request_body(process_key, business_key, form),
      headers: { 'Content-Type' => 'application/json' }
    )
    BpmProcessInstance.new(hash_process_instance)
  end

  private

  def self.start_process_request_body(process_key, business_key, form)
    variables = []
    {
      processDefinitionKey: process_key,
      businessKey: business_key,
      variables: variables_from_hash(form)
    }.to_json
  end


end
