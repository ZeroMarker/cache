Class CHSSWeb.PersonInfectionCardService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//列出所有的记录

ClassMethod ListPage(CommunityCode, Start, Limit) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT InfectionCardRowId,InfectionRowIdParref,GradeRowIdParref,TypeRowIdParref,CardCode,GeoCode,InfectionType,PatientName,ParentName,Phone,ICCard,Sex,Birth,WorkPlace,BirthPlace,CurrentAdd,Profession,Taken,Diagnose,Death,CaseType,ReportUnit,DateOfRegister,Register,DateOfReceiveCard,CommunityCode  FROM CHSS.PersonInfectionCard where CommunityCode ="_CommunityCode
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s InfectionCardRowId = result.Data("InfectionCardRowId")
	s InfectionRowIdParref = result.Data("InfectionRowIdParref")
	s GradeRowIdParref = result.Data("GradeRowIdParref")
	s TypeRowIdParref = result.Data("TypeRowIdParref")
	s CardCode = result.Data("CardCode")
	s GeoCode = result.Data("GeoCode")
	s InfectionType = result.Data("InfectionType")
	s PatientName = result.Data("PatientName")
	s ParentName = result.Data("ParentName")
	s Phone = result.Data("Phone")
	s ICCard = result.Data("ICCard")
	s Sex = result.Data("Sex")
	s Birth = result.Data("Birth")
	i (Birth'="") d
	.s Birth = $zd(Birth,3)
	s WorkPlace = result.Data("WorkPlace")
	s BirthPlace = result.Data("BirthPlace")
	s CurrentAdd = result.Data("CurrentAdd")
	s Profession = result.Data("Profession")
	s Taken = result.Data("Taken")
	i (Taken'="") d
	.s Taken = $zd(Taken,3)
	s Diagnose =result.Data("Diagnose")
	i (Diagnose'="") d
	.s Diagnose = $zd(Diagnose,3)
	s Death = result.Data("Death")
	i (Death'="") d
	.s Death = $zd(Death,3)
	s CaseType = result.Data("CaseType")
	s ReportUnit = result.Data("ReportUnit")
	s DateOfRegister = result.Data("DateOfRegister")
	i (DateOfRegister'="") d
	.s DateOfRegister = $zd(DateOfRegister,3)
	s Register = result.Data("Register")
	s DateOfReceiveCard = result.Data("DateOfReceiveCard")
	i (DateOfReceiveCard'="") d
	.s DateOfReceiveCard = $zd(DateOfReceiveCard,3)
	s CommunityCode = result.Data("CommunityCode")
	
	s tmp=InfectionCardRowId_"^"_InfectionRowIdParref_"^"_GradeRowIdParref_"^"_TypeRowIdParref_"^"_CardCode_"^"_GeoCode_"^"_InfectionType_"^"_PatientName_"^"_ParentName_"^"_Phone_"^"_ICCard_"^"_Sex_"^"_Birth_"^"_WorkPlace_"^"_BirthPlace_"^"_CurrentAdd_"^"_Profession_"^"_Taken_"^"_Diagnose_"^"_Death_"^"_CaseType_"^"_ReportUnit_"^"_DateOfRegister_"^"_Register_"^"_DateOfReceiveCard_"^"_CommunityCode
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("InfectionCardRowId^InfectionRowIdParref^GradeRowIdParref^TypeRowIdParref^CardCode^GeoCode^InfectionType^PatientName^ParentName^Phone^ICCard^Sex^Birth^WorkPlace^BirthPlace^CurrentAdd^Profession^Taken^Diagnose^Death^CaseType^ReportUnit^DateOfRegister^Register^DateOfReceiveCard^CommunityCode",count)
	k json
	q resultString
}

//添加记录

ClassMethod insert(InfectionRowIdParref, GradeRowIdParref, TypeRowIdParref, CardCode, GeoCode, InfectionType, PatientName, ParentName, Phone, ICCard, Sex, Birth, WorkPlace, BirthPlace, CurrentAdd, Profession, Taken, Diagnose, Death, CaseType, ReportUnit, DateOfRegister, Register, DateOfReceiveCard, CommunityCode) As %String
{
	
	i Birth '= "" d
	.s Birth=$zdh(Birth,3)
	i Taken '= "" d
	.s Taken=$zd(Taken,3)
	i Diagnose '= "" d
	.s Diagnose=$zdh(Diagnose,3)
	i Death '= "" d
	.s Death=$zdh(Death,3)
	i DateOfRegister '= "" d
	.s DateOfRegister=$zdh(DateOfRegister,3)
	i DateOfReceiveCard '="" d
	.s DateOfReceiveCard=$zdh(DateOfReceiveCard,3)
	
	s returncode = ..existCode(CardCode)
	i returncode '= "0" d
	.w "{""success"":""false"",""info"":""卡编码: "_CardCode_"已存在！请重输入！""}" 
	e  d
	. &sql(insert into CHSS.PersonInfectionCard (InfectionRowIdParref, GradeRowIdParref, TypeRowIdParref, CardCode, GeoCode,InfectionType ,PatientName ,ParentName ,Phone, ICCard,Sex,Birth,WorkPlace,BirthPlace,CurrentAdd,Profession,Taken , Diagnose, Death, CaseType ,ReportUnit, DateOfRegister, Register, DateOfReceiveCard,CommunityCode) values(:InfectionRowIdParref, :GradeRowIdParref, :TypeRowIdParref, :CardCode, :GeoCode,:InfectionType ,:PatientName ,:ParentName ,:Phone, :ICCard,:Sex,:Birth,:WorkPlace,:BirthPlace,:CurrentAdd,:Profession,:Taken , :Diagnose, :Death, :CaseType ,:ReportUnit, :DateOfRegister, :Register, :DateOfReceiveCard,:CommunityCode))
	.i SQLCODE ="0" d
	..w "{""success"":""true"",""info"":""添加成功！""}"
	.e  d
	..w "{""success"":""false"",""info"":""添加出错"_SQLCODE_"}"
	q ""
}

//修改记录

ClassMethod update(InfectionCardRowId, InfectionRowIdParref, GradeRowIdParref, TypeRowIdParref, CardCode, GeoCode, InfectionType, PatientName, ParentName, Phone, ICCard, Sex, Birth, WorkPlace, BirthPlace, CurrentAdd, Profession, Taken, Diagnose, Death, CaseType, ReportUnit, DateOfRegister, Register, DateOfReceiveCard, CommunityCode) As %String
{
	
	q:(InfectionCardRowId="") "code-rep"
	
	i Birth '= "" d
	.s Birth=$zdh(Birth,3)
	i Taken '= "" d
	.s Taken=$zdh(Taken,3)
	i Diagnose '= "" d
	.s Diagnose=$zdh(Diagnose,3)
	i Death '= "" d
	.s Death=$zdh(Death,3)
	i DateOfRegister '= "" d
	.s DateOfRegister=$zdh(DateOfRegister,3)
	i DateOfReceiveCard '="" d
	.s DateOfReceiveCard=$zdh(DateOfReceiveCard,3)
	
	&sql(update CHSS.PersonInfectionCard set InfectionRowIdParref=:InfectionRowIdParref, GradeRowIdParref=:GradeRowIdParref, TypeRowIdParref=:TypeRowIdParref, CardCode=:CardCode, GeoCode=:GeoCode,InfectionType=:InfectionType ,PatientName=:PatientName ,ParentName=:ParentName ,Phone=:Phone, ICCard=:ICCard ,Sex=:Sex ,Birth=:Birth ,WorkPlace=:WorkPlace ,BirthPlace=:BirthPlace,CurrentAdd=:CurrentAdd,Profession=:Profession,Taken=:Taken , Diagnose=:Diagnose, Death=:Death, CaseType=:CaseType ,ReportUnit=:ReportUnit, DateOfRegister=:DateOfRegister, Register=:Register, DateOfReceiveCard=:DateOfReceiveCard ,CommunityCode=:CommunityCode where %ID=:InfectionCardRowId)
	q SQLCODE
}

//删除一条数据库中已经存在的记录

ClassMethod delete(InfectionCardRowId) As %String
{
	&sql(delete from CHSS.PersonInfectionCard where %ID=:InfectionCardRowId)
	q SQLCODE
}

//判断卡编号是否重复

ClassMethod existCode(CardCode) As %String
{
 set count = 0
 Set json = ##class(Code.JsonObj).%New()
 s result = ##class(%Library.ResultSet).%New()
 s sqlStr = "SELECT InfectionCardRowId FROM CHSS.PersonInfectionCard where CardCode = '"_CardCode_"'"

 d result.Prepare(sqlStr)
 d result.Execute()
 While(result.Next())
{
 set tempRowId = result.Get("InfectionCardRowId")
 s count = count + 1
}
	 if (count>0)
	{
		 q "1"
	}
	 elseif (count=0)
	{
		q "0"
	}
}

ClassMethod Search(CommunityCode, Start, Limit, SqlStr) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	
	s sqlStr = "SELECT InfectionCardRowId,InfectionRowIdParref,GradeRowIdParref,TypeRowIdParref,CardCode,GeoCode,InfectionType,PatientName,ParentName,Phone,ICCard,Sex,Birth,WorkPlace,BirthPlace,CurrentAdd,Profession,Taken,Diagnose,Death,CaseType,ReportUnit,DateOfRegister,Register,DateOfReceiveCard,CommunityCode  FROM CHSS.PersonInfectionCard where CommunityCode= "_CommunityCode_SqlStr 
	
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s InfectionCardRowId = result.Data("InfectionCardRowId")
	s InfectionRowIdParref = result.Data("InfectionRowIdParref")
	s GradeRowIdParref = result.Data("GradeRowIdParref")
	s TypeRowIdParref = result.Data("TypeRowIdParref")
	s CardCode = result.Data("CardCode")
	s GeoCode = result.Data("GeoCode")
	s InfectionType = result.Data("InfectionType")
	s PatientName = result.Data("PatientName")
	s ParentName = result.Data("ParentName")
	s Phone = result.Data("Phone")
	s ICCard = result.Data("ICCard")
	s Sex = result.Data("Sex")
	s Birth = result.Data("Birth")
	i (Birth'="") d
	.s Birth = $zd(Birth,3)
	s WorkPlace = result.Data("WorkPlace")
	s BirthPlace = result.Data("BirthPlace")
	s CurrentAdd = result.Data("CurrentAdd")
	s Profession = result.Data("Profession")
	s Taken = result.Data("Taken")
	i (Taken'="") d
	.s Taken = $zd(Taken,3)
	s Diagnose =result.Data("Diagnose")
	i (Diagnose'="") d
	.s Diagnose = $zd(Diagnose,3)
	s Death = result.Data("Death")
	i (Death'="") d
	.s Death = $zd(Death,3)
	s CaseType = result.Data("CaseType")
	s ReportUnit = result.Data("ReportUnit")
	s DateOfRegister = result.Data("DateOfRegister")
	i (DateOfRegister'="") d
	.s DateOfRegister = $zd(DateOfRegister,3)
	s Register = result.Data("Register")
	s DateOfReceiveCard = result.Data("DateOfReceiveCard")
	i (DateOfReceiveCard'="") d
	.s DateOfReceiveCard = $zd(DateOfReceiveCard,3)
	s CommunityCode = result.Data("CommunityCode")
	
	s tmp=InfectionCardRowId_"^"_InfectionRowIdParref_"^"_GradeRowIdParref_"^"_TypeRowIdParref_"^"_CardCode_"^"_GeoCode_"^"_InfectionType_"^"_PatientName_"^"_ParentName_"^"_Phone_"^"_ICCard_"^"_Sex_"^"_Birth_"^"_WorkPlace_"^"_BirthPlace_"^"_CurrentAdd_"^"_Profession_"^"_Taken_"^"_Diagnose_"^"_Death_"^"_CaseType_"^"_ReportUnit_"^"_DateOfRegister_"^"_Register_"^"_DateOfReceiveCard_"^"_CommunityCode
	s count = count+1
	i (count>Start)&(count<=end) d
	d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("InfectionCardRowId^InfectionRowIdParref^GradeRowIdParref^TypeRowIdParref^CardCode^GeoCode^InfectionType^PatientName^ParentName^Phone^ICCard^Sex^Birth^WorkPlace^BirthPlace^CurrentAdd^Profession^Taken^Diagnose^Death^CaseType^ReportUnit^DateOfRegister^Register^DateOfReceiveCard^CommunityCode",count)
	k json
	q resultString
}

Storage Default
{
<Data name="PersonInfectionCardServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonInfectA61D</DataLocation>
<DefaultData>PersonInfectionCardServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonInfectA61D</IdLocation>
<IndexLocation>^CHSSWeb.PersonInfectA61I</IndexLocation>
<StreamLocation>^CHSSWeb.PersonInfectA61S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
