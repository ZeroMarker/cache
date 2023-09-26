Class EPRservice.Privilege.BLPrivCTLoc Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// Output：EPRservice.dataset.Privilege.EPrivCTLocDataset
/// added by Jiangew on 2012-11-14
ClassMethod GetCTLoc() As EPRservice.dataset.Privilege.EPrivCTLocDataset
{
	Set ds=##class(EPRservice.dataset.Privilege.EPrivCTLocDataset).%New()
	Quit ds
}

/// w ##Class(EPRservice.Privilege.BLPrivCTLoc).GetCTLocList("S07","",0,12,0,"","","")
/// added by Jiangew on 2012-11-15
ClassMethod GetCTLocList(ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, ByRef AResultCount As %String, ByRef SessionId As %String, AConditionCode As %String = "", ACondition As %String = "") As EPRservice.dataset.Privilege.EPrivCTLocDataset
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
   	s PageCount=##class(EPRmeta.StdDictionary).SelectNewStdDicPageCount(ADicCode,AItem,AStartRow,ARowCount,ASessionId,AConditionCode,ACondition)
   	s AResultCount=PageCount
   	s TotalRowCount=$G(^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount"))
   	//取相应页码的结果
  	if (PageCount'=0)
  	{ 
  		//以AStartRow开始，查询ARowCount个数据到Result中，与下面的按页查询相区别
  		s Result = ##class(EPRservice.dataset.Privilege.EPrivCTLocDataset).%New()
    	
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

}
