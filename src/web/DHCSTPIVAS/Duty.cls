Import sqluser

/// creator: 	yunhaibao
/// createdate: 2018-06-27
/// description:岗位维护
Class web.DHCSTPIVAS.Duty Extends %RegisteredObject
{

/// deccription:班次列表
/// table:      User.PIVADutyType
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Duty","PIVADuty",101)
Query PIVADuty(inputStr = "") As websys.Query(ROWSPEC = "pdId,pdLocId,pdLocDesc,pdCode,pdDesc,pdShortDesc,pdMinDays,pdMaxDays,pdWeekEndFlag,pdFestivalFlag,pdFestExFlag,pdHolidayFlag,pdFreeFlag")
{
}

ClassMethod PIVADutyExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PivaLocId=$p(inputStr,"^",1)
	q:+PivaLocId=0 $$$OK
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT * FROM PIVA_Duty where PD_RowId>0"
    i PivaLocId'="" s sqlStr=sqlStr_" and PD_Loc_Dr="_"'"_PivaLocId_"'"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s pdId= result.Data("PD_RowId") 
	    s pdLocId= result.Data("PD_Loc_Dr") 
	    s locObj=##class(User.CTLoc).%OpenId(pdLocId,0)
	    s pdLocDesc=locObj.CTLOCDesc
	   	s pdCode= result.Data("PD_Code") 
	    s pdDesc= result.Data("PD_Desc")
	    s pdShortDesc= result.Data("PD_ShortDesc") 
		s pdMinDays=result.Data("PD_MinDays") 
		s pdMaxDays=result.Data("PD_MaxDays") 
		s pdWeekEndFlag=result.Data("PD_WeekEndFlag") 
		s pdFestivalFlag=result.Data("PD_FestivalFlag") 
		s pdFestExFlag=result.Data("PD_FestExFlag") 
		s pdHolidayFlag=result.Data("PD_HolidayFlag")
		s pdFreeFlag=result.Data("PD_FreeFlag")  
        d outputPIVADuty
    }
    d result.Close()
	Quit $$$OK
outputPIVADuty
	s Data=$lb(pdId,pdLocId,pdLocDesc,pdCode,pdDesc,pdShortDesc,pdMinDays,pdMaxDays,pdWeekEndFlag,pdFestivalFlag,pdFestExFlag,pdHolidayFlag,pdFreeFlag)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
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
	s pdId=$p(inputStr,"^",1)
	s pdLocId=$p(inputStr,"^",2)
	s pdCode=$p(inputStr,"^",3)
	s pdDesc=$p(inputStr,"^",4)
	s pdShortDesc=$p(inputStr,"^",5)
	s pdMinDays=$p(inputStr,"^",6)
	i pdMinDays'="" s pdMinDays=+pdMinDays
	s pdMaxDays=$p(inputStr,"^",7)
	i pdMaxDays'="" s pdMaxDays=+pdMaxDays
	s pdWeekEndFlag=$p(inputStr,"^",8)
	s pdFestivalFlag=$p(inputStr,"^",9)
	s pdFestExFlag=$p(inputStr,"^",10)
	s pdHolidayFlag=$p(inputStr,"^",11)
	s pdFreeFlag=$p(inputStr,"^",12)
  	q:pdLocId="" "-1^配液中心不能为空"
  	q:pdCode="" "-1^岗位代码不能为空"
  	q:pdDesc="" "-1^岗位名称不能为空"
  	q:pdShortDesc="" "-1^岗位简称不能为空"
  	s errCode=""
  	i pdId="" d
  	.&SQL(SELECT PD_RowId FROM PIVA_Duty WHERE PD_Code=:pdCode and PD_Loc_Dr=:pdLocId)
  	.i SQLCODE=0 s errCode="-1^代码已存在:"_pdCode q
  	.&SQL(SELECT PD_RowId FROM PIVA_Duty WHERE PD_Desc=:pdDesc and PD_Loc_Dr=:pdLocId)
  	.i SQLCODE=0 s errCode="-1^名称已存在:"_pdDesc q
  	e  d 
  	.&SQL(SELECT PD_RowId FROM PIVA_Duty WHERE PD_Code=:pdCode and PD_Loc_Dr=:pdLocId and PD_RowId!=:pdId)
  	.i SQLCODE=0 s errCode="-1^代码已存在:"_pdCode q
  	.&SQL(SELECT PD_RowId FROM PIVA_Duty WHERE PD_Desc=:pdDesc and PD_Loc_Dr=:pdLocId and PD_RowId!=:pdId)
  	.i SQLCODE=0 s errCode="-1^名称已存在:"_pdDesc q
  	q:errCode'="" errCode
  	i pdId=""  d
  	.&sql(
  		insert into PIVA_Duty
  		(PD_Loc_Dr,PD_Code,PD_Desc,PD_ShortDesc,PD_MinDays,PD_MaxDays,PD_WeekEndFlag,PD_FestivalFlag,PD_FestExFlag,PD_HolidayFlag,PD_FreeFlag) 
  		values 
  		(:pdLocId,:pdCode,:pdDesc,:pdShortDesc,:pdMinDays,:pdMaxDays,:pdWeekEndFlag,:pdFestivalFlag,:pdFestExFlag,:pdHolidayFlag,:pdFreeFlag)
  	  )
  	.i SQLCODE'=0 s errCode="-1^增加失败:"_pdDesc_","_%msg
  	e   d
	.&sql(
		update PIVA_Duty 
		set PD_Loc_Dr=:pdLocId,PD_Code=:pdCode,PD_Desc=:pdDesc,PD_ShortDesc=:pdShortDesc,PD_MinDays=:pdMinDays,
		PD_MaxDays=:pdMaxDays,PD_WeekEndFlag=:pdWeekEndFlag,PD_FestivalFlag=:pdFestivalFlag,PD_FestExFlag=:pdFestExFlag,PD_HolidayFlag=:pdHolidayFlag,PD_FreeFlag=:pdFreeFlag
		where PD_RowId=:pdId  
	 )
	.i SQLCODE'=0 s errCode="-1^修改失败:"_pdDesc_","_$g(%msg)
	q:errCode'="" errCode
	q 0_"^保存成功"
}

