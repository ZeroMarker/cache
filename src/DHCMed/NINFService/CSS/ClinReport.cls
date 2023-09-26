/// 名称:DHCMed.NINFService.CSS.ClinReport
/// 描述:横断面临床报告
/// 编写者：zhufei
/// 编写日期: 2014-05-05
Class DHCMed.NINFService.CSS.ClinReport Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.NINFService.CSS.ClinReport).SaveReport($c(1)_"39"_$c(1)_"201406040001"_$c(1)_"2014-06-04"_$c(1)_"中西医结合一科【中西医结合一科护理单元】"_$c(1)_"med manager"_$c(1)_"1"_$c(1)_"500385"_$c(1)_"王莉莉"_$c(1)_"女"_$c(1)_"26"_$c(1)_"0"_$c(1)_"0"_$c(1)_"中西医结合一科"_$c(1)_"0501床"_$c(1)_"2013-02-19"_$c(1)_"巩膜结核##"_$c(1)_"存在"_$c(1)_"下呼吸道"_$c(1,1)_"金葡##"_$c(1,1,1)_"##"_$c(1,1,1)_"##"_$c(1)_"是"_$c(1)_"预防用药"_$c(1)_"三联"_$c(1)_"否"_$c(1)_"是"_$c(1,1)_"Ⅱ"_$c(1,1,1,1,1,1,1,1)_"117"_$c(1)_"9"_$c(1)_"0000000040"_$c(1)_"医院感染"_$c(1,1,1)_"##"_$c(1,1,1)_"##"_$c(1,1,1)_"##"_$c(1)_"不存在"_$c(1)_"金黄色葡萄球菌||苯唑西林:耐药||头孢西丁:敏感#凝固酶阴性葡萄球菌||苯唑西林:||头孢西丁:#粪肠球菌||氨苄西林:||万古霉素:#屎肠球菌||氨苄西林:||万古霉素:#肺炎链球菌||青霉素:#大肠埃希菌||头孢他啶:||亚胺/美罗培南:||左氧氟沙星:#肺炎克雷伯菌||头孢他啶:||亚胺/美罗培南:||左氧氟沙星:#铜绿假单胞菌||环丙沙星:||哌拉西林/他唑巴坦:||亚胺培南/美罗培南:||头孢他啶:||头孢吡肟:||阿米卡星:#鲍曼不动杆菌||亚胺培南/美罗培南:||头孢哌酮/舒巴坦:",$c(1))
ClassMethod SaveReport(aInput As %String, aSeparate As %String) As %String
{
	new (aInput,aSeparate)
	set return=""
	quit:(aInput="")||(aSeparate="") return
	
	set aInput=$tr(aInput,"^","")
	set aInput=$tr(aInput,aSeparate,"^")
	set return=##Class(DHCMed.NINF.CSS.ClinReport).Update(aInput)
	
	quit return
}

