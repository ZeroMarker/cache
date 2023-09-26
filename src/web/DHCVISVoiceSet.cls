Import SQLUser

Class web.DHCVISVoiceSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUpServer(txtServerName As %String = "", txtServerIP As %String = "", txtServerTopIP As %String = "", clientFlag As %String = "") As %Query(ROWSPEC = "ServerId:%String,ServerIP:%String,ServerName:%String,ServerLinkLoc:%String,ServerLinkLocId:%String,ServerLinkOtherLoc:%String,ServerNote:%String,ServerActive:%String,ServerPortNo:%String,ServerScreenNo:%String,ServerScreenColorNo:%String,ServerTopIP:%String,ServerTopDesc:%String,ServerState:%String,ServerVoiceTopIP:%String,ServerLinkOtherLocId:%String,ServerSuper:%String,ServerAutoUpdate:%String,Notification:%String,WaitPaitList:%String")
{
}

// d ##class(%ResultSet).RunQuery("web.DHCVISVoiceSet","LookUpServer")

ClassMethod LookUpServerExecute(ByRef qHandle As %Binary, txtServerName As %String = "", txtServerIP As %String = "", txtServerTopIP As %String = "", clientFlag As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s txtServerIP=$$upper^SSUTIL4(txtServerIP)
	s ServerId=""
	f  s ServerId=$O(^DHCVISServer(ServerId)) q:ServerId=""  d
	.s ServerStr=$G(^DHCVISServer(ServerId))
	.q:ServerStr=""
	.s ServerIP=$P(ServerStr,"^",1)
	.q:(txtServerIP'="")&&(ServerIP'[txtServerIP)
	.s ServerName=$P(ServerStr,"^",2)
	.q:(txtServerName'="")&&(ServerName'[txtServerName)
	.s ServerActive=$P(ServerStr,"^",3)
	.//客户端搜索需要过滤未激活服务器
	.q:(ServerActive'=clientFlag)&&(clientFlag'="")
	.s ServerPortNo=$P(ServerStr,"^",4)
	.s ServerScreenNo=$P(ServerStr,"^",5)
	.s ServerScreenColorNo=$P(ServerStr,"^",6)
	.s ServerLinkLocId=$P(ServerStr,"^",7)
	.s ServerLinkLoc=""
	.i ServerLinkLocId'="" d
	..&sql(	SELECT ExabName into :ServerLinkLoc
 		From SQLUser.DHCExaBorough
 		where ID=:ServerLinkLocId )
	.s ServerLinkOtherLocId=$P(ServerStr,"^",8)
	.s ServerLinkOtherLoc=""
	.i ServerLinkOtherLocId'="" s ServerLinkOtherLoc=$P($G(^CTLOC(ServerLinkOtherLocId)),"^",2)
	.s ServerNote=$P(ServerStr,"^",9)
	.s txtServerTopIP=$TR(txtServerTopIP," ")
	.s ServerTopIP=$P(ServerStr,"^",13)
	.q:(txtServerTopIP'="")&&(ServerTopIP'[txtServerTopIP)
	.s ServerTopDesc=$P(ServerStr,"^",14)
	.s LastDate=$P(ServerStr,"^",11)
	.s LastTime=$P(ServerStr,"^",12)
	.s ServerState="脱机"
	.i (LastDate=+$H)&&($P($H,",",2)-LastTime<300) s ServerState="联机"
	.s ServerVoiceTopIP=$P(ServerStr,"^",15)
	.s ServerSuper=$P(ServerStr,"^",16)
	.//客户端搜索需要过滤超级服务
	.q:(clientFlag'="")&&(ServerSuper=clientFlag)
	.s ServerAutoUpdate=$P(ServerStr,"^",17)
	.s Notification=$P(ServerStr,"^",18)
	.s WaitPaitList=$P(ServerStr,"^",19)
	.d OutServerRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutServerRow
	s Data=$lb(ServerId,ServerIP,ServerName,ServerLinkLoc,ServerLinkLocId,ServerLinkOtherLoc,ServerNote,ServerActive,ServerPortNo,ServerScreenNo,ServerScreenColorNo,ServerTopIP,ServerTopDesc,ServerState,ServerVoiceTopIP,ServerLinkOtherLocId,ServerSuper,ServerAutoUpdate,Notification,WaitPaitList)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpServerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpServerExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpServerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpServerExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod ServerInsert(ServerIP As %String, ServerName As %String, ServerActive As %String, ServerPortNo As %String = "", ServerScreenNo As %String = "", ServerScreenColorNo As %String = "", ServerLinkLocId As %String = "", ServerLinkOtherLoc As %String = "", ServerNote As %String = "", UserId As %String = "", ServerTopIP As %String = "", ServerTopDesc As %String = "", ServerVoiceTopIP As %String = "", ServerSuper As %String = "", ServerAutoUpdate As %String = "", WaitPaitList As %String = "", Notification As %String = "") As %String
{
	s nowDate=+$H
	s nowTime=$P($H,",",2)
	s ServerTopIP=$tr(ServerTopIP," ")
	s ServerVoiceTopIP=$tr(ServerVoiceTopIP," ")
	s ServerIP=$$upper^SSUTIL4(ServerIP)
	q:ServerIP="" "服务器IP不能为空!"
	q:ServerName="" "服务器名称不能为空!"
	q:ServerActive="" "服务器是否可用未勾选!"
	q:(ServerIP="")!(ServerName="")!(ServerActive="") "信息不完整!"
	q:$O(^DHCVISServeri(0,"ServerIP",ServerIP,""))'="" "该叫号服务IP已经存在!"
	&SQL(insert into DHC_VIS_VoiceServer(VIS_ServerIP,VIS_ServerName,VIS_ServerActive,VIS_ServerPortNo,VIS_ServerScreenNo,VIS_ServerScreenColorNo,VIS_ServerLinkLoc,VIS_ServerLinkOtherLoc,VIS_ServerNote,VIS_ServerUpdateUser,VIS_ServerUpdateDate,VIS_ServerUpdateTime,VIS_ServerTopIP,VIS_ServerTopDesc,VIS_ServerVoiceTopIP,VIS_ServerSuper,VIS_ServerAutoUpdate,VIS_Notification,VIS_WaitPaitList ) values (:ServerIP,:ServerName,:ServerActive,:ServerPortNo,:ServerScreenNo,:ServerScreenColorNo,:ServerLinkLocId,:ServerLinkOtherLoc,:ServerNote,:UserId,:nowDate,:nowTime,:ServerTopIP,:ServerTopDesc,:ServerVoiceTopIP,:ServerSuper,:ServerAutoUpdate,:Notification,:WaitPaitList))
	i SQLCODE'=0 q "插入失败!"
	q SQLCODE
}

ClassMethod ServerUpdate(ServerId As %String, ServerIP As %String, ServerName As %String, ServerActive As %String, ServerPortNo As %String = "", ServerScreenNo As %String = "", ServerScreenColorNo As %String = "", ServerLinkLocId As %String = "", ServerLinkOtherLoc As %String = "", ServerNote As %String = "", UserId As %String = "", ServerTopIP As %String = "", ServerTopDesc As %String = "", ServerVoiceTopIP As %String = "", ServerSuper As %String = "", ServerAutoUpdate As %String = "", WaitPaitList As %String = "", Notification As %String = "") As %String
{
	q:(ServerId="") "请选择需要操作的记录!"
	s nowDate=+$H
	s nowTime=$P($H,",",2)
	s ServerTopIP=$tr(ServerTopIP," ")
	s ServerVoiceTopIP=$tr(ServerVoiceTopIP," ")
	s ServerIP=$$upper^SSUTIL4(ServerIP)
	q:ServerIP="" "服务器IP不能为空!"
	q:ServerName="" "服务器名称不能为空!"
	q:ServerActive="" "服务器是否可用未勾选!"
	q:(ServerId="")!(ServerIP="")!(ServerName="")!(ServerActive="") "信息不完整!"
	s ifExit=0
	s ID="" f  s ID=$O(^DHCVISServeri(0,"ServerIP",ServerIP,ID)) q:ID=""  d
	.q:ID=ServerId
	.s ifExit=1
	q:ifExit=1 "此IP地址已经存在!"
	&SQL(update DHC_VIS_VoiceServer set VIS_ServerIP=:ServerIP,VIS_ServerName=:ServerName,VIS_ServerActive=:ServerActive,VIS_ServerPortNo=:ServerPortNo,VIS_ServerScreenNo=:ServerScreenNo,VIS_ServerScreenColorNo=:ServerScreenColorNo,VIS_ServerLinkLoc=:ServerLinkLocId,VIS_ServerLinkOtherLoc=:ServerLinkOtherLoc,VIS_ServerNote=:ServerNote,VIS_ServerUpdateUser=:UserId,VIS_ServerUpdateDate=:nowDate,VIS_ServerUpdateTime=:nowTime,VIS_ServerTopIP=:ServerTopIP,VIS_ServerTopDesc=:ServerTopDesc,VIS_ServerVoiceTopIP=:ServerVoiceTopIP,VIS_ServerSuper=:ServerSuper,VIS_ServerAutoUpdate=:ServerAutoUpdate,VIS_Notification=:Notification,VIS_WaitPaitList=:WaitPaitList where VIS_ServerID=:ServerId)
	i SQLCODE'=0 q "更新失败!"
	q SQLCODE
}

ClassMethod ServerDelete(ServerId As %String) As %String
{
	q:(ServerId="") "请选择需要操作的记录!"
	&SQL(Delete from DHC_VIS_VoiceServer where VIS_ServerID=:ServerId)
	i SQLCODE'=0 q "删除失败!"
	q SQLCODE
}

Query FindExaBorough(code As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "Tcode:%String,Tname:%String,Tmemo:%String,Tid:%String,TCheckin:%String")
{
	SELECT ExabCode,ExabName,ExabMemo,ID,ExabTem
 		From SQLUser.DHCExaBorough
 		where ExabCode %startswith :code
}

Query LookUpClient(txtClientName As %String = "", txtServerId As %String = "", txtClientIP As %String = "", txtClientTopIP As %String = "") As %Query(ROWSPEC = "ClientId:%String,ClientIP:%String,ClientName:%String,ServerId:%String,ServerName:%String,ClientLinkRoom:%String,ClientLinkRoomId:%String,ClientLinkDoc:%String,ClientLinkDocId:%String,ClientNote:%String,ClientNoteId:%String,ClientPortNo:%String,ClientScreenNo:%String,ClientScreenColorNo:%String,ClientShowMode:%String,ClientShowSpeed:%String,ClientShowTime:%String,ExaBoroughId:%String,ClientTopIP:%String,ClientTopDesc:%String,LocTopIP:%String,LocTopDesc:%String,ClientVoiceTopIP:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCVISVoiceSet","LookUpClient","",28)
ClassMethod LookUpClientExecute(ByRef qHandle As %Binary, txtClientName As %String = "", txtServerId As %String = "", txtClientIP As %String = "", txtClientTopIP As %String = "") As %Status
{
	//s ^lzx("LookUpClient")="txtClientName "_txtClientName_",txtServerId "_txtServerId_",txtClientIP "_txtClientIP_",txtClientTopIP "_txtClientTopIP
	s repid=$i(^CacheTemp)
 	s ind=1
 	s txtClientIP=$$upper^SSUTIL4(txtClientIP)
	s ClientId=""
	f  s ClientId=$O(^DHCVISClient(ClientId)) q:ClientId=""  d
	.s ClientStr=$G(^DHCVISClient(ClientId))
	.q:ClientStr=""
	.s ClientIP=$P(ClientStr,"^",2)
	.q:(txtServerId="")&&(txtClientIP'="")&&(ClientIP'[txtClientIP)
	.s ClientName=$P(ClientStr,"^",3)
	.q:(txtClientName'="")&&(ClientName'[txtClientName)
	.s ClientName=$P(ClientStr,"^",3)
	.s ServerId=$P(ClientStr,"^",1)
	.q:(txtServerId'="")&&(txtServerId'=ServerId)
	.s ServerName=$P($G(^DHCVISServer(ServerId)),"^",2)
	.s ExaBoroughId=$P($G(^DHCVISServer(ServerId)),"^",7)
	.s ClientLinkRoomId=$P(ClientStr,"^",11)
	.s ClientLinkRoom=""
	.i ClientLinkRoomId'="" d
	..//&sql( SELECT ExarName into :ClientLinkRoom From SQLUser.DHCExaRoom where ID=:ClientLinkRoomId )
	..//s ClientLinkRoom=$P($G(^CTLOC(ClientLinkRoomId)),"^",2)
	..s ClientLinkRoom=$p($G(^DHCPHWIN(ClientLinkRoomId)),"^",1)
	.s ClientLinkDocId=$P(ClientStr,"^",10)
	.//s ClientLinkDoc=ClientLinkDocId
	.s ClientLinkDoc=""
	.i ClientLinkDocId'="" s ClientLinkDoc=$p($g(^CTLOC(ClientLinkDocId)),"^",2)
	.s ClientNoteId=$P(ClientStr,"^",12)
	.s ClientNote=ClientNoteId
	.i $tr(ClientNoteId," ")'="" d
	..//s QueueTypeRowID=$o(^User.DHCVISLinkQueueTypeI("QueueDescIndex"," "_ClientNoteId,""))
	..//q:QueueTypeRowID=""
	..//s ClientNoteId=QueueTypeRowID
	..s ClientNote=$ListGet(^User.DHCVISLinkQueueTypeD(ClientNoteId),3)
	..//w "ClientNote "_ClientNote,!
	.s ClientPortNo=$P(ClientStr,"^",4)
	.s ClientScreenNo=$P(ClientStr,"^",5)
	.s ClientScreenColorNo=$P(ClientStr,"^",6)
	.s ClientShowMode=$P(ClientStr,"^",7)
	.s ClientShowSpeed=$P(ClientStr,"^",8)
	.s ClientShowTime=$P(ClientStr,"^",9)
	.s ClientTopIP=$P(ClientStr,"^",16)
	.q:(txtServerId="")&&(txtClientTopIP'="")&&(ClientTopIP'[txtClientTopIP)
	.s ClientTopDesc=$P(ClientStr,"^",17)
	.s LocTopIP=$P(ClientStr,"^",18)
	.s LocTopDesc=$P(ClientStr,"^",19)
	.s ClientVoiceTopIP=$P(ClientStr,"^",20)
	.d OutClientRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutClientRow
	//s Data=$lb(ClientId,ClientIP,ClientName,ServerId,ServerName,ClientLinkRoom,ClientLinkRoomId,ClientLinkDoc,ClientLinkDocId,ClientNote,ClientNoteId,ClientPortNo,ClientScreenNo,ClientScreenColorNo,ClientShowMode,ClientShowSpeed,ClientShowTime,ExaBoroughId,ClientNote,ClientTopIP,ClientTopDesc,LocTopIP,LocTopDesc,ClientVoiceTopIP)
	s Data=$lb(ClientId,ClientIP,ClientName,ServerId,ServerName,ClientLinkRoom,ClientLinkRoomId,ClientLinkDoc,ClientLinkDocId,ClientNote,ClientNoteId,ClientPortNo,ClientScreenNo,ClientScreenColorNo,ClientShowMode,ClientShowSpeed,ClientShowTime,ExaBoroughId,ClientTopIP,ClientTopDesc,LocTopIP,LocTopDesc,ClientVoiceTopIP)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpClientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpClientExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpClientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpClientExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod ClientInsert(ClientIP As %String, ClientName As %String, ServerId As %String, ClientPortNo As %String = "", ClientScreenNo As %String = "", ClientScreenColorNo As %String = "", ClientShowMode As %String = "", ClientShowSpeed As %String = "", ClientShowTime As %String = "", ClientLinkRoomId As %String = "", ClientLinkDocId As %String = "", ClientNote As %String = "", UserId As %String = "", ClientTopIP As %String = "", ClientTopDesc As %String = "", LocTopIP As %String = "", LocTopDesc As %String = "", ClientVoiceTopIP As %String = "") As %String
{
	s nowDate=+$H
	s nowTime=$P($H,",",2)
	s ClientTopIP=$tr(ClientTopIP," ")
	s ClientVoiceTopIP=$tr(ClientVoiceTopIP," ")
	//lzx -插入失败 组件自带空格
	s ClientPortNo=$tr(ClientPortNo," ")
	s ClientScreenNo=$tr(ClientScreenNo," ")
	s ClientScreenColorNo=$tr(ClientScreenColorNo," ")
	s ClientShowMode=$tr(ClientShowMode," ")
	s ClientShowSpeed=$tr(ClientShowSpeed," ")
	s ClientShowTime=$tr(ClientShowTime," ")
	s LocTopIP=$tr(LocTopIP," ")
	s ClientIP=$$upper^SSUTIL4(ClientIP)
	q:ClientIP="" "客户端IP不能为空!"
	q:ClientName="" "客户端名称不能为空!"
	q:ServerId="" "未选择对应叫号服务器!"
	q:(ClientIP="")!(ClientName="")!(ServerId="") "信息不完整!"
	q:$O(^DHCVISClienti(0,"ClientIP",ClientIP,""))'="" "该客户端IP已经存在!"
	&SQL(insert into DHC_VIS_VoiceClient(VIS_ClientIP,VIS_ClientName,VIS_ClientServerID,VIS_ClientPortNo,VIS_ClientScreenNo,VIS_ClientScreenColorNo,VIS_ClientShowMode,VIS_ClientShowSpeed,VIS_ClientShowTime,VIS_ClientLinkRoom,VIS_ClientLinkDoc,VIS_ClientNote,VIS_ClientUpdateUser,VIS_ClientUpdateDate,VIS_ClientUpdateTime,VIS_ClientTopIP,VIS_ClientTopDesc,VIS_LocTopIP,VIS_LocTopDesc,VIS_ClientVoiceTopIP)
		values (:ClientIP,:ClientName,:ServerId,:ClientPortNo,:ClientScreenNo,:ClientScreenColorNo,:ClientShowMode,:ClientShowSpeed,:ClientShowTime,:ClientLinkRoomId,:ClientLinkDocId,:ClientNote,:UserId,:nowDate,:nowTime,:ClientTopIP,:ClientTopDesc,:LocTopIP,:LocTopDesc,:ClientVoiceTopIP))
	i SQLCODE'=0 q "插入失败!"
	q SQLCODE
}

ClassMethod ClientUpdate(ClientId As %String, ClientIP As %String, ClientName As %String, ServerId As %String, ClientPortNo As %String = "", ClientScreenNo As %String = "", ClientScreenColorNo As %String = "", ClientShowMode As %String = "", ClientShowSpeed As %String = "", ClientShowTime As %String = "", ClientLinkRoomId As %String = "", ClientLinkDocId As %String = "", ClientNote As %String = "", UserId As %String = "", ClientTopIP As %String = "", ClientTopDesc As %String = "", LocTopIP As %String = "", LocTopDesc As %String = "", ClientVoiceTopIP As %String = "") As %String
{
	q:(ClientId="") "请选择需要操作的记录!"
	s nowDate=+$H
	s nowTime=$P($H,",",2)
	s ClientTopIP=$tr(ClientTopIP," ")
	s ClientVoiceTopIP=$tr(ClientVoiceTopIP," ")
	//lzx -插入失败 组件自带空格
	s ClientPortNo=$tr(ClientPortNo," ")
	s ClientScreenNo=$tr(ClientScreenNo," ")
	s ClientScreenColorNo=$tr(ClientScreenColorNo," ")
	s ClientShowMode=$tr(ClientShowMode," ")
	s ClientShowSpeed=$tr(ClientShowSpeed," ")
	s ClientShowTime=$tr(ClientShowTime," ")
	s LocTopIP=$tr(LocTopIP," ")
	s ClientIP=$$upper^SSUTIL4(ClientIP)
	q:(ClientId="")!(ClientIP="")!(ClientName="")!(ServerId="") "信息不完整!"
	s ifExit=0
	s ID="" f  s ID=$O(^DHCVISClienti(0,"ClientIP",ClientIP,ID)) q:ID=""  d
	.q:ID=ClientId
	.s ifExit=1
	q:ifExit=1 "此IP地址已经存在!"
	&SQL(update DHC_VIS_VoiceClient set VIS_ClientIP=:ClientIP,VIS_ClientName=:ClientName,VIS_ClientServerID=:ServerId,VIS_ClientPortNo=:ClientPortNo,VIS_ClientScreenNo=:ClientScreenNo,VIS_ClientScreenColorNo=:ClientScreenColorNo,VIS_ClientShowMode=:ClientShowMode,VIS_ClientShowSpeed=:ClientShowSpeed,VIS_ClientShowTime=:ClientShowTime,VIS_ClientLinkRoom=:ClientLinkRoomId,VIS_ClientLinkDoc=:ClientLinkDocId,VIS_ClientNote=:ClientNote,
	VIS_ClientUpdateUser=:UserId,VIS_ClientUpdateDate=:nowDate,VIS_ClientUpdateTime=:nowTime,VIS_ClientTopIP=:ClientTopIP,VIS_ClientTopDesc=:ClientTopDesc,VIS_LocTopIP=:LocTopIP,VIS_LocTopDesc=:LocTopDesc,VIS_ClientVoiceTopIP=:ClientVoiceTopIP where VIS_ClientID=:ClientId)
	i SQLCODE'=0 q "更新失败!"
	q SQLCODE
}

ClassMethod ClientDelete(ClientId As %String) As %String
{
	q:(ClientId="") "请选择需要操作的记录!"
	&SQL(Delete from  DHC_VIS_VoiceClient where VIS_ClientID=:ClientId)
	i SQLCODE'=0 q "删除失败!"
	q SQLCODE
}

Query FindExaRoom(borid As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "Tcode:%String,Tname:%String,Tbor:%String,Tmemo:%String,Tbordr:%String,Tid:%String")
{
	SELECT ExarCode,ExarName,ExarBorDr->ExabName,ExarMemo,ExarBorDr,ID
		From SQLUser.DHCExaRoom where SQLUser.DHCExaRoom.ExarBorDr=:borid
}

Query DeptList(CTType As %String = "", Desc As %String = "") As %Query(ROWSPEC = "CTRowId:%String,CTDesc:%String")
{
}

// d ##class(%ResultSet).RunQuery("web.DHCVISVoiceSet","DeptList","","产科")

// d ##class(%ResultSet).RunQuery("web.DHCVISVoiceSet","DeptList","","CK")

ClassMethod DeptListExecute(ByRef qHandle As %Binary, CTType As %String = "", Desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s LocType=""
	f  s LocType=$o(^CTLOC(0,"LocType",LocType)) q:LocType=""  d
	.q:(CTType'[LocType)&&(CTType'="")
	.s ctlocId=""
	.f  s ctlocId=$o(^CTLOC(0,"LocType",LocType,ctlocId)) q:ctlocId=""  d
	..s CTDesc=$p($g(^CTLOC(ctlocId)),"^",2)
	..s CTDesc=$$ALPHAUP^SSUTIL4(CTDesc)
	..s CTContactName=$p($g(^CTLOC(ctlocId)),"^",43)
	..s CTContactName=$$ALPHAUP^SSUTIL4(CTContactName)
	..s CTContactName=CTContactName_CTDesc
	..q:((Desc'="")&&(CTDesc'[Desc))||(Desc'="")&&(CTContactName'[Desc)
	..s CTRowId=ctlocId
	..Do OutputRow1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(CTRowId,CTDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod DeptListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		Set AtEnd=1
		Set Row=""
	}
	Else {
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DeptListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCVISVoiceSet).GetAppVersion("")
ClassMethod GetAppVersion(serverIP As %String = "") As %String
{
	i serverIP'="" s ServerId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:$G(ServerId)="" ""
	s ServerStr=$G(^DHCVISServer(ServerId))
	s ServerAutoUpdate=$P(ServerStr,"^",17)
	q:ServerAutoUpdate="N" ""
	s Version=$G(^DHCVISSet("Version"))
	i Version="" s Version="5.5.0.3"
	s hostname=$ZU(54,0)
	s dabaseIP=$P($ZU(54,13,hostname),",")
	i $G(^DHCVISSet("Ftp","ServerIP"))'="" s dabaseIP=$G(^DHCVISSet("Ftp","ServerIP"))
	s UpdateAddress=$G(^DHCVISSet("UpdateAddress"))
	i UpdateAddress="" s UpdateAddress="/vis/wget/"
	s URL="http://"_dabaseIP_UpdateAddress_"DHCVoiceCall.exe"
	s TargetFile="C:\DHCVISVoiceCall\DHCVoiceCall.exe"
	s ShareURL="\\"_dabaseIP_"\PrtSc\"      //抓图存放的共享目录   js写的目录是 /vis/wget/PrtSc/
	s RetStr=Version_"^"_URL_"^"_TargetFile_"^"_ShareURL
	q RetStr
}

/// w ##class(web.DHCVISVoiceSet).GetFtpInformation("")
ClassMethod GetFtpInformation(serverIP As %String = "") As %String
{
	s RetStr=""
	s FtpServerIP=$G(^DHCVISSet("Ftp","ServerIP"))
	i FtpServerIP="" s FtpServerIP="127.0.0.1"
	s FtpServerDir=$G(^DHCVISSet("Ftp","Voice"))
	i FtpServerDir="" s FtpServerDir="/voice/"
	s FtpUser=$G(^DHCVISSet("Ftp","User"))
	i FtpUser="" s FtpUser="administrator"
	s FtpPassword=$G(^DHCVISSet("Ftp","Password"))
	i FtpPassword="" s FtpPassword="huitailang489523"
	s FtpLog=$G(^DHCVISSet("Ftp","Log"))
	i FtpLog="" s FtpLog="/PrtSc/"
	s FtpVoiceMessage=$G(^DHCVISSet("Ftp","VoiceMessage"))
	i FtpVoiceMessage="" s FtpVoiceMessage="/vis/voicemessage/"
	i $G(serverIP)="" s serverIP=$ZUTIL(67,15,$JOB)
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	s SuperServer=$P($G(^DHCVISServer(serverId)),"^",16)
	i SuperServer="" s SuperServer="N"
	s RetStr=FtpServerIP_"^"_FtpUser_"^"_FtpPassword_"^"_FtpServerDir_"^"_FtpLog_"^"_SuperServer_"^"_FtpVoiceMessage
	q RetStr
}

/// w ##class(web.DHCVISVoiceSet).GetAreaTitle("")
ClassMethod GetAreaTitle(serverIP As %String = "") As %String
{
	s RetStr=""
	i serverIP="" s serverIP=$ZUTIL(67,15,$JOB)
	q:serverIP="" ""
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	q:serverId=""
	s RetStr=$P($G(^DHCVISServer(serverId)),"^",14)
	q RetStr
}

/// w ##class(web.DHCVISVoiceSet).GetServerQueType("")
ClassMethod GetServerQueType(IPAddress As %String = "") As %String
{
    ////服务器设置 备注 为 二级分诊等候人数 "0"-不取等候人数 为空时取系统设置的 
	q:IPAddress="" ""
	s IPAddress=$$upper^SSUTIL4(IPAddress)
	s QueType=""
	s clientId=$O(^DHCVISClienti(0,"ClientIP",IPAddress,""))
	i clientId'="" d
	.s serverId=$P($G(^DHCVISClient(clientId)),"^",1)
	.s QueType=$P($G(^DHCVISServer(serverId)),"^",9)
	q QueType
}

}
