Class web.DHCENS.STBLL.BOOKREG.METHOD.DoctorDictInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2012—03-14
/// Description：得到全部出诊医生信息
/// Table：
/// Input： 
/// Return：出诊医生信息
/// Others: w ##class(web.DHCENS.STBLL.BOOKREG.METHOD.DoctorDictInfo).GetScheduleDoctorInfo("")
ClassMethod GetScheduleDoctorInfo(Input As %String = "") As %String
{
	s $ztrap="ErrorMsg"
	s soap=##class(web.DHCENS.STBLL.BOOKREG.SOAP.PUB0001Soap).%New()
	s request=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Request).%New()
	s header=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Header).%New()
	s header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID($h)
	s header.SourceSystem="02"
	s request.header=header
	s body=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Body).%New()
	s docListObj=##class(web.DHCENS.STBLL.BOOKREG.MODEL.DoctorInfoList).%New()
	s SuccessFlag="0"
	
	s DocXMLRequest="<Request><TradeCode>1013</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID></ExtUserID><DepartmentCode></DepartmentCode></Request>"
	s repDocObj=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryDoctor(DocXMLRequest)
	s DoctorCount=repDocObj.Doctors.Count()
	for i=1:1:DoctorCount{
		s repChildDocObj=repDocObj.Doctors.GetAt(i)
		s docObj=##class(web.DHCENS.STBLL.BOOKREG.MODEL.DoctorInfo).%New()
		s docObj.DoctorId=repChildDocObj.DoctorId
		s docObj.DoctorCode=repChildDocObj.DoctorCode
		s docObj.DoctorName=repChildDocObj.DoctorName
		s docObj.DeptId=repChildDocObj.DeptId
		s docObj.DeptCode=repChildDocObj.DeptCode
		s docObj.DeptName=repChildDocObj.DeptName
		s docObj.Title=repChildDocObj.DoctorLevel
		d docListObj.DoctorInfo.Insert(docObj)
	}
	s docListObj.DoctorCount=DoctorCount
	s docListObj.TradeCode="T006"
	s body.doctorInfos=docListObj
	s request.body=body
	d request.XMLExportToStream(.str)
	s soap.Timeout="60"
	b ;lyh 1
	s RetStr=soap.SaveDictInfo("MES0005",str)
	d docListObj.DoctorInfo.Clear()
	s result=$p(RetStr.Read(),"^",1)
	q result
ErrorMsg
	Quit "-1^"_$ze
}

}
