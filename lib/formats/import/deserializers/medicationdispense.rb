module FHIR
    module Deserializer
        module MedicationDispense
        include FHIR::Formats::Utilities
        include FHIR::Deserializer::Utilities
            def parse_xml_entry_MedicationDispenseDispenseDosageComponent(entry) 
                return nil unless entry
                model = FHIR::MedicationDispense::MedicationDispenseDispenseDosageComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'additionalInstructions', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:additionalInstructions')))
                set_model_data(model, 'timingDateTime', entry.at_xpath('./fhir:timingDateTime/@value').try(:value))
                set_model_data(model, 'timingPeriod', FHIR::Period.parse_xml_entry(entry.at_xpath('./fhir:timingPeriod')))
                set_model_data(model, 'timingSchedule', FHIR::Schedule.parse_xml_entry(entry.at_xpath('./fhir:timingSchedule')))
                set_model_data(model, 'asNeededBoolean', entry.at_xpath('./fhir:asNeededBoolean/@value').try(:value))
                set_model_data(model, 'asNeededCodeableConcept', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:asNeededCodeableConcept')))
                set_model_data(model, 'site', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:site')))
                set_model_data(model, 'route', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:route')))
                set_model_data(model, 'method', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:method')))
                set_model_data(model, 'quantity', FHIR::Quantity.parse_xml_entry(entry.at_xpath('./fhir:quantity')))
                set_model_data(model, 'rate', FHIR::Ratio.parse_xml_entry(entry.at_xpath('./fhir:rate')))
                set_model_data(model, 'maxDosePerPeriod', FHIR::Ratio.parse_xml_entry(entry.at_xpath('./fhir:maxDosePerPeriod')))
                model
            end
            
            def parse_xml_entry_MedicationDispenseDispenseComponent(entry) 
                return nil unless entry
                model = FHIR::MedicationDispense::MedicationDispenseDispenseComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'identifier', FHIR::Identifier.parse_xml_entry(entry.at_xpath('./fhir:identifier')))
                set_model_data(model, 'status', entry.at_xpath('./fhir:status/@value').try(:value))
                set_model_data(model, 'fhirType', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:type')))
                set_model_data(model, 'quantity', FHIR::Quantity.parse_xml_entry(entry.at_xpath('./fhir:quantity')))
                set_model_data(model, 'medication', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:medication')))
                set_model_data(model, 'whenPrepared', entry.at_xpath('./fhir:whenPrepared/@value').try(:value))
                set_model_data(model, 'whenHandedOver', entry.at_xpath('./fhir:whenHandedOver/@value').try(:value))
                set_model_data(model, 'destination', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:destination')))
                set_model_data(model, 'receiver', entry.xpath('./fhir:receiver').map {|e| FHIR::ResourceReference.parse_xml_entry(e)})
                set_model_data(model, 'dosage', entry.xpath('./fhir:dosage').map {|e| parse_xml_entry_MedicationDispenseDispenseDosageComponent(e)})
                model
            end
            
            def parse_xml_entry_MedicationDispenseSubstitutionComponent(entry) 
                return nil unless entry
                model = FHIR::MedicationDispense::MedicationDispenseSubstitutionComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'fhirType', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:type')))
                set_model_data(model, 'reason', entry.xpath('./fhir:reason').map {|e| FHIR::CodeableConcept.parse_xml_entry(e)})
                set_model_data(model, 'responsibleParty', entry.xpath('./fhir:responsibleParty').map {|e| FHIR::ResourceReference.parse_xml_entry(e)})
                model
            end
            
            def parse_xml_entry(entry) 
                return nil unless entry
                model = self.new
                self.parse_element_data(model, entry)
                self.parse_resource_data(model, entry)
                set_model_data(model, 'identifier', FHIR::Identifier.parse_xml_entry(entry.at_xpath('./fhir:identifier')))
                set_model_data(model, 'status', entry.at_xpath('./fhir:status/@value').try(:value))
                set_model_data(model, 'patient', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:patient')))
                set_model_data(model, 'dispenser', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:dispenser')))
                set_model_data(model, 'authorizingPrescription', entry.xpath('./fhir:authorizingPrescription').map {|e| FHIR::ResourceReference.parse_xml_entry(e)})
                set_model_data(model, 'dispense', entry.xpath('./fhir:dispense').map {|e| parse_xml_entry_MedicationDispenseDispenseComponent(e)})
                set_model_data(model, 'substitution', parse_xml_entry_MedicationDispenseSubstitutionComponent(entry.at_xpath('./fhir:substitution')))
                model
            end
        end
    end
end
