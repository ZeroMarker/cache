/// Descript:套餐限额管理
/// Creator:wangguoying
Class User.DHCPEOrdSetsPreManager Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_OrdSetsPreManager ]
{

Parameter ClassName = "User.DHCPEOrdSetsPreManager";

Relationship OSPMTime As User.DHCPEOSPreTimeManager [ Cardinality = children, Inverse = OSPMTParRef ];

/// 套餐
Property OSPMOrdSets As User.ARCOrdSets [ Required, SqlColumnNumber = 2, SqlFieldName = OSPM_OrdSets ];

/// 科室
Property OSPMLoc As User.CTLoc [ Required, SqlColumnNumber = 3, SqlFieldName = OSPM_Loc ];

/// 数量
Property OSPMNum As %Integer [ Required, SqlColumnNumber = 4, SqlFieldName = OSPM_Num ];

/// 日期
Property OSPMDate As %Date [ Required, SqlColumnNumber = 5, SqlFieldName = OSPM_Date ];

Index LocDateSetsIndex On (OSPMLoc, OSPMDate, OSPMOrdSets) [ Unique ];

Index LocSetsDateIndex On (OSPMLoc, OSPMOrdSets, OSPMDate) [ Unique ];

Storage Default
{
<Data name="DHCPEOrdSetsPreManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OSPMOrdSets</Value>
</Value>
<Value name="3">
<Value>OSPMLoc</Value>
</Value>
<Value name="4">
<Value>OSPMNum</Value>
</Value>
<Value name="5">
<Value>OSPMDate</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEOrdSetsPreManagerD</DataLocation>
<DefaultData>DHCPEOrdSetsPreManagerDefaultData</DefaultData>
<IdLocation>^User.DHCPEOrdSetsPreManagerD</IdLocation>
<IndexLocation>^User.DHCPEOrdSetsPreManagerI</IndexLocation>
<StreamLocation>^User.DHCPEOrdSetsPreManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
