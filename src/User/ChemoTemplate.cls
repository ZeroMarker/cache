/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 化疗单模板
Class User.ChemoTemplate Extends (%Persistent, User.Abstract) [ SqlTableName = Chemo_Template, StorageStrategy = SQLStorage ]
{

Relationship ChildDetail As User.ChemoTemplateStage [ Cardinality = children, Inverse = TSParRef ];

Index RowIDBasedIDKeyIndex On TPID [ IdKey, PrimaryKey, Unique ];

/// TP_ID
Property TPID As %Numeric(SCALE = 0) [ InitialExpression = {$i(^CF.DOC.Chemo.Template(0))}, Required, SqlFieldName = TP_ID ];

/// 模板类型
Property TPType As %String [ SqlColumnNumber = 2, SqlFieldName = TP_Type ];

/// 模板描述
Property TPDesc As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = TP_Desc ];

/// 化疗单名称
Property TPName As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = TP_Name ];

/// 总阶段数
Property TPStageNum As %Numeric [ SqlColumnNumber = 5, SqlFieldName = TP_StageNum ];

/// 有效标志
Property TPActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = TP_Active ];

/// 创建日期
Property TPCreateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = TP_CreateDate ];

/// 创建时间
Property TPCreateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = TP_CreateTime ];

/// 创建人
Property TPCreateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = TP_CreateUser ];

/// 最后更新日期
Property TPUpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = TP_UpdateDate ];

/// 最后更新时间
Property TPUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = TP_UpdateTime ];

/// 最后更新人
Property TPUpdateUser As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = TP_UpdateUser ];

/// 化疗方案主药信息备注
Property TPMainNote As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = TP_MainNote ];

/// 化疗方案标题
Property TPTitle As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = TP_Title ];

/// 化疗方案别名
Property TPOtherName As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = TP_OtherName ];

/// 其它描述
Property TPOtherDesc As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = TP_OtherDesc ];

/// 其它科室
Property TPOtherLoc As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = TP_OtherLoc ];

/// 所属院区
Property TPHosp As User.CTHospital [ SqlColumnNumber = 18, SqlFieldName = TP_Hosp ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="TP_Active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TP_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TP_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TP_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TP_Hosp">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="TP_MainNote">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TP_Name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TP_OtherDesc">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TP_OtherLoc">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TP_OtherName">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TP_StageNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TP_Title">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TP_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TP_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^CF.DOC.Chemo.TemplateD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TP_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TP_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxHosp">
<Global>^CF.DOC.Chemo.TemplateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>TP_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoTemplate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TP_Hosp}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TP_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TP_Desc}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TP_Name}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{TP_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxTPOtherDesc">
<Global>^CF.DOC.Chemo.TemplateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TP_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoTemplate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TPOtherDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TP_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TP_OtherDesc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TP_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxTPType">
<Global>^CF.DOC.Chemo.TemplateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TP_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoTemplate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TPType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TP_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TP_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxTPTypeDesc">
<Global>^CF.DOC.Chemo.TemplateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TP_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoTemplate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TPTypeDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TP_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TP_Desc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TP_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxTPTypeDescName">
<Global>^CF.DOC.Chemo.TemplateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TP_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoTemplate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TPTypeDescName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TP_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TP_Desc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TP_Name}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TP_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TP_ID</SqlRowIdName>
<StreamLocation>^User.ChemoTemplateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
