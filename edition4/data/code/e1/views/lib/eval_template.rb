class EvalTemplate < ActionView::TemplateHandler
  include ActionView::TemplateHandlers::Compilable
  def compile(template)
    compiled = "controller.headers['Content-Type'] ||= 'text/plain'\n"
    compiled << "output = ''\n"
    
    compiled << template.source.split(/\n/).map do |line|
      <<-ruby_eval
        line = #{line.inspect}
        @eval_template_scope ||= binding
        begin
          output << line + " => " + eval(line,@eval_template_scope).to_s + "\n"
        rescue Exception => err
          output << line + " => " + err.inspect + "\n"
        end
      ruby_eval
    end.join("\n")
  end
end
