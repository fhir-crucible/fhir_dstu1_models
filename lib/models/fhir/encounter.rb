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
    class Encounter 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::Encounter
        
        SEARCH_PARAMS = [
            '_id',
            'location',
            'status',
            'subject',
            'indication',
            'length',
            '_language',
            'date',
            'identifier',
            'location-period'
            ]
        
        VALID_CODES = {
            status: [ "planned", "in progress", "onleave", "finished", "cancelled" ],
            fhirClass: [ "inpatient", "outpatient", "ambulatory", "emergency", "home", "field", "daytime", "virtual" ]
        }
        
        # This is an ugly hack to deal with embedded structures in the spec participant
        class EncounterParticipantComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            embeds_many :fhirType, class_name:'FHIR::CodeableConcept'
            embeds_one :individual, class_name:'FHIR::ResourceReference'
        end
        
        # This is an ugly hack to deal with embedded structures in the spec accomodation
        class EncounterHospitalizationAccomodationComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            embeds_one :bed, class_name:'FHIR::ResourceReference'
            embeds_one :period, class_name:'FHIR::Period'
        end
        
        # This is an ugly hack to deal with embedded structures in the spec hospitalization
        class EncounterHospitalizationComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            embeds_one :preAdmissionIdentifier, class_name:'FHIR::Identifier'
            embeds_one :origin, class_name:'FHIR::ResourceReference'
            embeds_one :admitSource, class_name:'FHIR::CodeableConcept'
            embeds_one :period, class_name:'FHIR::Period'
            embeds_many :accomodation, class_name:'FHIR::Encounter::EncounterHospitalizationAccomodationComponent'
            embeds_one :diet, class_name:'FHIR::CodeableConcept'
            embeds_many :specialCourtesy, class_name:'FHIR::CodeableConcept'
            embeds_many :specialArrangement, class_name:'FHIR::CodeableConcept'
            embeds_one :destination, class_name:'FHIR::ResourceReference'
            embeds_one :dischargeDisposition, class_name:'FHIR::CodeableConcept'
            embeds_one :dischargeDiagnosis, class_name:'FHIR::ResourceReference'
            field :reAdmission, type: Boolean
        end
        
        # This is an ugly hack to deal with embedded structures in the spec location
        class EncounterLocationComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            embeds_one :location, class_name:'FHIR::ResourceReference'
            validates_presence_of :location
            embeds_one :period, class_name:'FHIR::Period'
            validates_presence_of :period
        end
        
        embeds_many :identifier, class_name:'FHIR::Identifier'
        field :status, type: String
        validates :status, :inclusion => { in: VALID_CODES[:status] }
        validates_presence_of :status
        field :fhirClass, type: String
        validates :fhirClass, :inclusion => { in: VALID_CODES[:fhirClass] }
        validates_presence_of :fhirClass
        embeds_many :fhirType, class_name:'FHIR::CodeableConcept'
        embeds_one :subject, class_name:'FHIR::ResourceReference'
        embeds_many :participant, class_name:'FHIR::Encounter::EncounterParticipantComponent'
        embeds_one :period, class_name:'FHIR::Period'
        embeds_one :length, class_name:'FHIR::Quantity'
        embeds_one :reason, class_name:'FHIR::CodeableConcept'
        embeds_one :indication, class_name:'FHIR::ResourceReference'
        embeds_one :priority, class_name:'FHIR::CodeableConcept'
        embeds_one :hospitalization, class_name:'FHIR::Encounter::EncounterHospitalizationComponent'
        embeds_many :location, class_name:'FHIR::Encounter::EncounterLocationComponent'
        embeds_one :serviceProvider, class_name:'FHIR::ResourceReference'
        embeds_one :partOf, class_name:'FHIR::ResourceReference'
        track_history
    end
end
