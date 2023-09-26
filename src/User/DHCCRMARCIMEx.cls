Class User.DHCCRMARCIMEx Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AE_RowId, SqlTableName = DHC_CRM_ARCIMEx, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AE_ARCIM_DR
Property AEARCIMDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = AE_ARCIM_DR ];

/// AE_MajorDiseases
Property AEMajorDiseases As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = AE_MajorDiseases ];

/// AE_SendAllRlt
Property AESendAllRlt As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = AE_SendAllRlt ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCRMARCIMEx)</SqlIdExpression>
<SQLMap name="DataMasterDHCCRMARCIME">
<Data name="AE_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AE_MajorDiseases">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AE_SendAllRlt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCRMARCIMEx</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^DHCCRMARCIMEx</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AE_ARCIM_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AE_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCRMARCIMExS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
