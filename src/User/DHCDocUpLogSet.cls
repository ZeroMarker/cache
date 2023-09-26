Class User.DHCDocUpLogSet Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCDocUpLogSet, StorageStrategy = SQLStorage ]
{

/// 需要做日志的实体类名
Property UPLSClassName As %String [ SqlColumnNumber = 2, SqlFieldName = UPLS_ClassName ];

/// 需要做日志的实体类字段
Property UPLSClassProperty As %String [ SqlColumnNumber = 3, SqlFieldName = UPLS_ClassProperty ];

/// 需要做日志的实体类字段顺序
Property UPLSClassPropertyIndex As %String [ SqlColumnNumber = 4, SqlFieldName = UPLS_ClassPropertyIndex ];

/// 需要做日志的实体类字段描述
Property UPLSClassPropertyDescription As %String [ SqlColumnNumber = 5, SqlFieldName = UPLS_ClassPropertyDescription ];

/// 需要PropertyLink 获取实体类字段如为关联类则 需要存储PropertyLink取值字段
Property UPLSClassPropertyLink As %String [ SqlColumnNumber = 6, SqlFieldName = UPLS_ClassPropertyLink ];

Storage SQLStorage
{
<SqlIdExpression>$i(^User.DHCDOCUPDATELS(0))</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="UPLS_ClassName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UPLS_ClassProperty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UPLS_ClassPropertyDescription">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UPLS_ClassPropertyIndex">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UPLS_ClassPropertyLink">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^User.DHCDOCUPDATELS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UPLS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{UPLS_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTableMap">
<Global>^User.DHCDOCUPDATELS</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UPLS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Class"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UPLS_ClassName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPLS_ClassPropertyIndex}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UPLS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>UPLS_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocUpLogSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
