/// 名称:科室-房间分配 数据授权
/// 编写者:基础平台组 - 陈莹 
/// 编写日期: 2013-10-15
Class web.DHCBL.Authorize.PACWardRoom Extends web.BDP.sys.ExtPreferences
{

/// w ##class(web.DHCBL.Authorize.PACWardRoom).SaveAuthorizeData("G","1","[{ID:1},{ID:2}]")
/// w ##class(web.DHCBL.Authorize.PACWardRoom).GetTreeJson("menuTreeRoot","G","1")
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "PAC_WardRoom";

Parameter EntityClassName = "web.Entity.CT.PACWardRoom";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
	s strAutJson=##class(web.DHCBL.Authorize.PACWardRoom).DHCGetDataByReference(ObjectType,ObjectReference)
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
	s AuStr=##class(web.DHCBL.Authorize.PACWardRoom).DHCGetDataByReference(ObjectType,ObjectReference)				
	
	s CTLOCRowID=0
	s count=0
	s end=start+limit
	
	for{
		s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
		s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
		
		s ParRef = $o(^PAWARD(0,"WARD_LocationDR",CTLOCRowID,0))
		s childsub=0
		for
		{
			s childsub=$o(^PAWARD(ParRef,"ROOM",childsub)) q:childsub=""
			s ROOMRowId=ParRef_"||"_childsub
			s ROOMRoomDR=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",1)
			if (ROOMRoomDR'="")
			{
				s ROOMRoomDRCode=$p($g(^PAROOM(ROOMRoomDR)),"^",1)
				s ROOMRoomDRDesc=$p($g(^PAROOM(ROOMRoomDR)),"^",2)
			}
			else
			{
				s ROOMRoomDRCode=""
				s ROOMRoomDRDesc=""
			}		
			s ROOM=CTLOCDesc_"--"_ROOMRoomDRCode_"-"_ROOMRoomDRDesc
		
			if ($ZCONVERT(ROOM,"U")[$ZCONVERT(query,"U")){
				s count=count+1
				if ((count>start) & (count<=end)) || (end=0){
					s AuStr2="{ID:"_ROOMRowId_"}"
					if (AuStr[AuStr2) s myEnable=1
					else  s myEnable=0
				
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s myJsonStr=myJsonStr_"""id"":"""_""_ROOMRowId_""",""text"":"""_ROOM_""","
				
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
