Class dhc.bonus.module.BonusIncDetail Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusIncDetailID ]
{

/// 所属年
Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// 奖金期间
Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 科目编码
Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// 科目名称
Property ItemName As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// 项目金额
Property ItemValue As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// 计提系数
Property ItemRate As %Library.Float [ SqlColumnNumber = 7 ];

/// 科室ID
Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 8 ];

/// 操作员
Property Operator As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

/// 数据状态
Property State As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

/// 数据类型1=开单收入，2=执行收入，3=病人收入
Property DataType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

Property UpdateDate As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

/// 收费金额
Property IncValue As %Library.Float [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="BonusIncDetailDefaultData">
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
<Value>ItemCode</Value>
</Value>
<Value name="5">
<Value>ItemName</Value>
</Value>
<Value name="6">
<Value>ItemValue</Value>
</Value>
<Value name="7">
<Value>ItemRate</Value>
</Value>
<Value name="8">
<Value>BonusUnitID</Value>
</Value>
<Value name="9">
<Value>Operator</Value>
</Value>
<Value name="10">
<Value>State</Value>
</Value>
<Value name="11">
<Value>DataType</Value>
</Value>
<Value name="12">
<Value>UpdateDate</Value>
</Value>
<Value name="13">
<Value>IncValue</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusIncDetailD</DataLocation>
<DefaultData>BonusIncDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusIncDetailD</IdLocation>
<IndexLocation>^dhcbsBonusIncDetailI</IndexLocation>
<StreamLocation>^dhcbsBonusIncDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
