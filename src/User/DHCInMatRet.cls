Class User.DHCInMatRet Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_InMatRet ]
{

Relationship ChildDHCInMatRetItm As User.DHCInMatRetItm [ Cardinality = children, Inverse = IREIParRef ];

/// 单号
Property IRESNo As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IRE_No ];

/// 退回日期
Property IREDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = IRE_Date ];

/// 退回时间
Property IRETime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = IRE_Time ];

/// 退回人员
Property IRESSUSRDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = IRE_SSUSR_DR ];

/// 退回科室
Property IRECTLOCDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = IRE_CTLOC_DR ];

/// 退回科室
Property IREWardLocDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = IRE_WardLoc_DR ];

Index DateLoc On (IREDate As Exact, IRECTLOCDR As Exact);

Index DateLocWard On (IREDate As Exact, IRECTLOCDR As Exact, IREWardLocDR As Exact);

Storage Default
{
<Data name="DHCInMatRetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IRESNo</Value>
</Value>
<Value name="3">
<Value>IREDate</Value>
</Value>
<Value name="4">
<Value>IRETime</Value>
</Value>
<Value name="5">
<Value>IRESSUSRDR</Value>
</Value>
<Value name="6">
<Value>IRECTLOCDR</Value>
</Value>
<Value name="7">
<Value>IREWardLocDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCInMatRetD</DataLocation>
<DefaultData>DHCInMatRetDefaultData</DefaultData>
<IdLocation>^User.DHCInMatRetD</IdLocation>
<IndexLocation>^User.DHCInMatRetI</IndexLocation>
<StreamLocation>^User.DHCInMatRetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
