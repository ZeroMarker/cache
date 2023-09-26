Import SQLUser

Class web.DHCPE.Report.LocWorkStatisticByPAADM Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 641;

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.LocWorkStatisticByPAADM","LocWorkStatistic","61482","","")
Query LocWorkStatistic(DateBegin As %Library.String = "", DateEnd As %Library.String = "", LocDR As %Library.String = "", DType As %Library.String = "") As %Query(ROWSPEC = "TLoc:%String, TCount:%String, TAmount:%String")
{
}

ClassMethod LocWorkStatisticExecute(ByRef qHandle As %Binary, DateBegin As %Library.String = "", DateEnd As %Library.String = "", LocDR As %Library.String = "", DType As %Library.String = "") As %Status
{
 	s ind=1
 	s id=0	
	Set repid=$I(^CacheTemp)
	
 	if (""=DateBegin)&&(""=DateEnd){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	i DateBegin'="" s DateBegin=##class(websys.Conversions).DateHtmlToLogical(DateBegin)
 	i DateEnd'=""   s DateEnd=##class(websys.Conversions).DateHtmlToLogical(DateEnd)
 	k ^DHCPETMPLWA
 	s:(""=DType) DType="A" //默认按执行时间查询 
 	d:("A"=DType) ..LocWorkStatisticArriveDate(DateBegin, DateEnd,LocDR)
 	d:("E"=DType) ..LocWorkStatisticExecDate(DateBegin, DateEnd,LocDR)
 	 
	s RecDepDR=0
	f  s RecDepDR=$O(^DHCPETMPLWA("RecDep", RecDepDR)) q:RecDepDR=""  d
	.s CTLOCDesc=$P($G(^CTLOC(RecDepDR)),"^",2)   //科室名称
	.s TotalAmount=$G(^DHCPETMPLWA("RecDep", RecDepDR, "FactAmount"))
	.s Count=$G(^DHCPETMPLWA("RecDep", RecDepDR,"Count"))
	.s Data=$LB(CTLOCDesc, Count, TotalAmount)
    .d LocWorkStatisticOut

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
LocWorkStatisticOut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod LocWorkStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocWorkStatisticExecute ]
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

ClassMethod LocWorkStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocWorkStatisticExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 按到达时间统计科室工作量
/// w ##Class(web.DHCPE.Report.StationWorkStatistic).StationWorkStatisticArriveDate(1129,"6470||1",61054,61101)
ClassMethod LocWorkStatisticArriveDate(DateBegin As %Library.String = "", DateEnd As %Library.String = "", LocDR As %Library.String = "")
{
	//new (LocDR,DateBegin,DateEnd)
	k ^DHCPETMPLWA
	s num=0
    i (""'=DateBegin)  s AdmDate=DateBegin-1
    i (""=DateBegin)   s AdmDate=0
    i (""=DateEnd)     s DateEnd=+$h  
	f  s AdmDate=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate)) Q:(""=AdmDate)||((0'=+DateEnd)&(AdmDate>DateEnd))  d
	.s AdmTime=0
	.f  s AdmTime=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate, AdmTime)) Q:(""=AdmTime)  d
	..s IAdmRowId=0
	..f  s IAdmRowId=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate, AdmTime, IAdmRowId))  Q:(""=IAdmRowId)  d
	...s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	...Q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
	...s PAADM=$P($g(^DHCPEIADM(IAdmRowId)),"^",1)
	...Q:(""=PAADM)
	...s OEORDRowId=0
	...f  s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,OEORDRowId)) q:OEORDRowId=""  d
	....s OEORIChildsub=0
	....f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
	.....Q:(""=$O(^DHCPECRMO(0,"OEORI",(OEORDRowId_"||"_OEORIChildsub),0))) //过滤非体检项目
	.....// 过滤非医嘱站点
	.....s OtherSTRowId=$O(^DHCPEST(0,"STORD_ARCIM",(OEORDRowId_"||"_OEORIChildsub),0))
	.....;Q:(OtherSTRowId=$D(^DHCPESetting("DHCPE","StationId_Other")))
	.....Q:(OtherSTRowId=$D(^DHCPESetting("DHCPE","StationId_Other",CurLocID)))
	.....s OEORIItemStatDR=+$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	.....s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	.....// OEORI_RecDep_DR
	.....s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	.....Q:(""=RecDepDR) //
	.....Q:(""'=LocDR)&(LocDR'=RecDepDR)
    .....d DoExec
	.....s ^DHCPETMPLWA("RecDep", RecDepDR, "FactAmount")=+FactAmount+$G(^DHCPETMPLWA("RecDep", RecDepDR, "FactAmount"))
 	.....i ($G(^DHCPETMPLWA("RecDep", RecDepDR, "ADMList"))'[(PAADM_"^")) s ^DHCPETMPLWA("RecDep", RecDepDR,"Count")=+$G(^DHCPETMPLWA("RecDep", RecDepDR,"Count"))+1
 	.....i ($G(^DHCPETMPLWA("RecDep", RecDepDR, "ADMList"))'[(PAADM_"^")) S ^DHCPETMPLWA("RecDep", RecDepDR, "ADMList")=$G(^DHCPETMPLWA("RecDep", RecDepDR, "ADMList"))_PAADM_"^"
	
	Q 0
DoExec
	s FactAmount=0
	
	s OrdDeptDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",1)
	Q:(""'=OrdDeptDR) // 医嘱套项目不计算
	s OEORDIDR=OEORDRowId_"||"_OEORIChildsub
	s crmodr=$O(^DHCPECRMO(0,"OEORI",OEORDIDR,0))
    Q:crmodr=""
	s ^DHCPETMPSWA("DoExecDateGetItemFactAmount")=OEORDIDR
	
	s PIOIDR=$P($G(^DHCPECRMO(crmodr)),"^",2)

	s FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PIOIDR,"","")

	Q
}

/// 按医嘱执行时间统计科室工作量
/// w ##Class(web.DHCPE.Report.LocWorkStatisticByPAADM).LocWorkStatisticExecDate("61482","","")
ClassMethod LocWorkStatisticExecDate(DateBegin As %Library.String = "", DateEnd As %Library.String = "", LocDR As %Library.String = "")
{
	k ^DHCPETMPLWA
	s num=0
	s (PAPMINo,Name,SexName,Tel1,Tel2,MobilePhone,Company,GADM,GBIDR,GDesc)=""

	s ^DHCPETMPLWA("StationList")=""
	s CurLocID=%session.Get("LOGON.CTLOCID")
	s STRowId=0 
	f  s STRowId=$O(^DHCPEST(STRowId)) Q:(""=STRowId)  d
	.;Q:($G(^DHCPESetting("DHCPE","StationId_Lab"))=STRowId)					// 检验科室
	.;Q:(("^"_^DHCPESetting("DHCPE","StationId_Ris")_"^")[("^"_STRowId_"^"))	// 检查科室
	.;Q:($G(^DHCPESetting("DHCPE","StationId_Other"))=STRowId)				// 其它科室
	.Q:($G(^DHCPESetting("DHCPE","StationId_Lab",CurLocID))=STRowId) // 检验科室
	.Q:(("^"_^DHCPESetting("DHCPE","StationId_Ris",CurLocID)_"^")[("^"_STRowId_"^")) // 检查科室
	.Q:($G(^DHCPESetting("DHCPE","StationId_Other",CurLocID))=STRowId) // 其它科室

	.s ^DHCPETMPLWA("StationList")=^DHCPETMPLWA("StationList")_"^"_STRowId_"^"
	.
	.s STORDChildSub=0 // DHC_PE_StationOrder.{ STORD_ChildSub }
	.f  s STORDChildSub=$O(^DHCPEST(STRowId,"O",STORDChildSub)) Q:(""=STORDChildSub)  d
	..// STORD_ARCIM_DR
	..s ItmMastDR=$P(^DHCPEST(STRowId,"O",STORDChildSub),"^",1)
	..// 体检部门项目
	..s ^DHCPETMPLWA("StationList",STRowId)=$G(^DHCPETMPLWA("Station",STRowId))_"^"_ItmMastDR_"^"
	..s ^DHCPETMPLWA("ItmMastList",ItmMastDR)=STRowId	
    i (""'=DateBegin)  s SSAduitDate=DateBegin-1
    i (""=DateBegin)   s SSAduitDate=0
    i (""=DateEnd)     s DateEnd=+$h  
    f  s SSAduitDate=$O(^DHCPESS(0,"AuditDate",SSAduitDate)) Q:(""=SSAduitDate)||((""'=DateEnd)&(SSAduitDate>DateEnd))   d
	.s SSRowId=0
	.f  s SSRowId=$O(^DHCPESS(0,"AuditDate",SSAduitDate,SSRowId)) Q:(""=SSRowId)  d
	..s CurData=$G(^DHCPESS(SSRowId,1))
	..s SSStatus=$P(CurData,"^",7)
	..Q:("NA"=SSStatus)||((""=SSStatus))
	..s SSSTDR=$P(CurData,"^",2)
	..s ssauditdate=$zd($p(CurData,"^",6))
	..Q:(^DHCPETMPLWA("StationList")'[("^"_SSSTDR_"^"))
	..s SSIADMDR=$P(CurData,"^",1)
	..q:SSIADMDR=""
	..s Status=$P($g(^DHCPEIADM(SSIADMDR)),"^",8)
	..//Q:'(("ARRIVED"=Status)||("COMPLETED"=Status)||)
	..s ^DHCPETMPLWA("IADMUse",SSIADMDR,SSSTDR)=1 
	..s ^DHCPETMPLWA("IADM",SSIADMDR)=$G(^DHCPETMPLWA("Station",SSSTDR))_$G(^DHCPETMPLWA("IADM",SSIADMDR))
	
	s IADMDR=0
	f  s IADMDR=$O(^DHCPETMPLWA("IADM",IADMDR)) Q:(""=IADMDR)  d
	.s PAADM=$P($g(^DHCPEIADM(IADMDR)),"^",1)
	.Q:(""=PAADM)
	.s OEORDRowId=0
	.f  s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,OEORDRowId)) q:OEORDRowId=""  d
	..s ItmMastDR=0
	..f  s ItmMastDR=$O(^DHCPETMPLWA("ItmMastList",ItmMastDR)) Q:(""=ItmMastDR)  d
	...s STID=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))  //退掉该体检者没有检查的医嘱
	...q:('$d(^DHCPETMPLWA("IADMUse",IADMDR,STID)))
	...s OEORISttDat=0
	...f  s OEORISttDat=$O(^OEORDi(0,"ARCIM",OEORDRowId,ItmMastDR,OEORISttDat)) Q:(""=OEORISttDat)  d
	....s OEORIChildsub=0
	....f  s OEORIChildsub=$O(^OEORDi(0,"ARCIM",OEORDRowId,ItmMastDR,OEORISttDat,OEORIChildsub)) Q:(""=OEORIChildsub)  d
	.....Q:(""=$O(^DHCPECRMO(0,"OEORI",(OEORDRowId_"||"_OEORIChildsub),0))) //过滤非体检项目
	.....s OEORIItemStatDR=+$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	.....s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	.....s desc=$p(^CTLOC(RecDepDR),"^",2) 
	.....Q:(""'=LocDR)&(LocDR'=RecDepDR)
	.....Q:(6'=OEORIItemStatDR) //6	E	执行	N
	.....d DoExec
	.....s ^DHCPETMPLWA("RecDep", RecDepDR, "FactAmount")=+FactAmount+$G(^DHCPETMPLWA("RecDep", RecDepDR, "FactAmount"))
 	.....i ($G(^DHCPETMPLWA("RecDep", RecDepDR, "ADMList"))'[(PAADM_"^")) s ^DHCPETMPLWA("RecDep", RecDepDR,"Count")=+$G(^DHCPETMPLWA("RecDep", RecDepDR,"Count"))+1
 	.....i ($G(^DHCPETMPLWA("RecDep", RecDepDR, "ADMList"))'[(PAADM_"^")) S ^DHCPETMPLWA("RecDep", RecDepDR, "ADMList")=$G(^DHCPETMPLWA("RecDep", RecDepDR, "ADMList"))_PAADM_"^"



    //s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion"))
    s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",CurLocID))
    if (LisNewVersion'="Y") {
	//w "检验系统",!
	//s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA",CurLocID)
	// EP_VisitTestSet.{ VISTS_DateOfAuthorisation }
	s:(""'=DateBegin) vDate=$O(^[namespaceLab]TEPIi("AUTHORISED",DateBegin),-1)
	s num=0
	s:(""=DateBegin) vDate=$O(^[namespaceLab]TEPIi("AUTHORISED",""))
	f  s vDate=$O(^[namespaceLab]TEPIi("AUTHORISED",vDate)) Q:(""=vDate)||((""'=DateEnd)&&(DateEnd<vDate))  d
	.// 标本号 EP_VisitTestSet.{ VISTS_ParRef } = EP_VisitNumber.{ EPVIS_VisitNumber } = OE_OrdItem.{ OEORI_LabEpisodeNo }
	.s EPVISVisitNumber=0
	.f  s EPVISVisitNumber=$O(^[namespaceLab]TEPIi("AUTHORISED", vDate, EPVISVisitNumber)) Q:(""=EPVISVisitNumber)  d
	..// OE_Order.{ OEORD_RowId }
	..s OEORDRowId=0
	..f  s OEORDRowId=$O(^OEORD(0,"EpisNo",EPVISVisitNumber,OEORDRowId)) Q:(""=OEORDRowId)  d
	...s OEORIChildsub=0
	...f  s OEORIChildsub=$O(^OEORD(0,"EpisNo",EPVISVisitNumber,OEORDRowId,OEORIChildsub)) Q:(""=OEORIChildsub)  d
	....//DHC_PE_CRMOrder
	....Q:(""=$O(^DHCPECRMO(0,"OEORI",(OEORDRowId_"||"_OEORIChildsub),0))) //过滤非体检客户项目
	....
	....//医嘱状态 OEORI_ItemStat_DR(OEC_OrderStatus)
	....s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	....s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	....s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	....Q:(""=RecDepDR) //
	....Q:(""'=LocDR)&(LocDR'=RecDepDR)
	....d DoExec
	....s ^DHCPETMPLWA("RecDep", RecDepDR, "FactAmount")=+FactAmount+$G(^DHCPETMPLWA("RecDep", RecDepDR, "FactAmount"))
 	....i ($G(^DHCPETMPLWA("RecDep", RecDepDR, "ADMList"))'[(PAADM_"^")) s ^DHCPETMPLWA("RecDep", RecDepDR,"Count")=+$G(^DHCPETMPLWA("RecDep", RecDepDR,"Count"))+1
 	....i ($G(^DHCPETMPLWA("RecDep", RecDepDR, "ADMList"))'[(PAADM_"^")) S ^DHCPETMPLWA("RecDep", RecDepDR, "ADMList")=$G(^DHCPETMPLWA("RecDep", RecDepDR, "ADMList"))_PAADM_"^"
    }ELSE{
	    //参数: HospitalDR体检的一般都默认的1，具体如果查询不到，看下是不是默认不是1
	    S HospitalDR=%session.Get("LOGON.HOSPID") 
	    s HospitalDR=1
	   //标本接收时间 
	   S SttDate=$zd(DateBegin,8)
	   s EndDate=$zd(DateEnd,8)
	   s vDate=$O(^dbo.RPVisitNumberI("IndexReceiveDate",HospitalDR,SttDate),-1)
       f  s vDate= $O(^dbo.RPVisitNumberI("IndexReceiveDate",HospitalDR,vDate)) q:(vDate="")||($l(EndDate)&&(vDate>EndDate))  d
    	.s VisitNumberDR="" f  s VisitNumberDR= $O(^dbo.RPVisitNumberI("IndexReceiveDate",HospitalDR,vDate,VisitNumberDR)) q:VisitNumberDR=""  d
		..s gdata=$g(^dbo.RPVisitNumberD(VisitNumberDR))
		..s EPVISVisitNumber=$lg(gdata,2)
		..s OEORDRowId=0
	   	..f  s OEORDRowId=$O(^OEORD(0,"EpisNo",EPVISVisitNumber,OEORDRowId)) Q:(""=OEORDRowId)  d
    	...s OEORIChildsub=0
		...f  s OEORIChildsub=$O(^OEORD(0,"EpisNo",EPVISVisitNumber,OEORDRowId,OEORIChildsub)) Q:(""=OEORIChildsub)  d
		....//DHC_PE_CRMOrder
		....Q:(""=$O(^DHCPECRMO(0,"OEORI",(OEORDRowId_"||"_OEORIChildsub),0))) //过滤非体检客户项目
		....//医嘱状态 OEORI_ItemStat_DR(OEC_OrderStatus)
		....s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
		....s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
		....s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
		....Q:(""=RecDepDR) //
		....Q:(""'=LocDR)&(LocDR'=RecDepDR)
		....d DoExec
		....s ^DHCPETMPLWA("RecDep", RecDepDR, "FactAmount")=+FactAmount+$G(^DHCPETMPLWA("RecDep", RecDepDR, "FactAmount"))
 		....i ($G(^DHCPETMPLWA("RecDep", RecDepDR, "ADMList"))'[(PAADM_"^")) s ^DHCPETMPLWA("RecDep", RecDepDR,"Count")=+$G(^DHCPETMPLWA("RecDep", RecDepDR,"Count"))+1
 		....i ($G(^DHCPETMPLWA("RecDep", RecDepDR, "ADMList"))'[(PAADM_"^")) S ^DHCPETMPLWA("RecDep", RecDepDR, "ADMList")=$G(^DHCPETMPLWA("RecDep", RecDepDR, "ADMList"))_PAADM_"^"
    }

	
	// 检查系统
 	i (""'=DateBegin)  s date=DateBegin-1
    i (""=DateBegin)   s date=0
    i (""=DateEnd)     s DateEnd=+$h 
    f  s date=$o(^DHCPACRegInfoi("RegDate",date))   Q:(""=date)||((""'=DateEnd)&(date>DateEnd))  d 
      .s Regrowid=0 
	  .f  s Regrowid=$o(^DHCPACRegInfoi("RegDate",date,Regrowid)) q:Regrowid=""  d   
      ..q:$d(^DHCPACRegInfo(Regrowid))=0 
      ..s OEORDIRowId=$p(^DHCPACRegInfo(Regrowid),"^",11)
      ..s OEORDRowId=$p(OEORDIRowId,"||",1)
      ..s OEORIChildsub=$p(OEORDIRowId,"||",2)
      ..Q:(""=$O(^DHCPECRMO(0,"OEORI",(OEORDRowId_"||"_OEORIChildsub),0))) //过滤非体检项目
      ..s ItmMastDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
      ..s RecDepDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,3),"^",6)
      ..s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
      ..q:(""'=LocDR)&(LocDR'=RecDepDR)
      ..s PAADM=$p(^DHCPACRegInfo(Regrowid),"^",10)
	  ..Q:(6'=OEORIItemStatDR) //6	E	执行	N
      ..d DoExec
	  ..s ^DHCPETMPLWA("RecDep", RecDepDR, "FactAmount")=+FactAmount+$G(^DHCPETMPLWA("RecDep", RecDepDR, "FactAmount"))
 	  ..i ($G(^DHCPETMPLWA("RecDep", RecDepDR, "ADMList"))'[(PAADM_"^")) s ^DHCPETMPLWA("RecDep", RecDepDR,"Count")=+$G(^DHCPETMPLWA("RecDep", RecDepDR,"Count"))+1
 	  ..i ($G(^DHCPETMPLWA("RecDep", RecDepDR, "ADMList"))'[(PAADM_"^")) S ^DHCPETMPLWA("RecDep", RecDepDR, "ADMList")=$G(^DHCPETMPLWA("RecDep", RecDepDR, "ADMList"))_PAADM_"^"

	
	Q ""
DoExec
	s FactAmount=0
	s OrdDeptDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",1)
	Q:(""'=OrdDeptDR) // 医嘱套项目不计算
	s OEORDIDR=OEORDRowId_"||"_OEORIChildsub
	s crmodr=$O(^DHCPECRMO(0,"OEORI",OEORDIDR,0))
    Q:crmodr=""
	s ^DHCPETMPLWA("DoExecDateGetItemFactAmount")=OEORDIDR
	s PIOIDR=$P($G(^DHCPECRMO(crmodr)),"^",2)
	s FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PIOIDR,"","")
   
	Q
}

Query SearchLoc(Desc As %Library.String = "") As %SQLQuery(ROWSPEC = "CTLOC_Code:%String,CTLOC_Desc:%String, CTLOC_RowId:%String")
{
	select CTLOC_Code, CTLOC_Desc, CTLOC_RowId
	from CT_loc
	where CTLOC_Desc %STARTSWITH :Desc
}

}