/// w ##Class(DHCMed.NINFService.CSS.ClinReport).GetReport("","21997067","201605040002")
ClassMethod GetReport(aReportID As %String, aEpisodeID As %String, aSurvNumber As %String) As DHCMed.NINF.CSS.ClinReport
{
	new (aReportID,aEpisodeID,aSurvNumber)
	set return=""
	quit:(aReportID="")&&(aEpisodeID="") return
	
	set $ZT="GetReportErr"
	
	if aReportID="" {
		set aReportID=$o(^DHCMed.NINF.CSSi("REP","IndexEpisodeID"," "_aSurvNumber," "_aEpisodeID,1,0))
	}
	
	if aReportID'="" {
		set obj=##class(DHCMed.NINF.CSS.ClinReport).GetObjById(aReportID)
		quit:'$IsObject(obj) return
	} else {
		set EpisodeID=aEpisodeID
		set SurvNumber=aSurvNumber
		
		set SurvDate=""
		set xSurvRecID=0
		for {
			set xSurvRecID=$o(^DHCMed.NINF.CSSi("BSR","SurvNumPaadm"," "_SurvNumber,EpisodeID,xSurvRecID))
			quit:xSurvRecID=""
			set objSurvRec=##class(DHCMed.NINF.CSS.BedSurvRec).GetObjById(xSurvRecID)
			continue:'$IsObject(objSurvRec)
			set IsActive=objSurvRec.BSCIsActive
			continue:IsActive'=1
			set SurvDate=objSurvRec.BSCSurvDate
			set SurvDept=objSurvRec.BSCSurvDept
			set SurvWard=objSurvRec.BSCSurvWard
		}
		
		quit:SurvDate="" return
		set SurvDeptDesc=$p($g(^CTLOC(+SurvDept)),"^",2)
	    set:$p(SurvDeptDesc,"-",2)'="" SurvDeptDesc=$p(SurvDeptDesc,"-",2)
	    set SurvWardDesc=$p($g(^CTLOC(+SurvWard)),"^",2)
	    set:$p(SurvWardDesc,"-",2)'="" SurvWardDesc=$p(SurvWardDesc,"-",2)
	    set SurvLoc=SurvDeptDesc
	    set:SurvWardDesc'="" SurvLoc=SurvLoc_"【"_SurvWardDesc_"】"
		
		Set AdmLoc=$p($g(^PAADM(+EpisodeID)),"^",4)
		Set HospitalID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(+AdmLoc)
		Set SSHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCode(+HospitalID,"NINF")
		
		set obj=##class(DHCMed.NINF.CSS.ClinReport).%New()
		if obj'="" do obj.%Close()
		
		set objPaadm=##Class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
		quit:'$IsObject(objPaadm) return
		set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
		set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
		quit:'$IsObject(objPatient) return
		
		set obj.CREpisodeID   = EpisodeID
		set obj.CRSurvNumber  = SurvNumber
		set obj.CRSurvDate    = SurvDate
		set obj.CRSurvLoc     = SurvLoc
		set obj.CRSurvUser    = ""
		set obj.CRUpdateDate  = +$h
		set obj.CRUpdateTime  = $p($h,",",2)
		set obj.CRUpdateLoc   = ""
		set obj.CRUpdateUser  = ""
		set obj.CRIsActive    = 1
		if SSHospCode="11-AZ" {
			set obj.CRMRNo    = objPatient.PapmiNo
		} Else {
			set obj.CRMRNo    = objPatient.InPatientMrNo
		}
		set obj.CRPatNo       = objPatient.PapmiNo
		set obj.CRName        = objPatient.PatientName
		set obj.CRSex         = objPatient.Sex
		set obj.CRAgeY        = +objPatient.Age
		set obj.CRAgeM        = +objPatient.AgeMonth
		set obj.CRAgeD        = +objPatient.AgeDay
		set:(obj.CRAgeY<1)&&(obj.CRAgeM<1)&&(obj.CRAgeD<1) obj.CRAgeD=1
		
		set Loc = ""
		set objTmp=##class(DHCMed.NINF.Srv.MKDicMapping).GetMappingData("CSSLocGroup",SurvDept)
		If $IsObject(objTmp) {
			Set Loc=objTmp.TargetDesc
		}
		set:Loc="" Loc=SurvDeptDesc
		set obj.CRLoc         = Loc
		
		set obj.CRBed         = objPaadm.Bed
		set obj.CRAdmDate     = objPaadm.AdmitDate
		
		set obj.CRDiagnos     = ..GetDiagnosByAdm(EpisodeID)
		
		set obj.CRIsInfection = ""
		set obj.CRInfCategory = ""
		set obj.CRInfPos1     = ""
		//set obj.CRInfDiag1    = ""
		//set obj.CRInfDiagCat1 = ""
		set obj.CRInfDate1    = ""
		set obj.CRPathogen1   = ""
		set obj.CRInfPos2     = ""
		//set obj.CRInfDiag2    = ""
		//set obj.CRInfDiagCat2 = ""
		set obj.CRInfDate2    = ""
		set obj.CRPathogen2   = ""
		set obj.CRInfPos3     = ""
		//set obj.CRInfDiag3    = ""
		//set obj.CRInfDiagCat3 = ""
		set obj.CRInfDate3    = ""
		set obj.CRPathogen3   = ""
		set obj.CRComInfPos1     = ""
		set obj.CRComInfDate1    = ""
		set obj.CRComPathogen1   = ""
		set obj.CRComInfPos2     = ""
		set obj.CRComInfDate2    = ""
		set obj.CRComPathogen2   = ""
		set obj.CRComInfPos3     = ""
		set obj.CRComInfDate3    = ""
		set obj.CRComPathogen3   = ""
		set obj.CRBugsAntiSen    = ""
		
		set AntiInfo=..GetAntiInfo(EpisodeID,SurvDate)
		Set Anti1=$p(AntiInfo,"^",1)
		Set Anti3=$p(AntiInfo,"^",3)
		set obj.CRAnti1       = Anti1
		set obj.CRAnti2       = ""
		set obj.CRAnti3       = Anti3
		set obj.CRAnti4       = ""
		
		set OperInfo=..GetOperInfo(EpisodeID,SurvDate)
		Set Oper1=$p(OperInfo,"^",1)
		Set Oper3=$p(OperInfo,"^",3)
		set obj.CROper1       = Oper1
		set obj.CROper2       = ""
		set obj.CROper3       = Oper3
		set obj.CROper4       = ""
		
		set obj.CRAddOns1     = ""
		set obj.CRAddOns2     = ""
		set obj.CRAddOns3     = ""
		set obj.CRAddOns4     = ""
		set obj.CRAddOns5     = ""
		
	}
	
	set return=obj
	quit return
	
