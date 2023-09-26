/// Function:课程类(SqlStorage)
/// CreateDate:2023-09-12
/// Creator:孔晋川
Class User.DHCCourseKjcS Extends %Persistent [ SqlTableName = DHC_CourseKjcS, StorageStrategy = NewStorage1 ]
{

/// 编码
Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 描述
Property CrsDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 有效标志
Property CrsActiveFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCCOURSEKJCS(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<ConditionalWithHostVars></ConditionalWithHostVars>
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
<Global>^DHCCOURSEKJCS</Global>
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
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCCOURSEKJCS</Global>
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
<Expression>{Crs_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Crs_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCCOURSEKJCS</Global>
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
<StreamLocation>^User.DHCCourseKjcSS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
