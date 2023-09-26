Class User.PIVALocBat Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PLBAT_RowID, SqlTableName = PIVA_LocBat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildPIVALocBatCubage As User.PIVALocBatCubage [ Cardinality = children, Inverse = PLBATCUParrefDR ];

Relationship ChildPIVALocBatItm As User.PIVALocBatItm [ Cardinality = children, Inverse = PLBATILBParref ];

Relationship ChildPIVALocBatSort As User.PIVALocBatSort [ Cardinality = children, Inverse = PLBATSLBParref ];

/// PLBAT_Loc_DR
Property PLBATLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = PLBAT_Loc_DR ];

/// PLBAT_Ward_DR
Property PLBATWardDR As User.PACWard [ SqlColumnNumber = 3, SqlFieldName = PLBAT_Ward_DR ];

/// PLBAT_Order 病区序号
Property PLBATOrder As %Library.String [ SqlColumnNumber = 4, SqlFieldName = PLBAT_Order ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PIVALBAT)</SqlIdExpression>
<SQLMap name="IndexLoc">
<Global>^PIVALBAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PLBAT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PLBAT_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PLBAT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocWard">
<Global>^PIVALBAT</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocWard"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PLBAT_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PLBAT_Ward_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PLBAT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrder">
<Global>^PIVALBAT</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Order"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PLBAT_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PLBAT_Order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PLBAT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWard">
<Global>^PIVALBAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PLBAT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Ward"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PLBAT_Ward_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PLBAT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="PLBAT_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PLBAT_Order">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PLBAT_Ward_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PIVALBAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PLBAT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PLBAT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PIVALocBatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
