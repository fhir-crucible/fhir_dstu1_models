module FHIR
    module Deserializer
        module AdverseReaction
        include FHIR::Formats::Utilities
        include FHIR::Deserializer::Utilities
            def parse_xml_entry_AdverseReactionSymptomComponent(entry) 
                return nil unless entry
                model = FHIR::AdverseReaction::AdverseReactionSymptomComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'code', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:code')))
                set_model_data(model, 'severity', entry.at_xpath('./fhir:severity/@value').try(:value))
                model
            end
            
            def parse_xml_entry_AdverseReactionExposureComponent(entry) 
                return nil unless entry
                model = FHIR::AdverseReaction::AdverseReactionExposureComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'date', entry.at_xpath('./fhir:date/@value').try(:value))
                set_model_data(model, 'fhirType', entry.at_xpath('./fhir:type/@value').try(:value))
                set_model_data(model, 'causalityExpectation', entry.at_xpath('./fhir:causalityExpectation/@value').try(:value))
                set_model_data(model, 'substance', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:substance')))
                model
            end
            
            def parse_xml_entry(entry) 
                return nil unless entry
                model = self.new
                self.parse_element_data(model, entry)
                self.parse_resource_data(model, entry)
                set_model_data(model, 'identifier', entry.xpath('./fhir:identifier').map {|e| FHIR::Identifier.parse_xml_entry(e)})
                set_model_data(model, 'date', entry.at_xpath('./fhir:date/@value').try(:value))
                set_model_data(model, 'subject', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:subject')))
                set_model_data(model, 'didNotOccurFlag', entry.at_xpath('./fhir:didNotOccurFlag/@value').try(:value))
                set_model_data(model, 'recorder', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:recorder')))
                set_model_data(model, 'symptom', entry.xpath('./fhir:symptom').map {|e| parse_xml_entry_AdverseReactionSymptomComponent(e)})
                set_model_data(model, 'exposure', entry.xpath('./fhir:exposure').map {|e| parse_xml_entry_AdverseReactionExposureComponent(e)})
                model
            end
        end
    end
end
