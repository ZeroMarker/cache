/// 基础码表数据别名
/// 2014-03-17 zhaocz
Class User.BDPAlias Extends %Persistent
{

/// 表名称
Property TableName As %String(MAXLEN = "") [ Required ];

/// 数据别名
Property DataAlias As %String(MAXLEN = "") [ Required ];

/// 对应表数据RowID
Property DataReference As %String(MAXLEN = "") [ Required ];

Index AliasRef On (TableName As Exact, DataAlias As Exact, DataReference As Exact);

Index DataRef On (TableName As Exact, DataReference As Exact);

Storage Default
{
<Data name="BDPAliasClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BDPAliasDefaultData">
<Value name="1">
<Value>TableName</Value>
</Value>
<Value name="2">
<Value>DataAlias</Value>
</Value>
<Value name="3">
<Value>DataReference</Value>
</Value>
</Data>
<DataLocation>^User.BDPAliasD</DataLocation>
<DefaultData>BDPAliasDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPAliasD</IdLocation>
<IndexLocation>^User.BDPAliasI</IndexLocation>
<StreamLocation>^User.BDPAliasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
