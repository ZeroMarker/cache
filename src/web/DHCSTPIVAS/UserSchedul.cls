Import sqluser

/// creator: 	yunhaibao
/// createdate: 2018-08-27
/// description:人员班次日历
Class web.DHCSTPIVAS.UserSchedul Extends %RegisteredObject
{

/// deccription:按配液中心获取人员,默认登录科室以及其他登录科室存在此配液中心的
/// table:      
/// input:		^1:配液中心,^2:姓名模糊条件,^3:月份??
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.UserSchedul","PIVAScheUser","1^^")
Query PIVAScheUser(inputStr = "") As websys.Query(ROWSPEC = "userId,userCode,userName,colorFlag")
{
}

ClassMethod PIVAScheUserExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PivaLocId=$p(inputStr,"^",1)
	q:+PivaLocId=0 $$$OK
	s FilterText=$zcvt($p(inputStr,"^",2),"U")
	s userId=0
	f  s userId=$o(^SSU("SSUSR",userId)) q:userId=""  d
	.s locId=+$p(^SSU("SSUSR",userId),"^",4)
	.i locId=PivaLocId d SetUserIndex
	.q
	.s otherUserId=""
	.f  s otherUserId=$o(^SSU("SSUSR",userId,"OTHLL",otherUserId)) q:otherUserId=""  d
	..s locId=+$p(^SSU("SSUSR",userId,"OTHLL",otherUserId),"^",1)
	..i locId=PivaLocId d SetUserIndex
	s sortIndex=""
	f  s sortIndex=$o(PIVAScheUserData(sortIndex)) q:sortIndex=""  d
	.s mainIndex=""
	.f  s mainIndex=$o(PIVAScheUserData(sortIndex,mainIndex)) q:mainIndex=""  d
	..s outputData=PIVAScheUserData(sortIndex,mainIndex)
	..s Data=$lfs(outputData,"^")
	..s ^CacheTemp(repid,ind)=Data    
	..s ind=ind+1
	q $$$OK
SetUserIndex
	q:$d(PIVAScheUserArr(userId))
	s PIVAScheUserArr(userId)=""
	// 未关联的在中部显示
	s userObj=##class(User.SSUser).%OpenId(userId,0)
	s userCode=userObj.SSUSRInitials
	s userName=userObj.SSUSRName
	s userActive=userObj.SSUSRActive
	s userEndDate=userObj.SSUSRDateTo
	q:(userActive'="Y")
	q:(userEndDate'="")&&(userEndDate<+$h)
	s userPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(userName)
	s quitFlag="1"
	i FilterText'="" d
	.i $zcvt(userCode,"U")[FilterText s quitFlag="" q
	.i $zcvt(userName,"U")[FilterText s quitFlag="" q
	.i $zcvt(userPY,"U")[FilterText s quitFlag="" q
	q:(FilterText'="")&&(quitFlag'="")
	s sortIndex=1,mainIndex=userId,colorFlag=""
	i userPY="" s userPY=userName
	s PIVAScheUserData(userPY,mainIndex)=userId_"^"_userCode_"^"_userName_"^"_colorFlag
	q
}

/// deccription:按日期输出排班明细
/// table:      
/// input:		^1:开始日期,^2:结束日期,^3:配液中心,^4:用户Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.UserSchedul","UserCalenSche","2018-07-29^2018-09-09^101^346")
Query UserCalenSche(inputStr = "") As websys.Query(ROWSPEC = "start,title")
{
}

ClassMethod UserCalenScheExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.UserSchedul","UserCalenSche")=inputStr
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s StartDate=$p(inputStr,"^",1)
	s EndDate=$p(inputStr,"^",2)
	s LocId=$p(inputStr,"^",3)
	q:LocId="" $$$OK
	s UserId=$p(inputStr,"^",4)
	q:UserId="" $$$OK 
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	// 上月,本月,下月
	s StartMonth=$p($zd(StartDate,3),"-",1,2)_"-01"
	s EndMonth=$p($zd(EndDate,3),"-",1,2)_"-01"
	s StartMonth=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartMonth)
	s StPreMonth=$p($zd(StartMonth-1,3),"-",1,2)_"-01"
	s StPreMonth=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StPreMonth)
	s EndMonth=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndMonth)
	b //213
	s psaMonth=StPreMonth
	f  s psaMonth=$o(^Busi.PIVA.ScheArrange(0,"LocMon",LocId,psaMonth)) q:(psaMonth="")||(psaMonth>EndMonth)  d
	.q:+psaMonth=0
	.s psaId=""
	.f  s psaId=$o(^Busi.PIVA.ScheArrange(0,"LocMon",LocId,psaMonth,psaId)) q:psaId=""  d
	..q:+psaId=0
	..s psaItm=""
	..f  s psaItm=$o(^Busi.PIVA.ScheArrange(psaId,"I",psaItm)) q:psaItm=""  d
	...q:+psaItm=0
	...s pasItmData=^Busi.PIVA.ScheArrange(psaId,"I",psaItm)
	...s userId=$p(pasItmData,"^",2)
	...s scheId=$p(pasItmData,"^",3)
	...s scheDate=$p(pasItmData,"^",1)
	...q:(UserId'="")&&(UserId'=userId)
	...s userObj=##class(User.SSUser).%OpenId(userId,0)
	...q:userObj=""
	...s userName=userObj.SSUSRName
	...s scheObj=##class(User.PIVASchedul).%OpenId(scheId,0)
	...q:scheObj=""
	...s scheDesc=scheObj.PSDesc
	...s scheDateHtml=$zd(scheDate,3)
	...s UserCalenScheData(scheDate,scheId)=scheDateHtml_"^"_scheDesc
	s scheDate=""
	f  s scheDate=$o(UserCalenScheData(scheDate)) q:scheDate=""  d
	.s scheId=""
	.f  s scheId=$o(UserCalenScheData(scheDate,scheId)) q:scheId=""  d
	..s data=UserCalenScheData(scheDate,scheId)
	..s ^CacheTemp(repid,ind)=$lfs(data,"^")    
	..s ind=ind+1
	q $$$OK
}

}