GetReportErr
	quit ""
}

/// 取临床诊断方法
ClassMethod GetDiagnosByAdm(aEpisodeID As %String) As %String
{
	new (aEpisodeID)
	set return=""
	quit:aEpisodeID="" return
	
	set $ZT="GetDiagnosByAdmErr"
	
	set MRAdm=$p($g(^PAADM(aEpisodeID)),"^",61)
	quit:MRAdm="" return
	
	set xSubID=0
	for {
		set xSubID=$o(^MR(MRAdm,"DIA",xSubID))
		quit:xSubID=""
		
		set ICDDesc=""
		set ICDDr=$p($g(^MR(MRAdm,"DIA",xSubID)),"^",1)
		set:ICDDr'="" ICDDesc=$p($g(^MRC("ID",ICDDr)),"^",2)
		set:$p(ICDDesc,"-",2)'="" ICDDesc=$p(ICDDesc,"-",2)
		set ICDDesc1=$g(^MR(MRAdm,"DIA",xSubID,"DES",1))
		if ICDDesc="" {
			set ICDDesc=ICDDesc1
		} else {
			if (ICDDesc1'=""){
				set ICDDesc=ICDDesc_","_ICDDesc1
			}
		}
		continue:ICDDesc=""
		set ICDDesc=$tr(ICDDesc,"#","")
		
		set return=return_"#"_ICDDesc
	}
	set:return'="" return=$e(return,2,$l(return))
	
	quit return
	
GetDiagnosByAdmErr
	quit ""
}

