Class User.DHCEmConsWorkFlow Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsWorkFlow, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCEMCONSFLOWITM As User.DHCEmConsWorkFlowItem [ Cardinality = children, Inverse = ECParRefDr ];

/// Code EC_Code
Property ECCode As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = EC_Code ];

/// 名称 EC_Desc
Property ECDesc As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = EC_Desc ];

/// 名称 EC_Hosp_Dr
Property ECHospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = EC_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMCONWF)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEMCONWF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEMCONWF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsWorkFlowS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
