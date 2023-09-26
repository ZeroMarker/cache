/// 导出接口，中间类：InfReport
Class DHCHAI.MK.INFReport Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 基本信息ID
Property PatientID As %String(TRUNCATE = 1);

/// 感染报告ID
Property ReportID As %String(TRUNCATE = 1);

/// 报告类型
Property ReportType As DHCHAI.MK.INFDictionary;

/// 报告人员 指向SS_User
Property ReportUser As DHCHAI.MK.INFDictionary;

/// 报告状态
Property ReportStatus As DHCHAI.MK.INFDictionary;

/// 报告日期
Property ReportDate As %String(TRUNCATE = 1);

/// 报告时间
Property ReportTime As %String(TRUNCATE = 1);

/// 报告科室
Property ReportLoc As DHCHAI.MK.INFDictionary;

/// 报告病区
Property ReportWard As DHCHAI.MK.INFDictionary;

/// 入科来源（转入科室/入院）
Property FromPlace As DHCHAI.MK.INFDictionary;

/// 出科去向（转出科室/出院）
Property ToPlace As DHCHAI.MK.INFDictionary;

/// 转入日期
Property InICUDate As %String;

/// 转出日期
Property OutICUDate As %String;

/// APACHEⅡ评分
Property APACHEScore As %String;

