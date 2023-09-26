Class web.study.YWBDAY1 Extends %RegisteredObject
{

/// Function:获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述
/// CreaterDate:2023-09-11
/// Creater:yiwenbo
/// InPut:就诊表RowId
/// OutPut:对应的性别描述
/// Others:w ##class(web.study.YWBDAY1).GetPAAdmSexDesc(1)
ClassMethod GetPAAdmSexDesc(AdmRowId As %String)
{
		q:AdmRowId="" "就诊表RowId为空"
		q:^PAADM(AdmRowId)="" "没有对应的就诊表RowId"
		s patmasDr=$p($g(^PAADM(AdmRowId)),"^",1)
		s sexDr=$p($g(^PAPER(patmasDr,"ALL")),"^",7)
		s sexDesc=$p($g(^CT("SEX",sexDr)),"^",2)
		q sexDesc
}

/// Function:取出学生信息
/// CreaterDate:2023-09-12
/// Creater:yiwenbo
/// Table:DHC_Student
/// InPut:学生主键RowId
/// OutPut:StCode,StName,StSexDR,StDob
/// Others:w ##class(web.study.YWBDAY1).GetStudentInfo(1)
ClassMethod GetStudentInfo(RowId As %String) As %String
{
		q:RowId="" "RowId为空"
		q:'$data(^User.DHCStudentD(RowId)) "学生不存在"
		s StCode=$listget($g(^User.DHCStudentD(RowId)),2)
		s StName=$listget($g(^User.DHCStudentD(RowId)),3)
		s StSexDR=$listget($g(^User.DHCStudentD(RowId)),4)
		s:StSexDR'="" StSexDRDesc=$p($g(^CT("SEX",StSexDR)),"^",2)
		s StDob=$listget($g(^User.DHCStudentD(RowId)),5)
		s:StDob'="" StDob=$zdate(StDob,3)
		b ; 
		s result="学号:"_StCode_",姓名:"_StName_",性别:"_StSexDRDesc_",出生日期:"_StDob
		q result
}

/// Function:取出学生信息
/// CreaterDate:2023-09-12
/// Creater:yiwenbo
/// Table:DHC_StudentNew
/// InPut:学生主键RowId
/// OutPut:StCode,StName,StSexDR,StDob
/// Others:w ##class(web.study.YWBDAY1).GetStudentData(1)
ClassMethod GetStudentData(RowId As %String) As %String
{
		q:RowId="" "RowId为空"
		q:'$data(^DHCSTUDENT(RowId)) "学生不存在"
		s StCode=$listget($g(^DHCSTUDENT(RowId)),2)
		s StName=$listget($g(^DHCSTUDENT(RowId)),3)
		s StSexDR=$listget($g(^DHCSTUDENT(RowId)),4)
		s:StSexDR'="" StSexDRDesc=$p($g(^CT("SEX",StSexDR)),"^",2)
		s StDob=$listget($g(^DHCSTUDENT(RowId)),5)
		s:StDob'="" StDob=$zdate(StDob,3)
		b ; 
		s result="学号:"_StCode_",姓名:"_StName_",性别:"_StSexDRDesc_",出生日期:"_StDob
		q result
}

/// Function:生成单个索引
/// d ##class(web.study.YWBDAY1).ProduceIndex()
ClassMethod ProduceIndex() As %String
{
	s StRowId=0
	for
	{
		s StRowId=$O(^User.DHCStudentD(StRowId)) q:StRowId=""
		s StSexDR=$lg($g(^User.DHCStudentD(StRowId)),4)
		s ^User.DHCStudentI("Sex",StSexDR,StRowId)=""	
	}
}

/// Function:通过学号去找学生的性别：数据检索（无索引）
/// CreaterDate:2023-09-12
/// Creater:yiwenbo
/// Table:DHC_Student
/// InPut:Code
/// OutPut:StSexDR
/// Others:w ##class(web.study.YWBDAY1).GetDataByCode("01")
ClassMethod GetDataByCode(RowId As %String) As %String
{
		q:Code="" "Code为空"
		s StSexDR=""
		s count=0
		s StRowId=0
		for
		{
			s StRowId=$O(^User.DHCStudentD(StRowId))
			q:StRowId=""
			s count=count+1
			s StCode=$listget($g(^User.DHCStudentD(StRowId)),2)
			if (StCode=Code)
			{
				s StSexDR=$listget($g(^User.DHCStudentD(StRowId)),4)
				s:StSexDR'="" StSexDR=$p($g(^CT("SEX",StSexDR)),"^",2)
				w "性别:"_StSexDR ,!
			}
		}
		if (StSexDR="")
		{
			w "没有匹配的数据"
		}
		w count
}

/// Others:w ##class(web.study.YWBDAY1).GetDataByCodeIdx("01")
ClassMethod GetDataByCodeIdx(RowId As %String) As %String
{
		q:Code="" "Code为空"
		s StSexDR=""
		if ($d(^User.DHCStudentI("Code",Code)))
		{
			s StRowId=$O(^User.DHCStudentI("Code",Code,0))
			q:StRowId="" ""
			s StSexDR=$listget($g(^User.DHCStudentD(StRowId)),4)
			s:StSexDR'="" StSexDR=$p($g(^CT("SEX",StSexDR)),"^",2)
			b ;1
		}
		q "性别:"_StSexDR
}

}
