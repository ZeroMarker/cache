Class User.DHCSTLocRelation Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCLocRel_RowID, SqlTableName = DHCST_LocRelation, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCSTLocRelationItm As User.DHCSTLocRelationItm [ Cardinality = children, Inverse = LRELILRELParRef ];

Property DHCLocRelPlocdr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DHCLocRel_Ploc_dr ];

Property DHCLocRelRlocdr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DHCLocRel_Rloc_dr ];

Property DHCLocType As %Library.String [ SqlColumnNumber = 4, SqlFieldName = DHCLocRel_Type ];

Property DHCLocAutoRecFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DHCLocRel_AutoRecFlag ];

Property DHCLocAutoClearFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DHCLocRel_AutoClearFlag ];

/// 限制类型(仅限制/仅不限制)
Property DHCLocLimitType As %Library.String(DISPLAYLIST = ",Permit,NotAllowed", MAXLEN = 10, SELECTIVITY = "33.3333%", VALUELIST = ",P,NA") [ SqlColumnNumber = 7, SqlFieldName = DHCLocRel_LimitType ];

/// 默认转移出库类型
Property DHCLocRelOpertId As %Library.String [ SqlColumnNumber = 8, SqlFieldName = DHCLocRel_OpertId ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCLOCREL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCLocRel_AutoClearFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCLocRel_AutoRecFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCLocRel_LimitType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCLocRel_OpertId">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCLocRel_Ploc_dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCLocRel_Rloc_dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCLocRel_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCLOCREL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCLocRel_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCLocRel_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPLOCREL">
<Global>^DHCLOCREL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCLocRel_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PLOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCLocRel_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCLocRel_Ploc_dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCLocRel_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPRLOCREL">
<Global>^DHCLOCREL</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCLocRel_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRLOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCLocRel_Rloc_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCLocRel_Ploc_dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCLocRel_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTruePRLOCREL">
<Global>^DHCLOCREL</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCLocRel_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TruePRLOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCLocRel_Ploc_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCLocRel_Rloc_dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCLocRel_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexRLOCREL">
<Global>^DHCLOCREL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCLocRel_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RLOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCLocRel_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCLocRel_Rloc_dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCLocRel_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCSTLocRelationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCLOCREL)
	s oldI = +$g(^mdata("DHCCTLOCREL"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCLOCREL = maxI
	s ^mdata("DHCCTLOCREL") = maxI
}

}
