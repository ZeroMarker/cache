Class web.DHCBL.Authorize.CTPayMode Extends web.BDP.sys.ExtPreferences
{

/// 数据授权、
/// w ##class(web.DHCBL.Authorize.CTPayMode).SaveAuthorizeData("G","1","[{ID:1},{ID:2}]")
/// w ##class(web.DHCBL.Authorize.CTPayMode).GetAuthorizeTreeJson("menuTreeRoot","G","1")
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "CT_PayMode";

Parameter EntityClassName = "web.Entity.CT.CTPayMode";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.CTPayMode).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
	s strAutMenu=##class(web.DHCBL.Authorize.CTPayMode).DHCGetDataByReference(ObjectType,ObjectReference)
	q strAutMenu
}

/// 一级授权中获取Tree类型的json串
/// ParentID： 父ID
/// ObjectType: 需要显示的优先级类别
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
/// d ##class(web.DHCBL.Authorize.CTPayMode).GetTreeJson("G","","")
ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String, start, limit, query, FilterCK) As %String
{
	if (ParentID="menuTreeRoot") s ParentID=-100000000000000
	
	s myJsonStr=""
	s myImage=""
	
	//获取授权JSON
	s AuStr=##class(web.DHCBL.Authorize.CTPayMode).DHCGetDataByReference(ObjectType,ObjectReference)				
	
	s CTPMRowId=0
	s count=0
	s end=start+limit
	
	for{
			s CTPMRowId=$o(^CT("CTPM",CTPMRowId))
			q:CTPMRowId=""  
						//过滤已选、未选
			s AuStr2="{ID:"_CTPMRowId_"}"
			if (FilterCK="checked") {
			if (AuStr[AuStr2) 
				else  continue
		}
			elseif (FilterCK="unchecked") {
			if (AuStr[AuStr2) continue
			else  
		}
			s CTPMDesc=$p($g(^CT("CTPM",CTPMRowId)),"^",2)
 
			if ($ZCONVERT(CTPMDesc,"U")[$ZCONVERT(query,"U")){
			s count=count+1
			if ((count>start) & (count<=end)) || (end=0){
				s AuStr2="{ID:"_CTPMRowId_"}"
				if (AuStr[AuStr2) s myEnable=1
				else  s myEnable=0
				
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_CTPMRowId_""",""text"":"""_CTPMDesc_""","
				
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
