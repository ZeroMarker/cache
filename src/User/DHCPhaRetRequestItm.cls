Class User.DHCPhaRetRequestItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RETRQI_Rowid, SqlTableName = DHC_PhaRetRequestItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On RETRQIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PhaRetRequest Parent Reference
Relationship RETRQIRETRQParRef As User.DHCPhaRetRequest [ Cardinality = parent, Inverse = ChildDHCPhaRetRequestItm, Required, SqlFieldName = RETRQI_RETRQ_ParRef ];

/// RETRQI_ChildSub
Property RETRQIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = RETRQI_ChildSub ];

/// RETRQI_OEDIS_DR
Property RETRQIOEDISDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = RETRQI_OEDIS_DR ];

/// RETRQI_Qty
Property RETRQIQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = RETRQI_Qty ];

/// RETRQI_REASON_DR
Property RETRQIREASONDR As User.BLCReasonForRefund [ SqlColumnNumber = 5, SqlFieldName = RETRQI_REASON_DR ];

/// RETRQI_SAmount
Property RETRQISAmount As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = RETRQI_SAmount ];

/// RETRQI_SPrice
Property RETRQISPrice As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = RETRQI_SPrice ];

/// RETRQI_UpdateDate
Property RETRQIUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = RETRQI_UpdateDate ];

/// RETRQI_UpdateTime
Property RETRQIUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = RETRQI_UpdateTime ];

/// RETRQI_UpdateUser_Dr
Property RETRQIUpdateUserDr As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = RETRQI_UpdateUser_Dr ];

/// RETRQI_DateDosing
Property RETRQIDateDosing As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = RETRQI_DateDosing ];

/// RETRQI_Status
Property RETRQIStatus As %Library.String(MAXLEN = 7, SELECTIVITY = "25.0000%", VALUELIST = ",Prove,Execute,Ignore,Refuse") [ SqlColumnNumber = 12, SqlFieldName = RETRQI_Status ];

/// RETRQI_DoDis_Dr
Property RETRQIDoDisDr As User.DHCOEDispensing [ SqlColumnNumber = 13, SqlFieldName = RETRQI_DoDis_Dr ];

/// RETRQI_Status
Property RETRQIRefundStatus As %Library.String(MAXLEN = 7, SELECTIVITY = "25.0000%", VALUELIST = ",1") [ SqlColumnNumber = 14, SqlFieldName = RETRQI_RefundStatus ];

/// RETRQ_INCI_DR
Property RETRQIINCIDR As User.INCItm [ SqlColumnNumber = 15, SqlFieldName = RETRQI_INCI_DR ];

/// 打包子表
Property RETRQIDSPBDr As User.DHCOEDispBatch [ SqlColumnNumber = 16, SqlFieldName = RETRQI_DSPB_Dr ];

/// 发药孙表
Property RETRQIPHACILDr As User.DHCPhaCollectItmLB [ SqlColumnNumber = 17, SqlFieldName = RETRQI_PHACIL_Dr ];

/// 科室库存批次
Property RETRQIINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 18, SqlFieldName = RETRQI_INCLB_DR ];

/// 拒绝退药原因
Property RETRQIRefuseRetReasonDR As User.DHCStkComDictionary [ SqlColumnNumber = 19, SqlFieldName = RETRQI_RefuseRetReason_DR ];

/// 备注
Property RETRQIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = RETRQI_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexDspBatch">
<Global>^RETRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PhaRetRequest.RETRQ_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RETRQI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DSPB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RETRQI_DSPB_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PhaRetRequest.RETRQ_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RETRQI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInci">
<Global>^RETRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PhaRetRequest.RETRQ_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RETRQI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{RETRQI_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_PhaRetRequest.RETRQ_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{RETRQI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="datamaster">
<Data name="RETRQI_DSPB_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RETRQI_DateDosing">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RETRQI_DoDis_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RETRQI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RETRQI_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RETRQI_OEDIS_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RETRQI_PHACIL_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RETRQI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RETRQI_REASON_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RETRQI_REFUSERETREASON_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="RETRQI_RefundStatus">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RETRQI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="RETRQI_SAmount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RETRQI_SPrice">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RETRQI_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RETRQI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RETRQI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RETRQI_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^RETRQ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PhaRetRequest.RETRQ_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RETRQI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PhaRetRequest.RETRQ_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RETRQI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexDodis">
<Global>^RETRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PhaRetRequest.RETRQ_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RETRQI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DODIS"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{RETRQI_DoDis_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_PhaRetRequest.RETRQ_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{RETRQI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexoedis">
<Global>^RETRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PhaRetRequest.RETRQ_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>RETRQI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"OEDIS"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{RETRQI_OEDIS_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RETRQI_DateDosing}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_PhaRetRequest.RETRQ_Rowid}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{RETRQI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaRetRequestItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
