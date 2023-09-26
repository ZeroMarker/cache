/// Function:学生-课程关联类(SqlStorage存储)
/// CreateDate:2023-09-15
/// Creator:孔晋川
Class User.DHCStudentCourseKjc Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_StudentCourseKjc, StorageStrategy = NewStorage1 ]
{

/// 父表关联
Relationship StudentParRef As DHCStudentKjcS [ Cardinality = parent, Inverse = ChildStudentCourse, SqlFieldName = DHCSc_ParRef ];

/// childSub
Property DHCScChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCSTUDENTKJC(+$s($d(initvalue):initvalue,1:%d(0)),"StudentSub",0))}, Required, SqlColumnNumber = 2, SqlFieldName = DHCSc_ChildSub ];

/// 课程
Property DHCScCourseDR As DHCCourseKjc [ SqlColumnNumber = 3, SqlFieldName = DHCSc_Course_DR ];

/// 成绩
Property DHCScScore As %Integer [ SqlColumnNumber = 4, SqlFieldName = DHCSc_Score ];

/// childSub索引
Index RowIDBasedIDKeyIndex On DHCScChildSub [ IdKey, PrimaryKey, Unique ];

Storage NewStorage1
{
<SQLMap name="DataMaster">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="DHCSc_Course_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCSc_Score">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSTUDENTKJC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StudentKjcS.St_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCSc_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_StudentKjcS.St_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"StudentSub"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCSc_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCourse">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCSTUDENTKJC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StudentKjcS.St_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHCSc_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_StudentKjcS.St_RowId}</Expression>
<StartValue>1</StartValue>
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
<StreamLocation>^User.DHCStudentCourseKjcS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
