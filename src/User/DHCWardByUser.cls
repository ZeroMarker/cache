Class User.DHCWardByUser Extends %Persistent [ Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = DHCWBU_Rowid, SqlTableName = DHC_WardByUser, StorageStrategy = DHCWardByUserSQLStorage ]
{

/// zhaoxinlong 新建病区维护顺序表按人员 
/// DHCWBU_Date 修改日期
Property DHCWBUDate As %Date [ SqlColumnNumber = 2, SqlFieldName = DHCWBU_Date ];

/// DHCWBU_Ward_dr
Property DHCWBUWarddr As User.PACWard [ SqlColumnNumber = 3, SqlFieldName = DHCWBU_Ward_dr ];

/// DHCWBU_User_dr
Property DHCWBUUserdr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = DHCWBU_User_dr ];

/// DHCWBU_Number 维护顺序
Property DHCWBUNumber As %String [ SqlColumnNumber = 5, SqlFieldName = DHCWBU_Number ];

Storage DHCWardByUserSQLStorage
{
<SqlIdExpression>$i(^DHCWBU)</SqlIdExpression>
<SQLMap name="MasterIndex">
<Data name="DHCWBU_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCWBU_Number">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCWBU_User_dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCWBU_Ward_dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCWBU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCWBU_Row</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCWBU_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="UserIndex">
<Global>^DHCWBU</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"USer"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCWBU_User_dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWBU_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="UserWardIndex">
<Global>^DHCWBU</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"UserWard"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCWBU_User_dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWBU_Ward_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCWBU_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="WardIndex">
<Global>^DHCWBU</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Ward"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCWBU_Ward_dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCWBU_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWardByUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCWBU)
	s oldI = +$g(^mdata("DHCWBU"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCWBU = maxI
	s ^mdata("DHCWBU") = maxI
}

}
