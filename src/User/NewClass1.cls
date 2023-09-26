Class User.NewClass1 Extends %RegisteredObject
{

/// Funtion:获取获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述
/// CreatDate:2023.9.12
/// Creator:蒋美林
/// Table:PA_Adm,PA_PatMas
/// Input:AdmRowID
/// Outpt:SexDesc
/// Debug:w ##class(User.NewClass1).GetPAAdmSexDesc(2)
ClassMethod GetPAAdmSexDesc(AdmRowId As %String) As %String
{
		s AdmStr=$g(^PAADM(AdmRowId))
		s PAADMPAPMIDR = $p(AdmStr,"^",1)
		s PatMasStr =$g(^PAPER(PAADMPAPMIDR,"ALL"))
		s PAPMISexDR =$p(PatMasStr,"^",7)
		s SexStr =$g(^CT("SEX",PAPMISexDR))
		s SexDesc = $p(SexStr,"^",2)
		q SexDesc
}

/// Function:取出学生信息
/// Input:学生主键：RowId
/// Output:StCode,StName,StSexDR,StDob
/// Others:w ##class(User.NewClass1).GetStudentInfo(1)
ClassMethod GetStudentInfo(RowId As %String) As %String
{
	q:RowId="" "RowId为空"
	q:'$data(^User.DHCStudentJMLD(RowId)) "学生不存在"
	s StCode=$listget($g(^User.DHCStudentJMLD(RowId)),2)
	s StName=$listget($g(^User.DHCStudentJMLD(RowId)),3)
	s StSexDR=$listget($g(^User.DHCStudentJMLD(RowId)),4) //性别指向
	s StSexDRDesc=""
	s:StSexDR'="" StSexDRDesc=$p($g(^CT("SEX",StSexDR)),"^",2) //性别描述
	s StDob=$listget($g(^User.DHCStudentJMLD(RowId)),5)
	s:StDob'="" StDob=$zdate(StDob,3)
	s result="学号："_StCode_"姓名:"_StName_"性别："_StSexDRDesc_"出生日期："_StDob
	q result
}

/// Function:生成单个索引
/// CreatDate:2023.9.12
/// Creator:蒋美林
/// Others:d ##class(User.NewClass1).ProduceIndex()
ClassMethod ProduceIndex() As %String
{
	s StRowId=0
	for
	{
		s StRowId=$o(^User.DHCStudentJMLD(StRowId)) q:StRowId=""
		s StSexDR=$lg($g(^User.DHCStudentJMLD(StRowId)),4)
		s ^User.DHCStudentJMLI("Sex",StSexDR,StRowId)=""
		
	}
}

/// Function:通过学号去找学生的姓名：数据检索（无索引）
/// CreatDate:2023-9-14
/// Creator:蒋美林
/// Table:DHC_StudentJML
/// Input:Code
/// Output:StSexDR:性别
/// Others:d ##class(User.NewClass1).GetDatabyCode("01")
ClassMethod GetDatabyCode(Code As %String) As %String
{
	q:Code="" ""
	s StSexDR=""
	S StRowId=0
	s count=0
	for
	{
		s StRowId=$o(^User.DHCStudentJMLD(StRowId))
		q:StRowId=""
		s count=count+1
		s StCode=$listget($g(^User.DHCStudentJMLD(StRowId)),2) //学号
		if (StCode=Code)
		{
			S StSexDR=$listget($g(^User.DHCStudentJMLD(StRowId)),4)
			s:StSexDR'="" StSexDR=$P($g(^CT("SEX",StSexDR)),"^",2)
			w "性别："_StSexDR ,!
			
		}
	}
	if (StSexDR="")
	{
		w "没有匹配的数据"
		
	}
	w count
}

/// Function:获取学生信息
/// CreatDate:2023-9-14
/// Creator:蒋美林
/// Others:d ##class(User.NewClass1).GetStudentIn()
ClassMethod GetStudentIn() As %String
{
	s StRowId=0
	for
	{
		s StRowId=$o(^DHCSTUDENTJML(StRowId)) q:StRowId=""
		s StCode=$p(^DHCSTUDENTJML(StRowId),"^",1)
		s StName=$p(^DHCSTUDENTJML(StRowId),"^",2)
		s StSexDR=$p(^DHCSTUDENTJML(StRowId),"^",3)
		s SexDesc=$p(^CT("SEX",StSexDR),"^",2)
		s StDob=$p(^DHCSTUDENTJML(StRowId),"^",4)
		s Date=$zd(StDob,3)
		w "学号："_StCode_",姓名："_StName_",性别："_SexDesc_",出生日期："_Date,!
	}
}

/// Function:插入数据
/// CreatDate:2023-9-17
/// Creator:蒋美林
/// Others:
ClassMethod InsetInfo(CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	s result =""
	q:CrsCode =""  "CrsCdoe为空"
}

}
