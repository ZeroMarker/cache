/// 名称: DHCHAI.IO.ToHisSrv
/// 描述: 为HIS提供接口服务
/// 编写者：pylian
/// 编写日期: 2020-01-17
Class DHCHAI.IO.ToHisSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2020-01-17
/// Description:  获取患者是否存在管理科未读消息
/// Table：       DHCHAI.IR.CCMessage
/// Input：       aEpisodeID:就诊号
/// Return：      0:无消息，或未读消息，1：有未读消息
/// w ##class(DHCHAI.IO.ToHisSrv).GetMsgIsUnRead("90")
ClassMethod GetMsgIsUnRead(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:(aEpisodeID="") return
	Set EpisodeDr=##class(DHCHAI.CUS.ToClinReport).GetEpisodeDr(aEpisodeID,0)
	Quit:EpisodeDr="" return
	Quit:'$d(^DHCHAI.IR.CCMessageI("IndexPaadmDate",EpisodeDr)) return

	Set Flg =0
	Set xMsgDate =""
 	For {
	 	Set xMsgDate = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",EpisodeDr,xMsgDate))
		Quit:xMsgDate=""
		Quit:Flg=1
		
		Set xMsgTime = ""
		For {
			Set xMsgTime = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",EpisodeDr,xMsgDate,xMsgTime))
			Quit:xMsgTime=""
			Quit:Flg=1
			
		 	Set xMsgID = ""
			For {
				Set xMsgID = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",EpisodeDr,xMsgDate,xMsgTime,xMsgID))
				Quit:xMsgID=""
				Quit:Flg=1
				Set objMsg = ##class(DHCHAI.IR.CCMessage).GetObjById(xMsgID)
				Continue:'$Isobject(objMsg)
				Continue:objMsg.CSIsRead=1
				Set MsgType = objMsg.CSMsgType  //1院感、2临床、3多耐
				If (MsgType=1)||(MsgType=3) {    //院感科发送的消息(多耐消息)，科室未阅读
					Set Flg=1
				}
			}
		}
 	}
	
	Set return=Flg
	
	Quit return
}

