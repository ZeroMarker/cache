Class User.DHCPENetPreItemRecord Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_NetPreItemRecord ]
{

Parameter ClassName = "User.DHCPENetPreItemRecord";

Relationship NPIRParRef As User.DHCPENetPreRecord [ Cardinality = parent, Inverse = NPRPreItemRecord ];

/// 预约加项ID
Property NPIRItemDR As User.ARCItmMast [ Required, SqlFieldName = NPIR_Item_DR ];

/// 体检项目ID
Property NPIRPreIOrdDR As User.DHCPEPreIOrdItem [ SqlFieldName = NPIR_PreIOrd_DR ];

/// 所属拆分套餐的ID
Property NPIROrdSetsDR As User.DHCPENetPreOrdSetsRec [ SqlFieldName = NPIR_OrdSets_DR ];

/// 预约类型 PRE ADD
Property NPIRPreType As %String(VALUELIST = ",PRE,ADD") [ InitialExpression = "PRE", SqlFieldName = NPIR_PreType ];

Property NPIRPrice As %Float [ SqlFieldName = NPIR_Price ];

Index IndexPreIOrdDR On NPIRPreIOrdDR;

Index IndexItemDR On (NPIRParRef, NPIRItemDR);

Storage Default
{
<Data name="DHCPENetPreItemRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NPIRItemDR</Value>
</Value>
<Value name="3">
<Value>NPIRPreIOrdDR</Value>
</Value>
<Value name="4">
<Value>NPIROrdSetsDR</Value>
</Value>
<Value name="5">
<Value>NPIRPreType</Value>
</Value>
<Value name="6">
<Value>NPIRPrice</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("NPRPreItemRecord")</DataLocation>
<DefaultData>DHCPENetPreItemRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPENetPreRecordC("NPRPreItemRecord")</IdLocation>
<IndexLocation>^User.DHCPENetPreItemRecordI</IndexLocation>
<StreamLocation>^User.DHCPENetPreItemRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
