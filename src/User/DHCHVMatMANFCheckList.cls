/// 生产厂家对照表 DHC_HVMat_MANFCheckList
Class User.DHCHVMatMANFCheckList Extends (%Persistent, User.Abstract) [ SqlRowIdName = MF_RowId, SqlTableName = DHC_HVMat_MANFCheckList, StorageStrategy = SQLStorage ]
{

/// 生产厂家id
Property MFMANFDR As User.PHManufacturer [ Required, SqlColumnNumber = 2, SqlFieldName = MF_MANF_DR ];

/// 生产厂家代码
Property MFMANFCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MF_MANFCode ];

/// 生产厂家名称
Property MFMANFDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MF_MANFDesc ];

/// 下属医院id
Property MFHospCompDR As User.DHCHospComp [ Required, SqlColumnNumber = 5, SqlFieldName = MF_HospComp_DR ];

/// 下属医院生产厂家代码
Property MFHISMANFCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MF_HISMANFCode ];

/// 下属医院生产厂家名称
Property MFHISMANFDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MF_HISMANFDesc ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCHVMMFL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MF_HISMANFCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MF_HISMANFDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MF_HospComp_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MF_MANFCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MF_MANFDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MF_MANF_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCHVMMFL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHISMANFCODE">
<Global>^DHCHVMMFL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HISMANFCODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MF_HISMANFCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHISMANFDESC">
<Global>^DHCHVMMFL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HISMANFDESC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MF_HISMANFDesc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHOSPMANF">
<Global>^DHCHVMMFL</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSPMANF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MF_HospComp_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MF_MANF_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMANF">
<Global>^DHCHVMMFL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MANF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MF_MANF_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MF_RowId</SqlRowIdName>
<StreamLocation>^User.DHCHVMatMANFCheckListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCHVMMFL)
	s oldI = +$g(^mdata("^DHCHVMMFL"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCHVMMFL = maxI
	s ^mdata("^DHCHVMMFL") = maxI
}

}
