module FHIR
    module Deserializer
        module CarePlan
        include FHIR::Formats::Utilities
        include FHIR::Deserializer::Utilities
            def parse_xml_entry_CarePlanParticipantComponent(entry) 
                return nil unless entry
                model = FHIR::CarePlan::CarePlanParticipantComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'role', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:role')))
                set_model_data(model, 'member', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:member')))
                model
            end
            
            def parse_xml_entry_CarePlanGoalComponent(entry) 
                return nil unless entry
                model = FHIR::CarePlan::CarePlanGoalComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'description', entry.at_xpath('./fhir:description/@value').try(:value))
                set_model_data(model, 'status', entry.at_xpath('./fhir:status/@value').try(:value))
                set_model_data(model, 'notes', entry.at_xpath('./fhir:notes/@value').try(:value))
                set_model_data(model, 'concern', entry.xpath('./fhir:concern').map {|e| FHIR::ResourceReference.parse_xml_entry(e)})
                model
            end
            
            def parse_xml_entry_CarePlanActivitySimpleComponent(entry) 
                return nil unless entry
                model = FHIR::CarePlan::CarePlanActivitySimpleComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'category', entry.at_xpath('./fhir:category/@value').try(:value))
                set_model_data(model, 'code', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:code')))
                set_model_data(model, 'timingSchedule', FHIR::Schedule.parse_xml_entry(entry.at_xpath('./fhir:timingSchedule')))
                set_model_data(model, 'timingPeriod', FHIR::Period.parse_xml_entry(entry.at_xpath('./fhir:timingPeriod')))
                set_model_data(model, 'timingString', entry.at_xpath('./fhir:timingString/@value').try(:value))
                set_model_data(model, 'location', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:location')))
                set_model_data(model, 'performer', entry.xpath('./fhir:performer').map {|e| FHIR::ResourceReference.parse_xml_entry(e)})
                set_model_data(model, 'product', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:product')))
                set_model_data(model, 'dailyAmount', FHIR::Quantity.parse_xml_entry(entry.at_xpath('./fhir:dailyAmount')))
                set_model_data(model, 'quantity', FHIR::Quantity.parse_xml_entry(entry.at_xpath('./fhir:quantity')))
                set_model_data(model, 'details', entry.at_xpath('./fhir:details/@value').try(:value))
                model
            end
            
            def parse_xml_entry_CarePlanActivityComponent(entry) 
                return nil unless entry
                model = FHIR::CarePlan::CarePlanActivityComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'goal', entry.xpath('./fhir:goal/@value').map {|e| e.value })
                set_model_data(model, 'status', entry.at_xpath('./fhir:status/@value').try(:value))
                set_model_data(model, 'prohibited', entry.at_xpath('./fhir:prohibited/@value').try(:value))
                set_model_data(model, 'actionResulting', entry.xpath('./fhir:actionResulting').map {|e| FHIR::ResourceReference.parse_xml_entry(e)})
                set_model_data(model, 'notes', entry.at_xpath('./fhir:notes/@value').try(:value))
                set_model_data(model, 'detail', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:detail')))
                set_model_data(model, 'simple', parse_xml_entry_CarePlanActivitySimpleComponent(entry.at_xpath('./fhir:simple')))
                model
            end
            
            def parse_xml_entry(entry) 
                return nil unless entry
                model = self.new
                self.parse_element_data(model, entry)
                self.parse_resource_data(model, entry)
                set_model_data(model, 'identifier', entry.xpath('./fhir:identifier').map {|e| FHIR::Identifier.parse_xml_entry(e)})
                set_model_data(model, 'patient', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:patient')))
                set_model_data(model, 'status', entry.at_xpath('./fhir:status/@value').try(:value))
                set_model_data(model, 'period', FHIR::Period.parse_xml_entry(entry.at_xpath('./fhir:period')))
                set_model_data(model, 'modified', entry.at_xpath('./fhir:modified/@value').try(:value))
                set_model_data(model, 'concern', entry.xpath('./fhir:concern').map {|e| FHIR::ResourceReference.parse_xml_entry(e)})
                set_model_data(model, 'participant', entry.xpath('./fhir:participant').map {|e| parse_xml_entry_CarePlanParticipantComponent(e)})
                set_model_data(model, 'goal', entry.xpath('./fhir:goal').map {|e| parse_xml_entry_CarePlanGoalComponent(e)})
                set_model_data(model, 'activity', entry.xpath('./fhir:activity').map {|e| parse_xml_entry_CarePlanActivityComponent(e)})
                set_model_data(model, 'notes', entry.at_xpath('./fhir:notes/@value').try(:value))
                model
            end
        end
    end
end
