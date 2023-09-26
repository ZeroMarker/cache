Class web.DHCFBCM Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod ConvertStr(Str As %String) As %String
{
	s Str=$tr(Str," ")
	s RetStr=$p(Str,"^")
	q:RetStr="" ""
	s FillStr=$p(Str,"^",2)
	q:FillStr="" ""
	s StrLength=$p(Str,"^",3)
	q:StrLength="" RetStr
	S RetStr=$tr($justify(RetStr,StrLength,0)," ",FillStr)
 q RetStr
}

/// 获取科室表输入框数据
ClassMethod CtLoc(Type As %String) As %String
{
	s RetStr=""
	s rid=0,del="^"
	f  s rid=$o(^CTLOC(rid)) q:rid=""  d
	.s TmpStr=$g(^CTLOC(rid))
	.s TypeTmp=$p(TmpStr,del,13)
	.q:(($G(Type)'="")&($g(Type)'=TypeTmp))
	.s Desc=$p(TmpStr,del,2)
	.s Abbr=$p(TmpStr,del,43)
	.if RetStr'="" s RetStr=RetStr_del_rid_$C(1)_Desc_"-"_Abbr
 .i RetStr="" s RetStr=rid_$C(1)_Desc_"-"_Abbr
 q RetStr
}

ClassMethod RetErrorValue(RetStr As %String = "", ErrorStr As %String = "") As %String
{
	if RetStr="" d
	.s:ErrorStr'="" RetStr=ErrorStr
	else  d
	.s:ErrorStr'="" RetStr=RetStr_"@"_"   "_ErrorStr
	q RetStr
}

/// 通过这个类来调用别的类
ClassMethod RunClass(Para As %String) As %String
{
	q:Para="" "要执行的类为空"
	s RetStr=""
	s repid=$I(^CacheTempFHQ)
	S del="-"
	s ClassName=$p(Para,del),ClassPara=$p(Para,del,2)
	;s ClassName="web.DHCFFHQ",ClassMod="aa",ClassPara="mmddd"
	s ParStr=ClassName_"("_repid_","_""""_ClassPara_""""_")"
	XEcute ParStr
	if $g(^CacheTempFHQ(repid))'="" s RetStr=$g(^CacheTempFHQ(repid))
	q RetStr
}

ClassMethod StrToList(Str As %String = "", Sep As %String = "^") As %String
{
	q:$g(Str)="" ""
	s StrLen=$l(Str,Sep)
	s i=0
	s RetStr=""
	f  s i=i+1 q:i>StrLen  d
	.s TmpArray(i)=$p(Str,Sep,i)
	.s:i=1 RetStr=$lb(TmpArray(i))
	.s:i'=1 RetStr=RetStr_$lb(TmpArray(i))
	q RetStr
}

}
