Import sqluser

/// creator: 	yunhaibao
/// createdate: 2018-07-04
/// description:常规休息维护
Class web.DHCSTPIVAS.LeaveConfig Extends %RegisteredObject
{

/// deccription:按配液中心获取人员,默认登录科室以及其他登录科室存在此配液中心的
/// table:      User.PIVALeaveConfig
/// input:		^1:配液中心,^2:年份Id,^3:月份,^2:姓名模糊条件
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.LeaveConfig","PIVALeaveConfigUser","101^2018^6")
Query PIVALeaveConfigUser(inputStr = "") As websys.Query(ROWSPEC = "plcId,userId,userCode,userName,plcRestDays")
{
}

ClassMethod PIVALeaveConfigUserExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PivaLocId=$p(inputStr,"^",1)
	q:+PivaLocId=0 $$$OK
	s Year=$p(inputStr,"^",2)
	s Month=$p(inputStr,"^",3)
	s FilterText=$zcvt($p(inputStr,"^",4),"U")
	q:(Year="")||(Month="") $$$OK
	s MonthDate=Year_"-"_Month_"-"_"01"
	s MonthDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(MonthDate)
	s userId=0
	f  s userId=$o(^SSU("SSUSR",userId)) q:userId=""  d
	.s locId=+$p(^SSU("SSUSR",userId),"^",4)
	.i locId=PivaLocId d SetUserIndex
	.s otherUserId=""
	.f  s otherUserId=$o(^SSU("SSUSR",userId,"OTHLL",otherUserId)) q:otherUserId=""  d
	..s locId=+$p(^SSU("SSUSR",userId,"OTHLL",otherUserId),"^",1)
	..i locId=PivaLocId d SetUserIndex
	s sortIndex=""
	f  s sortIndex=$o(PIVALeaveConfigUserData(sortIndex)) q:sortIndex=""  d
	.s mainIndex=""
	.f  s mainIndex=$o(PIVALeaveConfigUserData(sortIndex,mainIndex)) q:mainIndex=""  d
	..s outputData=PIVALeaveConfigUserData(sortIndex,mainIndex)
	..s Data=$lfs(outputData,"^")
	..s ^CacheTemp(repid,ind)=Data    
	..s ind=ind+1
	q $$$OK
SetUserIndex
	q:$d(PIVALeaveConfigUserArr(userId))
	s PIVALeaveConfigUserArr(userId)=""
	s userObj=##class(User.SSUser).%OpenId(userId,0)
	s userCode=userObj.SSUSRInitials
	s userName=userObj.SSUSRName
	s quitFlag="1"
	i FilterText'="" d
	.i $zcvt(userCode,"U")[FilterText s quitFlag="" q
	.i $zcvt(userName,"U")[FilterText s quitFlag="" q
	.s userPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(userName)
	.i $zcvt(userPY,"U")[FilterText s quitFlag="" q
	q:(FilterText'="")&&(quitFlag'="")
	s plcRestDays =""	// select 无数据时,into 第一个之后后边均为未定义或者为上一个循环的值,注意
	&SQL(
		SELECT 
		PLC_RowId,PLC_RestDays into :plcId,:plcRestDays 
		FROM PIVA_LeaveConfig 
		WHERE PLC_Loc_Dr=:PivaLocId  AND PLC_Month=:MonthDate AND PLC_User_Dr=:userId
	)
	s sortIndex=1
	s mainIndex=userCode
	s PIVALeaveConfigUserData(sortIndex,userId)=plcId_"^"_userId_"^"_userCode_"^"_userName_"^"_plcRestDays
	q
}

/// description: 批量保存
ClassMethod SaveMulti(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..Save(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// description: 保存
ClassMethod Save(inputStr)
{
	s plcId=$p(inputStr,"^",1)
	s locId=$p(inputStr,"^",2)
	s userId=$p(inputStr,"^",3)
	s monthDate=$p(inputStr,"^",4)
	s plcRestDays=$p(inputStr,"^",5)
	s monthDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(monthDate)
	q:monthDate="" "-1^月份为空"
	//q:plcRestDays="" "-1^固定休息天数为空"
	q:locId="" "-1^配液中心为空"
	q:userId="" "-1^用户为空"
	&SQL(SELECT PLC_RowId into :tmpPlcId FROM PIVA_LeaveConfig WHERE PLC_Loc_Dr=:locId  AND PLC_Month=:monthDate AND PLC_User_Dr=:userId)
	i tmpPlcId'="" s plcId=tmpPlcId
	i plcId'="" d
	.&SQL(UPDATE PIVA_LeaveConfig SET PLC_RestDays=:plcRestDays WHERE PLC_RowId=:plcId)
	e  d
	.&SQL(
	 	INSERT INTO PIVA_LeaveConfig
	 	(PLC_Loc_Dr,PLC_User_Dr,PLC_Month,PLC_RestDays)
	 	VALUES
	 	(:locId,:userId,:monthDate,:plcRestDays)	 
	 )
	 q:SQLCODE'=0 "-1^保存失败,SQLCODE:"_SQLCODE_","_$g(%msg)
	 q 0
}

}
