/// Desc:从其它产品组创建病历，关联逻辑类
/// Creator:Candy
/// CreateDate:2019-1-15
Class EMRservice.BL.BLInstanceLinkProduct Extends %RegisteredObject
{

/// Desc:从其它产品组创建病历，存储关联关系
/// Creator:Candy
/// CreateDate:2019-1-15
ClassMethod SetData(AFromType As %String, AFromCode As %String, AInstanceID As %String, AUserID As %String) As %String
{
	s result = ""
	q:(AFromType = "")||(AFromCode = "")||(AInstanceID = "") result
	s obj = ##class(EMRinstance.InstanceLinkProduct).%New()
	s obj.FromCode = AFromCode
	s obj.FromType = AFromType
	s obj.InstanceID = AInstanceID
	s obj.UserID = AUserID
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = obj.%Id()
	d ..InvokInterface(AFromType,AFromCode,AInstanceID,AUserID)
	q result
}

/// Desc:删除病历时清空其它产品组ID与InstanceID关系
/// Creator:Candy
/// CreateDate:2019-1-15
ClassMethod DeleteData(AInstanceID As %String, AUserID As %String)
{
	q:(AInstanceID = "")
	s id = $o(^DHCEMRI.LinkProductI("IdxInstanceID"," "_AInstanceID,""))
	q:(id = "")
	s objLink = ##class(EMRinstance.InstanceLinkProduct).%OpenId(id)
	q:(objLink = "")
	s AFromType = objLink.FromType
	s AFromCode = objLink.FromCode
	d ..InvokInterface(AFromType,AFromCode,"",AUserID)
}

/// Desc:调用接口，将病历ID传回
/// Creator:Candy
/// CreateDate:2019-1-15
/// Input: AFromType 产品来源类型
///        AFromCode 关联产品ID
///        AInstanceID 关联病历ID
ClassMethod InvokInterface(AFromType As %String, AFromCode As %String, AInstanceID As %String, AUserID As %String) As %String
{
	if ($zcvt(AFromType,"U") = "CRITICAL")
	{
		q:(##class(%Dictionary.CompiledClass).%ExistsId("web.DHCAntCVReportLink") = "0")
		q:(##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCAntCVReportLink||SaveTransEMR") = "0")
		d ##class(web.DHCAntCVReportLink).SaveTransEMR(AFromCode,AInstanceID,AUserID)
	}
	elseif ($zcvt(AFromType,"U") = "CONSULTATION")
	{
		q:(##class(%Dictionary.CompiledClass).%ExistsId("web.DHCMDTInterface") = "0")
		q:(##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCMDTInterface||UpdMedHisInstanceId") = "0")
		d ##class(web.DHCMDTInterface).UpdMedHisInstanceId(AFromCode,AInstanceID,AUserID)
	}
}

}
