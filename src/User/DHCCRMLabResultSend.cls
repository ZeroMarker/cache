Class User.DHCCRMLabResultSend Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LRS_RowId, SqlTableName = DHC_CRM_LabResultSend, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// LRS_OEORI_DR
Property LRSOEORIDR As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = LRS_OEORI_DR ];

/// LRS_SendDate
Property LRSSendDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 3, SqlFieldName = LRS_SendDate ];

/// LRS_SendTime
Property LRSSendTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = LRS_SendTime ];

/// LRS_SendStatus
Property LRSSendStatus As %Library.String(DISPLAYLIST = ",S,F", MAXLEN = 1, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Success,Fail") [ SqlColumnNumber = 5, SqlFieldName = LRS_SendStatus ];

/// LRS_SendMode
Property LRSSendMode As %Library.String(DISPLAYLIST = ",SMS,EMAIL", MAXLEN = 5, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",SMS,EMAIL") [ SqlColumnNumber = 6, SqlFieldName = LRS_SendMode ];

/// LRS_SendUser_DR
Property LRSSendUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = LRS_SendUser_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCRMLRS)</SqlIdExpression>
<SQLMap name="DataMasterDHCCRMLRS">
<Data name="LRS_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LRS_SendDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LRS_SendMode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LRS_SendStatus">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LRS_SendTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LRS_SendUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCCRMLRS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LRS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{LRS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DHCCRMLRS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LRS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LRS_OEORI_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{LRS_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{LRS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSendDateTime">
<Global>^DHCCRMLRS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LRS_RowId</Field>
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
<Expression>{LRS_SendDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{LRS_SendTime}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{LRS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSendStatus">
<Global>^DHCCRMLRS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LRS_RowId</Field>
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
<Expression>{LRS_SendStatus}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{LRS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSendUser">
<Global>^DHCCRMLRS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LRS_RowId</Field>
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
<Expression>{LRS_SendUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{LRS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCRMLabResultSendS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
