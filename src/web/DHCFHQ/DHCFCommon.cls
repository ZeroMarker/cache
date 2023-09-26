Class web.DHCFHQ.DHCFCommon Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod RetValue(RetStr As %String = "", ErrorStr As %String = "") As %String
{
	if RetStr="" d
	.s:ErrorStr'="" RetStr=ErrorStr
	else  d
	.s:ErrorStr'="" RetStr=RetStr_"@"_"   "_ErrorStr
	q RetStr
}

}
