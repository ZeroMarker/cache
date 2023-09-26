Class web.DHCLisRealTimeInterfaceDel Extends %RegisteredObject
{

/// 版本8.5.3检验消息不再使用这个CLS  202211
/// Creator：      liuzf
/// CreatDate：    20210718改SQL查询为Globle
/// Description:   实时发送检验消息报告
///   1.SendAuthoriseMsg:审核消息
///   2.SendReAuthoriseMsg:复审核消息
///   3.SendReportUndoMsg:报取消消息
///   4.SendPanicMsg:危机值消息
///   5.SendSampleRejectMsg:拒收消息
/// d ##Class(web.DHCLisRealTimeInterface).Do()
ClassMethod Do()
{
	///发送接收消息
	d ..SendReceiveMsg()
	///发送核收消息
	d ..SendAcceptMsg()
	///发送复审消息
	d ..SendReAuthoriseTMsg()
	///发送取消审核消息
	d ..SendReportUndoTMsg()
	///发送审核信息
	d ..SendHISAuthoriseMsg()
	///发送中间报告审核消息
	d ..SendMidReportMsg()
	///发送发布报告消息
	//d ..SendHISReportMsg()
	///发送取消核收消息
	d ..SendCACCEPTMsg()
	///发送危机值结果消息
	d ..SendHISPanicResultMsg()
	///发送危机值未处理消息
	d ..SendHISPanicOutTimeMsg()
	///发送拒收消息
	d ..SendHISRejectMsg()
	///发送HIS传染病消息
	d ..SendHISInfectMsg()
	///发送多耐消息
	d ..SendMultipleResistantMsg()
	///血库消息
	d ..SendHISBdNoticeMsg()
}

/// 发送接收消息
ClassMethod SendReceiveMsg() As %String
{
	s ret=""
	///发送接收消息
	s MsgTypeI=##Class(LIS.Util.Common).IndexData("Receive")
	s MsgDR="" f  
	{
		s MsgDR=$o(^dbo.OTMsgStockI("IndexIsReply",MsgTypeI,0,MsgDR)) 
		q:MsgDR=""
		try
		{
			s VisitNumberDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),17)
			s UserDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),7)   
 			//平台标本状态更新消息接口
			s AddDate=$lg($g(^dbo.OTMsgStockD(MsgDR)),2)
			s AddTime=$lg($g(^dbo.OTMsgStockD(MsgDR)),3)
			s VisitNumberReportDR=""
			s Msg="Receive"
			//更新发送记录
			s ret=##Class(web.DHCLisRealTimeInterface).UpdateMsg(MsgDR,"1","")
			s ret=##Class(web.DHCLisRealTimeInterface).SendDHCHisInterface(MsgDR, VisitNumberDR, VisitNumberReportDR, UserDR, AddDate, AddTime, Msg)
		}
		catch ex
		{
			s ret=ex.Data	
		} 
	} 
		
	q ret
}

/// 发送核收消息
ClassMethod SendAcceptMsg() As %String
{
	s ret=""
	
	///发送核收消息
	s MsgTypeI=##Class(LIS.Util.Common).IndexData("Accept")
	s MsgDR="" f  
	{
		s MsgDR=$o(^dbo.OTMsgStockI("IndexIsReply",MsgTypeI,0,MsgDR)) 
		q:MsgDR=""  
		try
		{
			s VisitNumberReportDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),17)
			s UserDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),7)   
 			//平台标本状态更新消息接口
			s AddDate=$lg($g(^dbo.OTMsgStockD(MsgDR)),2)
			s AddTime=$lg($g(^dbo.OTMsgStockD(MsgDR)),3)
			s Msg="Accept"
			//更新发送记录
			s ret=##Class(web.DHCLisRealTimeInterface).UpdateMsg(MsgDR,"1","")
			s ret=##Class(web.DHCLisRealTimeInterface).SendDHCHisInterface(MsgDR, VisitNumberDR, VisitNumberReportDR, UserDR, AddDate, AddTime, Msg) 
		}
		catch ex
		{
			s ret=ex.Data	
		} 
		}	
	q ret
}

/// 发送复审消息
ClassMethod SendReAuthoriseTMsg() As %String
{
	s ret=""
	
	///发送复审消息
	s MsgTypeI=##Class(LIS.Util.Common).IndexData("HISReAuthorise")
	s MsgDR="" f  
	{
		s MsgDR=$o(^dbo.OTMsgStockI("IndexIsReply",MsgTypeI,0,MsgDR)) 
		q:MsgDR=""
		try
		{
			s VisitNumberReportDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),17)
			s UserDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),7)
			//更新发送记录
			s ret=##Class(web.DHCLisRealTimeInterface).UpdateMsg(MsgDR,"1","")
			s ret=##Class(web.DHCLisRealTimeInterface).SendAuthoriseMsg(MsgDR,VisitNumberReportDR,UserDR)
		}
		catch ex
		{
			s ret=ex.Data
		}
	}
	q ret
}

/// 发送取消审核消息
ClassMethod SendReportUndoTMsg() As %String
{
	s ret=""
	
	///发送取消审核消息
	s MsgTypeI=##Class(LIS.Util.Common).IndexData("HISReportUndo")
	s MsgDR="" f  
	{
		s MsgDR=$o(^dbo.OTMsgStockI("IndexIsReply",MsgTypeI,0,MsgDR)) 
		q:MsgDR=""
		try
		{
			s VisitNumberReportDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),17)
			s UserDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),7)
			s Msg=$lg($g(^dbo.OTMsgStockD(MsgDR)),10)    
			//平台标本状态更新消息接口
			s AddDate=$lg($g(^dbo.OTMsgStockD(MsgDR)),2)
			s AddTime=$lg($g(^dbo.OTMsgStockD(MsgDR)),3)
			s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),2)
			//更新发送记录
			s ret=##Class(web.DHCLisRealTimeInterface).UpdateMsg(MsgDR,"1","")
			s ret=##Class(web.DHCLisRealTimeInterface).SendReportUndoMsg(MsgDR,VisitNumberReportDR,UserDR,Msg)
			s Msg="CRP"
			s ret=##Class(web.DHCLisRealTimeInterface).SendDHCHisInterface(MsgDR, VisitNumberDR, VisitNumberReportDR, UserDR, AddDate, AddTime, Msg) 
		}
		catch ex
		{
			s ret=ex.Data
		}
	}
	q ret
}

/// 发送审核消息
ClassMethod SendHISAuthoriseMsg() As %String
{
	s ret=""
	
	s SelfPrintDelayMin=""
	s SelfPrintDelayMinRowId=$o(^dbo.SYSParameterI("IndexCode"," SELFPRINTDELAYMIN"," SYS"," DHCC",""))
	i $l(SelfPrintDelayMinRowId) s SelfPrintDelayMin=$lg($g(^dbo.SYSParameterD(SelfPrintDelayMinRowId)),5)
	///发送审核消息
	s MsgTypeI=##Class(LIS.Util.Common).IndexData("HISAuthorise")
	s MsgDR="" f  
	{
		s MsgDR=$o(^dbo.OTMsgStockI("IndexIsReply",MsgTypeI,0,MsgDR)) 
		q:MsgDR=""  
		try
		{
			s VisitNumberReportDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),17)
			s UserDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),7)
 			//平台标本状态更新消息接口
			s AddDate=$lg($g(^dbo.OTMsgStockD(MsgDR)),2)
			s AddTime=$lg($g(^dbo.OTMsgStockD(MsgDR)),3)
			s ShouldQ=0
			i $l(SelfPrintDelayMin) d
			.s DiffMin=##Class(LIS.Util.Common).GetDateTimeDiff($zd($h,8),$p($h,",",2),AddDate,AddTime)
			.s DiffMin=$p(DiffMin,",",3)
			.//小于延迟分钟认为附加任务没执行完
			.i DiffMin<SelfPrintDelayMin s ShouldQ=1
			i ShouldQ=1 continue
			s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),2)
			s Msg="RP"
			s ret=##Class(web.DHCLisRealTimeInterface).SendAuthoriseMsg(MsgDR,VisitNumberReportDR,UserDR)
			i ret'["-1^" d ##Class(web.DHCLisRealTimeInterface).UpdateMsg(MsgDR,"1","")
			s Msg="RP"
			s RetUrl=##Class(LISAPP.Common.Service.DHCReportFileServiceFacade).GetReportUrlByReportDRMTHD(VisitNumberReportDR)
			s ret=##Class(web.DHCLisRealTimeInterface).SendDHCHisInterface(MsgDR, VisitNumberDR, VisitNumberReportDR, UserDR, AddDate, AddTime, Msg ,RetUrl) 
    	}
		catch ex
		{
			s ret=ex.Data
		}
	}
	q ret
}

/// 发送中间报告审核消息
ClassMethod SendMidReportMsg() As %String
{
	s ret=""
	
	///发送中间报告审核消息
	s MsgTypeI=##Class(LIS.Util.Common).IndexData("MidReport")
	s MsgDR="" f  
	{
		s MsgDR=$o(^dbo.OTMsgStockI("IndexIsReply",MsgTypeI,0,MsgDR)) 
		q:MsgDR=""
		try
		{	
			s MidReportDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),17)
			s VisitNumberReportDR=$lg($g(^dbo.RPVisitNumberRepMidD(MidReportDR)),2)
			s UserDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),7)
 			//平台标本状态更新消息接口
			s AddDate=$lg($g(^dbo.OTMsgStockD(MsgDR)),2)
			s AddTime=$lg($g(^dbo.OTMsgStockD(MsgDR)),3)
			s VisitNumberDR=""
			s Msg="PreRP"
			//s RetUrl="jquery.easyui.dhclabmidreport.csp?VisitNumberReportDR="_VisitNumberReportDR
			s RetUrl=##Class(LISAPP.Common.Service.DHCReportFileServiceFacade).GetMidReportUrlByReportDRMTHD(VisitNumberReportDR)
			s ret=##Class(web.DHCLisRealTimeInterface).SendDHCHisInterface(MsgDR, "", VisitNumberReportDR, UserDR, AddDate, AddTime, Msg,RetUrl) 
			i ret'["-1^" d ##Class(web.DHCLisRealTimeInterface).UpdateMsg(MsgDR,"1","")
		}
		catch ex
		{
			s ret=ex.Data
		}
	}
	q ret
}

