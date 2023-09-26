Class web.DHCCM.DrugAdvice Extends %Persistent [ Not ProcedureBlock ]
{

/// creator:dws
/// 2016-11-08
/// Descript:用药建议时间
/// W ##Class(web.DHCCM.DrugAdvice).jsonMedAdvice("1609","")
ClassMethod jsonMedAdvice(EpisodeID As %String, SearchInfo As %String)
{
	s result=""
	s medAdvID=""
	s flagDate=""
	f  s medAdvID=$o(^DHCPHAD(0,"AdmDr",EpisodeID,medAdvID)) q:medAdvID=""  d
	.s medAdvDate=$p(^DHCPHAD(medAdvID),"^",4)     //记录日期
	.s:medAdvDate'="" medAdvDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(medAdvDate)
	.q:flagDate=medAdvDate
	.s flagDate=medAdvDate
	.s jsonData=medAdvDate
	.Q:jsonData'[SearchInfo
	.
	.s result = result_"{"
	.s result = result_"""text"":"""_jsonData_""""
	.s result = result_"},"
	s result=$e(result,1,$l(result)-1)
	q "["_result_"]"
}

/// creator:dws
/// 2016-11-08
/// Descript:获取医嘱信息
/// W ##Class(web.DHCCM.DrugAdvice).getPHMedAdvDrgItm("2016-09-28","1609")
ClassMethod getPHMedAdvDrgItm(date, EpisodeID)
{
	s:date'="" date=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(date)
	s count=0
	s result=""
	s medAdvID=""
	s medAdvId=""
	s PhadChildSub=""
	s CH=""
	f  s medAdvID=$o(^DHCPHAD(0,"Date",date,medAdvID))  q:medAdvID=""  d
	.f  s medAdvId=$o(^DHCPHAD(0,"AdmDr",EpisodeID,medAdvId)) q:medAdvId=""  d
	..Q:medAdvID'=medAdvId ;过滤掉多余的数据
	..F  S CH=$o(^DHCPHAD(medAdvId,"AI",CH)) Q:CH=""  D
	...S oeori=$p(^DHCPHAD(medAdvId,"AI",CH),"^",1) //医嘱ID
	...S ord=+oeori
	...S chl=$p(oeori,"||",2)
	...q:'$d(^OEORD(ord,"I",chl,1))
	...S priDr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    ...i priDr=0 q
    ...S priorty=$p(^OECPR(priDr),"^",1) //医嘱优先级代码              
    ...S priorty=$p(^OECPR(priDr),"^",2) //医嘱优先级
	...S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	...S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	...i inci="" q //医嘱名称
	...S inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	...S dosage=$p(^OEORD(ord,"I",chl,2),"^",1) //剂量
	...S dosuomID=+$p(^OEORD(ord,"I",chl,2),"^",3)
	...S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) //剂量单位
	...F  S PhadChildSub=$o(^DHCPHAD(medAdvId,"AD",PhadChildSub)) Q:PhadChildSub=""  D
	....s phadAdvice=$p(^DHCPHAD(medAdvId,"AD",PhadChildSub),"^",4) //用药建议
	....s count=count+1
	....
    ....s result = result_"{"
	....s result = result_"""inciDesc"":"""_inciDesc_""""
	....s result = result_",""dosage_doseuom"":"""_dosage_doseuom_""""
	....s result = result_",""phadAdvice"":"""_phadAdvice_""""
	....s result = result_"},"
	s result=$e(result,1,$l(result)-1)
	q "{""total"":"_count_",""rows"":["_result_"]}"
}

/// creator:dws
/// 2017-01-20
/// Descript:医学查房时间
/// W ##Class(web.DHCCM.DrugAdvice).jsonMedMedicalWard("1609","")
ClassMethod jsonMedMedicalWard(EpisodeID, SearchInfo)
{
	s result=""
	s PhcpRowID=""
	s flagDate=""
	f  s PhcpRowID=$o(^DHCPHCP(0,"Adm",EpisodeID,PhcpRowID))  q:PhcpRowID=""  d
	.s phcpDate=$p(^DHCPHCP(PhcpRowID),"^",19)
	.s:phcpDate'="" phcpDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(phcpDate)
	.q:phcpDate=flagDate
	.s flagDate=phcpDate
	.s jsonData=phcpDate
	.Q:jsonData'[SearchInfo
	.
	.s result = result_"{"
	.s result = result_"""text"":"""_jsonData_""""
	.s result = result_"},"
	s result=$e(result,1,$l(result)-1)
	q "["_result_"]"
}

/// creator:dws
/// 2017-01-20
/// Descript:获取医学查房内容
/// w ##Class(web.DHCCM.DrugAdvice).getMedicalWardItm("2017-01-20","1609")
ClassMethod getMedicalWardItm(date, EpisodeID)
{
	s:date'="" date=$zdh(date,3)
	s count=0
	s result=""
	s PhcpRowID=""
	f  s PhcpRowID=$o(^DHCPHCP(0,"DateAdm",date,EpisodeID,PhcpRowID)) q:PhcpRowID=""  d
	.s phcpDouLunBrePho=$p(^DHCPHCP(PhcpRowID),"^",8) //双肺呼吸音
	.s:phcpDouLunBrePho="10" phcpDouLunBrePho="清"
	.s:phcpDouLunBrePho="11" phcpDouLunBrePho="粗"
	.
	.s phcpRale=$p(^DHCPHCP(PhcpRowID),"^",9) //啰音
	.s:phcpRale="10" phcpRale="闻及"
	.s:phcpRale="11" phcpRale="未闻及"
	.s:phcpRale="12" phcpRale="干"
	.s:phcpRale="13" phcpRale="湿"
	.
	.s phcpArrhythmia=$p(^DHCPHCP(PhcpRowID),"^",10) //心律
	.s:phcpArrhythmia="10" phcpArrhythmia="齐"
	.s:phcpArrhythmia="11" phcpArrhythmia="不齐"
	.
	.s phcpPathMurmur=$p(^DHCPHCP(PhcpRowID),"^",11) //各瓣膜听诊区、病理性杂音
	.s:phcpPathMurmur="10" phcpPathMurmur="闻及"
	.s:phcpPathMurmur="11" phcpPathMurmur="未闻及"
	.
	.s phcpBelly=$p(^DHCPHCP(PhcpRowID),"^",12) //腹部
	.s:phcpBelly="10" phcpBelly="平软"
	.s:phcpBelly="11" phcpBelly="膨隆"
	.
	.s phcpLivLieCos=$p(^DHCPHCP(PhcpRowID),"^",13) //肝脾肋下
	.s:phcpLivLieCos="10" phcpLivLieCos="触及"
	.s:phcpLivLieCos="11" phcpLivLieCos="未触及"
	.
	.s phcpPerPain=$p(^DHCPHCP(PhcpRowID),"^",14) //双肾区叩击痛
	.s:phcpPerPain="10" phcpPerPain="有"
	.s:phcpPerPain="11" phcpPerPain="无"
	.
	.s phcpOedema=$p(^DHCPHCP(PhcpRowID),"^",15) //双下肢水肿
	.s:phcpOedema="10" phcpOedema="无"
	.s:phcpOedema="11" phcpOedema="轻"
	.s:phcpOedema="12" phcpOedema="中"
	.s:phcpOedema="13" phcpOedema="重度水肿"
	.
	.s phcpChaOfDisDesc=$p(^DHCPHCP(PhcpRowID),"^",16) //主要病情变化情况
	.s phcpGuidance=$p(^DHCPHCP(PhcpRowID),"^",17) //治疗方案
	.s count=count+1
	.
	.s result = result_"{"
	.s result = result_"""phcpDouLunBrePho"":"""_phcpDouLunBrePho_""""
	.s result = result_",""phcpRale"":"""_phcpRale_""""
	.s result = result_",""phcpArrhythmia"":"""_phcpArrhythmia_""""
	.s result = result_",""phcpPathMurmur"":"""_phcpPathMurmur_""""
	.s result = result_",""phcpBelly"":"""_phcpBelly_""""
	.s result = result_",""phcpLivLieCos"":"""_phcpLivLieCos_""""
	.s result = result_",""phcpPerPain"":"""_phcpPerPain_""""
	.s result = result_",""phcpOedema"":"""_phcpOedema_""""
	.s result = result_",""phcpChaOfDisDesc"":"""_phcpChaOfDisDesc_""""
	.s result = result_",""phcpGuidance"":"""_phcpGuidance_""""
	.s result = result_"},"
	s result=$e(result,1,$l(result)-1)
	q "{""total"":"_count_",""rows"":["_result_"]}"
}

Storage Default
{
<Data name="DrugAdviceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCM.DrugAdviceD</DataLocation>
<DefaultData>DrugAdviceDefaultData</DefaultData>
<IdLocation>^web.DHCCM.DrugAdviceD</IdLocation>
<IndexLocation>^web.DHCCM.DrugAdviceI</IndexLocation>
<StreamLocation>^web.DHCCM.DrugAdviceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
