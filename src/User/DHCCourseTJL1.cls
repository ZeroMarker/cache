Class User.DHCCourseTJL1 Extends %Persistent [ SqlRowIdName = "", SqlTableName = DHC_CourseTJL, StorageStrategy = NewStorage1 ]
{

// 代码

Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

// 名称

Property CrsDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

// 有效标志

Property CrsActive As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_Active ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCSTUDENTK(0))</SqlIdExpression>
<SQLMap name="IndexCOde">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCSTUDENTK</Global>
<PopulationType>nonnull</PopulationType>
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
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^STUDENT</Global>
<PopulationType>nonnull</PopulationType>
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
<SQLMap name="Master Map">
<ConditionalWithHostVars></ConditionalWithHostVars>
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
<Global>^DHCSTUDENTK</Global>
<PopulationType>nonnull</PopulationType>
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
<SqlRowIdName>Crs_RowID</SqlRowIdName>
<StreamLocation>^User.DHCCourseTJL1S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
