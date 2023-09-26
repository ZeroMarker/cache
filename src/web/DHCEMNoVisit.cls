/// Descript:   未就诊统计（分级后未下诊断）
/// Creator:    huaxiaoying
/// CreateDate: 2017-07-17
Class web.DHCEMNoVisit Extends %RegisteredObject
{

ClassMethod noVisitQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = noVisitQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 预检分级未就诊统计
ClassMethod noVisitQueryExecute(ByRef qHandle As %Binary, stDate, edDate, HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMNoVisit","noVisitQuery","2017-06-06","2017-08-01")
	;d ##class(%ResultSet).RunQuery("web.DHCEMNoVisit","noVisitQuery","","")
	
    Set repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    set ind=1
  	//编码开始
  	;s:stDate="" stDate=+$h
  	;s:edDate="" edDate=+$h
  	s stDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(stDate)
  	s edDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(edDate)
  	
    s PCLRowID=0  f  s PCLRowID=$o(^DHCEMPCL(PCLRowID))  q:PCLRowID=""  d
    .q:stDate=""
    .q:edDate="" 
    .s PatLocID=$p(^DHCEMPCL(PCLRowID),"^",10) //hxy 2020-06-11 st
    .s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	.q:CurHospID'=HOSPID //ed
    .s PatientID=$p(^DHCEMPCL(PCLRowID),"^",1)      /// 病人ID
    .s PCLCreatorDr=$p(^DHCEMPCL(PCLRowID),"^",3)   ///分诊护士
    .s PCLCreateDate=$p(^DHCEMPCL(PCLRowID),"^",4)  ///分诊日期
    .s CreateDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(PCLCreateDate)
    .q:(stDate'="")&(PCLCreateDate'="")&(CreateDate<stDate) ;小于开始退出
    .q:(edDate'="")&(PCLCreateDate'="")&(CreateDate>edDate) ;大于结束退出
    .s PCLCreateTime=$p(^DHCEMPCL(PCLRowID),"^",5)  ///分诊时间
    .q:'$d(^PAPER(PatientID,"PAT",1))
    .s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	///病人登记号
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    ///病人姓名
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 性别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByPatCheckLevID(PCLRowID)  /// 年龄
	.s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)   /// 出生日期
	.i birthday'="" s birthday=##class(web.DHCEMCommonUtil).DateLogicalToHtml(birthday) 
	.s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	 /// 电话
	.;s CardNoID=..GetPatCardNoID(PatientID)  		     /// 病人卡号ID
	.s PCLNurseLevel=$p(^DHCEMPCL(PCLRowID),"^",7)   /// 护士分级
	.s PCLNurseLevel=##class(web.DHCEMCommonUtil).LevFormat(PCLNurseLevel) //hxy 2020-02-28
	.;s PCLArea=$p(^DHCEMPCL(PCLRowID),"^",9)      /// 去向分区
	.;s PCLSignDr=$p(^DHCEMPCL(PCLRowID),"^",23) ///生命体征
	.s PCLSymDesc=$p(^DHCEMPCL(PCLRowID),"^",25) ///症状描述
    .s PCLSymDesc=##Class(web.DHCEMECheck).GetSymDesc(PCLRowID) ;##class(web.DHCEMRegister).TrNumto(PCLSymDesc,"") 
    .;s PCLSymDesc=$tr(PCLSymDesc,"!","")
    .;s PCLSymDesc=$tr(PCLSymDesc,"#",",")
    .s PCLOther=$p(^DHCEMPCL(PCLRowID),"^",36)      ///其他 
    .s PCLSymDesc=PCLSymDesc_" "_PCLOther           ///症状描述+其他
    .s PCSRowID="",PCSTemp="",PCSHeart="",PCSPCSPulse="",PCSBP="",PCSSoP2="" ///生命体征 st
	.s PCSRowID=$o(^DHCEMPCS(0,"PatCheckLev",PCLRowID,PCSRowID)) 
	.s PCSTemp=$p(^DHCEMPCS(PCSRowID),"^",3)        ///体温T 
 	.s PCSHeart=$p(^DHCEMPCS(PCSRowID),"^",4)       ///心率HR
 	.s PCSPCSPulse=$p(^DHCEMPCS(PCSRowID),"^",5)    ///脉搏R(实际为P)
 	.s PCSDBP=$p(^DHCEMPCS(PCSRowID),"^",7)         ///舒张压
 	.s PCSSBP=$p(^DHCEMPCS(PCSRowID),"^",6)         ///血压(BP)收缩压
 	.s PCSBP=PCSSBP_"/"_PCSDBP                      ///BP
 	.s PCSSoP2=$p(^DHCEMPCS(PCSRowID),"^",8)        ///血氧饱合度SoP2 
 	.s:(PCSSoP2<1)&&(PCSSoP2>0) PCSSoP2="0"_PCSSoP2
 	.s PCSR = $p(^DHCEMPCS(PCSRowID),"^",9)         ///R
 	.s PcsGLU=$p(^DHCEMPCS(PCSRowID),"^",10) 		///血糖
	.;s PCLLocDr=$p(^DHCEMPCL(PCLRowID),"^",10)   ///分诊科室id
	.;s PCLLocDesc=$p(^CTLOC(PCLLocDr),"^",2)
	.;s EpisodeID=$p(^DHCEMPCL(PCLRowID),"^",37)   ///就诊号 unuse
	.s curmarknostr=##class(web.DHCEMRegister).GetPatCare(PCLRowID)    //号别(科室)串串   
    .s EpisodeID="",PCARowID=""
	.s PCARowID=$o(^DHCEMPCA(0,"PatCheckLev",PCLRowID,PCARowID)) 
	.i PCARowID'="" s EpisodeID=$p($g(^DHCEMPCA(PCARowID)),"^",2) ///就诊号
	.s MedcialStatus=""
	.s MedcialStatus = ##Class(web.DHCADMVisitStat).GetPatCurStat(EpisodeID)
	.q:MedcialStatus'=""
	.;q:+EpisodeID'=0
	.S PatDiag=""
	.;i EpisodeID'="" s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDescForRunQian(EpisodeID) //诊断
	.;q:PatDiag'=""
	.;S WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(EpisodeID)
	.;I WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2) //获取到达
	.;q:WalkStatus="到达"
	.d OutputRow1
    
    //编码结束
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(PatNo,PatName,PatSex,PatAge,PatTelH,PCLSymDesc,PCSTemp,PCSHeart,PCSPCSPulse,PCSBP,PCSSoP2,PCSR,PcsGLU,curmarknostr,PCLNurseLevel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod noVisitQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = noVisitQueryExecute ]
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

Query noVisitQuery(stDate, edDate, HOSPID) As %Query(ROWSPEC = "PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatTelH:%String,PCLSymDesc:%String,PCSTemp:%String,PCSHeart:%String,PCSPCSPulse:%String,PCSBP:%String,PCSSoP2:%String,PCSR:%String,PcsGLU:%String,curmarknostr:%String,PCLNurseLevel:%String") [ SqlProc ]
{
}

}
