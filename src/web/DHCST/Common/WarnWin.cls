Import sqluser

/// Descript:   提醒窗口相关（写于长治二院）
/// Creator:    hulihua
/// CreateDate: 2014-11-20
Class web.DHCST.Common.WarnWin Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTWARNWIN";

/// Descript:	取窗口提示各属性参数值
/// Creator:	hulihua
/// CreateDate: 2014-11-20
/// Table:
/// Input:		安全组id,科室id,用户id
/// Output:		
/// Return:		提示间隔(分)^重复次数^自动隐藏时间(秒)
/// w ##class(web.DHCST.Common.WarnWin).GetParamProp("1","102","1")
ClassMethod GetParamProp(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    n (GroupId,LocId,UserId)
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCST.Common.WarnWin).%GetParameter("AppName")
    s minutes=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"Minutes",Param)
    s repeat=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"Repeat",Param)
    s autohidetime=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"AutoHideTime",Param)
    s:minutes="" minutes=10   ///默认为十分钟
    s:autohidetime="" autohidetime=5  //默认5秒钟自动隐藏
    s Data=minutes_"^"_repeat_"^"_autohidetime
    q Data
}

/// Descript:	获取提示窗口显示内容
/// Creator:	hulihua
/// CreateDate: 2014-11-20
/// Table:
/// Input:		安全组id,科室id,用户id
/// Output:		
/// Return:     提醒的数据串RetStr
/// Others:     <br> html 换行符
/// w ##class(web.DHCST.Common.WarnWin).GetWarns("1","102","1")		
ClassMethod GetWarns(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    n (GroupId,LocId,UserId)
    s Ret=""
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCST.Common.WarnWin).%GetParameter("AppName")
    s WarnStr=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"WarnStr",Param)
    s StartDate=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"StartDate",Param)
    s EndDate=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"EndDate",Param)
    s StartDate=(+$H+StartDate)
    s EndDate=(+$H+EndDate)
    s Ret=..GetWarnsDetail(WarnStr,StartDate,EndDate,LocId)
    q Ret
}

