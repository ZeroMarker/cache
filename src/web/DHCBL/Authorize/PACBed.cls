/// 名称:科室-病区床位 数据授权
/// 编写者:基础平台组 - 陈莹 
/// 编写日期: 2013-10-15
Class web.DHCBL.Authorize.PACBed Extends web.BDP.sys.ExtPreferences
{

/// w ##class(web.DHCBL.Authorize.PACBed).SaveAuthorizeData("G","1","[{ID:1},{ID:2}]")
/// w ##class(web.DHCBL.Authorize.PACBed).GetTreeJson("menuTreeRoot","G","1")
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "PAC_Bed";

Parameter EntityClassName = "web.Entity.CT.PACBed";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
	s strAutJson=##class(web.DHCBL.Authorize.PACBed).DHCGetDataByReference(ObjectType,ObjectReference)
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
	s AuStr=##class(web.DHCBL.Authorize.PACBed).DHCGetDataByReference(ObjectType,ObjectReference)				
	
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
			s childsub=$o(^PAWARD(ParRef,"BED",childsub)) q:childsub=""
			s BEDRowID=ParRef_"||"_childsub
			s BEDRoomDR=$p($g(^PAWARD(ParRef,"BED",childsub)),"^",3)
			if (BEDRoomDR'="")
			{
				s BEDRoomDR=$p($g(^PAROOM(BEDRoomDR)),"^",2)
			}
			else
			{
				s BEDRoomDR=""
			}
			s BEDCode=$p($g(^PAWARD(ParRef,"BED",childsub)),"^",1)
			s BEDBedTypeDR=$p($g(^PAWARD(ParRef,"BED",childsub)),"^",2)
			if (BEDBedTypeDR'="")
			{
				s BEDBedTypeDR=$p($g(^PAC("BEDTP",BEDBedTypeDR)),"^",2)
			}
			else
			{
				s BEDBedTypeDR=""
			}
			s BED=CTLOCDesc_"--"_BEDCode_"-"_BEDBedTypeDR_"-"_BEDRoomDR
		
			if ($ZCONVERT(BED,"U")[$ZCONVERT(query,"U")){
				s count=count+1
				if ((count>start) & (count<=end)) || (end=0){
					s AuStr2="{ID:"_BEDRowID_"}"
					if (AuStr[AuStr2) s myEnable=1
					else  s myEnable=0
				
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s myJsonStr=myJsonStr_"""id"":"""_""_BEDRowID_""",""text"":"""_BED_""","
				
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
