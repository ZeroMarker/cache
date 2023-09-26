/// 接口采集指标主表
Class dhc.bonus.data.DataCollectionMain Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = DataCollectionMainID ]
{

Property AuditingDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6 ];

Property AuditingState As %Integer [ Required, SqlColumnNumber = 7 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property DictInterfaceID As dhc.bonus.data.DataInterface [ SqlColumnNumber = 2 ];

Property UpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="DataCollectionMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DictInterfaceID</Value>
</Value>
<Value name="3">
<Value>BonusYear</Value>
</Value>
<Value name="4">
<Value>BonusPeriod</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
<Value name="6">
<Value>AuditingState</Value>
</Value>
<Value name="7">
<Value>AuditingDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsDataCollectionMainD</DataLocation>
<DefaultData>DataCollectionMainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsDataCollectionMainD</IdLocation>
<IndexLocation>^dhcbsDataCollectionMainI</IndexLocation>
<StreamLocation>^dhcbsDataCollectionMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
