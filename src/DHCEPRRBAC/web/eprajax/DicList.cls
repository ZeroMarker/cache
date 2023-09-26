Class DHCEPRRBAC.web.eprajax.DicList Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s filter = $g(%request.Data("Filter",1),"")
	s pageSize = $g(%request.Data("rows",1),"")
	s pageNum = $g(%request.Data("page",1),"")
	s startRow = (pageNum -1)*pageSize + 1
	s endRow = startRow + pageSize -1
	s dicCode = $g(%request.Data("DicCode",1),"")
	s action = $g(%request.Data("Action",1),"")
	
	if (action = "ssgroup")
	{
		d ..GetSSGroup(filter,startRow,endRow)
	}
	else
	{
		d ..GetDicList(dicCode,filter,startRow-1,pageSize,"True",0,"","","")
	}
	Quit $$$OK
}

/// d ##Class(DHCEPRRBAC.web.eprajax.DicList).GetDicList("S07","",0,12,"True",0,"","","")
ClassMethod GetDicList(ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, CountFlag As %String, ByRef AResultCount As %String, ByRef SessionId As %String, AConditionCode As %String = "", ACondition As %String = "")
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
   	s PageCount= ##class(EPRmeta.StdDictionary).SelectNewStdDicPageCount(ADicCode,AItem,AStartRow,ARowCount,ASessionId,AConditionCode,ACondition)
   	s AResultCount =PageCount
   	s TotalRowCount =  $G(^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount"))
   	//取相应页码的结果
  	if (PageCount'=0)
  	{ 
  		//以AStartRow开始，查询ARowCount个数据到Result中，与下面的按页查询相区别
  		s Result = ##class(%ResultSet).%New("EPRservice.DAL.Query.DAGetDicInTurn:GetDicInTurn")
  		//s Result = ##class(%ResultSet).%New("EPRmeta.StdDictionary:GetStdDicOrList")
    	d Result.Execute(ADicCode,AItem,AStartRow,ARowCount,ASessionId)
  	}
  	else
  	{
		s SessionId=0
		s Result = "" 
	}
 	
 	w "{""rows"":["
 	s count = 0
 	while(Result.Next())
 	{
	 	s count = count + 1
	 	if (count > 1) w ","
		w "{"
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ID"":"""_$g(Result.Data("ID"))_""",")
	 	w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""DicAlias"":"""_$g(Result.Data("DicAlias"))_""",")
	 	w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""DicCode"":"""_$g(Result.Data("DicCode"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""DicDesc"":"""_$g(Result.Data("DicDesc"))_"""")
		w "}"	
	}
	w "],""total"":"_TotalRowCount_"}"
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

/// d ##Class(DHCEPRRBAC.web.eprajax.DicList).GetSSGroup("",1,10)
ClassMethod GetSSGroup(AGroupName As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	if (AGroupName = $c(0)) s AGroupName = ""
	
	if (AGroupName = "")
	{
		s result = ##Class(%ResultSet).%New("DHCEPRRBAC.web.eprajax.DicList:GetAllSSGroup")
		s sc = result.Execute()
	}
	else
	{
		s result = ##Class(%ResultSet).%New("DHCEPRRBAC.web.eprajax.DicList:GetSSGroupByName")
		s sc = result.Execute("%"_AGroupName_"%")		
	}
	
 	//b "s"
 	w "{""rows"":["
 	s count = 0
 	s first = 1
 	while(result.Next())
 	{
	 	s count = count + 1
		if ( count >= AIdxStart) && (count <= AIdxLast)
		{
		 	if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ID"":"""_$g(result.Data("SSGRP_RowId"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""DicDesc"":"""_$g(result.Data("SSGRP_Desc"))_"""")
			w "}"
			s first = 0	
		}
 	}
	w "],""total"":"_count_"}"
}

Query GetAllSSGroup() As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSGRP_RowId:%String,SSGRP_Desc:%String")
{
	select SSGRP_RowId,SSGRP_Desc 
	from SQLUser.SS_Group 
	order by SSGRP_RowId
}

Query GetSSGroupByName(argGroupName As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSGRP_RowId:%String,SSGRP_Desc:%String")
{
	select SSGRP_RowId,SSGRP_Desc 
	from SQLUser.SS_Group 
	where SSGRP_Desc like :argGroupName
}

}
