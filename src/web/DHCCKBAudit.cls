Import sqluser

Class web.DHCCKBAudit Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Descript:药品审核标记查询
/// Creator:wangxin
/// CreateDate:2020-12-11  
/// w ##class(web.DHCCKBAudit).QueryAudit("2021-07-01^2021-07-27^全部院区")
ClassMethod QueryAudit(params)
{
	n (params)
	k ^y
	s ^y = params
	s stDate = $p(params,"^",1)
	s endDate = $p(params,"^",2)
	Q:(stDate = "")||(endDate = "") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s stDate = $zdh(stDate,3)
	s endDate = $zdh(endDate,3)
	s Hosp = $p(params,"^",3)
	
	s obj= ##class(DHCNewPro.COM.Object).%New()
	s DateArr = ##class(DHCNewPro.COM.Array).%New()					//月龄
	s ReposNumArr = ##class(DHCNewPro.COM.Array).%New()	
	s AnEmpSupArr = ##class(DHCNewPro.COM.Array).%New()	
	s SpeExpHospArr = ##class(DHCNewPro.COM.Array).%New()	
	s WrongHospArr = ##class(DHCNewPro.COM.Array).%New()	
	
	
	for date = stDate:1:endDate  d
	.s ReposNums=0     //知识库纠错
	.s AnEmpSups=0     //经验用药补充
	.s SpeExpHosps=0    //医院的特殊经验用药
	.s WrongHosps=0     //医院的错误用法
	.s monId = ""
	.for  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  Q:monId=""  d
	..s hosp = $lg(^CKB.PDSS.MonMasterD(monId),12)	//医院
	..q:(Hosp'="全部院区")&&(hosp'[Hosp)
	..s monItmId = ""	
	..for  s monItmId = $o(^CKB.PDSS.MonQueListI("Parref",monId,monItmId)) Q:monItmId=""  d
	...s exasignval = $lg(^CKB.PDSS.MonQueListD(monItmId),10)	//标记
	...q:exasignval=""  d
	...s:(exasignval="complet")||(exasignval="uwcomplet")||(exasignval="partcomp")||(exasignval="partcompcon")||(exasignval="partcompproame")||(exasignval="partcompruleimp")||(exasignval="partcompdicimp") ReposNums=ReposNums+1
	...s:(exasignval="verifycorrect") AnEmpSups=AnEmpSups+1
	...s:(exasignval="affirmcorrect") SpeExpHosps=SpeExpHosps+1
	...s:(exasignval="achievecorrect") WrongHosps=WrongHosps+1
	.s datetime=$zdate(date,3)
    .d DateArr.Push(datetime)
    .d ReposNumArr.Push(ReposNums)
    .d AnEmpSupArr.Push(AnEmpSups)
    .d SpeExpHospArr.Push(SpeExpHosps)
    .d WrongHospArr.Push(WrongHosps)
	
	s obj.date = DateArr
	s obj.ReposNum = ReposNumArr
	s obj.AnEmpSup = AnEmpSupArr
	s obj.SpeExpHosp = SpeExpHospArr
	s obj.WrongHosp = WrongHospArr
	
	w obj.ToJSON()
	Q ""
}

}
