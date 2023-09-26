Class DHCCPM.DHCRepFields Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, Owner = {_SYSTEM}, ProcedureBlock, SqlTableName = DHC_RepFields ]
{

Relationship ParRef As DHCCPM.DHCRepPanels [ Cardinality = parent, Inverse = RepFields ];

Property RFCaption As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = RF_Caption ];

Property RFDataType As %String(TRUNCATE = 1) [ Required, SqlFieldName = RF_DataType ];

Property RFDefaultValue As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlFieldName = RF_DefaultValue ];

Property RFName As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = RF_Name ];

Property RFDescription As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlFieldName = RF_Description ];

/// 在客户端 显示此数据的 控件类型
Property RFDisplayType As %String(TRUNCATE = 1) [ SqlFieldName = RF_DisplayType ];

Index RFNameIndex On RFName As Exact;

Property RFType As %String(TRUNCATE = 1) [ InitialExpression = "C", SqlFieldName = RF_Type ];

Storage Default
{
<Data name="DHCRepFieldsClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCRepFieldsDefaultData">
<Value name="1">
<Value>RFCaption</Value>
</Value>
<Value name="2">
<Value>RFName</Value>
</Value>
<Value name="3">
<Value>RFDataType</Value>
</Value>
<Value name="4">
<Value>RFDescription</Value>
</Value>
<Value name="5">
<Value>RFDefaultValue</Value>
</Value>
<Value name="6">
<Value>RFDisplayType</Value>
</Value>
<Value name="7">
<Value>RFType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("RepFields")</DataLocation>
<DefaultData>DHCRepFieldsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("RepFields")</IdLocation>
<IndexLocation>^DHCCPM.DHCRepFieldsI</IndexLocation>
<StreamLocation>^DHCCPM.DHCRepFieldsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
