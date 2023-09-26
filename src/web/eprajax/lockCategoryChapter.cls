Class web.eprajax.lockCategoryChapter Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	//通过系统参数打开电子病历书写锁定功能
	s eprLock = ##class(EPRmeta.SysOption).GetOptionValueByName("EPRLock")
	if (eprLock '= "Y")
	{
		w ""
        Quit $$$OK
	}
	
	//取session
	s ssid = %session.SessionId
	s userid = %session.Get("LOGON.USERID")
	s ctlocid = %session.Get("LOGON.CTLOCID")
	
	//取入参
	s episodeID = $Get(%request.Data("EpisodeID",1),"-1")
	s categoryChapterID = $Get(%request.Data("CategoryChapterID",1),"-1")
	//上次加锁的ID
	s lastCategoryChapterID = $Get(%request.Data("LastCategoryChapterID",1),"")

    // 加锁
    s returnmsg = ""	    
	//如果需加锁新的ID，则将之前的ID解锁
    if ((lastCategoryChapterID '= "") && (categoryChapterID '= lastCategoryChapterID))
    {
	    d ##Class(websys.Lock).LockClear($lb(episodeID_"-"_lastCategoryChapterID, "DHC.EPR"), ssid)
    }                                          
    s oid = episodeID_"-"_categoryChapterID
    if (..LockRecord(oid, "DHC.EPR", ssid, userid, ctlocid) = "1")
    {
	    //成功
        w ""
    }    
    else
    {
	    //失败 返回加锁用户的信息
        w ##Class(websys.Lock).GetLockedUser($lb(oid, "DHC.EPR"))
        //w ""
    }

    Quit $$$OK
}

/// w ##Class(web.eprajax.lockCategoryChapter).LockRecord("ssid","DHC.EPR","User","ctlocid","id")
ClassMethod LockRecord(oid As %String, className As %String, sessionid As %Library.String, userid As %Library.String, loginlocation As %Library.String = "") As %String
{
	s returnmsg = ""
	if (##Class(websys.Lock).Lock($lb(oid, className), sessionid, userid, returnmsg, loginlocation) = 1)
	{
        s Id = ""
        s Id = $o(^websys.LockI("Lock", className, oid, sessionid, Id))		
        q:Id="" "0"
        //在同一台机器上，登录两个用户，系统会自动将该机器上所有的锁清除掉
        //所以必须改变机器的名字
		Set obj = ##class(websys.Lock).%OpenId(Id)  
		s obj.Computer = "IP:"_obj.Computer
		//s obj.ComputerName = "Computer:"_obj.ComputerName
	    d obj.%Save()
	    d obj.%Close()
	    q "1"
	}
	q "0"
}

}
