Class DHCEPRRBAC.Srv.SrvAdvancedSecurity Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprrbacservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvAdvancedSecurity";

/// Desc:	查询病人列表
/// Input：	AParam:PatientID^PatientName^LocID^Ward^AdmNo^RegNo^MedRecordNo
/// Debug：	w ##class(DHCEPRRBAC.Srv.SrvAdvancedSecurity).GetPatientList("^^^^^01616390")
ClassMethod GetPatientList(AParam As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRRBAC.BL.BLFSAuthorization:GetPatientList")
	d obj.SetArgs(AParam)
	q obj
}

/// Desc:	查询已加入特殊病历病人列表
/// Input：	
/// Debug：	w ##class(DHCEPRRBAC.Srv.SrvAdvancedSecurity).GetASecurityList()
ClassMethod GetASecurityList() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRRBAC.BL.BLAdvancedSecurity:GetASecurityList")
	d obj.SetArgs()
	q obj
}

/// Desc: 将封存病历添加到特殊病历就诊
/// Debug: w ##class(DHCEPRRBAC.Srv.SrvAdvancedSecurity).Add("DHC","582","2776",)
ClassMethod AddSpcl(ASysCode As %String, AEpisodeID As %String, AUserID As %String, AType As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRRBAC.BL.BLAdvancedSecurity).AddSpcl(ASysCode,AEpisodeID,AUserID,AType)
	q ret
}

/// Desc: 删除特殊病历就诊
/// Debug: w ##class(DHCEPRRBAC.Srv.SrvAdvancedSecurity).Remove("DHC","582","2776")
ClassMethod RemoveSpcl(ASysCode As %String, AEpisodeID As %String, AUserID As %String, AType As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRRBAC.BL.BLAdvancedSecurity).RemoveSpcl(ASysCode,AEpisodeID,AUserID,AType)
	q ret
}

ClassMethod GetAllASType() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRRBAC.BL.BLAdvancedSecurity:GetAllASType")
	d obj.SetArgs()
	q obj
}

}
