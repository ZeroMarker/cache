Class web.DHCDocQryOEOrder Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod GetOrdByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdByAdmExecute ]
{
	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
}

/// Creator:      郭荣勇
/// CreatDate:    2009.02.20
/// Description:  查找本次就诊的所有医嘱
/// Table:        OEC_OrderCategory
/// Input:        EpisodeID:就诊指针, SearchStartDate:开始日期,SearchEndDate:截止日期,OrdComStatus("":全部,'Stop':已撤销,'UnPay':未收费,'Payed':已收费,'Dispensing':已发药,'UnDispensing':未发药)
/// CategoryID:	  大类指针, SubsortID:子类指针
/// Return:       
/// Others:   此方法门诊本次医嘱、预览&打印、毒麻出院带药打印在用 
ClassMethod GetOrdByAdmExecute(ByRef qHandle As %Binary, EpisodeID As %String = "", OrderCTPro As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OutOrd As %String = "", DrgFormPoison As %String = "", Nexus As %String = "", CMMedFlag As %String = "", OrdComStatus As %String = "") As %Status
{
	s ^RP("GetOrdByAdm")=EpisodeID_","_OrderCTPro_","_SearchStartDate_","_SearchEndDate_","_CategoryID_","_SubsortID_","_LongOrd_","_ShortOrd_","_OutOrd_","_DrgFormPoison_","_Nexus_","_CMMedFlag
	///d ##class(%ResultSet).RunQuery("web.DHCDocQryOEOrder","GetOrdByAdm",86,4634,"2018-12-07","2018-12-07","","","","","on","J1^DM^DX^MZ","Y","Y")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (SearchStartDate'="")&&((SearchStartDate["\")||(SearchStartDate["-")||(SearchStartDate["/")){
		s SearchStartDate=..%ZDH(SearchStartDate)
	}
	if (SearchEndDate'="")&&((SearchEndDate["\")||(SearchEndDate["-")||(SearchEndDate["/")){
		s SearchEndDate=..%ZDH(SearchEndDate)
	}
	/*if (SearchStartDate'="")&&(SearchEndDate'="")&&((SearchEndDate-SearchStartDate)>365){
		 Set qHandle=$lb(0,repid,0)
		k ^CacheTempFHQ(repid)
		k ^CacheTemp("DHCFindOrdItem",$j,"master")
		 quit $$$OK
	}*/
	Set langid=..%LanguageID()
	s SeqNo=1
	s SubSeqCount=1
	if (Nexus=""){
		s RetNum=..GetOrdItem(repid,EpisodeID, OrderCTPro,SearchStartDate,SearchEndDate,CategoryID,SubsortID,"",LongOrd,ShortOrd,OutOrd,DrgFormPoison,CMMedFlag,OrdComStatus)
		d loopData
	}else{
		if (SubsortID'=""){
			s RetNum=..GetOrdItem(repid,EpisodeID, OrderCTPro,SearchStartDate,SearchEndDate,CategoryID,SubsortID,"","","","","",CMMedFlag,OrdComStatus)
			d loopData
		}
		if (OutOrd'=""){
			s RetNum=..GetOrdItem(repid,EpisodeID, OrderCTPro,SearchStartDate,SearchEndDate,CategoryID,"","","","",OutOrd,"",CMMedFlag,OrdComStatus)
			d loopData
		}
		if (DrgFormPoison'=""){
			s RetNum=..GetOrdItem(repid,EpisodeID, OrderCTPro,SearchStartDate,SearchEndDate,CategoryID,"","","","","",DrgFormPoison,CMMedFlag,OrdComStatus)
			d loopData
		}
		
	}
	s SeqNo=0
	s ordcatNo1=0
	for  s ordcatNo1=$O(^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo1)) q:ordcatNo1=""  d
	.s mas=0 
	.for  s mas=$O(^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo1,mas)) q:mas=""  d
	.. s s1=^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo1,mas)
	.. s PSeq=$p(mas,"||",2)
	.. i s1'="" d 
	...s SeqNo=SeqNo+1
	...s $List(s1,56)=SeqNo
	...s Data=s1
	...d OutputRow
	.. s SubSeqCount=0
	..s sub=0  for  s sub=$O(^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo1,mas,"sub",sub)) q:sub=""  d
	... s s2=^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo1,mas,"sub",sub)
	... i s1="" d
	....s SeqNo= SeqNo+1
	....s $List(s2,56)=SeqNo
	.... s Data=s2
	.... d OutputRow
	... e  d
	.... s PSeq=$p(sub,"||",2)
	.... s SubSeqCount=SubSeqCount+1
	.... s SubSeqNo=SeqNo_"."_SubSeqCount
	.... s $List(s2,56)=SubSeqNo
	.... s Data=s2
	.... d OutputRow
	
	Set qHandle=$lb(0,repid,0)
	k ^CacheTempFHQ(repid)
	k ^CacheTemp("DHCFindOrdItem",$j,"master")
 quit $$$OK
OutputRow
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
loopData
	s i=0
	f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
	.s Data=^CacheTempFHQ(repid,i)
	.s OEItemID=$list(Data,14)
	.s OEItemIDChildsub=+$P($list(Data,14),"||",2)
	.s seqno=$P($list(Data,56),".",1)
	.s ordcatNo=$list(Data,55)
	.i $d(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),11)) s LinkOrderItemChildsub=$P($p(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),11),"^",39),"||",2)
	.if $G(LinkOrderItemChildsub)="" d
	..s ^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo,OEItemIDChildsub)=Data
	.e  d
	..if '$D(^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo,+LinkOrderItemChildsub)) d
	...s ^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo,+LinkOrderItemChildsub)=""
	..s ^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo,+LinkOrderItemChildsub,"sub",+OEItemIDChildsub)=Data
	q
}

ClassMethod GetOrdByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdByAdmExecute ]
{
 s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
 Quit $$$OK
}

