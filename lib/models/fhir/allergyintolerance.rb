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
    class AllergyIntolerance 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::AllergyIntolerance
        
        SEARCH_PARAMS = [
            'substance',
            '_id',
            'status',
            'recorder',
            'subject',
            '_language',
            'date',
            'type'
            ]
        
        VALID_CODES = {
            criticality: [ "fatal", "high", "medium", "low" ],
            status: [ "suspected", "confirmed", "refuted", "resolved" ],
            sensitivityType: [ "allergy", "intolerance", "unknown" ]
        }
        
        embeds_many :identifier, class_name:'FHIR::Identifier'
        field :criticality, type: String
        validates :criticality, :inclusion => { in: VALID_CODES[:criticality], :allow_nil => true }
        field :sensitivityType, type: String
        validates :sensitivityType, :inclusion => { in: VALID_CODES[:sensitivityType] }
        validates_presence_of :sensitivityType
        field :recordedDate, type: FHIR::PartialDateTime
        field :status, type: String
        validates :status, :inclusion => { in: VALID_CODES[:status] }
        validates_presence_of :status
        embeds_one :subject, class_name:'FHIR::ResourceReference'
        validates_presence_of :subject
        embeds_one :recorder, class_name:'FHIR::ResourceReference'
        embeds_one :substance, class_name:'FHIR::ResourceReference'
        validates_presence_of :substance
        embeds_many :reaction, class_name:'FHIR::ResourceReference'
        embeds_many :sensitivityTest, class_name:'FHIR::ResourceReference'
        track_history
    end
end
