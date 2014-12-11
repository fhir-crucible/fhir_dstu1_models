module FHIR
    module Deserializer
        module Practitioner
        include FHIR::Formats::Utilities
        include FHIR::Deserializer::Utilities
            def parse_xml_entry_PractitionerQualificationComponent(entry) 
                return nil unless entry
                model = FHIR::Practitioner::PractitionerQualificationComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'code', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:code')))
                set_model_data(model, 'period', FHIR::Period.parse_xml_entry(entry.at_xpath('./fhir:period')))
                set_model_data(model, 'issuer', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:issuer')))
                model
            end
            
            def parse_xml_entry(entry) 
                return nil unless entry
                model = self.new
                self.parse_element_data(model, entry)
                self.parse_resource_data(model, entry)
                set_model_data(model, 'identifier', entry.xpath('./fhir:identifier').map {|e| FHIR::Identifier.parse_xml_entry(e)})
                set_model_data(model, 'name', FHIR::HumanName.parse_xml_entry(entry.at_xpath('./fhir:name')))
                set_model_data(model, 'telecom', entry.xpath('./fhir:telecom').map {|e| FHIR::Contact.parse_xml_entry(e)})
                set_model_data(model, 'address', FHIR::Address.parse_xml_entry(entry.at_xpath('./fhir:address')))
                set_model_data(model, 'gender', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:gender')))
                set_model_data(model, 'birthDate', entry.at_xpath('./fhir:birthDate/@value').try(:value))
                set_model_data(model, 'photo', entry.xpath('./fhir:photo').map {|e| FHIR::Attachment.parse_xml_entry(e)})
                set_model_data(model, 'organization', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:organization')))
                set_model_data(model, 'role', entry.xpath('./fhir:role').map {|e| FHIR::CodeableConcept.parse_xml_entry(e)})
                set_model_data(model, 'specialty', entry.xpath('./fhir:specialty').map {|e| FHIR::CodeableConcept.parse_xml_entry(e)})
                set_model_data(model, 'period', FHIR::Period.parse_xml_entry(entry.at_xpath('./fhir:period')))
                set_model_data(model, 'location', entry.xpath('./fhir:location').map {|e| FHIR::ResourceReference.parse_xml_entry(e)})
                set_model_data(model, 'qualification', entry.xpath('./fhir:qualification').map {|e| parse_xml_entry_PractitionerQualificationComponent(e)})
                set_model_data(model, 'communication', entry.xpath('./fhir:communication').map {|e| FHIR::CodeableConcept.parse_xml_entry(e)})
                model
            end
        end
    end
end
