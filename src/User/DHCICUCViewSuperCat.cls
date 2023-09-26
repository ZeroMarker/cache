/// DHC_ICUC_ViewSuperCat
Class User.DHCICUCViewSuperCat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ICUCVSC_RowId, SqlTableName = DHC_ICUC_ViewSuperCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ICUCVSC_Code
Property ICUCVSCCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ICUCVSC_Code ];

/// ICUCVSC_Desc
Property ICUCVSCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ICUCVSC_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCICUC("VSCat",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICUCVSC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUCVSC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCICUC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ICUCVSC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"VSCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ICUCVSC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCICUC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ICUCVSC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"VSCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUCVSC_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICUCVSC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCICUCViewSuperCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
