Class DHCDoc.Interface.Inside.IOT.TreatInfo Extends %RegisteredObject
{

/// 过滤不是治疗的医嘱,项目上自己完成
/// date:2019-09-09
/// desc:互联互通共享文档【2.8.1治疗记录表（DHCENSCDA.User.CDA.C0008Info）】
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.IOT.TreatInfo","GetC0008Info","2019-09-10","2019-09-10","")
/// 过滤不是治疗的医嘱,项目上自己完成
ClassMethod GetC0008InfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Hospital As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	set qHandle = $lb(0,repid,0)
	s StartDate=$ZDH(StartDate,3)
	s EndDate=$ZDH(EndDate,3)
	s (AdmID,DocumentID,HDSD0005016,HDSD0006023,HDSD0006068,HDSD0006137,HDSD00061371,HDSD0006136,HDSD0006041,HDSD0006108,HDSD0006109,HDSD0006110,HDSD0006141,HDSD00061081,HDSD00061101)=""
	for Date=StartDate:1:EndDate {
		s orderParref=""
		for {
			s orderParref=$O(^OEORDi(0,"StDt",Date,orderParref))
			q:orderParref=""
			s orderId = 0 
			for{
				s orderId = $O(^OEORDi(0,"StDt",Date,orderParref,orderId))
				q:orderId=""
				s OEORIRowID=orderParref_"||"_orderId
				s OrdObj=##class(User.OEOrdItem).%OpenId(OEORIRowID,0)
				s ARCIMRowId=OrdObj.OEORIItmMastDR.%Id()
				continue:ARCIMRowId="" 
				s ItemCatRowid=$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)),"^",10)
				continue:ItemCatRowid=""
				s OrderType=""
				s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
				s OrdCat=$p(^ARC("IC",ItemCatRowid),"^",8)
				/*
				====过滤不是治疗的医嘱,项目上自己完成
				====可按大类(OrdCat)或子类(ItemCatRowid)过滤数据
				*/
				s AdmID=$P(^OEORD(orderParref),"^",1) ///就诊ID号	AdmID
				s DocumentID=orderParref_"||"_orderId  ///文档唯一编号	DocumentID
				s HDSD0005016=orderParref_"||"_orderId  ///医嘱号(电子申请单号)
				///处理及指导意见	HDSD0006023
				s HDSD0003047=$Zd($P(OrdObj.OEORIDateTime,",",1))_" "  _$Zt($P(OrdObj.OEORIDateTime,",",2)) ///签名日期时间
				s OEORIUserExecuted=OrdObj.OEORIUserExecuted
				if $ISOBJECT(OEORIUserExecuted){
					s OEORIUserExecuted=OrdObj.OEORIUserExecuted.%Id()
					s UserObj=##class(User.SSUser).%OpenId(OEORIUserExecuted,0)
					if $ISOBJECT(UserObj) {
						s HDSD0006137=UserObj.SSUSRInitials ///医嘱执行者代码
						s HDSD00061371=UserObj.SSUSRName ///医嘱执行者签名
					   do UserObj.%Close()
					}
				}
				s ExecDr=0
				for {
					s ExecDr=$O(^OEORD(orderParref,"I",orderId,"X",ExecDr))
					q:(ExecDr="")
					s ExStDate= $p(^OEORD(orderParref,"I",orderId,"X",ExecDr),"^",1)
					s ExStTime= $p(^OEORD(orderParref,"I",orderId,"X",ExecDr),"^",2)
					s ExecStateDR= $p(^OEORD(orderParref,"I",orderId,"X",ExecDr),"^",16)
					s execStatus=""
					i +ExecStateDR>0 s execStatus = $p(^OEC("STAT",ExecStateDR),"^",1)
					s CTPCPDR=$P(^OEORD(orderParref,"I",orderId,"X",ExecDr),"^",15)
					if (execStatus="F")&&(HDSD0006137="")&&(CTPCPDR'=""){
						s UserID=$O(^SSU("SSUSR",0,"CTPCP",CTPCPDR,0))
						s HDSD0006137=$P(^SSU("SSUSR",UserID),"^",1) ///医嘱执行者代码
						s HDSD00061371=$P(^SSU("SSUSR",UserID),"^",2) ///医嘱执行者签名
					}
				}
				
				
				
				s HDSD0006136=""  //医嘱使用备注
				if (OrdObj.OEORIDepProcNotes.Count())>0{
					s HDSD0006136=OrdObj.OEORIDepProcNotes.GetAt(OrdObj.OEORIDepProcNotes.Count())
				}
				
				s HDSD0006041="" //今后治疗方案	HDSD0006041
				///随访方式代码	HDSD0006108
				///随访日期	HDSD0006109
				///随访周期建议代码	HDSD0006110
				///有创诊疗操作标志	HDSD0006141
				///随访方式描述	HDSD00061081
				///随访周期建议描述	HDSD00061101
				d OutputRow1
				}
			}
		}


	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(AdmID,DocumentID,HDSD0005016,HDSD0006023,HDSD0006068,HDSD0006137,HDSD00061371,HDSD0006136,HDSD0006041,HDSD0006108,HDSD0006109,HDSD0006110,HDSD0006141,HDSD00061081,HDSD00061101)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetC0008InfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetC0008InfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
       Set AtEnd=1
	   Set Row=""
    }Else{Set Row=^CacheTemp(repid,ind)}
    s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetC0008InfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetC0008InfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetC0008Info(StartDate As %String, EndDate As %String, Hospital As %String) As %Query(ROWSPEC = "AdmID,DocumentID,HDSD0005016,HDSD0006023,HDSD0006068,HDSD0006137,HDSD00061371,HDSD0006136,HDSD0006041,HDSD0006108,HDSD0006109,HDSD0006110,HDSD0006141,HDSD00061081,HDSD00061101")
{
}

}
