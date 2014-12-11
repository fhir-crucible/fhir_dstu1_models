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
    class Media 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::Media
        
        SEARCH_PARAMS = [
            '_id',
            'subject',
            'subtype',
            '_language',
            'view',
            'date',
            'type',
            'identifier',
            'operator'
            ]
        
        VALID_CODES = {
            fhirType: [ "photo", "video", "audio" ]
        }
        
        field :fhirType, type: String
        validates :fhirType, :inclusion => { in: VALID_CODES[:fhirType] }
        validates_presence_of :fhirType
        embeds_one :subtype, class_name:'FHIR::CodeableConcept'
        embeds_many :identifier, class_name:'FHIR::Identifier'
        field :dateTime, type: FHIR::PartialDateTime
        embeds_one :subject, class_name:'FHIR::ResourceReference'
        embeds_one :operator, class_name:'FHIR::ResourceReference'
        embeds_one :view, class_name:'FHIR::CodeableConcept'
        field :deviceName, type: String
        field :height, type: Integer
        field :width, type: Integer
        field :frames, type: Integer
        field :length, type: Integer
        embeds_one :content, class_name:'FHIR::Attachment'
        validates_presence_of :content
        track_history
    end
end
