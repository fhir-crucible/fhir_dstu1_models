module FHIR
    module Deserializer
        module FamilyHistory
        include FHIR::Formats::Utilities
        include FHIR::Deserializer::Utilities
            def parse_xml_entry_FamilyHistoryRelationConditionComponent(entry) 
                return nil unless entry
                model = FHIR::FamilyHistory::FamilyHistoryRelationConditionComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'fhirType', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:type')))
                set_model_data(model, 'outcome', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:outcome')))
                set_model_data(model, 'onsetAge', FHIR::Quantity.parse_xml_entry(entry.at_xpath('./fhir:onsetAge')))
                set_model_data(model, 'onsetRange', FHIR::Range.parse_xml_entry(entry.at_xpath('./fhir:onsetRange')))
                set_model_data(model, 'onsetString', entry.at_xpath('./fhir:onsetString/@value').try(:value))
                set_model_data(model, 'note', entry.at_xpath('./fhir:note/@value').try(:value))
                model
            end
            
            def parse_xml_entry_FamilyHistoryRelationComponent(entry) 
                return nil unless entry
                model = FHIR::FamilyHistory::FamilyHistoryRelationComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'name', entry.at_xpath('./fhir:name/@value').try(:value))
                set_model_data(model, 'relationship', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:relationship')))
                set_model_data(model, 'bornPeriod', FHIR::Period.parse_xml_entry(entry.at_xpath('./fhir:bornPeriod')))
                set_model_data(model, 'bornDate', entry.at_xpath('./fhir:bornDate/@value').try(:value))
                set_model_data(model, 'bornString', entry.at_xpath('./fhir:bornString/@value').try(:value))
                set_model_data(model, 'deceasedBoolean', entry.at_xpath('./fhir:deceasedBoolean/@value').try(:value))
                set_model_data(model, 'deceasedAge', FHIR::Quantity.parse_xml_entry(entry.at_xpath('./fhir:deceasedAge')))
                set_model_data(model, 'deceasedRange', FHIR::Range.parse_xml_entry(entry.at_xpath('./fhir:deceasedRange')))
                set_model_data(model, 'deceasedDate', entry.at_xpath('./fhir:deceasedDate/@value').try(:value))
                set_model_data(model, 'deceasedString', entry.at_xpath('./fhir:deceasedString/@value').try(:value))
                set_model_data(model, 'note', entry.at_xpath('./fhir:note/@value').try(:value))
                set_model_data(model, 'condition', entry.xpath('./fhir:condition').map {|e| parse_xml_entry_FamilyHistoryRelationConditionComponent(e)})
                model
            end
            
            def parse_xml_entry(entry) 
                return nil unless entry
                model = self.new
                self.parse_element_data(model, entry)
                self.parse_resource_data(model, entry)
                set_model_data(model, 'identifier', entry.xpath('./fhir:identifier').map {|e| FHIR::Identifier.parse_xml_entry(e)})
                set_model_data(model, 'subject', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:subject')))
                set_model_data(model, 'note', entry.at_xpath('./fhir:note/@value').try(:value))
                set_model_data(model, 'relation', entry.xpath('./fhir:relation').map {|e| parse_xml_entry_FamilyHistoryRelationComponent(e)})
                model
            end
        end
    end
end
