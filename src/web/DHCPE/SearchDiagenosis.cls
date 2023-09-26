Class web.DHCPE.SearchDiagenosis Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// creator:wangfujian
/// createDate:2009-03-23
/// description:查询某段时间的所以的检查项目的诊断结论
/// input:登记号，姓名，开始日期，结束日期
/// return:"姓名	paadmRowid  登记号   电话   性别   年龄	 团体信息	诊断信息"
/// test:d ##class(%ResultSet).RunQuery("web.DHCPE.SearchDiagenosis","SearchDiagenosis","00000022","","","")
/// ReWrite by wrz 2009-10-22
Query SearchDiagenosis(RegNo As %String, Name As %String, StartDate As %Date, EndDate As %Date) As %Query(ROWSPEC = "tName:%String,EpisodeID:%String,tRegNo:%String,tTel:%String,tSex:%String,tAge:%String,tGroup:%String,tDiagenosis:%String")
{
}

ClassMethod SearchDiagenosisExecute(ByRef qHandle As %Binary, RegNo As %String, Name As %String, StartDate As %Date, EndDate As %Date) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 s Name=##class(web.DHCPE.DHCPECommon).UnEscape(Name)
 S Name=$$ALPHAUP^SSUTIL4(Name)
 if (RegNo="")&&(Name="")&&(StartDate="")&&(EndDate="")
 {
	 Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
 }
 i StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
 i EndDate'=""   s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 
 if RegNo'=""{
	 s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	 s IBI=0
	 f  s IBI=$O(^DHCPEPreIBI(0,"PAPMINo",RegNo,IBI))  q:IBI=""  d
	 .s PreIADM=0
	 .f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",IBI,PreIADM)) q:PreIADM=""  d
	 ..s PEIADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	 ..q:PEIADM=""
	 ..s Status=$P(^DHCPEIADM(PEIADM),"^",8)
	 ..q:Status'="ARRIVED"
	 ..s PAAdm=$p($G(^DHCPEIADM(PEIADM)),"^",1)
	 ..q:PAAdm=""
	 ..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAAdm)    //Add by 090702
     ..q:LocFlag=1 
	 ..d setData
 }
 elseif Name'=""{
	 s desc=$o(^DHCPEPreIBI(0,"Name",Name),-1)
	 f  s desc=$o(^DHCPEPreIBI(0,"Name",desc)) q:(desc="")||(desc'[Name)  d
	 .s IBI=0
	 .f  s IBI=$o(^DHCPEPreIBI(0,"Name",desc,IBI)) q:IBI=""  d
	 ..s PreIADM=0
	 ..f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",IBI,PreIADM)) q:PreIADM=""  d
	 ...s PEIADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	 ...q:PEIADM=""
	 ...s Status=$P(^DHCPEIADM(PEIADM),"^",8)
	 ...q:Status'="ARRIVED"
	 ...s PAAdm=$p($G(^DHCPEIADM(PEIADM)),"^",1)
	 ...q:PAAdm=""
	 ...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAAdm)    //Add by 090702
     ...q:LocFlag=1
     ...
	 ...d setData
 }
 else{
	 i StartDate="" d
  	 .s StartDate=0
     .//s EndDate=+$h
     i EndDate="" d
     .s EndDate=+$h
     s DeptItem=%session.Get("LOGON.CTLOCID")
     s Date=StartDate-1
     f  s Date=$O(^PAADMi("CurrLoc",DeptItem,Date)) q:(Date="")!(Date>EndDate)  d
	 .s Time=""
	 .f  s Time=$O(^PAADMi("CurrLoc",DeptItem,Date,Time)) q:(Time="")  d
	..Set PAAdm=""
	..f  s PAAdm=$O(^PAADMi("CurrLoc",DeptItem,Date,Time,PAAdm)) q:(PAAdm="")  d
	...s PEIADM=$O(^DHCPEIADM(0,"PAADM",PAAdm,0))
	...q:PEIADM=""
	...s Status=$P(^DHCPEIADM(PEIADM),"^",8)
	...q:Status'="ARRIVED"
	...s PreIADM=$p(^DHCPEIADM(PEIADM),"^",4)
	...q:PreIADM=""
	...s IBI=$p(^DHCPEPreIADM(PreIADM),"^",1)
	...q:IBI=""
	...d setData
 }
 
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK

