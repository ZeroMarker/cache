/// 检验项目 数据授权维护
/// 基础数据平台组  孙凤超
/// 开发日期：2013-12-06
Class web.DHCBL.Authorize.CTTestCode Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "CT_TestCode";

Parameter EntityClassName = "web.Entity.CT.CTTestCode";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.CTTestCode).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
	s strAutMenu=##class(web.DHCBL.Authorize.CTTestCode).DHCGetDataByReference(ObjectType,ObjectReference)
	q strAutMenu
}

/// 一级授权中获取Tree类型的json串
/// ParentID： 父ID
/// ObjectType: 需要显示的优先级类别
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
/// d ##class(web.DHCBL.Authorize.CMCBankMas).GetTreeJson("G","","")
ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String, start, limit, query) As %String
{
	if (ParentID="menuTreeRoot") s ParentID=-100000000000000
	
	s myJsonStr=""
	s myImage=""
	s del="\"
	//获取授权JSON
	s AuStr=##class(web.DHCBL.Authorize.CTTestCode).DHCGetDataByReference(ObjectType,ObjectReference)				
	
	s CTTCCode=0
	s count=0
	s end=start+limit
	
	for{
			s CTTCCode=$o(^TTAB("TC",CTTCCode))
			q:CTTCCode=""  
			s CTTCDesc=$p($g(^TTAB("TC",CTTCCode)),del,1) /// 取描述
 
			if ($ZCONVERT(CTTCDesc,"U")[$ZCONVERT(query,"U")){
			s count=count+1
			if ((count>start) & (count<=end)) || (end=0){
				s AuStr2="{ID:"_CTTCCode_"}"
				if (AuStr[AuStr2) s myEnable=1
				else  s myEnable=0
				
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_CTTCCode_""",""text"":"""_CTTCDesc_""","
				
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
