Class User.DHCCIServiceTypeList Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlTableName = DHC_CIServiceTypeList ]
{

Relationship STPLCISParRef As User.DHCCIService [ Cardinality = parent, Inverse = STypeList ];

Property STPLDateFrom As %Date [ Required, SqlFieldName = STPL_DateFrom ];

Property STPLDateTo As %Date [ SqlFieldName = STPL_DateTo ];

Property STPLTypeDefineDR As DHCCITypeDefine [ Required, SqlFieldName = STPL_TypeDefine_DR ];

Storage Default
{
<Data name="DHCCIServiceTypeClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCIServiceTypeListDefaultData">
<Value name="1">
<Value>STPLDateFrom</Value>
</Value>
<Value name="2">
<Value>STPLDateTo</Value>
</Value>
<Value name="3">
<Value>STPLTypeDefineDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("STypeList")</DataLocation>
<DefaultData>DHCCIServiceTypeListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCCIServiceC("STypeList")</IdLocation>
<IndexLocation>^User.DHCCIServiceTypeListI</IndexLocation>
<StreamLocation>^User.DHCCIServiceTypeListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
