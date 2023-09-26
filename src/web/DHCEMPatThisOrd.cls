Import sqluser

Class web.DHCEMPatThisOrd Extends (%RegisteredObject, %XML.Adaptor, ) [ Not ProcedureBlock ]
{

/// w ##class(web.DHCEMPatThisOrd).GetOrdByAdmDataToJsonNew(1,60,"610^全部^2")
ClassMethod GetOrdByAdmDataToJsonNew(page, rows, Params)
{
	n (page, rows, Params,%session)
	s Start=page-1*rows+1
	s End=page*rows

	s EpisodeID = $p(Params,"^",1)
	s OrderType=$p(Params,"^",2)
	s:OrderType="全部" OrderType=""
	s InHospID = $p(Params,"^",3)
	s StopOrd = $p(Params,"^",4)
	s:StopOrd=1 StopOrd=""
	s:StopOrd=2 StopOrd="Stop"
	s Pid=$i(^CacheTemp)
	k ^TMP("DHCEM","web.DHCEMPatThisOrd","GetOrdByAdmDataToJsonNew",Pid) 
	k ^TMP("DHCEM","web.DHCEMPatThisOrd","GetOrdByAdmDataToJsonItmPrice",Pid) 

	s Num = 0 
	;s PatientID = $p(^PAADM(EpisodeID),"^",1)
	;Set Result=##class(%Library.ResultSet).%New("web.DHCDocOPOrdInfo:GetOrdByAdm")
	;Set Sc=Result.Execute(EpisodeID,"","","") ;就诊ID^用户ID^计费状态^停止医嘱
	Set Result=##class(%Library.ResultSet).%New("web.DHCDocQryOEOrder.GetOrdByAdm")
	Set Sc=Result.Execute(EpisodeID,"","","","","","","","","","","",StopOrd)
	If $$$ISERR(Sc) Quit ""

	Set ColNum=Result.GetColumnCount() //列数
	While(Result.Next())
	{ 
		s ActiveQtySum = Result.Data("OrderSum")
		s ArcPrice = Result.Data("ArcPrice")
		s OrdBilled = Result.Data("OrdBilled")
		s OrdCreateDate = Result.Data("OrdCreateDate")
		s OrdCreateTime = Result.Data("OrdCreateTime")
		s OrdStartDate = Result.Data("OrdStartDate")
		s OrdStartTime = Result.Data("OrdStartTime")
		s ArcimDesc = Result.Data("ArcimDesc")
		s DoseQty = Result.Data("DoseQty")
		s OrderPackQty = Result.Data("OrderPackQty")
		s PackUOMDesc=Result.Data("PackUOMDesc")
		s OrderPackQty = OrderPackQty_PackUOMDesc  //总量
		s DoseUnit = Result.Data("DoseUnit")
		s PHFreq = Result.Data("PHFreq")
		s Priority = Result.Data("Priority")
		s Instr = Result.Data("Instr")
		s Doctor = Result.Data("Doctor")
		s Dura = Result.Data("Dura")
		s OrdStatus = Result.Data("OrdStatus")
		s OrdAction = Result.Data("OrdAction")
		s OrdDepProcNotes = Result.Data("OrdDepProcNotes")
		s OEItemID = Result.Data("OEItemID")
		s OrdXDate = Result.Data("OrdXDate")
		s OrdXTime=""
		s EndDate = Result.Data("EndDate")
		s BillType = Result.Data("BillType")
		s ActiveQty = Result.Data("ActiveQty")
		s LabEpisodeNo = ##class(web.DHCEMOrdInfoVO).getLisOrdLabNo(+OEItemID,$p(OEItemID,"||",2))
		s:LabEpisodeNo'="" LabEpisodeNo=$p(LabEpisodeNo,"^",1)
		s MaterialBarCode = Result.Data("MaterialBarCode")
		s PrescNo = Result.Data("PrescNo")
		s OrdSkinTestResult = Result.Data("OrdSkinTestResult")
		s OrderTypeDesc = ##class(web.DHCEMInComUseMethod).GetOECCatByOEORDItmDr(OEItemID)
		s DataList = ActiveQtySum_"^"_ArcPrice_"^"_OrdBilled_"^"_ActiveQty_"^"_OrdCreateDate_"^"_OrdCreateTime_"^"_OrdStartDate_"^"_OrdStartTime
		s DataList= DataList_"^"_ArcimDesc_"^"_DoseQty_"^"_DoseUnit_"^"_Priority_"^"_Instr_"^"_Dura_"^"_OrdStatus_"^"_OrdAction_"^"_OrdDepProcNotes
		s DataList= DataList_"^"_OEItemID_"^"_OrdXDate_"^"_OrdXTime_"^"_BillType_"^"_PrescNo_"^"_OrdSkinTestResult_"^"_LabEpisodeNo_"^"_PHFreq
		s DataList= DataList_"^"_Doctor_"^"_EndDate_"^"_OrderPackQty
		s ^TMP("DHCEM","web.DHCEMPatThisOrd","GetOrdByAdmDataToJsonNew",Pid,OrderTypeDesc,OEItemID)=DataList
		s ^TMP("DHCEM","web.DHCEMPatThisOrd","GetOrdByAdmDataToJsonNew",Pid,OrderTypeDesc) =$g(^TMP("DHCEM","web.DHCEMPatThisOrd","GetOrdByAdmDataToJsonNew",Pid,OrderTypeDesc))+ActiveQtySum
	}

	Do Result.Close()
	
	s InHospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmDocOrderCat",InHospID)  ;多院区改造
	
	b ;data 获取数据
	s TotalAmount=0 //总费用
	s PayedAmount=0 //已缴费合计
	s NotPayedAmount=0 //未缴费合计
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	s Count=0,CountNum=0
	s DataStr = "ActiveQtySum^ArcPrice^OrdBilled^ActiveQty^OrdCreateDate^OrdCreateTime^OrdStartDate^OrdStartTime"
	s DataStr = DataStr_"^ArcimDesc^DoseQty^DoseUnit^Priority^Instr^Dura^OrdStatus^OrdAction^OrdDepProcNotes"
	s DataStr = DataStr_"^OEItemID^OrdXDate^OrdXTime^BillType^PrescNo^OrdSkinTestResult^LabEpisodeNo^PHFreq"
	s DataStr = DataStr_"^Doctor^EndDate^OrderPackQty"
	s OrderTypeDesc=""
	s DocId =0
	f  s DocId = $o(^DHCEMDOCA(DocId)) q:DocId=""  d     //类型出发点从后台配置的类型表中取
	.q:$p(^DHCEMDOCA(DocId),"^",4)'="Y"   //过滤掉启用状态为N的数据
	.s SetHospID = $p(^DHCEMDOCA(DocId),"^",3)
	.q:(InHospID'="")&&(InHospID'=SetHospID)
	.s OecDr = $p($g(^DHCEMDOCA(DocId)),"^",1)
	.q:OecDr=""
	.s OrderTypeDesc = $p($g(^OEC("ORCAT",OecDr)),"^",2)
	.s OrderTypeDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.OECOrderCategory","ORCATDesc","",OrderTypeDesc)
	.q:(OrderType'="")&&(OrderType'=OrderTypeDesc)
	.q:'$d(^TMP("DHCEM","web.DHCEMPatThisOrd","GetOrdByAdmDataToJsonNew",Pid,OrderTypeDesc))
	.s AllPrice = ^TMP("DHCEM","web.DHCEMPatThisOrd","GetOrdByAdmDataToJsonNew",Pid,OrderTypeDesc)
	.s AllPrice = $j(AllPrice,"",$l($p(AllPrice,".",2)))
	.s ^TMP("DHCEM","web.DHCEMPatThisOrd","GetOrdByAdmDataToJsonItmPrice",Pid,OrderTypeDesc)=AllPrice
	.i '(((CountNum+1)<Start)||((CountNum+1)>End)) d
	..S Count=Count+1
	..W $case(Count,Start:"",:",") 
	..W ##class(web.DHCAPPJsonCommon).getJsonData(DataStr,OrderTypeDesc_"^"_AllPrice)
	.s Num=0
	.f  s Num = $o(^TMP("DHCEM","web.DHCEMPatThisOrd","GetOrdByAdmDataToJsonNew",Pid,OrderTypeDesc,Num)) q:Num=""  d
	..s DataList = ^TMP("DHCEM","web.DHCEMPatThisOrd","GetOrdByAdmDataToJsonNew",Pid,OrderTypeDesc,Num)
	..s OrdBilled = $p(DataList,"^",3)       //计费状态
	..s ActiveQtySum = $p(DataList,"^",1)	 //总金额 
	..s TotalAmount = TotalAmount+ActiveQtySum
	..s:OrdBilled="已收费" PayedAmount=PayedAmount+ActiveQtySum
	..s:OrdBilled'="已收费" NotPayedAmount=NotPayedAmount+ActiveQtySum
	..s Count=Count+1
	..S CountNum=CountNum+1
	..Q:CountNum<Start
	..Q:CountNum>End
	..W $case(Count,Start:"",:",") 
	..W ##class(web.DHCAPPJsonCommon).getJsonData(DataStr,DataList)
	s Del=""""
	w "],"
	s CountI=0
	w Del_"TotalAmount"_Del_":"""_TotalAmount_""","
	w Del_"PayedAmount"_Del_":"""_PayedAmount_""","
	w Del_"NotPayedAmount"_Del_":"""_NotPayedAmount_""","
	w Del_"ItmPriceScale"_Del_":"
	w "["
	s OrderTypeDesc=""
	f  s OrderTypeDesc = $o(^TMP("DHCEM","web.DHCEMPatThisOrd","GetOrdByAdmDataToJsonItmPrice",Pid,OrderTypeDesc)) q:OrderTypeDesc=""  d
	.s ItmPrice = ^TMP("DHCEM","web.DHCEMPatThisOrd","GetOrdByAdmDataToJsonItmPrice",Pid,OrderTypeDesc)
	.s:+TotalAmount=0 ItmScale = 0
	.s:+TotalAmount'=0 ItmScale = ItmPrice/TotalAmount
	.s ItmScale = $j(ItmScale,"",3)
	.s ItmData= OrderTypeDesc_"^"_ItmScale
	.s CountI=CountI+1
	.W $case(CountI,1:"",:",") 
	.W ##class(web.DHCAPPJsonCommon).getJsonData("OrderTypeDesc^Scale",ItmData)
	w "],"
	
	w Del_"total"_Del_":"""_CountNum_"""}"
	
	k ^TMP("DHCEM","web.DHCEMPatThisOrd","GetOrdByAdmDataToJsonNew",Pid)
	k ^TMP("DHCEM","web.DHCEMPatThisOrd","GetOrdByAdmDataToJsonItmPrice",Pid) 
	q ""
}

/// w ##class(web.DHCEMPatThisOrd).GetChlidByOeoriId("43||9")
ClassMethod GetChlidByOeoriId(oeoriId)
{
	n (oeoriId)
	q:oeoriId="" ""
	s mainOeori=""
	s ord = $p(oeoriId,"||",1)
	s itm = $p(oeoriId,"||",2)
	s mainOeori = $p(^OEORD(ord,"I",itm,11),"^",39)
	q mainOeori
}

/// w ##class(web.DHCEMPatThisOrd).GetOrderTypeByOeoriId("43||9")
ClassMethod GetOrderTypeByOeoriId(oeoriId)
{
	n (oeoriId)
	q:oeoriId="" ""
	s orderType=""
	s ord = $p(oeoriId,"||",1)
	s itm = $p(oeoriId,"||",2)
	s ordstr=$g(^OEORD(ord,"I",itm,1))
	s arcimId=$p(ordstr,"^",2)	//医嘱子类ID 10492||1 11-09
	s arctpdr=$p(^ARCIM($p(arcimId,"||",1),$p(arcimId,"||",2),1),"^",10)
	s orderTypeDr=$P(^ARC("IC",arctpdr),"^",8)	 //11-09
	s orderType=$P(^OEC("ORCAT",orderTypeDr),"^",2) //11-09
	q orderType
}

/// w ##class(web.DHCEMPatThisOrd).GetArciDescByOriId("244||11")
ClassMethod GetArciDescByOriId(oeoriId)
{
	n (oeoriId)
	q:oeoriId="" ""
	s ord = $p(oeoriId,"||",1)
	s itm = $p(oeoriId,"||",2)
	s ordstr=$g(^OEORD(ord,"I",itm,1))
	s ArcimId=$p(ordstr,"^",2)	//医嘱子类ID 10492||1 11-09
	s ArcStr=""
	s ArcStr=##class(web.DHCFBArcimGet).GetArcimById(ArcimId)	
	q ArcStr
}

/// 描述：获取材料类医嘱绑定的检验医嘱
/// 返回值：""或者OeoriID
/// w ##class(web.DHCEMPatThisOrd).GetAndOriIdByOriId("21||13")
ClassMethod GetAndOriIdByOriId(oeoriId)
{
	n (oeoriId)
	q:oeoriId="" ""
	s ord = $p(oeoriId,"||",1)
	s itm = $p(oeoriId,"||",2)
	s ordstr=$g(^OEORD(ord,"I",itm,"DHC"))
	q:ordstr="" ""
	s labEpisodeNoStr = $p(ordstr,"^",22)
	q:labEpisodeNoStr="" ""
	s labEpisodeNo = $p(labEpisodeNoStr,$c(1),1)
	s eOrd = ""
	s eOrd = $o(^OEORDi(0,"EpisPend",labEpisodeNo,eOrd),-1)
	s eItm=""
	s eItm = $o(^OEORDi(0,"EpisPend",labEpisodeNo,eOrd,eItm),-1)
	q eOrd_"||"_eItm
}

/// 根据就诊号返回病人费用信息
/// Input: PAADMRowid:急诊id; UserId:用户id;
/// Output:总费用^已缴费合计^未缴费合计
/// w ##class(web.DHCEMPatThisOrd).getpatFeeInfo(325,1)
ClassMethod getpatFeeInfo(PAADMRowid, UserId)
{
	
	q:PAADMRowid="" ""
	q:UserId="" ""
	//s Rtn=..BILL(PAADMRowid,UserId)
	s TotalAmount=0,PayedAmount=0,NotPayedAmount=0
	s PBRowId=0
	f  s PBRowId=$o(^DHCPB(0,"ADM",PAADMRowid,PBRowId)) q:PBRowId=""  d
	.s RefundFlag=$p($g(^DHCPB(PBRowId)),"^",17)
	.q:RefundFlag'=""
	.s Amount=+$p($g(^DHCPB(PBRowId)),"^",8)
	.s TotalAmount=TotalAmount+Amount
	.s PBPaydeFlag=$p($g(^DHCPB(PBRowId)),"^",16)
	.i PBPaydeFlag="P" s PayedAmount=Amount
	s NotPayedAmount=TotalAmount-PayedAmount
	//S CashPledge=##class(web.UDHCJFBaseCommon).getOPdeposit(PAADMRowid)
	q TotalAmount_"^"_PayedAmount_"^"_NotPayedAmount
}

/// 查询病人的医嘱大类
/// Create:lvpeng 2016-12-01
/// Input: AdmId:就诊id; 
/// Output: OrderTypeDesc:医嘱大类
/// w ##class(web.DHCEMPatThisOrd).QueryOrderType("40")
ClassMethod QueryOrderType(AdmId, InHospID) As %String
{
	n (AdmId,InHospID)
	s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
	s dataStr="全部"
	s count=0	
	q:($g(AdmId)="") ""
	q:'$d(^OEORD(0,"Adm",AdmId)) ""
	s OrdId1=$o(^OEORD(0,"Adm",AdmId,0))
	s PatientID=$P(^PAADM(AdmId),"^",1)	//病人id
	q:OrdId1=""
	s OrdId2=0
	s OrdCreateDate="",OrdCreateTime="",OrdStartDate="",OrdStartTime="",ArcimDesc=""
	f  s OrdId2=$o(^OEORD(OrdId1,"I",OrdId2)) q:OrdId2=""  d
	.s OEItemID=OrdId1_"||"_OrdId2
	.s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1)) 
	.s ArcimId=$p(ordstr1,"^",2)	//医嘱子类ID 10492||1
	.q:ArcimId=""
	.s arctpdr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10) //医嘱大类ID 
	.s OrderTypeDr=$P(^ARC("IC",arctpdr),"^",8)
	.s OrderTypeDesc=$P(^OEC("ORCAT",OrderTypeDr),"^",2) //医嘱大类描述
	.i '$d(QueryOrderType("Type",OrderTypeDesc)) d
	..s ^TMP("DHCEM","web.DHCEMPatThisOrd","QueryOrderType",pid,OrderTypeDesc)=""   //临时global存放数据
	
	s docId =""
	f  s docId = $o(^DHCEMDOCA(docId)) q:docId=""  d
	.q:$p($g(^DHCEMDOCA(docId)),"^",4)'="Y"
	.s SetHospID = $p(^DHCEMDOCA(docId),"^",3)
	.q:(InHospID'="")&&(InHospID'=SetHospID)
	.s oecDr = $p($g(^DHCEMDOCA(docId)),"^",1)
	.q:oecDr=""
	.s oecDesc = $p($g(^OEC("ORCAT",oecDr)),"^",2)	
	.q:$d(^TMP("DHCEM","web.DHCEMPatThisOrd","QueryOrderType",pid,oecDesc))=0
	.s count=count+1
	.i count=1 d
	..;s dataStr=dataStr_oecDesc
	.;e  d
	.s dataStr=dataStr_"^"
	.s dataStr=dataStr_oecDesc
	
	d ..killTmpGlobal(pid) //k掉临时global
	q dataStr
}

/// Descript:获取发药数量
ClassMethod GetOeoriDispQty(OrdItmID)
{
	n (OrdItmID)
	s OrderType=##class(web.DHCEMInComUseMethod).GetArcTypeByOEORDItmDr(OrdItmID) 
	s ActiveQty=""
	i (OrderType="R") d   ;如果没有填数量则自动计算数量
	.s ActiveQty = ##class(web.DHCSTINTERFACE).GetOeoriDispedQtyUom(OrdItmID) 
	i (OrderType'="R") d
	.s ActiveQty = ##class("web.DHCEMPatThisOrd").GetOeoriPqty(OrdItmID)
	q ActiveQty
}

/// Descript
/// w ##class("web.DHCEMPatThisOrd").GetOeoriPqty("950||4")
ClassMethod GetOeoriPqty(OrdItmID)
{
	n (OrdItmID)
	s Ord = +OrdItmID
	s Itm = $p(OrdItmID,"||",2)
	s ArcimId=$p(^OEORD(Ord,"I",Itm,1),"^",2)
	s ArcType = ##class(web.DHCEMInComUseMethod).GetArcTypeByOEORDItmDr(OrdItmID)
	s Pqty=""
	i ArcType="R" d
	.s DisDr=$O(^DHCOEDISQTY(0,"OEORI",OrdItmID,0))   
	.q:DisDr=""
	.q:'$d(^DHCOEDISQTY(DisDr))
	.s Pqty=$p(^DHCOEDISQTY(DisDr),"^",2)
	i ArcType'="R" d
	.s Pqty=0,PbRowid=0
	.f  s PbRowid=$o(^DHCPBi(0,"OEORI",OrdItmID,PbRowid)) q:PbRowid=""  d
	..q:$d(^DHCPB(PbRowid))=10 
    ..q:$d(^DHCPB(PbRowid))=0 
    ..s ConfDr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",+PbRowid,""))
    ..s PboSub=0
    ..f  s PboSub=$o(^DHCPBi(0,"OEORI",OrdItmID,PbRowid,PboSub)) q:PboSub=""  d
    ...q:$d(^DHCPB(PbRowid,"O",PboSub))=10
    ...s Pbo=^DHCPB(PbRowid,"O",PboSub)
    ...s PbbillQty=$p(Pbo,"^",5)
    ...s PbreFundQty=$p(Pbo,"^",6)
    ...s Pqty=Pqty+PbbillQty+PbreFundQty
	.s:+Pqty=0 Pqty=$p(^OEORD(Ord,"I",Itm,1),"^",12)
	
	s BaseUOMDesc=""
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimId)
	i INCIRowid'="" d 
	.; INCI_CTUOM_DR  库存基本单位
	.s BaseUOMRowid=$p($g(^INCI(INCIRowid,1)),"^",10)
	.s BaseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BaseUOMRowid)
	s:BaseUOMDesc'="" Pqty=Pqty_BaseUOMDesc
	q Pqty
}

/// 查询病人的医嘱大类
/// Create:huaxiaoying 2018-10-31
/// Input: AdmId:就诊id; 
/// Output: OrderTypeDesc:医嘱大类
/// w ##class(web.DHCEMPatThisOrd).QueryOrderTypeNew("115","2")
ClassMethod QueryOrderTypeNew(AdmId, InHospID) As %String
{
	n (AdmId,InHospID,%session)
	s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s InHospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmDocOrderCat",InHospID)  ;多院区改造
    
    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s listObj=##class(%ListOfObjects).%New()
	s TrsAll=##class(web.DHCEMCommonUtil).GetTrans("dhcem.onlyadvice.csp","全部")
    d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value",TrsAll).Put("text",TrsAll))
	  
	q:($g(AdmId)="") ""
	q:'$d(^OEORD(0,"Adm",AdmId)) ""
	s OrdId1=$o(^OEORD(0,"Adm",AdmId,0))
	s PatientID=$P(^PAADM(AdmId),"^",1)	//病人id
	q:OrdId1=""
	s OrdId2=0
	s OrdCreateDate="",OrdCreateTime="",OrdStartDate="",OrdStartTime="",ArcimDesc=""
	f  s OrdId2=$o(^OEORD(OrdId1,"I",OrdId2)) q:OrdId2=""  d
	.s OEItemID=OrdId1_"||"_OrdId2
	.s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1)) 
	.s ArcimId=$p(ordstr1,"^",2)	//医嘱子类ID 10492||1
	.q:ArcimId=""
	.s arctpdr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10) //医嘱大类ID 
	.s OrderTypeDr=$P(^ARC("IC",arctpdr),"^",8)
	.s OrderTypeDesc=$P(^OEC("ORCAT",OrderTypeDr),"^",2) //医嘱大类描述
	.s OrderTypeDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.OECOrderCategory","ORCATDesc","",OrderTypeDesc)
	.i '$d(QueryOrderType("Type",OrderTypeDesc)) d
	..s ^TMP("DHCEM","web.DHCEMPatThisOrd","QueryOrderTypeNew",pid,OrderTypeDesc)=""   //临时global存放数据
	
	s docId =""
	f  s docId = $o(^DHCEMDOCA(docId)) q:docId=""  d
	.q:$p($g(^DHCEMDOCA(docId)),"^",4)'="Y"
	.s SetHospID = $p(^DHCEMDOCA(docId),"^",3)
	.q:(InHospID'="")&&(InHospID'=SetHospID)
	.s oecDr = $p($g(^DHCEMDOCA(docId)),"^",1)
	.q:oecDr=""
	.s oecDesc = $p($g(^OEC("ORCAT",oecDr)),"^",2)	
	.s oecDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.OECOrderCategory","ORCATDesc","",oecDesc)
	.q:$d(^TMP("DHCEM","web.DHCEMPatThisOrd","QueryOrderTypeNew",pid,oecDesc))=0
	.d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value",oecDesc).Put("text",oecDesc)) 

	d ..killTmpGlobal(pid) //k掉临时global
	w jsonObj.ListToJson(listObj)	
	q ""
}

/// 转换数字格式日期
/// w ##class(web.DHCEmPatThisOrd).TransDate()
ClassMethod TransDate(Date) As %String
{
	q:Date="" ""
	I (Date'="") {
		I Date["/" Q $zdh(Date,4)
		I Date["-" Q $zdh(Date,3)
		Q Date
	}
}

/// 转换数字格式时间
ClassMethod TransTime(Time) As %String
{
	I (Time'="") {
		I $l(Time,":")=2 Q $zth(Time,2)
		I $l(Time,":")=3 Q $zth(Time)
		Q Time
	}
	else {
		Q $p($h,",",2)
	}
}

/// 就诊日期值
/// w ##class(web.DHCEmPatThisOrd).GetAbsTime("51")
ClassMethod GetAbsTime(PdmRowId) As %String
{
	Q:+PdmRowId="" ""
	s PdmDate=$p(^PAADM(PdmRowId),"^",6)
	s PdmDate=$zd(PdmDate,3)
	q PdmDate
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	K ^TMP("DHCEM","web.DHCEMPatThisOrd","QueryOrderType",pid)
}

/// Descript:病理结果查询
/// 根据PAADMDR--登记号，通过登记号倒叙检索,接收科室从system_set中循环取出
/// w ##class(web.DHCEMPatThisOrd).QueryStudyByPaadmDR(0,15,180,"","")
ClassMethod QueryStudyByPaadmDR(offset = 0, limit = 15, EpisodeID As %String, StDate As %String, EndDate As %String) As %String
{
	
	n (%session,offset,limit,EpisodeID,StDate,EndDate)
	s page=offset+1
	s rows=limit
	s End = page*rows
	s Start=(page-1)*rows+1
	s count=0
	Q:EpisodeID="" "{""rows"":[],""total"":"_count_"}"
	w "{""rows"":["
	s title="TRegNo^Tpathid^TItemName^TItemDate^TItemStatus^TOEOrderDr^TLocName^TreplocDr^TRptCls^TRptClsDesc^TOpenRpt^TOpenAllRpt^TIsOpenFrostRpt^TIfRead^TReadFlag^TChangeStatus^TRptRowid^IsdelayReport^TReadFlag2"
	s paadmdr=$g(EpisodeID)
	i (paadmdr="") s paadmdr=%request.Get("EpisodeID")
	s StDate=$p(StDate,$c(0))
	s EndDate=$p(EndDate,$c(0))
	s StDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate) //hxy 2017-03-01 当前并没使用
    s EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate) //hxy 2017-03-01 当前并没使用
	Set docCode= %session.Get("LOGON.USERCODE")
	;s docCode=337	
	s ^paadmStudy=EpisodeID_"^"_StDate_"^"_EndDate_"^"_docCode
	
	s sysid="" f  s sysid=$o(^User.DHCPISSYSTEMSETD(sysid))  q:sysid=""  d
	.i '$d(^User.DHCPISSYSTEMSETD(sysid)) q
	.d ##class(web.DHCPisApplicationSheet).SetPISNameSpace()
	.s sysInfo=##class(User.DHCPISSYSTEMSET).%OpenId(sysid)
	.s Locdr=sysInfo.SYSDEPTCODE
	.d ##class(Src.PIS3Common).SetWebSourceNameSpace()  
	.q:Locdr="" 
	.s papatmasmdr=$p(^PAADM(paadmdr),"^",1)      
    .s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)  
    .s ItemStatus="",delay="",RptRowid="",report=""
    .s tmid="" f  s tmid=$o(^DHCPISTestMasteri("IPNO",Locdr,RegNo,tmid),-1)  q:tmid=""  d
    ..i '$d(^DHCPISTestMaster(tmid))   
    ..s tmInfo=^DHCPISTestMaster(tmid)
    ..s oeorditemdr=$p(tmInfo,"^",32)
  	..q:oeorditemdr=""
    ..s OrderRowid=$p(oeorditemdr,"||",1),itemsub=$p(oeorditemdr,"||",2)
    ..s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2) 
	..s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	..s rsDr=$p(tmInfo,"^",41)
	..q:rsDr=""
	..i rsDr'=""  d
	...s rsId="" s rsId=$o(^DHCPISResultStatusi("CODE",rsDr,rsId)) q:rsId=""
	...i '$d(^DHCPISResultStatus(rsId))
	...s ItemStatus=$p(^DHCPISResultStatus(rsId),"^",2)
	...i ItemStatus["迟发" s delay="迟发原因"
	..s pathid=$p(tmInfo,"^",4)
	..s LocName=$p(tmInfo,"^",28)
	..s strDate=$p(tmInfo,"^",26)
	..i strDate'="" s strDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(strDate) //$zd(strDate,3) hxy 2017-03-01
	..i ##class(web.DHCPisApplicationSheet).ReportViewLog(oeorditemdr)=0 s ReadFlag2="已阅读"
	..else  s ReadFlag2=""
	..i pathid="" d
	...s RptClsDesc="报告未发布"
	...s pathid="病理科尚未登记"
	...s ReadFlag=""
	...s Data=RegNo_"^"_pathid_"^"_strOrderName_"^"_strDate_"^"_ItemStatus_"^"_oeorditemdr_"^"_LocName_"^"_""_"^"_$g(RptCls)_"^"_$g(RptClsDesc)_"^"_$g(report)_"^"_"AllReport"_"^"_$g(IsOpenFrostRpt)_""_"^"_$g(ChangeStatus)_"^"_$g(RptRowid)_"^"_$g(delay)_"^"_$g(ReadFlag2)
	...s count=count+1

	...q:count<Start
	...q:count>End
	...w $case(count,Start:"",:",")
	...W ##class(web.DHCAPPJsonCommon).getJsonData(title,Data)
	
	..else  i $d(^DHCPISReporti("PATHID",Locdr,tmid))   d
	...s RptRowid="" f  s RptRowid=$o(^DHCPISReporti("PATHID",Locdr,tmid,RptRowid)) q:RptRowid=""  d
	....s report=""
	....s RptCls=$p(^DHCPISReport(RptRowid),"^",2)
	....i RptCls=0 s RptClsDesc="病理冰冻切片报告"
	....i RptCls=1 s RptClsDesc="病理标本检查报告"
	....i RptCls=2 s RptClsDesc="病理会诊报告"
	....i RptCls=3 s RptClsDesc="病理检查补充报告"
	....i RptCls=4 s RptClsDesc="尸体检查报告"
	....i RptCls=5 s RptClsDesc="细胞学检查报告"
	....i RptCls=6 s RptClsDesc="液基细胞学检查报告"
	....i RptCls=8 s RptClsDesc="HPV检查报告"
	....i RptCls=9 s RptClsDesc="TSPOT检查报告"	
	....s IsOpenFrostRpt=##class(web.DHCPisApplicationSheet).IsOpenFrostRpt(pathid,Locdr,RptCls)
	....s examno=""
	....s examno=pathid_"|"_RptRowid
	....s yninfo=##class(RISService.ReadReportInfo).GetRPTCMStatus(oeorditemdr, examno, docCode)
	....s ReadFlag=$p(yninfo,"^",1)
	....s ChangeStatus=$p(yninfo,"^",2)
	....i ReadFlag="Y" s ReadFlag="已阅读"
	....e  s ReadFlag=""
	....i ChangeStatus="Y"  s ChangeStatus="已修改"
	....e  s ChangeStatus=""	
	....s temp=""
	....s imageRowid=0 f  s imageRowid=$o(^DHCPISImageIndexi("PATHID",Locdr,tmid,imageRowid)) q:imageRowid=""  d
	.....s temp=$p(^DHCPISImageIndex(imageRowid),"^",6)
	.....s rptid=$p(^DHCPISImageIndex(imageRowid),"^",12)
	.....q:RptRowid'=rptid		
	.....s handout=$p(^DHCPISReport(RptRowid),"^",11)
	.....i ((temp [ "PDF")&(handout'="")) d
	......s report="Report"
	.....i ((temp [ "PDF")&(handout="")) d
	......s RptClsDesc="报告未发布",ReadFlag="",report=""
	.....i (temp'[ "PDF") && (temp'="")  d
	......s RptClsDesc="报告未发布",ReadFlag="",report=""
	.....s Data=RegNo_"^"_pathid_"^"_strOrderName_"^"_strDate_"^"_ItemStatus_"^"_oeorditemdr_"^"_LocName_"^"_""_"^"_$g(RptCls)_"^"_$g(RptClsDesc)_"^"_$g(report)_"^"_"AllReport"_"^"_$g(IsOpenFrostRpt)_""_"^"_$g(ChangeStatus)_"^"_$g(RptRowid)_"^"_$g(delay)_"^"_$g(ReadFlag2)
	.....s count=count+1
	.....q:count<Start
	.....q:count>End
	.....w $case(count,Start:"",:",")
	.....W ##class(web.DHCAPPJsonCommon).getJsonData(title,Data)
	
	....i (imageRowid="") &&(temp="") d
	.....s RptClsDesc="报告未发布",ReadFlag="",report=""
	.....s Data=RegNo_"^"_pathid_"^"_strOrderName_"^"_strDate_"^"_ItemStatus_"^"_oeorditemdr_"^"_LocName_"^"_""_"^"_$g(RptCls)_"^"_$g(RptClsDesc)_"^"_$g(report)_"^"_"AllReport"_"^"_$g(IsOpenFrostRpt)_""_"^"_$g(ChangeStatus)_"^"_$g(RptRowid)_"^"_$g(delay)_"^"_$g(ReadFlag2)
	.....s count=count+1
	.....q:count<Start
	.....q:count>End
	.....w $case(count,Start:"",:",")
	.....W ##class(web.DHCAPPJsonCommon).getJsonData(title,Data)
	
	..e  d
	...s RptClsDesc="报告未发布",ReadFlag="",report=""
	...s Data=RegNo_"^"_pathid_"^"_strOrderName_"^"_strDate_"^"_ItemStatus_"^"_oeorditemdr_"^"_LocName_"^"_""_"^"_$g(RptCls)_"^"_$g(RptClsDesc)_"^"_$g(report)_"^"_"AllReport"_"^"_$g(IsOpenFrostRpt)_""_"^"_$g(ChangeStatus)_"^"_$g(RptRowid)_"^"_$g(delay)_"^"_$g(ReadFlag2)
	...s count=count+1
	...q:count<Start
	...q:count>End
	...w $case(count,Start:"",:",")
	...W ##class(web.DHCAPPJsonCommon).getJsonData(title,Data)
	W "],""total"":"_count_"}"
	q ""
}

/// 获取table第一列
/// w ##class(web.DHCEMPatThisOrd).GetFirstColumn("DHCEMONLYADVICECSP","demo-editable")
ClassMethod GetFirstColumn(cspName, tableId, Group = "", User = "") As %String
{
	
	n (cspName,tableId,Group,User)
	s pri="U^G^D",colunm=""
	f i=1:1:$l(pri,"^") d
	.s type=$p(pri,"^",i)
	.SET pointer=$SELECT(type="G":Group,type="U":User,type="D":"DHC")
	.q:colunm'=""
	.s sgs=""
	.f  s sgs=$o(^DHCEMSGS(0,"Grid",$$ALPHAUP^SSUTIL4(cspName),tableId,type,pointer,sgs)) q:sgs=""  d
	..q:colunm'=""
	..s colunm=$p(^DHCEMSGS(sgs),"^",5)
	q colunm
}

/// qqa
/// 获取该医嘱下发药数量
/// w ##class(web.DHCEMPatThisOrd).GetDispensingNum("5431||5")
ClassMethod GetDispensingNum(OEItemID)
{
	n (OEItemID)
	q:OEItemID="" 0
	s ConfirmQtyInPhdi=0
	s phdDr=""
	f  s phdDr = $o(^DHCPHDI(0,"OEORI",OEItemID,phdDr)) q:phdDr=""  d
	.q:$p(^DHCPHDISP(phdDr),"^",4)'=1   //未发
	.s phdSub=""
	.f  s phdSub = $o(^DHCPHDI(0,"OEORI",OEItemID,phdDr,phdSub)) q:phdSub=""  d
	..s phdyQty=$p(^DHCPHDI(phdDr,"PHDI",phdSub),"^",4)
	..s ConfirmQtyInPhdi = ConfirmQtyInPhdi+phdyQty        //发药字表发药数量
	q ConfirmQtyInPhdi
}

/// qqa
/// 获取该医嘱下发药数量
/// w ##class(web.DHCEMPatThisOrd).GetSeqTyByOEORI("5431||8")
ClassMethod GetSeqTyByOEORI(OEItemID)
{
	n (OEItemID)
	q:OEItemID="" 0
	s uomInfo = ..GetUomDescAndFun(OEItemID)
	s uomNum = $p(uomInfo,"^",1)
	s dis=0,AllConfirmQty=0,DspConfirmQty=0,ConfirmQty=0
	f  s dis=$O(^DHCOEDISQTY(0,"OEORI",OEItemID,dis)) Q:dis=""  d     //遍历打包表
	.s TotalQty=$p(^DHCOEDISQTY(dis),"^",2)
	.s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
	.//发药或退药数量
	.s dconfirmqty=$p(^DHCOEDISQTY(dis),"^",11)
	.i dstatus="R" d                                    //退药数量
	..s DspConfirmQty=DspConfirmQty+dconfirmqty
	.i dstatus="C" d
	..s AllConfirmQty=AllConfirmQty+dconfirmqty
	s ConfirmQty=AllConfirmQty-DspConfirmQty
	q:ConfirmQty=0 0    //发药-退药=0
	
	q ConfirmQty/uomNum
}

/// qqa
/// 获取该医嘱下库存数量转计费数量
/// return:转换系数^库存单位^计费单位
/// w ##class(web.DHCEMPatThisOrd).GetUomDescAndFun("5431||8")
ClassMethod GetUomDescAndFun(OEItemID)
{
	n (OEItemID)
	q:OEItemID="" 0
	s qty=0
	s ord = $p(OEItemID,"||",1)
	s itm = $p(OEItemID,"||",2)
	s arcimId = $p(^OEORD(ord,"I",itm,1),"^",2)
	s itmUomDr=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),8),"^",14)   //计费单位
	s iNCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+arcimId)   
	s baseUOMRowid=""
	i iNCIRowid'="" d
	.s baseUOMRowid=$p($g(^INCI(iNCIRowid,1)),"^",10)      //库存基本单位
	
	s itmUomDesc = ##class(web.DHCDocOrderCommon).GetUOMDesc(itmUomDr)      //单位描述
	s baseUOMDesc = ##class(web.DHCDocOrderCommon).GetUOMDesc(baseUOMRowid)
	
	s uomNum=1						//获取转换系数
	i (+itmUomDr'=0)&(+baseUOMRowid'=0) d
	.s CTCFRowId =$o(^CT("CTCF",0,"UOM",itmUomDr,baseUOMRowid,""),-1)
	.s uomNum = $p(^CT("CTCF",CTCFRowId),"^",3)
	
	q uomNum_"^"_itmUomDesc_"^"_baseUOMDesc
}

/// w ##class(web.DHCEMPatThisOrd).GetWeekDate("648||1")
ClassMethod GetWeekDate(OrdItmId)
{
	n (OrdItmId)
	s OrderFreq=""
	s Ord = +OrdItmId
	s Itm = $p(OrdItmId,"||",2)
	s OrderFreqWeek=$p($g(^OEORD(Ord,"I",Itm,"DHC")),"^",55)
	s OrderFreq=$TR(OrderFreqWeek,"|","")	
	q OrderFreq
}

}