/// w ##class(web.DHCDocQryOEOrder).GetOrdItem(1409,"",64989,"","","","","","","","","","")
ClassMethod GetOrdItem(repid As %Integer = 0, AdmId As %String = "", CTProID As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", ArcId As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OutOrd As %String = "", DrgFormPoison As %String = "", CMMedFlag As %String = "Y", OrdComStatus As %String = "") As %Integer
{
	s ^RP("benCiItm")=repid_","_AdmId_"^"_CTProID_"^"_SearchStartDate_"^"_SearchEndDate_","_CategoryID_","_SubsortID_","_ArcId_","_LongOrd_","_ShortOrd_","_OutOrd_","_DrgFormPoison_","_CMMedFlag_","_OrdComStatus
	s del="^",AdmType="",RetNum=0
	Set langid=..%LanguageID()
	k ^CacheTemp("DHCDocQryOEOrder",$j)
	q:($g(AdmId)="") RetNum
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(AdmId)
    s PatientId=$P(^PAADM(AdmId),"^",1)
    s AdmLoc=$P(^PAADM(AdmId),"^",4)
	q:'$d(^OEORD(0,"Adm",AdmId)) RetNum
	s CNMedItemCatStr=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr()
	s OrdId1=$o(^OEORD(0,"Adm",AdmId,0))
	s PatientID=$P(^PAADM(AdmId),"^",1)
	s PAADMRegConDisDR=$P($G(^PAADM(AdmId,"DHC")),"^",25)
	q:OrdId1=""
	s hospitalDR=$P(^CTLOC(AdmLoc),"^",22)
	set HOSPCode=$p($g(^CT("HOSP",hospitalDR)),"^",1)
	s expStr = "^^^"_hospitalDR
	//物资发放模式的配置
	s GrantConfig = ##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTMATDISPM", "MatDisp", expStr)
	s StayStatus=0
	s PatCurStat=##class(web.DHCADMVisitStat).GetStayStatus(AdmId)
	i " 1 2 "[(" "_PatCurStat_" ") s StayStatus=1
	s StayPayMode=##class(web.DHCBillInterface).IGetStayPayMode(hospitalDR)
	s OrdId2=0
	s OrdCreateDate="",OrdCreateTime="",OrdStartDate="",OrdStartTime="",ArcimDesc=""
	f  {
		s OrdId2=$o(^OEORD(OrdId1,"I",OrdId2))
		q:OrdId2=""
		; 门急诊费用转住院后不允许停医嘱
		;continue:$d(^DHCOPIPADMCON("OPADMORDER","OPAdm",AdmId,OrdId1_"||"_OrdId2)) 
		s OEItemID=OrdId1_"||"_OrdId2
		s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1))
		s ordstr2=$g(^OEORD(OrdId1,"I",OrdId2,2))
		s ordstr3=$g(^OEORD(OrdId1,"I",OrdId2,3))
		s ordstr5=$g(^OEORD(OrdId1,"I",OrdId2,5))
		s ordstr9=$g(^OEORD(OrdId1,"I",OrdId2,9))
		s ordstr11=$g(^OEORD(OrdId1,"I",OrdId2,11))
		s ArcimId=$p(ordstr1,del,2)
		continue:((ArcId'="")&(ArcimId'=ArcId))
		s ArcStr=##class(web.DHCFBArcimGet).GetArcimById(ArcimId)
		continue:ArcStr=""
		s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ArcimId)
		s PoisonCode=""
		i PoisonRowid'="" d
		.s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
		s PriorityDR=$p(ordstr1,del,8)
		s:$g(PriorityDR)="" Priority="",PriorityCode=""
		s:$g(PriorityDR)'="" Priority=$p(^OECPR(PriorityDR),del,2),PriorityCode=$p(^OECPR(PriorityDR),del,1)
		s Priority=##class(User.OECPriority).GetTranByDesc("OECPRDesc",Priority,langid)
		s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
		continue:(LongOrd="on")&&(ShortOrd'="on")&&(OutOrd'="on")&&(PriorityCode'="S")
		continue:(ShortOrd="on")&&(LongOrd'="on")&&(OutOrd'="on")&&(PriorityCode'="NORM")
		continue:(OutOrd="on")&&(ShortOrd'="on")&&(LongOrd'="on")&&(PriorityCode'="OUT")
		//continue:(DrgFormPoison'="")&&((DrgFormPoison'[PoisonCode)||(PoisonCode=""))&&(PriorityCode'="OUT")
		continue:(DrgFormPoison'="")&&((("^"_DrgFormPoison_"^")'[("^"_PoisonCode_"^")))
		s EpissubtypeId=$P($g(^PAADM(AdmId,1)),"^",6)
		s AdmReasonId=$P($g(^PAADM(AdmId,1)),"^",7)
		s arctpdr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)
		s drgformId=$P(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1),"^",12)
		s arctype=$p(^ARC("IC",arctpdr),"^",7) ;ARC_ItemCat 表中的ARCIC_Ordertype ,="R"是药物
		continue:((OutOrd="on")||(DrgFormPoison'=""))&&(arctype'="R")
		;continue:arctpdr=2  ;通用处置治疗屏蔽
		//continue:(CMMedFlag="N")&&(("^"_CNMedItemCatStr_"^")[("^"_arctpdr_"^"))
		s ARCICOrdCatDR=$p(^ARC("IC",arctpdr),"^",8)  ;医嘱大类,指向表OEC_OrderCategory
		s ORCATDesc=$p(^OEC("ORCAT",ARCICOrdCatDR),"^",2)
		s ORCATDesc=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc",ORCATDesc,langid)

		s ordcatno=1
		s DoseQty=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(OEItemID) //$p(ordstr2,del,1)
		s DoseUnitID=$p(ordstr2,del,3)
		s OrdcatDR=""
		s SubsortDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),del,10)
		s:SubsortDR'="" OrdcatDR=$p(^ARC("IC",SubsortDR),del,8)
		continue:(SubsortID'="")&&(("^"_SubsortID_"^")'[("^"_SubsortDR_"^"))
		continue:(CategoryID'="")&&(CategoryID'=OrdcatDR)
		s OrdStartDate=$p($g(^OEORD(OrdId1,"I",OrdId2,1)),"^",9)
		continue:(SearchStartDate'="")&&(SearchEndDate'="")&&(ISLongOrderPrior=0)&&((OrdStartDate<SearchStartDate)||(OrdStartDate>SearchEndDate))
		continue:(SearchStartDate'="")&&(ISLongOrderPrior=0)&&(OrdStartDate<SearchStartDate)
		continue:(SearchEndDate'="")&&(ISLongOrderPrior=0)&&(OrdStartDate>SearchEndDate)
		s OrderSeqNo=$p(ordstr3,del,4)
		s DoseUnit=""
		s:DoseUnitID'="" DoseUnit=$p(^CT("UOM",DoseUnitID),del,2)
		s DoseUnit=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",DoseUnit,langid)
		s BaseUOMDesc=""
		s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimId)
		i INCIRowid'="" {
			; INCI_CTUOM_DR  库存基本单位
			s BaseUOMRowid=$p($g(^INCI(INCIRowid,1)),"^",10)
			s BaseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BaseUOMRowid)
		}
		s ArcimCode=$p(ArcStr,del,2),ArcimDesc=$p(ArcStr,del,3)
		//s ArcimDesc=##class(web.DHCDocUtil).Replace(ArcimDesc,"'", "&#39;")
		
		s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
		s ArcimDesc=##class(web.DHCDocUtil).EvalHTML(ArcimDesc)
		s GenericName=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(ArcimId)
		s OrdCreateDate=$p(ordstr3,del,7)
		s OrdCreateTime=$p(ordstr1,del,17)
		s OrdStartDate=$p(ordstr1,del,9)
		s OrdStartTime=$p(ordstr1,del,10)
		s OrderPrescNo=$p(ordstr1,del,14)
		s DoseqtySum=$p(ordstr1,del,12)
		s OrderPackQty=$p(ordstr9,del,4)
		
		s PackUOMDesc=""
		//s BillingUOMDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),8),"^",14)
		s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OEItemID)
		if BillingUOMDR'="" d
		.s PackUOMDesc=$p(^CT("UOM",BillingUOMDR),"^",2)
		.s PackUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",PackUOMDesc,langid)
		s OrderRecDepRowid=$P($G(^OEORD(OrdId1,"I",OrdId2,3)),"^",6) ;OEORI_RecDep_DR
		;协议单位
		s ProtocolPackUOMDR=$p($g(^OEORD(OrdId1,"I",OrdId2,"DHC")),"^",13)
		i ProtocolPackUOMDR'="" {
			s BillingUOMDR=ProtocolPackUOMDR
			s PackUOMDesc=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
			s PackUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",PackUOMDesc,langid)
		}
		s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(ArcimId)
		if (CheckCHNFlag="Y") {
			S Phcdf=$P($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",12)
			if (Phcdf'=""){
				s BillingUOMDR=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
				s PackUOMDesc=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
				s PackUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",PackUOMDesc,langid)
				s BaseUOMDesc=PackUOMDesc
			}
		}
		;如果整包装数量是空也不能把单次计量直接赋值
		s OEORIPrice=$p(ordstr3,del,25)
		s ArcPrice=##class(web.DHCDocOrderCommon).GetOEORIPrice(OrdId1_"||"_OrdId2)
		s ArcPrice=$fn($p(ArcPrice,"^",1),"",4)
		/*s OrderSum=$p(ArcPrice,"^",1)*OrderPackQty
		i (ArcPrice[".")&&($p(ArcPrice,".",1)="") s ArcPrice="0"_ArcPrice*/
		s PrescNo=$p(ordstr1,del,14)
		s seqno=$p(ordstr3,del,4)              ;医嘱序号    
		
		s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(OEItemID,"-",langid)
		s PHFreqDR=$List(OrdFreqInfo,1)
		s PHFreqDesc=$List(OrdFreqInfo,2)
		s PHFreq=$List(OrdFreqInfo,5)
		
		s PHFreq=PHFreqDesc
		s Instr=$p(ordstr2,del,7)
		s:$g(Instr)'="" Instr=$p($g(^PHCIN(Instr)),del,2)
		s Instr=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",Instr,langid)
		s:$g(Instr)="" Instr=""
		s OrdStatusDR=$p(ordstr1,del,13)
		s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),del,2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),del,1)
		s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
		continue:OrdStatusCode="I" ;未审核的不需要展示 药品没有处方
		s OrdStatus=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc",OrdStatus,langid)
		//计价单位与基本单位的换算
		s convFac=##class(appcom.OEDispensing).convFac(ArcimId,BillingUOMDR)
		s OrdPackQtyInfo=..GetOrdPackQtyInfo(OrdId1_"||"_OrdId2)
		s PackUOMDesc=$p(OrdPackQtyInfo,"^",2)
		s PackUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",PackUOMDesc,langid)
		s OrderPackQty=$p(OrdPackQtyInfo,"^",1)
		s PackUOMDr=$p(OrdPackQtyInfo,"^",3)
		s QtyPackUOM=""
		s:(OrderPackQty'="") QtyPackUOM=OrderPackQty_PackUOMDesc //$p(OrdPackQtyInfo,"^",3)
		s DspConfirmQty=""
		s ActiveQty=$p(OrdPackQtyInfo,"^",7)
		s Pqty= ActiveQty
		if (ISLongOrderPrior=1){
			s OrderSum=""
		}elseif (+ActiveQty=0){
			s BaseQty=$p(OrdPackQtyInfo,"^",4) //换算成基本单位后的数量
			s OrderSum=(BaseQty/convFac)*ArcPrice
			s OrderSum=$j(OrderSum,"",2)
		}else{
			s OrderSum=(ActiveQty/convFac)*ArcPrice
			//s QtyPackUOM=(ActiveQty/convFac)_PackUOMDesc
			s OrderSum=$j(OrderSum,"",2)
		}
		
		s ActiveQtyUOM=$p(OrdPackQtyInfo,"^",8)
		if (ActiveQtyUOM=""){
			if +$E(PackUOMDesc,1)=$E(PackUOMDesc,1) s PackUOMDesc="("_PackUOMDesc_")"
			s ActiveQtyStr=ActiveQty_PackUOMDesc
		}else{
			s ActiveQtyUOMDesc=$p(OrdPackQtyInfo,"^",8)
			s ActiveQtyUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",ActiveQtyUOMDesc)
			if +$E(ActiveQtyUOMDesc,1)=$E(ActiveQtyUOMDesc,1) s ActiveQtyUOMDesc="("_ActiveQtyUOMDesc_")"
			s ActiveQtyStr=ActiveQty_ActiveQtyUOMDesc
		}
		s ActiveQtySum=OrderSum
		s dstatus=$p(OrdPackQtyInfo,"^",9)
		s RePay=##class(web.DHCBillInterface).IOrdItmInvStatusByOeoriDR(OrdId1_"||"_OrdId2)
		s RePay=$p(RePay,"^")
		i " 0 1 2 "[(" "_RePay_" ") s RePay=$Case(RePay,"0":"","1":"部分退费","2":"全部退费")
		s isStop=((OrdStatusCode="D")&(RePay'="部分退费")&&(dstatus'="部分退")&&(dstatus'="全发"))||((OrdStatusCode'="V")&(OrdStatusCode'="E")&(OrdStatusCode'="D")) 
		s OrdBilled=$p(ordstr3,"^",5)
		s OrdBilled=##class(web.DHCBillInterface).IGetOrdItmBilled(OrdId1_"||"_OrdId2)
		s OrdBilledCode=$p(OrdBilled,"^",1)
		s OrdBilled=$p(OrdBilled,"^",2)
		s OrdBilled=##class(websys.Translation).Get("opdoc.treatprint.csp",OrdBilled)
		//"":全部,'Stop':已撤销,'UnPay':未收费,'Payed':已收费,'Dispensing':已发药,'UnDispensing':未发药
		if OrdComStatus'="ALL"{
			s FindActiveExecFlag="N"
			if (ISLongOrderPrior=1){
				s OEOREChildsub=0
				for {
					q:(FindActiveExecFlag="Y")
					s OEOREChildsub=$O(^OEORD(OrdId1,"I",OrdId2,"X",OEOREChildsub))
					q:(OEOREChildsub="")
					s ExeData = $p($g(^OEORD(OrdId1,"I",OrdId2,"X",OEOREChildsub)),"^",1)
					continue:(SearchStartDate'="")&&(SearchEndDate'="")&&((ExeData<SearchStartDate)||(ExeData>SearchEndDate))
					s ExecStateDR = $p($g(^OEORD(OrdId1,"I",OrdId2,"X",OEOREChildsub)),"^",16)
					s ExecStateCode=""
					if (ExecStateDR'=""){
						s ExecStateCode = $p(^OEC("STAT",ExecStateDR),"^",1)
					}
					if (ExecStateCode'="D")&&(ExecStateCode'="R"){
						s FindActiveExecFlag="Y"
						q
					}
				}
			}
			if (OrdComStatus="Stop")&&('isStop){
				continue
			}elseif (OrdComStatus'="Stop")&&(isStop)&&(ISLongOrderPrior="0"){
				//(StopOrd'="Y")&&((isStop)||((FindActiveExecFlag="N")&&(ISLongOrderPrior="1"))){
				continue
			}
			if (OrdComStatus="UnPay")&&("TB"'[OrdBilledCode){
				continue
			}
			if (OrdComStatus="Payed")&&(OrdBilledCode'="P"){
				continue
			}
			if (OrdComStatus="Dispensing")&&(+ActiveQty=0){
				continue
			}
			if (OrdComStatus="UnDispensing")&&(dstatus'="未发"){
				continue
			}
			if ((FindActiveExecFlag="N")&&(ISLongOrderPrior="1")){
				continue
			}
		}
		
		s OEItemDR=$p(ordstr11,del,39)
		s DuraDR=$p(ordstr2,del,6)
		s Dura=""
		//s:($g(DuraDR)'="")&&('ISLongOrderPrior) Dura=$p(^PHCDU(DuraDR),del,3)
		s:($g(DuraDR)'="") Dura=$p(^PHCDU(DuraDR),del,3)
		s:($g(Dura)'="") Dura=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",Dura,langid)
		s doctorID=$p(ordstr1,del,11)
		s:$g(doctorID)'="" doctor=$p($g(^CTPCP(doctorID,1)),del,2)
		s:$g(doctorID)="" doctor=""
		Set doctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",doctor,langid)
		s QtyPackUOM=$p(ordstr9,del,4)
		;条码号,标本
		s LabEpisodeNo=$p(ordstr3,del,20) ;
		s OrdLabSpec=##Class(web.DHCOEOrdItem).GetLabSpec(OEItemID)
		;停医嘱日期,停医嘱时间
		s OrdXDate=$p(ordstr3,del,34)
		if OrdXDate'="" s OrdXDate=..%ZD(OrdXDate) //$zd(OrdXDate,3)
		s OrdXTime=$p(ordstr2,del,15)
		if OrdXTime'="" s OrdXTime=..%ZT(OrdXTime,2)
		;皮试,皮试备注,备注,
		s OrdSkinTest=$p(ordstr5,del,2)
		s OrdAction=$p(ordstr11,del,21)
		i OrdAction'="" s OrdAction=$P($G(^OEC("ACT",OrdAction)),"^",2) 
		s OrdAction=##class(User.OECAction).GetTranByDesc("ACTDesc",OrdAction,langid)
		s OrdDepProcNotes=$g(^OEORD(OrdId1,"I",OrdId2,"DEP",1))
		s OrdDepProcNotes=##class(web.DHCDocUtil).Replace(OrdDepProcNotes,"'", "&#39;") //
		s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(arctpdr,hospitalDR,ArcimId)
		i (PHPrescType="3") s OrdDepProcNotes=$p($g(^OEORD(OrdId1,"I",OrdId2,2)),"^",8)
		
		
		s abnorm=$p($g(^OEORD(OrdId1,"I",OrdId2,11)),"^",3)
		s OrdSkinTestResult=""
		//i OrdSkinTest="Y" {
			i abnorm="Y" s OrdSkinTestResult="阳性"
			i abnorm="N" s OrdSkinTestResult="阴性"
		//}
		s OrdSkinTestResult=##class(websys.Translation).Get("opdoc.treatprint.csp",OrdSkinTestResult)
		s ReLocID=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",6)
		If ReLocID'="" d
		.s ReLoc=$P($G(^CTLOC(ReLocID)),"^",2)
		.s ReLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ReLoc,langid)
		.Set ReLoc=##class(web.DHCOPAdmReg).LocDescFormate(ReLoc) //$P($P($G(^CTLOC(ReLocID)),"^",2),"-",2)
		S RetNum=RetNum+1
		s OrdRowid=OrdId1_"||"_OrdId2
		s LabNo=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",20)
		s UserDepart="",UserDepartType=""
		s UserDepartId=$p($g(^OEORD(OrdId1,"I",OrdId2,7)),"^",2)
		If UserDepartId'=""  d
		.s UserDepart=$P($G(^CTLOC(UserDepartId)),"^",2)
		.s UserDepart=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",UserDepart,langid)
		.Set UserDepart=##class(web.DHCOPAdmReg).LocDescFormate(UserDepart) //$P($P($G(^CTLOC(UserDepartId)),"^",2),"-",2)
		.Set UserDepartType=$P($G(^CTLOC(UserDepartId)),"^",13)
		;continue:(UserDepartId="")&((onlydoc="Y")||(onlyNurse="Y")||(onlyloc'=""))
		;continue:(onlydoc="Y")&(UserDepartType="W")
		;continue:(onlyNurse="Y")&(UserDepartType="E")
		;continue:(onlyloc'="")&(onlyloc'=UserDepartId)
		s UserAddID=""
		s DoctorDr=$p($g(^OEORD(OrdId1,"I",OrdId2,1)),"^",11) //$p($g(^OEORD(OrdId1,"I",OrdId2,7)),"^",1)
		If DoctorDr'="" {
			Set UserAdd=$p($g(^CTPCP(DoctorDr,1)),"^",2) //$P($G(^SSU("SSUSR",UserAddID)),"^",2)
			Set UserAdd= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",UserAdd,langid)
			Set UserAddID=$o(^SSU("SSUSR",0,"CTPCP",DoctorDr,""))
		}
		continue:(UserAddID'=CTProID)&&(CTProID'="")&&(DrgFormPoison="")
		s IsCNMedItem=##class(web.DHCDocOrderCommon).IsCNMedItem(ArcimId)
		s XUser=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",29)
		if XUser'="" Set XUser=$P($G(^CTPCP(XUser,1)),"^",2)
		Set XUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",XUser,langid)
		s EndDate=$p($g(^OEORD(OrdId1,"I",OrdId2,9)),"^",9)
		s EndTime=$p($g(^OEORD(OrdId1,"I",OrdId2,9)),"^",10)
		If EndDate'="" Set EndDate=..%ZD(EndDate) //$ZD(EndDate,3)
		If EndTime'="" Set EndTime=..%ZT(EndTime,1)
		s CoverMainInsur=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",3)
		s BillTypeRowid=$p($g(^OEORD(OrdId1,"I",OrdId2,11)),"^",18)
		s BillType=""
		If BillTypeRowid'=""  Set BillType=$P($G(^PAC("ADMREA",BillTypeRowid)),"^",2)
		s BillType=##class(User.PACAdmReason).GetTranByDesc("READesc",BillType,langid)
		s OrderType=""
		if arctpdr'="" s OrderType=$P(^ARC("IC",arctpdr),"^",7)
		i OrderType'="R" d 
		.s DoseqtySum=$p($g(^OEORD(OrdId1,"I",OrdId2,1)),"^",12)
		.//s OrderPackQty=DoseqtySum
		
		if (PriorityCode="OM")||(PriorityCode="OMST")||(PriorityCode="OMCQZT")||(PriorityCode="OMLSZT") s ActiveQtySum=0.00,OrderSum=0.00
		s MaterialBarCode=$p($G(^OEORD(OrdId1,"I",OrdId2,"DHC")),"^",14) ;高值条码
		;--------
		s OrderPrintFlag=""
		//i $g(^DHCDOCOEORDPRINTFLAG(OEItemID))="Y" s OrderPrintFlag="Y"
		//打印标志统一走总览打印的打印标识
		if (ISLongOrderPrior=1)||(SearchStartDate=SearchEndDate){
			s CFDPrintCount=##class(DHCDoc.OPDoc.PrintHistory).GetPrintCount(OEItemID_"||||"_SearchStartDate,"CFD")
			s CFZPrintCount=##class(DHCDoc.OPDoc.PrintHistory).GetPrintCount(OEItemID_"||||"_SearchStartDate,"CFZ")
			if (CFDPrintCount+CFZPrintCount)>0{
				s OrderPrintFlag="Y"
			}
		}else{
			for date1=SearchStartDate:1:SearchEndDate {
				s CFDPrintCount=##class(DHCDoc.OPDoc.PrintHistory).GetPrintCount(OEItemID_"||||"_date1,"CFD")
				s CFZPrintCount=##class(DHCDoc.OPDoc.PrintHistory).GetPrintCount(OEItemID_"||||"_date1,"CFZ")
				if (CFDPrintCount+CFZPrintCount)>0{
					s OrderPrintFlag="Y"
				}
			}
		}
		s OEItemDR1=$p(ordstr11,del,18)
		s AdmReason=""
		i OEItemDR1'="" d
		.s AdmReason=$p($g(^PAC("ADMREA",OEItemDR1)),"^",2)
		.s AdmReason=##class(User.PACAdmReason).GetTranByDesc("READesc",AdmReason,langid)
		
		S RetNum=RetNum+1
		//ie11 josn 不支持\
		//s ArcimDesc=##class(web.DHCDocUtil).EvalJSON(ArcimDesc)
		s OrdDepProcNotes=##class(web.DHCDocUtil).EvalJSON(OrdDepProcNotes)
		s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqItemDescNoOrder(OrdId1_"||"_OrdId2)
		s ArcimDesc=ArcimDesc_ReqPartDesc
		
		s OrdCreateDate=..%ZD(OrdCreateDate)
		s OrdCreateTime=..%ZT(OrdCreateTime,2)
		s OrdStartDate=..%ZD(OrdStartDate)
		s OrdStartTime=..%ZT(OrdStartTime,2)
		s OrderUsableDays=""
		if OrderType="R" s OrderUsableDays=##class(web.DHCDocOrderEntry).CalcDur(OrdId1_"||"_OrdId2) //可用天数
		s OrderNotifyClinician=$p($g(^OEORD(OrdId1,"I",OrdId2,11)),"^",55) //加急
		if (IsCNMedItem=1) {
			s DHCQueLinkOrdDR=OrdId1_"||"_OrdId2
			if (OEItemDR'="") s DHCQueLinkOrdDR=OEItemDR
			s DHCQUE1RowID=$o(^PAQUE1(0,"DHCPAQue","LinkOrderItem",DHCQueLinkOrdDR,""))
			if (DHCQUE1RowID'="") {
				s OrderNotifyClinician=$p(^PAQUE1(DHCQUE1RowID,"DHC"),"^",22)
			}
		}
		s OrdSpeedFlowRate=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",17) //输液流速
		s OrderFlowRateUnit=$p($g(^OEORD(OrdId1,"I",OrdId2,6)),"^",8) //流速单位
		s OrderFlowRateUnitdesc=""
		i OrderFlowRateUnit'="" s OrderFlowRateUnitdesc=$p($g(^OEC("SFR",OrderFlowRateUnit)),"^",2)
		s OrderFlowRateUnitdesc=##class(User.OECSpeedFlowRate).GetTranByDesc("SFRDesc",OrderFlowRateUnitdesc,langid)
		s OrderNeedPIVAFlag=$p($G(^OEORD(OrdId1,"I",OrdId2,"DHC")),"^",16) //需要配液
		s OrderLocalInfusionQty=$p($g(^OEORD(+OrdId1,"I",OrdId2,"DHC")),"^",21) //输液次数
		s ExceedReasonDesc=""
	    s ExceedReasonID=$p($G(^OEORD(+OrdId1,"I",OrdId2,"DHC")),"^",33)
	    if ExceedReasonID'=""  s ExceedReasonDesc=$P($G(^DHCDocExceedReason(ExceedReasonID)),"^",2) //疗程超量原因
		s ExceedReasonDesc=##class(User.DHCDocExceedReason).GetTranByDesc("DHCExceedDesc",ExceedReasonDesc,langid)
	    s OrderStage=$p($G(^OEORD(+OrdId1,"I",OrdId2,"DHC")),"^",8)
	    s OrderStage=$CASE(OrderStage,"SZ":"术中","SQ":"术前","SH":"术后","CZ":"产中","":"")
	    s OrderStage=##class(websys.Translation).Get("opdoc.treatprint.csp",OrderStage)
	    s OrderPilotPro=""
	    s OrderPilotProRowId=+$p($g(^OEORD(+OrdId1,"I",OrdId2,"DHC")),"^",10)
	    s:OrderPilotProRowId=0 OrderPilotProRowId=""
	    if OrderPilotProRowId'="" s OrderPilotPro=$p($G(^DHCDocPP(OrderPilotProRowId)),"^",2) //药理项目
	    
		s OrderOperation=""
		s OrderOperationCode=$p($g(^OEORD(+OrdId1,"I",OrdId2,4)),"^",10)
		if (OrderOperationCode'="") {
	        s curOperId=$P(^OR(AdmId,"ANA",$p(OrderOperationCode,"||",2),"OP",$p(OrderOperationCode,"||",3)),"^",6)       ;ANAOP_Type_DR；手术名称
	        if $D(^ORC("OPER",curOperId)) s OrderOperation=$P(^ORC("OPER",curOperId),"^",2) //手术
		}
		s OrderDIACatRowId=$p($g(^OEORD(+OrdId1,"I",OrdId2,6)),"^",6)
		i OrderDIACatRowId'="" s OrderDIACat=$P($G(^DHCDiagnosCat(OrderDIACatRowId)),"^",1)
	    e  s OrderDIACat=""
		Set OrderDIACat= ##class(User.DHCDiagnosCat).GetTranByDesc("DCDesc",OrderDIACat,langid)
	    i (+OrderPackQty'=0)&&(+OrderPackQty<1) s OrderPackQty="0"_$number(OrderPackQty)
	    
		s SkinTest=""
		s skinflag=##class(web.DHCOutPhCommon).SkinTest(OrdId1_"||"_OrdId2)
		i (skinflag'<0)&(skinflag'="") s SkinTest="(-)"
		i skinflag=-1 s SkinTest="(+)"
		i skinflag=-6 s SkinTest="( )"
		i skinflag=-5 s SkinTest="(原液)"
		s SkinTest=##class(websys.Translation).Get("opdoc.treatprint.csp",SkinTest)
	    s SkinTest=OrdAction_SkinTest
	    s OrderViewFlag=##Class(web.DHCDocInPatPortalCommon).GetOrderViewFlag(ArcimId,OrdId1_"||"_OrdId2)
	    s DMdsstatus=..GetdsStatusDate(OrdId1_"||"_OrdId2,SearchStartDate)
	    s DMdsstatus=##class(websys.Translation).Get("opdoc.treatprint.csp",DMdsstatus)
	    s BindSource=..GetBindSourceDesc(OrdId1_"||"_OrdId2)
	    s BindSource=##class(websys.Translation).Get("opdoc.treatprint.csp",BindSource)
	    set OrdDRGOrder=$p($g(^OEORD(+OrdId1,"I",OrdId2,"DHC")),"^",66)
		set ChronicInfo=##class(insuqc.service.ServicePort).GetChronicNameByCode(OrdDRGOrder, AdmReasonId, HOSPCode)
		set OrderChronicDiagCode=$p(ChronicInfo,"^",2)      //病种描述
		s ARCOSRowId=""
		if (PrescNo'="") {
			s QUE1RowID=$o(^PAQUE1(0,"PrescNo",PrescNo,""))
			if (QUE1RowID'="") s ARCOSRowId=$p($g(^PAQUE1(QUE1RowID,"DHC")),"^",24)
		}
		s ArcimARCOSRowId=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",10)
		s PrescTitle=""
		s:PrescNo'="" PrescTitle=##class(web.DHCOutPhCommon).GetPrescTitle(PrescNo)
		s dstatus=##class(websys.Translation).Get("opdoc.treatprint.csp",dstatus)
		s SignFlag=##class(web.DHCDocInPatPortalCommon).CheckOrdSign(OrdId1_"||"_OrdId2)
		//国家医保编码
		s InsuNationCode=""
		s InsuNationName=""
		s NowDate=..%ZD(+$H)
		s InsuNationCode=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(ArcimId,AdmReasonId,hospitalDR,NowDate,13)
		s InsuNationName=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(ArcimId,AdmReasonId,hospitalDR,NowDate,14)
		s OrdSerialNum=$p($g(^OEORD(+OrdId1,"I",OrdId2,"DHC")),"^",75)
		s OrdLinkSpecLocDiagStr=##class(DHCDoc.Diagnos.SpecLoc).GetOrdLinkSpecLocDiag(OrdId1_"||"_OrdId2,hospitalDR,langid)
		s OrdSpecDiagnosForm=$P(OrdLinkSpecLocDiagStr,"^",3)
		s OrdSpecLocDiagCatCode=$P(OrdLinkSpecLocDiagStr,"^",2)
		;s CacheTempFHQ(" "_PrescNo,RetNum)=$LB(OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,Priority,PHFreq,Instr,doctor,OrdStatus,Dura,OEItemID,PatientID,QtyPackUOM,PackUOMDesc,PrescNo,dstatus,LabEpisodeNo,OrdLabSpec,OrdXDate,OrdXTime,OrdSkinTest,OrdAction,OrdDepProcNotes,OrdBilled,OrdSkinTestResult,OrderPackQty,OrderPrescNo,Pqty,ArcPrice,ReLoc,LabNo,UserDepart,UserAdd,XUser,EndDate,EndTime,CoverMainInsur,BillType,DspConfirmQty,ActiveQtyStr,ActiveQtySum,MaterialBarCode,arctype,OrderSum,OrderPrintFlag,ReLocID,UserAddID,doctorID,PHFreqDesc,OEItemDR,ArcimId,ordcatno,OrderSeqNo,AdmReason)
		S ^CacheTempFHQ(repid,RetNum)=$LB(OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,Priority,PHFreq,Instr,doctor,OrdStatus,Dura,OEItemID,PatientID,QtyPackUOM,PackUOMDesc,PrescNo,dstatus,LabEpisodeNo,OrdLabSpec,OrdXDate,OrdXTime,OrdSkinTest,OrdAction,OrdDepProcNotes,OrdBilled,OrdSkinTestResult,OrderPackQty,OrderPrescNo,Pqty,ArcPrice,ReLoc,LabNo,UserDepart,UserAdd,XUser,EndDate,EndTime,CoverMainInsur,BillType,DspConfirmQty,ActiveQtyStr,ActiveQtySum,MaterialBarCode,arctype,OrderSum,OrderPrintFlag,ReLocID,UserAddID,doctorID,PHFreqDesc,OEItemDR,ArcimId,ordcatno,OrderSeqNo,AdmReason,OrderUsableDays,OrderNotifyClinician,OrdSpeedFlowRate,OrderFlowRateUnitdesc,OrderNeedPIVAFlag,OrderLocalInfusionQty,ExceedReasonDesc,OrderStage,OrderPilotPro,OrderOperation,OrderDIACat,SkinTest,OrderViewFlag,DMdsstatus,IsCNMedItem,BindSource,OrderChronicDiagCode,ARCOSRowId,ArcimARCOSRowId,$g(PrescTitle),SignFlag,InsuNationCode,InsuNationName,OrdSerialNum,OrdSpecDiagnosForm,OrdSpecLocDiagCatCode)
		;W OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,PHFreq,Instr,doctor,!
		;k ^CacheTemp("DHCDocQryOEOrder",$j)
	}
	q RetNum
}

/// 获取绑定医嘱的来源信息
ClassMethod GetBindSourceDesc(OERowID As %String)
{
	q:(OERowID="") ""
	s BindSource=$p($g(^OEORD(+OERowID,"I",$P(OERowID,"||",2),"DHC")),"^",41)
	s BindSourceDesc=..GetBindSourceDescByCode(BindSource)
	s FillerNo=$p($G(^OEORD(+OERowID,"I",$P(OERowID,"||",2),9)),"^",12)
	if (FillerNo'=""){
		s VirLong=##Class(web.DHCDocOrderVirtualLong).GetVirtualtLongFlag(FillerNo)
		if (VirLong="Y"){
			s BindSourceDesc=##class(websys.Translation).Get("opdoc.treatprint.csp","虚拟长期自动滚动")_FillerNo
		}
	}
	
	q BindSourceDesc
}

ClassMethod GetBindSourceDescByCode(BindSourceCode) As %String
{
	Q:BindSourceCode="" ""
	s BindSourceDesc=""
	if (BindSourceCode="IS"){
		s BindSourceDesc="用法绑定"
	}elseif (BindSourceCode="IT"){
		s BindSourceDesc="医嘱项绑定"
	}elseif (BindSourceCode="IC"){
		s BindSourceDesc="医嘱子类绑定"
	}elseif (BindSourceCode="SK"){
		s BindSourceDesc="皮试绑定"
	}elseif (BindSourceCode="CT"){
		s BindSourceDesc="容器绑定"
	}elseif (BindSourceCode="SP"){
		s BindSourceDesc="标本绑定"
	}elseif (BindSourceCode="BF"){
		s BindSourceDesc="采血费绑定"
	}elseif (BindSourceCode="OMIO"){
		s BindSourceDesc="自备药自动插入"
	}elseif (BindSourceCode="CA"){
		s BindSourceDesc="治疗申请绑定"
	}elseif (BindSourceCode="VLIO"){
		s BindSourceDesc="虚拟长期自动插入"
	}elseif (BindSourceCode="CMPTAM"){
		s BindSourceDesc="草药处方剂型绑定材料"
	}elseif (BindSourceCode="CMPTAOF"){
		s BindSourceDesc="草药处方剂型关联费用"
	}elseif (BindSourceCode="CMPTAL"){
		s BindSourceDesc="草药处方绑定医嘱单长期医嘱"
	}elseif (BindSourceCode="CMCMAO"){
		s BindSourceDesc="草药处方煎药方式附加医嘱"
	}elseif (BindSourceCode="CMPTCMA"){
		s BindSourceDesc="草药处方加工方式绑定医嘱"
	}elseif (BindSourceCode="WB"){
		s BindSourceDesc="病区绑定医嘱"
	}elseif (BindSourceCode="RPB"){
		s BindSourceDesc="检查申请单部位绑定医嘱"
	}elseif (BindSourceCode="DBFee"){
		s BindSourceDesc="住院每日床位费、诊察费"
	}elseif (BindSourceCode="RPO"){
		s BindSourceDesc="挂号预开医嘱"
	}elseif (BindSourceCode="RTO"){
		s BindSourceDesc="挂号产生医嘱"
	}
	Q BindSourceDesc
}

/// 获取绑定医嘱类型列表
Query GetBindSource() As websys.Query(ROWSPEC = "Code:%String,Desc:%String")
{
}

/// do ##class(%ResultSet).RunQuery("web.DHCDocQryOEOrder","GetBindSource")
ClassMethod GetBindSourceExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	s BindSourceList=$G(^oddCOM("User.OEOrdItemExt","a","OEORIBindSource","P","VALUELIST"))
	for i=1:1:$length(BindSourceList,","){
		s Code=$P(BindSourceList,",",i)
		continue:(Code="")
		s Desc=..GetBindSourceDescByCode(Code)
		Set ^CacheTemp(repid,i)=$LB(Code,Desc)
	}

	Set qHandle=$lb(0,repid,0)
 	quit $$$OK
}

/// do ##class(%ResultSet).RunQuery("web.DHCDocQryOEOrder","GetOrdByAdm","690","600","","","","","","","")
Query GetOrdByAdm(EpisodeID As %String = "", OrderCTPro As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OutOrd As %String = "", DrgFormPoison As %String = "", Nexus As %String = "", CMMedFlag As %String = "", OrdComStatus As %String = "") As %Query(ROWSPEC = "OrdCreateDate:%String,OrdCreateTime:%String,OrdStartDate:%String,OrdStartTime:%String,ArcimDesc:%String,DoseQty:%String,DoseUnit:%String,Priority:%String,PHFreq:%String,Instr:%String,Doctor:%String,OrdStatus:%String,Dura,OEItemID:%String,PatientID:%String,QtyPackUOM:%String,PackUOMDesc:%String,PrescNo:%String,dstatus:%String,LabEpisodeNo:%String,OrdLabSpec:%String,OrdXDate:%String,OrdXTime:%String,OrdSkinTest:%String,OrdAction:%String,OrdDepProcNotes:%String,OrdBilled:%String,OrdSkinTestResult:%String,OrderPackQty:%String,OrderPrescNo:%String,Pqty:%String,ArcPrice:%String,ReLoc:%String,LabNo:%String,userDep:%String,UserAdd:%String,XUser:%String,EndDate:%String,EndTime:%String,CoverMainInsur:%String,BillType:%String,DspConfirmQty:%String,ActiveQty:%String,ActiveQtySum:%String,MaterialBarCode:%String,OrderType:%String,OrderSum:%String,OrderPrintFlag:%String,ReLocID:%String,UserAddID,DoctorID:%String,PHFreqDesc,OEItemDR,ARCIMRowId,ordcatno,SeqNo:%String,AdmReason:%String,OrderUsableDays,OrderNotifyClinician,OrdSpeedFlowRate,OrderFlowRateUnitdesc,OrderNeedPIVAFlag,OrderLocalInfusionQty,ExceedReasonDesc,OrderStage,OrderPilotPro,OrderOperation,OrderDIACat,SkinTest,OrderViewFlag,DMdsstatus,IsCNMedItem,BindSource,OrderChronicDiagCode,ARCOSRowId,ArcimARCOSRowId,PrescTitle,SignFlag,InsuNationCode,InsuNationName,OrdSerialNum,OrdSpecDiagnosForm,OrdSpecLocDiagCatCode")
{
}

/// w ##class(web.DHCDocQryOEOrder).GetOrdItemSum("4334","434")
ClassMethod GetOrdItemSum(AdmId As %String = "", CTLocID As %String = "") As %Integer
{
	s del="^",AdmType="",RetNum=0
	q:($g(AdmId)="") RetNum
	q:'$d(^OEORD(0,"Adm",AdmId)) RetNum
	s OrdId1=$o(^OEORD(0,"Adm",AdmId,0))
	s PAADMRegConDisDR=$P($G(^PAADM(AdmId,"DHC")),"^",25)
	q:OrdId1=""
	s OrdId2=0
	s OrderTotalSum=""
	s OrdCreateDate="",OrdCreateTime="",OrdStartDate="",OrdStartTime="",ArcimDesc=""
	f  s OrdId2=$o(^OEORD(OrdId1,"I",OrdId2)) q:OrdId2=""  d
	.s OEItemID=OrdId1_"||"_OrdId2
	.s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1))
	.s ordstr2=$g(^OEORD(OrdId1,"I",OrdId2,2))
	.s ordstr3=$g(^OEORD(OrdId1,"I",OrdId2,3))
	.s ordstr5=$g(^OEORD(OrdId1,"I",OrdId2,5))
	.s ordstr9=$g(^OEORD(OrdId1,"I",OrdId2,9))
	.s ordstr11=$g(^OEORD(OrdId1,"I",OrdId2,11))
	.s ArcimId=$p(ordstr1,del,2)
	.s ArcStr=##class(web.DHCFBArcimGet).GetArcimById(ArcimId)
	.q:ArcStr=""
	.s OrdBilled=$p(ordstr3,"^",5)
	.i OrdBilled="P" s OrdBilled="已收费"
	.i OrdBilled="B" s OrdBilled="未收费"
	.i OrdBilled="TB" s OrdBilled="未收费"
	.i OrdBilled="TR"  s OrdBilled="待退费"
	.i OrdBilled="R"  s OrdBilled="已退费"
	.q:(OrdBilled="已退费")!(OrdBilled="已收费")!(OrdBilled="待退费")
	.s OrdStatusDR=$p(ordstr1,del,13)
	.s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),del,2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),del,1)
	.s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
	.Q:(OrdStatusCode'="V")
	.s ReLocID=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",6)
	.q:(CTLocID'=$g(ReLocID))&&(CTLocID'="")
	.s EpissubtypeId=$P($g(^PAADM(AdmId,1)),"^",6)  ;绿色or非绿色通道
	.s AdmReasonId=$P($g(^PAADM(AdmId,1)),"^",7)   ;费别：自费、医保。。。
	.s arctpdr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)
	.s drgformId=$P(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1),"^",12)
	.s arctype=$p(^ARC("IC",arctpdr),"^",7) ;ARC_ItemCat 表中的ARCIC_Ordertype ,="R"是药物
	.s ARCICOrdCatDR=$p(^ARC("IC",arctpdr),"^",8)  ;医嘱大类,指向表OEC_OrderCategory
	.q:($g(ARCICOrdCatDR)=17) ;草药
	.i ($g(arctype)="R") d
	..s oeori=OrdId1_"||"_OrdId2
	..s dis=$O(^DHCOEDISQTY(0,"OEORI",oeori,0))
	..q:dis=""
	..q:'$d(^DHCOEDISQTY(dis))
	..s Pqty=$p(^DHCOEDISQTY(dis),"^",2)
	.e  d
	..s Pqty=$p(^OEORD(OrdId1,"I",OrdId2,1),"^",12)
	.s BaseUOMDesc=""
	.s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimId)
	.i INCIRowid'="" d
	..; INCI_CTUOM_DR  库存基本单位
	..s BaseUOMRowid=$p($g(^INCI(INCIRowid,1)),"^",10)
	..s BaseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BaseUOMRowid)
	.i $g(Pqty)'="" s Pqty=Pqty_""_BaseUOMDesc
	.s ArcimCode=$p(ArcStr,del,2),ArcimDesc=$p(ArcStr,del,3)
	.;w ArcimDesc
	.;b ;1
	.s OEORIPrice=$p(ordstr3,del,25)
	.s DoseqtySum=$p(ordstr1,del,12)
	.s OrderPackQty=$p(ordstr9,del,4)
	.s QtyPackUOM=OrderPackQty
	.s PackUOMDesc=""
	.s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OEItemID)
	.i BillingUOMDR'="" d
	..s PackUOMDesc=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
	.;如果整包装数量是空也不能把单次计量直接赋值
	.s OrderRecDepRowid=$P($G(^OEORD(OrdId1,"I",OrdId2,3)),"^",6) ;OEORI_RecDep_DR
	. i OrderPackQty'="" d
	.. i OrderPackQty<1 s OrderPackQty="0"_$number(OrderPackQty)
	..;包含基础单位和整包装代为的价格转换
	..s ExpStr=OrdId1_"||"_OrdId2_"^"_""_"^"_AdmId_"^"_OrderRecDepRowid
	..s ArcPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(EpissubtypeId,AdmReasonId,ArcimId , $H, "", "","", OEORIPrice,"",PAADMRegConDisDR,ProtocolPackUOMDR,ExpStr)
	.else  d
	..;只是基本单位的价格
	..s ExpStr=PAADMRegConDisDR_"^"_OrdId1_"||"_OrdId2_"^"_""_"^"_AdmId_"^"_OrderRecDepRowid
	..s ArcPrice=##class(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeId,AdmReasonId,ArcimId , $H, "", "","",OEORIPrice,"",ExpStr)  //李洪磊
	.s OrderSum=$p(ArcPrice,"^",1)*OrderPackQty
	.s ArcPrice=$fn($p(ArcPrice,"^",1),"",4)
	.s DoseQty=$p(ordstr2,del,1)
	.s DoseUnitID=$p(ordstr2,del,3)
	.s DoseUnit=""
	.s:DoseUnitID'="" DoseUnit=$p(^CT("UOM",DoseUnitID),del,2)
	.s PriorityDR=$p(ordstr1,del,8)
	.s:$g(PriorityDR)="" Priority="",PriorityCode=""
	.s:$g(PriorityDR)'="" Priority=$p(^OECPR(PriorityDR),del,2),PriorityCode=$p(^OECPR(PriorityDR),del,1)
	.;w !,Priority_"^"_PriorityCode	
	.s OEItemDR=$p(ordstr11,del,39)
	.s PHFreqDR=$p(ordstr2,del,4)
	.i PHFreqDR'="" s FreqFactor=$P(^PHCFR(PHFreqDR),"^",2)
	.e  s FreqFactor=1
	.s DuraDR=$p(ordstr2,del,6)
	.i DuraDR'="" s DuraFactor=$P(^PHCDU(DuraDR),"^",2)
	.e  s DuraFactor=1
	.s Dura=""
	.s:$g(DuraDR)'="" Dura=$p(^PHCDU(DuraDR),del,3)
	.s UserAddID=$p($g(^OEORD(OrdId1,"I",OrdId2,7)),"^",1)
	.If UserAddID'="" Set UserAdd=$P($G(^SSU("SSUSR",UserAddID)),"^",2)
	.s OrderType=""
	.if arctpdr'="" s OrderType=$P(^ARC("IC",arctpdr),"^",7)
	.i OrderType'="R" d 
	..s DoseqtySum=$p($g(^OEORD(OrdId1,"I",OrdId2,1)),"^",12)
	..s OrderPackQty=DoseqtySum
	.s OrderSum=OrderPackQty*ArcPrice ;直接在外层计算
	.i (+OrderPackQty'=0)&&(+OrderPackQty<1) s OrderPackQty="0"_$number(OrderPackQty)
	.;如果没有填数量则自动计算数量
	.i ((+OrderPackQty=0)&&(OrderType="R"))  d
	..s Qty=##Class(web.DHCDocOrderEntry).CalDose(DoseUnitID,drgformId,DoseQty)
	..s OrderPackQty=0
	..i DuraDR'="" s OrderPackQty=+Qty*FreqFactor*DuraFactor
	..s OrderSum=OrderPackQty*ArcPrice
	.if (PriorityCode="OM")||(PriorityCode="OMST")||(PriorityCode="OMCQZT")||(PriorityCode="OMLSZT") s OrderSum=0
	.;w OrderSum
	.;b ;OrderSum
	.i OrderTotalSum'="" s OrderTotalSum=OrderTotalSum+$g(OrderSum)
	.i OrderTotalSum="" s OrderTotalSum=$g(OrderSum)
	i (OrderTotalSum<1)&&($p(OrderTotalSum,".",1)="") s OrderTotalSum=0_OrderTotalSum
	q OrderTotalSum
}

