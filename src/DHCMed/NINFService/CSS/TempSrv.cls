/// 名称:DHCMed.NINFService.CSS.TempSrv
/// 描述:横断面【电子病历数据导入横断面表】相关业务
/// 编写者：zhufei
/// 编写日期: 2014-05-23
Class DHCMed.NINFService.CSS.TempSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCMed.NINFService.CSS.TempSrv).ProCSSData("2014-05-11","2014-05-23",3)
ClassMethod ProCSSData(aDateFrom As %String, aDateTo As %String, aPrjID As %String) As %String
{
	new (aDateFrom,aDateTo,aPrjID)
	set return=0
	quit:(aDateFrom="")||(aDateTo="")||(aPrjID="") return
	
	set:aDateFrom["-" aDateFrom=$zdh(aDateFrom, 3)         //日期格式转换
	set:aDateTo["-" aDateTo=$zdh(aDateTo, 3)
	
	set xCRRepID="",Count=0
	for {
		set xCRRepID=$o(^DHCMed.CR.ReportI("IndexProjectID"," "_aPrjID,xCRRepID))
		quit:xCRRepID=""
		
		set objCRRep=##class(DHCMed.CR.Report).%OpenId(xCRRepID)
		continue:'$IsObject(objCRRep)
		do objCRRep.%Close()
		
		set RepDate=objCRRep.RepDate
		continue:(RepDate>aDateTo)||(RepDate<aDateFrom)
		set EpisodeID=objCRRep.EpisodeID
		set AdmInfo=$g(^PAADM(EpisodeID))
		set AdmLoc=$p(AdmInfo,"^",4)
		set HospitalID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
		if HospitalID="2" {
			set SurvNumber="201405230001"
		} else {
			set SurvNumber="201405230002"
		}
		
		set flg=..GetCSSDataFromEPR(xCRRepID,SurvNumber,"2014-05-21")
		continue:flg<1
		Set Count=Count+1
	}
	set return=Count
	
	quit return
}

/// w ##class(DHCMed.NINFService.CSS.TempSrv).GetCSSDataFromEPR("104")
ClassMethod GetCSSDataFromEPR(aCRRepID As %String, aSurvNumber As %String, aSurvDate As %String) As %String
{
	new (aCRRepID,aSurvNumber,aSurvDate)
	set return=0
	quit:(aCRRepID="")||(aSurvNumber="")||(aSurvDate="") return
	
	set return=-1
	set objCRRep=##class(DHCMed.CR.Report).%OpenId(aCRRepID)
	quit:'$IsObject(objCRRep) return
	do objCRRep.%Close()
	
	set EpisodeID=objCRRep.EpisodeID
	set InstanceID=objCRRep.InstanceID
	quit:(EpisodeID="")||(InstanceID="") return
	
	set:aSurvDate["-" aSurvDate=$zdh(aSurvDate,3)
	
	set return=-3
	if '$d(^DHCMed.NINF.CSSi("BSR","SurvNumPaadm"," "_aSurvNumber,EpisodeID)){
		set AdmInfo=$g(^PAADM(EpisodeID))
		set AdmLoc=$p(AdmInfo,"^",4)
		set AdmWard=$p(AdmInfo,"^",70)
		set:AdmWard'="" AdmWard=$p($g(^PAWARD(AdmWard)),"^",5)
		set strInput="^"_aSurvNumber_"^"_AdmLoc_"^"_AdmWard_"^"_aSurvDate_"^"_EpisodeID_"^^^^1^"
		set flg=##Class(DHCMed.NINF.CSS.BedSurvRec).Update(strInput)
		quit:flg<1 return
		set BSRID=flg
	} else {
		set BSRID=$o(^DHCMed.NINF.CSSi("BSR","SurvNumPaadm"," "_aSurvNumber,EpisodeID,0))
	}
	quit:BSRID="" return
	
	set return=-4
	set objBSR=##class(DHCMed.NINF.CSS.BedSurvRec).GetObjById(BSRID)
	quit:'$IsObject(objBSR) return
	
	set SurvDept=objBSR.BSCSurvDept
	set SurvDeptDesc=$p($g(^CTLOC(+SurvDept)),"^",2)
	set:$p(SurvDeptDesc,"-",2)'="" SurvDeptDesc=$p(SurvDeptDesc,"-",2)
	set SurvWard=objBSR.BSCSurvWard
	set SurvWardDesc=$p($g(^CTLOC(+SurvWard)),"^",2)
	set:$p(SurvWardDesc,"-",2)'="" SurvWardDesc=$p(SurvWardDesc,"-",2)
	set SurvDate=objBSR.BSCSurvDate
	/*
	set SurvDate=..GetDataFromEPR(EpisodeID,"调查日期.D0054#TYPE:Simple#TID:75#TVER:0#SCODE:D0054#VTYPE:V",InstanceID)
	set SurvDate=$p(SurvDate," ",1)
	set:SurvDate["-" SurvDate=$zdh(SurvDate,3)
	set SurvDate=+SurvDate
	*/
	set ID=$o(^DHCMed.NINF.CSSi("REP","IndexEpisodeID"," "_aSurvNumber," "_EpisodeID,1,0))
	
	//set AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	
	set inputStr=ID
	set inputStr=inputStr_$c(1)_EpisodeID
	set inputStr=inputStr_$c(1)_aSurvNumber
	set inputStr=inputStr_$c(1)_SurvDate
	set inputStr=inputStr_$c(1)_SurvDeptDesc_"【"_SurvWardDesc_"】"
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"调查医师签字.I0053#TYPE:Simple#TID:75#TVER:0#SCODE:I0053#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_1
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"病案号.S0003#TYPE:Simple#TID:75#TVER:0#SCODE:S0003#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"姓名.S0004#TYPE:Simple#TID:75#TVER:0#SCODE:S0004#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"性别.O0010#TYPE:Simple#TID:75#TVER:0#SCODE:O0010#VTYPE:V",InstanceID)
	set Age=..GetDataFromEPR(EpisodeID,"年龄.S0006#TYPE:Simple#TID:75#TVER:0#SCODE:S0006#VTYPE:V",InstanceID)
	if Age["岁" {
		set AgeY=+$p(Age,"岁",1)
		set Age=$p(Age,"岁",2)
	}
	if Age["月" {
		set AgeM=+$p(Age,"月",1)
		set Age=$p(Age,"月",2)
	}
	if Age["天" {
		set AgeD=+$p(Age,"天",1)
	}
	set inputStr=inputStr_$c(1)_+$g(AgeY)
	set inputStr=inputStr_$c(1)_+$g(AgeM)
	set inputStr=inputStr_$c(1)_+$g(AgeD)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"科室.S0001#TYPE:Simple#TID:75#TVER:0#SCODE:S0001#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"床号.S0002#TYPE:Simple#TID:75#TVER:0#SCODE:S0002#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"入院日期.D0073^#TYPE:Simple#TID:75#TVER:0#SCODE:D0073#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"主要诊断1.I0012^#TYPE:Simple#TID:75#TVER:0#SCODE:I0012#VTYPE:V",InstanceID)
	set inputStr=inputStr_"#"_..GetDataFromEPR(EpisodeID,"主要诊断2.I0011^#TYPE:Simple#TID:75#TVER:0#SCODE:I0011#VTYPE:V",InstanceID)
	set inputStr=inputStr_"#"_""
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"医院感染.O0015^#TYPE:Simple#TID:75#TVER:0#SCODE:O0015#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"新部位1.I0056#TYPE:Simple#TID:75#TVER:0#SCODE:I0056#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"感染日期1.D0071^#TYPE:Simple#TID:75#TVER:0#SCODE:D0071#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"病原体1-1.S0033#TYPE:Simple#TID:75#TVER:0#SCODE:S0033#VTYPE:V",InstanceID)
	set inputStr=inputStr_"#"_..GetDataFromEPR(EpisodeID,"病原体1-2.S0032#TYPE:Simple#TID:75#TVER:0#SCODE:S0032#VTYPE:V",InstanceID)
	set inputStr=inputStr_"#"_..GetDataFromEPR(EpisodeID,"病原体1-3.S0031^#TYPE:Simple#TID:75#TVER:0#SCODE:S0031#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"新部位2.I0058#TYPE:Simple#TID:75#TVER:0#SCODE:I0058#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"感染日期2.D0072^#TYPE:Simple#TID:75#TVER:0#SCODE:D0072#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"病原体2-1.S0030#TYPE:Simple#TID:75#TVER:0#SCODE:S0030#VTYPE:V",InstanceID)
	set inputStr=inputStr_"#"_..GetDataFromEPR(EpisodeID,"病原体2-2.S0029#TYPE:Simple#TID:75#TVER:0#SCODE:S0029#VTYPE:V",InstanceID)
	set inputStr=inputStr_"#"_..GetDataFromEPR(EpisodeID,"病原体2-3.S0028^#TYPE:Simple#TID:75#TVER:0#SCODE:S0028#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"新部位3.I0060#TYPE:Simple#TID:75#TVER:0#SCODE:I0060#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"感染日期3.D0070^#TYPE:Simple#TID:75#TVER:0#SCODE:D0070#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"病原体3-1.S0027#TYPE:Simple#TID:75#TVER:0#SCODE:S0027#VTYPE:V",InstanceID)
	set inputStr=inputStr_"#"_..GetDataFromEPR(EpisodeID,"病原体3-2.S0026#TYPE:Simple#TID:75#TVER:0#SCODE:S0026#VTYPE:V",InstanceID)
	set inputStr=inputStr_"#"_..GetDataFromEPR(EpisodeID,"病原体3-3.S0025^#TYPE:Simple#TID:75#TVER:0#SCODE:S0025#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"抗菌药物使用.O0039#TYPE:Simple#TID:75#TVER:0#SCODE:O0039#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"目的.O0038#TYPE:Simple#TID:75#TVER:0#SCODE:O0038#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"联用.O0040#TYPE:Simple#TID:75#TVER:0#SCODE:O0040#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"治疗用药前后送细菌培养.O0037#TYPE:Simple#TID:75#TVER:0#SCODE:O0037#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"手术.O0047#TYPE:Simple#TID:75#TVER:0#SCODE:O0047#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"手术前曾应用治疗性抗菌药物.O0046#TYPE:Simple#TID:75#TVER:0#SCODE:O0046#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"手术切口等级.O0045#TYPE:Simple#TID:75#TVER:0#SCODE:O0045#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"围手术期用药.O0044#TYPE:Simple#TID:75#TVER:0#SCODE:O0044#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"应用动静脉插管.O0051#TYPE:Simple#TID:75#TVER:0#SCODE:O0051#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"应用泌尿道插管.O0050#TYPE:Simple#TID:75#TVER:0#SCODE:O0050#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"应用呼吸机.O0049#TYPE:Simple#TID:75#TVER:0#SCODE:O0049#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_..GetDataFromEPR(EpisodeID,"过去24小时是否有≥3次的腹泻.O0069^#TYPE:Simple#TID:75#TVER:0#SCODE:O0069#VTYPE:V",InstanceID)
	set inputStr=inputStr_$c(1)_+$h
	set inputStr=inputStr_$c(1)_$p($h,",",2)
	set inputStr=inputStr_$c(1)_""
	set inputStr=inputStr_$c(1)_""
	
	set flg=##Class(DHCMed.NINFService.CSS.ClinReport).SaveReport(inputStr,$c(1))
	quit:flg<1 return
	set ReportID=flg
	
	set flg=##Class(DHCMed.NINF.CSS.BedSurvRec).UpdateCSSInfo(BSRID,ReportID)
	quit:flg<1 return
	
	set return=ReportID
	quit return
}

ClassMethod GetDataFromEPR(EpisodeID As %String, ItemPara As %String, InstanceDataID As %String) As %String
{
	n (EpisodeID, ItemPara ,InstanceDataID)
	s ret=##class(EPRservice.BOScatterData).GetEPRMultipleData(EpisodeID, ItemPara ,InstanceDataID)
	q ret
}

}
