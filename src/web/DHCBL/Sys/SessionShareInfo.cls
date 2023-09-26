Include (%cspBuild, %sySecurity)

/// 共享Session信息
/// 保存Session的Global  ^TMPSessionShare
/// 把此类变成 session的扩展类，但不是继承类, 数据都保存在Session中
Class web.DHCBL.Sys.SessionShareInfo Extends %Persistent [ ClassType = "", Not ProcedureBlock, StorageStrategy = NewStorage1 ]
{

Property AppTimeout As %Integer [ InitialExpression = 900 ];

/// 源Session Id
Property SourceSessionId As %String(TRUNCATE = 1);

/// 目标Session ID
Property TargetSessionId As %String(TRUNCATE = 1);

/// 总结出的session信息
Property CTLOCID As %String(TRUNCATE = 1);

Property SITECODE As %String(MAXLEN = 200, TRUNCATE = 1);

Property USERID As %String(TRUNCATE = 1);

Property USERCODE As %String(MAXLEN = 80, TRUNCATE = 1);

Property USERNAME As %String(MAXLEN = 80, TRUNCATE = 1);

Property GROUPID As %String(TRUNCATE = 1);

Property GROUPDESC As %String(MAXLEN = 80, TRUNCATE = 1);

Property LANGID As %String(TRUNCATE = 1);

Property ROUND As %String(TRUNCATE = 1);

Property ROUNDDESC As %String(MAXLEN = 80, TRUNCATE = 1);

Property HOSPID As %String(TRUNCATE = 1);

Property HOSPDESC As %String(MAXLEN = 120, TRUNCATE = 1);

Property TRUSTID As %String(TRUNCATE = 1);

Property TRUSTDESC As %String(TRUNCATE = 1);

Property SSUSERLOGINID As %String(TRUNCATE = 1);

Property TIMEOUT As %String(TRUNCATE = 1);

Property REMOTEADDR As %String(MAXLEN = 200, TRUNCATE = 1);

Property COMPUTERNAME As %String(MAXLEN = 200, TRUNCATE = 1);

Property SERVERNAME As %String(MAXLEN = 200, TRUNCATE = 1);

Property REGION As %String(TRUNCATE = 1);

Index STSessionID On (SourceSessionId, TargetSessionId) [ Unique ];

/// This callback method is invoked by the <METHOD>%New</METHOD> method to 
/// provide notification that a new instance of an object is being created.
/// 
/// <P>If this method returns an error then the object will not be created.
/// <p>It is passed the arguments provided in the %New call.
/// When customizing this method, override the arguments with whatever variables and types you expect to receive from %New().
/// For example, if you're going to call %New, passing 2 arguments, %OnNew's signature could be:
/// <p>Method %OnNew(dob as %Date = "", name as %Name = "") as %Status
/// initvalue = current session ID
Method %OnNew(initvalue As %CacheString) As %Status [ Private, ProcedureBlock = 1 ]
{
	If $get(initvalue)="" Quit $$$ERROR($$$SessionIdMissing)
	#; Two stage lock so we do not need to look up this global most of the time as we will get the lock immediately and only
	#; wait for the timeout if we have to
	;Lock +^%cspSession(initvalue):0 Else  Lock +^%cspSession(initvalue):$get(^%SYS("CSP","SessionLockTimeout"),240) Else  Quit $$$ERROR($$$LockFailedToAcquireExclusive)
	;Set i%SessionId=initvalue Do ..%IdSet(initvalue)
	;Set i%Key=$select($get(^%SYS("CSP","NoEncrypt")):"notencrypted",1:$system.Encryption.GenCryptRand(16))
	;Set i%CreateTime=$zdatetime($ztimestamp,3)
	;Do $zutil(67,14,initvalue,$job)
	
	$$$SysLog(2,"ShareSession","Creating new Share session",initvalue)
	;lock global time 
	;
	s mytimeout=270
	
	Lock +^TMPSessionShare(initvalue):0 Else  Lock +^TMPSessionShare(initvalue):$g(mytimeout,260) Else  Quit $$$ERROR($$$LockFailedToAcquireExclusive)
	s i%SourceSessionId=initvalue
	s i%AppTimeout=mytimeout
	
	Do ..%IdSet(initvalue)
	
	Quit $$$OK
}

/// [Previously private]
ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ ProcedureBlock = 1 ]
{
	;Set session=..GetSession(id)
	;If session=$$$NULLOREF Quit $select($get(%objlasterror)'="":%objlasterror,1:$$$ERROR($$$CSPSessionNotFound,id))
	;Do endSession^%SYS.cspServer(session)
	;q:(id="") $$$OK
	
	Quit $$$OK
}

Method %LoadDataBack(id As %String) As %Status [ Private, ProcedureBlock = 1 ]
{
	#; Two stage lock to avoid looking up ^%SYS global if we can get the lock straight away
	
	Lock +^TMPSessionShare(id):0 Else  Lock +^TMPSessionShare(id):$get(^%SYS("CSP","SessionLockTimeout"),240) Else  Quit $$$ERROR($$$LockFailedToAcquireExclusive) Else  Set ..%Concurrency=0 
	$$$SysLog(2,"ShareSession","Loading Share session",id)
	Set data=$get(^TMPSessionShare(id)) If data="" Quit $$$ERROR($$$SessionIdDoesNotExist,id)
	
	Set i%SourceSessionId=id
	s i%AppTimeout=$lg(data,1)
	s i%TargetSessionId=$lg(data,3)
	s i%CTLOCID=$lg(data,4)
	s i%SITECODE=$lg(data,5)
	s i%USERID=$lg(data,6)
	s i%USERCODE=$lg(data,7)
	s i%USERNAME=$lg(data,8)
	s i%GROUPID=$lg(data,9)
	s i%GROUPDESC=$lg(data,10)
	s i%LANGID=$lg(data,11)
	s i%ROUND=$lg(data,12)
	s i%ROUNDDESC=$lg(data,13)
	s i%HOSPID=$lg(data,14)
	s i%HOSPDESC=$lg(data,15)
	s i%TRUSTID=$lg(data,16)
	s i%TRUSTDESC=$lg(data,17)
	s i%SSUSERLOGINID=$lg(data,18)
	s i%TIMEOUT=$lg(data,19)
	s i%REMOTEADDR=$lg(data,20)
	s i%COMPUTERNAME=$lg(data,21)
	s i%SERVERNAME=$lg(data,22)
	s i%REGION=$lg(data,23)
	
	d ..Unlock()
	
	q $$$OK
}

/// 单独的数据存储
Method %LoadData(id As %String) As %Status [ Private, ProcedureBlock = 1 ]
{
	#; Two stage lock to avoid looking up ^%SYS global if we can get the lock straight away
	Set $ztrap="loadDataErr"
	
	$$$SysLog(2,"ShareSession","Loading Share session",id)
	
	;s mysession=##class(%CSP.Session).GetSession(id)
	If $l(id)>20{
  		s mysession=##class(BSP.SYS.Token).GetSession(id)
 	}else{
  		s mysession=##class(%CSP.Session).GetSession(id)
 	}
	
	Set i%SourceSessionId=id
	
	s i%AppTimeout=mysession.AppTimeout
	s i%TargetSessionId=$g(mysession.Data("DTHealth.targetsessionid"))
	s i%CTLOCID=$g(mysession.Data("LOGON.CTLOCID"))
	s i%SITECODE=$g(mysession.Data("LOGON.SITECODE"))
	s i%USERID=$g(mysession.Data("LOGON.USERID"))
	s i%USERCODE=$g(mysession.Data("LOGON.USERCODE"))
	s i%USERNAME=$g(mysession.Data("LOGON.USERNAME"))
	s i%GROUPID=$g(mysession.Data("LOGON.GROUPID"))
	s i%GROUPDESC=$g(mysession.Data("LOGON.GROUPDESC"))
	s i%LANGID=$g(mysession.Data("LOGON.LANGID"))
	s i%ROUND=$g(mysession.Data("LOGON.ROUND"))
	s i%ROUNDDESC=$g(mysession.Data("LOGON.ROUNDDESC"))
	s i%HOSPID=$g(mysession.Data("LOGON.HOSPID"))
	s i%HOSPDESC=$g(mysession.Data("LOGON.HOSPDESC"))
	s i%TRUSTID=$g(mysession.Data("LOGON.TRUSTID"))
	s i%TRUSTDESC=$g(mysession.Data("LOGON.TRUSTDESC"))
	s i%SSUSERLOGINID=$g(mysession.Data("LOGON.SSUSERLOGINID"))
	s i%TIMEOUT=mysession.AppTimeout
	s i%REMOTEADDR=$g(mysession.Data("REMOTE_ADDR"))
	s i%COMPUTERNAME=$g(mysession.Data("COMPUTER_NAME"))
	s i%SERVERNAME=$g(mysession.Data("SERVER_NAME"))
	s i%REGION=$g(mysession.Data("LOGON.REGION"))
	
	d mysession.%Close()
	
	q $$$OK
loadDataErr
	;有错误后，要及时把session对象释放掉
	s mysession=""
	q
}

/// %SaveData() - saves an object to disk, checks uniqueness and referential
/// integrity constraints, and maintains index structures. This method is
/// implemented by the storage class.
Method %SaveData(id As %String) As %Status [ Private, ProcedureBlock = 1 ]
{
	Set $ztrap="saveErr",inTransaction=$zutil(139,1)
	#; If the application can timeout setup the global to say when it will timeout
	
	;Set i%LastModified=$zdatetime($ztimestamp,3),i%OldTimeout=+$get(timeoutAt)
	;If 'nodata Set i%MessageNumber=i%MessageNumber+1
	
	;build uniqu index
	i (i%TargetSessionId'="")&&(i%SourceSessionId'=""){
	}
	
	s mysession=##class(%CSP.Session).GetSession(id)
	
	s mysession.Data("DTHealth.sourcesessionid")=id
	s mysession.Data("DTHealth.targetsessionid")=i%TargetSessionId
	
	s mysc= mysession.%Save()
	If $$$ISERR(mysc) {
		d saveErr
	}
	d mysession.%Close()
	
	$$$SysLog(2,"ShareSession","Saved Share session",id)
	#; Turn transactions back on
	Do $zutil(139,inTransaction)
	
	Quit $$$OK
saveErr	Set $ztrap=""
	s mysession=""
	If $data(inTransaction) Do $zutil(139,inTransaction)
	$$$SysLogError("ShareSession","Error saving session id:"_id_" $ze:"_$zerror)
	
	Quit $$$ERROR($$$CacheError,$zerror)
}

/// %SaveData() - saves an object to disk, checks uniqueness and referential
/// integrity constraints, and maintains index structures. This method is
/// implemented by the storage class.
Method %SaveDataBack(id As %String) As %Status [ Private, ProcedureBlock = 1 ]
{
	Set $ztrap="saveErr",inTransaction=$zutil(139,1)
	#; If the application can timeout setup the global to say when it will timeout
	
	;Set i%LastModified=$zdatetime($ztimestamp,3),i%OldTimeout=+$get(timeoutAt)
	;If 'nodata Set i%MessageNumber=i%MessageNumber+1
	;删除干扰  Session 有可能超时原因
	k ^TMPSessionShare(id)
	k ^TMPSessionShareI(id)
	
	;build uniqu index
	i (i%TargetSessionId'="")&&(i%SourceSessionId'=""){
		i $d(^TMPSessionShareI(id,0,i%SourceSessionId,i%TargetSessionId)){
			d saveErr
		}else{
			s ^TMPSessionShareI(id,0,i%SourceSessionId,i%TargetSessionId)=""
		}
	}
	
	Set ^TMPSessionShare(id)=$ListBuild(i%AppTimeout,i%SourceSessionId,i%TargetSessionId, i%CTLOCID,i%SITECODE,i%USERID,i%USERCODE, i%USERNAME, i%GROUPID, i%GROUPDESC, i%LANGID, i%ROUND, i%ROUNDDESC, i%HOSPID, i%HOSPDESC, i%TRUSTID, i%TRUSTDESC, i%SSUSERLOGINID, i%TIMEOUT, i%REMOTEADDR, i%COMPUTERNAME, i%SERVERNAME, i%REGION)
	
	d ..Unlock()
	
	$$$SysLog(2,"ShareSession","Saved Share session",id)
	#; Turn transactions back on
	Do $zutil(139,inTransaction)
	Quit $$$OK
saveErr	Set $ztrap=""
	If $data(inTransaction) Do $zutil(139,inTransaction)
	$$$SysLogError("ShareSession","Error saving session id:"_id_" $ze:"_$zerror)
	Quit $$$ERROR($$$CacheError,$zerror)
}

Method Unlock() As %Status
{
	
	Lock -^TMPSessionShare(i%SourceSessionId)
	b	;
	Quit $$$OK
}

/// 获取一个共享的Session信息
ClassMethod GetShareSession(sessionId As %String) As web.DHCBL.Sys.SessionShareInfo
{
	Quit:$Get(sessionId)="" ""
	Set session=$$$NULLOREF
	#; Two stage lock to avoid having to look up ^%SYS global if we can get lock immediately
	
	Set session=##class(web.DHCBL.Sys.SessionShareInfo).%OpenId(sessionId)
	
	If session=$$$NULLOREF Set session=##class(web.DHCBL.Sys.SessionShareInfo).%New(sessionId)
	
	Quit session
}

ClassMethod GetShareSessionBack(sessionId As %String) As web.DHCBL.Sys.SessionShareInfo
{
	Quit:$Get(sessionId)="" ""
	Set session=$$$NULLOREF
	#; Two stage lock to avoid having to look up ^%SYS global if we can get lock immediately
	Lock +^TMPSessionShare(sessionId):0 Else  Lock +^TMPSessionShare(sessionId):$get(^%SYS("CSP","SessionLockTimeout"),240) Else  Quit ""
	
	If $data(^TMPSessionShare(sessionId)) {
		Set session=##class(web.DHCBL.Sys.SessionShareInfo).%OpenId(sessionId)
	}
	
	If session=$$$NULLOREF Set session=##class(web.DHCBL.Sys.SessionShareInfo).%New(sessionId)
	
	Lock -^TMPSessionShare(sessionId)
	Quit session
}

/// 在DtHealth中设置Session info
ClassMethod SetDtHealthSessionInfo() As %Status
{
	i ('%session){
		q ""
	}
	s mySessionId=%session.SessionId
	
	s obj=##class(web.DHCBL.Sys.SessionShareInfo).GetShareSession(mySessionId)
	
	s obj.CTLOCID=$g(%session.Data("LOGON.CTLOCID"))
	s obj.SITECODE=$g(%session.Data("LOGON.SITECODE"))
	s obj.USERID=$g(%session.Data("LOGON.USERID"))
	s obj.USERCODE=$g(%session.Data("LOGON.USERCODE"))
	s obj.USERNAME=$g(%session.Data("LOGON.USERNAME"))
	s obj.GROUPID=$g(%session.Data("LOGON.GROUPID"))
	s obj.GROUPDESC=$g(%session.Data("LOGON.GROUPDESC"))
	s obj.LANGID=$g(%session.Data("LOGON.LANGID"))
	s obj.ROUND=$g(%session.Data("LOGON.ROUND"))
	s obj.ROUNDDESC=$g(%session.Data("LOGON.ROUNDDESC"))
	s obj.HOSPID=$g(%session.Data("LOGON.HOSPID"))
	s obj.HOSPDESC=$g(%session.Data("LOGON.HOSPDESC"))
	s obj.TRUSTID=$g(%session.Data("LOGON.TRUSTID"))
	s obj.TRUSTDESC=$g(%session.Data("LOGON.TRUSTDESC"))
	s obj.SSUSERLOGINID=$g(%session.Data("LOGON.SSUSERLOGINID"))
	s obj.TIMEOUT=$g(%session.Data("LOGON.TIMEOUT"))
	s obj.REMOTEADDR=$g(%session.Data("REMOTE_ADDR"))
	s obj.SERVERNAME=$g(%session.Data("COMPUTER_NAME"))
	s obj.REGION=$g(%session.Data("LOGON.REGION"))
	s sc= obj.%Save()
	If $$$ISERR(sc) {
	     Do $System.Status.DisplayError(sc)
	 }
	q $$$OK
}

ClassMethod CheckDtSessionSync() As %Boolean
{
	;验证 Session信息是否同步： s t 两个 id都不能为空
	s mySessionId=%session.SessionId
	
	s myrtn=0
	i $d(^TMPSessionShare(mySessionId)){
		i ($lg(^TMPSessionShare(mySessionId),3)'=""){
			s myrtn=1
		}else{
			s myrtn=0
		}
	}else{
		s myrtn=0
	}
	
	q myrtn
}

/// 根据Source SessionID 查找 源程序的SessionID
/// 同时设置源与目标的SessionID 对照关系
Query DTSessionInfo(ssessionid As %String, tsessionid As %String) As %Query(ROWSPEC = "CTLOCID:%String,SITECODE:%String, USERID:%String, USERCODE:%String, USERNAME:%String, GROUPID:%String, GROUPDESC:%String, LANGID:%String, ROUND:%String, ROUNDDESC:%String, HOSPID:%String, HOSPDESC:%String, TRUSTID:%String, TRUSTDESC:%String, SSUSERLOGINID:%String, TIMEOUT:%String, REMOTEADDR:%String, SERVERNAME:%String, REGION:%String") [ SqlProc ]
{
}

ClassMethod DTSessionInfoExecute(ByRef qHandle As %Binary, ssessionid As %String, tsessionid As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCBL.Sys.SessionShareInfo","DTSessionInfo", "", "")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	d ResetVariables
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	
	if ((ssessionid="")||(tsessionid="")){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	;
	s obj=##class(web.DHCBL.Sys.SessionShareInfo).GetShareSession(ssessionid)
	;增加一个逻辑判断
	;i obj.TargetSessionId
	s obj.TargetSessionId=tsessionid
	d obj.%Save()
	
	d ResetVariables
	
	s myCTLOCID=obj.CTLOCID
	s mySITECODE=obj.SITECODE
	s myUSERID=obj.USERID
	s myUSERCODE=obj.USERCODE
	s myUSERNAME=obj.USERNAME
	s myGROUPID=obj.GROUPID
	s myGROUPDESC=obj.GROUPDESC
	s myLANGID=obj.LANGID
	s myROUND=obj.ROUND
	s myROUNDDESC=obj.ROUNDDESC
	s myHOSPID=obj.HOSPID
	s myHOSPDESC=obj.HOSPDESC
	s myTRUSTID=obj.TRUSTID
	s myTRUSTDESC=obj.TRUSTDESC
	s mySSUSERLOGINID=obj.SSUSERLOGINID
	s myTIMEOUT=obj.TIMEOUT
	s myREMOTEADDR=obj.REMOTEADDR
	s mySERVERNAME=obj.SERVERNAME
	s myREGION=obj.REGION
	
	Do OutputRow
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(myCTLOCID,mySITECODE, myUSERID, myUSERCODE, myUSERNAME, myGROUPID, myGROUPDESC, myLANGID, myROUND, myROUNDDESC,myHOSPID, myHOSPDESC,myTRUSTID, myTRUSTDESC, mySSUSERLOGINID, myTIMEOUT, myREMOTEADDR, mySERVERNAME, myREGION)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables
	s (myCTLOCID,mySITECODE, myUSERID, myUSERCODE, myUSERNAME, myGROUPID, myGROUPDESC, myLANGID, myROUND)=""
	s (myROUNDDESC,myHOSPID, myHOSPDESC,myTRUSTID, myTRUSTDESC, mySSUSERLOGINID, myTIMEOUT, myREMOTEADDR, mySERVERNAME)=""
	s myREGION=""
	q
}

ClassMethod DTSessionInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DTSessionInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DTSessionInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DTSessionInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {			
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^web.DHCBL.Sys.SessionShare663S</StreamLocation>
<Type>%CustomStorage</Type>
}

}
