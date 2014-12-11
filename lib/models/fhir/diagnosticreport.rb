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
    class DiagnosticReport 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::DiagnosticReport
        
        SEARCH_PARAMS = [
            'result',
            'status',
            'subject',
            'issued',
            'diagnosis',
            'image',
            'date',
            '_id',
            'request',
            'specimen',
            'name',
            'service',
            'performer',
            '_language',
            'identifier'
            ]
        
        VALID_CODES = {
            status: [ "registered", "partial", "final", "corrected", "amended", "appended", "cancelled", "entered in error" ]
        }
        
        # This is an ugly hack to deal with embedded structures in the spec image
        class DiagnosticReportImageComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            field :comment, type: String
            embeds_one :link, class_name:'FHIR::ResourceReference'
            validates_presence_of :link
        end
        
        embeds_one :name, class_name:'FHIR::CodeableConcept'
        validates_presence_of :name
        field :status, type: String
        validates :status, :inclusion => { in: VALID_CODES[:status] }
        validates_presence_of :status
        field :issued, type: FHIR::PartialDateTime
        validates_presence_of :issued
        embeds_one :subject, class_name:'FHIR::ResourceReference'
        validates_presence_of :subject
        embeds_one :performer, class_name:'FHIR::ResourceReference'
        validates_presence_of :performer
        embeds_one :identifier, class_name:'FHIR::Identifier'
        embeds_many :requestDetail, class_name:'FHIR::ResourceReference'
        embeds_one :serviceCategory, class_name:'FHIR::CodeableConcept'
        field :diagnosticDateTime, type: FHIR::PartialDateTime
        validates_presence_of :diagnosticDateTime
        embeds_one :diagnosticPeriod, class_name:'FHIR::Period'
        validates_presence_of :diagnosticPeriod
        embeds_many :specimen, class_name:'FHIR::ResourceReference'
        embeds_many :result, class_name:'FHIR::ResourceReference'
        embeds_many :imagingStudy, class_name:'FHIR::ResourceReference'
        embeds_many :image, class_name:'FHIR::DiagnosticReport::DiagnosticReportImageComponent'
        field :conclusion, type: String
        embeds_many :codedDiagnosis, class_name:'FHIR::CodeableConcept'
        embeds_many :presentedForm, class_name:'FHIR::Attachment'
        track_history
    end
end
