/// Function:学生选课表(SQLStorage)
/// CreateDate:2023-09-15
/// Creator:zhangyizhu
Class User.DHCZYZTStudentCourse Extends (%Persistent, User.Abstract) [ SqlTableName = DHCZYZT_StudentCourse, StorageStrategy = NewStorage1 ]
{

/// 建立关系
Relationship StudentParRef As DHCZYZTStudent [ Cardinality = parent, Inverse = ChildCourse, SqlFieldName = Sc_ParRef ];

/// 定义childsub
Property ScChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCZYZTStudent(+$s($d(initvalue):initvalue,1:%d(0)),"Course",0))}, Required, SqlColumnNumber = 2, SqlFieldName = Sc_Childsub ];

/// 课程
Property ScCrsDR As User.DHCZYZTCourse [ Required, SqlColumnNumber = 3, SqlFieldName = Sc_Crs_DR ];

/// 成绩
Property ScScore As %Integer [ SqlColumnNumber = 4, SqlFieldName = Sc_Score ];

/// 创建childsub索引
Index RowIDBasedIDKeyIndex On ScChildsub [ IdKey, PrimaryKey, Unique ];

Storage NewStorage1
{
<SQLMap name="DataMaster">
<Data name="Sc_Crs_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Sc_Score">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCZYZTStudent</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCZYZT_Student.St_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>Sc_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCZYZT_Student.St_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"Course"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Sc_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCourse">
<Global>^DHCZYZTStudent</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCZYZT_Student.St_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>Sc_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCZYZT_Student.St_RowId}</Expression>
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
<Expression>{Sc_Crs_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{Sc_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCZYZTStudentCourseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
