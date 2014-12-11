module FHIR
    module Deserializer
        module ConceptMap
        include FHIR::Formats::Utilities
        include FHIR::Deserializer::Utilities
            def parse_xml_entry_OtherConceptComponent(entry) 
                return nil unless entry
                model = FHIR::ConceptMap::OtherConceptComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'concept', entry.at_xpath('./fhir:concept/@value').try(:value))
                set_model_data(model, 'system', entry.at_xpath('./fhir:system/@value').try(:value))
                set_model_data(model, 'code', entry.at_xpath('./fhir:code/@value').try(:value))
                model
            end
            
            def parse_xml_entry_ConceptMapConceptMapComponent(entry) 
                return nil unless entry
                model = FHIR::ConceptMap::ConceptMapConceptMapComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'system', entry.at_xpath('./fhir:system/@value').try(:value))
                set_model_data(model, 'code', entry.at_xpath('./fhir:code/@value').try(:value))
                set_model_data(model, 'equivalence', entry.at_xpath('./fhir:equivalence/@value').try(:value))
                set_model_data(model, 'comments', entry.at_xpath('./fhir:comments/@value').try(:value))
                set_model_data(model, 'product', entry.xpath('./fhir:product').map {|e| parse_xml_entry_OtherConceptComponent(e)})
                model
            end
            
            def parse_xml_entry_ConceptMapConceptComponent(entry) 
                return nil unless entry
                model = FHIR::ConceptMap::ConceptMapConceptComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'system', entry.at_xpath('./fhir:system/@value').try(:value))
                set_model_data(model, 'code', entry.at_xpath('./fhir:code/@value').try(:value))
                set_model_data(model, 'dependsOn', entry.xpath('./fhir:dependsOn').map {|e| parse_xml_entry_OtherConceptComponent(e)})
                set_model_data(model, 'map', entry.xpath('./fhir:map').map {|e| parse_xml_entry_ConceptMapConceptMapComponent(e)})
                model
            end
            
            def parse_xml_entry(entry) 
                return nil unless entry
                model = self.new
                self.parse_element_data(model, entry)
                self.parse_resource_data(model, entry)
                set_model_data(model, 'identifier', entry.at_xpath('./fhir:identifier/@value').try(:value))
                set_model_data(model, 'versionNum', entry.at_xpath('./fhir:version/@value').try(:value))
                set_model_data(model, 'name', entry.at_xpath('./fhir:name/@value').try(:value))
                set_model_data(model, 'publisher', entry.at_xpath('./fhir:publisher/@value').try(:value))
                set_model_data(model, 'telecom', entry.xpath('./fhir:telecom').map {|e| FHIR::Contact.parse_xml_entry(e)})
                set_model_data(model, 'description', entry.at_xpath('./fhir:description/@value').try(:value))
                set_model_data(model, 'copyright', entry.at_xpath('./fhir:copyright/@value').try(:value))
                set_model_data(model, 'status', entry.at_xpath('./fhir:status/@value').try(:value))
                set_model_data(model, 'experimental', entry.at_xpath('./fhir:experimental/@value').try(:value))
                set_model_data(model, 'date', entry.at_xpath('./fhir:date/@value').try(:value))
                set_model_data(model, 'source', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:source')))
                set_model_data(model, 'target', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:target')))
                set_model_data(model, 'concept', entry.xpath('./fhir:concept').map {|e| parse_xml_entry_ConceptMapConceptComponent(e)})
                model
            end
        end
    end
end
