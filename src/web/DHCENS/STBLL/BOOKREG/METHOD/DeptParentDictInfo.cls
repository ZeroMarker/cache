/// web.DHCENS.STBLL.Dict.Method.DeptDictInfo
/// 描述：查询HIS一级科室信息类方法
/// 编写者：WuXianPu
/// 编写日期：2011-06-18
Class web.DHCENS.STBLL.BOOKREG.METHOD.DeptParentDictInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2012—03-14
/// Description：得到全部科室信息
/// Table：
/// Input： 科室类型
/// Return：科室信息集合
/// Others: w ##class(web.DHCENS.STBLL.BOOKREG.METHOD.DeptParentDictInfo).GetLocParentInfo("")
ClassMethod GetLocParentInfo(type As %String) As %String
{
	s $ztrap="ErrorMsg"
	s soap=##class(web.DHCENS.STBLL.BOOKREG.SOAP.PUB0001Soap).%New()
	s request=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Request).%New()
	s header=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Header).%New()
	s header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID($h)
	s header.SourceSystem="02"
	s request.header=header
	s body=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Body).%New()
	s deptListObj=##class(web.DHCENS.STBLL.BOOKREG.MODEL.DeptInfoList).%New()
	s SuccessFlag="0"
	
	s XMLRequest="<Request><TradeCode>1014</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId></HospitalId><ExtUserID>3883</ExtUserID></Request>"
	s repObj=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryDepartmentGroup(XMLRequest)
	s DeptCount=repObj.RecordCount
	s deptListObj.TradeCode="T007"
	s deptListObj.DeptCount=DeptCount
	for i=1:1:DeptCount{
		s repChildObj=repObj.Departments.GetAt(i)
		s deptObj=##class(web.DHCENS.STBLL.BOOKREG.MODEL.DeptInfo).%New()
		s deptObj.DeptId=repChildObj.DepartmentRowId
		s deptObj.DeptCode=repChildObj.DepartmentCode
		s deptObj.DeptName=repChildObj.DepartmentName
		s deptObj.ParentId=repChildObj.ParentId
		s deptObj.Desc=repChildObj.Description
		d deptListObj.DeptInfo.Insert(deptObj)
	}
	s body.deptInfos=deptListObj
	s request.body=body
	d request.XMLExportToStream(.str)
	s soap.Timeout="60"
	;b ;lyh 1
	s RetStr=soap.SaveDictInfo("MES0010",str)
	d deptListObj.DeptInfo.Clear()
	s s=##class(%GlobalCharacterStream).%New()
	q RetStr.Read(RetStr.Size)
ErrorMsg
	q "-1^"_$ze
}

}
