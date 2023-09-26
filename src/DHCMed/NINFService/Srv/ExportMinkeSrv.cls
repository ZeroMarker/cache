/// 导出到民科医院感染系统
/// 创建者：李阳
/// 创建日期:2012-12-15
Class DHCMed.NINFService.Srv.ExportMinkeSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 默认分隔符  <TAB>
Parameter FieldSeperator = "^";

/// 说明        :导出的主函数
/// 输入参数    ：
/// ReportID    :报告的ID
/// 返回值      :
/// 返回值格式  :返回代码_$c(1)_问题描述_$c(1)_具体记录
/// 返回值代码  :OK--没有问题
/// 			:Error--有问题，但能够导出
/// 			:Fail--致命错误，无法导出
/// w ##class(DHCMed.NINFService.Srv.ExportMinkeSrv).ExportReport(24)
ClassMethod ExportReport(ReportID As %String, ReportType As %String = "COMP") As %String
{
	New (ReportID,ReportType)
	Set return=""
	Quit:ReportID="" return
	
	Set objRep=##class(DHCMed.NINF.Srv.InfReport).GetObjById(ReportID,ReportType)
	Quit:'$IsObject(objRep) return
	
	Set $p(return,$c(1),1)=..BuildBaseInfo(objRep)        //病人基本信息
	Set $p(return,$c(1),2)=..BuildBaseDiagnose(objRep)    //基础疾病
	Set $p(return,$c(1),3)=..BuildOperation(objRep)       //手术情况
	Set $p(return,$c(1),4)=..BuildInfFactors(objRep)      //易感因素
	Set $p(return,$c(1),5)=..BuildInvasiveOpers(objRep)   //侵害性操作
	Set $p(return,$c(1),6)=..BuildInfPos(objRep)          //感染部位1
	Set $p(return,$c(1),7)=..BuildInfPosOpr(objRep)       //感染部位2
	Set $p(return,$c(1),8)=..BuildLabResult(objRep)       //病原学检测1
	Set $p(return,$c(1),9)=..BuildLabResultsPY(objRep)    //病原学检测2
	Set $p(return,$c(1),10)=..BuildLabResultsDrug(objRep) //病原学检测3
	Set $p(return,$c(1),11)=..BuildAnti(objRep)           //抗菌药物使用情况
	
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
	Set arryPos=objRep.GetInfPos(objRep.ReportID)
	Set objPos=arryPos.GetAt(1)
	//Quit:'$IsObject(objPos) ret
	
	Set objSumm=objRep.GetReportSumm(objRep.ReportID)
	Quit:'$IsObject(objSumm) ret
	
	//*调查表时间（发生院内感染的时间）
	if $IsObject(objPos) {
		Set $p(ret,..#FieldSeperator,1)=objPos.InfDate
	}
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
	If objRep.ReportType.Code="OPR" {
		Set $p(ret,..#FieldSeperator,23)=1
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

/// 手术信息
ClassMethod BuildOperation(objRep As DHCMed.NINF.Srv.InfReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	Set arry=objRep.GetOperations(objRep.ReportID)
	Set Cnt=arry.Count()
	For ind=1:1:Cnt {
		Set objOpe=arry.GetAt(ind)
		Continue:'$IsObject(objOpe)
		Continue:objOpe.OperationDesc=""
		
		Set:ret'="" ret=ret_$c(2)
		
		Set tmp=""
		//*手术名称
		Set ICD10=objOpe.OperationICD
		Set $p(tmp,..#FieldSeperator,1)=..GetMapping("MKOperation",objOpe.OperationDesc,ICD10,ICD10)
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
		//*麻醉方式
		Set objDic=objOpe.Anesthesia
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,6)=..GetMapping("MKAnesthesia",objDic.Code,objDic.Desc,objDic.Code)
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
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,10)=..GetMapping("MKOperInfType",objDic.Code,objDic.Desc,objDic.Desc)
		} Else {
			Set $p(tmp,..#FieldSeperator,10)=""
		}
		//引起院内感染
		Set objDic=objOpe.InHospInfFlag
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,11)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,11)=""
		}
		//感染日期
		Set $p(tmp,..#FieldSeperator,12)=""
		//切口个数
		Set $p(tmp,..#FieldSeperator,13)=+objOpe.CuteNumber
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
			Set $p(tmp,..#FieldSeperator,17)=..GetMapping("MKBoolean",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,17)=""
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
		
		Set ret=ret_tmp
	}	
	Quit ret
}

/// 易感因素
ClassMethod BuildInfFactors(objRep As DHCMed.NINF.Srv.InfReport) As %String
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
ClassMethod BuildInvasiveOpers(objRep As DHCMed.NINF.Srv.InfReport) As %String
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
ClassMethod BuildInfPos(objRep As DHCMed.NINF.Srv.InfReport) As %String
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
		
		Set tmp=""
		//*感染部位
		Set $p(tmp,..#FieldSeperator,1)=..GetMapping("MKInfPos",objPos.InfPos.Code,objPos.InfPos.Desc,objPos.InfPos.Desc)
		//*感染日期
		Set $p(tmp,..#FieldSeperator,2)=objPos.InfDate
		//*感染诊断
		Set $p(tmp,..#FieldSeperator,3)=..GetMapping("MKInfDiag",objPos.InfDiag.Code,objPos.InfDiag.Desc,objPos.InfDiag.Desc)
		
		Set ret=ret_tmp
	}
	Quit ret
}

/// 感染部位2 侵害性操作
ClassMethod BuildInfPosOpr(objRep As DHCMed.NINF.Srv.InfReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	
	Set arry=objRep.GetInfPos(objRep.ReportID)
	Set Cnt=arry.Count()
	For i=1:1:Cnt {
		Set objPos=arry.GetAt(i)
		Continue:'$IsObject(objPos)
		
		Set Cnt1=objPos.InfPosOpr.Count()
		For j=1:1:Cnt1 {
			Set obj=objPos.InfPosOpr.GetAt(j)
			Continue:'$IsObject(obj)
			
			Set:ret'="" ret=ret_$c(2)
			
			Set tmp=""
			//*感染部位
			Set $p(tmp,..#FieldSeperator,1)=..GetMapping("MKInfPos",objPos.InfPos.Code,objPos.InfPos.Desc,objPos.InfPos.Desc)
			//*感染日期
			Set $p(tmp,..#FieldSeperator,2)=objPos.InfDate
			//*侵害性操作
			Set $p(tmp,..#FieldSeperator,3)=..GetMapping("MKInvasiveOpers",obj.Code,obj.Desc,obj.Desc)
			
			Set ret=ret_tmp
		}
	}
	Quit ret
}

/// 病原学检测1
ClassMethod BuildLabResult(objRep As DHCMed.NINF.Srv.InfReport) As %String
{
	New (objRep)
	Set ret=""
	Quit:'$IsObject(objRep) ret
	Set arryPos=objRep.GetInfPos(objRep.ReportID)
	Set objPos=arryPos.GetAt(1)
	Set:'$IsObject(objPos) objPos=##class(DHCMed.NINF.Srv.InfReportInfPos).%New()
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
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,1)=..GetMapping("MKSpecimen",objDic.Code,objDic.Desc,objDic.Desc)
		} Else {
			Set $p(tmp,..#FieldSeperator,1)=""
		}
		//*感染部位
		Set objDic=objPos.InfPos
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,2)=..GetMapping("MKInfPos",objDic.Code,objDic.Desc,objDic.Desc)
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
ClassMethod BuildLabResultsPY(objRep As DHCMed.NINF.Srv.InfReport) As %String
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
ClassMethod BuildLabResultsDrug(objRep As DHCMed.NINF.Srv.InfReport) As %String
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
ClassMethod BuildAnti(objRep As DHCMed.NINF.Srv.InfReport)
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
		Continue:objAnti.ArcimID=""
		
		Set:ret'="" ret=ret_$c(2)
		
		Set tmp=""
		//*抗菌药物
		Set $p(tmp,..#FieldSeperator,1)=..GetMapping("MKOEAntibiotics",objAnti.ArcimID,objAnti.ArcimDesc,objAnti.ArcimDesc)
		//*给药途径
		Set objDic=objAnti.AdminRoute
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,2)=..GetMapping("MKAdminRoute",objDic.Code,objDic.Desc,objDic.Desc)
		} Else {
			Set $p(tmp,..#FieldSeperator,2)=0
		}
		//*用药起始时间
		Set $p(tmp,..#FieldSeperator,3)=objAnti.StartDate
		//用药截至时间
		Set $p(tmp,..#FieldSeperator,4)=objAnti.EndDate
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
		Set objDic=objAnti.PreMedIndicat
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,7)=..GetMapping("MKPreMedIndicat",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,7)=""
		}
		//预防用药效果
		Set objDic=objAnti.PreMedEffect
		If $IsObject(objDic) {
			Set $p(tmp,..#FieldSeperator,8)=..GetMapping("MKPreMedEffect",objDic.Code,objDic.Desc,objDic.Code)
		} Else {
			Set $p(tmp,..#FieldSeperator,8)=1
		}
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
		
		Set ret=ret_tmp
	}
	Quit ret
}

/// w ##class(DHCMed.NINFService.Srv.ExportMinkeSrv).ValidateReport(48)
ClassMethod ValidateReport(aReportID As %String, aRepType As %String = "COMP") As %String
{
	New (aReportID,aRepType)
	Set return=""
	Quit:aReportID="" return
	
	Set objRep=##class(DHCMed.NINF.Srv.InfReport).GetObjById(aReportID,aRepType)
	Quit:'$IsObject(objRep) return
	
	Set ErrorList=""
	Set tmp=..CheckReport(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
	Set tmp=..CheckReportDiag(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
	Set tmp=..CheckReportInfPos(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
	Set tmp=..CheckReportOper(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
	Set tmp=..CheckReportLab(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
	Set tmp=..CheckReportAnti(objRep)
	Set:tmp'="OK" ErrorList=ErrorList_tmp_$c(2)
	
	Set:ErrorList'="" return=$e(ErrorList,1,$l(ErrorList)-1)
	Set:ErrorList="" return="OK"
	
	Quit return
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
		//Set tmp=..IsMapping(objSumm.TransLoc.Code,objSumm.TransLoc.Desc,"MKHospLoc","感染科室无法对照")
		//Set:tmp'="OK" ret=ret_tmp_$c(2)
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

ClassMethod CheckReportDiag(objRep As DHCMed.NINF.Srv.InfReport) As %String
{
	New (objRep)
	Set ret=""
	
	Set arryDia=objRep.GetDiagnos(objRep.ReportID)
	Set Cnt=arryDia.Count()
	For indArr=1:1:Cnt {
		Set objDia=arryDia.GetAt(indArr)
		Continue:'$IsObject(objDia)
		Continue:objDia.DiagnosDesc=""
		
		Set tmp=..IsMapping(objDia.DiagnosDesc,objDia.DiagnosICD,"MKDiagnos","疾病诊断无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
	}
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	
	Quit ret
}

ClassMethod CheckReportInfPos(objRep As DHCMed.NINF.Srv.InfReport) As %String
{
	New (objRep)
	Set ret=""
	
	Set arry=objRep.GetInfPos(objRep.ReportID)
	Set Cnt=arry.Count()
	For indArr=1:1:Cnt {
		Set objPos=arry.GetAt(indArr)
		Continue:'$IsObject(objPos)
		
		Set tmp=..IsMapping(objPos.InfPos.Code,objPos.InfPos.Desc,"MKInfPos","感染部位无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objPos.InfDiag.Code,objPos.InfDiag.Desc,"MKInfDiag","感染诊断无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		
		Set Cnt1=objPos.InfPosOpr.Count()
		For indArr1=1:1:Cnt1 {
			Set objPosOpr=objPos.InfPosOpr.GetAt(indArr1)
			Continue:'$IsObject(objPosOpr)
			
			Set tmp=..IsMapping(objPosOpr.Code,objPosOpr.Desc,"MKInvasiveOpers","侵害性操作无法对照")
			Set:tmp'="OK" ret=ret_tmp_$c(2)
		}
	}
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	
	Quit ret
}

ClassMethod CheckReportOper(objRep As DHCMed.NINF.Srv.InfReport) As %String
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
	}
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	
	Quit ret
}

ClassMethod CheckReportLab(objRep As DHCMed.NINF.Srv.InfReport) As %String
{
	New (objRep)
	Set ret=""
	
	Set arry=objRep.GetLabResults(objRep.ReportID)
	Set Cnt=arry.Count()
	For indArr=1:1:Cnt {
		Set objLab=arry.GetAt(indArr)
		Continue:'$IsObject(objLab)
		
		Set tmp=..IsMapping(objLab.Specimen.Code,objLab.Specimen.Desc,"MKSpecimen","标本无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)	
		Set tmp=..IsMapping(objLab.InfectionPos.Code,objLab.InfectionPos.Desc,"MKInfPos","感染部位无法对照")
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

ClassMethod CheckReportAnti(objRep As DHCMed.NINF.Srv.InfReport) As %String
{
	New (objRep)
	Set ret=""
	
	Set arry=objRep.GetAnti(objRep.ReportID)
	Do arry.%Close()
	Set Cnt=arry.Count()
	For indArr=1:1:Cnt {
		Set objAnti=arry.GetAt(indArr)
		Continue:'$IsObject(objAnti)
		
		Set tmp=..IsMapping(objAnti.ArcimID,objAnti.ArcimDesc,"MKOEAntibiotics","抗生素医嘱无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objAnti.AdminRoute.Code,objAnti.AdminRoute.Desc,"MKAdminRoute","给药途径无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objAnti.MedPurpose.Code,objAnti.MedPurpose.Desc,"MKMedPurpose","用药目的无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objAnti.TreatmentMode.Code,objAnti.TreatmentMode.Desc,"MKTreatmentMode","治疗用药方式无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objAnti.PreMedIndicat.Code,objAnti.PreMedIndicat.Desc,"MKPreMedIndicat","预防用药指征无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objAnti.PreMedEffect.Code,objAnti.PreMedEffect.Desc,"MKPreMedEffect","预防用药效果无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
		Set tmp=..IsMapping(objAnti.CombinedMed.Code,objAnti.CombinedMed.Desc,"MKCombinedMed","联合用药无法对照")
		Set:tmp'="OK" ret=ret_tmp_$c(2)
	}	
	Set:ret'="" ret=$e(ret,1,$l(ret)-1)
	Set:ret="" ret="OK"
	
	Quit ret
}

/// 判断是否已对照民科字典
/// 如果已对照，返回值 return="OK"
/// 如果未对照，返回值 return="ERROR^"_{对照字典类别}_"^"_{错误信息}_"^"_{源值}_"^"_{源值描述}
ClassMethod IsMapping(aSrcValue As %String, aSrcDesc As %String, aMappingType As %String, aErrorMsg As %String)
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

/// 取对照民科字典值，取之为空返回默认值
ClassMethod GetMapping(aMappingType As %String, aSrcValue As %String, aSrcDesc As %String, aDefaultValue As %String = "") As %String
{
	New (aMappingType,aSrcValue,aSrcDesc,aDefaultValue)
	Set return=""
	Quit:(aMappingType="")||(aSrcValue="") return
	
	//存储数据时，把空格都替换掉了
	Set aSrcValue=$tr(aSrcValue," ","")
	
	Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("INFMinkeMappingType",aMappingType,"")
	Quit:'$IsObject(objDic) return
	Set TargetField=objDic.StrC
	Set:TargetField="" TargetField="Target"
	
	Set aSrcValue=##Class(DHCMed.NINFService.Srv.CommonCls).Trim(aSrcValue)  //处理前后空格
	Set objMap=##class(DHCMed.NINF.Srv.MKDicMapping).GetMappingData(aMappingType,aSrcValue)
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
	
	If return="空" {
		Set return=""
	} Else {
		Set:return="" return=aDefaultValue             //默认值
	}
	Quit return
}

ClassMethod GetMinkeDic(MainCode As %String, Code As %String, Desc As %String) As DHCMed.NINF.Srv.MKDictionary
{
	New (MainCode,Code,Desc)
	Set ret=""
	Quit:MainCode="" ret
	
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.NINFSi("MKDic",0,"IndexCode"," "_$ZConvert(Code,"U"),RowID))
		Quit:RowID=""
		Quit:ret'=""
		
		Set obj=##class(DHCMed.NINF.Srv.MKDictionary).GetObjById(RowID)
		Continue:'$IsObject(obj)
		Continue:obj.IDCode'[MainCode
		
		Set ret=obj
	}
	
	If '$IsObject(ret) {
		Set RowID=""
		For {
			Set RowID=$o(^DHCMed.NINFSi("MKDic",0,"IndexDesc"," "_$ZConvert(Desc,"U"),RowID))
			Quit:RowID=""
			Quit:ret'=""
			
			Set obj=##class(DHCMed.NINF.Srv.MKDictionary).GetObjById(RowID)
			Continue:'$IsObject(obj)
			Continue:obj.IDCode'[MainCode
			
			Set ret=obj
		}
	}
	
	Quit ret
}

/// 查询医院感染报告校验信息
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Srv.ExportMinkeSrv","QryValidateInfo","5^13^14^22^23^24","^")
Query QryValidateInfo(aReportList As %String, aDelimiter As %String = "^", aRepType As %String = "COMP") As %Query(ROWSPEC = "Index:%String,ID:%String,SrcValue:%String,SrcDesc:%String,TargetValue:%String,TargetDesc:%String,ResumeText:%String,MappingTypeCode:%String,MappingTypeDesc:%String,MapDicGroupCode:%String,MapDicTypeCode:%String")
{
}

ClassMethod QryValidateInfoExecute(ByRef qHandle As %Binary, aReportList As %String, aDelimiter As %String = "^", aRepType As %String = "COMP") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set NIndex="QryValidateInfo"
 	Kill ^TMP($zn,$j,NIndex)
 	
 	For indRep=1:1:$l(aReportList,aDelimiter) {
 		Set ReportID=$p(aReportList,aDelimiter,indRep)
 		Continue:ReportID=""
 		
 		Set flg=..ValidateReport(ReportID,aRepType)
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
