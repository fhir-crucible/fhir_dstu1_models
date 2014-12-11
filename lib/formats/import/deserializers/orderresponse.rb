module FHIR
    module Deserializer
        module OrderResponse
        include FHIR::Formats::Utilities
        include FHIR::Deserializer::Utilities
            def parse_xml_entry(entry) 
                return nil unless entry
                model = self.new
                self.parse_element_data(model, entry)
                self.parse_resource_data(model, entry)
                set_model_data(model, 'identifier', entry.xpath('./fhir:identifier').map {|e| FHIR::Identifier.parse_xml_entry(e)})
                set_model_data(model, 'request', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:request')))
                set_model_data(model, 'date', entry.at_xpath('./fhir:date/@value').try(:value))
                set_model_data(model, 'who', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:who')))
                set_model_data(model, 'authorityCodeableConcept', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:authorityCodeableConcept')))
                set_model_data(model, 'authorityResource', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:authorityResource')))
                set_model_data(model, 'code', entry.at_xpath('./fhir:code/@value').try(:value))
                set_model_data(model, 'description', entry.at_xpath('./fhir:description/@value').try(:value))
                set_model_data(model, 'fulfillment', entry.xpath('./fhir:fulfillment').map {|e| FHIR::ResourceReference.parse_xml_entry(e)})
                model
            end
        end
    end
end