/// 发送报告消息
ClassMethod SendHISReportMsg() As %String
{
	s ret=""
	
	///发送报告消息
	s MsgTypeI=##Class(LIS.Util.Common).IndexData("HISReportSend")
	s MsgDR="" f  
	{
		s MsgDR=$o(^dbo.OTMsgStockI("IndexIsReply",MsgTypeI,0,MsgDR)) 
		q:MsgDR=""  
		try
		{
			s VisitNumberReportDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),17)
			s UserDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),7)
 			//平台标本状态更新消息接口
			s AddDate=$lg($g(^dbo.OTMsgStockD(MsgDR)),2)
			s AddTime=$lg($g(^dbo.OTMsgStockD(MsgDR)),3)
			s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),2)
			s Msg="RP"
			s ret=##Class(web.DHCLisRealTimeInterface).SendAuthoriseMsg(MsgDR,VisitNumberReportDR,UserDR)
			i ret'["-1^" d ##Class(web.DHCLisRealTimeInterface).UpdateMsg(MsgDR,"1","")
			s Msg="RP"
			s ret=##Class(web.DHCLisRealTimeInterface).SendDHCHisInterface(MsgDR, VisitNumberDR, VisitNumberReportDR, UserDR, AddDate, AddTime, Msg) 
    	}
		catch ex
		{
			s ret=ex.Data
		}
	}
	q ret
}

/// 发送取消核收消息
ClassMethod SendCACCEPTMsg() As %String
{
	s ret=""
	
		///发送取消核收消息
		s MsgTypeI=##Class(LIS.Util.Common).IndexData("CACCEPT")
		s MsgDR="" f  
		{
			s MsgDR=$o(^dbo.OTMsgStockI("IndexIsReply",MsgTypeI,0,MsgDR)) 
			q:MsgDR=""
			try
			{
			s VisitNumberDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),17)
			s VisitNumberReportDR=""
			s UserDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),7)
			s Msg=$lg($g(^dbo.OTMsgStockD(MsgDR)),10) 
			//平台标本状态更新消息接口
			s AddDate=$lg($g(^dbo.OTMsgStockD(MsgDR)),2)
			s AddTime=$lg($g(^dbo.OTMsgStockD(MsgDR)),3)
			//更新发送记录
			s ret=##Class(web.DHCLisRealTimeInterface).UpdateMsg(MsgDR,"1","")
			s Msg="CACCEPT"
			s ret=##Class(web.DHCLisRealTimeInterface).SendDHCHisInterface(MsgDR, VisitNumberDR, VisitNumberReportDR, UserDR, AddDate, AddTime, Msg) 
		}
		catch ex
		{
			s ret=ex.Data
		}
	}
	q ret
}

/// 发送危机值结果消息
ClassMethod SendHISPanicResultMsg() As %String
{
	s ret=""
	
	///发送危机值结果消息
	s MsgTypeI=##Class(LIS.Util.Common).IndexData("HISPanicResult")
	s MsgDR="" f  
	{
		s MsgDR=$o(^dbo.OTMsgStockI("IndexIsReply",MsgTypeI,0,MsgDR)) 
		q:MsgDR=""  
		try
		{
			s VisitNumberReportPanicDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),17)
			s UserDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),7)
			s Msg=$lg($g(^dbo.OTMsgStockD(MsgDR)),10) 
			//更新发送记录
			s ret=##Class(web.DHCLisRealTimeInterface).UpdateMsg(MsgDR,"1","")
			s ret=##Class(web.DHCLisRealTimeInterface).SendPanicMsg(MsgDR,VisitNumberReportPanicDR,UserDR,Msg)
		}
		catch ex
		{
			s ret=ex.Data
		}
	}
	q ret
}

/// 发送危机值未处理消息
ClassMethod SendHISPanicOutTimeMsg() As %String
{
	s ret=""
	
	///发送危机值未处理消息
	s CRISISOUT=900
	i $d(^dbo.SYSParameterI("IndexCode"," CRISISOUT"," SYS"," DHCC")) d
	.s ParaDR=$o(^dbo.SYSParameterI("IndexCode"," CRISISOUT"," SYS"," DHCC",""))
	.i $l(ParaDR) s CRISISOUT=$lg($g(^dbo.SYSParameterD(ParaDR)),5)   
	//从一天前开始查
	s PStartDate=$zd(($p($h,",",1)-1),8)
	s CurTime=$p($h,",",2)
	f  
	{
		s PStartDate=$o(^dbo.RPVisitNumberPanicReportI("IndexAuthUser",PStartDate)) 
		q:PStartDate=""  
			
		s AuthUserDR="" f  
		{
			s AuthUserDR=$o(^dbo.RPVisitNumberPanicReportI("IndexAuthUser",PStartDate,AuthUserDR)) 
			q:AuthUserDR=""
			s VisitNumberReportPanicDR="" f  
			{
				s VisitNumberReportPanicDR=$o(^dbo.RPVisitNumberPanicReportI("IndexAuthUser",PStartDate,AuthUserDR,VisitNumberReportPanicDR)) 
				q:VisitNumberReportPanicDR=""
				try
				{
					s SendMode=$lg($g(^dbo.RPVisitNumberPanicReportD(VisitNumberReportPanicDR)),17)
					i (SendMode'="S")&&(SendMode'="B") q
					s IsSendBackToLIS=$lg($g(^dbo.RPVisitNumberPanicReportD(VisitNumberReportPanicDR)),25)
					i (IsSendBackToLIS="1") q
					s CreateTime=+$lg($g(^dbo.RPVisitNumberPanicReportD(VisitNumberReportPanicDR)),5)
					s CalRes=CurTime-CreateTime
					i CalRes<0 s CalRes=3600*24+CalRes
					i CalRes>CRISISOUT d
					.s ret=##Class(web.DHCLisRealTimeInterface).SendLISPanicMsg("",VisitNumberReportPanicDR,"","","")
				}
				catch ex
				{
					s ret=ex.Data
				}
			}
		}
	}
	
	q ret
}

/// 发送拒收消息
ClassMethod SendHISRejectMsg() As %String
{
	s ret=""
	
	///发送拒收消息
	s MsgTypeI=##Class(LIS.Util.Common).IndexData("HISReject")
	s MsgDR="" f  
	{
		s MsgDR=$o(^dbo.OTMsgStockI("IndexIsReply",MsgTypeI,0,MsgDR)) 
		q:MsgDR=""
		try
		{
			s VisitNumberRejectSpecDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),17)
			s UserDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),7)
			s Msg=$lg($g(^dbo.OTMsgStockD(MsgDR)),10)    
			//平台标本状态更新消息接口
			s AddDate=$lg($g(^dbo.OTMsgStockD(MsgDR)),2)
			s AddTime=$lg($g(^dbo.OTMsgStockD(MsgDR)),3)
			s VisitNumberDR=$lg($g(^dbo.RPVisitNumberRejectSpecD(VisitNumberRejectSpecDR)),2)
			s VisitNumberReportDR=""
			s VisitNumberReportDR=""
			s Notes=Msg
			s ret=##Class(web.DHCLisRealTimeInterface).SendSampleRejectMsg(MsgDR,VisitNumberRejectSpecDR,UserDR,Msg)
			s Msg="Reject"
			s ret=##Class(web.DHCLisRealTimeInterface).SendDHCHisInterface(MsgDR, VisitNumberDR, VisitNumberReportDR, UserDR, AddDate, AddTime, Msg,Notes) 
			s ret=##Class(web.DHCLisRealTimeInterface).UpdateMsg(MsgDR,"1","")
		}
		catch ex
		{
			s ret=ex.Data
		}
	}
	q ret
}

/// 发送HIS传染病消息
ClassMethod SendHISInfectMsg() As %String
{
	s ret=""
			
	///发送HIS传染病消息
	s MsgTypeI=##Class(LIS.Util.Common).IndexData("HISInfectMsg")
	s MsgDR="" f  
	{
		s MsgDR=$o(^dbo.OTMsgStockI("IndexIsReply",MsgTypeI,0,MsgDR)) 
		q:MsgDR=""
		try
		{
			s VisitNumberReportDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),17)
			s UserDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),7)
			//更新发送记录
			s ret=##Class(web.DHCLisRealTimeInterface).UpdateMsg(MsgDR,"1","")
			s ret=##Class(web.DHCLisRealTimeInterface).SendInfectMsg(MsgDR,VisitNumberReportDR,UserDR)
		}
		catch ex
		{
			s ret=ex.Data
		}
	}
	q ret
}

/// 发送多耐消息
ClassMethod SendMultipleResistantMsg() As %String
{
	s ret=""
	
	///发送多耐消息
	s MsgTypeI=##Class(LIS.Util.Common).IndexData("MultipleResistant")
	s MsgDR="" f  
	{
		s MsgDR=$o(^dbo.OTMsgStockI("IndexIsReply",MsgTypeI,0,MsgDR)) 
		q:MsgDR=""  
		try
		{
			s VisitNumberReportDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),17)
			s UserDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),7) 
			//更新发送记录
			s ret=##Class(web.DHCLisRealTimeInterface).UpdateMsg(MsgDR,"1","")
			s ret=##Class(web.DHCLisRealTimeInterface).SendMicMulBug(MsgDR,VisitNumberReportDR,UserDR)
		}
		catch ex
		{
			s ret=ex.Data
		}
	}
	q ret
}

/// 血库消息
ClassMethod SendHISBdNoticeMsg() As %String
{
	s ret=""
    
	///血库消息
	s MsgTypeI=##Class(LIS.Util.Common).IndexData("HISBdNotice")
	s MsgDR="" f  
	{
		s MsgDR=$o(^dbo.OTMsgStockI("IndexIsReply",MsgTypeI,0,MsgDR)) 
		q:MsgDR=""  
		try
    	{
			s BllID=$lg($g(^dbo.OTMsgStockD(MsgDR)),17)
			s UserDR=$lg($g(^dbo.OTMsgStockD(MsgDR)),7) 
			s Msg=$lg($g(^dbo.OTMsgStockD(MsgDR)),10) 
			s ret=##Class(web.DHCLisRealTimeInterface).SendBldNoticeMsg(MsgDR,BllID,UserDR,Msg)
			i ret>0 d ##Class(web.DHCLisRealTimeInterface).UpdateMsg(MsgDR,"1","")
		}
		catch ex
		{
			s ret=ex.Data
		}
	}
	q ret
}

