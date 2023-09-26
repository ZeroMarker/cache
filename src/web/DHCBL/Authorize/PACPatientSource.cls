/// 名称:病人管理-患者来源数据授权
/// 描述:患者来源数据授权
/// 编写者:基础平台组 - 钟荣枫
/// 编写日期:2020-4-21
Class web.DHCBL.Authorize.PACPatientSource Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "PAC_PatientSource";

Parameter EntityClassName = "web.Entity.CT.PACPatientSource";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
	s strAutMenu=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByReference(ObjectType,ObjectReference)
	q strAutMenu
}

/// Creator:钟荣枫
/// CreatDate:2020-4-21
/// Description:一级授权中获取Tree类型的json串
/// Table:User.PACPatientSource
/// Input:ParentID As %String, ObjectType As %String, ObjectReference As %String, start, limit, query, FilterCK
/// Return: JSON字符串
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.Authorize.PACPatientSource","GetTreeJson","","","","","","","") 
/// ParentID： 父ID
/// ObjectType: 需要显示的优先级类别
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String, start, limit, query, FilterCK) As %String
{
	if (ParentID="menuTreeRoot") s ParentID=-100000000000000
	
	s myJsonStr=""
	s myImage=""
	
	//获取授权JSON
	s AuStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByReference(ObjectType,ObjectReference)				
	
	s RowId=0
	s count=0
	s end=start+limit
	
	for{
		s RowId=$o(^PAC("Source",RowId))
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
		s Desc=$p((^PAC("Source",RowId)),"^",2)
		
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

}
