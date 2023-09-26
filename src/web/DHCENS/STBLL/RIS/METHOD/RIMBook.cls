Class web.DHCENS.STBLL.RIS.METHOD.RIMBook Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter action = "MES0089";

/// Creator：ZhangXinying
/// CreatDate：2023—02-06
/// Description：提供方法给医生站根据病人医嘱是否可以打开医技预约界面
/// Input：xml入参 <Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><OpenBookWinRt><OEORIOrderItemID>378||287</OEORIOrderItemID><UpdateUserCode></UpdateUserCode><UpdateDate></UpdateDate><UpdateTime></UpdateTime></OpenBookWinRt></Body></Request>
/// Return：xml应答消息 <Response><Header><SourceSystem></SourceSystem><MessageID>1</MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>成功</ResultContent><LogoFlag>Y</LogoFlag></Body></Response>
/// w ##class(web.DHCENS.STBLL.RIS.METHOD.RIMBook).IsOpenBookWin("<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><OpenBookWinRt><OEORIOrderItemID>378||287</OEORIOrderItemID><UpdateUserCode></UpdateUserCode><UpdateDate></UpdateDate><UpdateTime></UpdateTime></OpenBookWinRt></Body></Request>")
ClassMethod IsOpenBookWin(inputContent As %String) As %String
{
	try
	{
		s soap=##class(web.DHCENS.STBLL.RIS.SOAP.HISServiceSoap).%New()
		s soap.Timeout=2
		s actionStream=##class(%Stream.GlobalCharacter).%New()
		s action=..#action
		d actionStream.Write(action)
		s inputStream=##class(%Stream.GlobalCharacter).%New()
		d inputStream.Write(inputContent)
		s rtnStream=soap.HIPMessageServer(actionStream,inputStream)
		d rtnStream.Rewind()
		s rtnXml=rtnStream.Read()
	}
	catch
	{
		s rtnXml="<Response><Header><SourceSystem>SYS0001</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>-1^<![CDATA["_$ze_"]]></ResultContent></Body></Response>"
	}
	Quit rtnXml
}

}
