Class User.Study.NewDayOne Extends %RegisteredObject
{

/// 获取rowid为3的病人(PA_Person)的生日PAPER_Dob  (YYYY-MM-DD)
/// CreateDate:2023-09-12
/// Creator:yanghongrui
/// Table:PA_Person
/// Tnput:rowid
/// Output:PAPERDob(YYY-MM-DD)
/// Others:w ##class(User.Study.NewDayOne).GetPAPERDob(1)
ClassMethod GetPAPERDob(rowid As %String) As %String
{
	q:rowid="" 
	q:$d(^PAPER(rowid,"ALL"))=0 "数据不存在"
	s Datastr=$get(^PAPER(rowid,"ALL"))
	s StDobDate=$p(Datastr,"^",6)
	s:StDobDate'="" StDobDate=$zdate(StDobDate,3) //转换日期
	//w "出生日期为:"_StDobDate
	q StDobDate
}

/// 方法调用
/// Others:d ##class(User.Study.NewDayOne).Test(1)
ClassMethod Test(rowid As %String) As %String
{
	//s result=##class(User.Study.NewDayOne).GetPAPERDob(rowid)
	s result=..GetPAPERDob(rowid)
	b
}

/// 获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述
/// CreateDate:2023-09-12
/// Creator:yanghongrui
/// input: AdmRowId
/// output:CTSEXDesc
/// others:w ##class(User.Study.NewDayOne).GetPAAdmSexDesc(1)
ClassMethod GetPAAdmSexDesc(AdmRowId As %String) As %String
{
   q:AdmRowId=" " " "  //判断是否有该rowid
   q:$d(^PAADM(AdmRowId))=0 "不存在该ID"
   s PAADMDR=$p($get(^PAADM(AdmRowId)),"^",1)
   s PAPMISexDR=$p($get(^PAPER(PAADMDR,"ALL")),"^",7)
   s CTSEXDesc=$p($get(^CT("SEX",PAPMISexDR)),"^",2)
   q "性别描述："_CTSEXDesc
}

/// Function:取出学生信息
/// CreateDate:2023-09-12
/// Creator:yanghongrui
/// Table:DHC_StudentY
/// Input:	RowId：学生主键
/// Output:	StCode,StName,StSexDR,StDob
/// Others:	w ##class(User.Study.NewDayOne).GetStudentInfo(1)
ClassMethod GetStudentInfo(RowId As %String) As %String
{
	q:RowId="" "RowId为空"
	q:'$data(^User.DHCStudentYD(RowId)) "学生不存在"
	s StCode=$listget($g(^User.DHCStudentYD(RowId)),2)
	s StName=$listget($g(^User.DHCStudentYD(RowId)),3)
	s StSexDR=$listget($g(^User.DHCStudentYD(RowId)),4) //性别指向
	s StSexDRDesc=""
	s:StSexDR'="" StSexDRDesc=$p($g(^CT("SEX",StSexDR)),"^",2) //性别描述
	s StDob=$listget($g(^User.DHCStudentYD(RowId)),5)
	s:StDob'="" StDob=$zdate(StDob,3)
	s result="学号:"_StCode_",姓名:"_StName_",性别:"_StSexDRDesc_",出生日期:"_StDob
	q result
}

/// Function:生成单个索引
/// d ##class(User.Study.NewDayOne).ProduceIndex()
ClassMethod ProduceIndex() As %String
{
	s StRowId=0
	for
	{
		s StRowId=$o(^User.DHCStudentYD(StRowId)) q:StRowId=""
		s StSexDR=$lg($g(^User.DHCStudentYD(StRowId)),4)
		s ^User.DHCStudentYI("Sex",StSexDR,StRowId)=""
		
		}
}

/// Function:通过学号去找学生的性别：数据检索(无索引)
/// CreateDate:2023-09-12
/// Creator:yanghongrui
/// Table:DHC_StudentY
/// Input:	Code
/// Output:	StSexDR：性别
/// Others:	w ##class(User.Study.NewDayOne).GetDatabyCode("01")
ClassMethod GetDatabyCode(Code As %String) As %String
{
	q:Code="" ""
	s StSexDR=""
	s count=0
	s StRowId=0
	for 
	{
		s StRowId=$o(^User.DHCStudentYD(StRowId))
		q:StRowId=""
		s count=count+1
		s StCode=$listget($g(^User.DHCStudentYD(StRowId)),2)
		if (StCode=Code)
			{
			s StSexDR=$listget($g(^User.DHCStudentYD(StRowId)),4) //性别dr
			s:StSexDR'="" StSexDR=$p($g(^CT("SEX",StSexDR)),"^",2)
			w "性别:"_StSexDR ,!
	
			}
	}
	b 
	if (StSexDR="")
	{
		w "没有匹配的数据"
	}
	w count
}

/// Others:	d ##class(User.Study.NewDayOne).GetDataByCodeIdx("01")
ClassMethod GetDataByCodeIdx(Code As %String) As %String
{
	q:Code=""
	s StSexDR=""
	if ($d(^USer.DHCStudentYI("Code",Code))) //索引存在
	{
		s StRowId=$o(^User.DHCStudentYI("Code",Code,0))
		q:StRowId="" ""
		s StSexDR=$listget($g(^User.DHCStudentYD(StRowId)),4) //性别dr
		s:StSexDR'="" StSexDR=$p($g(^CT("SEX",StSexDR)),"^",2)
	}

	q "性别:"_StSexDR
}

}
