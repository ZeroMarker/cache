Class User.PHRRefuseReason Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Refuse_Rowid, SqlTableName = PHR_RefuseReason, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHRRefuse_Code
Property RefuseCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Refuse_Code ];

/// PHRRefuse_Desc
Property RefuseDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Refuse_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PHRREFUSE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Refuse_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Refuse_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PHRREFUSE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Refuse_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Refuse_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Indexcode">
<Global>^PHRREFUSE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{Refuse_Rowi</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({Refuse_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Refuse_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexdesc">
<Global>^PHRREFUSE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{Refuse_Rowi</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Refuse_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Refuse_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHRRefuseReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^PHRREFUSE)
	s oldI = +$g(^mdata("PHRRefuseReason"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^PHRREFUSE = maxI
	s ^mdata("PHRRefuseReason") = maxI
}

}
