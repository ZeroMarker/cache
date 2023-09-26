Class dbo.BDReqFormPackID Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReqFormPackID, StorageStrategy = Default ]
{

Index IndexReqForm On ReqFormDR [ SqlName = Index_ReqForm, Type = index ];

Index PKBDREQFORMPACKID On RowID [ PrimaryKey, SqlName = PK_BDREQFORMPACKID, Type = index, Unique ];

/// Foreign Key FKBDRFCostIPack created via DDL
ForeignKey FKRFPACKIDREQ(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_RFPACKID_REQ ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property PackID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 5 ];

Property IsUsed As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BDReqFormPackIDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RegNo</Value>
</Value>
<Value name="3">
<Value>ReqFormDR</Value>
</Value>
<Value name="4">
<Value>PackID</Value>
</Value>
<Value name="5">
<Value>IsUsed</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReqFormPackIDD</DataLocation>
<DefaultData>BDReqFormPackIDDefaultData</DefaultData>
<IdLocation>^dbo.BDReqFormPackIDD</IdLocation>
<IndexLocation>^dbo.BDReqFormPackIDI</IndexLocation>
<StreamLocation>^dbo.BDReqFormPackIDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
