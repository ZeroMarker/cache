Class dbo.BDTakeRecordPack Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_TakeRecordPack, StorageStrategy = Default ]
{

/// Foreign Key FKBDRFIRReqForm created via DDL
ForeignKey FKBDTRPTakeRecord(TakeRecordDR) References dbo.BDTakeRecord(PKBDTAKERECORD) [ SqlName = FK_BD_TRP_TakeRecord ];

/// Foreign Key FKBDRFIRTestItem created via DDL
ForeignKey FKBDTRPPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_TRP_Pack ];

Index IndexMaster On (TakeRecordDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

/// DDL Primary Key Specification
Index PKBDTAKERECORDPACK On RowID [ PrimaryKey, SqlName = PK_BD_TAKERECORDPACK, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 取血单  
Property TakeRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 血袋信息  
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BDTakeRecordPackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TakeRecordDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDTakeRecordPackD</DataLocation>
<DefaultData>BDTakeRecordPackDefaultData</DefaultData>
<IdLocation>^dbo.BDTakeRecordPackD</IdLocation>
<IndexLocation>^dbo.BDTakeRecordPackI</IndexLocation>
<StreamLocation>^dbo.BDTakeRecordPackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
