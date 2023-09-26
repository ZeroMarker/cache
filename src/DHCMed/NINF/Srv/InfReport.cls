/// 名称: DHCMed.NINF.Srv.InfReport
/// 描述: 感染监测 对外接口
/// 编写者：zhufei
/// 编写日期: 2012-08-07
Class DHCMed.NINF.Srv.InfReport Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 基本信息ID
Property PatientID As %String(TRUNCATE = 1);

/// 感染报告ID
Property ReportID As %String(TRUNCATE = 1);

/// 报告类型
Property ReportType As DHCMed.NINF.Srv.Dictionary;

/// 报告人员 指向SS_User
Property ReportUser As DHCMed.NINF.Srv.Dictionary;

/// 报告状态
Property ReportStatus As DHCMed.NINF.Srv.Dictionary;

/// 报告日期
Property ReportDate As %String(TRUNCATE = 1);

/// 报告时间
Property ReportTime As %String(TRUNCATE = 1);

/// 报告科室
Property ReportLoc As DHCMed.NINF.Srv.Dictionary;

/// 报告病区
Property ReportWard As DHCMed.NINF.Srv.Dictionary;

/// 入科来源（转入科室/入院）
Property FromPlace As DHCMed.NINF.Srv.Dictionary;

/// 出科去向（转出科室/出院）
Property ToPlace As DHCMed.NINF.Srv.Dictionary;

/// 转入日期
Property InICUDate As %String;

/// 转出日期
Property OutICUDate As %String;

