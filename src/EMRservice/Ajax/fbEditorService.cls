Class EMRservice.Ajax.fbEditorService Extends %CSP.Page
{

/// 不能使用common类，stream在@stream解析时，无法将流数据传到后面的函数中。
/// 但，之前在其他项目上流数据可以正常传到。推测可能与cache版本或配置有关。
ClassMethod OnPage() As %Status
{
	
	s instanceID = $Get(%request.Data("AInstanceID",1),"")
	s documentStream = $Get(%request.Data("ADocumentStream",1),"")
	s action = $Get(%request.Data("Action",1),"")
	

		
	if (action="SaveDocument")
	{
		s result = ..SaveDocumentFromFile(instanceID,documentStream)
	}
	if (action = "GetDocument")
	{
		s result = ..GetDocumentToFile(instanceID)
	}
	

	while (result.AtEnd = 0)
	{
       	w $zcvt(result.Read(32000),"I","UTF8")
    }
	
	Quit $$$OK
}

/// w ##Class(EMRservice.Tools.DailyWorkTool).SaveDocumentFromFile("4084||1",file)
ClassMethod SaveDocumentFromFile(AInstanceID As %String, streamInput As %GlobalCharacterStream) As %Stream
{
	s argOutData = ##class(%FileBinaryStream).%New() 
	
	s saveinstanceobj=##class(EMRinstance.InstanceData).%OpenId(AInstanceID) 
	s userid=saveinstanceobj.CreateUser
	s title=saveinstanceobj.Title
	s titlecode=saveinstanceobj.TitleCode
	//验证文件长度
	s id = streamInput
	if ($f($e(id,1,50),"Stream") = 0)
	{
		s stream = ##class(%GlobalBinaryStream).%New()
		d stream.Write($zcvt(streamInput,"O","UTF8"))
	}
	else
	{
		s stream = ##class(%GlobalBinaryStream).%New()
		
		// utf8 bom 兼容首位补特殊字符
		//d stream.Write($c(65279))
		while (streamInput.AtEnd = 0)
        {
        	d stream.Write($zcvt(streamInput.Read(32000),"O","UTF8"))
        	
        	
        }
	}
	
	
	q:(userid="") -1
	s saveinstanceobj=""
 
	s status= ##Class(EMRservice.BL.BLInstanceData).SaveDoucment(AInstanceID,userid,stream, title,titlecode,"")
	
	d argOutData.Write(status)
	
	q argOutData
}

/// w ##Class(EMRservice.Tools.DailyWorkTool).GetDocumentToFile("19||3")
ClassMethod GetDocumentToFile(AInstanceID As %String) As %Stream
{


	s argOutData = ##class(%FileBinaryStream).%New() 

	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	
	d argOutData.CopyFrom(##Class(EMRservice.BL.BLTemplate).GetRecordXML(objInstance.RealTemplateID,"Document",objInstance.Title,objInstance.TitleCode,objInstance.InstanceMetaData,objInstance.InstanceScriptData,objInstance.InstanceData,objInstance.InstanceMedia,objInstance.InstanceInitialData))
	
	q argOutData
}

}
