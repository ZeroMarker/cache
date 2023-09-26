Class User.DHCProContractSpeclist Extends (%Persistent, User.Abstract) [ SqlRowIdName = PCList_RowId, SqlTableName = DHC_ProContractSpeclist, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PCListChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PCListParRef As User.DHCProContract [ Cardinality = parent, Inverse = ChildDHCProContractSpeclist, Required, SqlFieldName = PCList_ParRef ];

Property PCListChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCProContract($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"PCList",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PCList_ChildSub ];

/// 商品编号
Property PCListprocurecatalogId As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PCList_procurecatalogId ];

/// 规格型号编号
Property PCListsubcodeId As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PCList_subcodeId ];

/// 产品ID
Property PCListGoodsId As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PCList_GoodsId ];

/// 规格
Property PCListOutLookc As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PCList_OutLookc ];

/// 型号
Property PCListGoodsType As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PCList_GoodsType ];

/// 医疗器械唯一标识（UDI）-DI 码
Property PCListdiCode As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PCList_diCode ];

/// 是否启用
Property PCListisUsing As %Float [ SqlColumnNumber = 9, SqlFieldName = PCList_isUsing ];

/// 添加日期
Property PCListAddDate As %Library.Date [ SqlColumnNumber = 10, SqlFieldName = PCList_AddDate ];

/// 添加时间
Property PCListAddTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = PCList_AddTime ];

/// 变更日期
Property PCListLastUpdateDate As %Library.Date [ SqlColumnNumber = 12, SqlFieldName = PCList_LastUpdateDate ];

/// 变更时间
Property PCListLastUpdateTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = PCList_LastUpdateTime ];

Storage SQLStorage
{
<SqlIdExpression>$i(^PCLIST(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PCList_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCList_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCList_GoodsId">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCList_GoodsType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCList_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PCList_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PCList_OutLookc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PCList_diCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCList_isUsing">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCList_procurecatalogId">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PCList_subcodeId">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^PCLIST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ProContract.DHCMPCT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PCList_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_ProContract.DHCMPCT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PCLIST"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PCList_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexsubcode">
<Global>^PCLIST</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_ProContract.DHCMPCT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PCList_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SUBCODE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PCList_subcodeId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_ProContract.DHCMPCT_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PCList_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PCList_RowId</SqlRowIdName>
<StreamLocation>^User.DHCProContractSpeclistS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
