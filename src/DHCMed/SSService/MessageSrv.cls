/// 名称: DHCMed.SSService.MessageSrv
/// 描述: 消息常用操作
/// 编写者：liuyh
/// 编写日期: 2010-06-17
Class DHCMed.SSService.MessageSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-06-17
/// Description:  查询该用户发送的消息或该用户对应科室的所有用户发送的消息
/// Table：       SS_Message、DHCMed.SS.Message
/// Input：       UserID : 用户ID LocID : 科室ID
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.MessageSrv","QueryMessageByID",11,"")
Query QueryMessageByID(UserID As %String, LocID As %String) As %Query(ROWSPEC = "rowid:%String,UserID:%String,UserName:%String,CreateDate:%String,CreateTime:%String,Message:%String")
{
}

ClassMethod QueryMessageByIDExecute(ByRef qHandle As %Binary, UserID As %String, LocID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	f  s rowid=$o(^SST("MESS",rowid),-1) q:rowid=""  d
	.s userID=$p($g(^SST("MESS",rowid)),"^",3)
	.q:userID=""
	.s locID=$p(^SSU("SSUSR",userID),"^",4)
	.q:((UserID'="")&(UserID'=userID))
	.q:((LocID'="")&(LocID'=locID))
	.s CreateDate=$p($g(^SST("MESS",rowid)),"^",1)
	.s CreateTime=$p($g(^SST("MESS",rowid)),"^",2)
	.s:CreateDate'="" CreateDate=$zd(CreateDate,3)
	.s:CreateTime'="" CreateTime=$zt(CreateTime)
	.s $li(data,1)=rowid
	.s $li(data,2)=userID
	.s $li(data,3)=$p(^SSU("SSUSR",userID),"^",2)
	.s $li(data,4)=CreateDate
	.s $li(data,5)=CreateTime
	.s $li(data,6)=^SST("MESS",rowid,"TXT",1)
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    q $$$OK
}

ClassMethod QueryMessageByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMessageByIDExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryMessageByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMessageByIDExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2010-06-18
/// Description:  查询所有用户
/// Table：       SS_User
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.MessageSrv","QueryAllUser")
Query QueryAllUser() As %Query(ROWSPEC = "rowid:%String,UserName:%String,UserInitials:%String")
{
}

ClassMethod QueryAllUserExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=0
	f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
	.s UserName=$p($g(^SSU("SSUSR",rowid)),"^",2)
	.s UserInitials=$p($g(^SSU("SSUSR",rowid)),"^",1)
	.s $li(data,1)=rowid
	.s $li(data,2)=UserName
	.s $li(data,3)=UserInitials
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    q $$$OK
}

ClassMethod QueryAllUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllUserExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAllUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllUserExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2010-06-18
/// Description:  查询所有科室
/// Table：       CT_Loc
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.MessageSrv","QueryAllCtloc")
Query QueryAllCtloc() As %Query(ROWSPEC = "rowid:%String,code:%String,desc:%String")
{
}

ClassMethod QueryAllCtlocExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=0
	f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.s code=$p($g(^CTLOC(rowid)),"^",1)
	.s desc=$p($g(^CTLOC(rowid)),"^",2)
	.s $li(data,1)=rowid
	.s $li(data,2)=code
	.s $li(data,3)=desc
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    q $$$OK
}

ClassMethod QueryAllCtlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllCtlocExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAllCtlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllCtlocExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2010-06-18
/// Description:  查询所有科室
/// Table：       SS_Group
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.MessageSrv","QueryAllGroup")
Query QueryAllGroup() As %Query(ROWSPEC = "rowid:%String,desc:%String")
{
}

ClassMethod QueryAllGroupExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=0
	f  s rowid=$o(^SSU("SSGRP",rowid)) q:rowid=""  d
	.s desc=$p($g(^SSU("SSGRP",rowid)),"^",1)
	.s $li(data,1)=rowid
	.s $li(data,2)=desc
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    q $$$OK
}

ClassMethod QueryAllGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllGroupExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAllGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllGroupExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2010-06-18
/// Description:  查询所有科室
/// Table：       SS_Message
/// Input：       MessageDr
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.MessageSrv","QueryAllUserByMegDr",1)
Query QueryAllUserByMegDr(MessageDr As %String) As %Query(ROWSPEC = "rowid:%String,UserName:%String,IsRead:%String,ReadDate:%String,ReadTime:%String")
{
}

