Class web.DHCPE.Message.Main Extends %Persistent
{

Parameter ServiceClassName;

Parameter SendServiceMethodName;

Parameter RecvServiceMethodName;

Parameter ReportServiceMethodName;

/// 插入短信发送记录表
ClassMethod SaveSendMessage(InfoStr As %String, ExpStr As %String = "") As %String
{
	;w ##class(web.DHCPE.Message.Main).SaveSendMessage("0000000001^18610513055^^Report^62761^1^396^")
	;InfoStr  RegNo^Telephone^Content^Type^ExpectSendDate^UserID^SourceID^SendMessageID
	;ExpStr Name^性别
	s obj=##class(User.DHCPENewSendMessage).%New()
	s obj.NSMRegNo=$P(InfoStr,"^",1)
	s ExpStr=""
	i obj.NSMRegNo'="" d
	.s PersonID=$O(^PAPERi("PAPMI_PatNo",obj.NSMRegNo,0))
	.q:PersonID=""
	.s Name=$P(^PAPER(PersonID,"ALL"),"^",1)
	.s Sex=$P(^PAPER(PersonID,"ALL"),"^",7)
	.i Sex'="" d
	..s Sex=$P(^CT("SEX",Sex),"^",2)
	..s ExpStr=Name_"^"_Sex
	s obj.NSMMobile=$P(InfoStr,"^",2)
	s obj.NSMContent=$P(InfoStr,"^",3)
	s obj.NSMContent=..GetContent(obj.NSMContent,ExpStr)
	s obj.NSMType=$P(InfoStr,"^",4)
	s LocID=""
	s:$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	s obj.NSMLocDR=LocID
	i obj.NSMType="RP"
	{
		;d ..SendMessageToLHH($P(InfoStr,"^",7))
	}
	s obj.NSMExpectSendDate=$P(InfoStr,"^",5)
	d obj.NSMCreateUserDRSetObjectId($P(InfoStr,"^",6))
	s obj.NSMSourceID=$P(InfoStr,"^",7)
	
	s SendMessageID=$P(InfoStr,"^",8)
	d obj.NSMRelateDRSetObjectId(SendMessageID)
	//s obj.NSMRelateDR=$P(InfoStr,"^",8)
	
	s obj.NSMStatus=0 ;待发送状态
	s obj.NSMCreateDate=+$H
	s obj.NSMCreateTime=$P($H,",",2)
	s obj.NSMName=$P(ExpStr,"^",1)
	s obj.NSMSex=$P(ExpStr,"^",2)
	s sc=obj.%Save()
	d obj.%Close()
	i $$$ISERR(sc) {
     	q "-1"
 	}
 	q 0
}

ClassMethod GetContent(Contenct, ExpStr)
{
	q:ExpStr="" Contenct
	i $L(Contenct,"[Name]")>1 d
	.s Name=$P(ExpStr,"^",1)
	.s Sex=$P(ExpStr,"^",2)
	.s SexExp=""
	.i Sex[("男") d
	..s SexExp="先生"
	.e  i Sex[("女") d
	..s SexExp="女士"
	.s Name=Name_SexExp
	.s Contenct=##class(web.DHCPE.Public.Setting).Replace(Contenct,"[Name]",Name)
	q Contenct
}

ClassMethod UpdateMessage(ID, Status, UserID)
{
	s Obj=##class(User.DHCPENewSendMessage).%OpenId(ID)
	s CurType=Obj.NSMType
	s Obj.NSMSmsID=..GetSmsID(CurType)
	s Obj.NSMBid=..GetBid(CurType)
	s Obj.NSMSendLevel=..GetSendLevel(CurType)
	s Content=Obj.NSMContent
	i Content="" d
	.s Content=..GetContent(CurType,"^"_ID)
	.s Obj.NSMContent=Content
	s Obj.NSMStatus=Status
	d Obj.NSMSendUserDRSetObjectId(UserID)
	s Obj.NSMSendDate=+$H
	s Obj.NSMSendTime=$P($H,",",2)
	s sc=Obj.%Save()
	d Obj.%Close()
	i $$$ISERR(sc) {
     	q "-1"
 	}
 	q 0
}

/// 发送短信,并更新发送记录表
ClassMethod SendMessage(Type As %String = "", UserID As %String = "") As %String
{
	;w ##class(web.DHCPE.Message.Main).SendMessage("","1")
	s rtn="Success"
	s Date=+$H
	s SMSObj=##class(web.DHCPE.Message.SMS).%New()
	s SMSObj.type="send"
	s i=0
	s CurType=""
	f  s CurType=$O(^User.DHCPENewSendMessageI("DateTypeIndex",Date,CurType)) q:CurType=""  d
	.q:(Type'="")&&(CurType'=Type)
	.s ID=0
	.f  s ID=$O(^User.DHCPENewSendMessageI("DateTypeIndex",Date,CurType,"0",ID)) q:ID=""  d
	..s SendMessageObj=##class(User.DHCPENewSendMessage).%OpenId(ID)
	..s MessageObj=##class(web.DHCPE.Message.Message).%New()
	..s MessageObj.SmsID=..GetSmsID(CurType)
	..s SendMessageObj.NSMSmsID=MessageObj.SmsID
	..s MessageObj.Bid=..GetBid(CurType)
	..s SendMessageObj.NSMBid=MessageObj.Bid
	..s MessageObj.RecvNum=SendMessageObj.NSMMobile
	..s MessageObj.SendLevel=..GetSendLevel(CurType)
	..s SendMessageObj.NSMSendLevel=MessageObj.SendLevel
	..s Content=SendMessageObj.NSMContent
	..i Content="" d
	...s Content=..GetContent(Type,"^"_ID)
	...s SendMessageObj.NSMContent=Content
	..s Content=..MaskContent(Content,"C")
	..s MessageObj.Content=Content
	..s SendMessageObj.NSMStatus=1
	..d SendMessageObj.NSMSendUserDRSetObjectId(UserID)
	..s SendMessageObj.NSMSendDate=Date
	..s SendMessageObj.NSMSendTime=$P($H,",",2)
	..s sc=SendMessageObj.%Save()
	..d SMSObj.Message.Insert(MessageObj)
	..d SendMessageObj.%Close()
	..d MessageObj.%Close()
	..s i=i+1
	..i i=200 d
	...s rtn=SMSObj.XMLExportToString(.XML,"SMS")
	...s i=0
	...d SMSObj.Message.Clear()
	...s rtn=..SendMessageApp(XML)
	...i rtn'="Success" d
	....s Sort=$i(^DHCPENewRecvMessageErrInfo("Send"))
    ....s ^DHCPENewRecvMessageErrInfo("Send",Sort)=XML
	i i>0 d
	.s rtn=SMSObj.XMLExportToString(.XML,"SMS")
	.s ^wrz("Send")=XML
	.s rtn=..SendMessageApp(XML)
	.i rtn'="Success" d
	..s Sort=$i(^DHCPENewRecvMessageErrInfo("Send"))
    ..s ^DHCPENewRecvMessageErrInfo("Send",Sort)=XML
	d SMSObj.%Close()
	q:"Success"=rtn 0
	q -1
}

/// 接受短信
ClassMethod RecvMessage(Type As %String = "", UserID As %String = "") As %String
{
	;w ##class(web.DHCPE.Message.Main).RecvMessage("","1")
	s XML=..RecvMessageApp(Type)
	s SMSObj=##class(web.DHCPE.Message.SMS).%New()
	d SMSObj.XMLNodeDeserialize(.SMSObj,"SMS", XML)
	s MessageLength=SMSObj.Message.Count()
	f i=1:1:MessageLength {
    	s MessageObj=SMSObj.Message.GetAt(i)
    	s RecvObj=##class(User.DHCPENewRecvMessage).%New()
    	s RecvObj.NRMSmsID=MessageObj.SmsID
    	s RecvObj.NRMSendNum=MessageObj.RecvNum
    	s RecvObj.NRMBid=MessageObj.Bid
    	s RecvObj.NRMContent=MessageObj.Content
    	s RecvObj.NRMContent=..MaskContent(RecvObj.NRMContent,"RC")
    	
    	s RecvObj.NRMType=MessageObj.Bid
    	s DateTime=MessageObj.RecvTime
    	s Date=$P(DateTime," ",1)
    	s Time=$P(DateTime," ",2)
    	s:Date'="" Date=$ZDH(Date,3)
    	s:Time'="" Time=$ZTH(Time,3)
    	s RecvObj.NRMSendDate=Date
    	s RecvObj.NRMSendTime=Time
    	s RecvObj.NRMBid=MessageObj.Bid
    	d RecvObj.NRMRecvUserDRSetObjectId(UserID)
    	s RecvObj.NRMRecvDate=+$H
    	s RecvObj.NRMRecvTime=$P($H,",",2)
    	s sc=RecvObj.%Save()
    	i $$$ISERR(sc) {
     		s rtn=RecvObj.XMLExportToString(.XML,"Recv")
     		s Sort=$i(^DHCPENewRecvMessageErrInfo("Recv"))
     		s ^DHCPENewRecvMessageErrInfo("Recv",Sort)=XML
 		}
	}
	i MessageLength=200 d  ;最多200条,多于200再接受一次
	.s ret=..RecvMessage(Type, UserID)
	.s MessageLength=MessageLength+ret
	q MessageLength
}

/// 接受短信回执
ClassMethod ReportMessage(Type As %String = "", UserID As %String = "") As %String
{
	;w ##class(web.DHCPE.Message.Main).ReportMessage("","1")
	s XML=..ReportMessageApp(Type)
	s SMSObj=##class(web.DHCPE.Message.SMS).%New()
	d SMSObj.XMLNodeDeserialize(.SMSObj,"SMS", XML)
	s MessageLength=SMSObj.Message.Count()
	f i=1:1:MessageLength {
    	s MessageObj=SMSObj.Message.GetAt(i)
    	s SmsID=MessageObj.SmsID
    	s Status=MessageObj.Status
    	s SendID=$O(^User.DHCPENewSendMessageI("SmsIDIndex",SmsID,0))
    	continue:SendID=""
    	s:Status=1 Status=4
    	s:Status=0 Status=3
    	s SendSMSObj=##class(User.DHCPENewSendMessage).%OpenId(SendID)
    	s DateTime=MessageObj.ReportTime
    	s Date=$P(DateTime," ",1)
    	s Time=$P(DateTime," ",2)
    	s:Date'="" Date=$ZDH(Date,3)
    	s:Time'="" Time=$ZTH(Time,3)
    	s SendSMSObj.NSMStatus=Status
    	s SendSMSObj.NSMReportDate=Date
    	s SendSMSObj.NSMReportTime=Time
    	d SendSMSObj.NSMUpdateUserDRSetObjectId(UserID)
    	s SendSMSObj.NSMUpdateDate=+$H
    	s SendSMSObj.NSMUpdateTime=$P($H,",",2)
    	s sc=SendSMSObj.%Save()
    	i $$$ISERR(sc) {
     		s rtn=SendSMSObj.XMLExportToString(.XML,"Report")
     		s Sort=$i(^DHCPENewRecvMessageErrInfo("Report"))
     		s ^DHCPENewRecvMessageErrInfo("Report",Sort)=XML
 		}
	}
	i MessageLength=200 d  ;最多200条,多于200再接受一次
	.s ret=..ReportMessage(Type, UserID)
	.s MessageLength=MessageLength+ret
	q MessageLength
}

ClassMethod SendMessageApp(XML) As %String
{
	q "Success"
	q $zobjclassmethod(..#ServiceClassName,..#SendServiceMethodName,"POWERU-SMS",XML)
}

ClassMethod RecvMessageApp(Type As %String = "") As %String
{
	q ^wrz("Recv")
	s Bid=..GetBid(Type)
	q $zobjclassmethod(..#ServiceClassName,..#RecvServiceMethodName,"POWERU-SMS",Bid)
}

ClassMethod ReportMessageApp(Type As %String = "") As %String
{
	q ^wrz("Report")
	s Bid=..GetBid(Type)
	q $zobjclassmethod(..#ServiceClassName,..#ReportServiceMethodName,"POWERU-SMS",Bid)
}

/// 根据业务类型以及扩展参数,得到短信内容
ClassMethod GetContentEx(Type, ExpStr) As %String
{
	s Content=$G(^DHCPEDataEx("Content",Type,"Default"))
	i Type="Report"{
		s RegNo=ExpStr
		s RegNo=$ZCVT(RegNo,"U")
		s ID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
		s Name=$P(^PAPER(ID,"ALL"),"^",1)
		s SexDR=$P(^PAPER(ID,"ALL"),"^",7)
		s:(SexDR=1) Name=Name_"女士"
		s:(SexDR=2) Name=Name_"先生"
		s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"[Name]",Name)
		q Content
	}
	q "测试短信"
}

ClassMethod SaveContent(Type, Content)
{
	s ^DHCPEDataEx("Content",Type,"Default")=Content
}

/// 根据业务类型得到短信发送级别
ClassMethod GetSendLevel(Type) As %String
{
	q 1
}

/// 根据业务类型得到接口登录名
ClassMethod GetBid(Type) As %String
{
	q ""
}

/// 根据业务类型得到类型描述
/// w ##class(web.DHCPE.Message.Main).GetTypeDesc("Report")
ClassMethod GetTypeDesc(Type) As %String
{
	q:Type="RP" "报告通知"
	q:Type="HR" "上报高危"  
	q:Type="RR" "高危结果"
	q:Type="RC" "高危建议"
	q:Type="FS" "自由发送"
	q:Type="PAADM" "复查提醒"
	q:Type="NetPre" "网上预约"
	q:Type="HisPre" "His预约"
	q:Type="VC" "验证码"
	q ""
}

/// 根据状态得到状态描述
/// w ##class(web.DHCPE.Message.Main).GetStatusDesc("0")
ClassMethod GetStatusDesc(Status) As %String
{
	q:Status="0" "待发送"
	q:Status="1" "已发送"
	q:Status="2" "发送成功"
	q:Status="3" "发送失败"
	q ""
}

/// 根据业务类型得到短信ID
/// w ##class(web.DHCPE.Message.Main).GetSmsID()
ClassMethod GetSmsID(Type) As %String
{
	s CurDate=+$H
	s CurStr=$ZD(CurDate,8)
	k ^DHCPECreateSMSID((+$H-1))
	s Sort=$i(^DHCPECreateSMSID(CurDate,Type))
	s Sort=..MaskSmsSort(Sort,6)
	q "UE"_Type_CurStr_Sort_"0"
}

ClassMethod MaskSmsSort(Sort, Length) As %String
{
	s ZeroStr=$E("00000000000000000000000000",1,Length)
	s Sort=$E(ZeroStr,1,Length-$l(Sort))_Sort
	q Sort
}

/// C 去掉<>"'&符号
/// RC 转成<>"'&符号
ClassMethod MaskContent(Content, Type)
{
	i Type="C" d
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"&","&amp;")
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"<","&lt;")
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,">","&gt;")
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"""","&quot;")
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"'","&apos;")
	e  d
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"&lt;","<")
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"&gt;",">")
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"&quot;","""")
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"&apos;","'")
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"&amp;","&")
	
	q Content
}

ClassMethod SendMessageToLHH(ReportID)
{
	;d ##class(web.DHCPE.Message.Main).SendMessageToLHH(37391)
	s IADM=$P(^DHCPERPT(ReportID),"^",1)
	s VIPLevel=##class(web.DHCPE.PreCommon).GetVIPLevel("IADM", IADM)
	s:VIPLevel[("VIP") VIPLevel="V"
	s:VIPLevel'[("VIP") VIPLevel="P"
	s:VIPLevel="" VIPLevel="P"
	s CurDate=+$H
	s Sort=$I(^DHCPEDateEx("SendMessageCount",VIPLevel,CurDate))
	i Sort=10 d
	.d ##class(web.DHCPE.Message.Main).SaveSendMessage("C460453^18612672080^"_VIPLevel_"短信测试^RP^"_CurDate_"^5918^37391^")
}

Storage Default
{
<Data name="MainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.Message.MainD</DataLocation>
<DefaultData>MainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.Message.MainD</IdLocation>
<IndexLocation>^web.DHCPE.Message.MainI</IndexLocation>
<StreamLocation>^web.DHCPE.Message.MainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
