Class web.SSMessageRecipient Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 292;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MESSREC_RowId";

Parameter SQLDESCRIPTION = "MESSREC_RowId";

Parameter SQLROWID = "MESSREC_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod FindByRecipientClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindByRecipientFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ab 3.04.06 58711 - rewritten to use globals
/// by wuqk 
ClassMethod FindByRecipientExecute(ByRef QHandle As %Library.Binary, User As %String = "", DateFrom As %String = "", DateTo As %String = "", ShowRead As %String, DateCreatedFrom As %String = "", DateCreatedTo As %String = "", UserHidden As %String = "") As %Library.Status
{
	n repid
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	i User="" s QHandle=$lb(0,repid,0) q $$$OK
	s UserDr = ##class(web.SSUser).GetIdFromCodeOrDescription(User)

	s:ShowRead="true" ShowRead=1
	s:ShowRead'=1 ShowRead=0
	//User , DateFrom , DateTo , ShowRead , DateCreatedFrom, DateCreatedTo , UserHidde
	//"ID,DateRead,TimeRead,RecipientName,MessageID,MessageDate,MessageTime,MessageName")
	;wanghc 2012-11-21 改成m
	
	;包含读过的信息，读过的信息不在NotRead索引中
	i ShowRead=1 d
	.s:DateTo="" DateTo=+$h
	.s:DateFrom="" DateFrom=+$h	
	.f readDate = DateFrom:1:DateTo d
	..s messRowid="" f  s messRowid = $o(^SST("MESSREC",0,"User",UserDr,readDate,messRowid)) q:messRowid=""  d
	...d rowOutput
	;没读过的
	s messRowid=""
	f  s messRowid = $o(^SST("MESSREC",0,"NotRead",UserDr,messRowid),-1) q:messRowid=""  d
	.s readDate = $p(^SST("MESSREC",messRowid),"^",3)
	.d rowOutput
	
	s QHandle=$lb(0,repid,0)
	quit $$$OK
rowOutput
	s messageDr = $p(^SST("MESSREC",messRowid),"^",1)
	s createDate = $p(^SST("MESS",messageDr),"^",1)
	s createTime = $p(^SST("MESS",messageDr),"^",2)
	q:(DateCreatedTo'="")&&(createDate>DateCreatedTo)
	q:(DateCreatedFrom'="")&&(createDate<DateCreatedFrom)
	s readTime = $p(^SST("MESSREC",messRowid),"^",4)
	s createUserDr = $p(^SST("MESS",messageDr),"^",3)
	s createUserName = $p(^SSU("SSUSR",createUserDr),"^",2)
	s data=$lb(messRowid,readDate,readTime,User,messageDr,createDate,createTime,createUserName)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q 
	/*
	&sql(Declare cMessRec cursor for 
		SELECT MESSREC_Rowid, MESSREC_DateRead, MESSREC_TimeRead,
		MESSREC_User_DR->SSUSR_Name,
		MESSREC_Message_DR->MESS_Rowid,
		MESSREC_Message_DR->MESS_DateCreated, 
		MESSREC_Message_DR->MESS_TimeCreated, 
		MESSREC_Message_DR->MESS_UserCreated_DR->SSUSR_Name
		into :ID,:DateRead,:TimeRead,:RecipientName,:MessageID,
			 :MessageDate,:MessageTime,:MessageName
		FROM SQLUser.SS_MessageRecipient
	
		WHERE (MESSREC_User_DR->SSUSR_Name=:User OR MESSREC_User_DR->SSUSR_Initials=:User OR :User IS NULL)
		
		AND (MESSREC_Message_DR->MESS_DateCreated >= :DateCreatedFrom OR MESSREC_Message_DR->MESS_DateCreated IS NULL OR :DateCreatedFrom IS NULL OR :DateCreatedFrom='')
		AND (MESSREC_Message_DR->MESS_DateCreated <= :DateCreatedTo OR MESSREC_Message_DR->MESS_DateCreated IS NULL OR :DateCreatedTo IS NULL OR :DateCreatedFrom='')
		AND (MESSREC_DateRead >= :DateFrom OR MESSREC_DateRead IS NULL OR :DateFrom IS NULL OR :DateFrom='')
		AND (MESSREC_DateRead <= :DateTo OR MESSREC_DateRead IS NULL OR :DateTo IS NULL OR :DateTo='')
		AND (:ShowRead=1 OR (:ShowRead=0 AND MESSREC_DateRead IS NULL))
		ORDER BY MESSREC_Message_DR->MESS_DateCreated DESC, MESSREC_Message_DR->MESS_TimeCreated DESC
	)
	&sql(open cMessRec)
	&sql(fetch cMessRec)
	while (SQLCODE=0){
		set data=$lb(ID,DateRead,TimeRead,RecipientName,MessageID,MessageDate,MessageTime,MessageName)
		set ^CacheTemp(repid,ind)=data
		set ind=ind+1
		&sql(fetch cMessRec)
	}*/
	
	/*	
	SELECT MESSREC_Rowid, MESSREC_DateRead, MESSREC_TimeRead,
	MESSREC_User_DR->SSUSR_Name,
	MESSREC_Message_DR->MESS_Rowid,
	MESSREC_Message_DR->MESS_DateCreated, 
	MESSREC_Message_DR->MESS_TimeCreated, 
	MESSREC_Message_DR->MESS_UserCreated_DR->SSUSR_Name
	FROM SQLUser.SS_MessageRecipient
	WHERE (MESSREC_User_DR->SSUSR_Name=:User OR MESSREC_User_DR->SSUSR_Initials=:User OR :User IS NULL)
	AND (MESSREC_Message_DR->MESS_DateCreated >= :DateCreatedFrom OR MESSREC_Message_DR->MESS_DateCreated IS NULL OR :DateCreatedFrom IS NULL OR :DateCreatedFrom='')
	AND (MESSREC_Message_DR->MESS_DateCreated <= :DateCreatedTo OR MESSREC_Message_DR->MESS_DateCreated IS NULL OR :DateCreatedTo IS NULL OR :DateCreatedFrom='')
	AND (MESSREC_DateRead >= :DateFrom OR MESSREC_DateRead IS NULL OR :DateFrom IS NULL OR :DateFrom='')
	AND (MESSREC_DateRead <= :DateTo OR MESSREC_DateRead IS NULL OR :DateTo IS NULL OR :DateTo='')
	ORDER BY MESSREC_DateRead DESC, MESSREC_TimeRead DESC
	*/
}

ClassMethod FindByRecipientFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindByRecipientExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// by wuqk 2011-07-15
Query FindByRecipient(User As %String, DateFrom As %Date, DateTo As %Date, ShowRead As %String, DateCreatedFrom As %Date, DateCreatedTo As %Date, UserHidden As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,DateRead,TimeRead,RecipientName,MessageID,MessageDate,MessageTime,MessageName")
{
}

/// ab 3.04.06 58711 - rewritten to use globals - see above
ClassMethod FindByRecipientOLDClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindByRecipientOLDFetch ]
{
}

ClassMethod FindByRecipientOLDExecute(ByRef QHandle As %Library.Binary, User As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", ShowRead As %Library.String, DateCreatedFrom As %Library.String = "", DateCreatedTo As %Library.String = "", UserHidden As %Library.String = "") As %Library.Status
{
}

ClassMethod FindByRecipientOLDFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindByRecipientOLDExecute ]
{
}

/// KM 12-Nov-2001: Called at the top of most csp pages along with the session check event
/// by wuqk 2011-07-15
ClassMethod countNewMessages(UserID As %Library.String) As %Library.Integer
{
	/*&sql(select count(*) into :count from SQLUser.SS_MessageRecipient where MESSREC_User_DR=:UserID and MESSREC_DateRead is null)*/
	;wanghc 2012-11-18 sql要花3,4s
	s count=0
	s SSTRowid = ""
	for  s SSTRowid = $O(^SST("MESSREC",0,"NotRead",UserID,SSTRowid)) q:SSTRowid=""  d
	.s dateRead = $p(^SST("MESSREC",SSTRowid),"^",3)
	.s:dateRead="" count=count+1
	q count
}

/// KM 12-Nov-2001: Called at the top of most csp pages along with the session check event
/// by wuqk 2011-07-15
ClassMethod getMessageLink()
{
	n UserID,UserCode,count,link
	s UserID=%session.Data("LOGON.USERID")
	s UserCode=%session.Data("LOGON.USERCODE")
	s count=..countNewMessages(UserID)
	quit:count<1 ""
	s cmp=$s($g(%request.Data("WEBSYS.TCOMPONENT",1))'="":%request.Data("WEBSYS.TCOMPONENT",1),1:$g(%session.Data("WEBSYS.TCOMPONENT")))
	s url = "websys.default.csp?WEBSYS.TCOMPONENT=SSMessageRecipient.List&User="_UserCode
	set link=""
	if (cmp'["SSMessage"){
		s link=link_"<div id=""z_messagewin""></div>"
		s link=link_"<script>var messageWinShow=function(){new Ext.Window({ contentEl:'z_messagewin',title:'消息',width:700,height:500,layout: 'fit',closable:false,minimizable: true,listeners: {minimize: function(window){window.hide();}},html:'<iframe src="""_url_""" width=""100%"" height=""100%""></iframe>',modal:true}).show();}; Ext.onReady(messageWinShow);</script>"
		s link=link_"<A HREF=""javascript: messageWinShow();"" style=""color:red""><img SRC=""../images/webemr/message.gif"" BORDER=0>"
		s link=link_count_"新消息</A><BR>"
	}
	//<A HREF="javascript: var win=websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=SSMessageRecipient.List&User=demo','messages','top=10,left=10,width=300,height=300,status=yes,scrollbars=yes,resizable=yes')" style="color:red"><img SRC="../images/webemr/message.gif" BORDER=0>1 新消息</A><BR>
	Q link
}

/// KM 9-Nov-2001: Called when component SSMessage.Edit is updated
/// by wuqk 2011-07-15
ClassMethod insertMessage(IDs As %Library.String, MessageID As %Library.String)
{
	//s recIdList=%request.Data("MessageRecipientIDs",1)
	s len=$l(IDs,"^")
	for ind=1:1:len{
		s resUserId=$p(IDs,"^",ind)
		continue:resUserId=""
		&sql(insert into SQLUser.SS_MessageRecipient(MESSREC_Message_DR,MESSREC_User_DR) values(:MessageID,:resUserId))
	}
	quit
}

/// KM 12-Nov-2001
/// by wuqk 2011-07-15
ClassMethod websysSaveDateRead()
{
	n recId,objRec
	s recId=%request.Data("ID",1)
	s objRec=##class(User.SSMessageRecipient).%OpenId(recId)
	s objRec.MESSRECDateRead=+$h
	s objRec.MESSRECTimeRead=$p($h,",",2)
	d objRec.%Save()
	s objRec=""
	q
}

Query FindAllRecipientsOfMessage(MessageID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Name")
{
SELECT MESSREC_User_DR->SSUSR_Name
FROM SQLUser.SS_MessageRecipient
WHERE ((:MessageID<>"") and (MESSREC_Message_DR=:MessageID))
ORDER BY MESSREC_User_DR->SSUSR_Name
}

Query FindByRecipientOLD(User As %String, DateFrom As %Date, DateTo As %Date, ShowRead As %String, DateCreatedFrom As %Date, DateCreatedTo As %Date, UserHidden As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,DateRead,TimeRead,RecipientName,MessageID,MessageDate,MessageTime,MessageName")
{
}

Query FindByRecipientAll(User As %String, DateFrom As %Date, DateTo As %Date, DateCreatedFrom As %Date, DateCreatedTo As %Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,DateRead,TimeRead,RecipientName,MessageID,MessageDate,MessageTime,MessageName")
{
SELECT MESSREC_Rowid, MESSREC_DateRead, MESSREC_TimeRead,
MESSREC_User_DR->SSUSR_Name,
MESSREC_Message_DR->MESS_Rowid,
MESSREC_Message_DR->MESS_DateCreated, 
MESSREC_Message_DR->MESS_TimeCreated, 
MESSREC_Message_DR->MESS_UserCreated_DR->SSUSR_Name
FROM SQLUser.SS_MessageRecipient
WHERE (MESSREC_User_DR->SSUSR_Name=:User OR MESSREC_User_DR->SSUSR_Initials=:User OR :User IS NULL)
AND (MESSREC_Message_DR->MESS_DateCreated >= :DateCreatedFrom OR MESSREC_Message_DR->MESS_DateCreated IS NULL OR :DateCreatedFrom IS NULL OR :DateCreatedFrom='')
AND (MESSREC_Message_DR->MESS_DateCreated <= :DateCreatedTo OR MESSREC_Message_DR->MESS_DateCreated IS NULL OR :DateCreatedTo IS NULL OR :DateCreatedFrom='')
AND (MESSREC_DateRead >= :DateFrom OR MESSREC_DateRead IS NULL OR :DateFrom IS NULL OR :DateFrom='')
AND (MESSREC_DateRead <= :DateTo OR MESSREC_DateRead IS NULL OR :DateTo IS NULL OR :DateTo='')
ORDER BY MESSREC_DateRead DESC, MESSREC_TimeRead DESC
}

Query FindByRecipientAllRound(User As %String, DateFrom As %Date, DateTo As %Date, RoundCP As %String, DateCreatedFrom As %Date, DateCreatedTo As %Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,DateRead,TimeRead,RecipientName,MessageID,MessageDate,MessageTime,MessageName")
{
SELECT MESSREC_Rowid, MESSREC_DateRead, MESSREC_TimeRead,
MESSREC_User_DR->SSUSR_Name,
MESSREC_Message_DR->MESS_Rowid,
MESSREC_Message_DR->MESS_DateCreated, 
MESSREC_Message_DR->MESS_TimeCreated, 
MESSREC_Message_DR->MESS_UserCreated_DR->SSUSR_Name
FROM SQLUser.SS_MessageRecipient
WHERE (MESSREC_User_DR=ANY(select RND_ParRef  from SQLUser.SS_UserRound Where RND_CTCP_DR=:RoundCP) OR (MESSREC_User_DR->SSUSR_Name=:User OR MESSREC_User_DR->SSUSR_Initials=:User))
AND (MESSREC_Message_DR->MESS_DateCreated >= :DateCreatedFrom OR MESSREC_Message_DR->MESS_DateCreated IS NULL OR :DateCreatedFrom IS NULL OR :DateCreatedFrom='')
AND (MESSREC_Message_DR->MESS_DateCreated <= :DateCreatedTo OR MESSREC_Message_DR->MESS_DateCreated IS NULL OR :DateCreatedTo IS NULL OR :DateCreatedFrom='')
AND (MESSREC_DateRead >= :DateFrom OR MESSREC_DateRead IS NULL OR :DateFrom IS NULL OR :DateFrom='')
AND (MESSREC_DateRead <= :DateTo OR MESSREC_DateRead IS NULL OR :DateTo IS NULL OR :DateTo='')
ORDER BY MESSREC_DateRead DESC, MESSREC_TimeRead DESC
}

Query FindByRecipientUnRead(User As %String, DateCreatedFrom As %Date, DateCreatedTo As %Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,DateRead,TimeRead,RecipientName,MessageID,MessageDate,MessageTime,MessageName")
{
SELECT MESSREC_Rowid, MESSREC_DateRead, 
 MESSREC_TimeRead,
 MESSREC_User_DR->SSUSR_Name,
 MESSREC_Message_DR->MESS_Rowid,
 MESSREC_Message_DR->MESS_DateCreated, 
 MESSREC_Message_DR->MESS_TimeCreated, 
 MESSREC_Message_DR->MESS_UserCreated_DR->SSUSR_Name
FROM SQLUser.SS_MessageRecipient
WHERE (MESSREC_User_DR->SSUSR_Name=:User OR MESSREC_User_DR->SSUSR_Initials=:User OR :User IS NULL)
AND (MESSREC_Message_DR->MESS_DateCreated >= :DateCreatedFrom OR MESSREC_Message_DR->MESS_DateCreated IS NULL OR :DateCreatedFrom IS NULL OR :DateCreatedFrom='')
AND (MESSREC_Message_DR->MESS_DateCreated <= :DateCreatedTo OR MESSREC_Message_DR->MESS_DateCreated IS NULL OR :DateCreatedTo IS NULL OR :DateCreatedFrom='')
AND (MESSREC_DateRead IS NULL)
ORDER BY MESSREC_Message_DR->MESS_DateCreated DESC, MESSREC_Message_DR->MESS_TimeCreated DESC
}

/// KK 13/Sep/2002 Log 27559 - To show messages of the users associated with the round care provider
Query FindByRecipientUnReadRound(User As %String, DateCreatedFrom As %Date, DateCreatedTo As %Date, RoundCP As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,DateRead,TimeRead,RecipientName,MessageID,MessageDate,MessageTime,MessageName")
{
SELECT MESSREC_Rowid, MESSREC_DateRead, 
 MESSREC_TimeRead,
 MESSREC_User_DR->SSUSR_Name,
 MESSREC_Message_DR->MESS_Rowid,
 MESSREC_Message_DR->MESS_DateCreated, 
 MESSREC_Message_DR->MESS_TimeCreated, 
 MESSREC_Message_DR->MESS_UserCreated_DR->SSUSR_Name
FROM SQLUser.SS_MessageRecipient
WHERE (MESSREC_User_DR=ANY(select RND_ParRef  from SQLUser.SS_UserRound Where RND_CTCP_DR=:RoundCP) OR (MESSREC_User_DR->SSUSR_Name=:User OR MESSREC_User_DR->SSUSR_Initials=:User))
AND (MESSREC_Message_DR->MESS_DateCreated >= :DateCreatedFrom OR MESSREC_Message_DR->MESS_DateCreated IS NULL OR :DateCreatedFrom IS NULL OR :DateCreatedFrom='')
AND (MESSREC_Message_DR->MESS_DateCreated <= :DateCreatedTo OR MESSREC_Message_DR->MESS_DateCreated IS NULL OR :DateCreatedTo IS NULL OR :DateCreatedFrom='')
AND (MESSREC_DateRead IS NULL)
ORDER BY MESSREC_Message_DR->MESS_DateCreated DESC, MESSREC_Message_DR->MESS_TimeCreated DESC
}

/// Date : 2014-10-21
/// Param : MessageInfo 信息内容
/// Param : UserIDs 收件人ID串. 	SS_User表的RowId. 如 12^27^38
/// Param : CreateUserID 创建信息人ID.  SS_User表的RowId. 
/// Other : 把信息发给某些人
ClassMethod SendUserMessage(MessageInfo As %String, UserIDs As %String, CreateUserID)
{
	set MessId = ##class(web.SSMessage).Save(MessageInfo,CreateUserID)
	if (MessId>0) {
		d ..insertMessage(UserIDs,MessId)
	}
	q 1
}

/// Date : 2014-10-21
/// Param : MessageInfo 信息内容
/// Param : GroupIDs 收件安全组ID串. 	SS_Group表的RowId. 如 12^27^38
/// Param : CreateUserID 创建信息人ID.  SS_User表的RowId. 
/// Other : 把信息发给 某些安全组 内所以人
ClassMethod SendGroupMessage(MessageInfo As %String, GroupIDs As %String, CreateUserID)
{
	n (MessageInfo,GroupIDs,CreateUserID)
	set MessId = ##class(web.SSMessage).Save(MessageInfo,CreateUserID)
	if (MessId>0) {
		set UserIDs=""
		for i=1:1:$l(GroupIDs,"^"){
			set GroupID = $p(GroupIDs,"^",i)
			Set UserID = 0
			for{
				set UserID = $o(^SSU("SSUSR",0,"Group",GroupID,UserID))
				quit:UserID=""
				set UserIDs = UserIDs_"^"_UserID
			}
		}
		d ..insertMessage(UserIDs,MessId)
	}
	q 1
}

/// Date : 2014-10-21
/// Param : MessageInfo 信息内容
/// Param : LocIDs 收件科室ID串. 	SS_Loc表的RowId. 如 12^27^38
/// Param : CreateUserID 创建信息人ID.  SS_User表的RowId. 
/// Other : 把信息发给 某些科室内的 内所以人 默认登录科室
ClassMethod SendLocMessage(MessageInfo As %String, LocIDs As %String, CreateUserID)
{
	n (MessageInfo,GroupIDs,CreateUserID)
	set MessId = ##class(web.SSMessage).Save(MessageInfo,CreateUserID)
	if (MessId>0) {
		set UserIDs=""
		Set LocIDs="^"_LocIDs_"^"
		for{
			set UserID = $o(^SSU("SSUSR",UserID))
			quit:UserID=""
			Set DefaultLocID = $p(^SSU("SSUSR",UserID),"^",4)
			Quit:(LocIDs'[DefaultLocID)
			set UserIDs = UserIDs_"^"_UserID
		}
		do ..insertMessage(UserIDs,MessId)	
	}
	q 1
}

}
