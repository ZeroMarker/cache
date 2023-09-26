Class User.DHCRBCItemCatRShape Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCS_RowID, SqlTableName = DHCRBC_ItemCatRShape, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DCS_ItemCat_DR
Property DCSItemCatDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DCS_ItemCat_DR ];

/// DCS_ReportShape_DR
Property DCSReportShapeDR As User.DHCRBCReportShape [ SqlColumnNumber = 3, SqlFieldName = DCS_ReportShape_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBC("Cat_Shape"))</SqlIdExpression>
<SQLMap name="IndexCat">
<Global>^DHCRBCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cat-Shape"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCS_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DCS_ItemCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCS_ReportShape_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DCS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Cat_Shape"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCItemCatRShapeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
