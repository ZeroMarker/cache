Class DHCCPM.DHCRepPanels Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, Owner = {_SYSTEM}, ProcedureBlock, SqlTableName = DHC_RepPanels ]
{

Property RPCaption As %String(TRUNCATE = 1) [ Required, SqlFieldName = RP_Caption ];

Property RPClassName As %String(TRUNCATE = 1) [ SqlFieldName = RP_ClassName ];

/// 名称
Property RPName As %String(TRUNCATE = 1) [ Required, SqlFieldName = RP_Name ];

Property RPQueryName As %String(TRUNCATE = 1) [ SqlFieldName = RP_QueryName ];

Relationship ParRef As DHCCPM.DHCReports [ Cardinality = parent, Inverse = RepPanels ];

/// Panel 的类型 分为文本或记录集类型
Property RPType As %String(DISPLAYLIST = ",System,Text,Query", TRUNCATE = 1, VALUELIST = ",S,T,Q") [ Required, SqlFieldName = RP_Type ];

Relationship RepParameters As DHCCPM.DHCRepParameters [ Cardinality = children, Inverse = ParRef ];

Relationship RepFields As DHCCPM.DHCRepFields [ Cardinality = children, Inverse = ParRef ];

Storage Default
{
<Data name="DHCRepPanelsClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCRepPanelsDefaultData">
<Value name="1">
<Value>RPType</Value>
</Value>
<Value name="2">
<Value>RPClassName</Value>
</Value>
<Value name="3">
<Value>RPQueryName</Value>
</Value>
<Value name="4">
<Value>RPCaption</Value>
</Value>
<Value name="5">
<Value>RPName</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("RepPanels")</DataLocation>
<DefaultData>DHCRepPanelsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("RepPanels")</IdLocation>
<IndexLocation>^DHCCPM.DHCRepPanelsI</IndexLocation>
<StreamLocation>^DHCCPM.DHCRepPanelsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
