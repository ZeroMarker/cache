Import SQLUSER

/// 人员班次关联
Class web.DHCSTPIVAS.UserLinkSche Extends %RegisteredObject
{

/// deccription:按配液中心获取人员(按默认登陆科室)
/// input:		^1:配液中心,^2:姓名模糊条件
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.UserLinkSche","PIVAUser","403^")
Query PIVAUser(inputStr = "") As websys.Query(ROWSPEC = "userId,userCode,userName")
{
}

ClassMethod PIVAUserExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PivaLocId=$p(inputStr,"^",1)
	q:+PivaLocId=0 $$$OK
	s filterText=$zcvt($p(inputStr,"^",2),"U")
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
	f  s sortIndex=$o(PIVAUserData(sortIndex)) q:sortIndex=""  d
	.s mainIndex=""
	.f  s mainIndex=$o(PIVAUserData(sortIndex,mainIndex)) q:mainIndex=""  d
	..s outputData=PIVAUserData(sortIndex,mainIndex)
	..s Data=$lfs(outputData,"^")
	..s ^CacheTemp(repid,ind)=Data    
	..s ind=ind+1
	q $$$OK
SetUserIndex
	q:$d(PIVAUserDataArr(userId))
	s PIVAUserDataArr(userId)=""
	s userScheId=$o(^Config.PIVA.UserSchedul(0,"User",userId,""))
	s userObj=##class(User.SSUser).%OpenId(userId,0)
	s userCode=userObj.SSUSRInitials
	s userName=userObj.SSUSRName
	s userActive=userObj.SSUSRActive
	s userStartDate=userObj.SSUSRDateFrom
	s userEndDate=userObj.SSUSRDateTo
	q:(userScheId="")&&(userActive'="Y")
	q:(userScheId="")&&(userStartDate'="")&&(+$h<userStartDate)
	q:(userScheId="")&&(userEndDate'="")&&(+$h>userEndDate)
	s quitFlag="1"
	i filterText'="" d
	.i $zcvt(userCode,"U")[filterText s quitFlag="" q
	.i $zcvt(userName,"U")[filterText s quitFlag="" q
	.s userPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(userName)
	.i $zcvt(userPY,"U")[filterText s quitFlag="" q
	q:(filterText'="")&&(quitFlag'="")
	s sortIndex=userCode
	s mainIndex=userId
	s PIVAUserData(sortIndex,mainIndex)=userId_"^"_userCode_"^"_userName
	q
}

/// deccription:获取人员对应的班次
/// input:		^1:用户Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.UserLinkSche","UserSchedul","13423^M,ME,W,D")
Query UserSchedul(inputStr = "") As websys.Query(ROWSPEC = "pusId,psId,psCode,psDesc,psDuration,pusType,pusTypeDesc,pusDays,pusDaysHtml")
{
}

ClassMethod UserSchedulExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s UserId=$p(inputStr,"^",1)
	q:+UserId=0 $$$OK
	s PUSType=$p(inputStr,"^",2)
	s PSId=$p(inputStr,"^",3)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT * FROM PIVA_UserSchedul WHERE PUS_User_Dr='"_UserId_"'"
    i PSId'="" s sqlStr=sqlStr_" and PUS_Schedul_Dr="_"'"_PSId_"'"
    i PUSType="N" s sqlStr=sqlStr_" and PUS_Type="_"'"_PUSType_"'"
    e  d
    .s sqlStr=sqlStr_" and PUS_Type<>"_"'N'"
    .s sqlStr=sqlStr_" ORDER BY PUS_Schedul_Dr,PUS_Type"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s pusId = result.Data("PUS_RowId") 
        s psId = result.Data("PUS_Schedul_Dr")
        continue:psId=""
		s psObj=##class(User.PIVASchedul).%OpenId(psId,0)
		continue:psObj=""
	   	s psCode= psObj.PSCode
	    s psDesc= psObj.PSDesc
	    s psDuration=psObj.PSDuration
	    s pusType=result.Data("PUS_Type")
	    s pusDays=result.Data("PUS_Days")
	    s daysLen=$l(pusDays,",")
	    s pusDaysHtml=""
	    s i=""
		f i=1:1:daysLen d
		.s tmpDay=$p(pusDays,",",i)
		.s tmpDay=$replace(tmpDay," ","")
		.q:tmpDay=""
		.i pusType="D" s tmpDay=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(tmpDay)
		.e  d
		..s tmpDay="第"_tmpDay_"天"
		.s pusDaysHtml=$s(pusDaysHtml="":tmpDay,1:pusDaysHtml_","_tmpDay)
	    s pusTypeDesc=$s(pusType="M":"每月初",pusType="ME":"每月末",pusType="W":"每周",pusType="D":"指定日期",1:"常规")
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(pusId,psId,psCode,psDesc,psDuration,pusType,pusTypeDesc,pusDays,pusDaysHtml)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:获取配液中心所有班次
/// input:		^1:配液中心Id,^2:用户Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.UserLinkSche","Schedul","403^13423")
Query Schedul(inputStr = "") As websys.Query(ROWSPEC = "psId,psCode,psDesc,psCheck")
{
}

ClassMethod SchedulExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s LocId=$p(inputStr,"^",1)
	q:+LocId=0 $$$OK
	s UserId=$p(inputStr,"^",2)
	q:+UserId=0 $$$OK
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT * FROM PIVA_Schedul WHERE PS_Loc_Dr='"_LocId_"'"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s psId = result.Data("PS_RowId")
        continue:psId=""
	   	s psCode=result.Data("PS_Code")
	    s psDesc=result.Data("PS_Desc")
	    s psCheck=""
	    &SQL(SELECT PUS_RowId FROM PIVA_UserSchedul WHERE PUS_User_Dr=:UserId AND PUS_Schedul_Dr=:psId AND PUS_Type='N')
	    i SQLCODE=0 s psCheck="Y"
        d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(psId,psCode,psDesc,psCheck)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// description: 保存用户班次关联(常规关联)
ClassMethod Save(UserId, PsIdStr)
{
	q:UserId="" "-1^用户Id为空"
	// 先删除
	&SQL(DELETE FROM PIVA_UserSchedul WHERE PUS_User_Dr=:UserId and PUS_Type='N')
	s psLen=$l(PsIdStr,"^")
	s psI=""
	f psI=1:1:psLen d
	.s psId=$p(PsIdStr,"^",psI)
	.q:psId=""
	.&SQL(
		INSERT INTO PIVA_UserSchedul
		(PUS_User_Dr,PUS_Schedul_Dr,PUS_Type,PUS_Days)
		VALUES
		(:UserId,:psId,'N',NULL)
	)
	q 0
}

/// description: 保存固定班次数据
ClassMethod SaveMultiFix(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SaveFix(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// description: 保存固定班次
ClassMethod SaveFix(inputStr)
{
	s pusId=$p(inputStr,"^",1)		// 岗位班次对照Id
	s userId=$p(inputStr,"^",2)		// 岗位Id
	s psId=$p(inputStr,"^",3)		// 班次Id
	s pusType=$p(inputStr,"^",4)	// 对照方式
	s pusDays=$p(inputStr,"^",5)	// 对照方式日期规则
  	q:userId="" "-1^用户不能为空"
  	q:psId="" "-1^班次不能为空"
  	q:pusType="" "-1^对照方式不能为空"
  	s userName=##class(User.SSUser).%OpenId(userId,0).SSUSRName
  	s psDesc=##class(User.PIVASchedul).%OpenId(psId,0).PSDesc
  	s pusDays=##class(web.DHCSTPIVAS.DutySchedul).ChangeDays(pusType,pusDays)
  	q:(pusType'="N")&&(pusDays="") 0
  	s errCode=""
  	i pusId="" d
  	.&SQL(SELECT PUS_RowId FROM PIVA_UserSchedul WHERE PUS_Schedul_Dr=:psId and PUS_User_Dr=:userId and PUS_Type=:pusType)
  	.i SQLCODE=0 s errCode="-1^对照关系已存在:"_userName_"-"_psDesc q
  	e  d 
  	.&SQL(SELECT PUS_RowId FROM PIVA_UserSchedul WHERE PUS_Schedul_Dr=:psId and PUS_User_Dr=:userId and PUS_Type=:pusType and PUS_RowId!=:pusId)
  	.i SQLCODE=0 s errCode="-1^对照关系已存在:"_userName_"-"_psDesc q
  	q:errCode'="" errCode
  	i pusId=""  d
  	.&sql(
  		insert into PIVA_UserSchedul
  		(PUS_User_Dr,PUS_Schedul_Dr,PUS_Type,PUS_Days) 
  		values 
  		(:userId,:psId,:pusType,:pusDays)
  	  )
  	.i SQLCODE'=0 s errCode="-1^增加失败:"_userName_"-"_psDesc_","_%msg
  	e   d
	.&sql(
		update PIVA_UserSchedul 
		set PUS_User_Dr=:userId,PUS_Schedul_Dr=:psId,PUS_Type=:pusType,PUS_Days=:pusDays
		where PUS_RowId=:pusId  
	 )
	.i SQLCODE'=0 s errCode="-1^修改失败:"_userName_"-"_psDesc_","_$g(%msg)
	q:errCode'="" errCode
	q 0_"^保存成功"
}

/// description: 删除
ClassMethod Delete(PusId)
{
	q:PusId="" "-1^Id为空"
	&sql(delete from PIVA_UserSchedul where PUS_RowId=:PusId)
	q:SQLCODE'=0 "-1^删除失败,SQLCODE:"_SQLCODE
	q 0
}

/// deccription:获取某配液中心某人的休假日期
/// input:		^1:配液中心Id,^2:用户Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.UserLinkSche","UserScheDate","219^13310")
Query UserScheDate(inputStr = "") As websys.Query(ROWSPEC = "pusRowId,userStDate,Days")
{
}

ClassMethod UserScheDateExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s LocId=$p(inputStr,"^",1)
	q:+LocId=0 $$$OK
	s UserId=$p(inputStr,"^",2)
	q:+UserId=0 $$$OK
	s pusRowId=""
	f  s pusRowId=$o(^DHCST.PIVA.User(0,"LOC",LocId,UserId,pusRowId)) q:(pusRowId="")  d
	.s userStDate=$p(^DHCST.PIVA.User(pusRowId),"^",3)
	.s userStDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(userStDate,"PIVA")
	.q:(userStDate="")
    .s Days=$p(^DHCST.PIVA.User(pusRowId),"^",4)
    .d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(pusRowId,userStDate,Days)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// description: 保存人员休班日期
/// w ##class(web.DHCSTPIVAS.UserLinkSche).SaveUserDate("403^13429^2019-08-08^8")
ClassMethod SaveUserDate(inputStr)
{
	s locId=$p(inputStr,"^",1)		// 科室
	s userId=$p(inputStr,"^",2)		// 人员
	s date=$p(inputStr,"^",3)		// 开始日期
	s date=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(date)
	s days=$p(inputStr,"^",4)	    // 天数
  	q:userId="" "-1^用户不能为空"
  	q:locId="" "-1^科室不能为空"
  	q:date="" "-1^日期不能为空"
  	q:days="" "-1^天数不能为空"
  	q:$ISVALIDNUM(days)'=1 "-1^间隔天数必须是数字"
  	q:days<0 "-1^间隔天数不能为负数"
  	s errCode=""
  	s userFlag=0
  	&SQL(SELECT PUS_RowId FROM PIVA_User WHERE PUS_Loc_Dr=:locId and PUS_User_Dr=:userId)
  	i SQLCODE=0 s userFlag=1
  	i userFlag=0  d
  	.&sql(
  		insert into PIVA_User
  		(PUS_User_Dr,PUS_Loc_Dr,PUS_UserStDate,PUS_UserDays) 
  		values 
  		(:userId,:locId,:date,:days)
  	  )
  	.i SQLCODE'=0 s errCode="-1^保存失败:"_%msg
  	e   d
	.&sql(
		update PIVA_User 
		set PUS_UserStDate=:date,PUS_UserDays=:days
		WHERE PUS_Loc_Dr=:locId and PUS_User_Dr=:userId 
	 )
	.i SQLCODE'=0 s errCode="-1^保存失败:"_$g(%msg)
	q:errCode'="" errCode
	q 0_"^保存成功"
}

/// description: 删除人员休班日期
/// w ##class(web.DHCSTPIVAS.UserLinkSche).DeleteUserDate(2)
ClassMethod DeleteUserDate(PusId)
{
  	q:PusId="" "-1^ID不能为空"
  	s errCode=""
  	&sql(
		update PIVA_User 
		set PUS_UserStDate=NUll,PUS_UserDays=NUll
		WHERE PUS_RowId=:PusId
	 )
	i SQLCODE'=0 s errCode="-1^删除失败:"_$g(%msg)
	q:errCode'="" errCode
	q 0_"^删除成功"
}

}
