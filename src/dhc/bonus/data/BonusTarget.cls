/// ZD奖金指标
Class dhc.bonus.data.BonusTarget Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusTargetID ]
{

Index BonusTargetCode On BonusTargetCode As Exact;

Property BonusTargetCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property BonusTargetName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property CalUnitID As dhc.bonus.data.CalUnit [ SqlColumnNumber = 4 ];

Property TargetTypeID As dhc.bonus.data.TargetType [ SqlColumnNumber = 5 ];

Property TargetSpell As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// 数据来源  '手工录入' = 1， '公式计算' = 2,'区间计算'= 3,'比例系数' = 4,'辅助处理'= 5,'差额累加'= 6,'差率累加'= 7
/// 累加求和'= 8,'单项核算'= 9,'收入指标'= 10, '支出指标'= 11,'RBRVS指标'= 12,'Drgs指标'= 13,'绩效指标' = 14
Property DataSource As %Library.Integer [ SqlColumnNumber = 7 ];

Property TargetDesc As %Library.String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

Property CalculateFormula As %Library.String(COLLATION = "Exact", MAXLEN = 1500, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

Property CalculateDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1500, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Property CalculatePriority As %Library.Integer [ SqlColumnNumber = 11 ];

Property TargetProperty As %Library.Integer [ SqlColumnNumber = 12 ];

Property RateType As %Library.Integer [ SqlColumnNumber = 13 ];

Property ParameterTarget As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 14 ];

Property IsValid As %Library.Integer [ SqlColumnNumber = 15 ];

Property AuditingState As %Library.Integer [ SqlColumnNumber = 16 ];

Property AuditingDate As %Library.Date [ SqlColumnNumber = 17 ];

Property UpdateDate As %Library.Date [ SqlColumnNumber = 18 ];

Property calFlag As %Library.Integer [ SqlColumnNumber = 19 ];

Property InitValue As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 20 ];

Property MaxValue As %Library.Float [ SqlColumnNumber = 21 ];

Storage Default
{
<Data name="BonusTargetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusTargetCode</Value>
</Value>
<Value name="3">
<Value>BonusTargetName</Value>
</Value>
<Value name="4">
<Value>CalUnitID</Value>
</Value>
<Value name="5">
<Value>TargetTypeID</Value>
</Value>
<Value name="6">
<Value>TargetSpell</Value>
</Value>
<Value name="7">
<Value>DataSource</Value>
</Value>
<Value name="8">
<Value>TargetDesc</Value>
</Value>
<Value name="9">
<Value>CalculateFormula</Value>
</Value>
<Value name="10">
<Value>CalculateDesc</Value>
</Value>
<Value name="11">
<Value>CalculatePriority</Value>
</Value>
<Value name="12">
<Value>TargetProperty</Value>
</Value>
<Value name="13">
<Value>RateType</Value>
</Value>
<Value name="14">
<Value>ParameterTarget</Value>
</Value>
<Value name="15">
<Value>IsValid</Value>
</Value>
<Value name="16">
<Value>AuditingState</Value>
</Value>
<Value name="17">
<Value>AuditingDate</Value>
</Value>
<Value name="18">
<Value>UpdateDate</Value>
</Value>
<Value name="19">
<Value>calFlag</Value>
</Value>
<Value name="20">
<Value>InitValue</Value>
</Value>
<Value name="21">
<Value>MaxValue</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusTargetD</DataLocation>
<DefaultData>BonusTargetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusTargetD</IdLocation>
<IndexLocation>^dhcbsBonusTargetI</IndexLocation>
<StreamLocation>^dhcbsBonusTargetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
