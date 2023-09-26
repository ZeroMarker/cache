/// CTOR: QP
/// DATE: 2020-06-12
/// DESC: 化疗方案化疗组项目医嘱关联
Class User.ChemoPlanOrder Extends %Persistent [ SqlTableName = Chemo_PlanOrder, StorageStrategy = SQLStorage ]
{

/// 医嘱ID
Property POOeori As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = PO_Oeori ];

/// 化疗项目
Property POPlanItemDR As User.ChemoPlanItem [ SqlColumnNumber = 3, SqlFieldName = PO_PlanItemDR ];

/// 化疗日期
Property POXDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = PO_XDate ];

/// 医嘱项
Property POArcim As User.ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = PO_Arcim ];

/// 就诊
Property POAdm As User.PAAdm [ SqlColumnNumber = 6, SqlFieldName = PO_Adm ];

/// 病人DI
Property POPatientDR As User.PAPatMas [ SqlColumnNumber = 7, SqlFieldName = PO_PatientDR ];

/// 申请ID
Property POPDAID As User.ChemoPlanDateApply [ SqlColumnNumber = 8, SqlFieldName = PO_PDAID ];

/// 插入日期
Property POInsertDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = PO_InsertDate ];

/// 插入时间
Property POInsertTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = PO_InsertTime ];

/// 关联申请ID
Property POLinkPDAID As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = PO_LinkPDAID ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.DOC.Chemo.Count("User.ChemoPlanOrder"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PO_Adm">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PO_Arcim">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PO_InsertDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PO_InsertTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PO_LinkPDAID">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PO_Oeori">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PO_PDAID">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PO_PatientDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PO_PlanItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PO_XDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^BS.DOC.Chemo.PlanOrderD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PO_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PO_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxAdm">
<Global>^BS.DOC.Chemo.PlanOrderI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PO_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PO_Adm}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PO_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxAdmArcim">
<Global>^BS.DOC.Chemo.PlanOrderI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PO_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AdmArcim"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PO_Adm}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PO_Arcim}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PO_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxArcim">
<Global>^BS.DOC.Chemo.PlanOrderI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PO_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Arcim"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PO_Arcim}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PO_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxOeori">
<Global>^BS.DOC.Chemo.PlanOrderI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PO_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Oeori"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PO_Oeori}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PO_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPAIDItemDR">
<Global>^BS.DOC.Chemo.PlanOrderI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PO_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PDAIDItemDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PO_PDAID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PO_PlanItemDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PO_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPDAID">
<Global>^BS.DOC.Chemo.PlanOrderI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PO_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PDAID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PO_PDAID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PO_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPatient">
<Global>^BS.DOC.Chemo.PlanOrderI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PO_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PatientDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PO_PatientDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PO_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPatientArcim">
<Global>^BS.DOC.Chemo.PlanOrderI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PO_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PatientArcim"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PO_PatientDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PO_Arcim}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PO_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PO_ID</SqlRowIdName>
<StreamLocation>^User.ChemoPlanOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
