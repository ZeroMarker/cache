Class EPRservice.Quality.DataGather.OrderInfo Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	根据医嘱类型代码（从基础字典中获取）获取医嘱项目字符串，多个医嘱项目以“\”分隔
/// Debug:	w ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrderIDsByTypeCode("RBCOrder")
ClassMethod GetOrderIDsByTypeCode(ATypeCode As %String) As %String
{
	s ret = ""
	q:(ATypeCode = "") ret
	
	s DictionaryID = $o(^DHCEPRM.QualityDicI("IdxCode",ATypeCode,""))
	q:(DictionaryID = "") ret
	
	s RowID = ""
	for {
		s RowID = $o(^DHCEPRM.QualityOrderI("IdxDictionaryID"," "_DictionaryID,RowID))
		q:(RowID = "")
		
		s objOrder = $g(^DHCEPRM.QualityOrderD(RowID))
		
		// just get active order items
		s IsActive = $list(objOrder,5)
		continue:(IsActive '= "Y")
		
		s OrderID = $list(objOrder,2)
		
		s ret = ret_$lb(OrderID)
	}
	
	s ret = ##Class(EPRservice.Quality.CommonHelper).GetListToString(ret,"\")
	q ret
}

/// Desc:	取输血医嘱对应的输血量  红细胞、血小板、血浆、全血、其他等
/// Debug:	w ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemAmount(EpisodeID,OrdItems,OrdItemStatus)
ClassMethod GetOrderItemAmount(EpisodeID As %String, OrdItems As %String, OrdItemStatus As %String) As %String
{
	s Amount = 0
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.OrderInfo:QueryOrderItem")
	d ds.Execute(EpisodeID,OrdItems,OrdItemStatus)
	while(ds.Next())
	{
		s OeordItemID = ds.Data("OeordItemID")
		s OeordID = +$p(OeordItemID,"||",1)
		s ChildSub = +$p(OeordItemID,"||",2)
		s Amount = Amount + (+$p($g(^OEORD(OeordID,"I",ChildSub,1)),"^",12))     //输血量
	}
	d ds.Close()
	q Amount
}

/// Desc:	取有效医嘱次数 抢救医嘱、穿刺医嘱、会诊医嘱书、输血医嘱等
/// Debug:	w ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemCount(EpisodeID,OrdItems,OrdItemStatus)
ClassMethod GetOrdItemCount(EpisodeID As %String, OrdItems As %String, OrdItemStatus As %String) As %String
{
	s Count = 0
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.OrderInfo:QueryOrderItem")
	d ds.Execute(EpisodeID,OrdItems,OrdItemStatus)
	while(ds.Next())
	{
		s Count = Count+1
	}
	d ds.Close()
	q Count
}

/// Desc:	取特定医嘱日期和时间 抢救医嘱等
/// Debug:	w ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTime(EpisodeID,OrdItems,OrdItemStatus)
ClassMethod GetOrdItemTime(EpisodeID As %String, OrdItems As %String, OrdItemStatus As %String) As %String
{
	s cData = ""
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.OrderInfo:QueryOrderItem")
	d ds.Execute(EpisodeID,OrdItems,OrdItemStatus)
	while(ds.Next())
	{
		s OeordItemID = ds.Data("OeordItemID")
		s DateTime = ds.Data("VDate")_" "_ds.Data("VTime")
		s:(ds.Data("EDate") '= "")&&(ds.Data("ETime") '= "") DateTime = ds.Data("EDate")_" "_ds.Data("ETime")
		s cData = cData_$lb(DateTime)
	}
	d ds.Close()
	s:(cData '= "") cData = ##Class(EPRservice.Quality.CommonHelper).GetListToString(cData,"\")
	q cData
}

/// Desc:	查询特定医嘱项医嘱信息
/// Modify by: Candyxu 参加参数IsManualOrdItem 当为Y时不查滚出来的医嘱，增加判断OrdItemStatus 当为空时取所有状态的医嘱
/// Input:EpisodeID 就诊号，OrdItems 医嘱项，OrdItemStatus 医嘱状态(rowid 或 code都可以.多个以"\"分隔)，IsManualOrdItem 是否取滚动的医嘱
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.OrderInfo","QueryOrderItem",EpisodeID,OrdItems,OrdItemStatus)
Query QueryOrderItem(EpisodeID As %String, OrdItems As %String, OrdItemStatus As %String, IsManualOrdItem As %String = "N") As %Query(ROWSPEC = "OeordItemID:%String,IDate:%String,ITime:%String,VDate:%String,VTime:%String,EDate:%String,ETime:%String,DDate:%String,DTime:%String,ItemMastID:%String,ItemMastDesc:%String")
{
}

ClassMethod QueryOrderItemExecute(ByRef qHandle As %Binary, EpisodeID As %String, OrdItems As %String, OrdItemStatus As %String, IsManualOrdItem As %String = "N") As %Status
{
    s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:((EpisodeID = "")||(OrdItems = "")) $$$OK
	
	s OrdItemStatusls = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(OrdItemStatus,"\")
	s OrdItemls = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(OrdItems,"\")
	
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
					s FillerNo = $p($g(^OEORD(OrderID,"I",ChildSub,9)),"^",12)
					//只取手工下的医嘱，不取滚的医嘱
					if ($ZCVT(IsManualOrdItem,"U") = "Y")
					{
					   continue:(FillerNo '= "")	
					}
					s CurrStatus = $p($g(^OEORD(OrderID,"I",ChildSub,1)),"^",13)
					s CurrStatusCode = $p(^OEC("OSTAT",CurrStatus),"^",1)
					if ($listlength(OrdItemStatusls) > 0 ) 
					{ 
					   continue:(($listfind(OrdItemStatusls,CurrStatus) = 0) && ($listfind(OrdItemStatusls,CurrStatusCode) = 0))
					}
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

/// Desc:转换结果
/// debug w ##Class(EPRservice.Quality.DataGather.OrderInfo).ConvertResult("","","")
ClassMethod ConvertResult(AElement1 As %String, AElement2 As %String, AValue1 As %String = "0") As %String
{
	//b "s"
	s ret = ""
	
	q:(AElement1 = "")||(AElement1 = "") ret
	
	s ret = 0
	
	s ElementData1 = $lb(AElement1,AElement2)
			
	for Ind=1:1:$ll(ElementData1)
	{
		s tmpValue = $lg(ElementData1,Ind)
		q:(tmpValue'=AValue1)
	}		
	s ret = 1
	q ret
}

}
