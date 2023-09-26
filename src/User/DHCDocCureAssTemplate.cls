/// 治疗评估按照类型保存的模板数据
Class User.DHCDocCureAssTemplate Extends %Persistent [ SqlTableName = DHC_DocCureAssTemplate, StorageStrategy = SQLStorage ]
{

/// DCAssTempType 所属模板
Property DCAssTempType As User.DHCDocAppBLMap [ SqlColumnNumber = 2, SqlFieldName = DCAss_TempType ];

/// DCAss_TempSubType 所属类型  NormalCure 正常治疗 BetterCure 改善治疗 NoEffectCure 无效果
Property DCAssTempSubType As %String(DISPLAYLIST = ",NormalCure,BetterCure,NoEffectCure,ABNormalCure", MAXLEN = 18, TRUNCATE = 1, VALUELIST = ",NC,BC,NEC,ABNC") [ SqlColumnNumber = 3, SqlFieldName = DCAss_TempSubType ];

/// DCAss_TempJsonStr 模板内容
Property DCAssTempJsonStr As %Library.String(MAXLEN = 99999) [ SqlColumnNumber = 4, SqlFieldName = DCAss_TempJsonStr ];

/// DCAss_TempUserDr 模板用户
Property DCAssTempUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = DCAss_TempUserDr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDocCureAssTemp(0))</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="DCAss_TempJsonStr">
<Node>"JsonStr"</Node>
</Data>
<Data name="DCAss_TempSubType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCAss_TempType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCAss_TempUserDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocCureAssTemp</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DCAss_TempRowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DCAss_TempRowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCDocCureAssTempi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCAss_TempRowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCAss_TempType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAss_TempSubType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCAss_TempRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserType">
<Global>^DHCDocCureAssTempi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DCAss_TempRowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UserType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCAss_TempUserDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAss_TempType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCAss_TempSubType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCAss_TempRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DCAss_TempRowID</SqlRowIdName>
<StreamLocation>^User.DHCDocCureAssTemplateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
