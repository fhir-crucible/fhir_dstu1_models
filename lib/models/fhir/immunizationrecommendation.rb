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
    class ImmunizationRecommendation 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::ImmunizationRecommendation
        
        SEARCH_PARAMS = [
            'information',
            'dose-sequence',
            'support',
            'vaccine-type',
            '_id',
            'status',
            'dose-number',
            'subject',
            '_language',
            'date',
            'identifier'
            ]
        # This is an ugly hack to deal with embedded structures in the spec dateCriterion
        class ImmunizationRecommendationRecommendationDateCriterionComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            embeds_one :code, class_name:'FHIR::CodeableConcept'
            validates_presence_of :code
            field :value, type: FHIR::PartialDateTime
            validates_presence_of :value
        end
        
        # This is an ugly hack to deal with embedded structures in the spec protocol
        class ImmunizationRecommendationRecommendationProtocolComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            field :doseSequence, type: Integer
            field :description, type: String
            embeds_one :authority, class_name:'FHIR::ResourceReference'
            field :series, type: String
        end
        
        # This is an ugly hack to deal with embedded structures in the spec recommendation
        class ImmunizationRecommendationRecommendationComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            field :date, type: FHIR::PartialDateTime
            validates_presence_of :date
            embeds_one :vaccineType, class_name:'FHIR::CodeableConcept'
            validates_presence_of :vaccineType
            field :doseNumber, type: Integer
            embeds_one :forecastStatus, class_name:'FHIR::CodeableConcept'
            validates_presence_of :forecastStatus
            embeds_many :dateCriterion, class_name:'FHIR::ImmunizationRecommendation::ImmunizationRecommendationRecommendationDateCriterionComponent'
            embeds_one :protocol, class_name:'FHIR::ImmunizationRecommendation::ImmunizationRecommendationRecommendationProtocolComponent'
            embeds_many :supportingImmunization, class_name:'FHIR::ResourceReference'
            embeds_many :supportingPatientInformation, class_name:'FHIR::ResourceReference'
        end
        
        embeds_many :identifier, class_name:'FHIR::Identifier'
        embeds_one :subject, class_name:'FHIR::ResourceReference'
        validates_presence_of :subject
        embeds_many :recommendation, class_name:'FHIR::ImmunizationRecommendation::ImmunizationRecommendationRecommendationComponent'
        validates_presence_of :recommendation
        track_history
    end
end
