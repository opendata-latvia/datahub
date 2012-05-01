module AttachmentSpecHelper
  def attachment(file_name, content)
    file = Tempfile.new(file_name)
    file.instance_variable_set("@_file_name", file_name)
    file.write(content)
    # file.stub!(:local_path).and_return(file_name)
    def file.local_path; @_file_name; end
    # file.stub!(:original_filename).and_return(file_name)
    def file.original_filename; @_file_name; end
    file.instance_eval {alias :size :length}
    file.seek(0)
    file
  end
end
