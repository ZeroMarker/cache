Class User.DHCCRMBirthSend Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BS_RowId, SqlTableName = DHC_CRM_BirthSend, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BS_PAPMI_DR
Property BSPAPMIDR As User.PAPatMas [ Required, SqlColumnNumber = 2, SqlFieldName = BS_PAPMI_DR ];

/// BS_SendDate
Property BSSendDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = BS_SendDate ];

/// BS_SendTime
Property BSSendTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = BS_SendTime ];

/// BS_SendStatus
Property BSSendStatus As %Library.String(DISPLAYLIST = ",S,F", MAXLEN = 1, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Success,Fail") [ SqlColumnNumber = 5, SqlFieldName = BS_SendStatus ];

/// BS_SendMode
Property BSSendMode As %Library.String(DISPLAYLIST = ",SMS,EMAIL", MAXLEN = 5, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",SMS,EMAIL") [ SqlColumnNumber = 6, SqlFieldName = BS_SendMode ];

/// BS_SendUser_DR
Property BSSendUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = BS_SendUser_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCRMBS)</SqlIdExpression>
<SQLMap name="DataMasterDHCCRMBS">
<Data name="BS_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BS_SendDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BS_SendMode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BS_SendStatus">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BS_SendTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BS_SendUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCCRMBS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPAPMI">
<Global>^DHCCRMBS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BS_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BS_SendDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BS_SendTime}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{BS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSendDateTime">
<Global>^DHCCRMBS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SendDateTime"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BS_SendDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BS_SendTime}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSendStatus">
<Global>^DHCCRMBS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SendStatus"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BS_SendStatus}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSendUser">
<Global>^DHCCRMBS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SendUser"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BS_SendUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCRMBirthSendS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
