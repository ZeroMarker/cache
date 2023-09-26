Class User.DHCInMatDisp Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_InMatDisp, StorageStrategy = CacheStorage ]
{

Relationship ChildDHCInMatDispItm As User.DHCInMatDispItm [ Cardinality = children, Inverse = IDSIParRef ];

/// 单号
Property IDSNo As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IDS_No ];

/// 发放日期
Property IDSDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = IDS_Date ];

/// 发放时间
Property IDSTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = IDS_Time ];

/// 发放人员
Property IDSSSUSRDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = IDS_SSUSR_DR ];

/// 发放科室
Property IDSCTLOCDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = IDS_CTLOC_DR ];

/// 病区科室
Property IDSWardLocDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = IDS_WardLoc_DR ];

Storage CacheStorage
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDSNo</Value>
</Value>
<Value name="3">
<Value>IDSDate</Value>
</Value>
<Value name="4">
<Value>IDSTime</Value>
</Value>
<Value name="5">
<Value>IDSSSUSRDR</Value>
</Value>
<Value name="6">
<Value>IDSCTLOCDR</Value>
</Value>
<Value name="7">
<Value>IDSWardLocDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCInMatDispD</DataLocation>
<IdLocation>^User.DHCInMatDispD</IdLocation>
<IndexLocation>^User.DHCInMatDispI</IndexLocation>
<SqlRowIdName>DHC_InMatDisp</SqlRowIdName>
<StreamLocation>^User.DHCInMatDispS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index DateLoc On (IDSDate As Exact, IDSCTLOCDR As Exact);

Index DateLocWard On (IDSDate As Exact, IDSCTLOCDR As Exact, IDSWardLocDR As Exact);

}
