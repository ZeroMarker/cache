/// Description: 标注功能
Class web.DHCSTPIVAS.Remark Extends web.DHCSTPIVAS.Common
{

/// Input: type 
/// 			PIVASOrder - 配伍审核标注医嘱
/// 	   		PIVASExecute - 配伍审核标注配置, 用于配置时显示
/// Debug: w ##class(web.DHCSTPIVAS.Remark).Save("PIVASOrder", "1||2", "你猜", 1)
ClassMethod Save(type, pointer, remark, user)
{
	s curDate = +$h
	s curTime = +$p($h, ",", 2)
	&SQL(
		INSERT INTO BS_PHA_IN.Remark (Type, Pointer, Remark, MarkDate, MarkTime, MarkUser_DR)
		VALUES (:type, :pointer, :remark, :curDate, :curTime, :user)
	)
	q:(SQLCODE '= 0) "-1^保存标注失败, " _ $g(%msg)
	q $g(%ROWID)
}

/// Debug: w ##class(web.DHCSTPIVAS.Remark).Get("PIVASOrder", "1||2")
ClassMethod Get(type, pointer)
{
	s id = $o(^BS.PHA.IN.RemarkI("TypePointer", type, pointer, ""), -1)
	q:(id = "") ""
	q $lg(^BS.PHA.IN.RemarkD(id), 4)
}

}
