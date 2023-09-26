Class User.DHCAdvGenericRelation Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AdvGenericRelation ]
{

/// 关联项类型    TIME：时限，FORMDIC：面板维护
Property Type As %String;

/// 关联表指向  类型为TIME、FORMDIC时指向为 DHC_AdrEvtWorkFlowItm 
Property LinkDr As %String;

/// 数据    TIME：（时限时长）， FORMDIC：（面板Code）
Property Data As %String;

/// 属性  TIME：（级别）， FORMDIC：（0-可以编辑，1-不可以编辑）
Property Attribute As %String;

/// 备注  
Property Remark As %String;

/// 多院区改造 2021-04-12 cy
Property HospDr As User.CTHospital;

Storage Default
{
<Data name="DHCAdvGenericRelationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>LinkDr</Value>
</Value>
<Value name="4">
<Value>Data</Value>
</Value>
<Value name="5">
<Value>Attribute</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>HospDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCAdvGenericRelationD</DataLocation>
<DefaultData>DHCAdvGenericRelationDefaultData</DefaultData>
<IdLocation>^User.DHCAdvGenericRelationD</IdLocation>
<IndexLocation>^User.DHCAdvGenericRelationI</IndexLocation>
<StreamLocation>^User.DHCAdvGenericRelationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

/// 关联项类型与关联表指向
Index IndexTypeLink On (Type As AlphaUp, LinkDr);

}
