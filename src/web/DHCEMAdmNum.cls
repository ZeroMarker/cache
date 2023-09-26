/// Descript:   时间段急诊就诊人次统计
/// Creator:    huaxiaoying
/// CreateDate: 2017-07-19
Class web.DHCEMAdmNum Extends %RegisteredObject
{

Query admNumQuery(stDate, edDate, HOSPID) As %Query(ROWSPEC = "Date:%String,TodayNum:%Integer") [ SqlProc ]
{
}

ClassMethod admNumQueryExecute(ByRef qHandle As %Binary, stDate, edDate, HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMAdmNum","admNumQuery","2015-05-12","2017-06-12")
    Set repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    set ind=1
    i (stDate="")||(edDate="") Quit $$$OK
	
  	//编码开始
  	s stDate= $zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(stDate)
  	s edDate=$zdh(edDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(edDate)
  	
  	;s Num=0
  	f AdmDate=stDate:1:edDate  d 
  	.s AdmRowID="",AdmType="",PatDiag="",TodayNum=0 //该日期个数
  	.f  s AdmRowID=$o(^PAADMi("AdmDateCurr",AdmDate,AdmRowID))  q:AdmRowID=""  d
  	..s AdmType=$p(^PAADM(AdmRowID),"^",2)
  	..q:AdmType'="E"
  	..s PatLocID=$p(^PAADM(AdmRowID),"^",4) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
  	..s Date=$zd(AdmDate,3) ;##class(web.DHCEMCommonUtil).DateLogicalToHtml(AdmDate)
  	..s TodayNum=TodayNum+1
  	..;i AdmRowID'="" s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDescForRunQian(AdmRowID,",") //诊断
  	..;q:PatDiag=""
  	..;s Num=Num+1
	.i TodayNum'=0  d OutputRow1
	.
  
    
    //编码结束
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Date,TodayNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admNumQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admNumQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod admNumQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admNumtQueryExecute ]
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

Query admDetailQuery(Date, HOSPID) As %Query(ROWSPEC = "PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,tel:%String,Address:%String,PCLSymDesc:%String,PCSTemp:%String,PCSHeart:%String,PCSPCSPulse:%String,PCSBP:%String,PCSSoP2:%String,PCSR:%String,PCSGlu:%String,PCLNurseLevel:%String") [ SqlProc ]
{
}

ClassMethod admDetailQueryExecute(ByRef qHandle As %Binary, Date, HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMAdmNum","admDetailQuery","2015-04-11")
	
    Set repid=$I(^CacheTemp)
    set ind=1

  	//编码开始
  	s AdmDate= $zdh(Date,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(Date)
  	s AdmRowID="",PatSex="",PatDiag=""
  	f  s AdmRowID=$o(^PAADMi("AdmDateCurr",AdmDate,AdmRowID))  q:AdmRowID=""  d
  	.q:Date=""
  	.s PAPMIDr=$p(^PAADM(AdmRowID),"^",1)
  	.s AdmType=$p(^PAADM(AdmRowID),"^",2)
  	.q:AdmType'="E"
  	.s PatLocID=$p(^PAADM(AdmRowID),"^",4) //hxy 2020-06-11 st
    .s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	.q:CurHospID'=HOSPID //ed
	.s PatNo=$p($g(^PAPER(PAPMIDr,"PAT",1)),"^",1)	   /// 病人登记号	
	.s PatName=$p(^PAPER(PAPMIDr,"ALL"),"^",1)        /// 病人姓名
	.s sexId=$p(^PAPER(PAPMIDr,"ALL"),"^",7)          /// 性别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(AdmRowID) /// 年龄:根据病人ID
	.s tel=$p(^PAPER(PAPMIDr,"PER",1),"^",11) 	    /// 电话 
	.s Address=$g(^PAPER(PAPMIDr,"PER","ADD",1)) 	    /// 家庭住址
	.;s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PAPMIDr,""),-1)
	.;s:CardNoID'="" PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2) 			 /// 卡号
  	.;i AdmRowID'="" s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDescForRunQian(AdmRowID,",") //诊断
  	.;q:PatDiag=""
  	.s PCLSymDesc="",PCLNurseLevel=""
  	.s PCLRowID="",PCARowID=0
  	.f  s PCARowID=$o(^DHCEMPCA(PCARowID)) q:PCARowID=""  d
  	..s AdmDr=$p(^DHCEMPCA(PCARowID),"^",2)
  	..q:AdmDr'=AdmRowID
  	..s PCLRowID=$p(^DHCEMPCA(PCARowID),"^",1)
  	..Q:PCLRowID=""
  	..s PCLNurseLevel=$p(^DHCEMPCL(PCLRowID),"^",7)   /// 护士分级
  	..s PCLNurseLevel=##class(web.DHCEMCommonUtil).LevFormat(PCLNurseLevel) //hxy 2020-02-27
  	..s PCLSymDesc=$p(^DHCEMPCL(PCLRowID),"^",25) ///症状描述
    ..s PCLSymDesc=##Class(web.DHCEMECheck).GetSymDesc(PCLRowID)
    ..;s PCLSymDesc=$tr(PCLSymDesc,"!","")
    ..;s PCLSymDesc=$tr(PCLSymDesc,"#",",")
    ..s PCLOther=$p(^DHCEMPCL(PCLRowID),"^",36)      ///其他 
    ..s PCLSymDesc=PCLSymDesc_" "_PCLOther           ///症状描述+其他
    ..s PCSRowID="",PCSTemp="",PCSHeart="",PCSPCSPulse="",PCSBP="",PCSSoP2="" ///生命体征 st
	..;s PCSRowID=$o(^DHCEMPCS(0,"PatCheckLev",PCLRowID,PCSRowID)) //hxy 2020-04-08 取最后一次分诊st
	..s PcsID=""
	..f  s PcsID=$o(^DHCEMPCS(0,"PatCheckLev",PCLRowID,PcsID),-1) q:(PcsID="")!(PCSRowID'="")  d
	...s PcsTime=$p(^DHCEMPCS(PcsID),"^",2)
	...;q:PcsTime'="" //分诊无时间，干预保存有时间,有时间退出
	...s PCSRowID=PcsID //ed
	..s PCSTemp=$p(^DHCEMPCS(PCSRowID),"^",3)        ///体温T 
 	..s PCSHeart=$p(^DHCEMPCS(PCSRowID),"^",4)       ///心率HR
 	..s PCSPCSPulse=$p(^DHCEMPCS(PCSRowID),"^",5)    ///脉搏R(实际为P)
 	..s PCSDBP=$p(^DHCEMPCS(PCSRowID),"^",7)         ///舒张压
 	..s PCSSBP=$p(^DHCEMPCS(PCSRowID),"^",6)         ///血压(BP)收缩压
 	..s PCSBP=PCSSBP_"/"_PCSDBP                      ///BP
 	..s PCSSoP2=$p(^DHCEMPCS(PCSRowID),"^",8)        ///血氧饱合度SoP2 
 	..s:(PCSSoP2<1)&&(PCSSoP2>0) PCSSoP2 = "0"_PCSSoP2
 	..s PCSR = $p(^DHCEMPCS(PCSRowID),"^",9)         ///R
 	..s PCSGlu = $p(^DHCEMPCS(PCSRowID),"^",10)         ///R
	.d OutputRow1
	
  
    
    //编码结束
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(PatNo,PatName,PatSex,PatAge,tel,Address,PCLSymDesc,PCSTemp,PCSHeart,PCSPCSPulse,PCSBP,PCSSoP2,PCSR,PCSGlu,PCLNurseLevel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admDetailQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admDetailQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod admDetailQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admDetailtQueryExecute ]
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

}