/// 发送审核消息
ClassMethod SendAuthoriseMsg(MsgDR, VisitNumberReportDR, UserDR) As %String
{
	s ret=""
	s MsgDR=$g(MsgDR),VisitNumberReportDR=$g(VisitNumberReportDR),UserDR=$g(UserDR)
	i '$l(VisitNumberReportDR) q 100
	try
	{
		//推送结果到平台中心
		s reportJSON=##Class(LISService.Business.ReportOut).GetReportJSON(VisitNumberReportDR)
		s Labno=""
		s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),2)
		i $l(VisitNumberDR) d
		.s Labno=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),2)
		.s RegNo=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),3)
		//老写法
		//s ret=##Class(web.DHCENS.EnsHISService).DHCHisInterface("SendLISReport",reportJSON)
		//新写法
		//HIS操作代码
		s HISOper="SendLISReport"
		//操作名称
		s ServiceCName="推送检验报告"
		//便于查询的关键字
		s KeyWord="条码号:"_Labno_",登记号:"_RegNo
		//执行代理方法
		s ret=..DHCHisInterfaceProxy(HISOper,reportJSON,ServiceCName,KeyWord)
		//s ret=##Class(web.DHCLabPortal).PublishReport(VisitNumberReportDR)
		//s ret=..DHCHisInterfaceProxy("SENDLISREPORTTOJHEMR",VisitNumberReportDR)
	}
	catch ex
	{
		s ret=ex.Data
	}
	q ret
}

/// 发送复审消息
ClassMethod SendReAuthoriseMsg(MsgDR, VisitNumberReportDR, UserDR) As %String
{
	s ret=""
	s MsgDR=$g(MsgDR),VisitNumberReportDR=$g(VisitNumberReportDR),UserDR=$g(UserDR)
	i '$l(VisitNumberReportDR) return 100
	try
	{
		s LisNamespace="DHC-LISDATA"
		s UserCode=$lg(^[LisNamespace]dbo.SYSUserD(UserDR),2)
		s UserID=..UsrCodeToID(UserCode)
		s retVal=..LabnoToOrdInfo(VisitNumberReportDR,LisNamespace)
		s ret=-1
		//更新发送记录
		s ret=##Class(web.DHCLisRealTimeInterface).UpdateMsg(MsgDR,"1","")
		i $p(retVal,"^",1)="" return ret
		i ##Class(%ClassDefinition).%ExistsId("websys.DHCMessageInterface") {
			s Context="报告复审核"      //	发送的消息内容
			s ActionTypeCode="1013"	//消息动作代码
			s FromUserRowId=UserID	//发送消息的用户Id
			s EpisodeId=$p(retVal,"^",1)	//病人就诊Id
			s OrdItemId=$p(retVal,"^",2)	//医嘱Id
			s ToUserRowId=""	//接收消息的用户Id
			s OtherInfoJson=""  //	其它信息
			//老写法
			//s ret=##class(websys.DHCMessageInterface).Send(Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson) 
			//新写法
			//HIS操作代码
			s HISOper="ReAuth"
			//操作名称
			s ServiceCName="复审消息"
			//便于查询的关键字
			s KeyWord=""
			s ClassName="websys.DHCMessageInterface"
			s FunName="Send"
			//判断成功类
			s RetCheckClass=""
			//执行代理方法
			s ret=##Class(LISAPP.LIS.DHCLISServiceLog).DoService(HISOper,ServiceCName,KeyWord,RetCheckClass,ClassName,FunName,Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson)
		}
	}
	catch ex
	{
		s ret=ex.Data
	}
	q ret
}

/// 发送取消审核消息
ClassMethod SendReportUndoMsg(MsgDR, VisitNumberReportDR, UserDR, Msg) As %String
{
	s MsgDR=$g(MsgDR),VisitNumberReportDR=$g(VisitNumberReportDR),UserDR=$g(UserDR),Msg=$g(Msg)
	s ret=""
	i '$l(VisitNumberReportDR) return 100
	try
	{
		s LisNamespace="DHC-LISDATA"
		s UserCode=$lg(^[LisNamespace]dbo.SYSUserD(UserDR),2)
		s UserID=..UsrCodeToID(UserCode)
		s retVal=..LabnoToOrdInfo(VisitNumberReportDR,LisNamespace)
		s ret=-1
		//更新发送记录
		i $p(retVal,"^",1)="" return ret
		i ##Class(%ClassDefinition).%ExistsId("websys.DHCMessageInterface") {
			s Context="报告取消审核"_Msg      //	发送的消息内容
			s ActionTypeCode="1004"	//消息动作代码
			s FromUserRowId=UserID	//发送消息的用户Id
			s EpisodeId=$p(retVal,"^",1)	//病人就诊Id
			s OrdItemId=$p(retVal,"^",2)	//医嘱Id
			s ToUserRowId=""	//接收消息的用户Id
			s OtherInfoJson=""  //	其它信息
			//老写法
			//s ret=##class(websys.DHCMessageInterface).Send(Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson) 
			//新写法
			//HIS操作代码
			s HISOper="AuthUnDo"
			//操作名称
			s ServiceCName="取消审核"
			//便于查询的关键字
			s KeyWord=""
			s ClassName="websys.DHCMessageInterface"
			s FunName="Send"
			//判断成功类
			s RetCheckClass=""
			//执行代理方法
			s ret=##Class(LISAPP.LIS.DHCLISServiceLog).DoService(HISOper,ServiceCName,KeyWord,RetCheckClass,ClassName,FunName,Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson)
		}
		return ret
	}
	catch ex
	{
		s ret=ex.Data
	}
	q ret
}

/// 拒收消息
ClassMethod SendSampleRejectMsg(MsgDR, VisitNumberRejectSpecDR, UserDR, Msg) As %String
{
	s MsgDR=$g(MsgDR),VisitNumberRejectSpecDR=$g(VisitNumberRejectSpecDR),UserDR=$g(UserDR),Msg=$g(Msg)
	s ret=""
	s LisNamespace="DHC-LISDATA"
	try
	{
		s VisitNumberDR=$lg($g(^dbo.RPVisitNumberRejectSpecD(VisitNumberRejectSpecDR)),2)
		s UserCode=$lg(^[LisNamespace]dbo.SYSUserD(UserDR),2)
		s UserID=..UsrCodeToID(UserCode)
		s AdmissionTypeDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),4)
		s AdmTypeCode=""
		i $l(AdmissionTypeDR) s AdmTypeCode=$lg($g(^dbo.BTAdmissionTypeD(AdmissionTypeDR)),2)
		s LocationDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),22)
		s WardDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),26)
		s retVal=..LabnoToOrdInfo("",LisNamespace,VisitNumberDR)
		i $p(retVal,"^",1)="" return 0
		s AdmNo=$p(retVal,"^",1),HISOrderID=$p(retVal,"^",2)
		s ret=-1
		i ##Class(%ClassDefinition).%ExistsId("websys.DHCMessageInterface") {
		  s Context="标本拒收:"_Msg      //	发送的消息内容
		  s ActionTypeCode="1006"	//消息动作代码
		  s FromUserRowId=UserID	//发送消息的用户Id
		  s EpisodeId=$p(retVal,"^",1)	//病人就诊Id
		  s OrdItemId=$p(retVal,"^",2)	//医嘱Id
		  s ToUserRowId=""	//接收消息的用户Id
		  s OtherInfoJson="{"_""""_"linkParam"_""""_":"_""""_"EpisodeId="_EpisodeId_"&VisitNumberRejectSpecDR="_VisitNumberRejectSpecDR_""""_"}"  //	其它信息
		  //老写法
		  //s ret=##class(websys.DHCMessageInterface).Send(Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson) 
		  //新写法
		  //HIS操作代码
		  s HISOper="Reject"
		  //操作名称
		  s ServiceCName="拒收消息"
		  //便于查询的关键字
		  s KeyWord=""
		  s ClassName="websys.DHCMessageInterface"
		  s FunName="Send"
		  //判断成功类
		  s RetCheckClass=""
		  s ret=##Class(LISAPP.LIS.DHCLISServiceLog).DoService(HISOper,ServiceCName,KeyWord,RetCheckClass,ClassName,FunName,Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson)
		  //有临床科室就发送一份消息到LIS临床消息
		  i $l(LocationDR) d
		  .s ret=..SendLisClinicMsg(UserDR,"R",VisitNumberRejectSpecDR,AdmNo,AdmTypeCode,LocationDR,Context,HISOrderID,"",WardDR)
		}
		return ret
	}
	catch ex
	{
		s ret=ex.Data
	}
	q ret
}

/// 发送传染病消息
ClassMethod SendInfectMsg(MsgDR, VisitNumberReportDR, UserDR) As %String
{
	s MsgDR=$g(MsgDR),VisitNumberReportDR=$g(VisitNumberReportDR),UserDR=$g(UserDR)
	s ret=""
	i '$l(VisitNumberReportDR) return 100
	try
	{
		s LisNamespace="DHC-LISDATA"
		s UserCode=$lg(^[LisNamespace]dbo.SYSUserD(UserDR),2)
		s UserID=..UsrCodeToID(UserCode)
		s retVal=..LabnoToOrdInfo(VisitNumberReportDR,LisNamespace)
		s ret=-1
		i $p(retVal,"^",1)="" return ret
		i ##Class(%ClassDefinition).%ExistsId("websys.DHCMessageInterface") {
			s Context=$lg(^dbo.OTMsgStockD(MsgDR),10)   //	发送的消息内容
			s ActionTypeCode="1147"	//消息动作代码
			s FromUserRowId=UserID	//发送消息的用户Id
			s EpisodeId=$p(retVal,"^",1)	//病人就诊Id
			s OrdItemId=$p(retVal,"^",2)	//医嘱Id
			s ToUserRowId=""	//接收消息的用户Id
			s OtherInfoJson=""  //	其它信息
			//老写法
			//s ret=##class(websys.DHCMessageInterface).Send(Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson) 
			//新写法
		  	//HIS操作代码
		  	s HISOper="Reject"
		  	//操作名称
		  	s ServiceCName="拒收消息"
		  	//便于查询的关键字
		  	s KeyWord=""
		  	s ClassName="websys.DHCMessageInterface"
		  	s FunName="Send"
		  	//判断成功类
		  	s RetCheckClass=""
		    s ret=##Class(LISAPP.LIS.DHCLISServiceLog).DoService(HISOper,ServiceCName,KeyWord,RetCheckClass,ClassName,FunName,Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson)
		}
	}
	catch ex
	{
		s ret=ex.Data
	}
	q ret
}

