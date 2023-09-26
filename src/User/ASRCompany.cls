/// 名称:厂商表
/// 编写者:基础数据平台-likefan
/// 编写日期: 2020-09-24
Class User.ASRCompany Extends (%Persistent, User.Abstract) [ SqlRowIdName = ASRC_ID, SqlTableName = ASR_Company, StorageStrategy = SQLStorage ]
{

/// ASRC_AppName 应用名
Property ASRCAppName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ASRC_AppName ];

/// ASRC_CompanyName 公司名
Property ASRCCompanyName As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ASRC_CompanyName ];

/// ASRC_AppVersion 应用版本
Property ASRCAppVersion As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ASRC_AppVersion ];

/// ASRC_ProtocolVersion 通信模块协议版本
Property ASRCProtocolVersion As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ASRC_ProtocolVersion ];

/// ASRC_Company 产商
Property ASRCCompany As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ASRC_Company ];

/// ASRC_CompanyCmd 产商初始化命令串
Property ASRCCompanyCmd As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ASRC_CompanyCmd ];

/// ASRC_StartDate 开始日期
Property ASRCStartDate As %Date [ SqlColumnNumber = 8, SqlFieldName = ASRC_StartDate ];

/// ASRC_EndDate	结束日期
Property ASRCEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = ASRC_EndDate ];

/// ASRC_ServicePath 服务路径
Property ASRCServicePath As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ASRC_ServicePath ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.DOC.ASR.CompanyD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ASRC_AppName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASRC_AppVersion">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ASRC_Company">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ASRC_CompanyCmd">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ASRC_CompanyName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASRC_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ASRC_ProtocolVersion">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASRC_ServicePath">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ASRC_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^CF.DOC.ASR.CompanyD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ASRC_ID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ASRC_ID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCompany">
<Global>^CF.DOC.ASR.CompanyI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ASRC_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Company"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ASRC_Company}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASRC_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ASRC_ID</SqlRowIdName>
<StreamLocation>^CF.DOC.ASR.CompanyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