/// Descript:   实现药房药库各个界面右下角待处理信息的提示
/// Creator:    hulihua
/// CreateDate: 2014-11-20
/// Table:      DHC_INGdRec,DHC_INIsTrf,DHC_INGDRET,in_request,dhc_inrequest
/// Input:      WarnStr-提醒类型,StartDate-提醒开始日期,EndDate-提醒截至日期,LocId-当前登录科室ID
/// Output:     
/// Return：    提醒的数据串RetStr 
ClassMethod GetWarnsDetail(WarnStr As %String, StartDate As %String, EndDate As %String, LocId As %String) As %Library.String
{
	n (WarnStr,StartDate,EndDate,LocId)

	s RetStr=""
	s State1="N"
	s State2="31"
	s State3="21"
	s recStr="",retStr="",reqStr="",TrfStr="",NoRecStr="",OpNoRecStr=""
	s StkType=##class(web.DHCST.StkTypeG).sssCode()
	//入库单
	i (WarnStr["G")  d
	.s reccount=0	
	.&sql(select count(*) into :reccount from DHC_INGdRec 
	where INGR_Loc_Dr=:LocId and INGR_AuditFlag=:State1 and INGR_StkType=:StkType 
	and INGR_CreateDate between :StartDate and :EndDate)
	.q:SQLCODE'=0
	.s recStr=""
	.s:reccount'=0 recStr="　您有 <b><font color=#15428b size=4 >"_reccount_" </font></b>张<b><font color=#15428b size=2 ><a href=dhcst.ingdrec.csp>入库单</a></font></b>等待处理！<br>"
	//退货单
	i (WarnStr["R")  d
	.s retcount=0	
	.&sql(select count(*) into :retcount from DHC_INGDRET 
	where INGRT_CTLOC_DR=:LocId and INGRT_AuditFlag is NULL and INGRT_StkType=:StkType 
	and INGRT_DATE between :StartDate and :EndDate)
	.q:SQLCODE'=0
	.s retStr=""
	.s:retcount'=0 retStr="　您有 <b><font color=#15428b size=4 >"_retcount_" </font></b>张<b><font color=#15428b size=2 ><a href=dhcst.ingdret.csp>退货单</a></font></b>等待处理！<br>"
	//出库单
    i (WarnStr["T")  d
	.s trfcount=0	
	.&sql(select count(*) into :trfcount from DHC_INIsTrf 
	where INIT_FrLoc_DR=:LocId and INIT_State!=:State2 and INIT_State!=:State3 and INIT_StkType=:StkType
	and init_date between :StartDate and :EndDate)
	.q:SQLCODE'=0
	.s TrfStr=""
	.s:trfcount'=0 TrfStr="　您有 <b><font color=#15428b size=4 >"_trfcount_" </font></b>张<b><font color=#15428b size=2 ><a href=dhcst.dhcinistrfoutaudit.csp>出库单</a></font></b>等待处理！<br>"
	//转移单未接收
	i (WarnStr["K")  d
	.s noreccount=0	
	.&sql(select count(*) into :noreccount from DHC_INIsTrf 
	where INIT_ToLoc_DR=:LocId and INIT_State=:State3 and INIT_StkType=:StkType
	and init_date between :StartDate and :EndDate)
	.q:SQLCODE'=0
	.s NoRecStr=""
	.s:noreccount'=0 NoRecStr="　您有 <b><font color=#15428b size=4 >"_noreccount_" </font></b>张<b><font color=#15428b size=2 ><a href=dhcst.dhcinistrfinaudit.csp>库存转移单</a></font></b>未接收！<br>"
	//库存请求单
	i (WarnStr["B") d
	.s reqcount=0
	.&sql( declare B cursor for 
		select a.%ID from in_request a join dhc_inrequest b on a.INRQ_RowId=b.INRQ_INRQ_DR
		where inrq_date between :StartDate and :EndDate and inrq_reqloc_dr=:LocId 
		and INRQ_Status='O' and inrq_usercompleted='Y'
	)
	.&sql(open B)
	.f  &sql(fetch B into :req) q:SQLCODE  d
	..q:(##class(web.DHCST.DHCINIsTrf).TransferStatus(req)=2)
	..s stkcg="",INRQRowId=""
	..s INRQRowId=$o(^DHCINRQ(0,"INRQ",req,INRQRowId))
    ..i INRQRowId'="" d
    ...s INRQSCGDR=$p(^DHCINRQ(INRQRowId),"^",10)
    ...s inrqtype=$p(^DHCINRQ(INRQRowId),"^",1)
    ...s:INRQSCGDR'="" stkcg=$p($G(^DHCSCG(INRQSCGDR)),"^",3)
    ..q:(stkcg'="")&&(stkcg'=StkType)
    ..s itm=0,cnt=0       //此处过滤全部作废的
    ..f  s itm=$o(^INRQ(req,"RQI",itm)) q:(itm="")||(cnt'=0)  d
    ...s refuse=$p(^INRQ(req,"RQI",itm),"^",6)
    ...i refuse'="Y" s cnt=cnt+1
    ...
    ..q:cnt=0
	..s reqcount=+reqcount+1
	.&sql(close	B)
	.s reqStr=""
	.s:reqcount'=0 reqStr="　您有 <b><font color=#15428b size=4 >"_reqcount_" </font></b>张<b><font color=#15428b size=2 ><a href=dhcst.dhcinistrf.csp>请求单</a></font></b>等待处理！<br>"
	//转移单对方未接收
	i (WarnStr["A")  d
	.s opnoreccount=0	
	.&sql(select count(*) into :opnoreccount from DHC_INIsTrf 
	where INIT_FrLoc_DR=:LocId and INIT_State=:State3 and INIT_StkType=:StkType
	and init_date between :StartDate and :EndDate)
	.q:SQLCODE'=0
	.s OpNoRecStr=""
	.s:opnoreccount'=0 OpNoRecStr="　您的 <b><font color=#15428b size=4 >"_opnoreccount_" </font></b>张<b><font color=#15428b size=2 ><a href=dhcst.dhcinistrfinaudit.csp>出库单</a></font></b>对方未接收！<br>"
	s RetStr=recStr_retStr_reqStr_TrfStr_OpNoRecStr_NoRecStr
	q RetStr
}

}
