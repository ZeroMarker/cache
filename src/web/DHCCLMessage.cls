Class web.DHCCLMessage Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCCLMessage","FindCLCMessage","10")
Query FindCLCMessage(ClcmCtlocDr) As %Query(ROWSPEC = "tClcmId:%String,tClcmCtlocDr:%String,tClcmCtloc:%String,tClcmUserGroupDr:%String,tClcmUserGroup:%String,tClcmClientIP:%String,tClcmLastReceiveDate:%String,tClcmLastReceiveTime:%String") [ SqlProc ]
{
}

ClassMethod FindCLCMessageExecute(ByRef qHandle As %Binary, ClcmCtlocDr) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	q:ClcmCtlocDr=""
 	s tClcmId=0
	f  s tClcmId=$o(^DHCCLC("Message",0,"Ctloc",ClcmCtlocDr,tClcmId)) q:tClcmId=""  d
	    .s tClcmCtlocDr=$lg(^DHCCLC("Message",tClcmId),1)
	    .q:tClcmCtlocDr=""
	    .s tClcmCtloc=$p($g(^CTLOC(tClcmCtlocDr)),"^",2)
	    .s tClcmUserGroupDr=$lg(^DHCCLC("Message",tClcmId),2)
	    .s tClcmUserGroup=$p($g(^SSU("SSGRP",tClcmUserGroupDr)),"^",1)
	    .s tClcmClientIP=$lg(^DHCCLC("Message",tClcmId),3)
	    .s tClcmLastReceiveDate=$zd($lg(^DHCCLC("Message",tClcmId),4),3)
	    .s tClcmLastReceiveTime=$zt($lg(^DHCCLC("Message",tClcmId),5),2)
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tClcmId,tClcmCtlocDr,tClcmCtloc,tClcmUserGroupDr,tClcmUserGroup,tClcmClientIP,tClcmLastReceiveDate,tClcmLastReceiveTime)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindCLCMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCLCMessageExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCLCMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCLCMessageExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod InsertCLCMessage(clcmCtlocDr, clcmUserGroupDr, clcmClientIP, clcmLastReceiveDate, clcmLastReceiveTime) As %String
{
	q:clcmCtlocDr="" "科室ID不能为空!"
	s objClcmessage = ##class(User.DHCCLCMessage).%New()
	s objClcmessage.CLCMCtlocDr=clcmCtlocDr
	s objClcmessage.CLCMUserGroupDr=clcmUserGroupDr
	s objClcmessage.CLCMClientIP=clcmClientIP
	s objClcmessage.CLCMLastReceiveDate=$zdh(clcmLastReceiveDate,3)
	s objClcmessage.CLCMLastReceiveTime=$zth(clcmLastReceiveTime,2)
	s saveStatus=objClcmessage.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s clcmeId=objClcmessage.%Id()
	d objClcmessage.%Close()
	q 0
}

ClassMethod UpdateCLCMessage(clcmId, clcmCtlocDr, clcmUserGroupDr, clcmClientIP) As %String
{
	q:clcmId="" "RowId不能为空!"
	q:clcmCtlocDr="" "科室ID不能为空!"
	q:'##class(User.DHCCLCMessage).%ExistsId(clcmId) "日志码表指针无对应记录!"
	s objClcmessage = ##class(User.DHCCLCMessage).%OpenId(clcmId)
	s objClcmessage.CLCMCtlocDr=clcmCtlocDr
	s objClcmessage.CLCMUserGroupDr=clcmUserGroupDr
	s objClcmessage.CLCMClientIP=clcmClientIP
	s updateStatus=objClcmessage.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s clcmeId=objClcmessage.%Id()
	d objClcmessage.%Close()
	q 0
}

