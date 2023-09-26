Class User.DHCEQChangeStock Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CS_RowID, SqlTableName = DHC_EQChangeStock, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CS_EquipDR
Property CSEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = CS_EquipDR ];

/// CS_FromLocDR
Property CSFromLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CS_FromLocDR ];

/// CS_ToLocDR
Property CSToLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CS_ToLocDR ];

/// CS_SourceID
Property CSSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CS_SourceID ];

/// CS_ChangeType
Property CSChangeType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CS_ChangeType ];

/// CS_ChangeDate
Property CSChangeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = CS_ChangeDate ];

/// CS_AuditUserDR
Property CSAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CS_AuditUserDR ];

/// CS_AuditDate
Property CSAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = CS_AuditDate ];

/// CS_BillChangeDate
Property CSBillChangeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = CS_BillChangeDate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQChangeStock("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CS_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CS_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CS_BillChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CS_ChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CS_ChangeType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CS_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CS_FromLocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CS_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CS_ToLocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQChangeStock</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQChangeStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CS_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFromLoc">
<Global>^DHCEQChangeStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FromLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CS_FromLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQChangeStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CS_ChangeType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CS_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexToLoc">
<Global>^DHCEQChangeStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ToLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CS_ToLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQChangeStockS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
