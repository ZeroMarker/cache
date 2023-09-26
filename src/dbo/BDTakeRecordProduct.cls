Class dbo.BDTakeRecordProduct Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_TakeRecordProduct, StorageStrategy = Default ]
{

/// Foreign Key FKBDTRComComponents created via DDL
ForeignKey FKBDTRProduct(ReqProductDR) References dbo.BBReqProduct(PKBBREQPRODUCT) [ SqlName = FK_BD_TR_ReqProduct ];

/// Foreign Key FKBDTRComTakeRecord created via DDL
ForeignKey FKBDTRProTakeRecord(TakeRecordDR) References dbo.BDTakeRecord(PKBDTAKERECORD) [ SqlName = FK_BD_TRPro_TakeRecord ];

/// Foreign Key FKBDRFPBloodGroup created via DDL
ForeignKey FKBDTAKPBloodGroup(BloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_TRPro_BloodGroup ];

Index IndexMaster On (TakeRecordDR, ReqProductDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDTAKERECORDPRODUCT On RowID [ PrimaryKey, SqlName = PK_BD_TAKERECORDPRODUCT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TakeRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReqProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Volume As %Library.Float [ Required, SqlColumnNumber = 5 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property Units As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BDTakeRecordProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TakeRecordDR</Value>
</Value>
<Value name="3">
<Value>ReqProductDR</Value>
</Value>
<Value name="4">
<Value>Volume</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
<Value name="6">
<Value>Units</Value>
</Value>
<Value name="7">
<Value>BloodGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDTakeRecordProductD</DataLocation>
<DefaultData>BDTakeRecordProductDefaultData</DefaultData>
<IdLocation>^dbo.BDTakeRecordProductD</IdLocation>
<IndexLocation>^dbo.BDTakeRecordProductI</IndexLocation>
<StreamLocation>^dbo.BDTakeRecordProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
