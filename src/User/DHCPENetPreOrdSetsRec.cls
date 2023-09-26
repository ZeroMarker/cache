/// Description:网上预约套餐记录表
/// Creator:wangguoying
Class User.DHCPENetPreOrdSetsRec Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_NetPreOrdSetsRec ]
{

Parameter ClassName = "User.DHCPENetPreOrdSetsRec";

Relationship NPORParRef As User.DHCPENetPreRecord [ Cardinality = parent, Inverse = NPRPreOrdSetsRecord ];

/// 套餐ID
Property NPOROrdSetsDR As User.ARCOrdSets [ Required, SqlFieldName = NPOR_OrdSets_DR ];

/// 体检预约记录套餐ID
Property NPORPreEntDR As User.DHCPEPreIOrdEnt [ SqlFieldName = NPOR_PreEnt_DR ];

/// 是否拆分标记  若已拆分，则该字段只记录套餐，对应项目信息存储在User.DHCPENetPreItemRecord  插入体检项目表时，不考虑该字段
Property NPORBreak As %String(MAXLEN = 1, VALUELIST = ",Y,N") [ SqlFieldName = NPOR_Break ];

/// 预约类型 PRE ADD
Property NPORPreType As %String(VALUELIST = ",PRE,ADD") [ InitialExpression = "PRE", SqlFieldName = NPOR_PreType ];

Index IndexPreEntDR On NPORPreEntDR;

Index IndexOrdSetsDR On (NPORParRef, NPOROrdSetsDR) [ Unique ];

Storage Default
{
<Data name="DHCPENetPreOrdSetsRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NPOROrdSetsDR</Value>
</Value>
<Value name="3">
<Value>NPORPreEntDR</Value>
</Value>
<Value name="4">
<Value>NPORBreak</Value>
</Value>
<Value name="5">
<Value>NPORPreType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("NPRPreOrdSetsRec")</DataLocation>
<DefaultData>DHCPENetPreOrdSetsRecDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPENetPreRecordC("NPRPreOrdSetsRec")</IdLocation>
<IndexLocation>^User.DHCPENetPreOrdSetsRecI</IndexLocation>
<StreamLocation>^User.DHCPENetPreOrdSetsRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
