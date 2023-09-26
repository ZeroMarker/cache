Class User.DHCRBOrderTemplate Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DOT_RowID, SqlTableName = DHCRB_OrderTemplate, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DOT_Name
Property DOTName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DOT_Name ];

/// DOT_SeeDesc
Property DOTSeeDesc As list Of %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DOT_SeeDesc, SqlListType = SUBNODE ];

/// DOT_ResultDesc
Property DOTResultDesc As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DOT_ResultDesc ];

/// DOT_Order_DR
Property DOTItmMastDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DOT_ItmMast_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBOrdTemp(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DOT_ItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DOT_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DOT_ResultDesc">
<Node>"ResultDesc"</Node>
</Data>
<Data name="DOT_SeeDesc">
<Node>"SeeDesc"</Node>
</Data>
<Global>^DHCRBOrdTemp</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DOT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ItmMast"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItmMast">
<Global>^DHCRBOrdTempi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DOT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ArcItmMast"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOT_ItmMast_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBOrderTemplateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
