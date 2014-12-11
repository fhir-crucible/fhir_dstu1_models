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
    class AdverseReaction 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::AdverseReaction
        
        SEARCH_PARAMS = [
            'substance',
            '_id',
            'subject',
            '_language',
            'date',
            'symptom'
            ]
        # This is an ugly hack to deal with embedded structures in the spec symptom
        class AdverseReactionSymptomComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                severity: [ "severe", "serious", "moderate", "minor" ]
            }
            
            embeds_one :code, class_name:'FHIR::CodeableConcept'
            validates_presence_of :code
            field :severity, type: String
            validates :severity, :inclusion => { in: VALID_CODES[:severity], :allow_nil => true }
        end
        
        # This is an ugly hack to deal with embedded structures in the spec exposure
        class AdverseReactionExposureComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                causalityExpectation: [ "likely", "unlikely", "confirmed", "unknown" ],
                fhirType: [ "drugadmin", "immuniz", "coincidental" ]
            }
            
            field :date, type: FHIR::PartialDateTime
            field :fhirType, type: String
            validates :fhirType, :inclusion => { in: VALID_CODES[:fhirType], :allow_nil => true }
            field :causalityExpectation, type: String
            validates :causalityExpectation, :inclusion => { in: VALID_CODES[:causalityExpectation], :allow_nil => true }
            embeds_one :substance, class_name:'FHIR::ResourceReference'
        end
        
        embeds_many :identifier, class_name:'FHIR::Identifier'
        field :date, type: FHIR::PartialDateTime
        embeds_one :subject, class_name:'FHIR::ResourceReference'
        validates_presence_of :subject
        field :didNotOccurFlag, type: Boolean
        validates_presence_of :didNotOccurFlag
        embeds_one :recorder, class_name:'FHIR::ResourceReference'
        embeds_many :symptom, class_name:'FHIR::AdverseReaction::AdverseReactionSymptomComponent'
        embeds_many :exposure, class_name:'FHIR::AdverseReaction::AdverseReactionExposureComponent'
        track_history
    end
end
