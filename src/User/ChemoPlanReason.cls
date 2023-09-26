/// CTOR: QP
/// DATE: 2020-06-24
/// DESC: 化疗变更原因记录表
Class User.ChemoPlanReason Extends %Persistent [ SqlTableName = Chemo_PlanReason, StorageStrategy = SQLStorage ]
{

/// 化疗组
Property PRPGID As User.ChemoPlanGroup [ SqlColumnNumber = 2, SqlFieldName = PR_PGID ];

/// 化疗项目
Property PRPIID As User.ChemoPlanItem [ SqlColumnNumber = 3, SqlFieldName = PR_PIID ];

/// 操作类型(ADD/DEL)
Property PRAction As %String [ SqlColumnNumber = 4, SqlFieldName = PR_Action ];

/// 剂量单位
Property PRPatientID As User.PAPatMas [ SqlColumnNumber = 5, SqlFieldName = PR_PatientID ];

/// 剂量单位
Property PRAdmID As User.PAAdm [ SqlColumnNumber = 6, SqlFieldName = PR_AdmID ];

/// 剂量单位
Property PRArcim As User.ARCItmMast [ SqlColumnNumber = 7, SqlFieldName = PR_Arcim ];

/// 变更原因
Property PRReasonDR As User.ChemoChgReason [ SqlColumnNumber = 8, SqlFieldName = PR_ReasonDR ];

/// 变更人
Property PRUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PR_User ];

/// 变更科室
Property PRLoc As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = PR_Loc ];

/// 变更日期
Property PRDate As %Date [ SqlColumnNumber = 11, SqlFieldName = PR_Date ];

/// 变更时间
Property PRTime As %Time [ SqlColumnNumber = 12, SqlFieldName = PR_Time ];

/// 化疗周期
Property PRPSID As User.ChemoPlanStage [ SqlColumnNumber = 13, SqlFieldName = PR_PSID ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.DOC.Chemo.Count("User.ChemoPlanReason"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PR_Action">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PR_AdmID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PR_Arcim">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PR_Date">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PR_Loc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PR_PGID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PR_PIID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PR_PSID">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PR_PatientID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PR_ReasonDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PR_Time">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PR_User">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^CF.DOC.Chemo.PlanReasonD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PR_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PR_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxAdmID">
<Global>^CF.DOC.Chemo.PlanReasonI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PR_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AdmID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PR_AdmID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PR_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPGID">
<Global>^CF.DOC.Chemo.PlanReasonI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PR_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PGID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PR_PGID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PR_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPIID">
<Global>^CF.DOC.Chemo.PlanReasonI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PR_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PIID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PR_PIID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PR_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPatientID">
<Global>^CF.DOC.Chemo.PlanReasonI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PR_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PatientID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PR_PatientID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PR_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PR_ID</SqlRowIdName>
<StreamLocation>^User.ChemoPlanReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
