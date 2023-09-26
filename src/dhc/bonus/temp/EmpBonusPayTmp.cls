/// 人员奖金发放表临时表
Class dhc.bonus.temp.EmpBonusPayTmp Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = EmpBonusPayTmpID ]
{

/// 人员工号
Property EmpCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// 人员项目
Property EmpName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 所属科室
Property EmpUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 4 ];

/// 发放科室
Property PayUnitName As %Library.String [ SqlColumnNumber = 5 ];

/// 发放年份
Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// 发放月份
Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// 奖金金额
Property DataValue0 As %Library.Float [ SqlColumnNumber = 8 ];

/// 奖金金额
Property DataValue1 As %Library.Float [ SqlColumnNumber = 9 ];

/// 更新日期
Property UpdateDate As %Library.String [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="EmpBonusPayTmpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EmpCode</Value>
</Value>
<Value name="3">
<Value>EmpName</Value>
</Value>
<Value name="4">
<Value>EmpUnitID</Value>
</Value>
<Value name="5">
<Value>PayUnitID</Value>
</Value>
<Value name="6">
<Value>BonusYear</Value>
</Value>
<Value name="7">
<Value>BonusPeriod</Value>
</Value>
<Value name="8">
<Value>DataValue0</Value>
</Value>
<Value name="9">
<Value>DataValue1</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
<Value name="11">
<Value>PayUnitName</Value>
</Value>
</Data>
<DataLocation>^dhcbstempEmpBonusPayTmpD</DataLocation>
<DefaultData>EmpBonusPayTmpDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbstempEmpBonusPayTmpD</IdLocation>
<IndexLocation>^dhcbstempEmpBonusPayTmpI</IndexLocation>
<StreamLocation>^dhcbstempEmpBonusPayTmpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