/// w ##class(web.DHCDocQryOEOrder).GetOrderCategory("10359||1")
ClassMethod GetOrderCategory(ARCIMRowId As %String = "") As %String
{
	q:ARCIMRowId="" 0
	s arctpdr=$p(^ARCIM($p(ARCIMRowId,"||",1),$p(ARCIMRowId,"||",2),1),"^",10)
	q:arctpdr="" 0
	s ARCICOrdCatDR=$p(^ARC("IC",$g(arctpdr)),"^",8)  ;医嘱大类,指向表OEC_OrderCategory
	i ARCICOrdCatDR=2  s OrdCatFlag=1
	e  s OrdCatFlag=0		
	q OrdCatFlag
}

ClassMethod GetCMOrdByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCMOrdByAdmExecute ]
{
	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
}

ClassMethod GetCMOrdByAdmExecute(ByRef qHandle As %Binary, EpisodeID As %String = "", OrderCTPro As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OutOrd As %String = "") As %Status
{
	s ^RP("GetOrdByAdm")=EpisodeID_"^"_OrderCTPro_"^"_SearchStartDate_"^"_SearchEndDate_"^"_CategoryID_"^"_SubsortID_"^"_LongOrd_"^"_ShortOrd
	///d ##class(%ResultSet).RunQuery("web.DHCFOrdGet","GetOrdByAdm","201764","61325","61325","","")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (SearchStartDate'="")&&(SearchEndDate'="")&&((SearchEndDate-SearchStartDate)>365) Quit
	
	s RetNum=..GetCMOrdItem(repid,EpisodeID, OrderCTPro,SearchStartDate,SearchEndDate,CategoryID,SubsortID,"",LongOrd,ShortOrd,OutOrd)
	s i=0
	s SeqNo=1
	s SubSeqCount=1
	f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
	.s Data=^CacheTempFHQ(repid,i)
	.s OEItemID=$list(Data,14)
	.s OEItemIDChildsub=+$P($list(Data,14),"||",2)
	.s seqno=$list(Data,56)
	.s ordcatNo=$list(Data,55)
	.s ^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo)=Data
	.s ^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo,seqno)=Data
	.i $d(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),11)) s LinkOrderItemChildsub=$P($p(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),11),"^",39),"||",2)
	.if $G(LinkOrderItemChildsub)="" d
	..s ^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo,seqno,OEItemIDChildsub)=Data
	.e  d
	..if '$D(^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo,seqno,LinkOrderItemChildsub)) d
	...s ^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo,seqno,LinkOrderItemChildsub)=""
	..s ^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo,seqno,LinkOrderItemChildsub,"sub",OEItemIDChildsub)=Data
	s ordcatNo1=0
	for  s ordcatNo1=$O(^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo1)) q:ordcatNo1=""  d
	.s seqno1=0
	.for  s seqno1=$O(^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo1,seqno1)) q:seqno1=""  d
	..s SeqNo=0
	..s mas=0 
	..for  s mas=$O(^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo1,seqno1,mas)) q:mas=""  d
	... s s1=^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo1,seqno1,mas)
	... s PSeq=$p(mas,"||",2)
	... i s1'="" d 
	....s SeqNo=SeqNo+1
	....s $List(s1,56)=SeqNo
	....s Data=s1
	....d OutputRow
	... s SubSeqCount=0
	...s sub=0  for  s sub=$O(^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo1,seqno1,mas,"sub",sub)) q:sub=""  d
	.... s s2=^CacheTemp("DHCFindOrdItem",$j,"master",ordcatNo1,seqno1,mas,"sub",sub)
	.... i s1="" d
	.....s SeqNo= SeqNo+1
	.....s $List(s2,56)=SeqNo
	..... s Data=s2
	..... d OutputRow
	.... e  d
	..... s PSeq=$p(sub,"||",2)
	..... s SubSeqCount=SubSeqCount+1
	..... s SubSeqNo=SeqNo_"."_SubSeqCount
	..... s $List(s2,56)=SubSeqNo
	..... s Data=s2
	..... d OutputRow
	
	Set qHandle=$lb(0,repid,0)
	k ^CacheTempFHQ(repid)
	k ^CacheTemp("DHCFindOrdItem",$j,"master")
 quit $$$OK
