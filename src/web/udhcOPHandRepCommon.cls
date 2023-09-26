/// 公用报表接口
Class web.udhcOPHandRepCommon Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod ReadReportsDataByRowID(itmjs As %Library.String = "", itmjsex As %Library.String = "", ReportRowID As %String) As %String
{
	;w ##class(web.udhcOPHandRepCommon).ReadReportsDataByRowID("","",2)
	s myrtn=0
	
	;输出文本格式 的数据
	s myOutObj=##class(web.DHCEntity.OPC.Report).%New()
	s myReportObj=##class(User.DHCINVPRTReports).%OpenId(ReportRowID)
	
	d myOutObj.ExchangeData(myReportObj)
	s myOutObj.HISDate=$zd(myOutObj.HISDate,3)
	s myOutObj.HISTime=$zt(myOutObj.HISTime)
	s myOutObj.HISEndDate=$zd(myOutObj.HISEndDate,3)
	s myOutObj.HISEndTime=$zt(myOutObj.HISEndTime)
	s myOutObj.HISStartDate=$zd(myOutObj.HISStartDate,3)
	s myOutObj.HISStartTime=$zt(myOutObj.HISStartTime)
	
	s hUser=myOutObj.HISUser
	s myUserName=$p($g(^SSU("SSUSR",hUser)),"^",2)
	s myOutObj.HISUserName=myUserName
	
	;HISINVTotalSum
	s myOutObj.CalGetTotal= +myReportObj.HISNormalSum
	s myOutObj.CalGiveTotal=myReportObj.HISRefundSum+ myReportObj.HISParkSum

	s myRepOtherInfo=myReportObj.HISReportStatus_"^"_myReportObj.HISCollect_"^^^^^^"
	
	b	;;
	d myOutObj.XMLExportToStringExp(.mystr)
	
	d myOutObj.%Close()
	b		;myMInfo
	s myCatXmlData=""
	;
	s retval=itmjs_"('"_$ZCVT(mystr,"O","JS")_"', '"_$ZCVT(myCatXmlData,"O","JS")_"'"_", '"_$ZCVT(myRepOtherInfo,"O","JS")_"' "
	s retval=retval_");"
	s ^TMPJSTESTDFDFD=retval
	&javascript<#(retval)#>
	
	d myReportObj.%Close()
	
	;输出记录集数据格式
	
	s myTINVObj=##class(web.DHCEntity.OPC.ReportsInfo).%New()
	
	d myTINVObj.ReadReportByRowID(ReportRowID)
	
	d ##class(web.udhcOPHandinIF).ReportRSOut(itmjsex,myTINVObj)
	
	d myTINVObj.%Close()
	
	q myrtn
}

ClassMethod CancelReportsByRowID(ReportRowID As %String) As %String
{
	;w ##class(web.udhcOPHandRepCommon).CancelReportsByRowID(4)
	s myrtn=0
	
	
	s myRepobj=##class(User.DHCINVPRTReports).%OpenId(ReportRowID)
	
	i (myRepobj.HISReportStatus="C"){
		s myrtn=121
		q myrtn
	}
	
	i (myRepobj.HISCollect="Y"){
		s myrtn=120
		q myrtn
	}
	
	d myRepobj.%Close()
	
	ts
	
	s myDHCReports=##class(User.DHCINVPRTReports).%OpenId(ReportRowID)
	s myDHCReports.HISReportStatus="C"
	
	s sc=myDHCReports.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = -100
	}
	
	if (+myrtn=0){
		;撤销结帐子表
		
	}
	
	d myDHCReports.%Close()
	
	b	;;Tro
	if (+myrtn=0){
		tc
	}else
	{
		tro
	}
	
	q myrtn
}

}