/// description: 删除
ClassMethod Delete(pdId)
{
	q:pdId="" "-1^Id为空"
	ts
	&SQL(DELETE FROM PIVA_DutyUser WHERE PDU_Duty_Dr=:pdId)
	&SQL(DELETE FROM PIVA_DutySchedul WHERE PDS_Duty_Dr=:pdId)
	&SQL(delete from PIVA_Duty where PD_RowId=:pdId)
	//q:SQLCODE'=0 "-1^删除失败,SQLCODE:"_SQLCODE - 
	tc
	q 0
}

/// deccription:按配液中心获取人员,默认登录科室以及其他登录科室存在此配液中心的
/// table:      User.PIVADutyType
/// input:		^1:配液中心,^2:岗位Id,^2:姓名模糊条件
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Duty","PIVADutyUser","101^1^4")
Query PIVADutyUser(inputStr = "") As websys.Query(ROWSPEC = "pduId,userId,userCode,userName,colorFlag")
{
}

ClassMethod PIVADutyUserExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PivaLocId=$p(inputStr,"^",1)
	q:+PivaLocId=0 $$$OK
	s DutyId=$p(inputStr,"^",2)
	q:+DutyId=0 $$$OK
	s filterText=$zcvt($p(inputStr,"^",3),"U")
	s userId=0
	f  s userId=$o(^SSU("SSUSR",userId)) q:userId=""  d
	.s locId=+$p(^SSU("SSUSR",userId),"^",4)
	.i locId=PivaLocId d SetUserIndex
	.//s otherUserId=""
	.//f  s otherUserId=$o(^SSU("SSUSR",userId,"OTHLL",otherUserId)) q:otherUserId=""  d
	.//.s locId=+$p(^SSU("SSUSR",userId,"OTHLL",otherUserId),"^",1)
	.//.i locId=PivaLocId d SetUserIndex
	s sortIndex=""
	f  s sortIndex=$o(PIVADutyUserData(sortIndex)) q:sortIndex=""  d
	.s mainIndex=""
	.f  s mainIndex=$o(PIVADutyUserData(sortIndex,mainIndex)) q:mainIndex=""  d
	..s outputData=PIVADutyUserData(sortIndex,mainIndex)
	..s Data=$lfs(outputData,"^")
	..s ^CacheTemp(repid,ind)=Data    
	..s ind=ind+1
	q $$$OK
