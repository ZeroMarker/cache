Class web.DHCANOPMessage Extends %RegisteredObject
{

ClassMethod InsertMessageDetail(para As %String) As %String
{
	s OpaId=$p(para,"^",1)
	s MsgId=$p(para,"^",2)
	s Date=$p(para,"^",3)
	s Time=$p(para,"^",4)
	s IntervalTime=$p(para,"^",5)
	s Ctloc=$p(para,"^",6)
	s Group=$p(para,"^",7)
	s User=$p(para,"^",8)
	s Note=$p(para,"^",9)
	s Status=$p(para,"^",10)
	
	q:OpaId="" "-1"
	q:MsgId="" "-2"
	i Date="" s Date=+$H
	i Time="" s Time=$p($h,",",2)
	i Ctloc="" s Ctloc=%session.Data("LOGON.CTLOCID")
	i Group="" s Group=%session.Data("LOGON.GROUPID")
	i User="" s User=%session.Data("LOGON.USERID")
	s Status="U"
	
	s obj=##class(User.DHCANMessageDetail).%New()
	s obj.ANMDOpaDr=OpaId
	s obj.ANMDMsgDr=MsgId
	s obj.ANMDDate=Date
	s obj.ANMDTime=Time
	s obj.ANMDIntervalTime=IntervalTime
	s obj.ANMDCtloc=Ctloc
	s obj.ANMDGroupDr=Group
	s obj.ANMDUserDr=User
	s obj.ANMDNote=Note
	s obj.ANMDStatus=Status
	
	s saveStatus=obj.%Save()
	q:(+saveStatus=0) "-3^数据保存失败!"_para
	s ANMDRowId=obj.%Id()
	d obj.%Close()
	q ANMDRowId
}

/// w ##class(web.DHCANOPMessage).GetShowMessage("3","17/10/2014","17/10/2014")
ClassMethod GetShowMessage(MsgRowID, stdate, enddate) As %String
{
	q:MsgRowID="" "-1"

	i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)

	s retStr=""
	s count=0
	s MsgMaxinum=$li($g(^DHCANC("Message",MsgRowID)),6)
	s status=""
	s ANMDRowId="" f  s ANMDRowId=$o(^DHCANMessage(0,"Message",MsgRowID,ANMDRowId),-1) q:ANMDRowId=""  d
	.q:ANMDRowId=0
	.s ANMDDate=$li(^DHCANMessage(ANMDRowId),3)
	.q:(ANMDDate<sdate)!(ANMDDate>edate)
	.s ANMDNote=$li(^DHCANMessage(ANMDRowId),9)
	.s ANMDStatus=$li(^DHCANMessage(ANMDRowId),10)
	.;s ANMDStatus="R"
	.i (ANMDStatus="")!(ANMDStatus="U") s status="U"
	.w ANMDRowId
	.s count=count+1
	.q:count>MsgMaxinum
	.i retStr="" s retStr=ANMDNote
	.e  s retStr=retStr_"^"_ANMDNote
	i status="" s retStr=""
	q retStr
}

/// 获取病人的病案号
/// w ##class(web.DHCANOPMessage).GetmedCareNo("183947")
ClassMethod GetmedCareNo(opaId) As %String
{
	s medCareNo=""
	s admId=$P(^DHCANOPArrange(opaId),"^",1)
	s papmiId=$p($g(^PAADM(admId)),"^",1)
	s paadmtype=$p($g(^PAADM(admId)),"^",2)
	s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
	//s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	//S medCareNo= ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(admId , .ErrMsg)
	q medCareNo
}

