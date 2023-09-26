/// 单位对照表
Class User.DHCHVMatUOMCheckList Extends (%Persistent, User.Abstract) [ SqlRowIdName = UM_RowId, SqlTableName = DHC_HVMat_UOMCheckList, StorageStrategy = SQLStorage ]
{

/// 单位id
Property UMCTUOMDR As User.CTUOM [ Required, SqlColumnNumber = 2, SqlFieldName = UM_CTUOM_DR ];

/// 单位代码
Property UMCTUOMCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = UM_CTUOMCode ];

/// 单位名称
Property UMCTUOMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = UM_CTUOMDesc ];

/// 下属医院id
Property UMHospCompDR As User.DHCHospComp [ Required, SqlColumnNumber = 5, SqlFieldName = UM_HospComp_DR ];

/// 下属医院单位代码
Property UMHISUOMCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = UM_HISUOMCode ];

/// 下属医院单位名称
Property UMHISUOMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = UM_HISUOMDesc ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCHVMUML)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UM_CTUOMCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UM_CTUOMDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UM_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UM_HISUOMCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UM_HISUOMDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UM_HospComp_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCHVMUML</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{UM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHISUOMCODE">
<Global>^DHCHVMUML</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HISUOMCODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({UM_HISUOMCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHISUOMDESC">
<Global>^DHCHVMUML</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HISUOMDESC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({UM_HISUOMDesc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHOSPUOM">
<Global>^DHCHVMUML</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSPUOM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UM_HospComp_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UM_CTUOM_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUOM">
<Global>^DHCHVMUML</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UOM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UM_CTUOM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>UM_RowId</SqlRowIdName>
<StreamLocation>^User.DHCHVMatUOMCheckListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCHVMUML)
	s oldI = +$g(^mdata("^DHCHVMUML"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCHVMUML = maxI
	s ^mdata("^DHCHVMUML") = maxI
}

}
