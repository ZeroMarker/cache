Class web.DHCBL.Sys.SessionManager Extends %RegisteredObject
{

/// 保证 session信息双方 能在任何一方Session信息过期后能够自动同步
/// 根据Source SessionID 查找 源程序的SessionID
/// 同时设置源与目标的SessionID 对照关系
Query DTSessionInfo(ssessionid As %String, tsessionid As %String) As %Query(ROWSPEC = "CTLOCID:%String,SITECODE:%String, USERID:%String, USERCODE:%String, USERNAME:%String, GROUPID:%String, GROUPDESC:%String, LANGID:%String, ROUND:%String, ROUNDDESC:%String, HOSPID:%String, HOSPDESC:%String, TRUSTID:%String, TRUSTDESC:%String, SSUSERLOGINID:%String, TIMEOUT:%String, REMOTEADDR:%String, SERVERNAME:%String, REGION:%String") [ SqlProc ]
{
}

ClassMethod DTSessionInfoExecute(ByRef qHandle As %Binary, ssessionid As %String, tsessionid As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCBL.Sys.SessionManager","DTSessionInfo", "", "")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	s ^TMPURL = ssessionid_"^"_tsessionid
	
	d ResetVariables
	
	if ((ssessionid="")||(tsessionid="")){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	;
	;s obj=##class(web.DHCBL.Sys.SessionShareInfo).GetShareSession(ssessionid)
	;增加一个逻辑判断
	;s obj.TargetSessionId=tsessionid
	;s mysc= obj.%Save()
	
	d ResetVariables
	;s mysession=##class(%CSP.Session).GetSession(ssessionid)
	If $l(ssessionid)>20{
  		s mysession=##class(BSP.SYS.Token).GetSession(ssessionid)
 	}else{
  		s mysession=##class(%CSP.Session).GetSession(ssessionid)
 	}
	
	;s i%CTLOCID=$g(mysession.Data("LOGON.CTLOCID"))
	s myCTLOCID=$g(mysession.Data("LOGON.CTLOCID"))
	;s i%SITECODE=$g(mysession.Data("LOGON.SITECODE"))
	s mySITECODE=$g(mysession.Data("LOGON.SITECODE"))
	
	;s i%USERID=$g(mysession.Data("LOGON.USERID"))
	s myUSERID=$g(mysession.Data("LOGON.USERID"))
	
	;s i%USERCODE=$g(mysession.Data("LOGON.USERCODE"))
	s myUSERCODE=$g(mysession.Data("LOGON.USERCODE"))
	
	;s i%USERNAME=$g(mysession.Data("LOGON.USERNAME"))
	s myUSERNAME=$g(mysession.Data("LOGON.USERNAME"))
	
	;s i%GROUPID=$g(mysession.Data("LOGON.GROUPID"))
	s myGROUPID=$g(mysession.Data("LOGON.GROUPID"))
	
	;s i%GROUPDESC=$g(mysession.Data("LOGON.GROUPDESC"))
	s myGROUPDESC=$g(mysession.Data("LOGON.GROUPDESC"))
	
	;s i%LANGID=$g(mysession.Data("LOGON.LANGID"))
	s myLANGID=$g(mysession.Data("LOGON.LANGID"))
	
	;s i%ROUND=$g(mysession.Data("LOGON.ROUND"))
	s myROUND=$g(mysession.Data("LOGON.ROUND"))
	
	;s i%ROUNDDESC=$g(mysession.Data("LOGON.ROUNDDESC"))
	s myROUNDDESC=$g(mysession.Data("LOGON.ROUNDDESC"))
	
	;s i%HOSPID=$g(mysession.Data("LOGON.HOSPID"))
	s myHOSPID=$g(mysession.Data("LOGON.HOSPID"))
	
	;s i%HOSPDESC=$g(mysession.Data("LOGON.HOSPDESC"))
	s myHOSPDESC=$g(mysession.Data("LOGON.HOSPDESC"))
	
	;s i%TRUSTID=$g(mysession.Data("LOGON.TRUSTID"))
	s myTRUSTID=$g(mysession.Data("LOGON.TRUSTID"))
	
	;s i%TRUSTDESC=$g(mysession.Data("LOGON.TRUSTDESC"))
	s myTRUSTDESC=$g(mysession.Data("LOGON.TRUSTDESC"))
	
	;s i%SSUSERLOGINID=$g(mysession.Data("LOGON.SSUSERLOGINID"))
	s mySSUSERLOGINID=$g(mysession.Data("LOGON.SSUSERLOGINID"))
	
	;s i%TIMEOUT=mysession.AppTimeout
	s myTIMEOUT=60
	
	;s i%REMOTEADDR=$g(mysession.Data("REMOTE_ADDR"))
	s myREMOTEADDR=$g(mysession.Data("REMOTE_ADDR"))
	
	;s i%COMPUTERNAME=$g(mysession.Data("COMPUTER_NAME"))
	;s i%SERVERNAME=$g(mysession.Data("SERVER_NAME"))
	s mySERVERNAME=$g(mysession.Data("SERVER_NAME"))
	
	;;s i%REGION=
	s myREGION=$g(mysession.Data("LOGON.REGION"))
	
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

ClassMethod DTSessionInfoExecuteOld(ByRef qHandle As %Binary, ssessionid As %String, tsessionid As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCBL.Sys.SessionManager","DTSessionInfo", "", "")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	s ^TMPURL = ssessionid_"^"_tsessionid
	
	d ResetVariablesa
	
	if ((ssessionid="")||(tsessionid="")){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	;
	s obj=##class(web.DHCBL.Sys.SessionShareInfo).GetShareSession(ssessionid)
	;增加一个逻辑判断
	;i obj.TargetSessionId
	s obj.TargetSessionId=tsessionid
	s mysc= obj.%Save()
	
	d ResetVariablesa
	
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
	
	Do OutputRowa
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowa
	set Data=$lb(myCTLOCID,mySITECODE, myUSERID, myUSERCODE, myUSERNAME, myGROUPID, myGROUPDESC, myLANGID, myROUND, myROUNDDESC,myHOSPID, myHOSPDESC,myTRUSTID, myTRUSTDESC, mySSUSERLOGINID, myTIMEOUT, myREMOTEADDR, mySERVERNAME, myREGION)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariablesa
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
	}Else{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
