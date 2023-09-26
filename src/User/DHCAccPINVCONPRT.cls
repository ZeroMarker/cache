Class User.DHCAccPINVCONPRT Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ACP_RowID, SqlTableName = DHC_AccPINVCONPRT, StorageStrategy = SQLStorage ]
{

/// ACP_INVPRT_DR
Property ACPINVPRTDR As User.DHCINVPRT [ SqlColumnNumber = 2, SqlFieldName = ACP_INVPRT_DR ];

/// ACP_APINV_DR
Property ACPAPINVDR As User.DHCAccPayINV [ SqlColumnNumber = 3, SqlFieldName = ACP_APINV_DR ];

/// ACP_Note1
Property ACPNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ACP_Note1 ];

/// ACP_Note2
Property ACPNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ACP_Note2 ];

/// ACP_Note3
Property ACPNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ACP_Note3 ];

/// ACP_Note4
Property ACPNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ACP_Note4 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINVPRTCAP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ACP_APINV_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ACP_INVPRT_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ACP_Note1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ACP_Note2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ACP_Note3">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ACP_Note4">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCINVPRTCAP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ACP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ACP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAPINVDR">
<Global>^DHCINVPRTCAPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ACP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"APINVDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ACP_APINV_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ACP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINVPRTDR">
<Global>^DHCINVPRTCAPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ACP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INVPRTDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ACP_INVPRT_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ACP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAccPINVCONPRTS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
