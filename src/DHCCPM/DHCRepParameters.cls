Class DHCCPM.DHCRepParameters Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlTableName = DHC_RepParameters ]
{

Property RPRCaption As %String(TRUNCATE = 1) [ Required, SqlFieldName = RPR_Caption ];

/// 用来保存参数的默认值,对于自定义的参数 如果Value没有数值就找这个值
Property RPRDefaultValue As %String(TRUNCATE = 1) [ SqlFieldName = RPR_DefaultValue ];

Property RPRName As %String(TRUNCATE = 1) [ Required, SqlFieldName = RPR_Name ];

Property RPRType As %String(TRUNCATE = 1) [ Required, SqlFieldName = RPR_Type ];

Property RPRValue As %String(TRUNCATE = 1) [ SqlFieldName = RPR_Value ];

Index RPRNameIndex On RPRName [ Unique ];

Relationship ParRef As DHCCPM.DHCRepPanels [ Cardinality = parent, Inverse = RepParameters ];

Storage Default
{
<Data name="DHCRepParametersClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCRepParametersDefaultData">
<Value name="1">
<Value>RPRCaption</Value>
</Value>
<Value name="2">
<Value>RPRDefaultValue</Value>
</Value>
<Value name="3">
<Value>RPRName</Value>
</Value>
<Value name="4">
<Value>RPRType</Value>
</Value>
<Value name="5">
<Value>RPRValue</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("RepParameters")</DataLocation>
<DefaultData>DHCRepParametersDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("RepParameters")</IdLocation>
<IndexLocation>^DHCCPM.DHCRepParametersI</IndexLocation>
<StreamLocation>^DHCCPM.DHCRepParametersS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
