Class web.DHCPE.DHCPEUSERREPORTEx Extends %Persistent
{

ClassMethod GetReportInfoForXH(begindate, enddate, UserID)
{
	s ReportDate=begindate_"--"_enddate
	
	s BDate=##class(websys.Conversions).DateHtmlToLogical(begindate)
	s EDate=##class(websys.Conversions).DateHtmlToLogical(enddate)

	s PrintDate=$ZD($H,3)
	k ^TempDHCPEUserReport
	s Job=$J
	s Date=BDate-1
	f  s Date=$O(^DHCPEUSERREPORT(0,"DATE",Date)) q:(Date="")||(Date>EDate)  d
	.s FootID=""
	.f  s FootID=$O(^DHCPEUSERREPORT(0,"DATE",Date,FootID)) q:FootID=""  d
	..s CurUser=$P(^DHCPEUSERREPORT(FootID),"^",1)
	..;q:CurUser'=UserID
	..d ##class(web.DHCPE.DHCPEUSERREPORT).GetReportInfoForXH(FootID,"","N",Job)
	
	s UserCode=$P(^SSU("SSUSR",UserID),"^",1)
	s UserName=$P(^SSU("SSUSR",UserID),"^",2)
	s User=UserName_"("_UserCode_")"
	s BaseInfo=User_"^"_ReportDate_"^"_PrintDate
	s RefInvNo=""
	s RefInvNum=""
	s InvNo=""
	f  s InvNo=$O(^TempDHCPEUserReport(Job,"RefInvNoStr",InvNo)) q:InvNo=""  d
	.s RefInvNum=+RefInvNum+1
	.i RefInvNo="" d
	..s RefInvNo=InvNo
	.e  d
	..s RefInvNo=RefInvNo_","_InvNo
	b ;RefInvNo
	s NorInvNum=""
	s NorInvNo=""
	s PreInvNo=""
	s InvNo=""
	f  s InvNo=$O(^TempDHCPEUserReport(Job,"InvNoStr",InvNo)) q:InvNo=""  d
	.s NorInvNum=+NorInvNum+1
	.i NorInvNo="" d
	..s NorInvNo=InvNo
	.e  d
	..i InvNo-PreInvNo=1 d
	...
	..e  d
	...s NorInvNo=NorInvNo_"-"_PreInvNo_","_InvNo
	.s PreInvNo=InvNo
	s NorInvNo=NorInvNo_"-"_PreInvNo
	b ;NorInvNo
	s BaseInfo=BaseInfo_"^"_NorInvNum_"^"_NorInvNo_"^"_RefInvNum_"^"_RefInvNo
	q Job_"^"_BaseInfo
}

Storage Default
{
<Data name="DHCPEUSERREPORTExDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.DHCPEUSERREPORTExD</DataLocation>
<DefaultData>DHCPEUSERREPORTExDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.DHCPEUSERREPORTExD</IdLocation>
<IndexLocation>^web.DHCPE.DHCPEUSERREPORTExI</IndexLocation>
<StreamLocation>^web.DHCPE.DHCPEUSERREPORTExS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
