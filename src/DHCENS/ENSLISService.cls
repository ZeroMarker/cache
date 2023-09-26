Class DHCENS.ENSLISService Extends (%SOAP.WebService, %XML.Adaptor) [ Inheritance = right, ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "ENSLISService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

Parameter LOCATION = "http://192.168.1.70/dthealth/web";

ClassMethod DhcService(funName As %String, input As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	s objStream=##class(%GlobalCharacterStream).%New()

	if (funName="GetDictInfo")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).GetDictInfo(input)
	}
	
	if (funName="GetPatInfo")
	{	
		s objStream=##Class(DHCENS.LIS.Method.Interface).GetPatInfo(input)
	}
	
	if (funName="GetLabOrder")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).GetLabOrder(input)
	}
	if (funName="GetLabOrderList")
	{
		s objStream=##Class(DHCENS.LIS.Method.Interface).GetLabOrderList(input)
	}
	
	if (funName="ModifyStatus")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).ModifyStatus(input)
	}
	
	if (funName="GetOrderStatus")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).GetOrderStatus(input)
	}
	if (funName="CancelFeeApp")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).CancelFeeApp(input)
	}
	
    if (funName="CheckUp")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).CheckUp(input)
	}

    if (funName="Refuse")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).Refuse(input)
	}
	
    if (funName="ReportMsg")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).ReportMsg(input)
	}

	if (funName="AddOrderItem")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).AddOrderItem(input)
	}

	if (funName="GetAmountOfTube")
	{
		s objStream=##class(DHCENS.LIS.Method.Interface).GetAmountOfTube(input)
	}
	b ;222
    d ##class(DHCENS.BaseCode.DhcEnsLog).InsertDhcEns("LIS",funName,input,objStream)
    b  ;333
	q objStream
}

ClassMethod Test(Input As %String) As %String
{
	s objStream1=##class(%GlobalCharacterStream).%New()
	;d objStream.Write("<Request><GetLabOrder><LabNo>1000000212</LabNo></GetLabOrder></Request>")
	;d objStream.Write("<Request><CheckUps><CheckUp><LabNo>17</LabNo><Rowid>50_3</Rowid><ExeUser>demo@系统管理员</ExeUser><AcceptDate>2010-08-30</AcceptDate><AcceptTime>10:58:01</AcceptTime></CheckUp></CheckUps></Request>")
	;d objStream.Write("<Request><GetLabOrder><LabNo>17</LabNo></GetLabOrder></Request>")
	d objStream1.Write("<Request><ReportMsg><OrdID>50_3</OrdID><ReportID>100829LA0003</ReportID><ReportUrl>201008</ReportUrl><RecUser>demo@系统管理员</RecUser><RecDate>2010-08-29</RecDate><RecTime>09:32:57</RecTime><EntryUser>demo@系统管理员</EntryUser><EntryDate>2010-08-29</EntryDate><EntryTime>11:07:01</EntryTime><AuthUser>demo@系统管理员</AuthUser><AuthDate>2010-08-29</AuthDate><AuthTime>11:07:35</AuthTime><Notes></Notes><ImageFile></ImageFile><MainWarnDesc>危机</MainWarnDesc><ResultMsgs><ResultMsg><LabNo>17</LabNo><TestCode>A205</TestCode><TestName>红细胞分布宽度</TestName><TestEngName>RDW</TestEngName><Result>18.00</Result><Units>%</Units><Notes></Notes><ResultFlag>H</ResultFlag><Ranges>10.9-15.7</Ranges><Sequence>018</Sequence><MICFlag>N</MICFlag><MICName></MICName><WarnDesc></WarnDesc><OrgResultMsgs><OrgResultMsg><BugsCode></BugsCode><AntiCode></AntiCode><AntiName></AntiName><AntiEngName></AntiEngName><MICRes></MICRes><KBRes></KBRes><Result></Result><MICRanges></MICRanges><Order></Order></OrgResultMsg></OrgResultMsgs></ResultMsg><ResultMsg><LabNo>17</LabNo><TestCode>A201</TestCode><TestName>白细胞</TestName><TestEngName>WBC</TestEngName><Result>1.00</Result><Units>G/L</Units><Notes></Notes><ResultFlag>L</ResultFlag><Ranges>4-10</Ranges><Sequence>001</Sequence><MICFlag>N</MICFlag><MICName></MICName><WarnDesc></WarnDesc><OrgResultMsgs><OrgResultMsg><BugsCode></BugsCode><AntiCode></AntiCode><AntiName></AntiName><AntiEngName></AntiEngName><MICRes></MICRes><KBRes></KBRes><Result></Result><MICRanges></MICRanges><Order></Order></OrgResultMsg></OrgResultMsgs></ResultMsg></ResultMsgs></ReportMsg></Request>")
	
	
	;d objStream.Write("<Request><ReportMsg><OrdID>112_20</OrdID><ReportID>100831LA0027</ReportID><ReportUrl>201008</ReportUrl><RecUser>demo@系统管理员</RecUser><RecDate>2010-08-31</RecDate><RecTime>17:54:51</RecTime><EntryUser>demo@系统管理员</EntryUser><EntryDate>2010-08-31</EntryDate><EntryTime>17:55:13</EntryTime><AuthUser>demo@系统管理员</AuthUser><AuthDate>2010-08-31</AuthDate><AuthTime>18:12:23</AuthTime><Notes></Notes><ImageFile></ImageFile><MainWarnDesc></MainWarnDesc><ResultMsgs><ResultMsg><LabNo>47</LabNo><TestCode></TestCode><TestName>超敏C反应蛋白</TestName><TestEngName>CRP</TestEngName><Result>43.00</Result><Units>mg/L</Units><Notes></Notes><ResultFlag>H</ResultFlag><Ranges>0-8</Ranges><Sequence>B03</Sequence><MICFlag>N</MICFlag><MICName></MICName><WarnDesc></WarnDesc><OrgResultMsgs><OrgResultMsg><BugsCode></BugsCode><AntiCode></AntiCode><AntiName></AntiName><AntiEngName></AntiEngName><MICRes></MICRes><KBRes></KBRes><Result></Result><MICRanges></MICRanges><Order></Order></OrgResultMsg></OrgResultMsgs></ResultMsg></ResultMsgs></ReportMsg></Request>")
	
	d ..DhcService("ReportMsg",objStream1)
	;<OrgResultMsgs><OrgResultMsg><BugsCode></BugsCode><AntiCode></AntiCode><AntiName></AntiName><AntiEngName></AntiEngName><MICRes></MICRes><KBRes></KBRes><Result></Result><MICRanges></MICRanges><Order></Order></OrgResultMsg></OrgResultMsgs>
	q "ok"
}

}
