Import sqluser

/// 生成药房workload数据,用于服务器任务日志
Class web.DHCSTWORKLOAD Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCSTWORKLOAD).CreateSTWorkLoad()
ClassMethod CreateSTWorkLoad()
{
	///生成药房日报数据
	
	//w ##Class(web.DHCSTDAILYREPROT).CreateDailyReportData()
	
	
	//生成提交日志
	s stdate=+$h
	s enddate=+$h
	f date=stdate:1:enddate d
	.s stkrowid=""
	.f  s stkrowid=$o(^DHCPHSYSTASK(0,"Date",date,stkrowid)) q:stkrowid=""  d
	..s active=$p(^DHCPHSYSTASK(stkrowid),"^",5)
	..q:active'="Y"
	..s sucpno=$p(^DHCPHSYSTASK(stkrowid),"^",6)
	..q:sucpno'="" 	//MaYuqiang 20181113 已生成过点评单的任务不再执行
	..s exestr=$p(^DHCPHSYSTASK(stkrowid),"^",4)
	..s exestr=$tr(exestr,"!","^")
	..s x="s ret="_exestr
	..x x
	..s pcntsno=$p(ret,"^",2)
	..s $p(^DHCPHSYSTASK(stkrowid),"^",6)=pcntsno

	q ""
}

}
