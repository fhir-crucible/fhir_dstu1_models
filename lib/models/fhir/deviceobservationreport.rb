# Copyright (c) 2011-2014, HL7, Inc & The MITRE Corporation
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without modification, 
# are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice, this 
#       list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright notice, 
#       this list of conditions and the following disclaimer in the documentation 
#       and/or other materials provided with the distribution.
#     * Neither the name of HL7 nor the names of its contributors may be used to 
#       endorse or promote products derived from this software without specific 
#       prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.

module FHIR
    class DeviceObservationReport 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::DeviceObservationReport
        
        SEARCH_PARAMS = [
            'observation',
            'source',
            '_id',
            'subject',
            '_language',
            'code',
            'channel'
            ]
        # This is an ugly hack to deal with embedded structures in the spec metric
        class DeviceObservationReportVirtualDeviceChannelMetricComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            embeds_one :observation, class_name:'FHIR::ResourceReference'
            validates_presence_of :observation
        end
        
        # This is an ugly hack to deal with embedded structures in the spec channel
        class DeviceObservationReportVirtualDeviceChannelComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            embeds_one :code, class_name:'FHIR::CodeableConcept'
            embeds_many :metric, class_name:'FHIR::DeviceObservationReport::DeviceObservationReportVirtualDeviceChannelMetricComponent'
        end
        
        # This is an ugly hack to deal with embedded structures in the spec virtualDevice
        class DeviceObservationReportVirtualDeviceComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            embeds_one :code, class_name:'FHIR::CodeableConcept'
            embeds_many :channel, class_name:'FHIR::DeviceObservationReport::DeviceObservationReportVirtualDeviceChannelComponent'
        end
        
        field :instant, type: DateTime
        validates_presence_of :instant
        embeds_one :identifier, class_name:'FHIR::Identifier'
        embeds_one :source, class_name:'FHIR::ResourceReference'
        validates_presence_of :source
        embeds_one :subject, class_name:'FHIR::ResourceReference'
        embeds_many :virtualDevice, class_name:'FHIR::DeviceObservationReport::DeviceObservationReportVirtualDeviceComponent'
        track_history
    end
end