/// Creator：     zhufei
/// CreatDate：   2012-08-07
/// Description:  根据就诊号取【感染报告】接口
/// Table：       DHCMed.NINF.Srv.InfReport
/// Input：       EpisodeID 就诊号
/// Return：      返回%List
/// w ##class(DHCMed.NINF.Srv.InfReport).GetInfRepByAdm(60798)
ClassMethod GetInfRepByAdm(aEpisodeID As %String, aReportType As %String = "COMP", aDateFrom As %String = "", aDateTo As %String = "", aRepLoc As %String = "", aRepStatus As %String = "") As %ListOfObjects
{
	New (aEpisodeID,aReportType,aDateFrom,aDateTo,aRepLoc,aRepStatus)
	Set return=##class(%Library.ListOfObjects).%New()
	Quit:(aEpisodeID="") return
	
	Set xRepID=0
	For {
		Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",aEpisodeID,xRepID))
		Quit:xRepID=""
		
		//取报告对象
		//数据来源：DHCMed.NINF.Rep.InfReport
		Set objXRep=..GetObjById(xRepID,aReportType)
		Continue:objXRep=""
		
		//Do $system.OBJ.Dump(objXRep)
		Do return.Insert(objXRep)
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-08-07
/// Description:  根据报告ID取【医院感染报告】接口
/// Table：       
/// Input：       ReportID 报告ID
/// Return：      返回%List
/// w ##class(DHCMed.NINF.Srv.InfReport).GetObjById()
ClassMethod GetObjById(aReportID As %String, aReportType As %String = "COMP") As DHCMed.NINF.Srv.InfReport
{
	New (aReportID,aReportType)
	Set return=""
	
	//感染报告
	Set objRep=##class(DHCMed.NINF.Rep.InfReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.ReportType) return
	
	Set ReportID=objRep.%Id()
	Set RepTypeCode=objRep.ReportType.Code
	Set RepTypeDesc=objRep.ReportType.Description
	Quit:(aReportType'="")&&(RepTypeCode'=aReportType) return
	Quit:'$IsObject(objRep.ReportStatus) return
	Set RepStatusCode=objRep.ReportStatus.Code
	Set RepStatusDesc=objRep.ReportStatus.Description
	Quit:RepStatusDesc["删除" return
	Set EpisodeID=objRep.EpisodeID
	Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
	Set ReportDate=objRep.ReportDate
	Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set ReportTime=objRep.ReportTime
	Set:ReportTime'="" ReportTime=$zt(ReportTime,2)
	Set ReportLoc=objRep.ReportLoc
	Set RepLocCode="",RepLocDesc=""
	Set RepWardCode="",RepWardDesc=""
	If ReportLoc'="" {
		Set RepLocCode=$p($g(^CTLOC(ReportLoc)),"^",1)
		Set RepLocCode=$tr(RepLocCode," ","")
		Set RepLocDesc=$p($g(^CTLOC(ReportLoc)),"^",2)
		Set RepLocDesc=$tr(RepLocDesc," ","")
		
		//取科室对应病区
		Set TransID=0
		For {
			Set TransID=$o(^PAADM(EpisodeID,"TRANS",TransID))
			Quit:TransID=""
			
			Set tmpTrans=$g(^PAADM(EpisodeID,"TRANS",TransID))
			Continue:tmpTrans=""
			Set TransWard=$p($p(tmpTrans,"^",8),"||",1)
			Set:TransWard'="" TransWard=$p($g(^PAWARD(TransWard)),"^",5)
			Continue:TransWard=""
			Continue:'$d(^CTLOC(ReportLoc,"LINK",0,"Loc",TransWard))
			Set RepWardCode=$p($g(^CTLOC(TransWard)),"^",1)
			Set RepWardDesc=$p($g(^CTLOC(TransWard)),"^",2)
		}
	}
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(objRep.ReportUser)
	If $IsObject(objRepUser){
		Set RepUserCode=objRepUser.Code
		Set RepUserName=objRepUser.Name
	} Else {
		Set RepUserCode=""
		Set RepUserName=""
	}
	
	Set objXRep=##Class(DHCMed.NINF.Srv.InfReport).%New()
	Quit:'$IsObject(objXRep) return
	
	Set objXRep.EpisodeID=EpisodeID
	Set objXRep.PatientID=PatientID
	Set objXRep.ReportID=ReportID
	Set objXRep.ReportType=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(RepTypeCode_"^"_RepTypeDesc)
	Set objXRep.ReportStatus=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(RepStatusCode_"^"_RepStatusDesc)
	Set objXRep.ReportUser=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(RepUserCode_"^"_RepUserName)
	Set objXRep.ReportDate=ReportDate
	Set objXRep.ReportTime=ReportTime
	Set objXRep.ReportLoc=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(RepLocCode_"^"_RepLocDesc)
	Set objXRep.ReportWard=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(RepWardCode_"^"_RepWardDesc)
	
	If objXRep'="" Do objXRep.%Close()
	
	Set return=objXRep
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-08-07
/// Description:  根据报告ID取【疾病诊断】接口
/// Table：       
/// Input：       ReportID 报告ID
/// Return：      返回%List
/// s obj=##class(DHCMed.NINF.Srv.InfReport).%New()
/// w obj.GetDiagnos(1)
Method GetDiagnos(aReportID As %String, aReportType As %String = "COMP") As %ListOfObjects
{
	New (aReportID,aReportType)
	Set return=##class(%Library.ListOfObjects).%New()
	Quit:(aReportID="") return
	
	Set xSubID=0
	For {
		Set xSubID=$o(^DHCMed.NINF("InfRep",aReportID,"Diag",xSubID))
		Quit:xSubID=""
		
		Set objDiag=##class(DHCMed.NINF.Rep.InfReportDiag).GetObjById(aReportID_"||"_xSubID)
		Continue:'$IsObject(objDiag)
		Continue:objDiag.DiagnosDesc=""
		
		Set objXDiag=##Class(DHCMed.NINF.Srv.InfReportDiag).%New()
		If $IsObject(objXDiag) {
			//诊断ID  指向MRC_ICDDx
			Set DiagnosID=objDiag.DiagnosID
			Set objXDiag.DiagnosID=DiagnosID
			//诊断ICD10
			Set DiagnosICD=$p($g(^MRC("ID",+DiagnosID)),"^",4)
			Set objXDiag.DiagnosICD=DiagnosICD
			//诊断名称
			Set objXDiag.DiagnosDesc=objDiag.DiagnosDesc
			//下诊断日期
			Set DiagnosDate=objDiag.DiagnosDate
			Set:DiagnosDate'="" DiagnosDate=$zd(DiagnosDate,3)
			Set objXDiag.DiagnosDate=DiagnosDate
			//下诊断时间
			Set DiagnosTime=objDiag.DiagnosTime
			Set:DiagnosTime'="" DiagnosTime=$zt(DiagnosTime,2)
			Set objXDiag.DiagnosTime=DiagnosTime
			
			//Do $system.OBJ.Dump(objXDiag)
			Do return.Insert(objXDiag)
		}
		If objXDiag'="" Do objXDiag.%Close()
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-08-07
/// Description:  根据报告ID取【感染部位信息】接口
/// Table：       
/// Input：       ReportID 报告ID
/// Return：      返回%List
/// s obj=##class(DHCMed.NINF.Srv.InfReport).%New()
/// w obj.GetInfPos(1)
Method GetInfPos(aReportID As %String, aReportType As %String = "COMP") As %ListOfObjects
{
	New (aReportID,aReportType)
	Set return=##class(%ListOfObjects).%New()
	Quit:(aReportID="") return
	
	Set xSubID=0
	For {
		Set xSubID=$o(^DHCMed.NINF("InfRep",aReportID,"InfPos",xSubID))
		Quit:xSubID=""
		
		Set objInfPos=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(aReportID_"||"_xSubID)
		Continue:'$IsObject(objInfPos)
		Continue:'$IsObject(objInfPos.InfPos)
		
		Set objXInfPos=##Class(DHCMed.NINF.Srv.InfReportInfPos).%New()
		If $IsObject(objXInfPos) {
			//感染部位
			If $IsObject(objInfPos.InfPos) {
				Set Code=objInfPos.InfPos.IPCode
				Set Desc=objInfPos.InfPos.IPDesc
				Set objXInfPos.InfPos=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//感染日期
			Set InfDate=objInfPos.InfDate
			Set:InfDate'="" InfDate=$zd(InfDate,3)
			Set objXInfPos.InfDate=InfDate
			//感染诊断
			If $IsObject(objInfPos.InfDiag) {
				Set Code=objInfPos.InfDiag.IDCode
				Set Desc=objInfPos.InfDiag.IDDesc
				Set objXInfPos.InfDiag=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//侵害性操作
			For ind=1:1:objInfPos.InfPosOpr.Count() {
				Set objInfPosOpr=objInfPos.InfPosOpr.GetAt(ind)
				Continue:'$IsObject(objInfPosOpr)
				Continue:'$IsObject(objInfPosOpr.InvasiveOper)
				Set Code=objInfPosOpr.InvasiveOper.Code
				Set Desc=objInfPosOpr.InvasiveOper.Description
				Set objXDic=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
				Continue:'$IsObject(objXDic)
				Do objXInfPos.InfPosOpr.Insert(objXDic)
			}
			
			//Add By LiYang 2013-05-23
			//加入感染结果，截止日期
			Set objXInfPos.InfEndDate=""
			Set:objInfPos.InfEndDate'="" objXInfPos.InfEndDate=$zd(objInfPos.InfEndDate,3)
			If $IsObject(objInfPos.InfEndResult) {
				Set Code=objInfPos.InfEndResult.Code
				Set Desc=objInfPos.InfEndResult.Description
				Set objXInfPos.InfEndResult=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}			 
			
			//Do $system.OBJ.Dump(objXInfPos)
			Do return.Insert(objXInfPos)
		}
		If objXInfPos'="" Do objXInfPos.%Close()
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-08-07
/// Description:  根据报告ID取【手术信息】接口
/// Table：       
/// Input：       ReportID 报告ID
/// Return：      返回%List
/// s obj=##class(DHCMed.NINF.Srv.InfReport).%New()
/// w obj.GetOperations(1)
Method GetOperations(aReportID As %String, aReportType As %String = "COMP") As %ListOfObjects
{
	New (aReportID,aReportType)
	Set return=##class(%ListOfObjects).%New()
	Quit:(aReportID="") return
	
	Set xSubID=0
	For {
		Set xSubID=$o(^DHCMed.NINF("InfRep",aReportID,"Opr",xSubID))
		Quit:xSubID=""
		
		Set objOpr=##class(DHCMed.NINF.Rep.InfReportOpr).GetObjById(aReportID_"||"_xSubID)
		Continue:'$IsObject(objOpr)
		Continue:objOpr.OperationDesc=""
		
		Set objXOpr=##Class(DHCMed.NINF.Srv.InfReportOpr).%New()
		If $IsObject(objXOpr) {
			//手术ID 指向ORC_Operation
			Set OperationID=objOpr.OperationID
			Set objXOpr.OperationID=OperationID
			//手术ICD
			Set OperationICD=$p($g(^ORC("OPER",+OperationID)),"^",21)
			Set objXOpr.OperationICD=OperationICD
			//手术名称
			Set objXOpr.OperationDesc=objOpr.OperationDesc
			//手术开始日期
			Set OperStartDate=objOpr.OperStartDate
			Set:OperStartDate'="" OperStartDate=$zd(OperStartDate,3)
			Set objXOpr.OperStartDate=OperStartDate  
			//手术开始时间
			Set OperStartTime=objOpr.OperStartTime
			Set:OperStartTime'="" OperStartTime=$zt(OperStartTime,2)
			Set objXOpr.OperStartTime=OperStartTime 
			//手术结束日期
			Set OperEndDate=objOpr.OperEndDate
			Set:OperEndDate'="" OperEndDate=$zd(OperEndDate,3)
			Set objXOpr.OperEndDate=OperEndDate
			//手术结束时间
			Set OperEndTime=objOpr.OperEndTime
			Set:OperEndTime'="" OperEndTime=$zt(OperEndTime,2)
			Set objXOpr.OperEndTime=OperEndTime
			//手术医生
			Set OperDocID=objOpr.OperDoc
			If OperDocID'="" {
				Set Code=$p($g(^SSU("SSUSR",+OperDocID)),"^",1)
				Set Desc=$p($g(^SSU("SSUSR",+OperDocID)),"^",2)
				Set objXOpr.OperDoc=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//手术类型
			If $IsObject(objOpr.OperationType) {
				Set Code=objOpr.OperationType.Code
				Set Desc=objOpr.OperationType.Description
				Set objXOpr.OperationType=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//麻醉方式
			If $IsObject(objOpr.Anesthesia) {
				Set Code=objOpr.Anesthesia.Code
				Set Desc=objOpr.Anesthesia.Description
				Set objXOpr.Anesthesia=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//切口类型
			If $IsObject(objOpr.CuteType) {
				Set Code=objOpr.CuteType.Code
				Set Desc=objOpr.CuteType.Description
				Set objXOpr.CuteType=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//愈合情况
			If $IsObject(objOpr.CuteHealing) {
				Set Code=objOpr.CuteHealing.Code
				Set Desc=objOpr.CuteHealing.Description
				Set objXOpr.CuteHealing=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//是否切口感染
			If $IsObject(objOpr.CuteInfFlag) {
				Set Code=objOpr.CuteInfFlag.Code
				Set Desc=objOpr.CuteInfFlag.Description
				Set objXOpr.CuteInfFlag=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//手术感染类型
			If $IsObject(objOpr.OperInfType) {
				Set Code=objOpr.OperInfType.Code
				Set Desc=objOpr.OperInfType.Description
				Set objXOpr.OperInfType=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//是否引起院内感染
			If $IsObject(objOpr.InHospInfFlag) {
				Set Code=objOpr.InHospInfFlag.Code
				Set Desc=objOpr.InHospInfFlag.Description
				Set objXOpr.InHospInfFlag=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//ASA(麻醉)评分
			If $IsObject(objOpr.ASAScore) {
				Set Code=objOpr.ASAScore.Code
				Set Desc=objOpr.ASAScore.Description
				Set objXOpr.ASAScore=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//术前外周WBC计数(×10^9/L)
			Set objXOpr.PreoperWBC=objOpr.PreoperWBC
			//切口个数
			Set objXOpr.CuteNumber=+objOpr.CuteNumber.Description
			//使用窥镜
			If $IsObject(objOpr.EndoscopeFlag) {
				Set Code=objOpr.EndoscopeFlag.Code
				Set Desc=objOpr.EndoscopeFlag.Description
				Set objXOpr.EndoscopeFlag=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//植入物
			If $IsObject(objOpr.ImplantFlag) {
				Set Code=objOpr.ImplantFlag.Code
				Set Desc=objOpr.ImplantFlag.Description
				Set objXOpr.ImplantFlag=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//术前口服抗生素肠道准备
			If $IsObject(objOpr.PreoperAntiFlag) {
				Set Code=objOpr.PreoperAntiFlag.Code
				Set Desc=objOpr.PreoperAntiFlag.Description
				Set objXOpr.PreoperAntiFlag=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//失血
			If $IsObject(objOpr.BloodLossFlag) {
				Set Code=objOpr.BloodLossFlag.Code
				Set Desc=objOpr.BloodLossFlag.Description
				Set objXOpr.BloodLossFlag=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//失血量(MLS)
			Set objXOpr.BloodLoss=objOpr.BloodLoss
			//输血
			If $IsObject(objOpr.BloodTransFlag) {
				Set Code=objOpr.BloodTransFlag.Code
				Set Desc=objOpr.BloodTransFlag.Description
				Set objXOpr.BloodTransFlag=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//输血量(MLS)
			Set objXOpr.BloodTrans=objOpr.BloodTrans
			//术后并发症
			For ind=1:1:objOpr.PostoperComps.Count() {
				Set objDic=objOpr.PostoperComps.GetAt(ind)
				Continue:'$IsObject(objDic)
				
				Set Code=objDic.Code
				Set Desc=objDic.Description
				Set objXDic=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
				Continue:'$IsObject(objXDic)
				Do objXOpr.PostoperComps.Insert(objXDic)
			}
			
			//Do $system.OBJ.Dump(objXOpr)
			Do return.Insert(objXOpr)
		}
		If objXOpr'="" Do objXOpr.%Close()
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-08-07
/// Description:  根据报告ID取【检验信息】接口
/// Table：       
/// Input：       ReportID 报告ID
/// Return：      返回%List
/// s obj=##class(DHCMed.NINF.Srv.InfReport).%New()
/// w obj.GetLabResults(1)
Method GetLabResults(aReportID As %String, aReportType As %String = "COMP") As %ListOfObjects
{
	New (aReportID,aReportType)
	Set return=##class(%ListOfObjects).%New()
	Quit:(aReportID="") return
	
	Set xSubID=0
	For {
		Set xSubID=$o(^DHCMed.NINF("InfRep",aReportID,"Lab",xSubID))
		Quit:xSubID=""
		
		Set objLab=##class(DHCMed.NINF.Rep.InfReportLab).GetObjById(aReportID_"||"_xSubID)
		Continue:'$IsObject(objLab)
		Continue:'$IsObject(objLab.Specimen)&&'$IsObject(objLab.InfectionPos)
		
		Set objXLab=##Class(DHCMed.NINF.Srv.InfReportLab).%New()
		If $IsObject(objXLab) {
			//标本
			If $IsObject(objLab.Specimen) {
				Set Code=objLab.Specimen.Code
				Set Desc=objLab.Specimen.Description
				Set objXLab.Specimen=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//感染部位
			If $IsObject(objLab.InfectionPos) {
				Set Code=objLab.InfectionPos.IPCode
				Set Desc=objLab.InfectionPos.IPDesc
				Set objXLab.InfectionPos=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//送检日期
			Set SubmissionDate=objLab.SubmissionDate
			Set:SubmissionDate'="" SubmissionDate=$zd(SubmissionDate,3)
			Set objXLab.SubmissionDate=SubmissionDate
			//检验方法
			If $IsObject(objLab.AssayMethod) {
				Set Code=objLab.AssayMethod.Code
				Set Desc=objLab.AssayMethod.Description
				Set objXLab.AssayMethod=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//检验结果
			If $IsObject(objLab.PathogenTest) {
				Set Code=objLab.PathogenTest.Code
				Set Desc=objLab.PathogenTest.Description
				Set objXLab.PathogenTest=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			//细菌培养+药敏结果
			For indTestRst=1:1:objLab.TestResults.Count() {
				Set objTestRst=objLab.TestResults.GetAt(indTestRst)
				Continue:'$IsObject(objTestRst)
				Continue:objTestRst.PathogenyDesc=""
				
				Set objXLabPy=##Class(DHCMed.NINF.Srv.InfReportLabPy).%New()
				If $IsObject(objXLabPy) {
					//细菌培养
					Set PathogenyID=objTestRst.PathogenyID
					Set objPy=##class(DHCMed.NINF.Dic.Pathogeny).GetObjById(PathogenyID)
					If $IsObject(objPy) {
						Set objXLabPy.PathogenyID=objPy.%Id()
						Set objXLabPy.PathogenyDesc=objPy.PYDesc
						Set objXLabPy.PathogenyDesc1=objPy.PYDesc1
					} Else {
						Set objXLabPy.PathogenyDesc=objTestRst.PathogenyDesc
						//Set objXLabPy.PathogenyDesc=##class(DHCMed.NINF.Rep.InfReportLabPy).GetPathogenyDesc("",objTestRst.PathogenyDesc,objTestRst.DrugSenTest)
					}
					//药敏结果
					For indSenTest=1:1:objTestRst.DrugSenTest.Count() {
						Set objSenTest=objTestRst.DrugSenTest.GetAt(indSenTest)
						Continue:'$IsObject(objSenTest)
						Continue:objSenTest.AntibioticsDesc=""
						
						Set objXLabPyAnti=##Class(DHCMed.NINF.Srv.InfReportLabPyAnti).%New()
						If $IsObject(objXLabPyAnti) {
							Set AntibioticsID=objSenTest.AntibioticsID
							Set objAnti=##class(DHCMed.NINF.Dic.Antibiotics).GetObjById(AntibioticsID)
							If $IsObject(objAnti) {
								Set objXLabPyAnti.AntibioticsID=objAnti.%Id()
								Set objXLabPyAnti.AntibioticsDesc=objAnti.ANTDesc
								Set objXLabPyAnti.AntibioticsDesc1=objAnti.ANTDesc1
							} Else {
								Set objXLabPyAnti.AntibioticsDesc=objSenTest.AntibioticsDesc
							}
							Set objXLabPyAnti.SenTestRst=##class(DHCMed.NINF.Srv.Dictionary).GetDicObj(objSenTest.SenTestRst.Code_"^"_objSenTest.SenTestRst.Description)
							//Do $System.OBJ.Dump(objXLabPy)
							Do objXLabPy.DrugSenTest.Insert(objXLabPyAnti)
						}
						If objXLabPyAnti'="" Do objXLabPyAnti.%Close()
					}
					
					//Do $System.OBJ.Dump(objXLabPy)
					Do objXLab.TestResults.Insert(objXLabPy)
				}
				If objXLabPy'="" Do objXLabPy.%Close()
			}
			
			//Do $System.OBJ.Dump(objXLab)
			Do return.Insert(objXLab)
		}
		If objXLab'="" Do objXLab.%Close()
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-06-17
/// Description:  根据报告ID取【抗菌用药信息】接口
/// Table：       
/// Input：       ReportID 报告ID
/// Return：      返回%List
/// s obj=##class(DHCMed.NINF.Srv.InfReport).%New()
/// w obj.GetAnti(1)
Method GetAnti(aReportID As %String, aReportType As %String = "COMP") As %ListOfObjects
{
	New (aReportID,aReportType)
	Set return=##class(%ListOfObjects).%New()
	Quit:(aReportID="") return
	
	Set ChildSub=""
	For {
		Set ChildSub=$o(^DHCMed.NINF("InfRep",aReportID,"Anti",ChildSub))
		Quit:ChildSub=""
		
		Set objAnti=##class(DHCMed.NINF.Rep.InfReportAnti).GetObjById(aReportID_"||"_ChildSub)
		Continue:'$IsObject(objAnti)
		Continue:objAnti.ArcimDesc=""
		
		Set objXAnti=##class(DHCMed.NINF.Srv.InfReportAnti).%New()
		If $IsObject(objXAnti) {
			//医嘱项ID
			Set objXAnti.ArcimID=objAnti.ArcimID
			//医嘱名称
			Set objXAnti.ArcimDesc=objAnti.ArcimDesc
			//开始时间、结束时间数据校验
			If (objAnti.StartDate'="")&&(objAnti.EndDate'="") {
				If objAnti.EndDate<objAnti.StartDate {
					Set objAnti.EndDate=objAnti.StartDate
				}
			} ElseIf objAnti.EndDate="" {
				Set objAnti.EndDate=objAnti.StartDate
			} Else {
				//开始日期、结束日期都为空
			}
			//开始时间
			Set objXAnti.StartDate=$zd(objAnti.StartDate,3)
			//结束时间
			Set objXAnti.EndDate=$zd(objAnti.EndDate,3)
			//给药途径
			Set objXAnti.AdminRoute=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(objAnti.AdminRoute.Code_"^"_objAnti.AdminRoute.Description) 
			//目的
			Set objXAnti.MedPurpose=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(objAnti.MedPurpose.Code_"^"_objAnti.MedPurpose.Description) 
			// 治疗用药方式
			Set objXAnti.TreatmentMode=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(objAnti.TreatmentMode.Code_"^"_objAnti.TreatmentMode.Description)
			// 预防用药指征
			Set objXAnti.PreMedIndicat=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(objAnti.PreMedIndicat.Code_"^"_objAnti.PreMedIndicat.Description)
			// 预防用药效果
			Set objXAnti.PreMedEffect=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(objAnti.PreMedEffect.Code_"^"_objAnti.PreMedEffect.Description)
			// 联合用药
			Set objXAnti.CombinedMed=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(objAnti.CombinedMed.Code_"^"_objAnti.CombinedMed.Description)
			// 术前用药时间(分钟)
			Set objXAnti.PreMedTime=objAnti.PreMedTime
			// 术后用药天数(天)
			Set objXAnti.PostMedDays=+objAnti.PostMedDays
			
			//Do $System.OBJ.Dump(objXAnti)
			Do return.Insert(objXAnti)
		}
		If objXAnti'="" Do objXAnti.%Close()
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-06-17
/// Description:  根据报告ID取【摘要信息】接口
/// Table：       
/// Input：       ReportID 报告ID
/// Return：      返回%List
/// s obj=##class(DHCMed.NINF.Srv.InfReport).%New()
/// w obj.GetReportSumm(24)
ClassMethod GetReportSumm(aReportID As %String, aReportType As %String = "COMP") As DHCMed.NINF.Srv.InfReportSumm
{
	New (aReportID,aReportType)
	Set return=""
	Quit:aReportID="" return
	
	Set SummID=$o(^DHCMed.NINF("InfRep",aReportID,"Summ",0))
	Set objSumm=##class(DHCMed.NINF.Rep.InfReportSumm).GetObjById(aReportID_"||"_SummID)
	Quit:'$IsObject(objSumm) return
	
	Set objXSum=##class(DHCMed.NINF.Srv.InfReportSumm).%New()
	If $IsObject(objXSum) {
		//疾病转归
		If $IsObject(objSumm.DiseasePrognosis) {
			Set Code=objSumm.DiseasePrognosis.Code
			Set Desc=objSumm.DiseasePrognosis.Description
			Set objXSum.DiseasePrognosis=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
		}
		//与死亡关系
		If $IsObject(objSumm.DeathRelation) {
			Set Code=objSumm.DeathRelation.Code
			Set Desc=objSumm.DeathRelation.Description
			Set objXSum.DeathRelation=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
		}
		// 诊断依据
		Set objXSum.DiagnosisBasis=objSumm.DiagnosisBasis
		// 感染性疾病病程
		Set objXSum.DiseaseCourse=objSumm.DiseaseCourse
		//易感因素
		For ind=1:1:objSumm.InfFactors.Count() {
			Set objDic=objSumm.InfFactors.GetAt(ind)
			Continue:'$IsObject(objDic)
			
			Set Code=objDic.Code
			Set Desc=objDic.Description
			Set objXDic=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			Continue:'$IsObject(objXDic)
			Do objXSum.InfFactors.Insert(objXDic)
		}
		//侵害性操作
		For ind=1:1:objSumm.InvasiveOperation.Count() {
			Set objDic=objSumm.InvasiveOperation.GetAt(ind)
			Continue:'$IsObject(objDic)
			
			Set Code=objDic.Code
			Set Desc=objDic.Description
			Set objXDic=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			Continue:'$IsObject(objXDic)
			Do objXSum.InvasiveOperation.Insert(objXDic)
		}
		//是否入住ICU
		If $IsObject(objSumm.ICUBoolean) {
			Set Code=objSumm.ICUBoolean.Code
			Set Desc=objSumm.ICUBoolean.Description
			Set objXSum.ICUBoolean=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
		}
		//ICU科室
		If $IsObject(objSumm.ICULocation) {
			Set Code=objSumm.ICULocation.Code
			Set Desc=objSumm.ICULocation.Description
			Set objXSum.ICULocation=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
		}
		//是否手术
		If $IsObject(objSumm.OprBoolean) {
			Set Code=objSumm.OprBoolean.Code
			Set Desc=objSumm.OprBoolean.Description
			Set objXSum.OprBoolean=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
		}
		//是否病原学检验
		If $IsObject(objSumm.LabBoolean) {
			Set Code=objSumm.LabBoolean.Code
			Set Desc=objSumm.LabBoolean.Description
			Set objXSum.LabBoolean=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
		}
		//是否使用抗菌药物
		If $IsObject(objSumm.AntiBoolean) {
			Set Code=objSumm.AntiBoolean.Code
			Set Desc=objSumm.AntiBoolean.Description
			Set objXSum.AntiBoolean=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
		}
		//不良反应
		If $IsObject(objSumm.AdverseReaction) {
			Set Code=objSumm.AdverseReaction.Code
			Set Desc=objSumm.AdverseReaction.Description
			Set objXSum.AdverseReaction=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
		}
		//二重感染
		If $IsObject(objSumm.Superinfection) {
			Set Code=objSumm.Superinfection.Code
			Set Desc=objSumm.Superinfection.Description
			Set objXSum.Superinfection=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
		}
		// 新生儿出生体重(KG)
		Set objXSum.BornWeight=objSumm.BornWeight
		// 转科记录 指向PA_AdmTransaction
		Set objXSum.TransID=objSumm.TransID
		// 转入科室(感染科室)
		Set TransLoc=objSumm.TransLoc
		Set:TransLoc="" TransLoc=objRep.ReportLoc
		If TransLoc'="" {
			Set TransLocCode=$p($g(^CTLOC(TransLoc)),"^",1)
			Set TransLocCode=$tr(TransLocCode," ","")
			Set TransLocDesc=$p($g(^CTLOC(TransLoc)),"^",2)
			Set TransLocDesc=$tr(TransLocDesc," ","")
			Set:TransLocDesc["-" TransLocDesc=$p(TransLocDesc,"-",2)
			Set objXSum.TransLoc=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(TransLocCode_"^"_TransLocDesc)
		}
		// 入科来源 指向CT_Loc
		Set objXSum.TransFromLoc=objSumm.TransFromLoc
		// 出科去向 指向CT_Loc
		Set objXSum.TransToLoc=objSumm.TransToLoc
		///Update By CPJ 2015-01-20 修改转入日期和转出日期
		Set TransInfo = ##class(DHCMed.NINFService.Srv.CommonCls).GetTransLocByID(objSumm.TransID)
		Set TransInDate = $p($g(TransInfo),"^",4)
		Set TransOutDate = $p($g(TransInfo),"^",5)
		// 转入日期
		Set objXSum.TransInDate=$p(TransInDate," ",1)
		// 转出日期
		Set objXSum.TransOutDate=TransOutDate
		
		// 转出ICU时状态(带管情况)
		For ind=1:1:objSumm.OutICUStatus.Count() {
			Set objDic=objSumm.OutICUStatus.GetAt(ind)
			Continue:'$IsObject(objDic)
			
			Set Code=objDic.Code
			Set Desc=objDic.Description
			Set objXDic=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			Continue:'$IsObject(objXDic)
			Do objXSum.OutICUStatus.Insert(objXDic)
		}
		// 转出ICU48小时内状态(带管情况)
		For ind=1:1:objSumm.OutICU48Status.Count() {
			Set objDic=objSumm.OutICU48Status.GetAt(ind)
			Continue:'$IsObject(objDic)
			
			Set Code=objDic.Code
			Set Desc=objDic.Description
			Set objXDic=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			Continue:'$IsObject(objXDic)
			Do objXSum.OutICU48Status.Insert(objXDic)
		}
		// 系统症状
		Set objXSum.SystemSymptom=objSumm.SystemSymptom
		// 局部症状/体征
		Set objXSum.LocalSymptom=objSumm.LocalSymptom
		
		//Set objXSum.ApacheIIScore = objSumm.ApacheIIScore
	}
	If objXSum'="" Do objXSum.%Close()
	
	Quit objXSum
}

/// Creator : CPJ
/// CreatDate : 2015-01-17
/// Description : 根据报告ID取【重症监护信息】相关信息
/// Input :ReportID
/// return : %List
/// s obj = ##calss (DHCMed.NINF.Srv.InfReport).%New()
/// w obj.GetICUPICC() As %ListOfObjects
/// w ##class(DHCMed.NINF.Srv.InfReport).GetICUPICC(794)
ClassMethod GetICUPICC(aReportID As %String, aReportType As %String = "COMP") As %ListOfObjects
{
	New (aReportID,aReportType)
	Set return=##class(%ListOfObjects).%New()
	Quit:(aReportID="") return
	Set xSubID=""
	For {
		Set xSubID=$o(^DHCMed.NINF("InfRep",aReportID,"ICU",xSubID))
		Quit:xSubID=""
		
		Set objICUPICC=##class(DHCMed.NINF.Rep.InfReportICU).GetObjById(aReportID_"||"_xSubID)
		Continue:('$IsObject(objICUPICC))
		Set objxICUPICC=##Class(DHCMed.NINF.Srv.InfReportICU).%New() 
		If ($IsObject(objxICUPICC)) {
			//置管类型(中央导管、呼吸机、导尿管、NICU中央导管、NICU气管插管、NICU脐静脉)
			If $IsObject(objICUPICC.IntubateType) {
				Set Code = objICUPICC.IntubateType.Code
				Set Desc = objICUPICC.IntubateType.Description
				Set objxICUPICC.IntubateType=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			
			}
			If $IsObject(objICUPICC.PICCIntubateType) {
				Set Code = objICUPICC.PICCIntubateType.Code
				Set Desc = objICUPICC.PICCIntubateType.Description
				Set objxICUPICC.PICCIntubateType=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			/// 置管日期
			Set InDate = objICUPICC.IntubateDate
			Set:InDate'="" InDate=$zd(InDate,3)
			Set objxICUPICC.IntubateDate=InDate
			/// 置管时间
			Set InTime = objICUPICC.IntubateTime
			Set:InTime'="" InTime=$zt(InTime,3)
			Set objxICUPICC.IntubateTime=InTime
			/// 拔管日期
			Set OutDate = objICUPICC.ExtubateDate
			Set:OutDate'="" OutDate=$zd(OutDate,3)
			Set objxICUPICC.ExtubateDate=OutDate
			/// 拔管时间
			Set OutTime = objICUPICC.ExtubateTime
			Set:OutTime'="" OutTime=$zt(OutTime,3)
			Set objxICUPICC.ExtubateTime=OutTime
			/// 置管地点("NINFICUIntubatePlace")
			If $IsObject(objICUPICC.IntubatePlace) {
				Set Code = objICUPICC.IntubatePlace.Code
				Set Desc = objICUPICC.IntubatePlace.Description
				Set objxICUPICC.IntubatePlace=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			/// 置管人员类型("NINFICUIntubateUserType")
			If $IsObject(objICUPICC.IntubateUserType) {
				Set Code = objICUPICC.IntubateUserType.Code
				Set Desc = objICUPICC.IntubateUserType.Description
				Set objxICUPICC.IntubateUserType=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			/// 置管人员 指向SS_User
			Set UserDr = objICUPICC.IntubateUser	
			If UserDr'="" {
				Set Code=$p($g(^SSU("SSUSR",+UserDr)),"^",1)
				Set Desc=$p($g(^SSU("SSUSR",+UserDr)),"^",2)
				Set objxICUPICC.IntubateUser=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			/// 感染日期
			Set InfDate = objICUPICC.InfDate
			Set:InfDate'="" InfDate=$zd(InfDate,3)
			Set objxICUPICC.InfDate=InfDate
			/// 中央导管 置管方位("NINFICUPICCIntubatePos")
			If $IsObject(objICUPICC.PICCIntubatePos) {
				Set Code = objICUPICC.PICCIntubatePos.Code
				Set Desc = objICUPICC.PICCIntubatePos.Description
				Set objxICUPICC.PICCIntubatePos=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			/// 中央导管 置管内径("NINFICUPICCIntubateSize")
			If $IsObject(objICUPICC.PICCIntubateSize) {
				Set Code = objICUPICC.PICCIntubateSize.Code
				Set Desc = objICUPICC.PICCIntubateSize.Description
				Set objxICUPICC.PICCIntubateSize=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			/// 中央导管 导管类型("NINFICUPICCIntubateType")
			If $IsObject(objICUPICC.PICCIntubateType) {
				Set Code = objICUPICC.PICCIntubateType.Code
				Set Desc = objICUPICC.PICCIntubateType.Description
				Set objxICUPICC.PICCIntubateType=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			/// 中央导管 置管腔数("NINFICUPICCIntubateNum")
			If $IsObject(objICUPICC.PICCIntubateNum) {
				Set Code = objICUPICC.PICCIntubateNum.Code
				Set Desc = objICUPICC.PICCIntubateNum.Description
				Set objxICUPICC.PICCIntubateNum=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			/// 中央导管 置管部位("NINFICUPICCIntubateRegion")
			If $IsObject(objICUPICC.PICCIntubateRegion) {
				Set Code = objICUPICC.PICCIntubateRegion.Code
				Set Desc = objICUPICC.PICCIntubateRegion.Description
				Set objxICUPICC.PICCIntubateRegion=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			/// 中央导管 拔管原因("NINFICUPICCExtubateReason")
			If $IsObject(objICUPICC.PICCExtubateReason) {
				Set Code = objICUPICC.PICCExtubateReason.Code
				Set Desc = objICUPICC.PICCExtubateReason.Description
				Set objxICUPICC.PICCExtubateReason=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			/// 导尿管 尿袋类型("NINFICUUCUrineBagType")
			If $IsObject(objICUPICC.UCUrineBagType) {
				Set Code = objICUPICC.UCUrineBagType.Code
				Set Desc = objICUPICC.UCUrineBagType.Description
				Set objxICUPICC.UCUrineBagType=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			/// 呼吸机 气道类型("NINFInfVAPIntubateType")
			If $IsObject(objICUPICC.VAPIntubateType) {
				Set Code = objICUPICC.VAPIntubateType.Code
				Set Desc = objICUPICC.VAPIntubateType.Description
				Set objxICUPICC.VAPIntubateType=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}
			/// 置管感染类型 "NINFICUIntubateINFSymptom") Add By LiYang 2014-04-10
			/*If $IsObject(objICUPICC.INFSymptom) {
				Set Code = objICUPICC.INFSymptom.Code
				Set Desc = objICUPICC.INFSymptom.Description
				Set objxICUPICC.INFSymptom=##Class(DHCMed.NINF.Srv.Dictionary).GetDicObj(Code_"^"_Desc)
			}*/
			/// 感染过程 Add By cpj 2015-01-16 Add By cpj 2015-01-16
			//Set INFProcess = objICUPICC.INFProcess
			//Set objxICUPICC.INFProcess = INFProcess

			Do return.Insert(objxICUPICC)
		}
		If objxICUPICC'="" Do objxICUPICC.%Close()
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-09-13
/// Description:  根据报告ID取【器械相关信息】接口
/// Table：       
/// Input：       ReportID 报告ID
/// Return：      返回%List
/// s obj=##class(DHCMed.NINF.Srv.InfReport).%New()
/// w obj.GetMedApps(1)
Method GetMedApps(aReportID As %String, aReportType As %String = "COMP") As %ListOfObjects
{
	New (aReportID,aReportType)
	Set return=##class(%ListOfObjects).%New()
	Quit:(aReportID="") return
	
	//DHCMed.NINF.Srv.InfReportMedApp
	
	Quit return
}

/// 通过报告日期查询报告列表(输出Report列表)
/// w ##class(DHCMed.NINF.Srv.InfReport).GetInfRepList("2013-01-01","2013-08-01","")
ClassMethod GetInfRepList(aFromDate As %String, aToDate As %String, aLoc As %String) As %List
{
	New (aFromDate,aToDate,aLoc)
	Set return=""
	Quit:(aFromDate="")||(aToDate="") return
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Quit:(aFromDate="")||(aToDate="") return
	
	//通过感染日期取报告
	//^DHCMed.NINFi("InfRep",0,"InfPos","IndexInfDate",62733,10,1)
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.NINFi("InfRep",0,"InfPos","IndexInfDate",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"InfPos","IndexInfDate",xDate,xRepID))
			Quit:xRepID=""
			
			Set xSummID=$o(^DHCMed.NINF("InfRep",xRepID,"Summ",0))
			Set objSumm=##class(DHCMed.NINF.Rep.InfReportSumm).GetObjById(xRepID_"||"_xSummID)
			Continue:'$IsObject(objSumm)
			Set TransLoc=objSumm.TransLoc
			Continue:(aLoc'="")&&(aLoc'=TransLoc)
			
			Continue:$listfind(return,xRepID)>0
			Set return=return_$lb(xRepID)
		}
	}
	
	/* update by zf 2013-08-01
	//通过报告日期取报告
	//^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",62733,41709,22,303)
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		Set xTime=0
		For {
			Set xTime=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime))
			Quit:xTime=""
			
			Set xLoc=""
			For {
				Set xLoc=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime,xLoc))
				Quit:xLoc=""
				Continue:(aLoc'="")&&(aLoc'=xLoc)
				Set xRepID=0
				For {
					Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime,xLoc,xRepID))
					Quit:xRepID=""
					Set return=return_$lb(xRepID)
				}
			}
		}
	}
	*/
	
	Quit return
}

/// Add By LiYang 2013-05-23 判断一个患者是否当前是医院感染者
ClassMethod IsCurrentInfection(EpisodeID As %String, FromDate As %String = "", ToDate As %String = "")
{
	n (EpisodeID,FromDate,ToDate)
	Set ret=0
	Set arryRep=##class(DHCMed.NINF.Srv.InfReport).GetInfRepByAdm(EpisodeID)
	Set Count=arryRep.Count()
	Set tmpCnt=Count
	For i=1:1:Count {
		Set objRep=arryRep.GetAt(i)
		Continue:'$IsObject(objRep)
		Continue:..IsInfectionEnd(objRep,FromDate,ToDate)
		Set tmpCnt=tmpCnt-1
	}
	Set ret=tmpCnt
	;w EpisodeID_"    "_ret,!
	Quit ret
}

ClassMethod IsInfectionEnd(objRep, FromDate = "", ToDate = "")
{
	n (objRep,FromDate,ToDate)
	Set ret=0
	Quit:'$IsObject(objRep) ret
	Set arryPos=objRep.GetInfPos(objRep.ReportID)
	Set Count=arryPos.Count()
	Set infCnt=Count
	
	For i=1:1:Count {
		Set objPos=arryPos.GetAt(i)
		Continue:'$IsObject(objPos)
		Continue:'$IsObject(objPos.InfEndResult)
		Continue:objPos.InfEndResult.Code'=1 //不是【治愈】不算
		Continue:objPos.InfEndDate="" //截止日期为空认为没痊愈
		Set tmpStartDate=$zdh(objPos.InfDate,3)
		Set tmpEndDate=objPos.InfEndDate
		Set:tmpEndDate'="" tmpEndDate=$zdh(tmpEndDate,3)
		Continue:((tmpStartDate<FromDate)&&(FromDate'=""))
		Continue:((tmpEndDate>ToDate)&&(ToDate'=""))
		Set infCnt=infCnt-1
	}
	Set ret=infCnt
	Quit ret
}

Storage Default
{
<Data name="InfReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiseasePrognosis</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>ICUBoolean</Value>
</Value>
<Value name="5">
<Value>PatientID</Value>
</Value>
<Value name="6">
<Value>ReportID</Value>
</Value>
<Value name="7">
<Value>AntiBoolean</Value>
</Value>
<Value name="8">
<Value>LabBoolean</Value>
</Value>
<Value name="9">
<Value>OprBoolean</Value>
</Value>
</Data>
<Data name="InfReportState">
<Value name="1">
<Value>AntiBoolean</Value>
</Value>
<Value name="2">
<Value>DiseasePrognosis</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>ICUBoolean</Value>
</Value>
<Value name="5">
<Value>LabBoolean</Value>
</Value>
<Value name="6">
<Value>OprBoolean</Value>
</Value>
<Value name="7">
<Value>PatientID</Value>
</Value>
<Value name="8">
<Value>ReportID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Srv.InfReportD</DataLocation>
<DefaultData>InfReportDefaultData</DefaultData>
<IdLocation>^DHCMed.NINF.Srv.InfReportD</IdLocation>
<IndexLocation>^DHCMed.NINF.Srv.InfReportI</IndexLocation>
<State>InfReportState</State>
<StreamLocation>^DHCMed.NINF.Srv.InfReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
