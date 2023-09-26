/// CTOR: QP
/// DATE: 2019-10-08
/// DESC: 语音命令集表
Class User.ASRCommandSet Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = ASR_CommandSet, StorageStrategy = SQLStorage ]
{

/// ASR_AppName 应用名
Property ASRAppName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ASR_AppName ];

/// ASR_CompanyName 公司名
Property ASRCompanyName As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ASR_CompanyName ];

/// ASR_AppVersion 应用版本
Property ASRAppVersion As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ASR_AppVersion ];

/// ASR_ProtocolVersion 通信模块协议版本
Property ASRProtocolVersion As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ASR_ProtocolVersion ];

/// ASR_Company 产商
Property ASRCompany As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ASR_Company ];

/// ASR_CompanyCmd 产商初始化命令串
Property ASRCompanyCmd As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ASR_CompanyCmd ];

/// ASR_StartDate 开始日期
Property ASRStartDate As %Date [ SqlColumnNumber = 8, SqlFieldName = ASR_StartDate ];

/// ASR_EndDate	结束日期
Property ASREndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = ASR_EndDate ];

/// ASR_ServicePath 服务路径
Property ASRServicePath As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ASR_ServicePath ];

/// ASR_VoiceprintScore 声纹认证分值
Property ASRVoiceprintScore As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = ASR_VoiceprintScore ];

Relationship ChildASRS As User.ASRCommandSetScenes [ Cardinality = children, Inverse = ASRSParRef ];

Index RowIDBasedIDKeyIndex On ASRID [ IdKey, PrimaryKey, Unique ];

/// ASR_ID
Property ASRID As %Numeric(SCALE = 0) [ InitialExpression = {$i(^CF.DOC.ASR.CommandSetD(0))}, Required, SqlFieldName = ASR_ID ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.DOC.ASR.CommandSetD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ASR_AppName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASR_AppVersion">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ASR_Company">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ASR_CompanyCmd">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ASR_CompanyName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASR_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ASR_ProtocolVersion">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASR_ServicePath">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ASR_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ASR_VoiceprintScore">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^CF.DOC.ASR.CommandSetD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ASR_ID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ASR_ID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxAppName">
<Global>^CF.DOC.ASR.CommandSetI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ASR_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AppName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ASR_AppName}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASR_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxCompany">
<Global>^CF.DOC.ASR.CommandSetI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ASR_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Company"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ASR_Company}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASR_AppName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ASR_AppVersion}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ASR_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ASRP_ID</SqlRowIdName>
<StreamLocation>^User.ASRCommandSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
