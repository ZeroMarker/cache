Class User.DHCINStkContorl Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = INStkTkC_Rowid, SqlTableName = DHC_INStkTkControl, StorageStrategy = SQLStorage ]
{

/// 科室id
Property INStkTkCLocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = INStkTkC_Loc_Dr ];

/// 创建日期
Property INStkTkCCreateDate As %Library.String [ SqlColumnNumber = 3, SqlFieldName = INStkTkC_CreateDate ];

/// 创建人
Property INStkTkCCreateUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = INStkTkC_CreateUser_Dr ];

/// 更新日期
Property INStkTkCUpdateDate As %Library.String [ SqlColumnNumber = 5, SqlFieldName = INStkTkC_UpdateDate ];

/// 更新人
Property INStkTkCUpdateUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = INStkTkC_UpdateUser_Dr ];

/// 开始日期
Property INStkTkCStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = INStkTkC_StartDate ];

/// 截止日期
Property INStkTkCEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = INStkTkC_EndDate ];

/// 开始时间
Property INStkTkCStartTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = INStkTkC_StartTime ];

/// 截止时间
Property INStkTkCEndTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = INStkTkC_EndTime ];

/// 是否有效
Property INStkTkCActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = INStkTkC_Active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINSTKTkCS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INStkTkC_Active">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INStkTkC_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INStkTkC_CreateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INStkTkC_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INStkTkC_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INStkTkC_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INStkTkC_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INStkTkC_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INStkTkC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INStkTkC_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCINSTKTkCS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INStkTkC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{INStkTkC_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INStkTkCLoc">
<Global>^DHCINSTKTkCS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INStkTkC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OperLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INStkTkC_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INStkTkC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INStkTkC_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCINStkTkControlS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINSTKTkCS)
	s oldI = +$g(^mdata("DHCINStkTkControl"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINSTKTkCS = maxI
	s ^mdata("DHCINStkTkControl") = maxI
}

Parameter EXTENTSIZE = 250;

}
