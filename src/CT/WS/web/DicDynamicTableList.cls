/// 名称：		CT.WS.web.DicDynamicTableList
/// 描述：		获取获取代码配置表
/// 编写者：	yejian
/// 编写时间：	2013-4-17
Class CT.WS.web.DicDynamicTableList Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	
	s start = $g(%request.Data("start",1),"0")
	s limit = $g(%request.Data("limit",1),"12")
	s idxLast=(start+limit)-1
	s tableName = $Get(%request.Data("tableName",1))
	s configName = $Get(%request.Data("configName",1))
	s deleteId = $Get(%request.Data("deleteId",1))
	s actionBtn = $Get(%request.Data("actionBtn",1))
	s strTableName=tableName_"^@^"_configName
	if (tableName=""){
 		w ##class(CT.WS.BO.BODynamicConfigTable).GetConfigJson("",start,idxLast)}
 	if ((tableName'="") &((actionBtn="selectbox"))){
		w ##class(CT.WS.BO.BODynamicConfigTable).GetConfigJson(tableName_"",start,idxLast)	
	 	}
	 if ((tableName'="") &((actionBtn="btnDeleteS"))){
		S quits= ..DelConfigTable(tableName,deleteId)
		 w ##class(CT.WS.BO.BODynamicConfigTable).GetConfigJson(tableName_"",start,idxLast,quits)	

		 }
	if ((tableName'="") & (actionBtn="btnSearchConfig")){
		w ##class(CT.WS.BO.BODynamicConfigTable).GetConfigJson(tableName_"",start,idxLast)	
	 	}
	 
    Quit $$$OK
}

//d ##Class(CT.WS.web.DicDynamicTableList).DelConfigTable("CT.WS.CustomDictionary","24")

ClassMethod DelConfigTable(tableName As %String, deleteId As %Integer) As %String
{
			q:deleteId=""
			s quits=0
			s tableNames=""
			s defaultRow=""
			s defaultValue=""
			s tab=""
			s iniValue=""
			s tableNames=$o(^CT.WS.DynamicConfE129I("IdxTableName"," "_$ZCVT(tableName, "U"),tableNames))
			if (tableNames'="")
			{
				s obj=##class(CT.WS.DynamicConfigDefaultValue).%OpenId(tableNames)
				s defaultRow=obj.DefaultRow
			}
			 s objConfigT=##class(CT.WS.DynamicConfigTable).%OpenId(deleteId)
			 if (objConfigT'=""){
			 S iniValue=objConfigT.IniValue
			 }
			 s count=$l(iniValue,",")
			 for inti=1:1:count
			 {
			 	s OneiniValue=$p(iniValue,",",inti)
			 	s OneiniValueTableRow=$p(OneiniValue,"=",1)
			 	if (OneiniValueTableRow=defaultRow)
			 	{
				 s OneiniValueTableRowValue=$p(OneiniValue,"=",2)
				 s defaultValue=$P(OneiniValueTableRowValue,"'",2)
				s quits= ##class(CT.WS.BO.BODynamicConfigTable).DelDBByDVConfigRecord(tableName, defaultRow,defaultValue) 
				q:quits=1
				
			 	d ##class(CT.WS.BO.BODynamicConfigTable).DelDBByIDConfigRecord(deleteId)
				s tab=$o(^DHCCTWS.DynamicConfigTableI("Idx"," "_$ZCVT(tableName, "U"),tab))
				
				if (tab=""){
					d ##class(CT.WS.BO.BODynamicConfigDefaultValue).DelRecord(tableName)
					
					}
				}
			 
			 	
			 }
			 q quits
}

/// d ##Class(web.eprajax.query.getDicList).DicList("S07","",0,12,"True",0,"","","")
/// modify by ncc 2012-08-09
ClassMethod DicList(ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, CountFlag As %String, ByRef AResultCount As %String, ByRef SessionId As %String, AConditionCode As %String = "", ACondition As %String = "")
{
    //检查参数有效性
 	if (ADicCode=$C(0)) { s ADicCode= "" Quit ""}
 	if (AItem=$C(0)){ s AItem= ""}
 	if (AStartRow=$C(0)){ s AStartRow = 0 Quit ""}
 	if (ARowCount=$C(0)){ s ARowCount = 0 Quit ""} 
 	
   	S ASessionId=$I(^CacheTemp)
   	s SessionId=ASessionId
   	   
   	//生成字典查询结果集，并存储在临时global中
   	s dateResult= ##class(CT.WS.BO.BOStdDictionary).SelectALLStdDic()
   	s PageCount= ##class(CT.WS.StdDictionary).SelectNewStdDicPageCount(ADicCode,AItem,AStartRow,ARowCount,ASessionId,AConditionCode,ACondition)
   	s AResultCount =PageCount
   	s TotalRowCount =  $G(^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount"))
   	//取相应页码的结果
  	if (PageCount'=0)
  	{ 
  		//以AStartRow开始，查询ARowCount个数据到Result中，与下面的按页查询相区别
  		s Result = ##class(%ResultSet).%New("EPRservice.DAL.Query.DAGetDicInTurn:GetDicInTurn")
  		//s Result = ##class(%ResultSet).%New("CT.WS.StdDictionary:GetStdDicOrList")
    	d Result.Execute(ADicCode,AItem,AStartRow,ARowCount,ASessionId)
  	}
  	else
  	{
		s SessionId=0
		s Result = "" 
	}
 	
 	//构造json数据
 	s json = "["
 	while(Result.Next())
 	{
	 	s json = json_"{ID:'"_$g(Result.Data("ID"))_"',"
	 	s json = json_"DicAlias:'"_$g(Result.Data("DicAlias"))_"',"
	 	s json = json_"DicCode:'"_$g(Result.Data("DicCode"))_"',"
		s json = json_"DicDesc:'"_$g(Result.Data("DicDesc"))_"'},"	
	}
    s json = $e(json, 1, $l(json)-1)
	s json = json_"]"
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	
	w "{"
    w "TotalCount:'"_TotalRowCount_"'"
    w ",data:"_json_"}"
}

}
