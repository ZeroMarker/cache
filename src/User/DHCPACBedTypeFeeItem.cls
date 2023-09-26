Class User.DHCPACBedTypeFeeItem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BEDTPI_RowId, SqlTableName = DHC_PAC_BedTypeFeeItem, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On (BEDTPIBEDTPParRef, BEDTPIChildsub) [ IdKey, PrimaryKey, Unique ];

/// 床位类型
Property BEDTPIBEDTPParRef As User.PACBedType [ Required, SqlColumnNumber = 2, SqlFieldName = BEDTPI_BEDTP_ParRef ];

/// Child Sub
Property BEDTPIChildsub As %Float [ InitialExpression = {$i(^PAC("BEDTP",$s($d(initvalue):initvalue,1:%d(2)),"FEE",0))}, Required, SqlColumnNumber = 3, SqlFieldName = BEDTPI_Childsub ];

/// 费用类型
Property BEDTPIFeeType As User.DHCPACBedFeeType [ SqlColumnNumber = 4, SqlFieldName = BEDTPI_FeeType ];

/// 费用医嘱项
Property BEDTPIARCIMDR As User.ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = BEDTPI_ARCIM_DR ];

/// 开始时间
Property BEDTPIStartDate As %Date [ SqlColumnNumber = 6, SqlFieldName = BEDTPI_StartDate ];

/// 结束时间
Property BEDTPIEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = BEDTPI_EndDate ];

/// 费别
Property BEDTPIAdmReasonDR As User.PACAdmReason [ SqlColumnNumber = 8, SqlFieldName = BEDTPI_AdmReason_DR ];

/// 起始年龄
Property BEDTPIStartAge As %Integer [ SqlColumnNumber = 9, SqlFieldName = BEDTPI_StartAge ];

/// 截止年龄
Property BEDTPIEndAge As %Integer [ SqlColumnNumber = 10, SqlFieldName = BEDTPI_EndAge ];

/// 床位费时制
Property BEDTPIFeeTime As CT.BDP.CT.BedFeeTime [ SqlColumnNumber = 11, SqlFieldName = BEDTPI_Fee_Time ];

/// 母亲床位类型
Property BEDTPIMomBedTypeDR As User.PACBedType [ SqlColumnNumber = 12, SqlFieldName = BEDTPI_MomBedType_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="BEDTPI_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BEDTPI_AdmReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BEDTPI_EndAge">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BEDTPI_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BEDTPI_FeeType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BEDTPI_Fee_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BEDTPI_MomBedType_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BEDTPI_StartAge">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BEDTPI_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BEDTPI_BEDTP_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BEDTPI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"BEDTP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BEDTPI_BEDTP_ParRef}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="3">
<Expression>"FEE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BEDTPI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>BEDTPI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPACBedTypeFeeItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
