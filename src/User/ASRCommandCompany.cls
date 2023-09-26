/// 应用场景关联厂商表
/// 基础数据平台-likefan
/// 2020-9-25
Class User.ASRCommandCompany Extends %Persistent [ SqlRowIdName = ASRCC_ID, SqlTableName = ASR_CommandCompany, StorageStrategy = NewStorage1 ]
{

/// ASRCC_ScenesDR 应用场景DR
Property ASRCCScenesDR As User.ASRCommandSetScenes [ SqlColumnNumber = 2, SqlFieldName = ASRCC_ScenesDR ];

/// ASRCC_CompanyDR 厂商DR
Property ASRCCCompanyDR As User.ASRCompany [ SqlColumnNumber = 3, SqlFieldName = ASRCC_CompanyDR ];

/// ASRCC_DateFrom
Property ASRCCDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ASRCC_DateFrom ];

/// ASRCC_DateTo
Property ASRCCDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ASRCC_DateTo ];

Storage NewStorage1
{
<SqlIdExpression>$i(^CF.DOC.ASR.CommandCompanyD(0))</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="ASRCC_CompanyDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASRCC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ASRCC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASRCC_ScenesDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CF.DOC.ASR.CommandCompanyD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ASRCC_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ASRCC_ID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexScenesCompany">
<Global>^CF.DOC.ASR.CommandCompanyI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ASRCC_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ScenesCompany"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ASRCC_ScenesDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASRCC_CompanyDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ASRCC_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ASRCC_ID</SqlRowIdName>
<StreamLocation>^User.ASRCommandCompanyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
