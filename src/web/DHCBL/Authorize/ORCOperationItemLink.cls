/// 名称:手术关联医嘱项 数据授权
/// 编写者:基础平台组 - 陈莹 
/// 编写日期: 2013-10-15
Class web.DHCBL.Authorize.ORCOperationItemLink Extends web.BDP.sys.ExtPreferences
{

/// w ##class(web.DHCBL.Authorize.ORCOperationItemLink).SaveAuthorizeData("G","1","[{ID:1},{ID:2}]")
/// w ##class(web.DHCBL.Authorize.ORCOperationItemLink).GetTreeJson("menuTreeRoot","G","1")
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "ORC_OperationItemLink";

Parameter EntityClassName = "web.Entity.CT.ORCOperationItemLink";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
	s strAutJson=##class(web.DHCBL.Authorize.ORCOperationItemLink).DHCGetDataByReference(ObjectType,ObjectReference)
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
	s AuStr=##class(web.DHCBL.Authorize.ORCOperationItemLink).DHCGetDataByReference(ObjectType,ObjectReference)				
	
	s OPERRowId=0
	s count=0
	s end=start+limit
	
	for{
		s OPERRowId=$o(^ORC("OPER",OPERRowId)) q:OPERRowId=""
		s LINKChildsub=0
		for
		{
			s LINKChildsub=$o(^ORC("OPER",OPERRowId,"LINK",LINKChildsub)) q:LINKChildsub=""
			s LINKRowId=OPERRowId_"||"_LINKChildsub
			s LINKARCIMDR1=$p($g(^ORC("OPER",OPERRowId,"LINK",LINKChildsub)),"^",1)
			s ARCIMSubscript=$p(LINKARCIMDR1,"||",1),ARCIMVersion=$p(LINKARCIMDR1,"||",2)
			i LINKARCIMDR1'="" s LINKARCIMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
			else  s LINKARCIMDR=""
			s OPERDesc=$p($g(^ORC("OPER",OPERRowId)),"^",2)
		
			s LINK=OPERDesc_"-"_LINKARCIMDR
		
			if ($ZCONVERT(LINK,"U")[$ZCONVERT(query,"U")){
				s count=count+1
				if ((count>start) & (count<=end)) || (end=0){
					s AuStr2="{ID:"_LINKRowId_"}"
					if (AuStr[AuStr2) s myEnable=1
					else  s myEnable=0
				
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s myJsonStr=myJsonStr_"""id"":"""_""_LINKRowId_""",""text"":"""_LINK_""","
				
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
