Class User.DHCStkYear Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DhcSy_Rowid, SqlTableName = DHC_StkYear, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDhcStkYearReport As User.DhcStkYearReport [ Cardinality = children, Inverse = StkYrParRef ];

/// Dhcsy_Ctloc_dr
Property DhcsyCtlocdr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = Dhcsy_Ctloc_dr ];

/// DhcSy_FromDate
Property DhcSyFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = DhcSy_FromDate ];

/// DhcSy_ToDate
Property DhcSyToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DhcSy_ToDate ];

/// DhcSy_CreatedDate
Property DhcSyCreatedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DhcSy_CreatedDate ];

/// DhcSy_CreatedUser_Dr
Property DhcSyCreatedUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = DhcSy_CreatedUser_Dr ];

/// DhcSy_LocYear
Property DhcSyLocYear As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = DhcSy_LocYear ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSTKYEAR)</SqlIdExpression>
<SQLMap name="IndexLoc">
<Global>^DHCSTKYEAR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DhcSy_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{Dhcsy_Ctloc_dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DhcSy_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMapDHCSTKYEAR">
<Data name="DhcSy_CreatedDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DhcSy_CreatedUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DhcSy_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DhcSy_LocYear">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DhcSy_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Dhcsy_Ctloc_dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCSTKYEAR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DhcSy_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DhcSy_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCStkYearS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSTKYEAR)
	s oldI = +$g(^mdata("DHCSTKYEAR"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSTKYEAR = maxI
	s ^mdata("DHCSTKYEAR") = maxI
}

}
