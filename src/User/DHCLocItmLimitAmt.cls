Class User.DHCLocItmLimitAmt Extends (%Persistent, User.Abstract) [ SqlRowIdName = LRLI_RowId, SqlTableName = DHC_LocItmLimitAmt, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LRLIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship LRLIParrfe As User.DHCLocReqLimit [ Cardinality = parent, Inverse = ChildDHCLocItmLimitAmt, Required, SqlFieldName = LRLI_ParRef ];

Property LRLIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = LRLI_ChildSub ];

/// 起始日期
Property LRLIStartDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = LRLI_StartDate ];

/// 截止日期
Property LRLIEndDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = LRLI_EndDate ];

/// 限额
Property LRLIReqAmt As %Library.Float(MAXVAL = 999999999999) [ SqlColumnNumber = 5, SqlFieldName = LRLI_ReqAmt ];

/// 类组
Property LRLIScgDr As User.DHCStkCatGroup [ SqlColumnNumber = 6, SqlFieldName = LRLI_Scg_Dr ];

/// 库存分类
Property LRLICatDr As User.INCStkCat [ SqlColumnNumber = 7, SqlFieldName = LRLI_Cat_Dr ];

/// 库存项
Property LRLIInciDr As User.INCItm [ SqlColumnNumber = 8, SqlFieldName = LRLI_Inci_Dr ];

/// 已用额度
Property LRLIUsedAmt As %Library.Float(MAXVAL = 999999999999) [ SqlColumnNumber = 10, SqlFieldName = LRLI_UsedAmt ];

/// 限定类型
Property LRLILimitType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = LRLI_LimitType ];

/// 限制请领数量
Property LRLIReqQty As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = LRLI_ReqQty ];

/// 单次限制请领数量
Property LRLIOnceReqQty As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = LRLI_OnceReqQty ];

/// 单位
Property LRLICTUOMDR As User.CTUOM [ SqlColumnNumber = 14, SqlFieldName = LRLI_CTUOM_DR ];

/// 已请领数量
Property LRLIAddReqQty As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = LRLI_AddReqQty ];

Storage SQLStorage
{
<SQLMap name="IndexCat">
<Global>^DHCLRL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_LocReqLimit.LRL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LRLI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LRLI_Cat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_LocReqLimit.LRL_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LRLI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInci">
<Global>^DHCLRL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_LocReqLimit.LRL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LRLI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inci"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LRLI_Inci_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_LocReqLimit.LRL_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LRLI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexScg">
<Global>^DHCLRL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_LocReqLimit.LRL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LRLI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Scg"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LRLI_Scg_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_LocReqLimit.LRL_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LRLI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Masterdata">
<Data name="LRLI_AddReqQty">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="LRLI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="LRLI_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LRLI_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LRLI_Inci_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LRLI_LimitType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LRLI_OnceReqQty">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="LRLI_ReqAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LRLI_ReqQty">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="LRLI_Scg_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LRLI_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LRLI_UsedAmt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCLRL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_LocReqLimit.LRL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LRLI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_LocReqLimit.LRL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LRLI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{LRLI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LRLI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLocItmLimitAmtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
