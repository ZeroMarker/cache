/// CTOR: QP
/// DATE: 2020-12-17
/// DESC: 门诊化疗床位管理
Class User.ChemoBed Extends (%Persistent, User.Abstract) [ SqlTableName = Chemo_Bed, StorageStrategy = SQLStorage ]
{

/// 化疗日期
Property BChemoDate As %Date [ SqlColumnNumber = 2, SqlFieldName = B_ChemoDate ];

/// 病人
Property BPapmiDR As User.PAPatMas [ SqlColumnNumber = 3, SqlFieldName = B_PapmiDR ];

/// 就诊
Property BAdmDR As User.PAAdm [ SqlColumnNumber = 4, SqlFieldName = B_AdmDR ];

/// 床位类型(A:上午,P:下午)
Property BType As %String [ SqlColumnNumber = 5, SqlFieldName = B_Type ];

/// 床位位置
Property BAddress As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = B_Address ];

/// 用药
Property BDrugList As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = B_DrugList ];

/// 床号
Property BNum As %String [ SqlColumnNumber = 8, SqlFieldName = B_Num ];

/// 就诊科室
Property BAdmLoc As User.CTLoc [ SqlColumnNumber = 9, SqlFieldName = B_AdmLoc ];

/// 录入人
Property BEditUser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = B_EditUser ];

/// 化疗方案
Property BPlanDR As User.ChemoPlan [ SqlColumnNumber = 11, SqlFieldName = B_PlanDR ];

/// 院区
Property BHosp As User.CTHospital [ SqlColumnNumber = 12, SqlFieldName = B_Hosp ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.DOC.Chemo.Count("User.ChemoBed"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="B_Address">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="B_AdmDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="B_AdmLoc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="B_ChemoDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="B_DrugList">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="B_EditUser">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="B_Hosp">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="B_Num">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="B_PapmiDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="B_PlanDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="B_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^BS.DOC.Chemo.BedD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>B_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{B_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxChemoDate">
<Global>^BS.DOC.Chemo.BedI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>B_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{B_ChemoDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxChemoDateAdm">
<Global>^BS.DOC.Chemo.BedI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoDateAdm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{B_ChemoDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_AdmDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxChemoDateBType">
<Global>^BS.DOC.Chemo.BedI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoDateBType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{B_ChemoDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxChemoDateBTypeNum">
<Global>^BS.DOC.Chemo.BedI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>B_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoDateBTypeNum"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{B_ChemoDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_Num}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{B_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxChemoDateLoc">
<Global>^BS.DOC.Chemo.BedI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoDateLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{B_ChemoDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_AdmLoc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxChemoDatePapmi">
<Global>^BS.DOC.Chemo.BedI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoDatePapmi"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{B_ChemoDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_PapmiDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxHospChemoDate">
<Global>^BS.DOC.Chemo.BedI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HospChemoDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{B_Hosp}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_ChemoDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxHospChemoDateAdm">
<Global>^BS.DOC.Chemo.BedI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>B_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HospChemoDateAdm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{B_Hosp}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_ChemoDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_AdmDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{B_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxHospChemoDateBType">
<Global>^BS.DOC.Chemo.BedI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>B_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HospChemoDateBType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{B_Hosp}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_ChemoDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{B_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxHospChemoDateBTypeNum">
<Global>^BS.DOC.Chemo.BedI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>B_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HospChemoDateBTypeNum"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{B_Hosp}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_ChemoDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{B_Num}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{B_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxHospChemoDateLoc">
<Global>^BS.DOC.Chemo.BedI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>B_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HospChemoDateLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{B_Hosp}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_ChemoDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_AdmLoc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{B_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxHospChemoDatePapmi">
<Global>^BS.DOC.Chemo.BedI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>B_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HospChemoDatePapmi"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{B_Hosp}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_ChemoDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_PapmiDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{B_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>B_ID</SqlRowIdName>
<StreamLocation>^User.ChemoBedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
