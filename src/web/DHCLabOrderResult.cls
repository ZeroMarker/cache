Class web.DHCLabOrderResult Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod QueryOrderResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryOrderResultExecute(ByRef qHandle As %Binary, OrderID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	S ^TMPLABREPORT=OrderID
	If $g(ind)="" Set ind=1
	If '$l(OrderID) Quit 0
	Set TestSetRow=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",35)
	If '$l(TestSetRow) Quit 0
 	Set labno=$Piece(TestSetRow,"||",1)
 	Set ts=$Piece(TestSetRow,"||",2)
 	Set tscnt=$Piece(TestSetRow,"||",3)
 	Set isSen="N"
 	k ^TMP($zn,$j)
 	Set tc="" For  Set tc=$Order(^TEPI(labno,1,ts,tscnt,"DATA",tc)) Quit:tc=""  Do
 	.Set resStr=$Piece(^(tc),"\",1)
 	.Set RecDate=$P(^TEPI(labno,1,ts,tscnt),"\",21)
 	.Set temres=##Class(web.DHCLabTestCode).GetTestCodeResult(labno,tc,resStr,RecDate)
 	.Set tcDesc=$Piece(temres,$Char(2),2)
 	.Set tcSyn=$Piece(temres,$Char(2),7)
 	.Set tcResult=$Piece(temres,$Char(2),3)
 	.Set tcUnit=$Piece(temres,$Char(2),4)
 	.Set tcFlag=$Piece(temres,$Char(2),5)
 	.Set tcRanges=$Piece(temres,$Char(2),6)
 	.Set WarnFlag=$Piece(temres,$Char(2),8)
 	.Set isSen="N"
 	.If $d(^TEPI(labno,1,ts,tscnt,"DATA",tc,"ANT")) Set isSen="Y"
 	.i '$d(^TTAB("TC",tc,1,ts)) q
 	.Set Order1=$p(^TTAB("TC",tc,1,ts),"\",1)
 	.Set LayOrder=$p(^TTAB("TC",tc,1,ts),"\",2)
 	.Set Order=$p(^TTAB("TS",ts,LayOrder,Order1),"\",15)
 	.Set Report=$p(^TTAB("TS",ts,LayOrder,Order1),"\",13)
 	.If Report'="Y" Quit
 	.s ^TMP($zn,$j,"Order",Order)=$lb(tc,tcDesc,tcSyn,tcResult,tcUnit,tcFlag,tcRanges,isSen,WarnFlag)
	
	//排序
	s ord="" f  s ord=$o(^TMP($zn,$j,"Order",ord)) q:ord=""  d
	.s DataStr=^(ord)
	.Do OutPut
	k ^TMP($zn,$j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutPut
	//Set Data =$lb(tc,tcDesc,tcSyn,tcResult,tcUnit,tcFlag,tcRanges,isSen,WarnFlag)
 	Set ^CacheTemp(repid,ind)=DataStr //Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryOrderResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderResultExecute ]
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

ClassMethod SenResult(TSRowId As %String, ByRef AntiLIST As %Library.String) As %String
{
	s AntiLIST(1)="22"
	s AntiLIST(2)="33"
	m AntiLIST=^TMPSEN
}

/// Creator：      huhm
/// CreatDate：    20090514
/// Description:： 根据报告ID得到报告结果
/// Table：        EP_VisitNumber,EP_VisitTestSet,EP_VisitTestSetData
/// Input：        报告ID
/// Output：       项目代码,项目名称,缩写,结果,单位,标志,参考范围
/// Return：         函数返回值的说明
/// Others：        其它说明
Query QueryOrderResult(OrderID As %String) As %Query(ROWSPEC = "TCCode:%String,TCName:%String,TCSyn:%String,Result:%String,TCUnit:%String,ResultFlag:%String,RefRanges:%String,Sensitive:%String,WarnFlag:%String")
{
}

}
