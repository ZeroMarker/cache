/// 发送危急值
Class web.DHCEkg.HX.Method.SendEmergency Extends %RegisteredObject
{

/// 方法说明：	心电推送报告信息
/// 创建者：	杨亚莉
/// 创建时间：	2020-11-12
/// 入参：		医嘱号^检查号^日期时间^审核医生^诊断结论
/// 返回值：	
/// w ##class(web.DHCEkg.HX.Method.SendEmergency).SendEmergency("")
ClassMethod SendEmergency(params As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkg.HX.Method.SendEmergency","SendEmergency",$zd($h,3),$zt($p($h,",",2),1),params,"params")
}

}
