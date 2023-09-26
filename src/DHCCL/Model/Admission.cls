/// 就诊
Class DHCCL.Model.Admission Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Admission ]
{

/// Admission No
Property AdmNo As %String(COLLATION = "AlphaUp", MAXLEN = 99, TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 病人
Property Patient As DHCCL.Model.Patient [ SqlColumnNumber = 3 ];

/// 就诊科室
Property AdmDept As DHCCL.Config.Location [ SqlColumnNumber = 4 ];

/// 就诊分类
Property AdmCategory As %String [ SqlColumnNumber = 5 ];

/// 就诊日期
Property AdmDate As %Date [ SqlColumnNumber = 6 ];

/// 就诊时间
Property AdmTime As %Time [ SqlColumnNumber = 7 ];

/// 就诊类型
Property AdmType As %String(DISPLAYLIST = ",In Patient,Out Patient,Emergency,New Born,Health Promotion", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",I,O,E,N,H") [ SqlColumnNumber = 8 ];

/// 就诊医生
Property AdmDoctor As DHCCL.Config.CareProvider [ SqlColumnNumber = 9 ];

/// 出院日期
Property DischargeDate As %Date [ SqlColumnNumber = 10 ];

/// 出院时间
Property DischargeTime As %Time [ SqlColumnNumber = 11 ];

/// 出院医生
Property DischgDoctor As DHCCL.Config.CareProvider [ SqlColumnNumber = 12 ];

/// 在院状态
Property VisitStatus As %String(DISPLAYLIST = ",Admit,Cancel,Discharged,Pre-Admission,Released,DNA", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",A,C,D,P,R,N") [ SqlColumnNumber = 13 ];

/// 所在病区
Property CurrentWard As %String [ SqlColumnNumber = 14 ];

/// 所在房间
Property CurrentRoom As %String [ SqlColumnNumber = 15 ];

/// 所在床位
Property CurrentBed As %String [ SqlColumnNumber = 16 ];

/// 就诊诊断
Property MainMRAdm As DHCCL.Model.MRAdm [ SqlColumnNumber = 17 ];

/// 外部系统就诊ID
Property ExternalID As %String [ SqlColumnNumber = 18 ];

/// 就诊类型
Property AdmReason As DHCCL.Code.AdmReason [ SqlColumnNumber = 19 ];

Index AdmNo On AdmNo;

Index Dept On AdmDept;

Index AdmDate On AdmDate;

Index Type On AdmType;

Index DischgDate On DischargeDate;

Index Status On VisitStatus;

Index Ext On ExternalID;

Index Ward On CurrentWard;

Index MRAdm On MainMRAdm;

Index AdmReason On AdmReason;

Storage Default
{
<Data name="AdmissionDefaultData">
<Value name="1">
<Value>AdmNo</Value>
</Value>
<Value name="2">
<Value>Patient</Value>
</Value>
<Value name="3">
<Value>AdmDept</Value>
</Value>
<Value name="4">
<Value>AdmCategory</Value>
</Value>
<Value name="5">
<Value>AdmDate</Value>
</Value>
<Value name="6">
<Value>AdmTime</Value>
</Value>
<Value name="7">
<Value>AdmType</Value>
</Value>
<Value name="8">
<Value>AdmDoctor</Value>
</Value>
<Value name="9">
<Value>DischargeDate</Value>
</Value>
<Value name="10">
<Value>DischargeTime</Value>
</Value>
<Value name="11">
<Value>DischgDoctor</Value>
</Value>
<Value name="12">
<Value>VisitStatus</Value>
</Value>
<Value name="13">
<Value>CurrentWard</Value>
</Value>
<Value name="14">
<Value>CurrentRoom</Value>
</Value>
<Value name="15">
<Value>CurrentBed</Value>
</Value>
<Value name="16">
<Value>MainMRAdm</Value>
</Value>
<Value name="17">
<Value>ExternalID</Value>
</Value>
<Value name="18">
<Value>AdmReason</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Model.AdmissionD</DataLocation>
<DefaultData>AdmissionDefaultData</DefaultData>
<IdLocation>^DHCCL.Model.AdmissionD</IdLocation>
<IndexLocation>^DHCCL.Model.AdmissionI</IndexLocation>
<StreamLocation>^DHCCL.Model.AdmissionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
