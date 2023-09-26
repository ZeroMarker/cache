/// 科目表：DHC_CourseHXRR
/// 表名DHC_Course ,类名User.DHCCourse 主键  Crs_RowID
/// 字段Crs_Code,Crs_Desc,Crs_ActiveFlag(Y/N)
/// crestor:黄欣然
Class User.DHCcourseHXRR Extends %Persistent [ SqlTableName = DHC_CourseHXRR, StorageStrategy = NewStorage1 ]
{

/// 号
Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_code ];

/// 描述
Property CrsDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 是否有效
Property CrsActiveFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

/// 索引
Index Code On CrsCode As Exact;

Index Desc On CrsDesc As Exact;

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCCOURSEA)</SqlIdExpression>
<SQLMap name="DataMater">
<Data name="Crs_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Crs_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Crs_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCOURSEA</Global>
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
<Global>^DHCSTUDENTA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Crs_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Crs_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Crs_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCSTUDENTA</Global>
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
<SqlRowIdName>Crs_RowID</SqlRowIdName>
<StreamLocation>^User.DHCcourseHXRRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
