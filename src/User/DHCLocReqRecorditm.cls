Class User.DHCLocReqRecorditm Extends (%Persistent, User.Abstract) [ SqlRowIdName = LRRI_RowId, SqlTableName = DHC_LocReqRecorditm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LRRIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship LRRIParrfe As User.DHCLocReqRecord [ Cardinality = parent, Inverse = ChildDHCLocReqRecorditm, Required, SqlFieldName = LRRI_Parrfe ];

Property LRRIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = LRRI_ChildSub ];

/// 类组
Property LRRIScgDr As User.DHCStkCatGroup [ SqlColumnNumber = 3, SqlFieldName = LRRI_Scg_Dr ];

/// 库存分类
Property LRRICatDr As User.INCStkCat [ SqlColumnNumber = 4, SqlFieldName = LRRI_Cat_Dr ];

/// 库存项
Property LRRIInciDr As User.INCItm [ SqlColumnNumber = 5, SqlFieldName = LRRI_Inci_Dr ];

/// 已用额度
Property LRRIUsedAmt As %Library.Float(MAXVAL = 999999999999) [ SqlColumnNumber = 6, SqlFieldName = LRRI_UsedAmt ];

/// 统计方式
Property LRRILimitType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = LRRI_LimitType ];

/// 已用数量 (库存项纪录使用 基本单位)
Property LRRIUsedQty As %Library.Float(MAXVAL = 999999999999) [ SqlColumnNumber = 8, SqlFieldName = LRRI_UsedQty ];

Storage SQLStorage
{
<SQLMap name="Indexcat">
<Global>^DHCLRR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_LocReqRecord.LRR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LRRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"incsc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LRRI_Cat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_LocReqRecord.LRR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LRRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexinci">
<Global>^DHCLRR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_LocReqRecord.LRR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LRRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"inci"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LRRI_Inci_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_LocReqRecord.LRR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LRRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexscg">
<Global>^DHCLRR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_LocReqRecord.LRR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LRRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"scg"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LRRI_Scg_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_LocReqRecord.LRR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LRRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="masterdata">
<Data name="LRRI_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LRRI_Inci_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LRRI_LimitType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LRRI_Scg_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LRRI_UsedAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LRRI_UsedQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCLRR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_LocReqRecord.LRR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LRRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_LocReqRecord.LRR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"LRRI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{LRRI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LRRI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLocReqRecorditmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
