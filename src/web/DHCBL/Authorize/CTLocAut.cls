/// 名称:科室配置	
/// 描述:获取授权字符串，保存授权
/// 编写者:基础数据平台组 - 谷雪萍
/// 编写日期: 2015-4-9
Class web.DHCBL.Authorize.CTLocAut Extends web.BDP.sys.ExtPreferences
{

/// w ##class(web.DHCBL.Authorize.CTLocAut).SaveAuthorizeData("G","1","[{ID:1},{ID:2}]")
/// w ##class(web.DHCBL.Authorize.CTLocAut).GetTreeJson("menuTreeRoot","G","1")
Parameter ParaAppKey = "SYS";

Parameter ParaAppSubKey = "LocNewsAut";

Parameter EntityClassName = "web.Entity.CT.CTLoc";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
	s strAutMenu=##class(web.DHCBL.Authorize.CTLocAut).DHCGetDataByReference(ObjectType,ObjectReference)
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
	s AuStr=##class(web.DHCBL.Authorize.CTLocAut).DHCGetDataByReference(ObjectType,ObjectReference)				
	
	s RowId=0
	s count=0
	s end=start+limit
	
	for{
		s RowId=$o(^CTLOC(RowId))
		q:RowId=""
		
			//过滤已选、未选
		s AuStr2="{ID:"_RowId_"}"
		if (FilterCK="checked") {
			if (AuStr[AuStr2) 
			else  continue
		}
		elseif (FilterCK="unchecked") {
			if (AuStr[AuStr2) continue
			else  
		}
			
		s Desc=$p($g(^CTLOC(RowId)),"^",2)       //科室名
		
		//s Desc=$tr(Desc,$c(13,10),"")
		s Desc=##class(ext.util.String).EvalJSON(Desc)
		
		if ($ZCONVERT(Desc,"U")[$ZCONVERT(query,"U")){
			s count=count+1
			if ((count>start) & (count<=end)) || (end=0){
				s AuStr2="{ID:"_RowId_"}"
				if (AuStr[AuStr2) s myEnable=1
				else  s myEnable=0
				
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_RowId_""",""text"":"""_Desc_""","
				
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

/// 科室配置接口，入参 rowid ，返回 0或1  为1为可以查看消息
/// w ##class(web.DHCBL.Authorize.CTLocAut).IsAutCTLoc("1")
ClassMethod IsAutCTLoc(rowId As %String) As %String
{
	s ObjectType="G"
	s ObjectReference="1"
	s str="{ID:"_rowId_"}"
	s flag=""
	s strAutMenu=##class(web.DHCBL.Authorize.CTLocAut).DHCGetDataByReference(ObjectType,ObjectReference)
	if (strAutMenu[str){
		s flag=1
	}else{
		s flag=0
	}
	q flag
}

}