/// 发送危机值结果消息	
ClassMethod SendPanicMsg(MsgDR, VisitNumberReportPanicDR, UserDR, Msg) As %String
{
	s MsgDR=$g(MsgDR),VisitNumberReportPanicDR=$g(VisitNumberReportPanicDR),UserDR=$g(UserDR),Msg=$g(Msg)
	s ret=""
	s LisNamespace="DHC-LISDATA"
	i '$l(VisitNumberReportPanicDR) return 100
	try
	{
		s gVisitNumberPanicReportData=$g(^dbo.RPVisitNumberPanicReportD(VisitNumberReportPanicDR))
		s VisitNumberDR=$lg(gVisitNumberPanicReportData,2)
		s VisitNumberReportID=$lg(gVisitNumberPanicReportData,26)
		s UserCode=$lg(^[LisNamespace]dbo.SYSUserD(UserDR),2)
		s UserID=..UsrCodeToID(UserCode)
		s retVal=..LabnoToOrdInfo(VisitNumberReportID,LisNamespace,VisitNumberDR)
		s Labno=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),2)
		s AdmissionTypeDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),4)
		s AdmTypeCode=""
		i $l(AdmissionTypeDR) s AdmTypeCode=$lg($g(^dbo.BTAdmissionTypeD(AdmissionTypeDR)),2)
		s LocationDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),22)
		s WardDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),26)
		i $p(retVal,"^",1)="" return 0
		s AdmNo=$p(retVal,"^",1),HISOrderID=$p(retVal,"^",2)

		s AuthDate=$lg(gVisitNumberPanicReportData,10)
		s AuthTime=$lg(gVisitNumberPanicReportData,11)
		i $l(AuthDate) s AuthDate=$e(AuthDate,1,4)_"-"_$e(AuthDate,5,6)_"-"_$e(AuthDate,7,8)
		i $l(AuthTime) s AuthTime=$zt(AuthTime) 

		s DepartName="",DepartPhone=""
		s WorkGroupMachineDR=$lg(gVisitNumberPanicReportData,2)
		i $l(WorkGroupMachineDR) s WorkGroupDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),4)
		i $l(WorkGroupDR) S DepartPhone=$LG($G(^dbo.BTWorkGroupD(WorkGroupDR)),6)
		
		s ReportInfo=AuthDate_"^"_AuthTime_"^"_UserID_"^"_Msg_"^"_DepartName_"^"_DepartPhone
		///获取危机值结果
		s PanicResults="",num=0
		Set rsetPres=##class(%ResultSet).%New("DHCLIS.DHCCommon.QueryPanicResult")
		d rsetPres.Execute(VisitNumberReportPanicDR)
		While (rsetPres.Next()) {
			//TestCodeName,VisitNumberReportPanicDR,TestCodeDR,Result,TextRes,ExtraRes,OtherRes,ResNoes,AbFlag,RefRanges,MethodDR,MachineParameterDR,AssayDate,AssayTime,Sequence,Unit
			s TestCodeName=rsetPres.GetData(1)
			s Result=rsetPres.GetData(5)
			s ExtraRes=rsetPres.GetData(6)
			s AbFlag=rsetPres.GetData(9)
			s Ranges=rsetPres.GetData(10)
			s Unit=rsetPres.GetData(16)
			i AbFlag="多耐" s Unit=AbFlag
			i $l(ExtraRes) s Result=Result_" "_ExtraRes
			i $l(Unit) s Result=Result_"("_Unit_")"
			s num=num+1
			i PanicResults="" s PanicResults=num_"、项目名称："_TestCodeName_"结果："_Result_"    参考范围："_Ranges
			e  s PanicResults=PanicResults_"；"_num_"、项目名称："_TestCodeName_"结果："_Result_"    参考范围："_Ranges
		 }
		d rsetPres.Close()
		s OrderInfo=..LabReportInfo(VisitNumberReportID,VisitNumberDR,Msg)
		//老写法
		//s ret=##Class(web.DHCAntCVResult).Save(1,Labno,AdmNo,$p(HISOrderID,",",1),ReportInfo,PanicResults,VisitNumberReportPanicDR,OrderInfo)
		//新写法
		//HIS操作代码
		s HISOper="Panic"
		//操作名称
		s ServiceCName="危急值消息"
		//便于查询的关键字
		s KeyWord=""
		s ClassName="web.DHCAntCVResult"
		s FunName="Save"
		//判断成功类
		s RetCheckClass=""
		s ret=##Class(LISAPP.LIS.DHCLISServiceLog).DoService(HISOper,ServiceCName,KeyWord,RetCheckClass,ClassName,FunName,1,Labno,AdmNo,$p(HISOrderID,",",1),ReportInfo,PanicResults,VisitNumberReportPanicDR,OrderInfo)
		//有临床科室就发送一份消息到LIS临床消息
		i $l(LocationDR) d
		.s ret=..SendLisClinicMsg(UserDR,"W",VisitNumberReportPanicDR,AdmNo,AdmTypeCode,LocationDR,PanicResults,HISOrderID,"frmMsgDealPanic.aspx",WardDR)
	}
	catch ex
	{
		s ret=ex.Data
	}
	q ret
}

/// 发送危机值结果消息	
ClassMethod SendToPanicSYS(MsgDR, VisitNumberReportPanicDR, UserDR, Msg, Satus) As %String
{
	s MsgDR=$g(MsgDR),VisitNumberReportPanicDR=$g(VisitNumberReportPanicDR),UserDR=$g(UserDR),Msg=$g(Msg)
	s Satus=$g(Satus)
	s ret=""
	s LisNamespace="DHC-LISDATA"
	i '$l(VisitNumberReportPanicDR) q 100
	try
	{
		s OEOrdItemID=VisitNumberReportPanicDR
		s VisitNumberDR=$lg($g(^dbo.RPVisitNumberPanicReportD(VisitNumberReportPanicDR)),2)
		s EventDate=$lg($g(^dbo.OTMsgStockD(MsgDR)),5)
		s EventTime=$lg($g(^dbo.OTMsgStockD(MsgDR)),6)
		s EventDate=##Class(LIS.Util.Common).FormatDate(EventDate)
		s EventTime=##Class(LIS.Util.Common).FormatDate(EventTime)
		s LabNo=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),2)
		s UserCode=$lg(^dbo.SYSUserD(UserDR),2)
		s UserName=$lg(^dbo.SYSUserD(UserDR),3)
		s UserID=..UsrCodeToID(UserCode) 
		s jsonObj=##class(%Library.DynamicObject).%New()	//json对象
		d jsonObj.%Set("OEOrdItemID",OEOrdItemID)
		d jsonObj.%Set("Position","")
		d jsonObj.%Set("ExamID",LabNo)
		d jsonObj.%Set("Status","ALARM")
		d jsonObj.%Set("UserID",UserID)
		d jsonObj.%Set("UserName",UserName)
		d jsonObj.%Set("UpDateTime",EventDate_" "_EventTime)
		d jsonObj.%Set("SourceSystem","LISCV")
		s jsonArr=##class(%Library.DynamicArray).%New()		//json数组
		d jsonArr.%Push(jsonObj)						//json对象存入json数组
		s InputStream=##class(%GlobalCharacterStream).%New()
		s tsc=jsonArr.%ToJSON(.InputStream)
		s Labno=""
		i $l(VisitNumberDR) d
		.s Labno=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),2)
		.s RegNo=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),3)
		s ret=..DHCHisInterfaceProxy("UpdateSystemStatus",InputStream,"","条码号:"_Labno_",登记号:"_RegNo)
	}
	catch ex
	{
		s ret=ex.Data
	}
	q ret
}

/// 发送消息接口
/// d ##Class(web.DHCLisRealTimeInterface).SendLisClinicMsg()
/// AddUserDR:发送用户主键
/// DataType:W:危急值,R:拒收，T:取血通知，C:取消报告，M:多重耐药
/// DataID:具体的业务ID
/// AdmNo:就诊号
/// AdmTypeCode:就诊类型代码
/// LocationDR:科室
/// Content:消息内容
/// HISOrderID:HIS医嘱ID
/// DealUrl:处理链接，不给就默认设置一下消息状态。默认用frmMsgDealDemo.aspx页面处理
/// WardDR:病区主键
/// 返回空串，消息保存成功，否则返回失败原因
ClassMethod SendLisClinicMsg(AddUserDR, DataType, DataID, AdmNo, AdmTypeCode, LocationDR, Content, HISOrderID, DealUrl, WardDR)
{
	s AddUserDR=$g(AddUserDR)
	s DataType=$g(DataType)
	i '$L(DataType) q "DataType不能为空"
	i $L(DataType)>1 q "DataType长度只能为1"
	s DataID=$g(DataID)
	i '$l(DataID) q "DataID不能为空"
	s AdmNo=$g(AdmNo)
	s AdmTypeCode=$g(AdmTypeCode)
	s LocationDR=$g(LocationDR)
	i '$l(LocationDR) q "LocationDR不能为空"
	s Content=$g(Content)
	i '$l(Content) q "Content不能为空"
	s HISOrderID=$g(HISOrderID)
	s DealUrl=$g(DealUrl)
	s WardDR=$g(WardDR)
	s retVal=""
	s objMain=##Class(dbo.OTSendClinicMsg).%New()
	s objMain.AddDate=$zd($h,8)
	s objMain.AddTime=$p($h,",",2)
	s objMain.AdmNo=AdmNo
	s objMain.AdmType=AdmTypeCode
	s objMain.Content=Content
	s objMain.DataID=DataID
	s objMain.DataType=DataType
	s objMain.DealUrl=DealUrl
	s objMain.HISOrderID=HISOrderID
	s objMain.LastDate=$zd($h,8)
	s objMain.LastTime=$p($h,",",2)
	s objMain.LocationDR=LocationDR
	s objMain.Status="C"
	s objMain.AddUserDR=AddUserDR
	s objMain.WardDR=WardDR
	s sc=objMain.%Save()
	i ('$SYSTEM.Status.IsOK(sc)) d
	.s retVal= "-1^消息保存失败:"_$SYSTEM.Status.GetErrorText(sc)
	q retVal
}

/// 发送危机值未处理消息	
ClassMethod SendLISPanicMsg(MsgDR, VisitNumberReportPanicDR, MedicalStaff, MedicalPhone, NoticeNotes) As %String
{
	s MsgDR=$g(MsgDR),VisitNumberReportPanicDR=$g(VisitNumberReportPanicDR),MedicalStaff=$g(MedicalStaff)
	s MedicalPhone=$g(MedicalPhone),NoticeNotes=$g(NoticeNotes)
	s ret=""
	i '$l(VisitNumberReportPanicDR) q 100
	try
	{
		s info=""
		s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberPanicResultI("IndexMaster",VisitNumberReportPanicDR,TestCodeDR)) Quit:TestCodeDR=""  d
		.s PanicResultDR = $o(^dbo.RPVisitNumberPanicResultI("IndexMaster",VisitNumberReportPanicDR,TestCodeDR,""))
		.s Data=$g(^dbo.RPVisitNumberPanicResultD(PanicResultDR)),TestCodeName=""
		.i $l(TestCodeDR) s TestCodeName=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),3)
		.s Units=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),8)
		.s ResultFormat=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),9)
		.s Result=$lg(Data,4)
		.s TextRes=$lg(Data,5)
		.s RefRanges=$lg(Data,10)
		.i ResultFormat="M",$l(Result),Result'=$c(0),$d(^dbo.BTOrganismD(Result)) d  s TextRes=$lg(^dbo.BTOrganismD(Result),3)
		.s info=info_"项目名称："_TestCodeName_"&nbsp&nbsp危急值结果:"_TextRes_"&nbsp&nbsp单位:"_Units_"&nbsp&nbsp参考范围:"_RefRanges_"<br/>"
		s VisitNumberDR=$lg($g(^dbo.RPVisitNumberPanicReportD(VisitNumberReportPanicDR)),2)
		s LabNo=""
		s EpisNo=""
		s PatName=""
		s BedNo=""
		s Location=""
		i $l(VisitNumberDR) d
		.s LabNo=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),2)
		.s PatName=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),13)
		.s BedNo=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),27)
		.s LocationDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),22)
		.i $l(LocationDR) s Location=$lg($g(^dbo.BTLocationD(LocationDR)),3)
		s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberPanicReportD(VisitNumberReportPanicDR)),3)
		s WorkGroupMachine=""
		i $l(WorkGroupMachineDR) s WorkGroupMachine=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),3)
		s EpisNo=""
		i $l(VisitNumberDR),$l(WorkGroupMachineDR) d
		.s OrderNo=$O(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,""),-1)
		.s VisitNumberReportDR=""
		.i OrderNo'="" s VisitNumberReportDR=$O(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,""),-1)
		.i VisitNumberReportDR'="" s EpisNo=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),8)
		s info="<span style='color:#549cc7;font-weight:bold;'>工作小组："_WorkGroupMachine_"&nbsp流水号:"_EpisNo_"&nbsp&nbsp病人姓名:"_PatName_"&nbsp&nbsp检验号:"_LabNo_"&nbsp&nbsp科室:"_Location_"&nbsp&nbsp床号:"_BedNo_"</span><br/>"_info
		
		i $l(info) d
		.s perUser = "WG-"_$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),4)
		.s ret=retObj.SendMsg("dhcc","{ ""type"": ""<span style='color:red;font-weight:bold;'>危急值结果未处理</span>"", ""info"": """_info_""", ""dealurl"": ""../../lis/form/frmManageVisitNumberPanicReportNotice.aspx?RowID="_VisitNumberReportPanicDR_""" }", "Crisis", perUser)
   
		//更新发送记录
		&Sql(Update dbo.RP_VisitNumberPanicReport Set IsSendBackToLIS=1 Where RowID=:VisitNumberReportPanicDR)
		s ret=SQLCODE
	}
	catch ex
	{
		s ret=ex.Data
	}
	q ret
}

