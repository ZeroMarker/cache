Class web.DHCPE.Message.Test Extends %Persistent
{

/// w ##class(web.DHCPE.Message.Test).CreateXML()
ClassMethod CreateXML()
{
	s SmsObject=##class(web.DHCPE.Message.SMS).%New()
	s SmsObject.type="send"
	
	s MessageObj=##class(web.DHCPE.Message.Message).%New()
	s MessageObj.SmsID="UE09123456789123450"
	s MessageObj.Bid="userTest1"
	s MessageObj.Content="短信测试"
	s MessageObj.RecvNum="18610513055"
	s MessageObj.SendLevel="1"
	d SmsObject.Message.Insert(MessageObj)
	
	s MessageObj=##class(web.DHCPE.Message.Message).%New()
	s MessageObj.SmsID="UE09123456789123460"
	s MessageObj.Bid="userTest1"
	s MessageObj.Content="短信测试"
	s MessageObj.RecvNum="18610513056"
	s MessageObj.SendLevel="1"
	d SmsObject.Message.Insert(MessageObj)  ;Clear
	
	s rtn=SmsObject.XMLExportToString(.XML,"SMS")
	d SmsObject.%Close()
	d MessageObj.%Close()
	q XML
}

/// / Creat For Get Num LabID Change
/// By Sun
/// /根据PreIADM的起始ID 判断有多少需要修改的人数
/// w ##class(web.DHCPE.Message.Test).GetNum("49715","58402")
/// / 49715  58402  236人
/// --select * from arc_itmmast
/// --select PIADM_PIBI_DR->PIBI_PAPMINo,* from dhc_pe_preiadm where PIADM_RowId>58350
/// select dictinct PIOI_ParRef from dHC_PE_PreIOrdItem where PIOI_ParRef>49715 and PIOI_ParRef<58402 and PIOI_ItmMast_DR = (select ARCIM_RowId from arc_itmmast where ARCIM_Code in ('0000000441','1000000111','1000000109','1000000108','1000000110','1000000079','0000001565','0000001566','0000002096'))
ClassMethod GetNum(ID1, ID2)
{
	s Num=0,ID=0,no=0
	f  s ID=$o(^DHCPEPreIADM(ID)) q:(ID="")||(ID<ID1)||(ID>ID2)  d
	.s Sub=0
	.f  s Sub=$O(^DHCPEPreIADM(ID,"ORDITEM",Sub)) q:(Sub="")  d
	..s ItMast=$p($g(^DHCPEPreIADM(ID,"ORDITEM",Sub)),"^")
	..s Code="",Desc=""
	..s Code=$p($g(^ARCIM($p(ItMast,"||"),$p(ItMast,"||",2),1)),"^")
	..s Desc=$p($g(^ARCIM($p(ItMast,"||"),$p(ItMast,"||",2),1)),"^",2)
	..
	..s Flag=..GetIfConten(Code)
	..w Flag,!
	..q:(Flag=1)
	.s no=no+1
	.;w:(Flag=1) Desc,!
	.;w ID
	.;w !
	.s:(Flag=1) Num=Num+1
	q Num_"&&"_no
}

ClassMethod GetIfConten(Code)
{
	
	s Flag=0
	s:(Code="0000000441") Flag=1
	s:(Code="1000000111") Flag=1
	s:(Code="1000000109") Flag=1
	s:(Code="1000000108") Flag=1
	s:(Code="1000000110") Flag=1
	s:(Code="1000000079") Flag=1
	s:(Code="0000001565") Flag=1
	s:(Code="0000001566") Flag=1
	s:(Code="0000002096") Flag=1
	q Flag
}

/// w ##class(web.DHCPE.Message.Test).CreateObj()
ClassMethod CreateObj()
{
	s XML=..CreateXML()
	s SmsObject=##class(web.DHCPE.Message.SMS).%New()
	d SmsObject.XMLNodeDeserialize(.SmsObject,"SMS", XML)
	s MessageLength=SmsObject.Message.Count()
	For i=1:1:MessageLength {
    	   s MessageObj=SmsObject.Message.GetAt(i)
    	   s SmsID=MessageObj.SmsID
    	   s Bid=MessageObj.Bid
    	   s Content=MessageObj.Content
    	   s RecvNum=MessageObj.RecvNum
    	   s SendLevel=MessageObj.SendLevel
    	   w SmsID_"^"_Bid_"^"_Content_"^"_RecvNum_"^"_SendLevel,!
	}
	d SmsObject.%Close()
	q "OVER"
}

//d ##class(web.DHCPE.Message.Test).InsertSMS()

ClassMethod InsertSMS()
{
	s str="0000000001^18610513055^^01^62762^1^"
	d ##class(web.DHCPE.Message.Main).SaveSendMessage(str)
	s str="0000000002^18610513056^^01^62762^1^"
	d ##class(web.DHCPE.Message.Main).SaveSendMessage(str)
	s str="0000000002^18610513056^^01^62763^1^"
	d ##class(web.DHCPE.Message.Main).SaveSendMessage(str)
}

//d ##class(web.DHCPE.Message.Test).SendSMS()

ClassMethod SendSMS()
{
	d ##class(web.DHCPE.Message.Main).SendMessage("","2")
}

//d ##class(web.DHCPE.Message.Test).RecvSMS()

ClassMethod RecvSMS()
{
	d ##class(web.DHCPE.Message.Main).RecvMessage("","3")
}

//d ##class(web.DHCPE.Message.Test).ReportSMS()

ClassMethod ReportSMS()
{
	d ##class(web.DHCPE.Message.Main).ReportMessage("","4")
}

//d ##class(web.DHCPE.Message.Test).TestSend()

ClassMethod TestSend()
{
	s Url="http://admin.sms9.net/houtai/sms.php?cpid=3869&password=2ed182dae39779add2224689b67cf264&channelid=1&tele=18610513055&msg=testcontent&timestamp=1419488396"
	s obj=##class(%Net.HttpRequest).%New()  //Send("Post",Url)
	w obj.ContentCharsetGet(),!
	w obj.ContentEncodingGet(),!
	w obj.Send("Get",Url)
}

Storage Default
{
<Data name="TestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.Message.TestD</DataLocation>
<DefaultData>TestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.Message.TestD</IdLocation>
<IndexLocation>^web.DHCPE.Message.TestI</IndexLocation>
<StreamLocation>^web.DHCPE.Message.TestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
