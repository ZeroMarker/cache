Class User.DHCReasonForTrfIn Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCRFTI_RowID, SqlTableName = DHC_ReasonForTrfIn, StorageStrategy = SQLStorage ]
{

/// DHCRFTI_Desc
Property DHCRFTIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHCRFTI_Desc ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DHCRFTI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCRFTI_RowID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCSTREASON</Global>
<RowIdSpec name="1">
<Expression>L2</Expression>
<Field>DHCRFTI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"TRFI"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{DHCRFTI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCReasonForTrfInS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
