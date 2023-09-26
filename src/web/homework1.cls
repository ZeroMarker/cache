Class web.homework1 Extends %RegisteredObject
{

/// Function:获取rowid为3的病人（PA_Person）的生日PAPER_Dob（YYYY-MM-DD）
/// CreateDate:2023-09-11
/// Creator:zhailihong
/// Table:PA_Person
/// Input:rowid
/// Output:PAPERDob(YYYY-MM-DD)
/// Others: w ##class(web.homework1).GetPAPERDob(1)
ClassMethod GetPAPERDob(rowid As %String) As %String
{
	q:rowid="" "rowid不能为空"
	q:$d(^PAPER(rowid,"All"))=0 "数据不存在"       
	s Datastr=$get(^PAPER(rowid,"All"))
	s StDobDate=$p(Datastr,"^",6)
	s:StDobDate'="" StDoDate=$zdate(StDoDate,3)
	q "出生日期为："_StDobDate       ///结果为空
}

/// 方法调用
/// Others: d ##class(web.homework1).Test(1)
ClassMethod Test(rowid As %String) As %String
{
	s result=..GetPAPERDob(rowid)     //##class(web.homework1)
	b
}

/// Function:获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述
/// ClassMethod GetPAAdmSexDesc(AdmRowId)
/// Function:取出学生信息
/// Input: Rowid:学生主键
/// Output：StCode,StName,StSexDR,StDob
/// Others: w ##class(web.Study.NewDayOne).GetStudentInfo(1)
ClassMethod Getsyudentinfo(RowId As %String) As %String
{
	q:RowId="" "Rowid为空"
	q:'@data(^User.DHChomework2D(RowId)) "学生不存在"
	s StCode=$listget($g(^User.DHChomework2D(Rowid)),2)
	s StName=$listget($g(^User.DHChomework2D(Rowid)),3)
	s StSexDR=$listget($g(^User.DHChomework2D(Rowid)),4)   //性别指向
	s StSexDRDesc=""
	s:StSexDR'="" StSexDRDesc=$p($g(^CT("SEX",StSexDR)),"^",2) //性别描述
	s StDob=$listget($g(^User.DHChomework2D(Rowid)),5)
	s:StDob'="" StDob=$zdate(StDob,3)
	b ;
	s result="学号："_StCode_",性别："_StName_",性别："_StSexDRDesc_",出生日期："_StDob
	q result
}

}
