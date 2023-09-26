/// 名称:麻醉方法关联的麻醉剂 数据授权
/// 编写者:基础平台组 - 陈莹 
/// 编写日期: 2013-10-15
Class web.DHCBL.Authorize.ORCANAMethodAgentAlloc Extends web.BDP.sys.ExtPreferences
{

/// w ##class(web.DHCBL.Authorize.ORCANAMethodAgentAlloc).SaveAuthorizeData("G","1","[{ID:1},{ID:2}]")
/// w ##class(web.DHCBL.Authorize.ORCANAMethodAgentAlloc).GetTreeJson("menuTreeRoot","G","1")
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "ORC_ANA_Method_Agent_Alloc";

Parameter EntityClassName = "web.Entity.CT.ORCANAMethodAgentAlloc";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
	s strAutJson=##class(web.DHCBL.Authorize.ORCANAMethodAgentAlloc).DHCGetDataByReference(ObjectType,ObjectReference)
	q strAutJson
}

/// 一级授权中获取Tree类型的json串
/// ParentID： 父ID
/// ObjectType: 需要显示的优先级类别
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String, start, limit, query) As %String
{
	if (ParentID="menuTreeRoot") s ParentID=-100000000000000
	
	s myJsonStr=""
	s myImage=""
	
	//获取授权JSON
	s AuStr=##class(web.DHCBL.Authorize.ORCANAMethodAgentAlloc).DHCGetDataByReference(ObjectType,ObjectReference)				
	
	s METAGRowId=0
	s count=0
	s end=start+limit
	
	for{
		s METAGRowId=$o(^ORC("METAG",METAGRowId))  q:METAGRowId=""
		s ANMETRowId=$p($g(^ORC("METAG",METAGRowId)),"^",1)
		i ANMETRowId'="" {
			s METAGMethodDR=$p($g(^ORC("ANMET",ANMETRowId)),"^",2)
		}
		else {
			s METAGMethodDR=""
		}
		s ANAGNRowId=$p($g(^ORC("METAG",METAGRowId)),"^",2)
		i ANAGNRowId'="" {
			s METAGAgentDR=$p($g(^ORC("ANAGN",ANAGNRowId)),"^",2)
		}
		else {
			s METAGAgentDR=""
		}
			
		s METAG=METAGMethodDR_" - "_METAGAgentDR
		
		if ($ZCONVERT(METAG,"U")[$ZCONVERT(query,"U")){
			s count=count+1
			if ((count>start) & (count<=end)) || (end=0){
				s AuStr2="{ID:"_METAGRowId_"}"
				if (AuStr[AuStr2) s myEnable=1
				else  s myEnable=0
				
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_METAGRowId_""",""text"":"""_METAG_""","
				
				if (+myEnable){
					s myJsonStr=myJsonStr_"""checked"":true,"
				}else{
					s myJsonStr=myJsonStr_"""checked"":false,"
				}
				s myJsonStr=myJsonStr_"""leaf"":true"
				s myJsonStr=myJsonStr_"}"
			}
		}
	}
	s myJsonStr="{data:["_myJsonStr_"],totalCount:"_count_"}"
	
	q myJsonStr
}

}
