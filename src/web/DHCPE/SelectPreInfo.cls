Class web.DHCPE.SelectPreInfo Extends %Persistent
{

// w ##class(web.DHCPE.SelectPreInfo).InsertPreToTeam("134||2", 1531)

ClassMethod InsertPreToTeam(TeamID, PreIADMID)
{
	s IADM=$O(^DHCPEIADM(0,"CRMADM",PreIADMID,0))
	q:IADM="" "-1^还未登记,请先登记后合并到团体"
	s OldGADM=$P(^DHCPEPreIADM(PreIADMID),"^",2)
	s OldTeam=$P(^DHCPEPreIADM(PreIADMID),"^",3)
	q:OldTeam=TeamID "-1^一个分组里面不需要操作"
	//判断是否允许加入到分组
	s PIBI=$P(^DHCPEPreIADM(PreIADMID),"^",1)
	s ret=##class(web.DHCPE.PreGTeam).IsValidGTeamIADM(PIBI,TeamID,PreIADMID)
	q:ret'="" "-1^"_ret
	s PGTDisChargedMode=$P($G(^DHCPEPreGADM(+TeamID,"Team",$P(TeamID,"||",2))) ,"^",19)
	
	s PreAuditID=##class(web.DHCPE.PreItemList).GetPARowId("G",TeamID,"PRE")
	s ADDAuditID=##class(web.DHCPE.PreItemList).GetPARowId("G",TeamID,"ADD")
	s GADM=+TeamID
	TSTART
	&SQL(Update Sqluser.DHC_PE_PreIADM set PIADM_DisChargedMode=:PGTDisChargedMode,PIADM_PGADM_DR=:GADM,PIADM_PGTeam_DR=:TeamID where PIADM_RowID=:PreIADMID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "-1^更新团体ID失败"
	}
	s OldPETeam=$P(^DHCPEIADM(IADM),"^",4)
	s SQLCODE=##class(web.DHCPE.TransAdmInfo).CheckGAdmCreated(PreIADMID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "-1^"_SQLCODE
	}
	s NewPETeam=$P(^DHCPEIADM(IADM),"^",4)
	s ^DHCPEDateEx("DHCPEPreIADM","SelectPreToTeam",PreIADMID)=TeamID_"^"_OldTeam_"^"_NewPETeam_"^"_OldPETeam
	
	s ItemSub=0
	f  s ItemSub=$O(^DHCPEPreIADM(PreIADMID,"ORDITEM",ItemSub)) q:(ItemSub="")||(SQLCODE'=0)  d
	.s Stat=$P($g(^DHCPEPreIADM(PreIADMID,"ORDITEM",ItemSub)),"^",16)
	.;q:Stat'="1"
	.s OrdEndID=$P($G(^DHCPEPreIADM(PreIADMID,"ORDITEM",ItemSub)),"^",2)
	.;q:OrdEndID'="" //IMedical8.5 套餐费用表已不存数据,项目和套餐的费用都存在
	.s FeeSub=0
	.f  s FeeSub=$O(^DHCPEPreIADM(PreIADMID,"ORDITEM",ItemSub,"FEE",FeeSub)) q:(FeeSub="")||(SQLCODE'=0)  d
	..s AuditID=$P($g(^DHCPEPreIADM(PreIADMID,"ORDITEM",ItemSub,"FEE",FeeSub)),"^",5)
	..q:AuditID=""
	..s UseFlag=$P($g(^DHCPEPreA(AuditID)),"^",21)
	..q:UseFlag="NU"
	..s ChargedStatus=$P(^DHCPEPreA(AuditID),"^",14)
	..q:ChargedStatus="CHARGED"
	..s Type=$P($g(^DHCPEPreA(AuditID)),"^",1)
	..q:(OldGADM'="")&&(Type="I") ;团体里面的人，同时费用是自己付的
	..s AddPre=$P($g(^DHCPEPreA(AuditID)),"^",20)
	..s FeeID=PreIADMID_"||"_ItemSub_"||"_FeeSub
	..i AddPre="PRE" d
	...&SQL(Update Sqluser.DHC_PE_PreIOrdItemFee set PIOIF_PAudit_DR=:PreAuditID where PIOIF_RowId=:FeeID)
	..e  d
	...&SQL(Update Sqluser.DHC_PE_PreIOrdItemFee set PIOIF_PAudit_DR=:ADDAuditID where PIOIF_RowId=:FeeID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "-1^更新项目费用记录失败"
	}
	s ItemSub=0
	f  s ItemSub=$O(^DHCPEPreIADM(PreIADMID,"ORDENT",ItemSub)) q:(ItemSub="")||(SQLCODE'=0)  d
	.s Stat=$P($g(^DHCPEPreIADM(PreIADMID,"ORDENT",ItemSub)),"^",9)
	.;q:Stat'="1"
	.s FeeSub=0
	.f  s FeeSub=$O(^DHCPEPreIADM(PreIADMID,"ORDENT",ItemSub,"FEE",FeeSub)) q:(FeeSub="")||(SQLCODE'=0)  d
	..s AuditID=$P(^DHCPEPreIADM(PreIADMID,"ORDENT",ItemSub,"FEE",FeeSub),"^",5)
	..q:AuditID=""
	..s UseFlag=$P(^DHCPEPreA(AuditID),"^",21)
	..q:UseFlag="NU"
	..s ChargedStatus=$P(^DHCPEPreA(AuditID),"^",14)
	..q:ChargedStatus="CHARGED"
	..s Type=$P(^DHCPEPreA(AuditID),"^",1)
	..q:(OldGADM'="")&&(Type="I") ;团体里面的人，同时费用是自己付的
	..s AddPre=$P(^DHCPEPreA(AuditID),"^",20)
	..s FeeID=PreIADMID_"||"_ItemSub_"||"_FeeSub
	..i AddPre="PRE" d
	...&SQL(Update Sqluser.DHC_PE_PreIOrdEntFee set PIOEF_PAudit_DR=:PreAuditID where PIOEF_RowId=:FeeID)
	..e  d
	...&SQL(Update Sqluser.DHC_PE_PreIOrdEntFee set PIOEF_PAudit_DR=:ADDAuditID where PIOEF_RowId=:FeeID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "-1^更新套餐费用记录失败"
	}
	d ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(+TeamID)
	d:OldGADM'="" ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(OldGADM)
	s GAsCharged=$P(^DHCPEPreGADM(+TeamID),"^",7)
	s IAsCharged=$P(^DHCPEPreIADM(PreIADMID),"^",9)
	i GAsCharged'=IAsCharged d
	.d ##class(web.DHCPE.PreGADM).UpdateAsCharged(PreIADMID,"I")
	TCOMMIT
	q "0^更新成功"
}

ClassMethod Cancel(PreIADMID)
{
	q:'$D(^DHCPEDateEx("DHCPEPreIADM","SelectPreToTeam",PreIADMID)) "-1^不是选取人员过来的，不允许撤销"
	s TeamInfo=$G(^DHCPEDateEx("DHCPEPreIADM","SelectPreToTeam",PreIADMID))
	;=TeamID_"^"_OldTeam_"^"_NewPETeam_"^"_OldPETeam
	s OldTeam=$P(TeamInfo,"^",2)
	s OldPETeam=$P(TeamInfo,"^",4)
	s TeamID=$P(TeamInfo,"^",1)
 	
	i OldTeam'="" d
	.s PreAuditID=##class(web.DHCPE.PreItemList).GetPARowId("G",OldTeam,"PRE")
	.s ADDAuditID=##class(web.DHCPE.PreItemList).GetPARowId("G",OldTeam,"ADD")
	e  d
	.s PreAuditID=##class(web.DHCPE.PreItemList).GetPARowId("I",PreIADMID,"PRE")
	.s ADDAuditID=##class(web.DHCPE.PreItemList).GetPARowId("I",PreIADMID,"ADD")
	s GADM=""
	s PEGADM=""
	s:OldTeam'="" GADM=+OldTeam
	s:OldPETeam'="" PEGADM=+OldPETeam
 	s IADM=$O(^DHCPEIADM(0,"CRMADM",PreIADMID,0))
	
 	
 	TSTART
	k ^DHCPEDateEx("DHCPEPreIADM","SelectPreToTeam",PreIADMID)
	&SQL(Update Sqluser.DHC_PE_PreIADM set  PIADM_DisChargedMode='ID',PIADM_PGADM_DR=:GADM,PIADM_PGTeam_DR=:OldTeam where PIADM_RowID=:PreIADMID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "-1^更新团体ID失败"
	}
	&SQL(Update Sqluser.DHC_PE_IADM set IADM_GADM_DR=:PEGADM,IADM_GTeam_DR=:OldPETeam where IADM_RowID=:IADM)
	i SQLCODE'=0
	{
		TROLLBACK
		q "-1^更新团体ID失败"
	}
	s ItemSub=0
	f  s ItemSub=$O(^DHCPEPreIADM(PreIADMID,"ORDITEM",ItemSub)) q:(ItemSub="")||(SQLCODE'=0)  d
	.s Stat=$P($g(^DHCPEPreIADM(PreIADMID,"ORDITEM",ItemSub)),"^",16)
	.;q:Stat'="1"
	.s OrdEndID=$P($G(^DHCPEPreIADM(PreIADMID,"ORDITEM",ItemSub)),"^",2)
	.;q:OrdEndID'=""  //IMedical8.5 套餐费用表已不存数据,项目和套餐的费用都存在
	.s FeeSub=0
	.f  s FeeSub=$O(^DHCPEPreIADM(PreIADMID,"ORDITEM",ItemSub,"FEE",FeeSub)) q:(FeeSub="")||(SQLCODE'=0)  d
	..s AuditID=$P($g(^DHCPEPreIADM(PreIADMID,"ORDITEM",ItemSub,"FEE",FeeSub)),"^",5)
	..q:AuditID=""
	..s UseFlag=$P($g(^DHCPEPreA(AuditID)),"^",21)
	..q:UseFlag="NU"
	..s ChargedStatus=$P(^DHCPEPreA(AuditID),"^",14)
	..q:ChargedStatus="CHARGED"
	..s Type=$P($g(^DHCPEPreA(AuditID)),"^",1)
	..;q:(OldGADM'="")&&(Type="I") ;团体里面的人，同时费用是自己付的
	..s AddPre=$P($g(^DHCPEPreA(AuditID)),"^",20)
	..s FeeID=PreIADMID_"||"_ItemSub_"||"_FeeSub
	..i AddPre="PRE" d
	...&SQL(Update Sqluser.DHC_PE_PreIOrdItemFee set PIOIF_PAudit_DR=:PreAuditID where PIOIF_RowId=:FeeID)
	..e  d
	...&SQL(Update Sqluser.DHC_PE_PreIOrdItemFee set PIOIF_PAudit_DR=:ADDAuditID where PIOIF_RowId=:FeeID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "-1^更新项目费用记录失败"
	}
	s ItemSub=0
	f  s ItemSub=$O(^DHCPEPreIADM(PreIADMID,"ORDENT",ItemSub)) q:(ItemSub="")||(SQLCODE'=0)  d
	.s Stat=$P($g(^DHCPEPreIADM(PreIADMID,"ORDENT",ItemSub)),"^",9)
	.;q:Stat'="1"
	.s FeeSub=0
	.f  s FeeSub=$O(^DHCPEPreIADM(PreIADMID,"ORDENT",ItemSub,"FEE",FeeSub)) q:(FeeSub="")||(SQLCODE'=0)  d
	..s AuditID=$P(^DHCPEPreIADM(PreIADMID,"ORDENT",ItemSub,"FEE",FeeSub),"^",5)
	..q:AuditID=""
	..s UseFlag=$P(^DHCPEPreA(AuditID),"^",21)
	..q:UseFlag="NU"
	..s ChargedStatus=$P(^DHCPEPreA(AuditID),"^",14)
	..q:ChargedStatus="CHARGED"
	..s Type=$P(^DHCPEPreA(AuditID),"^",1)
	..;q:(OldGADM'="")&&(Type="I") ;团体里面的人，同时费用是自己付的
	..s AddPre=$P(^DHCPEPreA(AuditID),"^",20)
	..s FeeID=PreIADMID_"||"_ItemSub_"||"_FeeSub
	..i AddPre="PRE" d
	...&SQL(Update Sqluser.DHC_PE_PreIOrdEntFee set PIOEF_PAudit_DR=:PreAuditID where PIOEF_RowId=:FeeID)
	..e  d
	...&SQL(Update Sqluser.DHC_PE_PreIOrdEntFee set PIOEF_PAudit_DR=:ADDAuditID where PIOEF_RowId=:FeeID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "-1^更新套餐费用记录失败"
	}
	d ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(+TeamID)
	d:GADM'="" ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(GADM)
	d ##class(web.DHCPE.PreIADM).UpdatePersonAuditAmount(PreIADMID)
	;s GAsCharged=$P(^DHCPEPreGADM(+TeamID),"^",7)
	;s IAsCharged=$P(^DHCPEPreIADM(PreIADMID),"^",9)
	;i GAsCharged'=IAsCharged d
	;.d ##class(web.DHCPE.PreGADM).UpdateAsCharged(PreIADMID,"I")
	TCOMMIT
	q "0^更新成功"
}

///  搜索登记信息 只适合个人登记患者
///  
///  d ##class(%ResultSet).RunQuery("web.DHCPE.PreIADM","SearchPreIADM","00000023","","","","","","","")
Query SearchPreIADM(RegNo As %String = "", Name As %String = "", TeamID As %String = "", HospID As %String = "") As %Query(ROWSPEC = "TPIADM:%String, TRegNo:%String, TName:%String,TSex:%String,TAge:%String,TVIPLevel:%String,TPreDate:%String,TGroup:%String,TAmount:%String,TStatus:%String,TIDCard:%String,TPACCardType:%String")
{
}

ClassMethod SearchPreIADMExecute(ByRef qHandle As %Binary, RegNo As %String = "", Name As %String = "", TeamID As %String = "", HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	//s Name=##class(web.DHCPE.DHCPECommon).UnEscape(Name)
	if ((""=RegNo)&(""=Name)) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	//If PEDate="" Set PEDate=+$h-100
	s PESystemStartDate=##class(web.DHCPE.Public.Setting).GetPESystemStartDate()
	Set ind=1
	If RegNo'="" d 
	.Set PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	.Quit:PIBI=""
	.Set id=0
	.For  Set id=$o(^DHCPEPreIADM(0,"PIBI",PIBI,id)) Quit:id=""  Do
	..Do GetPIADMInfo
	e  i Name'="" d
	.s Name=$$ALPHAUP^SSUTIL4(Name)
	.s PatNameIndex=$o(^DHCPEPreIBI(0,"Name",Name),-1)
	.f  s PatNameIndex=$o(^DHCPEPreIBI(0,"Name",PatNameIndex)) q:(PatNameIndex="")||(PatNameIndex'[Name)  d
	..s PIBIDR=0
	..f  s PIBIDR=$o(^DHCPEPreIBI(0,"Name",PatNameIndex,PIBIDR)) q:PIBIDR=""  d
	...s id=0
	...f  s id=$o(^DHCPEPreIADM(0,"PIBI",PIBIDR,id)) q:id=""  d
	....Do GetPIADMInfo
	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
GetPIADMInfo
	s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",id)
	s TPIADM=id
	s CurData=$g(^DHCPEPreIADM(id))
	q:$P(CurData,"^",22)<PESystemStartDate
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",id)         
  	q:LocFlag=1  
  	s PIADMVIP = ##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",id)
	s TVIPLevel=$P(PIADMVIP,"^",2)
  	s PIADMPIBIDR=$p(CurData,"^",1)
	s TRegNo=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",1)
	s TIDCard=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",9)       //身份证号     
    
	s TAge="",PACCardDesc=""
	i TRegNo'="" d
	.s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",TRegNo,0))  
    .;s TAge=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId)
    .s TAge=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMIRowId,HospID)
    .S PACCardTypeDR=$P($G(^PAPER(PAPMIRowId,"PAT",3)),"^",7)
	.I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)

	s TSex=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",3)
	i TSex'="" s TSex=$P(^CT("SEX",TSex),"^",2)
	s TName=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",2)
	s TAmount=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(TPIADM)
	s TAmount=$p(TAmount,"^",2)
	s TGroup=$p(CurData,"^",2)
	i TGroup'="" d
	.s TGroup=$p($g(^DHCPEPreGADM(TGroup)),"^",1)
	.s TGroup=$p($g(^DHCPEPreGBI(TGroup)),"^",2)
	s TPreDate=$p(CurData,"^",4)
	s:TPreDate'="" TPreDate=##class(websys.Conversions).DateLogicalToHtml(TPreDate)
	s TStatus=$p(CurData,"^",8)
	s TStatus=##Class(web.DHCPE.PreCommon).TransStatus(TStatus)
	Do FindBuild
	q
	
FindBuild        
	set Data=$lb(TPIADM, TRegNo, TName,TSex,TAge,TVIPLevel, TPreDate, TGroup, TAmount, TStatus,TIDCard,PACCardDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchPreIADMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPreIADMExecute ]
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

ClassMethod SearchPreIADMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPreIADMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 根据预约分组ID查找登记号
ClassMethod GetRegNoByTeamID(TeamID, RegNo)
{
	s PIADMRowId=""
    s flag=0
	f  s PIADMRowId=$o(^DHCPEPreIADM(0,"PGTeam",TeamID,PIADMRowId)) q:(PIADMRowId="")||(flag=1)  d
	.s PIBIDR=$p($g(^DHCPEPreIADM(PIADMRowId)),"^",1)
	.s Status=$p($g(^DHCPEPreIADM(PIADMRowId)),"^",8)
	.q:Status="CANCELPE"
	.s PAPMINo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
	.I RegNo=PAPMINo S flag=1
	q flag
}

Storage Default
{
<Data name="SelectPreInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.SelectPreInfoD</DataLocation>
<DefaultData>SelectPreInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.SelectPreInfoD</IdLocation>
<IndexLocation>^web.DHCPE.SelectPreInfoI</IndexLocation>
<StreamLocation>^web.DHCPE.SelectPreInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
