Class EMRservice.BOModelInstanceData Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ModelInstanceData";

Query GetModelInstanceByTmpl(ATemplateID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String") [ WebMethod ]
{
	SELECT ID, Name
	FROM EMRmeta.ModelInstanceData
	WHERE TemplateID = :ATemplateID
}

/// w ##class(EMRservice.BOModelInstanceData).GetTemplateContent(44)
ClassMethod GetTemplateContent(ATemplateID As %String) As %GlobalBinaryStream [ WebMethod ]
{
	s result = ""		
    q:(ATemplateID = "") result 
    
    s version = $O(^DHCEMRM.TemplateVersionI("IndexTemplateVersion", " "_ATemplateID, ""), -1)
    q:(version="") result
    s versionId = $O(^DHCEMRM.TemplateVersionI("IndexTemplateVersion", " "_ATemplateID, version, ""))
    s objTemplateVersion = ##Class(EMRmeta.TemplateVersion).%OpenId(versionId)
    q:(objTemplateVersion = "") result
    
    s objMetaData = ##class(%GlobalBinaryStream).%New()
    s objScriptData = ##Class(%GlobalBinaryStream).%New()
    s objInstanceData = ##class(%GlobalBinaryStream).%New()
    s objMediaData = ##Class(%GlobalBinaryStream).%New()
    d objMetaData.CopyFrom(objTemplateVersion.MetaData)  	
    d objScriptData.CopyFrom(objTemplateVersion.ScriptData) 
    d objInstanceData.CopyFrom(objTemplateVersion.PresentationData)	
    d objMediaData.CopyFrom(objTemplateVersion.MediasData) 
    s TemplateID = objTemplateVersion.TemplateID
    s elementType = "Template"
    
    s result = ##Class(EMRservice.BL.BLTemplate).GetRecordXML(TemplateID,elementType,"","",objMetaData,objScriptData,objInstanceData,objMediaData)
	
	q result
}

/// w ##class(EMRservice.BOModelInstanceData).GetModelInstanceContent(103)
ClassMethod GetModelInstanceContent(AModelID As %String) As %GlobalBinaryStream [ WebMethod ]
{
    s result = ""		
    q:(AModelID = "") result
    //d AOutMessage.Write("[")
    s obj = ##Class(EMRmeta.ModelInstanceData).%OpenId(AModelID) 
	q:(obj = "") result
	
	s result = ##class(EMRservice.BL.ModelInstanceData).GetRecordXML(obj.TemplateID,"Document",obj.Title,obj.TitleCode,obj.InstanceMetaData,obj.InstanceScriptData,obj.InstanceData,obj.InstanceMedia)
	q result
}

ClassMethod UpdateModelDocument(ModelID As %String, AUserID As %String, AStream As %GlobalBinaryStream) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.ModelInstanceData).UpdateModelDocument(ModelID,  AUserID, AStream)
}

Query GetModelInstanceIDs() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String") [ WebMethod ]
{
	SELECT ID
	FROM EMRmeta.ModelInstanceData
}

ClassMethod GetInstanceMetaData(id As %String) As %GlobalBinaryStream [ WebMethod ]
{
	s obj = ##Class(EMRmeta.ModelInstanceData).%OpenId(id)
	q obj.InstanceMetaData
}

ClassMethod GetInstanceData(id As %String) As %GlobalBinaryStream [ WebMethod ]
{
	s obj = ##Class(EMRmeta.ModelInstanceData).%OpenId(id)
	q obj.InstanceData
}

ClassMethod UpdateInstanceMetaData(id As %String, streamInstanceData As %GlobalBinaryStream) [ WebMethod ]
{
	s obj = ##Class(EMRmeta.ModelInstanceData).%OpenId(id)
	d obj.InstanceMetaData.CopyFrom(streamInstanceData)
	d obj.%Save()
}

ClassMethod UpdateInstanceData(id As %String, streamInstanceData As %GlobalBinaryStream) [ WebMethod ]
{
	s obj = ##Class(EMRmeta.ModelInstanceData).%OpenId(id)
	d obj.InstanceData.CopyFrom(streamInstanceData) 
	d obj.%Save()
}

/// debug w ##class(EMRservice.BOModelInstanceData).GetTemplateData(103)
ClassMethod GetTemplateData(id As %String) As %GlobalBinaryStream [ WebMethod ]
{
	s resStream = ##class(%GlobalBinaryStream).%New()
	s objTem = ##class(EMRmeta.Template).%OpenId(id)
	q:(objTem="") resStream
	s temVersionNum = $case(objTem.PublishVersion,0:objTem.LastVersion,:objTem.PublishVersion)	
	s strVid =$o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_id,temVersionNum,""))
	q:(strVid="") resStream
	s obj = ##Class(EMRmeta.TemplateVersion).%OpenId(strVid)
	q obj.PresentationData
}

ClassMethod UpTempalteData(id As %String, streamInstanceData As %GlobalBinaryStream) [ WebMethod ]
{
	s objTem = ##class(EMRmeta.Template).%OpenId(id)
	q:(objTem="")
	s temVersionNum = $case(objTem.PublishVersion,0:objTem.LastVersion,:objTem.PublishVersion)
	s strVid =$o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_id,temVersionNum,""))
	q:(strVid="")
	s obj = ##Class(EMRmeta.TemplateVersion).%OpenId(strVid)
	d obj.PresentationData.CopyFrom(streamInstanceData)
	d obj.%Save()
}

}
