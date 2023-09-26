Class EMRservice.BL.BLPrivCTLoc Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Output：EMRservice.dataset.EPrivCTLocDataset
/// added by Jiangew on 2012-11-14
ClassMethod GetCTLoc() As EMRservice.dataset.EPrivCTLocDataset
{
	Set ds=##class(EMRservice.dataset.EPrivCTLocDataset).%New()
	Quit ds
}

/// w ##Class(EMRservice.BL.BLPrivCTLoc).GetCTLocList("S07","",0,12,0,"","","")
/// added by Jiangew on 2012-11-15
ClassMethod GetCTLocList(ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, ByRef AResultCount As %String, ByRef SessionId As %String, AConditionCode As %String = "", ACondition As %String = "") As EMRservice.dataset.EPrivCTLocDataset
{
    //检查参数有效性
 	if (ADicCode=$C(0)) { s ADicCode= "" Quit ""}
 	if (AItem=$C(0)){ s AItem= ""}
 	if (AStartRow=$C(0)){ s AStartRow = 0 Quit ""}
 	if (ARowCount=$C(0)){ s ARowCount = 0 Quit ""} 
 	
   	S ASessionId=$I(^CacheTemp)
   	s SessionId=ASessionId
   	K ^CacheTempStdQuery(ASessionId)
   
   	//生成字典查询结果集，并存储在临时global中
   	s PageCount=##class(EMRmeta.StdDictionary).SelectNewStdDicPageCount(ADicCode,AItem,AStartRow,ARowCount,ASessionId,AConditionCode,ACondition)
   	s AResultCount=PageCount
   	s TotalRowCount=$G(^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount"))
   	//取相应页码的结果
  	if (PageCount'=0)
  	{ 
  		//以AStartRow开始，查询ARowCount个数据到Result中，与下面的按页查询相区别
  		s Result = ##class(EMRservice.dataset.EPrivCTLocDataset).%New()
    	
    	//d Result.Execute(ADicCode,AItem,AStartRow,ARowCount,ASessionId)
    	d Result.SetArgs(ADicCode,AItem,AStartRow,ARowCount,ASessionId)
  	}
  	else
  	{
		s SessionId=0
		s Result = "" 
	}
	q Result
		
	//w !,"TotalCount:"_TotalRowCount_""
	//w !,"CTLOC_RowID:"_CTLOC_RowID_",CTLOC_Code:"_CTLOC_Code_",CTLOC_Desc:"_CTLOC_Desc_""
}

/// d ##class(%ResultSet).RunQuery("EPRservice.dao.DPrivCTLoc","GetCTLoc")
/// added by Jiangew on 2012-11-15
Query GetAllCTLoc() As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTLOC_RowID,CTLOC_Desc", SELECTMODE = "RUNTIME") [ SqlName = GetAllCTLoc, SqlProc ]
{
	Select CTLOC_RowID,CTLOC_Desc from SQLUser.CT_Loc order by CTLOC_RowID
}

Query GetCTLocByName(CTLocName As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTLOC_RowID,CTLOC_Desc", SELECTMODE = "RUNTIME") [ SqlName = GetCTLocByName, SqlProc ]
{
	Select CTLOC_RowID,CTLOC_Desc from SQLUser.CT_Loc where CTLOC_Desc like :CTLocName
}

/// added by Jiangew on 2012-11-15
Query GetCTLoc(ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, ASessionId As %String) As %Query(ROWSPEC = "CTLOC_RowID:%String,CTLOC_Desc:%String")
{
}

ClassMethod GetCTLocExecute(ByRef qHandle As %Binary, ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, ASessionId As %String) As %Status
{
	s qHandle="1" 
    s SQLCODE=0 
    s %counter=0
    s ID=""
    s %ResultID=""
    
    if ($D(^CacheTempStdQuery(ASessionId)))
    {
	    if ($G(^CacheTempStdQuery(ASessionId))="True") 
	    {
		    s StartPageID= AStartRow
		    s LastPageId = AStartRow+ARowCount
            s PageNumCounter = 0 
            s PageKey= $O(^CacheTempStdQuery(ASessionId,""))
            While (PageKey '="")
	        {
		        s PageNumCounter = PageNumCounter + 1
	            if (PageNumCounter> StartPageID)&(PageNumCounter <= LastPageId)
	            {
		            s %ResultID(PageNumCounter-StartPageID)= $G(^CacheTempStdQuery(ASessionId,PageKey))	 
	            }
		
	            s PageKey= $O(^CacheTempStdQuery(ASessionId,PageKey)) 	
		    }
		    s qHandle=%ResultID
            q $$$OK
		}
	}
}

ClassMethod GetCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTLocExecute ]
{
	s SQLCODE=0 
    s $ET="QUIT" 
    s %counter=%counter+1
    if $o(%ResultID(""),-1)<%counter 
    {
	    s Row = ""
	    s AtEnd=1
    }
    else 
    {
	    s Row=%ResultID(%counter)
	}
	q $$$OK
}

ClassMethod GetCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTLocExecute ]
{
	s qHandle="" 
	q $$$OK
}

}
