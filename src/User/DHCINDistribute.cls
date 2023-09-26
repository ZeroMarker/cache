Class User.DHCINDistribute Extends (%Persistent, User.Abstract) [ SqlRowIdName = DSTR_RowId, SqlTableName = DHC_INDistribute, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCINDistributeItm As User.DHCINDistributeItm [ Cardinality = children, Inverse = DSTRIDSTRParRef ];

Property DSTRCTLOCDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DSTR_CTLOC_DR ];

Property DSTRSSUSRDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = DSTR_SSUSR_DR ];

Property DSTRSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 4, SqlFieldName = DSTR_SCG_DR ];

Property DSTRDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = DSTR_Date ];

Property DSTRTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = DSTR_Time ];

Property DSTRNo As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DSTR_No ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCINDSTR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DSTR_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSTR_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSTR_No">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DSTR_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DSTR_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSTR_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCINDSTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DSTR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DSTR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocDate">
<Global>^DHCINDSTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DSTR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSTR_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSTR_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCINDSTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{DSTR_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSTR_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DSTR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCINDistributeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINDSTR)
	s oldI = +$g(^mdata("DHCINDISTRIBUTE"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINDSTR = maxI
	s ^mdata("DHCINDISTRIBUTE") = maxI
}

}
