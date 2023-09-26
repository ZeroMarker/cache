Import sqluser

/// creator: 	yunhaibao
/// createdate: 2018-08-28
/// description:常规休息维护以及存假数据处理
Class web.DHCSTPIVAS.Rest Extends %RegisteredObject
{

/// deccription:按配液中心获取人员,默认登录科室以及其他登录科室存在此配液中心的
/// table:      User.PIVARest
/// input:		^1:配液中心,^2:年份Id,^3:月份,^2:姓名模糊条件
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Rest","PIVARestUser","101^2018^6")
Query PIVARestUser(inputStr = "") As websys.Query(ROWSPEC = "prId,userId,userCode,userName,prRestDays")
{
}

ClassMethod PIVARestUserExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
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
	f  s sortIndex=$o(PIVARestUserData(sortIndex)) q:sortIndex=""  d
	.s mainIndex=""
	.f  s mainIndex=$o(PIVARestUserData(sortIndex,mainIndex)) q:mainIndex=""  d
	..s outputData=PIVARestUserData(sortIndex,mainIndex)
	..s Data=$lfs(outputData,"^")
	..s ^CacheTemp(repid,ind)=Data    
	..s ind=ind+1
	q $$$OK
SetUserIndex
	q:$d(PIVARestUserArr(userId))
	s PIVARestUserArr(userId)=""
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
	s prRestDays =""	// select 无数据时,into 第一个之后后边均为未定义或者为上一个循环的值,注意
	&SQL(
		SELECT 
		PR_RowId,PR_RestDays into :prId,:prRestDays 
		FROM PIVA_Rest
		WHERE PR_Loc_Dr=:PivaLocId  AND PR_Month=:MonthDate AND PR_User_Dr=:userId
	)
	s sortIndex=1
	s mainIndex=userCode
	s PIVARestUserData(sortIndex,userId)=prId_"^"_userId_"^"_userCode_"^"_userName_"^"_prRestDays
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
	s prId=$p(inputStr,"^",1)
	s locId=$p(inputStr,"^",2)
	s userId=$p(inputStr,"^",3)
	s monthDate=$p(inputStr,"^",4)
	s prRestDays=$p(inputStr,"^",5)
	s monthDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(monthDate)
	q:monthDate="" "-1^月份为空"
	//q:prRestDays="" "-1^固定休息天数为空"
	q:locId="" "-1^配液中心为空"
	q:userId="" "-1^用户为空"
	&SQL(SELECT PR_RowId into :tmpPRId FROM PIVA_Rest WHERE PR_Loc_Dr=:locId  AND PR_Month=:monthDate AND PR_User_Dr=:userId)
	i tmpPRId'="" s prId=tmpPRId
	i prId'="" d
	.&SQL(UPDATE PIVA_Rest SET PR_RestDays=:prRestDays WHERE PR_RowId=:prId)
	e  d
	.&SQL(
	 	INSERT INTO PIVA_Rest
	 	(PR_Loc_Dr,PR_User_Dr,PR_Month,PR_RestDays)
	 	VALUES
	 	(:locId,:userId,:monthDate,:prRestDays)	 
	 )
	 q:SQLCODE'=0 "-1^保存失败,SQLCODE:"_SQLCODE_","_$g(%msg)
	 q 0
}

