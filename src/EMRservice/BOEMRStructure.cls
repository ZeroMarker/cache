/// 名称: 病历业务域BO层
/// 描述: 病历业务域BO层
/// 编写者：叶剑
/// 编写日期: 2020-5-13
Class EMRservice.BOEMRStructure Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EMRStructInfo";

ClassMethod GetAllCate() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLEMRStructure:SELECTALLCATE")
	d result.SetArgs()
	q result
}

ClassMethod SelectDocumentData() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLEMRStructure:SelectDocumentData")
	d result.SetArgs()
	q result
}

/// w ##Class(EMRservice.BOEMRStructure).SELECTALL("20")
ClassMethod GetStructPIDByTemplateID(tID As %String) As %String [ WebMethod ]
{
 
    s tmp = ##Class(EMRmeta.Template).%OpenId(tID)
    s Code=tmp.Code
    s parentID = ""
    s parentID=$O(^DHCEMRM.EMRStructureI("IdxCode", " "_$zcvt(Code,"U"), parentID))
	q parentID
}

/// 增加一个结构
ClassMethod CreateEMRStructure(aEMRStructureInfo As EMRservice.entity.EEMRStructure) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRStructure).CreateEMRStructure(aEMRStructureInfo)
}

/// 删除一个结构
ClassMethod DeleteEMRStructure(aEMRStructureId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRStructure).DeleteEMRStructure(aEMRStructureId)
}

/// 更新一个结构
ClassMethod UpdateEMRStructure(aTemStructureInfo As EMRservice.entity.EEMRStructure) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRStructure).UpdateEMRStructure(aTemStructureInfo)
}

/// w ##Class(EMRservice.BOEMRStructure).GetCodeIsExist("20")
ClassMethod GetCodeIsExist(aCode As %String, aID As %String) As %String [ WebMethod ]
{
	 q ##Class(EMRservice.BL.BLEMRStructure).GetCodeIsExist(aCode,aID)
}

}
