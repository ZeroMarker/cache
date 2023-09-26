/// 名称:     web.DHCLabPanicResult
/// 描述:     危急报告结果
/// 编写者：  huhm
/// 编写日期: 20120710
Class web.DHCLabPanicResult Extends %RegisteredObject
{

/// Creator：      huhm
/// CreatDate：    20131009
/// Description:： 保存危急值报告
/// Table：        DHC_PanicReport
/// Input：        报告类型:ReportType(1:检验,2病理,3心电,4超声,5内镜,6放射),
///                检查号:ExamNo
///                就诊号:Adm
///                医嘱ID:OEOrdId
///                报告审核信息:ReportInfo(审核日期^审核时间^审核人^审核说明)
///                报告结果:Result
/// Output：       
/// Return：        0:成功,失败:-1^失败原因
/// Others：      ##Class(web.DHCLabPanicResult).Save
ClassMethod Save(ReportType As %String, ExamNo As %String, Adm As %String, OEOrdId As %String, ReportInfo As %String, Result As %String) As %String
{
	s ReportType=$g(ReportType),ExamNo=$g(ExamNo),Adm=$g(Adm),OEOrdId=$g(OEOrdId),ReportInfo=$g(ReportInfo),Result=$g(Result)
	s ADate=$p(ReportInfo,"^",1),ATime=$p(ReportInfo,"^",2),AUser=$p(ReportInfo,"^",3)
	s Comment=$p(ReportInfo,"^",4)
	i '$l(OEOrdId) q "-1^医嘱ID为空"
	i '$l(ExamNo) q "-1^检查号为空"
	i '$l(AUser) q "-1^审核人为空"
	i '$l(Result) q "-1^结果为空"
	s OrdId=$p(OEOrdId,"||",1),OrdSub=$p(OEOrdId,"||",2)
	i '$l(OrdId) q "-1^医嘱ID非法"
	i '$l(OrdSub) q "-1^医嘱ID非法"
	i '$d(^OEORD(OrdId,"I",OrdSub)) q "-1^医嘱ID不存在"
	i '$l(ADate) q "-1^审核日期为空"
	i '$l(ATime) q "-1^审核时间为空"
	s ADate=$zdh(ADate,3),ATime=$zth(ATime,3)	
	k PLIST
	s order=+$o(^DHCPanicReport(ReportType,ExamNo,""),-1)+1
	
	s PLIST(2)=ExamNo
  	s PLIST(3)=order
  	s PLIST(4)=ADate
  	s PLIST(5)=ATime
  	s PLIST(20)=AUser
  	s PLIST(10)=Adm
  	s PLIST(11)=Comment
  	s PLIST(12)="C"
  	s PLIST(17)=ReportType
  	s PLIST(18)=Result
  	s PLIST(19)=OEOrdId
  	b  ;01
  	&SQL(insert into lab.DHC_PanicReport values :PLIST())
  	i SQLCODE q "-1^"_SQLCODE_$s('SQLCODE:"",SQLCODE'=100:" "_$g(%msg)_" "_$g(%mdiag(1)),1:"") 
  	//发送的消息内容^消息动作代码^发送消息的用户Id^病人就诊Id^医嘱Id^接收消息的用户Id^其它信息
  	//d ##class(websys.DHCMessageInterface).Send(Context, ActionTypeCode, FromUserRowId, EpisodeId , OrdItemId , ToUserRowId , OtherInfoJson )	
	s Reportid=$p(%ROWID,"||",2)_"||"_$p(%ROWID,"||",3)
	s Link="criticalvalue.trans.csp?ReportId="_Reportid_"&RepType="_ReportType
	s lk="{""link"":"""_Link_""",""dialogWidth"":""800"",""dialogHeight"":""400""}"
	s ret=##class(websys.DHCMessageInterface).Send("","1000",AUser,Adm,OEOrdId,,lk)
	q SQLCODE
}

/// Creator：      huhm
/// CreatDate：    20120715
/// Description:： 根据检验号查询危急报告结果
/// Table：        DHC_PanicReport,DHC_PanicReportItems
/// Input：        检验号
/// Output：       报告时间,报告用户,说明,项目,结果,异常标记,单位,参考范围,ROWID
/// Return：        
/// Others：        其它说明
Query GetPanicResult(LabEpis As %String) As %Query(ROWSPEC = "ReportTime:%String,ReportUser:%String,Remark:%String,TestItem:%String,Result:%String,Flag:%String,Unit:%String,Ranges:%String,RowId:%String")
{
}

ClassMethod GetPanicResultExecute(ByRef qHandle As %Binary, LabEpis As %String) As %Status
{
 	Set LabEpis=$Get(LabEpis)
 	s ^TMPADM=LabEpis
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	If '$Length(LabEpis) Set qHandle=$lb(0,repid,0)	 Quit $$$OK
	s RType=1
	//
	s ord="" f  s ord=$o(^DHCPanicReport(RType,LabEpis,ord)) q:ord=""  d
	.s RDate=$p(^DHCPanicReport(RType,LabEpis,ord),"\",1)
	.s RTime=$p(^DHCPanicReport(RType,LabEpis,ord),"\",2)
	.s RUser=$p(^DHCPanicReport(RType,LabEpis,ord),"\",3)
	.s ReptTime="",ReptUser=""
	.i $l(RDate),$l(RTime) s ReptTime=$zd(RDate,3)_" "_$zt(RTime)
	.i $l(RUser) s ReptUser=$p(^SSU("SSUSR",1,RUser),"^",2)
	.s tc="" f  s tc=$o(^DHCPanicReport(RType,LabEpis,ord,"TC",tc)) q:tc=""  d
	..s TestItem=$p(^TTAB("TC",tc),"\",1)
	..s Result=$P(^DHCPanicReport(RType,LabEpis,ord,"TC",tc),"\",2)
	..s Flag=$p(^DHCPanicReport(RType,LabEpis,ord,"TC",tc),"\",3)
	..s Unit=$p(^DHCPanicReport(RType,LabEpis,ord,"TC",tc),"\",4)
	..s Ranges=$p(^DHCPanicReport(RType,LabEpis,ord,"TC",tc),"\",5)
	..s RowId=LabEpis_"||"_ord
	..d OutputRow
	//
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
OutputRow
	set Data=$lb(ReptTime,ReptUser,$g(Remark),TestItem,Result,$g(Flag),$g(Unit),$g(Ranges),RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPanicResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPanicResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPanicResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPanicResultExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

}
