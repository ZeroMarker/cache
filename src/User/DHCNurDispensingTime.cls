/// Dispensing Time
Class User.DHCNurDispensingTime Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHC_NurDispensingTime, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Dispensing From Time
Property FromTime As %Library.Time [ SqlColumnNumber = 2 ];

/// Dispensing End Time
Property EndTime As %Library.Time [ SqlColumnNumber = 3 ];

/// Dispensing Batch
Property Batch As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// Dispensing Audit Time
Property AuditTime As %Library.Time [ SqlColumnNumber = 5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCNurDisAud)</SqlIdExpression>
<SQLMap name="Master">
<Data name="AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Batch">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EndTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FromTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCNurDisAud</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCNurDispensingTimeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
