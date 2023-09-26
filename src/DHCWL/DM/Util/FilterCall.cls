Class DHCWL.DM.Util.FilterCall Extends %RegisteredObject
{

Property FilterConfig As DHCWL.DM.T.FilterFunConfig;

Property exeStr As %String [ Private ];

//Property fparams As %String [ Private ];

//Property cparams As %String [ Private ];

Property params As %List;

Property value As %String;

Property result As %Boolean;

Property iterator As %SerialObject;

// d ##class(DHCWL.DM.Util.FilterCall).Test()

ClassMethod Test()
{
	s filter=##class(FilterCall).%New("test",$lb("心"))
	w filter.Call("心内科")
	w filter.Call("内科")
}

Method %OnNew(filterName As %String, params As %List) As %Status [ Private, ServerOnly = 1 ]
{
	s filterFun=##class(DHCWL.DM.T.FilterFunConfig).GetByPath(filterName)
	s filterId=filterFun.%Id()
    s callExp=filterFun.CallExpression
    s ..FilterConfig=filterFun
	d ##class(DHCWL.DM.T.FilterFunParams).GetParams(filterId,.paramsDefined)
	;s fparams2=""
	s cparams2=""
	s j=0
	s i="" f  s i=$o(paramsDefined(i)) q:i=""  d
	.s j=j+1
	.s:j>1 cparams2=cparams2_"," ;,fparams2=fparams2_","
	.;s fparams2=fparams2_paramsDefined(i,"N")
	.s:$lg(params,i,"")="" $list(params,i)=paramsDefined(i,"V")
	.;s cparams2=cparams2_"..paramsMap("""_i_""")"
	.s cparams2=cparams2_"$lg(..params,"_i_")"
	s cparams2="..value,"_cparams2
	;s fparams2="..value,"_fparams2
	;s ..exeStr="s result="_callExp_"("_fparams2_")"
	s ..exeStr="s ..result="_callExp_"("_cparams2_")"
	;s ..fparams=fparams2,..cparams=cparams2
	s ..params=params
	i filterFun.FilterType.GetPath()="FILTER:ITERATOR" d
	.s exeStr="s ..iterator="_callExp_"("_cparams2_")"
	.x exeStr
    q $$$OK
}

Method Call(paraValue) As %Boolean
{
	s ..value=paraValue
	x ..exeStr
	q ..result
}

}
