/// 导出民科接口服务类
Class DHCHAI.MK.ExportToMKSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 默认分隔符  <TAB>
Parameter FieldSeperator = "^";

/// w ##class(DHCHAI.MK.ExportToMKSrv).ExportReport(18,18)
ClassMethod ExportReport(aReport As %String, aReportIDList As %String = "") As %String
{
	New (aReport,aReportIDList)
	Set return=""
	Quit:aReport="" return
	Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(aReport)
	Quit:'$IsObject(objReport) return
	Quit:'$IsObject(objReport.IRStatusDr) return
	Set StatusCode=objReport.IRStatusDr.BTCode
	Quit:(StatusCode'="3")&&(StatusCode'="2")&&(StatusCode'="8") return //只导审核+提交的报告
	Set RepType=objReport.IRRepType
	
	Set IREpisodeDr=objReport.IREpisodeDr
	Quit:'$IsObject(IREpisodeDr) return
	Set DPPaadmDr=IREpisodeDr.%Id()
	
	Set arryReports=##class(DHCHAI.MK.INFReport).GetINFRepListByAdm(DPPaadmDr,RepType)
	Set Count=arryReports.Count()
	Set tmpCnt=Count
	For i=1:1:Count {
		Set objRep=arryReports.GetAt(i)
		Continue:'$IsObject(objRep)
		
		Set tReportIDList="^"_aReportIDList_"^"
		Continue:(aReportIDList'="")&&(tReportIDList'[("^"_objRep.ReportID_"^"))
		
		Set OperCutFlag=0
		
	  
	    if ((RepType'=1)&&(RepType'=2)) {
		    Set $p(return,$c(1),1)=..BuildBaseInfonew(objRep)
	
		}else {
			Set $p(return,$c(1),1)=..BuildBaseInfo(objRep)
			}
		;b ;1
		//Set $p(return,$c(1),1)=..BuildBaseInfo(objRep)                                  //病人基本信息
		//add by zsz 20200110........................
		set operflag=""
		Set arrynew=objRep.GetInfPos(objRep.ReportID)
		Set Cntnew=arrynew.Count()
		;b ;1
		For j=1:1:Cntnew {
			Set objPos=arrynew.GetAt(j)
			Continue:'$IsObject(objPos)
			//w objPos.InfDiag.Desc,!
			if (objPos.InfDiag.Desc="表浅手术切口感染")||(objPos.InfDiag.Desc="深部手术切口感染")||(objPos.InfDiag.Desc="器官（或腔隙）感染"){
				;b ;1
				set operflag=objPos.InfDiag.Desc
				}
		}
		;b ;1
		
		Set $p(return,$c(1),2)=$p(return,$c(1),2)_$c(2)_..BuildBaseDiagnose(objRep)     //基础疾病
		if ((RepType=1)||(RepType=2)){
			if operflag'=""{
			 Set $p(return,$c(1),3)=$p(return,$c(1),3)_$c(2)_..BuildOperation(objRep)        //手术情况
			}else{
			 set $p(return,$c(1),3)=""
			}
		}else{
			 set $p(return,$c(1),3)=$p(return,$c(1),3)_$c(2)_..BuildOperation(objRep)
		}
		Set $p(return,$c(1),4)=$p(return,$c(1),4)_$c(2)_..BuildInfFactors(objRep)       //易感因素
		Set $p(return,$c(1),5)=$p(return,$c(1),5)_$c(2)_..BuildInvasiveOpers(objRep)    //侵害性操作
		Set $p(return,$c(1),6)=$p(return,$c(1),6)_$c(2)_..BuildInfPos(objRep)           //感染部位1
		Set $p(return,$c(1),7)=$p(return,$c(1),7)_$c(2)_..BuildInfPos2(objRep)      	//感染部位2				    //感染部位2
		Set $p(return,$c(1),8)=$p(return,$c(1),8)_$c(2)_..BuildLabResult(objRep)        //病原学检测1
		Set $p(return,$c(1),9)=$p(return,$c(1),9)_$c(2)_..BuildLabResultsPY(objRep)     //病原学检测2
		Set $p(return,$c(1),10)=$p(return,$c(1),10)_$c(2)_..BuildLabResultsDrug(objRep) //病原学检测3
		Set $p(return,$c(1),11)=$p(return,$c(1),11)_$c(2)_..BuildAnti(objRep)           //抗菌药物使用情况
		
		//如果院感报告有手术，同时导入手术切口调查报告
		If $p(return,$c(1),3)'="" {
			Set BaseInfo=$p(return,$c(1),1)
			If RepType="4" {  //4手术切口调查表
				Set $p(BaseInfo,..#FieldSeperator,28)=1
			} Else {
				Set arrOpsRep=##class(DHCHAI.MK.INFReport).GetINFRepListByAdm(DPPaadmDr,"4")  //4手术切口调查表
				If arrOpsRep.Count()>0 {
					Set $p(BaseInfo,..#FieldSeperator,28)=1  //是否做手术切口调查标志
				}
			}
			Set $p(return,$c(1),1)=BaseInfo
			
			Set RepDate=$p(BaseInfo,..#FieldSeperator,1)
			Set OperInfo=$p(return,$c(1),3)
			If ($p(OperInfo,..#FieldSeperator,11)="1") {
				Set $p(OperInfo,..#FieldSeperator,12)=RepDate
				Set $p(return,$c(1),3)=OperInfo
			}
		}
		Set tmpCnt=tmpCnt-1
	}
	Quit:return="" return
	
	//update by zf 2016-08-09
	//处理导出接口中的重复数据
	Set $p(return,$c(1),2)=..ProRepeatRecords($p(return,$c(1),2),$c(2))
	Set $p(return,$c(1),3)=..ProRepeatRecords($p(return,$c(1),3),$c(2))
	Set $p(return,$c(1),4)=..ProRepeatRecords($p(return,$c(1),4),$c(2))
	Set $p(return,$c(1),5)=..ProRepeatRecords($p(return,$c(1),5),$c(2))
	Set $p(return,$c(1),6)=..ProRepeatRecords($p(return,$c(1),6),$c(2))
	Set $p(return,$c(1),7)=..ProRepeatRecords($p(return,$c(1),7),$c(2))
	Set $p(return,$c(1),8)=..ProRepeatRecords($p(return,$c(1),8),$c(2))
	Set $p(return,$c(1),9)=..ProRepeatRecords($p(return,$c(1),9),$c(2))
	Set $p(return,$c(1),10)=..ProRepeatRecords($p(return,$c(1),10),$c(2))
	Set $p(return,$c(1),11)=..ProRepeatRecords($p(return,$c(1),11),$c(2))
	Quit return
}

/// w ##class(DHCHAI.MK.ExportToMKSrv).ExportICUReport("154","154","2019-11-26 13^2019-12-11 08^肝胆外科1^^218")
ClassMethod ExportICUReport(aReport As %String, aReportIDList As %String = "", IcuStr As %String = "") As %String
{
	New (aReport,aReportIDList,IcuStr)
	Set return=""
	Quit:aReport="" return
	s ^tempzsztest("gghhjsdkfsjdfkslfsdddd")=$lb(aReport , aReportIDList, IcuStr )
	Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(aReport)
	Quit:'$IsObject(objReport) return
	Quit:'$IsObject(objReport.IRStatusDr) return
	Set StatusCode=objReport.IRStatusDr.BTCode
	Quit:(StatusCode'="3")&&(StatusCode'="2")&&(StatusCode'="1")&&(StatusCode'="8") return //只导审核+提交的报告
	Set RepType=objReport.IRRepType
	;b ;1
	//if (RepType=1)||(RepType=2) Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(aReport)
	Set IREpisodeDr=objReport.IREpisodeDr
	Quit:'$IsObject(IREpisodeDr) return
	Set DPPaadmDr=IREpisodeDr.%Id()
	//add by zsz 20191216 取院感报告的ID
	/*set aRepID=""
	Set aRepID=$O(^DHCHAI.IR.INFReportI("IndexPaadmType",DPPaadmDr,1,""),-1) 
	if aRepID'="" {
	  //set objRepnew=##class(DHCHAI.IR.INFReport).GetObjById(aRepID)
	  set arryReportsnew=##class(DHCHAI.MK.INFReport).GetINFRepListByAdm(DPPaadmDr,1)
	  Set objRepnew=arryReportsnew.GetAt(1)
	  //Continue:'$IsObject(objRep)
	}*/
	//.....
	//b ;1
	Set arryReports=##class(DHCHAI.MK.INFReport).GetINFRepListByAdm(DPPaadmDr,RepType)
	Set Count=arryReports.Count()
	
	;b ;22222
	Set tmpCnt=Count
	For i=1:1:Count {
		Set objRep=arryReports.GetAt(i)
		Continue:'$IsObject(objRep)
		
		Set tReportIDList="^"_aReportIDList_"^"
		Continue:(aReportIDList'="")&&(tReportIDList'[("^"_objRep.ReportID_"^"))
		;b ;222
		Set OperCutFlag=0
        //Set $p(return,$c(1),1)=..BuildBaseInfo(objRep)
        //if aRepID'=""{
          //Set $p(return,$c(1),1)=..BuildBaseInfo(objRepnew)
        //}else{
          Set $p(return,$c(1),1)=..BuildICUBaseInfonew(objRep)
        //}
        Set $p(return,$c(1),2)=$p(return,$c(1),2)_$c(2)_..BuildICUBase(objRep)        //ICU病人基本情况
		//Set $p(return,$c(1),2)=$p(return,$c(1),2)_$c(2)_..BuildICUBase(objRep,IcuStr)        //ICU病人基本情况
		Set $p(return,$c(1),3)=$p(return,$c(1),3)_$c(2)_..BuildBaseDiagnose(objRep)    //ICU的疾病诊断
		//Set $p(return,$c(1),2)=$p(return,$c(1),2)_$c(2)_..BuildBaseDiagnose(objRep)
		//Set $p(return,$c(1),3)=$p(return,$c(1),3)_$c(2)_""
		Set $p(return,$c(1),4)=$p(return,$c(1),4)_$c(2)_..BuildICUPICC(objRep)        //中心静脉插管情况
		Set $p(return,$c(1),5)=$p(return,$c(1),5)_$c(2)_..BuildICUVAP(objRep)         //呼吸机使用情况
		Set $p(return,$c(1),6)=$p(return,$c(1),6)_$c(2)_..BuildICUUC(objRep)          //导尿管使用情况
		;b ;1
		//如果院感报告有手术，同时导入手术切口调查报告
		/*If $p(return,$c(1),3)'="" {
			Set BaseInfo=$p(return,$c(1),1)
			If RepType="4" {  //4手术切口调查表
				Set $p(BaseInfo,..#FieldSeperator,28)=1
			} Else {
				Set arrOpsRep=##class(DHCHAI.MK.INFReport).GetINFRepListByAdm(DPPaadmDr,"4")  //4手术切口调查表
				If arrOpsRep.Count()>0 {
					Set $p(BaseInfo,..#FieldSeperator,28)=1  //是否做手术切口调查标志
				}
			}
			Set $p(return,$c(1),1)=BaseInfo
			
			Set RepDate=$p(BaseInfo,..#FieldSeperator,1)
			Set OperInfo=$p(return,$c(1),3)
			If ($p(OperInfo,..#FieldSeperator,11)="1") {
				Set $p(OperInfo,..#FieldSeperator,12)=RepDate
				Set $p(return,$c(1),3)=OperInfo
			}
		}*/
		Set tmpCnt=tmpCnt-1
	}
	Quit:return="" return
	
	//update by zf 2016-08-09
	//处理导出接口中的重复数据

	Set $p(return,$c(1),2)=..ProRepeatRecords($p(return,$c(1),2),$c(2))
	Set $p(return,$c(1),3)=..ProRepeatRecords($p(return,$c(1),3),$c(2))
	Set $p(return,$c(1),4)=..ProRepeatRecords($p(return,$c(1),4),$c(2))
	Set $p(return,$c(1),5)=..ProRepeatRecords($p(return,$c(1),5),$c(2))
	Set $p(return,$c(1),6)=..ProRepeatRecords($p(return,$c(1),6),$c(2))
	Quit return
}

ClassMethod BuildBaseInfo(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	Set arryPos=objRep.GetInfPos(objRep.ReportID)
	//w arryPos.Count(),!
	;b ;1
	If arryPos.Count()>0 {
		Set objPos=arryPos.GetAt(1)
	} Else {
		Set objPos=##class(DHCHAI.MK.INFReportInfPos).%New()
		Do objPos.%Close()
	}
	
	Set objSumm=objRep.GetReportSumm(objRep.ReportID)
	Quit:'$IsObject(objSumm) ret

	Set OperDate=""
	Set arry=objRep.GetOperations(objRep.ReportID)
	Set Cnt=arry.Count()
	For ind=1:1:Cnt {
		Set objOpe=arry.GetAt(ind)
		Continue:'$IsObject(objOpe)
		Continue:objOpe.OperationDesc=""
		//*手术开始时间
		Set OperDate=objOpe.OperStartDate
	}
	//*调查表时间（发生院内感染的时间）
	Set $p(ret,..#FieldSeperator,1)=objPos.InfDate
	
	//*感染科别
	Set objDic=objPos.InfLoc
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,2)=..GetMapping("MKLocation",objDic.Code,objDic.Desc,objDic.Desc)
	} Else {
		Set objDic=objRep.ReportLoc
		Set $p(ret,..#FieldSeperator,2)=..GetMapping("MKLocation",objDic.Code,objDic.Desc,objDic.Desc)
	}

	//院内科别
	//Set objDic=objRep.ReportLoc
	Set objDic=objPos.InfLoc
	If $IsObject(objDic) {
		//Set $p(ret,..#FieldSeperator,3)=..GetMapping("MKHospLoc",objDic.Code,objDic.Desc,objDic.Desc)
	    //Set $p(ret,..#FieldSeperator,3)=..GetMapping("MKLocation",objDic.Code,objDic.Desc,objDic.Desc)
	    Set $p(ret,..#FieldSeperator,3)=objDic.Desc
	} Else {
		Set $p(ret,..#FieldSeperator,3)=""
	}
		//按院感科要求 安贞医院病案号应该显示 登记号
	Set DPEpisodeID=objRep.EpisodeID
	Set objPaadm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(DPEpisodeID)
	set PADischDate=objPaadm.PADischDate
	if PADischDate'="" {
	   //*调查表登记日期
	   set PADischDate=$zd(PADischDate,3)
	   Set $p(ret,..#FieldSeperator,4)=PADischDate
	}else{
	   Set $p(ret,..#FieldSeperator,4)=objRep.ReportDate
	}
	b ;1
	//*调查者
	Set $p(ret,..#FieldSeperator,5)=objRep.ReportUser.Desc
	//*病历号
	//Set:MrNo="" MrNo=objPatient.InPatientMrNo
	Set MrNo=objPaadm.PAMrNo        //如果病历号错误，用登记号代替
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
		Set $p(ret,..#FieldSeperator,7)=$p(ret,..#FieldSeperator,7)
	}
	//*姓名
	Set $p(ret,..#FieldSeperator,8)=objPaadm.PAPatName
	//*性别
	Set Sex=objPaadm.PASex
	If (Sex="F") { //M男、F女、O其他
		Set Sex="女"
	} ElseIf (Sex="M") {
		Set Sex="男"
	} Else {
		Set Sex="男"
	}
	Set $p(ret,..#FieldSeperator,9)=Sex
	//*年龄
	Set PatAge=objPaadm.PAAge
	Set:+PatAge<1 PatAge=1
	Set $p(ret,..#FieldSeperator,10)=PatAge
	//床位号
	Set objAdmBed=objPaadm.PAAdmBedDr
	Set AdmBedNo=""
	If ($IsObject(objAdmBed)) {
		Set Bed=objAdmBed.BTDesc
		Set:Bed["床" AdmBedNo=$p(Bed,"床",1)
	}
	Set $p(ret,..#FieldSeperator,11)=AdmBedNo
	//*入院日期
	Set AdmData=objPaadm.PAAdmDate
	Set:AdmData'="" AdmData=$zd(AdmData,3)
	Set $p(ret,..#FieldSeperator,12)=AdmData
	//出院日期
	Set DisDate=objPaadm.PADischDate
	Set:DisDate'="" DisDate=$zd(DisDate,3)
	Set $p(ret,..#FieldSeperator,13)=DisDate
	//医院感染
	Set $p(ret,..#FieldSeperator,14)=0
	If objRep.ReportType.Code="1" {
		Set $p(ret,..#FieldSeperator,14)=1 //医院感染
	}
	//漏报病人
	Set $p(ret,..#FieldSeperator,15)=0
	//调查方式
	Set $p(ret,..#FieldSeperator,16)=2
	//ICU检测(是否ICU目标性监测)
	Set $p(ret,..#FieldSeperator,17)=0
	//*疾病转归
	Set objDic=objPos.InfEndResult
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,18)=..GetMapping("MKDiseasePrognosis",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,18)=2
	}
	Set:$p(ret,..#FieldSeperator,18)="" $p(ret,..#FieldSeperator,18)=2
	//与死亡关系
	Set objDic=objPos.InfDeathRelation
	;b ;1
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,19)=..GetMapping("MKDeathRelation",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,19)=0
	}
	Set:$p(ret,..#FieldSeperator,19)="" $p(ret,..#FieldSeperator,19)=0
	//Set $p(ret,..#FieldSeperator,19)=0
	//感染性疾病病程
	Set DiseaseCourse=objPos.DiseaseCourse
	Set:$l(DiseaseCourse)>254 DiseaseCourse=$e(DiseaseCourse,1,254)
	//set DiseaseCourse=$tr(DiseaseCourse,"-","")
	//set DiseaseCourse="患者TACE术后发热，Tmax39.1℃，自觉发热，无畏寒寒战等，未处理自行降至正常。查体：神清，精神可。心肺（-），腹软无压痛，肝区叩痛阳性，双下肢不肿。孙巍副主任医师看病人，患者肝肿瘤介入术后，反复高热，查体新增肝区叩痛阳性体征，复查感染指标提示中性粒细胞升高，CRP、PCT升高，考虑合并肝内感染，继续头孢美唑抗感染治疗。"
	//w $l(DiseaseCourse)
	//set ^tempzsztest("ndy111111",23)=DiseaseCourse
	set DiseaseCourse=$tr(DiseaseCourse,$c(10),"")
	//set DiseaseCourse=$tr(DiseaseCourse," ","")
	//set ^tempzsztest("ndy111111",23)=DiseaseCourse
	Set $p(ret,..#FieldSeperator,20)=DiseaseCourse
	//Set $p(ret,..#FieldSeperator,20)=""
	//感染疾病诊断依据
	Set DiagnosisBasis=objPos.DiagnosisBasis
	;b ;1
	Set:$l(DiagnosisBasis)>254 DiagnosisBasis=$e(DiagnosisBasis,1,254)
	Set $p(ret,..#FieldSeperator,21)=DiagnosisBasis
	//Set $p(ret,..#FieldSeperator,21)=""
	//是否入住ICU
	Set objDic=objSumm.ICUBoolean
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,22)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,22)=0
	}
	//Set $p(ret,..#FieldSeperator,22)=0
	//手术（是否）
	Set objDic=objSumm.OprBoolean
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,23)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,23)=0
	}
	//Set $p(ret,..#FieldSeperator,23)=0
	//病原学监测（是否）
	Set objDic=objSumm.LabBoolean
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,24)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,24)=0
	}
	//Set $p(ret,..#FieldSeperator,24)=0
	//使用抗生素使用（是否）
	Set objDic=objSumm.AntiBoolean
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,25)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,25)=0
	}
	//Set $p(ret,..#FieldSeperator,25)=0
	//不良反应（是否）
	Set objDic=objSumm.AdverseReaction
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,26)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,26)=0
	}
	//Set $p(ret,..#FieldSeperator,26)=0
	//二重感染（是否）
	Set objDic=objSumm.Superinfection
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,27)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,27)=0
	}
	//Set $p(ret,..#FieldSeperator,27)=0
	//手术检测(是否手术切口目标性监测)
	Set $p(ret,..#FieldSeperator,28)=""
	//随访
	Set $p(ret,..#FieldSeperator,29)=0
	//电话随访
	Set $p(ret,..#FieldSeperator,30)=0
	//信函调查
	Set $p(ret,..#FieldSeperator,31)=0
	//短信随访
	Set $p(ret,..#FieldSeperator,32)=0
	//门诊随访
	Set $p(ret,..#FieldSeperator,33)=0
	//家庭随访
	Set $p(ret,..#FieldSeperator,34)=0
	//其他随访
	Set $p(ret,..#FieldSeperator,35)=0
	//其他随访描述
	Set $p(ret,..#FieldSeperator,36)=""
	
	Quit ret
}

/// 基本诊断
ClassMethod BuildBaseDiagnose(objRep As DHCHAI.MK.INFReport) As %String
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
		//w 
		//基础疾病
		Set ICD10=objDia.DiagnosICD
		//w objDia.DiagnosDesc_"^"_objDia.DiagnosICD_"^"_..GetMapping("MKDiagnos",objDia.DiagnosDesc,ICD10,ICD10),!
		//w ..GetMapping("MKDiagnos",objDia.DiagnosDesc,ICD10,ICD10),!
		//Set ret=ret_..GetMapping("MKDiagnos",objDia.DiagnosDesc,ICD10,ICD10)
		//set mret=..GetMapping("MKDiagnos",objDia.DiagnosDesc,ICD10,"")
		//Continue:mret=""
		//w objDia.DiagnosDesc_"^"_ICD10,!
		set ret=ret_..GetMapping("MKDiagnos",objDia.DiagnosDesc,ICD10,"")
		//w ret,!
		//w objDia.DiagnosDesc_"^"_ICD10_"^"_ret,!
	}
	//w ret_"^"_111,!
	Quit ret
}

/*
/// 基本诊断
ClassMethod BuildBaseDiagnose(objRep As DHCHAI.MK.INFReport) As %String
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
*/
/// 手术信息
ClassMethod BuildOperation(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	Set arrInfPos=objRep.GetInfPos(objRep.ReportID)
	Set objInfPos=""
	If (arrInfPos.Count()>0) {
		Set objInfPos=arrInfPos.GetAt(1)
	}
	
	Set arry=objRep.GetOperations(objRep.ReportID)
	Set Cnt=arry.Count()
	For ind=1:1:Cnt {
		Set objOpe=arry.GetAt(ind)
		Continue:'$IsObject(objOpe)
		Continue:objOpe.OperationDesc=""
		;b ;1
		Set:ret'="" ret=ret_$c(2)
		
		Set tmp=""
		//*手术名称
		Set ICD10=objOpe.OperationICD
		//Set $p(tmp,..#FieldSeperator,1)=..GetMapping("MKOperation",objOpe.OperationDesc,ICD10,ICD10)
		set DZicd=""
		set DZicd=..GetMapping("MKOperation",objOpe.OperationDesc,ICD10,"")
		Continue:DZicd=""
		Set $p(tmp,..#FieldSeperator,1)=..GetMapping("MKOperation",$replace(objOpe.OperationDesc,",",""),ICD10,"")
		//b ;1111
		//*急诊手术
		Set objDic=objOpe.OperationType
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,2)=..GetMapping("MKOperationType",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,2)=0
		}
		//*手术开始时间
		Set $p(tmp,..#FieldSeperator,3)=objOpe.OperStartDate_" "_objOpe.OperStartTime
		//*手术结束时间
		Set $p(tmp,..#FieldSeperator,4)=objOpe.OperEndDate_" "_objOpe.OperEndTime
		//手术医生
		Set objDic=objOpe.OperDoc
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,5)=objDic.Desc
		} Else {
			Set $p(tmp,..#FieldSeperator,5)=""
		}
		//*麻醉方式 Anesthesia
		Set objDic=objOpe.Anesthesia
		//if objDic="" w 1,!
		//w objOpe.Anesthesia.Code_"^"_objOpe.Anesthesia.Desc,!
		If $IsObject(objDic) {
			//b ;111
			//w ..GetMapping("MKAnesthesia",objDic.Code,objDic.Desc,objDic.Code),!
			Set $p(tmp,..#FieldSeperator,6)=..GetMapping("MKAnesthesia",objDic.Code,objDic.Desc,objDic.Code)
		    if (objDic.Code="")||(objDic.Desc="") {
			    set $p(tmp,..#FieldSeperator,6)=0
			    }
		} Else {
			Set $p(tmp,..#FieldSeperator,6)=0
		}
		
		//*切口类型
		Set objDic=objOpe.CuteType
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,7)=..GetMapping("MKCuteType",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,7)=0
		}
		//愈合情况
		Set objDic=objOpe.CuteHealing
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,8)=..GetMapping("MKCuteHealing",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,8)=""
		}
		//*切口感染
		Set objDic=objOpe.InHospInfFlag
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,9)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,9)=0
		}
		//手术部位感染类型
		Set objDic=objOpe.OperInfType
		//b ;111222
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,10)=..GetMapping("MKOperInfType",objDic.Code,objDic.Desc,objDic.Desc)
		} Else {
			Set $p(tmp,..#FieldSeperator,10)=""
		}
		//引起院内感染
		Set InHospInfFlag=""
		Set objDic=objOpe.InHospInfFlag
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,11)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,11)=""
		}
		Set InHospInfFlag=$p(tmp,..#FieldSeperator,11)
		
		//感染日期
		If (InHospInfFlag=1) {
			If $IsObject(objInfPos) {
				Set $p(tmp,..#FieldSeperator,12)=objInfPos.InfDate
			} Else {
				Set $p(tmp,..#FieldSeperator,12)=objOpe.OperStartDate
			}			
		} Else {
			Set $p(tmp,..#FieldSeperator,12)=""
		}
		
		//切口个数
		//Set $p(tmp,..#FieldSeperator,13)=+objOpe.CuteNumber
		Set CuteNumber=+objOpe.CuteNumber
		Set:CuteNumber=0 CuteNumber=1
		Set $p(tmp,..#FieldSeperator,13)=CuteNumber
		/*
		Set objDic=objOpe.CuteNumber
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,13)=..GetMapping("MKCuteNumber",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,13)=""
		}
		*/
		//*ASA评分
		Set objDic=objOpe.ASAScore
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,14)=..GetMapping("MKASAScore",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,14)=1
		}
		//术前外周白细胞数
		Set $p(tmp,..#FieldSeperator,15)=+objOpe.PreoperWBC
		//使用窥镜
		Set objDic=objOpe.EndoscopeFlag
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,16)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,16)=""
		}
		//植入物
		Set objDic=objOpe.ImplantFlag
		If $IsObject(objDic) {
			//Set $p(tmp,..#FieldSeperator,17)=""
			Set $p(tmp,..#FieldSeperator,17)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,17)=""
			//Set $p(tmp,..#FieldSeperator,17)=..GetMapping("MKImplantFlag",objDic.Code,objDic.Desc,objDic.Code)
		}
		//术前口服抗生素肠道准备
		Set objDic=objOpe.PreoperAntiFlag
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,18)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,18)=""
		}
		//失血
		Set objDic=objOpe.BloodLossFlag
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,19)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,19)=""
		}
		//失血量
		Set $p(tmp,..#FieldSeperator,20)=+objOpe.BloodLoss
		//输血
		Set objDic=objOpe.BloodTransFlag
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,21)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,21)=""
		}
		//输血量
		Set $p(tmp,..#FieldSeperator,22)=+objOpe.BloodTrans
		
		If (+objOpe.BloodIsOperCut=1) {
			Set OperCutFlag=1
		}
		Set ret=ret_tmp
	}
		
	Quit ret
}