/// w ##Class(DHCMed.NINFService.CSS.ClinReport).ProDiagnosErr("")
ClassMethod ProDiagnosErr(aSurvNumber As %String) As %String
{
	new (aSurvNumber)
	set return=""
	
	set xSurvNumber=""
	for {
		set xSurvNumber=$o(^DHCMed.NINF.CSSi("REP","IndexEpisodeID",xSurvNumber))
		quit:xSurvNumber=""
		continue:(aSurvNumber'="")&&($e(xSurvNumber,2,$l(xSurvNumber))'=aSurvNumber)
		
		set xEpisodeID=0
		for {
			set xEpisodeID=$o(^DHCMed.NINF.CSSi("REP","IndexEpisodeID",xSurvNumber,xEpisodeID))
			quit:xEpisodeID=""
			
			set xIsActive=""
			for {
				set xIsActive=$o(^DHCMed.NINF.CSSi("REP","IndexEpisodeID",xSurvNumber,xEpisodeID,xIsActive))
				quit:xIsActive=""
				
				set xRepID=0
				for {
					set xRepID=$o(^DHCMed.NINF.CSSi("REP","IndexEpisodeID",xSurvNumber,xEpisodeID,xIsActive,xRepID))
					quit:xRepID=""
					
					set objRep=##class(DHCMed.NINF.CSS.ClinReport).GetObjById(xRepID)
					continue:'$IsObject(objRep)
					set Diagnos=objRep.CRDiagnos
					set tmpDiagnos=$p(Diagnos,"#",1)
					continue:(tmpDiagnos'["伤寒")&&(tmpDiagnos'="")
					set tmpDiagnos=$p(Diagnos,"#",2)_"#"_$p(Diagnos,"#",3)_"#"
					set objRep=##class(DHCMed.NINF.CSS.ClinReport).%OpenId(xRepID)
					continue:'$IsObject(objRep)
					set objRep.CRDiagnos=tmpDiagnos
					set sc=objRep.%Save()
					if $system.Status.IsError(sc) {    //检查Save是否成功
				   		d $system.OBJ.DisplayError(sc)
					}
				}
			}
		}
	}
	
	Quit "OK"
}

