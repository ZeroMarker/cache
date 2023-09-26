/// CTOR: QP
/// DATE: 2019-10-08
/// DESC: 语音命令集场景参数表
Class User.ASRCommandParams Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = ASR_CommandParams, StorageStrategy = SQLStorage ]
{

/// ASRP_ScenesDR 场景关联
Property ASRPScenesDR As User.ASRCommandSetScenes [ SqlColumnNumber = 2, SqlFieldName = ASRP_ScenesDR ];

/// ASRP_CustomCommandName 自定义命令名
Property ASRPCustomCommandName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ASRP_CustomCommandName ];

/// ASRP_CustomCommandType 自定义命令类型
Property ASRPCustomCommandType As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ASRP_CustomCommandType ];

/// ASRP_CustomCommandTypeValue 自定义命令类型值
Property ASRPCustomCommandTypeValue As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ASRP_CustomCommandTypeValue ];

/// ASRP_Remark 备注说明
Property ASRPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ASRP_Remark ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.DOC.ASR.CommandParamsD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ASRP_CustomCommandName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASRP_CustomCommandType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ASRP_CustomCommandTypeValue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASRP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ASRP_ScenesDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CF.DOC.ASR.CommandParamsD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ASRP_ID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ASRP_ID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxCustomCommandName">
<Global>^CF.DOC.ASR.CommandParamsI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ASRP_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CustomCommandName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ASRP_CustomCommandName}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASRP_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxScenesCmd">
<Global>^CF.DOC.ASR.CommandParamsI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ASRP_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ScenesCmd"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ASRP_ScenesDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASRP_CustomCommandName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ASRP_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ASRP_ID</SqlRowIdName>
<StreamLocation>^User.ASRCommandParamsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
