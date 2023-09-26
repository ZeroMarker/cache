/// 名称: web.DHCBillLockAdm.cls
/// 描述: 计费公共session锁
/// 编写者: Lid
/// 编写日期: 2015-12-12
/// 产品组：计费医保组
Class web.DHCBillLockAdm Extends %RegisteredObject
{

/// Creator: Lid
/// CreatDate: 2015-12-12
/// Descripion: 结算界面加锁
/// Input: admStr:就诊RowId串(多个之间以"^"分割)，lockType:锁定类型，默认与医生站的相同(User.OEOrder)
/// Return: 空时，没有锁定记录，不为空时为锁定信息
/// Debug: w ##class(web.DHCBillLockAdm).LockAdm(631369)
ClassMethod LockAdm(admStr As %String, lockType As %String = "User.OEOrder") As %String
{
	set sessionId=%session.SessionId
	set userId=%session.Get("LOGON.USERID")
	set ctlocId=%session.Get("LOGON.CTLOCID")
	set langId=%session.Get("LOGON.LANGID")
	set msg=""
	set count=$l(admStr,"^")
	for i=1:1:count {
		set adm=$p(admStr,"^",i)
		continue:(adm="")
		set order=$o(^OEORD(0,"Adm",adm,0))
		continue:(order="")
		set admData=$g(^PAADM(adm))
		set admType=$p(admData,"^",2)
	 	set admDeptDR=$p(admData,"^",4)
	 	set admDept=$s((+admDeptDR'=0):$p($g(^CTLOC(admDeptDR)),"^",2),1:"")
	 	set admDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admDept, langId)
	 	set admDocDR=$p(admData,"^",9)
	 	set admDoc=$s((+admDocDR'=0):$p($g(^CTPCP(admDocDR,1)),"^",2),1:"")
	 	set admDoc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", admDoc, langId)
	 	set admDocDept=admDept_admDoc
	 	set timeout=..GetLockTimeout(admType)
		set warning=""
		do ##class(websys.Lock).Lock($lb(order,lockType), sessionId, userId, .warning, ctlocId, timeout)
		if (warning="") {
			do ##class(websys.Lock).Lock($lb(order,lockType_".Stop"), sessionId, userId, .warning, ctlocId, timeout)
		}
		//if (warning'="") &html<<DIV><STRONG><FONT COLOR=RED><%=warning%></FONT></STRONG></DIV>>
		if (warning'="") {
			set tmp=$p(warning,"(",2)
			set tmp=admDocDept_" "_##class(websys.Translation).Get("bill.chg.lock", "号被以下锁定", langId)_":("_tmp
			set msg=$s((msg=""):tmp,1:(msg_"^"_tmp))
		}
	}
	quit msg
}

/// Creator: Lid
/// CreatDate: 2015-12-12
/// Descripion: 结算界面解锁
/// Input: admStr:就诊RowId串(多个之间以"^"分割)，lockType:锁定类型，默认与医生站的相同(User.OEOrder)
/// Return: 空时，没有锁定记录，不为空时为锁定信息
/// Debug: w ##class(web.DHCBillLockAdm).UnLockAdm(631369)
ClassMethod UnLockAdm(admStr As %String, lockType As %String = "User.OEOrder") As %String
{
	set sessionId=%session.SessionId
	set count=$l(admStr,"^")
	for i=1:1:count {
		set adm=$p(admStr,"^",i)
		continue:(+adm=0)
		set order=$o(^OEORD(0,"Adm",adm,0))
		continue:(order="")
		do ##class(websys.Lock).LockClear($lb(order,lockType), sessionId)
		do ##class(websys.Lock).LockClear($lb(order,lockType_".Stop"), sessionId)
	}
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2023-02-22
/// Descripion: 获取session锁设置的超时时间
/// Input: admType:就诊类型代码(I:住院, O:门诊, E:急诊, H:体检)
/// Return: 超时时间(以秒为单位)
/// Debug: w ##class(web.DHCBillLockAdm).GetLockTimeout()
ClassMethod GetLockTimeout(admType As %String = "O") As %String
{
	quit:(admType="I") 600
	quit 300
}

}
