/// portal的登录
Class web.portal.SessionLogon Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Logon() As %Boolean
{
	;逻辑1：如果只有一个登陆科室， 直接登录到工作页面
	;		如果有多个登录科室， 返回到longon.csp 选择登录科室，再提交
	s mystatus=1
	s STATUS=""
	
	
	s LICENSE="Trak License to "
	
	;******************************************************
	;设置%Session信息
	;在表中获取医院信息
	;
	
	s welcometitle="欢迎 "
	
	;判断lisence
	s lic=1
	i ((+$g(^TMPSession("Session",+$h,"COUNT"))>2)&&('$d(^TMPSession("Session",+$h,%session.SessionId)))){
		;s lic=0
	}
	
	s forcePasswordChange=0
	s readonly=""
	s locIsDisabled=1
	
	s locIsDisabled=0
	s ValidUser=1
	s logonround=1
	d ..InitialiseSession()
	

 ; Set items for Logon.
 s LogonAttempts=+$g(%session.Data("LogonAttempts"))
 s PreviousUser=$g(%session.Data("PreviousUser")) 
 s STATUS=""
 s listflag=0
 s ValidUser=0
 s logonround=0
 s roundok=1
 s overrideauth=0,readonly=""
 s tdate=+$h
 s ttime=+$p($h,",",2)
 
 s config=##Class(websys.Configuration).%OpenId(1,0)
 i config {
 	s %session.Data("LOGON.SITECODE")=config.SiteCode
 	s %session.Data("LOGON.LAYOUTMANAGER")=config.LayoutManager
 	s (%session.Data("LOGON.TIMEOUT"),%session.AppTimeout)=$s(+config.TimeOut:config.TimeOut*60,1:900) ; convert from mins to secs
 	s %session.Data("LOGON.PPMDISPLAY")=config.PerformanceStatisticsDisplay
 	s %session.Data("LOGON.PPMCAPTURE")=config.PerformanceStatisticsCapture
	s %session.Data("LOGON.LANGID")=config.LanguageApp
 	s overrideauth=config.OverrideAuthentication
 	d config.%Close()
 	s %session.Data("TITLE")=$p($g(^CF("SM",1)),"^",5)
	s NoOfAttempts=$p($g(^CF("SM",1)),"^",46)
	s %session.Data("LICSITE")=$p($g(^CF("SM",1)),"^",43)
 }
 ;KK 02/Sep/2002 Log 27149 - translate messages
 ;TN: 01-Jan-2003 moved the retrieval of translations till the end for the correct %session("LANGID") to be set
 ;d ##Class(websys.Component).GetComponentMessages(.t,"websys.SYSTEM,SSUserLogon")
 ;i $g(%request.Data("RELOGON",1))'="" s STATUS=$g(t("SESSION_EXPIRED"),"Your session has expired. Please re-enter your username and password")
 i $g(%request.Data("RELOGON",1))'="" s STATUS="SESSION_EXPIRED"
 if ('overrideauth) {
 	s username=$g(%request.Data("USERNAME",1))
 	s password=$g(%request.Data("PASSWORD",1))
	s department=$g(%request.Data("DEPARTMENT",1))
	s round=$g(%request.Data("ROUND",1))
	s ^TMPDFDFDFD=username_"^"_password_"^"_department
 } else {
	; in this case always use this and never use the value from request.Data
 	s username=%request.GetCgiEnv("REMOTE_USER")
 	; get the username part only in case if is prefixed with domain
 	s username=$p(username,"\",$l(username,"\"))
 	s password="*****"
 	s department=""
	s round=""
 	s readonly="READONLY"
 }
 //Remove any old error messages
 d ##Class(websys.Message).%DeleteId(%session.SessionId)
 //Remove any (and all) existing session data
 //clear records against this computer
 d ##Class(websys.Lock).LockClearComputer($zu(67,15,$j))
 //k ^websys.LockD,^websys.LockI
 ;
 s (locIsDisabled,forcePasswordChange,blankDefaultLoc)=0	;TN: added for refresh purposes
 if $g(username)'="",$g(password)'="" {
	; Return -ve rowid if valid user but not active !
	if ('overrideauth) {
		s userid=##Class(web.portal.SSUser).IsValidUser(username,password)
	} else {
		s userid=##Class(web.portal.SSUser).IsValidUser(username,password,1)
	}
	i userid>0 s ValidUser=1
	//i userid="" s userid=##Class(web.SSUser).GetIdFromCodeOrDescription(username)
	; Check if user is active, if not show message and QUIT
	;TN: 01-Jan-2003: do not quit yet, move to end to retrieve tranlated messages
	i userid<0 {
		;s STATUS=$g(t("INACTIVE_LOGON"),"Your Login is Flagged 'Inactive'. Please see your System Administrator")
		s STATUS="INACTIVE_LOGON"
		;q 1
	}
	i userid'<0,'ValidUser {
		;非法用户登录，企图超过多少次后本用户可以被停止
		;if user has changed since last logon attempt, then counter should be reset
		i PreviousUser'=username s LogonAttempts=0
		s LogonAttempts=LogonAttempts+1
		;s STATUS=$g(t("VALID_USR_PWD"),"Please enter a valid Username and Password"),password=""
		s STATUS="VALID_USR_PWD",password=""
		; Log invalid logons
		i userid="" s userid=##Class(web.SSUser).GetIdFromCodeOrDescription(username)
		d ##Class(web.SSInvalidUserLogin).Insert(userid,%session.Data("COMPUTER_NAME"))
		i NoOfAttempts > 0 {
			i (LogonAttempts>NoOfAttempts) {
				i userid {
	 				; RQG 12.06.03 L33973: save the date and time when the user is deactivated
 					;&sql(UPDATE SQLUser.SS_User (SSUSR_Active) VALUES ("N") WHERE SSUSR_ROWID=:userid)
					&sql(UPDATE SQLUser.SS_User SET SSUSR_MarkInactiveDate=:tdate,SSUSR_MarkInactiveTime=:ttime, SSUSR_Active='N'  WHERE SSUSR_ROWID=:userid)
				}
				;s STATUS="You have had "_LogonAttempts_" Invalid Logins. Please contact your System Administrator."
				;s STATUS=$g(t("INVALID_LOGON1"))_LogonAttempts_$g(t("INVALID_LOGON2"))
				s STATUS="INVALID_LOGON1"
			}
		}
		s %session.Data("LogonAttempts")=LogonAttempts
		s %session.Data("PreviousUser")=username
	}
	
	i ValidUser {
		s logonround=1
		;是否有其他登录位置，如果有listflag>0
		;s listflag=##Class(web.SSUserOtherLogonLoc).CheckUserOtherLocation(userid)
		;;根据用户Code判断是否有其他的登录位置
		;;是否有登陆位置
		s listflag=##Class(web.SSUserOtherLogonLoc).CheckUserOtherLocation(username)
		b	;设置Group信息
		;如果 %request.Data("DEPARTMENT",1)'=""
		if +listflag=0, userid'="", $g(%request.Data("DEPARTMENT",1))=""{
			s myGroupID=$p($g(^SSU("SSUSR",userid)),"^",5)		;group
			s myGroupDesc=""
			i myGroupID'="" s myGroupDesc=$p(^SSU("SSGRP", myGroupID),"^",1)
			
			;s %request.Data("SSUSERGROUPDESC",1)=myGroupDesc
			
			;s myLocationID=$p($g(^SSU("SSUSR",userid)),"^",4)		;location
			;s myLocationDesc=""
			;i myLocationID'="" s myLocationDesc=$p($g(^CTLOC(myLocationID)),"^",2)
			;set %session.Data("LOGON.CTLOCID")=myLocationID
			;s department=myLocationDesc
			;i myLocationDesc=""{
			;	s STATUS="NOTGET_DEPT"
			;}
		}else{
			;提示选择登录科室
			s STATUS="SELECT_DEPT"
		}
		//GR 30/7/02 log26776 need to allocate correct group settings if the group is changed at login time
		s %request.Data("PASSWORD",1)=$g(password)
		i $g(%request.Data("SSUSERGROUPDESC",1))'="" s grpid=##Class(web.SSGroup).GetIdFromCodeOrDescription(%request.Data("SSUSERGROUPDESC",1))
		//w grpid
		;设置 用户基本的Session信息 zhaocz 2009-05-16
		d ##Class(web.SSUser).SetUserSessionData(userid,$g(grpid))
		//overwrite system config for application timeout
		d ##Class(epr.GroupSettings).SetGroupSessionTimeout($g(%session.Data("LOGON.GROUPID")))
		;
		&sql(SELECT SSUSR_ChangeLocation,SSUSR_DefaultDept_DR->CTLOC_Desc
		     INTO :changeloc,:loc
		     FROM SQLUser.SS_User
		     WHERE SSUSR_ROWID=:userid
		)
		i SQLCODE s changeloc="",loc=""
		i loc="" s blankDefaultLoc=1
		;S locid=##Class(web.CTLoc).GetIdFromCodeOrDescription(department)
		;KK 7/10/03 L:38430
		//update by zf 20110530
		s locid=##Class(web.SSUserOtherLogonLoc).CheckLoginLocation(department,"1")
		//s locid=##Class(web.SSUserOtherLogonLoc).CheckLoginLocation(department)
		b	;
		if (locid="") {
			if department'="" S STATUS="INVALID_DEPT" s %request.Data("DEPARTMENT",1)="" ;S STATUS=$g(t("INVALID_DEPT"),"Please enter a valid Department")
			if department="" {
				i loc'="" s department=loc s %request.Data("DEPARTMENT",1)=department ;need to set %request for component
				i changeloc'="Y" s locIsDisabled=1
			}
		}
		s roundid=##Class(web.CTCareProv).GetIdFromCodeOrDescription(round)
		if (roundid="") {
			;if round'="" s STATUS=$g(t("ROUND_CAREPROV"),"Please enter a valid Round Care Provider"),roundok=0
			if round'="" s STATUS="ROUND_CAREPROV",roundok=0
		} else {
			s %session.Data("LOGON.ROUND")=roundid		
			s %session.Data("LOGON.ROUNDDESC")=round
		}
		;log 33697 GR
		;JW removed
		;s locatid=##Class(web.CTLoc).GetIdFromCodeOrDescription(department)
		;s %session.Data("LOGON.CTLOCID")=locatid
		;s hosp=""
		;s hosp=$p($g(^CTLOC(+locatid)),"^",22)
		;s ^zgav($zn)=locatid_"^"_department
		;i changeinlogonhosp="Y" s %request.Data("changeinlogonhosp",1)=hosp
		;
		; go straight in if we can
		i (overrideauth) s locid=##Class(web.CTLoc).GetIdFromCodeOrDescription(department)
		;
		b	;roundok locid
		if roundok,locid'="" {
			s %session.Data("LOGON.CTLOCID")=locid
			s %session.Data("LOGON.CTLOCDESC")=department
			s hospid=$p($g(^CTLOC(+locid)),"^",22),%session.Data("LOGON.HOSPID")=hospid
			s hospdesc=$p($g(^CT("HOSP",+hospid)),"^",2),%session.Data("LOGON.HOSPDESC")=hospdesc
			s trustid=##Class(web.CTHospital).getTrustId(hospid),%session.Data("LOGON.TRUSTID")=trustid
			s trustdesc=$p($g(^PAC("TRUST",+trustid)),"^",2),%session.Data("LOGON.TRUSTDESC")=trustdesc
			//jump to emr screen/floor plan
			b	;;;EPR Frames
			i ##Class(epr.GroupSettings).GetStartPage($g(%session.Data("LOGON.GROUPID")))'="" s %response.ServerSideRedirect="epr.frames.csp"
			i %response.ServerSideRedirect="" s %response.ServerSideRedirect="websys.frames.csp"
			// if this is a successful re-logon then do 重新登录 需要刷新界面
			i $g(%request.Data("RELOGON",1))'="" s %response.ServerSideRedirect="logonrefresh.csp"
		}
		// does user need to change password?
		s forcePasswordChange=##Class(web.SSUser).IsRequiredToChangePassword(userid,$g(%session.Data("LOGON.GROUPID")))
		;i forcePasswordChange s %response.ServerSideRedirect="",STATUS=$g(t("PWD_EXPIRED"),"Password Expired, Please Change your Password")
		;i forcePasswordChange s %response.ServerSideRedirect="",STATUS="PWD_EXPIRED"
		;,'forcePasswordChange  用户登录都要记录
		if locid'="" s %session.Data("LOGON.SSUSERLOGINID")=##Class(web.SSUserLogin).Insert(userid)
		;
		; Kill Session Data for Logon Attempts
		s %session.Data("LogonAttempts")=""
		
	}
 }
 
 ;fetch translations at end to make sure %session("LOGON.LANGID") has been set correctly
 d ##Class(websys.Component).GetComponentMessages(.t,"websys.SYSTEM,SSUserPortalLogon")
 set %session.Data("XMONTHSSHORT")=$g(t("XMONTHSSHORT"),"Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec")
 b	;Message
 
 i STATUS'="" d
 . i STATUS'="INVALID_LOGON1" s STATUS=$g(t(STATUS))
 . i STATUS="INVALID_LOGON1" s STATUS=$g(t("INVALID_LOGON1"))_LogonAttempts_$g(t("INVALID_LOGON2"))
 s welcometitle=$g(t("WELCOME_TITLE"),"欢迎 ")
 ; RQG 15.01.03 Log31643
 //SP Hack for TrakCare Release
 s medtrakver=$g(t("MEDTRK_VERSION"),"TrakCare Version W650")
 //s medtrakver="TrakCare Version W650"
 s copyright=$g(t("COPYRIGHT"),"All Material Copyright ")
 //SP Hack for TrakCare Release
 //s copyrighttitle=$g(t("COPYRIGHT_TITLE"),"2001-2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED.")
 s copyrighttitle="2001-2009 TrakHealth Pty. Limited. ALL RIGHTS RESERVED."
 s traktooltip1=$g(t("TRAK_CAPTION"),"TrakHealth: Keep everything in your hospital on Trak")
 //SP Hack for TrakCare Release
 //s traktooltip2=$g(t("MEDTRK_FROM_TRAK"),"TrakCare from TrakHealth")
 s traktooltip2="TrakCare from TrakHealth"
 ;
 if (%response.ServerSideRedirect'="")
 {
 }
 
 i %response.ServerSideRedirect'="" quit 0
 
	q mystatus
}

/// 直接登录控制
/// 功能： 1. 提供使用者能够按照Portal方式登录，同时能够使用密文登录， 而不是原文登录
///        2. 提供给使用者超时判断
/// d ##class(web.portal.SessionLogon).LogonDirect()
ClassMethod LogonDirect() As %Boolean
{
 	s username=$g(%request.Data("USERNAME",1))
 	s password=$g(%request.Data("PASSWORD",1))
	s department=$g(%request.Data("DEPARTMENT",1))
	
	s myrtnflag=1
	s mycsppage=%request.PageName
	s ^ZF(111)=mycsppage
	;myrlflag=1 没有登录
	
	s myportflag=((username'="")&&(password'="")&&(department'=""))
	if (+myportflag){
		s myrlflag=(('$d(%session.Data("LOGON.USERID")))!($g(%session.Data("LOGON.USERID"))=""))
		if (myrlflag){
			;没有登录
			s myrtnflag=##Class(web.portal.SessionLogon).Logon()
			;s ^TMPDFDFDFDFD=myrtnflag_"^"_%response.ServerSideRedirect_"^"_mycsppage
			i ((+myrtnflag=0)&&(mycsppage'="")){
				;登录成功， 跳转到调用界面
				s %response.ServerSideRedirect=mycsppage
			}else{
				s %response.ServerSideRedirect="logon.csp"
			}
			
		}
	}else{
		;不是portal登录
		d ##Class(websys.SessionEvents).SessionExpired()
	}
	
	q myrtnflag
}

ClassMethod License(type As %String = "TC")
{
}

ClassMethod UnLicense()
{
}

ClassMethod CheckLicense() As %String [ ProcedureBlock = 1 ]
{
}

ClassMethod AddLicenseCount() [ ProcedureBlock = 1 ]
{
}

ClassMethod ResetLicenseCount(resetMedTrak As %Boolean = 0) [ ProcedureBlock = 1 ]
{
}

ClassMethod InitialiseSession() [ ProcedureBlock = 1 ]
{
	s LogonAttempts=$g(%session.Data("LogonAttempts"))
	s PreviousUser=$g(%session.Data("PreviousUser")) 
	
	kill %session.Data
	
	set %session.Data("LogonAttempts")=LogonAttempts
	s %session.Data("PreviousUser")=PreviousUser
	//Initialise all the core session data
	set %session.Data("LOGON.CTLOCID")=""
	set %session.Data("LOGON.SITECODE")=""
	set %session.Data("LOGON.USERID")=""
	set %session.Data("LOGON.USERCODE")=""
	set %session.Data("LOGON.USERNAME")=""
	set %session.Data("LOGON.GROUPID")=""
	set %session.Data("LOGON.GROUPDESC")=""
	set %session.Data("LOGON.LANGID")=""
	set %session.Data("LOGON.GROUPMENUS")=""
	set %session.Data("LOGON.LAYOUTMANAGER")=""
	set %session.Data("LOGON.ALLOWLAYOUTMANAGER")=""
	set %session.Data("LOGON.ALLOWCOLUMNMANAGER")=""
	set %session.Data("LOGON.PPMCAPTURE")=""
	set %session.Data("LOGON.PPMDISPLAY")=""
	set %session.Data("LOGON.ROUND")=""
	set %session.Data("LOGON.ROUNDDESC")=""
	set %session.Data("LOGON.HOSPID")=""
	set %session.Data("LOGON.HOSPDESC")=""
	set %session.Data("LOGON.TRUSTID")=""
	set %session.Data("LOGON.TRUSTDESC")=""
	set %session.Data("LOGON.SSUSERLOGINID")=""
	set %session.Data("TITLE")=""
	set %session.Data("LOGON.TIMEOUT")="900"
	;set %session.Data("LOGON.TIMEOUT")="20"
	; Do this because CSP only sends CGI with POST requests, but we need to log eveything in ComponentAudit
	set %session.Data("REMOTE_ADDR")=%request.GetCgiEnv("REMOTE_ADDR")
	set %session.Data("COMPUTER_NAME")=##Class(websys.Conversions).GetComputerName(%session.Data("REMOTE_ADDR"))
	;set %session.Data("COMPUTER_NAME")="XXXwombat"
	; Used to detemine if we are connecting to the code table server
	set %session.Data("SERVER_NAME")=%request.GetCgiEnv("SERVER_NAME")
	
	;P8 新增Session
	s %session.Data("LOGON.REGION")=""
	s %session.Data("LICENSE.TC")=""
	s %session.Data("SYS.LANGID")=""
	s %session.Data("SYS.TIMEOUT")=""
}

}
