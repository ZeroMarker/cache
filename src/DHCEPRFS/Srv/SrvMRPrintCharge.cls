Class DHCEPRFS.Srv.SrvMRPrintCharge Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvMRPrintCharge";

ClassMethod GetPrintChargeXML(AMREpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRPrintCharge).GetPrintChargeXML(AMREpisodeID)
	q ret
}

/// Desc:	保存患者打印病案收费记录
/// Author：yangpeng 2015.11.06
/// Debug : w ##class(DHCEPRFS.Srv.SrvMRPrintCharge).SavePrintCharge("2015-11-06^15:27:17^17^2015-11-06^14:16:21^19.5^159~28^^14:16:21^10^邮寄费^25||34^1^10^10~28^^14:16:21^20^基础费^25||34^1^8^8~28^^14:16:21^30^打印费^25||34^1^.5^.5~28^^15:26:57^30^打印费^25||35^1^.5^.5~28^^15:27:17^30^打印费^25||36^1^.5^.5~")
ClassMethod SavePrintCharge(AFootString As %String, AFootDate As %String, AFootTime As %String, AMRPatientID As %String, ABeginActDate As %String, ABeginActTime As %String, ATotalAmount As %String, AActUserID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRPrintCharge).SavePrintCharge(AFootString,AFootDate,AFootTime,
			AMRPatientID,ABeginActDate,ABeginActTime,ATotalAmount,AActUserID)
	q ret
}

/// Desc:	按照日期查询打印方案的打印次数及金额 杨鹏 2015.11.9
/// Input：	AMREpisodeID 		病案就诊ID
/// 		AEpisodeID 	就诊号
/// Debug：	w ##Class(DHCEPRFS.Srv.SrvMRPrintCharge).GetPrintChargeGpByUser("2015-11-30","2015-11-30")
/// SQL check:
ClassMethod GetPrintChargeGpByUser(ABeginDate As %String, AEndDate As %String, ARole As %String = "", AUserID As %String = "") As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRPrintCharge:GetPrintChargeGpByUser")
	d obj.SetArgs(ABeginDate,AEndDate,ARole,AUserID)
	q obj
}

/// Desc:	按照日期查询操作员的打印结算记录 杨鹏 2015.11.12
/// Input：	ABeginDate 		开始日期
/// 		AEndDate 		截止日期
/// 			AUserID			操作员编码
/// Debug：	w ##Class(DHCEPRFS.Srv.SrvMRPrintCharge).GetOperPrintChargeDetail("2015-11-01","2015-11-11","159")
/// return MRPrintChargeID^UserName^BeginDate^FootDate^MRPatientID^PatientName^TotalAmount^MedRecordNO^AdmDate^PrintTime
/// 			^ChargeTypeCode^ChargeTypeName^Quan^Price^Amount
ClassMethod GetOperPrintChargeDetail(AStartDate As %String, AEndDate As %String, AUserID As %String, ARole As %String = "") As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRPrintCharge:GetOperPrintChargeDetail")
	d obj.SetArgs(AStartDate,AEndDate,AUserID,ARole)
	q obj
}

/// Desc:	返回当日该患者打印病案未收费记录情况 杨鹏 2015.11.27
/// Input：	AMREpisodeID  	就诊ID
/// Deubg:	w ##Class(DHCEPRFS.Srv.SrvMRPrintCharge).GetPrintChargeDS("28")
/// Return:FootDate^FootTime^MRPatientID^Name^Sex^Birthday^BeginActDate^BeginActTime^TotalAmount
/// ^MREpisodeID^MRMedRecordID^MedRecordNO^AdmDate^PrintTime^ChargeTypeCode^ChargeTypeName^MRLogDetailID
/// ^Quan^Price^Amount
ClassMethod GetPrintChargeDS(AMREpisodeID As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRPrintCharge:GetPrintChargeDS")
	d obj.SetArgs(AMREpisodeID)
	q obj
}

/// Desc:	查询时间段内未结算打印记录明细
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// 		AUserName	用户名称 模糊查询
/// Debug：	w ##class(DHCEPRFS.Srv.SrvMRPrintCharge).GetUnChargePrintDetail("2015-12-01","2015-12-01","程丹颖")
ClassMethod GetUnChargePrintDetail(AStartDate As %String, AEndDate As %String, AUserName As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRPrintCharge:GetUnChargePrintDetail")
	d obj.SetArgs(AStartDate,AEndDate,AUserName)
	q obj
}

