/// creator:王清雍
/// date:2021-03-31
/// desc:医嘱录入获取后台数据的公共类
Class DHCDoc.Order.Common Extends DHCDoc.Util.RegisteredObject
{

/// 获取科室就诊类型
ClassMethod GetLocAdmType(LocID)
{
	Q:LocID="" "O"
	Q:##class(web.DHCOPAdmReg).IsEmergency(LocID) "E"
	Q:$D(^PAC("ADMLOC",0,"AdmType","I",LocID)) "I"
	s LocType=$P(^CTLOC(LocID),"^",13)
	Q:LocType="W" "I"
	Q "O"
}

/// 取登录科室医生可用医嘱优先级
ClassMethod GetOrderPriorJSON(EpisodeID, LocID = "", UserID = "", GroupID = "", DefPriorType = "", EmConsultItm = "", langid As %String = "")
{
	s rows=[]
	s:langid="" langid=..%LanguageID()
	s SessionStr=..%SessionStr()
	if SessionStr'="" {
        s:UserID="" UserID=$P(SessionStr,"^",1)
        s:GroupID="" GroupID=$P(SessionStr,"^",2)
        s:LocID="" LocID=$P(SessionStr,"^",3)
    }
	s INAdmTypeLoc=##class(web.DHCDocOrderCommon).CheckINAdmTypeLoc(LocID,EpisodeID,EmConsultItm)
	if INAdmTypeLoc="Y"{
		s PriorCodeArr=["S","NORM"]
	}else{
		s PriorCodeArr=["NORM"]
	}
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s VisitStatus=$p($g(^PAADM(+EpisodeID)),"^",20)
	if (PAAdmType="I")&&(INAdmTypeLoc="Y")&&(VisitStatus'="P"){
		s DoctorType=##class(web.SSUser).GetDefaultCareProviderType(UserID)
		if DoctorType="DOCTOR"{
			d PriorCodeArr.%Push("OUT")
		}
	}
	s DefFind=0
	for i=1:1:PriorCodeArr.%Size(){
		s OrderPriorCode=PriorCodeArr.%Get(i-1)
		s OrderPriorRowid=$O(^OECPR(0,"Code",OrderPriorCode,0))
		s OrderPrior=$P(^OECPR(OrderPriorRowid),"^",2)
		s OrderPrior=##class(User.OECPriority).GetTranByDesc("OECPRDesc",OrderPrior,langid)
		s OrderPriorType=..GetPriorTypeByID(OrderPriorRowid)
		s selected=0
		if DefPriorType=OrderPriorType s selected=1,DefFind=1
		s row={"id":(OrderPriorCode),"rowid":(OrderPriorRowid),"text":(OrderPrior),"code":(OrderPriorCode),"type":(OrderPriorType),"selected":(selected)}
		d rows.%Push(row)
		
	}
	if 'DefFind{
		s DefaultOrderPriorRowid=..GetDefaultOrderPrior(EpisodeID, LocID,UserID, GroupID,EmConsultItm)
		for i=rows.%Size():-1:1{
			s row=rows.%Get(i-1)
			if (DefaultOrderPriorRowid=row.rowid)||(i=1){
				s row.selected=1
				Q
			}
		}
	}
	Q rows.%ToJSON()
}

/// 默认医嘱优先级
ClassMethod GetDefaultOrderPrior(EpisodeID, LocID, UserID, GroupID, EmConsultItm = "")
{
	s HospID=$P(^CTLOC(LocID),"^",22)
	s DefaultOrderPriorRowid=""	;$O(^OECPR(0,"Code","NORM",0))
	if "Y"=##class(web.DHCDocOrderCommon).CheckINAdmTypeLoc(LocID,EpisodeID,EmConsultItm){
		s DefPriorType=##class(web.DHCDocConfig).GetUserPageSetting("OrderEntry","obj",UserID,GroupID).DefPriorType
		s DefaultOrderPriorRowid=..GetPriorIDByType(DefPriorType)
		if DefaultOrderPriorRowid=""{
			s IPDefaultPriorShort=##Class(web.DHCDocConfig).GetConfigNode("IPDefaultPriorShort",HospID)
			if IPDefaultPriorShort'=1 s DefaultOrderPriorRowid=$O(^OECPR(0,"Code","S",0))
		}
	}
	s:DefaultOrderPriorRowid="" DefaultOrderPriorRowid=$O(^OECPR(0,"Code","NORM",0))
	Q DefaultOrderPriorRowid
}

