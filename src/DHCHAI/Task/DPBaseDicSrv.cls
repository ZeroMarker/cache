/// 名称: DHCHAI.Task.DPBaseDicSrv
/// 描述: 系统基础字典相关服务
/// 编写者：zhufei
/// 编写日期: 2017-08-10
Class DHCHAI.Task.DPBaseDicSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-08-10
/// Description:  同步基础信息
/// Table：       DHCHAI.BT.Hospital，DHCHAI.BT.Location，DHCHAI.BT.SysUser
/// Input：		  aHospCode:DHCHAI.BT.Hospital.BTCode
/// 			  aUserID：用户表DHCHAI.BT.SysUser.ID
/// Return：      异常：空、正常：处理数据条数
/// w ##Class(DHCHAI.Task.DPBaseDicSrv).SyncBaseData("HIS02")
ClassMethod SyncBaseData(aSCode As %String) As %String
{
	New (aSCode)
	Set return="",Count=0
	Quit:aSCode="" return
	
	//医院
	Set ret=##Class(DHCHAI.DI.DHS.SyncHisInfo).SyncHospital(aSCode)
	Set:ret>0 Count=Count+ret
	
	Set xHospID=""
	For {
		Set xHospID=$o(^DHCHAI.BT.HospitalD(xHospID))
		Quit:xHospID=""
		
		Set objHosp=##class(DHCHAI.BT.Hospital).GetObjById(xHospID)
		Continue:'$IsObject(objHosp)
		Set XCode=objHosp.BTXCode
		Set aSCode=$p(XCode,"||",1)
		Set HospCode=objHosp.BTCode
		
		//科室
		Set ret=##Class(DHCHAI.DI.DHS.SyncHisInfo).SyncLocation(aSCode,HospCode)
		Set:ret>0 Count=Count+ret
		
		//用户
		Set ret=##Class(DHCHAI.DI.DHS.SyncHisInfo).SyncSSUser(aSCode,HospCode)
		Set:ret>0 Count=Count+ret
		
		//床位
		Set ret=##Class(DHCHAI.DI.DHS.SyncHisInfo).SyncPACBed(aSCode,HospCode)
		Set:ret>0 Count=Count+ret
	}
	Set return=Count
	Quit return
}

}
