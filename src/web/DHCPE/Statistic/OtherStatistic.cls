Class web.DHCPE.Statistic.OtherStatistic Extends %RegisteredObject
{

/// Creator：      ln
/// CreateDate：   2021-01-20
/// Description:：统计视同收费未交费的个人
/// Table：       DHC_PE_IADM  
/// Input：       BeginDate,EndDate
/// Output：      
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.OtherStatistic","AsChargedStatistic","2020-12-01","2021-01-20","152") 
Query AsChargedStatistic(BeginDate As %Library.String = "", EndDate As %Library.String = "", CTLOCID As %Library.String = "") As websys.Query(ROWSPEC = "IADM:%String,RegNo:%String,Name:%String,Sex:%String,Age:%String,VIPLevel:%String,Tel:%String,CheckDate:%String,PayStatusDesc:%String,TotalAmount:%Float,PayAmount:%Float,UnPayAmount:%Float,User:%String,AsDate:%String,AsTime:%String,Now:%String") [ SqlProc ]
{
}

ClassMethod AsChargedStatisticExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", CTLOCID As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
 	if ((""=BeginDate)&(""=EndDate)){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
 	i EndDate'=""   s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	i BeginDate="" s BeginDate=+$H
	i EndDate="" s EndDate=+$H
	s AdmDate=BeginDate-1
	f  s AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate)) q:(AdmDate="")||(AdmDate>EndDate)  d
	.s Time=""
	.f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate,Time)) q:(Time="")  d
	..s IADM=0
	..f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate,Time,IADM)) q:(IADM="")  d
	...s id=IADM
	...d OneAsInfo
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneAsInfo
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",id,CTLOCID)
	q:LocFlag="1"
	s CurData=$g(^DHCPEIADM(id))
	s IADMCRMADM=$p(CurData,"^",4)  // DHC_PE_PREIADM
	Q:(""=IADMCRMADM)
	s Status=$p($G(^DHCPEPreIADM(IADMCRMADM)),"^",8)
	q:Status'="ARRIVED"
	s PGADM=$p($G(^DHCPEPreIADM(IADMCRMADM)),"^",2)
	q:PGADM'=""
	s AsCharged=$p($G(^DHCPEPreIADM(IADMCRMADM)),"^",9)
	q:AsCharged'="Y"
	s PayStatus=##class(web.DHCPE.HandlerPreOrds).GetPaiedFlag(IADMCRMADM)
	q:(PayStatus="2")||(PayStatus="3")
	s PayStatusDesc=##class(web.DHCPE.HandlerPreOrds).GetPaiedFlagDesc(PayStatus)
	s retvalue=##Class(web.DHCPE.InvPrt).GetAdmFee(IADMCRMADM)
	s TotalAmount=$p(retvalue,"^",6)
	s PayAmount=$p(retvalue,"^",7)
	s UnPayAmount=$p(retvalue,"^",8)
	s BaseInfo=##Class(web.DHCPE.Statistic.WorkStatistic).GetBaseInfo("Pre",IADMCRMADM)
	s AsChargedInfo=$G(^DHCPEDataEx("AsCharged","I",IADMCRMADM))
	s User=""
	s UserID=$p(AsChargedInfo,"^",3)
	s:UserID'="" User=$p(^SSU("SSUSR",UserID),"^",2)
	s DateTime=$p(AsChargedInfo,"^",4)
	s AsDate=##class(websys.Conversions).DateLogicalToHtml(+DateTime)
	s AsTime=##class(websys.Conversions).TimeLogicalToHtml($p(DateTime,",",2))
	d AsStatisticOut
	
	q	
AsStatisticOut
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))    
    s Data=$LB(id, $p(BaseInfo,"^",1),$p(BaseInfo,"^",2),$p(BaseInfo,"^",3),$p(BaseInfo,"^",4), $p(BaseInfo,"^",5), $p(BaseInfo,"^",6), $p(BaseInfo,"^",7),PayStatusDesc,TotalAmount,PayAmount,UnPayAmount,User,AsDate,AsTime,Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1 	
 	q
}

/// Creator：      ln
/// CreateDate：   2021-06-29
/// Description:：体检中心每日预约情况统计
/// Table：       DHC_PE_IADM 
/// Input：       BeginDate,EndDate,VIPLevel,CTLOCID
/// Output：      
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.OtherStatistic","PreItemStatistic","2023-01-01","2023-02-15","","105","","") 
Query PreItemStatistic(BeginDate As %Library.String = "", EndDate As %Library.String = "", VIPLevel As %Library.String = "", CurLoc As %Library.String = "", PreDate As %Library.String = "", PreVIP As %Library.String = "") As websys.Query(ROWSPEC = "PreIADM:%String,Date:%String,PreDate:%String,VIP:%String,RegNo:%String,Name:%String,Sex:%String,Age:%String,VIPLevel:%String,Tel:%String,CheckDate:%String,GroupName:%String,GTName:%String,Position:%String,Now:%String") [ SqlProc ]
{
}

