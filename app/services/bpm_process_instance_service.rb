class BpmProcessInstanceService < ActivitiBpmService

  def self.process_instance_image(process_instance_id)
    get(
      '/runtime/process-instances/' + process_instance_id + '/diagram',
      basic_auth: @@auth
    ).body
  end

  def self.start_process(process_key, business_key, form)
    post(
      '/runtime/process-instances',
      basic_auth: @@auth,
      body: start_process_request_body(process_key, business_key, form),
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  private

  def self.start_process_request_body(process_key, business_key, form)
    variables = []
    form.each { |k, v| variables << { name: k, value: v } }
    {
      processDefinitionId: process_key,
      businessKey: business_key,
      variables: variables
    }.to_json
  end


end