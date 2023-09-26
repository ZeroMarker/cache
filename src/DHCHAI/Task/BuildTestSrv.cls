/// 名称: DHCHAI.Task.BuildTestSrv
/// 描述: 构建测试数据服务
/// 编写者：zhufei
/// 编写日期: 2017-09-30
Class DHCHAI.Task.BuildTestSrv Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCHAI.Task.BuildTestSrv).ChangeHospDic()
ClassMethod ChangeHospDic()
{
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.BT.HospitalD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.BT.Hospital).GetObjById(xID)
		Continue:'$IsObject(obj)
		Set XCode=obj.BTXCode
		Set Code=obj.BTCode
		Set Desc=obj.BTDesc
		Set SCode="HIS01"
		Set HospDr=xID
		
		Set obj=##class(DHCHAI.BT.Hospital).%OpenId(HospDr)
		Set obj.BTXCode		= SCode_"||"_XCode
		Set sc=obj.%Save()
		Do obj.%Close()
		
		Set MapID=""
		Set objMap=##class(DHCHAI.BT.HospitalMap).GetObjByXCode(SCode,XCode)
		Set:$IsObject(objMap) MapID=objMap.%Id()
		Set InputStr=MapID
		Set InputStr=InputStr_"^"_HospDr
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_Desc
		Set InputStr=InputStr_"^"_SCode
		Set InputStr=InputStr_"^"_XCode
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set flg=##class(DHCHAI.BT.HospitalMap).Update(InputStr)
	}
	Quit "OK"
}

/// w ##class(DHCHAI.Task.BuildTestSrv).ChangeLocDic()
ClassMethod ChangeLocDic()
{
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.BT.LocationD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.BT.Location).GetObjById(xID)
		Continue:'$IsObject(obj)
		Set XCode=obj.BTXCode
		Set Code=obj.BTCode
		Set Desc=obj.BTDesc
		Set SCode="HIS01"
		Set LocDr=xID
		
		Set obj=##class(DHCHAI.BT.Location).%OpenId(LocDr)
		Set obj.BTXCode		= SCode_"||"_XCode
		Set sc=obj.%Save()
		Do obj.%Close()
		
		Set MapID=""
		Set objMap=##class(DHCHAI.BT.LocationMap).GetObjByXCode(SCode,XCode)
		Set:$IsObject(objMap) MapID=objMap.%Id()
		Set InputStr=MapID
		Set InputStr=InputStr_"^"_LocDr
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_Desc
		Set InputStr=InputStr_"^"_SCode
		Set InputStr=InputStr_"^"_XCode
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set flg=##class(DHCHAI.BT.LocationMap).Update(InputStr)
	}
	Quit "OK"
}

/// w ##class(DHCHAI.Task.BuildTestSrv).ChangeUserDic()
ClassMethod ChangeUserDic()
{
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.BT.SysUserD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.BT.SysUser).GetObjById(xID)
		Continue:'$IsObject(obj)
		Set XCode=obj.BTXCode
		Set Code=obj.BTCode
		Set Desc=obj.BTDesc
		Set SCode="HIS01"
		Set UserDr=xID
		
		Set obj=##class(DHCHAI.BT.SysUser).%OpenId(UserDr)
		Set obj.BTXCode		= SCode_"||"_XCode
		Set sc=obj.%Save()
		Do obj.%Close()
		
		Set MapID=""
		Set objMap=##class(DHCHAI.BT.SysUserMap).GetObjByXCode(SCode,XCode)
		Set:$IsObject(objMap) MapID=objMap.%Id()
		Set InputStr=MapID
		Set InputStr=InputStr_"^"_UserDr
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_Desc
		Set InputStr=InputStr_"^"_SCode
		Set InputStr=InputStr_"^"_XCode
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set flg=##class(DHCHAI.BT.SysUserMap).Update(InputStr)
	}
	Quit "OK"
}

}
