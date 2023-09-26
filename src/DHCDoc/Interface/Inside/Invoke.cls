/// creator:guorongyong
/// date:2016-05-13
/// desc:和东华内部系统的接口类【主要是调用其他产品组的接口】,仅医生站,不包括建卡,挂号,分诊与内部的接口
Class DHCDoc.Interface.Inside.Invoke Extends DHCDoc.Util.RegisteredObject [ Not ProcedureBlock ]
{

/// Descript: 医生是否有录长期医嘱权限
/// 提供产品组: 新产品组
/// CreateDate: 2020-05-12
/// InPut: EpisodeID - 就诊ID,EmConsultItm="" ;会诊表ID
/// OutPut: QuitFlag：1-有权限，0-无权限
/// w ##Class(DHCDoc.Interface.Inside.Invoke).TakOrdLongAut("71") 
ClassMethod TakOrdLongAut(EpisodeID As %String, EmConsultItm As %String = "") As %String
{
	;Q ##Class(web.DHCEMConsInterface).GetCstPrintFlag(EpisodeID)
	Q:EmConsultItm="" 0
	Q ##Class(web.DHCEMConsInterface).GetTakOrdAut(EmConsultItm)
}

/// Creator:      郭荣勇
/// CreatDate:    2017.03.09
/// Description:  得到检查项目有的申请单信息,也用于判断检查项目是否可撤销或者作废
/// Table:        
/// Input:        oeitm:医嘱RowId   UserID:用户ID
/// Return:      
/// Others:       w ##class(DHCDoc.Interface.Inside.Invoke).GetTmInfoByOrderRowId("747886||227") 
ClassMethod GetTmInfoByOrderRowId(OEORIRowId As %String) As %String
{
	n (OEORIRowId)
	q:OEORIRowId="" ""
	
	s OutInfo=""
	;1. Pis检查项目(pis升级，不在使用此接口，判断申请单和医嘱)
	;s OutInfo=##class(web.DHCPisApplicationSheet).GetTmInfoByOrderRowId(OEORIRowId)
	;2. 病历检查项目判断
	
	;3. RIS检查项目判断,RIS已经在停止或者作废的时候自动取消了申请单
	
	Q OutInfo
}

/// Creator:      郭荣勇
/// CreatDate:    2017.04.1
/// Description:  撤销,作废,停止 操作发起推送接口交易,eg:第三方医技系统消息推送
/// Table:        
/// Input:        oeitm:医嘱RowId UserID:用户ID
/// Return:      
/// Others:       w ##class(DHCDoc.Interface.Inside.Invoke).CancelOrdInterface("747886||227") 
ClassMethod CancelOrdInterface(OEORIRowId As %String, UserID As %String = "", status As %String = "", ItemPartID As %String = "", LocID As %String = "") As %String
{
	n (OEORIRowId,UserID,status,ItemPartID,LocID)
	s $zt="ErrCancelOrdInterface"
	q:OEORIRowId="" ""
	
	s OutRet=""
	;1. 调用平台组接口,内部服务总线
	s OutRet=##class(web.DHCENS.EnsHISService).DHCHisInterface("STOPORDERITEMINFO",OEORIRowId)
	;2. 调用检查申请取消接口
	i (..%IsValidMethod("web.DHCAPPInterface","StopOrderInvExaReqNo")) {
		s OutRet=##Class(web.DHCAPPInterface).StopOrderInvExaReqNo(OEORIRowId,ItemPartID,UserID)
	}
	;3. pacs工作站停医嘱接口申请单
	/*
	//tanjishan ,已联系丁智勇，由服务总线去通知pacs工作站
	i (..%IsValidMethod("RISService.InvokeRISService","DiscontinueAppInfoPACS")) {
		s OutRet=##Class(RISService.InvokeRISService).DiscontinueAppInfoPACS(OEORIRowId)
	}
	
	i (..%IsValidMethod("web.DHCRisResourceApptSchudle","CancelBook")) {
		s OutRet=##class(web.DHCRisResourceApptSchudle).CancelBook(OEORIRowId)
	}*/
	if (status'=""){
		;调用医政接口改变临床路径医嘱状态
		s adm=$p(^OEORD(+OEORIRowId),"^",1)
		i (..%IsValidMethod("DHCMA.CPW.IO.ToDoc","ChangeOrdStatus")) {
			d ##class(DHCMA.CPW.IO.ToDoc).ChangeOrdStatus(adm,status,OEORIRowId,UserID)
		}
	}
	;调用杭州逸曜合理用药停医嘱接口
	i (..%IsValidMethod("web.DHCDocHLYYHZYY","StopHLYYInfo")) {
		s OutRet=##Class(web.DHCDocHLYYHZYY).StopHLYYInfo(OEORIRowId,status)
	}
	;调用平台状态统一存储接口存储状态
	s StatusCode=$CASE(status,"1":"STOP","2":"REVOKE","3":"VOID",:"")
	s ArcimRowId=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",2)
	s ItmCat=$p($g(^ARCIM($p(ArcimRowId,"||",1),$p(ArcimRowId,"||",2),1)),"^",10)
	s OrdType=$p($g(^ARC("IC",ItmCat)),"^",7)	;ARCIC_OrderType	
	if (OrdType="R" ){
		d ##class(DHCDoc.Interface.Inside.Invoke).UpdExaReqItmStatus(StatusCode,"",UserID,OEORIRowId,LocID)
		}
	Q OutRet
ErrCancelOrdInterface
	s $zt=""
	q ""
}

/// Creater: 宋春莉
/// CreateDate: 2020.08.04
/// Descript: 医生办理出院
/// InPut: EpisodeID - 就诊ID orderId-医嘱ID userId-用户ID  disconId-出院条件ID  deaddate-死亡日期 deadtime-死亡时间 disChargeMethodId-离院方式ID
/// OutPut: 0-成功 其他-失败
/// w ##Class(DHCDoc.Interface.Inside.Invoke).doctorDischarge
ClassMethod doctorDischarge(EpisodeID As %String, orderId As %String, userId As %String, disconId As %String, deaddate As %String = "", deadtime As %String = "", disChargeMethodId = "") As %String
{
	Q ##class(web.DHCDischargeHistory).doctorDischarge(EpisodeID, orderId, userId, disconId, deaddate, deadtime,disChargeMethodId)
}

/// Creater: 宋春莉
/// CreateDate: 2020.08.04
/// Descript: 医生撤销出院
/// InPut: EpisodeID - 就诊ID  userId-用户ID 
/// OutPut: 0-成功 其他-失败
/// w ##Class(DHCDoc.Interface.Inside.Invoke).CancelDoctorDischarge
ClassMethod CancelDoctorDischarge(EpisodeID As %String, userId As %String) As %String
{
	Q ##class(web.DHCDischargeHistory).CancelDoctorDischarge(EpisodeID, userId)
}

/// Creater: 宋春莉
/// CreateDate: 2020.08.04
/// Descript: 获取出院时间
/// InPut: EpisodeID - 就诊ID
/// OutPut: 出院时间
/// w ##Class(DHCDoc.Interface.Inside.Invoke).GetDischargeDateTime
ClassMethod GetDischargeDateTime(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
	s EstDischConfirmed=$P($G(^PAADM(EpisodeID,2)),"^",25)
	Q:EstDischConfirmed'="Y" ""
	Q ##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID)
}

/// Creater: tanjishan
/// CreateDate: 2020.09.15
/// Descript: 获取入院时间
/// InPut: EpisodeID - 就诊ID
/// OutPut: 入院时间
/// w ##Class(DHCDoc.Interface.Inside.Invoke).GetAdminDateTime
ClassMethod GetAdminDateTime(EpisodeID As %String) As %String
{
	Q ##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID)
}

/// Creater: tanjishan
/// CreateDate: 2020.09.15
/// Descript: 获取出入院时间
/// InPut: EpisodeID - 就诊ID
/// OutPut: 入院时间
/// w ##Class(DHCDoc.Interface.Inside.Invoke).GetAdmInOutDatebyEpisodeID
ClassMethod GetAdmInOutDate(EpisodeID As %String) As %String
{
	Q ##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(EpisodeID)
}

/// Creater: 宋春莉
/// CreateDate: 2020.08.04
/// Descript: 医生开立出院医嘱释放床位管理中心床位
/// InPut: EpisodeID - 就诊ID UserID - 用户ID ArcimID - 出院医嘱项ID
/// OutPut: 0-成功 其他-失败
/// w ##Class(DHCDoc.Interface.Inside.Invoke).orderReleaseBed
ClassMethod orderReleaseBed(EpisodeID As %String, UserID As %String, ArcimID As %String) As %String
{
	Q ##class(Nur.InService.Interface).orderReleaseBed(EpisodeID,UserID,ArcimID)
}

/// Creater: 宋春莉
/// CreateDate: 2020.08.04
/// Descript: 医嘱/草药录入页面是否显示“添加临床路径医嘱”按钮
/// InPut: EpisodeID - 就诊ID
/// OutPut: 1：显示；其他：不显示
/// w ##Class(DHCDoc.Interface.Inside.Invoke).GetPathStatusToDOC
ClassMethod GetPathStatusToDOC(EpisodeID As %String) As %String
{
	Q ##Class(DHCMA.CPW.IO.ToDoc).GetPathStatusToDOC(EpisodeID)
}

/// Creater: 宋春莉
/// CreateDate: 2020.08.04
/// Descript: 门诊路径医嘱审核后，将医嘱OrderID插入执行记录表
/// InPut: aEpisodeID - 就诊ID OrderStr - 医嘱串 aUserID - 用户ID  aType
/// OutPut: 0：成功；其他：失败
/// w ##Class(DHCDoc.Interface.Inside.Invoke).ExeOrderRewriteCPW
ClassMethod ExeOrderRewriteCPW(aEpisodeID As %String, OrderStr As %String, aUserID As %String, aType As %String = "W") As %String
{
	Q ##Class(DHCMA.CPW.IO.ToDoc).ExeOrderRewriteCPW(aEpisodeID,OrderStr,aUserID,aType)
}

/// Creater: 宋春莉
/// CreateDate: 2020.08.04
/// Descript: 医生站医嘱状态修改时调用接口（合并门诊路径、住院路径）
/// InPut: aEpisodeID : 就诊ID aType : 1停止2撤销3作废 aOrdIDStr : 医嘱ID串
/// OutPut: 1
/// w ##Class(DHCDoc.Interface.Inside.Invoke).ChangeOrdStatus
ClassMethod ChangeOrdStatus(aEpisodeID As %String, aType As %String, aOrdIDStr As %String, aUserID As %String) As %String
{
	Q ##Class(DHCMA.CPW.IO.ToDoc).ChangeOrdStatus(aEpisodeID,aType,aOrdIDStr,aUserID)
}

/// description: 医嘱闭环接口
/// Others: w ##class(DHCDoc.Interface.Inside.Invoke).UpdExaReqItmStatus()
ClassMethod UpdExaReqItmStatus(StatusCode, PisItmID, UserID, Oeori, LocID) As %String
{
	n (StatusCode, PisItmID, UserID, Oeori, LocID)
	s UserCode=$p($g(^SSU("SSUSR",+UserID)),"^",1)
	s UserName=$p($g(^SSU("SSUSR",+UserID)),"^",2)
	s DeptCode="",DeptDesc=""
	if (LocID'=""){
		s DeptCode=$P($G(^CTLOC(+LocID)),"^",1)
		s DeptDesc=$P($G(^CTLOC(+LocID)),"^",2)
	}
	s DataList=[]
	s Position="",PisNo=""
	if (PisItmID'=""){
		s PisID = +PisItmID
		s CH = $p(PisItmID,"||",2)
		s Oeori=$p(^DHCAPPPM(PisID,"A",CH),"^",3)   /// 检查申请医嘱ID
		s PisNo=$p(^DHCAPPPM(PisID),"^",13)     
	}                       
	s DymObj={}
	s DymObj.OEOrdItemID =Oeori
	s DymObj.Position =Position
	s DymObj.ExamID =PisNo
	s DymObj.Status =StatusCode
	s DymObj.UserID =UserCode
	s DymObj.UserName =UserName
	s DymObj.UpDateTime =$zd(+$h,3)_" "_..%ZT(..%SysTime(),2)
	s DymObj.SourceSystem ="HIS"
	s DymObj.OperateDeptCode=DeptCode
	s DymObj.OperateDept=DeptDesc
	d DataList.%Push(DymObj)
	s Steam = ##class(%Stream.GlobalCharacter).%New()
	d Steam.Write(DataList.%ToJSON())
	s Ret = ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",Steam)
	q 0
}

/// Creater: 王清雍
/// CreateDate: 2023.02.06
/// Descript: 判断医嘱项是否为转科、转病区医嘱
/// InPut: ArcimRowid : 医嘱项ID HospID : 院区ID
/// OutPut: "TL"(转科TransLoc)、"TW"(转病区TransWard)、"TL|TW"(同时属于转科转病区)、空值(不属于转科转病区医嘱)
/// w ##Class(DHCDoc.Interface.Inside.Invoke).GetArcimTransType("4189||1",2)
ClassMethod GetArcimTransType(ArcimRowid, HospID) As %String
{
	n (ArcimRowid, HospID,%session)
	s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
	s TransOrdCatStr=##Class(Nur.Interface.OutSide.Order).GetArcimBeforeTrans("arcimBeforeTrans", HospID)
	s TransWardOrdCatStr=##Class(Nur.Interface.OutSide.Order).GetArcimBeforeTransWard("arcimBeforeTransWard", HospID)
	s TransLocFlag=("^"_TransOrdCatStr_"^")[("^"_ItemCatDR_"^")
	s TransWardFlag=("^"_TransWardOrdCatStr_"^")[("^"_ItemCatDR_"^")
	Q:TransLocFlag&&TransWardFlag "TL|TW"
	Q:TransLocFlag "TL"
	Q:TransWardFlag "TW"
	Q ""
}

/// Creater: 李旭
/// CreateDate: 2023.04.12
/// Descript: 通过医嘱项ID，获取医嘱项维护的图标
/// InPut: ArcimRowid : 医嘱项ID、HospID : 院区ID
/// OutPut: img标签
/// w ##Class(DHCDoc.Interface.Inside.Invoke).GetDrugIconsByArcim("1||1",2)
ClassMethod GetDrugIconsByArcim(ArcimID, HospID = "") As %String
{
	n (ArcimID, HospID,%session)
    s DrugIconStr=""
	s OrderType=##class(web.DHCDocOrderCommon).GetOrderType(ArcimID)
	Q:OrderType'="R" DrugIconStr
    s IconObj=##class(PHA.FACE.OUT.Com).GetDrugIconsByArcim(ArcimID)
    for Len=0:1:IconObj.%Size()-1{
        s OneObj=IconObj.%Get(Len)
        s ImgPath="<img src='"_OneObj.iconPath_"' tips_title='"_OneObj.iconTips_"' class='pha-drugicon'/>"
        s DrugIconStr=DrugIconStr_ImgPath
    }
    Q DrugIconStr
}

}
