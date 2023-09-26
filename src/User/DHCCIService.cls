/// 定义的服务, Code代表指令
Class User.DHCCIService Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlTableName = DHC_CIService ]
{

Property CISActiveFlag As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = CIS_ActiveFlag ];

Property CISCode As %String(TRUNCATE = 1) [ Required, SqlFieldName = CIS_Code ];

Property CISDesc As %String(TRUNCATE = 1) [ Required, SqlFieldName = CIS_Desc ];

Relationship STypeList As User.DHCCIServiceTypeList [ Cardinality = children, Inverse = STPLCISParRef ];

Index CISCodeIndex On CISCode [ Unique ];

Storage Default
{
<Data name="DHCCIServiceClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCIServiceDefaultData">
<Value name="1">
<Value>CISCode</Value>
</Value>
<Value name="2">
<Value>CISDesc</Value>
</Value>
<Value name="3">
<Value>CISActiveFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCCIServiceD</DataLocation>
<DefaultData>DHCCIServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCCIServiceD</IdLocation>
<IndexLocation>^User.DHCCIServiceI</IndexLocation>
<StreamLocation>^User.DHCCIServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
