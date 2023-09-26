Import SQLUser

Class web.DHCMessage Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// w ##Class(web.DHCMessage).DHCRunClassMethod("##Class(web.DHCMessage).GetNewMessage")

ClassMethod DHCRunClassMethod(ActionName As %String, Param As %String = "") As %String
{
	q:ActionName="" ""
	s CommandStr="retStr="_ActionName_"("_Param_")"
	s @CommandStr
	//XECUTE CommandStr
	q retStr
}

/// w ##Class(web.DHCMessage).GetNewMessage()
ClassMethod GetNewMessage(Param As %String = "") As %String
{
	s retStr=""
	s userId=$P(Param,"^",1)
	s groupId=$P(Param,"^",2)
	s ctLocId=$P(Param,"^",3)
	s nowDate=+$H
	s dateEffective=""
	f  s dateEffective=$O(^DHCMESS("MESS",0,"DateEffective",dateEffective),-1) q:(dateEffective<nowDate)!(dateEffective="")  d
	.s categDr=""
	.f  s categDr=$O(^DHCMESS("MESS",0,"DateEffective",dateEffective,categDr)) q:categDr=""  d
	..s catCode=$P(^DHCMESS("MESSCAT",categDr),"^",1)
	..i (catCode="P")!(catCode="O") s objectId=userId
	..i (catCode="L") s objectId=ctLocId
	..i (catCode="G") s objectId=groupId
	..q:objectId=""
	..s catDesc=$P(^DHCMESS("MESSCAT",categDr),"^",2)
	..s flag=0
	..s messRowId=""
	..f  s messRowId=$O(^DHCMESS("MESS",0,"DateEffective",dateEffective,categDr,messRowId)) q:(messRowId="")!(flag=1)  d
	...s recRowId=""
	...f  s recRowId=$O(^DHCMESS("MESSREC",0,"MessageObject",messRowId,objectId,recRowId))  q:(recRowId="")!(flag=1)  d
	....s state=$P(^DHCMESS("MESSREC",recRowId),"^",6)
	....q:state="Y"
	....s flag=1
	....i retStr="" s retStr="有新消息:"_catDesc
	....e  s retStr=retStr_" "_catDesc
	
	s newNum=0
	i ctLocId'="" d
	.s wardId=$O(^PAWARD(0,"WARD_LocationDR",ctLocId,""))
	.i (wardId'="") d
	..s newNum=##Class(web.DHCMessage).GetNewOrdPatNum(wardId)
	s newNum=+newNum
	i newNum>0 s retStr=retStr_" 有需处理医嘱病人:"_newNum_"人"
#;	if (ctLocId'=""){
#;		s obj=##class(%Dictionary.QueryDefinition).%OpenId("web.DHCCVCommon||CVReportAlert",0)
#;		if $IsObject(obj){
#;			Set rs=##class(%ResultSet).%New("web.DHCCVCommon:CVReportAlert")
#;			set sc = rs.Execute(ctLocId)
#;			If rs.Next() set retStr = retStr_" 有需处理的危机值信息,请处理!"
#;			do rs.%Close()
#;			set rs=""
#;		}
#;		s obj=""
#;	}
#;	s ClientIP=""
#;	i $D(%session) s ClientIP=%session.Data("REMOTE_ADDR")
#;	i (ClientIP'="")&&(retStr'="") d
#;	.s retSendMessage=##class(web.DHCVISVoiceMessage).InsertVoiceMessage(retStr,ClientIP)
	q retStr
}

ClassMethod GetNewMessByCat(Param As %String = "") As %String
{
	s retStr=""
	s userId=$P(Param,"^",1)
	s groupId=$P(Param,"^",2)
	s ctLocId=$P(Param,"^",3)
	s categId=$P(Param,"^",4)
	s nowDate=+$H
	s dateEffective=""
	f  s dateEffective=$O(^DHCMESS("MESS",0,"DateEffective",dateEffective),-1) q:(dateEffective<nowDate)!(dateEffective="")  d
	.s catCode=$P(^DHCMESS("MESSCAT",categId),"^",1)
	.i (catCode="P")!(catCode="O") s objectId=userId
	.i (catCode="L") s objectId=ctLocId
	.i (catCode="G") s objectId=groupId
	.s catDesc=$P(^DHCMESS("MESSCAT",categId),"^",2)
	.s messRowId=""
	.f  s messRowId=$O(^DHCMESS("MESS",0,"DateEffective",dateEffective,categId,messRowId)) q:(messRowId="")  d
	..s recRowId=""
	..f  s recRowId=$O(^DHCMESS("MESSREC",0,"MessageObject",messRowId,objectId,recRowId))  q:recRowId=""  d
	...s state=$P(^DHCMESS("MESSREC",recRowId),"^",6)
	...//q:state="Y"
	...s content=$P(^DHCMESS("MESS",messRowId),"^",7)
	...s dateCreated=$P(^DHCMESS("MESS",messRowId),"^",1)
	...i dateCreated'="" s dateCreated=$ZD(dateCreated,3)
	...s timeCreated=$P(^DHCMESS("MESS",messRowId),"^",2)
	...i timeCreated'="" s timeCreated=$ZT(timeCreated)
	...s userCreated=$P(^DHCMESS("MESS",messRowId),"^",5)
	...i userCreated'="" s userCreated=$P($G(^SSU("SSUSR",userCreated)),"^",2)
	...s headDesc="创建时间:"_dateCreated_","_timeCreated_" 创建人:"_userCreated
	...b
	...s readRet=..ReadMessage(recRowId_"^"_userId)
	...q:readRet'=0
	...i retStr="" s retStr=headDesc_$C(1)_content
	...e   s retStr=retStr_$C(2)_headDesc_$C(1)_content
	q retStr
}

ClassMethod GetMessageCatTabs(Param As %String = "") As %String
{
	s retStr=""
	s rowId=""
	f  s rowId=$O(^DHCMESS("MESSCAT",rowId)) q:rowId=""  d
	.s active=$P(^DHCMESS("MESSCAT",rowId),"^",3)
	.q:active="N"
	.s code=$P(^DHCMESS("MESSCAT",rowId),"^",1)
	.s desc=$P(^DHCMESS("MESSCAT",rowId),"^",2)
	.i retStr="" s retStr=rowId_"^"_code_"^"_desc
	.e  s retStr=retStr_"!"_rowId_"^"_code_"^"_desc
	q retStr
}

ClassMethod ReadMessage(Param As %String = "") As %String
{
	s rowId=$P(Param,"^",1)
	s userId=$P(Param,"^",2)
	s readDate=+$H
	s readTime=$P($H,",",2)
	&SQL(Update SQLUser.DHC_MessageRecipient set MESSREC_DateRead=:readDate,MESSREC_TimeRead=:readTime,MESSREC_User_DR=:userId,MESSREC_State='Y' where MESSREC_RowId=:rowId)
	i SQLCODE'=0 TRollBack  q "读取消息失败!"
	q SQLCODE
}

ClassMethod SendMessage(Param As %String = "") As %String
{
	s dateCreated=+$H
	s timeCreated=$P($H,",",2)
	s userId=$P(Param,"^",1)
	s message=$P(Param,"^",2)
	//s message=$TR(message,$C(13,10),"<br/>")
	s message=$ZCVT(message,"I","HTML")
	s categId=$P(Param,"^",3)
	i $P(Param,"^",4)'="" s dateEffective=$ZDH($P(Param,"^",4),4)
	e  s dateEffective=dateCreated
	i $P(Param,"^",5)'="" s timeEffective=$ZTH($P(Param,"^",5))
	e  s timeEffective=timeCreated
	s objectIdStr=$P(Param,"^",6)
	s state="N"
	TSTART
	&SQL(Insert into SQLUser.DHC_Message (MESS_DateCreated,MESS_TimeCreated,MESS_DateEffective,MESS_TimeEffective,MESS_UserCreated_DR,MESS_Message,MESS_Categ_DR)
		values (:dateCreated,:timeCreated,:dateEffective,:timeEffective,:userId,:message,:categId))
	
	i SQLCODE'=0 TRollBack  q SQLCODE_"插入消息失败!"
	
	s messageDr=%ROWID
	
	i objectIdStr="A" d
	.s userId=""
	.f  s userId=$O(^SSU("SSUSR",userId)) q:userId=""  d
	..q:SQLCODE'=0
	..s active=$P($G(^SSU("SSUSR",userId)),"^",19)
	..q:active'="Y"
	..&SQL(Insert into SQLUser.DHC_MessageRecipient (MESSREC_Message_DR,MESSREC_Object,MESSREC_State)
		values (:messageDr,:userId,:state))
	e  d
	.s objectNum=$L(objectIdStr,"@")
	.f i=1:1:objectNum d
	..s objectId=$P(objectIdStr,"@",i)
	..q:SQLCODE'=0
	..&SQL(Insert into SQLUser.DHC_MessageRecipient (MESSREC_Message_DR,MESSREC_Object,MESSREC_State)
		values (:messageDr,:objectId,:state))
		
	i SQLCODE'=0 TRollBack  q "插入消息失败!"
	
	TCOMMIT
	q SQLCODE
}

ClassMethod GetUserByGroup(GroupId As %String = "") As %String
{
	q:+GroupId=0 0
	s UserId=""
	f  s UserId=$O(^SSU("SSUSR",0,"Group",GroupId,UserId)) q:UserId=""  d
	.s UserName=$$ALPHAUP^SSUTIL4($P($G(^SSU("SSUSR",UserId)),"^",2))
	.s UserStr=UserName_"^"_UserId
	.s retValue="AddUserToList('"_UserStr_"');"
	.d  &javascript<#(retValue)#>
	q 0
}

ClassMethod GetUserByLoction(LocId As %String = "") As %String
{
	q:+LocId=0 0
	s rbRowId="" f  s rbRowId=$O(^RB("RES",0,"CTLOC",LocId,rbRowId)) q:rbRowId=""  d
	.s ctcpDr=$P(^RB("RES",rbRowId),"^",2)
	.q:ctcpDr=""
	.s userId=$O(^SSU("SSUSR",0,"CTPCP",ctcpDr,""))
	.q:userId=""
	.s userName=$P($G(^SSU("SSUSR",userId)),"^",2)
	.s UserStr=userName_"^"_userId
	.s retValue="AddUserToList('"_UserStr_"');"
	.d  &javascript<#(retValue)#>
	q 0
}

ClassMethod UpdateMessSt(ID As %String) As %String
{
	s readDate=+$H
	s readTime=$P($H,",",2)
	&SQL(Update SQLUser.SS_MessageRecipient set MESSREC_DateRead=:readDate,MESSREC_TimeRead=:readTime where MESSREC_RowId=:ID )
}

Query Message(MessageID As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT MESS_Rowid, MESS_DateCreated, MESS_Message, MESS_TimeCreated, MESS_UserCreated_DR->SSUSR_Name
	FROM SQLUser.SS_Message
	WHERE  MESS_ROWID= :MessageID
}

Query FindMessCateg(PARREF As %String = "") As %SQLQuery
{
	SELECT MESSCAT_RowId, MESSCAT_Code, MESSCAT_Desc,MESSCAT_Note 
	FROM SQLUser.DHC_MessCateg
	WHERE MESSCAT_Active ='Y'
}

ClassMethod GetAllNewOrdPat(wardID As %String = "") As %String
{
	n (wardID)
	s retStr="",newSum=0,bedStr=""
	q:wardID="" retStr
	s inPatientNum=0
	s patRoomId=""
    f  s patRoomId=$o(^PAADMi("CurrWard",wardID,patRoomId)) q:patRoomId=""  d
    .s EpisodeId=0
    .f  s EpisodeId=$o(^PAADMi("CurrWard",wardID,patRoomId,EpisodeId)) q:EpisodeId=""  d
    ..s patVisit=$p($g(^PAADM(EpisodeId)),"^",20)
    ..q:patVisit'="A"
    ..s paPmiId=$p($g(^PAADM(EpisodeId)),"^",1)
    ..s regNo=$p($g(^PAPER(paPmiId,"PAT",1)),"^",1)
    ..s patName=$p($g(^PAPER(paPmiId,"ALL")),"^",1)
    ..s sex=$p($g(^CT("SEX",$p($g(^PAPER(paPmiId,"ALL")),"^",7))),"^",2)
    ..s bedSub=$p($p($g(^PAADM(EpisodeId)),"^",73),"||",2)
    ..s inPatientNum=inPatientNum+1
    ..q:bedSub=""
    ..s bedDr=wardID_"||"_bedSub
    ..s bedCode=$p($g(^PAWARD(wardID,"BED",bedSub)),"^",1)
    ..q:bedCode=""
    ..s locId=$p(^PAWARD(wardID),"^",5)
    ..s locId=$O(^CTLOC(locId,"LINK",0,"Loc",0))
    ..s flag=##class(web.DHCLCNUREXCUTE).GetIfSeeOrder(EpisodeId,wardID,locId)
    ..q:flag'=1
    ..s patStr="<table><tr><td>"_bedCode_patName_"有需处理医嘱</td></tr></table>"
    ..s patStr=patStr_"<DIV class='content'><a href='#' onClick=window.open('dhc.nurse.ip.csp?EpisodeID="_EpisodeId_"','_blank','top=0,left=0,width=1360,height=760,resizable=yes')>执行医嘱</a>"_"</DIV>"
    ..i retStr="" d
    ...s retStr=patStr
    ..e  s retStr=retStr_" "_patStr
    ..s newSum=newSum+1
	q retStr
}

ClassMethod GetNewOrdPatNum(wardID As %String = "") As %String
{
	n (wardID)
	s retStr="",newSum=0,bedStr=""
	q:wardID="" retStr
	s inPatientNum=0
	s patRoomId=""
    f  s patRoomId=$o(^PAADMi("CurrWard",wardID,patRoomId)) q:patRoomId=""  d
    .s EpisodeId=0
    .f  s EpisodeId=$o(^PAADMi("CurrWard",wardID,patRoomId,EpisodeId)) q:EpisodeId=""  d
    ..s patVisit=$p($g(^PAADM(EpisodeId)),"^",20)
    ..q:patVisit'="A"
    ..s paPmiId=$p($g(^PAADM(EpisodeId)),"^",1)
    ..s regNo=$p($g(^PAPER(paPmiId,"PAT",1)),"^",1)
    ..s patName=$p($g(^PAPER(paPmiId,"ALL")),"^",1)
    ..s sex=$p($g(^CT("SEX",$p($g(^PAPER(paPmiId,"ALL")),"^",7))),"^",2)
    ..s bedSub=$p($p($g(^PAADM(EpisodeId)),"^",73),"||",2)
    ..s inPatientNum=inPatientNum+1
    ..q:bedSub=""
    ..s bedDr=wardID_"||"_bedSub
    ..s bedCode=$p($g(^PAWARD(wardID,"BED",bedSub)),"^",1)
    ..q:bedCode=""
    ..s locId=$p(^PAWARD(wardID),"^",5)
    ..s locId=$O(^CTLOC(locId,"LINK",0,"Loc",0))
    ..q:locId=""
    ..s flag=##class(web.DHCLCNUREXCUTE).GetIfSeeOrder(EpisodeId,wardID,locId)
    ..q:flag'=1
    ..s newSum=newSum+1
	q newSum
}

/// /×××××消息类别维护×××××
Query LookUpMessCat() As %Query(ROWSPEC = "MessCatRowId:%String,MessCatDesc:%String,MessCatCode:%String,MessCatActive:%String,MessCatNote:%String")
{
}

ClassMethod LookUpMessCatExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
	s MessCatRowId=""
	f  s MessCatRowId=$O(^DHCMESS("MESSCAT",MessCatRowId)) q:MessCatRowId=""  d
	.s MessCatStr=$G(^DHCMESS("MESSCAT",MessCatRowId))
	.q:MessCatStr=""
	.s MessCatCode=$P(MessCatStr,"^",1)
	.s MessCatDesc=$P(MessCatStr,"^",2)
	.s MessCatActive=$P(MessCatStr,"^",3)
	.s MessCatNote=$P(MessCatStr,"^",4)
	.d OutMessCat
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutMessCat
	s Data=$lb(MessCatRowId,MessCatDesc,MessCatCode,MessCatActive,MessCatNote)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpMessCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpMessCatExecute ]
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

