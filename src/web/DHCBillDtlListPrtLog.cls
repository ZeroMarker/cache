Class web.DHCBillDtlListPrtLog Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2018-10-13
/// Description: 保存清单打印日志信息
/// Input: userId: SS_User.RowId, invId:票据RowId
/// Return: 0:成功，<>0:失败
/// Debug: w ##class(web.DHCBillDtlListPrtLog).SavePrtLog("4632","227756:PRT^227755:PRT^227754:PRT#")
ClassMethod SavePrtLog(userId As %String, invStr As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	
	ts
	
	for i=1:1:$l(invStr,"^") {
		set myInvStr=$p(invStr,"^",i)
		continue:(myInvStr="")
		set invId=$p(myInvStr,":",1)
		set invType=$p(myInvStr,":",2)
		set times=..GetPrtTimes(invId, invType)
		set obj=##class(User.DHCBillDtlListPrtLog).%New()
		do obj.DPLUserDRSetObjectId(userId)
		set obj.DPLInvDR=invId
		set obj.DPLInvType=invType
		set obj.DPLPrtTimes=times+1
		set sc=obj.%Save()
		do obj.%Close()
		if ($$$ISERR(sc)) {
			set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2018-10-13
/// Description: 获取打印次数
/// Input: invId:票据RowId, invType:票据类型
/// Return: times:打印次数
/// Debug: w ##class(web.DHCBillDtlListPrtLog).GetPrtTimes(227756, "PRT")
ClassMethod GetPrtTimes(invId As %String, invType As %String) As %String
{
	set times=0
	quit:((invId="")||(invType="")) times
	set rowId=$o(^DHCBillDtlListPrtLogi(0,"InvDR",invType,invId,""),-1)   //取最后一条记录
	quit:(rowId="") times
	set times=$p($g(^DHCBillDtlListPrtLog(rowId)),"^",6)	
	quit times
}

}
