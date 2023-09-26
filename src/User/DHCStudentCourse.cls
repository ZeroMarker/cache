Class User.DHCStudentCourse Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_StudentCourse, StorageStrategy = NewStorage1 ]
{

Relationship StudentParRef As DHCStudent1 [ Cardinality = parent, Inverse = ChildCourse, SqlFieldName = DHCSc_ParRef ];

Property DHCScChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCSTUDENT(+$s($d(initvalue):initvalue,1:%d(0)),"Course",0))}, Required, SqlColumnNumber = 2, SqlFieldName = DHCSc_ChildSub ];

Property DHCScCourseDR As DHCCourseYWB [ SqlColumnNumber = 3, SqlFieldName = DHCSc_Course_DR ];

Property DHCScScore As %Integer [ SqlColumnNumber = 4, SqlFieldName = DHC_ScScore ];

Index RowIDBasedIDKeyIndex On DHCScChildSub [ IdKey, PrimaryKey, Unique ];

Storage NewStorage1
{
<SQLMap name="DataMaser">
<Data name="DHCSc_Course_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHC_ScScore">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSTUDENT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_Student1.St_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCSc_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_Student1.St_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"Course"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCSc_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCourse">
<Global>^DHCSTUDENT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_Student1.St_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHCSc_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_Student1.St_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Course"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"CourseDR"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCSc_Course_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCSc_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DHCSc_RowId</SqlRowIdName>
<StreamLocation>^User.DHCStudentCourseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
