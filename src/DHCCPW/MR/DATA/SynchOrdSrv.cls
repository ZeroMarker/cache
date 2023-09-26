/// 名称: DHCCPW.MR.DATA.SynchOrdSrv
/// 描述: 医嘱同步相关服务
/// 编写者：zhufei
/// 编写日期: 2015-06-17
Class DHCCPW.MR.DATA.SynchOrdSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(DHCCPW.MR.DATA.SynchOrdSrv).SynchOrder()
ClassMethod SynchOrder()
{
	New
	Set xPathWayID=0,Count=0
	For {
		Set xPathWayID=$o(^DHCMR("CPW",xPathWayID))
		Quit:xPathWayID=""
		
		Set Count=Count+1
		w:(Count#10)=0 "Count="_Count,!
		
		Set flg=..SynchOrderByPathWay(xPathWayID)
		W:flg>0 "PathWayID="_xPathWayID,!
	}
	Quit "OK"
}

/// Creator:		zhufei
/// CreatDate:		2015-06-19
/// Description:	同步医嘱数据
/// Table:        	User.DHCMRClinicalPathWayOrder
/// Input:        	PathWayID ：就诊号
/// Return:       	return>0：成功    return<=0: 失败
/// w ##class(DHCCPW.MR.DATA.SynchOrdSrv).SynchOrderByPathWay(22)
ClassMethod SynchOrderByPathWay(aPathWayID As %String) As %String
{
	New (aPathWayID,aSaveFlag)
	Set return=0
	Quit:aPathWayID="" return
	
	Set objPathWay=##class(User.DHCMRClinicalPathWay).GetObjById(aPathWayID)
	Quit:'$IsObject(objPathWay) return
	Set MRAdm=objPathWay.CPWMRADMDR
	Set EpisodeID=##class(DHCCPW.MR.BASE.PaadmSrv).GetEpisodeID(MRAdm)
	Quit:EpisodeID="" return
	
	//add by zf 20150821 两次医嘱同步在30秒以上
	Set tmpDateTime=$g(^MR("OrderUpdateTime",aPathWayID))
	Set currDateTime=$h
	If tmpDateTime'="" {
		Set tmpDate=$p(tmpDateTime,",",1)
		Set tmpTime=$p(tmpDateTime,",",2)
		Set currDate=$p(currDateTime,",",1)
		Set currTime=$p(currDateTime,",",2)
		Quit:(currDate=tmpDate)&&((currTime-tmpTime)<30) return
	}
	Set ^MR("OrderUpdateTime",aPathWayID)=currDateTime
	
	Set OrdID=$o(^OEORD(0,"Adm",EpisodeID,0))
	Quit:OrdID="" return
	Set AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	Quit:AdmType'="I" return
	
	Set FromDate=$o(^MRi("Order","IndexUpdateDate"," "_aPathWayID,""),-1)
	//Set:FromDate="" FromDate=$p($g(^PAADM(EpisodeID)),"^",6)  //入院时间
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set FromDate=$p(AdmDateTime,"^",1)
	Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(EpisodeID)
	Set ToDate=$p(DischDateTime,"^",1)
	//Set ToDate=$p($g(^PAADM(EpisodeID)),"^",17)  //出院时间
	
	Set IsV7Episode=##class(DHCCPW.MR.DATA.SynchOrdSrv).CheckIsV7Episode(EpisodeID)
	
	Set return=-1
	Set xStatDate=FromDate-1,IsError=0
	For {
		Set xStatDate=$o(^OEORDi(0,"StatDate",xStatDate))
		Quit:xStatDate=""
		Quit:(ToDate'="")&&(xStatDate>ToDate)
		Continue:'$d(^OEORDi(0,"StatDate",xStatDate,OrdID))
		
		Set xSubID=0
		For {
			Set xSubID=$o(^OEORDi(0,"StatDate",xStatDate,OrdID,xSubID))
			Quit:xSubID=""
			
			Set OEItemID=OrdID_"||"_xSubID  //医嘱ID
			Set flg=$$SaveOrderItem(aPathWayID,OEItemID)
			Set:flg<0 IsError=1
		}
	}
	Quit:IsError>0 return
	
	Set return=-2
	Set xItmDate=FromDate-1,IsError=0
	For {
		Set xItmDate=$o(^OEORDi(0,"ItemDate",xItmDate))
		Quit:xItmDate=""
		Quit:(ToDate'="")&&(xItmDate>ToDate)
		Continue:'$d(^OEORDi(0,"ItemDate",xItmDate,OrdID))
		
		Set xSubID=0
		For {
			Set xSubID=$o(^OEORDi(0,"ItemDate",xItmDate,OrdID,xSubID))
			Quit:xSubID=""
			
			Set OEItemID=OrdID_"||"_xSubID  //医嘱ID
			Set flg=$$SaveOrderItem(aPathWayID,OEItemID)
			Set:flg<0 IsError=1
		}
	}
	Quit:IsError>0 return
	
	Set return=1
	Quit return
	
SaveOrderItem(PathWayID,OEItemID)
	Set (PHCGeneDesc,OrdStatusCode,OrdStatusDesc,PriorityCode,PriorityDesc,FreqCode,FreqDesc)=""
	Set ArcimID=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",2)                //医嘱项
	Quit:ArcimID="" 0
	
	Set PHCGeneID=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),8)),"^",20)                   //通用名
	Set:PHCGeneID'="" PHCGeneDesc=$p($g(^PHCGE("GE",PHCGeneID)),"^",2)
	Set:PHCGeneDesc="" PHCGeneDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)   //医嘱名称
	Quit:PHCGeneDesc["床位费" 0  //特殊医嘱不算临床路径医嘱
	Quit:PHCGeneDesc["取暖费" 0  //特殊医嘱不算临床路径医嘱
	Quit:PHCGeneDesc["空调费" 0  //特殊医嘱不算临床路径医嘱
	Quit:PHCGeneDesc["诊查费" 0  //特殊医嘱不算临床路径医嘱
	
	Set OrdStatusID=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",13)           //医嘱状态
	If OrdStatusID'="" {
		Set OrdStatusCode=$p($g(^OEC("OSTAT",OrdStatusID)),"^",1)
		Set OrdStatusDesc=$p($g(^OEC("OSTAT",OrdStatusID)),"^",2)
	}
	Set PriorityID=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",8)             //医嘱类型
	Quit:PriorityID="" 0  //无医嘱类型退出
	If PriorityID'="" {
		Set PriorityCode=$p($g(^OECPR(PriorityID)),"^",1)
		Set PriorityDesc=$p($g(^OECPR(PriorityID)),"^",2)
	}
	Set FreqID=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),2)),"^",4)                 //医嘱频次
	If FreqID'="" {
		Set FreqCode=$p($g(^PHCFR(FreqID)),"^",1)
		Set FreqDesc=$p($g(^PHCFR(FreqID)),"^",4)
	}
	Set InsertDate=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",19)            //插入日期
	Set InsertTime=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",20)            //插入时间
	
	Set ISLongOrderPrior=##class(DHCCPW.IO.FromHisSrv).ISLongOrderPrior(PriorityID)
	Set IsHourOrder=##class(DHCCPW.IO.FromHisSrv).IsHourOrder(ArcimID)
	
	Set SttDate=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",9)            //开始日期
	Set SttTime=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",10)           //开始时间
	Set XDate=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),3)),"^",34)             //停止日期
	Set XTime=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),2)),"^",15)             //停止时间
	
	//C撤销,U作废,I未审核,D停止
	If IsV7Episode="1" {  //滚执行记录模式
		If (OrdStatusCode="C")||(OrdStatusCode="U")||(OrdStatusCode="I") {
			Set IsActive=0
			Set OrdDays=0
		} ElseIf (OrdStatusCode="D")&&(IsHourOrder'="1")&&(ISLongOrderPrior'="1") {  //非长期医嘱,停止医嘱无效
			Set IsActive=0
			Set OrdDays=0
		} ElseIf (IsHourOrder="1") {  //HOUR医嘱,停止医嘱有效
			Set IsActive=1
			Set OrdDays=999
			Set:XDate'="" OrdDays=XDate-SttDate+1
		} Else {
			Set IsActive=1
			If (ISLongOrderPrior=1) {
				Set OrdDays=999
				If XDate'="" {
					Set flg=##class(DHCCPW.MR.DATA.SynchOrdSrv).CheckOrdExecByDate(OEItemID,XDate)
					If flg>0 {
						Set OrdDays=XDate-SttDate+1
					} Else {
						Set OrdDays=XDate-SttDate
					}
				}
			} Else {
				Set OrdDays=1
			}
		}
	} Else {  //滚医嘱模式
		Set FillerNo=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),9)),"^",12)
		Set FillerNo=$p(FillerNo,"!!",1)
		
		If (OrdStatusCode="C")||(OrdStatusCode="U")||(OrdStatusCode="I") {
			Set IsActive=0
			Set OrdDays=0
		} ElseIf (OrdStatusCode="D")&&(IsHourOrder'="1") {  //停止医嘱无效
			Set IsActive=0
			Set OrdDays=0
		} ElseIf (IsHourOrder="1") {  //HOUR医嘱,停止医嘱有效
			Set IsActive=1
			Set OrdDays=999
			Set:XDate'="" OrdDays=XDate-SttDate+1
		} Else {
			Set IsActive=1
			Set OrdDays=1
		}
	}
	
	Set InputStr=PathWayID
	Set InputStr=InputStr_"^"_OEItemID
	Set InputStr=InputStr_"^"_ArcimID
	Set InputStr=InputStr_"^"_PHCGeneDesc
	Set InputStr=InputStr_"^"_OrdStatusDesc
	Set InputStr=InputStr_"^"_PriorityDesc
	Set InputStr=InputStr_"^"_FreqDesc
	Set InputStr=InputStr_"^"_SttDate
	Set InputStr=InputStr_"^"_SttTime
	Set InputStr=InputStr_"^"_XDate
	Set InputStr=InputStr_"^"_XTime
	Set InputStr=InputStr_"^"_OrdDays
	Set InputStr=InputStr_"^"_IsActive
	Set InputStr=InputStr_"^"_InsertDate
	Set InputStr=InputStr_"^"_InsertTime
	Set ret=##class(User.DHCMRClinicalPathWayOrder).Update(InputStr)
	If ret<0 {
		//w "ret="_ret_",Input="_InputStr,!
		Quit -1
	}
	Quit 1
}

