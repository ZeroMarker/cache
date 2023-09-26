Class EMRservice.BOTemplateStructure Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplateStructInfo";

ClassMethod GetAllCate() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLTemplateStructure:SELECTALLCATE")
	d result.SetArgs()
	q result
}

ClassMethod SelectDocumentData() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLTemplateStructure:SelectDocumentData")
	d result.SetArgs()
	q result
}

/// w ##Class(EMRservice.BOTemplateStructure).SELECTALL("20")
ClassMethod GetSectionByTemplateCode(tCode As %String) As %XML.DataSet [ WebMethod ]
{
 	s obj = ##Class(%XML.DataSet).%New("EMRservice.BL.BLTemplateStructure:SelectDocumentByCode")
	d obj.SetArgs(tCode)
	q obj
}

/// w ##Class(EMRservice.BOTemplateStructure).SELECTALL("20")
ClassMethod GetStructPIDByTemplateID(tID As %String) As %String [ WebMethod ]
{
 
    s tmp = ##Class(EMRmeta.Template).%OpenId(tID)
    s Code=tmp.Code
    s parentID = ""
    s parentID=$O(^DHCEMRM.TemplateStructureI("IdxCode", " "_$zcvt(Code,"U"), parentID))
	q parentID
}

ClassMethod GetSectionByParentID(parentID As %String) As %XML.DataSet [ WebMethod ]
{
 
 	s obj = ##Class(%XML.DataSet).%New("EMRservice.BL.BLTemplateStructure:SELECTALLSECTION")
	d obj.SetArgs(parentID)
	q obj
}

/// 增加一个章节
ClassMethod CreateTemplateStructure(aTemplateStructureInfo As EMRservice.entity.ETemplateStructure) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateStructure).CreateTemplateStructure(aTemplateStructureInfo)
}

/// 删除一个章节
ClassMethod DeleteTemplateStructure(aTemplateStructureId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateStructure).DeleteTemplateStructure(aTemplateStructureId)
}

/// 更新一个章节
ClassMethod UpdateTemplateStructure(aTemStructureInfo As EMRservice.entity.ETemplateStructure) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateStructure).UpdateTemplateStructure(aTemStructureInfo)
}

/// 根据ID获取母板信息
ClassMethod GetmetaTemplateByID(ByRef AOutRecords As %GlobalBinaryStream, ATemplateStructureId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateStructure).LoadmetaTemplate(.AOutRecords,ATemplateStructureId)
}

/// 根据ID获取母板信息
ClassMethod SavemetaTemplateByID(AMetaRecords As %GlobalBinaryStream, ATemplateStructureId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateStructure).SaveTemplateStructure(AMetaRecords,ATemplateStructureId)
}

}
