/// 人员奖金发放表
Class dhc.bonus.data.EmpBonusPay Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = EmpBonusPayID ]
{

/// 发放年份
Property BonusYear As %Library.String [ SqlColumnNumber = 2 ];

/// 发放月份
Property BonusPeriod As %Library.String [ SqlColumnNumber = 3 ];

/// 人员工号
Property EmpCode As %Library.String [ SqlColumnNumber = 4 ];

/// 人员姓名
Property EmpName As %Library.String [ SqlColumnNumber = 5 ];

/// 所属科室
Property EmpUnit As %Library.String [ SqlColumnNumber = 6 ];

/// 发放科室
Property PayUnit As %Library.String [ SqlColumnNumber = 7 ];

/// 数据来源 1=方案核算，2=数据导入
Property DataSource As %Library.String [ SqlColumnNumber = 8 ];

/// 发放项目编码
Property ItemCode As %Library.String [ SqlColumnNumber = 9 ];

/// 发放项目名称
Property ItemName As %Library.String [ SqlColumnNumber = 10 ];

/// 奖金金额
Property ItemValue As %Library.Float [ SqlColumnNumber = 11 ];

/// 导入文件
Property ImportFile As %Library.String [ SqlColumnNumber = 12 ];

/// 更新日期
Property UpdateDate As %Library.String [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="EmpBonusPayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusYear</Value>
</Value>
<Value name="3">
<Value>BonusPeriod</Value>
</Value>
<Value name="4">
<Value>EmpCode</Value>
</Value>
<Value name="5">
<Value>EmpName</Value>
</Value>
<Value name="6">
<Value>EmpUnit</Value>
</Value>
<Value name="7">
<Value>PayUnit</Value>
</Value>
<Value name="8">
<Value>DataSource</Value>
</Value>
<Value name="9">
<Value>ItemCode</Value>
</Value>
<Value name="10">
<Value>ItemName</Value>
</Value>
<Value name="11">
<Value>ItemValue</Value>
</Value>
<Value name="12">
<Value>ImportFile</Value>
</Value>
<Value name="13">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsEmpBonusPayD</DataLocation>
<DefaultData>EmpBonusPayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsEmpBonusPayD</IdLocation>
<IndexLocation>^dhcbsEmpBonusPayI</IndexLocation>
<StreamLocation>^dhcbsEmpBonusPayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
