Import SQLUser

/// 检查预约外部接口类
Class web.DHCAPPRepInterFace Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      LiangQiang
/// CreatDate：    2016-06-06
/// Description:： 检查医嘱项是不是基价
/// Table：        DHC_AppArcLinkTar
/// Input：        arc 医嘱项id
/// Output：       Y：是 N：否 
/// w ##class(web.DHCAPPRepInterFace).CheckIsBase("9573||1")
ClassMethod CheckIsBaseOLD(arc) As %Library.String
{
	Q ..GetTarFlagByArcimId(arc)
}

/// Creator  : sufan
/// Descript : 获取基价标志
/// Table    : User.DHCOrderLinkTar 
/// Input    : 医嘱项Id
/// Output   : Y :是 or N ：不是
/// Others   : w ##class(web.DHCAPPRepInterFace).GetTarFlagByArcimId()
ClassMethod GetTarFlagByArcimId(arcimId As %String) As %String
{
	n (arcimId)
	q:arcimId="" ""
	s OltStartDate="",OltRowId="" ,TarFlag="" 	  /// 初始化变量
	f  s OltStartDate=$o(^DHCOLT(0,"ARCIM",arcimId,"Z",OltStartDate))  q:(OltStartDate="")||(TarFlag="Y")  d     /// 循环取开始时间
	.q:OltStartDate>+$H       /// 判断开始日期是否大于当前日期
	.f  s OltRowId=$o(^DHCOLT(0,"ARCIM",arcimId,"Z",OltStartDate,OltRowId))  q:(OltRowId="")||(TarFlag="Y")  d	/// 循环取Id
	..s EndDate=+$p(^DHCOLT(OltRowId),"^",5)
	..Q:(EndDate'=0)&&(EndDate<+$H)			  /// 判断结束日期是否小于当前日期
	..s TarFlag=$p(^DHCOLT(OltRowId),"^",8)   /// 取基价标志
	q TarFlag
}

/// Creator：      bianshuai
/// CreatDate：    2017-04-18
/// Description:： 检查计费是否取检查申请关联收费项目表记录
/// Table：        DHC_AppRepPart
/// Input：        医嘱id
/// Output：       Y：是 N：否 
/// w ##class(web.DHCAPPRepInterFace).CheckIsBase("9573||1")
ClassMethod CheckIsBase(oeori) As %Library.String
{
	n (oeori)
	Q ..IsInvTarItm(oeori)
}

/// Creator：      bianshuai
/// CreatDate：    2016-07-26
/// Descrip：      检查计费是否取检查申请关联收费项目表记录
/// Input：        oeori 医嘱id
/// Output：       Y：是 N：否 
/// w ##class(web.DHCAPPRepInterFace).IsInvExaReqTarItm("15437||24")
ClassMethod IsInvExaReqTarItm(oeori As %String) As %String
{
	n (oeori)
	Q:oeori="" "N"
	s arReqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))    /// 检查申请ID
	Q:arReqID="" "N"
	s CH=$o(^DHCAPREP(0,"OrdItem",oeori,arReqID,"")) /// 检查申请医嘱项Child
	Q:CH="" "N"
	s PartNum=##Class(web.DHCAPPExaReport).GetExaReqPartNum(arReqID,CH)  /// 部位数
	Q:PartNum>0 "Y"
	Q "N"
}

/// Creator：      bianshuai
/// CreatDate：    2017-04-19
/// Descrip：      检查计费是否取检查申请关联收费项目表记录
/// Input：        oeori 医嘱id
/// Output：       Y：是 N：否 
/// w ##class(web.DHCAPPRepInterFace).IsInvTarItm("1219||3")
ClassMethod IsInvTarItm(oeori As %String) As %String
{
	n (oeori)
	Q:oeori="" "N"
	Q:$d(^DHCAPREPTA(0,"OrdItem",oeori)) "Y"
	Q "N"
}

}