/// 发送危机值已处理消息	
ClassMethod SendHisDealPanicMsg(MsgDR, VisitNumberReportPanicDR, MedicalStaff, MedicalPhone, NoticeNotes) As %String
{
	s MsgDR=$g(MsgDR),VisitNumberReportPanicDR=$g(VisitNumberReportPanicDR),MedicalStaff=$g(MedicalStaff)
	s MedicalPhone=$g(MedicalPhone),NoticeNotes=$g(NoticeNotes)
	s ret=""
	s LisNamespace="DHC-LISDATA"
	i '$l(VisitNumberReportPanicDR) q 100
	try
	{
		s info=""
		s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberPanicResultI("IndexMaster",VisitNumberReportPanicDR,TestCodeDR)) Quit:TestCodeDR=""  d
		.s PanicResultDR = $o(^dbo.RPVisitNumberPanicResultI("IndexMaster",VisitNumberReportPanicDR,TestCodeDR,""))
		.s Data=$g(^dbo.RPVisitNumberPanicResultD(PanicResultDR)),TestCodeName=""
		.i $l(TestCodeDR) s TestCodeName=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),3)
		.s ResultFormat=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),9)
		.s Result=$lg(Data,4)
		.s TextRes=$lg(Data,5)
		.i ResultFormat="M",$l(Result),Result'=$c(0),$d(^dbo.BTOrganismD(Result)) d  s TextRes=$lg(^dbo.BTOrganismD(Result),3)
		.s info=info_"项目："_TestCodeName_" 危急结果:"_TextRes_";"
		s VisitNumberDR=$lg($g(^dbo.RPVisitNumberPanicReportD(VisitNumberReportPanicDR)),2)
		s LabNo=""
		s EpisNo=""
		s PatName=""
		i $l(VisitNumberDR) d
		.s LabNo=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),2)
		.//s EpisNo=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),8)
		.s PatName=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),13)
		s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberPanicReportD(VisitNumberReportPanicDR)),3)
		s WorkGroupMachine=""
		i $l(WorkGroupMachineDR) s WorkGroupMachine=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),3)
		s EpisNo=""
		i $l(VisitNumberDR),$l(WorkGroupMachineDR) d
		.s OrderNo=$O(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,""),-1)
		.s VisitNumberReportDR=""
		.i OrderNo'="" s VisitNumberReportDR=$O(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,""),-1)
		.i VisitNumberReportDR'="" s EpisNo=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),8)
		
		s info="工作小组："_WorkGroupMachine_" 流水号:"_EpisNo_" 患者:"_PatName_" 条码号:"_LabNo_info
		i $l(info) d
		.zn LisNamespace
		.s retObj=##Class(wbsLisMsgAsyncHandler.LISMsg.wbsLisMsgAsyncHandlerSoap).%New()
		.s perUser = "WG-"_$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),4)
		.s ret=retObj.SendMsg("dhcc","{ ""type"": ""危急结果已经被处理"", ""info"": """_info_""", ""dealurl"": """" }", "Crisis", perUser)
		zn "DHC-APP"
		
		//更新发送记录
		&Sql(Update dbo.RP_VisitNumberPanicNotice Set IsSendBackToLIS=1 Where VisitNumberReportPanicDR=:VisitNumberReportPanicDR)
		s ret=SQLCODE
	}
	catch ex
	{
		s $NAMESPACE="DHC-APP"
		s ret=ex.Data
	}
	q ret
}

/// 血库拒收消息
ClassMethod SendBldRejectMsg(MsgDR, ReqCostItemDR, UserDR, Msg) As %String
{
	s MsgDR=$g(MsgDR),ReqCostItemDR=$g(ReqCostItemDR),UserDR=$g(UserDR),Msg=$g(Msg)
	s ret=""
	s LisNamespace="DHC-LISDATA"
	try
	{
		//s VisitNumberDR=$lg($g(^dbo.RPVisitNumberRejectSpecD(VisitNumberRejectSpecDR)),2)
		s UserCode=$lg(^[LisNamespace]dbo.SYSUserD(UserDR),2)
		s UserID=..UsrCodeToID(UserCode)
		//s retVal=..LabnoToOrdInfo("",LisNamespace,VisitNumberDR)
		
		s HISOrderID=$lg($g(^[LisNamespace]dbo.BDReqFormCostItemD(ReqCostItemDR)),25)
		s ReqFormDR=$lg($g(^[LisNamespace]dbo.BDReqFormCostItemD(ReqCostItemDR)),2)
		s OrdRowID=HISOrderID
		//q AdmNo_"^"_OrdRowIDs
		s AdmNo=$lg($g(^[LisNamespace]dbo.BDReqFormD(ReqFormDR)),4) 
		i '$l(AdmNo) q
		s ret=-1

		i ##Class(%ClassDefinition).%ExistsId("websys.DHCMessageInterface") {
		  s Context="血袋拒收:"_Msg      //	发送的消息内容
		  s ActionTypeCode="1006"	//消息动作代码
		  s FromUserRowId=UserID	//发送消息的用户Id
		  s EpisodeId=AdmNo	//病人就诊Id
		  s OrdItemId=OrdRowID	//医嘱Id
		  s ToUserRowId=""	//接收消息的用户Id
		  s OtherInfoJson=""  //	其它信息
		  //老写法
		  //s ret=##class(websys.DHCMessageInterface).Send(Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson) 
		  //新写法
		  //HIS操作代码
		  s HISOper="BldReject"
		  //操作名称
		  s ServiceCName="血库拒收消息"
		  //便于查询的关键字
		  s KeyWord=""
		  s ClassName="websys.DHCMessageInterface"
		  s FunName="Send"
		  //判断成功类
		  s RetCheckClass=""
		  s ret=##Class(LISAPP.LIS.DHCLISServiceLog).DoService(HISOper,ServiceCName,KeyWord,RetCheckClass,ClassName,FunName,Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson)

		}  
	}
	catch ex
	{
		s $NAMESPACE="DHC-APP"
		s ret=ex.Data
	}
	q ret
}

/// 取血通知
ClassMethod SendBldNoticeMsg(MsgDR, BillID, UserDR, Msg) As %String
{
	s MsgDR=$g(MsgDR),BillID=$g(BillID),UserDR=$g(UserDR),Msg=$g(Msg)
	s ret=""
	s LisNamespace="DHC-LISDATA"
	try
	{
		//s VisitNumberDR=$lg($g(^dbo.RPVisitNumberRejectSpecD(VisitNumberRejectSpecDR)),2)
		s UserCode=$lg(^[LisNamespace]dbo.SYSUserD(UserDR),2)
		s UserID=..UsrCodeToID(UserCode)
		  
		s ret=-1

		i ##Class(%ClassDefinition).%ExistsId("websys.DHCMessageInterface") {
		  s Context="取血通知:"_Msg      //	发送的消息内容
		  s ActionTypeCode="1038"	//消息动作代码
		  s FromUserRowId=UserID	//发送消息的用户Id
		  s EpisodeId=BillID	//病人就诊Id
		  s OrdItemId=""	//医嘱Id
		  s ToUserRowId=""	//接收消息的用户Id
		  s OtherInfoJson=""  //	其它信息
		  //老写法
		  //s ret=##class(websys.DHCMessageInterface).Send(Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson) 
		  //新写法
		  //HIS操作代码
		  s HISOper="BldNotice"
		  //操作名称
		  s ServiceCName="取血通知"
		  //便于查询的关键字
		  s KeyWord=""
		  s ClassName="websys.DHCMessageInterface"
		  s FunName="Send"
		  //判断成功类
		  s RetCheckClass=""
		  s ret=##Class(LISAPP.LIS.DHCLISServiceLog).DoService(HISOper,ServiceCName,KeyWord,RetCheckClass,ClassName,FunName,Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson)
		}  
	}
	catch ex
	{
		s $NAMESPACE="DHC-APP"
		s ret=ex.Data
	}
	q ret
}

