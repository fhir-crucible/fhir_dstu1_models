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
    class DocumentReference 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::DocumentReference
        
        SEARCH_PARAMS = [
            'location',
            'indexed',
            'status',
            'relatesto',
            'subject',
            'relation',
            'class',
            'format',
            'period',
            'type',
            'authenticator',
            'size',
            'relationship',
            'author',
            'custodian',
            'facility',
            '_id',
            'created',
            'event',
            'confidentiality',
            'description',
            '_language',
            'language',
            'identifier'
            ]
        
        VALID_CODES = {
            status: [ "current", "superceded", "entered in error" ]
        }
        
        # This is an ugly hack to deal with embedded structures in the spec relatesTo
        class DocumentReferenceRelatesToComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                code: [ "replaces", "transforms", "signs", "appends" ]
            }
            
            field :code, type: String
            validates :code, :inclusion => { in: VALID_CODES[:code] }
            validates_presence_of :code
            embeds_one :target, class_name:'FHIR::ResourceReference'
            validates_presence_of :target
        end
        
        # This is an ugly hack to deal with embedded structures in the spec parameter
        class DocumentReferenceServiceParameterComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            field :name, type: String
            validates_presence_of :name
            field :value, type: String
        end
        
        # This is an ugly hack to deal with embedded structures in the spec service
        class DocumentReferenceServiceComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            embeds_one :fhirType, class_name:'FHIR::CodeableConcept'
            validates_presence_of :fhirType
            field :address, type: String
            embeds_many :parameter, class_name:'FHIR::DocumentReference::DocumentReferenceServiceParameterComponent'
        end
        
        # This is an ugly hack to deal with embedded structures in the spec context
        class DocumentReferenceContextComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            embeds_many :event, class_name:'FHIR::CodeableConcept'
            embeds_one :period, class_name:'FHIR::Period'
            embeds_one :facilityType, class_name:'FHIR::CodeableConcept'
        end
        
        embeds_one :masterIdentifier, class_name:'FHIR::Identifier'
        validates_presence_of :masterIdentifier
        embeds_many :identifier, class_name:'FHIR::Identifier'
        embeds_one :subject, class_name:'FHIR::ResourceReference'
        validates_presence_of :subject
        embeds_one :fhirType, class_name:'FHIR::CodeableConcept'
        validates_presence_of :fhirType
        embeds_one :fhirClass, class_name:'FHIR::CodeableConcept'
        embeds_many :author, class_name:'FHIR::ResourceReference'
        validates_presence_of :author
        embeds_one :custodian, class_name:'FHIR::ResourceReference'
        field :policyManager, type: String
        embeds_one :authenticator, class_name:'FHIR::ResourceReference'
        field :created, type: FHIR::PartialDateTime
        field :indexed, type: DateTime
        validates_presence_of :indexed
        field :status, type: String
        validates :status, :inclusion => { in: VALID_CODES[:status] }
        validates_presence_of :status
        embeds_one :docStatus, class_name:'FHIR::CodeableConcept'
        embeds_many :relatesTo, class_name:'FHIR::DocumentReference::DocumentReferenceRelatesToComponent'
        field :description, type: String
        embeds_many :confidentiality, class_name:'FHIR::CodeableConcept'
        field :primaryLanguage, type: String
        field :mimeType, type: String
        validates_presence_of :mimeType
        field :format, type: Array # Array of Strings
        field :size, type: Integer
        field :fhirHash, type: String
        field :location, type: String
        embeds_one :service, class_name:'FHIR::DocumentReference::DocumentReferenceServiceComponent'
        embeds_one :context, class_name:'FHIR::DocumentReference::DocumentReferenceContextComponent'
        track_history
    end
end
