Import SQLUser

/// Created by jdl 2007-5
Class web.DHCPE.SendMessage Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// 体检系统内，调用消息平台方法发送体检消息

// w ##class(web.DHCPE.Message).SendMessage("1160","体检消息测试","1160","","","923","304")

ClassMethod SendMessage(ActionTypeCode, Context, MessageOrgCode, EpisodeId, OrdItemId, FromUserRowId, CreateLoc)
{
	//ActionTypeCode:产品配置--消息平台管理--消息动作类型维护  菜单维护的 类型代码  1160：体检高危
	//MessageOrgCode:产品配置--消息平台管理--消息接收组织维护  菜单维护的 组织代码  1160：体检高危
	s OrgId=$O(^websys.DHCMessageOrgI("CodeIndex"," "_MessageOrgCode,0))
	q:OrgId="" "-1^消息组织机构未维护"
	s ToUserList=""
	s ret=##class(websys.DHCMessageOrgMgr).GetOrgUsers(OrgId,.ToUserList)
	
	s ToUserRowId=""
	s UserID=""
	f  s UserID=$O(ToUserList(UserID)) q:UserID=""  d
	.i ToUserRowId="" d
	..s ToUserRowId=UserID
	.e  d
	..s ToUserRowId=ToUserRowId_"^"_UserID
	
	q:ToUserRowId="" "-2^消息组织未维护人员"
	//Set rtn =##class(websys.DHCMessageInterface).Send(Context, ActionTypeCode, FromUserRowId, EpisodeId , OrdItemId , ToUserRowId , OtherInfoJson , ToLocRowId , EffectiveDays , CreateLoc)
	s rtn =##class(websys.DHCMessageInterface).Send(Context, ActionTypeCode, FromUserRowId, EpisodeId , OrdItemId , ToUserRowId , "" , CreateLoc , "" , CreateLoc)
	q rtn
}

ClassMethod InsertMessage(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "", message As %Library.String = "")
{
	
	s type= $P(InString,"^",1) // "SM"
	s receiveid = $P(InString,"^",2)
	s mobile = $P(InString,"^",3)
	s receivename = $P(InString,"^",4)
	s remark = $P(InString,"^",5)
	s receivetype = $P(InString,"^",6)
	s user = $P(InString,"^",7)
	s status = $P(InString,"^",8)

	s message= $G(message)
	
	new curdate,curtime
	s curdate=+$h
	s curtime=$p($h,",",2)
	
	&SQL(Insert into DHC_PE_SendMessage(SM_Message,SM_Type,SM_SendUser_DR,SM_SendDate,SM_SendTime,SM_ReceiveType,SM_ReceiveID,SM_Status,SM_ReceiveName,SM_Mobile,SM_Remark)
		values(:message,:type,:user,:curdate,:curtime,:receivetype,:receiveid,:status,:receivename,:mobile,:remark)
	)
	Q:(SQLCODE) SQLCODE_"^"
	q "0^"_%ROWID
}

