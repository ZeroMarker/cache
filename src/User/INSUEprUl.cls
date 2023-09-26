/// 病案上传信息主表
/// wty 20210305
Class User.INSUEprUl Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INEUL_Rowid, SqlTableName = INSU_EprUL, StorageStrategy = SQLStorage ]
{

/// 病人基本信息指针
Property INEULPapmiDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INEUL_PapmiDr ];

/// 病人就诊指针
Property INEULAdmDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INEUL_AdmDr ];

/// 病人结算指针
Property INEULDivDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INEUL_DivDr ];

/// 病人病案号/住院号
Property INEULMedcasNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INEUL_MedcasNo ];

/// 医保个人编码/卡号
Property INEULInsuNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INEUL_InsuNo ];

/// 医保登记流水号
Property INEULInsuZylsh As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INEUL_InsuZylsh ];

/// 医保结算流水号
Property INEULInsuDjlsh As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INEUL_InsuDjlsh ];

/// 医保类型（市医保、省医保等）
Property INEULInsuType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INEUL_InsuType ];

/// 入院日期
Property INEULAdmDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = INEUL_AdmDate ];

/// 出院日期
Property INEULOutDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = INEUL_OutDate ];

/// 结算日期
Property INEULDisDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = INEUL_DisDate ];

/// 上传用户
Property INEULOpter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INEUL_Opter ];

/// 上传日期
Property INEULOptDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = INEUL_OptDate ];

/// 上传日期
Property INEULOptTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = INEUL_OptTime ];

/// 上传标志
Property INEULOptFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INEUL_OptFlag ];

/// 病人类型（职工、居民等）
Property INEULPatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INEUL_PatType ];

/// 清单id(上传清单时医保返回id)
Property INEULListId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INEUL_ListId ];

/// 清单入参
Property INEULInPutData As %Stream.GlobalCharacter [ SqlColumnNumber = 19, SqlFieldName = INEUL_InPutData ];

/// 清单出参
Property INEULOutPutData As %Stream.GlobalCharacter [ SqlColumnNumber = 20, SqlFieldName = INEUL_OutPutData ];

Property INEULDemo1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INEUL_Demo1 ];

// Property INEULDemo2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INEUL_Demo2 ];

//  清单状态分类

Property INEULStasType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INEUL_StasType ];

Property INEULDemo3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INEUL_Demo3 ];

Property INEULDemo4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INEUL_Demo4 ];

Property INEULDemo5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INEUL_Demo5 ];

/// 病历提交日期  DingSH 20220427
Property INEULEMRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = INEUL_EMRDate ];

/// 病案编目日期  DingSH 20220427
Property INEULIPMRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = INEUL_IPMRDate ];

/// add 20230228 HanZH
/// 提交人
Property INEULSbmter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INEUL_Sbmter ];

/// 提交日期
Property INEULSbmtDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 29, SqlFieldName = INEUL_SbmtDate ];

/// 提交时间
Property INEULSbmtTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 30, SqlFieldName = INEUL_SbmtTime ];

/// 撤销人
Property INEULUndoer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = INEUL_Undoer ];

/// 撤销日期
Property INEULUndoDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 32, SqlFieldName = INEUL_UndoDate ];

/// 撤销时间
Property INEULUndoTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 33, SqlFieldName = INEUL_UndoTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINEUL)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INEUL_AdmDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INEUL_AdmDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INEUL_Demo1">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INEUL_Demo3">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INEUL_Demo4">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INEUL_Demo5">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INEUL_DisDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INEUL_DivDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INEUL_EMRDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INEUL_IPMRDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INEUL_InPutData">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INEUL_InsuDjlsh">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INEUL_InsuNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INEUL_InsuType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INEUL_InsuZylsh">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INEUL_ListId">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INEUL_MedcasNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INEUL_OptDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INEUL_OptFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INEUL_OptTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INEUL_Opter">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INEUL_OutDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INEUL_OutPutData">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INEUL_PapmiDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INEUL_PatType">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INEUL_SbmtDate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INEUL_SbmtTime">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INEUL_Sbmter">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INEUL_StasType">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INEUL_UndoDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INEUL_UndoTime">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INEUL_Undoer">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Global>^DHCINEUL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{INEUL_Rowi}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INEUL_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmDate">
<Global>^DHCINEULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INEUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AdmDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INEUL_AdmDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INEUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfAdmDr">
<Global>^DHCINEULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INEUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AdmDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INEUL_AdmDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INEUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfDisDate">
<Global>^DHCINEULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INEUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DisDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INEUL_DisDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INEUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfDivDr">
<Global>^DHCINEULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INEUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DivDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INEUL_DivDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INEUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfDjlsh">
<Global>^DHCINEULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INEUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Djlsh"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INEUL_InsuDjlsh}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INEUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfEMRDate">
<Global>^DHCINEULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INEUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"EMRDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INEUL_EMRDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INEUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfIMPRDate">
<Global>^DHCINEULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INEUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"IPMRDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INEUL_IPMRDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INEUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfListId">
<Global>^DHCINEULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INEUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ListId"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INEUL_ListId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INEUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfMedNo">
<Global>^DHCINEULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INEUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MedNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INEUL_MedcasNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INEUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfOptDate">
<Global>^DHCINEULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INEUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OptDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INEUL_OptDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INEUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfOutDate">
<Global>^DHCINEULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INEUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OutDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INEUL_OutDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INEUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfPapmiDr">
<Global>^DHCINEULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INEUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PapmiDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INEUL_PapmiDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INEUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfZylsh">
<Global>^DHCINEULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>{INEUL_Rowid}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Zylsh"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INEUL_InsuZylsh}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INEUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUEprUlS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
