Class User.DHCRBCClient Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCC_RowID, SqlTableName = DHCRBC_Client, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DCC_AE
Property DCCAE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DCC_AE ];

/// DCC_IP
Property DCCIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DCC_IP ];

/// DCC_Port
Property DCCPort As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DCC_Port ];

/// DCC_Equipment_DR
Property DCCEquipmentDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DCC_Equipment_DR ];

/// DCC_WorkList
Property DCCWorkList As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DCC_WorkList ];

/// DCC_RegPrintTemplateID
Property DCCRegPrintTemplate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DCC_RegPrintTemplate ];

/// DCC_BookedPrintTemplateID
Property DCCBookedPrintTemplate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DCC_BookedPrintTemplate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBC("Client"))</SqlIdExpression>
<SQLMap name="Datamastermap">
<Data name="DCC_AE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCC_BookedPrintTemplate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCC_Equipment_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCC_IP">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCC_Port">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DCC_RegPrintTemplate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DCC_WorkList">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DCC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Client"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAE">
<Global>^DHCRBCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Client"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCC_AE}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexequipment">
<Global>^DHCRBCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Client"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equipment"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCC_Equipment_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCClientS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
