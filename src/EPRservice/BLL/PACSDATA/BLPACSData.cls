/// 名称： EPRservice.BLL.PACSDATA.BLPACSData
/// 描述:按就诊号或按病人号分页查询或查询一段时间内的检查医嘱(返回已经执行的检查套列表)
/// 创建者：Candyxu
/// 创建时间：2011-12-06
Class EPRservice.BLL.PACSDATA.BLPACSData Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator: Candyxu
/// CreatTime: 2011-12-06
/// Input: SelectID：当Flag为1时SelectID为EpisodeID,否则SelectID为patientID，StDate：开始时间
///       EndDate：结束时间，StartPage：返回分页开始页号，EndPage：返回分页结束页号
/// OutPut:EpisodeDate:就诊日期,EpisodeSection:就诊科室,EpisodeItemName:医嘱名称,OrdCreateDate:下医嘱日期,OrdCreateTime:下医嘱时间,OEOrdItemDR:医嘱ID,RptRowID:报告ID	
/// do ##class(%ResultSet).RunQuery("EPRservice.BLL.PACSDATA.BLPACSData","GetPACSListItems",50729,61362,62092,1,1,2) 
/// modify by niucaicai 2013-05-03 增加两列输出值--OrdCreateDate:下医嘱日期,OrdCreateTime:下医嘱时间
/// 增加 RrtDate:%String,RrtTime:%String 报告日期，报告时间
Query GetPACSListItems(SelectID As %String, StDate As %String, EndDate As %String, Flag As %String, StartPage As %Integer, EndPage As %Integer) As %Query(ROWSPEC = "EpisodeDate:%String,EpisodeSection:%String,EpisodeItemName:%String,OrdCreateDate:%String,OrdCreateTime:%String,OEOrdItemDR:%String,RptRowID:%String,RrtDate:%String,RrtTime:%String")
{
}

ClassMethod GetPACSListItemsExecute(ByRef qHandle As %Binary, SelectID As %String, StDate As %String, EndDate As %String, Flag As %String, StartPage As %Integer, EndPage As %Integer) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	i (Flag="") ||(Flag=$c(0))  Quit $$$OK
 	s TotalCount=0	
 	//对有要求的医院，将检查号拼接在医嘱名称后面显示 add by niucaicai 2016-06-21
	s HospitalName = ##Class(EPRservice.BOSysOption).GetValueByName("HospitalName")	
 	//当前就诊信息
 	i Flag="1"
 	{
	   s episodeDate = $ZD($p($g(^PAADM(SelectID)),"^",6),3)	 	
	   s deptId=$p(^PAADM(SelectID),"^",4)
	   i (deptId'="") set deptDesc=$p(^CTLOC(deptId),"^",2) else  set deptDesc=""
	   s:($f(deptDesc,"-")'=0) deptDesc = $p(deptDesc,"-",2)
	 		
	   s ds = ##Class(%Library.ResultSet).%New("web.DHCRisclinicQueryEPR:SelectPACSItemListByDate")
	   d ds.Execute(SelectID,StDate,EndDate)
  	   While (ds.Next()){
	     s TotalCount = TotalCount + 1 
		 i (TotalCount>= StartPage)&&( TotalCount<=EndPage)
		 {
			 if (HospitalName = "WHXH")
			 {
				 s StudyNO = ..GetStudyNOByOrdItemDR(ds.Data("OEOrdItemDR"))
				 s data = $lb(episodeDate,deptDesc,ds.Data("ItemName")_"("_StudyNO_")",ds.Data("OrdCreateDate"),ds.Data("OrdCreateTime"),ds.Data("OEOrdItemDR"),ds.Data("RptRowID"),ds.Data("RrtDate"),ds.Data("RrtTime"))
			 }
			 else
			 {
				 s data = $lb(episodeDate,deptDesc,ds.Data("ItemName"),ds.Data("OrdCreateDate"),ds.Data("OrdCreateTime"),ds.Data("OEOrdItemDR"),ds.Data("RptRowID"),ds.Data("RrtDate"),ds.Data("RrtTime"))
			 }
	        
	        s ^CacheTemp(repid,ind) = data
	        s ind = ind + 1
		 } 
	   }
 	}
 	else   //全部就诊信息
 	{
	 	s typeRowID = "0" 
	    for {
	 	  s typeRowID = $o(^PAPERdr(SelectID,"ADM",typeRowID))
	 	  q:(typeRowID = "")
	      s episodeID = "0"
	 	  for {
		 	s episodeID = $o(^PAPERdr(SelectID,"ADM",typeRowID,episodeID))
		 	q:(episodeID = "")
		 	s episodeDate = $ZD($p($g(^PAADM(episodeID)),"^",6),3)
		 	s deptId=$p(^PAADM(episodeID),"^",4)
			i (deptId'="") set deptDesc=$p(^CTLOC(deptId),"^",2) else  set deptDesc=""
	        s ds = ##Class(%Library.ResultSet).%New("web.DHCRisclinicQueryEPR:SelectPACSItemListByDate")
	        d ds.Execute(episodeID,StDate,EndDate) 
  	        While (ds.Next()){
	           s TotalCount = TotalCount + 1 
		       i (TotalCount>= StartPage)&&( TotalCount<=EndPage)
		       {
	               if (HospitalName = "WHXH")
				   {
					   s StudyNO = ..GetStudyNOByOrdItemDR(ds.Data("OEOrdItemDR"))
					   s data = $lb(episodeDate,deptDesc,ds.Data("ItemName")_"("_StudyNO_")",ds.Data("OrdCreateDate"),ds.Data("OrdCreateTime"),ds.Data("OEOrdItemDR"),ds.Data("RptRowID"),ds.Data("RrtDate"),ds.Data("RrtTime"))
				   }
				   else
				   {
					   s data = $lb(episodeDate,deptDesc,ds.Data("ItemName"),ds.Data("OrdCreateDate"),ds.Data("OrdCreateTime"),ds.Data("OEOrdItemDR"),ds.Data("RptRowID"),ds.Data("RrtDate"),ds.Data("RrtTime"))
				   }
	               s ^CacheTemp(repid,ind) = data
	               s ind = ind + 1
		        } 
  	         }
	       }
	    }
	}
	Quit $$$OK
}

ClassMethod GetPACSListItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPACSListItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPACSListItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPACSListItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetStudyNOByOrdItemDR(AOEOrdItemDR As %String) As %String
{
	s StudyNo = ""
	q:(AOEOrdItemDR = "") StudyNo
	
	//&sql(select DRPT_StudyNo into:StudyNo from DHCRB_Report where DRPT_OeordItm_DR=:AOEOrdItemDR)
	s DRPTRowID = ""
	for
	{
		s DRPTRowID = $O(^DHCRBStudyi("Report-Oeorditm",AOEOrdItemDR,DRPTRowID))
		q:(DRPTRowID = "")
		
		s StudyNo = $p($g(^DHCRBStudy("Report",DRPTRowID)),"^",1)
	}
	q StudyNo
}

}
