Class User.DHCPESendMessage Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SM_RowId, SqlTableName = DHC_PE_SendMessage, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPESendMessage";

Parameter EXTENTSIZE = 250;

/// SM_Message
Property SMMessage As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SM_Message ];

/// SM_Mobile
Property SMMobile As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SM_Mobile ];

/// SM_ReceiveID
Property SMReceiveID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SM_ReceiveID ];

/// SM_ReceiveName
Property SMReceiveName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SM_ReceiveName ];

/// SM_ReceiveType
Property SMReceiveType As %Library.String(MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",G,I,PG,PI") [ SqlColumnNumber = 7, SqlFieldName = SM_ReceiveType ];

/// SM_Remark
Property SMRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = SM_Remark ];

/// SM_SendDate
Property SMSendDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = SM_SendDate ];

/// SM_SendTime
Property SMSendTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = SM_SendTime ];

/// SM_SendUser_DR
Property SMSendUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SM_SendUser_DR ];

/// SM_Status
Property SMStatus As %Library.String(DISPLAYLIST = ",Success,Failed", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",S,F") [ SqlColumnNumber = 9, SqlFieldName = SM_Status ];

/// SM_Type
Property SMType As %Library.String(DISPLAYLIST = ",ShortMessage", MAXLEN = 12, SELECTIVITY = "50.0000%", TRUNCATE = 1, VALUELIST = ",SM") [ SqlColumnNumber = 3, SqlFieldName = SM_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPESM("0"))</SqlIdExpression>
<SQLMap name="DataMasterDHCPESM">
<Data name="SM_Message">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SM_Mobile">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SM_ReceiveID">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SM_ReceiveName">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SM_ReceiveType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SM_SendDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SM_SendTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SM_SendUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SM_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SM_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPESM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SM_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexReceive">
<Global>^DHCPESM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ReceiveType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SM_ReceiveType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"ReceiveID"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SM_ReceiveID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{SM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSendDate">
<Global>^DHCPESM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SendDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SM_SendDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPESendMessageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
