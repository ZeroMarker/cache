Import sqluser

/// creator: 	yunhaibao
/// createdate: 2018-07-04
/// description:请假管理
Class web.DHCSTPIVAS.Leave Extends %RegisteredObject
{

/// deccription:请假列表
/// input:		^1:配液中心Id,^2:人员Id,^3:状态(-1,0,1,2),^4:请假类型
/// table:      User.PIVALeave
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Leave","PIVALeave","101^711")
Query PIVALeave(inputStr = "") As websys.Query(ROWSPEC = "plId,plLocId,plUserId,plUser,plLeaveTypeId,plLeaveType,plReason,plStDate,plEdDate,plDateTime,plAuditUserId,plAuditUser,plAuditDateTime,plFinishUserId,plFinishUser,plFinishDateTime,plStatus")
{
}

ClassMethod PIVALeaveExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	//s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.Leave","PIVALeave")=inputStr
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s LocId=$p(inputStr,"^",1)
	s UserId=$p(inputStr,"^",2)
	s Status=$p(inputStr,"^",3)
	s LeaveTypeId=$p(inputStr,"^",4)
	q:+LocId=0 $$$OK
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT * FROM PIVA_Leave where PL_RowId>0 and PL_Loc_Dr="_"'"_LocId_"'"  
    i UserId'="" d
    .s sqlStr=sqlStr_" and PL_User_Dr="_"'"_UserId_"'"
    i Status'="" d
    .s sqlStr=sqlStr_" and PL_Status="_"'"_Status_"'"
    i LeaveTypeId'="" d
    .s sqlStr=sqlStr_" and PL_LeaveType_Dr="_"'"_LeaveTypeId_"'"
    i sqlStr'["ORDER" s sqlStr=sqlStr_" ORDER BY PL_RowId DESC"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s plId=result.Data("PL_RowId") 
	    s plLocId=result.Data("PL_Loc_Dr") 
	    s plUserId=result.Data("PL_User_Dr") 
	    s plUser=##class(User.SSUser).%OpenId(plUserId,0)
	    i plUser'="" s plUser=plUser.SSUSRName
	    s plLeaveTypeId=result.Data("PL_LeaveType_Dr") 
	    s plLeaveType=##class(User.PIVALeaveType).%OpenId(plLeaveTypeId,0)
	    i plLeaveType'="" s plLeaveType=plLeaveType.PLTDesc
	    s plReason=result.Data("PL_Reason") 
	    s plStDate=result.Data("PL_StartDate") 
	    s plStDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(plStDate)
	    s plEdDate=result.Data("PL_EndDate") 
	    s plEdDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(plEdDate)
	    s plDate=result.Data("PL_Date") 
	    s plDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(plDate)
	    s plTime=result.Data("PL_Time") 
	    s plTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(plTime)
	    s plAuditUserId=result.Data("PL_AuditUser_Dr") 
	    s plAuditUser=$s(plAuditUserId="":"",1:##class(User.SSUser).%OpenId(plAuditUserId,0).SSUSRName)
	    s plAuditDate=result.Data("PL_AuditDate") 
	    s plAuditDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(plAuditDate)
	    s plAuditTime=result.Data("PL_AuditTime") 
	    s plAuditTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(plAuditTime)
	    s plFinishUserId=result.Data("PL_FinishUser_Dr") 
	    s plFinishUser=$s(plFinishUserId="":"",1:##class(User.SSUser).%OpenId(plFinishUserId,0).SSUSRName)
	    s plFinishDate=result.Data("PL_FinishDate") 
	    s plFinishDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(plFinishDate)
	    s plFinishTime=result.Data("PL_FinishTime") 
	    s plFinishTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(plFinishTime)
	    s plStatus=result.Data("PL_Status") 
	    s plStatus=$s(plStatus=0:"未审核",plStatus=1:"已审核",plStatus=2:"已完成",plStatus=-1:"已拒绝",1:"")
	    s plDateTime=plDate_" "_plTime
	    s plAuditDateTime=plAuditDate_" "_plAuditTime
	    s plFinishDateTime=plFinishDate_" "_plFinishTime
        d outputrow
    }
    d result.Close()
	Quit $$$OK
outputrow
	s Data=$lb(plId,plLocId,plUserId,plUser,plLeaveTypeId,plLeaveType,plReason,plStDate,plEdDate,plDateTime,plAuditUserId,plAuditUser,plAuditDateTime,plFinishUserId,plFinishUser,plFinishDateTime,plStatus)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// description: 保存
/// w ##class(web.DHCSTPIVAS.Leave).Save("^101^1")
ClassMethod Save(inputStr)
{
	s $zt="ThrowSave"
	s chkRet=..CheckSave(inputStr)
	q:+$p(chkRet,"^",1)<0 chkRet
	s errCode=""
	s plId=$p(inputStr,"^",1)
	s plLocId=$p(inputStr,"^",2)
	s plUserId=$p(inputStr,"^",3)
	s plLeaveTypeId=$p(inputStr,"^",4)
	s plStDate=$p(inputStr,"^",5)
	s plEdDate=$p(inputStr,"^",6)
	s plReason=$p(inputStr,"^",7)
	s plStDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(plStDate)
	s plEdDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(plEdDate)
	i plId'="" d
	.s plObj=##class(User.PIVALeave).%OpenId(plId)
	.s curStatus=plObj.PLStatus
	.i curStatus>0 s errCode="-1^已审核,无法编辑"
	.d plObj.%Reload()
	e  d
	.s plObj=##class(User.PIVALeave).%New()
	q:errCode'="" errCode
	s plObj.PLLocDr=##class(User.CTLoc).%OpenId(plLocId,0)
	s plObj.PLUserDr=##class(User.SSUser).%OpenId(plUserId,0)
	s plObj.PLLeaveTypeDr=##class(User.PIVALeaveType).%OpenId(plLeaveTypeId,0)
	s plObj.PLDate=+$h
	s plObj.PLTime=$p($h,",",2)
	s plObj.PLStartDate=plStDate
	s plObj.PLEndDate=plEdDate
	s plObj.PLStatus=0
	s plObj.PLReason=plReason
	s sc=plObj.%Save()
	i $$$ISERR(sc) d
	.s errInfo=$System.Status.GetErrorText(sc)
	.d ErrorRecord^DHCSTERROR("配液中心请假管理","web.DHCSTPIVAS.Leave:Save",errinfo)
	.s errCode="-1^"_errInfo
	q:errCode'="" errCode
	q 0
ThrowSave
	d ErrorRecord^DHCSTERROR("配液中心请假管理","web.DHCSTPIVAS.Leave:Save",$ze)
	q -2_"^"_$replace($ze,"^","")
}

/// description: 更新状态
ClassMethod UpdateStatus(plId, userId, status)
{
	q:+plId=0 "-1^获取不到请假Id"
	q:+userId=0 "-1^获取不到用户Id"
	q:status="" "-1^获取不到状态"
	q:(+status>2)||(+status<-1) "-1^状态错误"
	s plObj=##class(User.PIVALeave).%OpenId(plId,0)
	s curStatus=plObj.PLStatus
	q:(curStatus=2) "-1^已完成休假,无法修改"
	// 审批后可随时拒绝
	s curDate=+$h
	s curTime=$p($h,",",2)
	i status=2 d
	.// 完成
	.&SQL(
		UPDATE PIVA_Leave 
		SET PL_FinishUser_Dr=:userId,PL_FinishDate=:curDate,PL_FinishTime=:curTime,PL_Status=:status 
		WHERE PL_RowId=:plId
	 )
	e  d
	.// 审核
	.&SQL(
		UPDATE PIVA_Leave 
		SET PL_AuditUser_Dr=:userId,PL_AuditDate=:curDate,PL_AuditTime=:curTime,PL_Status=:status 
		WHERE PL_RowId=:plId
	 )
	q:SQLCODE'=0 "-1^更新失败,错误信息:"_$g(%msg)
	q 0
}

/// description: 删除请假
ClassMethod Delete(plId)
{
	q:+plId=0 "-1^请假Id为空"
	s plObj=##class(User.PIVALeave).%OpenId(plId,0)
	s plStatus=plObj.PLStatus
	q:plStatus=1 "-1^已审核,无法删除"
	q:plStatus=2 "-1^已完成,无法删除"
	q:plStatus>0 "-1^该状态无法删除"
	&SQL(DELETE FROM PIVA_Leave WHERE PL_RowId=:plId)
	q:SQLCODE'=0 "-1^删除失败,SQLCODE:"_SQLCODE
	q 0
}

/// Description: 保存前验证
ClassMethod CheckSave(inputStr)
{
	s plId=$p(inputStr,"^",1)
	s plLocId=$p(inputStr,"^",2)
	s plUserId=$p(inputStr,"^",3)
	s plLeaveTypeId=$p(inputStr,"^",4)
	s plStDate=$p(inputStr,"^",5)
	s plEdDate=$p(inputStr,"^",6)
	s plReason=$p(inputStr,"^",7)
	s plStDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(plStDate)
	s plEdDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(plEdDate)
  	q:plLocId="" "-1^获取不到登陆科室Id"
  	q:plUserId="" "-1^获取不到用户Id"
  	q:plLeaveTypeId="" "-1^请假类型为空"
	q:plStDate="" "-1^开始日期为空"
	q:plEdDate="" "-1^结束日期为空"
	q:plReason="" "-1^请假原因为空"
	q:plEdDate<plStDate "-1^开始日期大于结束日期"
	s dateRange=plEdDate-plStDate+1
	s leaveMaxDay=$p($g(^Code.PIVA.LeaveType(plLeaveTypeId)),"^",2)
	q:(leaveMaxDay'="")&&(dateRange>+leaveMaxDay) "-1^"_$p($g(^Code.PIVA.LeaveType(plLeaveTypeId)),"^",1)_"可申请最大天数为"_leaveMaxDay_"天"
	// 验证是否日期冲突
	s chkInfo=""
	s stDate=plStDate-1
	f  s stDate=$o(^Busi.PIVA.Leave(0,"LocUseStDate",plLocId,plUserId,stDate)) q:(stDate="")||(chkInfo'="")  d
	.q:+stDate=0
	.s id=""
	.f  s id=$o(^Busi.PIVA.Leave(0,"LocUseStDate",plLocId,plUserId,stDate,id)) q:(id="")||(chkInfo'="")  d
	..q:+id=0
	..q:(plId'="")&&(plId=id)
	..s leaveData=^Busi.PIVA.Leave(id)
	..s leaveStDate=$p(leaveData,"^",5)
	..s leaveEdDate=$p(leaveData,"^",6)
	..s inFlag=""
	..// 包含
	..i (plStDate<leaveStDate)&&(plEdDate>leaveEdDate) s inFlag=1
	..e  d
	...i (plStDate>=leaveStDate)&&(leaveStDate<=leaveEdDate) s inFlag=1 q
	...i (plEdDate>=leaveStDate)&&(leaveEdDate<=leaveEdDate) s inFlag=1 q
	..i inFlag'="" d
	...s leaveStDateH=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(leaveStDate)
	...s leaveEdDateH=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(leaveEdDate)
	...s chkInfo="-1^"_leaveStDateH_"至"_leaveEdDateH_"已请"_$p($g(^Code.PIVA.LeaveType(+$p(leaveData,"^",3))),"^",1)
	.
	q:chkInfo'="" chkInfo
	q 0
}

}
