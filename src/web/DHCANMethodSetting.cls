Class web.DHCANMethodSetting Extends %RegisteredObject
{

/// w ##class(web.DHCANMethodSetting).SaveANMethodSetting(133,"6379||1;12679||1;7543||1;"_$c(3)_$c(3)_$c(3)_$c(3)_$c(3)_"^",59)
ClassMethod SaveANMethodSetting(AnMethodId, ParaStr, ctlocId) As %String
{
	s ^tempck("ANMethod")=AnMethodId_"/"_ParaStr_"/"_ctlocId
	q:AnMethodId="" "-1"
	q:ParaStr="" "-2"
	q:ctlocId="" "-3"
	s retStr=""
	f i=1:1:$l(ParaStr,"^") d
	.s Para=$p(ParaStr,"^",i)
	.i Para'="" d
	..s ret=##class(web.DHCANMethodSetting).SaveSingleSetting(AnMethodId,Para,ctlocId)
	..i ret'=0 s retStr=retStr_ret_"^"
	q retStr
}

ClassMethod SaveSingleSetting(AnMethodId, Para, ctlocId) As %String
{
	q:AnMethodId="" "-1"
	q:Para="" "-2"
	q:ctlocId="" "-3"
	
	s orderList=$p(Para,$c(3),1)
	s code=$p(Para,$c(3),2)
	s desc=$p(Para,$c(3),3)
	s valueList=$p(Para,$c(3),4)
	s note=$p(Para,$c(3),5)
	
	s ret=##class(web.DHCANMethodSetting).CheckItems(AnMethodId,code,ctlocId)
	i ret>0 d
	.s obj=##class(User.DHCANCMethodSetting).%OpenId(ret)
	e  d
	.s obj=##class(User.DHCANCMethodSetting).%New()

	s obj.ANMSANMethodDr=AnMethodId
	s obj.ANMSCtlocDr=ctlocId
	s obj.ANMSOrderList=orderList
	s obj.ANMSCode=code
	s obj.ANMSDesc=desc
	//s obj.ANMSValueList=valueList
	s obj.ANMSOption=valueList
	s obj.ANMSNote=note
	
	s saveStatus=obj.%Save()
	q:(+saveStatus=0) "数据保存失败!"_code
	s anmsRowId=obj.%Id()
	d obj.%Close()
	q 0
}

/// chenkai 检测项目是否存在 
ClassMethod CheckItems(AnMethodId, code, ctlocId) As %String
{
	q:AnMethodId="" "-1"
	q:code="" "-2"
	q:ctlocId="" "-3"
	s retStr=-1
	s anmsRowId="" f  s anmsRowId=$o(^DHCANC("ANMethod",0,"ANMethod",AnMethodId,anmsRowId)) q:anmsRowId=""  d
	.s anmsCtlocDr=$li(^DHCANC("ANMethod",anmsRowId),2)
	.s anmsCode=$li(^DHCANC("ANMethod",anmsRowId),4)
	.i (anmsCtlocDr=ctlocId)&(code=anmsCode) s retStr=anmsRowId
	q retStr
}

/// w ##class(web.DHCANMethodSetting).GetAnaestMethodSetting("133","","")
ClassMethod GetAnaestMethodSetting(AnMethodId As %String = "", ctlocId As %String = "", opaId As %String = "") As %String
{
	//s ^tempck("GetAnaestMethodSetting")=AnMethodId_"/"_ctlocId_"/"_opaId
	s EpisodeID="",anaSub=""
	i opaId'="" d
	.s anaId=$p(^DHCANOPArrange(opaId),"^",2)
	.s EpisodeID=$p(anaId,"||",1)
	.s anaSub=$p(anaId,"||",2)
	
	s retStr=""

	s AnMethoddr="" f  s AnMethoddr=$o(^DHCANC("ANMethod",0,"ANMethod",AnMethoddr)) q:AnMethoddr=""  d
	.q:(AnMethodId'="")&(AnMethodId'=AnMethoddr)
	.s rowId="" f  s rowId=$o(^DHCANC("ANMethod",0,"ANMethod",AnMethoddr,rowId)) q:rowId=""  d
	..s orderListDesc=""
	..s anmsAnMethodId=$li(^DHCANC("ANMethod",rowId),1)
	..s anmsCtlocId=$li(^DHCANC("ANMethod",rowId),2)
	..q:(ctlocId'="")&(anmsCtlocId'=ctlocId)
	..s anmsOrderList=$li(^DHCANC("ANMethod",rowId),3)
	..i anmsOrderList'="" d
	...f count=1:1:$l(anmsOrderList,";") d
	....s singleOrderId=$p(anmsOrderList,";",count)
	....i singleOrderId'="" d
	.....i orderListDesc="" s orderListDesc=$p(^ARCIM(+singleOrderId,$p(singleOrderId,"||",2),1),"^",2)
	.....e  s orderListDesc=orderListDesc_";"_$p(^ARCIM(+singleOrderId,$p(singleOrderId,"||",2),1),"^",2)
	
	..s anmsCode=$li(^DHCANC("ANMethod",rowId),4)
	..s anmsDesc=$li(^DHCANC("ANMethod",rowId),5)
	..s anmsOption=$li(^DHCANC("ANMethod",rowId),6)
	..s anmsNote=$li(^DHCANC("ANMethod",rowId),7)
	
	..s anMethodCode=$p($g(^ORC("ANMET",anmsAnMethodId)),"^",1)
	..s anMethodDesc=$p($g(^ORC("ANMET",anmsAnMethodId)),"^",2)
	..s ctlocDesc=$p($g(^CTLOC(anmsCtlocId)),"^",2)
	
	..s anmsValue=""
	..i (EpisodeID'="")&(anaSub'="") d
	...i $d(^OR(EpisodeID,"ANA",anaSub,"MethodInfo")) d
	....q:anmsCode=""
	....s anmsValue=$p($g(^OR(EpisodeID,"ANA",anaSub,"MethodInfo",anmsAnMethodId,anmsCode)),"^",2)

	..s retStr=retStr_anmsAnMethodId_"^"_anmsCtlocId_"^"_anmsOrderList_"^"_anmsCode_"^"_anmsDesc_"^"_anmsOption_"^"_anmsNote_"^"_anMethodCode_"^"_anMethodDesc_"^"_ctlocDesc_"^"_orderListDesc_"^"_anmsValue_$c(1)
	q retStr
}

}