/// description: 保存存假记录,手工增加删除排班时调用,自动排班不会
/// 			 增加计算存假,删除取消存假
/// 			 存在问题,不知道你到底哪天是要休假的呢?
/// input:		 days(1存假加1,-1删除存假),doType(PLUS:增加,MINUS:减少)
/// w ##class(web.DHCSTPIVAS.Rest).SaveRestItm("64865^4^7^11","PLUS")
ClassMethod SaveRestItm(psaItmData, doType)
{
	s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.Rest","SaveRestItm")=$lb(psaItmData, doType)
	q:psaItmData="" ""
	s scheDate=$p(psaItmData,"^",1)	
	s userId=$p(psaItmData,"^",2)
	s scheId=$p(psaItmData,"^",3)
	s dutyId=$p(psaItmData,"^",4)
	s locId=$p(^Code.PIVA.Schedul(scheId),"^",1)
	s scheDateHtml=$zd(scheDate,3)
	s scheMonHtml=$p(scheDateHtml,"-",1,2)_"-01"
	s scheMon=$zdh(scheMonHtml,3)
	s weekEndFlag=##class(web.DHCSTPIVAS.ScheCommon).WeekEnd(scheDate)
	s festFlag=##class(web.DHCSTPIVAS.ScheCommon).FestCanRest(scheDate)
	// todo,目前只判断法定假日以及周末
	q:(weekEndFlag'="Y")&&(festFlag'="Y") ""	
	// 先判断是否存在存假主表
	s prId=""
	&SQL(SELECT PR_RowId into :prId FROM PIVA_Rest WHERE PR_Loc_Dr=:locId  AND PR_Month=:scheMon AND PR_User_Dr=:userId)
	i prId="" d
	.&SQL(
	 	INSERT INTO PIVA_Rest
	 	(PR_Loc_Dr,PR_User_Dr,PR_Month,PR_RestDays)
	 	VALUES
	 	(:locId,:userId,:scheMon,NULL)	 
	 )
	.s prId=$p(%ROWID,$c(1))
	q:prId'>0 "-1^插入存假主表失败"
	i doType="MINUS" d
	.&SQL(DELETE FROM PIVA_RestItm WHERE PRI_Parref=:prId AND PRI_Date=:scheDate)
	e  i doType="PLUS" d
	.&SQL(SELECT * FROM PIVA_RestItm WHERE PRI_Parref=:prId AND PRI_Date=:scheDate)
	.q:SQLCODE=0
	.s maxChild=$o(^Busi.PIVA.Rest(prId,"I",""),-1)+1
	.// 插入子表
	.&SQL(
		INSERT INTO PIVA_RestItm
		(PRI_Parref,PRI_ChildSub,PRI_Date)
		VALUES
		(:prId,:maxChild,:scheDate)	
	 )
	q 0
}

/// deccription:按年获取已排班的人员
/// table:      User.PIVARest
/// input:		^1:配液中心,^2:年份Id,^3:姓名模糊条件
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Rest","RestUser","101^2018^")
Query RestUser(inputStr = "") As websys.Query(ROWSPEC = "userId,userCode,userName,remDays")
{
}

