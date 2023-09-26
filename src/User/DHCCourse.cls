/// 课程持久类
/// Creator: 赵子豪
Class User.DHCCourse Extends %Persistent [ SqlTableName = DHC_Course, StorageStrategy = MyStorage ]
{

/// 代码
Property CrsCode As %String [ SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 名称
Property CrsDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 激活标致
Property CrsActiveFlag As %String(ValueList = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

Storage MyStorage
{
<SqlIdExpression>$i(^DHCCOURSE(0))</SqlIdExpression>
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
<Global>^DHCCOURSE</Global>
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
<Global>^DHCCOURSE</Global>
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
<Global>^DHCCOURSE</Global>
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
<Type>%Storage.SQL</Type>
}

}
