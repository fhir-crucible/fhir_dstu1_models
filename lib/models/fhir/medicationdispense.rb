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
    class MedicationDispense 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::MedicationDispense
        
        SEARCH_PARAMS = [
            'medication',
            'prescription',
            'status',
            'type',
            'destination',
            'patient',
            '_id',
            'responsibleparty',
            'dispenser',
            '_language',
            'identifier',
            'whenprepared',
            'whenhandedover'
            ]
        
        VALID_CODES = {
            status: [ "in progress", "on hold", "completed", "entered in error", "stopped" ]
        }
        
        # This is an ugly hack to deal with embedded structures in the spec dosage
        class MedicationDispenseDispenseDosageComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            embeds_one :additionalInstructions, class_name:'FHIR::CodeableConcept'
            field :timingDateTime, type: FHIR::PartialDateTime
            embeds_one :timingPeriod, class_name:'FHIR::Period'
            embeds_one :timingSchedule, class_name:'FHIR::Schedule'
            field :asNeededBoolean, type: Boolean
            embeds_one :asNeededCodeableConcept, class_name:'FHIR::CodeableConcept'
            embeds_one :site, class_name:'FHIR::CodeableConcept'
            embeds_one :route, class_name:'FHIR::CodeableConcept'
            embeds_one :method, class_name:'FHIR::CodeableConcept'
            embeds_one :quantity, class_name:'FHIR::Quantity'
            embeds_one :rate, class_name:'FHIR::Ratio'
            embeds_one :maxDosePerPeriod, class_name:'FHIR::Ratio'
        end
        
        # This is an ugly hack to deal with embedded structures in the spec dispense
        class MedicationDispenseDispenseComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                status: [ "in progress", "on hold", "completed", "entered in error", "stopped" ]
            }
            
            embeds_one :identifier, class_name:'FHIR::Identifier'
            field :status, type: String
            validates :status, :inclusion => { in: VALID_CODES[:status], :allow_nil => true }
            embeds_one :fhirType, class_name:'FHIR::CodeableConcept'
            embeds_one :quantity, class_name:'FHIR::Quantity'
            embeds_one :medication, class_name:'FHIR::ResourceReference'
            field :whenPrepared, type: FHIR::PartialDateTime
            field :whenHandedOver, type: FHIR::PartialDateTime
            embeds_one :destination, class_name:'FHIR::ResourceReference'
            embeds_many :receiver, class_name:'FHIR::ResourceReference'
            embeds_many :dosage, class_name:'FHIR::MedicationDispense::MedicationDispenseDispenseDosageComponent'
        end
        
        # This is an ugly hack to deal with embedded structures in the spec substitution
        class MedicationDispenseSubstitutionComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            embeds_one :fhirType, class_name:'FHIR::CodeableConcept'
            validates_presence_of :fhirType
            embeds_many :reason, class_name:'FHIR::CodeableConcept'
            embeds_many :responsibleParty, class_name:'FHIR::ResourceReference'
        end
        
        embeds_one :identifier, class_name:'FHIR::Identifier'
        field :status, type: String
        validates :status, :inclusion => { in: VALID_CODES[:status], :allow_nil => true }
        embeds_one :patient, class_name:'FHIR::ResourceReference'
        embeds_one :dispenser, class_name:'FHIR::ResourceReference'
        embeds_many :authorizingPrescription, class_name:'FHIR::ResourceReference'
        embeds_many :dispense, class_name:'FHIR::MedicationDispense::MedicationDispenseDispenseComponent'
        embeds_one :substitution, class_name:'FHIR::MedicationDispense::MedicationDispenseSubstitutionComponent'
        track_history
    end
end