/// 取医嘱优先级的类型 ShortOrderPrior LongOrderPrior OutOrderPrior
ClassMethod GetPriorTypeByID(OrderPriorRowid)
{
	s OrderPriorCode=$P(^OECPR(OrderPriorRowid),"^",1)
	Q $SELECT(OrderPriorCode["OUT":"OutOrderPrior",(OrderPriorCode["S")||(OrderPriorCode["CQ"):"LongOrderPrior",1:"ShortOrderPrior")
}

ClassMethod GetPriorIDByType(Code)
{
	Q $CASE(Code,"LongOrderPrior":$O(^OECPR(0,"Code","S",0)),
				 "OutOrderPrior":$O(^OECPR(0,"Code","OUT",0)),
				 "ShortOrderPrior":$O(^OECPR(0,"Code","NORM",0)),:"")
}

/// 是否长期医嘱
ClassMethod IsLongOrdItem(OrdItemID)
{
	s PriorRowid=$P($G(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1)),"^",8)
	Q:PriorRowid="" 0
	Q ##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)
}

/// 是否临时医嘱
ClassMethod IsShortOrdItem(OrdItemID)
{
	s PriorRowid=$P($G(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1)),"^",8)
	Q:PriorRowid="" 1
	Q ##class(appcom.OEOrdItem).ISShortOrderPrior(PriorRowid)
}

/// 是否出院带药医嘱
ClassMethod IsOutOrdItem(OrdItemID)
{
	s PriorRowid=$P($G(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1)),"^",8)
	Q:PriorRowid="" 0
	s PriorCode=$p($g(^OECPR(PriorRowid)),"^",1)
	Q PriorCode="OUT"
}

/// 是否取药医嘱
ClassMethod IsTakeDrugOrdItem(OrdItemID)
{
	s PriorRowid=$P($G(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1)),"^",8)
	Q:PriorRowid="" 0
	s PriorCode=$p($g(^OECPR(PriorRowid)),"^",1)
	Q PriorCode="ONE"
}

/// 是否草药频次
ClassMethod IsCNFreq(FreqRowid)
{
	s PHCFRDesc2=$P($G(^PHCFR(+FreqRowid)),"^",4)
	Q PHCFRDesc2="饮片"
}

ClassMethod IsCNOrdItem(OrdItemID, HospID = "") As %Boolean
{
	Q:OrdItemID="" 0
	s PAQue1RowID=$O(^PAQUE1(0,"DHCPAQue","AddLongOrderID",OrdItemID,0))
	if (PAQue1RowID'=""){
		s CMOrderRowId=$P($G(^PAQUE1(PAQue1RowID,"DHC")),"^",34)
		Q:CMOrderRowId'="" ..IsCNOrdItem(CMOrderRowId,HospID)
	}
	s ARCIMRowid=$P(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1),"^",2)
	Q ##class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowid,HospID)
}

/// 取医嘱的医嘱类型
ClassMethod GetOrdItemType(OrdItemID)
{
	s ArcimRowid=$P($G(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1)),"^",2)
	Q:ArcimRowid="" ""
	Q ##class(web.DHCDocOrderCommon).GetOrderType(ArcimRowid)
}

/// 获取医嘱状态代码
ClassMethod GetOrdStatusCode(OrdItemID)
{
	s ItmStatID=$p($g(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1)),"^",13)
	Q:ItmStatID="" ""
	Q $p($g(^OEC("OSTAT",ItmStatID)),"^",1)
}

