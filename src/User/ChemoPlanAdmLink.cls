/// CTOR: QP
/// DATE: 2020-06-28
/// DESC: 化疗方案就诊关联
Class User.ChemoPlanAdmLink Extends %Persistent [ SqlTableName = Chemo_PlanAdmLink, StorageStrategy = SQLStorage ]
{

/// 化疗方案
Property PAPLID As User.ChemoPlan [ SqlColumnNumber = 2, SqlFieldName = PA_PLID ];

/// 就诊ID
Property PAAdmID As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = PA_AdmID ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.DOC.Chemo.Count("User.ChemoPlanAdmLink"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PA_AdmID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PA_PLID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^BS.DOC.Chemo.PlanAdmLinkD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PA_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxAdmID">
<Global>^BS.DOC.Chemo.PlanAdmLinkI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AdmID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_AdmID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPLIDAdmID">
<Global>^BS.DOC.Chemo.PlanAdmLinkI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PLIDAdmID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_PLID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_AdmID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PA_ID</SqlRowIdName>
<StreamLocation>^User.ChemoPlanAdmLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
