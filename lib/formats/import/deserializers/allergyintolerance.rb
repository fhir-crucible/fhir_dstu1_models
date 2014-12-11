module FHIR
    module Deserializer
        module AllergyIntolerance
        include FHIR::Formats::Utilities
        include FHIR::Deserializer::Utilities
            def parse_xml_entry(entry) 
                return nil unless entry
                model = self.new
                self.parse_element_data(model, entry)
                self.parse_resource_data(model, entry)
                set_model_data(model, 'identifier', entry.xpath('./fhir:identifier').map {|e| FHIR::Identifier.parse_xml_entry(e)})
                set_model_data(model, 'criticality', entry.at_xpath('./fhir:criticality/@value').try(:value))
                set_model_data(model, 'sensitivityType', entry.at_xpath('./fhir:sensitivityType/@value').try(:value))
                set_model_data(model, 'recordedDate', entry.at_xpath('./fhir:recordedDate/@value').try(:value))
                set_model_data(model, 'status', entry.at_xpath('./fhir:status/@value').try(:value))
                set_model_data(model, 'subject', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:subject')))
                set_model_data(model, 'recorder', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:recorder')))
                set_model_data(model, 'substance', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:substance')))
                set_model_data(model, 'reaction', entry.xpath('./fhir:reaction').map {|e| FHIR::ResourceReference.parse_xml_entry(e)})
                set_model_data(model, 'sensitivityTest', entry.xpath('./fhir:sensitivityTest').map {|e| FHIR::ResourceReference.parse_xml_entry(e)})
                model
            end
        end
    end
end
