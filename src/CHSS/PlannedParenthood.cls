Class CHSS.PlannedParenthood Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = PlannedRowId, SqlTableName = PlannedParenthood ]
{

/// 个人档案主键
Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

/// 生育状态
Property BirthRowIDParref As CHSS.DictPlanBirthStatus;

/// 当前孕次
Property CurrentPregnancy As %Integer;

/// 当前产次
Property CurrentGiveBirth As %Integer;

/// 计划内男
Property InPlanMan As %Integer;

/// 计划内女
Property InPlanFemail As %Integer;

/// 计划外男
Property OutPlanMan As %Integer;

/// 计划外女
Property OutPlanFemail As %Integer;

/// 登记人
Property Register As User.SSUser;

/// 登记日期
Property RegisterDate As %Date(FORMAT = 1);

/// 备注
Property Remark As %String(MAXLEN = 200, TRUNCATE = 1);

Index PersonRowIdIndex On PersonRowId;

Storage Default
{
<Data name="PlannedParenthoodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BirthRowIDParref</Value>
</Value>
<Value name="3">
<Value>CurrentGiveBirth</Value>
</Value>
<Value name="4">
<Value>CurrentPregnancy</Value>
</Value>
<Value name="5">
<Value>InPlanFemail</Value>
</Value>
<Value name="6">
<Value>InPlanMan</Value>
</Value>
<Value name="7">
<Value>OutPlanFemail</Value>
</Value>
<Value name="8">
<Value>OutPlanMan</Value>
</Value>
<Value name="9">
<Value>PersonRowId</Value>
</Value>
<Value name="10">
<Value>Register</Value>
</Value>
<Value name="11">
<Value>RegisterDate</Value>
</Value>
<Value name="12">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^CHSS.PlannedParenthoodD</DataLocation>
<DefaultData>PlannedParenthoodDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PlannedParenthoodD</IdLocation>
<IndexLocation>^CHSS.PlannedParenthoodI</IndexLocation>
<StreamLocation>^CHSS.PlannedParenthoodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
