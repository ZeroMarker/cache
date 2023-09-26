Import SQLUSER

/// Creator:     	qqa
/// CreateDate:   	2021-09-09
/// Descript:		消息界面
Class web.DHCPRESCNewsContact Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCPRESCNewsContact).InsertMessage("2258^报错了^Doctor","2^214^22^11843")
ClassMethod InsertMessage(Params, LgParams)
{
	n (Params,LgParams)
	s AuditID=$p(Params,"^",1)
	s Content=$p(Params,"^",2)
	s LgUserID=$p(LgParams,"^",4)
	s UserType=$p(Params,"^",3)
	s RecUserType=$case(UserType,"Doctor":"Audit","Audit":"Doctor")
	
	s Ret=##class(web.DHCPRESCNewsContact).Inset(Params,LgParams)
	q:Ret<0 "保存消息数据失败!"
	
	q ##class(web.DHCPRESCNewsContact).JsonMsgData(Ret)
	
	;下面的websocket去掉了
	
	
	s MsgRowId = Ret
	
	s RecUserId=##class(web.DHCPRESCNewsContact).GetRecUserId(UserType,AuditID)
	q:+RecUserId=0 0 ;没有找到接收消息的人,不再发送消息
	
	///修改左侧消息数量：如果发送过去恰好用户看到消息会刷新数量
	s UnReadMesNumber = ##class(web.DHCPRESCAuditPopup).GetUnReadMessageNumber(AuditID)
	s Number=$case(RecUserType,"Doctor":$p(UnReadMesNumber,"^",1),"Audit":$p(UnReadMesNumber,"^",2))
	s Text = RecUserType_"^"_AuditID_"^"_Number
	d ##class(web.DHCPRESCMessageWebSocketServer).Send(RecUserId,Number)
	
	///推送消息
	b ;1
	s MsgData=##class(web.DHCPRESCNewsContact).JsonMsgData(MsgRowId)
	b ;3
	d ##class(web.DHCPRESCMessageWebSocketServer).Send(LgUserID,MsgData)
	d ##class(web.DHCPRESCMessageWebSocketServer).Send(RecUserId,MsgData)
	
	//修改接受消息的人的右下角消息数量
	s Text=##class(web.DHCPRESCAuditPopup).MainUnReadTextNew(RecUserType_"^"_RecUserId)
	d ##class(web.DHCPRESCWebSocketServer).Send("",RecUserId,Text)	;左下角落数量刷新
	
	q 0
}

/// Descript:保存数据
ClassMethod Inset(Params, LgParams)
{
	n (Params,LgParams)
	s AuditID=$p(Params,"^",1)
	s LgUserID=$p(LgParams,"^",4)
	s Content=$p(Params,"^",2)
	s UserType=$p(Params,"^",3)
	s Date=+$h
	s Time=$p($h,",",2)
	s LocID=""
	s ReadFlag="N"
	s LastId=""
	&sql(INSERT INTO PHA_PREADT.AuditMsg (PAM_Audit_Dr,PAM_SendUser_Dr,PAM_Content,PAM_Date,PAM_Time,PAM_Loc_DR,PAM_ReadFlag,PAM_Type)
		VALUES (:AuditID,:LgUserID,:Content,:Date,:Time,:LocID,:ReadFlag,:UserType))
	q:SQLCODE'=0 "-1"
	b ;err111
	q %ROWID
}

/// Creator:qqa
/// Descript:消息列表
/// w ##class(web.DHCPRESCNewsContact).JsonListMsgData(7462)
ClassMethod JsonListMsgData(Params)
{
	n (Params)
	s ^temptest("Params11") = Params
	s AuditID=$p(Params,"^",1)
	s PARRowID=##class(web.DHCPRESCNewsContact).GetPARLastRowId(AuditID)
	
	s TMPData("AuditData","JsonData")=##class(web.DHCPRESCAuditPopup).JsonUnreadMessageNew(AuditID)

	s PAMRowID=0
	f  s PAMRowID=$o(^PHA.PREADT.AuditMsgI("PAMAudit",AuditID,PAMRowID)) q:PAMRowID=""  d
	.s MDate=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),5)
	.s MTime=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),6)
	.s OrderIndex=MDate_","_MTime_","_PAMRowID
	.
	.s TMPData("MsgJsonData",OrderIndex)=##class(web.DHCPRESCNewsContact).JsonMsgData(PAMRowID)
	
	w "{"
	;申请信息
	w """AuditData"":"
	w $g(TMPData("AuditData","JsonData"))
	w ","
	;消息内容
	w """MsgData"":"
	w "["
	s Count=0,Index=""
	f  s Index=$o(TMPData("MsgJsonData",Index)) q:Index=""  d
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w TMPData("MsgJsonData",Index)
	w "]"
	w "}"
	q ""
}

/// w ##class(web.DHCPRESCNewsContact).JsonMsgData(1)
ClassMethod JsonMsgData(PAMRowID)
{
	n (PAMRowID)
	q:+PAMRowID=0 "{}"
	s SendUserID=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),3)
	s SendUser=$p($g(^SSU("SSUSR",+SendUserID)),"^",2)	
	s Content=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),4)
	s Date=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),5)
	s MDate=Date
	s:Date'="" Date=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(Date)
	s Time=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),6)
	s MTime=Time
	s:Time'="" Time=$zt(Time,1)
	s RecLocID=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),7)
	s RecLoc=$p($g(^CTLOC(+RecLocID)),"^",2)
	s ReadFlag=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),8)
	s Type=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),9)
	s ListData=PAMRowID_"^"_SendUserID_"^"_SendUser_"^"_Content_"^"_Date_"^"_Time_"^"_RecLocID_"^"_RecLoc_"^"_ReadFlag_"^"_Type
	s ListTitle="PAMRowID^SendUserID^SendUser^Content^Date^Time^RecLocID^RecLoc^ReadFlag^Type"
	q ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
}

