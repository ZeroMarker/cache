Class User.MRDiagnosProperty Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_DiagnosProperty, StorageStrategy = SQLStorage ]
{

Relationship ChildMRDiagnosProperty As MRDiagnosPropertyLog [ Cardinality = children, Inverse = DiagPParRef ];

/// 诊断表ID
Property MRDiagnosDR As MRDiagnos [ SqlColumnNumber = 2, SqlFieldName = MR_Diagnos_DR ];

/// 诊断属性表ID
Property DiagnosBaseCatPDR As TKBTremExtend [ SqlColumnNumber = 3, SqlFieldName = Diagnos_BaseCatP_DR ];

/// 树类型属性值
Property DiagnosTreeP As %String [ SqlColumnNumber = 4, SqlFieldName = Diagnos_TreeP ];

/// 下拉框属性值
Property DiagnosComboP As %String [ SqlColumnNumber = 5, SqlFieldName = Diagnos_ComboP ];

/// 文本属性值
Property DiagnosTextP As %String [ SqlColumnNumber = 6, SqlFieldName = Diagnos_TextP ];

/// 多行文本属性值
Property DiagnosTextAP As %String [ SqlColumnNumber = 7, SqlFieldName = Diagnos_TextAP ];

/// 单选框属性值
Property DiagnosRadioP As %String [ SqlColumnNumber = 8, SqlFieldName = Diagnos_RadioP ];

/// 复选框属性值
Property DiagnosCheckBoxP As %String [ SqlColumnNumber = 9, SqlFieldName = Diagnos_CheckBoxP ];

/// 属性备注 
Property DiagnosNotesP As %String(MAXLEN = "") [ SqlColumnNumber = 10, SqlFieldName = Diagnos_NotesP ];

/// 诊断展示名
Property DiagnosDisPlayName As %String(MAXLEN = "") [ SqlColumnNumber = 11, SqlFieldName = Diagnos_DisPlayName ];

Storage SQLStorage
{
<SqlIdExpression>$i(^MR("DIAGP",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="Diagnos_BaseCatP_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Diagnos_CheckBoxP">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Diagnos_ComboP">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Diagnos_DisPlayName">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Diagnos_NotesP">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Diagnos_RadioP">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Diagnos_TextAP">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Diagnos_TextP">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Diagnos_TreeP">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MR_Diagnos_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRDiagnosP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DIAGP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRDiagnosP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMRDiag">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MRDiagnosP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DIAGP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MR_Diagnos_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRDiagnosP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDiagBaseCatP">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MRDiagnosP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DIAGPP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Diagnos_BaseCatP_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRDiagnosP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MRDiagnosP_RowID</SqlRowIdName>
<StreamLocation>^User.MRDiagnosPropertyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
