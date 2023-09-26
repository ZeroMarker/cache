/// CTOR: QP
/// DATE: 2020-09-11
/// DESC: 筛选结果
Class User.GCPSWResult Extends %Persistent [ SqlTableName = GCPSW_Result, StorageStrategy = SQLStorage ]
{

Relationship ChildAdm As User.GCPSWResultAdm [ Cardinality = children, Inverse = PAParRef ];

Relationship ChildLis As User.GCPSWResultLis [ Cardinality = children, Inverse = PLParRef ];

/// 项目
Property RPrj As User.GCPSWPrj [ SqlColumnNumber = 2, SqlFieldName = R_Prj ];

/// 病人ID
Property RPatientID As User.PAPatMas [ SqlColumnNumber = 3, SqlFieldName = R_PatientID ];

/// 就诊科室
Property RAdmDep As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = R_AdmDep ];

/// 就诊医生
Property RAdmDoc As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = R_AdmDoc ];

/// 创建日期	
Property RAddDate As %Date [ SqlColumnNumber = 6, SqlFieldName = R_AddDate ];

/// 创建时间	
Property RAddTime As %Time [ SqlColumnNumber = 7, SqlFieldName = R_AddTime ];

/// 创建人
Property RAddUser As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = R_AddUser ];

/// 删除标记(空,1删除)
Property RDel As %String [ SqlColumnNumber = 9, SqlFieldName = R_Del ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.DOC.GCPSW.Result(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="R_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="R_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="R_AddUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="R_AdmDep">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="R_AdmDoc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="R_Del">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="R_PatientID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="R_Prj">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^BS.DOC.GCPSW.ResultD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>R_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{R_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxPrj">
<Global>^BS.DOC.GCPSW.ResultI</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>R_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RPrj"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{R_Prj}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{R_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPrjPat">
<Global>^BS.DOC.GCPSW.ResultI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>R_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PrjPat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{R_Prj}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{R_PatientID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{R_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>R_ID</SqlRowIdName>
<StreamLocation>^User.GCPSWResultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