/// w ##class(web.DHCPRESCNewsContact).SetMsgReadStatus("Doctor","1,2,3,4","2^214^22^11843")
ClassMethod SetMsgReadStatus(UserType, IdStr, LgParams)
{
	n (UserType,IdStr,LgParams)
	s LgUserID=$p(LgParams,"^",4)
	s Len=$l(IdStr,",")
	s AuditID=$lg(^PHA.PREADT.AuditMsgD(+IdStr),2)
	ts
	s Err=0
	f i=1:1:Len q:Err'=0  d
	.s Id=$p(IdStr,",",i)
	.&sql(UPDATE PHA_PREADT.AuditMsg SET PAM_ReadFlag="Y" WHERE PAM_RowID =:Id)
	.s Err=SQLCODE
	tro:Err'=0
	q:Err'=0 "修改已读状态失败,失败信息:"_Err
	tc
	
	s Text = UserType_"^"_AuditID_"^"_0
	Do ##class(web.DHCPRESCMessageWebSocketServer).Send(LgUserID,Text)
	
	q Err
}

/// Descript:最后一次审核记录的id
/// w ##class(web.DHCPRESCNewsContact).GetPARLastRowId(1)
ClassMethod GetPARLastRowId(AuditId)
{
	n (AuditId)
	s RetRowId=""
	s ID=""
	f  s ID=$o(^PHA.PREADT.AuditResultI("Parref",AuditId,ID)) q:(ID="")||(RetRowId'="")  d
	.s LastId=$lg(^PHA.PREADT.AuditResultD(ID),9)
	.q:LastId'=""
	.s RetRowId=ID
	q RetRowId
}

/// ws，消息沟通
/// w ##class(web.DHCPRESCNewsContact).WsSendData("Doctor",1,"11843")
ClassMethod WsSendData(UserType, AuditID, UserID, PAMRowID = "")
{
	n (UserType,AuditID,UserID,PAMRowID)
	
	s AppUserID=$lg(^PHA.PREADT.AuditD(AuditID),11) ;申请人
	
	s JsonData=##class(web.DHCPRESCAuditPopup).JsonUnreadMessageNew(AuditID)
	s LiItmText = "list"_$c(2)_JsonData
	
	s MsgJsonData=##class(web.DHCPRESCNewsContact).JsonMsgData(PAMRowID)
	s MsgText = "msg"_$c(2)_MsgJsonData
	
	s Err=0
	b   //s1
	;消息列表左侧显示数字修改 
	s:(UserType="Doctor")||(PAMRowID="") Err=##class(web.DHCPRESCWebSocketServer).Send(UserType,UserID,LiItmText)
	q:Err'=0 "列表未读数量更新ws交互失败!"
	b ;333
	;消息沟通
	i PAMRowID'="" d
	.;中心人员自动同步左侧列表未读数字
	.s Err=##class(web.DHCPRESCWebSocketServer).Send("Audit","",LiItmText)
	.q:Err'=0
	.
	.;审方中心刷新消息：所有审方中心的人都能看见发送的消息
	.s Err=##class(web.DHCPRESCWebSocketServer).Send("Audit","",MsgText)
	.q:Err'=0
	.;申请人界面刷新
	.s Err=##class(web.DHCPRESCWebSocketServer).Send("Doctor",AppUserID,MsgText)
	.q:Err'=0
	.;发送人(登录)人界面刷新
	.s:(AppUserID'=UserID) Err=##class(web.DHCPRESCWebSocketServer).Send("Doctor",UserID,MsgText)

	
	s Text=##class(web.DHCPRESCAuditPopup).MainUnReadTextNew("Doctor^"_AppUserID)
	s UnReadText="number"_$c(2)_Text
	s Err=##class(web.DHCPRESCWebSocketServer).Send("Doctor",AppUserID,UnReadText)
	q:Err'=0 "未读数量申请人更新失败!"
	
	s Text=##class(web.DHCPRESCAuditPopup).MainUnReadTextNew("Audit^")
	s UnReadText="number"_$c(2)_Text
	s Err=##class(web.DHCPRESCWebSocketServer).Send("Audit","",UnReadText)
	q:Err'=0 "未读数量审方中心数量更新失败!"
	
	q Err
}

/// Descripts:消息发送获取接收人UserID，医师发送取消息沟通第一个药师，药师发送取申请人
/// Input:发消息人类型Doctor/Audit，发消息人UserID，
/// w ##class(web.DHCPRESCNewsContact).GetRecUserId("Doctor",1)
ClassMethod GetRecUserId(UserType, AuditID)
{
	q:+AuditID=0 ""
	s RetUserId=""
	i UserType="Doctor" d
	.s PAMRowID=0
	.f  s PAMRowID=$o(^PHA.PREADT.AuditMsgI("PAMAudit",AuditID,PAMRowID)) q:(PAMRowID="")||(RetUserId'="")  d
	..s PAUserId=$lg(^PHA.PREADT.AuditD(AuditID),11)
	..s PAMType=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),9)
	..q:PAMType'="Audit"
	..s RetUserId=PAUserId
	
	i UserType="Audit" d
	.s RetUserId=$lg(^PHA.PREADT.AuditD(AuditID),11)
	q RetUserId
}

}
