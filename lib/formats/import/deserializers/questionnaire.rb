module FHIR
    module Deserializer
        module Questionnaire
        include FHIR::Formats::Utilities
        include FHIR::Deserializer::Utilities
            def parse_xml_entry_QuestionComponent(entry) 
                return nil unless entry
                model = FHIR::Questionnaire::QuestionComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'name', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:name')))
                set_model_data(model, 'text', entry.at_xpath('./fhir:text/@value').try(:value))
                set_model_data(model, 'answerDecimal', entry.at_xpath('./fhir:answerDecimal/@value').try(:value))
                set_model_data(model, 'answerInteger', entry.at_xpath('./fhir:answerInteger/@value').try(:value))
                set_model_data(model, 'answerBoolean', entry.at_xpath('./fhir:answerBoolean/@value').try(:value))
                set_model_data(model, 'answerDate', entry.at_xpath('./fhir:answerDate/@value').try(:value))
                set_model_data(model, 'answerString', entry.at_xpath('./fhir:answerString/@value').try(:value))
                set_model_data(model, 'answerDateTime', entry.at_xpath('./fhir:answerDateTime/@value').try(:value))
                set_model_data(model, 'answerInstant', parse_date_time(entry.at_xpath('./fhir:answerInstant/@value').try(:value)))
                set_model_data(model, 'choice', entry.xpath('./fhir:choice').map {|e| FHIR::Coding.parse_xml_entry(e)})
                set_model_data(model, 'options', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:options')))
                entry.xpath("./*[contains(local-name(),'data')]").each do |e| 
                  model.dataType = e.name.gsub('data','')
                  v = e.at_xpath('@value').try(:value)
                  v = "FHIR::#{model.dataType}".constantize.parse_xml_entry(e) unless v
                  model.data = {type: model.dataType, value: v}
                end
                set_model_data(model, 'remarks', entry.at_xpath('./fhir:remarks/@value').try(:value))
                set_model_data(model, 'group', entry.xpath('./fhir:group').map {|e| parse_xml_entry_GroupComponent(e)})
                model
            end
            
            def parse_xml_entry_GroupComponent(entry) 
                return nil unless entry
                model = FHIR::Questionnaire::GroupComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'name', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:name')))
                set_model_data(model, 'header', entry.at_xpath('./fhir:header/@value').try(:value))
                set_model_data(model, 'text', entry.at_xpath('./fhir:text/@value').try(:value))
                set_model_data(model, 'subject', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:subject')))
                set_model_data(model, 'group', entry.xpath('./fhir:group').map {|e| parse_xml_entry_GroupComponent(e)})
                set_model_data(model, 'question', entry.xpath('./fhir:question').map {|e| parse_xml_entry_QuestionComponent(e)})
                model
            end
            
            def parse_xml_entry(entry) 
                return nil unless entry
                model = self.new
                self.parse_element_data(model, entry)
                self.parse_resource_data(model, entry)
                set_model_data(model, 'status', entry.at_xpath('./fhir:status/@value').try(:value))
                set_model_data(model, 'authored', entry.at_xpath('./fhir:authored/@value').try(:value))
                set_model_data(model, 'subject', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:subject')))
                set_model_data(model, 'author', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:author')))
                set_model_data(model, 'source', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:source')))
                set_model_data(model, 'name', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:name')))
                set_model_data(model, 'identifier', entry.xpath('./fhir:identifier').map {|e| FHIR::Identifier.parse_xml_entry(e)})
                set_model_data(model, 'encounter', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:encounter')))
                set_model_data(model, 'group', parse_xml_entry_GroupComponent(entry.at_xpath('./fhir:group')))
                model
            end
        end
    end
end
