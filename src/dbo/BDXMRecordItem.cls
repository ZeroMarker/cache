/// 
Class dbo.BDXMRecordItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_XMRecordItem ]
{

/// Foreign Key FKBDXMRecordItemXMRecordDR created via DDL
ForeignKey FKBDXMRecordItemXMRecordDR(XMRecordDR) References dbo.BDXMRecord(PKBDXMRECORD) [ SqlName = FK_BDXMRecordItemXMRecordDR ];

/// Foreign Key FKBDXMRecordItemReqFormDR created via DDL
ForeignKey FKBDXMRecordItemReqFormDR(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_BDXMRecordItemReqFormDR ];

/// Foreign Key FKBDXMRecordItemPackDR created via DDL
ForeignKey FKBDXMRecordItemPackDR(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BDXMRecordItemPackDR ];

/// DDL Primary Key Specification
Index PKBDXMRECORDITEM On RowID [ PrimaryKey, SqlName = PK_BD_XMRECORDITEM, Type = index, Unique ];

Index IndexMaster On (XMRecordDR, ReqFormDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexReqForm On ReqFormDR [ SqlName = Index_ReqForm, Type = index ];

Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property XMRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BDXMRecordItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>XMRecordDR</Value>
</Value>
<Value name="3">
<Value>ReqFormDR</Value>
</Value>
<Value name="4">
<Value>PackDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDXMRecordItemD</DataLocation>
<DefaultData>BDXMRecordItemDefaultData</DefaultData>
<IdLocation>^dbo.BDXMRecordItemD</IdLocation>
<IndexLocation>^dbo.BDXMRecordItemI</IndexLocation>
<StreamLocation>^dbo.BDXMRecordItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
