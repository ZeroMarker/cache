/// 名称:安全组医嘱授权 数据授权
/// 编写者:基础平台组 - 陈莹 
/// 编写日期: 2013-10-15
Class web.DHCBL.Authorize.SSGroupOrderCategory Extends web.BDP.sys.ExtPreferences
{

/// w ##class(web.DHCBL.Authorize.SSGroupOrderCategory).SaveAuthorizeData("G","1","[{ID:1},{ID:2}]")
/// w ##class(web.DHCBL.Authorize.SSGroupOrderCategory).GetTreeJson("menuTreeRoot","G","1")
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "SS_GroupOrderCategory";

Parameter EntityClassName = "web.Entity.CT.SSGroupOrderCategory";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
	s strAutJson=##class(web.DHCBL.Authorize.SSGroupOrderCategory).DHCGetDataByReference(ObjectType,ObjectReference)
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
	s AuStr=##class(web.DHCBL.Authorize.SSGroupOrderCategory).DHCGetDataByReference(ObjectType,ObjectReference)				
	
	s SSGRPRowId=0
	s count=0
	s end=start+limit
	
	for{
		s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId))  q:SSGRPRowId=""
		s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1) //1
		
		s SSORDChildsub=0
		for
		{
			s SSORDChildsub=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)) q:SSORDChildsub=""
			s SSORDRowId=SSGRPRowId_"||"_SSORDChildsub
			s OrdCatDR=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",1)
			i OrdCatDR'="" s SSORDOrdCatDR=$p($g(^OEC("ORCAT",OrdCatDR)),"^",2)
			else  s SSORDOrdCatDR=""	
			s OrdSubCategory=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",5) //输出此项是为了明细里取子类id
			i OrdSubCategory'="" s SSORDOrdSubCategory=$p($g(^ARC("IC",OrdSubCategory)),"^",2)
			else  s SSORDOrdSubCategory=""
		
			s SSORD=SSGRPDesc_"--"_SSORDOrdCatDR_"-"_SSORDOrdSubCategory
			
			if ($ZCONVERT(SSORD,"U")[$ZCONVERT(query,"U")){
				s count=count+1
				if ((count>start) & (count<=end)) || (end=0){
					s AuStr2="{ID:"_SSORDRowId_"}"
					if (AuStr[AuStr2) s myEnable=1
					else  s myEnable=0
					
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s myJsonStr=myJsonStr_"""id"":"""_""_SSORDRowId_""",""text"":"""_SSORD_""","
				
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
	}
	s myJsonStr="{data:["_myJsonStr_"],totalCount:"_count_"}"
	
	q myJsonStr
}

}
