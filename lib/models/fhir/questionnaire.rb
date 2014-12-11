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
    class Questionnaire 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::Questionnaire
        
        SEARCH_PARAMS = [
            'author',
            'authored',
            '_id',
            'status',
            'subject',
            'name',
            '_language',
            'encounter',
            'identifier'
            ]
        
        VALID_CODES = {
            status: [ "draft", "published", "retired", "in progress", "completed", "amended" ]
        }
        
        # This is an ugly hack to deal with embedded structures in the spec question
        class QuestionComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            embeds_one :name, class_name:'FHIR::CodeableConcept'
            field :text, type: String
            field :answerDecimal, type: Float
            field :answerInteger, type: Integer
            field :answerBoolean, type: Boolean
            field :answerDate, type: FHIR::PartialDateTime
            field :answerString, type: String
            field :answerDateTime, type: FHIR::PartialDateTime
            field :answerInstant, type: DateTime
            embeds_many :choice, class_name:'FHIR::Coding'
            embeds_one :options, class_name:'FHIR::ResourceReference'
            field :dataType, type: String
            field :data, type: FHIR::AnyType
            field :remarks, type: String
            embeds_many :group, class_name:'FHIR::Questionnaire::GroupComponent', cyclic: true
        end
        
        # This is an ugly hack to deal with embedded structures in the spec group
        class GroupComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            embeds_one :name, class_name:'FHIR::CodeableConcept'
            field :header, type: String
            field :text, type: String
            embeds_one :subject, class_name:'FHIR::ResourceReference'
            embeds_many :group, class_name:'FHIR::Questionnaire::GroupComponent', cyclic: true
            embeds_many :question, class_name:'FHIR::Questionnaire::QuestionComponent', cyclic: true
        end
        
        field :status, type: String
        validates :status, :inclusion => { in: VALID_CODES[:status] }
        validates_presence_of :status
        field :authored, type: FHIR::PartialDateTime
        validates_presence_of :authored
        embeds_one :subject, class_name:'FHIR::ResourceReference'
        embeds_one :author, class_name:'FHIR::ResourceReference'
        embeds_one :source, class_name:'FHIR::ResourceReference'
        embeds_one :name, class_name:'FHIR::CodeableConcept'
        embeds_many :identifier, class_name:'FHIR::Identifier'
        embeds_one :encounter, class_name:'FHIR::ResourceReference'
        embeds_one :group, class_name:'FHIR::Questionnaire::GroupComponent'
        track_history
    end
end