/// Description : 增加方法，根据就诊ID,取当次就诊下所有的院感报告
/// Creator : CPJ
/// CreatDate : 2018-03-26
ClassMethod GetINFRepListByAdm(aIREpisodeDr As %String, aRepType As %String) As %ListOfObjects
{
	New (aIREpisodeDr,aRepType)
	
	Set return=##class(%ListOfObjects).%New()
	Quit:aIREpisodeDr="" return
	
	Set xRepID=""
	For {
		Set xRepID=$O(^DHCHAI.IR.INFReportI("IndexPaadmType",aIREpisodeDr,aRepType,xRepID))
		Quit:xRepID=""
		
		Set objXRep=..GetObjById(xRepID,aRepType)
		Continue:'$IsObject(objXRep)
		
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
/// w ##class(DHCHAI.MK.INFReport).GetObjById("45",3)
ClassMethod GetObjById(aReportID As %String, aReportType As %String = "") As DHCHAI.MK.INFReport
{
	New (aReportID,aReportType)
	Set return=""
	Quit:((aReportID="")) return
	//Set ^temphp111(333)=$lb(aReportID,aReportType)
	//感染报告
	Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	
	Set ReportID=objRep.%Id()
	Set RepType=objRep.IRRepType
	Set RepTypeCode="",RepTypeDesc=""
	If (RepType=1) {
		Set RepTypeCode="1"
		Set RepTypeDesc="医院感染报告"
	} ElseIf (RepType=2) {
		Set RepTypeCode="2"
		Set RepTypeDesc="新生儿感染报告"
	} ElseIf (RepType=3) {
		Set RepTypeCode="3"
		Set RepTypeDesc="ICU调查表"
	} ElseIf (RepType=4) {
		Set RepTypeCode="4"
		Set RepTypeDesc="手术切口调查表"
	} ElseIf (RepType=5) {
		Set RepTypeCode="5"
		Set RepTypeDesc="多重耐药调查表"
	} ElseIf (RepType=6) {
		Set RepTypeCode="6"
		Set RepTypeDesc="抗菌药物调查表"
	} ElseIf (RepType=7) {
		Set RepTypeCode="7"
		Set RepTypeDesc="横断面调查"
	}
	
	Quit:(aReportType'="")&&(RepTypeCode'=aReportType) return
	
	Quit:'$IsObject(objRep.IRStatusDr) return
	Set RepStatusCode=objRep.IRStatusDr.BTCode
	Set RepStatusDesc=objRep.IRStatusDr.BTDesc
	Quit:RepStatusDesc["删除" return
	
	Set IREpisodeDr=objRep.IREpisodeDr
	Set objIRPAAdm=##class(DHCHAI.DP.PAAdm).GetObjById(IREpisodeDr.%Id())
	Set PAEpisodeIDx=objIRPAAdm.PAEpisodeIDx
	Set PAPatientIDx=objIRPAAdm.PAPatientIDx
	Set EpisodeID=$P(PAEpisodeIDx,"||",2)

	Set ReportDate=objRep.IRRepDate
	Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set ReportTime=objRep.IRRepTime
	Set:ReportTime'="" ReportTime=$zt(ReportTime,2)
	
	Set objReportLoc=objRep.IRRepLocDr
	Set RepLocCode="",RepLocDesc=""
	Set RepWardCode="",RepWardDesc=""
	If $IsObject(objReportLoc) {
		Set RepLocCode=objReportLoc.BTCode
		Set RepLocCode=$tr(RepLocCode," ","")
		Set RepLocDesc=objReportLoc.BTDesc
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
			//取科室下对应的病区
			//Continue:'$d(^CTLOC(ReportLoc,"LINK",0,"Loc",TransWard))
			Set RepWardCode=$p($g(^CTLOC(TransWard)),"^",1)
			Set RepWardDesc=$p($g(^CTLOC(TransWard)),"^",2)
		}
	}
	
	Set objRepUser=objRep.IRRepUser
	If $IsObject(objRepUser){
		Set RepUserCode=objRepUser.BTCode
		Set RepUserName=objRepUser.BTDesc
		
	} Else {
		Set RepUserCode=""
		Set RepUserName=""
	}
	//入科来源
	Set objInLocDr=objRep.IRInLocDr
	Set InLocCode="",InLocDesc=""
	If $IsObject(objInLocDr) {
		Set InLocCode=objInLocDr.BTCode
		Set InLocCode=$tr(InLocCode," ","")
		Set InLocDesc=objInLocDr.BTDesc
		Set InLocDesc=$tr(InLocDesc," ","")
	
	}
	//出科去向
	Set objOutLocDr=objRep.IROutLocDr
	Set OutLocCode="",OutLocDesc=""
	//Set InWardCode="",InWardDesc=""
	If $IsObject(objOutLocDr) {
		Set OutLocCode=objOutLocDr.BTCode
		Set OutLocCode=$tr(OutLocCode," ","")
		Set OutLocDesc=objOutLocDr.BTDesc
		Set OutLocDesc=$tr(OutLocDesc," ","")
	
	}
	//入科时间
	Set InDate=objRep.IRInDate
	Set:InDate'="" InDate=$zd(InDate,3)
	//出科时间
	Set OutDate=objRep.IROutDate
	Set:OutDate'="" OutDate=$zd(OutDate,3)
	//APACHEⅡ评分
	Set APACHEScore=objRep.IRAPACHEScore
	
	Set objXRep=##Class(DHCHAI.MK.INFReport).%New()
	Quit:'$IsObject(objXRep) return
	
	Set objXRep.EpisodeID=PAEpisodeIDx
	Set objXRep.PatientID=PAPatientIDx
	Set objXRep.ReportID=ReportID
	Set objXRep.ReportType=##Class(DHCHAI.MK.INFDictionary).GetDicObj(RepTypeCode_"^"_RepTypeDesc)
	Set objXRep.ReportStatus=##Class(DHCHAI.MK.INFDictionary).GetDicObj(RepStatusCode_"^"_RepStatusDesc)
	Set objXRep.ReportUser=##Class(DHCHAI.MK.INFDictionary).GetDicObj(RepUserCode_"^"_RepUserName)
	Set objXRep.ReportDate=ReportDate
	Set objXRep.ReportTime=ReportTime
	Set objXRep.ReportLoc=##Class(DHCHAI.MK.INFDictionary).GetDicObj(RepLocCode_"^"_RepLocDesc)
	Set objXRep.ReportWard=##Class(DHCHAI.MK.INFDictionary).GetDicObj(RepWardCode_"^"_RepWardDesc)
	
	Set objXRep.FromPlace=##Class(DHCHAI.MK.INFDictionary).GetDicObj(InLocCode_"^"_InLocDesc)
	Set objXRep.ToPlace=##Class(DHCHAI.MK.INFDictionary).GetDicObj(OutLocCode_"^"_OutLocDesc)
	Set objXRep.InICUDate=InDate
	Set objXRep.OutICUDate=OutDate
	Set objXRep.APACHEScore=APACHEScore
	
	If objXRep'="" Do objXRep.%Close()
	Set return=objXRep
	
	Quit return
}

/// Creator：     CPJ
/// CreatDate：   2018-03-26
/// Description:  根据报告ID取【疾病诊断】接口
/// Table：       
/// Input：       ReportID 报告ID
/// Return：      返回%List  取HIS诊断
/// s obj=##class(DHCHAI.MK.INFReport).%New()
/// w obj.GetDiagnos(1)
Method GetDiagnos(aReportID As %String) As %ListOfObjects
{
	New (aReportID)
	Set return=##class(%Library.ListOfObjects).%New()
	Quit:(aReportID="") return
	
	Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
	Quit:'$IsObject(objReport) return
	Set aEpisodeID=objReport.IREpisodeDr.%Id()
	
	Set (MainDiag,AdmitDiag,OtherDiag,DischDiag,ProDiag)=""		// 主要诊断、入院诊断、其他诊断、出院诊断、初步诊断(2022-05-12)
	Set xDiagnosID = ""
	For {
		Set xDiagnosID = $o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",aEpisodeID,xDiagnosID))
		Quit:xDiagnosID=""
		
		Set objDiagnos = ##class(DHCHAI.DP.MRDiagnos).GetObjById(xDiagnosID)
		Continue:'$isobject(objDiagnos)
		
		Set IsActive = objDiagnos.MRIsActive
		Continue:IsActive'=1
		Continue:objDiagnos.MRDiagSource'="C"  //临床诊断
		
		Set SCode	   = objDiagnos.MRSCode
		Set DiagTpDesc = objDiagnos.MRDiagTpDesc
		Set DiagTypeMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"DiagType",DiagTpDesc)
		If DiagTypeMap'="" {
			Set DiagTpCode=$p(DiagTypeMap,"^",2)
			Set DiagTpDesc=$p(DiagTypeMap,"^",3)
		}
		//只查入院诊断和主要诊断 add其他诊断 add初步诊断
		Continue:((DiagTpDesc'="入院诊断")&&(DiagTpDesc'="主要诊断")&&(DiagTpDesc'="其他诊断")&&(DiagTpDesc'="初步诊断"))
		
		Set objXDiag=##Class(DHCHAI.MK.INFReportDiag).%New()
		If $IsObject(objXDiag) {
			//诊断ID  指向MRC_ICDDx
			Set DiagnosID=objDiagnos.%Id()
			Set objXDiag.DiagnosID=DiagnosID
			//诊断ICD10 
			//Set DiagnosICD=objDiagnos.MRDiagICD10
			Set DiagnosICD=$p($g(^MRC("ID",+DiagnosID)),"^",4)
			
			Set objXDiag.DiagnosICD=DiagnosICD
			//诊断名称
			Set objXDiag.DiagnosDesc=objDiagnos.MRDiagDesc
			//下诊断日期
			Set DiagnosDate=objDiagnos.MRDiagDate
			Set:DiagnosDate'="" DiagnosDate=$zd(DiagnosDate,3)
			Set objXDiag.DiagnosDate=DiagnosDate
			//下诊断时间
			Set DiagnosTime=objDiagnos.MRDiagTime
			Set:DiagnosTime'="" DiagnosTime=$zt(DiagnosTime,2)
			Set objXDiag.DiagnosTime=DiagnosTime
			
			Do return.Insert(objXDiag)
		}
		If objXDiag'="" Do objXDiag.%Close()
	}
	
	Quit return
}

