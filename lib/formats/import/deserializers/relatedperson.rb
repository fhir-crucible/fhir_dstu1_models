module FHIR
    module Deserializer
        module RelatedPerson
        include FHIR::Formats::Utilities
        include FHIR::Deserializer::Utilities
            def parse_xml_entry(entry) 
                return nil unless entry
                model = self.new
                self.parse_element_data(model, entry)
                self.parse_resource_data(model, entry)
                set_model_data(model, 'identifier', entry.xpath('./fhir:identifier').map {|e| FHIR::Identifier.parse_xml_entry(e)})
                set_model_data(model, 'patient', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:patient')))
                set_model_data(model, 'relationship', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:relationship')))
                set_model_data(model, 'name', FHIR::HumanName.parse_xml_entry(entry.at_xpath('./fhir:name')))
                set_model_data(model, 'telecom', entry.xpath('./fhir:telecom').map {|e| FHIR::Contact.parse_xml_entry(e)})
                set_model_data(model, 'gender', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:gender')))
                set_model_data(model, 'address', FHIR::Address.parse_xml_entry(entry.at_xpath('./fhir:address')))
                set_model_data(model, 'photo', entry.xpath('./fhir:photo').map {|e| FHIR::Attachment.parse_xml_entry(e)})
                model
            end
        end
    end
end
