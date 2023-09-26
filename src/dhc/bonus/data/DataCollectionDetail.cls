/// JK数据采集明细表
Class dhc.bonus.data.DataCollectionDetail Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = DataCollectionDetailID ]
{

Property CollectionDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property CollectionState As %Library.Integer [ SqlColumnNumber = 3 ];

Property DataCollectionMainID As dhc.bonus.data.DataCollectionMain [ SqlColumnNumber = 2 ];

Storage Default
{
<Data name="DataCollectionDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CollectionDesc</Value>
</Value>
<Value name="3">
<Value>CollectionState</Value>
</Value>
<Value name="4">
<Value>DataCollectionMainID</Value>
</Value>
</Data>
<DataLocation>^DataCollectionDetailD</DataLocation>
<DefaultData>DataCollectionDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DataCollectionDetailD</IdLocation>
<IndexLocation>^DataCollectionDetailI</IndexLocation>
<StreamLocation>^DataCollectionDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