/// Creator:		zhufei
/// CreatDate:		2015-06-30
/// Description:	根据日期检查医嘱执行记录
/// Table:        	OE_OrdExec
/// Input:        	EpisodeID ：就诊号
/// Return:       	return>0：成功    return=0: 失败
/// w ##class(DHCCPW.MR.DATA.SynchOrdSrv).CheckOrdExecByDate("4||1",62854)
ClassMethod CheckOrdExecByDate(aOEItemID As %String, aDate As %String) As %String
{
	New (aOEItemID,aDate)
	Set return=0
	Quit:(aOEItemID="")||(aDate="") return
	
	Set xSttTime=""
	For {
		Set xSttTime=$o(^OEORDi(0,"NotExecE",+aOEItemID,aDate,xSttTime))
		Quit:xSttTime=""
		Quit:return>0
		
		Set xSub=""
		For {
			Set xSub=$o(^OEORDi(0,"NotExecE",+aOEItemID,aDate,xSttTime,+$p(aOEItemID,"||",2),xSub))
			Quit:xSub=""
			Quit:return>0
			
			Set tmpOrdExec=$g(^OEORD(+aOEItemID,"I",$p(aOEItemID,"||",2),"X",xSub))
			Set ExStatus=$p(tmpOrdExec,"^",16)
			Set:ExStatus'="" ExStatus=$p($g(^OEC("STAT",ExStatus)),"^",1)
			Continue:(ExStatus'="F")&&(ExStatus'="")  //已执行
			Set return=1
		}
	}
	
	Quit return
}

/// Creator:		zhufei
/// CreatDate:		2015-06-19
/// Description:	检查滚医嘱类型版本(7:滚执行记录)
/// Table:        	User.DHCMRCBaseConfig
/// Input:        	EpisodeID ：就诊号
/// Return:       	return>0：成功    return=0: 失败
/// w ##class(DHCCPW.MR.DATA.SynchOrdSrv).CheckIsV7Episode(189)
ClassMethod CheckIsV7Episode(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Set StDtTmIndex=##class(User.DHCMRCBaseConfig).GetValueByCode("OEOrdItemStDtTmIndex")
	If StDtTmIndex="StDtTmNew" {
		Set return=1
	} Else {
		Set return=##class(DHCCPW.IO.FromHisSrv).isV7Episode(aEpisodeID)
	}
	Quit return
}

}
