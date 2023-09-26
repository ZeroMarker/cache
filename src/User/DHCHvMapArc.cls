Class User.DHCHvMapArc Extends (%Persistent, User.Abstract) [ SqlRowIdName = HMA_RowId, SqlTableName = DHC_HvMapArc, StorageStrategy = SQLStorage ]
{

Property HMAHvFlag As %Library.String [ SqlColumnNumber = 2, SqlFieldName = HMA_HvFlag ];

/// 医嘱子类
Property HMAItemCatDR As User.ARCItemCat [ SqlColumnNumber = 3, SqlFieldName = HMA_ItemCat_DR ];

/// 收费子类
Property HMAARCBillSubDR As User.ARCBillSub [ SqlColumnNumber = 4, SqlFieldName = HMA_ARCBillSub_DR ];

/// 子分类
Property HMATarSubCatDR As User.DHCTarSubCate [ SqlColumnNumber = 5, SqlFieldName = HMA_TarSubCat_DR ];

/// 住院子分类
Property HMATarInpatDR As User.DHCTarInpatCate [ SqlColumnNumber = 6, SqlFieldName = HMA_TarInpat_DR ];

/// 门诊子分类
Property HMATarOutDR As User.DHCTarOutpatCate [ SqlColumnNumber = 7, SqlFieldName = HMA_TarOut_DR ];

/// 核算子分类
Property HMATarEMCDR As User.DHCTarEMCCate [ SqlColumnNumber = 8, SqlFieldName = HMA_TarEMC_DR ];

/// 病历首页分类
Property HMATarMRDR As User.DHCTarMRCate [ SqlColumnNumber = 9, SqlFieldName = HMA_TarMR_DR ];

/// 新病历首页分类
Property HMATarNMRDR As %Library.String [ SqlColumnNumber = 10, SqlFieldName = HMA_TarNMR_DR ];

/// 会计子分类
Property HMATarAcctDR As User.DHCTarAcctCate [ SqlColumnNumber = 11, SqlFieldName = HMA_TarAcct_DR ];

/// 医院ID
Property HMAHospDR As CTHospital [ SqlColumnNumber = 12, SqlFieldName = HMA_Hosp_DR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCHVMAPARC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HMA_ARCBillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HMA_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="HMA_HvFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HMA_ItemCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HMA_TarAcct_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HMA_TarEMC_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HMA_TarInpat_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HMA_TarMR_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HMA_TarNMR_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HMA_TarOut_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HMA_TarSubCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCHVMAPARC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>HMA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{HMA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHospHv">
<Global>^DHCHVMAPARC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HMA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSPHV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HMA_Hosp_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HMA_HvFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HMA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHv">
<Global>^DHCHVMAPARC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HMA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HMA_HvFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HMA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HMA_RowId</SqlRowIdName>
<StreamLocation>^User.DHCHvMapArcS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCHVMAPARC)
	s oldI = +$g(^mdata("DHCHVMAPARC"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCHVMAPARC = maxI
	s ^mdata("DHCHVMAPARC") = maxI
}

}
