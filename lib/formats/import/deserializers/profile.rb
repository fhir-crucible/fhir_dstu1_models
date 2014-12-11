module FHIR
    module Deserializer
        module Profile
        include FHIR::Formats::Utilities
        include FHIR::Deserializer::Utilities
            def parse_xml_entry_ProfileMappingComponent(entry) 
                return nil unless entry
                model = FHIR::Profile::ProfileMappingComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'identity', entry.at_xpath('./fhir:identity/@value').try(:value))
                set_model_data(model, 'uri', entry.at_xpath('./fhir:uri/@value').try(:value))
                set_model_data(model, 'name', entry.at_xpath('./fhir:name/@value').try(:value))
                set_model_data(model, 'comments', entry.at_xpath('./fhir:comments/@value').try(:value))
                model
            end
            
            def parse_xml_entry_ElementSlicingComponent(entry) 
                return nil unless entry
                model = FHIR::Profile::ElementSlicingComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'discriminator', entry.at_xpath('./fhir:discriminator/@value').try(:value))
                set_model_data(model, 'ordered', entry.at_xpath('./fhir:ordered/@value').try(:value))
                set_model_data(model, 'rules', entry.at_xpath('./fhir:rules/@value').try(:value))
                model
            end
            
            def parse_xml_entry_TypeRefComponent(entry) 
                return nil unless entry
                model = FHIR::Profile::TypeRefComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'code', entry.at_xpath('./fhir:code/@value').try(:value))
                set_model_data(model, 'profile', entry.at_xpath('./fhir:profile/@value').try(:value))
                set_model_data(model, 'aggregation', entry.xpath('./fhir:aggregation/@value').map {|e| e.value })
                model
            end
            
            def parse_xml_entry_ElementDefinitionConstraintComponent(entry) 
                return nil unless entry
                model = FHIR::Profile::ElementDefinitionConstraintComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'key', entry.at_xpath('./fhir:key/@value').try(:value))
                set_model_data(model, 'name', entry.at_xpath('./fhir:name/@value').try(:value))
                set_model_data(model, 'severity', entry.at_xpath('./fhir:severity/@value').try(:value))
                set_model_data(model, 'human', entry.at_xpath('./fhir:human/@value').try(:value))
                set_model_data(model, 'xpath', entry.at_xpath('./fhir:xpath/@value').try(:value))
                model
            end
            
            def parse_xml_entry_ElementDefinitionBindingComponent(entry) 
                return nil unless entry
                model = FHIR::Profile::ElementDefinitionBindingComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'name', entry.at_xpath('./fhir:name/@value').try(:value))
                set_model_data(model, 'isExtensible', entry.at_xpath('./fhir:isExtensible/@value').try(:value))
                set_model_data(model, 'conformance', entry.at_xpath('./fhir:conformance/@value').try(:value))
                set_model_data(model, 'description', entry.at_xpath('./fhir:description/@value').try(:value))
                set_model_data(model, 'referenceUri', entry.at_xpath('./fhir:referenceUri/@value').try(:value))
                set_model_data(model, 'referenceResource', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:referenceResource')))
                model
            end
            
            def parse_xml_entry_ElementDefinitionMappingComponent(entry) 
                return nil unless entry
                model = FHIR::Profile::ElementDefinitionMappingComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'identity', entry.at_xpath('./fhir:identity/@value').try(:value))
                set_model_data(model, 'map', entry.at_xpath('./fhir:map/@value').try(:value))
                model
            end
            
            def parse_xml_entry_ElementDefinitionComponent(entry) 
                return nil unless entry
                model = FHIR::Profile::ElementDefinitionComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'short', entry.at_xpath('./fhir:short/@value').try(:value))
                set_model_data(model, 'formal', entry.at_xpath('./fhir:formal/@value').try(:value))
                set_model_data(model, 'comments', entry.at_xpath('./fhir:comments/@value').try(:value))
                set_model_data(model, 'requirements', entry.at_xpath('./fhir:requirements/@value').try(:value))
                set_model_data(model, 'synonym', entry.xpath('./fhir:synonym/@value').map {|e| e.value })
                set_model_data(model, 'min', entry.at_xpath('./fhir:min/@value').try(:value))
                set_model_data(model, 'max', entry.at_xpath('./fhir:max/@value').try(:value))
                set_model_data(model, 'fhirType', entry.xpath('./fhir:type').map {|e| parse_xml_entry_TypeRefComponent(e)})
                set_model_data(model, 'nameReference', entry.at_xpath('./fhir:nameReference/@value').try(:value))
                entry.xpath("./*[contains(local-name(),'value')]").each do |e| 
                  model.valueType = e.name.gsub('value','')
                  v = e.at_xpath('@value').try(:value)
                  v = "FHIR::#{model.valueType}".constantize.parse_xml_entry(e) unless v
                  model.value = {type: model.valueType, value: v}
                end
                entry.xpath("./*[contains(local-name(),'example')]").each do |e| 
                  model.exampleType = e.name.gsub('example','')
                  v = e.at_xpath('@value').try(:value)
                  v = "FHIR::#{model.exampleType}".constantize.parse_xml_entry(e) unless v
                  model.example = {type: model.exampleType, value: v}
                end
                set_model_data(model, 'maxLength', entry.at_xpath('./fhir:maxLength/@value').try(:value))
                set_model_data(model, 'condition', entry.xpath('./fhir:condition/@value').map {|e| e.value })
                set_model_data(model, 'constraint', entry.xpath('./fhir:constraint').map {|e| parse_xml_entry_ElementDefinitionConstraintComponent(e)})
                set_model_data(model, 'mustSupport', entry.at_xpath('./fhir:mustSupport/@value').try(:value))
                set_model_data(model, 'isModifier', entry.at_xpath('./fhir:isModifier/@value').try(:value))
                set_model_data(model, 'binding', parse_xml_entry_ElementDefinitionBindingComponent(entry.at_xpath('./fhir:binding')))
                set_model_data(model, 'mapping', entry.xpath('./fhir:mapping').map {|e| parse_xml_entry_ElementDefinitionMappingComponent(e)})
                model
            end
            
            def parse_xml_entry_ElementComponent(entry) 
                return nil unless entry
                model = FHIR::Profile::ElementComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'path', entry.at_xpath('./fhir:path/@value').try(:value))
                set_model_data(model, 'representation', entry.xpath('./fhir:representation/@value').map {|e| e.value })
                set_model_data(model, 'name', entry.at_xpath('./fhir:name/@value').try(:value))
                set_model_data(model, 'slicing', parse_xml_entry_ElementSlicingComponent(entry.at_xpath('./fhir:slicing')))
                set_model_data(model, 'definition', parse_xml_entry_ElementDefinitionComponent(entry.at_xpath('./fhir:definition')))
                model
            end
            
            def parse_xml_entry_ProfileStructureSearchParamComponent(entry) 
                return nil unless entry
                model = FHIR::Profile::ProfileStructureSearchParamComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'name', entry.at_xpath('./fhir:name/@value').try(:value))
                set_model_data(model, 'fhirType', entry.at_xpath('./fhir:type/@value').try(:value))
                set_model_data(model, 'documentation', entry.at_xpath('./fhir:documentation/@value').try(:value))
                set_model_data(model, 'xpath', entry.at_xpath('./fhir:xpath/@value').try(:value))
                set_model_data(model, 'target', entry.xpath('./fhir:target/@value').map {|e| e.value })
                model
            end
            
            def parse_xml_entry_ProfileStructureComponent(entry) 
                return nil unless entry
                model = FHIR::Profile::ProfileStructureComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'fhirType', entry.at_xpath('./fhir:type/@value').try(:value))
                set_model_data(model, 'name', entry.at_xpath('./fhir:name/@value').try(:value))
                set_model_data(model, 'publish', entry.at_xpath('./fhir:publish/@value').try(:value))
                set_model_data(model, 'purpose', entry.at_xpath('./fhir:purpose/@value').try(:value))
                set_model_data(model, 'element', entry.xpath('./fhir:element').map {|e| parse_xml_entry_ElementComponent(e)})
                set_model_data(model, 'searchParam', entry.xpath('./fhir:searchParam').map {|e| parse_xml_entry_ProfileStructureSearchParamComponent(e)})
                model
            end
            
            def parse_xml_entry_ProfileExtensionDefnComponent(entry) 
                return nil unless entry
                model = FHIR::Profile::ProfileExtensionDefnComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'code', entry.at_xpath('./fhir:code/@value').try(:value))
                set_model_data(model, 'display', entry.at_xpath('./fhir:display/@value').try(:value))
                set_model_data(model, 'contextType', entry.at_xpath('./fhir:contextType/@value').try(:value))
                set_model_data(model, 'context', entry.xpath('./fhir:context/@value').map {|e| e.value })
                set_model_data(model, 'definition', parse_xml_entry_ElementDefinitionComponent(entry.at_xpath('./fhir:definition')))
                model
            end
            
            def parse_xml_entry_ProfileQueryComponent(entry) 
                return nil unless entry
                model = FHIR::Profile::ProfileQueryComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'name', entry.at_xpath('./fhir:name/@value').try(:value))
                set_model_data(model, 'documentation', entry.at_xpath('./fhir:documentation/@value').try(:value))
                set_model_data(model, 'parameter', entry.xpath('./fhir:parameter').map {|e| parse_xml_entry_ProfileStructureSearchParamComponent(e)})
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
                set_model_data(model, 'code', entry.xpath('./fhir:code').map {|e| FHIR::Coding.parse_xml_entry(e)})
                set_model_data(model, 'status', entry.at_xpath('./fhir:status/@value').try(:value))
                set_model_data(model, 'experimental', entry.at_xpath('./fhir:experimental/@value').try(:value))
                set_model_data(model, 'date', entry.at_xpath('./fhir:date/@value').try(:value))
                set_model_data(model, 'requirements', entry.at_xpath('./fhir:requirements/@value').try(:value))
                set_model_data(model, 'fhirVersion', entry.at_xpath('./fhir:fhirVersion/@value').try(:value))
                set_model_data(model, 'mapping', entry.xpath('./fhir:mapping').map {|e| parse_xml_entry_ProfileMappingComponent(e)})
                set_model_data(model, 'structure', entry.xpath('./fhir:structure').map {|e| parse_xml_entry_ProfileStructureComponent(e)})
                set_model_data(model, 'extensionDefn', entry.xpath('./fhir:extensionDefn').map {|e| parse_xml_entry_ProfileExtensionDefnComponent(e)})
                set_model_data(model, 'query', entry.xpath('./fhir:query').map {|e| parse_xml_entry_ProfileQueryComponent(e)})
                model
            end
        end
    end
end
