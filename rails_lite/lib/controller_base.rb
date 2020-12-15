require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    # debuggers
    @already_built_response ||= false
  end

  # Set the response status code and header
  def redirect_to(url) #
    raise "Already Built" if @already_built_response
    res.set_header("Location", url)
    res.status = 302
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    # debugger
    if !already_built_response?
      res.content_type = content_type
      res.write(content)
      @already_built_response = true
      # debugger
    else
      raise "Double Render!"
    end
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    raise "Already Built" if @already_built_response
    # debugger  
    controller_name =self.class.name.underscore 
    current_directory = File.dirname(__FILE__)
    template_file = File.join(current_directory, "..", "views", controller_name, template_name.to_s + ".html.erb")
    debugger
    body = ERB.new(File.read(template_file))
    
    render_content(body, 'text/html')
    #use __FILE__ to grab current directory ../views....self.class.name.underscore /template_name
    #File.join ^^ 
    #File.read() 
    # File 

  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

