///     
Class dbo.BDNoticePack Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_NoticePack, StorageStrategy = Default ]
{

/// Foreign Key FKBDNoticePackNotice created via DDL
ForeignKey FKBDNoticePackNotice(NoticeDR) References dbo.BDNotice(PKBDNOTICE) [ SqlName = FK_BD_NoticePack_Notice ];

/// Foreign Key FKBDNoticePackPack created via DDL
ForeignKey FKBDNoticePackPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_NoticePack_Pack ];

/// Foreign Key FKBDNoticePackReqForm created via DDL
ForeignKey FKBDNoticePackReqForm(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BD_NoticePack_ReqForm ];

Index IndexMaster On (NoticeDR, ReqFormDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

Index IndexReqForm On ReqFormDR [ SqlName = Index_ReqForm, Type = index ];

/// DDL Primary Key Specification
Index PKBDNOTICEPACK On RowID [ PrimaryKey, SqlName = PK_BD_NOTICEPACK, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property NoticeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BDNoticePackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NoticeDR</Value>
</Value>
<Value name="3">
<Value>ReqFormDR</Value>
</Value>
<Value name="4">
<Value>PackDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDNoticePackD</DataLocation>
<DefaultData>BDNoticePackDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDNoticePackD</IdLocation>
<IndexLocation>^dbo.BDNoticePackI</IndexLocation>
<StreamLocation>^dbo.BDNoticePackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
