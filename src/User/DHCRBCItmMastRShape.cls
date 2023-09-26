Class User.DHCRBCItmMastRShape Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DIS_RowID, SqlTableName = DHCRBC_ItmMastRShape, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DIS_ItmMast_DR
Property DISItmMastDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DIS_ItmMast_DR ];

/// DIS_ReportShape_DR
Property DISReportShapeDR As User.DHCRBCReportShape [ SqlColumnNumber = 3, SqlFieldName = DIS_ReportShape_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBC("Itm_Shape"))</SqlIdExpression>
<SQLMap name="IndexItMast">
<Global>^DHCRBCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DIS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItMast-Shape"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIS_ItmMast_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DIS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DIS_ItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DIS_ReportShape_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DIS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Itm_Shape"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCItmMastRShapeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
