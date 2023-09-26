Class User.DHCSubLocStkTk Extends (%Persistent, User.Abstract) [ SqlRowIdName = SUBST_RowId, SqlTableName = DHC_SubLocStkTk, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCSubLocStkTkItm As DHCSubLocStkTkItm [ Cardinality = children, Inverse = SUBSTISUBSTParref ];

Property SUBSTNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SUBST_No ];

Property SUBSTCreateDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = SUBST_CreateDate ];

Property SUBSTCreateTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = SUBST_CreateTime ];

Property SUBSTCreateUserDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = SUBST_CreateUser_DR ];

/// 制单科室
Property SUBSTCreateLocDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = SUBST_CreateLoc_DR ];

/// 盘点科室
Property SUBSTCTLocDR As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = SUBST_CTLoc_DR ];

Property SUBSTSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 8, SqlFieldName = SUBST_SCG_DR ];

Property SUBSTINCSCDR As User.INCStkCat [ SqlColumnNumber = 9, SqlFieldName = SUBST_INCSC_DR ];

/// 单据完成
Property SUBSTCompleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = SUBST_Completed ];

Property SUBSTINADDR As User.DHCINAdj [ SqlColumnNumber = 11, SqlFieldName = SUBST_INAD_DR ];

Property SUBSTRemarks As list Of %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = SUBST_Remarks, SqlListType = SUBNODE ];

/// 实盘完成
Property SUBSTCountCompleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = SUBST_CountCompleted ];

/// 调整完成
Property SUBSTAdjCompleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = SUBST_AdjCompleted ];

/// 器械管理类别
Property SUBSTSupervision As %String [ SqlColumnNumber = 15, SqlFieldName = SUBST_Supervision ];

Index SUBSTNoUnqIdx On SUBSTNo [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSLST)</SqlIdExpression>
<SQLMap name="IndexCreateLoc">
<Global>^DHCSLST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SUBST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"CreateLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SUBST_CreateLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{SUBST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINADJ">
<Global>^DHCSLST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SUBST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INADJ"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SUBST_INAD_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{SUBST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStkTkLoc">
<Global>^DHCSLST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SUBST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SUBST_CTLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{SUBST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="SUBST_AdjCompleted">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SUBST_CTLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SUBST_Completed">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SUBST_CountCompleted">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SUBST_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SUBST_CreateLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SUBST_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SUBST_CreateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SUBST_INAD_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SUBST_INCSC_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SUBST_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUBST_Remarks">
<Delimiter>"^"</Delimiter>
<Node>"REM"</Node>
</Data>
<Data name="SUBST_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SUBST_Supervision">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCSLST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SUBST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{SUBST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SUBST_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSubLocStkTkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSLST)
	s oldI = +$g(^mdata("DHCSLST"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSLST = maxI
	s ^mdata("DHCSLST") = maxI
}

Parameter EXTENTSIZE = 250;

}
