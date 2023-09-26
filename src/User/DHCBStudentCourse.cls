/// Fountion：学生课程表（sqlstorage存储）
/// CreateDate:2023-09-14
/// Creator:翁瑞珍
Class User.DHCBStudentCourse Extends (%Persistent, User.Abstract) [ SqlTableName = DHCB_StudentCourse, StorageStrategy = NewStorage1 ]
{

/// 子表中建立与父表的关系
Relationship StudentParRef As DHCDStudent [ Cardinality = parent, Inverse = ChildCourse, SqlFieldName = SCA_ParRef ];

/// 定义ChildSub
Property SCAChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCSTUDENT(+$s($d(initvalue):initvalue,1:%d(0)),"Course",0))}, Required, SqlColumnNumber = 2, SqlFieldName = SCA_ChildSub ];

/// 课程
Property SCACourseDR As DHCBCourse [ SqlColumnNumber = 3, SqlFieldName = SCA_Course_DR ];

/// 分数
Property SCAScore As %Integer [ Required, SqlColumnNumber = 4, SqlFieldName = SCA_Score ];

/// 创建索引
Index RowIDBasedIDKeyIndex On SCAChildSub [ IdKey, PrimaryKey, Unique ];

Storage NewStorage1
{
<SQLMap name="DateMaterMap">
<Data name="SCA_Course_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SCA_Score">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSTUDENT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCD_Student.St_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SCA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCD_Student.St_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"Course"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="3">
<Expression>{SCA_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMap">
<Global>^DHCSTUDENT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCD_Student.St_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>SCA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCD_Student.St_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"Course"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<Expression>"CourseDR"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="5">
<Expression>{SCA_Course_DR}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="6">
<Expression>{SCA_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SCA_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCBStudentCourseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// Fountion：子表新增
/// CreateDate:2023-09-17
/// Creator:翁瑞珍
/// Table:DHCB_StudentCourse
/// Input:ParRef：父表id，SCACourseDR:课程表id，SCAScorse：成绩
/// Output:result
/// Others:w ##class(User.DHCBStudentCourse).AddStudentCourse("","","")
ClassMethod AddStudentCourse(ParRef As %String, SCACourseDR As %String, SCAScorse As %String) As %String
{
	q:ParRef=""
	q:SCACourseDR=""
	s obj=##class(User.DHCBStudentCourse).%New(ParRef)
	if (obj)
	{
		d obj.StudentParRefSetObjectId(ParRef)
		d obj.SCACourseDRSetObjectId(SCACourseDR)
		d obj.SCAScorseSetObjectId(SCAScorse)
		TSTART
		s sc=obj.%Save()
		if (sc)
		{
			s id=obj.%Id()
			s result="新增成功^"_Id
		}
		else
		{
			s result="新增失败"
		}
		d obj.%Close()
	}
	q result
}

/// Fountion：%Query查询
/// CreateDate:2023-09-17
/// Creator:翁瑞珍
/// Table:DHCB_StudentCourse
/// Output:result
/// Others:d ##class(%ResultSet).RunQuery("User.DHCBStudentCourse","SelectStudentCourse","1")
Query SelectStudentCourse(ParRef As %String) As %Query(ROWSPEC = "SCARowid:%String:ID,SCACourseDR:%String,SCAScore:%String")
{
}

ClassMethod SelectStudentCourseList(ByRef qHandle As %Binary, ParRef As %String) As %Status
{
 	s repid=$I(^CacheTemp)
	s ind=1
	if (ParRef'="")
	{
		s SCAChildSub=0
		for
		{
			s SCAChildSub=$O(^DHCSTUDENT(ParRef,"Course",SCAChildSub))
			q:SCAChildSub=""
			s SCARowid=ParRef_"||"_SCAChildSub
			s SCACourseDR=$P($G(^DHCSTUDENT(ParRef,"Course",SCAChildSub)),"^",1)
			s:SCACourseDR'="" SCACourseDR=$P($G(^DHCCOURSE(SCACourseDR)),"^",2)
			s SCAScore=$P($G(^DHCSTUDENT(ParRef,"Course",SCAChildSub)),"^",2)
			d OutputRow
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	     S ^CacheTemp(repid,ind)=$lb(StRowid,StCode,StName,StSexDR,StDob)
	     s ind=ind+1
	     q
}

ClassMethod SelectStudentCourseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectStudentCourseList ]
{
	s AtEnd=$LI(qHandle,1)
	s repid=$LI(qHandle,2)
	s ind=$LI(qHandle,3)
	s ind=$O(^CacheTemp(repid,ind))
	if ind=""
	{
		s AtEnd=1
		s Row=""
		
	}
	else
	{
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd(repid,ind))
	Quit $$$OK
}

}
