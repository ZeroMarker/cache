Class dbo.RPTransRecordItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_TransRecordItem ]
{

/// Foreign Key FKBDTRComTakeRecord created via DDL
ForeignKey FKRPTransRecord(TransRecordDR) References dbo.RPTransRecord(PKRPTRANSRECORD) [ SqlName = FK_RP_TRItem_TransRecord ];

/// Foreign Key FKBDRFPBloodGroup created via DDL
ForeignKey FKRPVisitNumber(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_RP_TRItem_VisitNumber ];

Index IndexMaster On (TransRecordDR, VisitNumberDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexTransRecord On TransRecordDR [ SqlName = Index_TransRecord, Type = index ];

/// DDL Primary Key Specification
Index PKRPTRANSRECORDITEM On RowID [ PrimaryKey, SqlName = PK_RP_TRANSRECORDITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TransRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property IsCancel As %Library.Boolean [ SqlColumnNumber = 5 ];

Property IsArrive As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="RPTransRecordItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransRecordDR</Value>
</Value>
<Value name="3">
<Value>VisitNumberDR</Value>
</Value>
<Value name="4">
<Value>IsCancel</Value>
</Value>
<Value name="5">
<Value>IsArrive</Value>
</Value>
</Data>
<DataLocation>^dbo.RPTransRecordItemD</DataLocation>
<DefaultData>RPTransRecordItemDefaultData</DefaultData>
<IdLocation>^dbo.RPTransRecordItemD</IdLocation>
<IndexLocation>^dbo.RPTransRecordItemI</IndexLocation>
<StreamLocation>^dbo.RPTransRecordItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
