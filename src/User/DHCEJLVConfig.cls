Class User.DHCEJLVConfig Extends (%Persistent, User.Abstract) [ SqlRowIdName = LVC_RowId, SqlTableName = DHC_EJLVConfig, StorageStrategy = SQLStorage ]
{

Property LVCInciDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = LVC_InciDR ];

Property LVCLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = LVC_CTLocDR ];

Property LVCNumber As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = LVC_Number ];

Property LVCScg As User.DHCStkCatGroup [ SqlColumnNumber = 5, SqlFieldName = LVC_ScgDr ];

Property LVCScgCat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = LVC_Cat ];

Property LVCSortNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = LVC_SortNum ];

/// 单次限量
Property LVCLimQty As %Library.Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 8, SqlFieldName = LVC_LimQty ];

/// 月限量
Property LVCMonLimQty As %Library.Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 9, SqlFieldName = LVC_MonLimQty ];

/// 月累计
Property LVCMonSumQty As %Library.Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 10, SqlFieldName = LVC_MonSumQty ];

/// 启用限量控制
Property LVCConQty As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = LVC_ConQty ];

/// 总累计量
Property LVCSumQty As %Library.Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 12, SqlFieldName = LVC_SumQty ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEJLVCONFIG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LVC_CTLocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LVC_Cat">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LVC_ConQty">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="LVC_InciDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LVC_LimQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LVC_MonLimQty">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LVC_MonSumQty">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="LVC_Number">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LVC_ScgDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LVC_SortNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LVC_SumQty">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCEJLVCONFIG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LVC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LVC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndescLocScg">
<Global>^DHCEJLVCONFIG</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>LVC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SCG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LVC_ScgDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LVC_CTLocDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LVC_InciDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LVC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocInci">
<Global>^DHCEJLVCONFIG</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LVC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LVC_CTLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LVC_InciDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LVC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LVC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCEJITMConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCEJLVCONFIG)
	s oldI = +$g(^mdata("DHCEJLVCONFIG"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCEJLVCONFIG = maxI
	s ^mdata("DHCEJLVCONFIG") = maxI
}

}
