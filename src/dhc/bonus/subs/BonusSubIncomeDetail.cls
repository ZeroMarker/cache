Class dhc.bonus.subs.BonusSubIncomeDetail Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubIncomeDetailID ]
{

//奖金核算单元

Property BonusUnitID As dhc.bonus.data.BonusUnit [ Required, SqlColumnNumber = 2 ];

//辅助核算项目

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 3 ];

//核算年度

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

//核算期间

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

//单位类型 1：开单科室 2：执行科室 3：病人科室 4：开单医生 5：执行医生

Property BonusUnitType As %Library.Integer [ SqlColumnNumber = 6 ];

//费用类型 1：门诊 、2：住院、3：急诊

Property ExpensesType As %Library.Integer [ SqlColumnNumber = 7 ];

//病人类型 1：自费 、2：医保、3、新农合

Property SickType As %Library.Integer [ Required, SqlColumnNumber = 8 ];

//负责医生

Property ChiefDoctorID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 9 ];

//开单医生

Property MakeBillDoctorID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 10 ];

//执行医生

Property ExecuteDoctorID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 11 ];

//收入金额

Property IncomeMoney As %Library.Float [ Required, SqlColumnNumber = 12 ];

//计提系数

Property IncomeRate As %Library.Float [ Required, SqlColumnNumber = 13 ];

//计提金额

Property ResultMoney As %Library.Float [ Required, SqlColumnNumber = 14 ];

Property State As %Library.Integer [ SqlColumnNumber = 15 ];

Property InterLocMethodID As dhc.bonus.inter.InterLocMethod [ SqlColumnNumber = 16 ];

Property MakeBillDeptID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 17 ];

Property ExecuteDeptID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 18 ];

Property SickDeptID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 19 ];

Property UpdateDate As %Library.TimeStamp [ SqlColumnNumber = 20 ];

Property BonusSubItemID As dhc.bonus.subs.BonusSubItem [ SqlColumnNumber = 21 ];

Property IncomeCollectID As dhc.bonus.subs.BonusSubIncomeCollect [ SqlColumnNumber = 22 ];

Storage Default
{
<Data name="BonusSubIncomeDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusUnitID</Value>
</Value>
<Value name="3">
<Value>BonusTargetID</Value>
</Value>
<Value name="4">
<Value>BonusYear</Value>
</Value>
<Value name="5">
<Value>BonusPeriod</Value>
</Value>
<Value name="6">
<Value>BonusUnitType</Value>
</Value>
<Value name="7">
<Value>ExpensesType</Value>
</Value>
<Value name="8">
<Value>SickType</Value>
</Value>
<Value name="9">
<Value>ChiefDoctorID</Value>
</Value>
<Value name="10">
<Value>MakeBillDoctorID</Value>
</Value>
<Value name="11">
<Value>ExecuteDoctorID</Value>
</Value>
<Value name="12">
<Value>IncomeMoney</Value>
</Value>
<Value name="13">
<Value>IncomeRate</Value>
</Value>
<Value name="14">
<Value>ResultMoney</Value>
</Value>
<Value name="15">
<Value>State</Value>
</Value>
<Value name="16">
<Value>InterLocMethodID</Value>
</Value>
<Value name="17">
<Value>ExecuteDeptID</Value>
</Value>
<Value name="18">
<Value>MakeBillDeptID</Value>
</Value>
<Value name="19">
<Value>SickDeptID</Value>
</Value>
<Value name="20">
<Value>UpdateDate</Value>
</Value>
<Value name="21">
<Value>BonusSubItemID</Value>
</Value>
<Value name="22">
<Value>IncomeCollectID</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubIncomeDetailD</DataLocation>
<DefaultData>BonusSubIncomeDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubIncomeDetailD</IdLocation>
<IndexLocation>^dhcbsSubIncomeDetailI</IndexLocation>
<StreamLocation>^dhcbsSubIncomeDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
