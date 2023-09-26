/// 科室站点项目序号表
Class User.DHCPEStationOrderSort Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_StationOrderSort ]
{

Parameter ClassName = "User.DHCPEStationOrderSort";

Relationship ParRef As User.DHCPEStationOrdCatSort [ Cardinality = parent, Inverse = ChildORD ];

/// 体检项目/站点项目
Property SOSOrderDR As User.DHCPEStationOrder [ SqlFieldName = SOS_OrderDR ];

/// 顺序号
Property SOSSort As %Integer [ SqlFieldName = SOS_Sort ];

/// 站点项目 索引
Index IdxOfOrderDR On SOSOrderDR;

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SOSOrderDR</Value>
</Value>
<Value name="3">
<Value>SOSSort</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ORD")</DataLocation>
<DefaultData>DHCPEStationOrderSortDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ORD")</IdLocation>
<IndexLocation>^CF.PE.StationOrdSortI("ORD")</IndexLocation>
<StreamLocation>^User.DHCPEStationOrderSortS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