/*
/// Creator：     zhufei
/// CreatDate：   2012-08-07
/// Description:  根据报告ID取【疾病诊断】接口
/// Table：       
/// Input：       ReportID 报告ID
/// Return：      返回%List
/// s obj=##class(DHCHAI.MK.INFReport).%New()
/// w obj.GetDiagnos(1)
Method GetDiagnos1(aReportID As %String, aReportType As %String = "COMP") As %ListOfObjects
{
	New (aReportID,aReportType)
	Set return=##class(%Library.ListOfObjects).%New()
	Quit:(aReportID="") return
	
	
	Set xSubID=0
	For {
		Set xSubID=$o(^DHCMed.NINF("InfRep",aReportID,"Diag",xSubID))
		Quit:xSubID=""
		
		Set objDiag=##class(DHCHAI.DP.MRDiagnos).GetObjById(aReportID_"||"_xSubID)
		Continue:'$IsObject(objDiag)
		Continue:objDiag.DiagnosDesc=""
		
		Set objXDiag=##Class(DHCHAI.DP.MRDiagnos).%New()
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
*/
/// Creator：     CPJ
/// CreatDate：   2018-03-26
/// Description:  根据报告ID取【感染部位信息】接口
/// Table：       
/// Input：       ReportID 报告ID
/// Return：      返回%List
/// s obj=##class(DHCHAI.MK.INFReport).%New()
/// w obj.GetInfPos(1)
Method GetInfPos(aReportID As %String) As %ListOfObjects
{
	New (aReportID,aReportType)
	Set return=##class(%ListOfObjects).%New()
	Quit:(aReportID="") return
	
	Set aDataType="DHCHAI.IR.INFDiagnos"
	
	Set xSubID=0
	For {
		Set xSubID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(aDataType,"U"),aReportID,xSubID))
		Quit:xSubID=""
		
		Set RepExtID=aReportID_"||"_xSubID
		Set obj=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
		Continue:'$IsObject(obj)
		Continue:'$IsObject(obj.Parref)
		Continue:'$IsObject(obj.Parref.IRStatusDr)
		Set StatusCode=obj.Parref.IRStatusDr.BTCode
		Continue:(StatusCode'="3")&&(StatusCode'="2")&&(StatusCode'="8") //只导审核+提交的报告
		
		Set ObjectID=obj.IRObjectID
		Continue:ObjectID=""
		
		Set objInfDiag=##class(DHCHAI.IR.INFDiagnos).GetObjById(ObjectID)
		Set objXInfPos=##Class(DHCHAI.MK.INFReportInfPos).%New()
		If $IsObject(objXInfPos) {
			If $IsObject(objInfDiag.IRInfPosDr) {
				Set DiagFlg=objInfDiag.IRInfPosDr.BTDiagFlag
				If (DiagFlg) {
					//感染诊断 
					Set Code=objInfDiag.IRInfPosDr.BTCode
					Set Desc=objInfDiag.IRInfPosDr.BTDesc
					Set objXInfPos.InfDiag=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					
					Set InfPosCode=$e(objInfDiag.IRInfPosDr.BTCode,1,2)
					Set objInfPos=##class(DHCHAI.BT.InfPos).GetObjByCode(InfPosCode)
					//感染部位
					If ($IsObject(objInfPos)) {
						Set Code=objInfPos.BTCode
						Set Desc=objInfPos.BTDesc
						Set objXInfPos.InfPos=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					}
				} 
				
				//感染日期
				Set InfDate=objInfDiag.IRInfDate
				Set:InfDate'="" InfDate=$zd(InfDate,3)
				Set objXInfPos.InfDate=InfDate
			}
			
			//加入感染结果，截止日期
			Set objXInfPos.InfEndDate=""
			Set:objInfDiag.IRInfXDate'="" objXInfPos.InfEndDate=$zd(objInfDiag.IRInfXDate,3)
			
			//感染科室
			Set objInfLoc=objInfDiag.IRInfLocDr
			If ($IsObject(objInfLoc)) {
				Set Code=objInfLoc.BTCode
				Set Desc=objInfLoc.BTDesc
				Set objXInfPos.InfLoc=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
			}
			
			//转归
			/*If $IsObject(objInfDiagnew.IRInfEffect) {
				Set Code=objInfDiagnew.IRInfEffect.BTCode
				Set Desc=objInfDiagnew.IRInfEffect.BTDesc
				Set objXInfPos.InfEndResult=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
			}*/
			//新加的转归   2022/7/11  刘时❤
			If $IsObject(objInfDiag.IRInfEffectDr) {
				Set Code=objInfDiag.IRInfEffectDr.BTCode
				Set Desc=objInfDiag.IRInfEffectDr.BTDesc
				Set objXInfPos.InfEndResult=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
			}
			
			
			//与死亡关系
			If $IsObject(objInfDiag.IRDeathRelationDr) {
				Set Code=objInfDiag.IRDeathRelationDr.BTCode
				Set Desc=objInfDiag.IRDeathRelationDr.BTDesc
				Set objXInfPos.InfDeathRelation=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
			}
			
			//诊断依据
			Set objXInfPos.DiagnosisBasis=objInfDiag.IRInfDiagnosisBasis
			
			//疾病病程
			Set objXInfPos.DiseaseCourse=objInfDiag.IRInfDiseaseCourse
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
/// s obj=##class(DHCHAI.MK.INFReport).%New(301)
/// w obj.GetOperations(301)
Method GetOperations(aReportID As %String) As %ListOfObjects
{
	New (aReportID)
	Set return=##class(%ListOfObjects).%New()
	Quit:(aReportID="") return
	Set ^tmphp222(444)=aReportID
	//手术信息要同时检查是否有手术切口调查表
	Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	
	Set IREpisodeDr=objRep.IREpisodeDr
	Quit:'$IsObject(IREpisodeDr) return
	
	Kill ^TMPDHCHAIGetOpr
	
	Set DPPaadmID=IREpisodeDr.%Id()
	Set xRepType=""
	For {
		Set xRepType=$O(^DHCHAI.IR.INFReportI("IndexPaadmType",DPPaadmID,xRepType),-1)
		Quit:xRepType=""
		
		Continue:((xRepType'=1)&&(xRepType'=4))
		Set xReportID=""
		For {
			Set xReportID=$O(^DHCHAI.IR.INFReportI("IndexPaadmType",DPPaadmID,xRepType,xReportID))
			Quit:xReportID=""
			
			Set aDataType="DHCHAI.IR.INFOPS"
			Set xSubID=0
			For {
				Set xSubID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(aDataType,"U"),xReportID,xSubID))
				Quit:xSubID=""
				
				Set RepExtID=xReportID_"||"_xSubID
				Set obj=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.Parref)
				Continue:'$IsObject(obj.Parref.IRStatusDr)
				Set StatusCode=obj.Parref.IRStatusDr.BTCode
				Continue:(StatusCode'="3")&&(StatusCode'="2")&&(StatusCode'="8") //只导审核+提交的报告
				
				Set ObjectID=obj.IRObjectID
				Continue:ObjectID=""
				
				Set objOpr=##class(DHCHAI.IR.INFOPS).GetObjById(ObjectID)
				Continue:'$IsObject(objOpr)
				
				Continue:objOpr.IROperName=""
				
				Set objXOpr=##Class(DHCHAI.MK.INFReportOpr).%New()
				If $IsObject(objXOpr) {
					//手术ID 指向ORC_Operation
					Set IROperDr=objOpr.IROperDr
					If $IsObject(IROperDr) {
						Set objXOpr.OperationID=IROperDr.%Id()
					} Else {
						Set objXOpr.OperationID=RepExtID
					}
					
					If (IROperDr) {
						//手术ICD
						Set objXOpr.OperationICD=IROperDr.OROperICD
						//手术名称
						Set objXOpr.OperationDesc=IROperDr.OROperDesc
					} ELSE {
						Set objXOpr.OperationICD=""
						Set objXOpr.OperationDesc=objOpr.IROperName
					}
					
					//判断是否有重复手术信息
					If ('$d(^TMPDHCHAIGetOpr("DHCHAIOper",objXOpr.OperationDesc))) {
						Set ^TMPDHCHAIGetOpr("DHCHAIOper",objXOpr.OperationDesc)=""
					} Else {
						Continue
					}
					//手术开始日期
					Set OperStartDate=objOpr.IROperDate
					Set:OperStartDate'="" OperStartDate=$zd(OperStartDate,3)
					Set objXOpr.OperStartDate=OperStartDate  
					//手术开始时间
					Set OperStartTime=objOpr.IRSttTime
					Set:OperStartTime'="" OperStartTime=$zt(OperStartTime,2)
					Set objXOpr.OperStartTime=OperStartTime 
					//手术结束日期
					Set OperEndDate=objOpr.IREndDate
					Set:OperEndDate'="" OperEndDate=$zd(OperEndDate,3)
					Set objXOpr.OperEndDate=OperEndDate
					//手术结束时间
					Set OperEndTime=objOpr.IREndTime
					Set:OperEndTime'="" OperEndTime=$zt(OperEndTime,2)
					Set objXOpr.OperEndTime=OperEndTime
					//手术医生
					Set OperDocTxt=objOpr.IROperDocTxt
					Set IROperDocDr=objOpr.IROperDocDr
					If $IsObject(IROperDocDr) {
						Set Code=IROperDocDr.BTCode
						Set Desc=IROperDocDr.BTDesc
						Set objXOpr.OperDoc=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					} Else {
						Set Code="Doc"
						Set Desc=OperDocTxt
						Set objXOpr.OperDoc=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					}
					
					//手术类型
					If $IsObject(objOpr.IROperTypeDr) {
						Set Code=objOpr.IROperTypeDr.BTCode
						Set Desc=objOpr.IROperTypeDr.BTDesc
						Set objXOpr.OperationType=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					}
					//麻醉方式
					If $IsObject(objOpr.IRAnesthesiaDr) {
						Set Code=objOpr.IRAnesthesiaDr.BTCode
						Set Desc=objOpr.IRAnesthesiaDr.BTDesc
						Set objXOpr.Anesthesia=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					}
					//切口类型
					If $IsObject(objOpr.IRCuteTypeDr) {
						Set Code=objOpr.IRCuteTypeDr.BTCode
						Set Desc=objOpr.IRCuteTypeDr.BTDesc
						Set objXOpr.CuteType=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					}
					//愈合情况
					If $IsObject(objOpr.IRCuteHealingDr) {
						Set Code=objOpr.IRCuteHealingDr.BTCode
						Set Desc=objOpr.IRCuteHealingDr.BTDesc
						Set objXOpr.CuteHealing=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					}
					//是否切口感染
					If objOpr.IRIsOperInf {
						Set Code="1"
						Set Desc="是"
						Set objXOpr.CuteInfFlag=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					} Else {
						Set Code="0"
						Set Desc="否"
						Set objXOpr.CuteInfFlag=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					}
					
					//手术感染类型
					If $IsObject(objOpr.IRInfTypeDr) {
						Set Code=objOpr.IRInfTypeDr.BTCode
						Set Desc=objOpr.IRInfTypeDr.BTDesc
						Set objXOpr.OperInfType=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					}
					//是否引起院内感染
					If objOpr.IRIsInHospInf {
						Set Code="1"
						Set Desc="是"
						Set objXOpr.InHospInfFlag=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					} Else {
						Set Code="0"
						Set Desc="否"
						Set objXOpr.InHospInfFlag=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					}
					
					//ASA(麻醉)评分
					If $IsObject(objOpr.IRASAScore) {
						Set Code=objOpr.IRASAScore.BTCode
						Set Desc=objOpr.IRASAScore.BTDesc
						Set objXOpr.ASAScore=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					}
					//术前外周WBC计数(×10^9/L)
					Set objXOpr.PreoperWBC=objOpr.IRPreoperWBC
					//切口个数
					Set objXOpr.CuteNumber=+objOpr.IRCuteNumber
					//使用窥镜
					If objOpr.IREndoscopeFlag {
						Set Code="1"
						Set Desc="是"
						Set objXOpr.EndoscopeFlag=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					} Else {
						Set Code="0"
						Set Desc="否"
						Set objXOpr.EndoscopeFlag=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					}
					/*
					//植入物
					If objOpr.IRImplantFlag {
						Set Code="1"
						Set Desc="是"
						Set objXOpr.ImplantFlag=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					} Else {
						Set Code="0"
						Set Desc="否"
						Set objXOpr.ImplantFlag=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					}
					*/
					//植入物
					If $IsObject(objOpr.IRImplant) {
						Set Code=objOpr.IRImplant.BTCode
						Set Desc=objOpr.IRImplant.BTDesc
						Set objXOpr.ImplantFlag=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					}
					
					//术前口服抗生素肠道准备
					If objOpr.IRPreoperAntiFlag {
						Set Code="1"
						Set Desc="有"
						Set objXOpr.PreoperAntiFlag=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					} Else {
						Set Code="0"
						Set Desc="无"
						Set objXOpr.PreoperAntiFlag=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					}
					//失血
					If objOpr.IRBloodLossFlag {
						Set Code="1"
						Set Desc="有"
						Set objXOpr.BloodLossFlag=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					} Else {
						Set Code="0"
						Set Desc="无"
						Set objXOpr.BloodLossFlag=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					}
					//失血量(MLS)
					Set objXOpr.BloodLoss=objOpr.IRBloodLoss
					//输血
					If objOpr.IRBloodTransFlag {
						Set Code="1"
						Set Desc="有"
						Set objXOpr.BloodTransFlag=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					} Else {
						Set Code="0"
						Set Desc="无"
						Set objXOpr.BloodTransFlag=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
					}
					//输血量(MLS)
					Set objXOpr.BloodTrans=objOpr.IRBloodTrans
					
					//术后并发症
					Set IRPostoperComps=objOpr.IRPostoperComps
					
					//是否手术切口
					If (xRepType="4") {
						Set objXOpr.BloodIsOperCut=1
					} Else {
						Set objXOpr.BloodIsOperCut=0
					}
					
					For ind=1:1:$L(IRPostoperComps,",") {
						Set dicID=$P(IRPostoperComps,",",ind)
						Continue:dicID=""	
						Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(dicID)
						If $IsObject(objDic){
							Set Code = objDic.BTCode
							Set Desc = objDic.BTDesc
							Set objXDic=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
							Continue:'$IsObject(objXDic)
							Do objXOpr.PostoperComps.Insert(objXDic)
						}
					}
					Do return.Insert(objXOpr)
				}
				If objXOpr'="" Do objXOpr.%Close()
			}
		}
	}
	
	
		
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-08-07
/// Description:  根据报告ID取【检验信息】接口
/// Table：       
/// Input：       ReportID 报告ID
/// Return：      返回%List
/// s obj=##class(DHCHAI.MK.INFReport).%New()
/// w obj.GetLabResults(61)
Method GetLabResults(aReportID As %String) As %ListOfObjects
{
	New (aReportID)
	Set return=##class(%ListOfObjects).%New()
	Quit:(aReportID="") return
	
	
	Set aDataType="DHCHAI.IR.INFLab"
	
	Set xSubID=0
	For {
		Set xSubID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(aDataType,"U"),aReportID,xSubID))
		Quit:xSubID=""
		
		Set RepExtID=aReportID_"||"_xSubID
		Set obj=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
		Continue:'$IsObject(obj)
		Continue:'$IsObject(obj.Parref)
		Continue:'$IsObject(obj.Parref.IRStatusDr)
		Set StatusCode=obj.Parref.IRStatusDr.BTCode
		Continue:(StatusCode'="3")&&(StatusCode'="2")&&(StatusCode'="8") //只导审核+提交的报告
		
		Set ObjectID=obj.IRObjectID
		Continue:ObjectID=""
		
		Set objLab=##class(DHCHAI.IR.INFLab).GetObjById(ObjectID)
		Set objXLab=##Class(DHCHAI.MK.INFReportLab).%New()
		If $IsObject(objXLab) {
			Set LabRowId=objLab.%Id()
			
			//标本
			If $IsObject(objLab.IRSpecimenDr) {
				Set Code=objLab.IRSpecimenDr.BTSpecCode
				Set Desc=objLab.IRSpecimenDr.BTSpecDesc
				Set objXLab.Specimen=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
			}
			
			//送检日期
			Set SubmissionDate=objLab.IRSubmissDate
			Set:SubmissionDate'="" SubmissionDate=$zd(SubmissionDate,3)
			Set objXLab.SubmissionDate=SubmissionDate
			
			//检验方法
			If $IsObject(objLab.IRAssayMethod) {
				Set Code=objLab.IRAssayMethod.BTCode
				Set Desc=objLab.IRAssayMethod.BTDesc
				Set objXLab.AssayMethod=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
			}
			
			//检验结果
			If $IsObject(objLab.IRPathogenTest) {
				Set Code=objLab.IRPathogenTest.BTCode
				Set Desc=objLab.IRPathogenTest.BTDesc
				Set objXLab.PathogenTest=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
			}
			
			//细菌培养+药敏结果
			//^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr")
			
			Set PathogenyRowID=""
			For {
				Set PathogenyRowID=$O(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",LabRowId,PathogenyRowID))
				Quit:PathogenyRowID=""
				
				Set ChildSub=""
				For {
					Set ChildSub=$O(^DHCHAI.IR.INFLabI("BACT","IndexParrefBactDicDr",LabRowId,PathogenyRowID,ChildSub))
					Quit:ChildSub=""
					
					//细菌培养
					Set PathogenyID=LabRowId_"||"_ChildSub
					Set objPathogeny=##class(DHCHAI.IR.INFLabBact).GetObjById(PathogenyID)
					Continue:'$IsObject(objPathogeny)
					
					Set (PathogenyDesc,PathogenyDesc1,PathogenyID)=""
					Set objBactDic=objPathogeny.IRBactDicDr
					If $IsObject(objBactDic) {
						Set PathogenyDesc=objBactDic.BTBacDesc
						Set PathogenyID=objBactDic.%Id()
						Set PathogenyDesc1=objBactDic.BTBacDesc
						Continue:((PathogenyDesc["细菌数")||(PathogenyDesc["细菌计数"))
					}
					
					Set objXLabPy=##Class(DHCHAI.MK.INFReportLabPy).%New()
					if $IsObject(objXLabPy) {
						Set objXLabPy.PathogenyDesc=PathogenyDesc
						Set objXLabPy.PathogenyDesc1=PathogenyDesc1
						Set objXLabPy.PathogenyID=PathogenyID
					}
					
					//药敏结果
					Set DrugSenTest=objPathogeny.IRDrugSens
				
					For indSenTest=1:1:DrugSenTest.Count() {
						Set objSenTest=DrugSenTest.GetAt(indSenTest)
						Continue:'$IsObject(objSenTest)
						Continue:objSenTest.IRAntiDesc=""
						
						Set objXLabPyAnti=##Class(DHCHAI.MK.INFReportLabPyAnti).%New()
						If $IsObject(objXLabPyAnti) {
							//add by chenjb 20190225 对象和id不可等同使用
							//Set AntibioticsID=objSenTest.IRAntiDicDr
							//Set objAnti=##class(DHCHAI.DP.LabAntibiotic).GetObjById(AntibioticsID)
							Set objAnti= objSenTest.IRAntiDicDr
							If $IsObject(objAnti) {
								Set objXLabPyAnti.AntibioticsID=objAnti.%Id()
								Set objXLabPyAnti.AntibioticsDesc=objAnti.BTAntDesc
								Set objXLabPyAnti.AntibioticsDesc1=objAnti.BTAntDesc
							} Else {
								Set objXLabPyAnti.AntibioticsDesc=objSenTest.IRAntiDesc
							}
							Set objXLabPyAnti.SenTestRst=##class(DHCHAI.MK.INFDictionary).GetDicObj(objSenTest.IRDrugSenDr.BTCode_"^"_objSenTest.IRDrugSenDr.BTDesc)
							
							Do objXLabPy.DrugSenTest.Insert(objXLabPyAnti)
						}
						If objXLabPyAnti'="" Do objXLabPyAnti.%Close()
					}
					
					Do objXLab.TestResults.Insert(objXLabPy)
					If objXLabPy'="" Do objXLabPy.%Close()
				}
				
			}
		}
		Do return.Insert(objXLab)
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
/// s obj=##class(DHCHAI.MK.INFReport).%New()
/// w obj.GetAnti(1)
Method GetAnti(aReportID As %String) As %ListOfObjects
{
	New (aReportID,aReportType)
	Set return=##class(%ListOfObjects).%New()
	Quit:(aReportID="") return
	
	Set aDataType="DHCHAI.IR.INFAnti"
	
	Set xSubID=0
	For {
		Set xSubID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(aDataType,"U"),aReportID,xSubID))
		Quit:xSubID=""
		
		Set RepExtID=aReportID_"||"_xSubID
		Set obj=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
		Continue:'$IsObject(obj)
		Continue:'$IsObject(obj.Parref)
		Continue:'$IsObject(obj.Parref.IRStatusDr)
		Set StatusCode=obj.Parref.IRStatusDr.BTCode
		Continue:(StatusCode'="3")&&(StatusCode'="2")&&(StatusCode'="8") //只导审核+提交的报告
		
		Set ObjectID=obj.IRObjectID
		Continue:ObjectID=""
		Set objAnti=##class(DHCHAI.IR.INFAnti).GetObjById(ObjectID)
		Continue:('$IsObject(objAnti))
		
		Set objXAnti=##class(DHCHAI.MK.INFReportAnti).%New()
		If $IsObject(objXAnti) {
			//医嘱项ID
			Set objXAnti.ArcimID=objAnti.IRAntiUseDr
			//医嘱名称
			Set objXAnti.ArcimDesc=objAnti.IRAntiDesc
			//开始时间、结束时间数据校验
			If (objAnti.IRSttDate'="")&&(objAnti.IREndDate'="")&&(objAnti.IRSttTime'="")&&(objAnti.IREndTime'="") {
				If objAnti.IREndDate<objAnti.IRSttDate {
					Set objAnti.IREndDate=objAnti.IRSttDate
					Set objAnti.IREndTime=objAnti.IRSttTime
				}
			} ElseIf (objAnti.IREndDate="")&&(objAnti.IREndTime="") {
				Set objAnti.IREndDate=objAnti.IRSttDate
				Set objAnti.IREndTime=objAnti.IRSttTime
				//Set objAnti.IREndDate=""
			} Else {
				//开始日期、结束日期都为空
			}
			//开始时间
			Set objXAnti.StartDate=$zd(objAnti.IRSttDate,3)
			//结束时间
			Set objXAnti.EndDate=$zd(objAnti.IREndDate,3)
			
			//开始时间
			Set objXAnti.StartTime=$zt(objAnti.IRSttTime,1)
			//结束时间
			Set objXAnti.EndTime=$zt(objAnti.IREndTime,1)
			
			//给药途径
			Set objXAnti.AdminRoute=##Class(DHCHAI.MK.INFDictionary).GetDicObj(objAnti.IRAdminRoute.BTCode_"^"_objAnti.IRAdminRoute.BTDesc) 
			//目的
			Set objXAnti.MedPurpose=##Class(DHCHAI.MK.INFDictionary).GetDicObj(objAnti.IRMedPurpose.BTCode_"^"_objAnti.IRMedPurpose.BTDesc) 
			// 治疗用药方式
			Set objXAnti.TreatmentMode=##Class(DHCHAI.MK.INFDictionary).GetDicObj(objAnti.IRTreatmentMode.BTCode_"^"_objAnti.IRTreatmentMode.BTDesc)
			// 预防用药指征
			//Set objXAnti.PreMedIndicat=##Class(DHCHAI.MK.INFDictionary).GetDicObj(objAnti.IRPreMedIndicat.BTCode_"^"_objAnti.IRPreMedIndicat.BTDesc)
			// 预防用药效果
			//Set objXAnti.PreMedEffect=##Class(DHCHAI.MK.INFDictionary).GetDicObj(objAnti.IRPreMedEffect.BTCode_"^"_objAnti.IRPreMedEffect.BTDesc)
			// 联合用药
			Set objXAnti.CombinedMed=##Class(DHCHAI.MK.INFDictionary).GetDicObj(objAnti.IRCombinedMed.BTCode_"^"_objAnti.IRCombinedMed.BTDesc)
			// 术前用药时间(分钟)
			Set objXAnti.PreMedTime=objAnti.IRPreMedTime
			// 术后用药天数(天)
			Set objXAnti.PostMedDays=+objAnti.IRPostMedDays
			
			set objXAnti.DoseQty=objAnti.IRDoseQty
			
			if $Isobject(objAnti.IRDoseUnit){
			  set objXAnti.DoseUnit=objAnti.IRDoseUnit.BTDesc
			}else{
			  set objXAnti.DoseUnit=""	
			}
			
			if $Isobject(objAnti.IRPhcFreq){
			  set objXAnti.PhcFreq=objAnti.IRPhcFreq.BTDesc
			}else{
			  set objXAnti.PhcFreq=""	
			}
			
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
/// s obj=##class(DHCHAI.MK.INFReport).%New()
/// w obj.GetReportSumm(24)
ClassMethod GetReportSumm(aReportID As %String) As DHCHAI.MK.INFReportSumm
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	
	Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	
	Set IREpisodeDr=objRep.IREpisodeDr
	
	Set objXSum=##class(DHCHAI.MK.INFReportSumm).%New()
	If $IsObject(objXSum) {
		//易感因素
		Set aDataType="DHCHAI.IR.INFPreFactor"
		Set xSubID=0,flagHave=0
		For {
			Set xSubID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(aDataType,"U"),aReportID,xSubID))
			Quit:xSubID=""
			
			Set RepExtID=aReportID_"||"_xSubID
			Set obj=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.Parref)
			Continue:'$IsObject(obj.Parref.IRStatusDr)
			Set StatusCode=obj.Parref.IRStatusDr.BTCode
			Continue:(StatusCode'="3")&&(StatusCode'="2")&&(StatusCode'="8") //只导审核+提交的报告
			
			Set ObjectID=obj.IRObjectID
			Continue:ObjectID=""
			
			Set objPreFactor=##class(DHCHAI.IR.INFPreFactor).GetObjById(ObjectID)
			Continue:'$IsObject(objPreFactor)
			
			Set Code=objPreFactor.IRPreFactorDr.BTCode
			Set Desc=objPreFactor.IRPreFactorDr.BTDesc
			Set objXDic=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
			Continue:'$IsObject(objXDic)
			Do objXSum.InfFactors.Insert(objXDic)
		}
		
		//侵害性操作
		Set aDataType="DHCHAI.IR.INFInvOper"
		Set xSubID=0,flagHave=0
		For {
			Set xSubID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(aDataType,"U"),aReportID,xSubID))
			Quit:xSubID=""
			
			Set RepExtID=aReportID_"||"_xSubID
			Set obj=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.Parref)
			Continue:'$IsObject(obj.Parref.IRStatusDr)
			Set StatusCode=obj.Parref.IRStatusDr.BTCode
			Continue:(StatusCode'="3")&&(StatusCode'="2")&&(StatusCode'="8") //只导审核+提交的报告
			
			Set ObjectID=obj.IRObjectID
			Continue:ObjectID=""
			
			Set objInvOper=##class(DHCHAI.IR.INFInvOper).GetObjById(ObjectID)
			Continue:'$IsObject(objInvOper)
			
			Set Code=objInvOper.IRInvOperDr.BTCode
			Set Desc=objInvOper.IRInvOperDr.BTDesc
			Set objXDic=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
			Continue:'$IsObject(objXDic)
			Do objXSum.InvasiveOperation.Insert(objXDic)
		}
	}
	
	//入住ICU（是/否)判断是否填写ICU调查登记表
	//是否手术
	Set OprList=objRep.GetRepLinkObjs("DHCHAI.IR.INFOPS")
	If (OprList.Count()>0) {
		Set Code=1
		Set Desc="是"
		Set objXSum.OprBoolean=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
	} Else {
		Set Code=0
		Set Desc="否"
		Set objXSum.OprBoolean=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
	}
	//病原学检验("NINFInfLabBoolean")(是/否)
	Set LabList=objRep.GetRepLinkObjs("DHCHAI.IR.INFLab")
	If (LabList.Count()>0) {
		Set Code=1
		Set Desc="是"
		Set objXSum.LabBoolean=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
	} else {
		Set Code=0
		Set Desc="否"
		Set objXSum.LabBoolean=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
	}
	//使用抗菌药物("NINFInfAntiBoolean")(是/否)
	Set AntiList=objRep.GetRepLinkObjs("DHCHAI.IR.INFAnti")
	If (AntiList.Count()>0) {
		Set Code=1
		Set Desc="是"
		Set objXSum.AntiBoolean=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
	} else {
		Set Code=0
		Set Desc="否"
		Set objXSum.AntiBoolean=##Class(DHCHAI.MK.INFDictionary).GetDicObj(Code_"^"_Desc)
	}
	
	If objXSum'="" Do objXSum.%Close()
	
	Quit objXSum
}

Storage Default
{
<Data name="INFReportState">
<Value name="1">
<Value>EpisodeID</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>ReportID</Value>
</Value>
<Value name="4">
<Value>ReportType</Value>
</Value>
<Value name="5">
<Value>ReportUser</Value>
</Value>
<Value name="6">
<Value>ReportStatus</Value>
</Value>
<Value name="7">
<Value>ReportDate</Value>
</Value>
<Value name="8">
<Value>ReportTime</Value>
</Value>
<Value name="9">
<Value>ReportLoc</Value>
</Value>
<Value name="10">
<Value>ReportWard</Value>
</Value>
<Value name="11">
<Value>FromPlace</Value>
</Value>
<Value name="12">
<Value>ToPlace</Value>
</Value>
<Value name="13">
<Value>InICUDate</Value>
</Value>
<Value name="14">
<Value>OutICUDate</Value>
</Value>
<Value name="15">
<Value>APACHEScore</Value>
</Value>
</Data>
<State>INFReportState</State>
<StreamLocation>^DHCHAI.MK.INFReportS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
