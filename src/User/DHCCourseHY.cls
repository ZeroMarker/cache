/// 名称: User.DHCCourseHY.cls
/// 描述: 科目SQLStorage表
/// 编写者: 黄钰
/// 编写日期: 2023-09-12
Class User.DHCCourseHY Extends %Persistent [ SqlRowIdName = Crs_RowID, Not SqlRowIdPrivate, SqlTableName = DHC_Course_HY, StorageStrategy = NewStorage1 ]
{

/// 科目号
Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 科目名称
Property CrsDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 是否可用
Property CrsActiveFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCCOURSEHY(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Crs_ActiveFlag">
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
<Global>^DHCCOURSEHY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Crs_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Crs_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCOURSEHY</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Crs_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Crs_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Crs_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCCOURSEHY</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Crs_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Crs_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Crs_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCourseHYS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
