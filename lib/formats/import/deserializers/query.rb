module FHIR
    module Deserializer
        module Query
        include FHIR::Formats::Utilities
        include FHIR::Deserializer::Utilities
            def parse_xml_entry_QueryResponseComponent(entry) 
                return nil unless entry
                model = FHIR::Query::QueryResponseComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'identifier', entry.at_xpath('./fhir:identifier/@value').try(:value))
                set_model_data(model, 'outcome', entry.at_xpath('./fhir:outcome/@value').try(:value))
                set_model_data(model, 'total', entry.at_xpath('./fhir:total/@value').try(:value))
                set_model_data(model, 'parameter', entry.xpath('./fhir:parameter').map {|e| FHIR::Extension.parse_xml_entry(e)})
                set_model_data(model, 'first', entry.xpath('./fhir:first').map {|e| FHIR::Extension.parse_xml_entry(e)})
                set_model_data(model, 'previous', entry.xpath('./fhir:previous').map {|e| FHIR::Extension.parse_xml_entry(e)})
                set_model_data(model, 'next', entry.xpath('./fhir:next').map {|e| FHIR::Extension.parse_xml_entry(e)})
                set_model_data(model, 'last', entry.xpath('./fhir:last').map {|e| FHIR::Extension.parse_xml_entry(e)})
                set_model_data(model, 'reference', entry.xpath('./fhir:reference').map {|e| FHIR::ResourceReference.parse_xml_entry(e)})
                model
            end
            
            def parse_xml_entry(entry) 
                return nil unless entry
                model = self.new
                self.parse_element_data(model, entry)
                self.parse_resource_data(model, entry)
                set_model_data(model, 'identifier', entry.at_xpath('./fhir:identifier/@value').try(:value))
                set_model_data(model, 'parameter', entry.xpath('./fhir:parameter').map {|e| FHIR::Extension.parse_xml_entry(e)})
                set_model_data(model, 'response', parse_xml_entry_QueryResponseComponent(entry.at_xpath('./fhir:response')))
                model
            end
        end
    end
end