/// 是否为有效医嘱(核实、执行、住院的停止)
ClassMethod IsValidOrd(OrdItemID)
{
	s StatusCode=..GetOrdStatusCode(OrdItemID)
	Q:StatusCode="" 0
	Q:"VE"[StatusCode 1
	if StatusCode="D"{
		s EpisodeID=$P(^OEORD(+OrdItemID),"^",1)
		s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
		Q:(AdmType="I")&&(..ExistValidExec(OrdItemID)) 1
	}
	Q 0
}

/// 检查医嘱指定时间范围内是否存在有效执行记录
ClassMethod ExistValidExec(OrdItemID, SttDate = "", EndDate = "")
{
	s Find=0
	s Ord=+OrdItemID,Sub=$P(OrdItemID,"||",2)
	s SttDate=..%ZDH(SttDate),EndDate=..%ZDH(EndDate)
	s Date=$CASE(SttDate,"":"",:SttDate-1)
	for{
		s Date=$O(^OEORDi(0,"OrdItem",Ord,Sub,Date)) Q:(Date="")||((EndDate'="")&&(Date>EndDate))
		s XSub=0 for{
			s XSub=$O(^OEORDi(0,"OrdItem",Ord,Sub,Date,XSub)) Q:XSub=""
			s StatusID=$p(^OEORD(Ord,"I",Sub,"X",XSub),"^",16)
			s StatusCode=$p($G(^OEC("STAT",+StatusID)),"^",1)
			continue:StatusCode="D"
			s Find=1
			Q
		}
		Q:Find
	}
	Q Find
}

/// w ##class(DHCDoc.Order.Common).GetTarList("109||19",2) 
/// Output:总价！收费项名称^数量单位^单价$c(2)收费项名称^数量单位^单价$c(2)收费项名称^数量单位^单价....
ClassMethod GetTarList(arcimrowid As %String, hospid As %String)
{
    s ^tempqujian("GetTarList")=$lb(arcimrowid, hospid )
    s oltarrayStr="",total=0
    s ItemCatRowid=$p($g(^ARCIM(+arcimrowid,$p(arcimrowid,"||",2),1)),"^",10)
	s OrderType=""
	i ItemCatRowid'="" s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	if (OrderType="R"){
		s inciDr=""
		s itmFlag=0
		for{
			s inciDr=$O(^INCI(0,"ARCIM_DR",+arcimrowid,inciDr))
			q:inciDr=""
			q:itmFlag=1
			s cltDr=0
			for {
				s cltDr=$O(^DHCINCTARi("INCI",inciDr,cltDr))
				q:cltDr=""
				s stDate=$P(^DHCINCTAR(cltDr),"^",4)
				s endDate=$P(^DHCINCTAR(cltDr),"^",5)
				continue:((+$H<stDate)||((endDate'="")&&(+$H>endDate)))
				s TarId=$P(^DHCINCTAR(cltDr),"^",2)
				s TarQty=$P(^DHCINCTAR(cltDr),"^",3)
				s TarCode=$p(^DHCTARI(TarId),"^",1) /// 收费项代码
				s TarDesc=$p(^DHCTARI(TarId),"^",2) /// 收费项描述
				s TarDesc=##class(User.DHCTarItem).GetTranByDesc("TARIDesc",TarDesc)
				s taruom=$p($g(^DHCTARI(TarId)),"^",3)
				s:taruom'="" taruom=$p($g(^CT("UOM",taruom)),"^",2),taruom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",taruom)
				s TarPrice=##class(web.DHCBL.CT.ARCItmMast).GetTariPrice(TarId,hospid)
				s ATarCost=TarPrice*TarQty
				s CNMedItemFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(arcimrowid,hospid)
				if (CNMedItemFlag="1"){
					s total=ATarCost
				}else{
					s total=ATarCost+total         /// 收费项目合计
				}
				s total=$fn(total,"",2)
				s TarPrice=$fn(TarPrice,"",2)
				i oltarrayStr="" s oltarrayStr=TarDesc_"^"_TarQty_taruom_"^"_TarPrice_"^"_total
				else  s oltarrayStr=oltarrayStr_$C(1)_TarDesc_"^"_TarQty_taruom_"^"_TarPrice_"^"_total
			}
		}	
	}else{
	    s olttariffdr=0 for  s olttariffdr=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr)) q:olttariffdr=""   d
	    .s startdate=0 for  s startdate=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr,startdate)) q:startdate=""  d
	    ..s associaterowid=0  for  s associaterowid=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr,startdate,associaterowid)) q:associaterowid=""  d
	    ...s tarDateTo=$p($g(^DHCOLT(associaterowid)),"^",5)
	    ...s arcimdr=$p($g(^DHCOLT(associaterowid)),"^",1)
	    ...s olttariffdr=$p($g(^DHCOLT(associaterowid)),"^",2)
	    ...s tarcode="",tardesc=""
	    ...s tarcode=$P($G(^DHCTARI(olttariffdr)),"^",1) 
	    ...s tardesc=$P($G(^DHCTARI(olttariffdr)),"^",2) 
	    ...s tardesc=##class(User.DHCTarItem).GetTranByDesc("TARIDesc",tardesc)
	    ...s tarnum=$p($g(^DHCOLT(associaterowid)),"^",3)
	    ...s taruom=$p($g(^DHCTARI(olttariffdr)),"^",3)
	    ...s:taruom'="" taruom=$p($g(^CT("UOM",taruom)),"^",2),taruom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",taruom)
	    ...s tarDate=$p($g(^DHCOLT(associaterowid)),"^",4)
	    ...s:tarDate'="" tarDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(tarDate)
	    ...s tarDateTo=$p($g(^DHCOLT(associaterowid)),"^",5)
	    ...q:((tarDateTo'="")&&(tarDateTo<+$h))
	    ...s:tarDateTo'="" tarDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(tarDateTo)         
	    ...s OLTBascPriceFlag=$p($g(^DHCOLT(associaterowid)),"^",8) //基价模式
	    ...s OLTBillOnceFlag=$p($g(^DHCOLT(associaterowid)),"^",9)  //多部位计价一次
	    ...s:OLTBascPriceFlag="" OLTBascPriceFlag="N"
	    ...s:OLTBillOnceFlag="" OLTBillOnceFlag="N"             
	    ...s tarprice=##class(web.DHCBL.CT.ARCItmMast).GetTariPrice(olttariffdr,hospid)
	    ...s total=tarnum*tarprice
	    ...s total=$fn(total,"",2)
		...s tarprice=$fn(tarprice,"",2)
	    ...i oltarrayStr="" s oltarrayStr=tardesc_"^"_tarnum_taruom_"^"_tarprice_"^"_total
	    ...else  s oltarrayStr=oltarrayStr_$C(1)_tardesc_"^"_tarnum_taruom_"^"_tarprice_"^"_total
	}
    q oltarrayStr
}

}
