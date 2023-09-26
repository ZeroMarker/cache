Class DHCEPRFS.Srv.SrvQualityReport Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvQualityReport";

/// Desc: 按科室统计逾期时间内医生提交、护士提交情况
/// Input: AStartDate: 起始出院日期, AEndDate: 截止出院日期, ACTLocIDS: 科室ID, AOverdueTimeSpan: 逾期时间
ClassMethod GetReceiptListByDept(AStartDate As %String, AEndDate As %String, ACTLocIDS As %String, AOverdueTimeSpan As %String) As DHCEPRFS.DataSet.EReceiptListByDeptDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EReceiptListByDeptDS).%New()
	d dataset.SetArgs(AStartDate,AEndDate,ACTLocIDS,AOverdueTimeSpan)
	q dataset
}

/// Desc: 逾期时间内科室提交详细信息
/// Input: AStartDate: 起始出院日期, AEndDate: 截止出院日期, ACTLocIDS: 科室ID, AOverdueTimeSpan: 逾期时间
ClassMethod GetReceiptDtlByDept(AStartDate As %String, AEndDate As %String, ACTLocIDS As %String, AOverdueTimeSpan As %String, ADocPromptFlag As %String, ANurPromptFlag As %String) As DHCEPRFS.DataSet.EReceiptDtlByDeptDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EReceiptDtlByDeptDS).%New()
	d dataset.SetArgs(AStartDate,AEndDate,ACTLocIDS,AOverdueTimeSpan,ADocPromptFlag,ANurPromptFlag)
	q dataset
}

/// Desc: 医疗单元逾期提交详细信息
/// Input: AStartDate: 起始出院日期, AEndDate: 截止出院日期, ACTLocIDS: 科室ID, AOverdueTimeSpan: 逾期时间
ClassMethod GetOverdueDtlByCTMU(AStartDate As %String, AEndDate As %String, ACTLocID As %String, ACTMUID As %String, AOverdueTimeSpan As %String) As DHCEPRFS.DataSet.EOverdueDtlByCTMUDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EOverdueDtlByCTMUDS).%New()
	d dataset.SetArgs(AStartDate,AEndDate,ACTLocID,ACTMUID,AOverdueTimeSpan)
	q dataset
}

/// Desc: 按科室统计逾期时间内病历退回情况
/// Input: AStartDate: 起始出院日期, AEndDate: 截止出院日期, ACTLocIDS: 科室ID, AOverdueTimeSpan: 逾期时间
ClassMethod GetQCBackListByDept(AStartDate As %String, AEndDate As %String, ACTLocIDS As %String, AOverdueTimeSpan As %String) As DHCEPRFS.DataSet.EQCBackListByDeptDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EQCBackListByDeptDS).%New()
	d dataset.SetArgs(AStartDate,AEndDate,ACTLocIDS,AOverdueTimeSpan)
	q dataset
}

/// Desc: 逾期时间内病历退回详细信息
/// Input: AStartDate: 起始出院日期, AEndDate: 截止出院日期, ACTLocIDS: 科室ID, AOverdueTimeSpan: 逾期时间
ClassMethod GetQCBackDtlByDept(AStartDate As %String, AEndDate As %String, ACTLocIDS As %String, AOverdueTimeSpan As %String, ADeptBackFlag As %String, AQCBackFlag As %String, AMRBackFlag As %String) As DHCEPRFS.DataSet.EQCBackDtlByDeptDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EQCBackDtlByDeptDS).%New()
	d dataset.SetArgs(AStartDate,AEndDate,ACTLocIDS,AOverdueTimeSpan,ADeptBackFlag,AQCBackFlag,AMRBackFlag)
	q dataset
}

/// Desc:查询表日志信息
ClassMethod GetMedUnitByCTLocID(ACTLocID As %String) As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.HISInfo.BLHISInfo:GetMedUnitByCTLocID")
	d ds.SetArgs(ACTLocID)
	q ds
}

/// Desc: 按就诊表出院日期统计归档迟交信息
/// Input: AStartDate: 起始出院日期, AEndDate: 截止出院日期, ALocID: 科室ID
ClassMethod GetMRArchiveLateByAdm(AStartDate As %String, AEndDate As %String, ALocID As %String) As DHCEPRFS.DataSet.EMRArchiveLateByAdmDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EMRArchiveLateByAdmDS).%New()
	d dataset.SetArgs(AStartDate,AEndDate,ALocID)
	q dataset
}

/// Desc: 按就诊表出院日期统计中心科室、二级科室归档迟交详细信息
/// Input: AStartDate: 起始出院日期, AEndDate: 截止出院日期, ALocDepDR: 科室部门组ID, ALocID: 科室ID
ClassMethod GetMRArchiveLateDetail(AStartDate As %String, AEndDate As %String, ALocDepDR As %String, ALocID As %String) As DHCEPRFS.DataSet.EMRArchiveLateDetailDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EMRArchiveLateDetailDS).%New()
	d dataset.SetArgs(AStartDate,AEndDate,ALocDepDR,ALocID)
	q dataset
}

}
