Class EPRservice.HISInterface.OrderInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	取输血医嘱对应的输血量  红细胞、血小板、血浆、全血、其他等（换算为收费项后的单位）
/// Debug:	w ##Class(EPRservice.HISInterface.OrderInfo).GetTarItemAmount(EpisodeID,OrdItems,OrdItemStatus)
ClassMethod GetTarItemAmount(EpisodeID As %String, OrdItems As %String, OrdItemStatus As %String) As %String
{
	s Amount = 0
	
	q:(EpisodeID="")||(OrdItems="")||(OrdItemStatus="") Amount
	
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.HISInterface.OrderInfo:QueryOrderItem")
	d ds.Execute(EpisodeID,OrdItems,OrdItemStatus)
	while(ds.Next())
	{
		s OeordItemID = ds.Data("OeordItemID")
		s OeordID = +$p(OeordItemID,"||",1)
		s ChildSub = +$p(OeordItemID,"||",2)
		continue:(OeordID="")||(ChildSub="")
		
		s OeoriItmMastID = $p($g(^OEORD(OeordID,"I",ChildSub,1)),"^",2)
		
		//收费项
		s TarItemID = $O(^DHCOLT(0,"ARTTA",OeordItemID,""))
		continue:(TarItemID="")
		
		//换算为收费项单位后的数量
		s PhQtyOrd = $p($g(^OEORD(OeordID,"I",ChildSub,1)),"^",12)
		s TarUOM = $p($g(^DHCTARI(tarItemID)),"^",3)
		s TmpAmount = (+PhQtyOrd) * (+TarUOM)
		
		s Amount = Amount + TmpAmount
	}
	d ds.Close()
	q Amount
}

/// Desc:	取输血医嘱对应的输血量  红细胞、血小板、血浆、全血、其他等
/// Debug:	w ##Class(EPRservice.HISInterface.OrderInfo).GetOrderItemAmount(EpisodeID,OrdItems,OrdItemStatus)
ClassMethod GetOrderItemAmount(EpisodeID As %String, OrdItems As %String, OrdItemStatus As %String) As %String
{
	s Amount = 0
	
	q:(EpisodeID="")||(OrdItems="")||(OrdItemStatus="") Amount
	
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.HISInterface.OrderInfo:QueryOrderItem")
	d ds.Execute(EpisodeID,OrdItems,OrdItemStatus)
	while(ds.Next())
	{
		s OeordItemID = ds.Data("OeordItemID")
		s OeordID = +$p(OeordItemID,"||",1)
		s ChildSub = +$p(OeordItemID,"||",2)
		s TmpAmount = $p($g(^OEORD(OeordID,"I",ChildSub,1)),"^",12)
		s Amount = Amount + (+TmpAmount)     //输血量
	}
	d ds.Close()
	q Amount
}

/// Desc:	查询特定医嘱项医嘱信息
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.HISInterface.OrderInfo","QryOeordItem",EpisodeID,OrdItems,OrdItemStatus)
Query QueryOrderItem(EpisodeID As %String, OrdItems As %String, OrdItemStatus As %String) As %Query(ROWSPEC = "OeordItemID:%String,IDate:%String,ITime:%String,VDate:%String,VTime:%String,EDate:%String,ETime:%String,DDate:%String,DTime:%String,ItemMastID:%String,ItemMastDesc:%String")
{
}

ClassMethod QueryOrderItemExecute(ByRef qHandle As %Binary, EpisodeID As %String, OrdItems As %String, OrdItemStatus As %String) As %Status
{
    s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(EpisodeID = "")||(OrdItems = "")||(OrdItemStatus = "") $$$OK
	
	s OrdItemStatusls = ##Class(EPRservice.Util.StringHelper).ConvertStringToList(OrdItemStatus,"^")
	q:(OrdItemStatusls = "") $$$OK
	
	s OrdItemls = ##Class(EPRservice.Util.StringHelper).ConvertStringToList(OrdItems,"^")
	
	//^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
	s OrderID = 0
	for {  
		s OrderID = $o(^OEORD(0,"Adm",EpisodeID,OrderID)) 
		q:(OrderID = "")
		
		for Ind = 1:1:$listlength(OrdItemls) {
			s ARCItmMast = $listget(OrdItemls,Ind)
			continue:(ARCItmMast = "")
			
			//^OEORDi(0,"ARCIM",{OE_Order.OEORD_RowId},{OEORI_ItmMast_DR},{OEORI_SttDat},{OEORI_Childsub})
			continue:('$d(^OEORDi(0,"ARCIM",OrderID,ARCItmMast)))
			
			s SttDat = ""
			for {
				s SttDat = $o(^OEORDi(0,"ARCIM",OrderID,ARCItmMast,SttDat)) 
				q:(SttDat = "")
				
				s ChildSub = 0
				for {
					s ChildSub = $o(^OEORDi(0,"ARCIM",OrderID,ARCItmMast,SttDat,ChildSub)) 
					q:(ChildSub="")
				
					s OeordItemID = OrderID_"||"_ChildSub
					s CurrStatus = $p($g(^OEORD(OrderID,"I",ChildSub,1)),"^",13)
					continue:($listfind(OrdItemStatusls,CurrStatus) = 0)
					s IDate = $p($g(^OEORD(OrderID,"I",ChildSub,1)),"^",9)      //开医嘱时间  OEORI_SttDat
					s ITime = $p($g(^OEORD(OrderID,"I",ChildSub,1)),"^",10)
					s VDate = $p($g(^OEORD(OrderID,"I",ChildSub,3)),"^",7)      //核实时间   OEORI_Date
					s VTime = $p($g(^OEORD(OrderID,"I",ChildSub,3)),"^",15)
					s:(VTime = "") VTime = ITime
					s EDate = $p($g(^OEORD(OrderID,"I",ChildSub,6)),"^",2)      //执行时间   OEORI_DateExecuted
					s ETime = $p($g(^OEORD(OrderID,"I",ChildSub,6)),"^",3)	
					s DDate = $p($g(^OEORD(OrderID,"I",ChildSub,3)),"^",34)     //停止时间   OEORI_XDate
					s DTime = $p($g(^OEORD(OrderID,"I",ChildSub,2)),"^",15)
					s ItemMastID = ARCItmMast
					s ItemMastDesc = $p($g(^ARCIM(+$p(ARCItmMast,"||",1),+$p(ARCItmMast,"||",2))),"^",2)
					
					s Data = $lb(OeordItemID,IDate,ITime,VDate,VTime,EDate,ETime,DDate,DTime,ItemMastID,ItemMastDesc)
					s ^CacheTemp(repid,ind) = Data
					s ind = ind+1
				}
			}
		}
	}
	q $$$OK
}

ClassMethod QueryOrderItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderItemExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	}
 	else {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QueryOrderItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderItemExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
