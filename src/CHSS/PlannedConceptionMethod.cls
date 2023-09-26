Class CHSS.PlannedConceptionMethod Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = MethodId, SqlTableName = PlannedConceptionMethod ]
{

/// 个人档案主键
Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

/// 采用措施	MethodName
Property MethodName As CHSS.DictProphylacticMethod;

/// 措施时间	 
Property MethodDate As %Date(FORMAT = 1);

/// 登记日期	 
Property DateOfRegister As %Date(FORMAT = 1);

/// 备注
Property Remark As %String(MAXLEN = 200, TRUNCATE = 1);

/// 登记人
Property Register As User.SSUser;

Index PersonRowIdIndex On PersonRowId;

Storage Default
{
<Data name="PlannedConceptionMethodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateOfRegister</Value>
</Value>
<Value name="3">
<Value>MethodDate</Value>
</Value>
<Value name="4">
<Value>MethodName</Value>
</Value>
<Value name="5">
<Value>PersonRowId</Value>
</Value>
<Value name="6">
<Value>Register</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^CHSS.PlannedConceptionMethodD</DataLocation>
<DefaultData>PlannedConceptionMethodDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PlannedConceptionMethodD</IdLocation>
<IndexLocation>^CHSS.PlannedConceptionMethodI</IndexLocation>
<StreamLocation>^CHSS.PlannedConceptionMethodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
