Class web.DHCENS.STBLL.DRUG.METHOD.BaseMethod Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// Description:解析韦乐海茨应答消息
/// Debug:w ##class(web.DHCENS.BLL.Drug.Method.BaseMethod).WlhcResultToStr("<ROOT><RETVAL>1</RETVAL><RETMSG>写入窗口代码成功</RETMSG><RETCODE>1</RETCODE></ROOT>")
ClassMethod WlhcResultToStr(xmlInput As %String) As %String
{
	set reader=##class(%XML.Reader).%New()
	set sc=reader.OpenString(xmlInput)
	do reader.Correlate("ROOT","web.DHCENS.STBLL.DRUG.MODEL.WlhcResponse")
	set ResultStr=""	
	while reader.Next(.obj,.sc) {
        set ResultStr = obj.RETCODE_"^"_obj.RETMSG_"^"_obj.RETVAL
	}
	Q ResultStr
}

}
