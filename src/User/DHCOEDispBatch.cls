/// 配药记录批次表,记录一次发药中各批次的组成情况 2013.07.12
/// d ##Class(User.DHCOEDispBatch).%BuildIndices()
Class User.DHCOEDispBatch Extends %Persistent [ SqlRowIdName = DSPB_RowId, SqlTableName = DHC_OEDispBatch, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DSPBChildsub [ IdKey, PrimaryKey, Unique ];

Relationship DSPBDSPParRef As User.DHCOEDispensing [ Cardinality = parent, Inverse = ChildBatch, SqlFieldName = DSPB_DSP_ParRef ];

Property DSPBChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCOEDISQTY($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = DSPB_Childsub ];

/// 批次
Property DSPBINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 3, SqlFieldName = DSPB_INCLB_DR ];

/// 数量
Property DSPBQty As %Float [ SqlColumnNumber = 4, SqlFieldName = DSPB_Qty ];

/// 售价
Property DSPBSp As %Float [ SqlColumnNumber = 5, SqlFieldName = DSPB_Sp ];

/// 进价
Property DSPBRp As %Float [ SqlColumnNumber = 6, SqlFieldName = DSPB_Rp ];

/// 库存项
Property DSPBINCIDR As User.INCItm [ SqlColumnNumber = 7, SqlFieldName = DSPB_INCI_DR ];

/// 打包明细的状态
Property DSPBStatus As %Library.String(DISPLAYLIST = ",READY,Collect,Return", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",TC,C,R") [ SqlColumnNumber = 8, SqlFieldName = DSPB_Status ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DSPB_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSPB_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSPB_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSPB_Rp">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSPB_Sp">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DSPB_Status">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCOEDISQTY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_OEDispensing.DSP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DSPB_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_OEDispensing.DSP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSPB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInci">
<Global>^DHCOEDISQTYi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_OEDispensing.DSP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DSPB_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DSPBInci"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSPB_INCI_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_OEDispensing.DSP_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSPB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCOEDISQTYi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_OEDispensing.DSP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DSPB_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DSPBStatus"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSPB_Status}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_OEDispensing.DSP_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSPB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DSPB_RowId</SqlRowIdName>
<StreamLocation>^User.DHCOEDispBatchS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
