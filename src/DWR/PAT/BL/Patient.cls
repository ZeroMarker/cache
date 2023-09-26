/// 患者信息
Class DWR.PAT.BL.Patient Extends %RegisteredObject
{

ClassMethod PatientQry(RtStream As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $ZT="PatientQryET"
	set pResponse=##Class(DWR.PAT.MSG.PatientQryRp).%New()

	set reader = ##class(%XML.Reader).%New()
	set sc=reader.OpenStream(RtStream)
	If $$$ISERR(sc) 
	{
		do Output("100","HIS接收到的入参数据格式有误"_sc)
	    Quit RpStream
	}
	Do reader.Correlate("Request","DWR.PAT.MSG.PatientQryRt")
	if (reader.Next(.pRequest,.sc))
	{   
	}
	if ('$IsObject(pRequest))
	{
		do Output("100","HIS接收到的入参数据格式有误")
	    Quit RpStream
	}
	
	
	set pResponse=..PatientQryExe(pRequest)
	do Output(pResponse.ResultCode,pResponse.ResultContent)
	
	quit RpStream
	
Output(ResultCode,ResultContent)
	set RpStream=""
	set pResponse.ResultCode=ResultCode
	set pResponse.ResultContent=ResultContent
	set RtStream=##class(%GlobalCharacterStream).%New()
	do pResponse.XMLExportToStream(.RpStream,"Response")
	quit
PatientQryET
	set pResponse=##Class(DWR.PAT.MSG.PatientQryRp).%New()
	do Output("-100","HIS端错误："_$ZERROR)
	quit RpStream
}

ClassMethod PatientQryExe(Rt As DWR.PAT.MSG.PatientQryRt) As DWR.PAT.MSG.PatientQryRp
{
	set $ZT="PatientQryExeET"
	set ResultCode="100"
	set ResultContent="没有查询到患者信息"
	
	set Rp=##Class(DWR.PAT.MSG.PatientQryRp).%New()
	set DepartmentID=Rt.DepartmentID
	set PatientID=Rt.PatientID
	if ((DepartmentID="")&&(PatientID=""))
	{
		do OutputResult("101","科室ID和患者ID不能同时为空")
	    Quit Rp
	}
	if (PatientID'="")
	{
		set EpisodeID=$order(^PAPERdr(PatientID,"ADM","I",""),-1)
		if (EpisodeID="")
		{
			do OutputResult("102","此患者没有住院记录")
	    	Quit Rp
		}
		set VisitStatus=$piece($get(^PAADM(EpisodeID)),"^",20)
		if (VisitStatus'="A")
		{
			do OutputResult("103","此患者没有在院记录")
	    	Quit Rp
		}
		do OutputPatient(PatientID,EpisodeID)
	}
	else
	{
		set myJob=$job
		kill ^TMP("DWRPATLIST",myJob,DepartmentID)
		set AdmDate="0"
		while($order(^PAADMi("CurrLoc",DepartmentID,AdmDate))'="")
		{
			set AdmDate=$order(^PAADMi("CurrLoc",DepartmentID,AdmDate))
			set AdmTime="0"
			while($order(^PAADMi("CurrLoc",DepartmentID,AdmDate,AdmTime))'="")
			{
				set AdmTime=$order(^PAADMi("CurrLoc",DepartmentID,AdmDate,AdmTime))
				set EpisodeID="0"
				while($order(^PAADMi("CurrLoc",DepartmentID,AdmDate,AdmTime,EpisodeID))'="")
				{
					set EpisodeID=$order(^PAADMi("CurrLoc",DepartmentID,AdmDate,AdmTime,EpisodeID))
					set BedID=$piece($get(^PAADM(EpisodeID)),"^",73)
					if (BedID="") continue
					set BedNo=$piece($get(^PAWARD(+BedID,"BED",$piece(BedID,"||",2))),"^",1)
					if (BedNo="") continue
					set ^TMP("DWRPATLIST",myJob,DepartmentID,BedNo,EpisodeID)=""
					
				}	
			}
		}
		
		set BedNo=""
		while($order(^TMP("DWRPATLIST",myJob,DepartmentID,BedNo))'="")
		{
			set BedNo=$order(^TMP("DWRPATLIST",myJob,DepartmentID,BedNo))
			set EpisodeID=""
			while($order(^TMP("DWRPATLIST",myJob,DepartmentID,BedNo,EpisodeID))'="")
			{
				set EpisodeID=$order(^TMP("DWRPATLIST",myJob,DepartmentID,BedNo,EpisodeID))
				set PatientID=$piece($get(^PAADM(EpisodeID)),"^",1)
				do OutputPatient(PatientID,EpisodeID)
			}
		}
		kill ^TMP("DWRPATLIST",myJob,DepartmentID)
	}
	
	
	
	do OutputResult(ResultCode,ResultContent)
	quit Rp
	
OutputPatient(PatientID,EpisodeID)
	set ResultCode="0"
	set ResultContent="查询成功"
	set RowObj=##Class(DWR.PAT.MSG.Patient).%New()
	set myPapmiObj=##Class(User.PAPatMas).%OpenId(PatientID)
	set myPaperObj=##Class(User.PAPerson).%OpenId(PatientID)
	set myAdmObj=##Class(User.PAAdm).%OpenId(EpisodeID)
	set RowObj.PatientID=PatientID
	set RowObj.PatientNo=myPapmiObj.PAPMINo
	set RowObj.PatientName=myPapmiObj.PAPMIName
	set RowObj.SexCode=myPaperObj.PAPERSexDR.CTSEXCode
	set RowObj.Sex=myPaperObj.PAPERSexDR.CTSEXDesc
	set RowObj.Age=..GetAgeFromDob(myPaperObj.PAPERDob)
	set RowObj.Height=""
	set RowObj.Weight=""
	set RowObj.BloodType=myPaperObj.PAPERBloodTypeDR.BLDTDesc
	if (RowObj.BloodType="") set RowObj.BloodType=$char(0)
	set RowObj.Occupation=myPaperObj.PAPEROccupationDR.CTOCCDesc
	set RowObj.Marital=myPaperObj.PAPERMaritalDR.CTMARDesc
	set RowObj.EpisodeID=EpisodeID
	set RowObj.InDate=$ZDate(myAdmObj.PAADMAdmDate,3)
	set InDays=+$H-myAdmObj.PAADMAdmDate
	set RowObj.InDays=InDays_"天"
	set RowObj.BedNo=myAdmObj.PAADMCurrentBedDR.BEDCode
	set RowObj.RoomNo=myAdmObj.PAADMCurrentRoomDR.ROOMDesc
	set RowObj.WardID=myAdmObj.PAADMCurrentWardDR.%Id()
	set WardName=myAdmObj.PAADMCurrentWardDR.WARDDesc
	set mystr="-"
	if (WardName[mystr) set WardName=$piece(WardName,mystr,2)
	set RowObj.WardName=WardName
	set RowObj.DepartmentID=myAdmObj.PAADMDepCodeDR.%Id()
	set DepartmentName=myAdmObj.PAADMDepCodeDR.CTLOCDesc
	set mystr="-"
	if (DepartmentName[mystr) set DepartmentName=$piece(DepartmentName,mystr,2)
	set RowObj.DepartmentName=DepartmentName
	set DoctorObj=myAdmObj.PAADMAdmDocCodeDR
	if ($IsObject(DoctorObj))
	{
		set DoctorID=DoctorObj.%Id()
		if (DoctorID'="") 
		{
			set RowObj.DoctorUserID=$order(^SSU("SSUSR",0,"CTPCP",DoctorID,"0"))
			set RowObj.Doctor=$piece($get(^CTPCP(DoctorID,1)),"^",2)
		}
	}
	
	set RowObj.Allergies=..GetPatientAllergies(PatientID)
	
	set Condition=$char(0)
	set ConditionNum="0"
	// 是否危重,需要配置危重医嘱项代码
	set img=##class(web.DHCSETIMAGE).IfOrddailyExist($get(EpisodeID),$get(^DHCDWRSET("ORD","Condition",1)))
	if (img="1")
	{
		set Condition="危重"
		set ConditionNum="1"
	}
	set img=##class(web.DHCSETIMAGE).IfOrddailyExist($get(EpisodeID),$get(^DHCDWRSET("ORD","Condition",2)))
	if (img="1")
	{
		set Condition="病重"
		set ConditionNum="2"
	}
	set RowObj.Condition=Condition
	set RowObj.ConditionNum=ConditionNum
	
	// 护理级别，需要配置护理级别医嘱项代码
	set CareLevel=$char(0)
	set CareLevelNum="0"
	s img1=##class(web.DHCSETIMAGE).IfOrddailyExist($get(EpisodeID),$get(^DHCDWRSET("ORD","CareLevel",1)))
	s img2=##class(web.DHCSETIMAGE).IfOrddailyExist($get(EpisodeID),$get(^DHCDWRSET("ORD","CareLevel",2)))
	s img3=##class(web.DHCSETIMAGE).IfOrddailyExist($get(EpisodeID),$get(^DHCDWRSET("ORD","CareLevel",3)))
	s img4=##class(web.DHCSETIMAGE).IfOrddailyExist($get(EpisodeID),$get(^DHCDWRSET("ORD","CareLevel",4)))
	if (img1="1")
	{
		set CareLevel="一级护理"
		set CareLevelNum="1"
	}
	if (img2="1")
	{
		set CareLevel="二级护理"
		set CareLevelNum="2"
	}
	if (img3="1")
	{
		set CareLevel="三级护理"
		set CareLevelNum="3"
	}
	if (img4="1")
	{
		set CareLevel="特级护理"
		set CareLevelNum="4"
	}
	set RowObj.CareLevel=CareLevel
	set RowObj.CareLevelNum=CareLevelNum
	
	set RowObj.ICStatus=""
	set RowObj.ICStatusNum=""
	set RowObj.WardRoundStatus="2"
	set RowObj.PatientPhotoURL=""
	set RowObj.PatientPhotoFile=""
	set sc=Rp.PatientList.Insert(RowObj)
		
	do RowObj.%Close()
	
		
	quit

OutputResult(ResultCode,ResultContent)
	set Rp.ResultCode=ResultCode
	set Rp.ResultContent=ResultContent
	quit
PatientQryExeET
	set Rp=##Class(DWR.PAT.MSG.PatientQryRp).%New()
	do OutputResult("-100","HIS端错误："_$ZERROR)
	quit Rp
}

ClassMethod GetAgeFromDob(PatientDOB As %String) As %String
{
	s Age=$$CalAge^at182(PatientDOB,+$H,"","","")
 	s AgeYear=$P(Age,"|",12)
 	s AgeMonth=$P(Age,"|",13)
 	s AgeDay=$P(Age,"|",14)
 	s AgeDesc=..FormatAge(AgeYear,AgeMonth,AgeDay)
 	quit AgeDesc
}

ClassMethod FormatAge(AgeYear As %String, AgeMonth As %String, AgeDay As %String) As %String
{
	if (AgeYear>0)
	{
		s AgeDesc=AgeYear_"岁"
	}
	else
	{
		if AgeMonth>0 s AgeDesc=AgeMonth_"月"
		else  s AgeDesc=AgeDay_"天"
	}
	Q AgeDesc
}

ClassMethod GetPatientAllergies(PatientID As %String = "") As %String
{
	set $ZT="GetPatientAllergiesET"
	set rtn=""
	if (PatientID="") quit rtn
	if ('$data(^PAPER(PatientID,"ALG"))) quit rtn
	set sid="0"
	while($order(^PAPER(PatientID,"ALG",sid))'="")
	{
		set sid=$order(^PAPER(PatientID,"ALG",sid))
		set PHCDM=$piece(^PAPER(PatientID,"ALG",sid),"^",27)
		if (PHCDM="") continue
		set AIGStatus=$piece(^PAPER(PatientID,"ALG",sid),"^",8)
		if (AIGStatus'="A") continue
		set DrugName=$piece($get(^PHCD(PHCDM,1)),"^",2)
		set AIGDate=$piece(^PAPER(PatientID,"ALG",sid),"^",10)
		set AIGDate=$ZDate(AIGDate,3)
		if (rtn="")
		{
			set rtn=DrugName_"["_AIGDate_"]"
		}
		else
		{
			set rtn=rtn_$char(10)_DrugName_"["_AIGDate_"]"
		}
		
	}
	quit rtn

GetPatientAllergiesET
	quit ""
}

ClassMethod GetPatientByRowId(PAPMI As %String) As %String
{
	
 s PAPMIOPNo=$p($g(^PAPER(PAPMI,"PAT",1)),"^",2)
 s PAPMIIPNo=$p($g(^PAPER(PAPMI,"PAT",1)),"^",1)
 s PAPMINo=##Class(web.PAPatMas).GetRegistration(PAPMI)
 s PatientName=$P($G(^PAPER(PAPMI,"ALL")),"^",1)
 s PatientDOB=$P($G(^PAPER(PAPMI,"ALL")),"^",6)
 s PatientBirthday=$ZD($G(PatientDOB),3)
 ;
 s PatientSexDr=$P($G(^PAPER(PAPMI,"ALL")),"^",7)
 if PatientSexDr'="" s PatientSex=$P($G(^CT("SEX",PatientSexDr)),"^",2)
 else  s PatientSex=""
 ;
 s Pattype=""
 s PatientSocialStausDR=$p($g(^PAPER(PAPMI,"PER",1)),"^",10)
 i PatientSocialStausDR'="" s Pattype=$p($g(^CT("SS",PatientSocialStausDR)),"^",2)
 ;
 s PatientCompany=$g(^PAPER(PAPMI,"PER","ADD",1))
 s PatientComAdd=$p($g(^PAPER(PAPMI,"PER",4)),"^",18)
 s EmployeeNO=$P($G(^PAPER(PAPMI,"EMP")),"^",5)
 s PatientMaritalDr=$p($g(^PAPER(PAPMI,"PER",2)),"^",3)
 if PatientMaritalDr'="" s PatientMarital= $P($G(^CT("MAR",PatientMaritalDr)),"^",2)
 e  s PatientMarital="未知"
 s PatCategoryRowid=$p($g(^PAPER(PAPMI,"PAT",1)),"^",8)
 s Medcare=$p($g(^PAPER(PAPMI,"PAT",1)),"^",22)
 ;
 s Age=$$CalAge^at182(PatientDOB,+$H,"","","")
 s AgeYear=$P(Age,"|",12)
 s AgeMonth=$P(Age,"|",13)
 s AgeDay=$P(Age,"|",14)
 s AgeDesc=..FormatAge(AgeYear,AgeMonth,AgeDay)
 s ret= PAPMI_"^"_PAPMINo_"^"_PatientName_"^"_PatientSex_"^"_AgeDesc_"^"_PatientBirthday_"^"_Pattype_"^"_PatientSocialStausDR_"^"_PatientSexDr_"^"_PatientDOB_"^"_PatientCompany_"^"_AgeYear_"^"_AgeMonth_"^"_AgeDay_"^"_PatientComAdd_"^"_EmployeeNO_"^"_PatientMarital_"^"_PatCategoryRowid_"^"_Medcare
 Q ret
}

}
