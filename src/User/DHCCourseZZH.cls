/// Description:	课程类 (SqlStorage)
/// CreateDate:	2023年9月12日
/// Creator:		赵子豪
Class User.DHCCourseZZH Extends %Persistent [ SqlTableName = DHC_CourseZZH, StorageStrategy = MyStorage ]
{

/// 代码
Property CrsCode As %String [ SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 名称
Property CrsDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 激活标致
Property CrsActiveFlag As %String(VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

Storage MyStorage
{
<SqlIdExpression>$i(^DHCCOURSEZZH)</SqlIdExpression>
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
<Global>^DHCCOURSEZZH</Global>
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
<Global>^DHCCOURSEZZH</Global>
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
<Global>^DHCCOURSEZZH</Global>
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
<SqlRowIdName>Crs_RowID</SqlRowIdName>
<StreamLocation>^User.DHCCourseZZHS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
