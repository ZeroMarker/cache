Import SQLUser

/// 查询未检项目
Class web.DHCPE.Query.ItemNoCheck Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 31;

/// test d ##Class(%ResultSet).RunQuery("web.DHCPE.Query.ItemNoCheck","QueryOEItem","","","9","","","","")
/// d ##Class(%ResultSet).RunQuery("web.DHCPE.Query.ItemNoCheck","QueryOEItem","","","","","","^8569||1^8571||1^","")
/// 
Query QueryOEItem(RegNo As %Library.String = "", PatName As %Library.String = "", GID As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", OEList As %Library.String = "", OEStatus As %Library.String = "", NoCheckStatus As %Library.String = "") As %Query(ROWSPEC = "TGID:%String, TPAPMIDR:%String, TIADMDR:%String, TPAADMDR:%String, RowId:%String, TGName:%String, TRegNo:%String, TPatName:%String, TRegDate:%String, ItemId:%String, ItemDesc:%String, StatDesc:%String,TFactPrice:%String")
{
}

ClassMethod QueryOEItemExecute(ByRef qHandle As %Binary, RegNo As %Library.String = "", PatName As %Library.String = "", GID As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", OEList As %Library.String = "", OEStatus As %Library.String = "", NoCheckStatus As %Library.String = "") As %Status
{
	
	//w RegNo_","_PatName_","_GID_","_DateFrom_","_DateTo_","_OEList_","_OEStatus,!
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	s User=%session.Get("LOGON.USERID")
 	k ^DHCPETMPItemNoCheck(User,"ItemNoCheck")

 	Q:(""=RegNo)&(""=PatName)&(""=GID)&(""=DateFrom)&(""=DateTo) $$$OK
	s:(""'=RegNo) RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)

	k ^xwmTemp("OEItem")
	I DateFrom'="" s DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
	I DateTo'=""   s DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)
	// 查找所有客户 
	i ""=GID d
	.s GID="-1"
	.s id="0"
	.f  s id=$O(^DHCPEIADM(id)) Q:(id="")  d
	..s CurData=$G(^DHCPEIADM(id))
	..Q:(""=CurData)
	..
	..
	..// DHC_PE_IADM.{ IADM_PAADM_DR }
	..s PAADMDR=$P(CurData,"^",1)
	..Q:(""=PAADMDR)
	..
	..//只查询完成的检验 
	..//Q:(1'=##Class(web.DHCPE.Query.IAdmItemStatus).IsOrdItemsCompleted(PAADMDR))
	..// DHC_PE_IADM.{ IADM_Status }
	..//s Status=$P(CurData,"^",9)
	..//Q:'(("COMPLETED"=Status)||("ARRIVED"=Status)) 
	..
	..s Status=$P(CurData,"^",8)
	..q:"ARRIVED"'=Status
	..
	..// PAADM.{ PAADM_PAPMI_DR }
	..s PAPMIDR=$p($g(^PAADM(PAADMDR)),"^",1)	// 取患者信息
	..
	..// 登记号	PA_PatMas.{ PAPMI_IPNo }
	..s PAPMIIPNo=$p(^PAPER(PAPMIDR,"PAT",1),"^",1)
	..Q:(""'=RegNo)&(RegNo'=PAPMIIPNo)
	..
	..// 姓名		PA_PatMas.{PAPMI_Name}
	..s PAPMIName=$p(^PAPER(PAPMIDR,"ALL"),"^",1)	
    ..Q:(""'=PatName)&(PAPMIName'[PatName)
	..
	..// DHC_PE_IADM.{ IADM_RegDate }
	..s RegDate=+$P(CurData,"^",5)
	..Q:(""'=DateFrom)&(""'=RegDate)&(DateFrom>RegDate)
	..Q:(""'=DateFrom)&(""'=RegDate)&(DateTo<RegDate)
	..s:(""'=RegDate) RegDate=##class(websys.Conversions).DateLogicalToHtml(RegDate)
	..
	..// OE_Order.{OEORD_RowId}
	..s OEORDRowId=0 
	..s OEORDRowId=$O(^OEORD(0,"Adm",PAADMDR,OEORDRowId))
	..
	..Q:(""=OEORDRowId)
	..
	..s ^xwmTemp("OEItem",GID)=""
	..s ^xwmTemp("OEItem",GID,PAPMIDR)=PAPMIIPNo_"^"_PAPMIName
	..s ^xwmTemp("OEItem",GID,PAPMIDR, OEORDRowId)=id_"^"_RegDate_"^"_PAADMDR
	..
	
	// 按团体查找
	i ""'=GID d
	.s GADMRowId="0"
	.f  s GADMRowId=$O(^DHCPEGADM(0,"GBI",GID,GADMRowId)) Q:(GADMRowId="")  d
	..s TeamID=""
	..f  s TeamID=$O(^DHCPEIADM(0,"GADM", GADMRowId, TeamID)) Q:(TeamID="")  d
	...s id="0"
	...f  s id=$O(^DHCPEIADM(0,"GADM", GADMRowId,TeamID,id)) Q:(id="")  d
	....s CurData=$G(^DHCPEIADM(id))
	....Q:(""=CurData)
	....
	....// DHC_PE_IADM.{ IADM_Status }
	....s Status=$P(CurData,"^",8)
	....q:"ARRIVED"'=Status

	....//Q:("COMPLETED"'=Status) //只查询完成的检验
	....
	....// DHC_PE_IADM.{ IADM_PAADM_DR }
	....s PAADMDR=$P(CurData,"^",1)
	....Q:(""=PAADMDR)
	....// PAADM.{ PAADM_PAPMI_DR }
	....s PAPMIDR=$p($g(^PAADM(PAADMDR)),"^",1)	// 取患者信息
	....
	....// 登记号	PA_PatMas.{ PAPMI_IPNo }
	....s PAPMIIPNo=$p(^PAPER(PAPMIDR,"PAT",1),"^",1)
	....Q:(""'=RegNo)&(RegNo'=PAPMIIPNo)
	....
	....// 姓名		PA_PatMas.{PAPMI_Name}
	....s PAPMIName=$p(^PAPER(PAPMIDR,"ALL"),"^",1)	
    ....Q:(""'=PatName)&(PAPMIName'[PatName)
	....
	....// DHC_PE_IADM.{ IADM_RegDate }
	....s RegDate=+$P(CurData,"^",5)
	....Q:(""'=DateFrom)&(""'=RegDate)&(DateFrom>RegDate)
	....Q:(""'=DateFrom)&(""'=RegDate)&(DateTo<RegDate)
	....s:(""'=RegDate) RegDate=##class(websys.Conversions).DateLogicalToHtml(RegDate)
	....
	....// OE_Order.{ OEORD_RowId }
	....s OEORDRowId=0 
	....s OEORDRowId=$O(^OEORD(0,"Adm",PAADMDR,OEORDRowId))
	....
	....Q:(""=OEORDRowId)
	....
	....s ^xwmTemp("OEItem",GADMRowId)=""
	....s ^xwmTemp("OEItem",GADMRowId,PAPMIDR)=PAPMIIPNo_"^"_PAPMIName
	....s ^xwmTemp("OEItem",GADMRowId,PAPMIDR, OEORDRowId)=id_"^"_RegDate_"^"_PAADMDR
	....

	s GCount=0
	s GID=""
	f  s GID=$O(^xwmTemp("OEItem",GID)) Q:(""=GID)  d
	.s GName=$G(^xwmTemp("OEItem",GID))
	.s PAPMIDR="0"
	.f  s PAPMIDR=$O(^xwmTemp("OEItem",GID,PAPMIDR)) Q:(""=PAPMIDR)  d
	..s RegNo=$P($G(^xwmTemp("OEItem",GID,PAPMIDR)),"^",1)
	..s PatName=$P($G(^xwmTemp("OEItem",GID,PAPMIDR)),"^",2)
	..s OEORDRowId="0"
	..//w $G(^xwmTemp("OEItem",GID,PAPMIDR)),!
	..f  s OEORDRowId=$O(^xwmTemp("OEItem", GID, PAPMIDR, OEORDRowId)) Q:(""=OEORDRowId)  d
	...s IADMDR=$P($G(^xwmTemp("OEItem", GID, PAPMIDR, OEORDRowId)),"^",1)
	...s RegDate=$P($G(^xwmTemp("OEItem", GID, PAPMIDR, OEORDRowId)),"^",2)
	...s PAADMDR=$P($G(^xwmTemp("OEItem", GID, PAPMIDR, OEORDRowId)),"^",3)
	...
	...// OE_OrdItem	医嘱项表
	...s OEORIChildsub=0
	...s ret=""
	...s iLLoop=1
	...f  s OEORIChildsub=$O(^OEORD(OEORDRowId, "I", OEORIChildsub)) Q:(""=OEORIChildsub)  d
	....s OEORIRowId=OEORDRowId_"||"_OEORIChildsub
	....s CRMORowId=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,""))
	....q:CRMORowId=""
	....s CRMORI=$p(^DHCPECRMO(CRMORowId),"^",2)
	....s FactPrice=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(CRMORI,"","")
	....i $p(FactPrice,".",1)="" s FactPrice=0_FactPrice
	....//医嘱状态 OEORI_ItemStat_DR(OEC_OrderStatus)
	....s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	....i OEORIItemStatDR'="" d
	.....// OEC_OrderStatus.{OSTAT_Code}
	.....s OSTATCode=$P($G(^OEC("OSTAT",OEORIItemStatDR)),"^",1)
	.....// OEC_OrderStatus.{OSTAT_Desc}
	.....s OSTATDesc=$P($G(^OEC("OSTAT",OEORIItemStatDR)),"^",2)
	....
	....i $D(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) s OSTATDesc="谢绝检查"
	....Q:("D"=OSTATCode)		// 医嘱停止
	....Q:("E"=OSTATCode)		// 医嘱已执行
	....Q:(""'=OEStatus)&(OSTATCode'[OEStatus)		// 医嘱是否停止
	....q:(NoCheckStatus'="")&&(OSTATDesc'=NoCheckStatus)
	....// OEORI_ItmMast_DR
	....s OEORIItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	....Q:(""'=OEList)&(OEList'[("^"_OEORIItmMastDR_"^"))
	....// ARC_ItmMast.{ARCIM_Desc}
	....s ARCIMSubscript=$P(OEORIItmMastDR,"||",1)
	....s ARCIMVersion=$P(OEORIItmMastDR,"||",2)
	....s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	....q:ARCIMDesc["体检费"
	....q:ARCIMDesc["调整费"
	....s STRowId=0
	....s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,STRowId))
	....Q:(""=STRowId)
	....Q:STRowId=$G(^DHCPESetting("DHCPE","StationId_Other"))
	....Q:STRowId=$G(^DHCPESetting("DHCPE","StationId_Medical"))
	....d OutQueryOItem
	.s GCount=+GCount+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQueryOItem
	s ^DHCPETMPItemNoCheck(User,"ItemNoCheck","List",ind)=PatName_"^"_RegNo_"^"_RegDate_"^"_ARCIMDesc_"^"_OSTATDesc_"^"_$fn(FactPrice,"",2)
	set Data=$lb(GID, PAPMIDR, IADMDR, PAADMDR, OEORIRowId_"||"_OEORIChildsub, GName, RegNo, PatName, RegDate, OEORIItmMastDR, ARCIMDesc, OSTATDesc,$fn(FactPrice,"",2))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryOEItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOEItemExecute ]
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

ClassMethod QueryOEItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOEItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetItemNoCheckRows(User)
{
 
 s iLLoop=0 ,Rows=0
 f  s iLLoop=$O(^DHCPETMPItemNoCheck(User,"ItemNoCheck","List", iLLoop)) Q:(""=iLLoop)  d
 .s Rows=Rows+1
 q Rows
}

ClassMethod GetItemNoCheckData(User, i)
{
	
	q:'$d(^DHCPETMPItemNoCheck(User,"ItemNoCheck","List",i)) ""
	q $g(^DHCPETMPItemNoCheck(User,"ItemNoCheck","List",i))
}

/*

ClassMethod QueryOEItemExecute(ByRef qHandle As %Binary, RegNo As %Library.String = "", PatName As %Library.String = "", GID As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", OEList As %Library.String = "", OEStatus As %Library.String = "") As %Status
{
	
	//w RegNo_","_PatName_","_GID_","_DateFrom_","_DateTo_","_OEList_","_OEStatus
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	Q:(""=RegNo)&(""=PatName)&(""=GID)&(""=DateFrom)&(""=DateTo) $$$OK
	s:(""'=RegNo) RegNo=$Extract("00000000",1,8-$Length(RegNo))_RegNo

	k ^xwmTemp("OEItem")
	
	i ""=GID d
	.// 查找符合条件的个人客户 
	.s GID="-1"
	.s id="0"
	.f  s id=$O(^DHCPEIADM(id)) Q:(id="")  d
	..s CurData=$G(^DHCPEIADM(id))
	..Q:(""=CurData)
	..
	..// DHC_PE_IADM.{ IADM_Status }
	..s Status=$P(CurData,"^",9)
	..//Q:("COMPLETED"'=Status) //只查询完成的检验
	..
	..// DHC_PE_IADM.{ IADM_PAADM_DR }
	..s PAADMDR=$P(CurData,"^",1)
	..Q:(""=PAADMDR)
	..// PAADM.{ PAADM_PAPMI_DR }
	..s PAPMIDR=$p($g(^PAADM(PAADMDR)),"^",1)	// 取患者信息
	..
	..// 登记号	PA_PatMas.{ PAPMI_IPNo }
	..s PAPMIIPNo=$p(^PAPER(PAPMIDR,"PAT",1),"^",1)
	..Q:(""'=RegNo)&(RegNo'=PAPMIIPNo)
	..
	..// 姓名		PA_PatMas.{PAPMI_Name}
	..s PAPMIName=$p(^PAPER(PAPMIDR,"ALL"),"^",1)	
    ..Q:(""'=PatName)&(PAPMIName'[PatName)
	..
	..// DHC_PE_IADM.{ IADM_RegDate }
	..s RegDate=+$P(CurData,"^",5)
	..Q:(""'=DateFrom)&(""'=RegDate)&(DateFrom>RegDate)
	..Q:(""'=DateFrom)&(""'=RegDate)&(DateTo<RegDate)
	..s:(""'=RegDate) RegDate=$ZD(RegDate,3)
	..
	..// OE_Order.{OEORD_RowId}
	..s OEORDRowId=0 
	..s OEORDRowId=$O(^OEORD(0,"Adm",PAADMDR,OEORDRowId))
	..
	..Q:(""=OEORDRowId)
	..
	..s ^xwmTemp("OEItem",GID)=""
	..s ^xwmTemp("OEItem",GID,PAPMIDR)=PAPMIIPNo_"^"_PAPMIName
	..s ^xwmTemp("OEItem",GID,PAPMIDR, OEORDRowId)=id_"^"_RegDate_"^"_PAADMDR
	..
	e  d
	.// 按团体查找
	.s GADMRowId="0"
	.f  s GADMRowId=$O(^DHCPEGADM(0,"GBI",GID,GADMRowId)) Q:(GADMRowId="")  d
	..s id="0"
	..f  s id=$O(^DHCPEIADM(0,"GADM", GADMRowId, id)) Q:(id="")  d
	...s CurData=$G(^DHCPEIADM(id))
	...Q:(""=CurData)
	...
	...// DHC_PE_IADM.{ IADM_Status }
	...s Status=$P(CurData,"^",9)
	...//Q:("COMPLETED"'=Status) //只查询完成的检验
	...
	...// DHC_PE_IADM.{ IADM_PAADM_DR }
	...s PAADMDR=$P(CurData,"^",1)
	...Q:(""=PAADMDR)
	...// PAADM.{ PAADM_PAPMI_DR }
	...s PAPMIDR=$p($g(^PAADM(PAADMDR)),"^",1)	// 取患者信息
	...
	...// 登记号	PA_PatMas.{ PAPMI_IPNo }
	...s PAPMIIPNo=$p(^PAPER(PAPMIDR,"PAT",1),"^",1)
	...Q:(""'=RegNo)&(RegNo'=PAPMIIPNo)
	...
	...// 姓名		PA_PatMas.{PAPMI_Name}
	...s PAPMIName=$p(^PAPER(PAPMIDR,"ALL"),"^",1)	
    ...Q:(""'=PatName)&(PAPMIName'[PatName)
	...
	...// DHC_PE_IADM.{ IADM_RegDate }
	...s RegDate=+$P(CurData,"^",5)
	...Q:(""'=DateFrom)&(""'=RegDate)&(DateFrom>RegDate)
	...Q:(""'=DateFrom)&(""'=RegDate)&(DateTo<RegDate)
	...s:(""'=RegDate) RegDate=$ZD(RegDate,3)
	...
	...// OE_Order.{ OEORD_RowId }
	...s OEORDRowId=0 
	...s OEORDRowId=$O(^OEORD(0,"Adm",PAADMDR,OEORDRowId))
	...
	...Q:(""=OEORDRowId)
	...
	...s ^xwmTemp("OEItem",GADMRowId)=""
	...s ^xwmTemp("OEItem",GADMRowId,PAPMIDR)=PAPMIIPNo_"^"_PAPMIName
	...s ^xwmTemp("OEItem",GADMRowId,PAPMIDR, OEORDRowId)=id_"^"_RegDate_"^"_PAADMDR
	...	
	
	s GCount=0
	s GID=""
	f  s GID=$O(^xwmTemp("OEItem",GID)) Q:(""=GID)  d
	.s GName=$G(^xwmTemp("OEItem",GID))
	.s PAPMIDR="0"
	.f  s PAPMIDR=$O(^xwmTemp("OEItem",GID,PAPMIDR)) Q:(""=PAPMIDR)  d
	..s RegNo=$P($G(^xwmTemp("OEItem",GID,PAPMIDR)),"^",1)
	..s PatName=$P($G(^xwmTemp("OEItem",GID,PAPMIDR)),"^",2)
	..s OEORDRowId="0"
	..//w $G(^xwmTemp("OEItem",GID,PAPMIDR)),!
	..f  s OEORDRowId=$O(^xwmTemp("OEItem", GID, PAPMIDR, OEORDRowId)) Q:(""=OEORDRowId)  d
	...s IADMDR=$P($G(^xwmTemp("OEItem", GID, PAPMIDR, OEORDRowId)),"^",1)
	...s RegDate=$P($G(^xwmTemp("OEItem", GID, PAPMIDR, OEORDRowId)),"^",2)
	...s PAADMDR=$P($G(^xwmTemp("OEItem", GID, PAPMIDR, OEORDRowId)),"^",3)
	...
	...// OE_OrdItem	医嘱项表
	...s OEORIChildsub=0
	...s ret=""
	...s iLLoop=1
	...f  s OEORIChildsub=$O(^OEORD(OEORDRowId, "I", OEORIChildsub)) Q:(""=OEORIChildsub)  d
	....s OEORIRowId=OEORDRowId_"||"_OEORIChildsub
	....
	....//医嘱状态 OEORI_ItemStat_DR(OEC_OrderStatus)
	....s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	....// OEC_OrderStatus.{OSTAT_Code}
	....s OSTATCode=$P($G(^OEC("OSTAT",OEORIItemStatDR)),"^",1)
	....// OEC_OrderStatus.{OSTAT_Desc}
	....s OSTATDesc=$P($G(^OEC("OSTAT",OEORIItemStatDR)),"^",2)
	....
	....Q:("D"=OSTATCode)		// 医嘱是否停止
	....Q:(""'=OEStatus)&(OSTATCode'[OEStatus)		// 医嘱是否停止
	....
	....// OEORI_ItmMast_DR
	....s OEORIItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	....Q:(""'=OEList)&(OEList'[("^"_OEORIItmMastDR_"^"))
	....// ARC_ItmMast.{ARCIM_Desc}
	....s ARCIMSubscript=$P(OEORIItmMastDR,"||",1)
	....s ARCIMVersion=$P(OEORIItmMastDR,"||",2)
	....s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	....
	....d OutQueryOItem
	.s GCount=+GCount+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQueryOItem
	set Data=$lb(GID, PAPMIDR, IADMDR, PAADMDR, OEORIRowId_"||"_OEORIChildsub, GName, RegNo, PatName, RegDate, OEORIItmMastDR, ARCIMDesc, OSTATDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}
*/
}
