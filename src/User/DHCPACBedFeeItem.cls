Class User.DHCPACBedFeeItem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BEDI_RowId, SqlTableName = DHC_PAC_BedFeeItem, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On (BEDIBEDParRef, BEDIBEDChildsub, BEDIChildsub) [ IdKey, PrimaryKey, Unique ];

/// 床位类型
Property BEDIBEDParRef As User.PACWard [ InitialExpression = {$s($d(initvalue):+initvalue,1:%d(2))}, Required, SqlColumnNumber = 2, SqlFieldName = BEDI_BED_ParRef ];

/// Child Sub
Property BEDIBEDChildsub As %Float [ InitialExpression = {$s($d(initvalue):$P(initvalue,"||",2),1:%d(3))}, Required, SqlColumnNumber = 3, SqlFieldName = BEDI_BED_Childsub ];

/// Child Sub
Property BEDIChildsub As %Float [ InitialExpression = {$i(^PAWARD($s($d(initvalue):+initvalue,1:%d(2)),"BED",$s($d(initvalue):$P(initvalue,"||",2),1:%d(3)),"FEE",0))}, Required, SqlColumnNumber = 4, SqlFieldName = BEDI_Childsub ];

/// 费用类型
Property BEDIIFeeType As User.DHCPACBedFeeType [ SqlColumnNumber = 5, SqlFieldName = BEDI_FeeType ];

/// 费用医嘱项
Property BEDIARCIMDR As User.ARCItmMast [ SqlColumnNumber = 6, SqlFieldName = BEDI_ARCIM_DR ];

/// 开始时间
Property BEDIStartDate As %Date [ SqlColumnNumber = 7, SqlFieldName = BEDI_StartDate ];

/// 结束时间
Property BEDIEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = BEDI_EndDate ];

/// 费别
Property BEDIAdmReasonDR As User.PACAdmReason [ SqlColumnNumber = 9, SqlFieldName = BEDI_AdmReason_DR ];

/// 起始年龄
Property BEDIStartAge As %Integer [ SqlColumnNumber = 10, SqlFieldName = BEDI_StartAge ];

/// 截止年龄
Property BEDIEndAge As %Integer [ SqlColumnNumber = 11, SqlFieldName = BEDI_EndAge ];

/// 床位费时制
Property BEDIFeeTime As CT.BDP.CT.BedFeeTime [ SqlColumnNumber = 12, SqlFieldName = BEDI_Fee_Time ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="BEDI_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BEDI_AdmReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BEDI_EndAge">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BEDI_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BEDI_FeeType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BEDI_Fee_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BEDI_StartAge">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BEDI_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAWARD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BEDI_BED_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>BEDI_BED_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>BEDI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BEDI_BED_ParRef}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"BED"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BEDI_BED_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<Expression>"FEE"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BEDI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>BEDI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPACBedFeeItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
