/// 名称:	EMRservice.Ajax.BSBrowseCommon
/// 描述:	BS病历浏览公用程序层 Request数据请求代理
/// 编写者:	yejian
/// 编写日期: 	2022-1-5
/// 产品组：	电子病历产品组
Class EMRservice.Ajax.BSBrowseCommon Extends %CSP.Page
{

Parameter CONTENTTYPE = "text/plain;charset=UTF-8";

ClassMethod OnPreHTTP(ByRef OutputBody As %Boolean) As %Boolean
{
    if ##class(websys.Conversions).IsValidClassName("websys.Filter") 
	{
		d ##class(websys.Filter).InjectionFilter()
	}
 	q $$$OK
}

ClassMethod OnPage() As %Status
{
	d ..DoAction()
	q $$$OK
}

/// Debug: d ##Class(EMR.DOC.COM.RequestCommon).DoAction()
ClassMethod DoAction()
{
	s fileid = $i(^CandyFileName)
	s fileid = "httpInput\"_fileid
	s separator = "-----------------------------8eb5b37251gef"

	s inputStream = ##class(%GlobalBinaryStream).%New()
	s argInMessage = ##Class(%GlobalBinaryStream).%New()
	s argInData = ##Class(%GlobalBinaryStream).%New()
	s strMethod = %request.Method
	if (strMethod="POST")
	{
		d inputStream.CopyFrom(%request.Content)		
		s objJson = ##class(%DynamicAbstractObject).%FromJSON(inputStream)
		s data = objJson.content.data
		s strAction = objJson.askParam.action
		s strInstanceID = objJson.askParam.p1
		/* 
		//旧版数据(2016之前版本支持)
		s objJson = ##Class(EMRservice.BL.StreamDataTool).%New()  
		s argInParams = objJson.Deserialize(inputStream)
		s content = argInParams.GetAt("content")
		s askParam = argInParams.GetAt("askParam")
		//请求的数据
		s data = content.GetAt("data")
		s strAction = askParam.GetAt("action") 
		s strInstanceID = askParam.GetAt("p1") 
		*/
		//请求的数据

		
		s uriStr = ##class(web.Util.Encryption).Base64Decode(data)
		s uriStr = $replace(uriStr,"+","%2B")
		s strData =$zcvt(uriStr,"I","URL")
		s objJson=""
		d argInData.Write(strData)
		s strInstanceID = $REPLACE(strInstanceID,"_","||")
		s strMessage = "{""action"":"""_strAction_""",""p1"":"""_strInstanceID_"""}"
		;s:("1734680||1"=strInstanceID) ^TempHtmlData(strInstanceID)=strMessage
		d argInMessage.Write(strMessage)
	}
	else 
	{
		s strParam = $Get(%request.Data("paramdata",1),"")
		d argInMessage.Write(strParam)
	}
	/*
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="d:\"_fileid_"-01-docInput.xml"
	d AStream.CopyFrom(inputStream)
	d AStream.SaveStream()
	d AStream.%Close()
	d inputStream.Rewind()
	*/
	///////////////////////////////////////////////////////////////////////
	
	s argOutMessage = ##class(%GlobalBinaryStream).%New()
	s argOutData = ##Class(%GlobalBinaryStream).%New()
	d ##Class(EMRservice.BL.ActionBSBrowseFactory).AcitonProxy(argInMessage,argInData,argOutMessage,argOutData)	
  
    d argOutData.Rewind()
	while (argOutData.AtEnd = 0)
	{
		w $ZSTRIP(argOutData.Read(32000),"*C",,$c(1)_$c(2))
	}

	/*
	////////////////////日志调试/////////////////////////////	
	d argOutData.Rewind()
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="d:\"_fileid_"-03-docInput.xml"
	d AStream.CopyFrom(outParam)
	d AStream.SaveStream()
	d AStream.%Close()
	///////////////////////////////////////////////////////////
 	*/
 	q $$$OK
}

}
