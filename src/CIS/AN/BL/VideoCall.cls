Class CIS.AN.BL.VideoCall Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2019-1-11
/// Description： 	获取视频通话服务端URL
/// Table：        	OperFloor
/// Input:			
/// Return：       	ResultSet
/// w ##class(CIS.AN.BL.VideoCall).GetURL("15390")
ClassMethod GetURL(opsId As %String) As %String
{
	quit:'##class(CIS.AN.OperSchedule).%ExistsId(opsId) "E^手术安排ID错误"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	quit:operSchedule.OperRoom="" "E^手术未安排手术间"
	
	quit:operSchedule.OperRoom.OperFloor="" "E^手术间未设置楼层"
	
	set floorId=operSchedule.OperRoom.OperFloor.%Id()
	set serverId=..GetServerId(floorId)
	quit:serverId="" "E^未找到视频通话服务器配置"
	
	set server=##class(CF.AN.VideoCallServer).%OpenId(serverId)
	
	set url="https://"_server.IPAddress_":"_server.Port_"/"
	quit url
}

/// Creator：      	雍阳
/// CreatDate：    	2019-1-11
/// Description： 	获取视频通话服务端ID
/// Table：        	OperFloor
/// Input:			
/// Return：       	ResultSet
/// w ##class(CIS.AN.BL.VideoCall).GetURL("")
ClassMethod GetServerId(floorId As %String) As %String
{
	set result=$o(^CF.AN.VideoCallServerI("Floor",floorId,""))
	
	quit result
}

}
