Class web.DHCINSUTask Extends %RegisteredObject
{

/// Description:删除指定日期前的日志记录  
/// Input:datebefor 日期yyyy-MM-dd
/// Output:成功: 0 ,失败: 非 0 
/// CreatDate:2019-4-19
ClassMethod deleteHistoricalLog(datebefor As %String = "") As %String
{
	s hdate=+$h-30	;默认删除30天前数据  
	i $g(datebefor)'="" d
	.s hdate=$zdh(datebefor,3)
	s date=hdate	
	f  s date=$o(^DHCINMSGi(0,"Date",date),-1) q:date=""  d
	.s tmprowid=""
	.f  s tmprowid=$o(^DHCINMSGi(0,"Date",date,tmprowid)) q:tmprowid=""  d
	..k ^DHCINMSG(tmprowid,"ALL") ;删除单独保存的Global数据  
	;删除指定日期前的日志记录  
	&sql(DELETE FROM SQLUser.INSU_MSGInfo WHERE INMSG_Date<=:hdate)
	Quit SQLCODE
}

}
