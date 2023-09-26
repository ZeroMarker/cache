/// 名称:DHCMed.NINFService.CSS.ClinRepSrv
/// 描述:横断面调查记录查询
/// 编写者：zhufei
/// 编写日期: 2014-05-11
Class DHCMed.NINFService.CSS.ClinRepSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 名称:DHCMed.NINFService.CSS.ClinRepSrv
/// 描述:横断面调查导出
/// 编写者：zhoubo
/// 编写日期: 2014-12-16
/// w ##class(DHCMed.NINFService.CSS.ClinRepSrv).QryExportInfo("fillxlSheet","")
ClassMethod QryExportInfo(itmjs As %String, ArgStr As %String) As %String
{
	n (itmjs,ArgStr)
	s Count=0
	s Arg1=$p(ArgStr,"^",1)
    s Arg2=$p(ArgStr,"^",2)
    s Arg3=$p(ArgStr,"^",3)
    s Arg4=$p(ArgStr,"^",4)
	s ds = ##class(%Library.ResultSet).%New("DHCMed.NINFService.CSS.ClinRepSrv:QryCSSSurvRec")
	d ds.Execute(Arg1,Arg2,Arg3,Arg4)
	
	s ReportID=""
	s StartRow=3
	while(ds.Next())
	{
		s BedSurvID = ds.Data("BedSurvID")
		s EpisodeID = ds.Data("EpisodeID")
		s PatientID=ds.Data("PatientID")
		s SurvDate=ds.Data("SurvDate")
		s SurvLoc=ds.Data("SurvLoc")
		s SurvUser=ds.Data("SurvUser")
		s PapmiNo=ds.Data("PapmiNo")
		s Name=ds.Data("Name")
		s MRNo=ds.Data("MRNo")
		s Sex=ds.Data("Sex")
		s Age=ds.Data("Age")
		s LinkReport=ds.Data("LinkReport")
		s ExportFlg=ds.Data("ExportFlg")
		s Loc=ds.Data("Loc")
		s Bed=ds.Data("Bed")
		s AdmDate=ds.Data("AdmDate")
		s Diagnos=ds.Data("Diagnos")
		s IsInfection=ds.Data("IsInfection")
		s InfPos1=ds.Data("InfPos1")
		s InfDate1=ds.Data("InfDate1")
		s Pathogen1=ds.Data("Pathogen1")
		s InfPos2=ds.Data("InfPos2")
		s InfDate2=ds.Data("InfDate2")
		s Pathogen2=ds.Data("Pathogen2")
		s InfPos3=ds.Data("InfPos3")
		s InfDate3=ds.Data("InfDate3")
		s Pathogen3=ds.Data("Pathogen3")
		s Anti1=ds.Data("Anti1")
		s Anti2=ds.Data("Anti2")
		s Anti3=ds.Data("Anti3")
		s Anti4=ds.Data("Anti4")
		s Oper1=ds.Data("Oper1")
		s Oper2=ds.Data("Oper2")
		s Oper3=ds.Data("Oper3")
		s Oper4=ds.Data("Oper4")	
		s AddOns1=ds.Data("AddOns1")
		s AddOns2=ds.Data("AddOns2")
		s AddOns3=ds.Data("AddOns3")	
		s AddOns4=ds.Data("AddOns4")
	
	   Set str=PapmiNo_$c(1)_Name_$c(1)_MRNo_$c(1)_Sex_$c(1)_Age_$c(1)_Loc_$c(1)_Bed_$c(1)_AdmDate_$c(1)_Diagnos_$c(1)_AddOns4_$c(1)_IsInfection_$c(1)_InfPos1_$c(1)_InfDate1_$c(1)_Pathogen1_$c(1)_InfPos2_$c(1)_InfDate2_$c(1)_Pathogen2_$c(1)_InfPos3_$c(1)_InfDate3_$c(1)_Pathogen3_$c(1)_Anti1_$c(1)_Anti2_$c(1)_Anti3_$c(1)_Anti4_$c(1)_Oper1_$c(1)_Oper2_$c(1)_Oper3_$c(1)_Oper4_$c(1)_AddOns1_$c(1)_AddOns2_$c(1)_AddOns3_$c(1)_SurvDate_$c(1)_SurvLoc_$c(1)_SurvUser

		s retval=itmjs_"(xlSheet,'"_$ZCVT(str,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	q 1
}

/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.CSS.ClinRepSrv","QryCSSSurvRec","201411030001","","","1")
Query QryCSSSurvRec(aSurvNumber As %String, aSurvLoc As %String, aHospitalID As %String, aCategory As %String) As %Query(ROWSPEC = "BedSurvID:%String,EpisodeID:%String,PatientID:%String,SurvDate:%String,SurvLoc:%String,SurvUser:%String,PapmiNo:%String,Name:%String,MRNo:%String,Sex:%String,Age:%String,LinkReport:%String,ExportFlg:%String,Loc:%String,Bed:%String,AdmDate:%String,Diagnos:%String,IsInfection:%String,InfPos1:%String,InfDate1:%String,Pathogen1:%String,InfPos2:%String,InfDate2:%String,Pathogen2:%String,InfPos3:%String,InfDate3:%String,Pathogen3:%String,Anti1:%String,Anti2:%String,Anti3:%String,Anti4:%String,Oper1:%String,Oper2:%String,Oper3:%String,Oper4:%String,AddOns1:%String,AddOns2:%String,AddOns3:%String,AddOns4:%String") [ SqlProc ]
{
}

ClassMethod QryCSSSurvRecExecute(ByRef qHandle As %Binary, aSurvNumber As %String, aSurvLoc As %String, aHospitalID As %String, aCategory As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aSurvNumber="" $$$OK
	
	Set JIndex=$j,ZIndex=$zn
	Kill ^TMP(JIndex,ZIndex,"QryCSSSurvRec")
	
	Set xPaadm=""
	For {
		Set xPaadm=$o(^DHCMed.NINF.CSSi("BSR","SurvNumPaadm"," "_aSurvNumber,xPaadm))
		Quit:xPaadm=""
		 
		Set xID=""
		For {
			Set xID=$o(^DHCMed.NINF.CSSi("BSR","SurvNumPaadm"," "_aSurvNumber,xPaadm,xID))
		    Quit:xID=""
			
			Set BedSurvID=xID
		    Set obj=##class(DHCMed.NINF.CSS.BedSurvRec).GetObjById(BedSurvID)
		    Continue:'$IsObject(obj)
		    Set IsActive=obj.BSCIsActive
			Continue:IsActive'=1
			
		    Set SurvNumber=obj.BSCSurvNumber
		    Set SurvDate=obj.BSCSurvDate
			;Set:SurvDate'="" SurvDate=$zd(SurvDate,3)
			Set:SurvDate'="" SurvDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SurvDate)
		    Set SurvDept=obj.BSCSurvDept
		    Set SurvWard=obj.BSCSurvWard
		    If aSurvLoc'="" {     //科室过滤
				Set LocType=$p($g(^CTLOC(aSurvLoc)),"^",13)
				Continue:(LocType="E")&&(SurvDept'=aSurvLoc)
				Continue:(LocType="W")&&(SurvWard'=aSurvLoc)
			}
			Set SurvDeptDesc=$p($g(^CTLOC(+SurvDept)),"^",2)
		    Set:$p(SurvDeptDesc,"-",2)'="" SurvDeptDesc=$p(SurvDeptDesc,"-",2)
		    Set SurvWardDesc=$p($g(^CTLOC(+SurvWard)),"^",2)
		    Set:$p(SurvWardDesc,"-",2)'="" SurvWardDesc=$p(SurvWardDesc,"-",2)
			If aHospitalID'="" {  //医院过滤
				set HospitalID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(SurvDept)
				continue:HospitalID'=aHospitalID
			}
			Set EpisodeID=obj.BSCEpisodeID
			Continue:EpisodeID=""
			Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
			Continue:PatientID=""
		    Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPatient)
			Set PapmiNo=objPatient.PapmiNo
			
			Set AdmLoc=$p($g(^PAADM(+EpisodeID)),"^",4)
			Set HospitalID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(+AdmLoc)
			Set SSHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCode(+HospitalID,"NINF")
			
			Set LinkReport=obj.BSCLinkReport
			Set LinkReport=$o(^DHCMed.NINF.CSSi("REP","IndexEpisodeID"," "_aSurvNumber," "_EpisodeID,1,0))
			Continue:(aCategory=2)&&(LinkReport="")  //只显示填过调查报告患者
		 
			Set (Loc,Bed,AdmDate,Diagnos)=""
			//add by pylian 2015-06-24 fix bug 112152 横断面调查查询列表-未维护横断面调查表的记录不显示科室、床位、入院日期和基础疾病诊断等 
			//upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
			Set AdmDate=$p(AdmDateTime,"^",1)
			Set AdmTime=$p(AdmDateTime,"^",2)
			;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
			Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
			Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
  			Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(+$p($g(^PAADM(+EpisodeID)),"^",4))
   			Set Loc=objLoc.Descs
     		Set BedID=$p($g(^PAADM(+EpisodeID)),"^",73)
    		Set Bed=$p($g(^PAWARD(+$p($g(^PAADM(+EpisodeID)),"^",73),"BED",+$p($p($g(^PAADM(+EpisodeID)),"^",73),"||",2))),"^",1)
			Set Diagnos=##class(DHCMed.NINFService.CSS.ClinReport).GetDiagnosByAdm(EpisodeID)
			
			Set (IsInfection,InfPos1,InfDate1,Pathogen1,InfPos2,InfDate2,Pathogen2,InfPos3,InfDate3,Pathogen3)=""
			Set (Anti1,Anti2,Anti3,Anti4,Oper1,Oper2,Oper3,Oper4,AddOns1,AddOns2,AddOns3,AddOns4)=""
			If LinkReport'="" {
				Set objReport=##class(DHCMed.NINF.CSS.ClinReport).GetObjById(LinkReport)
				Continue:'$IsObject(objReport)
				Set SurvDate    = objReport.CRSurvDate
				;Set:SurvDate'="" SurvDate=$zd(SurvDate,3)
				Set:SurvDate'="" SurvDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SurvDate)
				Set SurvLoc     = objReport.CRSurvLoc
				Set SurvUser    = objReport.CRSurvUser
				Set MRNo        = objReport.CRMRNo
				Set Name        = objReport.CRName
				Set Sex         = objReport.CRSex
				Set AgeY        = +objReport.CRAgeY
				Set AgeM        = objReport.CRAgeM
				Set AgeD        = objReport.CRAgeD
				Set:(AgeY<1)&&(AgeM<1)&&(AgeD<1) AgeD=1
				If AgeY>1 {
					Set Age=AgeY_"岁"
				}  ElseIf AgeM>1 {
					Set Age=AgeM_"月"
				}Else {
					Set Age=AgeD_"天"
				}
				//Set Loc         = objReport.CRLoc
				//Set Bed         = objReport.CRBed
				//Set AdmDate     = objReport.CRAdmDate
				//Set Diagnos     = objReport.CRDiagnos
				If $tr(Diagnos,"#","")="" {
					Set Diagnos=""
				} Else {
					Set Diagnos=$tr(Diagnos,"#","、")
				}
				Set IsInfection = objReport.CRIsInfection
				//update by likai for bug:3980
				Continue:(aCategory=3)&&(IsInfection'="是")&&(IsInfection'="存在")  //只显示感染患者
				
				Set InfPos1     = objReport.CRInfPos1
				Set InfDate1    = objReport.CRInfDate1
				Set Pathogen1   = objReport.CRPathogen1
				If $tr(Pathogen1,"#","")="" {
					Set Pathogen1=""
				} Else {
					Set Pathogen1=$tr(Pathogen1,"#","、")
				}
				Set InfPos2     = objReport.CRInfPos2
				Set InfDate2    = objReport.CRInfDate2
				Set Pathogen2   = objReport.CRPathogen2
				If $tr(Pathogen2,"#","")="" {
					Set Pathogen2=""
				} Else {
					Set Pathogen2=$tr(Pathogen2,"#","、")
				}
				Set InfPos3     = objReport.CRInfPos3
				Set InfDate3    = objReport.CRInfDate3
				Set Pathogen3   = objReport.CRPathogen3
				If $tr(Pathogen3,"#","")="" {
					Set Pathogen3=""
				} Else {
					Set Pathogen3=$tr(Pathogen3,"#","、")
				}
				Set Anti1       = objReport.CRAnti1
				Set Anti2       = objReport.CRAnti2
				Set Anti3       = objReport.CRAnti3
				Set Anti4       = objReport.CRAnti4
				Set Oper1       = objReport.CROper1
				Set Oper2       = objReport.CROper2
				Set Oper3       = objReport.CROper3
				Set Oper4       = objReport.CROper4
				Set AddOns1     = objReport.CRAddOns1
				Set AddOns2     = objReport.CRAddOns2
				Set AddOns3     = objReport.CRAddOns3
				Set AddOns4     = objReport.CRAddOns4
				
				Set ExportFlg=$o(^DHCMed.NINF.CSS("REP",LinkReport,"Log",0))
				Set ExportFlg=+ExportFlg
				If ExportFlg>0 {
					Set ExportFlg=1
				}
			} Else {
				Continue:aCategory=3 //只显示感染患者
			    Set SurvDate    = SurvDate
				Set SurvLoc     = SurvDeptDesc
			    Set:SurvWardDesc'="" SurvLoc=SurvLoc_"【"_SurvWardDesc_"】"
			    Set SurvUser    = ""
			    Set Name        = objPatient.PatientName
			    If SSHospCode="11-AZ" {
					Set MRNo    = objPatient.PapmiNo
				} Else {
					Set MRNo    = objPatient.InPatientMrNo
				}
			    Set Sex         = objPatient.Sex
			    //修改年龄问题
				Set ageData=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,"",AdmDate,AdmTime)	//返回值为“*岁*月*天”
				Set AgeYear=0,AgeMonth=0,AgeDay=0
				if ageData["岁" {
					set AgeYear=+ageData
				} else {
					if ageData["月" {
						set AgeMonth=+ageData
						set AgeDay=+$p(ageData,"月",2)
					}elseif ageData["天"{
						set AgeDay=+ageData
					}else{
						set AgeDay=1
					}
				}
				Set AgeY        = AgeYear
				Set AgeM        = AgeMonth
				Set AgeD        = AgeDay
				
				If AgeY>1 {
					Set Age=AgeY_"岁"
				}  ElseIf AgeM>1 {
					Set Age=AgeM_"月"
				}Else {
					Set Age=AgeD_"天"
				}
				Set ExportFlg=0
			}
			
			;Set:SurvDate'["-" SurvDate=$zd(+SurvDate,3)
			
		    Set Data=$lb(BedSurvID)
		    Set Data=Data_$lb(EpisodeID)
		    Set Data=Data_$lb(PatientID)
			Set Data=Data_$lb(SurvDate)
			Set Data=Data_$lb(SurvLoc)
			Set Data=Data_$lb(SurvUser)
		    Set Data=Data_$lb(PapmiNo)
			Set Data=Data_$lb(Name)
			Set Data=Data_$lb(MRNo)
			Set Data=Data_$lb(Sex)
			Set Data=Data_$lb(Age)
			Set Data=Data_$lb(LinkReport)
			Set Data=Data_$lb(ExportFlg)
			Set Data=Data_$lb(Loc)
			Set Data=Data_$lb(Bed)
			Set Data=Data_$lb(AdmDate)
			Set Data=Data_$lb(Diagnos)
			Set Data=Data_$lb(IsInfection)
			Set Data=Data_$lb(InfPos1)
			Set Data=Data_$lb(InfDate1)
			Set Data=Data_$lb(Pathogen1)
			Set Data=Data_$lb(InfPos2)
			Set Data=Data_$lb(InfDate2)
			Set Data=Data_$lb(Pathogen2)
			Set Data=Data_$lb(InfPos3)
			Set Data=Data_$lb(InfDate3)
			Set Data=Data_$lb(Pathogen3)
			Set Data=Data_$lb(Anti1)
			Set Data=Data_$lb(Anti2)
			Set Data=Data_$lb(Anti3)
			Set Data=Data_$lb(Anti4)
			Set Data=Data_$lb(Oper1)
			Set Data=Data_$lb(Oper2)
			Set Data=Data_$lb(Oper3)
			Set Data=Data_$lb(Oper4)
			Set Data=Data_$lb(AddOns1)
			Set Data=Data_$lb(AddOns2)
			Set Data=Data_$lb(AddOns3)
			Set Data=Data_$lb(AddOns4)
			
			Set num=$i(^TMP(JIndex,ZIndex,"QryCSSSurvRec","LOC"_SurvLoc))
			Set ^TMP(JIndex,ZIndex,"QryCSSSurvRec","LOC"_SurvLoc,num)=Data
		}
	}
	
	Set xSurvLoc=""
	For {
		Set xSurvLoc=$o(^TMP(JIndex,ZIndex,"QryCSSSurvRec",xSurvLoc))
		Quit:xSurvLoc=""
		
		Set xNum=""
		For {
			Set xNum=$o(^TMP(JIndex,ZIndex,"QryCSSSurvRec",xSurvLoc,xNum))
			Quit:xNum=""
			
			Set Data=$g(^TMP(JIndex,ZIndex,"QryCSSSurvRec",xSurvLoc,xNum))
			Set ^CacheTemp(repid,ind)=Data
		    Set ind=ind+1
		}
	}
	Kill ^TMP(JIndex,ZIndex,"QryCSSSurvRec")
	
	Quit $$$OK
}

ClassMethod QryCSSSurvRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCSSSurvRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCSSSurvRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCSSSurvRecExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