/// 检验号得到医嘱信息
ClassMethod LabnoToOrdInfo(VisitNumberReportDR, LisNamespace, VisitNumberDR) As %String
{
	s VisitNumberReportDR=$g(VisitNumberReportDR),CurAdm="",OrdRowIDs=""
	s VisitNumberDR=$g(VisitNumberDR)
	I $L(VisitNumberReportDR)
	{
		S SplitStatus=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),44) 
		i SplitStatus=2,$D(^dbo.RPReportSplitRecordI("IndexSplitReport",VisitNumberReportDR)) 
		{
			s CKTCDR=$o(^dbo.RPReportSplitRecordI("IndexSplitReport",VisitNumberReportDR,""))
			S RecordDR=$o(^dbo.RPReportSplitRecordI("IndexSplitReport",VisitNumberReportDR,CKTCDR,""))
			S VisitNumberReportDR=$LG($G(^dbo.RPReportSplitRecordD(RecordDR)),2)
	    }
	} 
	i '$l(VisitNumberDR) s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),2)
	i '$l(VisitNumberDR) return ""
	s TestSetDesc=""
	s AdmNo=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),5)
	s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:TestSetDR=""  d
	.s VisitNumberTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR,""))
	.s ReportDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),11)
	.i $l(VisitNumberReportDR),(ReportDR'=VisitNumberReportDR) q
	.s HISOrderID=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),10)
	.s OrdRowIDs=OrdRowIDs_HISOrderID_","
	.i $l(TestSetDesc) s TestSetDesc=TestSetDesc_"+"_$lg(^dbo.BTTestSetD(TestSetDR),3)
	.e  s TestSetDesc=$lg(^dbo.BTTestSetD(TestSetDR),3)

	s OrdRowIDs=$e(OrdRowIDs,1,$l(OrdRowIDs)-1)
	s AuthDate="",AuthTime=""
	i $l(VisitNumberReportDR) d
	.s AuthDate=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),19)
	.s AuthTime=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),20)
	.i $l(AuthDate) s AuthDate=$e(AuthDate,1,4)_"-"_$e(AuthDate,5,6)_"-"_$e(AuthDate,7,8)
	.i $l(AuthTime) s AuthTime=$zt(AuthTime) 
	s PatientID=""
	i $l(AdmNo) s PatientID=+$g(^PAADM(AdmNo))

	q AdmNo_"^"_OrdRowIDs_"^"_TestSetDesc_"^"_AdmNo_"^"_PatientID
}

/// 申请人^申请日期时间^采集人^采集日期时间^接收人^接收日期时间^预警日期时间^复核人^复核日期时间^报告人^报告日期时间(审核日期时间)^标本类型^危机说明^备注     (时间格式：YYYY-MM-DD  hh:mm:ss)
/// w ##Class(web.DHCLisRealTimeInterface).LabReportInfo()
ClassMethod LabReportInfo(VisitNumberReportID, VisitNumberDR, Msg) As %String
{
	s VisitNumberReportID=$g(VisitNumberReportID),VisitNumberDR=$g(VisitNumberDR)
	s Msg=$g(Msg)
	s RetReportInfo=""
	i '$l(VisitNumberDR) q ""
	//标本信息
  	s RPVisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDR))
	s DoctorDR=$lg(RPVisitNumberData,23),Doctor=""
	i $l(DoctorDR) s Doctor=$lg($g(^dbo.BTDoctorD(DoctorDR)),3)
	s RequestDate=$lg(RPVisitNumberData,24)
	s RequestTime=$lg(RPVisitNumberData,25)
	s CollectDate=$lg(RPVisitNumberData,51)
	s CollectTime=$lg(RPVisitNumberData,52)
	s CollectUserDR=$lg(RPVisitNumberData,53),CollectUser=""
	i $l(CollectUserDR) s CollectUser=$lg($g(^dbo.SYSUserD(CollectUserDR)),3)
	s ReceiveDate=$lg(RPVisitNumberData,66)
	s ReceiveTime=$lg(RPVisitNumberData,67)
	s ReceiveUserDR=$lg(RPVisitNumberData,68),ReceiveUser=""
	i $l(ReceiveUser) s ReceiveUser=$lg($g(^dbo.SYSUserD(ReceiveUserDR)),3)
	s SpecimenDR=$lg(RPVisitNumberData,56),Specimen=""
	i $l(SpecimenDR) s Specimen=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
	s AdmNo=$lg(RPVisitNumberData,5)

	s TestSetDesc=""
	s ReportDR=VisitNumberReportID
	i '$l(ReportDR) q ""
	s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:TestSetDR=""  d
	.s VisitNumberTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR,""))
	.s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),5)
	.s OrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,"")) 
	.;s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,""))
	.i $l(TestSetDesc) s TestSetDesc=TestSetDesc_"+"_$lg(^dbo.BTTestSetD(TestSetDR),3)
	.e  s TestSetDesc=$lg(^dbo.BTTestSetD(TestSetDR),3)
	
	s EntryDate=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),16)
	s EntryTime=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),17)
	s EntryUserDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),18),EntryUser=""
	i $l(EntryUserDR) s EntryUser=$lg($g(^dbo.SYSUserD(EntryUserDR)),3)
	s AuthDate=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),19)
	s AuthTime=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),20)
	s AuthUserDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),21),AuthUser=""
	i $l(AuthUserDR) s AuthUser=$lg($g(^dbo.SYSUserD(AuthUserDR)),3)

	i $l(ReceiveDate) s ReceiveDate=$e(ReceiveDate,1,4)_"-"_$e(ReceiveDate,5,6)_"-"_$e(ReceiveDate,7,8)
	i $l(ReceiveTime) s ReceiveTime=$zt(ReceiveTime)
	i $l(RequestDate) s RequestDate=$e(RequestDate,1,4)_"-"_$e(RequestDate,5,6)_"-"_$e(RequestDate,7,8) 
	i $l(RequestTime) s RequestTime=$zt(RequestTime)
	i $l(CollectDate) s CollectDate=$e(CollectDate,1,4)_"-"_$e(CollectDate,5,6)_"-"_$e(CollectDate,7,8)
	i $l(CollectTime) s CollectTime=$zt(CollectTime)
	i $l(EntryDate) s EntryDate=$e(EntryDate,1,4)_"-"_$e(EntryDate,5,6)_"-"_$e(EntryDate,7,8)
	i $l(EntryTime) s EntryTime=$zt(EntryTime) 
	i $l(AuthDate) s AuthDate=$e(AuthDate,1,4)_"-"_$e(AuthDate,5,6)_"-"_$e(AuthDate,7,8)
	i $l(AuthTime) s AuthTime=$zt(AuthTime) 
	
	s PatientID=""
	i $l(AdmNo) s PatientID=+$g(^PAADM(AdmNo))
	
	s RetReportInfo=Doctor_"^"_RequestDate_" "_RequestTime
	s RetReportInfo=RetReportInfo_"^"_CollectUser_"^"_CollectDate_" "_CollectTime
	s RetReportInfo=RetReportInfo_"^"_ReceiveUser_"^"_ReceiveDate_" "_ReceiveTime
	s RetReportInfo=RetReportInfo_"^"_EntryDate_" "_EntryTime
	s RetReportInfo=RetReportInfo_"^"_EntryUser_"^"_EntryDate_" "_EntryTime
	s RetReportInfo=RetReportInfo_"^"_AuthUser_"^"_AuthDate_" "_AuthTime
	s RetReportInfo=RetReportInfo_"^"_Specimen_"^"_Msg_"^"_TestSetDesc_"^"_AdmNo_"^"_PatientID
	q RetReportInfo
}

/// 用户代码得到HISID
ClassMethod UsrCodeToID(UsrCode) As %String
{
	s UsrCode=$g(UsrCode),UsrId=""
	i '$l(UsrCode) q ""
	s UsrCode=$$ALPHAUP^SSUTIL4(UsrCode)
	i $d(^SSU("SSUSR",0,"SSUSR_Initials",UsrCode)) s UsrId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UsrCode,""),-1)
	q UsrId
}

/// 更新消息
ClassMethod UpdateMsg(MsgDR, IsReply, PerUser) As %String
{
	s MsgDR=$g(MsgDR),IsReply=$g(IsReply),PerUser=$g(PerUser)
	s ret=""
	s objMesg=##Class(dbo.OTMsgStock).%OpenId(MsgDR)
	s objMesg.ReceiveDate=$tr($zd(+$h,3),"-")
	s objMesg.ReceiveTime=$p($h,",",2)
	s objMesg.PerUser=PerUser
	s objMesg.IsReply=IsReply
	s sc=objMesg.%Save()
 	s ret=100
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s ret=1
 	}
 	else {
	 	s ret=$SYSTEM.Status.GetErrorText(sc)
	}
 	q ret
}

