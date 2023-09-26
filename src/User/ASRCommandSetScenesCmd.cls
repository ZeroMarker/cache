/// CTOR: QP
/// DATE: 2019-10-08
/// DESC: 语音命令集场景命令指令表
Class User.ASRCommandSetScenesCmd Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = ASR_CommandSetScenesCmd, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ASRCChildSub [ IdKey, PrimaryKey, Unique ];

/// ASRC_Parref
Relationship ASRCParref As User.ASRCommandSetScenes [ Cardinality = parent, Inverse = CmdDetail, Required, SqlFieldName = ASRC_Parref ];

/// ASRC_ChildSub
Property ASRCChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^CF.DOC.ASR.CommandSetD(+$s($d(initvalue):initvalue,1:%d(0)),"Scenes",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"||",2),"Cmd",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ASRC_ChildSub ];

/// ASRC_IsParamCommand 是否有参数命令（Y/N）
Property ASRCIsParamCommand As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = ASRC_IsParamCommand ];

/// ASRC_CommandName 命令名
Property ASRCCommandName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ASRC_CommandName ];

/// ASRC_Expression 命令描述或表达式
Property ASRCExpression As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ASRC_Expression ];

/// ASRC_ParamFormat 参数格式
Property ASRCParamFormat As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ASRC_ParamFormat ];

/// ASRC_ParamType 参数类型
Property ASRCParamType As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ASRC_ParamType ];

/// ASRC_TriggerType 触发类型
Property ASRCTriggerType As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ASRC_TriggerType ];

/// ASRC_TriggerTypeExpression 触发类型表达式
Property ASRCTriggerTypeExpression As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = ASRC_TriggerTypeExpression ];

/// ASRC_CommandParam 命令参数 20200925
Property ASRCCommandParam As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ASRC_CommandParam ];

/// ASRC_ParamDescription 命令参数说明 20200925
Property ASRCParamDescription As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = ASRC_ParamDescription ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="ASRC_CommandName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASRC_CommandParam">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ASRC_Expression">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ASRC_IsParamCommand">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASRC_ParamDescription">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ASRC_ParamFormat">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASRC_ParamType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ASRC_TriggerType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ASRC_TriggerTypeExpression">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^CF.DOC.ASR.CommandSetD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ASR_CommandSet.ASR_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ASR_CommandSetScenes.ASRS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ASRC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ASR_CommandSet.ASR_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Scenes"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASR_CommandSetScenes.ASRS_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Cmd"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ASRC_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxCommandName">
<Global>^CF.DOC.ASR.CommandSetI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ASR_CommandSet.ASR_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ASR_CommandSetScenes.ASRS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ASRC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CommandName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ASR_CommandSet.ASR_ID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASR_CommandSetScenes.ASRS_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ASRC_CommandName}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ASRC_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ASRC_ID</SqlRowIdName>
<StreamLocation>^User.ASRCommandSetScenesCmdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
