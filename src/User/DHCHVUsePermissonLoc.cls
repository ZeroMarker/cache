Class User.DHCHVUsePermissonLoc Extends (%Persistent, User.Abstract) [ SqlRowIdName = HUPL_Rowid, SqlTableName = DHC_HVUsePermisson_Loc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCHVUsePermissonLocUser As User.DHCHVUsePermissonLocUser [ Cardinality = children, Inverse = HUPLUHuplParref ];

/// 科室id
Property HUPLLocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = HUPL_Loc_Dr ];

/// 创建日期
Property HUPLCreateDate As %Library.String [ SqlColumnNumber = 3, SqlFieldName = HUPL_CreateDate ];

/// 创建人
Property HUPLCreateUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = HUPL_CreateUser_Dr ];

/// 更新日期
Property HUPLUpdateDate As %Library.String [ SqlColumnNumber = 5, SqlFieldName = HUPL_UpdateDate ];

/// 更新人
Property HUPLUpdateUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = HUPL_UpdateUser_Dr ];

/// 开始日期
Property HUPLStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = HUPL_StartDate ];

/// 截止日期
Property HUPLEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = HUPL_EndDate ];

/// 开始时间
Property HUPLStartTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = HUPL_StartTime ];

/// 截止时间
Property HUPLEndTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = HUPL_EndTime ];

/// 是否有效
Property HUPLActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = HUPL_Active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCHUPL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HUPL_Active">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HUPL_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HUPL_CreateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HUPL_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HUPL_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HUPL_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HUPL_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HUPL_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HUPL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HUPL_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCHUPL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>HUPL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{HUPL_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="HUPLLoc">
<Global>^DHCHUPL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HUPL_Rowid</Field>
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
<Expression>{HUPL_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HUPL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HUPL_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCHVUsePermissonLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCHUPL)
	s oldI = +$g(^mdata("DHCHVUSEPERMISSONLOC"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCHUPL = maxI
	s ^mdata("DHCHVUSEPERMISSONLOC") = maxI
}

}
