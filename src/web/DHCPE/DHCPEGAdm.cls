Import SQLUser

/// Created by MLH 2006/4
/// Description:
/// -----------------------
/// Modified by SongDeBo 2006/6/1
/// Description: Add parameter "IncludeRegisterec" in GetDataFromCRM
/// 			 add function "DietUpdate"
/// ----------------------
/// modified by SongDeBo 2006/4/20
/// Description: Notify CRMSystem when audit in function "AuditUpdate"
/// -----------------------------------
Class web.DHCPE.DHCPEGAdm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 组件DHCPEGAudit(团体财务审核[到达])  组合条件查询
Query bGADMQuery(GBIDesc As %String = "", AuditUser As %String = "", AuditDateBegin As %String = "", AuditDateEnd As %String = "", STatusIsCheched As %String = "", STatusIsCharged As %String) As %Query(ROWSPEC = "TRowId:%String, TGDesc:%String, TGBIDR:%String, TGStatus:%String, TGAccountAmount:%String, TGDiscountedAmount:%String, TGFactAmount:%String, TAuditUser:%String, TAuditDate:%String, TAdmDate:%String")
{
}

// **************************************************************************

ClassMethod bGADMQueryExecute(ByRef qHandle As %Binary, GBIDesc As %String = "", AuditUser As %String = "", AuditDateBegin As %String = "", AuditDateEnd As %String = "", STatusIsCheched As %String = "", STatusIsCharged As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=0
 	
 	i ("1" = STatusIsCheched)  d //显示已审核[到达] 
 	.s STatusList="REGISTERED"_"ARRIVED"
 	e  d 
 	.s STatusList="REGISTERED"
 	i ("1" = STatusIsCharged)  d //显示已结算
 	.s STatusList=STatusList_"CHARGED"

	f  s id=$o(^DHCPEGADM(id)) q:id=""  d     //团体客户ADM表 DHC_PE_GADM
	.s CurData=$g(^DHCPEGADM(id))	
	.
	.//GADM_GBI_DR
	.s GBIDR=$p(CurData,"^",1)					//团体ADM
	.q:GBIDR=""
	.//团体客户基本信息登记表DHC_PE_GBaseInfo		
	.s GDesc=$p($g(^DHCPEGBI(GBIDR)),"^",2)		//团体名称
	.q:((""'=GBIDesc)&('(GDesc[GBIDesc)))
	.
	.//GADM_AdmDate
	.s GAdmDate=$p(CurData,"^",2)				//体检日期
	.q:(""'=AuditDateBegin)&(GAdmDate<AuditDateBegin)		
	.q:(""'=AuditDateEnd)&(GAdmDate>AuditDateEnd)	
	.i (""'=GAdmDate) d
	..s GAdmDate=$ZD(GAdmDate,3)
	.
	.//GADM_Status
	.s GStatus=$p(CurData,"^",8)				//状态
	.q:('(STatusList[GStatus))	
	.
	.//GADM_AccountAmount
    .s GAccountAmount=$p(CurData,"^",9)		//应收金额
    .//GADM_DiscountedAmo
    .s GDiscountedAmount=$p(CurData,"^",10)		//打折后金额
    .//GADM_FactAmount
    .s GFactAmount=$p(CurData,"^",11)			//实际金额
    .
    .//GADM_AuditUser_DR
    .s GAuditUserId=$p(CurData,"^",12)			//审核[到达]人	
  	.i (""'=GAuditUserId) d
  	..s AuditUserName=$p($g(^SSU("SSUSR",GAuditUserId)),"^",2)	//审核[到达]人名称
  	.e  d
  	..s AuditUserName=""
  	.q:((""'=AuditUser)&('(AuditUserName[AuditUser)))
  	.
    .//GADM_AuditDate
    .s GAuditDate=$p(CurData,"^",13)							//审核[到达]日期
    .i (""'=GAuditDate) d
    ..s GAuditDate=$ZD(GAuditDate,3)
    .
    .d Build
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build

	;			 TRowId  TGDesc TGBIDR TGStatus TGAccountAmount  TGDiscountedAmount  TGFactAmount  TAuditUser     TAuditDate  TAdmDate
	set Data=$lb( $g(id), GDesc, GBIDR, GStatus, GAccountAmount,  GDiscountedAmount,  GFactAmount,  AuditUserName, GAuditDate, GAdmDate )
	//w $g(id), GDesc, GBIDR, GStatus, GAccountAmount,   GDiscountedAmount,   GFactAmount,   AuditUserName, GAuditDate
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod bGADMQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = bGADMQueryExecute ]
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

ClassMethod bGADMQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = bGADMQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 组件 DHCPEGCashier（团体费用管理） 
Query GCashier(GADM As %String = "", GBIDesc As %String = "", AuditDateBegin As %String = "", AuditDateEnd As %String = "") As %Query(ROWSPEC = "TRowId:%String, TGDesc:%String, TGBIDR:%String, TGStatus:%String, TGAccountAmount:%String, TGDiscountedAmount:%String, TGFactAmount:%String, TGAuditDate:%String, TDischargedAmount:%String, TPayAmount:%String, TAdmDate:%String,TGADM:%String,TAsCharged:%String,TDisChargedMode:%String,TGReportSend:%String,TCRMADM:%String,TConfirmStatus:%String")
{
}

ClassMethod GCashierExecute(ByRef qHandle As %Binary, GADM As %String = "", GBIDesc As %String = "", AuditDateBegin As %String = "", AuditDateEnd As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=""
 	i AuditDateBegin'=""  s AuditDateBegin=##class(websys.Conversions).DateHtmlToLogical(AuditDateBegin)
 	i AuditDateEnd'=""    s AuditDateEnd=##class(websys.Conversions).DateHtmlToLogical(AuditDateEnd)
 	
 	s GBIDesc=##class(web.DHCPE.DHCPECommon).UnEscape(GBIDesc)
 	s STatusList="ARRIVED"					//允许显示状态列表
 	
	f  s id=$o(^DHCPEGADM(id),-1) q:(id="")||(id=0)  d
	.q:..HadUsedAudit("G","",id)
	.s CRMADM=$P($g(^DHCPEGADM(id)),"^",2)
	.s LocID=$P($G(^DHCPEPreGADM(CRMADM)),"^",23)
	.;s hospCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	.s hospCode=$G(^DHCPESetting("DHCPE","HospitalCode",LocID))
	.q:(0=+$G(^DHCPEDataEx("DHCPECharge","Group",id)))&&($G(^DHCPESetting("DHCPE","AllowCharge",LocID))=1)
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("GADM",id)
  	.q:LocFlag=1
	.s CurData=$g(^DHCPEGADM(id))			//团体客户ADM表 DHC_PE_GADM
	.
	.//GADM_GBI_DR
	.s GBIDR=$p(CurData,"^",1)
	.
	.//团体客户基本信息登记表DHC_PE_GBaseInfo
	.i GBIDR'="" s GDesc=$p($g(^DHCPEGBI(GBIDR)),"^",2)		//团体名称
	.q:((""'=GBIDesc)&('(GDesc[GBIDesc)))	
	.//GADM_AdmDate
	.s GAdmDate=$p(CurData,"^",4)				//体检日期
	.q:(""'=AuditDateBegin)&(GAdmDate<AuditDateBegin)&(GADM="")
	.q:(""'=AuditDateEnd)&(GAdmDate>AuditDateEnd)&(GADM="")
	.i (""'=GAdmDate) d
	..s GAdmDate=##class(websys.Conversions).DateLogicalToHtml(GAdmDate)
	.//GADM_Status
	.s GStatus=$p(CurData,"^",6)
	.q:GStatus'=STatusList
	.s GStatus=##class(web.DHCPE.PreAudit).GetADMStatus(GStatus)
	.//GADM_AccountAmount
    .s AccountAmount=""  //=$p(CurData,"^",9)			//应收金额
    .//GADM_DiscountedAmo
    .s DiscountedAmount=""  //$p(CurData,"^",10)		//打折后金额
    .//GADM_FactAmount
    .s FactAmount=""  //$p(CurData,"^",11)			//实际金额
    .
    .//GADM_AuditDate
    .s AuditDate=$p(CurData,"^",13)							//审核[到达]日期
    .i (""'=AuditDate) d
    ..s AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
    .
    .s DischargedAmount=$p(CurData,"^",16)
    .i DischargedAmount="" s DischargedAmount=0
    .s PayAmount=FactAmount-DischargedAmount
    .s CRMADM=$p(CurData,"^",2)
    .s TGADM=$p(CurData,"^",3)
    .s PGBIID=$p($G(^DHCPEPreGADM(CRMADM)),"^",1)
    .s TGADM=$p($G(^DHCPEPreGBI(PGBIID)),"^",13)
    .q:(GADM'="")&&(GADM'=TGADM)
    
    .s TAsCharged=$p(CurData,"^",7)
    .i TAsCharged="Y" s TAsCharged="是"
    .i TAsCharged="N" s TAsCharged="否"
    .s TDisChargedMode=$p(CurData,"^",16)
    .s TDisChargedMode=##class(web.DHCPE.PreAudit).GetDisChargedMode(TDisChargedMode)
    .s TGReportSend=$p(CurData,"^",14)
    .s TGReportSend=##class(web.DHCPE.PreAudit).GetGReportSend(TGReportSend)
    .//if GStatus="ARRIVED" d Build
    .S PGTSub="",ConfirmStatus="否"
    .F  S PGTSub=$O(^DHCPEPreGADM(CRMADM,"Team",PGTSub)) Q:(PGTSub="")||(ConfirmStatus="是")  D
    ..s ConfirmStatus=##class(web.DHCPE.PreItemList).GetItemName(CRMADM_"||"_PGTSub,"Team")
    ..i ConfirmStatus["确认加项"  S ConfirmStatus="是"
    ..e  S ConfirmStatus="否"

    .d Build
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build
	set Data=$lb(	 $g(id), GDesc, GBIDR, GStatus, AccountAmount,  DiscountedAmount,  FactAmount,  AuditDate,  DischargedAmount, PayAmount, GAdmDate,TGADM,TAsCharged,TDisChargedMode,TGReportSend,CRMADM,ConfirmStatus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GCashierFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GCashierExecute ]
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

ClassMethod GCashierClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GCashierExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// ##class(web.DHCPE.DHCPEGAdm).HadUsedAudit("I", "", 64)
/// Type "G":团体,"I":个人  CRMADM  预约ID  GIADM  到达后ID
/// 判断是否有可用来收费的审核纪录  1 没有  0有
ClassMethod HadUsedAudit(Type, CRMADM, GIADM)
{
	
	s Flag=1
	s ArgType=""
	s ChargedFlag="N",TeamFlag=""
 	s (PreADM,ADM)=""
 	s id=0
 	i Type="G"
 	{
	 	i CRMADM'=""
	 	{
		 	s PreADM=CRMADM
		 	s ADM=$o(^DHCPEGADM(0,"CRMADM",CRMADM,0))
	 	}
	 	elseif GIADM'=""
	 	{
		 	s ADM=GIADM
		 	s PreADM=$p($G(^DHCPEGADM(GIADM)),"^",2)
		 

	 	}
 	}
 	i Type="I"
 	{
	 	i CRMADM'=""
	 	{
		 	s PreADM=CRMADM
		 	s ADM=$o(^DHCPEIADM(0,"CRMADM",CRMADM,0))
	 	}
	 	elseif GIADM'=""
	 	{
		 	s ADM=GIADM
		 	s PreADM=$p($G(^DHCPEIADM(GIADM)),"^",4)
		 	s TeamFlag=$p($G(^DHCPEIADM(GIADM)),"^",2)
		 	s ChargedFlag=$p($G(^DHCPEIADM(GIADM)),"^",7)
	 	}
 	}
 	i CRMADM'="" s ArgType="CRM"
 	
 	i ADM'=""
 	{
	 	f  s id=$o(^DHCPEPreA(0,"GIADM",Type,ADM,id)) q:(id="")||(Flag=0)  d
	 	.s CRM=$p($G(^DHCPEPreA(id)),"^",2)
	 	.q:((ArgType="CRM")&&(CRM'=""))
	 	.s Status=$p($G(^DHCPEPreA(id)),"^",14)
	 	.q:Status="CHARGED"
	 	.s Amount=$p($G(^DHCPEPreA(id)),"^",9)
	 	.i Amount="" s Amount=0
	 	.;q:Amount=0
	 	.Q:('$d(^DHCPEPreIADM(0,"PAORDITEM",id)))&&('$d(^DHCPEPreIADM(0,"PAORDENT",id)))
	 	.s Flag=0
	 	
	 	;i ((ChargedFlag="N")&&(TeamFlag'="")) s Flag=0
 	}
 	
 	s id=0
 	i PreADM'=""
 	{
	 	f  s id=$o(^DHCPEPreA(0,"CRMADM",Type,PreADM,id)) q:(id="")||(Flag=0)  d
	 	.s CRM=$p($G(^DHCPEPreA(id)),"^",3)
	 	.q:((ArgType="")&&(CRM'=""))
	 	.s Status=$p($G(^DHCPEPreA(id)),"^",14)
	 	.q:Status="CHARGED"
	 	.s Amount=$p($G(^DHCPEPreA(id)),"^",9)
	 	.i Amount="" s Amount=0
	 	.;q:Amount=0
	 	.Q:('$d(^DHCPEPreIADM(0,"PAORDITEM",id)))&&('$d(^DHCPEPreIADM(0,"PAORDENT",id)))
	 	.s Flag=0
 	}
 	
 	q Flag
}

/// 提供一个查询审核[到达]人的列表
Query FindUser() As %Query(ROWSPEC = "usrname:%String,rowid:%String")
{
}

ClassMethod FindUserExecute(ByRef qHandle As %Binary) As %Status
{
   
    Set repid=$I(^CacheTemp)
    s ind=1
    s rowid="0"
    f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
    .s usrname=$p(^SSU("SSUSR",rowid),"^",2)
    .Do OutputRow3
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(usrname,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	Quit $$$OK
}

ClassMethod FindUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUserExecute ]
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
	Quit $$$OK
}

ClassMethod FindUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUserExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Created by MLH 
Query GADMList(GBIDesc As %String = "", RegDate As %String = "", ShowPersonGroup As %String = "0", Status As %String = "") As %Query(ROWSPEC = "TRowId:%String:团体ID,TGDesc:%String:团体名称,TGStatus:%String:状态,TAdmDate:%String:时间") [ SqlProc ]
{
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.DHCPEGAdm", "GADMList","团体","","1")

ClassMethod GADMListExecute(ByRef qHandle As %Binary, GBIDesc As %String = "", RegDate As %String = "", ShowPersonGroup As %String = "0", Status As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s GBIDesc=##class(web.DHCPE.DHCPECommon).UnEscape(GBIDesc)
 	s:""'=GBIDesc GBIDesc=$ZCVT(GBIDesc,"U")
 	s STatusList="ARRIVED"					
 	i ShowPersonGroup="1" d
 	.s id="ALLI"
 	.s GDesc="所有个人"
 	.s (GStatus, GAdmDate)=""
 	.d Build
 	.s id="ALLG"
 	.s GDesc="所有团体"
 	.s (GStatus, GAdmDate)=""
 	.d Build
	s id=""
 	f  s id=$o(^DHCPEGADM(id),-1) q:(id="")||(id=0)  d
	.s CurData=$g(^DHCPEGADM(id))			
	.s GBIDR=$p(CurData,"^",1)
	.q:GBIDR=""
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("GADM",id)  //add 2009-07-07 
    .q:LocFlag=1   
	.s GDesc=$p($g(^DHCPEGBI(GBIDR)),"^",2)
	.s TNamePY=##class(web.DHCINSUPort).GetCNCODE(GDesc,4,"")
	.;s ParaTNamePY=##class(web.DHCINSUPort).GetCNCODE(GBIDesc,4,"")
	.;q:(""'=ParaTNamePY)&('(TNamePY[ParaTNamePY))
	.;q:((""'=GBIDesc)&('(GDesc[GBIDesc)))
	.;q:((""'=GBIDesc)&('(($ZCVT(GBIDesc,"U")[GDesc)||(TNamePY[GBIDesc))))
	.;q:((""'=GBIDesc)&('(($ZCVT(GBIDesc,"U")[GDesc)||(TNamePY[GBIDesc))))	
	.q:(""'=GBIDesc)&&(GDesc'[GBIDesc)&&(TNamePY'[GBIDesc)
	.s GAdmDate=$p(CurData,"^",4)
	.;q:(""'=RegDate)
	.i (""'=GAdmDate) s GAdmDate=##class(websys.Conversions).DateLogicalToHtml(GAdmDate)
	.s GStatus=$p(CurData,"^",6)
	.q:((Status'[GStatus))&&(Status'="")
	.s:(""'=GStatus) GStatus=##Class(web.DHCPE.PreCommon).TransStatus(GStatus)
	.s:(""=GStatus) GStatus=""
	.;q:((STatusList'[GStatus))	
    .d Build
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build
	;				TRowId  TGDesc TGBIDR TGStatus TGAccountAmount TGDiscountedAmount TGFactAmount TGAuditDate TDischargedAmount TPayAmount	TAdmDate
	//w GStatus
	set Data=$lb($g(id), GDesc, GStatus, GAdmDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GADMListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GADMListExecute ]
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

ClassMethod GADMListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GADMListExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 根据给定的对应CRM的团体ADM号得到系统中团体ADM 菜单:团体登记
ClassMethod SearchGADMRowId(itmjs As %Library.String = "", itmjsex As %Library.String = "", GroupRegId As %Library.String = "")
{
    s ADM=-1
    &sql(select GADM_RowId into :ADM 
    	from DHC_PE_GAdm  
    	where GADM_CRMGADM=:GroupRegId)
	q ADM
}

/*Query DHCPEGItemList(GID As %String) As %SQLQuery(ROWSPEC = "GT_Desc:%String, GT_RowId:%String, GT_CRMTeam:%String")
{
	select GT_Desc,GT_RowId,GT_CRMTeam  
	From DHC_PE_GTeam 
	where GT_ParRef=:GID
}*/
Query DHCPEGItemList(GID As %String) As %Query(ROWSPEC = "GT_Desc:%String:分组名称,GT_RowId:%String:分组ID,GT_CRMTeam:%String:分组预约ID")
{
}

ClassMethod DHCPEGItemListExecute(ByRef qHandle As %Binary, GID As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	if (""=GID) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	S GTSub=0
    f  S GTSub=$O(^DHCPEGADM(GID,"Team",GTSub)) q:GTSub=""  d
    .s Desc=$p($g(^DHCPEGADM(GID,"Team",GTSub)),"^",1)
    .s CRMTeam=$p($g(^DHCPEGADM(GID,"Team",GTSub)),"^",2)
    .s GTRowId=GID_"||"_GTSub
	.d GetTeamInfo	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetTeamInfo
	
	set Data=$lb(Desc,GTRowId,CRMTeam)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod DHCPEGItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCPEGItemListExecute ]
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

ClassMethod DHCPEGItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCPEGItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Created by songDeBo 2006/6/1
/// Parameter: IsDieted: "Y"/"N"
/// return: ""-correct; else-error
ClassMethod DietUpdate(GrpAdmId As %String, IsDieted As %String = "Y")
{
	&SQL(update sqluser.dhc_pe_iadm set IADM_Diet=:IsDieted where IADM_GADM_DR=:GrpAdmId)
	q ""
}

/// 到达状态///Created by MLH
/// return: 0-正常 ,  else-有错
ClassMethod ArrivedUpdate(GRowId As %Library.String = "", GStatus As %Library.String = "")
{
	s ^Bob("temp",$zn)=GRowId _"^"_GStatus
	s AuditDate=+$h
	s crmGAdmId=""
	&sql(select GADM_CRMGAdm into :crmGAdmId from DHC_PE_GAdm where GADM_RowId=:GRowId)
	b:(crmGAdmId="")
	q:crmGAdmId="" -1
	
	s CurData=$g(^DHCPEGADM(GRowId))
	s AsCharged=$p(CurData,"^",15)
	s DelegateADM=$p(CurData,"^",14)  //团体代表的ADM号
	b:(DelegateADM="")
	q:DelegateADM="" -1
	
	//到达
	i GStatus="ARRIVED"  D 
	.//处理视同收费(医嘱Billed状态TB->P,视同收费表插入,状态O)
	.i AsCharged="Y" d
	..//给代表人挂帐
	..s OrdId=0
	..f  s OrdId=$o(^OEORD(0,"Adm",DelegateADM,OrdId)) q:OrdId=""  d
	...s OrdItem=0
	...f  s OrdItem=$o(^OEORD(OrdId,"I",OrdItem)) q:OrdItem=""  d
	....s OriData=$g(^OEORD(OrdId,"I",OrdItem,3))
	....s BillFlag=$p(OriData,"^",5)
	....i ((BillFlag="TB")!(BillFlag="B")) d
	.....s OriRowId=OrdId_"||"_OrdItem
	.....&sql(insert into DHC_PE_AsChargedOrder(ACO_PAADM_DR,ACO_OEORI_DR,ACO_BillStatus)values(:DelegateADM,:OriRowId,'O')) 
	.....&sql(update OE_OrdItem set Oeori_Billed='P' where oeori_rowid=:OriRowId)
	..//给团体中的成员挂帐
	..s IADM=0
	..f  s IADM=$o(^DHCPEIADM(0,"GADM",GRowId,IADM)) q:IADM=""  d
	...s IADMData=$g(^DHCPEIADM(IADM))
	...s PAADM=$p(IADMData,"^",1)
	...s OrdId=0
	...f  s OrdId=$o(^OEORD(0,"Adm",PAADM,OrdId)) q:OrdId=""  d
	....s OrdItem=0
	....f  s OrdItem=$o(^OEORD(OrdId,"I",OrdItem)) q:OrdItem=""  d
	.....s OriData=$g(^OEORD(OrdId,"I",OrdItem,3))
	.....s BillFlag=$p(OriData,"^",5)
	.....i ((BillFlag="TB")!(BillFlag="B")) d
	......s OriRowId=OrdId_"||"_OrdItem
	......&sql(insert into DHC_PE_AsChargedOrder(ACO_PAADM_DR,ACO_OEORI_DR,ACO_BillStatus)values(:PAADM,:OriRowId,'O')) 
	......&sql(update OE_OrdItem set Oeori_Billed='P' where oeori_rowid=:OriRowId)
	.////////////////
	.&sql(update DHC_PE_GAdm set GADM_Status=:GStatus where GADM_RowId=:GRowId)
	.&sql(update DHC_PE_IAdm set IADM_Status=:GStatus where iadm_GAdm_Dr=:GRowId)
	e  d
	.//取消到达
	.//处理视同收费(已挂帐的核实医嘱Billed状态P->TB,视同收费表删除该记录)
	.i AsCharged="Y" d
	..//处理代表人
	..s AsChargeOrd=0
	..s ^lisatest("DelegateADM")=DelegateADM
	..f  s AsChargeOrd=$o(^DHCPEACO(0,"PAADM",DelegateADM,AsChargeOrd)) q:AsChargeOrd=""  d
	...s AsChargeStatus=$p(^DHCPEACO(AsChargeOrd),"^",3)
	...i AsChargeStatus="O" d //医嘱是挂帐
	....s OrdRowId=$p(^DHCPEACO(AsChargeOrd),"^",2)
	....s OrdId=$p(OrdRowId,"||",1)
	....s OrdItem=$p(OrdRowId,"||",2)
	....s OriData=$g(^OEORD(OrdId,"I",OrdItem,1))
	....s OrdStat=$p(OriData,"^",13)
	....i (OrdStat=1) d //医嘱状态是核实
	.....&sql(update OE_OrdItem set Oeori_Billed='TB' where oeori_rowid=:OrdRowId)
	.....&sql(delete from DHC_PE_AsChargedOrder where ACO_RowId=:AsChargeOrd)
	..//处理团体中的成员
	..s IADM=0
	..f  s IADM=$o(^DHCPEIADM(0,"GADM",GRowId,IADM)) q:IADM=""  d
	...s IADMData=$g(^DHCPEIADM(IADM))
	...s PAADM=$p(IADMData,"^",1)
	...s AsChargeOrd=0
	...b //1
	...f  s AsChargeOrd=$o(^DHCPEACO(0,"PAADM",PAADM,AsChargeOrd)) q:AsChargeOrd=""  d
	....b //2
	....s AsChargeStatus=$p(^DHCPEACO(AsChargeOrd),"^",3)
	....i AsChargeStatus="O" d //医嘱是挂帐
	.....s OrdRowId=$p(^DHCPEACO(AsChargeOrd),"^",2)
	.....s OrdId=$p(OrdRowId,"||",1)
	.....s OrdItem=$p(OrdRowId,"||",2)
	.....s OriData=$g(^OEORD(OrdId,"I",OrdItem,1))
	.....s OrdStat=$p(OriData,"^",13)
	.....i (OrdStat=1) d //医嘱状态是核实
	......&sql(update OE_OrdItem set Oeori_Billed='TB' where oeori_rowid=:OrdRowId)
	......&sql(delete from DHC_PE_AsChargedOrder where ACO_RowId=:AsChargeOrd)
	.////////////////////////////
	.&sql(update DHC_PE_GAdm set GADM_Status=:GStatus where GADM_RowId=:GRowId)
	.&sql(update DHC_PE_IAdm set IADM_Status=:GStatus where iadm_GAdm_Dr=:GRowId) 
	
	//s rtn=##Class(web.DHCPE.GatewayCRM).ExamStatusNotify("GROUP",crmGAdmId,GStatus,"")

	q SQLCODE
}

/// 结算 Created by MLH
ClassMethod GroupBilled(itmjs As %Library.String = "", itmjsex As %Library.String = "", GRowId As %Library.String = "", UserId As %Library.String = "", PaymodeType As %Library.String = "", ChequeNo As %Library.String = "", Instype As %Library.String = "", gloc As %Library.String = "", FactAmount As %Library.String = "", PayAmount As %Library.String = "")
{
	s BillRet=0
	s BilledDate=+$h
	s BilledTime=$p($H,",",2)
	;s Paymode=PaymodeType_"^"_ChequeNo_"^"

	s mySqlCode=0
 	s id=0
 	//只对团体代表人结算
 	s DelegateADM=$p(^DHCPEGADM(GRowId),"^",14)
 	s GDelegate="Y"
 	//RowId As %Library.String = "", PAADM As %Library.String = "", UserId As %Library.String = "", PaymodeType As %Library.String = "", ChequeNo As %Library.String = "", Instype As %Library.String = "", gloc As %Library.String = "", FactAmount As %Library.String = "", PayAmount As %Library.String = ""
	s ret=##class(web.DHCPE.DHCPEIAdm).IBilled("","","",DelegateADM,UserId,PaymodeType,ChequeNo,Instype,gloc,FactAmount,PayAmount,GDelegate,GRowId)
	//
	//
	//如果团体代表人结算成功，处理该团体所有人员(？？？？？？？？？？？？)
	//
	
	s AsCharged=$p(^DHCPEGADM(GRowId),"^",15) //是否视同收费
	s ^lisatest("AsChargedeeeee")=AsCharged
	s ^lisatest("AsChargedeeeee-ret")=ret
	i $p(ret,"^",1)=0 d
	.f  s id=$o(^DHCPEIADM(0,"GADM",GRowId,id)) q:id=""  d
	..s CurData=$g(^DHCPEIADM(id))
	..s PAADM=$p(CurData,"^",1)
	..i (PAADM'="") d
	...s OEOrder=0
	...f  s OEOrder=$o(^OEORD(0,"Adm",PAADM,OEOrder)) q:OEOrder=""  d
	....s Chd=0
	....f  s Chd=$o(^OEORD(OEOrder,"I",Chd)) q:Chd=""  d
	.....s OrderData=$g(^OEORD(OEOrder,"I",Chd,3))
	.....s OEOrdItem=OEOrder_"||"_Chd
	.....s BillFlag=$p(OrderData,"^",5)
	.....i BillFlag="TB" d
	......&sql(update OE_OrdItem set OEORI_Billed='P' where OEORI_RowId=:OEOrdItem)
	.....i ((AsCharged="Y")&(BillFlag="P"))  d  //是视同收费，视同收费表修改状态为O->P
	......s ^lisatest("AsChargedeeeee",OEOrdItem)=""
	......&sql(update DHC_PE_AsChargedOrder set ACO_BillStatus='P' where ACO_OEORI_DR=:OEOrdItem)
	.e  d
	..goto errhandler
	//&sql(update DHC_PE_GAdm set GADM_Status="CHARGED",GADM_DischargedAmount=:PayAmount where GADM_RowId=:GRowId)
	q ret
errhandler
	q 1
}

Query GetDataFromCRM(GName As %String, IncludeRegistered As %String = "") As %Query(ROWSPEC = "TGroupId:%String,TGroupRegId:%String,TGroupName:%String,TPreRegDate:%String,TRecordDate:%String,TDiscountLevel:%String,TStatus:%String,TCountAmount:%String,TDiscountAmount:%String,TFinalAmount:%String,TStatusDesc:%String,TPreEndDate:%String,TDelayDate:%String")
{
}

ClassMethod GetDataFromCRMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataFromCRMExecute ]
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

ClassMethod GetDataFromCRMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataFromCRMExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Add By SongDeBo 2006/5/25
/// return: "0"-正常 ,  else-有错
/// test: 	w ##class(web.DHCPE.DHCPEGAdm).GAdmArrived("100")
ClassMethod GAdmArrived(CrmGAdmId As %String) As %String
{
	s objGAdm=##class(web.DHCPE.HandlerGroup).getGRegByCRMId(CrmGAdmId)
	q:(objGAdm.%Id()="") "The Group is not exists in HIS system. CrmGAdmId="_CrmGAdmId
	
	s ret=..ArrivedUpdate(objGAdm.%Id(),"ARRIVED")
	q ret
}

/// add by jdl
/// 到达状态
/// GRowId:DHC_PE_GAdm-->GADM_RowId
/// GStatus:"ARRIVED";
/// return: 0-正常 ,  else-有错
ClassMethod ArrivedUpdateNew(GRowId As %Library.String = "", GStatus As %Library.String = "")
{
	if IStatus="PREREG"
	{
		s rtn= ##class(web.DHCPE.Cashier).CheckPayed("G",GRowId)
		if rtn>0  q "该客户已经有收费记录，不能取消到达!"
		//&
	}
	s err=""
	s dealIAdmFlag=0  ///是否处理该团体的所有个人客户
	s AuditDate=+$h
	s crmGAdmId=$p($g(^DHCPEGADM(GRowId)),"^",2)
	q:crmGAdmId="" -1
	
	s CurData=$g(^DHCPEGADM(GRowId))
	s AsCharged=$p(CurData,"^",7)
	s DelegateADM=$p(CurData,"^",3)  //团体代表的ADM号
	b:(DelegateADM="")
	q:DelegateADM="" -1
	
	///如果是挂帐，则处理相应的医瞩
	i AsCharged="Y" d
	.//给代表人挂帐
	.//s admid=DelegateADM
	.//d ##class(web.DHCPE.OEOrdItem).TransOrder(admid,GStatus)
	.//是否处理该团体的所有个人客户
	.i dealIAdmFlag=1  d
	..s IADM=0
	..f  s IADM=$o(^DHCPEIADM(0,"GADM",GRowId,IADM)) q:IADM=""  d
	...s admid=$p($g(^DHCPEIADM(IADM)),"^",1)
	...s err=##class(web.DHCPE.OEOrdItem).TransOrder(admid,GStatus)
	
	if err'="" q err	
	&sql(update DHC_PE_GAdm set GADM_Status=:GStatus where GADM_RowId=:GRowId)
	if SQLCODE q SQLCODE
	i dealIAdmFlag=1  d
	.&sql(update DHC_PE_IAdm set IADM_Status=:GStatus where iadm_GAdm_Dr=:GRowId) 
	if SQLCODE q SQLCODE	
	s result=##Class(web.DHCPE.CRM.Gateway).ExamStatusNotify("GROUP",GRowId,GStatus,"")
	q result
}

ClassMethod GetDataFromCRMExecute(ByRef qHandle As %Binary, GName As %String, IncludeRegistered As %String = "") As %Status
{
	s gatewayCRM=##class(web.DHCPE.CRM.Factory).GetGateway()
	//b //0715-3
	s ^lisatest("GRegister")=GName
	s Ret=gatewayCRM.GetGrpRegList("GROUPNAME",GName,"UNCOMPLETED")
	//s ^lisatest("CRM")=Ret
	//s ^lisatest("CRM0716-IncludeRegistered")=IncludeRegistered
	s StatusList="CHECKED,PREREG,MODIFIED,"
	i IncludeRegistered'=""  s StatusList=StatusList_"REGISTERED,"
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=0
	Set GCount=$L(Ret,$C(1))
	s ^lisatest("GCount")=GCount
	For i=1:1:GCount Do
	.Set GItem=$p(Ret,$c(1),i)
	.//Quit:GItem=""
	.Set Status=$p(GItem,"^",7)
	.//Quit:(StatusList'[Status)
	.//b //0715-1
	.Set StatusDesc=##Class(web.DHCPE.Public.Common).strGetMatchVal("PREREG^MODIFIED^REGISTERED^ARRIVED^CHARGED^COMPLETED","预约^修改^登记^到达^收费^完成",Status,"^")
	.//Set StatusDesc=$$strGetMatchVal^DHCPECommon("PREREG^MODIFIED^REGISTERED^ARRIVED^CHARGED^COMPLETED","预约^修改^登记^到达^收费^完成",Status,"^")
	.//b //0715-2
	.Set GId=$p(GItem,"^",1)
	.Set GRegId=$p(GItem,"^",2)
	.Set GName=$p(GItem,"^",3)
	.Set PreRegDate=$p(GItem,"^",4)
	.Set RecordDate=$p(GItem,"^",5)
	.Set DiscountLevel=$p(GItem,"^",6)
	.set PreEndDate=$p(GItem,"^",8)
	.set PreDelayDate=$p(GItem,"^",9)
	.Set CountAmount=""
	.Set DiscountAmount=""
	.Set FinalAmount=""
    .d Build
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build
	set Data=$lb(GId,GRegId,GName,PreRegDate,RecordDate,DiscountLevel,Status,CountAmount,DiscountAmount,FinalAmount,StatusDesc,PreEndDate,PreDelayDate)
	s ^lisatest("Data")=Data
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q	
 	//Quit $$$OK
}

/// add by jdl 2007-4-24
/// ##Class(web.DHCPE.DHCPEGAdm).GetGAdmDesc(GAdm)
ClassMethod GetGAdmDesc(GAdm)
{
	s gAdmDesc=""
	if GAdm="" q gAdmDesc
	i GAdm="ALLG" s gAdmDesc="所有团体"
	i GAdm="ALLI" s gAdmDesc="所有个人"
	s gBaseInfoId=$p($g(^DHCPEGADM(GAdm)),"^",1)
	if gBaseInfoId="" q gAdmDesc
	s gAdmDesc=$p($g(^DHCPEGBI(gBaseInfoId)),"^",2)
	q gAdmDesc
}

/// ##Class(web.DHCPE.DHCPEGAdm).GetGTeamDesc(GTeam)
ClassMethod GetGTeamDesc(GTeam)
{
	if GTeam="" q ""
	q:GTeam'["||" ""
	q $p($g(^DHCPEGADM($p(GTeam,"||",1),"Team",$p(GTeam,"||",2))),"^",1)
}

}
