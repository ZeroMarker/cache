/// 科室站点分类序号表
Class User.DHCPEStationOrdCatSort Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_StationOrdCatSort ]
{

Parameter ClassName = "User.DHCPEStationOrdCatSort";

Relationship ChildORD As User.DHCPEStationOrderSort [ Cardinality = children, Inverse = ParRef ];

/// 站点分类
Property SOCSOrdCatDR As User.DHCPEStationLoc [ SqlFieldName = SOCS_OrdCatDR ];

/// 顺序号
Property SOCSSort As %Integer [ SqlFieldName = SOCS_Sort ];

/// 站点分类 索引
Index IdxOfOrdCatDR On SOCSOrdCatDR;

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SOCSOrdCatDR</Value>
</Value>
<Value name="3">
<Value>SOCSSort</Value>
</Value>
</Data>
<DataLocation>^CF.PE.StationOrdSortD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.StationOrdSortD</IdLocation>
<IndexLocation>^CF.PE.StationOrdSortI</IndexLocation>
<StreamLocation>^User.DHCPEStationOrdCatSortS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
