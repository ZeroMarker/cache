/// 科室收入计提系数设置
Class dhc.bonus.module.BonusIncomeRate Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubIncomeRateID ]
{

//收费类别 IncItemCode

Property BonusIncItemID As dhc.bonus.module.BonusIncItem [ SqlColumnNumber = 2 ];

//病人类别

Property SickType As %Library.Integer [ SqlColumnNumber = 3 ];

//开单科室计提系数

Property MakeBillDeptRate As %Library.Float [ SqlColumnNumber = 4 ];

//执行科室计提系数

Property ExecuteDeptRate As %Library.Float [ SqlColumnNumber = 5 ];

//病人科室计提系数

Property SickDeptRate As %Library.Float [ SqlColumnNumber = 6 ];

//审核人

Property CheckMan As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

//审核时间

Property CheckDate As %Library.String [ SqlColumnNumber = 8 ];

//更新时间

Property UpdateDate As %Library.String [ SqlColumnNumber = 9 ];

//数据状态

Property State As %Library.Integer [ SqlColumnNumber = 10 ];

//-1：通用，其他关联科室组

Property DeptGroupID As dhc.bonus.subs.BonusSubDeptGroup [ SqlColumnNumber = 11 ];

//收费类别病人类型联合索引

Index IncItemCodeSickType On (BonusIncItemID, DeptGroupID);

Storage Default
{
<Data name="BonusIncomeRateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusIncItemID</Value>
</Value>
<Value name="3">
<Value>SickType</Value>
</Value>
<Value name="4">
<Value>MakeBillDeptRate</Value>
</Value>
<Value name="5">
<Value>ExecuteDeptRate</Value>
</Value>
<Value name="6">
<Value>SickDeptRate</Value>
</Value>
<Value name="7">
<Value>CheckMan</Value>
</Value>
<Value name="8">
<Value>CheckDate</Value>
</Value>
<Value name="9">
<Value>UpdateDate</Value>
</Value>
<Value name="10">
<Value>State</Value>
</Value>
<Value name="11">
<Value>DeptGroupID</Value>
</Value>
</Data>
<DataLocation>^dhcbsmdBonusIncomeRateD</DataLocation>
<DefaultData>BonusIncomeRateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsmdBonusIncomeRateD</IdLocation>
<IndexLocation>^dhcbsmdBonusIncomeRateI</IndexLocation>
<StreamLocation>^dhcbsmdBonusIncomeRateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
