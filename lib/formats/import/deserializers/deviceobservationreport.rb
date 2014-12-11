module FHIR
    module Deserializer
        module DeviceObservationReport
        include FHIR::Formats::Utilities
        include FHIR::Deserializer::Utilities
            def parse_xml_entry_DeviceObservationReportVirtualDeviceChannelMetricComponent(entry) 
                return nil unless entry
                model = FHIR::DeviceObservationReport::DeviceObservationReportVirtualDeviceChannelMetricComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'observation', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:observation')))
                model
            end
            
            def parse_xml_entry_DeviceObservationReportVirtualDeviceChannelComponent(entry) 
                return nil unless entry
                model = FHIR::DeviceObservationReport::DeviceObservationReportVirtualDeviceChannelComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'code', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:code')))
                set_model_data(model, 'metric', entry.xpath('./fhir:metric').map {|e| parse_xml_entry_DeviceObservationReportVirtualDeviceChannelMetricComponent(e)})
                model
            end
            
            def parse_xml_entry_DeviceObservationReportVirtualDeviceComponent(entry) 
                return nil unless entry
                model = FHIR::DeviceObservationReport::DeviceObservationReportVirtualDeviceComponent.new
                self.parse_element_data(model, entry)
                set_model_data(model, 'code', FHIR::CodeableConcept.parse_xml_entry(entry.at_xpath('./fhir:code')))
                set_model_data(model, 'channel', entry.xpath('./fhir:channel').map {|e| parse_xml_entry_DeviceObservationReportVirtualDeviceChannelComponent(e)})
                model
            end
            
            def parse_xml_entry(entry) 
                return nil unless entry
                model = self.new
                self.parse_element_data(model, entry)
                self.parse_resource_data(model, entry)
                set_model_data(model, 'instant', parse_date_time(entry.at_xpath('./fhir:instant/@value').try(:value)))
                set_model_data(model, 'identifier', FHIR::Identifier.parse_xml_entry(entry.at_xpath('./fhir:identifier')))
                set_model_data(model, 'source', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:source')))
                set_model_data(model, 'subject', FHIR::ResourceReference.parse_xml_entry(entry.at_xpath('./fhir:subject')))
                set_model_data(model, 'virtualDevice', entry.xpath('./fhir:virtualDevice').map {|e| parse_xml_entry_DeviceObservationReportVirtualDeviceComponent(e)})
                model
            end
        end
    end
end
