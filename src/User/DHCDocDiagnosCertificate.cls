Class User.DHCDocDiagnosCertificate Extends %Persistent [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHC_DocDiagnosCertificate, StorageStrategy = NewStorage1 ]
{

/// 就诊ID
Property DDCAdmDr As PAAdm [ SqlColumnNumber = 2, SqlFieldName = DDC_Adm_Dr ];

/// 诊断表rowid串，多个以,分割
Property DDCDiagnosIDStr As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = DDC_DiagnosIDStr ];

/// 确诊日期
Property DDCDiagConfirmDate As %String [ SqlColumnNumber = 4, SqlFieldName = DDC_DiagConfirmDate ];

/// 建议休假天数
Property DDCDaysOff As %String [ SqlColumnNumber = 5, SqlFieldName = DDC_DaysOff ];

/// 医生建议
Property DDCDocNotes As %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = DDC_DocNotes ];

/// 诊断证明书备注
Property DDCNotes As %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = DDC_Notes ];

/// 诊断证明书状态 P 已打印 UnP 未打印 U 已作废
Property DDCStatus As %String [ SqlColumnNumber = 8, SqlFieldName = DDC_Status ];

/// 增加人
Property DDCAddUserDr As SSUser [ SqlColumnNumber = 9, SqlFieldName = DDC_AddUser_Dr ];

/// 增加日期
Property DDCAddDate As %Date [ SqlColumnNumber = 10, SqlFieldName = DDC_AddDate ];

/// 增加时间
Property DDCAddTime As %Time [ SqlColumnNumber = 11, SqlFieldName = DDC_AddTime ];

/// 患者ID--用以生成患者索引
Property DDCPatientDr As PAPatMas [ SqlColumnNumber = 12, SqlFieldName = DDC_Patient_Dr ];

/// 记录最后一次打印时的单位
Property DDCCompany As %String [ SqlColumnNumber = 13, SqlFieldName = DDC_Company ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCDOCDiagnosCertificate(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DDC_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DDC_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DDC_AddUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DDC_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDC_Company">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DDC_DaysOff">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DDC_DiagConfirmDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DDC_DiagnosIDStr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDC_DocNotes">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DDC_Notes">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DDC_Patient_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DDC_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCDOCDiagnosCertificate</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DDC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DDC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAddDate">
<Global>^DHCDOCDiagnosCertificate</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DDC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AddDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DDC_AddDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCDOCDiagnosCertificate</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DDC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AdmDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DDC_Adm_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatientAddDate">
<Global>^DHCDOCDiagnosCertificate</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DDC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PatAddDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DDC_Patient_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDC_AddDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DDC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocDiagnosCertificateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