ClassMethod LookUpMessCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpMessCatExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod MessCatInsert(MessCatDesc As %String, MessCatCode As %String, MessCatActive As %String, MessCatNote As %String = "") As %String
{
	q:(MessCatDesc="")!(MessCatCode="")!(MessCatActive="") "信息不完整!"
	&SQL(insert into DHC_MessCateg (MESSCAT_Desc,MESSCAT_Code,MESSCAT_Active,MESSCAT_Note) values (:MessCatDesc,:MessCatCode,:MessCatActive,:MessCatNote))
	i SQLCODE'=0 q "插入失败!"
	q SQLCODE
}

ClassMethod MessCatUpdate(MessCatRowId As %String, MessCatDesc As %String, MessCatCode As %String, MessCatActive As %String, MessCatNote As %String = "") As %String
{
	q:(MessCatRowId="")!(MessCatDesc="")!(MessCatCode="")!(MessCatActive="") "信息不完整!"
	&SQL(update DHC_MessCateg set MESSCAT_Desc=:MessCatDesc,MESSCAT_Code=:MessCatCode,MESSCAT_Active=:MessCatActive,MESSCAT_Note=:MessCatNote where MESSCAT_RowId=:MessCatRowId)
	i SQLCODE'=0 q "更新失败!"
	q SQLCODE
}

ClassMethod MessCatDelete(MessCatId As %String) As %String
{
	q:(MessCatId="") "信息不完整!"
	&SQL(Delete from  DHC_MessCateg where MESSCAT_RowId=:MessCatId)
	i SQLCODE'=0 q "删除失败!"
	q SQLCODE
}

ClassMethod GetCriticalNewMess(CTLocId)
{
	;Set rs=##class(%ResultSet).%New("web.DHCCVCommon","CVReportAlert")
	Set %request.Data("locid",1)=CTLocId
	s frm=##Class(websys.Component).OpenName("DHCDocCriticalMess")
    i frm  {
		w "<TABLE><TR><TD>"
		d frm.Show()
		d frm.%Close()
		w "</TABLE>"
		}
	q 1
}

ClassMethod CreateCriticalView()
{
	w "<a href='#' onClick=""window.showModalDialog('criticalvalue.trans.csp?ReportId="_rs.Data("ReportId")_"&RepType="_rs.Data("ReportTypeId")_"','','dialogwidth:790px;dialogheight:460px;status:no;center:1;resizable:yes');"">查看</a>"
	q 0
}

}