/// Creator：     liutao
/// CreatDate：   2022-09-28
/// Description:  获取患者是否属于疑似未处理或确诊未上报
/// Input：       aEpisodeID:就诊号
/// Table：       DHCHAI.IR.CCScreening
/// Return：      0:不属于，1：属于
/// w ##class(DHCHAI.IO.ToHisSrv).GetEpisodeStatus("453")
ClassMethod GetEpisodeStatus(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	Set EpisodeDr=##class(DHCHAI.CUS.ToClinReport).GetEpisodeDr(aEpisodeID,0)
	Quit:EpisodeDr="" return
	
	Set AttID=$o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",EpisodeDr,0))
	Quit:AttID="" return
	Set objAtt=##class(DHCHAI.IR.CCScreenAtt).GetObjById(AttID)
	Quit:'$IsObject(objAtt) return
	Set IsSusInf=objAtt.CSIsSusInf    //疑似病例  （1疑似病例）
	Set IsSuspend=objAtt.CSIsSuspend  //处置病例  （0待处理、1已确诊、2已排除、3已上报）
	
	//获取患者需上报数量
	Set ConfRepCnt=##class(DHCHAI.IRS.CCScreeningSrv).GetConfRepCnt(EpisodeDr)
	Set ConfCnt = $p(ConfRepCnt,"^",1)
	Set RepCnt = $p(ConfRepCnt,"^",2)
	Set NeedRepCnt=ConfCnt-RepCnt
	
	Set WaitDo=0    //疑似待处理
	Set Unreg=0     //确诊未上报
	Set:(IsSusInf=1)&(IsSuspend=0) WaitDo=1
	Set:NeedRepCnt>0 Unreg=1	
	Set return=WaitDo_"^"_Unreg
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2023-03-20
/// Description:  获取患者是否存在感染(以感染报告审核为准)
/// Table：       
/// Input：       aEpisodeID:HIS就诊号
/// Return：      0:无感染 1：有感染
/// w ##class(DHCHAI.IO.ToHisSrv).GetInfByEpisodeID("90")
/// w ##class(DHCHAI.IO.ToHisSrv).GetInfByEpisodeID("120")
ClassMethod GetInfByEpisodeID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:(aEpisodeID="") return
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX("HIS01"_"||"_aEpisodeID)
	Quit:'$IsObject(objEpisode) return
	
	Set aEpisodeDr=objEpisode.%Id()
	Set xRepType=""
	For {
		Set xRepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType))
		Quit:xRepType=""
		Quit:return=1
		Continue:(xRepType'=1) //1医院感染报告
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType,xID))
			Quit:xID=""
			Quit:return=1
			Set objInfRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
			Continue:'$IsObject(objInfRep)
			Continue:'$IsObject(objInfRep.IRStatusDr)
			Set StatusCode=objInfRep.IRStatusDr.BTCode
			Continue:StatusCode'="3"  //1保存、2提交、3审核、4删除、5退回、6取消审核
			Set return=1
		}
	}
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2023-03-28
/// Description:  查询本次就诊是否发生手术切口感染(以感染报告审核为准)
/// Table：       
/// Input：       aEpisodeID:HIS就诊号
/// Return：      0:否 1：是
/// w ##class(DHCHAI.IO.ToHisSrv).GetOperInfByEpID("262689")
ClassMethod GetOperInfByEpID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:(aEpisodeID="") return
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX("HIS01"_"||"_aEpisodeID)
	Quit:'$IsObject(objEpisode) return
	
	Set aEpisodeDr=objEpisode.%Id()
	Set xRepType=""
	For {
		Set xRepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType))
		Quit:xRepType=""
		Quit:return=1
		Continue:(xRepType'=1) //1医院感染报告
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType,xID))
			Quit:xID=""
			Quit:return=1
			Set objInfRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
			Continue:'$IsObject(objInfRep)
			Continue:'$IsObject(objInfRep.IRStatusDr)
			Set StatusCode=objInfRep.IRStatusDr.BTCode
			Continue:StatusCode'="3"  //1保存、2提交、3审核、4删除、5退回、6取消审核
			// 感染诊断信息
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xID,xSub))
				Quit:xSub=""
				Quit:return=1
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DiagID=$lg(INFRepExtData,3)
				Continue:DiagID=""
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Continue:DiagsData=""
				Continue:$lg(DiagsData,3)=""  //20211217 处理感染诊断变化导致的bug
				// 感染诊断
				Set InfPos = $lg(DiagsData,3)
				Set InfPosData=$g(^DHCHAI.BT.InfPosD(InfPos))
				Continue:InfPosData=""
				Set InPosDiag = $lg(InfPosData,3)
				If ((InPosDiag["表浅")||((InPosDiag["深部"))||((InPosDiag["器官和腔隙感染"))){
					Set return=1
				}
			}			
		}
	}
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2023-03-20
/// Description:  查询本次就诊的医院感染是否与手术相关(以感染报告审核为准)
/// Table：       
/// Input：       aEpisodeID:HIS就诊号
/// Return：      0:否 1：是
/// w ##class(DHCHAI.IO.ToHisSrv).GetInfOpsByEpisodeID("90")
/// w ##class(DHCHAI.IO.ToHisSrv).GetInfOpsByEpisodeID("1")
ClassMethod GetInfOpsByEpisodeID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:(aEpisodeID="") return
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX("HIS01"_"||"_aEpisodeID)
	Quit:'$IsObject(objEpisode) return
	
	Set aEpisodeDr=objEpisode.%Id()
	Set xRepType=""
	For {
		Set xRepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType))
		Quit:xRepType=""
		Quit:return=1
		Continue:(xRepType'=1) //1医院感染报告
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType,xID))
			Quit:xID=""
			Quit:return=1
			Set objInfRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
			Continue:'$IsObject(objInfRep)
			Continue:'$IsObject(objInfRep.IRStatusDr)
			Set StatusCode=objInfRep.IRStatusDr.BTCode
			Continue:StatusCode'="3"  //1保存、2提交、3审核、4删除、5退回、6取消审核
			
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFOPS","U"),xID,xSub))
				Quit:xSub=""
				Quit:return=1
				Set RepExtID=xID_"||"_xSub
				Set objExt=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
				Continue:'$IsObject(objExt)
				Set return=1
			}			
		}
	}
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2023-03-20
/// Description:  医院感染是否与侵入性操作相关(以感染报告审核为准)
/// Table：       
/// Input：       aEpisodeID:HIS就诊号
/// Return：      0:否 1：是
/// w ##class(DHCHAI.IO.ToHisSrv).GetInfInvOperByEpisodeID("90")
/// w ##class(DHCHAI.IO.ToHisSrv).GetInfInvOperByEpisodeID("1")
ClassMethod GetInfInvOperByEpisodeID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:(aEpisodeID="") return
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX("HIS01"_"||"_aEpisodeID)
	Quit:'$IsObject(objEpisode) return
	
	Set aEpisodeDr=objEpisode.%Id()
	Set xRepType=""
	For {
		Set xRepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType))
		Quit:xRepType=""
		Quit:return=1
		Continue:(xRepType'=1) //1医院感染报告
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeDr,xRepType,xID))
			Quit:xID=""
			Quit:return=1
			Set objInfRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
			Continue:'$IsObject(objInfRep)
			Continue:'$IsObject(objInfRep.IRStatusDr)
			Set StatusCode=objInfRep.IRStatusDr.BTCode
			Continue:StatusCode'="3"  //1保存、2提交、3审核、4删除、5退回、6取消审核
			
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFInvOper","U"),xID,xSub))
				Quit:xSub=""
				Quit:return=1
				Set RepExtID=xID_"||"_xSub
				Set objExt=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
				Continue:'$IsObject(objExt)
				Set return=1
			}			
		}
	}
	
	Quit return
}

}
