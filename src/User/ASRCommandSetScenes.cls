/// CTOR: QP
/// DATE: 2019-10-08
/// DESC: 语音命令集场景表
Class User.ASRCommandSetScenes Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = ASR_CommandSetScenes, StorageStrategy = SQLStorage ]
{

Relationship ASRSParRef As User.ASRCommandSet [ Cardinality = parent, Inverse = ChildASRS, Required, SqlFieldName = ASRS_ParRef ];

Relationship CmdDetail As User.ASRCommandSetScenesCmd [ Cardinality = children, Inverse = ASRCParref ];

Index RowIDBasedIDKeyIndex On ASRSChildSub [ IdKey, PrimaryKey, Unique ];

/// ASRS_ChildSub
Property ASRSChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^CF.DOC.ASR.CommandSetD($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"Scenes",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ASRS_ChildSub ];

/// ASRS_Scenes 场景
Property ASRSScenes As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ASRS_Scenes ];

/// ASRS_ScenesCommandName 场景命令名
Property ASRSScenesCommandName As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ASRS_ScenesCommandName ];

/// ASRS_ActiveFlag 有效标识（Y/N）
Property ASRSActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ASRS_ActiveFlag ];

/// ASRS_Remark 备注说明
Property ASRSRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ASRS_Remark ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="ASRS_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ASRS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASRS_Scenes">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASRS_ScenesCommandName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CF.DOC.ASR.CommandSetD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ASR_CommandSet.ASR_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ASRS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ASR_CommandSet.ASR_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Scenes"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASRS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxScenes">
<Global>^CF.DOC.ASR.CommandSetI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ASR_CommandSet.ASR_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ASRS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Scenes"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ASRS_Scenes}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASR_CommandSet.ASR_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ASRS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ASRS_ID</SqlRowIdName>
<StreamLocation>^User.ASRCommandSetScenesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