/// 取值手术相关信息
ClassMethod GetOperInfo(aEpisodeID As %String, aSurvDate As %String) As %String
{
	New (aEpisodeID,aSurvDate)
	Set return=""
	Quit:aEpisodeID="" return
	
	set $ZT="GetOperInfoErr"
	
	Set:aSurvDate["-" aSurvDate=$zdh(aSurvDate,3)
	
	Set IsHaveOper="否",OperCuttype=""
	Set rs=##Class(%ResultSet).%New("DHCMed.NINFService.Rep.InfReportOpr:QrySubRec")
	Do rs.Execute("",aEpisodeID)
	While (rs.Next()){
		Set OperDate=rs.Data("OperStartDate")
		Continue:OperDate=""
		Set CuteType=rs.Data("CuteTypeDesc")
		Continue:CuteType=""
		Set IsHaveOper="是"
		Set OperCuttype=CuteType
	}
	Do rs.Close()
	
	Set return=IsHaveOper_"^^"_OperCuttype_"^"
	Quit return
	
GetOperInfoErr
	quit ""
}

/// 取值抗生素相关信息
ClassMethod GetAntiInfo(aEpisodeID As %String, aSurvDate As %String) As %String
{
	New (aEpisodeID,aSurvDate)
	Set return=""
	Quit:aEpisodeID="" return
	
	set $ZT="GetAntiInfoErr"
	
	Set:aSurvDate["-" aSurvDate=$zdh(aSurvDate,3)
	
	Set IsHaveAnti="否",ArcimDescList=""
	Set rs=##Class(%ResultSet).%New("DHCMed.NINFService.Rep.InfReportAnti:QrySubRec")
	Do rs.Execute("",aEpisodeID)
	While (rs.Next()){
		Set ArcimDesc=rs.Data("ArcimDesc")
		Continue:ArcimDesc=""
		Set StartDate=rs.Data("StartDate")
		Continue:StartDate=""
		Set StartDate=$zdh(StartDate,3)
		Continue:StartDate'=aSurvDate
		
		Set IsHaveAnti="是"
		If $listfind(ArcimDescList,ArcimDesc)<0 {
			Set ArcimDescList=ArcimDescList_$lb(ArcimDesc)
		}
	}
	Do rs.Close()
	
	If ArcimDescList'="" {
		Set AntiCatCnt=$listlength(ArcimDescList)
		Set:AntiCatCnt=1 AntiCatCnt="单用"
		Set:AntiCatCnt=2 AntiCatCnt="二联"
		Set:AntiCatCnt=3 AntiCatCnt="三联"
		Set:AntiCatCnt>3 AntiCatCnt="四联及以上"
	} Else {
		Set AntiCatCnt=""
	}
	
	Set return=IsHaveAnti_"^^"_AntiCatCnt_"^"
	Quit return
	
GetAntiInfoErr
	quit ""
}

/// 打印横断面登记表
/// w ##Class(DHCMed.NINFService.CSS.ClinReport).PrintCSSReport("fillxlSheet",3)
ClassMethod PrintCSSReport(itmjs As %String, aReportID As %String) As %String
{
	new (itmjs,aReportID)
	set return=0
	quit:aReportID="" return
	
	set objReport=##class(DHCMed.NINF.CSS.ClinReport).GetObjById(aReportID)
	quit:'$IsObject(objReport) return
	set EpisodeID=objReport.CREpisodeID
	quit:EpisodeID="" return
	set AdmLoc=$p($g(^PAADM(EpisodeID)),"^",4)
	quit:AdmLoc="" return
	set CTHospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
	quit:CTHospID="" return
	set SSHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCode(CTHospID,"NINF")
	quit:SSHospCode="" return
	set SurvNumber=objReport.CRSurvNumber
	
	If $p(SSHospCode,"-",1)=11 {  //北京市版本
		If $e(SurvNumber,1,4)>=2013 {
			Set flg=##Class(DHCMed.NINFService.CSS.ClinRepPrt).PrintCSSReport2014BJ(itmjs,aReportID)
		} Else {}
	} Else {                       //全国统一版本
		If $e(SurvNumber,1,4)>2013 {
			Set flg=##Class(DHCMed.NINFService.CSS.ClinRepPrt).PrintCSSReport2014(itmjs,aReportID)
		} Else {}
	}
	
	set return=1
	quit return
}

/// w ##Class(DHCMed.NINFService.CSS.ClinReport).GetReportJS("21-DT","201406040001")
ClassMethod GetReportJS(aSSHospCode As %String, aSurvNumber As %String) As %String
{
	New (aSSHospCode,aSurvNumber)
	Set return=0
	Quit:(aSSHospCode="")||(aSurvNumber="") return
	
	If $p(aSSHospCode,"-",1)=11 {  //北京市版本
		If $e(aSurvNumber,1,4)>=2013 {
			Write "<script type='text/javascript' src='../Scripts/dhcmed/ninf/CSS/clinreport/2014BJ_gui.js'></script>",!
    		Write "<script type='text/javascript' src='../Scripts/dhcmed/ninf/CSS/clinreport/2014BJ_event.js'></script>",!
		} Else {}
	} Else {                       //全国统一版本
		If $e(aSurvNumber,1,4)>2013 {
			Write "<script type='text/javascript' src='../Scripts/dhcmed/ninf/CSS/clinreport/2014_gui.js'></script>",!
    		Write "<script type='text/javascript' src='../Scripts/dhcmed/ninf/CSS/clinreport/2014_event.js'></script>",!
		} Else {}
	}
	
	Set return=1
	Quit return
}

/// w ##Class(DHCMed.NINFService.CSS.ClinReport).GetReportTEMP("21-DT","201406040001")
ClassMethod GetReportTEMP(aSSHospCode As %String, aSurvNumber As %String) As %String
{
	New (aSSHospCode,aSurvNumber)
	Set return=""
	Quit:(aSSHospCode="")||(aSurvNumber="") return
	
	If $p(aSSHospCode,"-",1)=11 {  //北京市版本
		If $e(aSurvNumber,1,4)>=2013 {
			Set return="DHCMed.NINF.CSSReport2014BJ.xlt"
		} Else {}
	} Else {                       //全国统一版本
		If $e(aSurvNumber,1,4)>=2013 {
			Set return="DHCMed.NINF.CSSReport2014.xlt"
		} Else {}
	}
	
	Quit return
}

}