OutputRow
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetCMOrdByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCMOrdByAdmExecute ]
{
 s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
 Quit $$$OK
}

/// w ##class(web.DHCDocQryOEOrder).GetOrdItem("1480","","","","","","","","")
ClassMethod GetCMOrdItem(repid As %Integer = 0, AdmId As %String = "", CTProID As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", ArcId As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OutOrd As %String = "") As %Integer
{
	s ^RP("benCiItm")=LongOrd_"^"_ShortOrd_"^"_OutOrd
	s del="^",AdmType="",RetNum=0
	k ^CacheTemp("DHCDocQryOEOrder",$j)
	q:($g(AdmId)="") RetNum
	q:'$d(^OEORD(0,"Adm",AdmId)) RetNum
	s OrdId1=$o(^OEORD(0,"Adm",AdmId,0))
	s PatientID=$P(^PAADM(AdmId),"^",1)
	s PAADMRegConDisDR=$P($G(^PAADM(AdmId,"DHC")),"^",25)
	q:OrdId1=""
	s OrdId2=0
	s OrdCreateDate="",OrdCreateTime="",OrdStartDate="",OrdStartTime="",ArcimDesc=""
	f  s OrdId2=$o(^OEORD(OrdId1,"I",OrdId2)) q:OrdId2=""  d
	.s OEItemID=OrdId1_"||"_OrdId2
	.s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1))
	.s ordstr2=$g(^OEORD(OrdId1,"I",OrdId2,2))
	.s ordstr3=$g(^OEORD(OrdId1,"I",OrdId2,3))
	.s ordstr5=$g(^OEORD(OrdId1,"I",OrdId2,5))
	.s ordstr9=$g(^OEORD(OrdId1,"I",OrdId2,9))
	.s ordstr11=$g(^OEORD(OrdId1,"I",OrdId2,11))
	.s ArcimId=$p(ordstr1,del,2)
	.q:((ArcId'="")&(ArcimId'=ArcId))
	.s ArcStr=##class(web.DHCFBArcimGet).GetArcimById(ArcimId)
	.q:ArcStr=""
	.s EpissubtypeId=$P($g(^PAADM(AdmId,1)),"^",6)
	.s AdmReasonId=$P($g(^PAADM(AdmId,1)),"^",7)
	.s arctpdr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)
	.s drgformId=$P(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1),"^",12)
	.s arctype=$p(^ARC("IC",arctpdr),"^",7) ;ARC_ItemCat 表中的ARCIC_Ordertype ,="R"是药物
	.;q:arctpdr=2  ;通用处置治疗屏蔽
	.s ARCICOrdCatDR=$p(^ARC("IC",arctpdr),"^",8)  ;医嘱大类,指向表OEC_OrderCategory
	.s ORCATDesc=$p(^OEC("ORCAT",ARCICOrdCatDR),"^",2)
	.;w ARCICOrdCatDR_"^^^"_ORCATDesc,!
	.;b ;ARCICOrdCatDR^^^^ORCATDesc
	.q:($g(ARCICOrdCatDR)'=18) ;!($g(ARCICOrdCatDR)='6)!($g(ARCICOrdCatDR)'=10)
	.i ARCICOrdCatDR=18  s ordcatno=1
	.i (ARCICOrdCatDR'=18) s ordcatno=2
	.i ($g(arctype)="R") d
	..s oeori=OrdId1_"||"_OrdId2
	..s dis=$O(^DHCOEDISQTY(0,"OEORI",oeori,0))
	..q:dis=""
	..q:'$d(^DHCOEDISQTY(dis))
	..s Pqty=$p(^DHCOEDISQTY(dis),"^",2)
	.e  d
	..s Pqty=$p(^OEORD(OrdId1,"I",OrdId2,1),"^",12)
	.s BaseUOMDesc=""
	.s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimId)
	.i INCIRowid'="" d
	..; INCI_CTUOM_DR  库存基本单位
	..s BaseUOMRowid=$p($g(^INCI(INCIRowid,1)),"^",10)
	..s BaseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BaseUOMRowid)
	.i $g(Pqty)'="" s Pqty=Pqty_""_BaseUOMDesc
	.s ArcimCode=$p(ArcStr,del,2),ArcimDesc=$p(ArcStr,del,3)
	.s GenericName=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(ArcimId)
	.;i GenericName'="" s ArcimDesc=GenericName
	.;w ArcimDesc
	.;b
	.s OrdCreateDate=$p(ordstr3,del,7),OrdCreateDate=..%ZD(OrdCreateDate) //$zd(OrdCreateDate,3)
	.s OrdCreateTime=$p(ordstr1,del,17),OrdCreateTime=..%ZT(OrdCreateTime,2)
	.s OrdStartDate=$p(ordstr1,del,9),OrdStartDate=..%ZD(OrdStartDate) //$zd(OrdStartDate,3)
	.s OrdStartTime=$p(ordstr1,del,10),OrdStartTime=..%ZT(OrdStartTime,2)
	.s OrderPrescNo=$p(ordstr1,del,14)
	.s DoseqtySum=$p(ordstr1,del,12)
	.s OrderPackQty=$p(ordstr9,del,4)
	.s QtyPackUOM=OrderPackQty
	.s PackUOMDesc=""
	.s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OEItemID)
	.if BillingUOMDR'="" s PackUOMDesc=$p(^CT("UOM",BillingUOMDR),"^",2)
	.;协议单位
	.s ProtocolPackUOMDR=$p($g(^OEORD(OrdId1,"I",OrdId2,"DHC")),"^",13)
	.i ProtocolPackUOMDR'="" d
	.. s BillingUOMDR=ProtocolPackUOMDR
	.. s PackUOMDesc=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
	.s OrderRecDepRowid=$P($G(^OEORD(OrdId1,"I",OrdId2,3)),"^",6) ;OEORI_RecDep_DR
	.;如果整包装数量是空也不能把单次计量直接赋值
	.;i OrderPackQty=""  d
	.;.s OrderPackQty=DoseqtySum
	. i OrderPackQty'="" d
	. . i OrderPackQty<1 s OrderPackQty="0"_$number(OrderPackQty)
	..;包含基础单位和整包装代为的价格转换
	..s ExtStr=OrdId1_"||"_OrdId2_"^"_""_"^"_AdmId_"^"_OrderRecDepRowid
	..s ArcPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(EpissubtypeId,AdmReasonId,ArcimId , $H, "", "","", "","",PAADMRegConDisDR,ProtocolPackUOMDR,ExtStr)
	.else  d
	..;只是基本单位的价格
	..s ExtStr=PAADMRegConDisDR_"^"_OrdId1_"||"_OrdId2_"^"_""_"^"_AdmId_"^"_OrderRecDepRowid
	..s ArcPrice=##class(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeId,AdmReasonId,ArcimId , $H, "", "","", "","",ExtStr)  //李洪磊
	.s OrderSum=$p(ArcPrice,"^",1)*OrderPackQty
	.s ArcPrice=$fn($p(ArcPrice,"^",1),"",4)
	.s PrescNo=$p(ordstr1,del,14)
	.s seqno=$p(ordstr3,del,4)              ;医嘱序号    
	.s DoseQty=$p(ordstr2,del,1)
	.s DoseUnitID=$p(ordstr2,del,3)
	.//guorongyong start 2008-11-25
	.s OrdcatDR=""
	.s SubsortDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),del,10)
	.s:SubsortDR'="" OrdcatDR=$p(^ARC("IC",SubsortDR),del,8)
	.Q:(SubsortID'="")&&(SubsortID'=SubsortDR)
	.Q:(CategoryID'="")&&(CategoryID'=OrdcatDR)
	.Q:(SearchStartDate'="")&&(SearchEndDate'="")&&(($zdh(OrdStartDate,3)<SearchStartDate)||($zdh(OrdStartDate,3)>SearchEndDate))
	.s OrderSeqNo=$p(ordstr3,del,4)
	.//end
	.s DoseUnit=""
	.s:DoseUnitID'="" DoseUnit=$p(^CT("UOM",DoseUnitID),del,2)
	.s PriorityDR=$p(ordstr1,del,8)
	.s:$g(PriorityDR)="" Priority="",PriorityCode=""
	.s:$g(PriorityDR)'="" Priority=$p(^OECPR(PriorityDR),del,2),PriorityCode=$p(^OECPR(PriorityDR),del,1)
	.;w !,Priority_"^"_PriorityCode
	.Q:(LongOrd="on")&&(ShortOrd'="on")&&(OutOrd'="on")&&(PriorityCode'="S")
	.Q:(ShortOrd="on")&&(LongOrd'="on")&&(OutOrd'="on")&&(PriorityCode'="NORM")
	.Q:(OutOrd="on")&&(ShortOrd'="on")&&(LongOrd'="on")&&(PriorityCode'="OUT")
        .s PHFreq=""
	.s PHFreqDR=$p(ordstr2,del,4)
	.s:($g(PHFreqDR)'="")&&($d(^PHCFR(PHFreqDR))) PHFreq=$p(^PHCFR(PHFreqDR),del,1),PHFreqDesc=$p(^PHCFR(PHFreqDR),del,4)
	.s:$g(PHFreq)="" PHFreq="",PHFreqDesc=""
	.s Instr=$p(ordstr2,del,7)
	.s:$g(Instr)'="" Instr=$p($g(^PHCIN(Instr)),del,2)
	.s:$g(Instr)="" Instr=""
	.s OrdStatusDR=$p(ordstr1,del,13)
	.s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),del,2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),del,1)
	.s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
	.Q:((OrdStatusCode'="V")&(OrdStatusCode'="E"))   ;东方医院不显示停止的医嘱
	.s OEItemDR=$p(ordstr11,del,39)
	.s DuraDR=$p(ordstr2,del,6)
	.s Dura=""
	.s:$g(DuraDR)'="" Dura=$p(^PHCDU(DuraDR),del,3)
	.s doctorID=$p(ordstr1,del,11)
	.s:$g(doctorID)'="" doctor=$p(^CTPCP(doctorID,1),del,2)
	.s:$g(doctorID)="" doctor=""
	.s HaveDispensing=0,dstatus=""
	.s DspConfirmQty=""     /////////////////////////存储退药数量   zlj
	.s dis=0  f  s dis=$O(^DHCOEDISQTY(0,"OEORI",OEItemID,dis)) Q:dis=""  d
	..s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
	..s HaveDispensing=1
	..i dstatus="R" d                              ///zlj   2012-08-17
	...s dconfirmqty=$p(^DHCOEDISQTY(dis),"^",11)  //退药数量    zlj
	...s DspConfirmQty=DspConfirmQty+dconfirmqty   //退药数量    zlj
	.i DspConfirmQty'="" d
	..s DspConfirmQty=DspConfirmQty_BaseUOMDesc    //加上基本单位  zlj
	.i HaveDispensing=1 d
	..i dstatus="C" s dstatus="已发"
	..i dstatus="TC" s dstatus="未发"
	..i dstatus=""  s dstatus="未打包"
	..i dstatus="R" s dstatus="已退药"	         ///zlj   2012-08-17
	.;条码号,标本
	.s LabEpisodeNo=$p(ordstr3,del,20) ;
	.s OrdLabSpec=##Class(web.DHCOEOrdItem).GetLabSpec(OEItemID)
	.;停医嘱日期,停医嘱时间
	.s OrdXDate=$p(ordstr3,del,34)
	.if OrdXDate'="" s OrdXDate=..%ZD(OrdXDate) //$zd(OrdXDate,3)
	.s OrdXTime=$p(ordstr2,del,15)
	.if OrdXTime'="" s OrdXTime=..%ZT(OrdXTime,2)
	.;皮试,皮试备注,备注,
	.s OrdSkinTest=$p(ordstr5,del,2)
	.s OrdAction=$p(ordstr11,del,21)
	.i OrdAction'="" s OrdAction=$P($G(^OEC("ACT",OrdAction)),"^",2) 
	.s OrdDepProcNotes=$g(^OEORD(OrdId1,"I",OrdId2,"DEP",1))
	.s OrdBilled=$p(ordstr3,"^",5)
	.i OrdBilled="P" s OrdBilled="已收费"
	.i OrdBilled="B" s OrdBilled="未收费"
	.i OrdBilled="TB" s OrdBilled="未收费"
	.i OrdBilled="TR"  s OrdBilled="待退费"
	.i OrdBilled="R"  s OrdBilled="已退费"
	.q:(OrdBilled="已退费")  ;已退费医嘱屏蔽
	.s abnorm=$p($g(^OEORD(OrdId1,"I",OrdId2,11)),"^",3)
	.s OrdSkinTestResult=""
	.i OrdSkinTest="Y" d
	..i abnorm="Y" s OrdSkinTestResult="阳性"
	..i abnorm="N" s OrdSkinTestResult="阴性"
	.;
	.s ReLocID=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",6)
	.If ReLocID'="" Set ReLoc=$P($P($G(^CTLOC(ReLocID)),"^",2),"-",2)
	.S RetNum=RetNum+1
	.s OrdRowid=OrdId1_"||"_OrdId2
	.s LabNo=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",20)
	.s UserDepart="",UserDepartType=""
	.s UserDepartId=$p($g(^OEORD(OrdId1,"I",OrdId2,7)),"^",2)
	.If UserDepartId'=""  d
	..Set UserDepart=$P($P($G(^CTLOC(UserDepartId)),"^",2),"-",2)
	..Set UserDepartType=$P($G(^CTLOC(UserDepartId)),"^",13)
	.;Q:(UserDepartId="")&((onlydoc="Y")||(onlyNurse="Y")||(onlyloc'=""))
	.;Q:(onlydoc="Y")&(UserDepartType="W")
	.;Q:(onlyNurse="Y")&(UserDepartType="E")
	.;Q:(onlyloc'="")&(onlyloc'=UserDepartId)
	.
	.s UserAddID=$p($g(^OEORD(OrdId1,"I",OrdId2,7)),"^",1)
	.q:(UserAddID'=CTProID)
	.If UserAddID'="" Set UserAdd=$P($G(^SSU("SSUSR",UserAddID)),"^",2)
	.s XUser=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",29)
	.if XUser'="" Set XUser=$P($G(^CTPCP(XUser,1)),"^",2)
	.s EndDate=$p($g(^OEORD(OrdId1,"I",OrdId2,9)),"^",9)
	.s EndTime=$p($g(^OEORD(OrdId1,"I",OrdId2,9)),"^",10)
	.If EndDate'="" Set EndDate=..%ZD(EndDate) //$ZD(EndDate,3)
	.If EndTime'="" Set EndTime=..%ZT(EndTime,1)
	.s CoverMainInsur=$p($g(^OEORD(OrdId1,"I",OrdId2,3)),"^",3)
	.s BillTypeRowid=$p($g(^OEORD(OrdId1,"I",OrdId2,11)),"^",18)
	.s BillType=""
	.If BillTypeRowid'=""  Set BillType=$P($G(^PAC("ADMREA",BillTypeRowid)),"^",2)
	.s OrderType=""
	.if arctpdr'="" s OrderType=$P(^ARC("IC",arctpdr),"^",7)
	.i OrderType'="R" d 
	..s DoseqtySum=$p($g(^OEORD(OrdId1,"I",OrdId2,1)),"^",12)
	..s OrderPackQty=DoseqtySum
	.s OrderSum=OrderPackQty*ArcPrice ;直接在外层计算
	.i (+OrderPackQty'=0)&&(+OrderPackQty<1) s OrderPackQty="0"_$number(OrderPackQty)
	.;如果没有填数量则自动计算数量
	.i ((+OrderPackQty=0)&&(OrderType="R"))  d
	..s Qty=##Class(web.DHCDocOrderEntry).CalDose(DoseUnitID,drgformId,DoseQty)
	..s OrderPackQty=0
	..i DuraDR'="" s OrderPackQty=+Qty*$P(^PHCFR(PHFreqDR),"^",2)*$P(^PHCDU(DuraDR),"^",2)
	..s OrderSum=OrderPackQty*ArcPrice
	..;展示的时候单位和数量匹配
	..s PackUOMDesc=BaseUOMDesc
	.s ActiveQty=(OrderPackQty-DspConfirmQty) 
	.s ActiveQtySum=ActiveQty*ArcPrice	;有效价格
	.s ActiveQtySum=$fn(ActiveQtySum,"",2)
	.s ActiveQty=ActiveQty_PackUOMDesc	;有效数量
	.s AdmType=$P($g(^PAADM(AdmId)),"^",2)
	.if AdmType="I"  d
	..s ActiveQtySum=OrderSum
	..s ActiveQty=OrderPackQty_PackUOMDesc
	.s MaterialBarCode=$p($G(^OEORD(OrdId1,"I",OrdId2,"DHC")),"^",14) ;高值条码
	.;--------
	.s OrderPrintFlag=""
	.i $g(^DHCDOCOEORDPRINTFLAG(OEItemID))="Y" s OrderPrintFlag="Y"
	.S RetNum=RetNum+1
	.S ^CacheTempFHQ(repid,RetNum)=$LB(OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,Priority,PHFreq,Instr,doctor,OrdStatus,Dura,OEItemID,PatientID,QtyPackUOM,PackUOMDesc,PrescNo,dstatus,LabEpisodeNo,OrdLabSpec,OrdXDate,OrdXTime,OrdSkinTest,OrdAction,OrdDepProcNotes,OrdBilled,OrdSkinTestResult,OrderPackQty,OrderPrescNo,Pqty,ArcPrice,ReLoc,LabNo,UserDepart,UserAdd,XUser,EndDate,EndTime,CoverMainInsur,BillType,DspConfirmQty,ActiveQty,ActiveQtySum,MaterialBarCode,arctype,OrderSum,OrderPrintFlag,ReLocID,UserAddID,doctorID,PHFreqDesc,OEItemDR,ArcimId,ordcatno,OrderSeqNo)
	.;W OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,PHFreq,Instr,doctor,!
	;k ^CacheTemp("DHCDocQryOEOrder",$j)
	q RetNum
}

/// do ##class(%ResultSet).RunQuery("web.DHCDocQryOEOrder","GetCMOrdByAdm","693","600","","","","","","","")
Query GetCMOrdByAdm(EpisodeID As %String = "", OrderCTPro As %String = "", SearchStartDate As %String = "", SearchEndDate As %String = "", CategoryID As %String = "", SubsortID As %String = "", LongOrd As %String = "", ShortOrd As %String = "", OutOrd As %String = "") As %Query(ROWSPEC = "OrdCreateDate:%String,OrdCreateTime:%String,OrdStartDate:%String,OrdStartTime:%String,ArcimDesc:%String,DoseQty:%String,DoseUnit:%String,Priority:%String,PHFreq:%String,Instr:%String,Doctor:%String,OrdStatus:%String,Dura,OEItemID:%String,PatientID:%String,QtyPackUOM:%String,PackUOMDesc:%String,PrescNo:%String,dstatus:%String,LabEpisodeNo:%String,OrdLabSpec:%String,OrdXDate:%String,OrdXTime:%String,OrdSkinTest:%String,OrdAction:%String,OrdDepProcNotes:%String,OrdBilled:%String,OrdSkinTestResult:%String,OrderPackQty:%String,OrderPrescNo:%String,Pqty:%String,ArcPrice:%String,ReLoc:%String,LabNo:%String,userDep:%String,UserAdd:%String,XUser:%String,EndDate:%String,EndTime:%String,CoverMainInsur:%String,BillType:%String,DspConfirmQty:%String,ActiveQty:%String,ActiveQtySum:%String,MaterialBarCode:%String,OrderType:%String,OrderSum:%String,OrderPrintFlag:%String,ReLocID:%String,UserAddID,DoctorID:%String,PHFreqDesc,OEItemDR,ARCIMRowId,ordcatno,SeqNo:%String")
{
}

/// 根据就诊id返回是否单病种,定额结算金额
/// 出参： Y^金额  N^
/// w ##class(web.DHCDocQryOEOrder).GetDBZInfoByAdm("33651","")
ClassMethod GetDBZInfoByAdm(Adm, ExpStr)
{
	s SelectedStr=""
	Q:Adm="" SelectedStr
	s SelectedStr=##class(web.DHCMRDiagnos).GetSingleDisInfo(Adm)
	i SelectedStr'="" d
	.s DisBill=$p(SelectedStr,",",2)
	.s ret="Y"_"^"_DisBill
	e  d
	.s ret="N"_"^"_""	
	q ret
}

/// 根据医嘱ID获取医嘱数量信息
/// 出参: 数量^单位^单位ID^数量(换算成基本单位)^基本单位^单位ID^实发数量^实发数量单位^发药状态
/// w ##class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo("178||565")
ClassMethod GetOrdPackQtyInfo(OEOrdItem As %String) As %String
{
	s AdmId=$p(^OEORD(+OEOrdItem),"^",1)
	s AdmDepDr=$p($g(^PAADM(AdmId)),"^",4)
	s AdmDepHospId=$p(^CTLOC(AdmDepDr),"^",22)
	s PatCurStat=##class(web.DHCADMVisitStat).GetStayStatus(AdmId)
	s StayPayMode=##class(web.DHCBillInterface).IGetStayPayMode(AdmDepHospId)
	s StayStatus=0
	i " 1 2 "[(" "_PatCurStat_" ") s StayStatus=1
	
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(AdmId)
	s ArcimId=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1)),"^",2)
	if (+ArcimId=0) q ""
	s Phcdf=$P($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",12)
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimId)
	s ItemCatDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s DoseUnitID=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),2)),"^",3)
	s PriorityDR = $p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1)),"^",8)
	s PriorityCode=$p(^OECPR(PriorityDR),"^",1)
	s RecLocRowId=$P($G(^OEORD(+OEOrdItem,"I",$P(OEOrdItem,"||",2),3)),"^",6)
	;无库存医嘱
	s AllowOrderWithoutStock=$p($g(^ARCIM(+ArcimId,$p(ArcimId,"||",2),8)),"^",11)
	s DoseUnit=""
	s:DoseUnitID'="" DoseUnit=$p(^CT("UOM",DoseUnitID),"^",2)
	s PackUOMDesc="" //整包装单位

	s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OEOrdItem)
	i BillingUOMDR'="" {
		s PackUOMDesc=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
	}
	s convFac=##class(appcom.OEDispensing).convFac(ArcimId,BillingUOMDR)
	;基本单位
	s BaseUOMDesc="",BaseUOMRowid="" 
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimId)
	i INCIRowid'="" {
		; INCI_CTUOM_DR  库存基本单位
		s BaseUOMRowid=$p($g(^INCI(INCIRowid,1)),"^",10)
		s BaseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BaseUOMRowid)
	}
	;草药取药学项单位
	s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(ArcimId)
	if (CheckCHNFlag="Y") { 
		if (Phcdf'=""){
			s BillingUOMDR=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
			s PackUOMDesc=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
			s BaseUOMDesc=PackUOMDesc,BaseUOMRowid=BillingUOMDR
		}
	}
	;整包装数量(医嘱录入界面数量)
	s OrderPackQty=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),9)),"^",4)
	s DoseqtySum=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1)),"^",12)
	s DuraDR=$p($G(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),2)),"^",6)
	s OrderFirstDayTimes=$p($G(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1)),"^",18)
	s DuraFactor=1
	s:(DuraDR=1) DuraFactor=$P(^PHCDU(DuraDR),"^",2)
	if (OrderType'="R"){
		;非药品医嘱
		s OrderPackQty=DoseqtySum
	}
	s HaveDispensing=0
	if $D(^DHCOEDISQTY(0,"OEORI",OEOrdItem)){
		s HaveDispensing=1
	}
	;出院带药按门诊规则计算
	if (AdmType="I")&&'##class(DHCDoc.Order.Common).IsOutOrdItem(OEOrdItem){
		s DoseQty=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(OEOrdItem) //$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),2)),"^",1)
		s PriorityDR=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1)),"^",8)
		s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
		if (ISLongOrderPrior){
			s NewDoseQty=0
			for DoseIndex=1:1:$l(DoseQty,"-") {
				s NewDoseQty=NewDoseQty+$p(DoseQty,"-",DoseIndex)
			}
			s DoseQty=NewDoseQty
			//s OrderPackQty=DoseQty
			s Pqty=DoseQty
			//s PackUOMDesc=DoseUnit
			s BillingUOMDR=DoseUnitID
		}else{
			if (OrderPackQty'=""){
				s Pqty=OrderPackQty
			}else{
				if (OrderType="R") {
					if DoseQty>0{
						s DoseqtySum=$$calcqty^DHCOEOrdItem(DrgformRowid,DoseUnitID,DoseQty)
					}
					s BaseQty=DoseqtySum
				}
				s OrderPackQty=DoseqtySum
				s Pqty=DoseqtySum
				s PackUOMDesc=DoseUnit
				s BillingUOMDR=DoseUnitID
			}
		}
		
	}else{
		//b "L+" ;+
		///tanjishan 2020.05.06只有虚拟长期是严格按照首日执行次数生成的执行记录及打包记录，直接修改为统计执行记录要求数量，
		///防止此处的计算值与执行记录生成值不一致的情况。比如虚拟长期医嘱的首日为0
		s VirLong=##Class(web.DHCDocOrderVirtualLong).GetVirtualtLongFlag(OEOrdItem)
		if (VirLong="Y")&&(PriorityCode'["OM")&&(OrderType="R"){
			s OrderPackQty=0
			s BaseDoseQtySum=0
			s OEOREChildsub=""
			for{
				s OEOREChildsub=$O(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),"X",OEOREChildsub))
				q:OEOREChildsub=""
				s OneAdminQty=$P(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),"X",OEOREChildsub),"^",5)
				s BaseDoseQtySum=BaseDoseQtySum+(+OneAdminQty)
			}
			s OrderPackQty = BaseDoseQtySum / convFac
		}elseif ((+OrderPackQty=0)&&(OrderType="R"))  { //&&(PriorityCode'["OM")
			s OrderPackQty=0
			s BaseDoseQtySum=0
			s EndDate=$p($G(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),3)),"^",34)	
			s GenDate=$CASE(EndDate,"":+$H,:EndDate)
			;Wqy 改用执行记录生成方法计算
			d ##class(DHCDoc.Order.Exec).GetGenTimeList(OEOrdItem,GenDate,.ExecList)
			d ##class(DHCDoc.Order.Exec).GetOrdExecQtyToList(OEOrdItem,.ExecList)
			s Date="" for{
				s Date=$O(ExecList(Date)) Q:Date=""
				s Time="" for{
					s Time=$O(ExecList(Date,Time)) Q:Time=""
					s ind=0 for{
						s ind=$O(ExecList(Date,Time,ind)) Q:ind=""
						s BaseDoseQty=ExecList(Date,Time,ind).AdminQty
						s BaseDoseQtySum=BaseDoseQtySum+BaseDoseQty
					}
				}
			}
			s OrderPackQty = BaseDoseQtySum / convFac
			
		}
	}
	if (BillingUOMDR=BaseUOMRowid)||(OrderPackQty=""){
		s BaseQty=OrderPackQty
	}else{
		//s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimId)
		if (DrgformRowid'=""){
			if ($g(BaseQty)="") {
				s leq=0 
				for {
					s leq=$o(^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),"EQ",leq)) q:leq=""
					s eqrec=^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),"EQ",leq)
					s FormDoseUOMRowid=$p(eqrec,"^")
					if (FormDoseUOMRowid=BillingUOMDR){
						s convFac=$p(eqrec,"^",2)
						s BaseQty=OrderPackQty/convFac
						Q 
					}
				}
				if (+leq=0){
					s BaseQty=OrderPackQty*convFac
				}
			}
		}else{
			;获取账单数量
			s BillQty=0,BilledFlag=0
			s pbrowid=0
			f  {
				s pbrowid=$o(^DHCPBi(0,"OEORI",OEOrdItem,pbrowid)) 
				q:pbrowid=""
				continue:$d(^DHCPB(pbrowid))=10
				continue:$d(^DHCPB(pbrowid))=0
				s confdr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",+pbrowid,""))
				s pb=pbrowid  
				s pbosub=0
				f  {
					s pbosub=$o(^DHCPBi(0,"OEORI",OEOrdItem,pbrowid,pbosub))
					q:pbosub=""
					continue:$d(^DHCPB(pbrowid,"O",pbosub))=10
					s pbo=^DHCPB(pbrowid,"O",pbosub)
					s pbbillqty=$p(pbo,"^",5)
					s pbrefundqty=$p(pbo,"^",6)
					s BillQty=BillQty+pbbillqty+pbrefundqty
					s BilledFlag=1
				}
			}
			///住院多部位检查医嘱不走账单表数量
			if ((##class(web.DHCDocOrderCommon).GetItemServiceFlag(ArcimId)="1")&&((AdmType="I"))){
				s BaseQty=OrderPackQty
				}else{
				if (BilledFlag=1) {s OrderPackQty=BillQty}
				s BaseQty=OrderPackQty
			}
		}
	}
	///------------------获取实发数量
	;获取打包表中的发药数量
	s DSPQty=0,TotalQty=0,DSPStatus="",DSPStatusList=""
	if (HaveDispensing=1){
		s dis=0  
		f  {
			s dis=$O(^DHCOEDISQTY(0,"OEORI",OEOrdItem,dis))
			q:dis=""
			s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
			s dspQty=$p(^DHCOEDISQTY(dis),"^",5) 
			s DSPStatusList=DSPStatusList_dstatus
			if (dstatus="C"){
				i DSPStatus="" s DSPStatus="已发"
				s DSPQty=DSPQty+dspQty
			}elseif (dstatus="R"){
				s DSPStatus="已发"
				s DSPQty=DSPQty-dspQty
			}
		}
		if (DSPStatusList["R"){
			if (DSPQty=0){
				s DSPStatus="全退"
			}else{
				s DSPStatus="部分退"
			}
		}elseif (DSPStatusList["TC"){
			if (DSPQty=0){
				s DSPStatus="未发"
			}else{
				s DSPStatus="部分发"
			}
		}else{
			s DSPStatus="已发"
		}
	}
	if (OrderType="R"){
		s ConfirmQtyInfo=##class(PHA.FACE.OUT.Com).GetOeoriQtyInfoForDoc(OEOrdItem)
		s ActiveQty=$P(ConfirmQtyInfo,"^",1) //实际发药数量
		s BaseUOMDesc=$P(ConfirmQtyInfo,"^",2)
		s DSPStatus=$P(ConfirmQtyInfo,"^",3)
	}elseif (HaveDispensing=1){
		s ActiveQty=DSPQty
		s DSPStatus=""
	}else{
		s ActiveQty=0
		s DSPStatus=""
	}
	if (ActiveQty<0) s ActiveQty=0
	s:(OrderPackQty'="") OrderPackQty=$j(OrderPackQty,"",2)
	s:OrderPackQty'="" BaseQty=$j(BaseQty,"",2)
	s:OrderPackQty'="" ActiveQty=$j(ActiveQty,"",2)
	Set langid=..%LanguageID()
	s PackUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",PackUOMDesc,langid)
	s BaseUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",BaseUOMDesc,langid)
	//数量^单位^单位ID^数量(换算成基本单位)^基本单位^单位ID^实发数量^实发数量单位^发药状态
	Q OrderPackQty_"^"_PackUOMDesc_"^"_BillingUOMDR_"^"_BaseQty_"^"_BaseUOMDesc_"^"_BaseUOMRowid_"^"_ActiveQty_"^"_BaseUOMDesc_"^"_DSPStatus
}

/*

/// 根据医嘱ID获取医嘱数量信息
/// 出参: 数量^单位^单位ID^数量(换算成基本单位)^基本单位^单位ID^实发数量^实发数量单位^发药状态
/// w ##class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo()
ClassMethod GetOrdPackQtyInfoBak(OEOrdItem As %String) As %String
{
	s AdmId=$p(^OEORD(+OEOrdItem),"^",1)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(AdmId)
	s ArcimId=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1)),"^",2)
	s Phcdf=$P($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",12)
	s ItemCatDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s DoseUnitID=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),2)),"^",3)
	s DoseUnit=""
	s:DoseUnitID'="" DoseUnit=$p(^CT("UOM",DoseUnitID),"^",2)
	s PackUOMDesc="" //整包装单位
	s BillingUOMDR=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),8),"^",14)
	if BillingUOMDR'="" {
		s PackUOMDesc=$p(^CT("UOM",BillingUOMDR),"^",2)
	}
	;协议单位
	s ProtocolPackUOMDR=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),"DHC")),"^",13)
	i ProtocolPackUOMDR'="" {
		s BillingUOMDR=ProtocolPackUOMDR
		s PackUOMDesc=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
	}
	s convFac=##class(appcom.OEDispensing).convFac(ArcimId,BillingUOMDR)
	;基本单位
	s BaseUOMDesc="",BaseUOMRowid="" 
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimId)
	i INCIRowid'="" {
		; INCI_CTUOM_DR  库存基本单位
		s BaseUOMRowid=$p($g(^INCI(INCIRowid,1)),"^",10)
		s BaseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BaseUOMRowid)
	}
	;草药取药学项单位
	s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(ArcimId)
	if (CheckCHNFlag="Y") { 
		if (Phcdf'=""){
			s BillingUOMDR=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
			s PackUOMDesc=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
			s BaseUOMDesc=PackUOMDesc,BaseUOMRowid=BillingUOMDR
		}
	}
	;整包装数量(医嘱录入界面数量)
	s OrderPackQty=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),9)),"^",4)
	s DoseqtySum=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1)),"^",12)
	if (OrderType'="R"){
		;非药品医嘱
		s OrderPackQty=DoseqtySum
	}
	s HaveDispensing=0
	if $D(^DHCOEDISQTY(0,"OEORI",OEOrdItem)){
		s HaveDispensing=1
	}
	;退药数量
	s DspConfirmQty=""
	;实际发药数量
	s ConfirmQty=""
	if (OrderType="R"){
		s dis=0  
		f  {
			s dis=$O(^DHCOEDISQTY(0,"OEORI",OEOrdItem,dis))
			q:dis=""
			s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
			//退药数量
			i dstatus="R" {
				s DSPBChildsub="0"
				for{
					s DSPBChildsub=$O(^DHCOEDISQTY(dis,"I",DSPBChildsub))
					q:DSPBChildsub=""
					s dconfirmqty=$p(^DHCOEDISQTY(dis,"I",DSPBChildsub),"^",2)
					if (CheckCHNFlag="Y"){
						S Phcdf=$P($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",12)
						s BillingUOMDR=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
						s IncID=$p(^DHCOEDISQTY(dis,"I",DSPBChildsub),"^",5)
						s UomID=$p(^INCI(IncID,1),"^",10)
						s FindConFac=##class(web.DHCSTINTERFACE).UOMFac(UomID,BillingUOMDR)
						s dconfirmqty=dconfirmqty*FindConFac
						s DspConfirmQty=DspConfirmQty+dconfirmqty
					}else{
						s DspConfirmQty=DspConfirmQty+dconfirmqty
					}
				}
			}
			//发药数量
			i dstatus="C" {
				s DSPBChildsub="0"
				for{
					s DSPBChildsub=$O(^DHCOEDISQTY(dis,"I",DSPBChildsub))
					q:DSPBChildsub=""
					s dconfirmqty=$p(^DHCOEDISQTY(dis,"I",DSPBChildsub),"^",2)
					if (CheckCHNFlag="Y"){
						S Phcdf=$P($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",12)
						s BillingUOMDR=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
						s IncID=$p(^DHCOEDISQTY(dis,"I",DSPBChildsub),"^",5)
						s UomID=$p(^INCI(IncID,1),"^",10)
						s FindConFac=##class(web.DHCSTINTERFACE).UOMFac(UomID,BillingUOMDR)
						s dconfirmqty=dconfirmqty*FindConFac
						s ConfirmQty=ConfirmQty+dconfirmqty
					}else{
						s ConfirmQty=ConfirmQty+dconfirmqty
					}
				}
			}
		}
	}else{
		;已收费或急诊留观押金模式,根据账单取
		s OrdBilled=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),3)),"^",5)
		s StayStatus=0
		s PatCurStat=##class(web.DHCADMVisitStat).GetStayStatus(AdmId)
		i " 1 2 "[(" "_PatCurStat_" ") s StayStatus=1
		s StayPayMode=##class(web.DHCBillInterface).IStayPayModeByEpisodeID()
		if ("^B^TB^")'[("^"_OrdBilled_"^")||((StayPayMode="1")&&(StayStatus="1")){
			s pbrowid=0,PBFlag=0
			f  {
				s pbrowid=$o(^DHCPBi(0,"OEORI",OEOrdItem,pbrowid)) 
				q:pbrowid=""
				continue:$d(^DHCPB(pbrowid))=10
				continue:$d(^DHCPB(pbrowid))=0
				s confdr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",+pbrowid,""))
				s pb=pbrowid  
				s pbosub=0
				f  {
					s pbosub=$o(^DHCPBi(0,"OEORI",OEOrdItem,pbrowid,pbosub))
					q:pbosub=""
					continue:$d(^DHCPB(pbrowid,"O",pbosub))=10
					s pbo=^DHCPB(pbrowid,"O",pbosub)
					s pbbillqty=$p(pbo,"^",5)
					s pbrefundqty=$p(pbo,"^",6)
					s DspConfirmQty=DspConfirmQty+pbrefundqty
					s ConfirmQty=ConfirmQty+pbbillqty
					s PBFlag=1
				}
			}
			if (+PBFlag=0) {
				s dis=0  
				f  {
					s dis=$O(^DHCOEDISQTY(0,"OEORI",OEOrdItem,dis))
					q:dis=""
					s dstatus1=$p(^DHCOEDISQTY(dis),"^",7)
					if (dstatus1="TC") s ConfirmQty=0
					//if (dstatus1="R") s ConfirmQty=0
				}
			}
		}
	}
	;取绝对值
	s DspConfirmQty=$ZABS(DspConfirmQty)
	s ConfirmQty=$ZABS(ConfirmQty)
	;发药状态
	s dstatus=""
	if (OrderType="R"){
		;实际发药数量
		;退药数量
		s PHDIPHDPARREF=0,PHDIQTYSum=0,phdiretqtySum=0
		for {
			s PHDIPHDPARREF=$o(^DHCPHDI(0,"OEORI",OEOrdItem,PHDIPHDPARREF)) 
			q:PHDIPHDPARREF=""
			s PHDICHILDSUB=0
			for {
				 s PHDICHILDSUB=$o(^DHCPHDI(0,"OEORI",OEOrdItem,PHDIPHDPARREF,PHDICHILDSUB)) 
				 q:PHDICHILDSUB=""
				 s PHDICCHILDSUB=""
				 for{
					 s PHDICCHILDSUB=$O(^DHCPHDI(PHDIPHDPARREF,"PHDI",PHDICHILDSUB,"INCLB",PHDICCHILDSUB))
					 q:PHDICCHILDSUB=""
					 s PHDIQTY=$p(^DHCPHDI(PHDIPHDPARREF,"PHDI",PHDICHILDSUB,"INCLB",PHDICCHILDSUB),"^",1)
					 s phdiretqty=+$p(^DHCPHDI(PHDIPHDPARREF,"PHDI",PHDICHILDSUB,"INCLB",PHDICCHILDSUB),"^",2)
					 if (CheckCHNFlag="Y"){
						 s DSPBDR=$p(^DHCPHDI(PHDIPHDPARREF,"PHDI",PHDICHILDSUB,"INCLB",PHDICCHILDSUB),"^",9)
						 S Phcdf=$P($g(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1)),"^",12)
						 s BillingUOMDR=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
						 s IncID=$p(^DHCOEDISQTY(+DSPBDR,"I",$P(DSPBDR,"||",2)),"^",5)
						 s UomID=$p(^INCI(IncID,1),"^",10)
						 s FindConFac=##class(web.DHCSTINTERFACE).UOMFac(UomID,BillingUOMDR)
						 s PHDIQTY=PHDIQTY*FindConFac
						 s phdiretqty=phdiretqty*FindConFac
						 s PHDIQTYSum=PHDIQTYSum+PHDIQTY
						 s phdiretqtySum=phdiretqtySum+phdiretqty
					 }else{
						s PHDIQTYSum=PHDIQTYSum+PHDIQTY
						s phdiretqtySum=phdiretqtySum+phdiretqty}
					 }
			}
		}
		if (PHDIQTYSum'=0){
			//退药数量为0
			if (phdiretqtySum=0){
				if (ConfirmQty>PHDIQTYSum) s dstatus="部分发"
				if (PHDIQTYSum=ConfirmQty) s dstatus="全发"
				if (ConfirmQty=0) s dstatus="未发"
			}else{
				if (PHDIQTYSum=phdiretqtySum) s dstatus="全退"
				if (PHDIQTYSum>phdiretqtySum) s dstatus="部分退"
			}
		}else{
			s dstatus="未发"
		}
		s ConfirmQty=PHDIQTYSum-phdiretqtySum //实际发药数量
	}elseif (HaveDispensing=1){
		;物资那边发放不发放模式，走的全局配置，测试组来回改这个配置导致数据显示混乱，非药品不再显示发药状态
		s ConfirmQty=ConfirmQty-DspConfirmQty
	}
	i DspConfirmQty'="" {
		s DspConfirmQty=DspConfirmQty_BaseUOMDesc
	}
	;实发数量
	s ActiveQty=""
	s Pqty=""
	if (AdmType="I"){
		s PriorityDR=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1)),"^",8)
		s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
		if (ISLongOrderPrior){
			s DoseQty=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),2)),"^",1)
			s OrderPackQty=DoseQty
			s Pqty=DoseQty
			s PackUOMDesc=DoseUnit
			s BillingUOMDR=DoseUnitID
		}else{
			if (OrderPackQty'=""){
				s Pqty=OrderPackQty
			}else{
				s OrderPackQty=DoseqtySum
				s Pqty=DoseqtySum
				s PackUOMDesc=DoseUnit
				s BillingUOMDR=DoseUnitID
			}
		}
		i $D(^DHCOEDISQTY(0,"OEORI",OEOrdItem)) {
			s ActiveQty=ConfirmQty 
			s Pqty=ActiveQty
		}else{
			s pbrowid=0,pqty=0
			f  {
				s pbrowid=$o(^DHCPBi(0,"OEORI",OEOrdItem,pbrowid)) 
				q:pbrowid=""
				continue:$d(^DHCPB(pbrowid))=10 
				continue:$d(^DHCPB(pbrowid))=0 
				s confdr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",+pbrowid,""))
				s pb=pbrowid  
				s pbosub=0
				f  {
					s pbosub=$o(^DHCPBi(0,"OEORI",OEOrdItem,pbrowid,pbosub))
					q:pbosub=""
					continue:$d(^DHCPB(pbrowid,"O",pbosub))=10
					s pbo=^DHCPB(pbrowid,"O",pbosub)
					s pbbillqty=$p(pbo,"^",5)
					s pbrefundqty=$p(pbo,"^",6)
					s pqty=pqty+pbbillqty+pbrefundqty
				}
			}
			i +pqty'=0 s Pqty=pqty
			e  s Pqty=$p(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1),"^",12)
			s ActiveQty=Pqty
		}
	}else{
		;如果没有填数量则自动计算数量
		i ((+OrderPackQty=0)&&(OrderType="R"))  {
			s drgformId=$P(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1),"^",12)
			s DoseQty=$p(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),2),"^",1)
			s DuraDR=$p(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),2),"^",6)
			s PHFreqDR=$p(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),2),"^",4)
			s OrderFreqDispTimeStr=""
			if (PHFreqDR'="") {
				s WeekFlag=$P(^PHCFR(PHFreqDR),"^",9)
				if (WeekFlag="Y") {
					s OrderFreqWeek=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),"DHC")),"^",55)
					//周频次
					s OrderFreqDispTimeStr=##class(web.DHCOEOrdItem).GetOrderFreqDispTimeStr(PHFreqDR,OrderFreqWeek)
				}
			}
			k OrderFreqTimeDoseArr
			//同频次不同剂量
			s OrderFreqTimeDoseStr=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),"DHC")),"^",59)
			if (OrderFreqTimeDoseStr'=""){
				s BaseDoseQty=0
		        s Len=$l(OrderFreqTimeDoseStr,"!")
		        for i=1:1:Len{
			        s OneFreqDispTimeDose=$p(OrderFreqTimeDoseStr,"!",i)
			        s OneDoseQty=$p(OneFreqDispTimeDose,"$",2)
			        s OneBaseDoseQty = ##Class(web.DHCDocOrderEntry).CalDose(DoseUnitID, drgformId, OneDoseQty)
			        s BaseDoseQty=BaseDoseQty+(+OneBaseDoseQty)
			        s OrderFreqTimeDoseArr(i)=OneBaseDoseQty
			    }
			}else{
				s BaseDoseQty=##Class(web.DHCDocOrderEntry).CalDose(DoseUnitID,drgformId,DoseQty)
			}
			s OrderPackQty=0
			s BaseDoseQtySum=0
			s OrderFirstDayTimes=$p($G(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1)),"^",18)
			s OrderStarDate=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1)),"^",9) ;医嘱开始日期
			i DuraDR'="" {
				s FreqFactor=$P(^PHCFR(PHFreqDR),"^",2)
				s DuraFactor=$P(^PHCDU(DuraDR),"^",2)
				if OrderFreqDispTimeStr'="" {
					s NumTimes=##class(web.DHCOEOrdItemView).GetCountByFreqDispTime(OrderFreqDispTimeStr, OrderStarDate, DuraFactor,OrderFirstDayTimes)
				}else{
					//i +OrderFirstDayTimes>0 s NumTimes=FreqFactor*(DuraFactor-1)+OrderFirstDayTimes
					//e  s NumTimes=FreqFactor*DuraFactor
					
					if ($d(OrderFreqTimeDoseArr)) {
		                if (OrderFirstDayTimes>0) {
			                s NumTimes=1
			                s:DuraFactor>=1 BaseDoseQtySum=BaseDoseQty*(DuraFactor-1)
			                for i=1:1:OrderFirstDayTimes {
				                s index=$o(OrderFreqTimeDoseArr(""),-1)-OrderFirstDayTimes+i
				                s BaseDoseQtySum=BaseDoseQtySum+$g(OrderFreqTimeDoseArr(index))
				            }
			            }else{
				            s NumTimes=DuraFactor
				        }
		            }else{
						if (OrderFirstDayTimes>0){
							s NumTimes=FreqFactor * (DuraFactor-1)+OrderFirstDayTimes
						}else{
							s NumTimes=FreqFactor * DuraFactor
						}
					}
					
				}
				if (BaseDoseQtySum=0) {
	            	s BaseDoseQtySum = BaseDoseQty * NumTimes
	            }
				
	            if (OrderFreqTimeDoseStr'=""){
	            	s OrderPackQty = BaseDoseQtySum / convFac	// / FreqFactor
	            }else{
		            s OrderPackQty = BaseDoseQtySum / convFac
		        }
		        b ;
				//s OrderPackQty=+Qty*FreqFactor*$P(^PHCDU(DuraDR),"^",2)
			}
		}
		i $D(^DHCOEDISQTY(0,"OEORI",OEOrdItem)) {
			s ActiveQty=ConfirmQty 
			s Pqty=ActiveQty
		}else{
			s pbrowid=0,pqty=0
			f  {
				s pbrowid=$o(^DHCPBi(0,"OEORI",OEOrdItem,pbrowid)) 
				q:pbrowid=""
				continue:$d(^DHCPB(pbrowid))=10 
				continue:$d(^DHCPB(pbrowid))=0 
				s confdr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",+pbrowid,""))
				s pb=pbrowid  
				s pbosub=0
				f  {
					s pbosub=$o(^DHCPBi(0,"OEORI",OEOrdItem,pbrowid,pbosub))
					q:pbosub=""
					continue:$d(^DHCPB(pbrowid,"O",pbosub))=10
					s pbo=^DHCPB(pbrowid,"O",pbosub)
					s pbbillqty=$p(pbo,"^",5)
					s pbrefundqty=$p(pbo,"^",6)
					s pqty=pqty+pbbillqty+pbrefundqty
				}
			}
			//i +pqty'=0 s Pqty=pqty
			//e  s Pqty=$p(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1),"^",12)
			s ActiveQty=pqty
		}
		s OrdStatusCode=""
		s OrdStatusDR=$p(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1),"^",13)
		s:$g(OrdStatusDR)'="" OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
		if (OrdStatusCode="D") {
			s RePay=##class(web.DHCBillInterface).IOrdItmInvStatusByOeoriDR(OEOrdItem)
			s RePay=$p(RePay,"^")
			i " 0 1 2 "[(" "_RePay_" ") s RePay=$Case(RePay,"0":"","1":"部分退费","2":"全部退费")
			s isStop=((OrdStatusCode="D")&(RePay'="部分退费")&&(RePay'="")&(dstatus'="部分退")&&(dstatus'="全发"))||((OrdStatusCode'="V")&(OrdStatusCode'="E")&(OrdStatusCode'="D"))
			if (isStop){
				s ActiveQty=0
			}
		}
	}
	if (BillingUOMDR=BaseUOMRowid){
		s BaseQty=OrderPackQty
	}else{
		s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimId)
		if (DrgformRowid'=""){
			s leq=0 
			for {
				s leq=$o(^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),"EQ",leq)) q:leq=""
				s eqrec=^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),"EQ",leq)
				s FormDoseUOMRowid=$p(eqrec,"^")
				if (FormDoseUOMRowid=BillingUOMDR){
					s convFac=$p(eqrec,"^",2)
					s BaseQty=OrderPackQty/convFac
					Q 
				}
			}
			if (+leq=0){
				s BaseQty=OrderPackQty*convFac
			}
		}else{
			s BaseQty=OrderPackQty
		}
	}
	if (ActiveQty<0) s ActiveQty=0
	s OrderPackQty=$j(OrderPackQty,"",2)
	s BaseQty=$j(BaseQty,"",2)
	s ActiveQty=$j(ActiveQty,"",2)
	//数量^单位^单位ID^数量(换算成基本单位)^基本单位^单位ID^实发数量^实发数量单位^发药状态
	Q OrderPackQty_"^"_PackUOMDesc_"^"_BillingUOMDR_"^"_BaseQty_"^"_BaseUOMDesc_"^"_BaseUOMRowid_"^"_ActiveQty_"^"_BaseUOMDesc_"^"_dstatus
}
*/
/// 得到当前日期的发药状态
/// 如果是长嘱 取日期里的执行记录里的数据，判断是否发药
/// 临嘱或出院带药等 取医嘱对应的执行记录的发药状态
ClassMethod GetdsStatusDate(OEOrdItem As %String, NowDate As %String = "")
{
	q:OEOrdItem="" ""
	s OrdId1=+OEOrdItem
	s OrdId2=$P(OEOrdItem,"||",2)
	if NowDate="" s NowDate=..%SysDate()
	s PriorityDR=$p($g(^OEORD(OrdId1,"I",OrdId2,1)),"^",8)
	s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
	s rtn=""
	s dstatusStr=""
	if (ISLongOrderPrior){
		s OEOREChildsub=""
		for{
			s OEOREChildsub=$O(^OEORDi(0,"OrdItem",OrdId1,OrdId2,NowDate,OEOREChildsub))
			q:OEOREChildsub=""
			s OEOrdExec=OrdId1_"||"_OrdId2_"||"_OEOREChildsub
			s dis=0  
			f  {	
				s dis=$O(^DHCOEDISQTY(0,"OEORE",OEOrdExec,dis))
				q:dis=""
				s dstatus1=$p(^DHCOEDISQTY(dis),"^",7)
				if (dstatusStr=""){s dstatusStr=dstatus1}else{s dstatusStr=dstatusStr_"^"_dstatus1}
			}
		}
	}else{
		s OEOREChildsub=""
		for{
			s OEOREChildsub=$O(^OEORD(OrdId1,"I",OrdId2,"X",OEOREChildsub))
			q:OEOREChildsub=""
			s OEOrdExec=OrdId1_"||"_OrdId2_"||"_OEOREChildsub
			s dis=0  
			f  {	
				s dis=$O(^DHCOEDISQTY(0,"OEORE",OEOrdExec,dis))
				q:dis=""
				s dstatus1=$p(^DHCOEDISQTY(dis),"^",7)
				if (dstatusStr=""){s dstatusStr=dstatus1}else{s dstatusStr=dstatusStr_"^"_dstatus1}
			}
		}
	}
	s dstatusStr="^"_dstatusStr_"^"
	if (dstatusStr["^R^"){
		s rtn="已退药"
	}
	if ((dstatusStr["^C^")&&(dstatusStr'["^R^")){
		s rtn="已发"
	}
	if (dstatusStr["^TC^"){
		s rtn="未发"
	}
	q rtn
}

/// 获取病人慢病信息串
Query LookUpChronicDiag(desc As %String, EpisodeID As %String) As %Query(ROWSPEC = "Code:%String,Desc:%String,Type:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocQryOEOrder","LookUpChronicDiag","","415")
ClassMethod LookUpChronicDiagExecute(ByRef qHandle As %Binary, desc As %String, EpisodeID As %String) As %Status
{
	s ^tan("LookUpChronicDiag")=desc_","_EpisodeID
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	;患者慢病信息
	s ChronicErrMsg=""
	s PatientNo=##Class(web.PAPatMas).GetRegistration(PatientID) 
	s PatYBCode=$p($g(^PAPER(PatientID,"PAT",3)),"^",12)
	s AdmReasonDR=$p(^PAADM(EpisodeID,1),"^",7)
	
	s AdmDepId=$P($G(^PAADM(EpisodeID)),"^",4)
	s HospitalID=$p(^CTLOC(AdmDepId),"^",22)
	i HospitalID="" s HospitalID=$O(^CT("HOSP",0))
	s HospCode=$P(^CT("HOSP",HospitalID),"^",1)
	k ChronicList
	Set langid=..%LanguageID()
	s i=0
	Set rs=##Class(%ResultSet).%New("insuqc.service.ServicePort:GetChronicList")
	If rs.QueryIsValid() {
		Set Status=rs.Execute(PatientNo, PatYBCode,AdmReasonDR,HospCode)
		If 'Status Quit
		While (rs.Next()) {
			s Code=rs.GetData(1)
			s Desc=rs.GetData(2)
			s Type=rs.GetData(3)
			s Type=$CASE(Type,"1":"慢病","2":"特病")
			s Type=..%Translate("oeorder.oplistcustom.new.csp",Type,langid)
			s i=i+1
			s ChronicList(i)=$lb(Code,Desc,Type)
		}
		d rs.Close()
	}
	
	Set ind=1
	Set repid=$I(^CacheTemp)
	s i=""
	for {
		s i=$O(ChronicList(i))
		q:(i="")
		s Data=ChronicList(i)
		d GetChronicDiag
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetChronicDiag
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod LookUpChronicDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpChronicDiagExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpChronicDiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpChronicDiagExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
