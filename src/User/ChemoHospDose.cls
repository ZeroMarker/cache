/// CTOR: QP
/// DATE: 2020-06-24
/// DESC: 外院剂量
Class User.ChemoHospDose Extends %Persistent [ SqlTableName = Chemo_HospDose, StorageStrategy = SQLStorage ]
{

/// 病人
Property HDPatientDR As User.PAPatMas [ SqlColumnNumber = 2, SqlFieldName = HD_PatientDR ];

/// 就诊
Property HDAdmDR As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = HD_AdmDR ];

/// 化疗药品
Property HDArcimDR As User.ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = HD_ArcimDR ];

/// 终身剂量
Property HDDosage As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = HD_Dosage ];

/// 剂量单位
Property HDUomDR As %String [ SqlColumnNumber = 6, SqlFieldName = HD_UomDR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.DOC.Chemo.Count("User.ChemoHospDose"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HD_AdmDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HD_ArcimDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HD_Dosage">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HD_PatientDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HD_UomDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^BS.DOC.Chemo.HospDoseD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>HD_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{HD_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxAdmArcim">
<Global>^BS.DOC.Chemo.HospDoseI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HD_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AdmArcim"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{HD_AdmDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HD_ArcimDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HD_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPatientArcim">
<Global>^BS.DOC.Chemo.HospDoseI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HD_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PatientArcim"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{HD_PatientDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HD_ArcimDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HD_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPatientDR">
<Global>^BS.DOC.Chemo.HospDoseI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>HD_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PatientDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{HD_PatientDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HD_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HD_ID</SqlRowIdName>
<StreamLocation>^User.ChemoHospDoseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
