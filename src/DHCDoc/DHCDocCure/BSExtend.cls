/// CTOR: QP
/// DATE: 2019-12-26
/// DESC: 治疗科室业务扩展类
Class DHCDoc.DHCDocCure.BSExtend Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2019-12-26
/// DESC: 获取打印的元素
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.DHCDocCure.BSExtend).GetPrintData(95,"2019-06-06","2019-06-06")
ClassMethod GetPrintData(LocId As %String, StartDate As %String, EndDate As %String) As %String
{
	n (LocId,StartDate,EndDate)
	
	s LocDesc=$p(^CTLOC(LocId),"^",2)
	i LocDesc["-" s LocDesc=$p(LocDesc,"-",2)
	s LocDesc=LocDesc_"医生治疗申请工作量统计"
	s printObj = ##class(ext.util.JsonObject).%New()
	do printObj.Put("LocDesc",LocDesc)
	do printObj.Put("StartDate",StartDate)
	do printObj.Put("EndDate",EndDate)
	s mRtn = printObj.GetPrintData()
	do printObj.%Close()
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-12-26
/// DESC: 打印列表
/// IN  : 
/// OUT : 
/// TABL: 
/// INDE: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.BSExtend","WorkReport","15132","10296")
Query WorkReport(ProcessNo As %String, USERID As %String) As %Library.Query(ROWSPEC = "FinishUser,ArcimDesc,UnitPrice,OrderQM,OrdPrice")
{
}

ClassMethod WorkReportExecute(ByRef qHandle As %Library.Binary, ProcessNo As %String, USERID As %String) As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s FinishUser="<font style='font-weight:bold;'>开单医师</font>"
	s ArcimDesc="<font style='font-weight:bold;'>治疗项目</font>"
	s UnitPrice="<font style='font-weight:bold;'>单价</font>"
	s OrderQM="<font style='font-weight:bold;'>数量/单位</font>"
	s OrdPrice="<font style='font-weight:bold;'>总金额</font>"
	d OutputRow1
	s num=##class(DHCDoc.DHCDocCure.WordReport).GetQryWorkReportForDocAppNum(ProcessNo,USERID)
	f i=1:1:num {
		s record=##class(DHCDoc.DHCDocCure.WordReport).GetQryWorkReportForDocAppInfo(ProcessNo,i,USERID)
		s FinishUser=$p(record,"^",2)
		s ArcimDesc=$p(record,"^",3)
		s UnitPrice=$p(record,"^",4)
		s OrderQty=$p(record,"^",5)
		s OrdBillUOM=$p(record,"^",6)
		s OrdPrice=$p(record,"^",7)
		i OrdBillUOM'="" s OrdBillUOM="/"_OrdBillUOM
		s OrderQM=OrderQty_OrdBillUOM
		d OutputRow1
	}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow1
	set Data=$lb(FinishUser,ArcimDesc,UnitPrice,OrderQM,OrdPrice)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod WorkReportFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = WorkReportExecute ]
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

ClassMethod WorkReportClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = WorkReportFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
