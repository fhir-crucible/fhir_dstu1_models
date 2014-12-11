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
    class Query 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::Query
        
        SEARCH_PARAMS = [
            'response',
            '_id',
            '_language',
            'identifier'
            ]
        # This is an ugly hack to deal with embedded structures in the spec response
        class QueryResponseComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                outcome: [ "ok", "limited", "refused", "error" ]
            }
            
            field :identifier, type: String
            validates_presence_of :identifier
            field :outcome, type: String
            validates :outcome, :inclusion => { in: VALID_CODES[:outcome] }
            validates_presence_of :outcome
            field :total, type: Integer
            embeds_many :parameter, class_name:'FHIR::Extension'
            embeds_many :first, class_name:'FHIR::Extension'
            embeds_many :previous, class_name:'FHIR::Extension'
            embeds_many :next, class_name:'FHIR::Extension'
            embeds_many :last, class_name:'FHIR::Extension'
            embeds_many :reference, class_name:'FHIR::ResourceReference'
        end
        
        field :identifier, type: String
        validates_presence_of :identifier
        embeds_many :parameter, class_name:'FHIR::Extension'
        validates_presence_of :parameter
        embeds_one :response, class_name:'FHIR::Query::QueryResponseComponent'
        track_history
    end
end