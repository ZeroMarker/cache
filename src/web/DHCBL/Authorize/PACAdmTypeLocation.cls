/// 访问类型位置数据授权
/// 2013-10-11 by lisen
Class web.DHCBL.Authorize.PACAdmTypeLocation Extends web.BDP.sys.ExtPreferences
{

/// w ##class(web.DHCBL.Authorize.PACAdmTypeLocation).SaveAuthorizeData("G","1","[{ID:1},{ID:2}]")
/// w ##class(web.DHCBL.Authorize.PACAdmTypeLocation).GetTreeJson("menuTreeRoot","G","1")
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "PAC_AdmTypeLocation";

Parameter EntityClassName = "web.Entity.CT.PACAdmTypeLocation";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
	s strAut=##class(web.DHCBL.Authorize.PACAdmTypeLocation).DHCGetDataByReference(ObjectType,ObjectReference)
	q strAut
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
	s AuStr=##class(web.DHCBL.Authorize.PACAdmTypeLocation).DHCGetDataByReference(ObjectType,ObjectReference)				
	
	s rowid=0
	s count=0
	s end=start+limit
	
	for {
		s rowid=$o(^PAC("ADMLOC",rowid))
		q:rowid=""
		s V = $p(^PAC("ADMLOC",rowid),"^",1)
		s L = $p(^PAC("ADMLOC",rowid),"^",2)
		s L = $p($g(^CTLOC(L)),"^",2)
		if (V="O") s V="OutPatient"
		if (V="I") s V="InPatient"
		if (V="E") s V="Emergency"
		if (V="H") s V="HealthPromotion"
		s desc = V_" & "_L
		
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
		
		if ($ZCONVERT(desc,"U")[$ZCONVERT(query,"U")) {
			s count=count+1
			if ((count>start) & (count<=end)) || (end=0) {
				s AuStr2="{ID:"_rowid_"}"
				if (AuStr[AuStr2) s myEnable=1
				else  s myEnable=0
				
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_rowid_""",""text"":"""_desc_""","
				
				if (+myEnable) {
					s myJsonStr=myJsonStr_"""checked"":true,"
				}else {
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