/// d ##Class(web.DHCLisRealTimeInterface).QryExpireReqByRegNoExecute()
ClassMethod QryExpireReqByRegNoExecute()
{
    s LisNamespace = "DHC-LISDATA"
    //s $NAMESPACE=LisNamespace 
	s RegNo="" 
	 s repid=$i(^CacheTemp) 
	s Msg=""
	 for{ 
	    s RegNo = $o(^[LisNamespace]dbo.BDReqFormI("IndexRegNo",RegNo))  
	    q:RegNo=""
		s ReqFormDR = ""
		for {
			s ReqFormDR = $o(^[LisNamespace]dbo.BDReqFormI("IndexRegNo",RegNo,ReqFormDR))
			q:ReqFormDR=""
			s ReqFormData = $g(^[LisNamespace]dbo.BDReqFormD(ReqFormDR))
			s ReqFormNo=$lg(ReqFormData,2)
			s AdmNo=$lg(ReqFormData,4)
			s Status=$lg(ReqFormData,51) 
			i Status'="35" continue
			s BookDate=$lg(ReqFormData,40)
			i '$l(BookDate) continue 
            s BookDate=$ZDateH(BookDate,5)  
            s BookTime=$lg(ReqFormData,81)
            s NowDate=$p($h,",",1)
            s NowTime=$p($h,",",2)
            i BookDate>NowDate continue
            i (BookDate=NowDate),(BookTime>NowTime) continue
            s IssueRecordDR="" 
            s ExpireReqFlag="1" 
			i $d(^TMPSendFormNo($zn,repid,$j,"FormNo",ReqFormNo)) continue
            for { 
              s IssueRecordDR=$o(^[LisNamespace]dbo.BDIssueRecordI("IndexReqForm",ReqFormDR,IssueRecordDR))
              q:IssueRecordDR="" 
              s PackDR="" 
              for
              {
	            s PackDR=$o(^[LisNamespace]dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR))
                q:PackDR=""
                s IssueRecordItemsDR=$o(^[LisNamespace]dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
                s IssueRecordItemsData=$g(^[LisNamespace]dbo.BDIssueRecordItemsD(IssueRecordItemsDR))
                s IsReturned=$lg(IssueRecordItemsData,4)
                i IsReturned="0" s ExpireReqFlag="0" q 
              }  
            }
            i ExpireReqFlag="0" continue
            s Msg=ReqFormNo 
            s ret=##Class(web.DHCLisRealTimeInterface).SendExpireReqMsg(ReqFormDR,AdmNo,"",Msg) 
		}
 	}
}

/// 过期申请单
ClassMethod SendExpireReqMsg(MsgDR, AdmNo, UserDR, Msg) As %String
{
	s MsgDR=$g(MsgDR),AdmNo=$g(AdmNo),UserDR=$g(UserDR),Msg=$g(Msg)
	s ret=""
	s LisNamespace="DHC-LISDATA"
	try
	{
		//s UserCode=$lg(^[LisNamespace]dbo.SYSUserD(UserDR),2)
		//s UserID=..UsrCodeToID(UserCode)
		s repid=$i(^CacheTemp) 
		s ret=-1
		i ##Class(%ClassDefinition).%ExistsId("websys.DHCMessageInterface") {
		  s Context="申请单过期:"_Msg      //	发送的消息内容
		  s ActionTypeCode="2038"	//消息动作代码
		  s FromUserRowId=""	//发送消息的用户Id
		  s EpisodeId=AdmNo	//病人就诊Id
		  s OrdItemId=""	//医嘱Id
		  s ToUserRowId=""	//接收消息的用户Id
		  s OtherInfoJson=""  //	其它信息 
		  //老写法
		  //s ret=##class(websys.DHCMessageInterface).Send(Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson) 
		  //新写法
		  //HIS操作代码
		  s HISOper="ExpireReq"
		  //操作名称
		  s ServiceCName="过期申请单"
		  //便于查询的关键字
		  s KeyWord=""
		  s ClassName="websys.DHCMessageInterface"
		  s FunName="Send"
		  //判断成功类
		  s RetCheckClass=""
		  s ret=##Class(LISAPP.LIS.DHCLISServiceLog).DoService(HISOper,ServiceCName,KeyWord,RetCheckClass,ClassName,FunName,Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson)
		}  
		//更新发送记录
		i ret>0 s ^TMPSendFormNo($zn,repid,$j,"FormNo",Msg)=1
		return ret
	}
	catch ex
	{
		s $NAMESPACE="DHC-APP"
		s ret=ex.Data
	}
	q ret
}

/// 多重耐药消息
ClassMethod SendMicMulBug(MsgDR, VisitNumberReportDR, UserDR) As %String
{
	s MsgDR=$g(MsgDR),VisitNumberReportDR=$g(VisitNumberReportDR),UserDR=$g(UserDR)
	s ret=""
	s LisNamespace="DHC-LISDATA"
	i '$l(VisitNumberReportDR) q 100
	try
	{
		s ret=""
		s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),2)
		s UserCode=$lg(^[LisNamespace]dbo.SYSUserD(UserDR),2)
		s UserID=..UsrCodeToID(UserCode)
		s AdmissionTypeDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),4)
		s AdmNo=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),5)
		s AdmTypeCode=""
		i $l(AdmissionTypeDR) s AdmTypeCode=$lg($g(^dbo.BTAdmissionTypeD(AdmissionTypeDR)),2)
		s LocationDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),22)
		s WardDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),26)
		s HISOrderID=""
		i ##Class(%ClassDefinition).%ExistsId("websys.DHCMessageInterface") {
		  s Msg=$lg(^dbo.OTMsgStockD(MsgDR),10)   //	发送的消息内容
		  s Context="多重耐药:"_Msg      //	发送的消息内容
		  s ActionTypeCode="1056"	//消息动作代码
		  s FromUserRowId=UserID	//发送消息的用户Id
		  s EpisodeId=VisitNumberReportDR	//病人就诊Id
		  s OrdItemId=""	//医嘱Id
		  s ToUserRowId=""	//接收消息的用户Id
		  s OtherInfoJson=""  //	其它信息
		  //老写法
		  //s ret=##class(websys.DHCMessageInterface).Send(Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson) 
		  //新写法
		  //HIS操作代码
		  s HISOper="MicMulBug"
		  //操作名称
		  s ServiceCName="多重耐药消息"
		  //便于查询的关键字
		  s KeyWord=""
		  s ClassName="websys.DHCMessageInterface"
		  s FunName="Send"
		  //判断成功类
		  s RetCheckClass=""
		  s ret=##Class(LISAPP.LIS.DHCLISServiceLog).DoService(HISOper,ServiceCName,KeyWord,RetCheckClass,ClassName,FunName,Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson)
		} 
		//有临床科室就发送一份消息到LIS临床消息
		i $l(LocationDR) d
		.s ret=..SendLisClinicMsg(UserDR,"M",VisitNumberReportDR,AdmNo,AdmTypeCode,LocationDR,Context,HISOrderID,"",WardDR) 
		return ret
	}
	catch ex
	{
		s $NAMESPACE="DHC-APP"
		s ret=ex.Data
	}
	q ret
}

/// 多重耐药消息
ClassMethod SendETypeReport(MsgDR, EpisodeId, UserID, Msg) As %String
{
	s MsgDR=$g(MsgDR),EpisodeId=$g(EpisodeId),UserID=$g(UserID),Msg=$g(Msg)
	s ret=""
	try
	{
		i ##Class(%ClassDefinition).%ExistsId("websys.DHCMessageInterface") {
		  s Context="多重耐药:"_Msg      //	发送的消息内容
		  s ActionTypeCode="1056"	//消息动作代码
		  s FromUserRowId=UserID	//发送消息的用户Id
		  s EpisodeId=EpisodeId	//病人就诊Id
		  s OrdItemId=""	//医嘱Id
		  s ToUserRowId=""	//接收消息的用户Id
		  s OtherInfoJson=""  //	其它信息
		  //老写法
		  //s ret=##class(websys.DHCMessageInterface).Send(Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson) 
		  //新写法
		  //HIS操作代码
		  s HISOper="MicMulBug"
		  //操作名称
		  s ServiceCName="多重耐药消息"
		  //便于查询的关键字
		  s KeyWord=""
		  s ClassName="websys.DHCMessageInterface"
		  s FunName="Send"
		  //判断成功类
		  s RetCheckClass=""
		  s ret=##Class(LISAPP.LIS.DHCLISServiceLog).DoService(HISOper,ServiceCName,KeyWord,RetCheckClass,ClassName,FunName,Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson)
		}  
	}
	catch ex
	{
		s $NAMESPACE="DHC-APP"
		s ret=ex.Data
	}
	q ret
}

/// 急查超时消息
/// d ##Class(web.DHCLisRealTimeInterface).FindOutTimeMsg() 
ClassMethod FindOutTimeMsg() As %Status
{
    //只查当天数据
    s ret=""
    try
    {
	    s Date=$zd($h,8)
	    i $d(^dbo.RPVisitNumberReportI("IndexResultID",Date))  d
	    .s WorkGPMiDR="" f  s WorkGPMiDR=$o(^dbo.RPVisitNumberReportI("IndexResultID",Date,WorkGPMiDR)) q:WorkGPMiDR=""  d
	    ..s AssayNo="" f  s AssayNo=$o(^dbo.RPVisitNumberReportI("IndexResultID",Date,WorkGPMiDR,AssayNo)) q:AssayNo=""  d
	    ...s ReportDR="" f  s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexResultID",Date,WorkGPMiDR,AssayNo,ReportDR)) q:ReportDR=""  d
	    ....s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),2)
	    ....s RptOrder=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR, WorkGPMiDR,""),-1) 
	    ....i '$l(RptOrder) Quit
	    ....s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR, WorkGPMiDR,RptOrder,""))
	    ....s ReportData=$g(^dbo.RPVisitNumberReportD(ReportDR))
	    ....s RPVisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDR))
	    ....s Status=$lg(ReportData,22)
	    ....i $d(^LISSendVisitOutTime(ReportDR)) q
	    ....//急查标本
	    ....s Urgent = $lg(RPVisitNumberData,50)
	    ....i Urgent'="1" q
	    ....//审核的就不判断时间了
	    ....i Status=3 q
	    ....//接收日期
	    ....s ReceiveDate = $lg(RPVisitNumberData,66)
	    ....//接收时间
	    ....s ReceiveTime = $lg(RPVisitNumberData,67)
	    ....//当前时间
	    ....s thisDate = $zd($h,8)
	    ....//当前时间
	    ....s thisTime = $p($h,",",2)
	    ....//使用的时间
	    ....s tUsedTime=""
	    ....//计算出接收到现在的时间，取小数点之前的值
	    ....i $l(ReceiveDate),$l(ReceiveTime) s tUsedTime = $p((thisDate-ReceiveDate*24*60+(thisTime-ReceiveTime/60)),".",1)  
	    ....s TestSetDesc=""
	    ....//代表要完成报告合格所剩余的时间
	    ....s LeftTimer =0  
	    ....//就诊类型
	    ....s AdmTypeDR=$lg(RPVisitNumberData,4),AdmType=""
	    ....i $l(AdmTypeDR) s AdmType=$lg($g(^dbo.BTAdmissionTypeD(AdmTypeDR)),3)
	    ....//医嘱
	    ....s TestSetDRS=""
	    ....s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:TestSetDR=""  d
	    .....i $l(TestSetDesc) d
	    ......s TestSetDesc=TestSetDesc_"+"_$lg($g(^dbo.BTTestSetD(TestSetDR)),3)
	    ......s TestSetDRS=TestSetDRS_"@"_TestSetDR
	    .....e  s TestSetDesc=$lg(^dbo.BTTestSetD(TestSetDR),3)
	    ....s HosptialDR = $lg(RPVisitNumberData,21)
	    ....s LocationDR = $lg(RPVisitNumberData,22)
	    ....s DoctorDR = $lg(RPVisitNumberData,23)
	    ....s WardDR = $lg(RPVisitNumberData,26)
	    ....s BedNo = $lg(RPVisitNumberData,27)
	    ....s SpeciesDR = $lg(RPVisitNumberData,15)
	    ....s SpecimenDR=$lg(RPVisitNumberData,56),SpecimenDesc=""
	    ....i $l(SpecimenDR) s SpecimenDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
	    ....s ContainerDR=$lg(RPVisitNumberData,57)
	    ....s SurName=$lg(RPVisitNumberData,13)
	    ....s GivenName=$lg(RPVisitNumberData,14)
	    ....i SurName=GivenName s PatName=SurName
	    ....e  s PatName=SurName_GivenName
	    ....s Labno=$lg(RPVisitNumberData,2)
	    ....s RegNo=$lg(RPVisitNumberData,3)
	    ....s RecordNo=$lg(RPVisitNumberData,6)
	    ....s Urgent=$lg(RPVisitNumberData,50)
	    ....s LocationDR=$lg(RPVisitNumberData,22)
	    ....s EpisodeNo=$lg(ReportData,8)
	    ....s AssayNo1=$lg(ReportData,6)     
	    ....s AcceptDate=$lg(ReportData,9)
	    ....s AcceptTime=$lg(ReportData,10)
	    ....//核收了没发报告，报审核超时信息
	    ....i ((thisDate-ReceiveDate)*24*60+((thisTime-ReceiveTime)/60))-120>0 d
	    .....s info="患者："_SurName_",检验号："_Labno_",医嘱："_TestSetDesc_"急查接收两小时未出报告，请注意！"
	    .....s $NAMESPACE="DHC-LISDATA"
	    .....s retObj=##Class(wbsLisMsgAsyncHandler.LISMsg.wbsLisMsgAsyncHandlerSoap).%New()
	    .....s perUser = "WG-"_$lg($g(^dbo.BTWorkGroupMachineD(WorkGPMiDR)),4)
	    .....//s perUser = "WGM-"_WorkGPMiDR
	    .....s ret=retObj.SendMsg("dhcc","{ ""type"": ""标本超时"", ""info"": """_info_""", ""dealurl"": """" }", "Crisis", perUser)
		.....s $NAMESPACE="DHC-APP"
		.....s ^LISSendVisitOutTime(ReportDR)=""
	    return 0

	}
	catch ex
	{
		s $NAMESPACE="DHC-APP"
		s ret=ex.Data
	}
	q ret
}