ClassMethod RestUserExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PivaLocId=$p(inputStr,"^",1)
	q:+PivaLocId=0 $$$OK
	s Year=$p(inputStr,"^",2)
	s FilterText=$zcvt($p(inputStr,"^",3),"U")
	q:(Year="") $$$OK
	s i=0
	f i=1:1:12 d
	.s MonthDate=Year_"-"_i_"-01"
	.s MonthDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(MonthDate)
	.s prId=""
	.f  s prId=$o(^Busi.PIVA.Rest(0,"LocMon",PivaLocId,MonthDate,prId)) q:prId=""  d
	..q:+prId=0
	..s prData=^Busi.PIVA.Rest(prId)
	..s userId=$p(prData,"^",2)
	..s userObj=##class(User.SSUser).%OpenId(userId,0)
	..q:userObj=""
	..s userCode=userObj.SSUSRInitials
	..s userName=userObj.SSUSRName
	..s quitFlag="1"
	..i FilterText'="" d
	...i $zcvt(userCode,"U")[FilterText s quitFlag="" q
	...i $zcvt(userName,"U")[FilterText s quitFlag="" q
	...s userPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(userName)
	...i $zcvt(userPY,"U")[FilterText s quitFlag="" q
	..q:(FilterText'="")&&(quitFlag'="")
	..s monRemDays=0
	..&SQL(SELECT count(*) into :monRemDays FROM PIVA_RestItm WHERE PRI_Parref=:prId)
	..i '$d(RestUserData(userId)) d
	...s RestUserData(userId)=userId_"^"_userCode_"^"_userName_"^"_monRemDays
	..e  d
	...s $p(RestUserData(userId),"^",4)=monRemDays+$p(RestUserData(userId),"^",4)
	// 没存假的放在最后
	s userId=""
	f  s userId=$o(RestUserData(userId)) q:userId=""  d
	.s data=RestUserData(userId)
	.s remDays=$p(data,"^",4)
	.s sortIndex=0
	.i +remDays=0 s sortIndex=1
	.s RestUserDataFin(sortIndex,userId)=data
	k RestUserData
	s sortIndex=""
	f  s sortIndex=$o(RestUserDataFin(sortIndex)) q:sortIndex=""  d
	.s mainIndex=""
	.f  s mainIndex=$o(RestUserDataFin(sortIndex,mainIndex)) q:mainIndex=""  d
	..s outputData=RestUserDataFin(sortIndex,mainIndex)
	..s Data=$lfs(outputData,"^")
	..s ^CacheTemp(repid,ind)=Data    
	..s ind=ind+1
	q $$$OK
}

/// deccription:按人员获取某年的存假,按月份输出
/// table:      User.PIVARest
/// input:		^1:配液中心,^2:年份Id,^3:姓名Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Rest","Rest","101^2018^")
Query Rest(inputStr = "") As websys.Query(ROWSPEC = "prId,prMonth,remDays")
{
}

ClassMethod RestExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PivaLocId=$p(inputStr,"^",1)
	s Year=$p(inputStr,"^",2)
	s UserId=$p(inputStr,"^",3)
	q:(+PivaLocId=0)||(+Year=0)||(+UserId=0) $$$OK
	q:(Year="") $$$OK
	s i=0
	f i=1:1:12 d
	.s MonthDate=Year_"-"_i_"-01"
	.s MonthDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(MonthDate)
	.s prId=""
	.f  s prId=$o(^Busi.PIVA.Rest(0,"LocMon",PivaLocId,MonthDate,prId)) q:prId=""  d
	..q:+prId=0
	..s prData=^Busi.PIVA.Rest(prId)
	..s userId=$p(prData,"^",2)
	..q:UserId'=userId
	..s monRemDays=0
	..&SQL(SELECT count(*) into :monRemDays FROM PIVA_RestItm WHERE PRI_Parref=:prId)
	..s Data=$lb(prId,i_"月",monRemDays)
	..s ^CacheTemp(repid,ind)=Data    
	..s ind=ind+1
	q $$$OK
}

/// deccription:按人员获取某年的存假,按日期输出
/// table:      User.PIVARestItm
/// input:		^1:配液中心,^2:年份Id,^3:姓名Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Rest","Rest","101^2018^")
Query RestItm(inputStr = "") As websys.Query(ROWSPEC = "prItmDate")
{
}

ClassMethod RestItmExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.Rest","RestItm")=inputStr
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PivaLocId=$p(inputStr,"^",1)
	s Year=$p(inputStr,"^",2)
	s UserId=$p(inputStr,"^",3)
	s MonthNum=$p(inputStr,"^",4)
	q:(+PivaLocId=0)||(+Year=0)||(+UserId=0) $$$OK
	s i=0
	f i=1:1:12 d
	.q:(MonthNum'="")&&(+MonthNum'=i)
	.s MonthDate=Year_"-"_i_"-01"
	.s MonthDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(MonthDate)
	.s prId=""
	.f  s prId=$o(^Busi.PIVA.Rest(0,"LocMon",PivaLocId,MonthDate,prId)) q:prId=""  d
	..q:+prId=0
	..s prData=^Busi.PIVA.Rest(prId)
	..s userId=$p(prData,"^",2)
	..q:UserId'=userId
	..s prItm=""
	..f  s prItm=$o(^Busi.PIVA.Rest(prId,"I",prItm)) q:prItm=""  d
	...q:+prItm=0
	...s prItmDate=$p(^Busi.PIVA.Rest(prId,"I",prItm),"^",1)
	...s RestItmData(prItmDate)=""
	s prItmDate=""
	f  s prItmDate=$o(RestItmData(prItmDate)) q:prItmDate=""  d
	.s prItmDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(prItmDate)
	.s Data=$lb(prItmDateHtml)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	q $$$OK
}

}
