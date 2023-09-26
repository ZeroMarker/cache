/// creator:	yunhaibao 
/// createdate:	2018-01-18
/// description:批准文号前缀维护
Class web.DHCST.ItmRemark Extends %RegisteredObject
{

/// description:查询
/// ^DHCSTOFFICODE("Gp")="国药准字^京卫健字"
/// w ##class(web.DHCST.ItmRemark).Query()
ClassMethod Query()
{
	s gpData=$g(^DHCSTOFFICODE("Gp"))
	q:gpData="" ##class(web.DHCSTEXTCOMMON).GetNoJson() 
	s json = ##class(Code.JsonObj).%New()
	s count=0
	s gpLen=$l(gpData,"^")
	f gpI=1:1:gpLen d
	.s gpDesc=$p(gpData,"^",gpI)
	.q:gpDesc=""
	.d json.InsertRowData(gpDesc)
	.s count=count+1
	s resultString = json.getJsonData("Desc",count)
	k json
	q resultString
}

/// description:保存
ClassMethod Save(listData)
{
	s ^DHCSTOFFICODE("Gp")=listData
	q ""
}

}
