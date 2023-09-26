Class User.PIVALocBatItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PLBATI_RowID, SqlTableName = PIVA_LocBatItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PLBATIChildSub [ IdKey, PrimaryKey, Unique ];

/// PIVA_LocBat Parent Reference
Relationship PLBATILBParref As User.PIVALocBat [ Cardinality = parent, Inverse = ChildPIVALocBatItm, Required, SqlFieldName = PLBATI_LB_Parref ];

/// PLBATI_ChildSub
Property PLBATIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PLBATI_ChildSub ];

/// PLBATI_INCI_DR
Property PLBATIINCIDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = PLBATI_INCI_DR ];

/// PLBATI_SubCat_DR
Property PLBATISubCatDR As User.PHCSubCat [ SqlColumnNumber = 4, SqlFieldName = PLBATI_SubCat_DR ];

/// PLBATI_BatNo
Property PLBATIBatNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PLBATI_BatNo ];

/// PLBATI_Order
Property PLBATIOrder As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PLBATI_Order ];

/// PLBATI_Type
Property PLBATIType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PLBATI_Type ];

/// PLBATI_PHCC_Dr
Property PLBATIPHCCDR As User.DHCPHCCat [ SqlColumnNumber = 8, SqlFieldName = PLBATI_PHCC_Dr ];

/// PLBATI_Freq_Dr
Property PLBATIFREQDR As User.PHCFreq [ SqlColumnNumber = 9, SqlFieldName = PLBATI_Freq_Dr ];

/// PLBATI_Instr_Dr
Property PLBATIINSTRDR As User.PHCInstruc [ SqlColumnNumber = 10, SqlFieldName = PLBATI_Instr_Dr ];

/// 轮次,对应某日第几次用药
Property PLBATISeqNo As %Library.Integer [ SqlColumnNumber = 11, SqlFieldName = PLBATI_SeqNo ];

/// 配液大类
Property PLBATIOrdLinkDR As User.PIVAOrderLink [ SqlColumnNumber = 12, SqlFieldName = PLBATI_OrdLink_DR ];

/// 是否参与容积规则
Property PLBATIInLiquidFlag As %Boolean [ SqlColumnNumber = 13, SqlFieldName = PLBATI_InLiquidFlag ];

/// 医嘱类型, 与配液大类联合使用, 医嘱类型不同可能归到不同的批次
Property PLBATIPriorityDR As User.OECPriority [ SqlColumnNumber = 14, SqlFieldName = PLBATI_Priority_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PLBATI_BatNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PLBATI_Freq_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PLBATI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PLBATI_InLiquidFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PLBATI_Instr_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PLBATI_OrdLink_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PLBATI_Order">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PLBATI_PHCC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PLBATI_Priority_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PLBATI_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PLBATI_SubCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PLBATI_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PIVALBAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVA_LocBat.PLBAT_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PLBATI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PIVA_LocBat.PLBAT_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Itm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PLBATI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInci">
<Global>^PIVALBAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIVA_LocBat.PLBAT_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PLBATI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inci"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVA_LocBat.PLBAT_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PLBATI_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PLBATI_INCI_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PLBATI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInstr">
<Global>^PIVALBAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIVA_LocBat.PLBAT_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PLBATI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Instr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVA_LocBat.PLBAT_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PLBATI_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PLBATI_Instr_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PLBATI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdLink">
<Global>^PIVALBAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIVA_LocBat.PLBAT_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PLBATI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdLink"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVA_LocBat.PLBAT_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PLBATI_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PLBATI_OrdLink_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PLBATI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVALocBatItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