SetUserIndex
	q:$d(PIVADutyUserArr(userId))
	s PIVADutyUserArr(userId)=""
	// 未关联的在中部显示
	s sortIndex=2
	s pduId=$o(^Config.PIVA.DutyUser(0,"User",userId,""))
	i pduId'="" d
	.s dutyId=$p(^Config.PIVA.DutyUser(pduId),"^",1)
	.i dutyId=DutyId s sortIndex=1		// 关联在本岗位的在顶部显示
	.e  s sortIndex=3					// 关联其他岗位的在底部显示
	i pduId="" s mainIndex=userId
	e  s mainIndex=pduId
	s userObj=##class(User.SSUser).%OpenId(userId,0)
	s userCode=userObj.SSUSRInitials
	s userName=userObj.SSUSRName
	s userActive=userObj.SSUSRActive
	s userEndDate=userObj.SSUSRDateTo
	q:(pduId="")&&(userActive'="Y")
	q:(pduId="")&&(userEndDate'="")&&(userEndDate<+$h)
	s quitFlag="1"
	i filterText'="" d
	.i $zcvt(userCode,"U")[filterText s quitFlag="" q
	.i $zcvt(userName,"U")[filterText s quitFlag="" q
	.s userPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(userName)
	.i $zcvt(userPY,"U")[filterText s quitFlag="" q
	q:(filterText'="")&&(quitFlag'="")
	s colorFlag=sortIndex
	s PIVADutyUserData(sortIndex,mainIndex)=pduId_"^"_userId_"^"_userCode_"^"_userName_"^"_colorFlag
	q
}

/// description: 保存岗位人员关联
ClassMethod SaveDutyUser(inputStr)
{
	s pduId=$p(inputStr,"^",1)
	s pdId=$p(inputStr,"^",2)
	s userId=$p(inputStr,"^",3)
	q:pdId="" "-1^岗位为空"
	q:userId="" "-1^用户为空"
	s locId=##class(User.PIVADuty).%OpenId(pdId,0).PDLocDr
	s errCode=""
	// 取消关联关系
	i pduId'="" d
	.&SQL(DELETE FROM PIVA_DutyUser WHERE PDU_RowId=:pduId)
	e  d
	.&SQL(DELETE FROM PIVA_DutyUser WHERE PDU_User_Dr=:userId and  PDU_Duty_Dr->PD_Loc_Dr=:locId)
	.&SQL(INSERT INTO PIVA_DutyUser(PDU_Duty_Dr,PDU_User_Dr) VALUES (:pdId,:userId))
	i SQLCODE'=0 s errCode="-1^关联失败:"_$g(%msg)
	q:errCode'="" errCode
	q 0
}

/// description: 验证人员关联
/// w ##class(web.DHCSTPIVAS.Duty).CheckDutyUser("13^3^141")
ClassMethod CheckDutyUser(inputStr)
{
	//s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.Duty","CheckDutyUser")=inputStr
	s PDUId=$p(inputStr,"^",1)
	s PDId=$p(inputStr,"^",2)
	s UserId=$p(inputStr,"^",3)
	s LocId=##class(User.PIVADuty).%OpenId(PDId,0).PDLocDr
	&SQL(SELECT PDU_Duty_Dr into :pdId FROM PIVA_DutyUser WHERE PDU_User_Dr=:UserId and PDU_Duty_Dr->PD_Loc_Dr=:LocId)
	q:$g(pdId)="" 0
	s userName=##class(User.SSUser).%OpenId(UserId,0).SSUSRName
	s pdObj=##class(User.PIVADuty).%OpenId(pdId,0)
	s pdDesc=$s(pdObj="":"",1:pdObj.PDDesc)
	q:(PDId'=pdId) "-1^"_userName_"已与"_pdDesc_"关联"
	q 0
}

/// description: 删除岗位前验证岗位相关维护
ClassMethod CheckDuty(pdId)
{
	q:pdId="" "-1^岗位Id为空"
	s errCode=""
	&SQL(SELECT PDU_RowId into :pduId FROM PIVA_DutyUser WHERE PDU_Duty_Dr=:pdId)	
	i pduId'="" s errCode="-1^该岗位已关联人员"
	&SQL(SELECT PDS_RowId into :pdsId FROM PIVA_DutySchedul WHERE PDS_Duty_Dr=:pdId)
	i pdsId'="" s errCode=$s(errCode="":"-1^该岗位已关联班次",1:errCode_"</br>该岗位已关联班次")
	q:errCode'="" errCode
	q 0
}

}
