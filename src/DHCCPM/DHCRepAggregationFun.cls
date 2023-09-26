/// 聚合函数名称公式说明
Class DHCCPM.DHCRepAggregationFun Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlTableName = DHC_RepAggregationFun ]
{

/// 标题
Property RAFCaption As %String(TRUNCATE = 1) [ Required, SqlFieldName = RAF_Caption ];

/// 聚合函数的描述说明
Property RAFDesc As %String(MAXLEN = "", TRUNCATE = 1) [ SqlFieldName = RAF_Desc ];

Property RAFName As %String(TRUNCATE = 1) [ Required, SqlFieldName = RAF_Name ];

Index RAFNameIndex On RAFName [ Unique ];

Storage Default
{
<Data name="DHCRepAggregationFunClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCRepAggregationFunDefaultData">
<Value name="1">
<Value>RAFCaption</Value>
</Value>
<Value name="2">
<Value>RAFDesc</Value>
</Value>
<Value name="3">
<Value>RAFName</Value>
</Value>
</Data>
<DataLocation>^DHCCPM.DHCRepAggregationFunD</DataLocation>
<DefaultData>DHCRepAggregationFunDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCPM.DHCRepAggregationFunD</IdLocation>
<IndexLocation>^DHCCPM.DHCRepAggregationFunI</IndexLocation>
<StreamLocation>^DHCCPM.DHCRepAggregationFunS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
