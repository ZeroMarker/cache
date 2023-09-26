/// Desc: 病历查询
/// Creator:Candy
Class DHCEPRFS.Srv.SrvQuery Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvQuery";

ClassMethod QueryResultList(AMedRecordNo As %String, ADisDate As %String, AAdmDate As %String, AResult As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQuery:QueryResultList")
	d obj.SetArgs(AMedRecordNo,ADisDate,AAdmDate,AResult)
	q obj
}

/// Desc: 返回查询列表
/// Creator:Candy
/// Input:ACondition 查询条件
ClassMethod GetQueryData(ACondition As DHCEPRFS.Entity.EQuery) As %XML.DataSet [ WebMethod ]
{
	s MedNo = $case(ACondition.MedRecordNo,$c(0):"",:ACondition.MedRecordNo)
	s SDisDate = $case(ACondition.StartDisDate,$c(0):"",:ACondition.StartDisDate)
	s EDisDate = $case(ACondition.EndDisDate,$c(0):"",:ACondition.EndDisDate)
	s DisLocID = $case(ACondition.DisLocID,$c(0):"",:ACondition.DisLocID)
	s Conditions = ##Class(DHCEPRFS.BL.BLQuery).GetQueryItemFromXML(ACondition.Conditions)
	//s ResultColumns = ##Class(DHCEPRFS.BL.BLQuery).GetDataFromXML(ACondition.ResultColumns)
	//s ResultColumns = ##Class(DHCEPRFS.BL.BLQuery).GetListFromString(ResultColumns,",")
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQuery:ComplexQueryList")
	d obj.SetArgs(MedNo,SDisDate,EDisDate,DisLocID,Conditions,ACondition.ResultColumns)
	q obj
}

/// desc:获取ICD信息
/// input:code、icd描述、icd字母简写
/// ouput:icd列表
/// debug: d ##class(DHCEPRFS.Srv.SrvQuery).GetICDDXData("肝炎")
ClassMethod GetICDDXData(QueryText As %String) As DHCEPRFS.DataSet.EMRDiagnosICDDS [ WebMethod ]
{
	s result = ##class(DHCEPRFS.DataSet.EMRDiagnosICDDS).%New()
	d result.SetArgs(QueryText)
	q result
}

/// desc:获取手术信息
/// input:code、icd描述、icd字母简写
/// ouput:icd列表
/// debug: d ##class(DHCEPRFS.Srv.SrvQuery).GetOperationData("切")
ClassMethod GetOperationData(QueryText As %String) As DHCEPRFS.DataSet.EMROperationICDDS [ WebMethod ]
{
	s result = ##class(DHCEPRFS.DataSet.EMROperationICDDS).%New()
	d result.SetArgs(QueryText)
	q result
}

/// desc:获取麻醉方式信息
/// input:code、icd描述、icd字母简写
/// ouput:icd列表
/// debug: d ##class(DHCEPRFS.Srv.SrvQuery).GetOperationData("吸入")
ClassMethod GetAnesthesiaData(QueryText As %String) As DHCEPRFS.DataSet.EMRAnesthesiaDS [ WebMethod ]
{
	s result = ##class(DHCEPRFS.DataSet.EMRAnesthesiaDS).%New()
	d result.SetArgs(QueryText)
	q result
}

}
