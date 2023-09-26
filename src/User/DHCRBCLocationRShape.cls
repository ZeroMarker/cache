Class User.DHCRBCLocationRShape Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DOS_RowID, SqlTableName = DHCRBC_LocationRShape, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DOS_Loc_DR
Property DOSLocDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DOS_Loc_DR ];

/// DOS_ReportShape_DR
Property DOSReportShapeDR As User.DHCRBCReportShape [ SqlColumnNumber = 3, SqlFieldName = DOS_ReportShape_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBC("Loc-Shape"))</SqlIdExpression>
<SQLMap name="IndexLoc">
<Global>^DHCRBCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DOS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc-Shape"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOS_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DOS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterIndex">
<Data name="DOS_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DOS_ReportShape_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DOS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Loc-Shape"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCLocationRShapeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
