Class User.DHCCRMCallbackSend Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CBS_RowId, SqlTableName = DHC_CRM_CallbackSend, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CBS_PAADM_DR
Property CBSPAADMDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = CBS_PAADM_DR ];

/// CBS_SendDate
Property CBSSendDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 3, SqlFieldName = CBS_SendDate ];

/// CBS_SendTime
Property CBSSendTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = CBS_SendTime ];

/// CBS_SendStatus
Property CBSSendStatus As %Library.String(DISPLAYLIST = ",S,F", MAXLEN = 1, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Success,Fail") [ SqlColumnNumber = 5, SqlFieldName = CBS_SendStatus ];

/// CBS_SendMode
Property CBSSendMode As %Library.String(DISPLAYLIST = ",SMS,EMAIL", MAXLEN = 5, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",SMS,EMAIL") [ SqlColumnNumber = 6, SqlFieldName = CBS_SendMode ];

/// CBS_SendUser_DR
Property CBSSendUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = CBS_SendUser_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCRMCBS)</SqlIdExpression>
<SQLMap name="DataMasterDHCCRMCBS">
<Data name="CBS_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CBS_SendDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CBS_SendMode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CBS_SendStatus">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CBS_SendTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CBS_SendUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCCRMCBS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CBS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CBS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^DHCCRMCBS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CBS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CBS_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CBS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSendDateTime">
<Global>^DHCCRMCBS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CBS_RowId</Field>
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
<Expression>{CBS_SendDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CBS_SendTime}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CBS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSendStatus">
<Global>^DHCCRMCBS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CBS_RowId</Field>
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
<Expression>{CBS_SendStatus}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CBS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSendUser">
<Global>^DHCCRMCBS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CBS_RowId</Field>
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
<Expression>{CBS_SendUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CBS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCRMCallbackSendS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
