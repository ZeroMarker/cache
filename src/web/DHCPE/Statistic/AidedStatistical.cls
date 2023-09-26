Class web.DHCPE.Statistic.AidedStatistical Extends %RegisteredObject
{

/// 按到达日期查询  DHCPEItemExecutionStatus.raq  DHCPEItemExecutionStatusForItem.raq
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.AidedStatistical","ItemExecutionStatus","2022-03-01","","","","","","","","","","","","105")
/// call web_DHCPE_Statistic.AidedStatistical_ItemExecutionStatus(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,"ITEM","304")
Query ItemExecutionStatus(BeginDate As %String = "", EndDate As %String = "", Sex As %String = "", VIPLevel As %String = "", Station As %String = "", PERoom As %String = "", AuditStatus As %String = "", ChcekStatus As %String = "", ItemID As %String = "", ItemStatus As %String = "", ShowType As %String = "", GroupDR As %String = "", CurLoc As %String = "") As websys.Query(ROWSPEC = "tARCIM:%String,tARCIMDesc:%String,tItemStatus:%String,tItemStatusDesc:%String,tPAADM:%String,tRegNo:%String,tName:%String,tSex:%String,tAge:%String,tVIPDesc:%String,tTel:%String,tGDesc:%String,tCurRoom:%String,tCheckStatus:%String,tAuditStatus:%String,tNoCheckItem:%String,tHadCheckItem:%String,tRefCheckItem:%String,tRoomPlace:%String,Now:%String") [ SqlProc ]
{
}

ClassMethod ItemExecutionStatusExecute(ByRef qHandle As %Binary, BeginDate As %String = "", EndDate As %String = "", Sex As %String = "", VIPLevel As %String = "", Station As %String = "", PERoom As %String = "", AuditStatus As %String = "", ChcekStatus As %String = "", ItemID As %String = "", ItemStatus As %String = "", ShowType As %String = "", GroupDR As %String = "", CurLoc As %String = "") As %Status
{
	s ^tempdhcpe("ItemExecutionStatus")=$lb(BeginDate,EndDate,Sex,VIPLevel,Station,PERoom,AuditStatus,ChcekStatus, ItemID,ItemStatus, ShowType, GroupDR,CurLoc)
	Set ind=1
	Set repid=$I(^CacheTemp)
 	i ((BeginDate="")&(EndDate="")&(GroupDR=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	s Job=$j
 	k ^TempDHCPEItemExecutionStatus(Job)
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
 	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 	i BeginDate="" s BeginDate=1
 	i EndDate="" s EndDate=+$h
 	//s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other"))
	//s MedicalStation=$G(^DHCPESetting("DHCPE","StationId_Medical"))
	s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other",CurLoc))
	s MedicalStation=$G(^DHCPESetting("DHCPE","StationId_Medical",CurLoc))
	s OtherStation="^"_OtherStation_"^"_MedicalStation_"^"
	
	i +GroupDR=0 s GroupDR=""
	i GroupDR'="" {
		s GTeam=0
		f  s GTeam=$o(^DHCPEIADM(0,"GADM",GroupDR,GTeam)) q:GTeam=""  d
		.s IADM=0
		.f  s IADM=$o(^DHCPEIADM(0,"GADM",GroupDR,GTeam,IADM)) q:IADM=""  d
		..d SetOneIADMInfo
	}
	else{
		s Date=BeginDate-1
	 	f  s Date=$o(^DHCPEIADM(0,"AdmDateTime",Date)) q:(Date="")||(Date>EndDate)  d
		.s Time=""
		.f  s Time=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:(Time="")  d
		..s IADM=""
		..f  s IADM=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADM)) q:(IADM="")  d
		...d SetOneIADMInfo
	}
	
	
	if ('$d(^TempDHCPEItemExecutionStatus(Job))) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	if (ShowType="PAADM") {
		s tDate=""
		f  s tDate=$o(^TempDHCPEItemExecutionStatus(Job,tDate)) q:tDate=""  d
		.s tPAADM=""
		.f  s tPAADM=$o(^TempDHCPEItemExecutionStatus(Job,tDate,"PAADM",tPAADM)) q:tPAADM=""  d
		..d SetChcekValue
		..s tItemStatus=""
		..s CurData=$g(^TempDHCPEItemExecutionStatus(Job,tDate,"PAADM",tPAADM))
		..d SetChcekStatus
		..d OutChcekStatus
	} elseif (ShowType="ITEM") {
		s tARCIM=""
		f  s tARCIM=$o(^TempDHCPEItemExecutionStatus(Job,"ITEM",tARCIM)) q:tARCIM=""  d
		.s tItemStatus=""
		.f  s tItemStatus=$o(^TempDHCPEItemExecutionStatus(Job,"ITEM",tARCIM,tItemStatus)) q:tItemStatus=""  d
		..q:((ItemStatus'="")&&(ItemStatus'=tItemStatus))
		..d SetChcekValue
		..s tARCIMDesc=$p($g(^ARCIM($p(tARCIM,"||",1),$p(tARCIM,"||",2),1)),"^",2)
		..s tDate=""
		..f  s tDate=$o(^TempDHCPEItemExecutionStatus(Job,"ITEM",tARCIM,tItemStatus,tDate)) q:tDate=""  d
		...s tPAADM=""
		...f  s tPAADM=$o(^TempDHCPEItemExecutionStatus(Job,"ITEM",tARCIM,tItemStatus,tDate,tPAADM)) q:tPAADM=""  d
		....s CurData=$g(^TempDHCPEItemExecutionStatus(Job,"ITEM",tARCIM,tItemStatus,tDate,tPAADM))
		....d SetChcekStatus
		....d OutChcekStatus
	}
 	
 	k ^TempDHCPEItemExecutionStatus(Job)
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SetOneIADMInfo
    s Status=$p($g(^DHCPEIADM(IADM)),"^",8)
	q:Status'="ARRIVED"
	s PreIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
	s PreLoc=$p($g(^DHCPEPreIADM(PreIADM)),"^",26)
	q:PreLoc'=CurLoc  // 判断科室
	s PreIBI=$p($g(^DHCPEPreIADM(PreIADM)),"^",1)
	s SexDR=$p($g(^DHCPEPreIBI(PreIBI)),"^",3)
	q:((Sex'="")&&(SexDR'=Sex))  // 判断性别
	s VIPID=$p($g(^DHCPEPreIADM(PreIADM)),"^",18)
	q:((VIPLevel'="")&&(VIPID'=VIPLevel))  // 判断VIP
	s AdmDate=$p($g(^DHCPEIADM(IADM)),"^",5)
	s PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
	s GSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM),GSUser=""
	s:GSID'="" GSUser=$p($g(^DHCPEGS(GSID,1)),"^",5)
	s AuditFlag="NA"
	s:GSUser'="" AuditFlag="A"
	q:((AuditStatus'="")&&(AuditFlag'=AuditStatus))  // 判断总检状态
	
	s CurRoomInfo=##class(web.DHCPE.RoomManager).GetAdmCurRoom(PAADM,"ADM","Desc")
	s CurRoomID=$p(CurRoomInfo,"^",1)
	;q:((PERoom'="")&&(CurRoomID'=PERoom))
	s RoomPlace=$G(^DHCPEDataEx("DHCPEPreIADM","RoomPlace",PreIADM))
	q:((PERoom'="")&&(RoomPlace'=PERoom))
	s CheckFlag="",NoCheckItem="",HadCheckItem="",RefCheckItem="",NoCheckItemID="",HadCheckItemID="",RefCheckItemID=""
    d GetChcekStatus
    q:CheckFlag=""
    q:((ChcekStatus'="")&&(ChcekStatus'=CheckFlag))
    
    q:((ItemStatus'="")&&(ItemStatus="V")&&(NoCheckItem=""))
    q:((ItemStatus'="")&&(ItemStatus="E")&&(HadCheckItem=""))
    q:((ItemStatus'="")&&(ItemStatus="R")&&(RefCheckItem=""))
    
    s PreGADM=$p($g(^DHCPEPreIADM(PreIADM)),"^",2)
	s ^TempDHCPEItemExecutionStatus(Job,AdmDate,"PAADM",PAADM)=PreIBI_"^"_PreGADM_"^"_VIPID_"^"_CheckFlag_"^"_AuditFlag_"^"_NoCheckItem_"^"_HadCheckItem_"^"_RefCheckItem
    
    i NoCheckItemID'="" d
    .f noi=1:1:$l(NoCheckItemID,"^") d
    ..s ARCI=$p(NoCheckItemID,"^",noi)
    ..s ^TempDHCPEItemExecutionStatus(Job,"ITEM",ARCI,"V",AdmDate,PAADM)=PreIBI_"^"_PreGADM_"^"_VIPID_"^"_CheckFlag_"^"_AuditFlag
    i HadCheckItemID'="" d
    .f hadi=1:1:$l(HadCheckItemID,"^") d
    ..s ARCI=$p(HadCheckItemID,"^",hadi)
    ..s ^TempDHCPEItemExecutionStatus(Job,"ITEM",ARCI,"E",AdmDate,PAADM)=PreIBI_"^"_PreGADM_"^"_VIPID_"^"_CheckFlag_"^"_AuditFlag
    i RefCheckItemID'="" d
    .f refi=1:1:$l(RefCheckItemID,"^") d
    ..s ARCI=$p(RefCheckItemID,"^",refi)
    ..s ^TempDHCPEItemExecutionStatus(Job,"ITEM",ARCI,"R",AdmDate,PAADM)=PreIBI_"^"_PreGADM_"^"_VIPID_"^"_CheckFlag_"^"_AuditFlag
	
    q	
SetChcekStatus	
	// --------------- 基本信息 --------------- //
	s PreIBI=$p(CurData,"^",1)
	s PreIBIData=$g(^DHCPEPreIBI(PreIBI))
	s tRegNo=$p(PreIBIData,"^",1)
	s tName=$p(PreIBIData,"^",2)
	s tSex=$p(PreIBIData,"^",3)
	s:tSex'="" tSex=$p($g(^CT("SEX",tSex)),"^",2)
	s tBirth=$p(PreIBIData,"^",4)
	s tAge=""
	S PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",tRegNo,0))
	i PAPMIRowId'="" s tAge=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId,tPAADM)  // 年龄
	//s:tBirth'="" tAge=+$p(##class(web.DHCLCNUREXCUTE).CalAge(tBirth,+$h),"Y",1)
	s:tBirth'="" tBirth=$ZD(tBirth,3)
	s tTel=$p(PreIBIData,"^",8)
	s:tTel="" tTel=$p(PreIBIData,"^",6)
	s:tTel="" tTel=$p(PreIBIData,"^",7)
	s PGADM=$p(CurData,"^",2),tGDesc=""
	i PGADM'="" d
	.s PGBID=$p($g(^DHCPEPreGADM(PGADM)),"^",1)
	.s tGDesc=$p($g(^DHCPEPreGBI(PGBID)),"^",2)
	
	
	// --------------- 诊室信息 --------------- //
	s CurRoomInfo=##class(web.DHCPE.RoomManager).GetAdmCurRoom(tPAADM,"ADM","Desc")
	s CurRoomDesc=$p(CurRoomInfo,"^",1)
	s CurRoomNum=$p(CurRoomInfo,"^",2)  // 诊室人数
	s tCurRoom=""
	s IADM=$o(^DHCPEIADM(0,"PAADM",tPAADM,0))
	s PreIADM=$p(^DHCPEIADM(IADM),"^",4)
	s PreLoc=$p($g(^DHCPEPreIADM(PreIADM)),"^",26)
	// --------------- VIP --------------- //
	s tVIPId=$p(CurData,"^",3)
	;i tVIPId="" s tVIPId=$G(^DHCPEVIPLevel("VIPapprove"))
	;s tVIPDesc=$p($g(^DHCPEVIPLevel("VIP",tVIPId)),"^",2)
	i tVIPId="" s tVIPId=##class(web.DHCPE.CT.VIPLevel).GetDefaultVIP(PreLoc)
	s tVIPDesc=$lg($g(^CT.PE.VIPLevelD(tVIPId)),3)
	
	s tRoomPlace=$G(^DHCPEDataEx("DHCPEPreIADM","RoomPlace",PreIADM))
	;s:tRoomPlace'="" tRoomPlace=$P(^DHCPECTDataEx("RoomPlace",tRoomPlace),"^",2)
	s:tRoomPlace'="" tRoomPlace=$lg(^CF.PE.RoomPlaceD(tRoomPlace),3) //诊室位置（多院区）
	s:CurRoomInfo'="" tCurRoom=CurRoomDesc_"("_CurRoomNum_")"
	// --------------- 检查状态 --------------- //
	s tCheckStatus=$p(CurData,"^",4)
	;s:tCheckStatus="0" tCheckStatus="谢绝检查"
	s:tCheckStatus="NC" tCheckStatus="全部未检"
	s:tCheckStatus="PC" tCheckStatus="部分已检"
	s:tCheckStatus="AC" tCheckStatus="全部已检"
	// --------------- 总检状态 --------------- //
	s tAuditStatus=$p(CurData,"^",5)
	s:tAuditStatus="NA" tAuditStatus="未总检"
	s:tAuditStatus="A" tAuditStatus="已总检"
	
	s:tItemStatus="V" tItemStatusDesc="核实"
	s:tItemStatus="E" tItemStatusDesc="执行"
	s:tItemStatus="R" tItemStatusDesc="谢绝检查"
	
	if (ShowType="PAADM") d
	.s tNoCheckItem=$p(CurData,"^",6)
	.s tHadCheckItem=$p(CurData,"^",7)
	.s tRefCheckItem=$p(CurData,"^",8)
	
	q
	
GetChcekStatus
	s Order=$o(^OEORD(0,"Adm",PAADM,0))
	q:Order=""
	
	s ItemSub=""
	f  s ItemSub=$o(^OEORD(Order,"I",ItemSub)) q:ItemSub=""  d
	.s OEORI=Order_"||"_ItemSub
	.s ARCIM=$p($g(^OEORD(Order,"I",ItemSub,1)),"^",2)
	.q:ARCIM=""
	.q:((ItemID'="")&&(ARCIM'=ItemID))
	.s Stat=$p($g(^OEORD(Order,"I",ItemSub,1)),"^",13)
	.q:Stat="4"
	.s CRMOrder=$o(^DHCPECRMO(0,"OEORI",OEORI,0))
	.q:CRMOrder=""
	.s CRMORI=$p(^DHCPECRMO(CRMOrder),"^",2)
	.q:CRMORI=""
	.;s STID=$o(^DHCPEST(0,"STORD_ARCIM",ARCIM,0))
	.//根据医嘱项ID查找站点（多院区）
	.s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIM,CurLoc)
	.q:StatOrderID=""
	.s STID=$p(StatOrderID,"||",1)
	.q:STID=""
	.q:OtherStation[("^"_STID_"^")
	.q:(STID'=Station)&(Station'="")
	.s ItemDesc=$p($g(^ARCIM($p(ARCIM,"||",1),$p(ARCIM,"||",2),1)),"^",2)
	.
	.i $d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORI)) d
	..s:RefCheckItem'="" RefCheckItem=RefCheckItem_$c(10)_ItemDesc
	..s:RefCheckItem="" RefCheckItem=ItemDesc
	..s:RefCheckItemID'="" RefCheckItemID=RefCheckItemID_"^"_ARCIM
	..s:RefCheckItemID="" RefCheckItemID=ARCIM
	.e  i Stat=6 d
	..s:HadCheckItem'="" HadCheckItem=HadCheckItem_$c(10)_ItemDesc
	..s:HadCheckItem="" HadCheckItem=ItemDesc
	..s:HadCheckItemID'="" HadCheckItemID=HadCheckItemID_"^"_ARCIM
	..s:HadCheckItemID="" HadCheckItemID=ARCIM
	..i CheckFlag="NC" s CheckFlag="PC"
	..e  i ((CheckFlag="")||(CheckFlag="AC")) s CheckFlag="AC" 
	..e  s CheckFlag="PC"
	.e  d
	..s:NoCheckItem'="" NoCheckItem=NoCheckItem_$c(10)_ItemDesc
	..s:NoCheckItem="" NoCheckItem=ItemDesc
	..s:NoCheckItemID'="" NoCheckItemID=NoCheckItemID_"^"_ARCIM
	..s:NoCheckItemID="" NoCheckItemID=ARCIM
	..i CheckFlag="AC" s CheckFlag="PC"
	..e  i ((CheckFlag="")||(CheckFlag="NC")) s CheckFlag="NC" 
	..e  s CheckFlag="PC"
	
	q
	
SetChcekValue
	s (tARCIMDesc,tItemStatusDesc,tRegNo,tName,tSex,tAge,tVIPDesc,tTel,tGDesc,tCurRoom,tCheckStatus,tAuditStatus,tNoCheckItem,tHadCheckItem,tRefCheckItem,tRoomPlace)=""	
	q
OutChcekStatus 
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	set Data=$lb(tARCIM,tARCIMDesc,tItemStatus,tItemStatusDesc,tPAADM,tRegNo,tName,tSex,tAge,tVIPDesc,tTel,tGDesc,tCurRoom,tCheckStatus,tAuditStatus,tNoCheckItem,tHadCheckItem,tRefCheckItem,tRoomPlace,Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

}
