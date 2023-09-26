/// 科室病区扩展表
/// 基础数据-likefan
/// 2020-12-24
Class User.CTLocExtend Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = CTLOC_RowID, SqlTableName = CT_LocExtend, StorageStrategy = NewStorage1 ]
{

/// itro	简介
Property CTLOCEItro As %String(MAXLEN = 99999) [ SqlColumnNumber = 2, SqlFieldName = CTLOCE_Itro ];

/// depttype	诊疗科目类别
Property CTLOCEDeptType As %String [ SqlColumnNumber = 3, SqlFieldName = CTLOCE_DeptType ];

/// aprvbedcnt	批准床位数量
Property CTLOCEAprvBedCnt As %String [ SqlColumnNumber = 4, SqlFieldName = CTLOCE_AprvBedCnt ];

/// hicrtfbedcnt	医保认可床位数
Property CTLOCEHiCrtfBedCnt As %String [ SqlColumnNumber = 5, SqlFieldName = CTLOCE_HiCrtfBedCnt ];

/// poolareano	统筹区编号
Property CTLOCEPoolareaNo As %String [ SqlColumnNumber = 6, SqlFieldName = CTLOCE_PoolareaNo ];

/// drpsncnt	医师人数
Property CTLOCEDrPsncnt As %String [ SqlColumnNumber = 7, SqlFieldName = CTLOCE_DrPsncnt ];

/// pharpsncnt	药师人数
Property CTLOCEPharPsncnt As %String [ SqlColumnNumber = 8, SqlFieldName = CTLOCE_PharPsncnt ];

/// nurspsncnt	护士人数
Property CTLOCENursPsncnt As %String [ SqlColumnNumber = 9, SqlFieldName = CTLOCE_NursPsncnt ];

/// tecnpsncnt	技师人数
Property CTLOCETecnPsncnt As %String [ SqlColumnNumber = 10, SqlFieldName = CTLOCE_TecnPsncnt ];

/// 标准编码
Property CTLOCEStandardCode As %String [ SqlColumnNumber = 11, SqlFieldName = CTLOCE_StandardCode ];

/// 标准名称
Property CTLOCEStandardDesc As %String [ SqlColumnNumber = 12, SqlFieldName = CTLOCE_StandardDesc ];

/// 是否医技科室
Property CTLOCEMedtechFlag As %String [ SqlColumnNumber = 13, SqlFieldName = CTLOCE_MedtechFlag ];

/// 科室医疗服务范围
Property CTLOCEDeptMedServScp As %String(MAXLEN = 999999) [ SqlColumnNumber = 14, SqlFieldName = CTLOCE_DeptMedServScp ];

/// 医疗服务类型
Property CTLOCEMedservType As %String [ SqlColumnNumber = 15, SqlFieldName = CTLOCE_MedservType ];

/// 备注
Property CTLOCEMemo As %String(MAXLEN = 999999) [ SqlColumnNumber = 16, SqlFieldName = CTLOCE_Memo ];

Storage NewStorage1
{
<SQLMap name="DataMap">
<Data name="CTLOCE_AprvBedCnt">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>3</Piece>
</Data>
<Data name="CTLOCE_DeptMedServScp">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>13</Piece>
</Data>
<Data name="CTLOCE_DeptType">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>2</Piece>
</Data>
<Data name="CTLOCE_DrPsncnt">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>6</Piece>
</Data>
<Data name="CTLOCE_HiCrtfBedCnt">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>4</Piece>
</Data>
<Data name="CTLOCE_Itro">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>1</Piece>
</Data>
<Data name="CTLOCE_MedservType">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>14</Piece>
</Data>
<Data name="CTLOCE_MedtechFlag">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>12</Piece>
</Data>
<Data name="CTLOCE_Memo">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>15</Piece>
</Data>
<Data name="CTLOCE_NursPsncnt">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>8</Piece>
</Data>
<Data name="CTLOCE_PharPsncnt">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>7</Piece>
</Data>
<Data name="CTLOCE_PoolareaNo">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>5</Piece>
</Data>
<Data name="CTLOCE_StandardCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>10</Piece>
</Data>
<Data name="CTLOCE_StandardDesc">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>11</Piece>
</Data>
<Data name="CTLOCE_TecnPsncnt">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>9</Piece>
</Data>
<Global>^CTLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CTLOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CTLOC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CTLOC_RowID</SqlRowIdName>
<StreamLocation>^User.CTLocExtendS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
