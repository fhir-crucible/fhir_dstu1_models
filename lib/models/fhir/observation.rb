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
    class Observation 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::Observation
        
        SEARCH_PARAMS = [
            'value-string',
            'status',
            'subject',
            'value-concept',
            'reliability',
            'date',
            'name-value-[x]',
            'related-target',
            'related',
            '_id',
            'specimen',
            'name',
            'related-type',
            'performer',
            '_language',
            'value-quantity',
            'value-date'
            ]
        
        VALID_CODES = {
            status: [ "registered", "preliminary", "final", "amended", "cancelled", "entered in error" ],
            reliability: [ "ok", "ongoing", "early", "questionable", "calibrating", "error", "unknown" ]
        }
        
        # This is an ugly hack to deal with embedded structures in the spec referenceRange
        class ObservationReferenceRangeComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            embeds_one :low, class_name:'FHIR::Quantity'
            embeds_one :high, class_name:'FHIR::Quantity'
            embeds_one :meaning, class_name:'FHIR::CodeableConcept'
            embeds_one :age, class_name:'FHIR::Range'
        end
        
        # This is an ugly hack to deal with embedded structures in the spec related
        class ObservationRelatedComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                fhirType: [ "has-component", "has-member", "derived-from", "sequel-to", "replaces", "qualified-by", "interfered-by" ]
            }
            
            field :fhirType, type: String
            validates :fhirType, :inclusion => { in: VALID_CODES[:fhirType], :allow_nil => true }
            embeds_one :target, class_name:'FHIR::ResourceReference'
            validates_presence_of :target
        end
        
        embeds_one :name, class_name:'FHIR::CodeableConcept'
        validates_presence_of :name
        embeds_one :valueQuantity, class_name:'FHIR::Quantity'
        embeds_one :valueCodeableConcept, class_name:'FHIR::CodeableConcept'
        embeds_one :valueAttachment, class_name:'FHIR::Attachment'
        embeds_one :valueRatio, class_name:'FHIR::Ratio'
        embeds_one :valuePeriod, class_name:'FHIR::Period'
        embeds_one :valueSampledData, class_name:'FHIR::SampledData'
        field :valueString, type: String
        embeds_one :interpretation, class_name:'FHIR::CodeableConcept'
        field :comments, type: String
        field :appliesDateTime, type: FHIR::PartialDateTime
        embeds_one :appliesPeriod, class_name:'FHIR::Period'
        field :issued, type: DateTime
        field :status, type: String
        validates :status, :inclusion => { in: VALID_CODES[:status] }
        validates_presence_of :status
        field :reliability, type: String
        validates :reliability, :inclusion => { in: VALID_CODES[:reliability] }
        validates_presence_of :reliability
        embeds_one :bodySite, class_name:'FHIR::CodeableConcept'
        embeds_one :method, class_name:'FHIR::CodeableConcept'
        embeds_one :identifier, class_name:'FHIR::Identifier'
        embeds_one :subject, class_name:'FHIR::ResourceReference'
        embeds_one :specimen, class_name:'FHIR::ResourceReference'
        embeds_many :performer, class_name:'FHIR::ResourceReference'
        embeds_many :referenceRange, class_name:'FHIR::Observation::ObservationReferenceRangeComponent'
        embeds_many :related, class_name:'FHIR::Observation::ObservationRelatedComponent'
        track_history
    end
end
