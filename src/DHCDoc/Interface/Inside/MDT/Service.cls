/// Creator:郭荣勇
/// date: 2019-07-17
/// description:MDT系统统一封装接口类
Class DHCDoc.Interface.Inside.MDT.Service Extends %RegisteredObject
{

/// 1、排版资源接口(Query FindRBASList)：
///   入参：科室ID
///   出参：时段、号别、总数、已预约数量、地点、预约资源ID(需要能用此ID自动预约挂号)
/// 2、预约挂号接口(OPRegist)：
///   入参：病人ID, 出诊资源ID，用户ID，安全组ID，登录科室ID，登录医院ID
///   出参：预约挂号成功标识
/// 	  注：如果预约挂号后MDT系统需要插入收费医嘱，请MDT系统自行调用发布的标准插入医嘱方法
/// 3、 修改就诊与医嘱日期(ChangeDate):
///   入参：就诊ID，医嘱ID串,新日期
///   出参：修改成功标识(0 成功;其他为失败)
/// 	  注：在MDT系统改约日期时调用
/// -----------------------------------------
/// 4、退号接口(CancelOPRegist)：
///   入参：就诊ID
///   出参：退号成功标识
/// 	  	   注：在MDT系统中取消预约挂号时使用，可同时调用停医嘱接口；如果医嘱已经收费，不可调用停医嘱接口
/// 5、停医嘱(StopOrd)
///   入参：医嘱ID串
///   出参：停医嘱成功标识
/// lxz
/// 提供给新产品MDT预约使用接口
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.MDT.Service","FindRBASList","2570","10073",+$H,+$H+100,"WIN")
Query FindRBASList(AdmLoc As %String, AdmDoc As %String, AmdDateFrom As %String, AdmDateTo As %String, AppMethCode As %String = "", HospitalID As %String = "") As websys.Query(ROWSPEC = "ASRowId:%String,TRRowId:%String,TRDesc:%String,ASDate:%String,AllNum:%String,Usered:%String,CanDo:%String,TRange:%String,DocDesc:%String,WaitingAddress:%String")
{
}

ClassMethod FindRBASListExecute(ByRef qHandle As %Binary, AdmLoc As %String, AdmDoc As %String, AmdDateFrom As %String, AdmDateTo As %String, AppMethCode As %String = "", HospitalID As %String = "") As %Status
{
	q ##class(DHCDoc.Interface.Inside.MDT.ServiceMethod).FindRBASListExecute(.qHandle,AdmLoc,AdmDoc,AmdDateFrom,AdmDateTo,AppMethCode, HospitalID)
}

/// output: (0$返回信息 成功;其他为失败,格式:失败代码$)
ClassMethod OPRegist(PatientID As %String, ASRowId As %String, AdmReason As %String, FeeStr As %String, PayModeCode As %String, UserID As %String, GroupID As %String, LoginLocId As %String, LoginHospId As %String) As %String
{
	q ##class(DHCDoc.Interface.Inside.MDT.ServiceMethod).OPRegist(PatientID,ASRowId,AdmReason,FeeStr,PayModeCode,UserID,GroupID,LoginLocId,LoginHospId)
}

/// output: (0^成功描述 成功;其他为失败,格式:失败代码^失败描述)
ClassMethod ChangeDate(AdmId As %String, OEORIStr As %String, NewRBASId As %String, UserID As %String) As %String
{
	q ##class(DHCDoc.Interface.Inside.MDT.ServiceMethod).ChangeDate(AdmId,OEORIStr,NewRBASId,UserID)
}

/// output: (0^集中打印标识 成功;其他为失败,格式:失败代码^失败描述)
ClassMethod CancelOPRegist(AdmId As %String, UserRowId As %String, GroupRowId As %String, LogonLocRowId As %String, ReturnReasonDr As %String = "", LoginHospId As %String = "") As %String
{
	q ##class(DHCDoc.Interface.Inside.MDT.ServiceMethod).CancelOPRegist(AdmId,UserRowId,GroupRowId,LogonLocRowId,ReturnReasonDr,LoginHospId)
}

/// output: (0 成功;其他为失败,格式:失败代码^失败描述)
ClassMethod StopOrd(OrdList, UserID, ReasonDr As %String = "", ReasonDesc As %String = "") As %String
{
	q ##class(DHCDoc.Interface.Inside.MDT.ServiceMethod).StopOrd(OrdList,UserID,ReasonDr,ReasonDesc)
}

}
