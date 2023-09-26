Class DHCMed.NINFService.Srv.ExportMinkeICUSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

Parameter FieldSeperator = "^";

/// 说明        :导出的主函数
/// 输入参数    ：
/// ReportID    :报告的ID
/// 返回值      :
/// 返回值格式  :返回代码_$c(1)_问题描述_$c(1)_具体记录
/// 返回值代码  :OK--没有问题
/// 			:Error--有问题，但能够导出
/// 			:Fail--致命错误，无法导出
/// w ##class(DHCMed.NINFService.Srv.ExportMinkeICUSrv).ExportReport(14)
ClassMethod ExportReport(ReportID As %String) As %String
{
	New (ReportID)
	Set return=""
	Quit:ReportID="" return
	
	Set objRep=##class(DHCMed.NINF.Srv.InfReport).GetObjById(ReportID,"ICU")
	Quit:'$IsObject(objRep) return
	Set tmp=..BuildBaseInfo(objRep) 
	Set $p(tmp,..#FieldSeperator,17)=1 //是否有ICU监测报告
	Set $p(tmp,..#FieldSeperator,18)=3 //疾病转归
	Set $p(return,$c(1),1)=tmp       //病人基本信息
	Set $p(return,$c(1),2)=..BuildICUBase(objRep)        //ICU调查的病人基本情况
	//Set $p(return,$c(1),3)=..BuildICUDiagnose(objRep,"COMP")    //基础疾病
	Set $p(return,$c(1),3)=..BuildICUDiagnose(objRep,"ICU")       //入ICU诊断
	Set $p(return,$c(1),4)=..BuildNPICC(objRep)      //ICU插管
	
	Set $p(return,$c(1),5)=##class(DHCMed.NINFService.Srv.ExportMinkeSrv).BuildBaseDiagnose(objRep)    //基础疾病
	Set $p(return,$c(1),6)=##class(DHCMed.NINFService.Srv.ExportMinkeSrv).BuildOperation(objRep)       //手术情况
	Set $p(return,$c(1),7)=##class(DHCMed.NINFService.Srv.ExportMinkeSrv).BuildInfFactors(objRep)      //易感因素
	Set $p(return,$c(1),8)=##class(DHCMed.NINFService.Srv.ExportMinkeSrv).BuildInvasiveOpers(objRep)   //侵害性操作
	Set $p(return,$c(1),9)=##class(DHCMed.NINFService.Srv.ExportMinkeSrv).BuildInfPos(objRep)          //感染部位1
	Set $p(return,$c(1),10)=##class(DHCMed.NINFService.Srv.ExportMinkeSrv).BuildInfPosOpr(objRep)       //感染部位2
	Set $p(return,$c(1),11)=##class(DHCMed.NINFService.Srv.ExportMinkeSrv).BuildLabResult(objRep)       //病原学检测1
	Set $p(return,$c(1),12)=##class(DHCMed.NINFService.Srv.ExportMinkeSrv).BuildLabResultsPY(objRep)    //病原学检测2
	Set $p(return,$c(1),13)=##class(DHCMed.NINFService.Srv.ExportMinkeSrv).BuildLabResultsDrug(objRep) //病原学检测3
	Set $p(return,$c(1),14)=##class(DHCMed.NINFService.Srv.ExportMinkeSrv).BuildAnti(objRep)           //抗菌药物使用情况	
	
	Quit return
}

/// 病人基本信息
ClassMethod BuildBaseInfo(objRep As DHCMed.NINF.Srv.InfReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objRep.EpisodeID)
	Do objAdm.%Close()
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(objRep.PatientID)
	Do objPatient.%Close()
	//Set arryPos=objRep.GetInfPos(objRep.ReportID)
	//Set objPos=arryPos.GetAt(1)
	//Quit:'$IsObject(objPos) ret
	
	Set objSumm=objRep.GetReportSumm(objRep.ReportID)
	Quit:'$IsObject(objSumm) ret
	
	//*调查表时间（发生院内感染的时间）
	Set $p(ret,..#FieldSeperator,1)=objRep.ReportDate
	//*感染科别
	Set objDic=objSumm.TransLoc
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,2)=..GetMapping("MKLocation",objDic.Code,objDic.Desc,objDic.Desc)
	} Else {
		Set objDic=objRep.ReportLoc
		Set $p(ret,..#FieldSeperator,2)=..GetMapping("MKLocation",objDic.Code,objDic.Desc,objDic.Desc)
	}
	
	//院内科别
	Set objDic=objSumm.TransLoc
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,3)=..GetMapping("MKHospLoc",objDic.Code,objDic.Desc,objDic.Desc)
	} Else {
		Set $p(ret,..#FieldSeperator,3)=""
	}
	//*调查表登记日期
	Set $p(ret,..#FieldSeperator,4)=objRep.ReportDate
	//*调查者
	Set $p(ret,..#FieldSeperator,5)=objRep.ReportUser.Desc
	//*病历号
	Set MrNo=##class(DHCMed.NINFService.Srv.CommonSrv).GetMrNoByAdm(objRep.EpisodeID)
	Set:MrNo="" MrNo=objPatient.InPatientMrNo
	Set:MrNo="" MrNo=objPatient.PapmiNo        //如果病历号错误，用登记号代替
	Set $p(ret,..#FieldSeperator,6)=MrNo
	//*本月住院次数（本院转入该科室的次数）
	Set $p(ret,..#FieldSeperator,7)=1
	Set Year=$p(objRep.ReportDate,"-",1)
	Set Month=$p(objRep.ReportDate,"-",2)
	Set FirstDay=$zdh(Year_"-"_Month_"-01",3)
	If Month=12 {
		Set LastDay=$zdh((Year+1)_"-01-01",3)-1
	} Else {
		Set LastDay=$zdh(Year_"-"_(Month+1)_"-01",3)-1
	}
	Set Paadm=""
	For {
		Set Paadm=$o(^PAPERdr(objRep.PatientID,"ADM","I",Paadm))
		Quit:Paadm=""
		Set AdmData=$g(^PAADM(Paadm))
		Set AdmitDate=$p(AdmData,"^",6)
		Continue:((AdmitDate<FirstDay)||(AdmitDate>LastDay))
		Set $p(ret,..#FieldSeperator,7)=$p(ret,..#FieldSeperator,7)+1
	}
	//*姓名
	Set $p(ret,..#FieldSeperator,8)=objPatient.PatientName
	//*性别
	Set $p(ret,..#FieldSeperator,9)=objPatient.Sex
	//*年龄
	Set $p(ret,..#FieldSeperator,10)=objPatient.Age
	//床位号
	Set $p(ret,..#FieldSeperator,11)=objAdm.Bed
	//*入院日期
	Set $p(ret,..#FieldSeperator,12)=objAdm.AdmitDate
	//出院日期
	Set $p(ret,..#FieldSeperator,13)=objAdm.DisDate
	//医院感染
	Set $p(ret,..#FieldSeperator,14)=0
	If objRep.ReportType.Code="COMP" {
		Set $p(ret,..#FieldSeperator,14)=1 //医院感染
	}
	//漏报病人
	Set $p(ret,..#FieldSeperator,15)=0
	//调查方式
	Set $p(ret,..#FieldSeperator,16)=2
	//ICU检测(是否ICU目标性监测)
	Set $p(ret,..#FieldSeperator,17)=0
	//*疾病转归
	Set objDic=objSumm.DiseasePrognosis
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,18)=..GetMapping("MKDiseasePrognosis",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,18)=3
	}
	//与死亡关系
	Set objDic=objSumm.DeathRelation
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,19)=..GetMapping("MKDeathRelation",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,19)=0
	}
	//感染性疾病病程
	Set DiseaseCourse=objSumm.DiseaseCourse
	Set:$l(DiseaseCourse)>254 DiseaseCourse=$e(DiseaseCourse,1,254)
	Set $p(ret,..#FieldSeperator,20)=DiseaseCourse
	//感染疾病诊断依据
	Set DiagnosisBasis=objSumm.DiagnosisBasis
	Set:$l(DiagnosisBasis)>254 DiagnosisBasis=$e(DiagnosisBasis,1,254)
	Set $p(ret,..#FieldSeperator,21)=DiagnosisBasis
	//是否入住ICU
	Set objDic=objSumm.ICUBoolean
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,22)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,22)=0
	}
	//手术（是否）
	Set objDic=objSumm.OprBoolean
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,23)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,23)=0
	}
	//病原学监测（是否）
	Set objDic=objSumm.LabBoolean
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,24)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,24)=0
	}
	//使用抗生素使用（是否）
	Set objDic=objSumm.AntiBoolean
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,25)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,25)=0
	}
	//不良反应（是否）
	Set objDic=objSumm.AdverseReaction
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,26)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,26)=0
	}
	//二重感染（是否）
	Set objDic=objSumm.Superinfection
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,27)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,27)=0
	}
	//手术检测(是否手术切口目标性监测)
	Set $p(ret,..#FieldSeperator,28)=0
	Quit ret
}

