/// CTOR: QP
/// DATE: 2020-11-05
/// DESC: 禁用药设置
Class User.GCPSWarning Extends (%Persistent, User.Abstract) [ SqlTableName = GCPSW_Warning, StorageStrategy = SQLStorage ]
{

/// 禁用药类型(A,D,N:医嘱项,药学项,不明确)
Property WType As %String [ SqlColumnNumber = 2, SqlFieldName = W_Type ];

/// 关联项目
Property WPrj As User.DHCDocPilotProject [ SqlColumnNumber = 3, SqlFieldName = W_Prj ];

/// 禁用项目
Property WItem As %String [ SqlColumnNumber = 4, SqlFieldName = W_Item ];

/// 提示信息
Property WMsg As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = W_Msg ];

/// 备注
Property WNote As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = W_Note ];

/// 添加日期
Property WAddDate As %String [ SqlColumnNumber = 7, SqlFieldName = W_AddDate ];

/// 添加时间
Property WAddTime As %String [ SqlColumnNumber = 8, SqlFieldName = W_AddTime ];

/// 添加用户
Property WAddUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = W_AddUser ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.DOC.GCPSW.Warning(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="W_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="W_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="W_AddUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="W_Item">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="W_Msg">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="W_Note">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="W_Prj">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="W_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CF.DOC.GCPSW.WarningD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>W_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{W_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxPrj">
<Global>^CF.DOC.GCPSW.WarningI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>W_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"WPrj"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{W_Prj}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{W_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxWItem">
<Global>^CF.DOC.GCPSW.WarningI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>W_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"WItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{W_Prj}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{W_Item}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{W_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxWType">
<Global>^CF.DOC.GCPSW.WarningI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>W_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"WType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{W_Prj}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{W_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{W_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxWTypeItem">
<Global>^CF.DOC.GCPSW.WarningI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>W_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"WTypeItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{W_Prj}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{W_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{W_Item}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{W_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>W_ID</SqlRowIdName>
<StreamLocation>^User.GCPSWarningS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
