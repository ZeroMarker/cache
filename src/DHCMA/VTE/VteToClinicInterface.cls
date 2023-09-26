/// vte给临床提供的接口方法
/// Date 2021-03-29
/// 武加锋
Class DHCMA.VTE.VteToClinicInterface [ Abstract, ClassType = "", Not ProcedureBlock ]
{

// 获取VTE风险等级 

// Return 0：未知 1：极低 2：低危 3：中危 4：高危 5：极高危

// w ##class(DHCMA.VTE.VteToClinicInterface).getVteRiskLevel("315")

ClassMethod getVteRiskLevel(episodeId As %String) As %String
{
	New (episodeId)
	Set riskLevel=0
	Set id=0
	Set id=$o(^DHCMA.VTE.VtePointCaseI("IndexEpisodeDr"," "_episodeId,id))
	Quit:id="" riskLevel
	Set riskLevel=$listget($g(^DHCMA.VTE.VtePointCaseD(id)),3) ;风险等级
	Quit riskLevel
	
getVteRiskLevel
	Quit 0
}

// 获取VTE预防治疗提醒医嘱

// return 医嘱项ID1^医嘱项ID2^医嘱项ID3^医嘱项ID4^.......

// w ##class(DHCMA.VTE.VteToClinicInterface).getVteOrderId()

ClassMethod getVteOrderId() As %String
{
	Set orderIdStr=""
	Set id=0
	for
	{
		Set id=$o(^DHCMA.VTE.CLINIC.ClcAssistanOrd("IndexOrderAlert"," 1",id))
		Quit:id=""
		Set orderId = ""
		Set orderId=$listget($g(^DHCMA.VTE.CLINIC.ClcAssistanOrd(id)),2)
		Continue:orderId=""
		Set orderIdStr = orderId_"^"_orderIdStr
	}
	Quit orderIdStr
	
getVteOrderIdErr
	Quit ""
}

// 直接插入医嘱 无需审核

// w ##class(DHCMA.VTE.VteToClinicInterface).insertOrderItem(315,4636,197,6024||1,10)

// Input :admId就诊号  UserID 当前登录人的id  userDeptId当前登录人的科室 ArcimID医嘱ID OrderPrice医嘱费用

ClassMethod insertOrderItem(admId As %String, UserID As %String, userDeptId As %String, ArcimID As %String, OrderPrice As %String)
{
	
	s TargetDoc=$p($g(^SSU("SSUSR",UserID)),"^",14)
	s OrderPackQty=1 //医嘱数量
	s OrderQtySum=1 //医嘱单位总数量
	s OrderPriorRowid=$o(^OECPR(0,"Code","NORM","")) //医嘱优先级	
	
 	s ARCIMItemCatDR=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",10)
 	i ARCIMItemCatDR'="" s OrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7) //医嘱项类型代码
 	
 	s OrderStartDate=$zd(+$h,4),OrderStartTime=$zt($p($h,",",2),2) ///开始日期时间
 	s BillTypeRowid=$p($g(^PAADM(admId,1)),"^",7)  //费别指针
 	s OrderSeqNo=1 //医嘱序号 
 	s AnaesthesiaID=""
 	s OrderDepProcNotes="" //备注
 	
 	s AdmStr = $g(^PAADM(+admId))
	s OrderRecDepRowid	= $p(AdmStr,"^",4)	//医嘱接收科室
	s OrderDrugFormRowid = "" // 药学关联指针
	
 	s OrderSkinTest="N"      //皮试
 	s OrderCoverMainIns="N"   //医保标示 OEORI_CoverMainIns（住院）
 	s OrderLabSpecRowid=""  //标本代码
 	S OrderItemStr=ArcimID_"^"_OrderType_"^"_OrderPriorRowid_"^"_OrderStartDate  //4
 	S OrderItemStr=OrderItemStr_"^"_OrderStartTime_"^"_OrderPackQty_"^"_OrderPrice_"^"_OrderRecDepRowid_"^"_BillTypeRowid_"^"_OrderDrugFormRowid //10
	S OrderItemStr=OrderItemStr_"^"_OrderDepProcNotes_"^^^^^" //16
 	S OrderItemStr=OrderItemStr_"^^^^"_OrderSeqNo_"^"_OrderSkinTest_"^"  //22
 	S OrderItemStr=OrderItemStr_"^"_OrderCoverMainIns_"^^^^^" //28
 	S OrderItemStr=OrderItemStr_"^^^^^^^^^"_AnaesthesiaID ///37
 	
 	s Ret=##class(web.DHCOEOrdItem).SaveOrderItems(admId,OrderItemStr,UserID,userDeptId,TargetDoc)
 	
 	Quit Ret
	
insertOrderItemErr
	Quit ""
}

// w ##class(DHCMA.VTE.VteToClinicInterface).HttpGetVTE("315")

ClassMethod HttpGetVTE(EpisodeID As %String) As %String
{
	New (EpisodeID)
	Set return=0
	Quit:EpisodeID="" return 
	Set tResponse=##class(%Net.HttpRequest).%New()
	Set tResponse.Server="127.0.0.1"
	Set tResponse.Port="8081"
	Do tResponse.ContentTypeSet("application/json")
	DO tResponse.Get("/api/getNodeInfo?EpisodeID="_EpisodeID_"&EventType=DISC")
	Set res=tResponse.HttpResponse.Data
	Do ##class(ext.util.JsonObject).ParseJSON(res,"",.obj)
	Set code = obj.code
	
	return code
}

}
