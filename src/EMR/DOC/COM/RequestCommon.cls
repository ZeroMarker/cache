/// 名称:	EMR.DOC.COM.AjaxCommon
/// 描述:	通用文档管理模块 Document(Doc) 公用程序层 Request数据请求代理
/// 编写者:	yejian
/// 编写日期: 	2020-12-7
/// 产品组：	电子病历产品组
Class EMR.DOC.COM.RequestCommon Extends %CSP.Page
{

Parameter CONTENTTYPE = "text/plain;charset=UTF-8";

Parameter UseSession As BOOLEAN = 0;

/// 不占session
ClassMethod OnPreHTTP(ByRef OutputBody As %Boolean) As %Boolean
{
    /*星号表示所有的域都可以接受，*/
    Do %response.SetHeader("Access-Control-Allow-Origin","*")
    Do %response.SetHeader("Access-Control-Allow-Methods","GET,POST")
    Do %response.SetHeader("Access-Control-Allow-Headers","x-requested-with,content-type")
   	//Do %response.SetHeader("Access-Control-Allow-Headers","x-requested-with,content-type")
    //Do %response.SetHeader("Content-Type","application/pdf")
    //Do %response.SetHeader("Access-Control-Allow-Headers","accept,x-requested-with,Content-type,X-Custom-Header")
    Do %response.SetHeader("Access-Control-Allow-Credentials","true")
    
    Quit 1
}

ClassMethod OnPage() As %Status
{
	d ..DoAction()
	Quit $$$OK
}

/// Debug: d ##Class(EMR.DOC.COM.RequestCommon).DoAction()
ClassMethod DoAction()
{
	s fileid = $i(^CandyFileName)
	//s fileid = "httpInput\"_fileid
	//s key = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("DECRYPTKEY")
	//s key = "lacideMi"_key
	//s keyLen = $l(key)*1000
	s separator = "-----------------------------8eb5b37251gef"

	s inputStream = ##class(%GlobalBinaryStream).%New()
	//s namekey = $o(%request.MimeData(""))
	//d inputStream.CopyFrom(%request.MimeData(namekey,1))
	//s ^InputToolMessageService(1) = %request.Method _"1^"_ %request.Content_"2^"_ $Get(%request.Data("paramdata",1),"")
	
	s strMethod = %request.Method
	
	if (strMethod="POST")
	{
		d inputStream.CopyFrom(%request.Content)
		if (inputStream.Size<=0)
		{
			s strParam = $Get(%request.Data("paramdata",1),"")
			d inputStream.Write(strParam)	
		}
	}
	else 
	{
		s strParam = $Get(%request.Data("paramdata",1),"")
		d inputStream.Write(strParam)
	}
	
	///////////////////////写日志调试//////////////////////////////////////
    /*
    s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="d:\"_fileid_"docInput.xml"
	d AStream.CopyFrom(inputStream)
	d AStream.SaveStream()
	d AStream.%Close()
	d inputStream.Rewind()
	*/
	///////////////////////////////////////////////////////////////////////
	
	
	s argInMessage = ##Class(%GlobalBinaryStream).%New()
	s argInData = ##Class(%GlobalBinaryStream).%New()
	s argInData = ##Class(EMR.DOC.COM.Parser.StreamData).GetFirstParserStream(inputStream,.separator,.argInMessage)
	s argOutMessage = ##class(%DynamicObject).%New()
	s argOutData = ##Class(%GlobalBinaryStream).%New()
	d ##Class(EMR.DOC.COM.AbstractActionFactory).CreateActionFactory(argInMessage,argInData,argOutMessage,argOutData)
	s outParam = ##Class(%GlobalBinaryStream).%New()
	s argOutMessageStream = ##Class(%GlobalBinaryStream).%New()
	d argOutMessage.%ToJSON(argOutMessageStream)
	s size = argOutMessageStream.Size
	s argOutMessageString = argOutMessageStream.Read(size-1)
	d outParam.Write(argOutMessageString)
	d outParam.Write(",""data"":")
	if (argOutData.IsNull()="1"){
			d outParam.Write("""""")
	}else{
			d outParam.CopyFrom(argOutData)
	}
	d outParam.Write("}")
	
  
    d outParam.Rewind()
	while (outParam.AtEnd = 0)
	{
		s tmpOut = outParam.Read(32000)
		//s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
		//w tmpUtf8
		//w ##Class(web.Util.Encryption).Byte2Hex(tmpOut)
		w tmpOut
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

 	
	Quit $$$OK
}

/// 加密
ClassMethod SimpleEncrypt(Src, Key = "IMedical")
{
	Quit:Src="" ""
	Quit:Key="" ""
	Set rtn = ""
	Set KeyLen = $l(Key)
	Set SrcKey = Key
	//if ($l(Src) # KeyLen)'=0 b "s"
	Set Count = $system.SQL.CEILING($l(Src)/KeyLen)
	For i=1:1:Count-1{ Set SrcKey = SrcKey_Key }
	Set rtn = $zb(Src,SrcKey,6) 
	Set rtn = ##Class(web.Util.Encryption).Byte2Hex(rtn)
	Quit rtn
}

/// 解密
ClassMethod SimpleDecrypt(EncStr, Key = "IMedical")
{
	Quit:EncStr="" ""
	Quit:Key="" ""
	Set rtn=""
	Set EncStr = ##Class(web.Util.Encryption).Hex2Byte(EncStr)
	Set KeyLen = $l(Key)
	Set EncKey = Key
	Set Count = $system.SQL.CEILING($l(EncStr)/KeyLen)
	For i=1:1:Count-1{ Set EncKey = EncKey_Key}
	Set rtn = $zb(EncStr,EncKey,6) 
	Quit rtn
}

}
