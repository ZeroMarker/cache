/// Description：体检锁
/// 		参照:websys.lock
/// 		因websys.lock需要有持久化对象的oid,而一些体检业务加锁可能具体不到oid,特拓展体检锁，进行体检业务加锁
/// 		新加体检锁时应同步生成websys.lock，且持久化对象为User.DHCPELock：
/// 		因为websys.lock 会在切换菜单或session注销时自动释放（详见websys.SessionEvents）
/// 		当然也可以在websys.SessionEvents时增加释放体检锁的代码，无需生成websys.lock。
/// 		为保持websys的一致通用性，且不影响HIS其他业务,本类采用以下方法：
/// 		体检加锁时判断若业务锁存在但websys.lock对应值不存在时，自动释放过期的体检锁。
/// 		拓展：保险起见，可增加定时任务每晚定时清除体检锁:d ##class(web.DHCPE.Lock).PELockClear()
/// 
/// 	
/// Creator：wangguoying
Class web.DHCPE.Lock Extends %RegisteredObject
{

/// Descript:业务加锁
/// Input:
/// 				bId：	业务ID
/// 				bType：	业务类型  AR:报告初审  MAR:报告复审
/// 				sessionid：sessionId
/// 				userid：用户ID
/// 				loginloc：登录科室
/// Return: 	""：成功 	非空：失败  
/// Creater:	wangguoying
/// CreateDate:	2020-08-12
/// Debug: w ##class(web.DHCPE.Lock).Lock(4245,"AR","PCHaFi6A46",923,20)
ClassMethod Lock(bId As %Library.String, bType As %Library.String, sessionid As %Library.String = "", userid As %Library.String = "", loginloc As %Library.String = "")
{
	set $ZT="LockErr"
	set returnmsg=""
	if sessionid="" s sessionid=%session.SessionId
	if userid="" s userid=%session.Data("LOGON.USERID")
	if loginloc="" s loginloc=%session.Data("LOGON.CTLOCID")
	
	TSTART
	
	if $d(^User.DHCPELockI("Lock",bType,bId)){
		//先检查websys.lock是否存在，不存在说明已有的体检锁过期
		s LockSessionId=$O(^User.DHCPELockI("Lock",bType,bId,0))
		set LockId=$O(^User.DHCPELockI("Lock",bType,bId,LockSessionId,0))
		set websysId=$O(^websys.LockI("Lock","User.DHCPELock",LockId,LockSessionId,0))
		if websysId="" d ..LockClear(bId,bType,LockSessionId)
	}
	
	if $d(^User.DHCPELockI("Lock",bType,bId)){
		s LockSessionId=$O(^User.DHCPELockI("Lock",bType,bId,0))
		set LockId=$O(^User.DHCPELockI("Lock",bType,bId,LockSessionId,0))
		set websysId=$O(^websys.LockI("Lock","User.DHCPELock",LockId,LockSessionId,0))
		
		if sessionid=LockSessionId {
		}else{
			
			set lockobj=##class(User.DHCPELock).%OpenId(LockId)
			if $IsObject(lockobj) {
				set UserName=""
				set UserId=lockobj.UserDR
				if UserId>0{
					set UserName=$P(^SSU("SSUSR",UserId),"^",2)
				}
				set Computer=lockobj.Computer
				set ComputerName=lockobj.ComputerName
			
				set LocDesc=""
				set LogonLocId=lockobj.LoginLoc
				if LogonLocId>0{
					set LocDesc=$p(^CTLOC(LogonLocId),"^",2)
					if ($l(LocDesc,"-")>1) set LocDesc=$p(LocDesc,"-",2)
				}
				set lockdate=##class(websys.Conversions).DateLogicalToHtml(lockobj.LockDate)_" "_$ZT(lockobj.LockTime)
				d ##Class(websys.Component).GetComponentMessages(.t,"websys.SYSTEM")
				set returnmsg=$g(t("XLOCKED"))_"("_UserName_" | "_LocDesc_" | "_Computer_" | "_ComputerName_" | "_lockdate_")"
				Set lockobj=""
			}else{
				set returnmsg="lock fail!"
			}
		}
		TCOMMIT
		Q returnmsg
	}
	set lobj=##class(User.DHCPELock).%New()
	set lobj.BusType=bType
	set lobj.Computer=%session.Data("REMOTE_ADDR")
	Set ClientComputerName = %session.Data("COMPUTER_NAME")
	Set ssuserLoginId = $G(%session.Data("LOGON.SSUSERLOGINID"))
	if ssuserLoginId>0 {
		Set ClientComputerName = $p($g(^SST("LOG",ssuserLoginId,"ADDR")),"^",4)
	}
	set lobj.ComputerName= ClientComputerName
	set lobj.BusId=bId
	set lobj.LoginLoc=loginloc
	set lobj.SessionId=sessionid
	set lobj.UserDR=userid
	set sc=lobj.%Save()
	if $system.Status.IsError(sc){
		TROLLBACK
		quit $system.Status.GetErrorText(sc)
	}
	set lockId=lobj.%Id()
	s return=##class(websys.Lock).Lock($Lb(lockId,"User.DHCPELock"),sessionid,userid,.returnmsg,loginloc)
	i return=1
	{
		TCOMMIT
	}else{
		TROLLBACK
	}
	quit returnmsg
LockErr
	s $ZT=""
	i $TL>0 TROLLBACK
	q $ZE
}

/// Descript:获取业务锁信息
/// Input:
/// 				bId：	业务ID
/// 				bType：	业务类型  AR:报告初审  MAR:报告复审
/// Return: 	体检测试1 | 体检中心 | 192.169.106.27 LD-20190606VCXK | 2020-08-12 13:19:52
/// Creater:	wangguoying
/// CreateDate:	2020-08-12
/// Debug: w ##class(web.DHCPE.Lock).GetLockedUser(2678,"AR")
ClassMethod GetLockedUser(bId As %Library.String, bType As %Library.String) As %Library.String
{
	
	set LockSessionId=$O(^User.DHCPELockI("Lock",bType,bId,0))
	Quit:LockSessionId="" ""
	
	set LockId=$O(^User.DHCPELockI("Lock",bType,bId,LockSessionId,0))
	Quit:LockId="" ""

	Set objLock=##class(User.DHCPELock).%OpenId(LockId)
	
	Set UserName=$p($g(^SSU("SSUSR",objLock.UserDR)),"^",2)
	
	Set CtLocDesc=$p($g(^CTLOC(objLock.LoginLoc)),"^",2)
	
	Set LockDateTime=##class(websys.Conversions).DateLogicalToHtml(objLock.LockDate)_" "_$zt(objLock.LockTime)
	
	Set ReturnVaule=UserName_" | "_CtLocDesc_" | "_objLock.Computer_" "_objLock.ComputerName_" | "_LockDateTime
	quit ReturnVaule
}

ClassMethod LockClear(bId As %Library.String, bType As %Library.String, sessionid As %Library.String)
{
	quit:(bId="")||(bType="")||(sessionid="") 
	set lockId=$o(^User.DHCPELockI("Lock",bType,bId,sessionid,0))
	if lockId'="" 
	{
		do ##class(websys.Lock).LockClear($lb(lockId,"User.DHCPELock"),sessionid)
		do ##class(User.DHCPELock).%DeleteId(lockId)
	}	
	quit
}

ClassMethod LockClearLast(bId As %Library.String, bType As %Library.String)
{
	set lockId = ""
	For {
		s lockId = $O(^User.DHCPELockI("IndOfLocUserCpTypeID",$C(32)_%session.Get("LOGON.CTLOCID"),$C(32)_%session.Get("LOGON.USERID"),$C(32)_%session.Data("REMOTE_ADDR"),bType,bId,lockId))
		q:lockId=""
		do ##class(websys.Lock).LockClear($lb(lockId,"User.DHCPELock"),$lg(^User.DHCPELockD(lockId),9))
		do ##class(User.DHCPELock).%DeleteId(lockId)
			
	}	
	quit
}

ClassMethod LockClearTypeAndSession(bType As %Library.String, sessionid As %Library.String)
{
	s:sessionid="" sessionid = %session.SessionId
	s lockId=0
	f  s lockId=$O(^User.DHCPELockI("SessionId",sessionid,lockId)) q:lockId=""  d
	.do ##class(websys.Lock).LockClear($lb(lockId,"User.DHCPELock"),sessionid)
	.do ##class(User.DHCPELock).Delete(lockId)
	quit ""
}

/// d ##class(web.DHCPE.Lock).PELockClear()
ClassMethod PELockClear()
{
	Kill ^User.DHCPELockI
	Kill ^User.DHCPELockD
	quit
}

/// Description：查询现有锁信息
/// Input：
/// Return：
/// Creator： wangguoying
/// CreateDate： 2021-12-20
/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.Lock",QueryLoc)
Query QueryLock(Type = "", BusID = "", ComputerIP = "", UserID = "") As websys.Query(ROWSPEC = "TID:%String,TBusType:%String,TBusDesc:%String,TBusId:%String,TComputerIP:%String,TsessionId:%String,TLockUserId:%String,TLockUserName:%String,TLockLoc:%String,TLockLocDesc:%String,TLockDate:%String,TLockTime:%String") [ SqlProc ]
{
}

ClassMethod QueryLockExecute(ByRef qHandle As %Binary, Type = "", BusID = "", ComputerIP = "", UserID = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s type = ""
	f  s type = $O(^User.DHCPELockI("Lock",type)) q:type=""  d
	.q:(Type'="")&&(type'="")
	.s sourceId = ""
	.f  s sourceId = $O(^User.DHCPELockI("Lock",type,sourceId)) q:sourceId=""  d
	..q:(BusID'="")&&(BusID'=sourceId)
	..s sessionId = ""
	..f  s sessionId = $O(^User.DHCPELockI("Lock",type,sourceId,sessionId)) q:sessionId=""  d
	...s id = ""
	...f  s id = $O(^User.DHCPELockI("Lock",type,sourceId,sessionId,id)) q:id=""  d
	....//无效的锁 自动释放
	....s websysId=$O(^websys.LockI("Lock","User.DHCPELock",id,sessionId,0))
	....i websysId="" d ..LockClear(sourceId,type,sessionId) q

	....s lockUserId = $LISTGET(^User.DHCPELockD(id),10)
	....q:(UserID'="")&&(lockUserId'=UserID)
	....s lockUserName = $P(^SSU("SSUSR",lockUserId),"^",2)
	....s busDesc = ..GetBusDesc(type)
	....s ip = $LISTGET(^User.DHCPELockD(id),3)
	....q:(ComputerIP'="")&&(ip'=ComputerIP)
	....s lockDate = $LISTGET(^User.DHCPELockD(id),6)
	....s lockDate = ##class(websys.Conversions).DateLogicalToHtml(lockDate)
	....s lockTime = $LISTGET(^User.DHCPELockD(id),7)
	....s lockTime = ##class(websys.Conversions).TimeLogicalToHtml(lockTime)
	....s lockLoc = $LISTGET(^User.DHCPELockD(id),8)
	....s lockLocDesc = $PIECE(^CTLOC(lockLoc),"^",2)
	....set Data=$lb(id,type,busDesc,sourceId,ip,sessionId,lockUserId,lockUserName,lockLoc,lockLocDesc,lockDate,lockTime)
	....Set ^CacheTemp(repid,ind)=Data
	....Set ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Description：加锁业务类型描述
/// Input：
///               Code : 业务代码 
/// Return：       
/// Creator：     wangguoying
/// CreateDate：  2021-12-20
/// Debug: w ##class(web.DHCPE.Lock).GetBusDesc(1)
ClassMethod GetBusDesc(Code)
{
	q:Code="AR" "报告初审"
	q:Code="MR" "报告复审"
	q ""
}

/// Debug：d ##class(%ResultSet).RunQuery("web.DHCPE.Lock","QueryBusType")
Query QueryBusType() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod QueryBusTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
	s inStr = "AR^MR"
	f i=1:1:$L(inStr,"^") d
	.s id = $P(inStr,"^",i)
	.s desc = ..GetBusDesc(id)
    .s ^CacheTemp(repid,ind)=$lb(id,desc)
    .s ind = ind + 1 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
