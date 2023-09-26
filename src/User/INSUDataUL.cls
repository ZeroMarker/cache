/// 数据上传信息主表
/// wty 20210305
Class User.INSUDataUL Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INDUL_Rowid, SqlTableName = INSU_DataUL, StorageStrategy = SQLStorage ]
{

/// 病人基本信息指针
Property INDULPapmiDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INDUL_PapmiDr ];

/// 病人就诊指针
Property INDULAdmDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INDUL_AdmDr ];

/// 病人结算指针
Property INDULDivDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INDUL_DivDr ];

/// 病人病案号/住院号
Property INDULMedcasNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INDUL_MedcasNo ];

/// 发票表id
Property INDULPrtDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INDUL_PrtDr ];

/// 就诊类型
Property INDULAdmType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INDUL_AdmType ];

/// 医保个人编码/卡号
Property INDULInsuNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INDUL_InsuNo ];

/// 医保登记流水号
Property INDULInsuZylsh As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INDUL_InsuZylsh ];

/// 医保结算流水号
Property INDULInsuDjlsh As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INDUL_InsuDjlsh ];

/// 医保类型（市医保、省医保等）
Property INDULInsuType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INDUL_InsuType ];

/// 入院日期
Property INDULAdmDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = INDUL_AdmDate ];

/// 出院日期
Property INDULOutDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = INDUL_OutDate ];

/// 结算日期
Property INDULDisDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = INDUL_DisDate ];

/// 上传用户
Property INDULOpter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INDUL_Opter ];

/// 上传日期
Property INDULOptDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = INDUL_OptDate ];

/// 上传日期
Property INDULOptTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = INDUL_OptTime ];

/// 上传标志
Property INDULOptFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INDUL_OptFlag ];

/// 院区
Property INDULHospID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INDUL_HospID ];

/// 编目日期
Property INDULBMDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = INDUL_BMDate ];

Property INDULDemo1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INDUL_Demo1 ];

Property INDULDemo2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INDUL_Demo2 ];

Property INDULDemo3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INDUL_Demo3 ];

Property INDULDemo4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INDUL_Demo4 ];

Property INDULDemo5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INDUL_Demo5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINDUL)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INDUL_AdmDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INDUL_AdmDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INDUL_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INDUL_BMDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INDUL_Demo1">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INDUL_Demo2">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INDUL_Demo3">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INDUL_Demo4">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INDUL_Demo5">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INDUL_DisDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INDUL_DivDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INDUL_HospID">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INDUL_InsuDjlsh">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INDUL_InsuNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INDUL_InsuType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INDUL_InsuZylsh">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INDUL_MedcasNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INDUL_OptDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INDUL_OptFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INDUL_OptTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INDUL_Opter">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INDUL_OutDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INDUL_PapmiDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INDUL_PrtDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCINDUL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{INDUL_Rowi}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INDUL_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmDate">
<Global>^DHCINDULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INDUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AdmDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INDUL_AdmDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfAdmDr">
<Global>^DHCINDULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INDUL_AdmDr</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AdmDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INDUL_AdmDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfBMDate">
<Global>^DHCINDULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INDUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"BMDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INDUL_BMDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfDisDate">
<Global>^DHCINDULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INDUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DisDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INDUL_DisDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfDivDr">
<Global>^DHCINDULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INDUL_Rowi</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DivDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INDUL_DivDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfDjlsh">
<Global>^DHCINDULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INDUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Djlsh"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INDUL_InsuDjlsh}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfMedNo">
<Global>^DHCINDULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INDUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MedNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INDUL_MedcasNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfOptDate">
<Global>^DHCINDULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INDUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OptDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INDUL_OptDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfOutDate">
<Global>^DHCINDULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INDUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OutDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INDUL_OutDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfPapmiDr">
<Global>^DHCINDULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INDUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PapmiDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INDUL_PapmiDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfPrtDr">
<Global>^DHCINDULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDUL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PrtDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INDUL_AdmType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDUL_PrtDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INDUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfZylsh">
<Global>^DHCINDULi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>{INDUL_Rowid}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Zylsh"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INDUL_InsuZylsh}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDUL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUEprUlS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
