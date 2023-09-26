/// 发送检查状态
Class web.DHCEkg.HX.Method.SendExamStatus Extends %RegisteredObject
{

/// 方法说明：	心电向his发送检查状态
/// 创建者：	杨亚莉
/// 创建时间：	2020-11-12
/// 入参：		OrdId^ExamNo^UserCode^UserName^Status^DateTime
/// 			医嘱号^检查号^用户工号^用户姓名^状态代码^日期时间
/// 返回值：	
/// w ##class(web.DHCEkg.HX.Method.SendExamStatus).SendStatus("")
ClassMethod SendStatus(params As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkg.HX.Method.SendExamStatus","SendStatus",$zd($h,3),$zt($p($h,",",2),1),params,"params")
}

}