/// w ##class(web.DHCPE.SendMessage).GetSendMessage()
ClassMethod GetSendMessage(rowid)
{
	new messagedata
	if rowid="" q ""
	s messagedata=$g(^DHCPESM(rowid))
	i ($p(InvData,"^",4)'="")  s $p(InvData,"^",4)= $zd($p(InvData,"^",4),3)
	i ($p(InvData,"^",5)'="")  s $p(InvData,"^",4)= $zdt($p(InvData,"^",5),3)
	i ($p(InvData,"^",8)="S")  s $p(InvData,"^",8)="成功"
	i ($p(InvData,"^",3)'="")  s $p(InvData,"^",3)=$p($g(^SSU("SSUSR",$p(InvData,"^",3))),"^",2)
	q InvData
}

/// w ##class(%Querty).FindSendMessageList("I",25,"","")
/// d ##class(%ResultSet).RunQuery("web.DHCPE.SendMessage","FindSendMessageList","I",25,"","")
Query FindSendMessageList(ReceiveType As %Library.String = "", ReceiveID As %Library.String = "", BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Query(ROWSPEC = "TRowId:%String,TMessage:%String,TType:%String,TSendUser:%String,TSendDate:%String,TSendTime:%String,TReceiveType:%String,TReceiveID:%String,TStatus:%String,TReceiveName:%String,TMobile:%String,TRemark:%String")
{
}

/// w ##class(web.DHCPE.SendMessage).FindSendMessageList(4149)
ClassMethod FindSendMessageListExecute(ByRef qHandle As %Binary, ReceiveType As %Library.String = "", ReceiveID As %Library.String = "", BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Status
{
	
	new TRowId,TMessage,TType,TSendUser,TSendDate,TSendTime,TReceiveType,TReceiveID,TStatus,TReceiveName,TMobile,TRemark
	new hasdata

	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	
 	/*
 	d ClearSendMessage
 	d OutSendMessage
 	s TMessage=ReceiveType_"^"_ReceiveID
 	s ^xwmTemp("FindSendMessageList","Param")=ReceiveType_"^"_ReceiveID_"^"_BeginDate_"^"_EndDate
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 	*/
 	i ((ReceiveType'="")&&(ReceiveID'=""))  d
 	.s TRowId=""
 	.f  s TRowId=$o(^DHCPESM(0,"ReceiveType",ReceiveType,"ReceiveID",ReceiveID,TRowId))  q:(TRowId="")  d
 	..d ClearSendMessage
 	..s hasdata=0
 	..d GetSendMessage
 	..q:hasdata'=1
 	..d OutSendMessage
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetSendMessage
	s InvData=$g(^DHCPESM(TRowId))
	s TMessage=$p(InvData,"^",1)
 	s TType=$p(InvData,"^",2)
 	s TSendUser=$p(InvData,"^",3)
 	s TSendDate=$p(InvData,"^",4)
 	s TSendTime=$p(InvData,"^",5)
 	s TReceiveType=$p(InvData,"^",6)
 	s TReceiveID=$p(InvData,"^",7)
 	s TStatus=$p(InvData,"^",8)
 	s TReceiveName=$p(InvData,"^",9)
 	s TMobile=$p(InvData,"^",10)
 	s TRemark=$p(InvData,"^",11)
 	
 	i (TSendDate'="")  s TSendDate= ##class(websys.Conversions).DateLogicalToHtml(TSendDate)
	i (TSendTime'="")  s TSendTime= $zt(TSendTime,1)
	b //
	s:(TStatus["F")||(TStatus["Failed") TStatus="失败"
	s:(TStatus["S")||(TStatus["Success") TStatus="成功"
	b //
	i (TSendUser'="")  s TSendUser=$p($g(^SSU("SSUSR",TSendUser)),"^",2)
 	
	s hasdata=1	
	q
ClearSendMessage
	s hasdata=0
	s (TMessage,TType,TSendUser,TSendDate,TSendTime,TReceiveType,TReceiveID,TStatus,TReceiveName,TMobile,TRemark)=""
	q
OutSendMessage
	set Data=$lb(TRowId,TMessage,TType,TSendUser,TSendDate,TSendTime,TReceiveType,TReceiveID,TStatus,TReceiveName,TMobile,TRemark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSendMessageListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSendMessageListExecute ]
{

	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindSendMessageListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSendMessageListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(web.DHCPE.SendMessage).GetSMSMessage()
ClassMethod GetSMSMessage(ReceiveId As %String = "", ReceiveType As %String = "", SMSType As %String = "")
{
	s retData=""
	Q:(""=$G(ReceiveId)) ""
	i "I"=ReceiveType d
	.// DHC_PE_IADM.{ IADM_CRMADM }
	.s IADMDR=$P($G(^DHCPEIADM(ReceiveId)), "^", 4) 
	.Q:(""=IADMDR)
	.// DHC_PE_PreIADM.{ PIADM_PIBI_DR } = DHC_PE_PreIBaseInfo.{  }
	.s PIBIDR=$P($G(^DHCPEPreIADM(IADMDR)),"^",1)
	.Q:(""=PIBIDR)	
	.s CurData=$G(^DHCPEPreIBI(PIBIDR))
	.
	.// PIBI_Name	姓名
	.s Name=$p(CurData,"^",2)
	.
	.// PIBI_Sex_DR = CT_Sex.{}	性别
	.s SexDR=$p(CurData,"^",3)
	.s:(""'=SexDR) SexDRName=$p(^CT("SEX",SexDR),"^",2)
	.// // PIBI_MobilePhone 手机
	.s MobilePhone=$p(CurData,"^",8)
	.
	.s Message=""
	.i "ReportComplete"=SMSType  d
	..s Message="尊敬的"_Name
	..i (SexDRName["男") d
	...s Message=Message_"先生"
	..
	..i (SexDRName["女") d
	...s Message=Message_"女士"
	..
	..s Message=Message_"您的报告已完成请及时领取"_$C(13)_$C(10)
	..s Message=Message_$P($G(^DHCPESetting("DHCPE","ReportTitle")),"-",2)
	..s retData=MobilePhone_"^"_Name_"^"_Message
	
	i "G"=ReceiveType d
	.// DHC_PE_GADM.{ GADM_GBI_DR }
	.s GBIDR=$P($G(^DHCPEGADM(ReceiveId)), "^", 1) 
	.Q:(""=GBIDR)
	.// DHC_PE_GBaseInfo
	.s CurData=$G(^DHCPEGBI(GBIDR))
	.Q:(""=CurData)
	.// GBI_Desc
	.s GName=$p(CurData,"^",2)
	.
	.// GBI_Linkman1	姓名
	.s Name=$p(CurData,"^",6)
	.
	.// GBI_Tel1 手机
	.s MobilePhone=$p(CurData,"^",10)
	.
	.s Message=""
	.i "ReportComplete"=SMSType  d
	..s Message="尊敬的"_Name_"您好,"
	..
	..s Message=Message_GName_"的体检已完成,请及时领取团体报告和个人报告."_$C(13)_$C(10)
	..s Message=Message_$P($G(^DHCPESetting("DHCPE","ReportTitle")),"-",2)
	..s retData=MobilePhone_"^"_Name_"^"_Message
	Q retData
}

/// d ##class(web.DHCPE.SendMessage).InvSMSCLSID()
ClassMethod InvSMSCLSID() As %String
{
	//w "<OBJECT ID='GSM' CLASSID='CLSID:EFF0F9F7-B10A-4A18-9737-0D0FD743D926' CODEBASE='../addins/client/DHCPEGSM.CAB#version=1,1,0,15'>"
	//w "<OBJECT ID='GSM' CLASSID='CLSID:0822FD81-9E94-4847-A3AB-AA5E68CA7FE8' CODEBASE='../addins/client/DHCPEGSM.CAB#version=1,2,0,82'>"
	//w "</object>",!
	
	w "<object ID='GSM' WIDTH=0 HEIGHT=0 CLASSID='CLSID:5BBDF9C6-47DF-4E81-A057-92DFA26DECC6' CODEBASE='../addins/client/DHCPEGSM.CAB#version=1,2,0,88' VIEWASTEXT>"
	w "</object>",!
}

ClassMethod SaveMessage(Type, ExpStr)
{
	;w ##class(web.DHCPE.Message.Main).SaveSendMessage("0000000001^18610513055^^Report^62761^1^396^")
	;InfoStr  RegNo^Telephone^Content^Type^ExpectSendDate^UserID^SourceID^SendMessageID
	;ExpStr Name^性别
	s UserID=%session.Get("LOGON.USERID")
	s SendMessageID=##class(web.DHCPE.Message.Main).GetSmsID(Type)
	if Type="RP" d
	.s ID=$P(ExpStr,"^",1)
	.s RegNo=$P(ExpStr,"^",2)
	.s Tel=$P(ExpStr,"^",3)
	.;s InfoStr=RegNo_"^"_Tel
	.s ContentExpStr=RegNo
	.s ContentType="Report"
	.s Content=$P(ExpStr,"^",4) //##class(web.DHCPE.Message.Main).GetContent(ContentType,ContentExpStr)
	.s InfoStr=RegNo_"^"_Tel_"^"_Content_"^"_Type_"^"_+$H_"^"_UserID_"^"_ID_"^"_SendMessageID
	.;s ret=##class(web.DHCPE.Message.Main).SaveSendMessage(InfoStr)
	if (Type="RR")||(Type="HR")||(Type="RC")||(Type="THR")||(Type="TRC") d
	.s ID=$P(ExpStr,"^",1)
	.s RegNo=$P(ExpStr,"^",2)
	.s Tel=$P(ExpStr,"^",3)
	.s Content=$P(ExpStr,"^",4)
	.s InfoStr=RegNo_"^"_Tel_"^"_Content_"^"_Type_"^"_+$H_"^"_UserID_"^"_ID_"^"_SendMessageID
	if (Type="FS") d
	.s ID=$P(ExpStr,"^",1)
	.s RegNo=$P(ExpStr,"^",2)
	.s Tel=$P(ExpStr,"^",3)
	.s Content=$P(ExpStr,"^",4)
	.s InfoStr=RegNo_"^"_Tel_"^"_Content_"^"_Type_"^"_+$H_"^"_UserID_"^"_ID_"^"_SendMessageID
	if (Type="PAADM")  d
	.s ID=$P(ExpStr,"^",1)
	.s RegNo=$P(ExpStr,"^",2)
	.s Tel=$P(ExpStr,"^",3)
	.;s InfoStr=RegNo_"^"_Tel
	.;s Type="PAADM"
	.s ContentExpStr=RegNo
	.s ContentType="Report"
	.s Content=$P(ExpStr,"^",4)
	.s InfoStr=RegNo_"^"_Tel_"^"_Content_"^"_Type_"^"_+$H_"^"_UserID_"^"_ID_"^"_SendMessageID
	.
	.
	//s ^sxt("xx")=InfoStr
	s ret=##class(web.DHCPE.Message.Main).SaveSendMessage(InfoStr)
	q ret
}

Query FindMessage(StartDate As %Library.String = "", EndDate As %Library.String = "", Type As %Library.String = "", NoSend As %Library.String = "", AutoSend As %Library.String = "", RegNo As %Library.String = "", Name As %Library.String = "", LocID As %Library.String = "") As %Query(ROWSPEC = "TID:%String,TRegNo:%String,TName:%String,TBirth:%String,TSex:%String,THadSend:%String,TTel:%String,TContent:%String,TSend:%String,TType:%String,TSendDate:%String,TSendStatus:%String")
{
}

/// Debug: d ##class(%ResultSet).RunQuery("web.DHCPE.SendMessage","FindMessage","2022-01-17","","","0","","","","105")
ClassMethod FindMessageExecute(ByRef qHandle As %Binary, StartDate As %Library.String = "", EndDate As %Library.String = "", Type As %Library.String = "", NoSend As %Library.String = "", AutoSend As %Library.String = "", RegNo As %Library.String = "", Name As %Library.String = "", LocID As %Library.String = "") As %Status
{
	s ^tempdhcpe("FindMessage")=$lb(StartDate,EndDate,Type,NoSend, AutoSend,RegNo, Name , LocID)
	new TRowId,TMessage,TType,TSendUser,TSendDate,TSendTime,TReceiveType,TReceiveID,TStatus,TReceiveName,TMobile,TRemark,CurSendStatus
	new hasdata

	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
 	s Type=$ZCVT(Type,"U")
 	
 	i StartDate'=""  s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate) 
 	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
 	
 	i StartDate="" s StartDate=+$H
 	i EndDate="" s EndDate=+$H
 	i NoSend="" s NoSend=0
 	i RegNo'="" d
 	.s RegNo=$ZCVT(RegNo,"U")
 	.s ID=""
 	.f  s ID=$O(^User.DHCPENewSendMessageI("NSMRegNoIndex",RegNo,ID)) q:ID=""  d
 	..d GetOneInfo
 	e  i Name'=""  d
 	.s Name=$ZCVT(Name,"U")
 	.s PatNameIndex=$O(^DHCPEPreIBI(0,"Name",Name),-1)
	.f  s PatNameIndex=$O(^DHCPEPreIBI(0,"Name",PatNameIndex)) q:(PatNameIndex="")||(PatNameIndex'[Name)  d
	..Set PIBIRowIdIndex=0
	..For  Set PIBIRowIdIndex=$O(^DHCPEPreIBI(0,"Name",PatNameIndex,PIBIRowIdIndex)) Quit:(PIBIRowIdIndex="")  Do
	...Set PAPMINoIndex=$p(^DHCPEPreIBI(PIBIRowIdIndex),"^",1)
	...s ID=""
	...f  s ID=$O(^User.DHCPENewSendMessageI("NSMRegNoIndex",PAPMINoIndex,ID)) q:ID=""  d
 	....d GetOneInfo
 	e  d
 	.s Date=StartDate-1
 	.f  s Date=$O(^User.DHCPENewSendMessageI("DateTypeIndex",Date)) q:Date=""  d
 	..s CurType=""
 	..f  s CurType=$O(^User.DHCPENewSendMessageI("DateTypeIndex",Date,CurType)) q:CurType=""  d
 	...q:(CurType="THR")||(CurType="TRC")
 	...q:(Type'="")&&(Type'=CurType)
 	...s SendStatus=""
 	...f  s SendStatus=$O(^User.DHCPENewSendMessageI("DateTypeIndex",Date,CurType,SendStatus)) q:SendStatus=""  d
 	....q:(NoSend'=1)&&(SendStatus'=NoSend)
 	....q:(NoSend=1)&&(SendStatus=0)
 	....s ID=""
 	....f  s ID=$O(^User.DHCPENewSendMessageI("DateTypeIndex",Date,CurType,SendStatus,ID)) q:ID=""  d
 	.....d GetOneInfo
 	
 	q $$$OK
GetOneInfo
 	s obj=##class(User.DHCPENewSendMessage).%OpenId(ID)
 	d ClearSendMessage2
 	q:(LocID'="")&&(obj.NSMLocDR'="")&&(obj.NSMLocDR'=LocID)
 	s CCurType=obj.NSMType
 	q:(CCurType="THR")||(CCurType="TRC")
 	q:(Type'="")&&(Type'=CCurType)
 	s TType=##class(web.DHCPE.Message.Main).GetTypeDesc(CCurType)
 	s CurSendStatus=obj.NSMStatus
 	q:(NoSend'=1)&&(CurSendStatus'=NoSend)
 	q:(NoSend=1)&&(CurSendStatus=0)
 	s CurSendStatus=##class(web.DHCPE.Message.Main).GetStatusDesc(CurSendStatus)
 	//s:NoSend=0 TSend=1
 	//s:NoSend'=0 TSend=0
 	s:NoSend=0 TSend=0
 	s:NoSend'=0 TSend=1
 	s TID=ID
 	s TRegNo=obj.NSMRegNo
 	//s TName=obj.NSMName_"%%"_CurSendStatus
 	s TName=obj.NSMName
 	s TBirth=""
 	s TBirth=""
 	i TRegNo'="" d
 	.s PIBIId=$o(^DHCPEPreIBI(0,"PAPMINo",TRegNo,0))
 	i PIBIId'="" s TBirth=$p($g(^DHCPEPreIBI(PIBIId)),"^",4)
 	i TBirth'="" s TBirth=##class(websys.Conversions).DateLogicalToHtml(TBirth)

 	s TSex=obj.NSMSex
 	s THadSend=NoSend
 	s TTel=obj.NSMMobile
 	s TContent=obj.NSMContent
 	s TType=obj.NSMType
 	s TSendDate=obj.NSMSendDate
 	s:TSendDate'="" TSendDate=##class(websys.Conversions).DateLogicalToHtml(TSendDate)
 	s TSendTime=obj.NSMSendTime
 	s:TSendTime'="" TSendTime=##class(websys.Conversions).TimeLogicalToHtml(TSendTime)
 	s TSendDate=TSendDate_" "_TSendTime
 	s TType=##class(web.DHCPE.Message.Main).GetTypeDesc(TType)
 	d OutSendMessage2
	q
ClearSendMessage2
	s (TID,TRegNo,TName,TBirth,TSex,THadSend,TTel,TContent,TSend,TType,TSendDate,CurSendStatus)=""
	q
OutSendMessage2
	set Data=$lb(TID,TRegNo,TName,TBirth,TSex,THadSend,TTel,TContent,TSend,TType,TSendDate,CurSendStatus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMessageExecute ]
{

	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMessageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query QuerySendMessage(PAADM As %Library.String = "") As %Query(ROWSPEC = "TType:%String, TSendStatus:%String, TTel:%String,TContent:%String")
{
}

ClassMethod QuerySendMessageExecute(ByRef qHandle As %Binary, PAADM As %Library.String = "") As %Status
{
	s ind=1
	set repid=$I(^CacheTemp)
	q:PAADM="" $$$OK
	s Type=""
	f  s Type=$O(^User.DHCPENewSendMessageI("TypeSourceIndex",Type)) q:Type=""  d
	.i Type="RP" d ;发送报告
	..s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	..q:IADM=""
	..s SourceID=$O(^DHCPERPT(0,"IADM",IADM,0))
	..q:SourceID=""
	..d GetInfoBySourceID
	.i Type="RR" d   ;高危结果DHCPERESULT
	..s SourceID=0
	..f  s SourceID=$O(^DHCPERLT(0,"ADM",PAADM,SourceID)) q:SourceID=""  d
	...d GetInfoBySourceID
	.i Type="HR" d ;高危结果
	..s SourceID=0
	..f  s SourceID=$O(^User.DHCPEHighRiskResultI("PAAdmIndex",PAADM,SourceID)) q:SourceID=""  d
	...d GetInfoBySourceID
	.i Type="FS" d
	..s SourceID=PAADM
	..d GetInfoBySourceID
 	set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetInfoBySourceID
	s MessageID=0
	f  s MessageID=$O(^User.DHCPENewSendMessageI("TypeSourceIndex",Type,SourceID,MessageID)) q:MessageID=""  d
	.d ClearInfo
	.s TType=##class(web.DHCPE.Message.Main).GetTypeDesc(Type)
	.s Status=$LG(^User.DHCPENewSendMessageD(MessageID),13)
	.s TSendStatus=##class(web.DHCPE.Message.Main).GetStatusDesc(Status)
	.s TTel=$LG(^User.DHCPENewSendMessageD(MessageID),7)
	.s TContent=$LG(^User.DHCPENewSendMessageD(MessageID),2)
	.d PutOut2
	q
ClearInfo
	s (TType, TSendStatus, TTel,TContent)=""
	q
PutOut2     
	set Data=$lb(TType, TSendStatus, TTel,TContent)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QuerySendMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySendMessageExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QuerySendMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySendMessageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 得到短信模板内容
/// w ##class(web.DHCPE.SendMessage).GetContent(PAADM,OEORIItemID)
ClassMethod GetContent(PAADM, OEORIItemID)
{
	q:OEORIItemID="" ""
	s BaseInfo=##class(web.DHCPE.AdmRecordManager).GetBaseInfo(PAADM)
	s Name=$P(BaseInfo,"^",1)
	s ItemObj=##class(User.OEOrdItem).%OpenId(OEORIItemID)
	s ItemDesc=ItemObj.OEORIItmMastDR.ARCIMDesc
	s ArcimID=ItemObj.OEORIItmMastDRGetObjectId()
	s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
	q:STID'="4" ""
	//s Content="尊敬的"_Name_"您好:您的"_ItemDesc_"体检结果有以下危急结果,[],请尽快就医或者联系协和医院健康医学部."
	s Content="[],请及时到妇科门诊就诊。协和体检中心 妇科"
	q Content
	s HighInfo=""
	s OrderDetailID=""
	f  s OrderDetailID=$O(^DHCPERLT(0,"ADMOD",PAADM,OEORIItemID,OrderDetailID)) q:OrderDetailID=""  d
	.s RLTID=0
	.s OneInfo=""
	.f  s RLTID=$O(^DHCPERLT(0,"ADMOD",PAADM,OEORIItemID,OrderDetailID,RLTID)) q:RLTID=""  d
	..s obj=##class(User.DHCPEResult).%OpenId(RLTID)
	..s HighRisk=obj.RLTHighRiskFlag
	..q:HighRisk'="Y"
	..s ItemDesc=obj.RLTODDR.ODDesc
	..s Result=obj.RLTResult
	..i OneInfo="" d
	...s OneInfo=ItemDesc_":"_Result
	..e  d
	...s OneInfo=OneInfo_","_Result
	.q:OneInfo=""
	.i HighInfo=""  d
	..s HighInfo=OneInfo
	.e  d
	..s HighInfo=HighInfo_";"_OneInfo
	s Content=Content_HighInfo
	s Content=Content_",请尽快就医或者联系本体检中心."
	q Content
}

Query FindAdviceByOrder(OrderItemID As %Library.String = "", PAADM As %Library.String = "") As %Query(ROWSPEC = "AdviceInfo:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.SendMessage", "FindAdviceByOrder","3696670||25")
ClassMethod FindAdviceByOrderExecute(ByRef qHandle As %Binary, OrderItemID As %Library.String = "", PAADM As %Library.String = "") As %Status
{
	
	new TRowId,TMessage,TType,TSendUser,TSendDate,TSendTime,TReceiveType,TReceiveID,TStatus,TReceiveName,TMobile,TRemark
	new hasdata
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	q:(OrderItemID="")&&(PAADM="") $$$OK
	i OrderItemID'=""
	{
		s PAADM=$P(^OEORD(+OrderItemID),"^",1)
		s ArcimID=$P(^OEORD(+OrderItemID,"I",$P(OrderItemID,"||",2),1),"^",2)
		s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
		q:STID="" $$$OK
		s SSID=##class(web.DHCPE.ResultEdit).GetSSId(PAADM, STID)
		q:SSID="" $$$OK
		s Sub=""
		f  s Sub=$O(^DHCPESS(SSID,"Diagnosis",Sub)) q:Sub=""  d
		.s SDID=SSID_"||"_Sub
		.s DisplayDesc=$G(^DHCPEDataEx("DHCPESSDiagnosis","DisplayDesc",SDID))
		.s Advice=$P(^DHCPESS(SSID,"Diagnosis",Sub),"^",7)
		.q:(DisplayDesc="")&&(Advice="")
		.s OneInfo=DisplayDesc_":"_Advice
		.d FindAdviceByOrder
	}
	else
	{
		s SSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
		q:SSID="" $$$OK
		s Sub=""
		f  s Sub=$O(^DHCPEGS(SSID,"Diagnosis",Sub)) q:Sub=""  d
		.s SDID=SSID_"||"_Sub
		.s Status=$P(^DHCPEGS(SSID,"Diagnosis",Sub),"^",11)
		.q:Status'="0"
		.s DisplayDesc=$G(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",SDID))
		.s Advice=$P(^DHCPEGS(SSID,"Diagnosis",Sub),"^",9)
		.q:(DisplayDesc="")&&(Advice="")
		.s OneInfo=DisplayDesc_":"_Advice
		.d FindAdviceByOrder
	}
	q $$$OK

FindAdviceByOrder
	set Data=$lb(OneInfo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAdviceByOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdviceByOrderExecute ]
{

	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAdviceByOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdviceByOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OutMessageStatusHTML(ContrlWidth As %String = "", DefaultValue As %String = "", tabIndex As %String = 0) As %String
{
	;d ##class(web.DHCPE.SendMessage).OutMessageStatusHTML()
	s:(""=ContrlWidth) ContrlWidth="155"
	;w "<select name='NoSend' id='NoSend' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex="_tabIndex_">",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("NoSend","")
	s selected=""
	s:DefaultValue="2" selected=" selected"
	w "<option value='2'"_selected_">发送成功</option>",!
	s selected=""
	s:DefaultValue="3" selected=" selected"
	w "<option value='3'"_selected_">发送失败</option>",!
	s selected=""
	s:DefaultValue="0" selected=" selected"
	w "<option value='0'"_selected_">待发送</option>",!
	w "</select>",!
	Quit $$$OK
	
	s selected="1"
	s:DefaultValue="1" selected=" selected"
	w "<option value='1'"_selected_">成功失败</option>",!
}

/*
q:Type="RP" "报告通知"
	q:Type="HR" "上报高危"  
	q:Type="RR" "高危结果"
	q:Type="RC" "高危建议"
	q:Type="FS" "自由发送"
	q:Type="PAADM" "复查提醒"
	q:Type="NetPre" "网上预约"
	q:Type="HisPre" "His预约"
	q:Type="VC" "验证码"
*/
ClassMethod OutTypeToHTML(ContrlWidth As %String = "", DefaultValue As %String = "", tabIndex As %String = 0) As %String
{
	;d ##class(web.DHCPE.SendMessage).OutMessageStatusHTML()
	s:(""=ContrlWidth) ContrlWidth="155"
	;w "<select name='Type' id='Type' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex="_tabIndex_">",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("Type","")
	s TypeCode=""
	s selected=""
	w "<option value='"_TypeCode_"'"_selected_">"_##class(web.DHCPE.Message.Main).GetTypeDesc(TypeCode)_"</option>",!
	
	s TypeCode="RP"
	s:DefaultValue=TypeCode selected=" selected"
	w "<option value='"_TypeCode_"'"_selected_">"_##class(web.DHCPE.Message.Main).GetTypeDesc(TypeCode)_"</option>",!
	s selected=""
	s TypeCode="HR"
	s:DefaultValue=TypeCode selected=" selected"
	w "<option value='"_TypeCode_"'"_selected_">"_##class(web.DHCPE.Message.Main).GetTypeDesc(TypeCode)_"</option>",!
	s selected=""
	s TypeCode="RR"
	s:DefaultValue=TypeCode selected=" selected"
	w "<option value='"_TypeCode_"'"_selected_">"_##class(web.DHCPE.Message.Main).GetTypeDesc(TypeCode)_"</option>",!
	s selected=""
	s TypeCode="RC"
	s:DefaultValue=TypeCode selected=" selected"
	w "<option value='"_TypeCode_"'"_selected_">"_##class(web.DHCPE.Message.Main).GetTypeDesc(TypeCode)_"</option>",!
	s selected=""
	s TypeCode="FS"
	s:DefaultValue=TypeCode selected=" selected"
	w "<option value='"_TypeCode_"'"_selected_">"_##class(web.DHCPE.Message.Main).GetTypeDesc(TypeCode)_"</option>",!
	s selected=""
	s TypeCode="PAADM"
	s:DefaultValue=TypeCode selected=" selected"
	w "<option value='"_TypeCode_"'"_selected_">"_##class(web.DHCPE.Message.Main).GetTypeDesc(TypeCode)_"</option>",!
	s selected=""
	s TypeCode="NetPre"
	s:DefaultValue=TypeCode selected=" selected"
	w "<option value='"_TypeCode_"'"_selected_">"_##class(web.DHCPE.Message.Main).GetTypeDesc(TypeCode)_"</option>",!
	s selected=""
	s TypeCode="HisPre"
	s:DefaultValue=TypeCode selected=" selected"
	w "<option value='"_TypeCode_"'"_selected_">"_##class(web.DHCPE.Message.Main).GetTypeDesc(TypeCode)_"</option>",!
	s selected=""
	s TypeCode="VC"
	s:DefaultValue=TypeCode selected=" selected"
	w "<option value='"_TypeCode_"'"_selected_">"_##class(web.DHCPE.Message.Main).GetTypeDesc(TypeCode)_"</option>",!
	w "</select>",!
	Quit $$$OK
}

}
