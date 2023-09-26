/// Function:课程类(SQLStorage存储)
/// CreateDate:2023-09-12
/// Creator:yanghongrui
/// Table:DHC_CourseH
/// Input:	Crs_RowId：课程主键
/// Output:	CrsCode,CrsDesc,CrsActiveFlag(Y/N)
/// Others:	w ##class(User.Study.DHCCourseH).GetStudentInfo(1)
Class User.DHCCourseH Extends %Persistent [ SqlRowIdName = Crs_RowId, SqlTableName = DHC_CourseH, StorageStrategy = NewStorage1 ]
{

/// 字段：字段 Crs_Code,Crs_Desc,Crs_Active
/// 代码
Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 名称
Property CrsDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 有效标志
Property CrsActive As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_Active ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCCOURSE(0))</SqlIdExpression>
<SQLMap name="DataMaster">
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
<Global>^DHCCOURSE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Crs_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Crs_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>Crs_RowId</SqlRowIdName>
<StreamLocation>^User.DHCCourseHS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
