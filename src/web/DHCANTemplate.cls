Import SQLUser

Class web.DHCANTemplate Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod SaveTemplate(nodeStr As %String, orderList As %String, userId As %String, locId As %String) As %String
{
	//k ^DHCANTemplate
	s nodeType=$p(nodeStr,"^",1)
	i nodeType="公用" d
	.k ^DHCANTemplate("Public",locId,nodeStr)
	e  d
	.k ^DHCANTemplate("Private",locId,userId,nodeStr)
	s singleOrderNum=$l(orderList,"^")
	s result=""
	f i=1:1:singleOrderNum d
	.s singleOrderPara=$p(orderList,"^",i)
	.i nodeType="公用" d
	..s ^DHCANTemplate("Public",locId,nodeStr,i)=singleOrderPara
	.e  d
	..s ^DHCANTemplate("Private",locId,userId,nodeStr,i)=singleOrderPara
	
	//return 0
	q 0
}

ClassMethod FindTemplateNodes(userId As %String, locId As %String) As %String
{
	s nodeStr="",result=""
	f  s nodeStr=$o(^DHCANTemplate("Public",locId,nodeStr)) q:nodeStr=""  d
	.i result="" d
	..s result=nodeStr
	.e  d
	..s result=result_"*"_nodeStr
	s nodeStr=""
	f  s nodeStr=$o(^DHCANTemplate("Private",locId,userId,nodeStr)) q:nodeStr=""  d
	.i result="" d
	..s result=nodeStr
	.e  d
	..s result=result_"*"_nodeStr
	q result
}

ClassMethod DelTemplateByNode(nodeStr As %String, userId As %String, locId As %String) As %String
{
	s nodeType=$p(nodeStr,"^",1)
	i nodeType="公用" d
	.k ^DHCANTemplate("Public",locId,nodeStr)
	e  i nodeType="私有" d
	.k ^DHCANTemplate("Private",locId,userId,nodeStr)
	q "1"
}

Query FindTemplateByNode(nodeStr As %String, userId As %String, locId As %String) As %Query(ROWSPEC = "RecordItemId,ArcimId,Note,Qty,UomId,Density,InstrId,RecordSubCatId,Flag,DrugMode,Speed,SpeedUnitId,RecordOrderId,Reason,EditFlag,OEOriId,RecvLocId,DocUserId,Volume,Source,OrderType,Qty2,Qty3,SubRecordOrderId,MainRecordOrderId,Abbreviate,AfterMinute,DurationMinute")
{
}

ClassMethod FindTemplateByNodeExecute(ByRef qHandle As %Binary, nodeStr As %String, userId As %String, locId As %String) As %Status
{
	//取开始时间点数据，不取结束时间点数据
	//D ##class(%ResultSet).RunQuery("web.DHCANTemplate","FindTemplateByNode","公用^新节点12",269,42)
	//s ^tmpYpz("queryTime")=$p($h,",",2)
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s nodeType=$p(nodeStr,"^",1)
	i nodeType="公用" d
	.s rowId=""
	.f  s rowId=$o(^DHCANTemplate("Public",locId,nodeStr,rowId)) q:rowId=""  d
	..s record=^DHCANTemplate("Public",locId,nodeStr,rowId)
	..;w record
	..Do getRecord
	..//Do OutputRow
	
	i nodeType="私有" d
	.s rowId=""
	.
	.f  s rowId=$o(^DHCANTemplate("Private",locId,userId,nodeStr,rowId)) q:rowId=""  d
	..s record=^DHCANTemplate("Private",locId,userId,nodeStr,rowId)
	..Do getRecord
	..//Do OutputRow
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

getRecord
	//s Id=$p(record,"^",1)
	//s OpaId=$p(record,"^",2)
	s RecordItemId=$p(record,$c(3),3)
	//b ;;w record
	//s UserId=$p(record,"^",4)
	//s StartDate=$p(record,"^",5)
	//s StartTime=$p(record,"^",6)
	//s EndDate=$p(record,"^",7)
	//s EndTime=$p(record,"^",8)
	s ArcimId=$p(record,$c(3),9)
	s Note=$p(record,$c(3),10)
	s Qty=$p(record,$c(3),11)
	s UomId=$p(record,$c(3),12)
	s Density=$p(record,$c(3),13)
	s InstrId=$p(record,$c(3),15)
	s RecordSubCatId=$p(record,$c(3),16)
	s Flag=$p(record,$c(3),17)
	s DrugMode=$p(record,$c(3),18)
	s Speed=$p(record,$c(3),19)
	s SpeedUnitId=$p(record,$c(3),20)
	//s UpdateDate=$p(record,"^",21)
	//s UpdateTime=$p(record,"^",22)
	s RecordOrderId=$p(record,$c(3),23)
	s Reason=$p(record,$c(3),24)
	s EditFlag=$p(record,$c(3),25)
	s OEOriId=$p(record,$c(3),26)
	s RecvLocId=$p(record,$c(3),27)
	s DocUserId=$p(record,$c(3),28)
	s Volume=$p(record,$c(3),29)
	s Source=$p(record,$c(3),30)
	s OrderType=$p(record,$c(3),31)
	s Qty2=$p(record,$c(3),32)
	s Qty3=$p(record,$c(3),33)
	s SubRecordOrderId=$p(record,$c(3),34)
	s MainRecordOrderId=$p(record,$c(3),35)
	s Abbreviate=$p(record,$c(3),36)
	s AfterMinute=$p(record,$c(3),38)
	s DurationMinute=$p(record,$c(3),39)
	
	//s ParaItemId=$p(record,"^",37)
    
OutputRow
	set Data=$lb(RecordItemId,ArcimId,Note,Qty,UomId,Density,InstrId,RecordSubCatId,Flag,
	DrugMode,Speed,SpeedUnitId,RecordOrderId,Reason,EditFlag,OEOriId,RecvLocId,DocUserId,Volume,
	Source,OrderType,Qty2,Qty3,SubRecordOrderId,MainRecordOrderId,Abbreviate,AfterMinute,DurationMinute)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindTemplateByNodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTemplateByNodeExecute ]
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

ClassMethod FindTemplateByNodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTemplateByNodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindTemplateByNode(node As %String) As %String
{
	s nodeType=$p(nodeStr,"^",1)
	i nodeType="公用" d
	.
	q result
}

}
