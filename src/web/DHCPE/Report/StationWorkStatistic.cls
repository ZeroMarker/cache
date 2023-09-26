Import SQLUser

Class web.DHCPE.Report.StationWorkStatistic Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 547;

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.StationWorkStatistic","StationWorkStatistic","4","E","","60821","61109")
Query StationWorkStatistic(LocDR As %Library.String = "", DType As %Library.String = "", OEItemDR As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "", GroupDR As %Library.String = "", VIPLevel As %String = "") As %Query(ROWSPEC = "SWA_Loc:%String, SWA_OEItem:%String, SWA_OrderStatus:%String, SWA_Count:%String, SWA_Amount:%String,SWA_OEItemDR:%String,SWA_LocDR:%String,SWA_DType:%String")
{
}

ClassMethod StationWorkStatisticExecute(ByRef qHandle As %Binary, LocDR As %Library.String = "", DType As %Library.String = "", OEItemDR As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "", GroupDR As %Library.String = "", VIPLevel As %String = "") As %Status
{
 	s ind=1
 	s id=0	
	Set repid=$I(^CacheTemp)
	
 	if (""=DateBegin)&&(""=DateEnd){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	i DateBegin'=""  s DateBegin=##class(websys.Conversions).DateHtmlToLogical(DateBegin)
 	i DateEnd'=""   s DateEnd=##class(websys.Conversions).DateHtmlToLogical(DateEnd)
 	s CurUserID=%session.Get("LOGON.USERID")   //add by zl
 	k ^DHCPETMPSWA
 	k ^DHCPETMPSWAExport("ExportStationWorkStatistic",CurUserID)	  //add by zl
 	s ^DHCPETMPSWA("StationWorkStatistic")=LocDR_","""_DType_""""_","""_OEItemDR_""","_DateBegin_","_DateEnd
 	s:(""=DType) DType="E" //默认按执行时间查询 
 	d:("A"=DType) ..StationWorkStatisticArriveDate(LocDR, OEItemDR, DateBegin, DateEnd,GroupDR,VIPLevel)
 	d:("E"=DType) ..StationWorkStatisticExecDate(LocDR, OEItemDR, DateBegin, DateEnd,GroupDR,VIPLevel)
	s RecDepDR=0
	f  s RecDepDR=$O(^DHCPETMPSWA("RecDep", RecDepDR)) q:RecDepDR=""  d
	.s CTLOCDesc=$P($G(^CTLOC(RecDepDR)),"^",2)   //科室名称
	.s ItmMastDR=0
	.f  s ItmMastDR=$O(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR)) q:ItmMastDR=""  d
	..s ARCIMSubscript=$P(ItmMastDR,"||",1)
	..s ARCIMVersion=$P(ItmMastDR,"||",2)
	..s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	..s Count=+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 0))
	..Q:(Count=0)
	..s Amount=$FN(+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 1)),"",2)
	..s OrderStatus="总计"
	..s Data=$LB(CTLOCDesc, ARCIMDesc, OrderStatus, Count, Amount,ItmMastDR,RecDepDR,DType)
    ..d StationWorkStatisticOut
    ..s CTLOCDesc=""
    .
    .s ARCIMDesc="总计:"
    .s OrderStatus=""
    .s Count=$G(^DHCPETMPSWA("RecDep", RecDepDR,0))
    .s Amount=$FN($G(^DHCPETMPSWA("RecDep", RecDepDR,1)),"",2)
    .s Data=$LB(CTLOCDesc, ARCIMDesc, OrderStatus, Count, Amount,"",RecDepDR,DType)
    .d StationWorkStatisticOut

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
StationWorkStatisticOut
 	Set ^CacheTemp(repid,ind)=Data
    s ^DHCPETMPSWAExport("ExportStationWorkStatistic",CurUserID,ind)=CTLOCDesc_"^"_ARCIMDesc_"^"_Count_"^"_Amount   //add by zl
    Set ind=ind+1
 	q
}

ClassMethod StationWorkStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StationWorkStatisticExecute ]
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

ClassMethod StationWorkStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StationWorkStatisticExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 按到达时间统计科室工作量
/// w ##Class(web.DHCPE.Report.StationWorkStatistic).StationWorkStatisticArriveDate(1129,"6470||1",61054,61101)
ClassMethod StationWorkStatisticArriveDate(LocDR As %Library.String = "", OEItemDR As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "", GroupDR As %Library.String = "", VIPLevel As %String = "")
{
	
	k ^DHCPETMPSWA
	s num=0
	s (PAPMINo,Name,SexName,Tel1,Tel2,Mobil,MobilePhone,Company,GADM,GBIDR,GDesc)=""
	s ^DHCPETMPSWA("StationWorkStatisticArriveDate")=LocDR_","""_OEItemDR_""","_DateBegin_","_DateEnd
    i (""'=DateBegin)  s AdmDate=DateBegin-1
    i (""=DateBegin)   s AdmDate=0
    i (""=DateEnd)     s DateEnd=+$h  
	f  s AdmDate=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate)) Q:(""=AdmDate)||((0'=+DateEnd)&(AdmDate>DateEnd))  d
	.s AdmTime=0
	.f  s AdmTime=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate, AdmTime)) Q:(""=AdmTime)  d
	..s IAdmRowId=0
	..f  s IAdmRowId=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate, AdmTime, IAdmRowId))  Q:(""=IAdmRowId)  d
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IAdmRowId)          //add 2009-07-07 
 	...q:LocFlag=1
	...s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	...Q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
	...s PAADM=$P($g(^DHCPEIADM(IAdmRowId)),"^",1)
	...Q:(""=PAADM)
	...//用于具体人员信息
	...s PreIADM=$P($g(^DHCPEIADM(IAdmRowId)),"^",4)
	...s VIP=+##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PreIADM)
	...q:(VIPLevel'="")&&(VIPLevel'=VIP)
	...i PreIADM'=""  s PIBIDR=$P($G(^DHCPEPreIADM(PreIADM)),"^",1)
	...Q:PIBIDR=""  
	...s PAPMINo=""
	...s PAPMINo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
    ...s Name=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
    ...s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
    ...i SexDR'=""   s SexName=$p(^CT("SEX",SexDR),"^",2) 
    ...s Tel1=$p($g(^DHCPEPreIBI(PIBIDR)),"^",6)
    ...//s Tel2=$p($g(^DHCPEPreIBI(PIBIDR)),"^",7)
    ...s Mobil=$p($g(^DHCPEPreIBI(PIBIDR)),"^",8)
    ...s MobilePhone=Mobil
    ...i (""=Mobil)   s MobilePhone=Tel1
    ...s Company=$p($g(^DHCPEPreIBI(PIBIDR)),"^",12)
    ...S GADM=""
    ...S GBIDR=""
    ...S GDesc=""
    ...s GADM=$P($g(^DHCPEIADM(IAdmRowId)),"^",2)
    ...i GADM'=""  s GBIDR=$P($G(^DHCPEGADM(GADM)),"^",1)
    ...Q:(GroupDR'="")&&(GroupDR'=GADM)
    ...i GBIDR'="" s GDesc=$p($G(^DHCPEGBI(GBIDR)),"^",2)
	...s OEORDRowId=0
	...f  s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,OEORDRowId)) q:OEORDRowId=""  d
	....s OEORIChildsub=0
	....f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
	.....Q:(""=$O(^DHCPECRMO(0,"OEORI",(OEORDRowId_"||"_OEORIChildsub),0))) //过滤非体检项目
	.....// 过滤非医嘱站点
	.....s OtherSTRowId=$O(^DHCPEST(0,"STORD_ARCIM",(OEORDRowId_"||"_OEORIChildsub),0))
	.....;Q:(OtherSTRowId=$g(^DHCPESetting("DHCPE","StationId_Other")))
	.....s OEORIItemStatDR=+$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	.....s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	.....Q:(""'=OEItemDR)&(OEItemDR'=ItmMastDR)
	.....s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	.....Q:(""=RecDepDR) //
	.....Q:(""'=LocDR)&(LocDR'=RecDepDR)
	.....s num=num+1
	.....//w !,GDesc
	.....s ^DHCPETMPSWA("A",RecDepDR,IAdmRowId)=PAPMINo_"^"_Name_"^"_SexName_"^"_MobilePhone_"^"_Company_"^"_GDesc
	.....s ^DHCPETMPSWA("A",RecDepDR,ItmMastDR,IAdmRowId,num)=PAPMINo_"^"_Name_"^"_SexName_"^"_MobilePhone_"^"_Company_"^"_GDesc
	.....// 科室-医嘱-医嘱状态
	.....;s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, OEORIItemStatDR)=1+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, OEORIItemStatDR))
	.....// Q:(6'=OEORIItemStatDR) //6	E	执行	N MLH
	.....// 科室
	.....s ^DHCPETMPSWA("RecDep", RecDepDR)=1+$G(^DHCPETMPSWA("RecDep",RecDepDR))
	.....// 科室-医嘱
	.....s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 0)=1+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 0))
	.....// 医嘱
	.....s ^DHCPETMPSWA("ItmMast", ItmMastDR)=1+$G(^DHCPETMPSWA("ItmMast", ItmMastDR))
	.....// 医嘱-科室
	.....s ^DHCPETMPSWA("ItmMast", ItmMastDR, "RecDep", RecDepDR)=1+$G(^DHCPETMPSWA("ItmMast", ItmMastDR, "RecDep", RecDepDR))
	.....d DoExecDateGetItemFactAmount
	.....// 科室单项收入
	.....s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 1)=+FactAmount+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 1))
	.....// 科室总收入
	.....s ^DHCPETMPSWA("RecDep", RecDepDR, 1)=+FactAmount+$G(^DHCPETMPSWA("RecDep",RecDepDR, 1))
	.....// 科室总人次
	.....s ^DHCPETMPSWA("RecDep", RecDepDR, 0)=1+$G(^DHCPETMPSWA("RecDep",RecDepDR, 0))
	
	Q 0
DoArriveDateGetItemFactAmount
	s OrdDeptDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",1)
	Q:(""'=OrdDeptDR) // 医嘱套项目不计算
	s OEORDIDR=OEORDRowId_"||"_OEORIChildsub
	s crmodr=$O(^DHCPECRMO(0,"OEORI",OEORDIDR,0))
	s PIOIDR=$P($G(^DHCPECRMO(crmodr)),"^",2)
	s FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PIOIDR,"","")
	Q
}

/// 按医嘱执行时间统计科室工作量
/// w ##Class(web.DHCPE.Report.StationWorkStatistic).StationWorkStatisticExecDate(,, 60941, 60971)
/// w ##Class(web.DHCPE.Report.StationWorkStatistic).StationWorkStatisticExecDate("10","",61056,61115)
///  w ##Class(web.DHCPE.Report.StationWorkStatistic).StationWorkStatisticExecDate(1128,"8306||1",61054,61101)
ClassMethod StationWorkStatisticExecDate(LocDR As %Library.String = "", OEItemDR As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "", GroupDR As %Library.String = "", VIPLevel As %String = "")
{
	k ^DHCPETMPSWA
	s num=0
	s (PAPMINo,Name,SexName,Tel1,Tel2,MobilePhone,Company,GADM,GBIDR,GDesc)=""
	s ^DHCPETMPSWA("StationWorkStatisticExecDate")=LocDR_","""_OEItemDR_""","_DateBegin_","_DateEnd
	//Q:(""=DateBegin)||(""=DateEnd) 0
	// 获取各科室项目列表	
	s ^DHCPETMPSWA("StationList")=""
	s CurLocID=%session.Get("LOGON.CTLOCID")
	s STRowId=0 
	f  s STRowId=$O(^DHCPEST(STRowId)) Q:(""=STRowId)  d
	.;Q:($G(^DHCPESetting("DHCPE","StationId_Lab"))=STRowId)					// 检验科室
	.;Q:(("^"_^DHCPESetting("DHCPE","StationId_Ris")_"^")[("^"_STRowId_"^"))	// 检查科室
	.;Q:($G(^DHCPESetting("DHCPE","StationId_Other"))=STRowId)				// 其它科室
	.Q:($G(^DHCPESetting("DHCPE","StationId_Lab",CurLocID))=STRowId) // 检验科室
	.Q:(("^"_^DHCPESetting("DHCPE","StationId_Ris",CurLocID)_"^")[("^"_STRowId_"^")) // 检查科室
	.Q:($G(^DHCPESetting("DHCPE","StationId_Other",CurLocID))=STRowId) // 其它科室

	.s ^DHCPETMPSWA("StationList")=^DHCPETMPSWA("StationList")_"^"_STRowId_"^"
	.s STORDChildSub=0 
	.f  s STORDChildSub=$O(^DHCPEST(STRowId,"O",STORDChildSub)) Q:(""=STORDChildSub)  d
	..s ItmMastDR=$P(^DHCPEST(STRowId,"O",STORDChildSub),"^",1)
	..Q:(""'=OEItemDR)&(OEItemDR'=ItmMastDR)
	..// 体检部门项目
	..s ^DHCPETMPSWA("StationList",STRowId)=$G(^DHCPETMPSWA("Station",STRowId))_"^"_ItmMastDR_"^"
	..s ^DHCPETMPSWA("ItmMastList",ItmMastDR)=STRowId	
    
    i (""'=DateBegin)  s SSAduitDate=DateBegin-1
    i (""=DateBegin)   s SSAduitDate=0
    i (""=DateEnd)     s DateEnd=+$h  
    f  s SSAduitDate=$O(^DHCPESS(0,"AuditDate",SSAduitDate)) Q:(""=SSAduitDate)||(SSAduitDate>DateEnd)   d
	.s SSRowId=0
	.f  s SSRowId=$O(^DHCPESS(0,"AuditDate",SSAduitDate,SSRowId)) Q:(""=SSRowId)  d
	..s CurData=$G(^DHCPESS(SSRowId,1))
	..s SSStatus=$P(CurData,"^",7)
	..Q:("NA"=SSStatus)||((""=SSStatus))
	..s SSSTDR=$P(CurData,"^",2)
	..//q:SSSTDR'=2
	..s ssauditdate=$zd($p(CurData,"^",6))
	..Q:(^DHCPETMPSWA("StationList")'[("^"_SSSTDR_"^"))
	..s SSIADMDR=$P(CurData,"^",1)
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",SSIADMDR)          //add 2009-07-07 
 	..q:LocFlag=1
 	..q:SSIADMDR=""
	..s Status=$P($g(^DHCPEIADM(SSIADMDR)),"^",8)
	..//Q:'(("ARRIVED"=Status)||("COMPLETED"=Status)||)
	..s ^DHCPETMPSWA("IADM",SSIADMDR)=$G(^DHCPETMPSWA("Station",SSSTDR))_$G(^DHCPETMPSWA("IADM",SSIADMDR))
	s i=0
	s IADMDR=0
	f  s IADMDR=$O(^DHCPETMPSWA("IADM",IADMDR)) Q:(""=IADMDR)  d
	.s PAADM=$P($g(^DHCPEIADM(IADMDR)),"^",1)
	.Q:(""=PAADM)
	.//用于具体人员信息
	.i IADMDR'="" s PreIADM=$P($g(^DHCPEIADM(IADMDR)),"^",4)
	.i PreIADM'=""  s PIBIDR=$P($g(^DHCPEPreIADM(PreIADM)),"^",1)
	.Q:PIBIDR=""  
	.s PAPMINo=""
	.s PAPMINo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
    .s Name=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
    .s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
    .i SexDR'=""   s SexName=$p(^CT("SEX",SexDR),"^",2) 
    .s Tel1=$p($g(^DHCPEPreIBI(PIBIDR)),"^",6)
    .//s Tel2=$p($g(^DHCPEPreIBI(PIBIDR)),"^",7)
    .s Mobil=$p($g(^DHCPEPreIBI(PIBIDR)),"^",8)
    .i (""=Mobil)   s MobilePhone=Tel1
	.i (""'=Mobil)  s MobilePhone=Mobil
    .s Company=$p($g(^DHCPEPreIBI(PIBIDR)),"^",12)
    .S GADM=""
    .S GBIDR=""
    .S GDesc=""
    .i IADMDR'="" s GADM=$P($g(^DHCPEIADM(IADMDR)),"^",2)
    .i GADM'=""  s GBIDR=$P($g(^DHCPEGADM(GADM)),"^",1)
    .Q:(GroupDR'="")&&(GroupDR'=GADM)
    .i GBIDR'="" s GDesc=$p($g(^DHCPEGBI(GBIDR)),"^",2)
	.s PreIADM=$P($g(^DHCPEIADM(IADMDR)),"^",4)
	.s VIP=+##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PreIADM)
	.q:(VIPLevel'="")&&(VIPLevel'=VIP)
	.s OEORDRowId=0
	.f  s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,OEORDRowId)) q:OEORDRowId=""  d
	..s OEORIChildsub=0
	..f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
	...s ARCID=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	...q:ARCID=""
	...q:'$D(^DHCPETMPSWA("ItmMastList",ARCID))
	...s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	...s desc=$p(^CTLOC(RecDepDR),"^",2) 
	...Q:(""'=LocDR)&(LocDR'=RecDepDR)
	...s OEORIItemStatDR=+$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	...// 科室-医嘱-医嘱状态
	...//s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, OEORIItemStatDR)=1+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, OEORIItemStatDR))
	...Q:(6'=OEORIItemStatDR) //6	E	执行	N
	...s num=num+1
	...// 科室
	...s ^DHCPETMPSWA("RecDep", RecDepDR)=1+$G(^DHCPETMPSWA("RecDep",RecDepDR))
	...//点总计获取所有人员
    ...//s ^DHCPETMPSWA("E",RecDepDR,IAdmRowId)=PAPMINo_"^"_Name_"^"_SexName_"^"_MobilePhone_"^"_Company_"^"_GDesc
	...//具体人员信息
	...s ^DHCPETMPSWA("E",RecDepDR,ARCID,IADMDR,num)=PAPMINo_"^"_Name_"^"_SexName_"^"_MobilePhone_"^"_Company_"^"_GDesc
	...// 科室-医嘱
	...s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ARCID, 0)=1+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ARCID, 0))
	...// 医嘱
	...s ^DHCPETMPSWA("ItmMast", ARCID,0)=1+$G(^DHCPETMPSWA("ItmMast", ARCID))
	...// 医嘱-科室
	...s ^DHCPETMPSWA("ItmMast", ARCID, "RecDep", RecDepDR)=1+$G(^DHCPETMPSWA("ItmMast", ARCID, "RecDep", RecDepDR))
	...d DoExecDateGetItemFactAmount
	...// 科室单项收入
	...s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ARCID, 1)=+FactAmount+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ARCID, 1))
	...// 科室总收入
	...s ^DHCPETMPSWA("RecDep", RecDepDR, 1)=+FactAmount+$G(^DHCPETMPSWA("RecDep",RecDepDR, 1))
	...// 科室总人次
	...s ^DHCPETMPSWA("RecDep", RecDepDR, 0)=1+$G(^DHCPETMPSWA("RecDep",RecDepDR, 0))
	
	
	/*
	..s ItmMastDR=0
	..f  s ItmMastDR=$O(^DHCPETMPSWA("ItmMastList",ItmMastDR)) Q:(""=ItmMastDR)  d
	...
	...S s=$p(ItmMastDR,"||",1)
	...s d=$p(ItmMastDR,"||",2)
	...s desc=$P(^ARCIM(s,d,1),"^",2)
	...s ww=$g(^DHCPETMPSWA("ItmMastList",ItmMastDR))
	...// OE_Order.{ OEORI_SttDat }
	...s OEORISttDat=0
	...f  s OEORISttDat=$O(^OEORDi(0,"ARCIM",OEORDRowId,ItmMastDR,OEORISttDat)) Q:(""=OEORISttDat)  d
	
	....// OE_Order.{ OEORI_Childsub }
	....s OEORIChildsub=0
	....f  s OEORIChildsub=$O(^OEORDi(0,"ARCIM",OEORDRowId,ItmMastDR,OEORISttDat,OEORIChildsub)) Q:(""=OEORIChildsub)  d
	.....//DHC_PE_CRMOrder
	.....Q:(""=$O(^DHCPECRMO(0,"OEORI",(OEORDRowId_"||"_OEORIChildsub),0))) //过滤非体检项目
	.....//  OEC_OrderStatus.{ }
	.....s OEORIItemStatDR=+$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	.....// OE_OrdItem>{ OEORI_RecDep_DR }
	.....s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	.....s desc=$p(^CTLOC(RecDepDR),"^",2) 
	.....//Q:(""=RecDepDR) //
	.....Q:(""'=LocDR)&(LocDR'=RecDepDR)
	.....
	.....// 科室-医嘱-医嘱状态
	.....//s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, OEORIItemStatDR)=1+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, OEORIItemStatDR))
	.....Q:(6'=OEORIItemStatDR) //6	E	执行	N
	.....s num=num+1
	.....// 科室
	.....s ^DHCPETMPSWA("RecDep", RecDepDR)=1+$G(^DHCPETMPSWA("RecDep",RecDepDR))
	.....//点总计获取所有人员
    .....//s ^DHCPETMPSWA("E",RecDepDR,IAdmRowId)=PAPMINo_"^"_Name_"^"_SexName_"^"_MobilePhone_"^"_Company_"^"_GDesc
	.....//具体人员信息
	.....s ^DHCPETMPSWA("E",RecDepDR,ItmMastDR,IADMDR,num)=PAPMINo_"^"_Name_"^"_SexName_"^"_MobilePhone_"^"_Company_"^"_GDesc
	.....// 科室-医嘱
	.....s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 0)=1+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 0))
	.....// 医嘱
	.....s ^DHCPETMPSWA("ItmMast", ItmMastDR,0)=1+$G(^DHCPETMPSWA("ItmMast", ItmMastDR))
	.....// 医嘱-科室
	.....s ^DHCPETMPSWA("ItmMast", ItmMastDR, "RecDep", RecDepDR)=1+$G(^DHCPETMPSWA("ItmMast", ItmMastDR, "RecDep", RecDepDR))
	.....d DoExecDateGetItemFactAmount
	.....// 科室单项收入
	.....s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 1)=+FactAmount+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 1))
	.....// 科室总收入
	.....s ^DHCPETMPSWA("RecDep", RecDepDR, 1)=+FactAmount+$G(^DHCPETMPSWA("RecDep",RecDepDR, 1))
	.....// 科室总人次
	.....s ^DHCPETMPSWA("RecDep", RecDepDR, 0)=1+$G(^DHCPETMPSWA("RecDep",RecDepDR, 0))
	w i,!
	*/
	
	//s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion"))
    s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",CurLocID))
    if (LisNewVersion'="Y"){
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
	...//具体人员信息
	...s PAADM=""
	...s PAADM=$P($G(^OEORD(OEORDRowId)),"^",1)
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)          //add 2009-07-07 
  	...q:LocFlag=1
	...s IADMDR=""
	...S PreIADM=""
	...S PIBIDR=""
	...i PAADM'=""  s IADMDR=$o(^DHCPEIADM(0,"PAADM",PAADM,0)) 
	...i IADMDR'="" s PreIADM=$P($g(^DHCPEIADM(IADMDR)),"^",4)
	...i PreIADM'=""  s PIBIDR=$P($G(^DHCPEPreIADM(PreIADM)),"^",1)
	...Q:PIBIDR=""  
	...s PAPMINo=""
	...s PAPMINo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
    ...s Name=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
    ...s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
    ...i SexDR'=""   s SexName=$p(^CT("SEX",SexDR),"^",2) 
    ...s Tel1=$p($g(^DHCPEPreIBI(PIBIDR)),"^",6)
    ...//s Tel2=$p($g(^DHCPEPreIBI(PIBIDR)),"^",7)
    ...s Mobil=$p($g(^DHCPEPreIBI(PIBIDR)),"^",8)
    ...i (""=Mobil)   s MobilePhone=Tel1
	...i (""'=Mobil)  s MobilePhone=Mobil
    ...s Company=$p($g(^DHCPEPreIBI(PIBIDR)),"^",12)
    ...S GADM=""
    ...S GBIDR=""
    ...S GDesc=""
    ...s GADM=$P($g(^DHCPEIADM(IADMDR)),"^",2)
    ...Q:(GroupDR'="")&&(GroupDR'=GADM)
    ...i GADM'=""  s GBIDR=$P($G(^DHCPEGADM(GADM)),"^",1)
    ...i GBIDR'="" s GDesc=$p($G(^DHCPEGBI(GBIDR)),"^",2)
	...// OE_Order.{ OEORI_Childsub }
	...s OEORIChildsub=0
	...f  s OEORIChildsub=$O(^OEORD(0,"EpisNo",EPVISVisitNumber,OEORDRowId,OEORIChildsub)) Q:(""=OEORIChildsub)  d
	....
	....//DHC_PE_CRMOrder
	....Q:(""=$O(^DHCPECRMO(0,"OEORI",(OEORDRowId_"||"_OEORIChildsub),0))) //过滤非体检客户项目
	....
	....//医嘱状态 OEORI_ItemStat_DR(OEC_OrderStatus)
	....s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	....
	....// OEORI_ItmMast_DR
	....s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	....Q:(""'=OEItemDR)&(OEItemDR'=ItmMastDR)
	....
	....// OEORI_RecDep_DR
	....s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	....Q:(""=RecDepDR) //
	....Q:(""'=LocDR)&(LocDR'=RecDepDR)
	....s num=num+1
	....//s ^DHCPETMPSWA("E",RecDepDR,IAdmRowId)=PAPMINo_"^"_Name_"^"_SexName_"^"_MobilePhone_"^"_Company_"^"_GDesc
	....// 科室
	....s ^DHCPETMPSWA("RecDep", RecDepDR)=1+$G(^DHCPETMPSWA("RecDep",RecDepDR))
	....// 科室-医嘱-医嘱状态
	....//s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, OEORIItemStatDR)=1+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, OEORIItemStatDR))
	....Q:(6'=OEORIItemStatDR) //6	E	执行	N
	....s ^DHCPETMPSWA("E",RecDepDR,ItmMastDR,IADMDR,num)=PAPMINo_"^"_Name_"^"_SexName_"^"_MobilePhone_"^"_Company_"^"_GDesc
	....// 科室-医嘱
	....s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 0)=1+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 0))
	....// 医嘱
	....s ^DHCPETMPSWA("ItmMast", ItmMastDR)=1+$G(^DHCPETMPSWA("ItmMast", ItmMastDR))
	....// 医嘱-科室
	....s ^DHCPETMPSWA("ItmMast", ItmMastDR, "RecDep", RecDepDR)=1+$G(^DHCPETMPSWA("ItmMast", ItmMastDR, "RecDep", RecDepDR))
	....s ^DHCPETMPSWA("ItmMast", ItmMastDR, "OEORD", OEORDRowId)=$ZD(vDate,3)
	....d DoExecDateGetItemFactAmount
	....// 科室单项收入
	....s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 1)=+FactAmount+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 1))
	....// 科室总收入
	....s ^DHCPETMPSWA("RecDep", RecDepDR, 1)=+FactAmount+$G(^DHCPETMPSWA("RecDep",RecDepDR, 1))
	....// 科室总人次
	....s ^DHCPETMPSWA("RecDep", RecDepDR, 0)=1+$G(^DHCPETMPSWA("RecDep",RecDepDR, 0))
    }else{
	 
	 //参数: HospitalDR体检的一般都默认的1，具体如果查询不到，看下是不是默认不是1
	 S HospitalDR=%session.Get("LOGON.HOSPID")  
	 s HospitalDR=1
	 //标本接收时间 
	 S SttDate=$zd(DateBegin,8)
	 s EndDate=$zd(DateEnd,8)
	 s vDate=$O(^dbo.RPVisitNumberI("IndexReceiveDate",HospitalDR,SttDate),-1)
    f  s vDate= $O(^dbo.RPVisitNumberI("IndexReceiveDate",HospitalDR,vDate)) q:(vDate="")||($l(EndDate)&&(vDate>EndDate))  d	
   .s VisitNumberDR="" 
   .f  s VisitNumberDR= $O(^dbo.RPVisitNumberI("IndexReceiveDate",HospitalDR,vDate,VisitNumberDR)) q:VisitNumberDR=""  d
   ..s gdata=$g(^dbo.RPVisitNumberD(VisitNumberDR))
	..s EPVISVisitNumber=$lg(gdata,2)
    ..s OEORDRowId=0
	..f  s OEORDRowId=$O(^OEORD(0,"EpisNo",EPVISVisitNumber,OEORDRowId)) Q:(""=OEORDRowId)  d
	...//具体人员信息
	...s PAADM=""
	...s PAADM=$P($G(^OEORD(OEORDRowId)),"^",1)
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)
  	...q:LocFlag=1
	...s IADMDR=""
	...S PreIADM=""
	...S PIBIDR=""
	...i PAADM'=""  s IADMDR=$o(^DHCPEIADM(0,"PAADM",PAADM,0)) 
	...i IADMDR'="" s PreIADM=$P($g(^DHCPEIADM(IADMDR)),"^",4)
	...i PreIADM'=""  s PIBIDR=$P($G(^DHCPEPreIADM(PreIADM)),"^",1)
	...Q:PIBIDR=""  
	...s PAPMINo=""
	...s PAPMINo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
    ...s Name=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
    ...s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
    ...i SexDR'=""   s SexName=$p(^CT("SEX",SexDR),"^",2) 
    ...s Tel1=$p($g(^DHCPEPreIBI(PIBIDR)),"^",6)
    ...//s Tel2=$p($g(^DHCPEPreIBI(PIBIDR)),"^",7)
    ...s Mobil=$p($g(^DHCPEPreIBI(PIBIDR)),"^",8)
    ...i (""=Mobil) s MobilePhone=Tel1
	...i (""'=Mobil) s MobilePhone=Mobil
    ...s Company=$p($g(^DHCPEPreIBI(PIBIDR)),"^",12)
    ...S GADM=""
    ...S GBIDR=""
    ...S GDesc=""
    ...s GADM=$P($g(^DHCPEIADM(IADMDR)),"^",2)
    ...Q:(GroupDR'="")&&(GroupDR'=GADM)
    ...i GADM'=""  s GBIDR=$P($G(^DHCPEGADM(GADM)),"^",1)
    ...i GBIDR'="" s GDesc=$p($G(^DHCPEGBI(GBIDR)),"^",2)
	...// OE_Order.{ OEORI_Childsub }
	...s OEORIChildsub=0
	...f  s OEORIChildsub=$O(^OEORD(0,"EpisNo",EPVISVisitNumber,OEORDRowId,OEORIChildsub)) Q:(""=OEORIChildsub)  d
	....
	....//DHC_PE_CRMOrder
	....Q:(""=$O(^DHCPECRMO(0,"OEORI",(OEORDRowId_"||"_OEORIChildsub),0))) //过滤非体检客户项目
	....
	....//医嘱状态 OEORI_ItemStat_DR(OEC_OrderStatus)
	....s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	....
	....// OEORI_ItmMast_DR
	....s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	....Q:(""'=OEItemDR)&(OEItemDR'=ItmMastDR)
	....
	....// OEORI_RecDep_DR
	....s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	....Q:(""=RecDepDR) //
	....Q:(""'=LocDR)&(LocDR'=RecDepDR)
	....s num=num+1
	....// 科室
	....s ^DHCPETMPSWA("RecDep", RecDepDR)=1+$G(^DHCPETMPSWA("RecDep",RecDepDR))
	....// 科室-医嘱-医嘱状态
	....Q:(6'=OEORIItemStatDR) //6 E 执行 N
	....s ^DHCPETMPSWA("E",RecDepDR,ItmMastDR,IADMDR,num)=PAPMINo_"^"_Name_"^"_SexName_"^"_MobilePhone_"^"_Company_"^"_GDesc
	....// 科室-医嘱
	....s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 0)=1+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 0))
	....// 医嘱
	....s ^DHCPETMPSWA("ItmMast", ItmMastDR)=1+$G(^DHCPETMPSWA("ItmMast", ItmMastDR))
	....// 医嘱-科室
	....s ^DHCPETMPSWA("ItmMast", ItmMastDR, "RecDep", RecDepDR)=1+$G(^DHCPETMPSWA("ItmMast", ItmMastDR, "RecDep", RecDepDR))
	....s ^DHCPETMPSWA("ItmMast", ItmMastDR, "OEORD", OEORDRowId)=$zd($ZDh(vDate,8),3)
	....d DoExecDateGetItemFactAmount
	....// 科室单项收入
	....s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 1)=+FactAmount+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 1))
	....// 科室总收入
	....s ^DHCPETMPSWA("RecDep", RecDepDR, 1)=+FactAmount+$G(^DHCPETMPSWA("RecDep",RecDepDR, 1))
	....// 科室总人次
	....s ^DHCPETMPSWA("RecDep", RecDepDR, 0)=1+$G(^DHCPETMPSWA("RecDep",RecDepDR, 0))


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
	  ..s ItmMastDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
	  ..q:(OEItemDR'=ItmMastDR)&(OEItemDR'="")
      ..Q:(""=$O(^DHCPECRMO(0,"OEORI",OEORDIRowId,0))) //过滤非体检项目
      ..s RecDepDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,3),"^",6)
      ..s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
      ..q:(""'=LocDR)&(LocDR'=RecDepDR)
      ..s ItmMastDesc=$p(^ARCIM($p(ItmMastDR,"||",1),$p(ItmMastDR,"||",2),1),"^",2)
      ..s PAADM=$p(^DHCPACRegInfo(Regrowid),"^",10)
      ..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)          //add 2009-07-07 
  	  ..q:LocFlag=1
      ..s IADMDR=0
	  ..s IADMDR=$o(^DHCPEIADM(0,"PAADM",PAADM,0)) 
	  ..q:IADMDR=""
	  ..s PreIADM=$P($g(^DHCPEIADM(IADMDR)),"^",4)
	  ..i PreIADM'=""  s PIBIDR=$P($G(^DHCPEPreIADM(PreIADM)),"^",1)
	  ..q:PIBIDR=""  
      ..s PAPMINo=""
	  ..s PAPMINo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
      ..s Name=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
      ..s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
      ..i SexDR'=""   s SexName=$p(^CT("SEX",SexDR),"^",2) 
      ..s Tel1=$p($g(^DHCPEPreIBI(PIBIDR)),"^",6)
      ..//s Tel2=$p($g(^DHCPEPreIBI(PIBIDR)),"^",7)
      ..s Mobil=$p($g(^DHCPEPreIBI(PIBIDR)),"^",8)
      ..i (""=Mobil)   s MobilePhone=Tel1
      ..i (""'=Mobil)  s MobilePhone=Mobil
      ..s Company=$p($g(^DHCPEPreIBI(PIBIDR)),"^",12)
      ..S GADM=""
      ..S GBIDR=""
      ..S GDesc=""
      ..s GADM=$P($g(^DHCPEIADM(IADMDR)),"^",2)
      ..Q:(GroupDR'="")&&(GroupDR'=GADM)
      ..i GADM'=""  s GBIDR=$P($G(^DHCPEGADM(GADM)),"^",1)
      ..i GBIDR'="" s GDesc=$p($G(^DHCPEGBI(GBIDR)),"^",2)
       ..s ^DHCPETMPSWA("RecDep", RecDepDR)=1+$G(^DHCPETMPSWA("RecDep",RecDepDR))
	  ..// 科室-医嘱-医嘱状态
	  ..//s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, OEORIItemStatDR)=1+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, OEORIItemStatDR))
	  ..Q:(6'=OEORIItemStatDR) //6	E	执行	N
	  ..//w !,PAPMINo
	  ..s num=num+1
	  ..s ^DHCPETMPSWA("E",RecDepDR,ItmMastDR,IADMDR,num)=PAPMINo_"^"_Name_"^"_SexName_"^"_MobilePhone_"^"_Company_"^"_GDesc
	  ..// 科室-医嘱
	  ..s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 0)=1+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 0))
	  ..// 医嘱
	  ..s ^DHCPETMPSWA("ItmMast", ItmMastDR)=1+$G(^DHCPETMPSWA("ItmMast", ItmMastDR))
	  ..// 医嘱-科室
	  ..s ^DHCPETMPSWA("ItmMast", ItmMastDR, "RecDep", RecDepDR)=1+$G(^DHCPETMPSWA("ItmMast", ItmMastDR, "RecDep", RecDepDR))
	 
	  ..d DoExecDateGetItemFactAmount
	  ..// 科室单项收入
	  ..s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 1)=+FactAmount+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 1))
	  ..// 科室总收入
	  ..s ^DHCPETMPSWA("RecDep", RecDepDR, 1)=+FactAmount+$G(^DHCPETMPSWA("RecDep",RecDepDR, 1))
	  ..// 科室总人次
	  ..s ^DHCPETMPSWA("RecDep", RecDepDR, 0)=1+$G(^DHCPETMPSWA("RecDep",RecDepDR, 0))
	
	
    i (""=DateBegin)   s date=0
    i (""=DateEnd)     s DateEnd=+$h 
    s date=DateBegin-1                                                                  //可以从当天开始查询
 	f  s date=$o(^DHCPEDataEx("DHCPEOtherStation",date))  q:(date="")||(date>DateEnd)  d   //当日期不符合条件退出
	.s OEORDIRowId=0
	.f  s OEORDIRowId=$o(^DHCPEDataEx("DHCPEOtherStation",date,OEORDIRowId))  q:OEORDIRowId=""  d
	 ..s OEORDRowId=$p(OEORDIRowId,"||",1)
     ..s OEORIChildsub=$p(OEORDIRowId,"||",2)
     ..Q:(""=$O(^DHCPECRMO(0,"OEORI",(OEORDRowId_"||"_OEORIChildsub),0))) //过滤非体检项目
     ..s ItmMastDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
     ..s RecDepDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,3),"^",6)
     ..s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
     ..q:(""'=LocDR)&(LocDR'=RecDepDR)
     ..s ItmMastDesc=$p(^ARCIM($p(ItmMastDR,"||",1),$p(ItmMastDR,"||",2),1),"^",2)
     ..s PAADM=$p(^OEORD(OEORDRowId),"^",1)
     ..q:PAADM=""
     ..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)          //add 2009-07-07 
  	 ..q:LocFlag=1
     ..s IADMDR=0
	 ..s IADMDR=$o(^DHCPEIADM(0,"PAADM",PAADM,0)) 
	 ..q:IADMDR=""
	 ..s PreIADM=$P($g(^DHCPEIADM(IADMDR)),"^",4)
	 ..i PreIADM'=""  s PIBIDR=$P($G(^DHCPEPreIADM(PreIADM)),"^",1)
	 ..q:PIBIDR=""  
     ..s PAPMINo=""
	 ..s PAPMINo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
     ..s Name=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
     ..s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
     ..i SexDR'=""   s SexName=$p(^CT("SEX",SexDR),"^",2) 
     ..s Tel1=$p($g(^DHCPEPreIBI(PIBIDR)),"^",6)
     ..//s Tel2=$p($g(^DHCPEPreIBI(PIBIDR)),"^",7)
     ..s Mobil=$p($g(^DHCPEPreIBI(PIBIDR)),"^",8)
     ..i (""=Mobil)   s MobilePhone=Tel1
     ..i (""'=Mobil)  s MobilePhone=Mobil
     ..s Company=$p($g(^DHCPEPreIBI(PIBIDR)),"^",12)
      ..S GADM=""
      ..S GBIDR=""
      ..S GDesc=""
      ..s GADM=$P($g(^DHCPEIADM(IADMDR)),"^",2)
      ..i GADM'=""  s GBIDR=$P($G(^DHCPEGADM(GADM)),"^",1)
      ..i GBIDR'="" s GDesc=$p($G(^DHCPEGBI(GBIDR)),"^",2)
       ..s ^DHCPETMPSWA("RecDep", RecDepDR)=1+$G(^DHCPETMPSWA("RecDep",RecDepDR))
	  ..// 科室-医嘱-医嘱状态
	  ..//s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, OEORIItemStatDR)=1+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, OEORIItemStatDR))
	  ..Q:(6'=OEORIItemStatDR) //6	E	执行	N
	  ..//w !,PAPMINo
	  ..s num=num+1
	  ..s ^DHCPETMPSWA("E",RecDepDR,ItmMastDR,IADMDR,num)=PAPMINo_"^"_Name_"^"_SexName_"^"_MobilePhone_"^"_Company_"^"_GDesc
	  ..// 科室-医嘱
	  ..s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 0)=1+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 0))
	  ..// 医嘱
	  ..s ^DHCPETMPSWA("ItmMast", ItmMastDR)=1+$G(^DHCPETMPSWA("ItmMast", ItmMastDR))
	  ..// 医嘱-科室
	  ..s ^DHCPETMPSWA("ItmMast", ItmMastDR, "RecDep", RecDepDR)=1+$G(^DHCPETMPSWA("ItmMast", ItmMastDR, "RecDep", RecDepDR))
	 
	  ..d DoExecDateGetItemFactAmount
	  ..// 科室单项收入
	  ..s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 1)=+FactAmount+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR, 1))
	  ..// 科室总收入
	  ..s ^DHCPETMPSWA("RecDep", RecDepDR, 1)=+FactAmount+$G(^DHCPETMPSWA("RecDep",RecDepDR, 1))
	  ..// 科室总人次
	  ..s ^DHCPETMPSWA("RecDep", RecDepDR, 0)=1+$G(^DHCPETMPSWA("RecDep",RecDepDR, 0))
	  q ""

DoExecDateGetItemFactAmount
	s FactAmount=0
	
	s OrdDeptDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",1)
	Q:(""'=OrdDeptDR) // 医嘱套项目不计算
	s OEORDIDR=OEORDRowId_"||"_OEORIChildsub
	s crmodr=$O(^DHCPECRMO(0,"OEORI",OEORDIDR,0))
    Q:crmodr=""
	s ^DHCPETMPSWA("DoExecDateGetItemFactAmount")=OEORDIDR
	s PIOIDR=$P($G(^DHCPECRMO(crmodr)),"^",2)
	s PIOEDR=$P(^DHCPEPreIADM($p(PIOIDR,"||",1),"ORDITEM",$p(PIOIDR,"||",2)),"^",2)
	If PIOEDR'="" Do
	.d ##class(web.DHCPE.OrdSetsPrice).SplitOrdSetPrice(PIOEDR)
	.s FactAmount=$G(^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",PIOEDR,PIOIDR))
	Else  Do
	.s FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PIOIDR,"","")

	Q
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.StationWorkStatistic", "SearchLoc","")

Query SearchLoc(Desc As %Library.String = "") As %SQLQuery(ROWSPEC = "CTLOC_Code:%String:编码,CTLOC_Desc:%String:描述, CTLOC_RowId:%String:ID") [ SqlProc ]
{
	select CTLOC_Code, CTLOC_Desc, CTLOC_RowId
	from CT_loc
	where CTLOC_Desc %STARTSWITH :Desc
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.StationWorkStatistic", "SearchLocNew","")
Query SearchLocNew(Desc As %Library.String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Query(ROWSPEC = "CTLOC_Code:%String:编码,CTLOC_Desc:%String:描述, CTLOC_RowId:%String:ID")
{
}

ClassMethod SearchLocNewExecute(ByRef qHandle As %Binary, Desc As %String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 
    s curHospId=%session.Data("LOGON.HOSPID") ;当前登陆的医院Id
	;s curHospId=2
    i $g(Desc)'="" s Desc=$$ALPHAUP^SSUTIL4(Desc) //进行大小写转换 
 	s CTLOCCode="",desc=""
	s ctlocrowid=0
	f  s ctlocrowid=$o(^CTLOC(ctlocrowid)) q:ctlocrowid=""  d
	.s CTLOCCode=$p(^CTLOC(ctlocrowid),"^",1)
	.s desc=$p(^CTLOC(ctlocrowid),"^",2)
	.; locHospId=$p(^CTLOC(ctlocrowid),"^",22)
	.;:(locHospId'=curHospId)&(locHospId'="")&(curHospId'="")
	.; LocActiveFrom=+$p($g(^CTLOC(ctlocrowid)),"^",24)
	.;s LocActiveTo=+$p($g(^CTLOC(ctlocrowid)),"^",25)
	.;q:((LocActiveFrom'=0)&&(LocActiveFrom>+$h))||((LocActiveTo<+$h)&&(LocActiveTo'=0))
	.s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("CT_Loc",ctlocrowid,Type,LocID)
    .q:DateShowFlag="Y"
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("CT_Loc",ctlocrowid,hospId)
	.q:(HOSPshowFlag="N")

	.q:##class(web.DHCPE.Public.SettingEdit).CheckLocDesc(ctlocrowid,Desc)'=1
    .d CTLocList      

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

    
CTLocList      
	set Data=$lb(CTLOCCode,desc,$G(ctlocrowid))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchLocNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchLocNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchLocNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchLocNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/*
/// 月科室工作量统计
/// w ##Class(web.DHCPE.Report.StationWorkStatistic).StationStatisticImport("","","2007-12")
ClassMethod StationStatisticImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", ImportDate As %Library.String = "") As %Status
{
	k ^DHCPETMPSWA
 	Q:(""=ImportDate) ""
	s DateBegin=$ZDH(ImportDate_"-01",3)
	s MaxDay=27
	while(+$P($ZD(DateBegin+MaxDay, 3),"-",2)=+$P(ImportDate,"-",2)) {
		s MaxDay=1+MaxDay
	}
	s DateEnd=DateBegin+MaxDay
 	
 	
	//
	s PAADM=""
	f  s PAADM=$O(^DHCPEIADM(0,"PAADM",PAADM)) q:PAADM=""  d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)          //add 2009-07-07 
  	.q:LocFlag=1
	.// OE_Order.{ OEORD_RowId }
	.s OEORDRowId=0
	.f  s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,OEORDRowId)) q:OEORDRowId=""  d
	..// OE_OrdItem.{ OEORI_Childsub }
	..s OEORIChildsub=0
	..f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
	...
	...// 过滤非医嘱站点
	...s OtherSTRowId=$O(^DHCPEST(0,"STORD_ARCIM",(OEORDRowId_"||"_OEORIChildsub),0))
	...Q:(OtherSTRowId=$D(^DHCPESetting("DHCPE","StationId_Other")))
	...
	...
	...
	...// OEORI_SttDat
	...s SttDat=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",9)
	...Q:(""'=DateBegin)&(+DateBegin>SttDat)
	...Q:(""'=DateEnd)&(+DateEnd<=SttDat)
	...//  OEC_OrderStatus
	...s OEORIItemStatDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	...Q:(6'=OEORIItemStatDR) //6	E	执行	N
	...// OEORI_ItmMast_DR
	...s ItmMastDR=$P($G(^OEORD(OEORDRowId, "I", OEORIChildsub,1)),"^",2)
	...//Q:(""'=OEItemDR)&(OEItemDR'=ItmMastDR)
	...// OEORI_RecDep_DR
	...s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	...//Q:(""'=LocDR)&(LocDR'=RecDepDR)
	...s ^DHCPETMPSWA("RecDep", RecDepDR)=+$G(^DHCPETMPSWA("RecDep",RecDepDR))+1
	...s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR)=+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR))+1
	...s ^DHCPETMPSWA("RecDep", RecDepDR, "Day", SttDat)=+$G(^DHCPETMPSWA("RecDep", RecDepDR, "Day", SttDat))+1
	...s ^DHCPETMPSWA("ItmMast", ItmMastDR)=+$G(^DHCPETMPSWA("ItmMast", ItmMastDR))+1
	...s ^DHCPETMPSWA("ItmMast", ItmMastDR, RecDepDR)=+$G(^DHCPETMPSWA("ItmMast", ItmMastDR, RecDepDR))+1
	...
	
	s retValue=""
	s RecDepDR=0
	f  s RecDepDR=$O(^DHCPETMPSWA("RecDep", RecDepDR)) q:RecDepDR=""  d
	.//  CT_Loc.{ CTLOC_Desc }
	.s CTLOCDesc=$P($G(^CTLOC(RecDepDR)),"^",2)
	.s Amount=+$G(^DHCPETMPSWA("RecDep", RecDepDR))
	.s retValue=retValue_CTLOCDesc_":"_Amount_"人;"
	.
	.

	Q retValue
}

/// 每日科室工作量统计
/// d ##Class(web.DHCPE.Report.StationWorkStatistic).StationDayStatisticImport("Out","","2008-1")
ClassMethod StationDayStatisticImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{
	k ^DHCPETMPSWA
	s ImportDate=Instring
 	Q:(""=ImportDate) ""
	s DateBegin=$ZDH(ImportDate_"-01",3)
	s MaxDay=27
	while(+$P($ZD(DateBegin+MaxDay, 3),"-",2)=+$P(ImportDate,"-",2)) {
		s MaxDay=1+MaxDay
	}
	s DateEnd=DateBegin+MaxDay
 	
 	
	//
	s PAADM=""
	f  s PAADM=$O(^DHCPEIADM(0,"PAADM",PAADM)) q:PAADM=""  d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)          //add 2009-07-07 
  	.q:LocFlag=1
	.s IAdmRowId=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	.Q:(""=IAdmRowId)
	.// IADM_AdmDate
	.s IADMAdmDate=$P($g(^DHCPEIADM(IAdmRowId)),"^",5)
	.
	.// IADM_Status
	.s IADMStatus=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	.
	.Q:'(("ARRIVED"=IADMStatus)||("COMPLETED"=IADMStatus))
	.
	.s patMatId=$p($G(^PAADM(PAADM)),"^",1) 
	.Q:(""=patMatId)
	.s PatName=$p($g(^PAPER(patMatId,"ALL")),"^",1)
	.s PatNo=$p($g(^PAPER(patMatId,"PAT",1)),"^",2)
	.
	.
	.
	.// OE_Order.{ OEORD_RowId }
	.s OEORDRowId=0
	.f  s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,OEORDRowId)) q:OEORDRowId=""  d
	..// OE_OrdItem.{ OEORI_Childsub }
	..s OEORIChildsub=0
	..f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
	...
	...// 过滤非医嘱站点
	...s OtherSTRowId=$O(^DHCPEST(0,"STORD_ARCIM",(OEORDRowId_"||"_OEORIChildsub),0))
	...Q:(OtherSTRowId=$D(^DHCPESetting("DHCPE","StationId_Other")))
	...
	...// OEORI_SttDat
	...s SttDat=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",9)
	...Q:(""'=DateBegin)&(+DateBegin>SttDat)
	...Q:(""'=DateEnd)&(+DateEnd<=SttDat)
	...//  OEC_OrderStatus
	...s OEORIItemStatDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	...Q:(6'=OEORIItemStatDR) //6	E	执行	N
	...// OEORI_ItmMast_DR
	...s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	...//Q:(""'=OEItemDR)&(OEItemDR'=ItmMastDR)
	...// OEORI_RecDep_DR
	...s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	...//Q:(""'=LocDR)&(LocDR'=RecDepDR)
	...s ^DHCPETMPSWA("RecDep", RecDepDR)=+$G(^DHCPETMPSWA("RecDep",RecDepDR))+1
	...s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR)=+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR))+1
	...s ^DHCPETMPSWA("ItmMast", ItmMastDR)=+$G(^DHCPETMPSWA("ItmMast", ItmMastDR))+1
	...s ^DHCPETMPSWA("ItmMast", ItmMastDR, RecDepDR)=+$G(^DHCPETMPSWA("ItmMast", ItmMastDR, RecDepDR))+1
	...
	...
	...
	...s:($G(^DHCPETMPSWA("RecDep", RecDepDR, "Day", SttDat, "ADMList"))'[(PAADM_"^")) ^DHCPETMPSWA("RecDep", RecDepDR, "Day", SttDat)=+$G(^DHCPETMPSWA("RecDep", RecDepDR, "Day", SttDat))+1
	...s:($G(^DHCPETMPSWA("Day", SttDat, "ADMList"))'[(PAADM_"^")) ^DHCPETMPSWA("Day", SttDat)=+$G(^DHCPETMPSWA("Day", SttDat))+1
	...
	...// 测试用
	...s:($G(^DHCPETMPSWA("RecDep", RecDepDR, "Day", SttDat, "ADMList"))'[(PAADM_"^")) ^DHCPETMPSWA("RecDep", RecDepDR, "Day", SttDat, "ADMList")=$G(^DHCPETMPSWA("RecDep", RecDepDR, "Day", SttDat, "ADMList"))_PAADM_"^"
	...// 测试用
	...s:($G(^DHCPETMPSWA("Day", SttDat, "ADMList"))'[(PAADM_"^")) ^DHCPETMPSWA("Day", SttDat, "ADMListName")=$G(^DHCPETMPSWA("Day", SttDat, "ADMListName"))_PatName_"^"
	...// 测试用
	...s:($G(^DHCPETMPSWA("Day", SttDat, "ADMList"))'[(PAADM_"^")) ^DHCPETMPSWA("Day", SttDat, IAdmRowId)=IAdmRowId_"^"_PAADM_"^"_IADMAdmDate_"^"_PatNo_"^"_PatName
	...
	...// 过滤体检人员重复的项目
	...s:($G(^DHCPETMPSWA("Day", SttDat, "ADMList"))'[(PAADM_"^")) ^DHCPETMPSWA("Day", SttDat, "ADMList")=$G(^DHCPETMPSWA("Day", SttDat, "ADMList"))_PAADM_"^"
	...
	
	s RecDepList="^体检总数"
	// 科室列表
	s RecDepDR=0
	f  s RecDepDR=$O(^DHCPETMPSWA("RecDep", RecDepDR)) q:RecDepDR=""  d
	.//  CT_Loc.{ CTLOC_Desc }
	.s CTLOCDesc=$P($G(^CTLOC(RecDepDR)),"^",2)
	.s RecDepList=RecDepList_"^"_CTLOCDesc
	.
	s RecDepList=RecDepList_"^"_"备注"
	s retValue=RecDepList_";"
	
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(RecDepList,"O","JS")_"');"
	.&javascript<#(retval)#>
	.//w RecDepList,!
	
	//w !,"科室列表:"_retValue,!
	
	s AdmDate=DateBegin
	while (AdmDate<+DateEnd) {
		
		s DayAmount=""
		s RecDepDR=0		
		f  s RecDepDR=$O(^DHCPETMPSWA("RecDep", RecDepDR)) q:RecDepDR=""  d
		.//  CT_Loc.{ CTLOC_Desc }
		.s CTLOCDesc=$P($G(^CTLOC(RecDepDR)),"^",2)
		.s Amount=+$G(^DHCPETMPSWA("RecDep", RecDepDR, "Day", AdmDate))
		.s DayAmount=DayAmount_"^"_Amount
		.
		
		s Date=$ZD(AdmDate,3)
		s DayAmount=Date_"^"_+$G(^DHCPETMPSWA("Day", AdmDate))_DayAmount
		//w "每日情况:"_DayAmount,!
		
		s retValue=retValue_DayAmount_";"
		s AdmDate=+AdmDate+1
		
		i ""'=itmjs d
		.s retval=itmjs_"('"_$ZCVT(DayAmount,"O","JS")_"');"
		.&javascript<#(retval)#>
		.//w DayAmount,!
	}
	
	Q retValue
}
*/
ClassMethod StationStatisticImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", ImportDate As %Library.String = "") As %Status
{
	k ^DHCPETMPSWA
 	s Instring=ImportDate
 	s ImportDate=$P(Instring,"^",1)
	s StartDate=$P(Instring,"^",2)
	s EndDate=$P(Instring,"^",3)
 	s:StartDate'="" StartDate=$ZDH(StartDate,4)
 	s:EndDate'="" EndDate=$ZDH(EndDate,4)
 	
 	Q:(""=ImportDate) ""
	s DateBegin=$ZDH(ImportDate_"-01",3)
	s MaxDay=27
	while(+$P($ZD(DateBegin+MaxDay, 3),"-",2)=+$P(ImportDate,"-",2)) {
		s MaxDay=1+MaxDay
	}
	s DateEnd=DateBegin+MaxDay
 	s:StartDate'="" DateBegin=StartDate
  	s:EndDate'="" DateEnd=EndDate
	s PAADM=""
	f  s PAADM=$O(^DHCPEIADM(0,"PAADM",PAADM)) q:PAADM=""  d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)          //add 2009-07-07 
  	.q:LocFlag=1
	.s IAdmRowId=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	.s GAdm=$p(^DHCPEIADM(IAdmRowId),"^",2)
	.;q:GAdm=224
	.s IADMAdmDate=$P($g(^DHCPEIADM(IAdmRowId)),"^",5)
	.s PIADMAdm=$P($g(^DHCPEIADM(IAdmRowId)),"^",4)
	.Q:(""'=DateBegin)&(+DateBegin>IADMAdmDate)
	.Q:(""'=DateEnd)&(+DateEnd<=IADMAdmDate)
	.s CurLoc=$P($G(^PAADM(PAADM)),"^",4)
	.s OEORDRowId=0
	.f  s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,OEORDRowId)) q:OEORDRowId=""  d
	..// OE_OrdItem.{ OEORI_Childsub }
	..s OEORIChildsub=0
	..f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
	...// 过滤非医嘱站点
	...s OtherSTRowId=$O(^DHCPEST(0,"STORD_ARCIM",(OEORDRowId_"||"_OEORIChildsub),0))
	...s SttDat=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",9)
	...//  OEC_OtherSTRowIdOrderStatus
	...s OEORIItemStatDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	...;Q:(6'=OEORIItemStatDR)&&(OtherSTRowId'=$G(^DHCPESetting("DHCPE","StationId_Other"))) //6	E	执行	N
	...Q:(6'=OEORIItemStatDR)&&(OtherSTRowId'=$G(^DHCPESetting("DHCPE","StationId_Other",CurLoc))) //6 E 执行 N
   	...;Q:(OtherSTRowId=$G(^DHCPESetting("DHCPE","StationId_Other")))&&(OEORIItemStatDR'=1)
   	...Q:(OtherSTRowId=$G(^DHCPESetting("DHCPE","StationId_Other",CurLoc)))&&(OEORIItemStatDR'=1)
	...s ItmMastDR=$P($G(^OEORD(OEORDRowId, "I", OEORIChildsub,1)),"^",2)
	...s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	...//Q:(""'=LocDR)&(LocDR'=RecDepDR)
	...s:($G(^DHCPETMPSWA("RecDep",RecDepDR,"ADMList"))'[("^"_IAdmRowId_"^")) ^DHCPETMPSWA("RecDep", RecDepDR)=+$G(^DHCPETMPSWA("RecDep",RecDepDR))+1
	...s:($G(^DHCPETMPSWA("RecDep",RecDepDR,"ADMList"))'[("^"_IAdmRowId_"^")) ^DHCPETMPSWA("RecDep",RecDepDR,"ADMList")="^"_$G(^DHCPETMPSWA("RecDep",RecDepDR,"ADMList"))_IAdmRowId_"^"

	s retValue=""
	s RecDepDR=0
	f  s RecDepDR=$O(^DHCPETMPSWA("RecDep", RecDepDR)) q:RecDepDR=""  d
	.//  CT_Loc.{ CTLOC_Desc }
	.s CTLOCDesc=$P($G(^CTLOC(RecDepDR)),"^",2)
	.s Amount=+$G(^DHCPETMPSWA("RecDep", RecDepDR))
	.s retValue=retValue_CTLOCDesc_":"_Amount_"人;"
	.
	.

	Q retValue
}

/// 每日科室工作量统计
/// d ##Class(web.DHCPE.Report.StationWorkStatistic).StationDayStatisticImport("","","2009-5")
ClassMethod StationDayStatisticImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{
	k ^DHCPETMPSWA
	s ImportDate=$P(Instring,"^",1)
	s StartDate=$P(Instring,"^",2)
	s EndDate=$P(Instring,"^",3)
 	s:StartDate'="" StartDate=$ZDH(StartDate,4)
 	s:EndDate'="" EndDate=$ZDH(EndDate,4)
 	Q:(""=ImportDate) ""
	s DateBegin=$ZDH(ImportDate_"-01",3)
	s MaxDay=27
	while(+$P($ZD(DateBegin+MaxDay, 3),"-",2)=+$P(ImportDate,"-",2)) {
		s MaxDay=1+MaxDay
	}
	s DateEnd=DateBegin+MaxDay
	s:StartDate'="" DateBegin=StartDate
  	s:EndDate'="" DateEnd=EndDate
	//
	s PAADM=""
	f  s PAADM=$O(^DHCPEIADM(0,"PAADM",PAADM)) q:PAADM=""  d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)          //add 2009-07-07 
  	.q:LocFlag=1
	.s IAdmRowId=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	.s GAdm=$p(^DHCPEIADM(IAdmRowId),"^",2)
	.s IADMAdmDate=$P($g(^DHCPEIADM(IAdmRowId)),"^",5)
	.s PIADMAdm=$P($g(^DHCPEIADM(IAdmRowId)),"^",4)
	.Q:(""'=DateBegin)&(+DateBegin>IADMAdmDate)
	.Q:(""'=DateEnd)&(+DateEnd<=IADMAdmDate)
	.s IADMStatus=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	.Q:'(("ARRIVED"=IADMStatus)||("COMPLETED"=IADMStatus))
	.s patMatId=$p($G(^PAADM(PAADM)),"^",1) 
	.Q:(""=patMatId)
	.s PatName=$p($g(^PAPER(patMatId,"ALL")),"^",1)
	.s PatNo=$p($g(^PAPER(patMatId,"PAT",1)),"^",2)
	.s CurLoc=$P($G(^PAADM(PAADM)),"^",4)
	.s OEORDRowId=0
	.f  s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,OEORDRowId)) q:OEORDRowId=""  d
	..s OEORIChildsub=0
	..f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
	...s CRMORowId=$o(^DHCPECRMO(0,"OEORI",OEORDRowId_"||"_OEORIChildsub,0)) 
	...i CRMORowId'=""  s PreOrdItemDR=$P($G(^DHCPECRMO(CRMORowId)),"^",2)
	...s OrdEntDR=$p(^DHCPEPreIADM($p(PreOrdItemDR,"||",1),"ORDITEM",$p(PreOrdItemDR,"||",2)),"^",2)
	...s SttDat=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",9)
	...s OEORIItemStatDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	...s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	...q:ItmMastDR=""
	...s ARCIMSubscript=$P(ItmMastDR,"||",1)
	...s ARCIMVersion=$P(ItmMastDR,"||",2)
	...s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	...s OtherSTRowId=$O(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
	...;Q:(6'=OEORIItemStatDR)&&(OtherSTRowId'=$G(^DHCPESetting("DHCPE","StationId_Other"))) //6	E	执行	N
   	...;Q:(OtherSTRowId=$G(^DHCPESetting("DHCPE","StationId_Other")))&&(OEORIItemStatDR'=1)
   	...Q:(6'=OEORIItemStatDR)&&(OtherSTRowId'=$G(^DHCPESetting("DHCPE","StationId_Other",CurLoc))) //6 E 执行 N
   	...Q:(OtherSTRowId=$G(^DHCPESetting("DHCPE","StationId_Other",CurLoc)))&&(OEORIItemStatDR'=1)

	...s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	...s ^DHCPETMPSWA("RecDep", RecDepDR)=+$G(^DHCPETMPSWA("RecDep",RecDepDR))+1
	...s ^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR)=+$G(^DHCPETMPSWA("RecDep", RecDepDR, "ItmMast", ItmMastDR))+1
	...s ^DHCPETMPSWA("ItmMast", ItmMastDR)=+$G(^DHCPETMPSWA("ItmMast", ItmMastDR))+1
	...s ^DHCPETMPSWA("ItmMast", ItmMastDR, RecDepDR)=+$G(^DHCPETMPSWA("ItmMast", ItmMastDR, RecDepDR))+1
	...//.s ^DHCPETMPSWA("FEE", "RecDep",RecDepDR)=+$G(^DHCPETMPSWA("FEE", "RecDep",RecDepDR))+FactAmount
	...//.s ^DHCPETMPSWA("TotalFEE")=+$G(^DHCPETMPSWA("TotalFEE"))+FactAmount
	...s:($G(^DHCPETMPSWA("RecDep", RecDepDR, "Day", IADMAdmDate, "ADMList"))'[("^"_PAADM_"^")) ^DHCPETMPSWA("RecDep", RecDepDR, "Day", IADMAdmDate)=+$G(^DHCPETMPSWA("RecDep", RecDepDR, "Day", IADMAdmDate))+1
	...s:($G(^DHCPETMPSWA("Day", IADMAdmDate, "ADMList"))'[("^"_PAADM_"^")) ^DHCPETMPSWA("Day", IADMAdmDate)=+$G(^DHCPETMPSWA("Day", IADMAdmDate))+1
	...
	...//s ^DHCPETMPSWA("Day", SttDat)=+$G(^DHCPETMPSWA("Day", SttDat))+1
	...// 测试用
	...s:($G(^DHCPETMPSWA("RecDep", RecDepDR, "Day", IADMAdmDate, "ADMList"))'[(PAADM_"^")) ^DHCPETMPSWA("RecDep", RecDepDR, "Day", IADMAdmDate, "ADMList")="^"_$G(^DHCPETMPSWA("RecDep", RecDepDR, "Day", IADMAdmDate, "ADMList"))_PAADM_"^"
	...// 测试用
	...s:($G(^DHCPETMPSWA("Day", IADMAdmDate, "ADMList"))'[("^"_PAADM_"^")) ^DHCPETMPSWA("Day", IADMAdmDate, "ADMListName")="^"_$G(^DHCPETMPSWA("Day", IADMAdmDate, "ADMListName"))_PatName_"^"
	...// 测试用
	...s:($G(^DHCPETMPSWA("Day", IADMAdmDate, "ADMList"))'[("^"_PAADM_"^")) ^DHCPETMPSWA("Day", IADMAdmDate, IAdmRowId)=IAdmRowId_"^"_PAADM_"^"_IADMAdmDate_"^"_PatNo_"^"_PatName
	...
	...// 过滤体检人员重复的项目
	...s:($G(^DHCPETMPSWA("Day", IADMAdmDate, "ADMList"))'[("^"_PAADM_"^")) ^DHCPETMPSWA("Day", IADMAdmDate, "ADMList")="^"_$G(^DHCPETMPSWA("Day", IADMAdmDate, "ADMList"))_PAADM_"^"
    ...//s:($G(^sg("Day", IADMAdmDate, "ADMList"))'[("^"_PAADM_"^")) ^sg("Day", IADMAdmDate, "ADMList")="^"_$G(^sg("Day", IADMAdmDate, "ADMList"))_PAADM_"^"
	...//医嘱套不能统计出单个科室收入
	...i OrdEntDR=""  d
	....s PIOIFChildSub=0
	....f  s PIOIFChildSub=$o(^DHCPEPreIADM($p(PreOrdItemDR,"||",1),"ORDITEM",$p(PreOrdItemDR,"||",2),"FEE",PIOIFChildSub))  q:PIOIFChildSub=""  d
	.....s FactAmount=$p(^DHCPEPreIADM($p(PreOrdItemDR,"||",1),"ORDITEM",$p(PreOrdItemDR,"||",2),"FEE",PIOIFChildSub),"^",2)
	.....s ^DHCPETMPSWA("FEE", "RecDep",RecDepDR)=+$G(^DHCPETMPSWA("FEE", "RecDep",RecDepDR))+FactAmount
	.....s ^DHCPETMPSWA("TotalFEE")=+$G(^DHCPETMPSWA("TotalFEE"))+FactAmount
       ...e   d
	....d ##class(web.DHCPE.OrdSetsPrice).SplitOrdSetPrice(OrdEntDR)	
       ....s FactAmount=^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",OrdEntDR,PreOrdItemDR)
       ....s ^DHCPETMPSWA("FEE", "RecDep",RecDepDR)=+$G(^DHCPETMPSWA("FEE", "RecDep",RecDepDR))+FactAmount
	....s ^DHCPETMPSWA("TotalFEE")=+$G(^DHCPETMPSWA("TotalFEE"))+FactAmount


	
	
	s RecDepList="^体检总数"
	// 科室列表
	s RecDepDR=0
	f  s RecDepDR=$O(^DHCPETMPSWA("RecDep", RecDepDR)) q:RecDepDR=""  d
	.//  CT_Loc.{ CTLOC_Desc }
	.s CTLOCDesc=$P($G(^CTLOC(RecDepDR)),"^",2)
	.s RecDepList=RecDepList_"^"_CTLOCDesc
	s RecDepList=RecDepList_"^"_"备注"
	s retValue=RecDepList_";"
	
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(RecDepList,"O","JS")_"');"
	.&javascript<#(retval)#>
	.//w RecDepList,!
	
	//w !,"科室列表:"_retValue,!
	
	s AdmDate=DateBegin
	while (AdmDate<+DateEnd) {
		
		s DayAmount=""
		s RecDepDR=0		
		f  s RecDepDR=$O(^DHCPETMPSWA("RecDep", RecDepDR)) q:RecDepDR=""  d
		.//  CT_Loc.{ CTLOC_Desc }
		.s CTLOCDesc=$P($G(^CTLOC(RecDepDR)),"^",2)
		.s Amount=+$G(^DHCPETMPSWA("RecDep", RecDepDR, "Day", AdmDate))
		.s DayAmount=DayAmount_"^"_Amount

		
		s Date=$ZD(AdmDate,3)
		s DayAmount=Date_"^"_+$G(^DHCPETMPSWA("Day", AdmDate))_DayAmount
		//w "每日情况:"_DayAmount,!
		s retValue=retValue_DayAmount_";"
		s AdmDate=+AdmDate+1
		
		i ""'=itmjs d
		.s retval=itmjs_"('"_$ZCVT(DayAmount,"O","JS")_"');"
		.&javascript<#(retval)#>
		.//w DayAmount,!
	}
	
	 s RecDepFees=""
	 s RecDepDR=0
	 f  s RecDepDR=$o(^DHCPETMPSWA("FEE", "RecDep",RecDepDR))  q:RecDepDR=""   d
	 .s RecDepFee=$g(^DHCPETMPSWA("FEE", "RecDep",RecDepDR))
	 .s RecDepFees=RecDepFees_"^"_RecDepFee
	 s TotalFee=$G(^DHCPETMPSWA("TotalFEE"))
     s TotalFee="金额合计"_"^"_+$G(^DHCPETMPSWA("TotalFEE"))_RecDepFees
     i ""'=itmjs d
     .s retval=itmjs_"('"_$ZCVT(TotalFee,"O","JS")_"');"
	 .&javascript<#(retval)#>
	
	 Q retValue_TotalFee
	//Q retValue
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.StationWorkStatistic","StationOrderList","血","")
/// 查找体检系统的医嘱项目
/// 参考 web.DHCPE.StationOrder的StationOrderList
Query StationOrderList(Desc As %Library.String = "", Type As %Library.String = "") As %Query(ROWSPEC = "STORD_ARCIM_Code:%String:编码, STORD_ARCIM_Desc:%String:名称, STORD_ARCIM_DR:%String:ID, STORD_ARCIM_Price:%String:价格")
{
}

ClassMethod StationOrderListExecute(ByRef qHandle As %Binary, Desc As %String = "", Type As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set TrakVerison=$g(^DHCPESetting("DHCPE","TrakVerison"))
 	 s CurLocID=%session.Get("LOGON.CTLOCID")
 	//Set LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
 	//Set OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other"))
 	Set LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",CurLocID))
 	Set OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other",CurLocID))

 	s ind=1
 	s Desc=##class(web.DHCPE.DHCPECommon).UnEscape(Desc)
 	s Desc=$ZCVT(Desc,"U")
	
 	s Sort=0
 	f  s Sort=$o(^DHCPEItemSort("Item",Sort)) q:Sort=""  d
 	.s Sub=0
 	.f  s Sub=$o(^DHCPEItemSort("Item",Sort,Sub)) q:Sub=""  d
 	..s Flag=0
 	..s iARCIMDR=$G(^DHCPEItemSort("Item",Sort,Sub))
 	..q:iARCIMDR=""
 	..s ST=$O(^DHCPEST(0,"STORD_ARCIM",iARCIMDR,0))
 	..q:(ST=LabStation)&&(Type'="Lab")&&(Type'="")
 	..q:(ST'=LabStation)&&(Type="Lab")&&(Type'="")
 	..q:(ST=OtherStation)&&(Type'="Other")&&(Type'="")
 	..q:(ST'=OtherStation)&&(Type="Other")&&(Type'="")
 	..s Flag=0
 	..i Desc'="" d
 	...s myDesc=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1),"^",2)
 	...s ALIASRowId=0
 	...f  s ALIASRowId=$O(^ARC("ALIAS",0,"ARCIM",iARCIMDR,ALIASRowId)) q:ALIASRowId=""  d
	....s ALIAS=""
	....s:(""'=ALIASRowId) ALIAS=$P($G(^ARC("ALIAS",ALIASRowId)),"^",6)
	....s ALIAS=$ZCVT(ALIAS,"U")
	....s:((""'=Desc)&(ALIAS[Desc)) Flag=1 
	....s:((""'=Desc)&(myDesc[Desc)) Flag=1 
	..s:Desc="" Flag=1
	..q:Flag=0
 	..d GetOneInfo
 	
 	
 	//查找全部
 	i ""=Desc {
 	
 	//i Type="" s Type="Item"
 	s ParRef=0
 	f  s ParRef=$O(^DHCPEST(ParRef)) q:ParRef=""  d
 	.Quit:(TrakVerison="MedTrak")&&(ParRef=LabStation)
 	.Quit:(Type="Lab")&&(ParRef'=LabStation)
 	.Quit:(Type="Item")&&(ParRef=LabStation)&&(ParRef=OtherStation)
 	.Quit:(Type="Other")&&(ParRef'=OtherStation)
 	.Set id="0"
 	.f  s id=$O(^DHCPEST(ParRef,"O",id)) q:id=""  d
	..s CurData=$g(^DHCPEST(ParRef,"O",id))
	..// 医嘱编码 医嘱名称
	..s iARCIMDR=$p(CurData,"^",1)
	..Q:(""=iARCIMDR)
	..s iSTORDDiet=$p(CurData,"^",2)
	..// STORD_ARCOS_DR -> ARC_OrdSets
	..s iARCOSDR=$p(CurData,"^",3)
	..s iARCOSDRName=""
	..s:(""'=iARCOSDR) iARCOSDRName=$P($G(^ARCOS(iARCOSDR)),"^",2)
	..// STORD_ReportFormat
    ..s iReportFormat=$p(CurData,"^",4)
	..s ST=+ParRef
	..s CurSort=$G(^DHCPEItemSort("Sort","Item",iARCIMDR))
	..q:CurSort'=""
	..d GetOneInfo
	/*..s iARCIMCode=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1),"^",1)
	..s iARCIMDesc=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1),"^",2)
	..
	..s OwnFlag=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),7),"^",13)
	..q:OwnFlag'="Y"
	..s Flag=0
	..i ParRef=LabStation d
	...s ItemCatDR=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1),"^",10)
	...i ItemCatDR'="" d
	....s OrderType=$p(^ARC("IC",ItemCatDR),"^",7)
	....i OrderType'="L" s Flag=1
	..q:Flag=1
	..b //4
	..s EffDate=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),7),"^",1)
	..i EffDate="" s EffDate=+$H+1
	..q:EffDate<+$H
	..s ARCIMPrice=##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(iARCIMDR)
    ..i ARCIMPrice="" s ARCIMPrice=0
    ..
    ..d StationOrderList*/
 	}

 	
 	// 按别名查
 	if (""'=Desc) {
 	s ALIASText=$O(^ARC("ALIAS",0,"Desc",Desc),-1)
	f  s ALIASText=$O(^ARC("ALIAS",0,"Desc",ALIASText)) Q:(""=ALIASText)||(ALIASText'[Desc)  d
	.s ALIASDesc=""  //ALIAS_Desc
	.f  s ALIASDesc=$O(^ARC("ALIAS",0,"Desc",ALIASText, ALIASDesc)) Q:(""=ALIASDesc)  d
	..s ALIASRowId=""
	..f  s ALIASRowId=$O(^ARC("ALIAS",0,"Desc",ALIASText, ALIASDesc, ALIASRowId)) Q:(""=ALIASRowId)  d
	...s CurData=$G(^ARC("ALIAS", 0, "Desc", ALIASText, ALIASDesc, ALIASRowId,1))
	...// ALIAS_Type
	...s ALIASType=$P(CurData,"^",2)
	...// ALIAS_Row_Calc
	...s ALIASRowCalc=$P(CurData,"^",1)
	...s iARCIMDR=""
	...//w ALIASText_"  "_ALIASDesc_"  "_ALIASRowCalc_"   :"_ALIASType_":",!
	...
	...i ("ARCIM"=ALIASType) d
	....//b // ARCIM
	....//w "   ARICM    "
	....s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ALIASRowCalc,""))
	....Q:(""=STRowId)
	....s ST=STRowId
	....q:(TrakVerison="MedTrak")&&(STRowId=LabStation)
	....q:(Type="Lab")&&(STRowId'=LabStation)
 	....q:(Type="Item")&&(STRowId=LabStation)
	....s Childsub=$O(^DHCPEST(0,"STORD_ARCIM",ALIASRowCalc, STRowId,""))
	....Q:(""=Childsub)
	....s iARCIMDR=ALIASRowCalc
	....//w "iARCIMDR:"_iARCIMDR_"  "_ALIASText_"  "_ALIASDesc_"  "_ALIASRowCalc_"   "_ALIASType,!
	....
	...
	...
	...i "ARCOS"=ALIASType d
	....s STRowId=$O(^DHCPEST(0,"STORD_ARCOS",ALIASRowCalc,""))
	....s ST=STRowId
	....q:(TrakVerison="MedTrak")&&(STRowId=LabStation)
	....Q:(""=STRowId)
	....q:(Type="Lab")&&(STRowId'=LabStation)
 	....q:(Type="Item")&&(STRowId=LabStation)
	....s Childsub=$O(^DHCPEST(0,"STORD_ARCIM",ALIASRowCalc, STRowId,""))
	....Q:(""=Childsub)
	....
	....s iARCIMDR=$P($G(^DHCPEST(STRowId,"O",Childsub)),"^",1)
	....
	....//&SQL(Select STORD_ParRef, STORD_RowId, STORD_Childsub, STORD_ARCIM_DR into :STRowId, :RowId, :Childsub, :iARCIMDR
	....//	from DHC_PE_StationOrder
	....//	where STORD_ARCOS_DR=:ALIASRowCalc)
	....//s:(0'=SQLCODE) iARCIMDR=""
	....
	...
	...Q:(""=iARCIMDR)
	...s CurSort=$G(^DHCPEItemSort("Sort","Item",iARCIMDR))
	...q:CurSort'=""
	...d GetOneInfo
	/*...s OwnFlag=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),7),"^",13)
	...q:OwnFlag'="Y"
	...s Flag=0
	...i STRowId=LabStation d
	....s ItemCatDR=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1),"^",10)
	....i ItemCatDR'="" d
	.....s OrderType=$p(^ARC("IC",ItemCatDR),"^",7)
	.....i OrderType'="L" s Flag=1
	...q:Flag=1
	...
	...
	...
	...s EffDate=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),7),"^",1)
	...i EffDate="" s EffDate=+$H+1
	...q:EffDate<+$H
	...s iARCIMCode=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1),"^",1)
	...s iARCIMDesc=ALIASDesc
	...s ARCIMPrice=##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(iARCIMDR)
	...i ARCIMPrice="" s ARCIMPrice=0
	...d StationOrderList
	...
    ...*/
 	}

    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOneInfo
	s iARCIMCode=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1),"^",1)
	s iARCIMDesc=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1),"^",2)
	//q:((Desc'="")&&(iARCIMDesc'[Desc)) //&&(iARCIMCode'[Desc)
	s OwnFlag=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),7),"^",13)
	//q:OwnFlag'="Y" 过滤非独立医嘱
	s Flag=0
	i ST=LabStation d
	.s ItemCatDR=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1),"^",10)
	.i ItemCatDR'="" d
	..s OrderType=$p(^ARC("IC",ItemCatDR),"^",7)
	..i OrderType'="L" s Flag=1
	q:Flag=1
	s EffDate=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),7),"^",1)
	i EffDate="" s EffDate=+$H+1
	q:EffDate<+$H
	s ARCIMPrice=##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(iARCIMDR)
    i ARCIMPrice="" s ARCIMPrice=0
    d StationOrderList
    q 
StationOrderList      
	set Data=$lb(iARCIMCode, iARCIMDesc, iARCIMDR, ARCIMPrice)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod StationOrderListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StationOrderListExecute ]
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

ClassMethod StationOrderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StationOrderListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ChangeDate()
{
 
	&sql(Update DHC_PE_StationSummarize set SS_AduitDate=SS_AduitDate-1)
	Q SQLCODE
}

ClassMethod GetStationWorkInfoListStatisticRows(User)
{
	q $o(^DHCPETMP("StationWorkStatistic","InfoExport","List",User,""),-1)
}

ClassMethod GetStationWorkInfoListRowsInfo(User, num)
{
	q:'$d(^DHCPETMP("StationWorkStatistic","InfoExport","List",User,num)) ""
	q $g(^DHCPETMP("StationWorkStatistic","InfoExport","List",User,num))
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.StationWorkStatistic","InfoList","2329","6941||1","A")
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.StationWorkStatistic","InfoList","1128","2856||1","E")
/// 在科室工作量统计界面点数量链接到人员信息
Query InfoList(LocID As %Library.String = "", OEItemDR As %Library.String = "", DType As %Library.String = "") As %Query(ROWSPEC = "TRegNo:%String,TPatName:%String,TSex:%String,TTel:%String,TCompany:%String,TGroupName:%String")
{
}

ClassMethod InfoListExecute(ByRef qHandle As %Binary, LocID As %Library.String = "", OEItemDR As %Library.String = "", DType As %Library.String = "") As %Status
{
    s CurUserID=%session.Get("LOGON.USERID") 
    K ^DHCPETMP("StationWorkStatistic","InfoExport","List",CurUserID)
	Set repid=$I(^CacheTemp)
	s ind=1	
	s PAPMINo=""
	s Name=""
	s SexName=""
	s MobilePhone=""
	s Company=""
	s GDesc=""
    i DType="A"  d
  	.s RecDepDR=0
 	.i OEItemDR=""  d
 	..f  s RecDepDR=$o(^DHCPETMPSWA("A",RecDepDR)) q:RecDepDR=""  d
 	...Q:(LocID'="")&&(RecDepDR'=LocID)
 	...s ItmMastDR=0
 	...f  s ItmMastDR=$o(^DHCPETMPSWA("A",RecDepDR,ItmMastDR))  q:ItmMastDR=""  d
 	....s IADM=0
 	....f  s IADM=$o(^DHCPETMPSWA("A",RecDepDR,ItmMastDR,IADM))   q:IADM=""  d
 	.....s num=0
 	.....f  s num=$o(^DHCPETMPSWA("A",RecDepDR,ItmMastDR,IADM,num)) q:num=""  d
	......s str=$g(^DHCPETMPSWA("A",RecDepDR,ItmMastDR,IADM,num))
	......s PAPMINo=$p(str,"^",1)
    ......s Name=$p(str,"^",2)   
    ......s SexName=$p(str,"^",3)
    ......s MobilePhone=$p(str,"^",4)
    ......s Company=$p(str,"^",5)
    ......s GDesc=$p(str,"^",6)
 	......d StationWorkInfoOut
 	
 	
 	.i OEItemDR'=""  d
 	..f  s RecDepDR=$o(^DHCPETMPSWA("A",RecDepDR)) q:RecDepDR=""  d
 	...Q:(LocID'="")&&(RecDepDR'=LocID)
 	...s ItmMastDR=0
 	...f  s ItmMastDR=$o(^DHCPETMPSWA("A",RecDepDR,ItmMastDR)) q:ItmMastDR=""  d
 	....q:ItmMastDR'=OEItemDR
 	....s IADM=0
 	....f  s IADM=$o(^DHCPETMPSWA("A",RecDepDR,ItmMastDR,IADM))   q:IADM=""  d
 	.....s num=0
 	.....f  s num=$o(^DHCPETMPSWA("A",RecDepDR,ItmMastDR,IADM,num)) q:num=""  d
	......s str=$g(^DHCPETMPSWA("A",RecDepDR,ItmMastDR,IADM,num))
	......s PAPMINo=$p(str,"^",1)
    ......s Name=$p(str,"^",2)
    ......s SexName=$p(str,"^",3)
    ......s MobilePhone=$p(str,"^",4)
    ......s Company=$p(str,"^",5)
    ......s GDesc=$p(str,"^",6)
 	......d StationWorkInfoOut
   

    i DType="E"  d
  	.s RecDepDR=0
 	.i OEItemDR=""  d
 	..f  s RecDepDR=$o(^DHCPETMPSWA("E",RecDepDR)) q:RecDepDR=""  d
 	...Q:(LocID'="")&&(RecDepDR'=LocID)
 	...s ItmMastDR=0
 	...f  s ItmMastDR=$o(^DHCPETMPSWA("E",RecDepDR,ItmMastDR))  q:ItmMastDR=""  d
 	....s IADM=0
 	....f  s IADM=$o(^DHCPETMPSWA("E",RecDepDR,ItmMastDR,IADM))   q:IADM=""  d
 	.....s num=0
 	.....f  s num=$o(^DHCPETMPSWA("E",RecDepDR,ItmMastDR,IADM,num)) q:num=""  d
	......s str=$g(^DHCPETMPSWA("E",RecDepDR,ItmMastDR,IADM,num))
	......s PAPMINo=$p(str,"^",1)
    ......s Name=$p(str,"^",2)
    ......s SexName=$p(str,"^",3)
    ......s MobilePhone=$p(str,"^",4)
    ......s Company=$p(str,"^",5)
    ......s GDesc=$p(str,"^",6)
 	......d StationWorkInfoOut
 	
 	
 	.i OEItemDR'=""  d
 	..f  s RecDepDR=$o(^DHCPETMPSWA("E",RecDepDR)) q:RecDepDR=""  d
 	...Q:(LocID'="")&&(RecDepDR'=LocID)
 	...s ItmMastDR=0
 	...f  s ItmMastDR=$o(^DHCPETMPSWA("E",RecDepDR,ItmMastDR)) q:ItmMastDR=""  d
 	....Q:ItmMastDR'=OEItemDR
 	....s IADM=0
 	....f  s IADM=$o(^DHCPETMPSWA("E",RecDepDR,ItmMastDR,IADM))   q:IADM=""  d
 	.....s num=0
 	.....f  s num=$o(^DHCPETMPSWA("E",RecDepDR,ItmMastDR,IADM,num)) q:num=""  d
	......s str=$g(^DHCPETMPSWA("E",RecDepDR,ItmMastDR,IADM,num))
	......s PAPMINo=$p(str,"^",1)
    ......s Name=$p(str,"^",2)
    ......s SexName=$p(str,"^",3)
    ......s MobilePhone=$p(str,"^",4)
    ......s Company=$p(str,"^",5)
    ......s GDesc=$p(str,"^",6)
 	......d StationWorkInfoOut
 
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
StationWorkInfoOut
	set Data=$lb(PAPMINo,Name,SexName,MobilePhone,Company,GDesc)
	s ^DHCPETMP("StationWorkStatistic","InfoExport","List",CurUserID,ind)=PAPMINo_"^"_Name_"^"_SexName_"^"_MobilePhone_"^"_Company_"^"_GDesc
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod InfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InfoListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod InfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InfoListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 用于生成新索引
/// d ##class(web.DHCPE.Report.StationWorkStatistic).reduceDate()
ClassMethod AddDate()
{
  &sql(update DHC_PE_StationSummarize  set SS_AduitDate =SS_AduitDate+1 )

	Q SQLCODE
}

ClassMethod reduceDate()
{
  &sql(update DHC_PE_StationSummarize  set SS_AduitDate =SS_AduitDate-1 )

	Q SQLCODE
}

ClassMethod GetRowNum() As %Status
{
  
	s CurUserID=%session.Get("LOGON.USERID")
	s StrNum=""
	s num=0
	f  s num=$o(^DHCPETMPSWAExport("ExportStationWorkStatistic",CurUserID,num))  q:num=""  d
	.i StrNum=""  s StrNum=num
	.else  s StrNum=StrNum_"^"_num
	q StrNum
}

ClassMethod ExportStationWorkInfo(Num As %Library.String = "") As %Status
{
	q:Num="" ""
	s UserID=%session.Get("LOGON.USERID")
 	s Data=$G(^DHCPETMPSWAExport("ExportStationWorkStatistic",UserID,Num))
	Q Data
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.StationWorkStatistic","StationWorkStatisticNew","2017-11-16","2017-11-17")
Query StationWorkStatisticNew(DateBegin As %Library.String = "", DateEnd As %Library.String = "") As %Query(ROWSPEC = "Loc:%String:科室, ArcDesc:%String:检查项目, INum:%String:个检人次, IAmount:%String:个检金额, GNum:%String:团检人次,GAmount:%String:团检金额,Num:%String:人次合计,Amount:%String:金额合计") [ SqlProc ]
{
}

ClassMethod StationWorkStatisticNewExecute(ByRef qHandle As %Binary, DateBegin As %Library.String = "", DateEnd As %Library.String = "") As %Status
{
 	s ind=1
 	s id=0	
	Set repid=$I(^CacheTemp)
	
 	if (""=DateBegin)&&(""=DateEnd){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	i DateBegin'=""  s DateBegin=##class(websys.Conversions).DateHtmlToLogical(DateBegin)
 	i DateEnd'=""   s DateEnd=##class(websys.Conversions).DateHtmlToLogical(DateEnd)
 	
 	k ^DHCPETMPSTA
 	
 	i (""'=DateBegin)  s SSAduitDate=DateBegin-1
    i (""=DateBegin)   s SSAduitDate=0
    i (""=DateEnd)     s DateEnd=+$h 
    
    ///按到达统计
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
	...s RLTDR=$o(^DHCPERLT(0,"ADM",PAADM,0))	;已到达没任何结果退出
	...q:RLTDR=""
	...s GADM=$P($g(^DHCPEIADM(IAdmRowId)),"^",2)
	...s PIADM=$p(^DHCPEIADM(IAdmRowId),"^",4)
	...s PIBI=$p(^DHCPEPreIADM(PIADM),"^",1)
	...s Reg=$p(^DHCPEPreIBI(PIBI),"^",1)
	...//用于具体人员信息
	...s OEORDRowId=0
	...f  s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,OEORDRowId)) q:OEORDRowId=""  d
	....s OEORIChildsub=0
	....f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
	.....Q:(""=$O(^DHCPECRMO(0,"OEORI",(OEORDRowId_"||"_OEORIChildsub),0))) //过滤非体检项目
	.....// 过滤非医嘱站点
	.....s OtherSTRowId=$O(^DHCPEST(0,"STORD_ARCIM",(OEORDRowId_"||"_OEORIChildsub),0))
	.....s OEORIStat=$p(^OEORD($p(OEORDRowId,"||",1),"I",OEORIChildsub,1),"^",13)
	.....q:(OEORIStat=4)
	.....s ARCID=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
	.....q:(ARCID="")
	.....s RecDepDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,3),"^",6)
	.....s STDR=$o(^DHCPEST(0,"STORD_ARCIM",ARCID,0))
	.....q:(STDR=7)
	.....s STDR=RecDepDR
	.....q:(STDR="")
	.....//q:(STIDS'[("^"_STDR_"^"))
	.....s crmodr=$O(^DHCPECRMO(0,"OEORI",OEORDRowId_"||"_OEORIChildsub,0))
	.....q:(crmodr="")
	.....s PIOIDR=$P($G(^DHCPECRMO(crmodr)),"^",2)
	.....s:(GADM'="") FactAmount=1 //##class(web.DHCDocOrderEntry).GetOrderPrice("","",ARCID,AdmDate,"","","","")
	.....s:(GADM="") FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PIOIDR,"","")
 	.....s ^DHCPETMPSTA("NewStatistic","allNum",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","allNum",STDR,ARCID))+1
 	.....s ^DHCPETMPSTA("NewStatistic","allAmount",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","allAmount",STDR,ARCID))+FactAmount
 	.....s:(GADM'="") ^DHCPETMPSTA("NewStatistic","GNum",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","GNum",STDR,ARCID))+1
 	.....s:(GADM'="") ^DHCPETMPSTA("NewStatistic","GAmount",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","GAmount",STDR,ARCID))+FactAmount
 	.....s:(GADM="") ^DHCPETMPSTA("NewStatistic","INum",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","INum",STDR,ARCID))+1
 	.....s:(GADM="") ^DHCPETMPSTA("NewStatistic","IAmount",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","IAmount",STDR,ARCID))+FactAmount
 	
    ///检验的按照状态记录检索
    i (""'=DateBegin)  s AdmDate=DateBegin-1
    i (""=DateBegin)   s AdmDate=0
    i (""=DateEnd)     s DateEnd=+$h  
    f  s AdmDate=$o(^OEORDi(0,"StatDate",AdmDate)) q:(AdmDate="")||(AdmDate>DateEnd)  d
    .s Ord=0
    .f  s Ord=$o(^OEORDi(0,"StatDate",AdmDate,Ord)) q:(Ord="")  d
    ..s PAADM=$p($g(^OEORD(Ord)),"^",1)
    ..q:(PAADM="")
    ..s IADM=($o(^DHCPEIADM(0,"PAADM",PAADM,0)))
    ..q:(IADM="")
    ..s GADM=$P($g(^DHCPEIADM(IADM)),"^",2)
    ..s ori=0
    ..f  s ori=$o(^OEORDi(0,"StatDate",AdmDate,Ord,ori)) q:(ori="")  d
    ...s ARCID=$p(^OEORD(Ord,"I",ori,1),"^",2)
    ...s STDR=$o(^DHCPEST(0,"STORD_ARCIM",ARCID,0))
	...q:(STDR'=7)
    ...s OEORIStat=$p(^OEORD(Ord,"I",ori,1),"^",13)
	...q:(OEORIStat'=6)
	...s ssub=$o(^OEORDi(0,"StatDate",AdmDate,Ord,ori,""),-1)
	...q:(ssub="")
	...s curstat=$p(^OEORD(Ord,"I",ori,"ST",ssub),"^",3)
	...q:(curstat'=6)
    ...s RecDepDR=$p(^OEORD(Ord,"I",ori,3),"^",6)
    ...s STDR=RecDepDR
    ...;s STDR="R"_RecDepDR
    ...s crmodr=$O(^DHCPECRMO(0,"OEORI",Ord_"||"_ori,0))
	...q:(crmodr="")
	...s PIOIDR=$P($G(^DHCPECRMO(crmodr)),"^",2)
	...s:(GADM'="") FactAmount=1 //##class(web.DHCDocOrderEntry).GetOrderPrice("","",ARCID,AdmDate,"","","","")
	...s:(GADM="") FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PIOIDR,"","")
    ...s ^DHCPETMPSTA("NewStatistic","allNum",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","allNum",STDR,ARCID))+1
 	...s ^DHCPETMPSTA("NewStatistic","allAmount",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","allAmount",STDR,ARCID))+FactAmount
 	...s:(GADM'="") ^DHCPETMPSTA("NewStatistic","GNum",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","GNum",STDR,ARCID))+1
 	...s:(GADM'="") ^DHCPETMPSTA("NewStatistic","GAmount",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","GAmount",STDR,ARCID))+FactAmount
 	...s:(GADM="") ^DHCPETMPSTA("NewStatistic","INum",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","INum",STDR,ARCID))+1
 	...s:(GADM="") ^DHCPETMPSTA("NewStatistic","IAmount",STDR,ARCID)=$g(^DHCPETMPSTA("NewStatistic","IAmount",STDR,ARCID))+FactAmount
    
     
    
 	 	
 	s STDR=0
 	f  s STDR=$o(^DHCPETMPSTA("NewStatistic","allNum",STDR)) q:(STDR="")  d
 	.;s:($l(STDR,"R")>1) STDesc=$p($P($G(^CTLOC($p(STDR,"R",2))),"^",2),"-",2)
 	.;s:($l(STDR,"R")=1) STDesc=$p(^DHCPEST(STDR),"^",2)
 	.s STDesc=$P($G(^CTLOC(STDR)),"^",2)
 	.s ARCID=0
 	.f  s ARCID=$o(^DHCPETMPSTA("NewStatistic","allNum",STDR,ARCID)) q:(ARCID="")  d
 	..s ARCDesc=$p(^ARCIM(+ARCID,1,1),"^",2)
 	..//DateBegin
 	..s CurGAmt=##class(web.DHCDocOrderEntry).GetOrderPrice("","",ARCID,DateBegin,"","","","")
 	..s INum=+$g(^DHCPETMPSTA("NewStatistic","INum",STDR,ARCID))
 	..s IAmount=+$G(^DHCPETMPSTA("NewStatistic","IAmount",STDR,ARCID))
 	..s GNum=+$G(^DHCPETMPSTA("NewStatistic","GNum",STDR,ARCID))
 	..s GAmount=CurGAmt*GNum  //+$G(^DHCPETMPSTA("NewStatistic","GAmount",STDR,ARCID))
 	..s AllNum=+$G(^DHCPETMPSTA("NewStatistic","allNum",STDR,ARCID))
 	..s AllAmount=IAmount+GAmount  //+$G(^DHCPETMPSTA("NewStatistic","allAmount",STDR,ARCID))
 	..s Data=$LB(STDesc, ARCDesc, INum, IAmount, GNum,GAmount,AllNum,AllAmount)
 	..d StationWorkStatisticOutNew2

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
StationWorkStatisticOutNew2
 	Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
 	q
}

ClassMethod StationWorkStatisticNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StationWorkStatisticNewExecute ]
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

ClassMethod StationWorkStatisticNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StationWorkStatisticNewExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
