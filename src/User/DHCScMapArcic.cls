Class User.DHCScMapArcic Extends (%Persistent, User.Abstract) [ SqlRowIdName = MP_RowId, SqlTableName = DHC_ScMapArcic, StorageStrategy = SQLStorage ]
{

Property MPINCSCDR As User.INCStkCat [ SqlColumnNumber = 2, SqlFieldName = MP_INCSC_DR ];

/// 医嘱子类
Property MPItemCatDR As User.ARCItemCat [ SqlColumnNumber = 3, SqlFieldName = MP_ItemCat_DR ];

/// 收费子类
Property MPARCBillSubDR As User.ARCBillSub [ SqlColumnNumber = 4, SqlFieldName = MP_ARCBillSub_DR ];

/// 子分类
Property MPTarSubCatDR As User.DHCTarSubCate [ SqlColumnNumber = 5, SqlFieldName = MP_TarSubCat_DR ];

/// 住院子分类
Property MPTarInpatDR As User.DHCTarInpatCate [ SqlColumnNumber = 6, SqlFieldName = MP_TarInpat_DR ];

/// 会计子分类
Property MPTarAcctDR As User.DHCTarAcctCate [ SqlColumnNumber = 7, SqlFieldName = MP_TarAcct_DR ];

/// 病历首页分类
Property MPTarMRDR As User.DHCTarMRCate [ SqlColumnNumber = 8, SqlFieldName = MP_TarMR_DR ];

/// 核算子分类
Property MPTarEMCDR As User.DHCTarEMCCate [ SqlColumnNumber = 9, SqlFieldName = MP_TarEMC_DR ];

/// 门诊子分类
Property MPTarOutDR As User.DHCTarOutpatCate [ SqlColumnNumber = 10, SqlFieldName = MP_TarOut_DR ];

/// 新病历首页分类
Property MPTarNMRDR As %Library.String [ SqlColumnNumber = 11, SqlFieldName = MP_TarNMR_DR ];

/// 医嘱项默认生效日期为当天
Property MPEffDateFlag As %Library.String [ SqlColumnNumber = 12, SqlFieldName = MP_EffDateFlag ];

/// 优先级
Property MPPriorityDR As User.OECPriority [ SqlColumnNumber = 13, SqlFieldName = MP_Priority_DR ];

/// 默认独立医嘱
Property MPOwnFlag As %Library.String [ SqlColumnNumber = 14, SqlFieldName = MP_OwnFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$I(^DHCMapScArcic(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MP_ARCBillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MP_EffDateFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MP_INCSC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MP_ItemCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MP_OwnFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MP_Priority_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MP_TarAcct_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MP_TarEMC_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MP_TarInpat_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MP_TarMR_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MP_TarNMR_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MP_TarOut_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MP_TarSubCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCMapScArcic</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{MP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSc">
<Global>^DHCMapScArcic</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MP_INCSC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCScMapArcicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