ClassMethod PreItemStatisticExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, VIPLevel As %Library.String = "", CurLoc As %Library.String = "", PreDate As %Library.String = "", PreVIP As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ((BeginDate="")&(EndDate=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i BeginDate="" s BeginDate=0
	i EndDate="" s EndDate=+$H
	
	s AdmDate=BeginDate-1
	f  s AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate)) q:(AdmDate="")||(AdmDate>EndDate)  d
	.q:(PreDate'="")&&(PreDate'=AdmDate)
	.s Time=""
	.f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate,Time)) q:(Time="")  d
	..s IADM=0
	..f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate,Time,IADM)) q:(IADM="")  d
	...d SetOneInfo
			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SetOneInfo
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADM,CurLoc) 
	q:LocFlag=1
	s Status=$p(^DHCPEIADM(IADM),"^",8)
	q:Status="CANCELPE"
	s PreIADM=$p(^DHCPEIADM(IADM),"^",4)
	s VIP=$p(^DHCPEPreIADM(PreIADM),"^",18)
	q:((VIPLevel'="")&&(VIPLevel'=VIP))
	q:(PreVIP'="")&&(PreVIP'=VIP)
	s Info=##class(web.DHCPE.Statistic.WorkStatistic).GetBaseInfo("Pre",PreIADM)
	s RegDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
	d OutOneInfo
	
	q
OutOneInfo
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	set Data=$lb(PreIADM,AdmDate,RegDate,VIP,$p(Info,"^",1),$p(Info,"^",2),$p(Info,"^",3),$p(Info,"^",4),$p(Info,"^",5),$p(Info,"^",6),$p(Info,"^",7),$p(Info,"^",8),$p(Info,"^",9),$p(Info,"^",10),Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator：      ln
/// CreateDate：   2021-06-29
/// Description:：体检中心每日预约项目统计
/// Table：       DHC_PE_IADM,OE_OrdItem 
/// Input：       Date,CTLOCID
/// Output：      
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.OtherStatistic","ItemDetail","65930","152") 
Query ItemDetail(Date As %Library.String = "", CurLoc As %Library.String = "") As websys.Query(ROWSPEC = "RecLoc:%String,RecLocDesc:%String,ItmMastDR:%String,ARCIMDesc:%String,ordtype:%String,Now:%String") [ SqlProc ]
{
}

ClassMethod ItemDetailExecute(ByRef qHandle As %Binary, Date As %String, CurLoc As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ((Date=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 		
	s Time=""
	f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:(Time="")  d
	.s IADM=0
	.f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADM)) q:(IADM="")  d
	..d SetItemInfo
				
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SetItemInfo
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADM,CurLoc) 
	q:LocFlag=1
	s Status=$p(^DHCPEIADM(IADM),"^",8)
	q:Status="CANCELPE"
	s PAADM=$p(^DHCPEIADM(IADM),"^",1)
	q:PAADM=""
	
	s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,0))
	q:OEORDRowId="" 
	s OrdItemID=""
	s OEORIChildsub=0
	f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
	.s OrdItemID=OEORDRowId_"||"_OEORIChildsub
	.s ItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	.q:ItmMastDR=""
	.s ARCIMDesc=$P($G(^ARCIM($P(ItmMastDR,"||",1),$P(ItmMastDR,"||",2),1)),"^",2)
	.s ordtype=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	.s RecLoc=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	.s RecLocDesc=$p(^CTLOC(RecLoc),"^",2)
	.d OutItemInfo
	
	q
OutItemInfo
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	set Data=$lb(RecLoc,RecLocDesc,ItmMastDR,ARCIMDesc,ordtype,Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 定额卡支付统计报表
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.OtherStatistic","PEPreAIStatistic","2021-07-27","2021-07-27","152")
Query PEPreAIStatistic(BeginDate As %Library.String = "", EndDate As %Library.String = "", CTLOCID As %Library.String = "") As websys.Query(ROWSPEC = "ID:%String,AuditDR:%String,Name:%String,FactAmount:%String,User:%String,TUser:%String,TDate:%String,TTime:%String,Now:%String") [ SqlProc ]
{
}

ClassMethod PEPreAIStatisticExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", CTLOCID As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if ((""=BeginDate) && (""=EndDate) ){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
 	i EndDate'=""   s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 	i BeginDate="" s BeginDate=+$H
	i EndDate="" s EndDate=+$H 	
	s Date=EndDate+1 
	f  s Date=$o(^User.DHCPEAsChargedI("ACDateIndex",Date),-1) q:(Date="")||(Date<BeginDate)  d
	.s ID=""
	.f  s ID=$o(^User.DHCPEAsChargedI("ACDateIndex",Date,ID))  q:ID=""  d
	..d GetOneInfo
	
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
GetOneInfo
    s AuditDR=$LG(^User.DHCPEAsChargedD(ID),2)
    s PAGIADM=$p(^DHCPEPreA(AuditDR),"^",3)
    s ADMType=$p(^DHCPEPreA(AuditDR),"^",1)
    i ADMType="I" d
    .s PreIADM=$p(^DHCPEIADM(PAGIADM),"^",4)
    .s PAADM=$p(^DHCPEIADM(PAGIADM),"^",1)
    .s PIBI=$p(^DHCPEPreIADM(PreIADM),"^",1)
    .s Name=$p(^DHCPEPreIBI(PIBI),"^",2)
    e  d
    .s GBIDR=$p(^DHCPEGADM(PAGIADM),"^",1)
    .s PAADM=$p(^DHCPEGADM(PAGIADM),"^",3)
    .s Name=$p(^DHCPEGBI(GBIDR),"^",2)
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM,CTLOCID) 
	q:LocFlag=1
	
    s FactAmount=$p(^DHCPEPreA(AuditDR),"^",9)
    s User=$LG(^User.DHCPEAsChargedD(ID),3)
    s TUser=$P(^SSU("SSUSR",User),"^",2)
    s TDate=##class(websys.Conversions).DateLogicalToHtml(Date)
    s Time=$LG(^User.DHCPEAsChargedD(ID),5)
    s TTime=##class(websys.Conversions).TimeLogicalToHtml(Time)
    d OutOneInfo
  
	q
