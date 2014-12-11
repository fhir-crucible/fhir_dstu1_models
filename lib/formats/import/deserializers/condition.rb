module FHIR
    module Deserializer
        module Condition
        include FHIR::Formats::Utilities
        include FHIR::Deserializer::Utilities
            def parse_xml_entry_ConditionStageComponent(entry) 
                return nil unless entry
                model = FHIR::Condition::ConditionStageComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'summary', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:summary')))
                set_model_data(model, 'assessment', entry.xpath('./fhir:assessment').map {|e| FHIR::ResourceReference.parse_xml_entry(e)})
                model
            end
            
            def parse_xml_entry_ConditionEvidenceComponent(entry) 
                return nil unless entry
                model = FHIR::Condition::ConditionEvidenceComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'code', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:code')))
                set_model_data(model, 'detail', entry.xpath('./fhir:detail').map {|e| FHIR::ResourceReference.parse_xml_entry(e)})
                model
            end
            
            def parse_xml_entry_ConditionLocationComponent(entry) 
                return nil unless entry
                model = FHIR::Condition::ConditionLocationComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'code', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:code')))
                set_model_data(model, 'detail', entry.at_xpath('./fhir:detail/@value').try(:value))
                model
            end
            
            def parse_xml_entry_ConditionRelatedItemComponent(entry) 
                return nil unless entry
                model = FHIR::Condition::ConditionRelatedItemComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'fhirType', entry.at_xpath('./fhir:type/@value').try(:value))
                set_model_data(model, 'code', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:code')))
                set_model_data(model, 'target', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:target')))
                model
            end
            
            def parse_xml_entry(entry) 
                return nil unless entry
                model = self.new
                self.parse_element_data(model, entry)
                self.parse_resource_data(model, entry)
                set_model_data(model, 'identifier', entry.xpath('./fhir:identifier').map {|e| FHIR::Identifier.parse_xml_entry(e)})
                set_model_data(model, 'subject', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:subject')))
                set_model_data(model, 'encounter', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:encounter')))
                set_model_data(model, 'asserter', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:asserter')))
                set_model_data(model, 'dateAsserted', entry.at_xpath('./fhir:dateAsserted/@value').try(:value))
                set_model_data(model, 'code', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:code')))
                set_model_data(model, 'category', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:category')))
                set_model_data(model, 'status', entry.at_xpath('./fhir:status/@value').try(:value))
                set_model_data(model, 'certainty', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:certainty')))
                set_model_data(model, 'severity', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:severity')))
                set_model_data(model, 'onsetDate', entry.at_xpath('./fhir:onsetDate/@value').try(:value))
                set_model_data(model, 'onsetAge', FHIR::Quantity.parse_xml_entry(entry.at_xpath('./fhir:onsetAge')))
                set_model_data(model, 'abatementDate', entry.at_xpath('./fhir:abatementDate/@value').try(:value))
                set_model_data(model, 'abatementAge', FHIR::Quantity.parse_xml_entry(entry.at_xpath('./fhir:abatementAge')))
                set_model_data(model, 'abatementBoolean', entry.at_xpath('./fhir:abatementBoolean/@value').try(:value))
                set_model_data(model, 'stage', parse_xml_entry_ConditionStageComponent(entry.at_xpath('./fhir:stage')))
                set_model_data(model, 'evidence', entry.xpath('./fhir:evidence').map {|e| parse_xml_entry_ConditionEvidenceComponent(e)})
                set_model_data(model, 'location', entry.xpath('./fhir:location').map {|e| parse_xml_entry_ConditionLocationComponent(e)})
                set_model_data(model, 'relatedItem', entry.xpath('./fhir:relatedItem').map {|e| parse_xml_entry_ConditionRelatedItemComponent(e)})
                set_model_data(model, 'notes', entry.at_xpath('./fhir:notes/@value').try(:value))
                model
            end
        end
    end
end
