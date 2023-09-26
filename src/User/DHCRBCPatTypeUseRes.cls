Class User.DHCRBCPatTypeUseRes Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DPTR_RowID, SqlTableName = DHCRBC_PatTypeUseRes, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DPTR_PatTYpeCode
Property DPTRPatTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DPTR_PatTypeCode ];

/// DPTR_ServiceGroup_DR
Property DPTRServiceGroupDR As User.RBCServiceGroup [ SqlColumnNumber = 3, SqlFieldName = DPTR_ServiceGroup_DR ];

/// DPTR_Resource_DR
Property DPTRResourceDR As User.RBResource [ SqlColumnNumber = 4, SqlFieldName = DPTR_Resource_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCPatTypeUseResource)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCRBCPatTypeUseResourcei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DPTR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TYPECODE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DPTR_PatTypeCode}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DPTR_Resource_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DPTR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DPTR_PatTypeCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DPTR_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DPTR_ServiceGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCPatTypeUseResource</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DPTR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DPTR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCPatTypeUseResS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
