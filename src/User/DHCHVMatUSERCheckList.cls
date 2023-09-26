/// 人员对照表
Class User.DHCHVMatUSERCheckList Extends (%Persistent, User.Abstract) [ SqlRowIdName = USR_RowId, SqlTableName = DHC_HVMat_USERCheckList, StorageStrategy = SQLStorage ]
{

/// 人员id
Property USRSSUSRDR As User.SSUser [ Required, SqlColumnNumber = 2, SqlFieldName = USR_SSUSR_DR ];

/// 人员代码
Property USRSSUSRCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = USR_SSUSRCode ];

/// 人员姓名
Property USRSSUSRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = USR_SSUSRDesc ];

/// 下属医院id
Property USRHospCompDR As User.DHCHospComp [ Required, SqlColumnNumber = 5, SqlFieldName = USR_HospComp_DR ];

/// 下属医院人员代码
Property USRHISUSRCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = USR_HISUSRCode ];

/// 下属医院人员姓名
Property USRHISUSRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = USR_HISUSRDesc ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCHVMUSRL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="USR_HISUSRCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="USR_HISUSRDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="USR_HospComp_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="USR_SSUSRCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="USR_SSUSRDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="USR_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCHVMUSRL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>USR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{USR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHISUSRCODE">
<Global>^DHCHVMUSRL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>USR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HISUSRCODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{USR_HISUSRCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{USR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHOSPUSR">
<Global>^DHCHVMUSRL</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>USR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSPSSUSR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{USR_HospComp_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{USR_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{USR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUSR">
<Global>^DHCHVMUSRL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>USR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{USR_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{USR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUSRCODE">
<Global>^DHCHVMUSRL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>USR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SSUSRCODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{USR_SSUSRCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{USR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>USR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCHVMatUSERCheckListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCHVMUSRL)
	s oldI = +$g(^mdata("DHCHVMUSRL"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCHVMUSRL = maxI
	s ^mdata("DHCHVMUSRL") = maxI
}

}