/// 易感因素
ClassMethod BuildInfFactors(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	Set objSumm=objRep.GetReportSumm(objRep.ReportID)
	Quit:'$IsObject(objSumm) ret
	
	Set Cnt=objSumm.InfFactors.Count()
	For i=1:1:Cnt {
		Set obj=objSumm.InfFactors.GetAt(i)
		Continue:'$IsObject(obj)
		
		Set:ret'="" ret=ret_$c(2)
		
		//易感因素
		Set ret=ret_..GetMapping("MKInfFactors",obj.Code,obj.Desc,obj.Desc)
	}
	
	Quit ret
}

/// 侵害性操作
ClassMethod BuildInvasiveOpers(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	Set objSumm=objRep.GetReportSumm(objRep.ReportID)
	Quit:'$IsObject(objSumm) ret
	
	Set Cnt=objSumm.InvasiveOperation.Count()
	For i=1:1:Cnt {
		Set obj=objSumm.InvasiveOperation.GetAt(i)
		Continue:'$IsObject(obj)
		
		Set:ret'="" ret=ret_$c(2)
		
		//侵害性操作
		Set ret=ret_..GetMapping("MKInvasiveOpers",obj.Code,obj.Desc,obj.Desc)
	}
	Quit ret
}

/// 感染部位1
ClassMethod BuildInfPos(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	Set arry=objRep.GetInfPos(objRep.ReportID)
	Set Cnt=arry.Count()
	For i=1:1:Cnt {
		Set objPos=arry.GetAt(i)
		Continue:'$IsObject(objPos)
		
		Set:ret'="" ret=ret_$c(2)
		;b ;123
		Set tmp=""
		//*感染部位
		//add by zsz 2020-01-10
		//Set $p(tmp,..#FieldSeperator,1)=..GetMapping("MKInfPos",objPos.InfPos.Code,objPos.InfPos.Desc,objPos.InfPos.Desc)
		Set $p(tmp,..#FieldSeperator,1)=..GetMapping("MKInfPos",objPos.InfPos.Desc,objPos.InfPos.Desc,objPos.InfPos.Desc)
		//*感染日期
		Set $p(tmp,..#FieldSeperator,2)=objPos.InfDate
		//*感染诊断
		//add by zsz 2020-01-10
		//Set $p(tmp,..#FieldSeperator,3)=..GetMapping("MKInfDiag",objPos.InfDiag.Code,objPos.InfDiag.Desc,objPos.InfDiag.Desc)
		Set $p(tmp,..#FieldSeperator,3)=..GetMapping("MKInfDiag",objPos.InfDiag.Desc,objPos.InfDiag.Desc,objPos.InfDiag.Desc)
		
		Set ret=ret_tmp
	}
	
	Quit ret
}

/// 感染部位2
ClassMethod BuildInfPos2(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	Set objSumm=objRep.GetReportSumm(objRep.ReportID)
	//Quit:'$IsObject(objSumm) ret

	Set arry=objRep.GetInfPos(objRep.ReportID)
	
	Set Cnt=objSumm.InvasiveOperation.Count()
	Set Cnt=arry.Count()
	For i=1:1:Cnt {
		Set objPos=arry.GetAt(i)
		
		Set obj=objSumm.InvasiveOperation.GetAt(i)
		
		Continue:'$IsObject(objPos)
		
		Set:ret'="" ret=ret_$c(2)
		;b ;123
		Set tmp=""
		//*感染部位
		//add by zsz 2020-01-10
		//Set $p(tmp,..#FieldSeperator,1)=..GetMapping("MKInfPos",objPos.InfPos.Code,objPos.InfPos.Desc,objPos.InfPos.Desc)
		Set $p(tmp,..#FieldSeperator,1)=..GetMapping("MKInfPos",objPos.InfPos.Desc,objPos.InfPos.Desc,objPos.InfPos.Desc)
		//*感染日期
		Set $p(tmp,..#FieldSeperator,2)=objPos.InfDate
		//*侵害性操作 InfPosOpr
		//add by zsz 2020-01-10
		//Set $p(tmp,..#FieldSeperator,3)=..GetMapping("MKInfDiag",objPos.InfDiag.Code,objPos.InfDiag.Desc,objPos.InfDiag.Desc)
		//Set:$Isobject(objPos.InfPosOpr) $p(tmp,..#FieldSeperator,3)=..GetMapping("MKInvasiveOpers",objPos.InfPosOpr.Code,objPos.InfPosOpr.Desc,objPos.InfPosOpr.Desc)
		
		Set ret=ret_tmp
		//Set ret=ret
	}
	
	Quit ret
}

/// 病原学检测1
ClassMethod BuildLabResult(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	Set arryPos=objRep.GetInfPos(objRep.ReportID)
	Set objPos=arryPos.GetAt(1)
	
	Set:'$IsObject(objPos) objPos=##class(DHCHAI.MK.INFReportInfPos).%New()
	Do objPos.%Close()
	
	Set arry=objRep.GetLabResults(objRep.ReportID)
	Set Cnt=arry.Count()
	For i=1:1:Cnt {
		Set objLab=arry.GetAt(i)
		Continue:'$IsObject(objLab)
		
		Set:ret'="" ret=ret_$c(2)
		
		Set tmp=""
		//*标本
		Set objDic=objLab.Specimen
		;b ;1111
		;w objDic.Code_"^"_objDic.Desc,!
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,1)=..GetMapping("MKSpecimen",objDic.Code,objDic.Desc,objDic.Desc)
		} Else {
			Set $p(tmp,..#FieldSeperator,1)=""
		}
		//*感染部位
		Set objDic=objPos.InfPos
		If $IsObject(objDic) {
			//add by zsz 20200110
			//Set $p(tmp,..#FieldSeperator,2)=..GetMapping("MKInfPos",objDic.Code,objDic.Desc,objDic.Desc)
			Set $p(tmp,..#FieldSeperator,2)=..GetMapping("MKInfPos",objDic.Desc,objDic.Desc,objDic.Desc)
		} Else {
			Set $p(tmp,..#FieldSeperator,2)=""
		}
		//*送检日期
		Set $p(tmp,..#FieldSeperator,3)=objLab.SubmissionDate
		//*检验方法
		Set objDic=objLab.AssayMethod
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,4)=..GetMapping("MKAssayMethod",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,4)=""
		}
		//白细胞数
		Set $p(tmp,..#FieldSeperator,5)=0
		//报警时间
		Set $p(tmp,..#FieldSeperator,6)=0
		//病原学检验结果
		Set objDic=objLab.PathogenTest
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,7)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,7)=0
		}
		
		Set ret=ret_tmp
	}
	Quit ret
}

/// 病原学检测2  病原菌监测结果
ClassMethod BuildLabResultsPY(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	Set arry=objRep.GetLabResults(objRep.ReportID)
	Set Cnt=arry.Count()
	For i=1:1:Cnt {
		Set objLab=arry.GetAt(i)
		Continue:'$IsObject(objLab)
		
		Set Cnt1=objLab.TestResults.Count()
		For j=1:1:Cnt1 {
			Set objPy=objLab.TestResults.GetAt(j)
			Continue:'$IsObject(objPy)
			
			Set Pathogeny=..GetMapping("MKPathogeny",objPy.PathogenyDesc,objPy.PathogenyDesc,objPy.PathogenyDesc)
			Continue:Pathogeny=""
			
			Set:ret'="" ret=ret_$c(2)
			
			Set tmp=""
			//*标本
			Set objDic=objLab.Specimen
			If $IsObject(objDic) {
				Set $p(tmp,..#FieldSeperator,1)=..GetMapping("MKSpecimen",objDic.Code,objDic.Desc,objDic.Desc)
			} Else {
				Set $p(tmp,..#FieldSeperator,1)=""
			}
			//*送检日期
			Set $p(tmp,..#FieldSeperator,2)=objLab.SubmissionDate
			//*病原体
			set BYTname=""
			set BYTname=..GetMapping("MKPathogeny",objPy.PathogenyDesc,objPy.PathogenyDesc,"")
			Continue:BYTname=""
			Set $p(tmp,..#FieldSeperator,3)=..GetMapping("MKPathogeny",objPy.PathogenyDesc,objPy.PathogenyDesc,objPy.PathogenyDesc)
			//*药敏结果
			Set $p(tmp,..#FieldSeperator,4)=0
			Set:objPy.DrugSenTest.Count()>0 $p(tmp,..#FieldSeperator,4)=1
			
			Set ret=ret_tmp
		}
	}
	Quit ret
}

/// 病原学检测3  药敏试验结果
ClassMethod BuildLabResultsDrug(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	Set arry=objRep.GetLabResults(objRep.ReportID)
	Set Cnt=arry.Count()
	For i=1:1:Cnt {
		Set objLab=arry.GetAt(i)
		Continue:'$IsObject(objLab)
		
		Set Cnt1=objLab.TestResults.Count()
		For j=1:1:Cnt1 {
			Set objPy=objLab.TestResults.GetAt(j)
			Continue:'$IsObject(objPy)
			
			Set tmpAntiList=""
			Set Cnt2=objPy.DrugSenTest.Count()
			For k=1:1:Cnt2 {
				Set objSen=objPy.DrugSenTest.GetAt(k)
				Continue:'$IsObject(objSen)
				
				Set Pathogeny=..GetMapping("MKPathogeny",objPy.PathogenyDesc,objPy.PathogenyDesc,objPy.PathogenyDesc)
				Continue:Pathogeny=""
				Set Antibiotics=..GetMapping("MKAntibiotics",objSen.AntibioticsDesc,objSen.AntibioticsDesc,objSen.AntibioticsDesc)
				Continue:Antibiotics=""
				
				Set:ret'="" ret=ret_$c(2)
				
				Set tmp=""
				//*标本
				Set objDic=objLab.Specimen
				If $IsObject(objDic) {
					Set $p(tmp,..#FieldSeperator,1)=..GetMapping("MKSpecimen",objDic.Code,objDic.Desc,objDic.Desc)
				} Else {
					Set $p(tmp,..#FieldSeperator,1)=""
				}
				//*送检日期
				Set $p(tmp,..#FieldSeperator,2)=objLab.SubmissionDate
				//*病原体
				Set $p(tmp,..#FieldSeperator,3)=..GetMapping("MKPathogeny",objPy.PathogenyDesc,objPy.PathogenyDesc,objPy.PathogenyDesc)
				//*抗菌药物名称
				set KSSymname=""
				set KSSymname=..GetMapping("MKAntibiotics",objSen.AntibioticsDesc,objSen.AntibioticsDesc,"")
				Continue:KSSymname=""
				Set tmpAntiName=..GetMapping("MKAntibiotics",objSen.AntibioticsDesc,objSen.AntibioticsDesc,objSen.AntibioticsDesc)
				Continue:$listfind(tmpAntiList,tmpAntiName)>0
				Set $p(tmp,..#FieldSeperator,4)=tmpAntiName
				Set tmpAntiList=tmpAntiList_$lb(tmpAntiName)
				//*敏感
				Set objDic=objSen.SenTestRst
				If $IsObject(objDic) {
					Set $p(tmp,..#FieldSeperator,5)=..GetMapping("MKSenTestRst",objDic.Code,objDic.Desc,objDic.Code)
				} Else {
					Set $p(tmp,..#FieldSeperator,5)=""
				}
				
				Set ret=ret_tmp
			}
		}
	}
	Quit ret
}

/// 抗菌药物使用情况
ClassMethod BuildAnti(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	Set arry=objRep.GetAnti(objRep.ReportID)
	Quit:arry.Count()=0 ret
	Do arry.%Close()
	Set Cnt=arry.Count()
	For i=1:1:Cnt {
		Set objAnti=arry.GetAt(i)
		Continue:'$IsObject(objAnti)
		//Continue:objAnti.ArcimID=""
		
		Set:ret'="" ret=ret_$c(2)
		
		Set tmp=""
		//*抗菌药物
		set KSSname=""
		set KSSname=..GetMapping("MKOEAntibiotics",objAnti.ArcimDesc,objAnti.ArcimID,"")
		Continue:KSSname=""
		Set $p(tmp,..#FieldSeperator,1)=..GetMapping("MKOEAntibiotics",objAnti.ArcimDesc,objAnti.ArcimID,objAnti.ArcimDesc)
		
		//*给药途径
		Set objDic=objAnti.AdminRoute
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,2)=..GetMapping("MKAdminRoute",objDic.Code,objDic.Desc,objDic.Desc)
		} Else {
			Set $p(tmp,..#FieldSeperator,2)=0
		}
		//*用药起始时间
		Set $p(tmp,..#FieldSeperator,3)=objAnti.StartDate_" "_objAnti.StartTime
		//用药截至时间
		Set $p(tmp,..#FieldSeperator,4)=objAnti.EndDate_" "_objAnti.EndTime
		//*目的
		Set objDic=objAnti.MedPurpose
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,5)=..GetMapping("MKMedPurpose",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,5)=0
		}
		//治疗用药方式
		Set objDic=objAnti.TreatmentMode
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,6)=..GetMapping("MKTreatmentMode",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,6)=""
		}
		//预防用药指征
		Set $p(tmp,..#FieldSeperator,7)=0
		/*
		Set objDic=objAnti.PreMedIndicat
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,7)=..GetMapping("MKPreMedIndicat",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,7)=""
		}
		*/
		//预防用药效果
		Set $p(tmp,..#FieldSeperator,8)=0
		/*
		Set objDic=objAnti.PreMedEffect
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,8)=..GetMapping("MKPreMedEffect",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,8)=1
		}
		*/
		//*联合用药
		Set objDic=objAnti.CombinedMed
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,9)=..GetMapping("MKCombinedMed",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,9)=1
		}
		//围术期用药
		Set $p(tmp,..#FieldSeperator,10)=0
		//术前用药时间
		If objAnti.PreMedTime'="" {
			Set $p(tmp,..#FieldSeperator,11)=(objAnti.PreMedTime\60)_"小时"_(objAnti.PreMedTime-(objAnti.PreMedTime\60*60))_"分"
		} Else {
			Set $p(tmp,..#FieldSeperator,11)=""
		}
		//术后用药天数
		If objAnti.PostMedDays'="" {
			Set $p(tmp,..#FieldSeperator,12)=+objAnti.PostMedDays
		} Else {
			Set $p(tmp,..#FieldSeperator,12)=""
		}
		//合理性
		Set $p(tmp,..#FieldSeperator,13)=2
		//不合理原因
		Set $p(tmp,..#FieldSeperator,14)=""
		//疗效
		Set $p(tmp,..#FieldSeperator,15)=""
		set $p(tmp,..#FieldSeperator,16)=objAnti.DoseQty
		set $p(tmp,..#FieldSeperator,17)=""     //objAnti.PhcFreq //民科频次
		set $p(tmp,..#FieldSeperator,18)=objAnti.DoseUnit
		Set ret=ret_tmp
	}
	
	Quit ret
}

/// w ##class(DHCHAI.MK.ExportToMKSrv).GetMapping("MKDiagnos","慢性肾功能不全","N18.905","")
/// 取对照民科字典值，取之为空返回默认值
ClassMethod GetMapping(aMappingType As %String, aSrcValue As %String, aSrcDesc As %String, aDefaultValue As %String = "") As %String
{
	New (aMappingType,aSrcValue,aSrcDesc,aDefaultValue)
	Set return=""
	Quit:(aMappingType="")||(aSrcValue="") return
	
	//存储数据时，把空格都替换掉了
	Set aSrcValue=$tr(aSrcValue," ","")
	Set objDic=##class(DHCHAI.MK.BTMapItem).GetByTypeCode("INFMinkeMappingType",aMappingType,"")
	Quit:'$IsObject(objDic) return
	Set TargetField=objDic.StrC
	Set:TargetField="" TargetField="Target"
	;b ;111
	Set aSrcValue=##Class(DHCHAI.MK.BTMappingSrv).Trim(aSrcValue)  //处理前后空格
	;b ;2
	//w aMappingType_"^"_aSrcValue,!
	Set objMap=##class(DHCHAI.MK.BTMapData).GetMappingData(aMappingType,aSrcValue)
	;b ;3
	If $IsObject(objMap){
		If TargetField="Target" {
			Set return=objMap.Target               //取目标值
		} ElseIf TargetField="TargetDesc" {
			Set return=objMap.TargetDesc           //取目标值描述
		} ElseIf TargetField="SrcObjectID" {
			Set return=objMap.SrcObjectID          //取源值
		} ElseIf TargetField="SrcDescription" {
			Set return=objMap.SrcDescription       //取源值描述
		} Else {}
	}
	;b ;1112
	//w return_"^"_1 ,!
	If return="空" {
		Set return=""
	} Else {
		Set:return="" return=aDefaultValue             //默认值
	}
	//w return_"^"_2 ,!
	Quit return
}

ClassMethod GetMinkeDic(MainCode As %String, Code As %String, Desc As %String) As DHCHAI.MK.BTDictionary
{
	New (MainCode,Code,Desc)
	Set ret=""
	Quit:MainCode="" ret
	
	Set RowID=""
	For {
		Set RowID=$o(^DHCHAI.MK.BTDictionaryI("IndexCode"," "_$ZConvert(Code,"U"),RowID))
		Quit:RowID=""
		Quit:ret'=""
		
		Set obj=##class(DHCHAI.MK.BTDictionary).GetObjById(RowID)
		Continue:'$IsObject(obj)
		Continue:obj.IDCode'[MainCode
		
		Set ret=obj
	}
	If '$IsObject(ret) {
		Set RowID=""
		For {
			Set RowID=$o(^DHCHAI.MK.BTDictionaryI("IndexDesc"," "_$ZConvert(Desc,"U"),RowID))
			Quit:RowID=""
			Quit:ret'=""
			
			Set obj=##class(DHCHAI.MK.BTDictionary).GetObjById(RowID)
			Continue:'$IsObject(obj)
			Continue:obj.IDCode'[MainCode
			
			Set ret=obj
		}
	}
	Quit ret
}

/// w ##class(DHCHAI.MK.ExportToMKSrv).ValidateReport(71)
ClassMethod ValidateReport(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	
	Set objRep=##class(DHCHAI.MK.INFReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	
	Set ErrorList=""
	Set tmp=..CheckReport(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
	//w ErrorList,!
	Set tmp=..CheckReportDiag(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
    
	Set tmp=..CheckReportInfPos(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
    //w ErrorList,!
	Set tmp=..CheckReportOper(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
    
	Set tmp=..CheckReportLab(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
	//w ErrorList,!
	Set tmp=..CheckReportAnti(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
	
	Set:ErrorList'="" return=$e(ErrorList,1,$l(ErrorList)-1)
	Set:ErrorList="" return="OK"
	
	Quit return
}

/// 完成
ClassMethod CheckReport(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	
	//报告科室
	Set tmp=..IsMapping(objRep.ReportLoc.Code,objRep.ReportLoc.Desc,"MKLocation","报告科室无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	//Set tmp=..IsMapping(objRep.ReportLoc.Code,objRep.ReportLoc.Desc,"MKHospLoc","报告科室无法对照")
	//Set:tmp'="OK" ret=ret_tmp_$c(2)
	
	Set infPosList=objRep.GetInfPos(objRep.ReportID)
	Set objInfPos=infPosList.GetAt(1)
	
	If $IsObject(objInfPos) {
		//感染科室
		Set tmp=..IsMapping(objInfPos.InfLoc.Code,objInfPos.InfLoc.Desc,"MKLocation","感染科室无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		//Set tmp=..IsMapping(objInfPos.InfLoc.Code,objInfPos.InfLoc.Desc,"MKHospLoc","感染科室无法对照")
		//Set:tmp'="OK" ret=ret_tmp_$c(2)
		
		//疾病转归
		Set tmp=..IsMapping(objInfPos.InfEndResult.Code,objInfPos.InfEndResult.Desc,"MKInfEndResult","疾病转归无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		//与死亡关系
		Set tmp=..IsMapping(objInfPos.InfDeathRelation.Code,objInfPos.InfDeathRelation.Desc,"MKInfDeathRelation","与死亡关系无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
	}
	
	//易感因素
	Set objSumm=objRep.GetReportSumm(objRep.ReportID)
	
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
		
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	
	Quit ret
}

ClassMethod CheckReportDiag(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	
	Set arryDia=objRep.GetDiagnos(objRep.ReportID)
	Set Cnt=arryDia.Count()
	For indArr=1:1:Cnt {
		Set objDia=arryDia.GetAt(indArr)
		Continue:'$IsObject(objDia)
		Continue:objDia.DiagnosDesc=""
		Set objDia.DiagnosDesc=$tr(objDia.DiagnosDesc,$c(13),"") //add by wuqk 2014-03-06
		
		Set tmp=..IsMapping(objDia.DiagnosDesc,objDia.DiagnosICD,"MKDiagnos","疾病诊断无法对照")
		//w objDia.DiagnosDesc_"^"_objDia.DiagnosICD_"^"_tmp,!
		Set:tmp'="OK" ret=ret_tmp_$c(2)
	}
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	
	Quit ret
}

ClassMethod CheckReportInfPos(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	
	Set arry=objRep.GetInfPos(objRep.ReportID)
	Set Cnt=arry.Count()
	For indArr=1:1:Cnt {
		Set objPos=arry.GetAt(indArr)
		Continue:'$IsObject(objPos)
		//w objPos.InfPos.Desc,!
		Set tmp=..IsMapping(objPos.InfPos.Desc,objPos.InfPos.Desc,"MKInfPos","感染部位无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objPos.InfDiag.Desc,objPos.InfDiag.Desc,"MKInfDiag","感染诊断无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
	}
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	
	Quit ret
}

ClassMethod CheckReportOper(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	
	Set arry=objRep.GetOperations(objRep.ReportID)
	Set Cnt=arry.Count()
	For indArr=1:1:Cnt {
		Set objOpe=arry.GetAt(indArr)
		Continue:'$IsObject(objOpe)
		Continue:objOpe.OperationDesc=""
		
		Set tmp=..IsMapping(objOpe.OperationDesc,objOpe.OperationICD,"MKOperation","手术名称无法对照") 
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objOpe.Anesthesia.Code,objOpe.Anesthesia.Desc,"MKAnesthesia","麻醉方式无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objOpe.CuteHealing.Code,objOpe.CuteHealing.Desc,"MKCuteHealing","愈合情况无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objOpe.CuteType.Code,objOpe.CuteType.Desc,"MKCuteType","切口类型无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objOpe.OperationType.Code,objOpe.OperationType.Desc,"MKOperationType","手术类别无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objOpe.OperInfType.Code,objOpe.OperInfType.Desc,"MKOperInfType","手术部位感染类型无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objOpe.ASAScore.Code,objOpe.ASAScore.Desc,"MKASAScore","ASA评分无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objOpe.ImplantFlag.Code,objOpe.ImplantFlag.Desc,"MKImplantFlag","植入物无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
	}
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	
	Quit ret
}

ClassMethod CheckReportLab(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	
	Set arry=objRep.GetLabResults(objRep.ReportID)
	Set Cnt=arry.Count()
	For indArr=1:1:Cnt {
		Set objLab=arry.GetAt(indArr)
		Continue:'$IsObject(objLab)
		//w objLab.Specimen.Code_"^"_objLab.InfectionPos.Code,!
		//add by zsz 20200110
		//Set tmp=..IsMapping(objLab.Specimen.Desc,objLab.Specimen.Desc,"MKSpecimen","标本无法对照")
		Set tmp=..IsMapping(objLab.Specimen.Code,objLab.Specimen.Desc,"MKSpecimen","标本无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)	
		Set tmp=..IsMapping(objLab.InfectionPos.Desc,objLab.InfectionPos.Desc,"MKInfPos","感染部位无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objLab.AssayMethod.Code,objLab.AssayMethod.Desc,"MKAssayMethod","检验方法无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		
		Set Cnt1=objLab.TestResults.Count()
		For indArr1=1:1:Cnt1 {
			Set objPy=objLab.TestResults.GetAt(indArr1)
			Continue:'$IsObject(objPy)
			
			Set tmp=..IsMapping(objPy.PathogenyDesc,objPy.PathogenyID,"MKPathogeny","细菌名称无法对照")
			Set:tmp'="OK" ret=ret_tmp_$c(2)
			
			Set Cnt2=objPy.DrugSenTest.Count()
			For indArr2=1:1:Cnt2 {
				Set objSen=objPy.DrugSenTest.GetAt(indArr2)
				Continue:'$IsObject(objSen)
				
				Set tmp=..IsMapping(objSen.AntibioticsDesc,objSen.AntibioticsID,"MKAntibiotics","抗菌药物名称无法对照")
				Set:tmp'="OK" ret=ret_tmp_$c(2)
				Set tmp=..IsMapping(objSen.SenTestRst.Code,objSen.SenTestRst.Desc,"MKSenTestRst","药物敏感性无法对照")
				Set:tmp'="OK" ret=ret_tmp_$c(2)
			}
		}
	}
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	
	Quit ret
}

ClassMethod CheckReportAnti(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	
	Set arry=objRep.GetAnti(objRep.ReportID)
	Do arry.%Close()
	Set Cnt=arry.Count()
	For indArr=1:1:Cnt {
		Set objAnti=arry.GetAt(indArr)
		Continue:'$IsObject(objAnti)
		
		Set tmp=..IsMapping(objAnti.ArcimDesc,objAnti.ArcimID,"MKOEAntibiotics","抗生素医嘱无法对照")
		;b ;1
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objAnti.AdminRoute.Code,objAnti.AdminRoute.Desc,"MKAdminRoute","给药途径无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objAnti.MedPurpose.Code,objAnti.MedPurpose.Desc,"MKMedPurpose","用药目的无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objAnti.TreatmentMode.Code,objAnti.TreatmentMode.Desc,"MKTreatmentMode","治疗用药方式无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		//Set tmp=..IsMapping(objAnti.PreMedIndicat.Code,objAnti.PreMedIndicat.Desc,"MKPreMedIndicat","预防用药指征无法对照")
		//Set:tmp'="OK" ret=ret_tmp_$c(2)
		//Set tmp=..IsMapping(objAnti.PreMedEffect.Code,objAnti.PreMedEffect.Desc,"MKPreMedEffect","预防用药效果无法对照")
		//Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objAnti.CombinedMed.Code,objAnti.CombinedMed.Desc,"MKCombinedMed","联合用药无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
	}
	//w ret,!
	//b:ret'="" ;22333	
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	
	Quit ret
}

/// 判断是否已对照民科字典
/// 如果已对照，返回值 return="OK"
/// 如果未对照，返回值 return="ERROR^"_{对照字典类别}_"^"_{错误信息}_"^"_{源值}_"^"_{源值描述}
/// w ##class(DHCHAI.MK.ExportToMKSrv).IsMapping("手术部位感染","手术部位感染","MKInfPos","感染部位无法对照")
ClassMethod IsMapping(aSrcValue As %String, aSrcDesc As %String, aMappingType As %String, aErrorMsg As %String)
{
	New (aSrcValue,aSrcDesc,aMappingType,aErrorMsg)
	Set return=""
	Quit:(aMappingType="")||(aSrcValue="") return
	//w aMappingType_"^"_aSrcValue_"^"_aSrcDesc,!
	Set tmpValue=..GetMapping(aMappingType,aSrcValue,aSrcDesc)
	If tmpValue="" {
		Set return="ERROR^"_aMappingType_"^"_aErrorMsg_"^"_aSrcValue_"^"_aSrcDesc
	} Else {
		Set return="OK"
	}
	
	Quit return
}

/// add by zsz 20200514
/// 判断是否已对照民科字典
/// 如果已对照，返回值 return="OK"
/// 如果未对照，返回值 return="ERROR^"_{对照字典类别}_"^"_{错误信息}_"^"_{源值}_"^"_{源值描述}
ClassMethod IsMapping1(aSrcValue As %String, aSrcDesc As %String, aMappingType As %String, aErrorMsg As %String)
{
	New (aSrcValue,aSrcDesc,aMappingType,aErrorMsg)
	Set return=""
	Quit:(aMappingType="")||(aSrcValue="") return
	
	Set tmpValue=..GetMapping(aMappingType,aSrcValue,aSrcDesc)
	//w aMappingType_"^"_aSrcValue_"^"_aSrcDesc_"^"_tmpValue,!
	If tmpValue="" {
		Set return="ERROR^"_aMappingType_"^"_aErrorMsg_"^"_aSrcValue_"^"_aSrcDesc
	} Else {
		Set return="OK^"_aMappingType_"^"_aErrorMsg_"^"_aSrcValue_"^"_aSrcDesc
	}
	
	Quit return
}

ClassMethod IsMappingNew(aSrcValue As %String, aSrcDesc As %String, aMappingType As %String, aErrorMsg As %String) As %String
{
	
	New (aSrcValue,aSrcDesc,aMappingType,aErrorMsg)
	Set return=""
	Quit:(aMappingType="")||(aSrcValue="") return
	
	Set tmpValue=..GetMapping(aMappingType,aSrcValue,aSrcDesc) 
	If tmpValue="" {
		Set return="ERROR^"_aMappingType_"^"_aErrorMsg_"^"_aSrcValue_"^"_aSrcDesc
	} Else {
		Set return="OK"
	}
	
	Quit return
}

/// 查询医院感染报告校验信息
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.MK.ExportToMKSrv","QryValidateInfo","252","^","4")
Query QryValidateInfo(aReportList As %String, aDelimiter As %String = "^", RepType As %String = "") As %Query(ROWSPEC = "Index:%String,ID:%String,SrcValue:%String,SrcDesc:%String,TargetValue:%String,TargetDesc:%String,ResumeText:%String,MappingTypeCode:%String,MappingTypeDesc:%String,MapDicGroupCode:%String,MapDicTypeCode:%String")
{
}

ClassMethod QryValidateInfoExecute(ByRef qHandle As %Binary, aReportList As %String, aDelimiter As %String = "^", RepType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set ^tempzsztest("jjhhshdfsfkskakdsk")=$lb(aReportList, aDelimiter, RepType)
 	Set NIndex="QryValidateInfo"
 	Kill ^TMP($zn,$j,NIndex)
 	
 	For indRep=1:1:$l(aReportList,aDelimiter) {
 		Set ReportID=$p(aReportList,aDelimiter,indRep)
 		Continue:ReportID=""
 		
		Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
		Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.IRStatusDr)
		Set StatusCode=objRep.IRStatusDr.BTCode
		//Continue:(StatusCode'="3")&&(StatusCode'="2")&&(StatusCode'="1") //只导审核+提交的报告
		Continue:(StatusCode'="3")&&(StatusCode'="2")&&(StatusCode'="8")
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
 	//zw ^TMP($zn,$j)
 	Set xMappingType=""
 	For {
	 	Set xMappingType=$o(^TMP($zn,$j,NIndex,"ErrorIndex",xMappingType))
	 	Quit:xMappingType=""
	 	//w xMappingType,!
	 	Set objDic=##class(DHCHAI.MK.BTMapItem).GetByTypeCode("INFMinkeMappingType",xMappingType,"")
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
	 		//b:SrcValue["注射用头"
	 		//if ($IsObject(SrcDesc)) set SrcDesc=SrcDesc.%Id()
	 		
	 		Set SrcValue = $tr(SrcValue," ","") //
	 		//字典对照RowID
	 		Set ID=$o(^DHCHAI.MK.BTMapDataI("IndexCategorySrcID"," "_$zcvt(MappingType,"U")," "_$zcvt(SrcValue,"U"),0))
	 		if ID'=""{
		 		set targetcode=$list(^DHCHAI.MK.BTMapDataD(ID),5)
		 		set targetdesc=$list(^DHCHAI.MK.BTMapDataD(ID),7)
		 	}else{
			 	set targetcode=""
			 	set targetdesc=""
			}
	 		//对照字典类别代码,对照字典类别名称,源值,源值描述,目标值,目标值描述,备注,字典类别,序号
	 		Set Data=$lb("")
	 		Set $li(Data,1)=ind
	 		Set $li(Data,2)=ID
	 		Set $li(Data,3)=SrcValue
	 		Set $li(Data,4)=SrcDesc
	 		Set $li(Data,5)=""
	 		Set:targetcode'="" $li(Data,5)=targetcode
	 		Set $li(Data,6)=""
	 		Set:targetdesc'="" $li(Data,6)=targetdesc
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

ClassMethod ProRepeatRecords(aRecords As %String, aSeperator As %String)
{
	New (aRecords,aSeperator)
	Set return=""
	Quit:(aRecords="")||(aSeperator="") return
	
	Kill arrRecords
	For indR=1:1:$l(aRecords,aSeperator) {
		Set tRecord=$p(aRecords,aSeperator,indR)
		Continue:tRecord=""
		Continue:$d(arrRecords(tRecord))
		Set arrRecords(tRecord)=""
		If return="" {
			Set return=tRecord
		} Else {
			Set return=return_aSeperator_tRecord
		}
	}
	Kill arrRecords
	
	Quit return
}

// w ##class(DHCHAI.MK.ExportToMKSrv).GetReportInfo(252)

ClassMethod GetReportInfo(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	
	Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
	Quit:'$IsObject(objReport) return
	
	Set objDPPaadm=objReport.IREpisodeDr
	Quit:'$IsObject(objDPPaadm) return
	set PatAdmDate=""
	Set PatName=objDPPaadm.PAPatName
	Set PatNo=objDPPaadm.PAMrNo
	Set PatAdmDate=objDPPaadm.PAAdmDate
	Set:PatAdmDate'="" PatAdmDate=$zd(PatAdmDate,3)
	Set PAAdmTime=objDPPaadm.PAAdmTime
	set:PAAdmTime'="" PAAdmTime=$zt(PAAdmTime,1)
	set:PAAdmTime'="" paadmt=$p(PAAdmTime,":",1)
	if (PatAdmDate'="")&&(paadmt'="") set PatAdmDate=PatAdmDate_" "_paadmt
	Set return=PatName_"^"_PatNo_"^"_PatAdmDate
	
	Quit return
}

ClassMethod BuildICUBase(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:('$IsObject(objRep)) ret
	//set aReportID=objRep.ReportID
	//Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
	//Quit:'$IsObject(objReport) ret
	//set IREpisodeDr=objReport.IREpisodeDr
	//Quit:'$IsObject(IREpisodeDr) ret
	//s ^tempzsztest("IcuStr11111111111")=IcuStr
	//set ^tempzsztest("jndeeeeee")=$lb(IcuStr)
	Set $p(ret,..#FieldSeperator,1)=objRep.InICUDate
	Set $p(ret,..#FieldSeperator,2)=""
	Set $p(ret,..#FieldSeperator,3)=""
	Set $p(ret,..#FieldSeperator,4)=objRep.InICUDate
	Set $p(ret,..#FieldSeperator,5)=""
	Set $p(ret,..#FieldSeperator,6)=""
	Set $p(ret,..#FieldSeperator,7)=objRep.OutICUDate
	Set $p(ret,..#FieldSeperator,8)=""
	Set $p(ret,..#FieldSeperator,9)=""
	/*
	Set $p(ret,..#FieldSeperator,5)=..GetMapping("MKLocation",$p(IcuStr,"^",5),$p(IcuStr,"^",3),$p(IcuStr,"^",3))
	Set $p(ret,..#FieldSeperator,6)=$p(IcuStr,"^",3)
	set $p(ret,..#FieldSeperator,7)=$p(IcuStr,"^",2)
	set $p(ret,..#FieldSeperator,8)=..GetMapping("MKLocation",$p(IcuStr,"^",5),$p(IcuStr,"^",3),$p(IcuStr,"^",3))
	set $p(ret,..#FieldSeperator,9)=$p(IcuStr,"^",3)
	*/
	set $p(ret,..#FieldSeperator,10)=0
	set $p(ret,..#FieldSeperator,11)=0
	set $p(ret,..#FieldSeperator,12)=0
	set $p(ret,..#FieldSeperator,13)=0
	set $p(ret,..#FieldSeperator,14)=0
	set $p(ret,..#FieldSeperator,15)=0
	set $p(ret,..#FieldSeperator,16)=0
	set $p(ret,..#FieldSeperator,17)=0
	set $p(ret,..#FieldSeperator,18)=0
	set $p(ret,..#FieldSeperator,19)=0
	set $p(ret,..#FieldSeperator,20)=0
	set $p(ret,..#FieldSeperator,21)=0
	set $p(ret,..#FieldSeperator,22)=""
	set $p(ret,..#FieldSeperator,23)=""
    set $p(ret,..#FieldSeperator,24)=objRep.APACHEScore
	
	
	q ret
}

// BuildICUDiagnose

ClassMethod BuildICUDiagnose(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	set aReportID=objRep.ReportID
	Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
	Quit:'$IsObject(objReport) ret
	set IREpisodeDr=objReport.IREpisodeDr
	Quit:'$IsObject(IREpisodeDr) ret
	
	q ret
}

// w ##class(DHCHAI.MK.ExportToMKSrv).BuildICUPICC(ReportID)

ClassMethod BuildICUPICC(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	set aReportID=objRep.ReportID
	Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
	Quit:'$IsObject(objReport) ret
	set IREpisodeDr=objReport.IREpisodeDr
	Quit:'$IsObject(IREpisodeDr) ret
	set repID=objReport.%Id()
	//set PICCid=""
	set PICCid=$O(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," DHCHAI.IR.INFICUPICC",repID,""))
	Quit:PICCid="" ret
	set piccdr=$list(^DHCHAI.IR.INFReportD(repID,"EXT",PICCid),3)
	Quit:piccdr="" ret	
	set objpicc=##class(DHCHAI.IR.INFICUPICC).GetObjById(piccdr)	
	set IRPICCType=objpicc.IRPICCType
	Quit:'$IsObject(IRPICCType) ret
	set IRPICCTypedesc="",IRPICCCntdesc=""
	set IRPICCTypedesc=objpicc.IRPICCType.BTDesc
	set IRPICCCnt=objpicc.IRPICCCnt
	set:$IsObject(IRPICCCnt) IRPICCCntdesc=objpicc.IRPICCCnt.BTDesc
	set IRPICCPosdesc=""
	set IRPICCPos=objpicc.IRPICCPos
	set:$IsObject(IRPICCPos) IRPICCPosdesc=objpicc.IRPICCPos.BTDesc
	
	/*set IRPICCPosdesc=""
	set IRPICCPos=objpicc.IRPICCPos
	set:$IsObject(IRPICCPos) IRPICCPosdesc=objpicc.IRPICCPos.BTDesc*/
	set IRIntuDate=objpicc.IRIntuDate
	set:IRIntuDate'="" IRIntuDate=$zd(IRIntuDate,3)
	set IRIntuTime=objpicc.IRIntuTime
	set:IRIntuTime'="" IRIntuTime=$zt(IRIntuTime,2)
	set IRExtuDate=objpicc.IRExtuDate
	set:IRExtuDate'="" IRExtuDate=$zd(IRExtuDate,3)
	set IRExtuTime=objpicc.IRExtuTime
	set:IRExtuTime'="" IRExtuTime=$zt(IRExtuTime,2)
	;b ;1
	set IROperDocdesc=""
	set IROperDoc=objpicc.IROperDoc
	set:$IsObject(IROperDoc) IROperDocdesc=objpicc.IROperDoc.BTDesc
	set IROperLocdesc=""
	set IROperLoc=objpicc.IROperLoc
	set:$IsObject(IROperLoc) IROperLocdesc=objpicc.IROperLoc.BTDesc
	set IRIsInf=objpicc.IRIsInf
	set IRInfSymptomsdesc=""
	set IRInfSymptoms=objpicc.IRInfSymptoms
	set:$IsObject(IRInfSymptoms) IRInfSymptomsdesc=objpicc.IRInfSymptoms.BTDesc
	set IRInfDate=objpicc.IRInfDate
	set:IRInfDate'="" IRInfDate=$zd(IRInfDate,3)
	Set $p(ret,..#FieldSeperator,1)=IRPICCTypedesc
	Set $p(ret,..#FieldSeperator,2)=IRPICCCntdesc
	Set $p(ret,..#FieldSeperator,3)=IRPICCPosdesc
	Set $p(ret,..#FieldSeperator,4)=IRIntuDate_" "_IRIntuTime
	Set $p(ret,..#FieldSeperator,5)=IRExtuDate_" "_IRExtuTime
	Set $p(ret,..#FieldSeperator,6)=IROperDocdesc
	Set $p(ret,..#FieldSeperator,7)=IROperLocdesc
	Set $p(ret,..#FieldSeperator,8)=IRIsInf
	Set $p(ret,..#FieldSeperator,9)=IRInfSymptomsdesc
	Set $p(ret,..#FieldSeperator,10)=IRInfDate


	q ret
}

/// 呼吸机
ClassMethod BuildICUVAP(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	set aReportID=objRep.ReportID
	Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
	Quit:'$IsObject(objReport) ret
	set IREpisodeDr=objReport.IREpisodeDr
	Quit:'$IsObject(IREpisodeDr) ret
	set repID=objReport.%Id()
	//set PICCid=""
	set RepExtid=$O(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," DHCHAI.IR.INFICUVAP",repID,""))
	Quit:RepExtid="" ret
	set VAPdr=$list(^DHCHAI.IR.INFReportD(repID,"EXT",RepExtid),3)
	Quit:VAPdr="" ret	
	set objVAP=##class(DHCHAI.IR.INFICUVAP).GetObjById(VAPdr)
	set IRVAPTypedesc=""
	set IRVAPType=objVAP.IRVAPType
	Quit:'$IsObject(IRVAPType) ret
	set IRVAPTypedesc=objVAP.IRVAPType.BTDesc
	set IRIntuDate=objVAP.IRIntuDate
	set:IRIntuDate'="" IRIntuDate=$zd(IRIntuDate,3)
	set IRIntuTime=objVAP.IRIntuTime
	set:IRIntuTime'="" IRIntuTime=$zt(IRIntuTime,2)
	set IRExtuDate=objVAP.IRExtuDate
	set:IRExtuDate'="" IRExtuDate=$zd(IRExtuDate,3)
	set IRExtuTime=objVAP.IRExtuTime
	set:IRExtuTime'="" IRExtuTime=$zt(IRExtuTime,2)
	
	set IROperDocdesc=""
	set IROperDoc=objVAP.IROperDoc
	set:$IsObject(IROperDoc) IROperDocdesc=objVAP.IROperDoc.BTDesc
	set IROperLocdesc=""
	set IROperLoc=objVAP.IROperLoc
	set:$IsObject(IROperLoc) IROperLocdesc=objVAP.IROperLoc.BTDesc
	set IRIsInf=objVAP.IRIsInf
	set IRInfSymptomsdesc=""
	set IRInfSymptoms=objVAP.IRInfSymptoms
	set:$IsObject(IRInfSymptoms) IRInfSymptomsdesc=objVAP.IRInfSymptoms.BTDesc
	set IRInfDate=objVAP.IRInfDate
	set:IRInfDate'="" IRInfDate=$zd(IRInfDate,3)

	Set $p(ret,..#FieldSeperator,1)=IRVAPTypedesc
	Set $p(ret,..#FieldSeperator,2)=IRIntuDate_" "_IRIntuTime
	Set $p(ret,..#FieldSeperator,3)=IRExtuDate_" "_IRExtuTime
	Set $p(ret,..#FieldSeperator,4)=IROperDocdesc
	Set $p(ret,..#FieldSeperator,5)=IROperLocdesc
	Set $p(ret,..#FieldSeperator,6)=IRIsInf
	Set $p(ret,..#FieldSeperator,7)=IRInfSymptomsdesc
	Set $p(ret,..#FieldSeperator,8)=IRInfDate

	q ret
}

/// 导尿管
ClassMethod BuildICUUC(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	set aReportID=objRep.ReportID
	Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
	Quit:'$IsObject(objReport) ret
	set IREpisodeDr=objReport.IREpisodeDr
	Quit:'$IsObject(IREpisodeDr) ret
	set repID=objReport.%Id()
	//set PICCid=""
	set RepExtid=$O(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," DHCHAI.IR.INFICUUC",repID,""))
	Quit:RepExtid="" ret
	set UCdr=$list(^DHCHAI.IR.INFReportD(repID,"EXT",RepExtid),3)
	Quit:UCdr="" ret	
	set objUC=##class(DHCHAI.IR.INFICUUC).GetObjById(UCdr)
	set IRUCTypedesc=""
	set IRUCType=objUC.IRUCType
	Quit:'$IsObject(IRUCType) ret
	set IRUCTypedesc=objUC.IRUCType.BTDesc
	set IRIntuDate=objUC.IRIntuDate
	set:IRIntuDate'="" IRIntuDate=$zd(IRIntuDate,3)
	set IRIntuTime=objUC.IRIntuTime
	set:IRIntuTime'="" IRIntuTime=$zt(IRIntuTime,2)
	set IRExtuDate=objUC.IRExtuDate
	set:IRExtuDate'="" IRExtuDate=$zd(IRExtuDate,3)
	set IRExtuTime=objUC.IRExtuTime
	set:IRExtuTime'="" IRExtuTime=$zt(IRExtuTime,2)
	set IROperDocdesc=""
	set IROperDoc=objUC.IROperDoc
	set:$IsObject(IROperDoc) IROperDocdesc=objUC.IROperDoc.BTDesc
	set IROperLocdesc=""
	set IROperLoc=objUC.IROperLoc
	set:$IsObject(IROperLoc) IROperLocdesc=objUC.IROperLoc.BTDesc
	set IRIsInf=objUC.IRIsInf
	set IRInfSymptomsdesc=""
	set IRInfSymptoms=objUC.IRInfSymptoms
	set:$IsObject(IRInfSymptoms) IRInfSymptomsdesc=objUC.IRInfSymptoms.BTDesc
	set IRInfDate=objUC.IRInfDate
	set:IRInfDate'="" IRInfDate=$zd(IRInfDate,3) 

	Set $p(ret,..#FieldSeperator,1)=IRUCTypedesc
	Set $p(ret,..#FieldSeperator,2)=IRIntuDate_" "_IRIntuTime
	Set $p(ret,..#FieldSeperator,3)=IRExtuDate_" "_IRExtuTime
	Set $p(ret,..#FieldSeperator,4)=IROperDocdesc
	Set $p(ret,..#FieldSeperator,5)=IROperLocdesc
	Set $p(ret,..#FieldSeperator,6)=IRIsInf
	Set $p(ret,..#FieldSeperator,7)=IRInfSymptomsdesc
	Set $p(ret,..#FieldSeperator,8)=IRInfDate

	q ret
}

ClassMethod BuildBaseInfonew(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	
	Set ret=""
	Quit:'$IsObject(objRep) ret

	/*
	Set arryPos=objRep.GetInfPos(objRep.ReportID)
	If arryPos.Count()>0 {
		Set objPos=arryPos.GetAt(1)
	} Else {
		Set objPos=##class(DHCHAI.MK.INFReportInfPos).%New()
		Do objPos.%Close()
	}
	
	Set objSumm=objRep.GetReportSumm(objRep.ReportID)
	Quit:'$IsObject(objSumm) ret
    */
    Set OperStartDate=""
	Set arry=objRep.GetOperations(objRep.ReportID)
	Set Cnt=arry.Count()
	For ind=1:1:Cnt {
		Set objOpe=arry.GetAt(ind)
		Continue:'$IsObject(objOpe)
		Continue:objOpe.OperationDesc=""
		//*手术开始时间
		Set OperStartDate=objOpe.OperStartDate
	}
    //Set OperStartDate=objOpe.OperStartDate
    ;b ;1
    ;set IRRepDate=$zd(IRRepDate,3)
    /*
    Set DPEpisodeID=objRep.EpisodeID
	Set objPaadm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(DPEpisodeID)
	set PADischDate=objPaadm.PADischDate
	set:PADischDate'="" PADischDate=$zd(PADischDate,3)
	
    if PADischDate'=""{
       Set $p(ret,..#FieldSeperator,1)=PADischDate
    }else{
	   Set $p(ret,..#FieldSeperator,1)=IRRepDate 
	}
	*/
	
	Set $p(ret,..#FieldSeperator,1)=OperStartDate
	

    Set objSumm=objRep.GetReportSumm(objRep.ReportID)
	Quit:'$IsObject(objSumm) ret
    //Set objDic=objSumm.TransLoc
    //w objSumm.TransLoc,!
    ;b ;1111
    //If ($IsObject(objDic)&&(objDic.Desc)="") {
	    //b ;23332
		//Set $p(ret,..#FieldSeperator,2)=..GetMapping("MKLocation",objDic.Code,objDic.Desc,objDic.Desc)
	//} Else {
		//b ;2332
	Set objDic=objRep.ReportLoc
	Set $p(ret,..#FieldSeperator,2)=..GetMapping("MKLocation",objDic.Code,objDic.Desc,objDic.Desc)
	//} 
	;b ;233
    //院内科别
	//Set objDic=objSumm.TransLoc
	//If ($IsObject(objDic)&&(objDic.Desc)="") {
		;b ;11
		//Set $p(ret,..#FieldSeperator,3)=..GetMapping("MKHospLoc",objDic.Code,objDic.Desc,objDic.Desc)
	//} Else {
		;b ;22
		Set objDicnew=objRep.ReportLoc
		Set $p(ret,..#FieldSeperator,3)=objDicnew.Desc
	//}
    //b ;12
    //按院感科要求 安贞医院病案号应该显示 登记号
	
	Set DPEpisodeID=objRep.EpisodeID
	Set objPaadm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(DPEpisodeID)
	set PADischDate=objPaadm.PADischDate
	set:PADischDate'="" PADischDate=$zd(PADischDate,3)
	/*
	if PADischDate'="" {
	   //*调查表登记日期
	   
	   Set $p(ret,..#FieldSeperator,4)=PADischDate
	}else{
		*/
	   Set $p(ret,..#FieldSeperator,4)=objRep.ReportDate
	   
	//}
	
	
	
	//*调查表登记日期
	//Set $p(ret,..#FieldSeperator,4)=objRep.ReportDate
	//*调查者
	
	Set $p(ret,..#FieldSeperator,5)=objRep.ReportUser.Desc
	
	//Set $p(ret,..#FieldSeperator,5)=$zconvert(objRep.ReportUser.Desc,"O","UTF-8")
	//*病历号
	//Set:MrNo="" MrNo=objPatient.InPatientMrNo
	
	Set MrNo=objPaadm.PAMrNo        //如果病历号错误，用登记号代替
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
	Set $p(ret,..#FieldSeperator,8)=objPaadm.PAPatName
	//*性别
	Set Sex=objPaadm.PASex
	If (Sex="F") { //M男、F女、O其他
		Set Sex="女"
	} ElseIf (Sex="M") {
		Set Sex="男"
	} Else {
		Set Sex="男"
	}
	Set $p(ret,..#FieldSeperator,9)=Sex
	//*年龄
	Set PatAge=objPaadm.PAAge
	Set:+PatAge<1 PatAge=1
	Set $p(ret,..#FieldSeperator,10)=PatAge
	//床位号
	Set objAdmBed=objPaadm.PAAdmBedDr
	Set AdmBedNo=""
	If ($IsObject(objAdmBed)) {
		Set Bed=objAdmBed.BTDesc
		Set:Bed["床" AdmBedNo=$p(Bed,"床",1)
	}
	Set $p(ret,..#FieldSeperator,11)=AdmBedNo
	//*入院日期
	Set AdmData=objPaadm.PAAdmDate
	Set:AdmData'="" AdmData=$zd(AdmData,3)
	Set $p(ret,..#FieldSeperator,12)=AdmData
	//出院日期
	Set DisDate=objPaadm.PADischDate
	Set:DisDate'="" DisDate=$zd(DisDate,3)
	Set $p(ret,..#FieldSeperator,13)=DisDate
	//医院感染
	Set $p(ret,..#FieldSeperator,14)=0
	If objRep.ReportType.Code="1" {
		Set $p(ret,..#FieldSeperator,14)=1 //医院感染
	}
	//漏报病人
	Set $p(ret,..#FieldSeperator,15)=0
	//调查方式
	Set $p(ret,..#FieldSeperator,16)=2
	//ICU检测(是否ICU目标性监测)
	Set $p(ret,..#FieldSeperator,17)=0
	//*疾病转归
	//*疾病转归
	Set objDic=""
	//Set objDic=objOpe.InfEndResult
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,18)=..GetMapping("MKInfEndResult",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,18)=1
	}
	Set:$p(ret,..#FieldSeperator,18)="" $p(ret,..#FieldSeperator,18)=""
	//与死亡关系
	Set $p(ret,..#FieldSeperator,19)=0
	
	//感染性疾病病程
	Set DiseaseCourse=""
	//Set:$l(DiseaseCourse)>254 DiseaseCourse=$e(DiseaseCourse,1,254)
	Set $p(ret,..#FieldSeperator,20)=DiseaseCourse
	//感染疾病诊断依据
	Set DiagnosisBasis=""
	//Set:$l(DiagnosisBasis)>254 DiagnosisBasis=$e(DiagnosisBasis,1,254)
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
		Set $p(ret,..#FieldSeperator,23)=InfOPSBar
	}
	//病原学监测（是否）
	Set objDic=objSumm.LabBoolean
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,24)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,24)=InfLabBar
	}
	//使用抗生素使用（是否）
	Set objDic=objSumm.AntiBoolean
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,25)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,25)=InfAntiBar
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
	Set $p(ret,..#FieldSeperator,28)=""
	//随访
	Set $p(ret,..#FieldSeperator,29)=1
	//电话随访
	Set $p(ret,..#FieldSeperator,30)=0
	//信函调查
	Set $p(ret,..#FieldSeperator,31)=0
	//短信随访
	Set $p(ret,..#FieldSeperator,32)=0
	//门诊随访
	Set $p(ret,..#FieldSeperator,33)=1
	//家庭随访
	Set $p(ret,..#FieldSeperator,34)=0
	//其他随访
	Set $p(ret,..#FieldSeperator,35)=0
	//其他随访描述
	Set $p(ret,..#FieldSeperator,36)=""
	
	Quit ret
}

ClassMethod BuildICUBaseInfonew(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret

	/*
	Set arryPos=objRep.GetInfPos(objRep.ReportID)
	If arryPos.Count()>0 {
		Set objPos=arryPos.GetAt(1)
	} Else {
		Set objPos=##class(DHCHAI.MK.INFReportInfPos).%New()
		Do objPos.%Close()
	}
	
	Set objSumm=objRep.GetReportSumm(objRep.ReportID)
	Quit:'$IsObject(objSumm) ret
    */
    //Set OperStartDate=""
	Set arry=objRep.GetOperations(objRep.ReportID)
	Set Cnt=arry.Count()
	For ind=1:1:Cnt {
		Set objOpe=arry.GetAt(ind)
		Continue:'$IsObject(objOpe)
		Continue:objOpe.OperationDesc=""
		//*手术开始时间
		Set OperStartDate=objOpe.OperStartDate
	}
    //Set OperStartDate=objOpe.OperStartDate
    ;b ;1
    ;set IRRepDate=$zd(IRRepDate,3)
    /*
    Set DPEpisodeID=objRep.EpisodeID
	Set objPaadm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(DPEpisodeID)
	set PADischDate=objPaadm.PADischDate
	set:PADischDate'="" PADischDate=$zd(PADischDate,3)
	
    if PADischDate'=""{
       Set $p(ret,..#FieldSeperator,1)=PADischDate
    }else{
	   Set $p(ret,..#FieldSeperator,1)=IRRepDate 
	}
	*/
	
	Set $p(ret,..#FieldSeperator,1)=objRep.ReportDate
	
	
	
    Set objSumm=objRep.GetReportSumm(objRep.ReportID)
	Quit:'$IsObject(objSumm) ret
    //Set objDic=objSumm.TransLoc
    //w objSumm.TransLoc,!
    ;b ;1111
    //If ($IsObject(objDic)&&(objDic.Desc)="") {
	    //b ;23332
		//Set $p(ret,..#FieldSeperator,2)=..GetMapping("MKLocation",objDic.Code,objDic.Desc,objDic.Desc)
	//} Else {
		//b ;2332
	Set objDic=objRep.ReportLoc
	Set $p(ret,..#FieldSeperator,2)=..GetMapping("MKLocation",objDic.Code,objDic.Desc,objDic.Desc)
	//} 
	;b ;233
    //院内科别
	//Set objDic=objSumm.TransLoc
	//If ($IsObject(objDic)&&(objDic.Desc)="") {
		;b ;11
		//Set $p(ret,..#FieldSeperator,3)=..GetMapping("MKHospLoc",objDic.Code,objDic.Desc,objDic.Desc)
	//} Else {
		;b ;22
		Set objDicnew=objRep.ReportLoc
		Set $p(ret,..#FieldSeperator,3)=objDicnew.Desc
	//}
    //b ;12
    //按院感科要求 安贞医院病案号应该显示 登记号
	
	Set DPEpisodeID=objRep.EpisodeID
	Set objPaadm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(DPEpisodeID)
	set PADischDate=objPaadm.PADischDate
	set:PADischDate'="" PADischDate=$zd(PADischDate,3)
	/*
	if PADischDate'="" {
	   //*调查表登记日期
	   
	   Set $p(ret,..#FieldSeperator,4)=PADischDate
	}else{
		*/
	   Set $p(ret,..#FieldSeperator,4)=objRep.ReportDate
	   
	//}
	
	
	
	//*调查表登记日期
	//Set $p(ret,..#FieldSeperator,4)=objRep.ReportDate
	//*调查者
	Set $p(ret,..#FieldSeperator,5)=objRep.ReportUser.Desc
	//*病历号
	//Set:MrNo="" MrNo=objPatient.InPatientMrNo
	
	Set MrNo=objPaadm.PAMrNo        //如果病历号错误，用登记号代替
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
	Set $p(ret,..#FieldSeperator,8)=objPaadm.PAPatName
	//*性别
	Set Sex=objPaadm.PASex
	If (Sex="F") { //M男、F女、O其他
		Set Sex="女"
	} ElseIf (Sex="M") {
		Set Sex="男"
	} Else {
		Set Sex="男"
	}
	Set $p(ret,..#FieldSeperator,9)=Sex
	//*年龄
	Set PatAge=objPaadm.PAAge
	Set:+PatAge<1 PatAge=1
	Set $p(ret,..#FieldSeperator,10)=PatAge
	//床位号
	Set objAdmBed=objPaadm.PAAdmBedDr
	Set AdmBedNo=""
	If ($IsObject(objAdmBed)) {
		Set Bed=objAdmBed.BTDesc
		Set:Bed["床" AdmBedNo=$p(Bed,"床",1)
	}
	Set $p(ret,..#FieldSeperator,11)=AdmBedNo
	//*入院日期
	Set AdmData=objPaadm.PAAdmDate
	Set:AdmData'="" AdmData=$zd(AdmData,3)
	Set $p(ret,..#FieldSeperator,12)=AdmData
	//出院日期
	Set DisDate=objPaadm.PADischDate
	Set:DisDate'="" DisDate=$zd(DisDate,3)
	Set $p(ret,..#FieldSeperator,13)=DisDate
	//医院感染
	Set $p(ret,..#FieldSeperator,14)=0
	If objRep.ReportType.Code="1" {
		Set $p(ret,..#FieldSeperator,14)=1 //医院感染
	}
	//漏报病人
	Set $p(ret,..#FieldSeperator,15)=0
	//调查方式
	Set $p(ret,..#FieldSeperator,16)=2
	//ICU检测(是否ICU目标性监测)
	Set $p(ret,..#FieldSeperator,17)=0
	//*疾病转归
	//*疾病转归
	Set objDic=""
	//Set objDic=objOpe.InfEndResult
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,18)=..GetMapping("MKInfEndResult",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,18)=1
	}
	Set:$p(ret,..#FieldSeperator,18)="" $p(ret,..#FieldSeperator,18)=""
	//与死亡关系
	Set $p(ret,..#FieldSeperator,19)=0
	
	//感染性疾病病程
	Set DiseaseCourse=""
	//Set:$l(DiseaseCourse)>254 DiseaseCourse=$e(DiseaseCourse,1,254)
	Set $p(ret,..#FieldSeperator,20)=DiseaseCourse
	//感染疾病诊断依据
	Set DiagnosisBasis=""
	//Set:$l(DiagnosisBasis)>254 DiagnosisBasis=$e(DiagnosisBasis,1,254)
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
		Set $p(ret,..#FieldSeperator,23)=InfOPSBar
	}
	//病原学监测（是否）
	Set objDic=objSumm.LabBoolean
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,24)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,24)=InfLabBar
	}
	//使用抗生素使用（是否）
	Set objDic=objSumm.AntiBoolean
	If $IsObject(objDic) {
		Set $p(ret,..#FieldSeperator,25)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
	} Else {
		Set $p(ret,..#FieldSeperator,25)=InfAntiBar
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
	Set $p(ret,..#FieldSeperator,28)=""
	//随访
	Set $p(ret,..#FieldSeperator,29)=0
	//电话随访
	Set $p(ret,..#FieldSeperator,30)=0
	//信函调查
	Set $p(ret,..#FieldSeperator,31)=0
	//短信随访
	Set $p(ret,..#FieldSeperator,32)=0
	//门诊随访
	Set $p(ret,..#FieldSeperator,33)=0
	//家庭随访
	Set $p(ret,..#FieldSeperator,34)=0
	//其他随访
	Set $p(ret,..#FieldSeperator,35)=0
	//其他随访描述
	Set $p(ret,..#FieldSeperator,36)=""
	
	Quit ret
}

/// add by zsz 20190815
/// 查询医院感染报告校验信息
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Srv.ExportMinKeCss","QryValidateInfo","951","^")
Query QryValidateInfonew(aReportList As %String, aDelimiter As %String = "^", RepType As %String = "") As %Query(ROWSPEC = "Index:%String,ID:%String,SrcValue:%String,SrcDesc:%String,TargetValue:%String,TargetDesc:%String,ResumeText:%String,MappingTypeCode:%String,MappingTypeDesc:%String,MapDicGroupCode:%String,MapDicTypeCode:%String")
{
}

ClassMethod QryValidateInfonewExecute(ByRef qHandle As %Binary, aReportList As %String, aDelimiter As %String = "^", RepType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set NIndex="QryValidateInfo"
 	Kill ^TMP($zn,$j,NIndex)
 	
 	For indRep=1:1:$l(aReportList,aDelimiter) {
 		Set ReportID=$p(aReportList,aDelimiter,indRep)
 		Continue:ReportID=""
 		
 		Set flg=..ValidateReportnew(ReportID)
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

ClassMethod QryValidateInfonewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryValidateInfonewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryValidateInfonewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryValidateInfonewExecute ]
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

/// w ##class(DHCMed.NINFService.Srv.ExportMinKeCss).ValidateReport(48)
ClassMethod ValidateReportnew(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	
	Set objRep=##class(DHCHAI.MK.INFReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	
	Set ErrorList=""
	Set tmp=..CheckReportnew(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
	Set tmp=..CheckReportDiagnew(objRep) 
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
	Set tmp=..CheckReportLabnew(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
	
	Set:ErrorList'="" return=$e(ErrorList,1,$l(ErrorList)-1)
	Set:ErrorList="" return="OK"
	
	Quit return
}

ClassMethod CheckReportnew(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	
	//报告科室
	Set tmp=..IsMapping(objRep.ReportLoc.Code,objRep.ReportLoc.Desc,"MKLocation","报告科室无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	Set tmp=..IsMapping(objRep.ReportLoc.Code,objRep.ReportLoc.Desc,"MKHospLoc","报告科室无法对照")
	Set:tmp'="OK" ret=ret_tmp_$c(2)
	
	Set infPosList=objRep.GetInfPos(objRep.ReportID)
	Set objInfPos=infPosList.GetAt(1)
	
	If $IsObject(objInfPos) {
		//感染科室
		Set tmp=..IsMapping(objInfPos.InfLoc.Code,objInfPos.InfLoc.Desc,"MKLocation","感染科室无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objInfPos.InfLoc.Code,objInfPos.InfLoc.Desc,"MKHospLoc","感染科室无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
	}
	
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	
	Quit ret
}

ClassMethod CheckReportDiagnew(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	
	Set arryDia=objRep.GetDiagnos(objRep.ReportID)
	Set Cnt=arryDia.Count()
	For indArr=1:1:Cnt {
		Set objDia=arryDia.GetAt(indArr)
		Continue:'$IsObject(objDia)
		Continue:objDia.DiagnosDesc=""
		Set objDia.DiagnosDesc=$tr(objDia.DiagnosDesc,$c(13),"") //add by wuqk 2014-03-06
		
		Set tmp=..IsMapping(objDia.DiagnosDesc,objDia.DiagnosICD,"MKDiagnos","疾病诊断无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
	}
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	
	Quit ret
}

ClassMethod CheckReportLabnew(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	
	set ExtID=$O(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," DHCHAI.IR.INFCSS",objRep.ReportID,"")) 
	set cssID=$list(^DHCHAI.IR.INFReportD(objRep.ReportID,"EXT",ExtID),3)
	set ObjCSS=##class(DHCHAI.IR.INFCSS).GetObjById(cssID)
	
	Quit:'$IsObject(ObjCSS) ret
	
	set IRInfPathogen1=ObjCSS.IRInfPathogen1
	set IRInfPathogen2=ObjCSS.IRInfPathogen2
	set IRInfPathogen3=ObjCSS.IRInfPathogen3
	
	set (PosBTDesc1,infBacteria11,BTBacDesc11,infBacteria12,BTBacDesc12,infBacteria13,BTBacDesc13)=""
	if IRInfPathogen1'=""{
	    set infpos1=$p(IRInfPathogen1,"#",1)
	    set:infpos1'="" PosBTDesc1=$list(^DHCHAI.BT.InfPosD(infpos1),3)
	    if PosBTDesc1'="" {
		    Set tmp=..IsMapping(PosBTDesc1,PosBTDesc1,"MKInfPos","感染部位无法对照")
		    Set:tmp'="OK" ret=ret_tmp_$c(2)
	    }
		set infBacteria11=$p(IRInfPathogen1,"#",2)
		set:infBacteria11'="" BTBacDesc11=$list(^DHCHAI.DP.LabBacteriaD(infBacteria11),3)
		if infBacteria11'="" {
			Set tmp=..IsMapping(BTBacDesc11,infBacteria11,"MKPathogeny","细菌名称无法对照")
			Set:tmp'="OK" ret=ret_tmp_$c(2)
		}
		set infBacteria12=$p(IRInfPathogen1,"#",4)
		set:infBacteria12'="" BTBacDesc12=$list(^DHCHAI.DP.LabBacteriaD(infBacteria12),3)
		if infBacteria12'="" {
			Set tmp=..IsMapping(BTBacDesc12,infBacteria12,"MKPathogeny","细菌名称无法对照")
			Set:tmp'="OK" ret=ret_tmp_$c(2)
		}	
		set infBacteria13=$p(IRInfPathogen1,"#",6)
		set:infBacteria13'="" BTBacDesc13=$list(^DHCHAI.DP.LabBacteriaD(infBacteria13),3)
		if infBacteria13'="" {
			Set tmp=..IsMapping(BTBacDesc13,infBacteria13,"MKPathogeny","细菌名称无法对照")
			Set:tmp'="OK" ret=ret_tmp_$c(2)
		}
	}
	set (PosBTDesc2,infBacteria21,BTBacDesc21,infBacteria22,BTBacDesc22,infBacteria23,BTBacDesc23)=""
	if IRInfPathogen2'=""{
	    set infpos2=$p(IRInfPathogen2,"#",1)
	    set:infpos2'="" PosBTDesc2=$list(^DHCHAI.BT.InfPosD(infpos2),3)
	    if PosBTDesc2'="" {
		    Set tmp=..IsMapping(PosBTDesc2,PosBTDesc2,"MKInfPos","感染部位无法对照")
		    Set:tmp'="OK" ret=ret_tmp_$c(2)
	    }
		set infBacteria21=$p(IRInfPathogen2,"#",2)
		set:infBacteria21'="" BTBacDesc21=$list(^DHCHAI.DP.LabBacteriaD(infBacteria21),3)
		if infBacteria21'="" {
			Set tmp=..IsMapping(BTBacDesc21,infBacteria21,"MKPathogeny","细菌名称无法对照")
			Set:tmp'="OK" ret=ret_tmp_$c(2)
		}
		set infBacteria22=$p(IRInfPathogen2,"#",4)
		set:infBacteria22'="" BTBacDesc22=$list(^DHCHAI.DP.LabBacteriaD(infBacteria22),3)
		if infBacteria22'="" {
			Set tmp=..IsMapping(BTBacDesc22,infBacteria22,"MKPathogeny","细菌名称无法对照")
			Set:tmp'="OK" ret=ret_tmp_$c(2)
		}	
		set infBacteria23=$p(IRInfPathogen2,"#",6)
		set:infBacteria23'="" BTBacDesc23=$list(^DHCHAI.DP.LabBacteriaD(infBacteria23),3)
		if infBacteria23'="" {
			Set tmp=..IsMapping(BTBacDesc23,infBacteria23,"MKPathogeny","细菌名称无法对照")
			Set:tmp'="OK" ret=ret_tmp_$c(2)
		}
	}
	set (PosBTDesc3,infBacteria31,BTBacDesc31,infBacteria32,BTBacDesc32,infBacteria33,BTBacDesc33)=""
	if IRInfPathogen3'=""{
	    set infpos3=$p(IRInfPathogen3,"#",1)
	    set:infpos3'="" PosBTDesc3=$list(^DHCHAI.BT.InfPosD(infpos3),3)
	    if PosBTDesc3'="" {
		    Set tmp=..IsMapping(PosBTDesc3,PosBTDesc3,"MKInfPos","感染部位无法对照")
		    Set:tmp'="OK" ret=ret_tmp_$c(2)
	    }
		set infBacteria31=$p(IRInfPathogen3,"#",2)
		set:infBacteria31'="" BTBacDesc31=$list(^DHCHAI.DP.LabBacteriaD(infBacteria31),3)
		if infBacteria31'="" {
			Set tmp=..IsMapping(BTBacDesc31,infBacteria31,"MKPathogeny","细菌名称无法对照")
			Set:tmp'="OK" ret=ret_tmp_$c(2)
		}
		set infBacteria32=$p(IRInfPathogen3,"#",4)
		set:infBacteria32'="" BTBacDesc32=$list(^DHCHAI.DP.LabBacteriaD(infBacteria32),3)
		if infBacteria32'="" {
			Set tmp=..IsMapping(BTBacDesc32,infBacteria32,"MKPathogeny","细菌名称无法对照")
			Set:tmp'="OK" ret=ret_tmp_$c(2)
		}	
		set infBacteria33=$p(IRInfPathogen3,"#",6)
		set:infBacteria33'="" BTBacDesc33=$list(^DHCHAI.DP.LabBacteriaD(infBacteria33),3)
		if infBacteria33'="" {
			Set tmp=..IsMapping(BTBacDesc33,infBacteria33,"MKPathogeny","细菌名称无法对照")
			Set:tmp'="OK" ret=ret_tmp_$c(2)
		}
	}
	
	
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	//set ^tempzsztest("kkkkjjjjfhdhfhshhfd")=$lb(ret)
	Set:ret="" ret="OK"
	
	Quit ret
}

/// 根据诊断描述取对应ICD吗
/// w ##class(DHCMed.NINFService.Srv.ExportMinKeCss).getICDInfoByDesc("埃尔托生物型霍乱")
ClassMethod getICDInfoByDesc(aDesc As %String) As %String
{
	New (aDesc)
	Set return=""
	Quit:aDesc="" return
	//^MRC("ID",0,"Desc",$$ALPHAUP({MRCID_ShortDesc}),{MRCID_RowId})
	
	Set shortDesc=$ZCVT(aDesc,"U")

	Quit:('$d(^MRC("ID",0,"Desc",shortDesc))) return

	Set ICDRowId="",ICDCode=""
	For {
		Set ICDRowId=$o(^MRC("ID",0,"Desc",shortDesc,ICDRowId),-1)
		Quit:ICDRowId=""
		Quit:ICDCode'=""
		
		Set ICDInfo=$g(^MRC("ID",ICDRowId))
		Set DateTo=$p(ICDInfo,"^",7)
		Continue:((DateTo'="")&&(DateTo<+$h))
		
		Set ICDCode=$p(ICDInfo,"^",4)
	}
	Set return=ICDCode
	
	Quit return
}

/// w ##class(DHCHAI.MK.ExportToMKSrv).ExportXHLReport(951,"951")
ClassMethod ExportXHLReport(aReport As %String, aReportIDList As %String = "") As %String
{
	New (aReport,aReportIDList)
	Set return=""
	Quit:aReport="" return
	s ^tempzsztest("jhjsdfjsfjdsdddd")=$lb(aReport,aReportIDList)
	Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(aReport)
	Quit:'$IsObject(objReport) return
	;b ;1
	Quit:'$IsObject(objReport.IRStatusDr) return
	Set StatusCode=objReport.IRStatusDr.BTCode
	;b ;2222
	Quit:(StatusCode'="3")&&(StatusCode'="2")&&(StatusCode'="8") return //只导审核+提交的报告
	Set RepType=objReport.IRRepType
	
	Set IREpisodeDr=objReport.IREpisodeDr
	Quit:'$IsObject(IREpisodeDr) return
	Set DPPaadmDr=IREpisodeDr.%Id()
	
	Set arryReports=##class(DHCHAI.MK.INFReport).GetINFRepListByAdm(DPPaadmDr,RepType)
	Set Count=arryReports.Count()
	Set tmpCnt=Count
	For i=1:1:Count {
		Set objRep=arryReports.GetAt(i)
		Continue:'$IsObject(objRep)
		
		Set tReportIDList="^"_aReportIDList_"^"
		Continue:(aReportIDList'="")&&(tReportIDList'[("^"_objRep.ReportID_"^"))
		
		Set OperCutFlag=0
		
		Set $p(return,$c(1),1)=..BuildBaseInfXHL(objRep)                                  //病人基本信息
		Set $p(return,$c(1),2)=$p(return,$c(1),2)_$c(2)_..BuildBaseDiagnosenew(objRep)     //基础疾病
		Set $p(return,$c(1),3)=$p(return,$c(1),3)_$c(2)_..BuildLabResultnew(objRep)        //病原学检测1
	
		
		Set tmpCnt=tmpCnt-1
	}
	;b ;3333
	Quit:return="" return
	;b ;123
	//update by zf 2016-08-09
	//处理导出接口中的重复数据
	Set $p(return,$c(1),2)=..ProRepeatRecords($p(return,$c(1),2),$c(2))
	Set $p(return,$c(1),3)=..ProRepeatRecords($p(return,$c(1),3),$c(2))
	Quit return
}

ClassMethod BuildBaseInfXHL(objRep As DHCHAI.MK.INFReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	Set arryPos=objRep.GetInfPos(objRep.ReportID)
	If arryPos.Count()>0 {
		Set objPos=arryPos.GetAt(1)
	} Else {
		Set objPos=##class(DHCHAI.MK.INFReportInfPos).%New()
		Do objPos.%Close()
	}
	
	Set objSumm=objRep.GetReportSumm(objRep.ReportID)
	Quit:'$IsObject(objSumm) ret

	Set OperDate=""
	Set arry=objRep.GetOperations(objRep.ReportID)
	Set Cnt=arry.Count()
	For ind=1:1:Cnt {
		Set objOpe=arry.GetAt(ind)
		Continue:'$IsObject(objOpe)
		Continue:objOpe.OperationDesc=""
		//*手术开始时间
		Set OperDate=objOpe.OperStartDate
	}
	
	
	//*感染科别
	//Set objDic=objPos.InfLoc
	//If $IsObject(objDic) {
		//Set $p(ret,..#FieldSeperator,2)=..GetMapping("MKLocation",objDic.Code,objDic.Desc,objDic.Desc)
	//} Else {
		Set objDic=objRep.ReportLoc  
		Set $p(ret,..#FieldSeperator,2)=..GetMapping("MKLocation",objDic.Code,objDic.Desc,objDic.Desc)
	//}

	//院内科别
	Set objDic=objRep.ReportLoc
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
	//Set:MrNo="" MrNo=objPatient.InPatientMrNo
	//按院感科要求 安贞医院病案号应该显示 登记号
	Set DPEpisodeID=objRep.EpisodeID
	Set objPaadm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(DPEpisodeID)
	Set MrNo=objPaadm.PAMrNo        //如果病历号错误，用登记号代替
	Set $p(ret,..#FieldSeperator,6)=MrNo
	/*
	//*本月住院次数（本院转入该科室的次数）
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
		Set AdmitDate=$p(AdmData,"^",7)
		Continue:((AdmitDate<FirstDay)||(AdmitDate>LastDay))
	}
	*/
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
	Set $p(ret,..#FieldSeperator,8)=objPaadm.PAPatName
	//*性别
	Set Sex=objPaadm.PASex
	If (Sex="F") { //M男、F女、O其他
		Set Sex="女"
	} ElseIf (Sex="M") {
		Set Sex="男"
	} Else {
		Set Sex="男"
	}
	Set $p(ret,..#FieldSeperator,9)=Sex
	//*年龄
	Set PatAge=objPaadm.PAAge
	Set:+PatAge<1 PatAge=1
	Set $p(ret,..#FieldSeperator,10)=PatAge
	//床位号
	Set objAdmBed=objPaadm.PAAdmBedDr
	;b ;123
	Set AdmBedNo=""
	If ($IsObject(objAdmBed)) {
		Set AdmBedNo=objAdmBed.BTDesc
		Set:AdmBedNo["床" AdmBedNo=$p(AdmBedNo,"床",1)
	}
	Set $p(ret,..#FieldSeperator,11)=AdmBedNo
	
	//入院日期
	Set AdmData=objPaadm.PAAdmDate
	Set:AdmData'="" AdmData=$zd(AdmData,3)
	Set $p(ret,..#FieldSeperator,12)=AdmData
   
    set ExtID=$O(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," DHCHAI.IR.INFCSS",objRep.ReportID,"")) 
	set cssID=$list(^DHCHAI.IR.INFReportD(objRep.ReportID,"EXT",ExtID),3)
	set ObjCSS=##class(DHCHAI.IR.INFCSS).GetObjById(cssID)
	
	Quit:'$IsObject(ObjCSS) ret
	
	set infdate=""
	set IRInfPathogen1=ObjCSS.IRInfPathogen1
	if IRInfPathogen1'="" set infdate=$p(IRInfPathogen1,"#",8)
	//*调查表时间（发生院内感染的时间）
	//Set $p(ret,..#FieldSeperator,1)=objPos.InfDate
	if infdate'=""{
		Set $p(ret,..#FieldSeperator,1)=infdate
	}else{
		Set $p(ret,..#FieldSeperator,1)=objRep.ReportDate	
	}
	
	set IsinfGR=""
	if $IsObject(ObjCSS.IRInfectionDr) set IsinfGR=ObjCSS.IRInfectionDr.BTDesc
	;b ;1
	set IsinfGR=$s(IsinfGR="是":1,IsinfGR="否":0,1:0)
	Set $p(ret,..#FieldSeperator,14)=IsinfGR   //ObjCSS.IRInfCategoryDr
	//set IRHbsAgDr=ObjCSS.IRHbsAgDr
	//if $IsObject(IRHbsAgDr) {
		//set $p(ret,..#FieldSeperator,11)=IRHbsAgDr.BTCode
	//}else{
		set $p(ret,..#FieldSeperator,15)=""
    //}
	//set IRHCVDr=ObjCSS.IRHCVDr
	//if $IsObject(IRHCVDr) {
		//set $p(ret,..#FieldSeperator,12)=IRHCVDr.BTCode
	//}else{
		set $p(ret,..#FieldSeperator,16)=""
    //}
	//set IRHIVDr=ObjCSS.IRHIVDr
	//if $IsObject(IRHIVDr) {
		//Set $p(ret,..#FieldSeperator,13)=IRHIVDr.BTCode
	//}else{
		Set $p(ret,..#FieldSeperator,17)=""
   // }
	//set IRAddPICC=ObjCSS.IRAddPICC
	
	set IRInfectionDr=ObjCSS.IRInfectionDr 
    if $IsObject(IRInfectionDr) {
		Set $p(ret,..#FieldSeperator,18)=IRInfectionDr.BTCode
	}else{
		Set $p(ret,..#FieldSeperator,18)=""
    }	
    //Set $p(ret,..#FieldSeperator,14)=ObjCSS.IRInfectionDr
    Set $p(ret,..#FieldSeperator,19)=""
    Set $p(ret,..#FieldSeperator,20)=""
    //set $p(ret,..#FieldSeperator,17)=ObjCSS.IRAddJMSY
    set $p(ret,..#FieldSeperator,21)=""
    set $p(ret,..#FieldSeperator,25)=ObjCSS.IRAntiFlag
    set IRAntiUsePurposeDr=ObjCSS.IRAntiUsePurposeDr 
    if $IsObject(IRAntiUsePurposeDr) {
		Set $p(ret,..#FieldSeperator,19)=IRAntiUsePurposeDr.BTCode
	}else{
		Set $p(ret,..#FieldSeperator,19)=""
    }
    set IRAntiCombinedMedDr=ObjCSS.IRAntiCombinedMedDr 
    if $IsObject(IRAntiCombinedMedDr) {
		Set $p(ret,..#FieldSeperator,20)=IRAntiCombinedMedDr.BTCode
	}else{
		Set $p(ret,..#FieldSeperator,20)=""
    }
    set $p(ret,..#FieldSeperator,21)=ObjCSS.IRAntiSenFlag
    set $p(ret,..#FieldSeperator,22)=""
    set $p(ret,..#FieldSeperator,23)=ObjCSS.IROperFlag
    set IROperCuteTypeDr=ObjCSS.IROperCuteTypeDr
    if $IsObject(IROperCuteTypeDr) {
            set IROperCuteTypeDesc=""
	    set IROperCuteTypeDesc=ObjCSS.IROperCuteTypeDr.BTCode
	    if (IROperCuteTypeDesc="99")||(IROperCuteTypeDesc="") set IROperCuteTypeDesc=0
	    Set $p(ret,..#FieldSeperator,24)=IROperCuteTypeDesc
		//Set $p(ret,..#FieldSeperator,24)=IROperCuteTypeDr.BTCode
	}else{
		Set $p(ret,..#FieldSeperator,24)=0
    }
	Set $p(ret,..#FieldSeperator,25)=""
	//set $p(ret,..#FieldSeperator,26)=
    Set $p(ret,..#FieldSeperator,27)=""
    

	
	Quit ret
}

/// 病原学检测1
/// w ##class(DHCHAI.MK.ExportToMKSrv).QryLabResultnew("大肠埃希菌",187)
ClassMethod BuildLabResultnew(objRep As DHCHAI.MK.INFReport) As %String
{
    New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
  
    set ExtID=$O(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," DHCHAI.IR.INFCSS",objRep.ReportID,"")) 
	set cssID=$list(^DHCHAI.IR.INFReportD(objRep.ReportID,"EXT",ExtID),3)
	set ObjCSS=##class(DHCHAI.IR.INFCSS).GetObjById(cssID)
	
	Quit:'$IsObject(ObjCSS) ret
	quit:(ObjCSS.IRInfPathogen1="")&&(ObjCSS.IRInfPathogen2="")&&(ObjCSS.IRInfPathogen3="") ret
	set (PosBTDesc1,BTBacDesc11,infBTDesc11,infdate1,BTBacDesc12,infBTDesc12,BTBacDesc13,infBTDesc13)=""
	set IRInfPathogen1=ObjCSS.IRInfPathogen1
	if IRInfPathogen1'="" {
		set infpos1=$p(IRInfPathogen1,"#",1)
		set:infpos1'="" PosBTDesc1=$list(^DHCHAI.BT.InfPosD(infpos1),3)
		Set:PosBTDesc1'="" PosBTDesc1=..GetMapping("MKInfPos",PosBTDesc1,PosBTDesc1,PosBTDesc1)
		set infBacteria11=$p(IRInfPathogen1,"#",2)
		set:infBacteria11'="" BTBacDesc11=$list(^DHCHAI.DP.LabBacteriaD(infBacteria11),3)
		set:BTBacDesc11'="" BTBacDesc11=..GetMapping("MKPathogeny",BTBacDesc11,BTBacDesc11,"")
		set infMDR11=$p(IRInfPathogen1,"#",3)
		set:infMDR11'="" infBTDesc11=$list(^DHCHAI.BT.DictionaryD(infMDR11),3)
		set infBTDesc11=$s(infBTDesc11="耐药":0,infBTDesc11="敏感":1,1:"")
		
		set infBacteria12=$p(IRInfPathogen1,"#",4)
		set:infBacteria12'="" BTBacDesc12=$list(^DHCHAI.DP.LabBacteriaD(infBacteria12),3)
		set:BTBacDesc12'="" BTBacDesc12=..GetMapping("MKPathogeny",BTBacDesc12,BTBacDesc12,"")
		
		set infMDR12=$p(IRInfPathogen1,"#",5)
		set:infMDR12'="" infBTDesc12=$list(^DHCHAI.BT.DictionaryD(infMDR12),3)
		set infBTDesc12=$s(infBTDesc12="耐药":0,infBTDesc12="敏感":1,1:"")
		
		set infBacteria13=$p(IRInfPathogen1,"#",6)
		set:infBacteria13'="" BTBacDesc13=$list(^DHCHAI.DP.LabBacteriaD(infBacteria13),3)
		set:BTBacDesc13'="" BTBacDesc13=..GetMapping("MKPathogeny",BTBacDesc13,BTBacDesc13,"")
		set infMDR13=$p(IRInfPathogen1,"#",7)
		set:infMDR13'="" infBTDesc13=$list(^DHCHAI.BT.DictionaryD(infMDR13),3)
		set infBTDesc13=$s(infBTDesc13="耐药":0,infBTDesc13="敏感":1,1:"")
		
		set infdate1=$p(IRInfPathogen1,"#",8)
		if BTBacDesc11'=""{
			set $p(tmp,..#FieldSeperator,1)=PosBTDesc1
			set $p(tmp,..#FieldSeperator,2)=BTBacDesc11
			set $p(tmp,..#FieldSeperator,4)=infBTDesc11
			set $p(tmp,..#FieldSeperator,3)=infdate1
			Set:ret'="" ret=ret_$c(2)
		    set ret=ret_tmp
		}
		if BTBacDesc12'=""{
			set tmp=""
			set $p(tmp,..#FieldSeperator,1)=PosBTDesc1
			set $p(tmp,..#FieldSeperator,2)=BTBacDesc12
			set $p(tmp,..#FieldSeperator,4)=infBTDesc12
			set $p(tmp,..#FieldSeperator,3)=infdate1
			Set:ret'="" ret=ret_$c(2)
		    set ret=ret_tmp
		}
		if BTBacDesc13'=""{
			set tmp=""
			set $p(tmp,..#FieldSeperator,1)=PosBTDesc1
			set $p(tmp,..#FieldSeperator,2)=BTBacDesc13
			set $p(tmp,..#FieldSeperator,4)=infBTDesc13
			set $p(tmp,..#FieldSeperator,3)=infdate1
			Set:ret'="" ret=ret_$c(2)
		    set ret=ret_tmp
		}
		 
	}
	
	set (PosBTDesc2,BTBacDesc21,infBTDesc21,infdate2,BTBacDesc22,infBTDesc22,BTBacDesc23,infBTDesc23)=""
	set IRInfPathogen2=ObjCSS.IRInfPathogen2
	if IRInfPathogen2'="" {
		set infpos2=$p(IRInfPathogen2,"#",1)
		set:infpos2'="" PosBTDesc2=$list(^DHCHAI.BT.InfPosD(infpos2),3)
		Set:PosBTDesc2'="" PosBTDesc2=..GetMapping("MKInfPos",PosBTDesc2,PosBTDesc2,PosBTDesc2)
		set infBacteria21=$p(IRInfPathogen2,"#",2)
		set:infBacteria21'="" BTBacDesc21=$list(^DHCHAI.DP.LabBacteriaD(infBacteria21),3)
		set:BTBacDesc21'="" BTBacDesc21=..GetMapping("MKPathogeny",BTBacDesc21,BTBacDesc21,"")
		set infMDR21=$p(IRInfPathogen2,"#",3)
		set:infMDR21'="" infBTDesc21=$list(^DHCHAI.BT.DictionaryD(infMDR21),3)
		set infBTDesc21=$s(infBTDesc21="耐药":0,infBTDesc21="敏感":1,1:"")
		
		set infBacteria22=$p(IRInfPathogen2,"#",4)
		set:infBacteria22'="" BTBacDesc22=$list(^DHCHAI.DP.LabBacteriaD(infBacteria22),3)
		set:BTBacDesc22'="" BTBacDesc22=..GetMapping("MKPathogeny",BTBacDesc22,BTBacDesc22,"")
		set infMDR22=$p(IRInfPathogen2,"#",5)
		set:infMDR22'="" infBTDesc22=$list(^DHCHAI.BT.DictionaryD(infMDR22),3)
		set infBTDesc22=$s(infBTDesc22="耐药":0,infBTDesc22="敏感":1,1:"")
		
		set infBacteria23=$p(IRInfPathogen2,"#",6)
		set:infBacteria23'="" BTBacDesc23=$list(^DHCHAI.DP.LabBacteriaD(infBacteria23),3)
		set:BTBacDesc23'="" BTBacDesc23=..GetMapping("MKPathogeny",BTBacDesc23,BTBacDesc23,"")
		set infMDR23=$p(IRInfPathogen2,"#",7)
		set:infMDR23'="" infBTDesc23=$list(^DHCHAI.BT.DictionaryD(infMDR23),3)
		set infBTDesc23=$s(infBTDesc23="耐药":0,infBTDesc23="敏感":1,1:"")
		
		set infdate2=$p(IRInfPathogen2,"#",8)
		if BTBacDesc21'=""{
			set tmp=""
			set $p(tmp,..#FieldSeperator,1)=PosBTDesc2
			set $p(tmp,..#FieldSeperator,2)=BTBacDesc21
			set $p(tmp,..#FieldSeperator,4)=infBTDesc21
			set $p(tmp,..#FieldSeperator,3)=infdate2
			Set:ret'="" ret=ret_$c(2)
		    set ret=ret_tmp
		}
		if BTBacDesc22'=""{
			set tmp=""
			set $p(tmp,..#FieldSeperator,1)=PosBTDesc2
			set $p(tmp,..#FieldSeperator,2)=BTBacDesc22
			set $p(tmp,..#FieldSeperator,4)=infBTDesc22
			set $p(tmp,..#FieldSeperator,3)=infdate2
			Set:ret'="" ret=ret_$c(2)
		    set ret=ret_tmp
		}
		if BTBacDesc23'=""{
			set tmp=""
			set $p(tmp,..#FieldSeperator,1)=PosBTDesc2
			set $p(tmp,..#FieldSeperator,2)=BTBacDesc23
			set $p(tmp,..#FieldSeperator,4)=infBTDesc23
			set $p(tmp,..#FieldSeperator,3)=infdate2
			Set:ret'="" ret=ret_$c(2)
		    set ret=ret_tmp
		}
		 
	}
	
	set (PosBTDesc3,BTBacDesc31,infBTDesc31,infdate3,BTBacDesc32,infBTDesc32,BTBacDesc33,infBTDesc33)=""
	set IRInfPathogen3=ObjCSS.IRInfPathogen3
	if IRInfPathogen3'="" {
		set infpos3=$p(IRInfPathogen3,"#",1)
		set:infpos3'="" PosBTDesc3=$list(^DHCHAI.BT.InfPosD(infpos3),3)
		Set:PosBTDesc3'="" PosBTDesc3=..GetMapping("MKInfPos",PosBTDesc3,PosBTDesc3,PosBTDesc3)
		set infBacteria31=$p(IRInfPathogen3,"#",2)
		set:infBacteria31'="" BTBacDesc31=$list(^DHCHAI.DP.LabBacteriaD(infBacteria31),3)
		set:BTBacDesc31'="" BTBacDesc31=..GetMapping("MKPathogeny",BTBacDesc31,BTBacDesc31,"")
		set infMDR31=$p(IRInfPathogen3,"#",3)
		set:infMDR31'="" infBTDesc31=$list(^DHCHAI.BT.DictionaryD(infMDR31),3)
		set infBTDesc31=$s(infBTDesc31="耐药":0,infBTDesc31="敏感":1,1:"")
		
		set infBacteria32=$p(IRInfPathogen3,"#",4)
		set:infBacteria32'="" BTBacDesc32=$list(^DHCHAI.DP.LabBacteriaD(infBacteria32),3)
		set:BTBacDesc32'="" BTBacDesc32=..GetMapping("MKPathogeny",BTBacDesc32,BTBacDesc32,"")
		set infMDR32=$p(IRInfPathogen3,"#",5)
		set:infMDR32'="" infBTDesc32=$list(^DHCHAI.BT.DictionaryD(infMDR32),3)
		set infBTDesc32=$s(infBTDesc32="耐药":0,infBTDesc32="敏感":1,1:"")
		
		set infBacteria33=$p(IRInfPathogen3,"#",6)
		set:infBacteria33'="" BTBacDesc33=$list(^DHCHAI.DP.LabBacteriaD(infBacteria33),3)
		set:BTBacDesc33'="" BTBacDesc33=..GetMapping("MKPathogeny",BTBacDesc33,BTBacDesc33,"")
		set infMDR33=$p(IRInfPathogen3,"#",7)
		set:infMDR33'="" infBTDesc33=$list(^DHCHAI.BT.DictionaryD(infMDR33),3)
		set infBTDesc33=$s(infBTDesc33="耐药":0,infBTDesc33="敏感":1,1:"")
		
		set infdate3=$p(IRInfPathogen3,"#",8)
		if BTBacDesc31'=""{
			set tmp=""
			set $p(tmp,..#FieldSeperator,1)=PosBTDesc3
			set $p(tmp,..#FieldSeperator,2)=BTBacDesc31
			set $p(tmp,..#FieldSeperator,4)=infBTDesc31
			set $p(tmp,..#FieldSeperator,3)=infdate3
			Set:ret'="" ret=ret_$c(2)
		    set ret=ret_tmp
		}
		if BTBacDesc32'=""{
			set tmp=""
			set $p(tmp,..#FieldSeperator,1)=PosBTDesc3
			set $p(tmp,..#FieldSeperator,2)=BTBacDesc32
			set $p(tmp,..#FieldSeperator,4)=infBTDesc32
			set $p(tmp,..#FieldSeperator,3)=infdate3
			Set:ret'="" ret=ret_$c(2)
		    set ret=ret_tmp
		}
		if BTBacDesc33'=""{
			set tmp=""
			set $p(tmp,..#FieldSeperator,1)=PosBTDesc3
			set $p(tmp,..#FieldSeperator,2)=BTBacDesc33
			set $p(tmp,..#FieldSeperator,4)=infBTDesc33
			set $p(tmp,..#FieldSeperator,3)=infdate3
			Set:ret'="" ret=ret_$c(2)
		  set ret=ret_tmp
		}
		 
	}
	quit ret
}

/// w ##class(DHCHAI.MK.ExportToMKSrv).QryLabResultnew("大肠埃希菌",187)
/// 病原学检测1
ClassMethod QryLabResultnew(IRBacteria As %String, ReportID As %String) As %String
{
	New (IRBacteria,ReportID)
	Set ret1=""
	Quit:(ReportID="")||(IRBacteria="") ret
	set ExtID=""
	for {
	set ExtID=$O(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," DHCHAI.IR.INFLAB",ReportID,ExtID))
	quit:ExtID=""
	;w ExtID,!
	set LabID=$list(^DHCHAI.IR.INFReportD(ReportID,"EXT",ExtID),3)
	set ObjLab=##class(DHCHAI.IR.INFLab).GetObjById(LabID)
	;b ;2222
	Continue:'$IsObject(ObjLab) 
	set IRPathogencode=""
	set IRBacteriadr=""
	for {
	 set IRBacteriadr=$O(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",LabID,IRBacteriadr))
	 quit:IRBacteriadr=""
	 set IRBacter=$list(^DHCHAI.DP.LabBacteriaD(IRBacteriadr),3)
	 ;b ;356
	 
	 if IRBacter=IRBacteria {
		 set IRPathogencode=ObjLab.IRPathogenTest.BTCode
		 //set ret=IRPathogencode
		 if IRPathogencode=1 set ret1=0
		 else  set ret1=1
		 } 
	}
	}
	Quit ret1
}

/// 基本诊断
ClassMethod BuildBaseDiagnosenew(objRep As DHCHAI.MK.INFReport) As %String
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
		//w objDia.DiagnosDesc_"^"_objDia.DiagnosICD,!
		Set:ret'="" ret=ret_$c(2)
		
		//基础疾病
		Set ICD10=objDia.DiagnosICD
		//b ;1233
		//set ret=ret_ICD10
		Set ret=ret_..GetMapping("MKDiagnos",objDia.DiagnosDesc,ICD10,ICD10)
	}
	
	Quit ret
}

}