/// 基本诊断
ClassMethod BuildBaseDiagnose(objRep As DHCMed.NINF.Srv.InfReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	Set arryDia=objRep.GetDiagnos(objRep.ReportID)
	Set Cnt=arryDia.Count()
	For ind=1:1:Cnt {
		Set objDia=arryDia.GetAt(ind)
		Continue:'$IsObject(objDia)
		Continue:objDia.DiagnosDesc=""
		
		Set:ret'="" ret=ret_$c(2)
		
		//基础疾病
		Set ICD10=objDia.DiagnosICD
		Set ret=ret_..GetMapping("MKDiagnos",objDia.DiagnosDesc,ICD10,ICD10)
	}
	
	Quit ret
}

ClassMethod BuildICUBase(objRep As DHCMed.NINF.Srv.InfReport) As %String
{
		new (objRep	)
		Set ret=""
		Quit:'$IsObject(objRep) ret
		Set objSumm=##class(DHCMed.NINF.Srv.InfReport).GetReportSumm(objRep.ReportID)
		Quit:'$IsObject(objSumm) ret
		Do objSumm.%Close()
		
		
		Set $p(ret,..#FieldSeperator,1)="" //上次入ICU日期
		
		//标准科别
		Set objCtloc=objSumm.TransLoc //##class(DHCMed.Base.Ctloc).GetObjById(objSumm.TransLoc)
		Set:'$IsObject(objCtloc) objCtloc=##class(DHCMed.Base.Ctloc).%New()
		Do objCtloc.%Close()
		Set $p(ret,..#FieldSeperator,2)=..GetMapping("MKLocation",objCtloc.Code,objCtloc.Desc,objCtloc.Desc) //标准科别
		Set $p(ret,..#FieldSeperator,3)=objCtloc.Desc //院内科别
		Set TransInDate=objSumm.TransInDate
		Set:TransInDate'="" $p(ret,..#FieldSeperator,4)=TransInDate //入ICU日期
		
		Set objCtloc=objSumm.TransFromLoc 
		Set:'$IsObject(objCtloc) objCtloc=##class(DHCMed.Base.Ctloc).%New()
		Do objCtloc.%Close()		
		Set $p(ret,..#FieldSeperator,5)=..GetMapping("MKLocation",objCtloc.Code,objCtloc.Desc,objCtloc.Desc) //由..转入
		Set $p(ret,..#FieldSeperator,6)=objCtloc.Desc //院内科别
		Set TransOutDate=objSumm.TransOutDate
		Set:TransOutDate'="" $p(ret,..#FieldSeperator,7)=TransOutDate //转出ICU日期
		
		Set objCtloc=objSumm.TransToLoc 
		Set:'$IsObject(objCtloc) objCtloc=##class(DHCMed.Base.Ctloc).%New()
		Do objCtloc.%Close()				
		Set $p(ret,..#FieldSeperator,8)=..GetMapping("MKLocation",objCtloc.Code,objCtloc.Desc,objCtloc.Desc) //由..转入 //转出至
		Set $p(ret,..#FieldSeperator,9)=objCtloc.Desc //院内科别
		//转出ICU时状态
		For i=1:1:objSumm.OutICUStatus.Count() {
			Set objDic=objSumm.OutICUStatus.GetAt(i)
			Set:objDic.Code="1" $p(ret,..#FieldSeperator,10)="" //转出ICU时状态：气道
			Set:objDic.Code="2" $p(ret,..#FieldSeperator,11)="" //机械通气
			Set:objDic.Code="3" $p(ret,..#FieldSeperator,12)="" //中心静脉导管
			Set:objDic.Code="4" $p(ret,..#FieldSeperator,13)="" //尿管
			Set:objDic.Code="5" $p(ret,..#FieldSeperator,14)="" //动脉置管
			Set:objDic.Code="6" $p(ret,..#FieldSeperator,15)="" //其他装置
		}
		//转出48小时内状态
		For i=1:1:objSumm.OutICU48Status.Count() {
			Set objDic=objSumm.OutICU48Status.GetAt(i)
			Set $p(ret,..#FieldSeperator,16)="" //转出48小时内状态：气道
			Set $p(ret,..#FieldSeperator,17)="" //机械通气
			Set $p(ret,..#FieldSeperator,18)="" //中心静脉导管
			Set $p(ret,..#FieldSeperator,19)="" //尿管
			Set $p(ret,..#FieldSeperator,20)="" //动脉置管
			Set $p(ret,..#FieldSeperator,21)="" //其他装置
		}
		
		Set $p(ret,..#FieldSeperator,22)=objSumm.SystemSymptom //系统症状
		Set $p(ret,..#FieldSeperator,23)=objSumm.LocalSymptom //局部症状
		Quit ret
}

//诊断

ClassMethod BuildICUDiagnose(objRep As DHCMed.NINF.Srv.InfReport, DiagType As %String = "COMP")
{
	n (objRep,DiagType)
	Set ret=""
	Set arryDia=objRep.GetDiagnos(objRep.ReportID,DiagType)
	For i=1:1:arryDia.Count() {
		Set objDia=arryDia.GetAt(i)
		Continue:'$IsObject(objDia)
		Set ICD=$Extract(objDia.DiagnosICD,1,5)
		Set DisName=objDia.DiagnosDesc
		Set tmp=$$GetICUDiagnose1(ICD,DisName,ICD)
		Set:ret'="" ret=ret_$c(2)
		Set:tmp'="" ret=ret_tmp
	}
	Quit ret
}

ClassMethod BuildNPICC(objRep As DHCMed.NINF.Srv.InfReport) As %String
{
	n (objRep)
	Set ret=""
	Set arry=objRep.GetICUPICC(objRep.ReportID)
	For i=1:1:arry.Count() {
		Set objItm=arry.GetAt(i)
		Continue:'$IsObject(objItm)
		
		Set $p(tmp,..#FieldSeperator,1)=objItm.IntubateType.Desc //导管类型
		Set $p(tmp,..#FieldSeperator,2)=objItm.PICCIntubateNum.Desc //导管腔数
		Set $p(tmp,..#FieldSeperator,3)=objItm.PICCIntubateRegion.Desc //部位
		Set $p(tmp,..#FieldSeperator,4)=objItm.IntubateDate //插管日期
		Set $p(tmp,..#FieldSeperator,5)=objItm.ExtubateDate //拔管日期
		Set $p(tmp,..#FieldSeperator,6)=objItm.IntubateUserType.Desc //插管者
		Set $p(tmp,..#FieldSeperator,7)=objItm.IntubatePlace.Desc //置管地点
		Set $p(tmp,..#FieldSeperator,8)=$s(objItm.InfDate'="":1,1:0) //是否感染
		Set $p(tmp,..#FieldSeperator,9)="局部症状" //感染症状
		Set $p(tmp,..#FieldSeperator,10)=objItm.InfDate //感染日期			
		Set:ret'="" ret=ret_$c(2)
		Set ret=ret_"^"_tmp
	}
	Quit ret
}

ClassMethod ValidateReport(ReportID As %String) As %String
{
	n (ReportID)
	Set ret=""
	
	Set objRep=##class(DHCMed.NINF.Srv.InfReport).GetObjById(ReportID,"ICU")
	Quit:'$IsObject(objRep) ret
	
	Quit:'$IsObject(objRep.ReportType) ret
	Do objRep.%Close()

	Set objSumm=objRep.GetReportSumm(ReportID)
	Quit:'$IsObject(objSumm) ret
	//校验基本信息
	//转入科室
	Set objDic=objSumm.TransLoc
	If $IsObject(objDic) { 
		Set tmp=..IsMapping(objDic.Code,objDic.Desc,"MKLocation","报告科室无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
	}
	//入科来源
	Set objDic=objSumm.TransFromLoc
	If $IsObject(objDic) { 
		Set tmp=..IsMapping(objDic.Code,objDic.Desc,"MKLocation","报告科室无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)	
	}
	//出科去向
	Set objDic=objSumm.TransToLoc
	If $IsObject(objDic) { 
		Set tmp=..IsMapping(objDic.Code,objDic.Desc,"MKLocation","报告科室无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
	}
	Set tmp=..CheckReport(objRep)
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	
	//校验诊断信息
	Set arryDia=objRep.GetDiagnos(ReportID)
	//ICU转入诊断
	For i=1:1:arryDia.Count() {
		Set objDia=arryDia.GetAt(i)
		Continue:objDia.DiagnosType.Code'="ICU"
		Set ICD=$Extract(objDia.DiagnosICD,1,5)
		Set DisName=objDia.DiagnosDesc
		Set tmp1=$$GetICUDiagnose1(ICD,DisName,"ERROR")
		Set tmp2=..IsMapping(ICD,DisName,"MKInfDiag","ICU诊断无法对照")
		Set:tmp'=((tmp1="ERROR")&&(tmp2'="OK")) ret=ret_tmp_$c(2)
	}
	//基础诊断
	For i=1:1:arryDia.Count() {
		Set objDia=arryDia.GetAt(i)
		Continue:objDia.DiagnosType.Code'="COMP"
		Set ICD=$Extract(objDia.DiagnosICD,1,5)
		Set DisName=objDia.DiagnosDesc
		Set tmp1=$$GetICUDiagnose1(ICD,DisName,"ERROR")
		Set tmp2=..IsMapping(ICD,DisName,"MKInfDiag","基础诊断无法对照")
		Set:tmp'=((tmp1="ERROR")&&(tmp2'="OK")) ret=ret_tmp_$c(2)
	}	
	Set arryPICC=objRep.GetICUPICC(ReportID)
	For i=1:1:arryPICC.Count() {
		Set objPICC=arryPICC.GetAt(i)
		Continue:'$IsObject(objPICC)
	}
	
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	Quit ret
GetICUDiagnose1(ICD,DisName,DefaultValue)
	n (ICD,DisName,DefaultValue)
	Set DefaultValue=$g(DefaultValue)
	Set tmpRet=""
	Set ShortDesc=##Class(DHCMed.NINFService.Srv.CommonCls).ALPHAUP(DisName)
	Set objDic=##class(DHCMed.NINFService.Srv.ExportMinkeSrv).GetMinkeDic("000001006",ICD,DisName)
	if ($IsObject(objDic)) {
		Set tmpRet=objDic.Code
		Do objDic.%Close()
	}else {
		Set tmpRet=DefaultValue
	}
	Quit tmpRet
}

ClassMethod CheckReport(objRep As DHCMed.NINF.Srv.InfReport) As %String
{
	New (objRep)
	Set ret=""
	
	//报告科室
	Set tmp=..IsMapping(objRep.ReportLoc.Code,objRep.ReportLoc.Desc,"MKLocation","报告科室无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.ReportLoc.Code,objRep.ReportLoc.Desc,"MKHospLoc","报告科室无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	
	Set objSumm=objRep.GetReportSumm(objRep.ReportID)
	If $IsObject(objSumm) {
		//感染科室
		Set tmp=..IsMapping(objSumm.TransLoc.Code,objSumm.TransLoc.Desc,"MKLocation","感染科室无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objSumm.TransLoc.Code,objSumm.TransLoc.Desc,"MKHospLoc","感染科室无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		//易感因素
		Set Cnt=objSumm.InfFactors.Count()
		For indArr=1:1:Cnt {
			Set objFact=objSumm.InfFactors.GetAt(indArr)
			Continue:'$IsObject(objFact)
			
			Set tmp=..IsMapping(objFact.Code,objFact.Desc,"MKInfFactors","易感因素无法对照")
			Set:tmp'="OK" ret=ret_tmp_$c(2)
		}
		//侵害性操作
		Set Cnt=objSumm.InvasiveOperation.Count()
		For indArr=1:1:Cnt {
			Set objOpr=objSumm.InvasiveOperation.GetAt(indArr)
			Continue:'$IsObject(objOpr)
		
			Set tmp=..IsMapping(objOpr.Code,objOpr.Desc,"MKInvasiveOpers","侵害行操作无法对照")
			Set:tmp'="OK" ret=ret_tmp_$c(2)
		}
		//疾病转归
		Set tmp=..IsMapping(objSumm.DiseasePrognosis.Code,objSumm.DiseasePrognosis.Desc,"MKDiseasePrognosis","与死亡关系无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		//与死亡关系
		Set tmp=..IsMapping(objSumm.DeathRelation.Code,objSumm.DeathRelation.Desc,"MKDeathRelation","与死亡关系无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
	}
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	Quit ret
}

ClassMethod GetMapping(aMappingType As %String, aSrcValue As %String, aSrcDesc As %String, aDefaultValue As %String = "") As %String
{
	New (aMappingType,aSrcValue,aSrcDesc,aDefaultValue)
	Quit ##class(DHCMed.NINFService.Srv.ExportMinkeSrv).GetMapping(aMappingType,aSrcValue,aSrcDesc,aDefaultValue)
}

ClassMethod IsMapping(aSrcValue As %String, aSrcDesc As %String, aMappingType As %String, aErrorMsg As %String)
{
	New (aSrcValue,aSrcDesc,aMappingType,aErrorMsg)
	Quit ##class(DHCMed.NINFService.Srv.ExportMinkeSrv).IsMapping(aSrcValue,aSrcDesc,aMappingType,aErrorMsg)
}

/// 查询医院感染报告校验信息
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Srv.ExportMinkeICUSrv","QryValidateInfo","5^13^14^22^23^24","^")
Query QryValidateInfo(aReportList As %String, aDelimiter As %String = "^") As %Query(ROWSPEC = "Index:%String,ID:%String,SrcValue:%String,SrcDesc:%String,TargetValue:%String,TargetDesc:%String,ResumeText:%String,MappingTypeCode:%String,MappingTypeDesc:%String,MapDicGroupCode:%String,MapDicTypeCode:%String")
{
}

ClassMethod QryValidateInfoExecute(ByRef qHandle As %Binary, aReportList As %String, aDelimiter As %String = "^") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set NIndex="QryValidateInfo"
 	Kill ^TMP($zn,$j,NIndex)
 	
 	For indRep=1:1:$l(aReportList,aDelimiter) {
 		Set ReportID=$p(aReportList,aDelimiter,indRep)
 		Continue:ReportID=""
 		
 		Set flg=..ValidateReport(ReportID)
 		Continue:flg="OK"
 		Set ErrorList=flg    //获取错误列表
 		
 		For indErr=1:1:$l(ErrorList,$c(2)) {
	 		Set ErrorItem=$p(ErrorList,$c(2),indErr)
	 		Continue:ErrorItem=""
	 		
	 		//"ERROR^"_{对照字典类别}_"^"_{错误信息}_"^"_{源值}_"^"_{源值描述}
	 		Set ErrorLevel=$p(ErrorItem,"^",1)   //错误级别
	 		Set MappingType=$p(ErrorItem,"^",2)  //对照字典类别
	 		Set ErrorMsg=$p(ErrorItem,"^",3)     //错误信息
	 		Set SrcValue=$p(ErrorItem,"^",4)     //源值
	 		Set SrcDesc=$p(ErrorItem,"^",5)      //源值描述
	 		Continue:((MappingType="")||(SrcValue=""))
	 		Set ^TMP($zn,$j,NIndex,"ErrorIndex",MappingType,SrcValue)=ErrorItem
	 	}
 	}
 	
 	Set xMappingType=""
 	For {
	 	Set xMappingType=$o(^TMP($zn,$j,NIndex,"ErrorIndex",xMappingType))
	 	Quit:xMappingType=""
	 	
	 	Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("INFMinkeMappingType",xMappingType,"")
	 	Continue:'$IsObject(objDic)
	 	
	 	Set xSrcValue=""
	 	For {
	 		Set xSrcValue=$o(^TMP($zn,$j,NIndex,"ErrorIndex",xMappingType,xSrcValue))
	 		Quit:xSrcValue=""
	 		
			Set ErrorItem=$g(^TMP($zn,$j,NIndex,"ErrorIndex",xMappingType,xSrcValue))
	 		Continue:ErrorItem=""
	 		Set ErrorLevel=$p(ErrorItem,"^",1)   //错误级别
	 		Set MappingType=$p(ErrorItem,"^",2)  //对照字典类别
	 		Set ErrorMsg=$p(ErrorItem,"^",3)     //错误信息
	 		Set SrcValue=$p(ErrorItem,"^",4)     //源值
	 		Set SrcDesc=$p(ErrorItem,"^",5)      //源值描述
	 		
	 		//字典对照RowID
	 		Set ID=$o(^DHCMed.NINFSi("MKDMap",0,"IndexCategorySrcID"," "_$zcvt(MappingType,"U")," "_$zcvt(SrcValue,"U"),0))
	 		
	 		//对照字典类别代码,对照字典类别名称,源值,源值描述,目标值,目标值描述,备注,字典类别,序号
	 		Set Data=$lb("")
	 		Set $li(Data,1)=ind
	 		Set $li(Data,2)=ID
	 		Set $li(Data,3)=SrcValue
	 		Set $li(Data,4)=SrcDesc
	 		Set $li(Data,5)=""
	 		Set $li(Data,6)=""
	 		Set $li(Data,7)=""
	 		Set $li(Data,8)=objDic.Code
	 		Set $li(Data,9)=objDic.Description
	 		Set $li(Data,10)=objDic.StrA
	 		Set $li(Data,11)=objDic.StrB
	 		Set ^CacheTemp(repid,ind)=Data
	 		Set ind=ind+1
	 	}
 	}
 	Kill ^TMP($zn,$j,NIndex)
 	
	Quit $$$OK
}

ClassMethod QryValidateInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryValidateInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryValidateInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryValidateInfoExecute ]
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