ClassMethod QueryAllUserByMegDrExecute(ByRef qHandle As %Binary, MessageDr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:MessageDr="" $$$OK
	s rowid=0
	f  s rowid=$o(^SST("MESSREC",rowid)) q:rowid=""  d
	.s messDr=$p($g(^SST("MESSREC",rowid)),"^",1)
	.q:messDr'=MessageDr
	.s UserDr=$p($g(^SST("MESSREC",rowid)),"^",2)
	.q:UserDr=""
	.s UserName=$p($g(^SSU("SSUSR",UserDr)),"^",2)
	.s ReadDate=$p($g(^SST("MESSREC",rowid)),"^",3)
	.s ReadTime=$p($g(^SST("MESSREC",rowid)),"^",4)
	.s:ReadDate'="" ReadDate=$zd(ReadDate,3)
	.s:ReadTime'="" ReadTime=$zt(ReadTime)
	.s IsRead="N"
	.s:ReadDate'="" IsRead="Y"
	.s $li(data,1)=rowid
	.s $li(data,2)=UserName
	.s $li(data,3)=IsRead
	.s $li(data,4)=ReadDate
	.s $li(data,5)=ReadTime
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    q $$$OK
}

ClassMethod QueryAllUserByMegDrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllUserByMegDrExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAllUserByMegDrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllUserByMegDrExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2010-06-18
/// Description:  通过安全组ID查询该安全组下的用户
/// Table：       SS_Group、SS_User
/// Input：       GroupID
/// w ##class(DHCMed.SSService.MessageSrv).GetUserByGroupID(1)
ClassMethod GetUserByGroupID(GroupID As %String) As %String
{
	n (GroupID)
	s rowid="",ret=-1
	q:GroupID="" ret
	
	f  s rowid=$o(^SSU("SSUSR",0,"Group",GroupID,rowid)) q:rowid=""  d
	.s UserName=$p($g(^SSU("SSUSR",rowid)),"^",2)
	.i ret=-1 d
	..s ret=rowid_"^"_UserName
	.e  d
	..s ret=ret_$c(1)_rowid_"^"_UserName
	
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2010-06-18
/// Description:  通过科室ID查询该科室下的用户
/// Table：       CT_Loc、SS_User
/// Input：       LocID
/// w ##class(DHCMed.SSService.MessageSrv).GetUserByLocID(1)
ClassMethod GetUserByLocID(LocID As %String) As %String
{
	n (LocID)
	s rowid="",ret=-1
	q:LocID="" ret
	
	f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
	.s DefaultDept=$p($g(^SSU("SSUSR",rowid)),"^",4)
	.q:DefaultDept'=LocID
	.s UserName=$p($g(^SSU("SSUSR",rowid)),"^",2)
	.i ret=-1 d
	..s ret=rowid_"^"_UserName
	.e  d
	..s ret=ret_$c(1)_rowid_"^"_UserName
	
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2010-06-18
/// Description:  发送消息给用户
/// Table：       CT_Loc、SS_User
/// Input：       LogonUserID_"^"_Message_$c(1)_UserID_"^"_UserID....
/// w ##class(DHCMed.SSService.MessageSrv).SendMessageToUser()
ClassMethod SendMessageToUser(str As %String) As %String
{
	n (str)
	s rowid="",ret=-1,retValue=0
	q:str="" ret
	
	s tmp=$p(str,$c(1),1)
	s LogonUserID=$p(tmp,"^",1)
	s MessText=$p(tmp,"^",2)
	s Users=$p(str,$c(1),2)
	
	set $ZT="Error"
	TStart
	
	s CreateDate=$p($h,",",1)
	s CreateTime=$p($h,",",2)
	s objMessage=##Class(User.SSMessage).%New()
	s objMessage.MESSDateCreated=CreateDate
	s objMessage.MESSTimeCreated=CreateTime
	s objMessage.MESSUserCreatedDR=##Class(User.SSUser).%OpenId(LogonUserID)
	//Set objMessage.MESSMessage=Message
	s sc=objMessage.%Save()
	s ret=objMessage.%Id()
	d objMessage.%Close()

	q:ret<0 ret
	s ^SST("MESS",ret,"TXT",0)=1
	s ^SST("MESS",ret,"TXT",1)=MessText
	
	s len=$l(Users,"^")
	f i=1:1:len d
	.s UserID=$p(Users,"^",i)
	.&sql(Insert into SQLUser.SS_MessageRecipient (MESSREC_Message_DR,MESSREC_User_DR) values (:ret,:UserID))
	.s:$p(%ROWID,$c(1))<1 retValue=$p(%ROWID,$c(1))

	if retValue<0 TRollback
	TCommit

	quit ret

Error
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

/// Creator：     liuyh
/// CreatDate：   2010-06-18
/// Description:  修改消息
/// Table：       CT_Loc、SS_User
/// Input：       MessID_"^"_LogonUserID_"^"_Message
/// w ##class(DHCMed.SSService.MessageSrv).UpdateMessageToUser("1^1^aaa")
ClassMethod UpdateMessageToUser(str As %String) As %String
{
	n (str)
	s rowid="",ret=-1,retValue=0,NullDate=""
	q:str="" ret

	s MessID=$p(str,"^",1)
	s LogonUserID=$p(str,"^",2)
	s MessText=$p(str,"^",3)

	q:MessID="" ret
	q:LogonUserID="" ret
	q:MessText="" ret
	set $ZT="tError"
	TStart
	;&sql(delete from SQLUser.SS_MessageRecipient where MESSREC_Message_DR=:MessID)
	
	s CreateDate=$p($h,",",1)
	s CreateTime=$p($h,",",2)
	s objMessage=##Class(User.SSMessage).%OpenId(MessID)
	q:'$IsObject(objMessage) ret
	s objMessage.MESSDateCreated=CreateDate
	s objMessage.MESSTimeCreated=CreateTime
	s objMessage.MESSUserCreatedDR=##Class(User.SSUser).%OpenId(LogonUserID)
	//Set objMessage.MESSMessage=Message
	s sc=objMessage.%Save()
	s ret=objMessage.%Id()
	d objMessage.%Close()
	q:ret<0 ret
	s ^SST("MESS",ret,"TXT",0)=1
	s ^SST("MESS",ret,"TXT",1)=MessText
	s rowid=""
	f  s rowid=$o(^SST("MESSREC",rowid)) q:rowid=""  d   // 删除阅读时间
	.s MessDr=$p($g(^SST("MESSREC",rowid)),"^",1)
	.q:MessDr'=MessID
	.&sql(update SQLUser.SS_MessageRecipient set MESSREC_DateRead=:NullDate,MESSREC_TimeRead=:NullDate where MESSREC_RowId=:rowid)
	.s:$p(%ROWID,$c(1))<1 retValue=$p(%ROWID,$c(1))
	
	if retValue<0 TRollback
	TCommit

	quit ret

tError
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

/// Creator：     liuyh
/// CreatDate：   2010-06-21
/// Description:  通过消息Rowid查询对应的用户
/// Table：       SS_Message
/// Input：       MessID
/// w ##class(DHCMed.SSService.MessageSrv).GetUserListByMessID(1)
ClassMethod GetUserListByMessID(MessID As %String) As %String
{
	n (MessID)
	s ret=-1
	q:MessID="" ret
	s rowid=""
	f  s rowid=$o(^SST("MESSREC",rowid)) q:rowid=""  d
	.s MessDr=$p($g(^SST("MESSREC",rowid)),"^",1)
	.q:MessDr'=MessID
	.s UserID=$p($g(^SST("MESSREC",rowid)),"^",2)
	.q:UserID=""
	.s UserName=$p($g(^SSU("SSUSR",UserID)),"^",2)
	.q:UserName=""
	.i ret=-1 d
	..s ret=UserID_"^"_UserName
	.e  d
	..s ret=ret_$c(1)_UserID_"^"_UserName
	
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2010-06-21
/// Description:  添加阅读日期和时间
/// Table：       SS_MessageRecipent
/// Input：       
/// w ##class(DHCMed.SSService.MessageSrv).AddReadDateTime(544)
ClassMethod AddReadDateTime(MESSRecID As %String) As %String
{
	n (MESSRecID)
	s ReadDate=$p($h,",",1)
	s ReadTime=$p($h,",",2)
	&sql(update SQLUser.SS_MessageRecipient set MESSREC_DateRead=:ReadDate,MESSREC_TimeRead=:ReadTime where MESSREC_RowId=:MESSRecID)
	q $p(%ROWID,$c(1))
}

/// Creator：     liuyh
/// CreatDate：   2010-06-24
/// Description:  发送与用户有关的消息
/// Table：       DHCMed_SS.Message
/// Input：       paadm_^"_logonUserID_"^"_Message_$c(1)_UserID_"^"UserID_....
/// w ##class(DHCMed.SSService.MessageSrv).SendMessageToPatient("1^2^3333$c(1)1")
ClassMethod SendMessageToPatient(str As %String) As %String
{
	n (str)
	s retValue=0
	s tmp=$p(str,$c(1),1)
	s paadm=$p(tmp,"^",1)
	s LogonUserID=$p(tmp,"^",2)
	s Message=$p(tmp,"^",3)
	s Users=$p(str,$c(1),2)
	set $ZT="pError"
	TStart
	
	// 1 往SS_Message表中插入消息
	s CreateDate=$p($h,",",1)
	s CreateTime=$p($h,",",2)
	s objMessage=##Class(User.SSMessage).%New()
	s objMessage.MESSDateCreated=CreateDate
	s objMessage.MESSTimeCreated=CreateTime
	s objMessage.MESSUserCreatedDR=##Class(User.SSUser).%OpenId(LogonUserID)
	s sc=objMessage.%Save()
	s MessID=objMessage.%Id()
	d objMessage.%Close()

	if MessID<0 TRollback
	s ^SST("MESS",MessID,"TXT",0)=1
	s ^SST("MESS",MessID,"TXT",1)=Message
	
	//2 往DHCMed.SS.Message消息记录表中插入记录
	s MessInfo="^"_MessID_"^"_paadm
	set ret=##class(DHCMed.SS.Message).Update(MessInfo)
	if ret<0 TRollback
	
	//3 往SS_MessageRecipient表中插入信息接收者信息
	s len=$l(Users,"^")
	f i=1:1:len d
	.s UserID=$p(Users,"^",i)
	.&sql(Insert into SQLUser.SS_MessageRecipient (MESSREC_Message_DR,MESSREC_User_DR) values (:MessID,:UserID))
	.s:$p(%ROWID,$c(1))<1 retValue=$p(%ROWID,$c(1))

	if retValue<0 TRollback
	TCommit

	quit ret

pError
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

/// Creator：     liuyh
/// CreatDate：   2010-06-23
/// Description:  查询是否有该病人的消息
/// Table：       SS_Message
/// Input：       EdisodeID
/// w ##class(DHCMed.SSService.MessageSrv).FindMessByEdisodeID(11)
ClassMethod FindMessByEdisodeID(EdisodeID As %String) As %String
{
	n (EdisodeID)
	s ret=0
	s:$o(^DHCMed.SS.MessageI("IndexPaadm",EdisodeID,""))'="" ret=1
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2010-06-24
/// Description:  查询该病人的消息
/// Table：       SS_Message
/// Input：       EdisodeID
/// w ##class(DHCMed.SSService.MessageSrv).FindMessInfoByEdisodeID(11)
ClassMethod FindMessInfoByEdisodeID(EdisodeID As %String) As %String
{
	n (EdisodeID)
	s ret="",ind=1
	q:$o(^DHCMed.SS.MessageI("IndexPaadm",EdisodeID,""))="" ret=""
	s rowid=""
	f  s rowid=$o(^DHCMed.SS.MessageI("IndexPaadm",EdisodeID,rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.SS.Message).%OpenId(rowid)
	.s MessDr=obj.MessageDr
	.s ret=ret_$c(13)_$c(10)_"消息"_ind_": "_^SST("MESS",MessDr,"TXT",1)
	.s ind=ind+1
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2010-06-21
/// Description:  查询用户的消息
/// Table：       SS_Message
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.MessageSrv","QueryRecMessage",1,"","","","")
Query QueryRecMessage(LogonUserID As %String, ISRead As %String, SendUserID As %String, DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "rowid:%String,IsRead:%String,CreateUserName:%String,CreateDate:%String,CreateTime:%String,ReadDate:%String,ReadTime:%String,Message:%String")
{
}

ClassMethod QueryRecMessageExecute(ByRef qHandle As %Binary, LogonUserID As %String, ISRead As %String, SendUserID As %String, DateFrom As %String, DateTo As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	
	s:DateFrom["/" DateFrom=$zdh(DateFrom)
	s:DateTo["/" DateTo=$zdh(DateTo)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateTo["-" DateTo=$zdh(DateTo,3)

	f  s rowid=$o(^SST("MESSREC",rowid),-1) q:rowid=""  d
	.s UserDr=$p($g(^SST("MESSREC",rowid)),"^",2)
	.q:UserDr'=LogonUserID
	.s ReadDate=$p($g(^SST("MESSREC",rowid)),"^",3)
	.q:((DateFrom'="")&(DateFrom>ReadDate))
	.q:((DateTo'="")&(DateTo<ReadDate))
	.s ReadTime=$p($g(^SST("MESSREC",rowid)),"^",4)
	.s MessDr=$p($g(^SST("MESSREC",rowid)),"^",1)
	.q:MessDr=""
	.s CreateDate=$p($g(^SST("MESS",MessDr)),"^",1)
	.s CreateTime=$p($g(^SST("MESS",MessDr)),"^",2)
	.s CreateUserDr=$p($g(^SST("MESS",MessDr)),"^",3)
	.q:CreateUserDr=""
	.q:((SendUserID'="")&(SendUserID'=CreateUserDr))
	.s CreateUserName=$p($g(^SSU("SSUSR",CreateUserDr)),"^",2)
	.q:CreateUserName=""
	.s Message=^SST("MESS",MessDr,"TXT",1)
	.s IsRead="否"
	.s:ReadDate'="" IsRead="是"
	.s:CreateDate'="" CreateDate=$zd(CreateDate,3)
	.s:CreateTime'="" CreateTime=$zt(CreateTime)
	.s:ReadDate'="" ReadDate=$zd(ReadDate,3)
	.s:ReadTime'="" ReadTime=$zt(ReadTime)
	.q:((ISRead="true")&(ReadDate=""))
	.q:((ISRead="false")&(ReadDate'=""))
	.s $li(data,1)=rowid
	.s $li(data,2)=IsRead
	.s $li(data,3)=CreateUserName
	.s $li(data,4)=CreateDate
	.s $li(data,5)=CreateTime
	.S $li(data,6)=ReadDate
	.s $li(data,7)=ReadTime
	.s $li(data,8)=Message
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    q $$$OK
}

ClassMethod QueryRecMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRecMessageExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryRecMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRecMessageExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2010-06-24
/// Description:  通过paadm查询用户的消息
/// Table：       DHCMed_SS_Message
/// Input：       paadm
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.MessageSrv","QueryPatMessage",1)
Query QueryPatMessage(paadm As %String) As %Query(ROWSPEC = "rowid:%String,CreateUserName:%String,CreateDate:%String,CreateTime:%String,Message:%String")
{
}

ClassMethod QueryPatMessageExecute(ByRef qHandle As %Binary, paadm As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:$o(^DHCMed.SS.MessageI("IndexPaadm",paadm,""))="" $$$OK
	s rowid=""
	f  s rowid=$o(^DHCMed.SS.MessageI("IndexPaadm",paadm,rowid),-1) q:rowid=""  d
	.s obj=##class(DHCMed.SS.Message).%OpenId(rowid)
	.s MessageDr=obj.MessageDr
	.q:MessageDr=""
	.s CreateDate=$p($g(^SST("MESS",MessageDr)),"^",1)
	.s CreateTime=$p($g(^SST("MESS",MessageDr)),"^",2)
	.s:CreateDate'="" CreateDate=$zd(CreateDate,3)
	.s:CreateTime'="" CreateTime=$zt(CreateTime)
	.s CreateUserDr=$p($g(^SST("MESS",MessageDr)),"^",3)
	.b
	.q:CreateUserDr=""
	.s CreateUserName=$p($g(^SSU("SSUSR",CreateUserDr)),"^",2)
	.;q:CreateUserName=""
	.s Message=^SST("MESS",MessageDr,"TXT",1)
	.s $li(data,1)=rowid
	.s $li(data,2)=CreateUserName
	.s $li(data,3)=CreateDate
	.s $li(data,4)=CreateTime
	.s $li(data,5)=Message
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .do obj.%Close()
    q $$$OK
}

ClassMethod QueryPatMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatMessageExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPatMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatMessageExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
}

}