/// 平台标本状态更新消息接口
/// json串多个一样的话平台不会插入后面的,所以VisitNumberDR,VisitNumberReportDR给一个就行
ClassMethod SendDHCHisInterface(MsgDR, VisitNumberDR, VisitNumberReportDR, UserDR, Date, Time, Msg, Notes, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %String
{
	s MsgDR=$g(MsgDR),VisitNumberDR=$g(VisitNumberDR),VisitNumberReportDR=$g(VisitNumberReportDR),UserDR=$g(UserDR),Msg=$g(Msg)
	s ret=""
	s Date=$g(Date),Time=$g(Time),Notes=$g(Notes)
	try
	{
		s ret="",UserCode="",UserName=""
		i $l(VisitNumberReportDR),Msg="RP" d
		.//审核者作为消息操作这
		.s UserDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),21)
		i $l(UserDR) d
		.s UserCode=$lg(^dbo.SYSUserD(UserDR),2)
		.s UserName=$lg(^dbo.SYSUserD(UserDR),3)
		
		i $l(Date)=8 s Date=$e(Date,1,4)_"-"_$e(Date,5,6)_"-"_$e(Date,7,8)
		i $l(Time) s Time=$zt(Time)
		s RegNo=""
		s Labno=""
		i $l(VisitNumberDR) d
		.s Labno=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),2)
		.s RegNo=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),3)
		.s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:TestSetDR=""  d
		..s VisitNumberTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR,""))
		..s HISOrderID=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),10)
		..i '$l(ret) s ret="{"_""""_"OEOrdItemID"_""""_":"_""""_HISOrderID_""""_","_""""_"Position"_""""_":"_""""_""""_","_""""_"ExamID"_""""_":"_""""_Labno_""""_","_""""_"Status"_""""_":"_""""_Msg_""""_","_""""_"UserID"_""""_":"_""""_UserCode_""""_","_""""_"UserName"_""""_":"_""""_UserName_""""_","_""""_"UpDateTime"_""""_":"_""""_Date_" "_Time_""""_","_""""_"SourceSystem"_""""_":"_""""_"LIS"_""""_"}"
		..e  s ret=ret_",{"_""""_"OEOrdItemID"_""""_":"_""""_HISOrderID_""""_","_""""_"Position"_""""_":"_""""_""""_","_""""_"ExamID"_""""_":"_""""_Labno_""""_","_""""_"Status"_""""_":"_""""_Msg_""""_","_""""_"UserID"_""""_":"_""""_UserCode_""""_","_""""_"UserName"_""""_":"_""""_UserName_""""_","_""""_"UpDateTime"_""""_":"_""""_Date_" "_Time_""""_","_""""_"SourceSystem"_""""_":"_""""_"LIS"_""""_"}"
		..//更新医嘱接收状态 DaiYi 20210409
		..//i $l(Labno),$l(HISOrderID) d
		..//.s $namespace="DHC-LISDATA"
		..//.s TSState=5
		..//.i Msg="Receive" s TSState=5
		..//.i Msg="HISReject" s TSState=8
		..//.i Msg="Accept" s TSState=9
		..//.i Msg="HISAuthorise" s TSState=12
		..//.i Msg="HISReAuthorise" s TSState=12
		..//.i Msg="HISReportUndo" s TSState=9
		..//.i Msg="CACCEPT" s TSState=9
		..//.s ret=##class(LIS.WS.BLL.DHCENSLabInterface).OrderItemExec(Labno,HISOrderID,TSState)
		..//.s $namespace="DHC-APP"

		//拆分主,次报告审核或者取消审核  
		s SplitStatus=""   //1:主报告 2:次报告
		I $l(VisitNumberReportDR) s SplitStatus=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),44)
		I SplitStatus'="" D
		.s MainReportDR=""
		.i SplitStatus=2 s MainReportDR=$O(^dbo.RPReportSplitRecordI("IndexSpitMain",VisitNumberReportDR,""))
		.i $l(MainReportDR) s VisitNumberReportDR=MainReportDR //消息按主报告处理
		.//审核------>
		.i Msg="RP" D  Q  
		..s retval=##Class(LISAPP.Common.Service.DHCReportFileServiceFacade).GetSplitReportDR(VisitNumberReportDR,.ReportSplitList)
		..i retval=0 d   //部分审核 发报告地址，当作中间报告处理
		...s Msg="PRP" 
		...s Notes=##Class(LISAPP.Common.Service.DHCReportFileServiceFacade).GetReportUrlByReportDRMTHD(VisitNumberReportDR)
		.//取消------> //删除主报告
		.i Msg="CRP" D  Q 
		..s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface("DeleteSystemStatus",VisitNumberReportDR)
		
		///统一平台中心JSON串格式
		i $l(VisitNumberReportDR) d
		.s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexReportID",VisitNumberReportDR,TestSetDR)) q:TestSetDR=""  d
		..s VisitNumberTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexReportID",VisitNumberReportDR,TestSetDR,""))
		..s HISOrderID=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),10)
		..s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),2)
		..s Labno=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),2)
		..i '$l(ret) s ret="{"_""""_"OEOrdItemID"_""""_":"_""""_HISOrderID_""""_","_""""_"Position"_""""_":"_""""_""""_","_""""_"ExamID"_""""_":"_""""_Labno_""""_","_""""_"Status"_""""_":"_""""_Msg_""""_","_""""_"UserID"_""""_":"_""""_UserCode_""""_","_""""_"UserName"_""""_":"_""""_UserName_""""_","_""""_"UpDateTime"_""""_":"_""""_Date_" "_Time_""""_","_""""_"SourceSystem"_""""_":"_""""_"LIS"_""""_","_""""_"Notes"_""""_":"_""""_Notes_""""_"}"
		..e  s ret=ret_",{"_""""_"OEOrdItemID"_""""_":"_""""_HISOrderID_""""_","_""""_"Position"_""""_":"_""""_""""_","_""""_"ExamID"_""""_":"_""""_Labno_""""_","_""""_"Status"_""""_":"_""""_Msg_""""_","_""""_"UserID"_""""_":"_""""_UserCode_""""_","_""""_"UserName"_""""_":"_""""_UserName_""""_","_""""_"UpDateTime"_""""_":"_""""_Date_" "_Time_""""_","_""""_"SourceSystem"_""""_":"_""""_"LIS"_""""_","_""""_"Notes"_""""_":"_""""_Notes_""""_"}"
		///推送报告状态到平台中心
		i $l(ret) d
		.s keyWord="条码:"_Labno_",登记号:"_RegNo
		.s ret="["_ret_"]"
		.s retStream=##class(%GlobalCharacterStream).%New()
		.d retStream.Write(ret)
		.s ret=..DHCHisInterfaceProxy("UpdateSystemStatus",retStream,"",keyWord)
	}
	catch ex
	{
		s ret="-1^"_ex.Data
	}
	q ret
}

/// 也可以直接调用##Class(LISAPP.LIS.DHCLISServiceLog).DoService托管使用
/// 托管代理推消息给HIS的接口给业务调用
/// d ##class(web.DHCLisRealTimeInterface).DHCHisInterfaceProxy("","","") 
ClassMethod DHCHisInterfaceProxy(keyName As %String, Input, serviceName, keyWord) As %String
{
	set ret=""
	try
	{
		s keyName=$g(keyName)
		s Input=$g(Input)
		s serviceName=$g(serviceName)
		i '$l(serviceName) s serviceName="给平台推数据数据"
		s keyWord=$g(keyWord)
		i '$l(keyWord) s keyWord=keyName
		s ClassName="web.DHCENS.EnsHISService"
		s FunName="DHCHisInterface"
		s ret=##Class(LISAPP.LIS.DHCLISServiceLog).DoService(keyName,serviceName,keyWord,"",ClassName,FunName,keyName, Input)
	}
	catch ex
	{
		s ret="-1^"_ex.Code_ex.Data
	}
	q ret
}

}
