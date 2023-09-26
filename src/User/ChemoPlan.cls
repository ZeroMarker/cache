/// CTOR: QP
/// DATE: 2020-06-12
/// DESC: 化疗方案
Class User.ChemoPlan Extends %Persistent [ SqlTableName = Chemo_Plan, StorageStrategy = SQLStorage ]
{

Relationship ChildDetail As User.ChemoPlanStage [ Cardinality = children, Inverse = PSParRef ];

Index RowIDBasedIDKeyIndex On PLID [ IdKey, PrimaryKey, Unique ];

/// PL_ID
Property PLID As %Numeric(SCALE = 0) [ InitialExpression = {$i(^BS.DOC.Chemo.Plan(0))}, Required, SqlFieldName = PL_ID ];

/// 病人
Property PLPatientDR As User.PAPatMas [ SqlColumnNumber = 2, SqlFieldName = PL_PatientDR ];

/// 化疗方案名称
Property PLName As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PL_Name ];

/// 模板
Property PLTemplateDR As User.ChemoTemplate [ SqlColumnNumber = 4, SqlFieldName = PL_TemplateDR ];

/// 开单科室
Property PLOrderDep As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = PL_OrderDep ];

/// 开单人
Property PLOrderUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = PL_OrderUser ];

/// 就诊
Property PLAdmDR As User.PAAdm [ SqlColumnNumber = 7, SqlFieldName = PL_AdmDR ];

/// 方案状态 Y(有效)、N(未生效)、S(停止)、U(完成)、D（删除）
Property PLStatus As %String [ SqlColumnNumber = 8, SqlFieldName = PL_Status ];

/// 方案备注
Property PLNote As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PL_Note ];

/// 检验检查备注
Property PLExamNote As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PL_ExamNote ];

/// 插入日期
Property PLInsertDate As %Date [ SqlColumnNumber = 11, SqlFieldName = PL_InsertDate ];

/// 插入时间
Property PLInsertTime As %Time [ SqlColumnNumber = 12, SqlFieldName = PL_InsertTime ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PL_AdmDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PL_ExamNote">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PL_InsertDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PL_InsertTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PL_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PL_Note">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PL_OrderDep">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PL_OrderUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PL_PatientDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PL_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PL_TemplateDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^BS.DOC.Chemo.PlanD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PL_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PL_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxAdm">
<Global>^BS.DOC.Chemo.PlanI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PL_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoPlan"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PL_AdmDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PL_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPatient">
<Global>^BS.DOC.Chemo.PlanI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PL_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoPlan"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatientDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PL_PatientDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PL_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PL_ID</SqlRowIdName>
<StreamLocation>^User.ChemoPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
