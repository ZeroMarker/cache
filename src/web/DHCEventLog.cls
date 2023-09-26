Class web.DHCEventLog Extends (%RegisteredObject, websys.Abstract)
{

ClassMethod InitData()
{
	&sql(insert into SQLUser.DHC_AuditStatus (Status_Code,Status_Desc) values('EvilLogin','恶意登录'))
	&sql(insert into SQLUser.DHC_AuditStatus (Status_Code,Status_Desc) values('RepeatPrint','重复打印'))
	&sql(insert into SQLUser.DHC_AuditStatus (Status_Code,Status_Desc) values('RepeatQuery','重复查询'))
	&sql(insert into SQLUser.DHC_AuditStatus (Status_Code,Status_Desc) values('RepeatView','重复预览'))
	&sql(insert into SQLUser.DHC_AuditStatus (Status_Code,Status_Desc) values('Normal','正常操作'))
	
	&sql(insert into SQLUser.DHC_EventModel (Model_Code,Model_Desc,Model_Active,Model_Type,Model_Note) values('LOGIN','登录','Y','L','基础平台'))
	
	&sql(insert into SQLUser.DHC_SecretLevel (Level_Code,Level_Desc,Level_Alias) values('1005','秘密','III'))
	&sql(insert into SQLUser.DHC_SecretLevel (Level_Code,Level_Desc,Level_Alias) values('1004','机密','II'))
	&sql(insert into SQLUser.DHC_SecretLevel (Level_Code,Level_Desc,Level_Alias) values('1000','一般','I'))
	&sql(insert into SQLUser.DHC_SecretLevel (Level_Code,Level_Desc,Level_Alias) values('0001','不涉密',' '))
	
	d ##class(web.Util.UtilService).PutComponent("/tmp/")
	d ##class(web.Util.MenuService).Import("/tmp/menu/DHCLogAuditAndCfg.xml",0,.SuccList)
	d $SYSTEM.CSP.LoadRule("/dthealth/web/csp/EASYUI132.csr")
}

ClassMethod EventLog(ModelName, Condition, Content, SecretCode, Success As %String = "Y", UserId = "", IP = "", Mac = "", CName = "", LocId = "", GroupId = "")
{
	Set ^Temp("EventLog")=ModelName_","_ Condition_","_ Content_","_ SecretCode
	Set ModelId = ##class(web.DHCEventModel).ValidModelCode(ModelName)
	Quit:ModelId=0 "-100^"_ModelName_" Model Is Not Exist Or Unactive!"
	If SecretCode="" Set SecretCode = ##class(web.DHCSecretLevel).GetLowLevel()
	Set SecretCode = $zu(28,SecretCode,7,32768)
	Set SecretId = $o(^User.DHCSecretLevelI("Code",SecretCode,""))
	Quit:SecretId="" "-100^"_SecretCode_" SecretCode Is Not Exist!"
	
	Set LoginId=0
	if $d(%session) {
		Set LoginId = $g(%session.Data("LOGON.SSUSERLOGINID"))
		if (LoginId>0) {
			if $d(^SST("LOG",LoginId,"ADDR")){
				If IP="" Set IP = $p(^SST("LOG",LoginId,"ADDR"),"^",1)
				If CName="" Set CName = $p(^SST("LOG",LoginId,"ADDR"),"^",4)
				If Mac="" Set Mac = $p(^SST("LOG",LoginId,"ADDR"),"^",5)
			}
		}
		If UserId="" Set UserId = $g(%session.Data("LOGON.USERID"))
		If LocId="" Set LocId = $g(%session.Data("LOGON.CTLOCID"))
		If GroupId="" Set GroupId = $g(%session.Data("LOGON.GROUPID"))
	}
	set rtn = ..InsertLogAndDetails(ModelId,Condition,Content,SecretId,Success,UserId,LoginId,IP,Mac,CName,LocId,GroupId)
	quit rtn
}

ClassMethod InsertLogAndDetails(ModelId, Condition, Content, SecretId, Success = "Y", UserId = "", LoginId = "", IP = "", Mac = "", CName = "", LocId = "", GroupId = "")
{
	Set ^Temp("DHCEventLog","InsertLogAndDetails")="w ##class(web.DHCEventLog).InsertLogAndDetails("_ModelId_","""_Condition_""","""_Content_""","_SecretId_","""_Success_""","""_UserId_""","""_LoginId_""","""_IP_""","""_Mac_""","""_CName_""","""_LocId_""","""_GroupId_""")"
	Quit:UserId="" "-100^InsertLogAndDeteails. UserId Is Null"
	Quit:Condition="" "-100^InsertLogAndDeteails. Condition Is Null"
	Quit:ModelId="" "-100^InsertLogAndDeteails. ModelId Is Null"
	Set nowDate = +$h,nowTime = $p($h,",",2)
	Set NewLog = 1	,PreLogId=0 ;默认新增
	Set ModelName = $lg(^User.DHCEventModelD(ModelId),2)
	Set ModelType = $lg(^User.DHCEventModelD(ModelId),5)
	If Success'="N" Set Success="Y"
	If $zcvt(ModelType,"U")="L"{
		If Success="N"{				;登录失败
			Set PreLogId = $Order(^DHCEVENTLOGI(0,"DetDate",nowDate,"Model",ModelId,"Conditions",Condition," "),-1)
			;连续登录失败,且未审核过
			If (PreLogId>0),^DHCEVENTLOGI(0,"DetDate",nowDate,"Model",ModelId,"Conditions",Condition,PreLogId)="N",$d(^DHCEVENTLOG(PreLogId)){
				Set LogSuccess = $p(^DHCEVENTLOG(PreLogId),"^",4)
				If (LogSuccess="N"){ Set NewLog = 0	}
			}
		}
	}
	If ($zcvt(ModelType,"U")="P")||($zcvt(ModelType,"U")="Q")||($zcvt(ModelType,"U")="V"){
		Set PreLogId = $Order(^DHCEVENTLOGI(0,"Model",ModelId,"Conditions",Condition,"User",UserId," "),-1)
		;打印/查询/浏览过,且未审核过
		If (PreLogId>0),^DHCEVENTLOGI(0,"Model",ModelId,"Conditions",Condition,"User",UserId,PreLogId)="N",$d(^DHCEVENTLOG(PreLogId)){
			Set NewLog = 0
		}
	}
	Set $zt = "EventLogErr"
	ts
	If NewLog{
		set PreLogId = ..Insert(ModelId,UserId,nowDate,nowTime,nowDate,nowTime,Success)
	}else{
		set PreLogId = ..AddTimes(PreLogId,nowDate,nowTime)
	}	
	If PreLogId'>0 tro  quit "-100^Save Event Log fail!"
	Set rtn=-100
	if PreLogId>0{
		Set rtn = ##class(web.DHCEventLogDetails).Insert(PreLogId,Content,Condition,SecretId,UserId,LocId,GroupId,LoginId,IP,Mac,CName)	
	}
	If rtn'>0 tro  quit "-100^Save Event Log Details fail!"
	tc
	q rtn
EventLogErr
	tro
	Set ^Temp("DHCEventLog","SaveErr")=$ze
	q "-100^"_$ze
}

/// 更新重复次数	
ClassMethod AddTimes(LogId, EndDate, EndTime)
{
	Set LogObj = ##class(User.DHCEventLog).%OpenId(LogId)
	Set LogObj.LogTimes = 1+LogObj.LogTimes
	Set LogObj.LogEndDate = EndDate
	Set LogObj.LogEndTime = EndTime
	Set sc = LogObj.%Save()
	If $$$ISERR(sc) set LogObj="" Quit "-100^"_$SYSTEM.Status.GetErrorCodes(sc)
	Quit LogId
}

ClassMethod Insert(ModelId, UserId, StDate, StTime, EndDate, EndTime, Success)
{
	Set LogId = "-100"
	Set LogObj = ##Class(User.DHCEventLog).%New()
	do LogObj.LogModelDrSetObjectId(ModelId)
	Do LogObj.LogUserDrSetObjectId(UserId)
	Set LogObj.LogTimes = 1
	Set LogObj.LogStDate = StDate
	Set LogObj.LogStTime = StTime
	Set LogObj.LogEndDate = EndDate
	Set LogObj.LogEndTime = EndTime
	Set LogObj.LogSuccess = Success
	Set sc = LogObj.%Save()
	If $$$ISERR(sc) set LogObj="" Quit "-100^"_$SYSTEM.Status.GetErrorCodes(sc)
	Set LogId = LogObj.%Id()
	Set LogObj=""
	Quit LogId
}

/// d ##class(%ResultSet).RunQuery("web.DHCEventLog","Find","","","","")
/// @param StDate 开始时间
/// @param EndDate 结束时间
/// @param User    用户RowId
/// @param AuditFlag 是否已审核 默认N 			不为空
/// @param Model 模块RowId
/// @param Type  登录类型还是打印类型L/P 默认L 不为空
Query Find(StDate, EndDate, User = "", AuditFlag = "N", Model = "", Type = "L") As websys.Query(CONTAINID = 1, ROWSPEC = "LogRowId:%String,LogStDate:%String,LogStTime:%String,LogEndDate:%String,LogEndTime:%String,LogSuccess:%String,LogTimes:%String,LogUserDr:%String,LogUserName:%String,LogModelDr:%String,LogModelDesc:%String,LogAuditFlag:%String,LogAuditDr:%String,LogAuditStatusDesc:%String,LogAuditUserName:%String,LogAuditNote:%String")
{
}

/// by wuqk 2011-05-27 未完成，全查；RUDesc 响应单位 关系不清楚
ClassMethod FindExecute(ByRef QHandle As %Library.Binary, StDate, EndDate, User = "", AuditFlag = "N", Model = "", Type = "L") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set QHandle=$lb(0,repid,0)
	Set StDate = ##Class(websys.Conversions).DateHtmlToLogical(StDate)
	Set EndDate = ##Class(websys.Conversions).DateHtmlToLogical(EndDate)
	;If StDate["-" Set StDate=$zdh(StDate,3)
	;If EndDate["-" Set EndDate=$zdh(EndDate,3)
	If StDate="" Set StDate=+$h
	If (EndDate="")||(EndDate<StDate)  Set EndDate=StDate
	//If AuditFlag="" Set AuditFlag="N"
	Set LogRowId=""
	for Date=StDate:1:EndDate{
		for iAuditFlag="N","Y"{  //为空要查未审核 与 已审核
			continue:(AuditFlag'="")&&(iAuditFlag'=AuditFlag)
			Set LogRowId=""
			For{
				Set LogRowId = $Order(^DHCEVENTLOGI(0,"StDate",Date,"AuditFlag",iAuditFlag,LogRowId))
				Quit:LogRowId=""
				If $d(^DHCEVENTLOG(LogRowId),g){
					Set LogStDate = Date
					If LogStDate'="" Set LogStDate=##Class(websys.Conversions).DateLogicalToHtml(LogStDate)
					Set LogTimes = $p(g,"^",1)
					Set LogModelDr = $p(g,"^",2)
					Continue:(Model'="")&&(LogModelDr'=Model)
					Set LogModelDesc=""
					If LogModelDr>0 {
						Set LogModelDesc = $lg(^User.DHCEventModelD(LogModelDr),3)
						Set ModelType = $lg(^User.DHCEventModelD(LogModelDr),5)
						Continue:(Type'="")&&(Type'=ModelType)
					}
					Set LogUserDr = $p(g,"^",3)
					Continue:(User'="")&&(LogUserDr'=User)
					set LogUserName=""
					If LogUserDr>0 Set LogUserName = $P($g(^SSU("SSUSR",LogUserDr)),"^",2)
					//if LogUserDr>0,LogUserName=""  set LogUserName="Err"_LogUserDr
					Set LogAuditFlag = $p(g,"^",6)
					Set LogAuditDr =  $p(g,"^",5)
					Set LogAuditUserName = "",LogAuditStatusDesc="",LogAuditNote=""
					IF LogAuditDr>0 {
						Set LogAuditUserDr = $lg(^User.DHCEventLogAuditD(LogAuditDr),3)
						if LogAuditUserDr>0 Set LogAuditUserName = $P($g(^SSU("SSUSR",LogAuditUserDr)),"^",2)
						if LogAuditUserDr,LogAuditUserName="" set LogAuditUserName="Err"_LogAuditUserDr
						Set LogAuditStatusDr = $lg(^User.DHCEventLogAuditD(LogAuditDr),2)
						If LogAuditStatusDr>0  Set LogAuditStatusDesc = $lg(^User.DHCAuditStatusD(LogAuditStatusDr),3)
						Set LogAuditNote = $lg(^User.DHCEventLogAuditD(LogAuditDr),6)
					}
					Set LogSuccess =  $p(g,"^",4)
					;Set LogSuccess = $case(LogSuccess,"Y":"成功",:"失败")
					Set LogStTime =  $p(g,"^",8)
					If LogStTime'="" Set LogStTime=$zt(LogStTime,2)
					Set LogEndDate =  $p(g,"^",9)
					If LogEndDate'="" Set LogEndDate=##Class(websys.Conversions).DateLogicalToHtml(LogEndDate)
					Set LogEndTime =  $p(g,"^",10)
					If LogEndTime'="" Set LogEndTime=$zt(LogEndTime,2)
					Set ^CacheTemp(repid,ind)=$lb(LogRowId,LogStDate,LogStTime,LogEndDate,LogEndTime,LogSuccess,LogTimes,LogUserDr,LogUserName,LogModelDr,LogModelDesc,LogAuditFlag,LogAuditDr,LogAuditStatusDesc,LogAuditUserName,LogAuditNote)
					Set ind=ind+1
				}
			}
		} //iAuditFlag
	}  
	Set QHandle=$lb(0,repid,0)
	quit $$$OK
}

ClassMethod AuditLog(LogIds, StatusDr, UserDr, Note)
{
	Quit:LogIds="" "-100^LogIds Is Null"
	Ts
	Set rtn = ##class(web.DHCEventLogAudit).Save(StatusDr,UserDr,Note)
	If +rtn=-100 tro  quit "-100^Save LogAudit Error"
	For i=1:1:$l(LogIds,"^") {
		Set LogId = $p(LogIds,"^",i)
		Set Obj = ##class(User.DHCEventLog).%OpenId(LogId)
		if (Obj.LogAuditFlag="N"){
			Do Obj.LogAuditDrSetObjectId(rtn)
			Set Obj.LogAuditFlag = "Y"
			Set sc = Obj.%Save()
		}
		set Obj=""
		If $$$ISERR(sc) Quit 
	}
	If $$$ISERR(sc) tro  quit "-100^Save Log Audit Flag Error"
	tc
	quit 0
}

}