/// 获取病人的状态
/// w ##class(web.DHCANOPMessage).GetopaStatus("184")
ClassMethod GetopaStatus(opaId) As %String
{
	s status=""
	s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	s opaPatStatus=$P(^DHCANOPArrange(opaId),"^",23)
	s status=""
    i opaStatus="A" s status="申请"
	i (opaStatus="D")&(opaPatStatus'="I") s status="拒绝"
	i opaStatus="R" s status="安排"
	i opaStatus="N" s status="非预约"
	i opaStatus="I" s status="术中"
	i opaStatus="P" s status="恢复室"
	i opaStatus="L" s status="术毕"
	i opaStatus="F" s status="完成"
	i (opaStatus="D")&(opaPatStatus="I") s status="撤销"
	q status
}

/// 插入病人信息(病房准备)
/// d ##class(web.DHCANOPMessage).InsertAnMessage("2149","213","3053")
ClassMethod InsertAnMessage(EpisodeID, opaId, userId) As %String
{
    i EpisodeID="",opaId'="" s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	q:EpisodeID="" ""
	s operLocDesc="",patName="",age="",ward="",bedCode="",opdes="",oproom="",medCareNo="",MsgId="",Ctloc=""
    s medCareNo=..GetmedCareNo(opaId)
    s stats=..GetopaStatus(opaId)
	s anaesrw=""
	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	s bedCode="" i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	s ward="" i curWardId'="" s ward=$P($G(^PAWARD(curWardId)),"^",2)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s age=##Class(web.UDHCANOPArrange).CalAge(birth,+$h)
	s opstdate=+$h
	s day=$zd(opstdate,10)
	i day>4 s opstdate=opstdate+1
	i day=5 s opstdate=opstdate+1
	s opdate=$ZD(opstdate+1,4)_"          "
	s locListCodeStr=##class(web.DHCCLCom).AdjustLocListCode("OP^OUTOP^EMOP",EpisodeID)	
	s age=##Class(web.UDHCANOPArrange).CalAge(birth,opstdate)
	s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	i oproomdr'="" s oproom=$P($G(^DHCANC("OPRoom",oproomdr)),"^",2)
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$P(anaId,"||",2)	
	s anaesrw=EpisodeID_"||"_anaSub
	s i=0
	s subchl=0 
	f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")!(i=1)  d
       .s i=i+1
	   .s opdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",6)
	   .i opdr'="" d
	   ..i $D(^ORC("OPER",opdr)) d
	   ...s opdes=$P(^ORC("OPER",opdr),"^",2)
       ...s OPStatName=$P(^ORC("OPER",opdr),"^",35) 						
	   .e  d
       ..i $g(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",2))'="" d
       ...s opdes=$G(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",2))
       ...s opdr=opdes
	   .s operLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",10)
	   .s operLocDesc=""
	   .i operLocId'="" s operLoc=$p(^CTLOC(operLocId),"^",2)
	   .s operLocDesc=$p(operLoc,"-",2)
	s Note=operLocDesc_" "_patName_" "_age_" "_ward_"|"_bedCode_" "_opdes_" "_oproom_" "_medCareNo
	;w Note
	s Date=+$H
	s Time=$p($H,",",2)
	s Ctloc=%session.Data("LOGON.CTLOCID")
	s Group=%session.Data("LOGON.GROUPID")
	s User=%session.Data("LOGON.USERID")
	s Status="U"
	/*i stats="拒绝"  s MsgId="5"
	i stats="申请"  s MsgId="6"
	i stats="安排"  s MsgId="7"*/
	s MsgId="3"
	s IntervalTime=""
	s obj=##class(User.DHCANMessageDetail).%New()
	s obj.ANMDOpaDr=##class(User.DHCANOPArrange).%OpenId(opaId)
	s obj.ANMDMsgDr=##class(User.DHCANCMessage).%OpenId(MsgId)
	s obj.ANMDDate=Date
	s obj.ANMDTime=Time
	s obj.ANMDIntervalTime=IntervalTime
	s obj.ANMDCtloc=Ctloc
	s obj.ANMDGroupDr=Group
	s obj.ANMDUserDr=User
	s obj.ANMDNote=Note
	s obj.ANMDStatus=Status
	
	s saveStatus=obj.%Save()
	q:(+saveStatus=0) "-3^数据保存失败!"
	s ANMDRowId=obj.%Id()
	d obj.%Close()
	q ANMDRowId
}

/// 插入病人信息(呼叫护工)
ClassMethod InsertAnMessage1(EpisodeID, opaId, userId) As %String
{
    i EpisodeID="",opaId'="" s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	q:EpisodeID="" ""
	s operLocDesc="",patName="",age="",ward="",bedCode="",opdes="",oproom="",medCareNo="",MsgId="",Ctloc=""
    s medCareNo=..GetmedCareNo(opaId)
    s stats=..GetopaStatus(opaId)
	s anaesrw=""
	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	s bedCode="" i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	s ward="" i curWardId'="" s ward=$P($G(^PAWARD(curWardId)),"^",2)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s age=##Class(web.UDHCANOPArrange).CalAge(birth,+$h)
	s opstdate=+$h
	s day=$zd(opstdate,10)
	i day>4 s opstdate=opstdate+1
	i day=5 s opstdate=opstdate+1
	s opdate=$ZD(opstdate+1,4)_"          "
	s locListCodeStr=##class(web.DHCCLCom).AdjustLocListCode("OP^OUTOP^EMOP",EpisodeID)	
	s age=##Class(web.UDHCANOPArrange).CalAge(birth,opstdate)
	s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	i oproomdr'="" s oproom=$P($G(^DHCANC("OPRoom",oproomdr)),"^",2)
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$P(anaId,"||",2)	
	s anaesrw=EpisodeID_"||"_anaSub
	s i=0
	s subchl=0 
	f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")!(i=1)  d
       .s i=i+1
	   .s opdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",6)
	   .i opdr'="" d
	   ..i $D(^ORC("OPER",opdr)) d
	   ...s opdes=$P(^ORC("OPER",opdr),"^",2)
       ...s OPStatName=$P(^ORC("OPER",opdr),"^",35) 						
	   .e  d
       ..i $g(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",2))'="" d
       ...s opdes=$G(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",2))
       ...s opdr=opdes
	   .s operLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",10)
	   .s operLocDesc=""
	   .i operLocId'="" s operLocDesc=$p(^CTLOC(operLocId),"^",2)
	s Note=operLocDesc_" "_patName_" "_age_" "_ward_"|"_bedCode_" "_opdes_" "_oproom_" "_medCareNo
	;w Note
	s Date=+$H
	s Time=$p($H,",",2)
	s Ctloc=%session.Data("LOGON.CTLOCID")
	s Group=%session.Data("LOGON.GROUPID")
	s User=%session.Data("LOGON.USERID")
	s Status="U"
	/*i stats="拒绝"  s MsgId="5"
	i stats="申请"  s MsgId="6"
	i stats="安排"  s MsgId="7"*/
	s MsgId="4"
	s IntervalTime=""
	s obj=##class(User.DHCANMessageDetail).%New()
	s obj.ANMDOpaDr=##class(User.DHCANOPArrange).%OpenId(opaId)
	s obj.ANMDMsgDr=##class(User.DHCANCMessage).%OpenId(MsgId)
	s obj.ANMDDate=Date
	s obj.ANMDTime=Time
	s obj.ANMDIntervalTime=IntervalTime
	s obj.ANMDCtloc=Ctloc
	s obj.ANMDGroupDr=Group
	s obj.ANMDUserDr=User
	s obj.ANMDNote=Note
	s obj.ANMDStatus=Status
	
	s saveStatus=obj.%Save()
	q:(+saveStatus=0) "-3^数据保存失败!"
	s ANMDRowId=obj.%Id()
	d obj.%Close()
	q ANMDRowId
}

/// 取病人的OpaDr(病房准备状态)
/// w ##class(web.DHCANOPMessage).GetOpadr("169")
ClassMethod GetOpadr(opaId)
{
	s ret=""
	s ANMDOpaDr=""
	s ANMDRowId="" f  s ANMDRowId=$o(^DHCANMessage(0,"Message",3,ANMDRowId),-1) q:ANMDRowId=""  d
	.q:ANMDRowId=0
	.s ANMDOpaDr=$li(^DHCANMessage(ANMDRowId),1)
	.q:ANMDOpaDr'=opaId
	.s ret=ANMDOpaDr
	q ret
}

/// 取病人的OpaDr(准备完成状态)
ClassMethod GetOpadr1(opaId)
{
	s ret=""
	s ANMDOpaDr=""
	s ANMDRowId="" f  s ANMDRowId=$o(^DHCANMessage(0,"Message",4,ANMDRowId),-1) q:ANMDRowId=""  d
	.q:ANMDRowId=0
	.s ANMDOpaDr=$li(^DHCANMessage(ANMDRowId),1)
	.q:ANMDOpaDr'=opaId
	.s ret=ANMDOpaDr
	q ret
}

/// 更新病人信息指针(准备完成->呼叫护工)
/// d ##class(web.DHCANOPMessage).UpdateAnMessage("147")
ClassMethod UpdateAnMessage(opaId) As %String
{
	
    &SQL(Update SQLUser.DHC_AN_MessageDetail Set ANMD_Msg_Dr="4" where ANMD_Opa_Dr=:opaId)
    q opaId
}

/// 更新病人信息指针(病房准备->准备完成)
ClassMethod Update1AnMessage(opaId) As %String
{
	
    &SQL(Update SQLUser.DHC_AN_MessageDetail Set ANMD_Msg_Dr="5" where ANMD_Opa_Dr=:opaId)
    q opaId
}

/// 获取用户需要所有显示的消息
/// w ##class(web.DHCANOPMessage).GetMessageTabs("3819","311","134")
ClassMethod GetMessageTabs(userId, ctlocId, groupId) As %String
{
	q:userId="" "-1"
	q:ctlocId="" "-2"
	q:groupId="" "-3"
	s retStr=""
	s MsgRowId=0 f  s MsgRowId=$o(^DHCANC("Message",MsgRowId)) q:MsgRowId=""  d
	.s MsgCode=$li(^DHCANC("Message",MsgRowId),1)
	.s MsgDesc=$li(^DHCANC("Message",MsgRowId),2)
	.s MsgRecGroup=$li(^DHCANC("Message",MsgRowId),3)
	.s MsgRecCtloc=$li(^DHCANC("Message",MsgRowId),4)
	.s MsgRecUser=$li(^DHCANC("Message",MsgRowId),5)
	.s MsgMaxinum=$li(^DHCANC("Message",MsgRowId),6)
	.s MsgIfUse=$li(^DHCANC("Message",MsgRowId),7)
	.s MsgRecType=$li(^DHCANC("Message",MsgRowId),8)
	.q:MsgIfUse'="Y"
	.q:(MsgRecType="C")&((","_MsgRecCtloc_",")'[(","_ctlocId_","))
	.q:(MsgRecType="G")&((","_MsgRecGroup_",")'[(","_groupId_","))
	.q:(MsgRecType="U")&((","_MsgRecUser_",")'[(","_userId_","))
	.i retStr="" s retStr=MsgRowId_"^"_MsgCode_"^"_MsgDesc
	.e  s retStr=retStr_$c(3)_MsgRowId_"^"_MsgCode_"^"_MsgDesc
	q retStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPMessage","FindMessage")
Query FindMessage() As %Query(ROWSPEC = "MsgRowId,MsgCode,MsgDesc,MsgRecCtloc,MsgRecGroup,MsgRecUser,MsgMaxinum,MsgIfUse,MsgRecType,MsgRecCtlocDesc,MsgRecGroupDesc,MsgRecUserDesc")
{
}

ClassMethod FindMessageExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s MsgRowId=0 f  s MsgRowId=$o(^DHCANC("Message",MsgRowId)) q:MsgRowId=""  d
	.s MsgCode=$li(^DHCANC("Message",MsgRowId),1)
	.s MsgDesc=$li(^DHCANC("Message",MsgRowId),2)
	.s MsgRecGroup=$li(^DHCANC("Message",MsgRowId),3)
	.s MsgRecCtloc=$li(^DHCANC("Message",MsgRowId),4)
	.s MsgRecUser=$li(^DHCANC("Message",MsgRowId),5)
	.s MsgMaxinum=$li(^DHCANC("Message",MsgRowId),6)
	.s MsgIfUse=$li(^DHCANC("Message",MsgRowId),7)
	.s MsgRecType=$li(^DHCANC("Message",MsgRowId),8)
	.s MsgRecCtlocDesc="",MsgRecGroupDesc="",MsgRecUserDesc=""
	.i MsgRecCtloc'="" d
	..f i=1:1:$l(MsgRecCtloc,",") d
	...i MsgRecCtlocDesc="" s MsgRecCtlocDesc=$p($g(^CTLOC($p(MsgRecCtloc,",",i))),"^",2)
	...e  s MsgRecCtlocDesc=MsgRecCtlocDesc_","_$p($g(^CTLOC($p(MsgRecCtloc,",",i))),"^",2)
	.i MsgRecGroup'="" d
	..f i=1:1:$l(MsgRecGroup,",") d
	...i MsgRecGroupDesc="" s MsgRecGroupDesc=$p($g(^SSU("SSGRP",$p(MsgRecGroup,",",i))),"^",1)
	...e  s MsgRecGroupDesc=MsgRecGroupDesc_","_$p($g(^SSU("SSGRP",$p(MsgRecGroup,",",i))),"^",1)
	.i MsgRecUser'="" d
	..f i=1:1:$l(MsgRecUser,",") d
	...i MsgRecUserDesc="" s MsgRecUserDesc=$p($g(^CTPCP($p(MsgRecUser,",",i),1)),"^",2)
	...e  s MsgRecUserDesc=MsgRecUserDesc_","_$p($g(^CTPCP($p(MsgRecUser,",",i),1)),"^",2)

	.d OutputMessage
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputMessage
 set Data=$lb(MsgRowId,MsgCode,MsgDesc,MsgRecCtloc,MsgRecGroup,MsgRecUser,MsgMaxinum,MsgIfUse,MsgRecType,MsgRecCtlocDesc,MsgRecGroupDesc,MsgRecUserDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMessageExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMessageExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod InsertMessage(Para As %String) As %String
{
	q:Para="" "-1"
	s MsgCode=$p(Para,"^",1)
	s MsgDesc=$p(Para,"^",2)
	s MsgRecCtloc=$p(Para,"^",3)
	s MsgRecGroup=$p(Para,"^",4)
	s MsgRecUser=$p(Para,"^",5)
	s MsgMaxinum=$p(Para,"^",6)
	s MsgIfUse=$p(Para,"^",7)
	s MsgRecType=$p(Para,"^",8)
	q:MsgCode="" "-2"
	q:MsgDesc="" "-3"
	q:(MsgRecCtloc="")&(MsgRecGroup="")&(MsgRecUser="") "-4"
	i MsgMaxinum="" s MsgMaxinum=5
	i MsgRecType="" s MsgRecType="G"
	
	s obj=##class(User.DHCANCMessage).%New()
	s obj.ANMSGCode=MsgCode
	s obj.ANMSGDesc=MsgDesc
	s obj.ANMSGReceiveCtloc=MsgRecCtloc
	s obj.ANMSGReceiveGroup=MsgRecGroup
	s obj.ANMSGReceiveUser=MsgRecUser
	s obj.ANMSGMaxinum=MsgMaxinum
	s obj.ANMSGIfUse=MsgIfUse
	s obj.ANMSGReceiveType=MsgRecType
	
	s saveStatus=obj.%Save()
	q:(+saveStatus=0) "-5^数据保存失败!"_code
	s MsgRowId=obj.%Id()
	d obj.%Close()
	q MsgRowId
}

ClassMethod UpdateMessage(MsgRowId, Para) As %String
{
	q:MsgRowId="" "-1"
	q:Para="" "-2"
	s MsgCode=$p(Para,"^",1)
	s MsgDesc=$p(Para,"^",2)
	s MsgRecCtloc=$p(Para,"^",3)
	s MsgRecGroup=$p(Para,"^",4)
	s MsgRecUser=$p(Para,"^",5)
	s MsgMaxinum=$p(Para,"^",6)
	s MsgIfUse=$p(Para,"^",7)
	s MsgRecType=$p(Para,"^",8)
	q:MsgCode="" "-3"
	q:MsgDesc="" "-4"
	q:(MsgRecCtloc="")&(MsgRecGroup="")&(MsgRecUser="") "-5"
	i MsgMaxinum="" s MsgMaxinum=5
	i MsgRecType="" s MsgRecType="G"
	
	s obj=##class(User.DHCANCMessage).%OpenId(MsgRowId)
	s obj.ANMSGCode=MsgCode
	s obj.ANMSGDesc=MsgDesc
	s obj.ANMSGReceiveCtloc=MsgRecCtloc
	s obj.ANMSGReceiveGroup=MsgRecGroup
	s obj.ANMSGReceiveUser=MsgRecUser
	s obj.ANMSGMaxinum=MsgMaxinum
	s obj.ANMSGIfUse=MsgIfUse
	s obj.ANMSGReceiveType=MsgRecType
	
	s saveStatus=obj.%Save()
	q:(+saveStatus=0) "-6^数据保存失败!"_code
	s MsgRowId=obj.%Id()
	d obj.%Close()
	q MsgRowId
}

ClassMethod DeleteMessage(MsgRowId) As %String
{
	q:MsgRowId="" "-1"
	&sql(delete from sqluser.DHC_ANC_Message where ANMSG_RowId=:MsgRowId)
	q SQLCODE
}

Query FindGroup() As %Query(ROWSPEC = "groupId,groupDesc")
{
}

ClassMethod FindGroupExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s groupId="" f  s groupId=$o(^SSU("SSGRP",groupId)) q:groupId=""  d
	.s groupDesc=$p(^SSU("SSGRP",groupId),"^",1)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(groupId,groupDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGroupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
