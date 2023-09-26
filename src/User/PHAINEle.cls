/// 页面元素定义
Class User.PHAINEle Extends (%Persistent, User.Abstract) [ SqlTableName = PHAIN_Ele, StorageStrategy = CacheSQLStorage ]
{

Relationship ChildPHAINEleItm As User.PHAINEleItm [ Cardinality = children, Inverse = EleItmParref ];

/// 元素代码
Property EleCode As %String(MAXLEN = 150) [ Required, SqlColumnNumber = 2, SqlFieldName = Ele_Code ];

/// 元素名称
Property EleDesc As %String(MAXLEN = 150) [ Required, SqlColumnNumber = 3, SqlFieldName = Ele_Desc ];

/// 层级,指上一层
Property ElePar As %String [ Required, SqlColumnNumber = 4, SqlFieldName = Ele_Par ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^CF.PHA.IN.Ele)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Ele_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Ele_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Ele_Par">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CF.PHA.IN.Ele</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Ele_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Ele_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CF.PHA.IN.Elei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Ele_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Ele_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Ele_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>Ele_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINEleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