ClassMethod GetPatiInfo(AMREpisodeID As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMRPrintCharge).GetPatiInfo(AMREpisodeID)
}

ClassMethod GetChargePriceParam() As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMRPrintCharge).GetChargePriceParam()
}

ClassMethod GetPrintList(AStartDate As %String, AEndDate As %String, AConditionType As %String, ACondition As %String, AStatus As %String, AUserID As %String = "") As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRPrintCharge:GetPrintList")
	d obj.SetArgs(AStartDate,AEndDate,AConditionType,ACondition,AStatus,AUserID)
	q obj
}

ClassMethod GetPrintListFee(AMRPrintChargeID As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRPrintCharge:GetPrintListFee")
	d obj.SetArgs(AMRPrintChargeID)
	q obj
}

ClassMethod GetPrintListRec(AMRPrintChargeID As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRPrintCharge:GetPrintListRec")
	d obj.SetArgs(AMRPrintChargeID)
	q obj
}

ClassMethod GetPrintListItem(AMRPrintChargeID As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRPrintCharge:GetPrintListItem")
	d obj.SetArgs(AMRPrintChargeID)
	q obj
}

ClassMethod SetPrintListCharge(AMRPrintChargeID As %String, AChargeUserID As %String, AInvoiceNo As %String = "") As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMRPrintCharge).SetPrintListCharge( AMRPrintChargeID,AChargeUserID,AInvoiceNo)
}

ClassMethod SetPrintListPrint(AMRPrintChargeID As %String, APrintUserID As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMRPrintCharge).SetPrintListPrint( AMRPrintChargeID,APrintUserID)
}

ClassMethod Add2PrintList(AMRPatientID As %String, ATotalAmount As %String, AActUserID As %String, AFootChargeStr As %String, APrintLogStr As %String, AItemStr As %String) As %String [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLMRPrintCharge).Add2PrintList(AMRPatientID,ATotalAmount,AActUserID,AFootChargeStr,APrintLogStr,AItemStr)
	q ret
}

ClassMethod SavePrintListPrintLogOnly(AMRPrintChargeID As %String, APrintUserID As %String) As %String [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLMRPrintCharge).SavePrintListPrintLogOnly(AMRPrintChargeID,APrintUserID)
	q ret
}

ClassMethod SetPrintListCancel(AMRPrintChargeID As %String, ACancelUserID As %String) As %String [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLMRPrintCharge).SetPrintListCancel(AMRPrintChargeID,ACancelUserID)
	q ret
}

ClassMethod RePrintInvoice(AMRPrintChargeID As %String, ANewInvoiceNo As %String, AActUserID As %String) As %String [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLMRPrintInvoice).RePrintInvoice(AMRPrintChargeID,ANewInvoiceNo,AActUserID)
	q ret
}

ClassMethod GetDailyChargeTotal(AStartDate As %String, AEndDate As %String, AUserID As %String = "") As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRPrintCharge:GetDailyChargeTotal")
	d obj.SetArgs(AStartDate,AEndDate,AUserID)
	q obj
}

ClassMethod GetCharge4Receipt(AMREpisodeID As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRPrintCharge:GetCharge4Receipt")
	d obj.SetArgs(AMREpisodeID)
	q obj
}

ClassMethod GetDtlHospital(AMedRecordNo As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMRPrintCharge).GetDtlHospital(AMedRecordNo)
}

ClassMethod AddPrintApply(AEPrintApply As DHCEPRFS.Entity.EPrintApply) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMRPrintCharge).AddPrintApply(AEPrintApply)
}

ClassMethod GetPrintApplyByID(MrPatient As %String, applyDate As %String) As DHCEPRFS.Entity.EPrintApply [ WebMethod ]
{
	//q ##class(DHCEPRFS.BL.BLMRPrintCharge).GetPrintApplyByID(APrintApplyID)
	q ##class(DHCEPRFS.BL.BLMRPrintCharge).GetPrintApplyByDateAndID(MrPatient,applyDate)
}

ClassMethod GetPrintApplyHis(AMREpisodeID As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMRPrintCharge).GetPrintApplyHis(AMREpisodeID)
}

}
