Class EMRservice.Ajax.MessageServer Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	d ..DoAction()
	Quit $$$OK
}

/// Debug: d ##Class(EMRservice.Ajax.MessageServer).DoAction()
ClassMethod DoAction()
{
	s fileid = $i(^CandyFileName)
	s separator = "-----------------------------8eb5b37251gef"
		

	s inputStream = ##class(%GlobalBinaryStream).%New()
	s namekey = $o(%request.MimeData(""))
	d inputStream.CopyFrom(%request.MimeData(namekey,1))
	
	/*
	///////////////////////写日志调试//////////////////////////////////////
    s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="D:\emrlog\"_fileid_"-01-encrytion-MimeData.xml"
	d AStream.CopyFrom(inputStream)
	d AStream.SaveStream()
	d AStream.%Close()
	//////////////////////////////////////////////////////////////////////
	*/
	s argInMessage = ##Class(%GlobalBinaryStream).%New()
	s argInData = ##Class(%GlobalBinaryStream).%New()
	s tmpInput = ##Class(EMRservice.Parser.StreamData).GetFirstParserStream(inputStream,separator,argInMessage)
	s tmpInput = ##Class(EMRservice.Parser.StreamData).GetFirstParserStream(tmpInput,separator,argInData)
	s argOutMessage = ##Class(%GlobalBinaryStream).%New()
	s argOutData = ##Class(%GlobalBinaryStream).%New()
	d ##Class(EMRservice.BOAbstractActionFactory).CreateActionFactory(argInMessage,argInData,argOutMessage,argOutData)
	s outParam = ##Class(%GlobalBinaryStream).%New()
	d outParam.CopyFrom(argOutMessage)
	d outParam.Write(separator)
	d outParam.CopyFrom(argOutData)
	
	d outParam.Rewind()
	while (outParam.AtEnd = 0)
	{
		s tmpOut = outParam.Read(32000)
		//s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
		//w tmpUtf8
		w ##Class(web.Util.Encryption).Byte2Hex(tmpOut)
	}
	/*
	////////////////////日志调试/////////////////////////////	
	d argOutData.Rewind()
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="D:\emrlog\"_fileid_"-03-decryption-argMessageOutData.xml"
	d AStream.CopyFrom(outParam)
	d AStream.SaveStream()
	d AStream.%Close()
	///////////////////////////////////////////////////////////
 	*/
	Quit $$$OK
}

ClassMethod SimpleEncrypt(Src, Key = "IMedical")
{
	Quit:Src="" ""
	Quit:Key="" ""
	Set rtn = ""
	Set KeyLen = $l(Key)
	Set SrcKey = Key
	Set Count = $system.SQL.CEILING($l(Src)/KeyLen)
	For i=1:1:Count-1{ Set SrcKey = SrcKey_Key }
	Set rtn = $zb(Src,SrcKey,6) 
	Set rtn = ##Class(web.Util.Encryption).Byte2Hex(rtn)
	Quit rtn
}

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
