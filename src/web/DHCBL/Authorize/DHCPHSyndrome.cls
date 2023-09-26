/// 名称:证型字典 数据授权
/// 编写者:基础平台组 - 石萧伟 
/// 编写日期: 2010-01-11
Class web.DHCBL.Authorize.DHCPHSyndrome Extends web.BDP.sys.ExtPreferences
{

/// w ##class(web.DHCBL.Authorize.DHCPHSyndrome).SaveAuthorizeData("G","1","[{ID:1},{ID:2}]")
/// w ##class(web.DHCBL.Authorize.DHCPHSyndrome).GetTreeJson("menuTreeRoot","G","1")
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "DHC_PHSyndrome";

Parameter EntityClassName = "web.Entity.KB.DHCPHSyndrome";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
	s strAutJson=##class(web.DHCBL.Authorize.DHCPHSyndrome).DHCGetDataByReference(ObjectType,ObjectReference)
	q strAutJson
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
	s AuStr=##class(web.DHCBL.Authorize.DHCPHSyndrome).DHCGetDataByReference(ObjectType,ObjectReference)				
	
	s rowid=0
	s count=0
	s end=start+limit
	
	for{
		s rowid=$o(^DHCPHSYDRO(rowid))  q:rowid=""
		//过滤已选、未选
		s AuStr2="{ID:"_rowid_"}"
		if (FilterCK="checked") {
			if (AuStr[AuStr2) 
			else  continue
		}
		elseif (FilterCK="unchecked") {
			if (AuStr[AuStr2) continue
			else  
		}
		s DRODesc=$p($g(^DHCPHSYDRO(rowid)),"^",2)
		
		if ($ZCONVERT(DRODesc,"U")[$ZCONVERT(query,"U")){
			s count=count+1
			if ((count>start) & (count<=end)) || (end=0){
				s AuStr2="{ID:"_rowid_"}"
				if (AuStr[AuStr2) s myEnable=1
				else  s myEnable=0
				
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_rowid_""",""text"":"""_DRODesc_""","
				
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
