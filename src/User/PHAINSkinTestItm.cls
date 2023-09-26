/// creator: Huxt
/// date: 2020-03-18
Class User.PHAINSkinTestItm Extends %Persistent [ SqlRowIdName = PISTI_RowId, SqlTableName = PHAIN_SkinTestItm, StorageStrategy = CacheSQLStorage ]
{

/// 指向父表
Index RowIDBasedIDKeyIndex On PISTIChildsub [ IdKey, PrimaryKey, Unique ];

Relationship PISTIParref As User.PHAINSkinTest [ Cardinality = parent, Inverse = ChildPHAINSkinTestItm, Required, SqlFieldName = PISTI_Parref ];

Property PISTIChildsub As %Float [ SqlColumnNumber = 2, SqlFieldName = PISTI_Childsub ];

/// 就诊类型 (O-门诊, E-急诊, I-住院, H-体检)
Property PISTIAdmType As %String(DISPLAYLIST = ",O,E,I,H", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",O,E,I,H") [ SqlColumnNumber = 3, SqlFieldName = PISTI_AdmType ];

/// 科室ID
Property PISTICTLOCDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PISTI_CTLOC_DR ];

/// 医嘱项ID (与通用名二选一)
Property PISTIARCIMDR As User.ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = PISTI_ARCIM_DR ];

/// 通用名ID (与医嘱项二选一)
Property PISTIGenericDR As User.PHCGeneric [ SqlColumnNumber = 6, SqlFieldName = PISTI_Generic_DR ];

/// 结果标志
Property PISTIResultFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PISTI_ResultFlag ];

/// 优先级ID
Property PISTIPriorityDR As User.OECPriority [ SqlColumnNumber = 8, SqlFieldName = PISTI_Priority_DR ];

/// 开医嘱默认剂量
Property PISTIDoseQty As %Float [ SqlColumnNumber = 9, SqlFieldName = PISTI_DoseQty ];

/// 开医嘱默认剂量单位
Property PISTIUnitDR As User.CTUOM [ SqlColumnNumber = 10, SqlFieldName = PISTI_Unit_DR ];

/// 开医嘱默认频次
Property PISTIPHFreqDR As User.PHCFreq [ SqlColumnNumber = 11, SqlFieldName = PISTI_PHFreq_DR ];

/// 开医嘱默认用法
Property PISTIInstrDR As User.PHCInstruc [ SqlColumnNumber = 12, SqlFieldName = PISTI_Instr_DR ];

/// 关联序号
Property PISTISeqNo As %String [ SqlColumnNumber = 13, SqlFieldName = PISTI_SeqNo ];

/// 结果标志
Property PISTIAutoInsFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = PISTI_AutoInsFlag ];

/// 开始日期
Property PISTIStartDate As %Date [ SqlColumnNumber = 15, SqlFieldName = PISTI_StartDate ];

/// 截止日期
Property PISTIEndDate As %Date [ SqlColumnNumber = 16, SqlFieldName = PISTI_EndDate ];

Storage CacheSQLStorage
{
<SQLMap name="DataMap">
<Data name="PISTI_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PISTI_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PISTI_AutoInsFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PISTI_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PISTI_DoseQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PISTI_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PISTI_Generic_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PISTI_Instr_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PISTI_PHFreq_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PISTI_Priority_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PISTI_ResultFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PISTI_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PISTI_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PISTI_Unit_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^CF.PHA.IN.SkinTest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIN_SkinTest.PIST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PISTI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIN_SkinTest.PIST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PISTI_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexIARCIM">
<Global>^CF.PHA.IN.SkinTesti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHAIN_SkinTest.PIST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PISTI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"IARCIM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PISTI_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAIN_SkinTest.PIST_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PISTI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIGeneric">
<Global>^CF.PHA.IN.SkinTesti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHAIN_SkinTest.PIST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PISTI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"IGeneric"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PISTI_Generic_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAIN_SkinTest.PIST_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PISTI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PISTI_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINSkinTestItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
