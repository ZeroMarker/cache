/// 流程岗位数据授权
/// 2023--3-30
Class web.DHCBL.Authorize.HOSProcPost Extends web.BDP.sys.ExtPreferences
{

/// w ##class(web.DHCBL.Authorize.HOSProcPost).SaveAuthorizeData("G","1","[{ID:1},{ID:2}]")
/// w ##class(web.DHCBL.Authorize.HOSProcPost).GetTreeJson("menuTreeRoot","G","1",1,20,"","")
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "CT_BDP_CT.HOS_ProcPost";

Parameter EntityClassName = "web.Entity.CT.HOSProcPost";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
	s strAutMenu=##class(web.DHCBL.Authorize.HOSProcPost).DHCGetDataByReference(ObjectType,ObjectReference)
	q strAutMenu
}

/// 一级授权中获取Tree类型的json串
/// ParentID： 父ID
/// ObjectType: 需要显示的优先级类别
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String, start, limit, query, FilterCK) As %String
{
	if (ParentID="menuTreeRoot") s ParentID=-100000000000000
	
	s myJsonStr=""
	s myImage=""
	
	//获取授权JSON
	s AuStr=##class(web.DHCBL.Authorize.HOSProcPost).DHCGetDataByReference(ObjectType,ObjectReference)				
	
	s count=0
	s end=start+limit
	
	s ID=0
    for 
    {
        s ID=$o(^CT.BDP.CT.HOSProcPostD(ID))
        q:ID="" 
	    s PPOSTDesc=$listget($g(^CT.BDP.CT.HOSProcPostD(ID)),3)	//流程岗位
	    //过滤已选、未选
		s AuStr2="{ID:"_ID_"}"
		if (FilterCK="checked") {
			if (AuStr[AuStr2) 
			else  continue
		}
		elseif (FilterCK="unchecked") {
			if (AuStr[AuStr2) continue
			else  
		}
		
		if ($ZCONVERT(PPOSTDesc,"U")[$ZCONVERT(query,"U"))
		{
			s count=count+1
			if ((count>start) & (count<=end)) || (end=0){
				s AuStr2="{ID:"_ID_"}"
				if (AuStr[AuStr2) s myEnable=1
				else  s myEnable=0
				
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_ID_""",""text"":"""_PPOSTDesc_""","
				
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
