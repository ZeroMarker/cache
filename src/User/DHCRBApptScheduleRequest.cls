Class User.DHCRBApptScheduleRequest Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCRBApptScheduleRequest ]
{

Property ASRRBASID As User.DHCRBApptSchedule [ SqlColumnNumber = 16, SqlFieldName = ASR_RBASID ];

/// S:停诊  R:替诊
Property ASRRequestType As %String [ SqlColumnNumber = 3, SqlFieldName = ASR_RequestType ];

/// N:新增  A:已审核  R:拒绝
Property ASRRequestResult As %String [ SqlColumnNumber = 4, SqlFieldName = ASR_RequestResult ];

Property ASRDoctorDR As CTCareProv [ SqlColumnNumber = 5, SqlFieldName = ASR_DoctorDR ];

Property ASRLocDR As CTLoc [ SqlColumnNumber = 6, SqlFieldName = ASR_LocDR ];

Property ASRReasonDR As RBCReasonNotAvail [ SqlColumnNumber = 7, SqlFieldName = ASR_ReasonDR ];

Property ASRSessionTypeDR As User.RBCSessionType [ SqlColumnNumber = 8, SqlFieldName = ASR_SessionTypeDR ];

Property ASRRequestUserDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = ASR_RequestUserDR ];

Property ASRRequestDate As %Library.Date [ SqlColumnNumber = 10, SqlFieldName = ASR_RequestDate ];

Property ASRRequestTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = ASR_RequestTime ];

Property ASRRequestAuditUserDR As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = ASR_RequestAuditUserDR ];

Property ASRRequestAuditDate As %Library.Date [ SqlColumnNumber = 13, SqlFieldName = ASR_RequestAuditDate ];

Property ASRRequestAuditTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = ASR_RequestAuditTime ];

Property ASRRBASDR As User.RBApptSchedule [ SqlColumnNumber = 15, SqlFieldName = ASR_RBASDR ];

Property ASRRequestRefuseReasonDr As User.DHCRBApptScheduleAudiReason [ SqlColumnNumber = 17, SqlFieldName = ASR_RequestRefuseReason_Dr ];

// AuditUserID As %String

Index RBASIDIndex On ASRRBASID;

Index TypeResultIndex On (ASRRequestType, ASRRequestResult, ASRRequestDate);

Storage Default
{
<Data name="DHCRBApptScheduleRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ASRDoctorDR</Value>
</Value>
<Value name="3">
<Value>ASRLocDR</Value>
</Value>
<Value name="4">
<Value>ASRRBASDR</Value>
</Value>
<Value name="5">
<Value>ASRRBASID</Value>
</Value>
<Value name="6">
<Value>ASRReasonDR</Value>
</Value>
<Value name="7">
<Value>ASRRequestAuditDate</Value>
</Value>
<Value name="8">
<Value>ASRRequestAuditTime</Value>
</Value>
<Value name="9">
<Value>ASRRequestAuditUserDR</Value>
</Value>
<Value name="10">
<Value>ASRRequestDate</Value>
</Value>
<Value name="11">
<Value>ASRRequestResult</Value>
</Value>
<Value name="12">
<Value>ASRRequestTime</Value>
</Value>
<Value name="13">
<Value>ASRRequestType</Value>
</Value>
<Value name="14">
<Value>ASRRequestUserDR</Value>
</Value>
<Value name="15">
<Value>ASRSessionTypeDR</Value>
</Value>
<Value name="16">
<Value>ASRRequestRefuseReasonDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCRBApptScheduleRequestD</DataLocation>
<DefaultData>DHCRBApptScheduleRequestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCRBApptScheduleRequestD</IdLocation>
<IndexLocation>^User.DHCRBApptScheduleRequestI</IndexLocation>
<StreamLocation>^User.DHCRBApptScheduleRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
