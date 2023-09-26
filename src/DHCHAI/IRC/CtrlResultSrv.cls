/// 名称: DHCHAI.IRC.CtrlResultSrv
/// 描述: 监控结果记录相关服务
/// 编写者：zhufei
/// 编写日期: 2017-03-20
Class DHCHAI.IRC.CtrlResultSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-05-03
/// Description:  监控结果筛查
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCResult
/// Input：       aSttDate : 开始日期
///               aEndDate : 结束日期
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CtrlResultSrv).GetCtrlResult("1403","2018-05-01","2018-06-06")
ClassMethod GetCtrlResult(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String) As %String
{
	New (aEpisodeDr,aSttDate,aEndDate)
	Set return=0
	Quit:(aEpisodeDr="")||(aSttDate="")||(aEndDate="") return
	
	Set $ZT="GetCtrlResultErr"
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set SttDate=objEpisode.PAAdmDate
	Set EndDate=objEpisode.PADischDate
	Set:EndDate="" EndDate=+$h
	
	// 发热
	Set ItmMastID=..GetActItmMastID("MR-ObsFever")
	Set flg=##class(DHCHAI.IRC.MRObsFeverSrv).Check(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 腹泻
	Set ItmMastID=..GetActItmMastID("MR-ObsDiarr")
	Set flg=##class(DHCHAI.IRC.MRObsDiarrSrv).Check(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 检出菌
	Set ItmMastID=..GetActItmMastID("LAB-Bacteria")
	Set flg=##class(DHCHAI.IRC.LabBacteriaSrv).Check(aEpisodeDr,SttDate,EndDate+15,ItmMastID)
	
	// 常规检验
	Set ItmMastID=..GetActItmMastID("LAB-TestAb")
	Set flg=##class(DHCHAI.IRC.LabTestAbSrv).Check(aEpisodeDr,SttDate,EndDate+15,ItmMastID)
	
	// 常规送检
	Set ItmMastID=..GetActItmMastID("LAB-Submit")
	Set flg=##class(DHCHAI.IRC.LabSubmitSrv).Check(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 抗菌用药
	Set ItmMastID=..GetActItmMastID("OE-AntiUse")
	Set flg=##class(DHCHAI.IRC.OEAntiUseSrv).Check(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 器械相关治疗
	Set ItmMastID=..GetActItmMastID("OE-Intubate")
	Set flg=##class(DHCHAI.IRC.OEOrdItemSrv).Check(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 手术切口
	Set ItmMastID=..GetActItmMastID("OR-Incision")
	Set flg=##class(DHCHAI.IRC.ORIncisionSrv).Check(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 放射学检查
	Set ItmMastID=..GetActItmMastID("RME-Radiology")
	Set flg=##class(DHCHAI.IRC.RBReportSrv).Check(aEpisodeDr,SttDate,EndDate+15,ItmMastID)
	
	// 症状或体征
	Set ItmMastID=..GetActItmMastID("RME-Symptom")
	Set flg=##class(DHCHAI.IRC.EmrAbnorSrv).Check(aEpisodeDr,SttDate,EndDate+15,ItmMastID)
	
	// 请会诊医嘱
	Set ItmMastID=..GetActItmMastID("OE-Consult")
	Set flg=##class(DHCHAI.IRC.OEConsultSrv).Check(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	//add 20190911 
	// 出院诊断
	Set ItmMastID=..GetActItmMastID("RME-Diagnos")
	Set flg=##class(DHCHAI.IRC.DiagnosSrv).Check(aEpisodeDr,SttDate,EndDate+15,ItmMastID)
	
	// 入院诊断
	Set ItmMastID=..GetActItmMastID("RME-AdmDiagnos")
	Set flg=##class(DHCHAI.IRC.DiagnosSrv).AdmCheck(aEpisodeDr,SttDate,EndDate+15,ItmMastID)

	// 会诊意见
	//Set ItmMastID=..GetActItmMastID("RME-Consult")
	//Set flg=##class(DHCHAI.IRC.OEConsultSrv).EmcCheck(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	//add 20191211 
	// 清创手术（手麻）
	Set ItmMastID=..GetActItmMastID("OR-Debridement")
	Set flg=##class(DHCHAI.IRC.ORDebridementSrv).Check(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 手术愈合等级（首页）
	Set ItmMastID=..GetActItmMastID("OR-Healing")
	Set flg=##class(DHCHAI.IRC.ORHealingSrv).Check(aEpisodeDr,SttDate,EndDate,ItmMastID)
	Quit 1
	
GetCtrlResultErr
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2017-05-03
/// Description:  监控结果筛查
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCResult
/// Input：       aSttDate : 开始日期
///               aEndDate : 结束日期
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CtrlResultSrv).GetCtrlResult2("1604","2018-08-01",+$h)
ClassMethod GetCtrlResult2(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String) As %String
{
	New (aEpisodeDr,aSttDate,aEndDate)
	Set return=0
	Quit:(aEpisodeDr="")||(aSttDate="")||(aEndDate="") return
	
	Set $ZT="GetCtrlResult2Err"
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set SttDate=objEpisode.PAAdmDate
	Set EndDate=objEpisode.PADischDate
	Set:EndDate="" EndDate=+$h
	
	// 发热
	Set ItmMastID=..GetActItmMastID("MR-ObsFever")
	Set flg=##class(DHCHAI.IRC.MRObsFeverSrv).Check2(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 腹泻
	Set ItmMastID=..GetActItmMastID("MR-ObsDiarr")
	Set flg=##class(DHCHAI.IRC.MRObsDiarrSrv).Check2(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 检出菌
	Set ItmMastID=..GetActItmMastID("LAB-Bacteria")
	Set flg=##class(DHCHAI.IRC.LabBacteriaSrv).Check2(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 常规检验
	Set ItmMastID=..GetActItmMastID("LAB-TestAb")
	Set flg=##class(DHCHAI.IRC.LabTestAbSrv).Check2(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 常规送检
	Set ItmMastID=..GetActItmMastID("LAB-Submit")
	Set flg=##class(DHCHAI.IRC.LabSubmitSrv).Check2(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 抗菌用药
	Set ItmMastID=..GetActItmMastID("OE-AntiUse")
	Set flg=##class(DHCHAI.IRC.OEAntiUseSrv).Check2(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 器械相关治疗
	Set ItmMastID=..GetActItmMastID("OE-Intubate")
	Set flg=##class(DHCHAI.IRC.OEOrdItemSrv).Check2(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 手术切口
	Set ItmMastID=..GetActItmMastID("OR-Incision")
	Set flg=##class(DHCHAI.IRC.ORIncisionSrv).Check2(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 放射学检查
	Set ItmMastID=..GetActItmMastID("RME-Radiology")
	Set flg=##class(DHCHAI.IRC.RBReportSrv).Check2(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 症状或体征
	Set ItmMastID=..GetActItmMastID("RME-Symptom")
	Set flg=##class(DHCHAI.IRC.EmrAbnorSrv).Check2(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	//add 20191211 
	// 请会诊医嘱
	Set ItmMastID=..GetActItmMastID("OE-Consult")
	Set flg=##class(DHCHAI.IRC.OEConsultSrv).Check2(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
    // 出院诊断
	Set ItmMastID=..GetActItmMastID("RME-Diagnos")
	Set flg=##class(DHCHAI.IRC.DiagnosSrv).Check2(aEpisodeDr,SttDate,EndDate+15,ItmMastID)
	
	// 入院诊断
	Set ItmMastID=..GetActItmMastID("RME-AdmDiagnos")
	Set flg=##class(DHCHAI.IRC.DiagnosSrv).Check2(aEpisodeDr,SttDate,EndDate+15,ItmMastID)

	// 清创手术（手麻）
	Set ItmMastID=..GetActItmMastID("OR-Debridement")
	Set flg=##class(DHCHAI.IRC.ORDebridementSrv).Check2(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 手术愈合等级（首页）
	Set ItmMastID=..GetActItmMastID("OR-Healing")
	Set flg=##class(DHCHAI.IRC.ORHealingSrv).Check2(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	Quit 1
	
GetCtrlResult2Err
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2018-03-26
/// Description:  检查监控结果是否有效
/// Table：       DHCHAI.IR.CCResult
/// Input：       obj : 监控记录
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CtrlResultSrv).CheckResultAct()
ClassMethod CheckResultAct(obj As DHCHAI.IR.CCResult) As DHCHAI.IR.CCResult
{
	New (obj)
	Set return=obj
	Quit:'$IsObject(obj) return
	Quit:obj.CCIsActive'=1 return
	Quit:'$IsObject(obj.CCItemDr)
	Set ItemCode=obj.CCItemDr.CCCode
	Set ObjectID=obj.CCObjectID
	Quit:ObjectID="" return
	
	Set IsActive=1
	If ((ItemCode="LAB-Bacteria")||(ItemCode="LAB-TestAb")) {
		//检验-检出菌、检验-常规检验异常 Set ObjectID=TSReportID_"||"_TestCode
		Set objID = $o(^DHCHAI.DP.LabVisitReportI("IndexLabReportID",+ObjectID,0))
		Set objVisitReport=##class(DHCHAI.DP.LabVisitReport).GetObjById(+objID)	
			
		Quit:'$IsObject(objVisitReport) return
		Set tIsActive=objVisitReport.LabIsActive
		Set:tIsActive=0 IsActive=0
	} ElseIf (ItemCode="LAB-Submit") {
		//检验-常规送检
		Set objVisitTestSet=##class(DHCHAI.DP.LabVisitTestSet).GetObjById(+ObjectID)
		Set objVisitNumber=objVisitTestSet.LabVisitNumberDr
		Quit:'$IsObject(objVisitNumber) return
		Set tIsActive=objVisitNumber.LabIsActive
		Set:tIsActive=0 IsActive=0
	} ElseIf ((ItemCode="MR-ObsFever")||(ItemCode="MR-ObsDiarr")) {
		//护理-发热、护理-腹泻
		Set objOBS=##class(DHCHAI.DP.MRObservations).GetObjById(+ObjectID)
		Quit:'$IsObject(objOBS) return
		Set tIsActive=objOBS.OBIsActive
		Set:tIsActive=0 IsActive=0
	} ElseIf ((ItemCode="OE-AntiUse")||(ItemCode="OE-Intubate")||(ItemCode="OE-Consult")) {
		//医嘱-抗菌用药、医嘱-器械相关治疗、医嘱-请会诊
		Set objOEItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(+ObjectID)
		Quit:'$IsObject(objOEItem) return
		Set tIsActive=objOEItem.OEIsActive
		Set:tIsActive=0 IsActive=0
	} ElseIf (ItemCode="RME-Symptom") {
		//语义-症状或体征、语义-诊断
		Set objRecord=##class(DHCHAI.DP.EmrRecord).GetObjById(+ObjectID)
		Quit:'$IsObject(objRecord) return
		Set tIsActive=objRecord.EmrIsActive
		Set:tIsActive=0 IsActive=0
	}ElseIf (ItemCode="RME-Diagnos")||(ItemCode="RME-AdmDiagnos") {
		//语义-诊断
		Set objDiag=##class(DHCHAI.DP.MRDiagnos).GetObjById(+ObjectID)
		Quit:'$IsObject(objDiag) return
		Set tIsActive=objDiag.MRIsActive
		Set:tIsActive=0 IsActive=0
	}  ElseIf (ItemCode="RME-Radiology") {
		//语义-放射学检查
		Set objRBReport=##class(DHCHAI.DP.RBReport).GetObjById(+ObjectID)
		Quit:'$IsObject(objRBReport) return
		Set tIsActive=objRBReport.RBIsActive
		Set:tIsActive=0 IsActive=0
	} ElseIf ((ItemCode="OR-Incision")||(ItemCode="OR-Debridement")) {
		//手术-手术切口、手术-清创术
		Set objOper=##class(DHCHAI.DP.OROperAnaes).GetObjById(+ObjectID)
		Quit:'$IsObject(objOper) return
		Set tIsActive=objOper.ORIsActive
		Set:tIsActive=0 IsActive=0
	}ElseIf (ItemCode="OR-Healing") {
		//手术-愈合等级
		Set objOper=##class(DHCHAI.DP.OROperation).GetObjById(+ObjectID)
		Quit:'$IsObject(objOper) return
		Set tIsActive=objOper.ORIsActive
		Set:tIsActive=0 IsActive=0
	}
	Quit:IsActive'=0 return
	
	//作废监控记录
	Set ResultID=obj.%Id()
	Set flg=##class(DHCHAI.IR.CCResult).CancelById(ResultID)
	Set return.CCIsActive=0
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2017-11-23
/// Description:  监控检出菌结
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCResult
/// Input：       aSttDate : 开始日期
///               aEndDate : 结束日期
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CtrlResultSrv).GetCtrlBactResult("1604","2018-08-01",+$h)
ClassMethod GetCtrlBactResult(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String) As %String
{
	New (aEpisodeDr,aSttDate,aEndDate)
	Set return=0
	Quit:(aEpisodeDr="")&((aSttDate="")||(aEndDate="")) return
	
	Set $ZT="GetCtrlBactResultErr"
	
	If aEpisodeDr'="" {  //按就诊获取监控结果
		Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
		Quit:'$IsObject(objEpisode) return
		Set SttDate=objEpisode.PAAdmDate
		//Set EndDate=objEpisode.PADischDate
		Set EndDate=+$h
	} Else {  //按增量方式获取监控结果
		Set:aSttDate["-" aSttDate=$zdh(aSttDate,3)
		Set:aSttDate="" aSttDate=+$h
		Set:aEndDate["-" aEndDate=$zdh(aEndDate,3)
		Set:aEndDate="" aEndDate=+$h
		Set SttDate=aSttDate
		Set EndDate=aEndDate
	}
	
	// 检出菌
	Set ItmMastID=..GetActItmMastID("LAB-Bacteria")
	Set flg=##class(DHCHAI.IRC.LabBacteriaSrv).Check(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	// 常规检验
	Set ItmMastID=..GetActItmMastID("LAB-TestAb")
	Set flg=##class(DHCHAI.IRC.LabTestAbSrv).Check(aEpisodeDr,SttDate,EndDate,ItmMastID)
	
	Quit 1
	
GetCtrlBactResultErr
	Quit "-999^"_$ZError
}

/// 根据代码取有效监控项目，返回有效ID 
/// w ##class(DHCHAI.IRC.CtrlResultSrv).GetActItmMastID("LAB-Bacteria")
ClassMethod GetActItmMastID(aItmMastCode As %String) As %String
{
	New (aItmMastCode)
	Set return=""
	Quit:aItmMastCode="" return
	Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjByCode(aItmMastCode)
	Quit:'$IsObject(objItmMast) return
	Quit:objItmMast.CCIsActive'=1 return
	Set return=objItmMast.%Id()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-05
/// Description:  保存监控结果
/// Table：       DHCHAI.IR.CCResult
/// Input：       objRecord : DHCHAI.IRC.CtrlRecord对象
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CtrlResultSrv).SaveResult(obj)
ClassMethod SaveResult(objRecord As DHCHAI.IRC.CtrlRecord) As %String
{
	New (objRecord)
	Set return=""
	Quit:'$IsObject(objRecord) return
	
	Set EpisodeDr=objRecord.CCEpisodeDr.%Id()
	Set ItemDr=objRecord.CCItemDr.%Id()
	Set SCode=objRecord.CCSCode
	Set ObjectID=objRecord.CCObjectID
	Quit:(EpisodeDr="")||(ItemDr="")||(SCode="")||(ObjectID="") return
	
	Set ID=$o(^DHCHAI.IR.CCResultI("IndexObjectID",EpisodeDr,ItemDr,SCode,ObjectID,0))
	
	Set KeyWordDr=""
	Set KeyWord=objRecord.CCKeyWord
	If KeyWord'="" {
		Set objKeyWord=##class(DHCHAI.IR.CCKeyWord).GetObjByDesc(KeyWord)
		If $IsObject(objKeyWord) {
			Set KeyWordDr=objKeyWord.%Id()
		}
	}

	Set InputStr=ID
	Set InputStr=InputStr_"^"_EpisodeDr
	Set InputStr=InputStr_"^"_ItemDr
	Set InputStr=InputStr_"^"_objRecord.CCResult
	Set InputStr=InputStr_"^"_objRecord.CCTextRes
	Set InputStr=InputStr_"^"_objRecord.CCUnit
	Set InputStr=InputStr_"^"_objRecord.CCActLocDr
	Set InputStr=InputStr_"^"_objRecord.CCActDate
	Set InputStr=InputStr_"^"_objRecord.CCActTime
	Set InputStr=InputStr_"^"_objRecord.CCActUser
	Set InputStr=InputStr_"^"_objRecord.CCRepDate
	Set InputStr=InputStr_"^"_objRecord.CCRepTime
	Set InputStr=InputStr_"^"_objRecord.CCRepUser
	Set InputStr=InputStr_"^"_1                        //是否有效
	Set InputStr=InputStr_"^"_+$h                      //更新日期
	Set InputStr=InputStr_"^"_$p($h,",",2)             //更新时间
	Set InputStr=InputStr_"^"_objRecord.CCSCode
	Set InputStr=InputStr_"^"_objRecord.CCObjectID
	Set InputStr=InputStr_"^"_objRecord.CCParams
	Set InputStr=InputStr_"^"_KeyWordDr
	Set InputStr=InputStr_"^"_objRecord.CCIsAbFlag
	Set InputStr=InputStr_"^"_objRecord.CCSpecimen
	Set InputStr=InputStr_"^"_objRecord.CCBacteria
	Set InputStr=InputStr_"^"_objRecord.CCMRBTpDr
	Set InputStr=InputStr_"^"_objRecord.CCAntiGrade
	Set InputStr=InputStr_"^"_objRecord.CCOperDate
	Set InputStr=InputStr_"^"_objRecord.CCIncision
	Set InputStr=InputStr_"^"_objRecord.CCAntiDesc
	Set InputStr=InputStr_"^"_objRecord.CCIsNotEnd
	Set InputStr=InputStr_"^"_objRecord.CCSummary
	Set InputStr=InputStr_"^"_objRecord.CCMRBTp2Dr
	Set InputStr=InputStr_"^"_objRecord.MultipleResChild
	
	Set return=##class(DHCHAI.IR.CCResult).Update(InputStr,"^")
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2018-04-01
/// Description:  作废监控结果
/// Table：       DHCHAI.IR.CCResult
/// Input：       
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CtrlResultSrv).CancelCCResult()
ClassMethod CancelCCResult(aEpisodeID, aItemDr, aSCode, aObjectID) As %String
{
	New (aEpisodeID,aItemDr,aSCode,aObjectID)
	Set return = ""
	Quit:(aEpisodeID="")||(aItemDr="")||(aSCode="")||(aObjectID="") return
	
	Set ID=$o(^DHCHAI.IR.CCResultI("IndexObjectID",aEpisodeID,aItemDr,aSCode,aObjectID,0))
	Quit:ID="" return
	
	Set return = ##class(DHCHAI.IR.CCResult).CancelById(ID)
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-09-04
/// Description:  处理以前数据的bug，objectID用的不一致
/// Table：       DHCHAI.IR.CCResult
/// Input：       obj : 监控记录
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CtrlResultSrv).UpdateResultActOld("2018-09-04","2018-09-04")
ClassMethod UpdateResultActOld(aStartDate As %String, aEndDate As %String) As %String
{
	New (aStartDate,aEndDate)
	
	Set xDate = 0
	For {
		Set xDate = $o(^DHCHAI.IR.CCResultI("IndexUpdateDate",xDate))
		Quit:xDate=""
		Set xTime = 0 
		For {
			Set xTime = $o(^DHCHAI.IR.CCResultI("IndexUpdateDate",xDate,xTime))
			Quit:xTime=""
			Set xID = 0
			For {
				Set xID = $o(^DHCHAI.IR.CCResultI("IndexUpdateDate",xDate,xTime,xID))
				Quit:xID=""
				Set obj =##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Quit:'$IsObject(obj)
				Quit:obj.CCIsActive'=0
				Quit:'$IsObject(obj.CCItemDr)
				Set ItemCode=obj.CCItemDr.CCCode
				Set ObjectID=obj.CCObjectID
				Quit:ObjectID=""
				
				Set IsActive =0
				If ((ItemCode="LAB-Bacteria")||(ItemCode="LAB-TestAb")) {
					//检验-检出菌、检验-常规检验异常Set ObjectID=TSReportID_"||"_TestCode
					Set objID = $o(^DHCHAI.DP.LabVisitReportI("IndexLabReportID",+ObjectID,0))
					Set objVisitReport=##class(DHCHAI.DP.LabVisitReport).GetObjById(+objID)	
						
					Quit:'$IsObject(objVisitReport)
					Set tIsActive=objVisitReport.LabIsActive
					Set:tIsActive'=0 IsActive=1
				} ElseIf (ItemCode="LAB-Submit") {
					//检验-常规送检
					Set objVisitTestSet=##class(DHCHAI.DP.LabVisitTestSet).GetObjById(+ObjectID)
					Set objVisitNumber=objVisitTestSet.LabVisitNumberDr
					Quit:'$IsObject(objVisitNumber)
					Set tIsActive=objVisitNumber.LabIsActive
					Set:tIsActive'=0 IsActive=1
				} ElseIf ((ItemCode="MR-ObsFever")||(ItemCode="MR-ObsDiarr")) {
					//护理-发热、护理-腹泻
					Set objOBS=##class(DHCHAI.DP.MRObservations).GetObjById(+ObjectID)
					Quit:'$IsObject(objOBS)
					Set tIsActive=objOBS.OBIsActive
					Set:tIsActive'=0 IsActive=1
				} ElseIf ((ItemCode="OE-AntiUse")||(ItemCode="OE-Intubate")||(ItemCode="OE-Consult")) {
					//医嘱-抗菌用药、医嘱-器械相关治疗、医嘱-请会诊
					Set objOEItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(+ObjectID)
					Quit:'$IsObject(objOEItem)
					Set tIsActive=objOEItem.OEIsActive
					Set:tIsActive'=0 IsActive=1
				} ElseIf ((ItemCode="RME-Symptom")||(ItemCode="RME-Diagnos")) {
					//语义-症状或体征、语义-诊断
					Set objRecord=##class(DHCHAI.DP.EmrRecord).GetObjById(+ObjectID)
					Quit:'$IsObject(objRecord)
					Set tIsActive=objRecord.EmrIsActive
					Set:tIsActive'=0 IsActive=1
				} ElseIf (ItemCode="RME-Radiology") {
					//语义-放射学检查
					Set objRBReport=##class(DHCHAI.DP.RBReport).GetObjById(+ObjectID)
					Quit:'$IsObject(objRBReport)
					Set tIsActive=objRBReport.RBIsActive
					Set:tIsActive'=0 IsActive=1
				} ElseIf (ItemCode="OR-Incision") {
					//手术-手术切口
					Set objOper=##class(DHCHAI.DP.OROperAnaes).GetObjById(+ObjectID)
					Quit:'$IsObject(objOper)
					Set tIsActive=objOper.ORIsActive
					Set:tIsActive'=0 IsActive=1
				}
				Quit:IsActive'=1
				
				//更正作废监控记录
				Set obj.CCIsActive=1
				Set obj.CCUpdateDate    = +$h
				Set obj.CCUpdateTime    = $p($h,",",2)
				Set sc=obj.%Save()
				if $system.Status.IsError(sc) {        //检查Save是否成功
			   		Do $system.OBJ.DisplayError(sc)			   		
				}else{
					Set return=return+1
				}
				
			}
		}
		
	}
	Quit return
}

}
