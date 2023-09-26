Import sqluser

/// Descript:   急诊检验结果
/// Creator:    QQA 
/// CreateDate: 2017-02-24
Class web.DHCEMPatCheck Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 标本列表
/// w ##class(web.DHCEMPatCheck).JsonQryOrdList("0","20","-1^190^^^^^^^^^^^^^")
ClassMethod JsonQryOrdList(offset As %String, limit As %String, Params As %String)
{
	
	n (offset,limit,Params)
	s Start=offset+1
	s End=offset+limit
	s EpisodeID=$p(Params,"^",1)
	s PatientID=$p(Params,"^",2)
	s FromDate=$p(Params,"^",3)
	s ToDate=$p(Params,"^",4)
	s LocCode=$p(Params,"^",5)
	s AuthFlag=$p(Params,"^",6)
	s AllTS=$p(Params,"^",7)
	s AdmDateFlag=$p(Params,"^",8)
	s UserId=$p(Params,"^",9)
	s fReadFlag=$p(Params,"^",10)
	s fRegNo=$p(Params,"^",11)
	s fLocationDR=$p(Params,"^",12)
	s fWardDR=$p(Params,"^",13)
	s fPrintFlag=$p(Params,"^",14)

	Set result=##class(%Library.ResultSet).%New("DHCLIS.DHCOrderList:QueryOrderList")
	Set sc=result.Execute(EpisodeID, PatientID, FromDate, ToDate, LocCode, AuthFlag, AllTS, AdmDateFlag, UserId, fReadFlag, fRegNo, fLocationDR, fWardDR, fPrintFlag,"")
	If $$$ISERR(sc) Quit ""

	Set colNum=result.GetColumnCount() //列数
	Set count = 0
	Set del=""""
	Set tmp=""
	Set EmPatLevTotal=0,EmPatLevCnt1=0,EmPatLevCnt2=0,EmPatLevCnt3=0,EmPatLevNotCnt=0
	Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	While(result.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		Set count = count+1
		Continue:(count<Start)||(count>End)
		
		If count=Start Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 }
	 w "]"
	 w ","_del_"total"_del_":"_count
	 w "}"
	 Do result.Close()
	 Quit ""
}

/// Descript: 报告结果
/// w ##class(web.DHCEMPatCheck).JsonQryTSInfo("0","20","16")
ClassMethod JsonQryTSInfo(offset As %String, limit As %String, ReportDR As %String)
{
	
	n (offset,limit,ReportDR)
	s Start=offset+1
	s End=offset+limit
	
	Set result=##class(%Library.ResultSet).%New("LIS.WS.BLL.DHCRPVisitNumberReportResult:QryTSInfo")
	Set sc=result.Execute(ReportDR)
	If $$$ISERR(sc) Quit ""

	Set colNum=result.GetColumnCount() //列数
	Set count = 0
	Set del=""""
	Set tmp=""
	Set EmPatLevTotal=0,EmPatLevCnt1=0,EmPatLevCnt2=0,EmPatLevCnt3=0,EmPatLevNotCnt=0
	Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	While(result.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		Set count = count+1
		Continue:(count<Start)||(count>End)
		
		If count=Start Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 }
	 w "]"
	 w ","_del_"total"_del_":"_count
	 w "}"
	 Do result.Close()
	 Quit ""
}

}
