/// Mozy	2017-2-23
/// 消息发送信息(用于记录短信,Email等的发送信息)
Class web.DHCEQMessageSendInfo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 描述:新增,更新数据
/// w ##Class(web.DHCEQMessageSendInfo).AddData("1^1^^Sun^Test^13012345678^^Hold1^Hold2^Hold3")
/// w ##Class(web.DHCEQMessageSendInfo).AddData("1^10^30^DHCC^短信^13812345678^^^^")
/// w ##Class(web.DHCEQMessageSendInfo).AddData("1^11^31^Demo^短信^110^^^^")
/// w ##Class(web.DHCEQMessageSendInfo).AddData("1^^^ReceiveUser^测试^13610029678")
ClassMethod AddData(val As %String = "")
{
	i $p(val,"^",6)="" q 0
	Set $ZT="ERRORAdd"
	
	k PLIST
	s PLIST(2) = $p(val,"^",1)		;MessagesType
	s PLIST(3) = $p(val,"^",2)		;MessagesDR
	s PLIST(4) = $p(val,"^",3)		;MessagesRecInfoDR
	s PLIST(5) = $p(val,"^",4)		;ReceiveUser
	s PLIST(6) = $p(val,"^",5)		;MsgInfo
	s PLIST(7) = $p(val,"^",6)		;ToAddress
	s PLIST(8) = $p(val,"^",7)		;Remark
	s PLIST(9) = 0					;Status
 	s PLIST(10) = 0					;Times
	;Set ID=$Order(^DHCEQMessageSendInfo(0,"Type",PLIST(2),PLIST(3),PLIST(7),""),-1)
 	;If ID'="" Set PLIST(10) = 1 + $Piece($Get(^DHCEQMessageSendInfo(ID)),"^",9)
	;s PLIST(11) = +$H				;SendDate
 	;s PLIST(12) = $P($H,",",2)		;SendTime
 	;s PLIST(13) = $p(val,"^",9)	;ErrInfo
    //Modify by zx 2021-07-30 消息发送增加重复发生处理
    s PLIST(14) = +$H				;CreateDate
 	s PLIST(15) = $P($H,",",2)		;CreateTime
 	s PLIST(16) = $p(val,"^",8)		;RepeatFlag
 	s PLIST(17) = $p(val,"^",9)		;RepeatLength
 	s PLIST(18) = $p(val,"^",10)	;MaxLength
 	
	TSTART	
	&SQL(insert into sqluser.DHC_EQMessageSendInfo values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
 	
	TCOMMIT
 	
 	Quit 0
ERRORAdd 
	TRollBack	
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "<ERRORAdd>"_ErrorMsg		//返回错误消息
}

/// w ##Class(web.DHCEQMessageSendInfo).UpdateData("4^1")
/// w ##Class(web.DHCEQMessageSendInfo).UpdateData("5^空号")
/// Modify by zx 2021-07-31
/// input:"消息ID^返回状态^返回结果"
/// Modify by zx 2021-08-27
/// 消息状态调整
ClassMethod UpdateData(val As %String = "")
{
	n RowID,Times
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	s CurDate=+$H
	s CurTime=$P($H,",",2)
	Set $ZT="ERRORUpdate"
	
	k PLIST,MPLIST
 	//add by zx 2018-11-23 增加数据获取未返回状态
 	s PLIST(9) = $p(val,"^",2)		;Status
 	s PLIST(11) = CurDate			;SendDate
	s PLIST(12) = CurTime    		;SendTime
	s PLIST(13) = $p(val,"^",3)     ;ErrInfo
	s Times=1 + $Piece($Get(^DHCEQMessageSendInfo(RowID)),"^",9)	;Times
 	if PLIST(9)=1
 	{
	 	Set PLIST(10) = Times
	}
	elseif PLIST(9)=3
	{
		s PLIST(13) = ""
	}
	else
	{
		Set PLIST(10) = Times
 		s PLIST(9) = 2
	}
	//重复发送时,未到有效期时状态仍未0
	s RepeatFlag=$Piece($Get(^DHCEQMessageSendInfo(RowID)),"^",15)
	i RepeatFlag="Y"
	{
		s BeginDate=$Piece($Get(^DHCEQMessageSendInfo(RowID)),"^",13)
		s BeginTime=$Piece($Get(^DHCEQMessageSendInfo(RowID)),"^",14)
		s CreateLength=##Class(web.DHCEQCommon).TimeDiff(BeginDate,BeginTime,CurDate,CurTime,0)
		s CreateLength=$fn($p(CreateLength,"^",1)/3600,"",2)
		s MaxLength=$Piece($Get(^DHCEQMessageSendInfo(RowID)),"^",17)
		i (CreateLength<MaxLength)&&(PLIST(9)=1) s PLIST(9)=0
	}
	TSTART	
 	if RowID'=""
 	{
		&SQL(update sqluser.DHC_EQMessageSendInfo values :PLIST() where MSI_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		if (PLIST(9)'=3)
		{
			s MPLIST(2)=RowID
			s MPLIST(3)=CurDate
			s MPLIST(4)=CurTime
			s MPLIST(5)=Times
			s MPLIST(6)=$p(val,"^",2)
			s MPLIST(7)=$p(val,"^",3)
			&SQL(insert into sqluser.DHC_EQMessageSendInfoDetail values :MPLIST())
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
 	}
 	
	TCOMMIT
 	
 	q RowID
ERRORUpdate 
	TRollBack	
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "<ERRORUpdate>"_ErrorMsg   //返回错误消息
}

/// w ##class(web.DHCEQMessageSendInfo).GetMessageSendInfo(1,52,"12345678912")
ClassMethod GetMessageSendInfo(MessagesType As %String = "", MessagesDR As %String = "", ToAddress As %String = "")
{
	If (MessagesType="")||(MessagesDR="")||(ToAddress="") Quit ""
	new rowid,result,resultex
	Set result=""
	Set resultex=""
	
	Set rowid=""
	For  Set rowid=$Order(^DHCEQMessageSendInfo(0,"Type",MessagesType,MessagesDR,ToAddress,rowid)) Quit:rowid=""  Do
	.If resultex'="" Set resultex=resultex_"&"
	.Set result=$Get(^DHCEQMessageSendInfo(rowid))
	.Set resultex=resultex_rowid_"^"_result
	.Set resultex=resultex_"^"_##class(web.DHCEQMessageSendInfo).GetMessagesType($Piece(result,"^",1))	;MessagesType
	.Set resultex=resultex_"^"_##class(web.DHCEQMessageSendInfo).GetSendStatus($Piece(result,"^",8))	;Status
	.Set resultex=resultex_"^"
	.If $Piece(result,"^",10)'=""  Do  //Date
	..Set resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",10),"date")
	.Set resultex=resultex_"^"
	.If $Piece(result,"^",11)'=""  Do  //Time
	..Set resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",11),"time")
	
	Set resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n")
	Quit resultex
}

ClassMethod GetMessagesType(MessagesType)
{
	Quit $CASE(MessagesType,"1":"短信","2":"Email","3":"微信")
}

// add by zx 2018-11-23 增加数据获取未返回状态

ClassMethod GetSendStatus(Status)
{
	Quit $CASE(Status,"0":"未发送","1":"已发送","2":"发送未成功","3":"发送未返回",:"没有定义")
}

/// w ##class(web.DHCEQMessageSendInfo).GetMessageSendTimes(1,52,"12345678912")
ClassMethod GetMessageSendTimes(MessagesType As %String = "", MessagesDR As %String = "", ToAddress As %String = "")
{
	If (MessagesType="")||(MessagesDR="")||(ToAddress="") Quit 0
	Set ID=$Order(^DHCEQMessageSendInfo(0,"Type",MessagesType,MessagesDR,ToAddress,""),-1)
	If ID="" Quit 0
	
	Quit $Piece($Get(^DHCEQMessageSendInfo(ID)),"^",9)
}

/// 入参:
/// 		status-过滤发送状态		times-过滤发送次数的消息
/// d ##class(%ResultSet).RunQuery("web.DHCEQMessageSendInfo","GetMSIDetail",1,5)
Query GetMSIDetail(status As %String = "", times As %String = "") As %Query(ROWSPEC = "TRowID:%String,TMessagesType:%String,TMessagesDR:%String,TMsgTitle:%String,TMessagesRecInfoDR:%String,TReceiveUser:%String,TMsgInfo:%String,TToAddress:%String,TRemark:%String,TStatus:%String,TTimes:%String,TSendDate:%String,TSendTime:%String,TErrInfo:%String,THold1:%String,THold2:%String,THold3:%String")
{
}

ClassMethod GetMSIDetailExecute(ByRef qHandle As %Binary, status As %String = "", times As %String = "") As %Status
{
 	New repid, index,rowid,CurRole
	Set repid=$Increment(^CacheTemp)
 	Set qHandle=$ListBuild(0,repid,0)
	Set index=1
	Set TRow=0
	
	Set TMessagesTypeDR=""
	For  Set TMessagesTypeDR=$Order(^DHCEQMessageSendInfo(0,"TypeStatus",TMessagesTypeDR)) Quit:TMessagesTypeDR=""  Do
	.Set TStatusDR=""
	.For  Set TStatusDR=$Order(^DHCEQMessageSendInfo(0,"TypeStatus",TMessagesTypeDR,TStatusDR)) Quit:TStatusDR=""  Do
	..Quit:(status'="")&&(TStatusDR=status)
	..//Modify by zx 2021-07-31  0:未发送 1:已发送 2发送失败 3获取未返回 4不需发送
	..Quit:(TStatusDR="3")||(TStatusDR="4")
	..Set rowid=0
	..For  Set rowid=$Order(^DHCEQMessageSendInfo(0,"TypeStatus",TMessagesTypeDR,TStatusDR,rowid)) Quit:rowid=""  Do
	...Do ResetVariablesGetMSIDetail
	...Set TRowID = rowid
	...Set TMessagesType=##class(web.DHCEQMessageSendInfo).GetMessagesType(TMessagesTypeDR)
	...Set TMessagesDR =$Piece($Get(^DHCEQMessageSendInfo(rowid)),"^",2)
	...// Modify by zx 2021-07-31 关联业务待办消息表时,处理后不再发送
	...Set TMessagesDealFlag="N"
	...If TMessagesDR'="" d
	....Set TMsgTitle=$Piece($Get(^DHCEQMessages(TMessagesDR)),"^",1)
	....Set TMessagesDealFlag=$Piece($Get(^DHCEQMessages(TMessagesDR)),"^",21)
	...Quit:TMessagesDealFlag'="N"
	...Set TMessagesRecInfoDR = $Piece($Get(^DHCEQMessageSendInfo(rowid)),"^",3)
	...s TMessagesDelayLength=0
	...s TReRepeatSendFlag="1"
	...i TMessagesRecInfoDR'="" d
	....Set TMessagesDelayLength=$Piece($Get(^DHCEQMessagesRecInfo(TMessagesRecInfoDR)),"^",13)
	...i +TMessagesDelayLength>0 d
	....Set TMessagesReceiveDate=$Piece($Get(^DHCEQMessagesRecInfo(TMessagesRecInfoDR)),"^",6)
	....Set TMessagesReceiveTime=$Piece($Get(^DHCEQMessagesRecInfo(TMessagesRecInfoDR)),"^",7)
	....Set TMessagesReceiveLength=##Class(web.DHCEQCommon).TimeDiff(TMessagesReceiveDate,TMessagesReceiveTime,$H,$P($H,",",2),0)
	....Set TMessagesReceiveLength=$fn($p(TMessagesReceiveLength,"^",1)/3600,"",2)
	....i (TMessagesDelayLength>TMessagesReceiveLength) s TReRepeatSendFlag="0"
	...q:TReRepeatSendFlag'="1"
	...Set TReceiveUser = $Piece($Get(^DHCEQMessageSendInfo(rowid)),"^",4)
	...Set TMsgInfo = $Piece($Get(^DHCEQMessageSendInfo(rowid)),"^",5)
	...Set TToAddress = $Piece($Get(^DHCEQMessageSendInfo(rowid)),"^",6)
	...Set TRemark = $Piece($Get(^DHCEQMessageSendInfo(rowid)),"^",7)
	...Set TStatus=##class(web.DHCEQMessageSendInfo).GetSendStatus(TStatusDR)
	...Set TTimes = $Piece($Get(^DHCEQMessageSendInfo(rowid)),"^",9)
	...Quit:(times'="")&&(TStatusDR'="0")&&(TTimes>times)  //Modify by zx 2021-07-31 未发送消息不受次数限制
	...Set TSendDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQMessageSendInfo(rowid)),"^",10),"date")
	...Set TSendTime=$Piece($Get(^DHCEQMessageSendInfo(rowid)),"^",11)
	...//Modify by zx 2021-07-31 重复发送控制
	...s TRepeatFlag=$Piece($Get(^DHCEQMessageSendInfo(rowid)),"^",15)
	...i TRepeatFlag="Y" d
	....s TRepeatLength=$Piece($Get(^DHCEQMessageSendInfo(rowid)),"^",16)
	....s TCurrentLength=##Class(web.DHCEQCommon).TimeDiff(TSendDate,TSendTime,$H,$P($H,",",2),0)
	....s TCurrentLength=$fn($p(TCurrentLength,"^",1)/3600,"",2)
	....i (TCurrentLength<TRepeatLength) s TReRepeatSendFlag="0"
	...q:TReRepeatSendFlag'="1"
	...s TSendDate = ##class(web.DHCEQCommon).TransValueToPage(TSendDate,"date")
	...Set TErrInfo=$Piece($Get(^DHCEQMessageSendInfo(rowid)),"^",12)
	...Set THold1=$Piece($Get(^DHCEQMessageSendInfo(rowid)),"^",13)
	...Set THold2=$Piece($Get(^DHCEQMessageSendInfo(rowid)),"^",14)
	...Set THold3=$Piece($Get(^DHCEQMessageSendInfo(rowid)),"^",15)
	...Quit:##Class(web.DHCEQMessageSendInfo).UpdateData(rowid_"^3")'>0  //add by zx 2018-11-23 获取数据后修改状态
	...DO OutputRowGetMSIDetail
	Quit $$$OK
OutputRowGetMSIDetail
	Set TRow=TRow+1
	Set Data=$ListBuild(TRowID,TMessagesType,TMessagesDR,TMsgTitle,TMessagesRecInfoDR,TReceiveUser,TMsgInfo,TToAddress,TRemark,TStatus,TTimes,TSendDate,TSendTime,TErrInfo,THold1,THold2,THold3)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	Quit
ResetVariablesGetMSIDetail
	Set (TRowID,TMessagesType,TMessagesDR,TMsgTitle,TMessagesRecInfoDR,TReceiveUser,TMsgInfo,TToAddress,TRemark,TStatus,TTimes,TSendDate,TSendTime,TErrInfo,THold1,THold2,THold3)=""
	Quit
}

ClassMethod GetMSIDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMSIDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$ListBuild(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMSIDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMSIDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// add by ZX 2022-6-10

ClassMethod MessageDealByRecInfo(RecInfoDR As %String = "")
{
	n MessagesDR,ActionIDs,ReceiveUserDR,DealFlag,BussType,BussID,BussInfo,ApproveInfo,EquipNo,UseLoc,No,Name,LastOperate,ApproveSetDR,ActionID,ActionCodes,ActionDescs
	s (MessagesDR,ActionIDs,ReceiveUserDR,DealFlag,BussType,BussID,BussInfo,ApproveInfo,EquipNo,UseLoc,No,Name,LastOperate,ApproveSetDR,ActionID,ActionCodes,ActionDescs)=""
	i (RecInfoDR="") q "Y^^^^^^^^"
	
	s MessagesDR=$p($g(^DHCEQMessagesRecInfo(RecInfoDR)),"^",1)
	s ActionIDs=$p($g(^DHCEQMessagesRecInfo(RecInfoDR)),"^",10)
	s ReceiveUserDR=$p($g(^DHCEQMessagesRecInfo(RecInfoDR)),"^",2)
	s DealFlag=$p($g(^DHCEQMessages(MessagesDR)),"^",21)
	s BussType=$p($g(^DHCEQMessages(MessagesDR)),"^",10)
	s BussID=$p($g(^DHCEQMessages(MessagesDR)),"^",11)
	s BussInfo=##Class(web.DHCEQMessages).GetBussInfo(BussType,BussID)
	s ApproveInfo=##Class(web.DHCEQMessages).GetApproveInfo(BussType,BussID,"")
	
	s EquipNo=$p(BussInfo,"^",23) 
	s UseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(BussInfo,"^",5))
	s No=$p(BussInfo,"^",1)
	s Name=$p(BussInfo,"^",2)
	s LastOperate=$p(BussInfo,"^",21)
							
	s ApproveSetDR=$p(ApproveInfo,"^",3)
	
	i ActionIDs'="" d
	.s ActionIDsLen=$l(ActionIDs,",")
	.f i=1:1:ActionIDsLen d
	..s ActionID=$p(ActionIDs,",",i)
	..i ActionCodes'="" s ActionCodes=ActionCodes_","
	..s ActionCodes=ActionCodes_$p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",1)
	..i ActionDescs'="" s ActionDescs=ActionDescs_","
	..s ActionDescs=ActionDescs_$p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",2)
	
	q DealFlag_"^"_ReceiveUserDR_"^"_BussType_"^"_BussID_"^"_EquipNo_"^"_UseLoc_"^"_No_"^"_Name_"^"_LastOperate_"^"_ApproveSetDR_"^"_ActionCodes_"^"_ActionDescs
}

}
