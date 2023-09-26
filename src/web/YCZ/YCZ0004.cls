Class web.YCZ.YCZ0004 Extends %RegisteredObject
{

/// Function:获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述.
/// CreateDate:2023-09-11
/// Creator:俞长志
/// Table:PA_Adm
/// Input:rowid
/// Output:PA_PatMas
/// Others: w ##class(web.YCZ.YCZ0004).GetPAPMISexDR()
ClassMethod GetPAPMISexDR(rowid As %String) As %String
{
	q:rowid="" ""
	q:$d(^PAADM(rowid))=0 "病人不存在"
	s PAADMPAPMIDR=$P($get(^PAADM(rowid)),"^",1)
	s PAPMISexDR=$P($g(^PAPER(PAADMPAPMIDR,"ALL")),"^",7)
	s CTSexDesc=$P($g(^CT("SEX",PAPMISexDR)),"^",2) //性别描述
	q CTSexDesc
}

///  方法调用
/// Others: w ##class(web.YCZ.YCZ0004).Test(1)
ClassMethod Test(rowid As %String) As %String
{
	s result=..GetStudentInfo(rowid)
	q result
}

/// Function:取出学生信息
/// CreateDate:2023-09-12
/// Creator: 俞长志
/// Table:   DHC_StudentYCZ
/// Input:   RowId:学生主键
/// Output:  StCode,StName,StSexDR,StDob
/// others:  w ##class(web.YCZ.YCZ0004).GetStudentInfo(1)
ClassMethod GetStudentInfo(RowId As %String) As %String
{
	q:RowId="" "RowId为空"
	q:'$data(^User.DHCStudentYCZD(RowId)) "学生不存在"
	s StCode=$listget($get(^User.DHCStudentYCZD(RowId)),2)
	s StName=$listget($get(^User.DHCStudentYCZD(RowId)),3)
	s StSexDR=$listget($get(^User.DHCStudentYCZD(RowId)),4) //性别指向
	s StSexDRDesc=""
	s:StSexDR'="" StSexDRDesc=$P($g(^CT("SEX",StSexDR)),"^",2) //性别描述
	s StDob=$listget($get(^User.DHCStudentYCZD(RowId)),5)
	s:StDob'="" StDob=$zdate(StDob,3)
	s resul="学号:"_StCode_",姓名:"_StName_",性别:"_StSexDRDesc_",出生日期:"_StDob
	q resul
}

/// Function:取出学生信息
/// CreateDate:2023-09-12
/// Creator: 俞长志
/// Table:   DHC_StudentYC
/// Input:   RowId:学生主键
/// Output:  StCode,StName,StSexDR,StDob
/// others:  w ##class(web.YCZ.YCZ0004).GetStudentData(1)
ClassMethod GetStudentData(RowId As %String) As %String
{
	q:RowId="" "RowId为空"
	q:'$data(^DHCSTUDENTYC(RowId)) "学生不存在"
	s StCode=$P($get(^DHCSTUDENTYC(RowId)),"^",1)
	s StName=$P($get(^DHCSTUDENTYC(RowId)),"^",2)
	s StSexDR=$P($get(^DHCSTUDENTYC(RowId)),"^",3) //性别指向
	s StSexDRDesc=""
	s:StSexDR'="" StSexDRDesc=$P($g(^CT("SEX",StSexDR)),"^",2) //性别描述
	s StDob=$P($get(^DHCSTUDENTYC(RowId)),"^",4)
	s:StDob'="" StDob=$zdate(StDob,3)
	s resul="学号:"_StCode_",姓名:"_StName_",性别:"_StSexDRDesc_",出生日期:"_StDob
	q resul
}

}
