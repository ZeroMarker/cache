Class User.DHCItmDocStorage Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DOCI_RowId, SqlTableName = DHC_ItmDocStorage, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property DOCIINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = DOCI_INCI_DR ];

Property DOCINAME As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DOCI_NAME ];

Property DOCITYPE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DOCI_Type ];

/// 关键字
Property DOCIKeyWord As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DOCI_KeyWord ];

/// 文件原始名称
Property DOCIFileName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DOCI_FileName ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCITMDOC)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DOCI_FileName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DOCI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DOCI_KeyWord">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DOCI_NAME">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DOCI_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCITMDOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DOCI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DOCI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDocName">
<Global>^DHCITMDOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DOCI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TypeName"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DOCI_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DOCI_NAME}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DOCI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDOCI">
<Global>^DHCITMDOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DOCI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DOCI_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DOCI_Type}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DOCI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCItmDocStorageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCITMDOC)
	s oldI = +$g(^mdata("DHCITMDOC"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCITMDOC = maxI
	s ^mdata("DHCITMDOC") = maxI
}

}
