Class web.webDHCBillTouchScreenSOAP Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCIPBill";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://127.0.0.1/dthealth/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/DHCIPBill/TouchFee";

/// 取病人信息
/// w ##class(web.DHCIPBillTouchFeeDataSet).GetPatInfo("","0000000539")
ClassMethod GetPatInfo(CardNo As %String, RegNo As %String) As %String [ WebMethod ]
{
	;s ^Lid("getpatinfo")=CardNo_","_RegNo
	n (CardNo,RegNo)
	set CardNo=$tr(CardNo,$c(0),"")
	set RegNo=$tr(RegNo,$c(0),"")
 Set result=##class(web.DHCBillTouchScreenQuery).GetPatInfo(CardNo,RegNo)

 Quit result
}

/// 取药品价格
ClassMethod GetMedPriceDataSet(MedAlias As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCBillTouchScreenQuery:FindMedInfoByAlias")
  Do result.SetArgs(MedAlias)
 Quit result
}

/// 取非药品价格
ClassMethod GetTarItemPriceDataSet(ItmAlias As %String, Flag As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCBillTouchScreenQuery:FindTarItemPrice")
 Do result.SetArgs(ItmAlias,Flag)
 Quit result
}

/// 取住院费用发票明细
ClassMethod GetInPatAdmInfoDataSet(CardNo As %String, RegNo As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCBillTouchScreenQuery:FindInPatFeeInfo")
 Do result.SetArgs(CardNo,RegNo)
 Quit result
}

/// 取住院费用分类金额
ClassMethod GetInPatCateFeeInfoDataSet(PBRowID As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCBillTouchScreenQuery:FindInPatCateFeeInfo")
 Do result.SetArgs(PBRowID)
 Quit result
}

/// 取病人的住院分类费用明细信息
ClassMethod GetInPatCateFeeDetailDataSet(PBRowID As %String, BillDate As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCBillTouchScreenQuery:FindInPatCateFeeDetail")
 Do result.SetArgs(PBRowID,BillDate)
 Quit result
}

/// 取门诊费用发票明细
ClassMethod GetOutPatAdmInfoDataSet(CardNo As %String, RegNo As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCBillTouchScreenQuery:FindOutPatFeeInfo")
 Do result.SetArgs(CardNo,RegNo)
 Quit result
}

/// 取门诊费用分类金额
ClassMethod GetOutPatCateFeeInfoDataSet(PrtRowID As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCBillTouchScreenQuery:FindOutPatCateFeeInfo")
 Do result.SetArgs(PrtRowID)
 Quit result
}

/// 取病人的门诊分类费用明细信息
ClassMethod GetOutPatCateFeeDetailDataSet(PrtRowID As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCBillTouchScreenQuery:FindOutPatCateFeeDetail")
 Do result.SetArgs(PrtRowID)
 Quit result
}

/// 排班记录查询
/// Input:AdmLocIDe(科室ID),ScheduleDate(出诊日期)
/// w ##class(web.DHCIPBillTouchFeeDataSet).GetApptScheduleListDataSet(13,"2015/09/09")
ClassMethod GetApptScheduleListDataSet(AdmLocID As %String, ScheduleDate As %String) As %XML.DataSet [ WebMethod ]
{
	s ^Lid("appsc")=AdmLocID_","_ScheduleDate
 Set result=##class(%XML.DataSet).%New("web.DHCBillTouchScreenQuery:ApptScheduleListQuery")
 Do result.SetArgs(AdmLocID,ScheduleDate)
 Quit result
}

/// 取门诊排班科室
ClassMethod GetOPDeptDataSet() As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCBillTouchScreenQuery:FindLoc")
 Do result.SetArgs()
 Quit result
}

/// 取检验报告列表
Method GetReportList(EpisodeID As %String, PatientID As %String) As %XML.DataSet [ WebMethod ]
{
	Set Search="^^^Y" 
 	Set result=##class(%XML.DataSet).%New("web.DHCLISService:QueryOrderList")
 	Do result.SetArgs(EpisodeID,PatientID,Search)
 	Quit result
}

/// 取检验报告结果列表
Method GetReportResult(OrderID As %String) As %XML.DataSet [ WebMethod ]
{
 	Set result=##class(%XML.DataSet).%New("web.DHCLISService:QueryOrderResult")
 	Do result.SetArgs(OrderID)
 	Quit result
}

/// 取检验报告结果列表
Method GetReportResultSen(OrderID As %String, TC As %String) As %XML.DataSet [ WebMethod ]
{
 	Set result=##class(%XML.DataSet).%New("web.DHCLISService:QueryResultSen")
 	Do result.SetArgs(OrderID,TC)
 	Quit result
}

/// 取报告基本信息
ClassMethod GetReportInfo(OrderID As %String) As %String [ WebMethod ]
{
 Set result=##Class(web.DHCLISService).GetReportInfo(OrderID)
 Quit result
}

}
