Class web.DHCANStat Extends %RegisteredObject
{

/// Creator：      	ck
/// CreatDate：    	2013-02-27
/// Description： 	质量检查:查整点未记录数据，查超最高、最低值。
/// Table：        	DHC_AN_Order,PA_Adm,DHC_ANC_CommonOrd
/// Input：        	startDate开始日期，endDate结束日期，opaId手术排班表ID,EpisodeID就诊号;ctlocId:科室ID;
/// 				
/// Output：        科室,床位名,病区名,登记号,病人姓名,日期,时间,项目,状态,opaId手术排班表ID,EpisodeID
/// Return：       	返回0正常，否则提示出错信息。(相同状态不插入)
/// d ##class(%ResultSet).RunQuery("web.DHCANStat","CheckAnData","62590","62595",5,"","")
Query CheckAnData(startDate, endDate, opaId, EpisodeID = "", ctlocId = "") As %Query(ROWSPEC = "tlocdes,tbedCode,tWardDes,tRegNo,tPatName,tDate,tTime,tCheckDesc,tCheckStatus,opaId,EpisodeID")
{
}

ClassMethod CheckAnDataExecute(ByRef qHandle As %Binary, startDate, endDate, opaId, EpisodeID = "", ctlocId = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	q:opaId="" "-1"
	s startDate=##class(web.DHCANOPCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCANOPCom).ConvertToDateH(endDate)
	
	s ancoCode=0,maxMinAncoIdList=""
	f  s ancoCode=$o(^DHCANC("ComOrd",0,"TypeCode","V",ancoCode)) q:ancoCode=""  d
		.s ancoId=$o(^DHCANC("ComOrd",0,"TypeCode","V",ancoCode,""))
		.q:ancoId=""
		.q:ancoId>5000
		.q:+$p($g(^DHCANC("ComOrd",ancoId)),"^",19)=0
		.q:$p($g(^DHCANC("ComOrd",ancoId)),"^",20)=""
		.s maxMinAncoIdList(ancoId,"Max")=$p($g(^DHCANC("ComOrd",ancoId)),"^",19)
		.s maxMinAncoIdList(ancoId,"Min")=$p($g(^DHCANC("ComOrd",ancoId)),"^",20)
		.s ^tempck(ancoId,"Max")=$p($g(^DHCANC("ComOrd",ancoId)),"^",19)
	
	i EpisodeID="" s EpisodeID=$p(^DHCANOPArrange(opaId),"^",1)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s tRegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s tPatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s tInPatNo=$p($g(^PAADM(EpisodeID)),"^",29)
	s tbedCode="",tWardDes=""
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
	i curWardId'="" s tWardDes=$P(^PAWARD(curWardId),"^",1)
	i (bedSub'="")&(curWardId'="") s tbedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	s admLocId=$p($g(^PAADM(EpisodeID)),"^",4)
	q:admLocId="" "-2"
	s tlocdes=$P($g(^CTLOC(admLocId)),"^",2)
	
	s anodr=""  f  s anodr=$o(^DHCANOrder(0,"OPApp",opaId,anodr)) q:anodr=""  d
	.s anoType=$p(^DHCANOrder(anodr),"^",30)
	.q:anoType'="V"
	.s anoEditFlag=$p(^DHCANOrder(anodr),"^",25)
	.q:(anoEditFlag'="N")&(anoEditFlag'="E")
	.s anoStartDate=$p(^DHCANOrder(anodr),"^",5)
	.s anoStartTime=$p(^DHCANOrder(anodr),"^",6)
	.q:(anoStartDate<startDate)&(anoStartDate>endDate)
	.s anoQty=$p(^DHCANOrder(anodr),"^",11)
	.q:anoQty=""
	.s tCheckStatus=""
	.s ancorddr=$p(^DHCANOrder(anodr),"^",2)
	.i (+$g(maxMinAncoIdList(ancorddr,"Max"))'=0)&(anoQty>$g(maxMinAncoIdList(ancorddr,"Max"))) s tCheckStatus="超最高值,"_anoQty_",正常最大值,"_$g(maxMinAncoIdList(ancorddr,"Max"))
	.i (+$g(maxMinAncoIdList(ancorddr,"Min"))'=0)&(anoQty<$g(maxMinAncoIdList(ancorddr,"Min"))) s tCheckStatus="超最低值,"_anoQty_",正常最小值,"_$g(maxMinAncoIdList(ancorddr,"Min"))
	.;i anoQty>190 s tCheckStatus="超最高值,"_anoQty
	.;i anoQty<60 s tCheckStatus="超最低值,"_anoQty
	.q:tCheckStatus=""
	.s tCheckDesc=$p($g(^DHCANC("ComOrd",ancorddr)),"^",2)
	.s tDate=$zd(anoStartDate,4)
	.s tTime=$zt(anoStartTime,2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(tlocdes,tbedCode,tWardDes,tRegNo,tPatName,tDate,tTime,tCheckDesc,tCheckStatus,opaId,EpisodeID) 
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CheckAnDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckAnDataExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod CheckAnDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckAnDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
