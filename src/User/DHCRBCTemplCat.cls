Class User.DHCRBCTemplCat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DMC_RowID, SqlTableName = DHCRBC_TemplCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DMC_Code
Property DMCCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DMC_Code ];

/// DMC_Desc
Property DMCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DMC_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCTempl("TemplCat"))</SqlIdExpression>
<SQLMap name="DataMasterIndex">
<Data name="DMC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DMC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCTempl</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DMC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TemplCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DMC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCTemplCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