setData
   d ..TransRisResult(PreIADM,PAAdm) 
   s diagenosis=##class(web.DHCPE.SearchDiagenosis).FindRisDiagenosisByAdmRowid(PAAdm)
   q:diagenosis=""
   s EpisodeID=PAAdm
   S PAPMI=$P($G(^PAADM(PAAdm)),"^",1)
   s tName=$p($G(^DHCPEPreIBI(IBI)),"^",2)
   s tRegNo=$p($G(^DHCPEPreIBI(IBI)),"^",1)
   s tTel=$p($G(^DHCPEPreIBI(IBI)),"^",8)
   i tTel="" s tTel=$p($G(^DHCPEPreIBI(IBI)),"^",7)
   i tTel="" s tTel=$p($G(^DHCPEPreIBI(IBI)),"^",6)
   s tSex=$p($G(^DHCPEPreIBI(IBI)),"^",3)
   i tSex'="" s tSex=$P(^CT("SEX",tSex),"^",2)
   ;s tAge=$p($G(^DHCPEPreIBI(IBI)),"^",4)
   
   s AdmDate=$P($G(^DHCPEIADM(PEIADM)),"^",5)
   s ArrDate=+AdmDate
   i ArrDate=0 s ArrDate=+$H
   ;i tAge'="" s tAge=##class(web.DHCLCNUREXCUTE).CalAge(tAge,ArrDate)
   ;s tAge=$P(tAge,"Y",1)
   s tAge=##class(web.DHCBillInterface).GetPapmiAge(PAPMI,PAAdm)
   s tGroup=$p($G(^DHCPEPreIADM(PreIADM)),"^",2)
   i tGroup'="" s tGroup=##Class(web.DHCPE.PreGTeam).GetGAdmDesc(tGroup)
   s tDiagenosis=diagenosis
   d outData
   q

outData
	//	 	姓名	paadmRowid  登记号   电话   性别   年龄	 团体信息	诊断信息
	//	  tName 	EpisodeID   tRegNo   tTel  tSex    tAge  tGroup     tDiagenosis
 set Data=$lb( tName, EpisodeID,tRegNo, tTel, tSex,tAge,tGroup,tDiagenosis)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 q
}

ClassMethod SearchDiagenosisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchDiagenosisExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 //
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod SearchDiagenosisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchDiagenosisExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod TransRisResult(PreIADM, admId)
{
	q:##class(web.DHCPE.ResultPermission).GetGeneAdviserStatus(admId)="Audited"
	s userId=%session.Get("LOGON.USERID")
	s ItemSub=0
	//TSTART
	f  s ItemSub=$o(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)) q:(ItemSub="")  d
	.s Flag=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)),"^",16)
	.q:Flag'=1
	.s ItemId=PreIADM_"||"_ItemSub
	.s ItemMastId=$p(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub),"^",1)
	.q:..IsRisARCIM(ItemMastId)=0
	.s CrmOrderId=$o(^DHCPECRMO(0,"CRMORI",ItemId,0))
	.q:CrmOrderId=""
	.s ordItmId=$p(^DHCPECRMO(CrmOrderId),"^",1)
	.q:ordItmId=""
	.s RLTRowid=$o(^DHCPERLT(0,"OEORI",ordItmId,0))
	.q:RLTRowid'=""
	.d ##class(web.DHCPE.TransResult).TransARisItem(admId, ordItmId, userId)
}

/// creator:wangfujian
/// createDate:2009-03-23
/// description:判断指定医嘱是否是一个Ris医嘱
/// input:ARCIMRowid为病人就诊表达rowid
/// return:是ris医嘱返回1，不会返回0
/// test:w ##class(web.DHCPE.SearchDiagenosis).IsRisARCIM("17420||1")
ClassMethod IsRisARCIM(ARCIMRowid As %String = "") As %String
{
	s isRis=0
	s StationRowid=""
	f  s StationRowid=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMRowid,StationRowid)) q:StationRowid=""  d
	.;s stationCode=$p(^DHCPEST(StationRowid),"^",1) 
	.s risStations=$G(^DHCPESetting("DHCPE","StationId_Ris"))
	.s risStations="^"_risStations_"^"
	.i risStations[StationRowid d
	..s isRis=1
	q isRis
}

ClassMethod FindRisDiagenosisByAdmRowid(EpisodeID)
{
	q:EpisodeID="" ""
	s Diagenosis=""
	s oeid=""
	f  s oeid=$o(^DHCPERLT(0,"ADMOD",EpisodeID,oeid)) q:oeid=""  d
	.s odid=$o(^DHCPERLT(0,"ADMOD",EpisodeID,oeid,""))
	.q:odid=""
	.s rltid=$o(^DHCPERLT(0,"ADMOD",EpisodeID,oeid,odid,""))
	.q:rltid=""
	.s ARCIMRowid=$p(^DHCPERLT(rltid),"^",2)
	.q:(##class(web.DHCPE.SearchDiagenosis).IsRisARCIM(ARCIMRowid)=0)
	.s result=$p(^DHCPERLT(rltid),"^",4)
	.s result=$p(result,"诊断意见:",2)
	.q:result=""
	.i Diagenosis="" d
	..s Diagenosis=result
	.e  d
	..s Diagenosis=Diagenosis_";"_result
	q Diagenosis
	
	/*
	s ResultRowid=""
	f  s ResultRowid=$o(^DHCPERLT(0,"ADM",EpisodeID,ResultRowid)) q:ResultRowid=""  d
	.//取出医嘱的rowid
	.s ARCIMRowid=$p(^DHCPERLT(ResultRowid),"^",2)
	.q:(##class(web.DHCPE.SearchDiagenosis).IsRisARCIM(ARCIMRowid)=0)
	.s result=$p(^DHCPERLT(ResultRowid),"^",4)
	.s result=$p(result,"诊断意见:",2)
	.q:result=""
	.i Diagenosis="" d
	..s Diagenosis=result
	.e  d
	..s Diagenosis=Diagenosis_";"_result
	q Diagenosis
	*/
}

}
