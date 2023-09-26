/// Function: 科目表（SQLStorage）
/// CreateDate: 2023-09-13
/// Creator: 魏方茜
Class User.DHCCOURSEWFQ Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_WFQCourse, StorageStrategy = NewStorage1 ]
{

/// 代码
Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 名称
Property CrsDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 有效标志
Property CrsActive As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_Active ];

Storage NewStorage1
{
<SqlIdExpression>$i(DHCWFQCOURSE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Crs_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Crs_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Crs_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCWFQCOURSE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Crs_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Crs_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCWFQCOURSE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Crs_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CrsCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Crs_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Crs_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>Crs_RowId</SqlRowIdName>
<StreamLocation>^User.DHCCOURSEWFQS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