OutOneInfo
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	set Data=$lb(ID,AuditDR,Name,FactAmount,User,TUser,TDate,TTime,Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 体检投诉情况统计报表
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.OtherStatistic","PEComplain","2023-02-17","2023-02-28","C","","","105")
Query PEComplain(BeginDate As %Library.String = "", EndDate As %Library.String = "", Type As %Library.String = "", CurType As %Library.String = "", CurUser As %Library.String = "", CurLoc As %Library.String = "") As websys.Query(ROWSPEC = "ID:%String,CType:%String,CTypeDesc:%String,CompUser:%String,CompUserName:%String,CSource:%String,TCComplainObject:%String,TCComplainContent:%String,TCEventTime:%String,TCComplainCause:%String,TCDisProposal:%String,TStatus:%String,DisposeDate:%String,TCClaimantName:%String,TCTel:%String,TCName:%String,Now:%String") [ SqlProc ]
{
}

ClassMethod PEComplainExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", Type As %Library.String = "", CurType As %Library.String = "", CurUser As %Library.String = "", CurLoc As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if ((""=BeginDate) && (""=EndDate) ){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
 	i EndDate'=""   s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 	i BeginDate="" s BeginDate=+$H
	i EndDate="" s EndDate=+$H 	
	
	s Date=EndDate+1 
	f  s Date=$o(^User.DHCPEComplainI("CTypeUpdateDateIndex"," "_Type,Date),-1) q:(Date="")||(Date<BeginDate)  d
	.s ID=""
	.f  s ID=$o(^User.DHCPEComplainI("CTypeUpdateDateIndex"," "_Type,Date,ID))  q:ID=""  d
	..d GetOneInfo
	
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
GetOneInfo
    q:ID="" 
    s obj=##class(User.DHCPEComplain).%OpenId(ID)
    s Cloc=obj.CLocGetObjectId()
    q:(CurLoc'="")&&(CurLoc'=Cloc)
   
    s CType=obj.CComplainType
    q:CType=""
    q:(CurType'="")&&(CurType'=CType)
    s CTypeDesc=##class(web.DHCPE.Complain).GetValueByCode("PEComplain","CType","C",CType)
    
    s CompUser=obj.CComplainUserGetObjectId()
    q:(CurUser'="")&&(CurUser'=CompUser)
    s CompUserName=""
    s:CompUser'="" CompUserName=$P(^SSU("SSUSR",CompUser),"^",2)
    
    s CSource=obj.CSource
    s CSource=##class(web.DHCPE.Complain).GetValueByCode("PEComplain","CSource","C",CSource)
    
    s TCComplainObject=obj.CComplainObject
    s TCComplainObject=##class(web.DHCPE.Complain).GetValueByCode("PEComplain","CObject","C",TCComplainObject)
    s TCComplainContent=obj.CComplainContent
    s TCEventTime=obj.CEventTime
    s TCEventTime=##class(websys.Conversions).DateLogicalToHtml(TCEventTime)
    s TCComplainCause=obj.CComplainCause
    s TCComplainCause=##class(web.DHCPE.Complain).GetValueByCode("PEComplain","CCause","C",TCComplainCause)
    s TCDisProposal=obj.CDisProposal
    
    s CompDispose=$o(^User.DHCPECompDisposeI("CDCompDRIndex",ID,0))
    i CompDispose="" s TStatus="未处理"
    e  s TStatus="已处理"
    s DisposeDate=""
    i CompDispose'="" d
    .s DisposeDate=$LG(^User.DHCPECompDisposeD(CompDispose),6)
    .s:DisposeDate'="" DisposeDate=##class(websys.Conversions).DateLogicalToHtml(DisposeDate)
    
    s TCClaimantName=obj.CClaimantName
    s TCTel=obj.CTel
    s TCName=obj.CName 
    d OutOneInfo
  
	q
OutOneInfo
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	set Data=$lb(ID,CType,CTypeDesc,CompUser,CompUserName,CSource,TCComplainObject,TCComplainContent,TCEventTime,TCComplainCause,TCDisProposal,TStatus,DisposeDate,TCClaimantName,TCTel,TCName,Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

}
