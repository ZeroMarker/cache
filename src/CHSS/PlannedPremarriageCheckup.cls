Class CHSS.PlannedPremarriageCheckup Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = CheckUpRowId, SqlTableName = PlannedPremarriageCheckup ]
{

/// 个人档案主键
Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

/// 检查日期	 
Property CheckUpDate As %Date(FORMAT = 1);

/// 检查结果	
Property CheckResult As %String(MAXLEN = 200, TRUNCATE = 1);

/// 医学意见	
Property DoctorOpinion As %String(MAXLEN = 200, TRUNCATE = 1);

/// 备注
Property Remark As %String(MAXLEN = 200, TRUNCATE = 1);

/// 操作日期	
Property OperatorDate As %Date(FORMAT = 1);

/// 登记人
Property Register As User.SSUser;

Index PersonRowIdIndex On PersonRowId;

Storage Default
{
<Data name="PlannedPremarriageCheckupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckResult</Value>
</Value>
<Value name="3">
<Value>CheckUpDate</Value>
</Value>
<Value name="4">
<Value>DoctorOpinion</Value>
</Value>
<Value name="5">
<Value>OperatorDate</Value>
</Value>
<Value name="6">
<Value>PersonRowId</Value>
</Value>
<Value name="7">
<Value>Register</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^CHSS.PlannedPrema9F4D</DataLocation>
<DefaultData>PlannedPremarriageCheckupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PlannedPrema9F4D</IdLocation>
<IndexLocation>^CHSS.PlannedPrema9F4I</IndexLocation>
<StreamLocation>^CHSS.PlannedPrema9F4S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
