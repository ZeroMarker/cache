///     
Class dbo.RILabOPRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Final, Owner = {daiyi}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RI_LabOPRecord ]
{

// Property RowId As %Library.BigInt(MINVAL = 1) [ Identity, Required, SqlColumnNumber = 2 ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BarCode As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property OperateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property OperateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property OperateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property OperateTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property OperateNotes As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 8 ];

Property OperateIP As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 9 ];

Property OperateAddress As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 10 ];

Property VisitNumberRecordID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// DDL Primary Key Specification
Index RILabOPRecord On RowID [ PrimaryKey, SqlName = PK_RI_LabOPRecord, Type = index, Unique ];

Index IndexMaster On (BarCode, OperateDate, OperateTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexOperateDate On (OperateTypeDR, OperateDate) [ SqlName = Index_OperateDate, Type = index ];

Index IndexOperateType On (BarCode, OperateTypeDR) [ SqlName = Index_OperateType, Type = index ];

/// Foreign Key FKRILabOPRecordOperateUser created via DDL
ForeignKey FKRILabOPRecordOperateUser(OperateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RILabOPRecordOperateUser ];

/// Foreign Key FKRILabOPRecordOperatorType created via DDL
ForeignKey FKRILabOPRecordOperatorType(OperateTypeDR) References dbo.BTOperatorType(PKBTOPERATORTYPE) [ SqlName = FK_RILabOPRecordOperatorType ];

Storage Default
{
<Data name="RILabOPRecordDefaultData">
<Value name="1">
<Value>BarCode</Value>
</Value>
<Value name="2">
<Value>OperateDate</Value>
</Value>
<Value name="3">
<Value>OperateTime</Value>
</Value>
<Value name="4">
<Value>OperateUserDR</Value>
</Value>
<Value name="5">
<Value>OperateTypeDR</Value>
</Value>
<Value name="6">
<Value>OperateNotes</Value>
</Value>
<Value name="7">
<Value>OperateIP</Value>
</Value>
<Value name="8">
<Value>OperateAddress</Value>
</Value>
<Value name="9">
<Value>VisitNumberRecordID</Value>
</Value>
</Data>
<DataLocation>^dbo.RILabOPRecordD</DataLocation>
<DefaultData>RILabOPRecordDefaultData</DefaultData>
<IdFunction>sequence</IdFunction>
<IdLocation>^dbo.RILabOPRecordD</IdLocation>
<IndexLocation>^dbo.RILabOPRecordI</IndexLocation>
<StreamLocation>^dbo.RILabOPRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
