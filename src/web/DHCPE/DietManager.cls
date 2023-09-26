Import SQLUser

Class web.DHCPE.DietManager [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCPE.DietManager).IsDietFlag("0000000311^")
ClassMethod IsDietFlag(PREIADM)
{
	
	s PEIADM=""
	if (PREIADM["^") d
	.s RegNo=$P(PREIADM,"^",1)
    .i RegNo'="" d
    ..s IBIID=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
    ..q:IBIID=""
    ..s PreIADM=""
    ..f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",IBIID,PreIADM)) q:(PreIADM="" )  d
    ...s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
    ...q:Status'="ARRIVED"
    ...s TPEADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
    ...s PEIADM=TPEADM 
    e  d
    .s PEIADM=PREIADM
     q:PEIADM="" "NoPerson"
    
	
	s PreIADM=$p(^DHCPEIADM(PEIADM),"^",4)
	S DietFlag=""
	s PGADM=$p($g(^DHCPEPreIADM(PreIADM)),"^",2)
	i PGADM="" s DietFlag=$G(^DHCPEDataEx("DHCPEPreIADM","DietFlag",PreIADM))
	i PGADM'="" s DietFlag=$G(^DHCPEDataEx("DHCPEPreGADM","DietFlag",PGADM))
	q:(DietFlag'="1") "NCanntDiet"
	q:(""'=..IsCanDiet(PEIADM)) "CanntDiet"
	
	s Status=$p(^DHCPEIADM(PEIADM),"^",8)
	q:Status'="ARRIVED" "NoArrived"
	s DietFlag=$p(^DHCPEIADM(PEIADM),"^",17)
	q:DietFlag="Y" "HadDiet"
	q PEIADM
}

/// w ##class(web.DHCPE.DietManager).UpdateDiet(PEIADM,HadFlag)
ClassMethod UpdateDietNew(PREIADM, HadFlag)
{
	
	s PEIADM=""
	if (PREIADM["^") d
	.s RegNo=$P(PREIADM,"^",1)
    .i RegNo'="" d
    ..s IBIID=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
    ..q:IBIID=""
    ..s PreIADM=""
    ..f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",IBIID,PreIADM)) q:(PreIADM="" )  d
    ...s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
    ...q:Status'="ARRIVED"
    ...s TPEADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
    ...s PEIADM=TPEADM 
    e  d
    .s PEIADM=PREIADM
     
     s User=%session.Get("LOGON.USERID")
	s Date=+$H
	s Time=$P($H,",",2)
     s SQLCODE=0
	//如果就就餐一次、不设置Gloal、节省空间
	i HadFlag=0 d
	.&SQL(update DHC_PE_IADM set IADM_Diet='Y',IADM_UpdateUser_DR=:User,IADM_UpdateDate=:Date,IADM_UpdateTime=:Time where IADM_RowId=:PEIADM)
	e  d
	.s Count=+$G(^DHCPEDataEx("DHCPEIADM","Diet",PEIADM))+1
	.s ^DHCPEDataEx("DHCPEIADM","Diet",PEIADM)=Count   //实际就餐次数为Count+1
	.s ^DHCPEDataEx("DHCPEIADM","Diet",PEIADM,Count)=User_"^"_Date_"^"_Time
	q:SQLCODE'=0 "Err"
	q "Success"
}

/// w ##class(web.DHCPE.DietManager).UpdateDiet(PEIADM,HadFlag)
ClassMethod UpdateDiet(PREIADM, HadFlag)
{
	s PEIADM=""
	if (PREIADM["^") d
	.s RegNo=$P(PREIADM,"^",1)
    .i RegNo'="" d
    ..s IBIID=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
    ..q:IBIID=""
    ..s PreIADM=""
    ..f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",IBIID,PreIADM)) q:(PreIADM="" )  d
    ...s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
    ...q:Status'="ARRIVED"
    ...s TPEADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
    ...s PEIADM=TPEADM 
    e  d
    .s PEIADM=PREIADM
      q:PEIADM="" "NoPerson"
    
	s User=%session.Get("LOGON.USERID")
	s Date=+$H
	s Time=$P($H,",",2)
	s PreIADM=$p(^DHCPEIADM(PEIADM),"^",4)
	S DietFlag=""
	s PGADM=$p($g(^DHCPEPreIADM(PreIADM)),"^",2)
	i PGADM="" s DietFlag=$G(^DHCPEDataEx("DHCPEPreIADM","DietFlag",PreIADM))
	i PGADM'="" s DietFlag=$G(^DHCPEDataEx("DHCPEPreGADM","DietFlag",PGADM))
	q:(DietFlag'="1") "NCanntDiet"
	q:(""'=..IsCanDiet(PEIADM)) "CanntDiet"
	s SQLCODE=0
	i HadFlag=0
	{
		s Status=$p(^DHCPEIADM(PEIADM),"^",8)
		q:Status'="ARRIVED" "NoArrived"
		s DietFlag=$p(^DHCPEIADM(PEIADM),"^",17)
		q:DietFlag="Y" "HadDiet"
	}
	//如果就就餐一次、不设置Gloal、节省空间
	i HadFlag=0 d
	.&SQL(update DHC_PE_IADM set IADM_Diet='Y',IADM_UpdateUser_DR=:User,IADM_UpdateDate=:Date,IADM_UpdateTime=:Time where IADM_RowId=:PEIADM)
	e  d
	.s Count=+$G(^DHCPEDataEx("DHCPEIADM","Diet",PEIADM))+1
	.s ^DHCPEDataEx("DHCPEIADM","Diet",PEIADM)=Count   //实际就餐次数为Count+1
	.s ^DHCPEDataEx("DHCPEIADM","Diet",PEIADM,Count)=User_"^"_Date_"^"_Time
	q:SQLCODE'=0 "Err"
	q "Success"
}

ClassMethod CancelDiet(PEIADM, flag, TCount)
{
	s User=%session.Get("LOGON.USERID")
	s Date=+$H
	s Time=$P($H,",",2)
	s SQLCODE=0
	
	i flag=0
	{
		s Status=$p(^DHCPEIADM(PEIADM),"^",8)
		q:Status'="ARRIVED" "NoArrived"
		s Dietflag=$p(^DHCPEIADM(PEIADM),"^",17)
		q:((Dietflag="N")&(TCount<1))||(Dietflag="") "NCancelDiet"
		q:(Dietflag="Y")&(TCount>=1) "CancelDiet"
	}
	I (flag=0)||(flag=1) D
	.i (TCount>1) d
	..s Count=+$G(^DHCPEDataEx("DHCPEIADM","CancelDiet",PEIADM))+1
    ..s ^DHCPEDataEx("DHCPEIADM","CancelDiet",PEIADM)=Count   
    ..s ^DHCPEDataEx("DHCPEIADM","CancelDiet",PEIADM,Count)=User_"^"_Date_"^"_Time
	.i (TCount=1) d
	..&SQL(update DHC_PE_IADM set IADM_Diet='N',IADM_UpdateUser_DR=:User,IADM_UpdateDate=:Date,IADM_UpdateTime=:Time where IADM_RowId=:PEIADM)
	q:SQLCODE'=0 "Err"
	q "Success"
}

/*
/// Description: 获取未执行的餐前项目
/// Debug: w ##class(web.DHCPE.DietManager).IsCanDiet("417")
ClassMethod IsCanDiet(PEIADM)
{
	s PAADM=$p(^DHCPEIADM(PEIADM),"^",1)
	s Flag=0
	s RetStr=""
	s OrdID=$o(^OEORD(0,"Adm",PAADM,0))
	q:OrdID="" Flag
	s sub=0
	f  s sub=$o(^OEORD(OrdID,"I",sub)) q:(sub="")  d
	.s ARCIMID=$p($g(^OEORD(OrdID,"I",sub,1)),"^",2)
	.q:ARCIMID=""
	.s Stat=$p(^OEORD(OrdID,"I",sub,1),"^",13)
	.q:Stat'="1"
	.s SpecNo=$p(^OEORD(OrdID,"I",sub,3),"^",20)
	.q:(SpecNo'="")&&($G(^DHCPETempLabEpisodeNo(SpecNo))'="")
	.s ARCDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ARCIMID)
	.s StationID=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,0))
	.q:StationID=""
	.s StSub=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,StationID,0))
	.s DDietFlag=$p(^DHCPEST(StationID,"O",StSub),"^",2)
	.i DDietFlag="PRE" d
	..s Flag=1
	..s RetStr=RetStr_","_ARCDesc
	i Flag=1 q $p(RetStr,",",2,$l(RetStr,","))_"未检查"
	q ""
}
*/
/// Description: 获取未执行的餐前项目
/// Debug: w ##class(web.DHCPE.DietManager).IsCanDiet("417")
ClassMethod IsCanDiet(PEIADM)
{
	s PAADM=$p($g(^DHCPEIADM(PEIADM)),"^",1)
	q:PAADM="" ""
	s LocID=$p($g(^PAADM(PAADM)),"^",4) //就诊科室ID
	s Flag=0
	s RetStr=""
	s OrdID=$o(^OEORD(0,"Adm",PAADM,0))
	q:OrdID="" Flag
	s sub=0
	f  s sub=$o(^OEORD(OrdID,"I",sub)) q:(sub="")  d
	.s ARCIMID=$p($g(^OEORD(OrdID,"I",sub,1)),"^",2)
	.q:ARCIMID=""
	.s Stat=$p($g(^OEORD(OrdID,"I",sub,1)),"^",13)
	.q:Stat'="1"
	.s SpecNo=$p($g(^OEORD(OrdID,"I",sub,3)),"^",20)
	.;q:(SpecNo'="")&&($G(^DHCPETempLabEpisodeNo(SpecNo))'="")
	.q:(SpecNo'="")&&($G(^DHCPETempLabEpisodeScan(SpecNo))'="")
	.s ARCDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ARCIMID,"A",LocID)
	.s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMID,LocID)
	.q:StatOrderID=""
	.s StationID=$p(StatOrderID,"||",1)
	.q:StationID=""
	.s StatOrderSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderID,0)) 
	.q:StatOrderSetID=""
	.s DDietFlag=$lg($g(^CF.PE.StationOrderSetD(StatOrderSetID)),4) //就餐（站点项目组合界面）
	.i DDietFlag="PRE" d
	..s Flag=1
	..s RetStr=RetStr_","_ARCDesc
	i Flag=1 q $p(RetStr,",",2,$l(RetStr,","))_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpedietmanager.hisui.csp","未检查","","csp")
	q ""
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.DietManager","SearchIADMDiet",8)
Query SearchIADMDiet(BeginDate As %String = "", EndDate As %String = "", GroupID As %String = "", RegNo As %String = "", DietFlag As %String = "", CardNo As %String = "", VIPLevel As %Library.String = "") As %Query(ROWSPEC = "TPEADM:%String, TName:%String, TRegNo:%String, TGroupDesc:%String, TDate:%String, TTime:%String, TCount:%String,TRegDate:%String,TReason:%String,TVIPDesc")
{
}

ClassMethod SearchIADMDietExecute(ByRef qHandle As %Binary, BeginDate As %String = "", EndDate As %String = "", GroupID As %String = "", RegNo As %String = "", DietFlag As %String = "", CardNo As %String = "", VIPLevel As %Library.String = "") As %Status
{
	s ^TMP("DHCPE","SearchIADMDiet")=$lb(BeginDate,EndDate,GroupID,RegNo,DietFlag,CardNo,VIPLevel)
   	k ^DHCPETMPPA("PersonDietStatic","Person","Total")
	Set repid=$I(^CacheTemp)
	s ind=2
 	i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
 	
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
	i EndDate'=""   s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	i (BeginDate="")&&(EndDate="")&&(GroupID="")&&(RegNo="")
	{
		
		s BeginDate=+$H
		s EndDate=+$H
	}
	i BeginDate="" s BeginDate=0
 	i EndDate="" s EndDate=+$H
 	i RegNo'="" d
 	.s IBIID=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
 	.q:IBIID=""
 	.s PreIADM=0
 	.f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",IBIID,PreIADM)) q:PreIADM=""  d
 	..s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
 	..q:Status'="ARRIVED"
 	..s TPEADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
 	..q:TPEADM=""
 	..d GetOneInfo
 	e  i GroupID'=""  d
 	.s TeamID=""
 	.f  s TeamID=$o(^DHCPEIADM(0,"GADM",GroupID,TeamID)) q:TeamID=""  d
 	..s TPEADM=0
 	..f  s TPEADM=$o(^DHCPEIADM(0,"GADM",GroupID,TeamID,TPEADM)) q:TPEADM=""  d
 	...d GetOneInfo
 	e  d
 	.s Date=BeginDate-1
 	.f  s Date=$o(^DHCPEIADM(0,"AdmDateTime",Date)) q:(Date>EndDate)||(Date="")  d
 	..s Time=0
 	..f  s Time=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:(Time="")  d
 	...s TPEADM=0
 	...f  s TPEADM=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time,TPEADM)) q:(TPEADM="")  d
 	....d GetOneInfo
 	
 	
 	s ind=1
 	s vipid="",totaldesc=""
 	f  s vipid=$o(^DHCPETMPPA("PersonDietStatic","Person","Total",vipid)) q:vipid=""  d
 	.s vipdesc="",vippernum=""
 	.;s vipdesc=$P($G(^DHCPEVIPLevel("VIP",vipid)),"^",2)
 	.s vipdesc=$lg($g(^CT.PE.VIPLevelD(vipid)),3) 
 	.s vipdesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",vipdesc,"VLDesc","cls")
 	.s vippernum=$G(^DHCPETMPPA("PersonDietStatic","Person","Total",vipid))
 	.i totaldesc="" d
 	..s totaldesc="其中 "_vipdesc_"共"_vippernum_"人 "
 	..s totaldesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpedietmanager.hisui.csp","其中 ","","csp")_vipdesc_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpedietmanager.hisui.csp","共","","csp")_vippernum_"人 "
 	.e  d
 	..s totaldesc=totaldesc_vipdesc_"共"_vippernum_"人"
 	..s totaldesc=totaldesc_vipdesc_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpedietmanager.hisui.csp","共","","csp")_vippernum_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpedietmanager.hisui.csp","人","","csp")
 	
 	
 	s TRegNo="合计:"
 	s TRegNo=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpedietmanager.hisui.csp","合计:","","csp")
	s TName="共"_(+$G(^DHCPETMPPA("PersonDietStatic","Person","Total")))_"人 "_totaldesc
	s TName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpedietmanager.hisui.csp","共","","csp")_(+$G(^DHCPETMPPA("PersonDietStatic","Person","Total")))_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpedietmanager.hisui.csp","人","","csp")_totaldesc
	s TPEADM="",TGroupDesc="",TDate="", TTime="", TCount="",TRegDate="",TReason=""
	d Build
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOneInfo
	d Reset
	
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",TPEADM)        //Add by 090702
  	q:LocFlag=1
	s Status=$p(^DHCPEIADM(TPEADM),"^",8)
	q:Status'="ARRIVED"
	s TDiet=$p(^DHCPEIADM(TPEADM),"^",17)
	
	//q:(TDiet'="")&(DietFlag="N")
	//Q:(TDiet="")&(DietFlag="Y")
	q:((TDiet="N")||(TDiet=""))&(DietFlag="Y")
	Q:(TDiet="Y")&(DietFlag'="Y")

	s TGroupID=$p(^DHCPEIADM(TPEADM),"^",2)
	q:((GroupID'="")&&(TGroupID'=GroupID))
	s TRegDate=$p(^DHCPEIADM(TPEADM),"^",5)
	q:(TRegDate<BeginDate)||(TRegDate>EndDate)
	s TRegDate=##class(websys.Conversions).DateLogicalToHtml(TRegDate)
	s TDate=$p(^DHCPEIADM(TPEADM),"^",20)
	s TTime=$p(^DHCPEIADM(TPEADM),"^",21)
	s PreIADMDR=$p(^DHCPEIADM(TPEADM),"^",4)
	q:"1"'=##class(web.DHCPE.PreIADM).GetDietFlagByID(PreIADMDR)
	s PreIADMVip=$P($G(^DHCPEPreIADM(PreIADMDR)),"^",18)
	q:(VIPLevel'="")&(VIPLevel'=PreIADMVip)
	s VIPDesc=$lg($g(^CT.PE.VIPLevelD(PreIADMVip)),3) 
	s PIBIDR=$p(^DHCPEPreIADM(PreIADMDR),"^",1)
	s TRegNo=$p(^DHCPEPreIBI(PIBIDR),"^",1)
	q:((RegNo'="")&&(RegNo'=TRegNo))
	s TName=$p(^DHCPEPreIBI(PIBIDR),"^",2)
	s TGroupDesc=##Class(web.DHCPE.DHCPEGAdm).GetGAdmDesc(TGroupID)
	/*
	i TDate'="" s TDate=##class(websys.Conversions).DateLogicalToHtml(TDate)
	i TTime'="" s TTime=##class(websys.Conversions).TimeLogicalToHtml(TTime)
	i TDate'="" s TCount=$G(^DHCPEDataEx("DHCPEIADM","Diet",TPEADM))+1
	i TDate="" s TReason=..IsCanDiet(TPEADM)
	*/
		
	i TDiet="Y" s TCount=$G(^DHCPEDataEx("DHCPEIADM","Diet",TPEADM))+1-$g(^DHCPEDataEx("DHCPEIADM","CancelDiet",TPEADM))
	i TDiet="N" s TCount=$G(^DHCPEDataEx("DHCPEIADM","Diet",TPEADM))-$g(^DHCPEDataEx("DHCPEIADM","CancelDiet",TPEADM))
	i TDate="" s TReason=..IsCanDiet(TPEADM)
	i (TCount>=1)&(TDate'="") s TDate=##class(websys.Conversions).DateLogicalToHtml(TDate)
	i (TCount>=1)&(TTime'="") s TTime=##class(websys.Conversions).TimeLogicalToHtml(TTime)
	i (TCount="0")&(TDate'="") s TDate=""
	i (TCount="0")&(TTime'="") s TTime=""
	i (TCount="0") s TCount=""
    i (TCount="") s TDate=""
	d Build
	q

Reset
	s (TName, TRegNo, TGroupDesc, TDate, TTime, TCount,TRegDate,TReason,VIPDesc)=""
	q 
     
	
Build
    
    s VIPDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",VIPDesc,"VLDesc","cls") //翻译VIP
	set Data=$lb(TPEADM, TName, TRegNo, TGroupDesc, TDate, TTime, TCount,TRegDate,TReason,VIPDesc)
	i TPEADM'=0 d
	.s ^DHCPETMPPA("PersonDietStatic","Person","Total")=1+$g(^DHCPETMPPA("PersonDietStatic","Person","Total"))
	.s:$D(PreIADMVip) ^DHCPETMPPA("PersonDietStatic","Person","Total",PreIADMVip)=1+$G(^DHCPETMPPA("PersonDietStatic","Person","Total",PreIADMVip))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchIADMDietFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchIADMDietExecute ]
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

ClassMethod SearchIADMDietClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchIADMDietExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCPE.DietManager).UpdateGift(PEIADM,HadFlag,GiftName)
ClassMethod UpdateGift(PEIADM, HadFlag, GiftName)
{
	s User=%session.Get("LOGON.USERID")
	s Date=+$H
	s Time=$P($H,",",2)
	s SQLCODE=0
	s GiftName=##class(web.DHCPE.Public.Setting).Replace(GiftName,"^",",")
	i HadFlag=0
	{
		s Status=$p(^DHCPEIADM(PEIADM),"^",8)
		q:Status'="ARRIVED" "NoArrived"
		q:$D(^DHCPEDataEx("DHCPEIADM","Gift",PEIADM)) "HadGift"
	}
	s Count=+$G(^DHCPEDataEx("DHCPEIADM","Gift",PEIADM))+1
	s ^DHCPEDataEx("DHCPEIADM","Gift",PEIADM)=Count
	s ^DHCPEDataEx("DHCPEIADM","Gift",PEIADM,Count)=User_"^"_Date_"^"_Time_"^"_GiftName
	q "Success"
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.DietManager","SearchIADMGift",8) //, GiftFlag As %String = ""
Query SearchIADMGift(BeginDate As %String = "", EndDate As %String = "", GroupID As %String = "", RegNo As %String = "", GiftFlag As %String = "", CardNo As %String = "", GiftName As %String = "", VIPLevel As %String = "") As %Query(ROWSPEC = "TPEADM:%String, TName:%String, TRegNo:%String, TGroupDesc:%String, TDate:%String, TTime:%String, TCount:%String,TRegDate:%String,TReason:%String,TVIPDesc")
{
}

ClassMethod SearchIADMGiftExecute(ByRef qHandle As %Binary, BeginDate As %String = "", EndDate As %String = "", GroupID As %String = "", RegNo As %String = "", GiftFlag As %String = "", CardNo As %String = "", GiftName As %String = "", VIPLevel As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	s ind=1
 	
	i (BeginDate="")&&(EndDate="")&&(GroupID="")&&(RegNo="")
	{
		
		s BeginDate=+$H
		s EndDate=+$H
	}
	
	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
 	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	i BeginDate="" s BeginDate=0
 	i EndDate="" s EndDate=+$H
 	i RegNo'="" d
 	.s IBIID=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
 	.q:IBIID=""
 	.s PreIADM=0
 	.f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",IBIID,PreIADM)) q:PreIADM=""  d
 	..s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
 	..q:Status'="ARRIVED"
 	..s TPEADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
 	..q:TPEADM=""
 	..d GetOneGiftInfo
 	e  i GroupID'=""  d
 	.s TeamID=""
 	.f  s TeamID=$o(^DHCPEIADM(0,"GADM",GroupID,TeamID)) q:TeamID=""  d
 	..s TPEADM=0
 	..f  s TPEADM=$o(^DHCPEIADM(0,"GADM",GroupID,TeamID,TPEADM)) q:TPEADM=""  d
 	...d GetOneGiftInfo
 	e  d
 	.s Date=BeginDate-1
 	.f  s Date=$o(^DHCPEIADM(0,"AdmDateTime",Date)) q:(Date>EndDate)||(Date="")  d
 	..s Time=0
 	..f  s Time=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:(Time="")  d
 	...s TPEADM=0
 	...f  s TPEADM=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time,TPEADM)) q:(TPEADM="")  d
 	....d GetOneGiftInfo
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOneGiftInfo
	d GiftReset
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",TPEADM)        //Add by 090702
  	q:LocFlag=1
	s Status=$p(^DHCPEIADM(TPEADM),"^",8)
	q:Status'="ARRIVED"
	s TGift=$D(^DHCPEDataEx("DHCPEIADM","Gift",TPEADM))
	i TGift>0 s TGift=1
	q:+GiftFlag'=(+TGift)
	s TGroupID=$p(^DHCPEIADM(TPEADM),"^",2)
	q:((GroupID'="")&&(TGroupID'=GroupID))
	s TRegDate=$p(^DHCPEIADM(TPEADM),"^",5)
	q:(TRegDate<BeginDate)||(TRegDate>EndDate)
	s TRegDate=##class(websys.Conversions).DateLogicalToHtml(TRegDate)
	s TDate=$p($G(^DHCPEDataEx("DHCPEIADM","Gift",TPEADM,1)),"^",2)
	s TTime=$p($G(^DHCPEDataEx("DHCPEIADM","Gift",TPEADM,1)),"^",3)
	s PreIADMDR=$p(^DHCPEIADM(TPEADM),"^",4)
	
	s PreIADMVip=$P($G(^DHCPEPreIADM(PreIADMDR)),"^",18)
	q:(VIPLevel'="")&(VIPLevel'=PreIADMVip)
	s VIPDesc=$lg($g(^CT.PE.VIPLevelD(PreIADMVip)),3)
	
	s preGiftFlag=##class(web.DHCPE.PreIADM).GetGiftFlagByID(PreIADMDR)
	if (TGift="1") s preGiftFlag=1
	q:"1"'=preGiftFlag

	//q:"1"'=##class(web.DHCPE.PreIADM).GetGiftFlagByID(PreIADMDR)
	
	s PIBIDR=$p(^DHCPEPreIADM(PreIADMDR),"^",1)
	s TRegNo=$p(^DHCPEPreIBI(PIBIDR),"^",1)
	q:((RegNo'="")&&(RegNo'=TRegNo))
	s TName=$p(^DHCPEPreIBI(PIBIDR),"^",2)
	s TGroupDesc=##Class(web.DHCPE.DHCPEGAdm).GetGAdmDesc(TGroupID)
	i TDate'="" s TDate=##class(websys.Conversions).DateLogicalToHtml(TDate)
	i TTime'="" s TTime=##class(websys.Conversions).TimeLogicalToHtml(TTime)
	i TDate'="" s TCount=$G(^DHCPEDataEx("DHCPEIADM","Gift",TPEADM))
	s TReason=..GetGiftName(TPEADM)
	i TReason'="" s TReason=","_TReason_","
	q:(TReason'[GiftName)&&(GiftFlag=1)
	d GiftBuild
	q

GiftReset
	s (TName, TRegNo, TGroupDesc, TDate, TTime, TCount,TRegDate,TReason,VIPDesc)=""
	q 
GiftBuild
    s VIPDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",VIPDesc,"VLDesc","cls")
	set Data=$lb(TPEADM, TName, TRegNo, TGroupDesc, TDate, TTime, TCount,TRegDate,TReason,VIPDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchIADMGiftFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchIADMGiftExecute ]
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

ClassMethod SearchIADMGiftClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchIADMGiftExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetGiftName(TPEIADM)
{
	n (TPEIADM)
	s GiftName=""
	s Count=0
	f  s Count=$o(^DHCPEDataEx("DHCPEIADM","Gift",TPEIADM,Count)) q:Count=""  d
	.s OneName=$p($G(^DHCPEDataEx("DHCPEIADM","Gift",TPEIADM,Count)),"^",4)
	.i GiftName="" d
	..s GiftName=OneName
	.e  d
	..s GiftName=GiftName_","_OneName
	q GiftName
}

ClassMethod OutDietFlag(ContrlWidth As %String = "", DefaultValue As %String = "")
{
	s:(""=ContrlWidth) ContrlWidth="80"
	//下拉列表
	w "<select name='DietFlag' id='DietFlag' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	s selected=""
	s:DefaultValue="" selected="selected"
	w "<option value='' "_selected_">不限</option>",!
	s selected=""
	s:DefaultValue="1" selected="selected"
	w "<option value='1' "_selected_">有</option>",!
	s selected=""
	s:DefaultValue="0" selected="selected"
	w "<option value='0' "_selected_">无</option>",!
	w "</select>",!
	Quit $$$OK
}

Storage Default
{
<Data name="DietManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.DietManagerD</DataLocation>
<DefaultData>DietManagerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCP.DietManagerD</IdLocation>
<IndexLocation>^web.DHCP.DietManagerI</IndexLocation>
<StreamLocation>^web.DHCP.DietManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
