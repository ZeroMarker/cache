/// 病人
Class DHCCL.Model.Patient Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Patient ]
{

/// 身份证号
Property CardID As %String(COLLATION = "AlphaUp", MAXLEN = 18, TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 病人姓名1
Property FullName1 As %String(COLLATION = "AlphaUp", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 病人姓名2
Property FullName2 As %String(COLLATION = "AlphaUp", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 出生日期
Property DOB As %Date [ SqlColumnNumber = 5 ];

/// 病人性别
Property Gender As %String [ SqlColumnNumber = 6 ];

/// Patient No
Property PatientNo As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// Inpatient No
Property InpatientNo As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// Outpatient No
Property OutpatientNo As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 9 ];

/// Patient ID
Property PatientID As %String [ SqlColumnNumber = 10 ];

/// 病人别名
Property Alias As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11 ];

/// 死亡标志
Property Deceased As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12 ];

/// 死亡日期
Property DeceasedDate As %Date [ SqlColumnNumber = 13 ];

/// 死亡时间
Property DeceasedTime As %Time [ SqlColumnNumber = 14 ];

/// Medicare No
Property MedicareNo As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>CardID</Value>
</Value>
<Value name="2">
<Value>FullName1</Value>
</Value>
<Value name="3">
<Value>FullName2</Value>
</Value>
<Value name="4">
<Value>DOB</Value>
</Value>
<Value name="5">
<Value>Gender</Value>
</Value>
<Value name="6">
<Value>PatientNo</Value>
</Value>
<Value name="7">
<Value>InpatientNo</Value>
</Value>
<Value name="8">
<Value>OutpatientNo</Value>
</Value>
<Value name="9">
<Value>PatientID</Value>
</Value>
<Value name="10">
<Value>Alias</Value>
</Value>
<Value name="11">
<Value>Deceased</Value>
</Value>
<Value name="12">
<Value>DeceasedDate</Value>
</Value>
<Value name="13">
<Value>DeceasedTime</Value>
</Value>
<Value name="14">
<Value>MedicareNo</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Model.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<IdLocation>^DHCCL.Model.PatientD</IdLocation>
<IndexLocation>^DHCCL.Model.PatientI</IndexLocation>
<StreamLocation>^DHCCL.Model.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
