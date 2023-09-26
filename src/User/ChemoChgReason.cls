/// CTOR: QP
/// DATE: 2020-04-22
/// DESC: 化疗项目变更原因
Class User.ChemoChgReason Extends (%Persistent, User.Abstract) [ SqlTableName = Chemo_ChgReason, StorageStrategy = SQLStorage ]
{

/// 变更原因
Property CRReason As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CR_Reason ];

/// 化疗模板
Property CRTemplateDR As User.ChemoTemplate [ SqlColumnNumber = 3, SqlFieldName = CR_TemplateDR ];

/// 有效标志
Property CRActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = CR_Active ];

/// 所属院区
Property CRHosp As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = CR_Hosp ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.DOC.Chemo.Count("User.ChemoChgReason"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CR_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CR_Hosp">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CR_Reason">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CR_TemplateDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CF.DOC.Chemo.ChgReasonD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CR_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CR_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CR_ID</SqlRowIdName>
<StreamLocation>^User.ChemoChgReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
