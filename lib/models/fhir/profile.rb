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
    class Profile 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::Profile
        
        SEARCH_PARAMS = [
            'status',
            'code',
            'type',
            'date',
            'version',
            'publisher',
            'extension',
            '_id',
            'valueset',
            'description',
            'name',
            '_language',
            'identifier'
            ]
        
        VALID_CODES = {
            status: [ "draft", "active", "retired" ]
        }
        
        # This is an ugly hack to deal with embedded structures in the spec mapping
        class ProfileMappingComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            field :identity, type: String
            validates_presence_of :identity
            field :uri, type: String
            field :name, type: String
            field :comments, type: String
        end
        
        # This is an ugly hack to deal with embedded structures in the spec slicing
        class ElementSlicingComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                rules: [ "closed", "open", "openAtEnd" ]
            }
            
            field :discriminator, type: String
            validates_presence_of :discriminator
            field :ordered, type: Boolean
            validates_presence_of :ordered
            field :rules, type: String
            validates :rules, :inclusion => { in: VALID_CODES[:rules] }
            validates_presence_of :rules
        end
        
        # This is an ugly hack to deal with embedded structures in the spec fhirType
        class TypeRefComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                aggregation: [ "contained", "referenced", "bundled" ],
                code: [ "Address", "Age", "Attachment", "CodeableConcept", "Coding", "Contact", "Count", "Distance", "Duration", "Extension", "HumanName", "Identifier", "Money", "Narrative", "Period", "Quantity", "Range", "Ratio", "ResourceReference", "SampledData", "Schedule", "base64Binary", "boolean", "code", "date", "dateTime", "decimal", "id", "instant", "integer", "oid", "string", "uri", "uuid" ]
            }
            
            field :code, type: String
            validates :code, :inclusion => { in: VALID_CODES[:code] }
            validates_presence_of :code
            field :profile, type: String
            field :aggregation, type: Array # Array of Strings
            validates :aggregation, :inclusion => { in: VALID_CODES[:aggregation], :allow_nil => true }
        end
        
        # This is an ugly hack to deal with embedded structures in the spec constraint
        class ElementDefinitionConstraintComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                severity: [ "error", "warning" ]
            }
            
            field :key, type: String
            validates_presence_of :key
            field :name, type: String
            field :severity, type: String
            validates :severity, :inclusion => { in: VALID_CODES[:severity] }
            validates_presence_of :severity
            field :human, type: String
            validates_presence_of :human
            field :xpath, type: String
            validates_presence_of :xpath
        end
        
        # This is an ugly hack to deal with embedded structures in the spec binding
        class ElementDefinitionBindingComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                conformance: [ "required", "preferred", "example" ]
            }
            
            field :name, type: String
            validates_presence_of :name
            field :isExtensible, type: Boolean
            validates_presence_of :isExtensible
            field :conformance, type: String
            validates :conformance, :inclusion => { in: VALID_CODES[:conformance], :allow_nil => true }
            field :description, type: String
            field :referenceUri, type: String
            embeds_one :referenceResource, class_name:'FHIR::ResourceReference'
        end
        
        # This is an ugly hack to deal with embedded structures in the spec mapping
        class ElementDefinitionMappingComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            field :identity, type: String
            validates_presence_of :identity
            field :map, type: String
            validates_presence_of :map
        end
        
        # This is an ugly hack to deal with embedded structures in the spec definition
        class ElementDefinitionComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            field :short, type: String
            validates_presence_of :short
            field :formal, type: String
            validates_presence_of :formal
            field :comments, type: String
            field :requirements, type: String
            field :synonym, type: Array # Array of Strings
            field :min, type: Integer
            validates_presence_of :min
            field :max, type: String
            validates_presence_of :max
            embeds_many :fhirType, class_name:'FHIR::Profile::TypeRefComponent'
            field :nameReference, type: String
            field :valueType, type: String
            field :value, type: FHIR::AnyType
            field :exampleType, type: String
            field :example, type: FHIR::AnyType
            field :maxLength, type: Integer
            field :condition, type: Array # Array of Strings
            embeds_many :constraint, class_name:'FHIR::Profile::ElementDefinitionConstraintComponent'
            field :mustSupport, type: Boolean
            field :isModifier, type: Boolean
            validates_presence_of :isModifier
            embeds_one :binding, class_name:'FHIR::Profile::ElementDefinitionBindingComponent'
            embeds_many :mapping, class_name:'FHIR::Profile::ElementDefinitionMappingComponent'
        end
        
        # This is an ugly hack to deal with embedded structures in the spec element
        class ElementComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                representation: [ "xmlAttr" ]
            }
            
            field :path, type: String
            validates_presence_of :path
            field :representation, type: Array # Array of Strings
            validates :representation, :inclusion => { in: VALID_CODES[:representation], :allow_nil => true }
            field :name, type: String
            embeds_one :slicing, class_name:'FHIR::Profile::ElementSlicingComponent'
            embeds_one :definition, class_name:'FHIR::Profile::ElementDefinitionComponent'
        end
        
        # This is an ugly hack to deal with embedded structures in the spec searchParam
        class ProfileStructureSearchParamComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                target: [ "AdverseReaction", "Alert", "AllergyIntolerance", "CarePlan", "Composition", "ConceptMap", "Condition", "Conformance", "Device", "DeviceObservationReport", "DiagnosticOrder", "DiagnosticReport", "DocumentManifest", "DocumentReference", "Encounter", "FamilyHistory", "Group", "ImagingStudy", "Immunization", "ImmunizationRecommendation", "List", "Location", "Media", "Medication", "MedicationAdministration", "MedicationDispense", "MedicationPrescription", "MedicationStatement", "MessageHeader", "Observation", "OperationOutcome", "Order", "OrderResponse", "Organization", "Other", "Patient", "Practitioner", "Procedure", "Profile", "Provenance", "Query", "Questionnaire", "RelatedPerson", "SecurityEvent", "Specimen", "Substance", "Supply", "ValueSet" ],
                fhirType: [ "number", "date", "string", "token", "reference", "composite", "quantity" ]
            }
            
            field :name, type: String
            validates_presence_of :name
            field :fhirType, type: String
            validates :fhirType, :inclusion => { in: VALID_CODES[:fhirType] }
            validates_presence_of :fhirType
            field :documentation, type: String
            validates_presence_of :documentation
            field :xpath, type: String
            field :target, type: Array # Array of Strings
            validates :target, :inclusion => { in: VALID_CODES[:target], :allow_nil => true }
        end
        
        # This is an ugly hack to deal with embedded structures in the spec structure
        class ProfileStructureComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                fhirType: [ "Address", "Age", "Attachment", "CodeableConcept", "Coding", "Contact", "Count", "Distance", "Duration", "Extension", "HumanName", "Identifier", "Money", "Narrative", "Period", "Quantity", "Range", "Ratio", "ResourceReference", "SampledData", "Schedule", "base64Binary", "boolean", "code", "date", "dateTime", "decimal", "id", "instant", "integer", "oid", "string", "uri", "uuid", "AdverseReaction", "Alert", "AllergyIntolerance", "CarePlan", "Composition", "ConceptMap", "Condition", "Conformance", "Device", "DeviceObservationReport", "DiagnosticOrder", "DiagnosticReport", "DocumentManifest", "DocumentReference", "Encounter", "FamilyHistory", "Group", "ImagingStudy", "Immunization", "ImmunizationRecommendation", "List", "Location", "Media", "Medication", "MedicationAdministration", "MedicationDispense", "MedicationPrescription", "MedicationStatement", "MessageHeader", "Observation", "OperationOutcome", "Order", "OrderResponse", "Organization", "Other", "Patient", "Practitioner", "Procedure", "Profile", "Provenance", "Query", "Questionnaire", "RelatedPerson", "SecurityEvent", "Specimen", "Substance", "Supply", "ValueSet" ]
            }
            
            field :fhirType, type: String
            validates :fhirType, :inclusion => { in: VALID_CODES[:fhirType] }
            validates_presence_of :fhirType
            field :name, type: String
            field :publish, type: Boolean
            field :purpose, type: String
            embeds_many :element, class_name:'FHIR::Profile::ElementComponent'
            embeds_many :searchParam, class_name:'FHIR::Profile::ProfileStructureSearchParamComponent'
        end
        
        # This is an ugly hack to deal with embedded structures in the spec extensionDefn
        class ProfileExtensionDefnComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                contextType: [ "resource", "datatype", "mapping", "extension" ]
            }
            
            field :code, type: String
            validates_presence_of :code
            field :display, type: String
            field :contextType, type: String
            validates :contextType, :inclusion => { in: VALID_CODES[:contextType] }
            validates_presence_of :contextType
            field :context, type: Array # Array of Strings
            validates_presence_of :context
            embeds_one :definition, class_name:'FHIR::Profile::ElementDefinitionComponent'
            validates_presence_of :definition
        end
        
        # This is an ugly hack to deal with embedded structures in the spec query
        class ProfileQueryComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            field :name, type: String
            validates_presence_of :name
            field :documentation, type: String
            validates_presence_of :documentation
            embeds_many :parameter, class_name:'FHIR::Profile::ProfileStructureSearchParamComponent'
        end
        
        field :identifier, type: String
        field :versionNum, type: String
        field :name, type: String
        validates_presence_of :name
        field :publisher, type: String
        embeds_many :telecom, class_name:'FHIR::Contact'
        field :description, type: String
        embeds_many :code, class_name:'FHIR::Coding'
        field :status, type: String
        validates :status, :inclusion => { in: VALID_CODES[:status] }
        validates_presence_of :status
        field :experimental, type: Boolean
        field :date, type: FHIR::PartialDateTime
        field :requirements, type: String
        field :fhirVersion, type: String
        embeds_many :mapping, class_name:'FHIR::Profile::ProfileMappingComponent'
        embeds_many :structure, class_name:'FHIR::Profile::ProfileStructureComponent'
        embeds_many :extensionDefn, class_name:'FHIR::Profile::ProfileExtensionDefnComponent'
        embeds_many :query, class_name:'FHIR::Profile::ProfileQueryComponent'
        track_history
    end
end
