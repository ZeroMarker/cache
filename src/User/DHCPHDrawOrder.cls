Class User.DHCPHDrawOrder Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHDWO_RowID, SqlTableName = DHC_PHDrawOrder, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 25000;

Index RowIDBasedIDKeyIndex On PHDWOChildSub [ IdKey, PrimaryKey, Unique ];

/// 主表 Parent Reference
Relationship PHDWOPHDWIParref As User.DHCPHDrawInc [ Cardinality = parent, Inverse = ChildDHCPHDrawOrder, Required, SqlFieldName = PHDWO_PHDWI_Parref ];

/// PHDWO_ChildSub
Property PHDWOChildSub As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHDWO_ChildSub ];

/// 打包表
Property PHDWODspBatchDr As User.DHCOEDispBatch [ SqlColumnNumber = 3, SqlFieldName = PHDWO_DspBatch_Dr ];

/// 数量
Property PHDWOQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHDWO_Qty ];

/// 备药完成
Property PHDWORefFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 5, SqlFieldName = PHDWO_RefFlag ];

/// 执行停止
Property PHDWOStopFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 6, SqlFieldName = PHDWO_StopFlag ];

/// 请领子表
Property PHDWOPHRIDr As User.DHCInPhReqItm [ SqlColumnNumber = 7, SqlFieldName = PHDWO_PHRI_Dr ];

/// 发药子表
Property PHDWOPHACIDr As User.DHCPHACollectItm [ SqlColumnNumber = 8, SqlFieldName = PHDWO_PHACI_Dr ];

/// 发药子表
Property PHDWODspDr As User.DHCOEDispensing [ SqlColumnNumber = 9, SqlFieldName = PHDWO_Dsp_Dr ];

/// 完成标识
Property PHDWOCompFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 10, SqlFieldName = PHDWO_CompFlag ];

Storage SQLStorage
{
<ExtentSize>25000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHDWO_CompFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHDWO_DspBatch_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHDWO_Dsp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHDWO_PHACI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHDWO_PHRI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHDWO_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHDWO_RefFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHDWO_StopFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHDRAW</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHDraw.PHDW_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_PHDrawInc.PHDWI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PHDWO_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_PHDraw.PHDW_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_PHDrawInc.PHDWI_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>"ORDER"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PHDWO_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDsp">
<Global>^DHCPHDRAWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PHDraw.PHDW_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_PHDrawInc.PHDWI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PHDWO_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DSPBATCH"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{PHDWO_DspBatch_Dr}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_PHDraw.PHDW_RowID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_PHDrawInc.PHDWI_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PHDWO_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>User.DHCPHDrawOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
