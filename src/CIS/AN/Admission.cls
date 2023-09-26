/// 患者就诊表
Class CIS.AN.Admission Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Admission ]
{

/// 就诊号
Property EpisodeID As %String [ SqlColumnNumber = 2 ];

/// 患者
Property Patient As CIS.AN.Patient [ Required, SqlColumnNumber = 3 ];

/// 病案号
Property MedcareNo As %String [ SqlColumnNumber = 4 ];

/// 就诊类型
Property Type As %String(DISPLAYLIST = ",In Patient,Out Patient,Emergency,New Born,Health Promotion", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",I,O,E,N,H") [ SqlColumnNumber = 5 ];

/// 就诊日期
Property AdmDate As %Date [ SqlColumnNumber = 6 ];

/// 就诊时间
Property AdmTime As %Time [ SqlColumnNumber = 7 ];

/// 就诊科室
Property Department As %String [ SqlColumnNumber = 8 ];

/// 就诊病区
Property Ward As %String [ SqlColumnNumber = 9 ];

/// 就诊床位
Property Bed As %String [ SqlColumnNumber = 10 ];

/// 在院状态
Property VisitStatus As %String(DISPLAYLIST = ",Admit,Cancel,Discharged,Pre-Admission,Released,DNA", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",A,C,D,P,R,N") [ SqlColumnNumber = 11 ];

/// 就诊原因
Property AdmReason As %String [ SqlColumnNumber = 12 ];

/// 出院日期
Property DischargeDate As %Date [ SqlColumnNumber = 13 ];

/// 出院时间
Property DischargeTime As %Time [ SqlColumnNumber = 14 ];

/// 就诊号索引
Index IAdm On EpisodeID;

/// 病案号索引
Index IMedcare On MedcareNo;

Storage Default
{
<Data name="AdmissionDefaultData">
<Value name="1">
<Value>EpisodeID</Value>
</Value>
<Value name="2">
<Value>Patient</Value>
</Value>
<Value name="3">
<Value>MedcareNo</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>AdmDate</Value>
</Value>
<Value name="6">
<Value>AdmTime</Value>
</Value>
<Value name="7">
<Value>Department</Value>
</Value>
<Value name="8">
<Value>Ward</Value>
</Value>
<Value name="9">
<Value>Bed</Value>
</Value>
<Value name="10">
<Value>VisitStatus</Value>
</Value>
<Value name="11">
<Value>AdmReason</Value>
</Value>
<Value name="12">
<Value>DischargeDate</Value>
</Value>
<Value name="13">
<Value>DischargeTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.AdmissionD</DataLocation>
<DefaultData>AdmissionDefaultData</DefaultData>
<IdLocation>^CIS.AN.AdmissionD</IdLocation>
<IndexLocation>^CIS.AN.AdmissionI</IndexLocation>
<StreamLocation>^CIS.AN.AdmissionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
