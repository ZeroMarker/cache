Class CHSSWeb.PlannedVaccinationService Extends %Persistent
{

ClassMethod List(CommunityCode, Start, Limit)
{
	Set CommunityCode=$G(CommunityCode)

	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	 s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select ImmuCardRowId from CHSS.ChildPlanedImmuCard where communitycode="_CommunityCode

	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
   
	s ImmuCardRowId=result.Data("ImmuCardRowId")
	s tempChild = ##class(CHSS.ChildPlanedImmuCard).%OpenId(ImmuCardRowId)
	
	s ChildName=tempChild.ChildName
	
	s ChildSex=""
	s ChildSexName=""
	i tempChild.ChildSex'="" d
	.s ChildSex=tempChild.ChildSex.%Id()
	s ChildSexName=tempChild.ChildSex.CTSEXDesc
	
	s ChildHandBookCode=tempChild.ChildHandBookCode
  
	s BcCode=tempChild.BcCode
	s VaccinateHandbookCode=tempChild.VaccinateHandbookCode
	
	
	
	s ChildBirth=tempChild.ChildBirth
	i ChildBirth'="" d
	.s ChildBirth = $zd(ChildBirth,3)
	
	s InfectionHistory=tempChild.InfectionHistory
	s FosterTele=tempChild.FosterTele
	s CardCode=tempChild.CardCode
	s HandbookAdd=tempChild.HandbookAdd
	s CurrentAddress=tempChild.CurrentAddress
	s PostCode=tempChild.PostCode
	s FatherName=tempChild.FatherName

	s FatherTele=tempChild.FatherTele
	s FatherWorkUnit=tempChild.FatherWorkUnit
	s MatherName=tempChild.MatherName
	
	s MotherWorkUnit=tempChild.MotherWorkUnit
	s MotherTele=tempChild.MotherTele
	s dInoVolUnit=tempChild.dInoVolUnit
	s Creater=tempChild.Creater
	s dInoVolUnitPhone=tempChild.dInoVolUnitPhone
	

	s dInoVolDate=tempChild.dInoVolDate
	i dInoVolDate'="" d
	.s dInoVolDate = $zd(dInoVolDate,3)
	
	
	s tmp=""
	
	
	s tmp=ImmuCardRowId_"^"_ChildName_"^"_ChildBirth_"^"_ChildSex_"^"_MotherTele_"^"_ChildSexName_"^"_ChildHandBookCode_"^"_BcCode_"^"_VaccinateHandbookCode_"^"_InfectionHistory_"^"_FosterTele_"^"_CardCode_"^"_HandbookAdd_"^"_CurrentAddress_"^"_PostCode_"^"_FatherName_"^"_FatherTele_"^"_FatherWorkUnit_"^"_MatherName_"^"_MotherWorkUnit_"^"_dInoVolUnit_"^"_Creater_"^"_dInoVolUnitPhone_"^"_dInoVolDate
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("ImmuCardRowId^ChildName^ChildBirth^ChildSex^MotherTele^ChildSexName^ChildHandBookCode^BcCode^VaccinateHandbookCode^InfectionHistory^FosterTele^CardCode^HandbookAdd^CurrentAddress^PostCode^FatherName^FatherTele^FatherWorkUnit^MatherName^MotherWorkUnit^dInoVolUnit^Creater^dInoVolUnitPhone^dInoVolDate",count)
	k json	
	Quit resultString
}

ClassMethod addOrUpdate(ImmuCardRowId, CommunityCode, PersonRowId, Name, Sex, ChildHandBookCode, BcCode, VaccinateHandbookCode, Birth, InfectionHistory, FosterTele, CardCode, HandbookAdd, ChildAddress, PostCode, FatherName, FMobTele, FatherTele, FatherWorkUnit, MotherName, MMobTele, MotherWorkUnit, dInoVolUnit, Creater, dInoVolUnitPhone, dInoVolDate)
{
	s tempChild = ""
	i ImmuCardRowId="" d
	.s tempChild =##class(CHSS.ChildPlanedImmuCard).%New()
	e  d 
	.s tempChild=##class(CHSS.ChildPlanedImmuCard).%OpenId(ImmuCardRowId)
   
	
	s tempChild.CommunityCode=CommunityCode
	
	i PersonRowId'="" d
	.s tempChild.PersonRowIdParref=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)

	
	s tempChild.ChildName=Name
	
	i Sex'="" d
	.s tempChild.ChildSex=##class(User.CTSex).%OpenId(Sex)

	s tempChild.ChildHandBookCode=ChildHandBookCode
	s tempChild.BcCode=BcCode
	s tempChild.VaccinateHandbookCode=VaccinateHandbookCode
	
	
	i Birth'="" d
	.s Birth=$zdh(Birth,3)
	.s tempChild.ChildBirth=Birth
	
	s tempChild.InfectionHistory=InfectionHistory
	s tempChild.FosterTele=FosterTele
	s tempChild.CardCode=CardCode
	s tempChild.HandbookAdd=HandbookAdd
	s tempChild.CurrentAddress=ChildAddress
	s tempChild.PostCode=PostCode
	s tempChild.FatherName=FatherName

	s tempChild.FatherTele=FatherTele
	s tempChild.FatherWorkUnit=FatherWorkUnit
	s tempChild.MatherName=MotherName
	
	s tempChild.MotherWorkUnit=MotherWorkUnit
	s tempChild.MotherTele=MMobTele
	s tempChild.dInoVolUnit=dInoVolUnit
	s tempChild.Creater=Creater
	s tempChild.dInoVolUnitPhone=dInoVolUnitPhone
	
	i dInoVolDate'="" d
	.s dInoVolDate=$zdh(dInoVolDate,3)
	.s tempChild.dInoVolDate=dInoVolDate
	
	s result=""
    s result=tempChild.%Save()
    Set resultString = ""
   
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempChild.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

ClassMethod Search(CommunityCode, searchname, Start, Limit)
{
		Set CommunityCode=$G(CommunityCode)

	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	 s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select ImmuCardRowId from CHSS.ChildPlanedImmuCard where communitycode="_CommunityCode_" and ChildName like '%"_searchname_"%'"

	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	s ImmuCardRowId=result.Data("ImmuCardRowId")
	s tempChild = ##class(CHSS.ChildPlanedImmuCard).%OpenId(ImmuCardRowId)
	
	s ChildName=tempChild.ChildName
	
	s ChildSex=""
	s ChildSexName=""
	i tempChild.ChildSex'="" d
	.s ChildSex=tempChild.ChildSex.%Id()
	s ChildSexName=tempChild.ChildSex.CTSEXDesc
	
	s ChildHandBookCode=tempChild.ChildHandBookCode
  
	s BcCode=tempChild.BcCode
	s VaccinateHandbookCode=tempChild.VaccinateHandbookCode
	
	
	
	s ChildBirth=tempChild.ChildBirth
	i ChildBirth'="" d
	.s ChildBirth = $zd(ChildBirth,3)
	
	s InfectionHistory=tempChild.InfectionHistory
	s FosterTele=tempChild.FosterTele
	s CardCode=tempChild.CardCode
	s HandbookAdd=tempChild.HandbookAdd
	s CurrentAddress=tempChild.CurrentAddress
	s PostCode=tempChild.PostCode
	s FatherName=tempChild.FatherName

	s FatherTele=tempChild.FatherTele
	s FatherWorkUnit=tempChild.FatherWorkUnit
	s MatherName=tempChild.MatherName
	
	s MotherWorkUnit=tempChild.MotherWorkUnit
	s MotherTele=tempChild.MotherTele
	s dInoVolUnit=tempChild.dInoVolUnit
	s Creater=tempChild.Creater
	s dInoVolUnitPhone=tempChild.dInoVolUnitPhone
	

	s dInoVolDate=tempChild.dInoVolDate
	i dInoVolDate'="" d
	.s dInoVolDate = $zd(dInoVolDate,3)
	
	
	s tmp=""
	
	
	s tmp=ImmuCardRowId_"^"_ChildName_"^"_ChildBirth_"^"_ChildSex_"^"_MotherTele_"^"_ChildSexName_"^"_ChildHandBookCode_"^"_BcCode_"^"_VaccinateHandbookCode_"^"_InfectionHistory_"^"_FosterTele_"^"_CardCode_"^"_HandbookAdd_"^"_CurrentAddress_"^"_PostCode_"^"_FatherName_"^"_FatherTele_"^"_FatherWorkUnit_"^"_MatherName_"^"_MotherWorkUnit_"^"_dInoVolUnit_"^"_Creater_"^"_dInoVolUnitPhone_"^"_dInoVolDate
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	s resultString = json.getJsonData("ImmuCardRowId^ChildName^ChildBirth^ChildSex^MotherTele^ChildSexName^ChildHandBookCode^BcCode^VaccinateHandbookCode^InfectionHistory^FosterTele^CardCode^HandbookAdd^CurrentAddress^PostCode^FatherName^FatherTele^FatherWorkUnit^MatherName^MotherWorkUnit^dInoVolUnit^Creater^dInoVolUnitPhone^dInoVolDate",count)
	k json	
	Quit resultString
}

//判断是否需要插入

ClassMethod justInto(ImmuCardRowId)
{
	set ImmuCardRowId=$G(ImmuCardRowId)
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	s rowcount = 0
	&SQL(select count(RecordRowId) into :rowcount from CHSS.ImmunityBacterinRecord where ImmuCardRowId=:ImmuCardRowId)
	i rowcount = 0 d
    .s result = ##class(%Library.ResultSet).%New()
	.;s sqlStr = "insert into chss.ImmunityBacterinRecord(ImmunityClassId,ImmuCardRowId,PreviewDate) select ClassRowId,"_ImmuCardRowId_",(select   b.ChildBirth  + a.ScheduleRowId->MinDays  as numm from chss.DictBacterinVsClass a ,chss.ChildPlanedImmuCard b where b.ImmuCardRowId="_ImmuCardRowId_") from chss.DictBacterinVsClass"
	.;d result.Prepare(sqlStr)
	.;d result.Execute() 
	.;d result.Close()
	.&SQL(insert into chss.ImmunityBacterinRecord(ImmunityClassId,ImmuCardRowId,PreviewDate,ImmunityTimes) select  a.ClassRowId,:ImmuCardRowId,  b.ChildBirth  + a.ScheduleRowId->MinDays  as numm,a.ImmunityTimes from chss.DictBacterinVsClass a ,chss.ChildPlanedImmuCard b where b.ImmuCardRowId=:ImmuCardRowId and  a.bOtherBacterin='false')
}

//列出接种记录

ClassMethod listseed(ImmuCardRowId, Start, Limit)
{
	Set start=$G(Start)
	Set limit=$G(Limit)
	d ..justInto(ImmuCardRowId)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	 s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select RecordRowId from CHSS.ImmunityBacterinRecord where ImmuCardRowId="_ImmuCardRowId

	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	s RecordRowId=result.Data("RecordRowId")
	s tempChild = ##class(CHSS.ImmunityBacterinRecord).%OpenId(RecordRowId)
	s ImmuCardRowId=tempChild.ImmunityClassId
	S BacterinClass=ImmuCardRowId.BacterinClass
	S BacterinRowId=ImmuCardRowId.BacterinRowId
	S ClassDesc =BacterinClass.Description
	s BacterinCode=tempChild.ImmunityTimes
	s BacterinDesc=BacterinRowId.Description
	
	
	s PreviewDate=tempChild.PreviewDate
	i PreviewDate'="" d
	.s PreviewDate=$zd(PreviewDate,3)
	
	
	s CommunityCode=tempChild.CommunityCode
	s Doctor=tempChild.Doctor
	

	s ImmunityDate=tempChild.ImmunityDate
	i ImmunityDate'="" d
	.s ImmunityDate = $zd(ImmunityDate,3)
	
	s ImmunityStatus=tempChild.ImmunityStatus
	i ImmunityStatus="true" d
	.s ImmunityStatus="<font color=green><b>已接种</b></font>"
	else  d
	.s ImmunityStatus="<font color=red><b>未接种</b></font>"
	
	s tmp=""
	s tmp=RecordRowId_"^"_PreviewDate_"^"_ClassDesc_"^"_BacterinCode_"^"_BacterinDesc_"^"_ImmunityStatus_"^"_CommunityCode_"^"_Doctor_"^"_ImmunityDate
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RecordRowId^PreviewDate^BacterinClass^BacterinTime^BacterinName^ImmunityStatus^CommunityCode^Doctor^ImmunityDate",count)
	k json	
	Quit resultString
}

ClassMethod editseed(RecordRowId, ImmunityDate, Doctor, SeedCommunity)
{
	s tempChild = ""
	s tempChild=##class(CHSS.ImmunityBacterinRecord).%OpenId(RecordRowId)
	
	
    i ImmunityDate'="" d
	.s ImmunityDate=$zdh(ImmunityDate,3)
	.s tempChild.ImmunityDate=ImmunityDate
	
	s tempChild.Doctor=Doctor
	s tempChild.ImmunityStatus="true"
	s tempChild.CommunityCode=SeedCommunity
   	s result=""
    s result=tempChild.%Save()
    Set resultString = ""
   
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempChild.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

//列出计划外接种的疫苗信息

ClassMethod ListOutSeed()
{
    Set count=0
	Set resultString = ""
	Set json = ##class(Code.JsonObj).%New()
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select ClassRowId from CHSS.DictBacterinVsClass where bOtherBacterin='true'"

	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	s ClassRowId=result.Data("ClassRowId")
	s tempChild = ##class(CHSS.DictBacterinVsClass).%OpenId(ClassRowId)
	
	S BacterinClass=tempChild.BacterinClass
	S BacterinRowId=tempChild.BacterinRowId
	S ClassDesc =BacterinClass.Description
	;s BacterinCode=tempChild.time
	s BacterinCode=""
	s BacterinDesc=BacterinRowId.Description
	
	s Description=BacterinDesc_"["_ClassDesc_"]"
	
	s tmp=""
	
	s count=count+1
	s tmp=ClassRowId_"^"_Description
    d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Description",count)
	k json	
	Quit resultString
}

ClassMethod editoutseed(time, ImmunityClassId, ImmuCardRowId, PreviewDate, ImmunityDate, Doctor, SeedCommunity)
{
	s tempChild = ""
	s tempChild=##class(CHSS.ImmunityBacterinRecord).%New()
	i PreviewDate'="" d
	.s PreviewDate=$zdh(PreviewDate,3)
	i ImmunityClassId'="" d 
	.s tempChild.ImmunityClassId=##class(CHSS.DictBacterinVsClass).%OpenId(ImmunityClassId)
	;.s tempChild.ImmunityClassId.PreviewDate=PreviewDate
	;.s tempChild.ImmunityClassId.time=time
	
	i ImmuCardRowId'="" d
	.s tempChild.ImmuCardRowId=##class(CHSS.ChildPlanedImmuCard).%OpenId(ImmuCardRowId)
	
	
	s tempChild.PreviewDate=PreviewDate
	
    i ImmunityDate'="" d
	.s ImmunityDate=$zdh(ImmunityDate,3)
	.s tempChild.ImmunityDate=ImmunityDate
	s tempChild.PreviewDate=PreviewDate
	s tempChild.ImmunityTimes=time
	s tempChild.Doctor=Doctor
	s tempChild.ImmunityStatus="true"
	s tempChild.CommunityCode=SeedCommunity
   	s result=""
    s result=tempChild.%Save()
    Set resultString = ""
   
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempChild.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

ClassMethod test()
{
	s num=""
	 ;s sqlStr="select  sum(select (select ChildBirth  from chss.ChildPlanedImmuCard where ImmuCardRowId=1) as numm from chss.DictBacterinVsClass ,select a.ScheduleRowId->MinDays  as days from chss.DictBacterinVsClass a) as numm from CHSS.Childbaseinfo a"
	
	 s sqlStr="select   b.ChildBirth  + a.ScheduleRowId->MinDays  as numm from chss.DictBacterinVsClass a ,chss.ChildPlanedImmuCard b where b.ImmuCardRowId=1"
	
	
    s result = ##class(%Library.ResultSet).%New()
	 d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	While(result.Next()){
		
		s num=result.Data("numm")
		s count=count+1
		}
	
	w count,!
	w num
}

Storage Default
{
<Data name="PlannedVaccinationServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PlannedVacciA02D</DataLocation>
<DefaultData>PlannedVaccinationServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PlannedVacciA02D</IdLocation>
<IndexLocation>^CHSSWeb.PlannedVacciA02I</IndexLocation>
<StreamLocation>^CHSSWeb.PlannedVacciA02S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
