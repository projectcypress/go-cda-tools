require 'ffi'
require 'health-data-standards'
require 'pry'

module GoCDATools
  module Import
    class GoImporter
      include Singleton
      extend FFI::Library
        ffi_lib File.expand_path("../../../ext/libgocda.so", File.dirname(__FILE__))
        attach_function :import_cat1, [:string], :string

        def parse_with_ffi(file)
          data = file.kind_of?(String) ? file : file.inner_html
          data.gsub!("<?xml-stylesheet type=\"text/xsl\" href=\"cda.xsl\">",'')
          patient_json_string = import_cat1(data)
          patient = Record.new(JSON.parse(patient_json_string))
          patient
        end

    end
  end
end
