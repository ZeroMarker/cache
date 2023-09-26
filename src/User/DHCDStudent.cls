/// Foution：学生类（sqlstorage存储)
/// CreateDate:2023-09-12
/// Creator:翁瑞珍
Class User.DHCDStudent Extends (%Persistent, User.Abstract) [ SqlTableName = DHCD_Student, StorageStrategy = NewStorage1 ]
{

/// 关联子表
Relationship ChildCourse As DHCBStudentCourse [ Cardinality = children, Inverse = StudentParRef ];

/// 学号
Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 姓名
Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCSTUDENT(0))</SqlIdExpression>
<SQLMap name="DateMaster">
<Data name="St_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="St_Dob">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="St_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="St_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSTUDENT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>St_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{St_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCSTUDENT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>St_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{St_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{St_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCSTUDENT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>St_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{St_Name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{St_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>St_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCDStudentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// Fountion：新增数据(父表)
/// CreateDate:2023-09-17
/// Creator:翁瑞珍
/// Table:DHCA_Course
/// Input:StCode,StName,StSexDR,StDob
/// Output:result
/// Others:w ##class(User.DHCDStudent).InsertDate("04","张三","1","2019-09-18")
ClassMethod InsertDate(StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	q:StName="" "StName为空"
	q:StCode="" "StCode为空"
	q:StSexDR="" "StSexDR为空"
	q:$D(^User.DHCDStudent("Code",StCode)) "0^代码重复"
	s:StDob'="" StDob=$zd(StDob,3)
	s obj=##class(User.DHCDStudent).%New()
	s obj.StCode=StCode
	s obj.StName=StName
	s obj.StSexDR=StSexDR
	S obj.StDob=StDob
	s sc=obj.%Save()
	TSTART
	if (sc)
	{
		TCOMMIT 
		S StRowid=obj.%Id()
		s result="新增成功^"_StRowid
	}
	else
	{
		TROLLBACK
		s result="新增失败"
	} 
	d obj.%Close()   
	q result
}

}
