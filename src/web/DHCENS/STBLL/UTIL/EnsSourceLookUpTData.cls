Class web.DHCENS.STBLL.UTIL.EnsSourceLookUpTData Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.UTIL.EnsSourceLookUpTData).GetTarCode("CHINA","CT_Country")
ClassMethod GetTarCode(SourceCode As %String, LookUpTable As %String) As %String
{
	set $zt="Exception"
	set tableId=$O(^User.EnsLookUpTableI("lookUpTableCode",LookUpTable,""))
	Quit:tableId="" "-1^对照信息表不存在"
	set souId=$o(^User.EnsSouLookUpTDataI("sourceCode",tableId,SourceCode,"")) 
	Quit:souId="" "-1^未添加对照信息"
	set tId=$o(^User.EnsLookUpTDataI("sourceTableDr",tableId,souId,""))
	Quit:tId="" "-1^未添加对照信息"
	set tarId=$lg(^User.EnsLookUpTDataD(tId),4)
	Quit:tarId="" "-1^未添加对照信息"
	set tarCode=$lg(^User.EnsTarLookUpTDataD(tarId),2)
	set tarDesc=$lg(^User.EnsTarLookUpTDataD(tarId),3)
	Quit "0^"_tarCode_"^"_tarDesc
Exception
	Quit "-1^"_$ze
}

}
