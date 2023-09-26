Class CHSS.PersonConsultation Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = PersonConsultation ]
{

//个人档案主键

Property PersonRowId As CHSS.PersonHealthRecordMain;

/// 会诊日期 
Property ConsultDate As %Date;

/// 会诊原因 
Property ConsultReason As %String(MAXLEN = 100, TRUNCATE = 1);

/// 会诊意见 
Property ConsultSuggestion As %String(MAXLEN = 100, TRUNCATE = 1);

/// 责任医生 
Property MainDoctor As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注 
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

/// 登记日期 
Property DateRegister As %Date;

/// 登记人员 
Property Register As %String(MAXLEN = 50, TRUNCATE = 1);

Index PersonIndex On PersonRowId;

Storage Default
{
<Data name="PersonConsultationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConsultDate</Value>
</Value>
<Value name="3">
<Value>ConsultReason</Value>
</Value>
<Value name="4">
<Value>ConsultSuggestion</Value>
</Value>
<Value name="5">
<Value>DateRegister</Value>
</Value>
<Value name="6">
<Value>MainDoctor</Value>
</Value>
<Value name="7">
<Value>PersonRowId</Value>
</Value>
<Value name="8">
<Value>Register</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
<Value name="10">
<Value>RowId</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonConsultationD</DataLocation>
<DefaultData>PersonConsultationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonConsultationD</IdLocation>
<IndexLocation>^CHSS.PersonConsultationI</IndexLocation>
<StreamLocation>^CHSS.PersonConsultationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
