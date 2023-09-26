/// Function:学生选课表(SQLStorage)
/// CreateDate:2023-09-15
/// Creator:yanghongrui
Class User.DHCStudentCourseRR Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_StudentCourseRR, StorageStrategy = NewStorage1 ]
{

/// 建立关系
Relationship ParRef As DHCStudentH [ Cardinality = parent, Inverse = ChildCourse, SqlFieldName = DHCSc_ParRef ];

/// 定义 ChildSub
Property DHCScChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCSTUDENTY(+$s($d(initvalue):initvalue,1:%d(0)),"Course",0))}, Required, SqlColumnNumber = 2, SqlFieldName = DHCSc_ChildSub ];

/// 课程
Property DHCScCourseDR As DHCCourseC [ SqlColumnNumber = 3, SqlFieldName = DHCSc_Course_DR ];

/// 成绩
Property DHCScScore As %Integer [ SqlColumnNumber = 4, SqlFieldName = DHC_ScScore ];

/// 创建ChildSub索引
Index RowIDBasedIDKeyIndex On DHCScChildSub [ IdKey, PrimaryKey, Unique ];

Storage NewStorage1
{
<SQLMap name="DataMaster">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="DHCSc_Course_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHC_ScScore">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSTUDENTY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StudentH.St_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCSc_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_StudentH.St_RowId}</Expression>
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
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCSTUDENTY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StudentH.St_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHCSc_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_StudentH.St_RowId}</Expression>
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
<StreamLocation>^User.DHCStudentCourseRRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
