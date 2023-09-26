Class User.DHCBankCheckSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BCS_Rowid, SqlTableName = DHC_BankCheckSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On BCSChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_BankCheck Parent Reference
Relationship BCSParRef As User.DHCBankCheck [ Cardinality = parent, Inverse = ChildDHCBankCheckSub, Required, SqlFieldName = BCS_ParRef ];

/// New Key
Property BCSChildSub As %Library.Float(MINVAL = 1) [ InitialExpression = {$i(^DHCRB($p(%d(0),$c(1)),0))}, SqlColumnNumber = 2, SqlFieldName = BCS_ChildSub ];

/// BCS_PatientID
Property BCSPatientID As User.PAPatMas [ SqlColumnNumber = 3, SqlFieldName = BCS_PatientID ];

/// BCS_ApptId
Property BCSApptId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BCS_ApptId ];

/// BCS_PayFee
Property BCSPayFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BCS_PayFee ];

/// BCS_PayFlag
Property BCSPayFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = BCS_PayFlag ];

/// BCS_TransactionId
Property BCSTransactionId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BCS_TransactionId ];

/// BCS_OperType
Property BCSOperType As %Library.String(DISPLAYLIST = ",Appt,CancelAppt,Pay,CancelPay", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ Required, SqlColumnNumber = 8, SqlFieldName = BCS_OperType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexMasterData">
<Data name="BCS_ApptId">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BCS_OperType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BCS_PatientID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BCS_PayFee">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BCS_PayFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BCS_TransactionId">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCBC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_BankCheck.BC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>BCS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_BankCheck.BC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{BCS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPatientIDData">
<Global>^DHCBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_BankCheck.BC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>BCS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PatientID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BCS_PatientID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_BankCheck.BC_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BCS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCBankCheckSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
