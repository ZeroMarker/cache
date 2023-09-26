/// 供应商对照表 DHC_HVMat_APCVMCheckList  
Class User.DHCHVMatAPCVMCheckList Extends (%Persistent, User.Abstract) [ SqlRowIdName = VM_RowId, SqlTableName = DHC_HVMat_APCVMCheckList, StorageStrategy = SQLStorage ]
{

/// 供应商id
Property VMAPCVMDR As User.APCVendor [ Required, SqlColumnNumber = 2, SqlFieldName = VM_APCVM_DR ];

/// 供应商代码
Property VMAPCVMCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = VM_APCVMCode ];

/// 供应商名称
Property VMAPCVMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = VM_APCVMDesc ];

/// 下属医院id
Property VMHospCompDR As User.DHCHospComp [ Required, SqlColumnNumber = 5, SqlFieldName = VM_HospComp_DR ];

/// 下属医院供应商代码
Property VMHISAPCVMCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = VM_HISAPCVMCode ];

/// 下属医院供应商名称
Property VMHISAPCVMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = VM_HISAPCVMDesc ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCHVMVML)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VM_APCVMCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VM_APCVMDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VM_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VM_HISAPCVMCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VM_HISAPCVMDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VM_HospComp_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCHVMVML</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{VM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAPCVM">
<Global>^DHCHVMVML</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"APCVM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VM_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHISAPCVMCODE">
<Global>^DHCHVMVML</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HISAPCVMCODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({VM_HISAPCVMCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHISAPCVMDESC">
<Global>^DHCHVMVML</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HISAPCVMDESC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({VM_HISAPCVMDesc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHOSPAPCVM">
<Global>^DHCHVMVML</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>VM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSPAPCVM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VM_HospComp_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VM_APCVM_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>VM_RowId</SqlRowIdName>
<StreamLocation>^User.DHCHVMatAPCVMCheckListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCHVMVML)
	s oldI = +$g(^mdata("^DHCHVMVML"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCHVMVML = maxI
	s ^mdata("^DHCHVMVML") = maxI
}

}
