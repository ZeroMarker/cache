Class web.DHCIPBillTouchFeeDataSet Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCIPBill";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://172.23.6.6/dthealth/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/DHCIPBill/TouchFee";

/// 取病人信息
/// w ##class(web.DHCIPBillTouchFeeDataSet).GetPatInfo("63010400002","")
ClassMethod GetPatInfo(CardNo As %String, RegNo As %String) As %String [ WebMethod ]
{
 Set result=##class(web.DHCIPBillTouchFee).GetPatInfo(CardNo,RegNo)

 Quit result
}

/// 取药品价格
ClassMethod GetMedPriceDataSet(MedAlias As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCIPBillTouchFee:FindMedInfoByAlias")
  Do result.SetArgs(MedAlias)
 Quit result
}

/// 取非药品价格
ClassMethod GetTarItemPriceDataSet(ItmAlias As %String, Flag As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCIPBillTouchFee:FindTarItemPrice")
 Do result.SetArgs(ItmAlias,Flag)
 Quit result
}

/// 取住院费用发票明细
ClassMethod GetInPatAdmInfoDataSet(CardNo As %String, RegNo As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCIPBillTouchFee:FindInPatFeeInfo")
 Do result.SetArgs(CardNo,RegNo)
 Quit result
}

/// 取住院费用分类金额
ClassMethod GetInPatCateFeeInfoDataSet(PBRowID As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCIPBillTouchFee:FindInPatCateFeeInfo")
 Do result.SetArgs(PBRowID)
 Quit result
}

/// 取病人的住院分类费用明细信息
ClassMethod GetInPatCateFeeDetailDataSet(PBRowID As %String, BillDate As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCIPBillTouchFee:FindInPatCateFeeDetail")
 Do result.SetArgs(PBRowID,BillDate)
 Quit result
}

/// 取门诊费用发票明细
ClassMethod GetOutPatAdmInfoDataSet(CardNo As %String, RegNo As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCIPBillTouchFee:FindOutPatFeeInfo")
 Do result.SetArgs(CardNo,RegNo)
 Quit result
}

/// 取门诊费用分类金额
ClassMethod GetOutPatCateFeeInfoDataSet(PrtRowID As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCIPBillTouchFee:FindOutPatCateFeeInfo")
 Do result.SetArgs(PrtRowID)
 Quit result
}

/// 取病人的门诊分类费用明细信息
ClassMethod GetOutPatCateFeeDetailDataSet(PrtRowID As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(%XML.DataSet).%New("web.DHCIPBillTouchFee:FindOutPatCateFeeDetail")
 Do result.SetArgs(PrtRowID)
 Quit result
}

}
