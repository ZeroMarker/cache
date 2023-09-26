Class CHSS.PlannedDrugList Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = DurgListId, SqlTableName = PlannedDrugList ]
{

/// 个人档案主键
Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

/// 领用药具	
Property PlannedDrugParref As CHSS.DictProphylactic;

/// 登记人
Property Register As User.SSUser;

/// 有效日期
Property ValidDate As %Date(FORMAT = 1);

/// 领用日期
Property TakeDate As %Date(FORMAT = 1);

/// 备注
Property Remark As %String(MAXLEN = 200, TRUNCATE = 1);

Index PersonRowIdIndex On PersonRowId;

Storage Default
{
<Data name="PlannedDrugListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PersonRowId</Value>
</Value>
<Value name="3">
<Value>PlannedDrugParref</Value>
</Value>
<Value name="4">
<Value>Register</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
<Value name="6">
<Value>TakeDate</Value>
</Value>
<Value name="7">
<Value>ValidDate</Value>
</Value>
</Data>
<DataLocation>^CHSS.PlannedDrugListD</DataLocation>
<DefaultData>PlannedDrugListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PlannedDrugListD</IdLocation>
<IndexLocation>^CHSS.PlannedDrugListI</IndexLocation>
<StreamLocation>^CHSS.PlannedDrugListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
