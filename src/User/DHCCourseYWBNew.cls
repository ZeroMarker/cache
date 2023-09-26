/// Function:科目类（SQLStorage存储）
/// CreateTime:2023-09-12
/// Creator:YiWenbo
/// 建立课程表表名DHC_Course ,类名User.DHCCourse 主键  Crs_RowID字段Crs_Code,Crs_Desc,Crs_ActiveFlag(Y/N)
Class User.DHCCourseYWBNew Extends (%Persistent, User.Abstract) [ SqlRowIdName = Crs_RowID, SqlTableName = DHC_CourseYWBNew, StorageStrategy = NewStorage1 ]
{

Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

Property CrsDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

Property CrsActiveFlag As %String(VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

Index CodeIdx On CrsCode [ Unique ];

Storage NewStorage1
{
<SqlIdExpression>$I(^DHCCOURSE(0))</SqlIdExpression>
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
<Global>^DHCCOURSE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Crs_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Crs_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCCOURSE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Crs_RowId</Field>
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
<Expression>{Crs_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>Crs_RowId</SqlRowIdName>
<StreamLocation>^User.DHCCourseYWBNewS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
