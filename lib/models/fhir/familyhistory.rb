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
    class FamilyHistory 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::FamilyHistory
        
        SEARCH_PARAMS = [
            '_id',
            'subject',
            '_language'
            ]
        # This is an ugly hack to deal with embedded structures in the spec condition
        class FamilyHistoryRelationConditionComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            embeds_one :fhirType, class_name:'FHIR::CodeableConcept'
            validates_presence_of :fhirType
            embeds_one :outcome, class_name:'FHIR::CodeableConcept'
            embeds_one :onsetAge, class_name:'FHIR::Quantity'
            embeds_one :onsetRange, class_name:'FHIR::Range'
            field :onsetString, type: String
            field :note, type: String
        end
        
        # This is an ugly hack to deal with embedded structures in the spec relation
        class FamilyHistoryRelationComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            field :name, type: String
            embeds_one :relationship, class_name:'FHIR::CodeableConcept'
            validates_presence_of :relationship
            embeds_one :bornPeriod, class_name:'FHIR::Period'
            field :bornDate, type: FHIR::PartialDateTime
            field :bornString, type: String
            field :deceasedBoolean, type: Boolean
            embeds_one :deceasedAge, class_name:'FHIR::Quantity'
            embeds_one :deceasedRange, class_name:'FHIR::Range'
            field :deceasedDate, type: FHIR::PartialDateTime
            field :deceasedString, type: String
            field :note, type: String
            embeds_many :condition, class_name:'FHIR::FamilyHistory::FamilyHistoryRelationConditionComponent'
        end
        
        embeds_many :identifier, class_name:'FHIR::Identifier'
        embeds_one :subject, class_name:'FHIR::ResourceReference'
        validates_presence_of :subject
        field :note, type: String
        embeds_many :relation, class_name:'FHIR::FamilyHistory::FamilyHistoryRelationComponent'
        track_history
    end
end