ClassMethod DeleteCLCMessage(clcmId) As %String
{
	q:clcmId="" "RowId不能为空!"
	q:'##class(User.DHCCLCMessage).%ExistsId(clcmId) "日志码表指针无对应记录!"
	s deleteStatus=##class(User.DHCCLCMessage).%DeleteId(clcmId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

Query FindCLMessage(ctlocId, fromDate, toDate, clmClientip) As %Query(ROWSPEC = "tClmId:%String,tCtlocId:%String,tClmUserGroup:%String,tClmClientip:%String,tClmNote:%String,tClmSource:%String,tClmIfSent:%String,tClmType:%String,tClmDate:%String,tClmTime:%String,tClmUser:%String") [ SqlProc ]
{
}

ClassMethod FindCLMessageExecute(ByRef qHandle As %Binary, ctlocId, fromDate, toDate, clmClientip) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tCtlocId=ctlocId
 	q:tCtlocId=""
 	f date=fromDate:1:toDate d
 	  .s tClmId=0
 	  .f  s tClmId=$o(^DHCCLMessage(0,"CtlocDate",tCtlocId,date,tClmId))  q:tClmId=""  d
 	     ..s tClmUserGroupId=$lg(^DHCCLMessage(tClmId),2)
 	     ..s tClmUserGroup=$p($g(^SSU("SSGRP",tClmUserGroupId)),"^",1)
 	     ..s tClmClientip=$lg(^DHCCLMessage(tClmId),3)
 	     ..q:((clmClientip'="")&("|"_clmClientip_"|"'["|"_tClmClientip_"|"))!(clmClientip="")
 	     ..s tClmNote=$lg(^DHCCLMessage(tClmId),4)
 	     ..s tClmSource=$lg(^DHCCLMessage(tClmId),5)
 	     ..s tClmIfSent=$lg(^DHCCLMessage(tClmId),6)
 	     ..s tClmType=$lg(^DHCCLMessage(tClmId),7)
 	     ..s tClmDate=$zd($lg(^DHCCLMessage(tClmId),8),3)
 	     ..s tClmTime=$zt($lg(^DHCCLMessage(tClmId),9),2)
 	     ..s tClmUserId=$lg(^DHCCLMessage(tClmId),10)
 	     ..s tClmUser=$p(^SSU("SSUSR",tClmUserId),"^",2)
 	     ..d OutputRow11
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow11
	s Data=$lb(tClmId,tCtlocId,tClmUserGroup,tClmClientip,tClmNote,tClmSource,tClmIfSent,tClmType,tClmDate,tClmTime,tClmUser)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindCLMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCLMessageExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCLMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCLMessageExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetMessage(ctLocId As %String, ipAddress As %String) As %String
{
	s msgCodeRowId=0,curMsgCodeRowId=0,lastRecvDate="",lastRecvTime=""
	f  s msgCodeRowId=$o(^DHCCLC("Message",0,"Ctloc",+ctLocId,msgCodeRowId)) q:msgCodeRowId=""  d
	.s msgIPAddress=$li(^DHCCLC("Message",msgCodeRowId),3)
	.i (msgIPAddress=ipAddress)  d
	..s lastRecvDate=$li(^DHCCLC("Message",msgCodeRowId),4)
	..s lastRecvTime=$li(^DHCCLC("Message",msgCodeRowId),5)
	..i (lastRecvDate'="" & lastRecvTime'="") s curMsgCodeRowId=msgCodeRowId
	..q:(lastRecvDate'="" & lastRecvTime'="")
	
	s msgRowId=0
	s retStr=""
	i (lastRecvDate'="")&(lastRecvTime'="")  d
	.s lastRecvDate=lastRecvDate-1
	.f  s lastRecvDate=$o(^DHCCLMessage(0,"CtlocDate",+ctLocId,+lastRecvDate)) q:lastRecvDate=""  d
	..s msgRowId=0
	..f  s msgRowId=$o(^DHCCLMessage(0,"CtlocDate",+ctLocId,lastRecvDate,msgRowId)) q:msgRowId=""  d
	...s msgIPAddress=$li(^DHCCLMessage(msgRowId),3)
	...q:(msgIPAddress'="")&(msgIPAddress=ipAddress)
	...s msgDate=$li(^DHCCLMessage(msgRowId),8)
	...s msgDate=##class(web.DHCClinicCom).ConvertToDate(msgDate)
	...s msgTime=$li(^DHCCLMessage(msgRowId),9)
	...q:(msgTime<=lastRecvTime)
	...s msgTime=##class(web.DHCClinicCom).ConvertToTime(msgTime)
	...s msgNote=$li(^DHCCLMessage(msgRowId),4)
	...i retStr'="" s retStr=retStr_$c(13)_$c(10)
	...s retStr=retStr_msgDate_" "_msgTime_" "_msgNote
	...s $li(^DHCCLC("Message",curMsgCodeRowId),4)=$li(^DHCCLMessage(msgRowId),8)
	...s $li(^DHCCLC("Message",curMsgCodeRowId),5)=$li(^DHCCLMessage(msgRowId),9)
	
	q retStr
}

}
