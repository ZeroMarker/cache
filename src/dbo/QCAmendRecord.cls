///     
Class dbo.QCAmendRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_AmendRecord, StorageStrategy = Default ]
{

/// Foreign Key FKAmendRecordAddUser created via DDL
ForeignKey FKAmendRecordAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AmendRecordAddUser ];

/// Foreign Key FKAmendRecordLiquid created via DDL
ForeignKey FKAmendRecordLiquid(QCAmendLiquidDR) References dbo.BTQCAmendLiquid(PKBTQCAMENDLIQUID) [ SqlName = FK_AmendRecordLiquid ];

/// Foreign Key FKAmendRecordLot created via DDL
ForeignKey FKAmendRecordLot(MaterialLotDR) References dbo.BTQCMaterialLot(PKBTQCMATERIALLOT) [ SqlName = FK_AmendRecordLot ];

/// Foreign Key FKAmendRecordMethod created via DDL
ForeignKey FKAmendRecordMethod(QCAmendMethodDR) References dbo.BTQCAmendMethod(PKBTQCAMENDMETHOD) [ SqlName = FK_AmendRecordMethod ];

/// Foreign Key FKAmendRecordTestCode created via DDL
ForeignKey FKAmendRecordTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_AmendRecordTestCode ];

/// Foreign Key FKAmendRecordUser created via DDL
ForeignKey FKAmendRecordUser(AmendUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AmendRecordUser ];

Index IndexAddDate On (MaterialLotDR, TestCodeDR, LevelNo, AddDate) [ SqlName = Index_AddDate, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Index IndexAmendUser On (AmendUserDR, AmendDate) [ SqlName = Index_AmendUser, Type = index ];

Index IndexMaster On (MaterialLotDR, TestCodeDR, LevelNo, AmendDate, AmendTime) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKQCAMENDRECORD On RowID [ PrimaryKey, SqlName = PK_QC_AMENDRECORD, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MaterialLotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AmendDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AmendTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property QCAmendMethodDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property QCAmendLiquidDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property AmendUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="QCAmendRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MaterialLotDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>LevelNo</Value>
</Value>
<Value name="5">
<Value>AmendDate</Value>
</Value>
<Value name="6">
<Value>AmendTime</Value>
</Value>
<Value name="7">
<Value>QCAmendMethodDR</Value>
</Value>
<Value name="8">
<Value>QCAmendLiquidDR</Value>
</Value>
<Value name="9">
<Value>AmendUserDR</Value>
</Value>
<Value name="10">
<Value>AddDate</Value>
</Value>
<Value name="11">
<Value>AddTime</Value>
</Value>
<Value name="12">
<Value>AddUserDR</Value>
</Value>
<Value name="13">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.QCAmendRecordD</DataLocation>
<DefaultData>QCAmendRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.QCAmendRecordD</IdLocation>
<IndexLocation>^dbo.QCAmendRecordI</IndexLocation>
<StreamLocation>^dbo.QCAmendRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
