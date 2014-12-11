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
    class ConceptMap 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::ConceptMap
        
        SEARCH_PARAMS = [
            'dependson',
            'status',
            'date',
            'version',
            'publisher',
            'product',
            'system',
            '_id',
            'source',
            'description',
            'name',
            'target',
            '_language',
            'identifier'
            ]
        
        VALID_CODES = {
            status: [ "draft", "active", "retired" ]
        }
        
        # This is an ugly hack to deal with embedded structures in the spec dependsOn
        class OtherConceptComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            field :concept, type: String
            validates_presence_of :concept
            field :system, type: String
            validates_presence_of :system
            field :code, type: String
            validates_presence_of :code
        end
        
        # This is an ugly hack to deal with embedded structures in the spec map
        class ConceptMapConceptMapComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                equivalence: [ "equal", "equivalent", "wider", "subsumes", "narrower", "specialises", "inexact", "unmatched", "disjoint" ]
            }
            
            field :system, type: String
            field :code, type: String
            field :equivalence, type: String
            validates :equivalence, :inclusion => { in: VALID_CODES[:equivalence] }
            validates_presence_of :equivalence
            field :comments, type: String
            embeds_many :product, class_name:'FHIR::ConceptMap::OtherConceptComponent'
        end
        
        # This is an ugly hack to deal with embedded structures in the spec concept
        class ConceptMapConceptComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            field :system, type: String
            validates_presence_of :system
            field :code, type: String
            embeds_many :dependsOn, class_name:'FHIR::ConceptMap::OtherConceptComponent'
            embeds_many :map, class_name:'FHIR::ConceptMap::ConceptMapConceptMapComponent'
        end
        
        field :identifier, type: String
        field :versionNum, type: String
        field :name, type: String
        validates_presence_of :name
        field :publisher, type: String
        embeds_many :telecom, class_name:'FHIR::Contact'
        field :description, type: String
        field :copyright, type: String
        field :status, type: String
        validates :status, :inclusion => { in: VALID_CODES[:status] }
        validates_presence_of :status
        field :experimental, type: Boolean
        field :date, type: FHIR::PartialDateTime
        embeds_one :source, class_name:'FHIR::ResourceReference'
        validates_presence_of :source
        embeds_one :target, class_name:'FHIR::ResourceReference'
        validates_presence_of :target
        embeds_many :concept, class_name:'FHIR::ConceptMap::ConceptMapConceptComponent'
        track_history
    end
end
