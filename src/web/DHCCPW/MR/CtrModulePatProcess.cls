/// 单个临床路径患者信息处理
Class web.DHCCPW.MR.CtrModulePatProcess Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod ProcessSinglePerson(repid, Paadm, PathWayID, SummaryInfo)
{
		New (repid, Paadm, PathWayID, SummaryInfo)
		Set return=0
		//Set $ZT="ProcessSinglePersonErr"
		//ToDo:以后有啥其他监控的先把Class放到Module目录中，然后在此添加调用
		Set tmp=##class(web.DHCCPW.MR.CtrModuleOrdControl).ProcessOrderControl(repid,PathWayID)
		Set tmp=##class(web.DHCCPW.MR.CtrModuleFeeControl).ProcessFeeControl(repid,PathWayID) //Add By LiYang 2011-04-07 费用监控
		Set tmp=##class(web.DHCCPW.MR.CtrModuleExtraControl).ProcessDaysControl(repid,PathWayID) //Add By LiYang 2011-04-07 入径天数监控
		//下面的程序将校验生成的数据，如果触发监控项目返回1，否则返回0
		Set:$g(^CacheTemp("CPWControl",repid,"paadm",Paadm,"IsFired"))=1 return=1
		
		Quit return
		
ProcessSinglePersonErr
	Kill ^CacheTemp("CPWControl",repid)
	Quit -1
}

}
