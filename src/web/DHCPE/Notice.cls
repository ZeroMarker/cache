Class web.DHCPE.Notice Extends %Persistent
{

/// Creator：    sunxintao
/// CreatDate：  20210819
/// Description: 体检到期提醒查询
/// Input:       NoticeType:查询类型, Days:天数, CurLoc:科室id , Limits: 范围(0 全部 1 1年内  --- 防止用的时间太长 查询越来越慢)  
/// Debug： d ##class(%ResultSet).RunQuery("web.DHCPE.Notice","Notice","2","0",105,"")
Query Notice(NoticeType As %Library.String = "", Days As %Library.String = "", CurLoc As %Library.String = "", Limits As %Library.String = "") As %Query(ROWSPEC = "TRegNo:%String,TName:%String,DateDesc:%String,PAPMISex:%String,TAge:%String,GADMDRName:%String")
{
}

ClassMethod NoticeExecute(ByRef qHandle As %Binary, NoticeType As %Library.String = "", Days As %Library.String = "", CurLoc As %Library.String = "", Limits As %Library.String = "") As %Status
{
 	s ind=1
   	
   	Set repid=$I(^CacheTemp)
 	if ((""=Days)&&(""=NoticeType)){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	i CurLoc="" s CurLoc=%session.Get("LOGON.CTLOCID")
 	s HospID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(CurLoc)
	s NeedReCheck=$G(^DHCPESetting("DHCPE","MainDoctorGroup",CurLoc))
	s EndDate=+$H-Days
	s:(Limits="") Limits=0
	i Limits=0  s Date=0
	e  s Date=+$H-(365*Limits)
	
	if (NoticeType=1)||(NoticeType=3) d
	.f  s Date=$o(^DHCPEIADM(0,"AdmDateTime",Date)) q:(Date="")||(Date>EndDate)  d
	..s Time=0
	..s DateDesc=##class(websys.Conversions).DateLogicalToHtml(Date)
	..f  s Time=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:(Time="")  d
	...s IADMDR=0
	...f  s IADMDR=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADMDR)) q:(IADMDR="")  d
	....d GetOneInfo
	e  i (NoticeType=2) d
	.f  s Date=$o(^DHCPERPT(0,"PrintDate",Date)) q:(Date="")||(Date>EndDate)  d
	..s Time=""
	..f  s Time=$o(^DHCPERPT(0,"PrintDate",Date,Time)) q:(Time="")  d
	...s RptID=0
	...f  s RptID=$o(^DHCPERPT(0,"PrintDate",Date,Time,RptID)) q:(RptID="")  d
	....s Status=$p(^DHCPERPT(RptID),"^",2)
	....q:(Status="C") // 已完成的
	....s IADMDR=$p(^DHCPERPT(RptID),"^",1)
	....q:(IADMDR="")
	....d GetOneInfo

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetOneInfo
	s Qflag=0
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADMDR,CurLoc)       
  	q:LocFlag=1 
  	s IADMPAADMDR=$p($g(^DHCPEIADM(IADMDR)),"^",1)					
	q:(""=IADMPAADMDR)
	s Status=$p($g(^DHCPEIADM(IADMDR)),"^",8)
	q:Status'="ARRIVED"	
  	s AduitUserDR=$p($g(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",IADMPAADMDR)),"^",1)
	s id=$o(^DHCPERPT(0,"IADM",IADMDR,0))
	q:(NoticeType=3)&&($d(^User.DHCPEWorkDistributionI("TypePAADMIndex","AR",IADMPAADMDR)))
	i (id'="")&&(NoticeType=1) d
	.s RptData=$g(^DHCPERPT(id))
	.s RptStatus=$p(RptData,"^",2)
	.i NeedReCheck'="N" d
	..s:(RptStatus="A") Qflag=1
	.e  d
	..s:(AduitUserDR'="") Qflag=1
	q:(Qflag=1)
	s PAPMIID=$P($g(^PAADM(IADMPAADMDR)),"^",1)
	s TRegNo=$P($g(^PAPER(PAPMIID,"PAT",1)),"^",1)
	s TName=$P($g(^PAPER(PAPMIID,"ALL")),"^",1)
	s GADMDR=$p($g(^DHCPEIADM(IADMDR)),"^",2)
	s GADMDRName=##Class(web.DHCPE.DHCPEGAdm).GetGAdmDesc(GADMDR)
	
	// 性别 
    s PAPMISex=""
    s PAPMISexDR=$p($g(^PAPER(PAPMIID,"ALL")),"^",7)
    i ""'=PAPMISexDR s PAPMISex=$p($g(^CT("SEX",PAPMISexDR)), "^", 2)
    
	//年龄
	s TAge=""
	s TAge=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMIID,HospID,CurLoc)
	
	/***翻译 start***/
	S PAPMISex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",PAPMISex,"CTSEXDesc","cls")
	/***翻译 end***/
	
	s Data=$lb(TRegNo,TName,DateDesc,PAPMISex,TAge,GADMDRName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod NoticeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NoticeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod NoticeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NoticeExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Storage Default
{
<Data name="NoticeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.NoticeD</DataLocation>
<DefaultData>NoticeDefaultData</DefaultData>
<IdLocation>^web.DHCPE.NoticeD</IdLocation>
<IndexLocation>^web.DHCPE.NoticeI</IndexLocation>
<StreamLocation>^web.DHCPE.NoticeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
