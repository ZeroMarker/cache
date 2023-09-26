Class User.PHCDMPOISONLINK Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHC_DMPOLink_RowID, SqlTableName = PHC_DMPoisonLink, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property PHCDMLDRGMASTDR As PHCPoison [ SqlColumnNumber = 2, SqlFieldName = PHCDML_DRGMAST_DR ];

Property PHCDMLPHCPODR As PHCPoison [ SqlColumnNumber = 3, SqlFieldName = PHCDML_PHCPO_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PHCDMPOL)</SqlIdExpression>
<SQLMap name="IndexPHCDMastDR">
<Global>^PHCDMPOL</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DMPOISON"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCDML_DRGMAST_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHC_DMPOLink_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHCDMPOLMaster">
<Data name="PHCDML_DRGMAST_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCDML_PHCPO_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PHCDMPOL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHC_DMPOLink_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHC_DMPOLink_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PHCDMPOISONLINKS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
