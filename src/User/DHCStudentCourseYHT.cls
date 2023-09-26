Class User.DHCStudentCourseYHT Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_StudentCourseYHT, StorageStrategy = NewStorage1 ]
{

Relationship DHCScStudentParRef As DHCStudentYHT [ Cardinality = parent, Inverse = ChildStudentCourse, SqlFieldName = DHCSC_St_ParRef ];

Property DHCScChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^StudentInfoSQLYHT(+$s($d(initvalue):initvalue,1:%d(0)),"Course",0))}, Required, SqlColumnNumber = 2, SqlFieldName = DHCSC_Childsub ];

/// 课程
Property DHCScCourseDR As DHCCourseYHT [ SqlColumnNumber = 3, SqlFieldName = DHCSC_Course_DR ];

/// 成绩
Property DHCScScore As %Integer [ SqlColumnNumber = 4, SqlFieldName = DHCSC_Score ];

Index RowIDBasedIDKeyIndex On DHCScChildsub [ IdKey, PrimaryKey, Unique ];

Storage NewStorage1
{
<SQLMap name="CourseIndex">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^StudentInfoSQLYHT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StudentYHT.St_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHCSC_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_StudentYHT.St_RowId}</Expression>
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
<Expression>{DHCSC_Course_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCSC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="DHCSC_Course_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCSC_Score">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^StudentInfoSQLYHT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StudentYHT.St_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCSC_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_StudentYHT.St_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"Course"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCSC_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DHCSC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCStudentCourseYHTS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
