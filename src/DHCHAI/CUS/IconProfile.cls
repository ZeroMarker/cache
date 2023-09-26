/// 名称: DHCHAI.CUS.IconProfile
/// 描述: 院感图标管理
/// 编写者：zhufei
/// 编写日期: 2018-01-29
Class DHCHAI.CUS.IconProfile Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2018-01-29
/// Description:  院感图标管理
/// Table：       DHCHAI.IR.INFDiagnos、DHCHAI.IR.CCScreenAtt
/// Input：       aEpisodeID : HIS就诊号
/// Return：      返回值String
/// 原有类方法；  ##Class(DHCMed.NINFService.BC.IconProfile).CheckIcon()
/// w ##Class(DHCHAI.CUS.IconProfile).CheckIcon(54943884,0)
ClassMethod CheckIcon(aEpisodeID As %String, aCheckFlag As %String)
{
	new (aEpisodeID,aCheckFlag)
	set return=""
	quit:(aEpisodeID="")||(aCheckFlag="") return
	
	Set $ZT="CheckIconErr"
	
	Set EpisodeDr=##class(DHCHAI.CUS.ToClinReport).GetEpisodeDr(aEpisodeID,0)
	Quit:EpisodeDr="" return

	//绿色图标 确诊未上报、报告退回
	If aCheckFlag=1 {
		Set ConfRepCnt=##class(DHCHAI.IRS.CCScreeningSrv).GetConfRepCnt(EpisodeDr)
		Set ConfCnt = $p(ConfRepCnt,"^",1)
	    Set RepCnt = $p(ConfRepCnt,"^",2)
	    Set NeedCnt = ConfCnt-RepCnt	
		If (NeedCnt>0) {
			Set return="确诊未上报"
			Quit return	//退出
		}
		Set xRepType = "",IsReturn =0
		For {
			Set xRepType = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",EpisodeDr,xRepType))
			Quit:xRepType=""
			Continue:(xRepType'=1)
		    Quit:IsReturn=1
		    
		    Set xRepID = ""
			For {
				Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",EpisodeDr,xRepType,xRepID))
				Quit:xRepID=""			
	
				Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				Continue:'$IsObject(objReport)
				Continue:'$IsObject(objReport.IREpisodeDr)
				Continue:'$IsObject(objReport.IRStatusDr)
				Continue:objReport.IRStatusDr.BTCode'=5
				Set IsReturn =1
			}
		}
		If (IsReturn=1) {
			Set return="报告退回"
			Quit return //退出
		}
		
	} Else {   //黄色图标 疑似待处理 
		Set AttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(EpisodeDr)
		If AttInfo'="" {
			Set IsSusInf=$p(AttInfo,"^",2)
			Set IsSuspend=$p(AttInfo,"^",3)
			If (IsSusInf=1)&(IsSuspend=0) { //疑似待处理
				Set return="疑似待处理"
			}
		}
	}
	
	quit return
	
CheckIconErr
	quit $ZError
}

}
