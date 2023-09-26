Class web.DHCENS.STBLL.DOCU.METHOD.MOHDocument Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.DOCU.METHOD.MOHDocument).MOHDocument("9090257^C0052^9053096||1413")
/// w ##class(web.DHCENS.EnsHISService).DHCHisInterfaceV8("S00000038","9090257","WEB00000021","C0052","9053096||1413")
ClassMethod MOHDocument(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DOCU.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.DOCU.MODEL.Header).%New()

	set admRowId=$p(Input,"^",1)
	set typeCode=$p(Input,"^",2)
	set businId=$p(Input,"^",3)
	set AdmDeptRowID=$p($g(^PAADM(admRowId)),"^",4)	
	// 取院区
	set HospCode="",hospId=""
	set:AdmDeptRowID'="" hospId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
	set:hospId="" hospId=$o(^CT("HOSP","0"))
	set:hospId'="" header.SourceSystem=$p($g(^CT("HOSP",hospId)),"^",1)
	set header.TargetSystem="医院信息平台"
	set request.header=header
	
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	set PAPATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	set PAPATDEName=$p($g(^PAPER(patRowId,"ALL")),"^",1)
		
	set body=##class(web.DHCENS.STBLL.DOCU.MODEL.Body).%New()
	set obj=##class(web.DHCENS.STBLL.DOCU.MODEL.MOHDocument).%New()	
	set MOHDSerialNumber=patRowId_admRowId_typeCode_businId
	set identityCardID=$p($g(^PAPER(patRowId,"ALL")),"^",9)
	set obj.MOHDSerialNumber=MOHDSerialNumber 
	set obj.MOHDPatientID=PAPATPatientID
	set obj.MOHDPatientName=PAPATDEName
	set obj.MOHDVisitNumber=admRowId	
	set obj.MOHDIdentityCardID=identityCardID	
	set obj.MOHDHealthCardID=identityCardID
	set obj.MOHDOrganId="ORG0000005"
	set obj.MOHDOrganName="宁夏医科大学总医院"
	set obj.MOHDTypeCode=typeCode	
	set obj.MOHDUpdateUserCode="宁医总院"
	set obj.MOHDUrl=""
	set obj.MOHDVersionNumber=""
	set obj.MOHDFlag=""	
	d body.mohDocuments.Insert(obj)				
	set request.body=body
	d request.XMLExportToStream(.stream)
	Quit stream
Exception
	Quit "-1^"_$ze
}

/// 获取文档概要信息
/// w ##class(web.DHCENS.STBLL.DOCU.METHOD.MOHDocument).HOSAbstractDocument("0000141513^935568^C0002^935568")
ClassMethod HOSAbstractDocument(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DOCU.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.DOCU.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header

	set body=##class(web.DHCENS.STBLL.DOCU.MODEL.Body).%New()
	set obj=##class(web.DHCENS.STBLL.DOCU.MODEL.HOSDocument).%New()
	
	set obj.OrganizationCode="ORG0000005"
	set obj.PATPatientID=$p(Input,"^",1)
	set obj.PAADMVisitNumber=$p(Input,"^",2)
	set obj.OEORIOrderItemID=""
	//类型
	set obj.DocumentType=$p(Input,"^",3)
	set obj.DocumentID=$p(Input,"^",4)
	//pdf路径
	set obj.DocumentPath=""
	set obj.UpdateUserCode="-"
	set obj.UpdateDate=$zd(+$h,3)
	set obj.UpdateTime=$zt($p($h,",",2),3)
	d body.hosDocuments.Insert(obj)
	set request.body=body
	d request.XMLExportToStream(.stream)
	Quit stream
Exception
	Quit "-1^"_$ze
}

}
