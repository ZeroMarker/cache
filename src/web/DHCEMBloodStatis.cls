Class web.DHCEMBloodStatis Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// comParams：stDate^endDate
/// params: 明细表过滤条件
/// type：汇总数量/明细  T/D
/// w ##class(web.DHCEMBloodStatis).listData(1, 12, "2021-01-01","D")
ClassMethod listData(page, rows, comParams, params, type)
{
	n (page, rows, comParams, params ,type,%session)
	s start=page-1*rows+1
	s end=page*rows
	
	s stDate=$p(comParams,"^",1)
	s endDate=$p(comParams,"^",2)
	s:stDate'="" stDate =##class(web.DHCEMCommonUtil).DateHtmlToLogical(stDate)
	s:endDate'="" endDate =##class(web.DHCEMCommonUtil).DateHtmlToLogical(endDate)
	s:stDate="" stDate=+$h
	s:endDate="" endDate=+$h
	s execUserId=$p(params,"^",1)
	
	s pid=##Class(web.DHCAPPCommonUtil).NewPid()
	k ^TMPData("web.BloodStatis","listData",pid)
	k ^TMPData("web.BloodStatis","listTotalData","ordNumber",pid)
	k ^TMPData("web.BloodStatis","listTotalData","specNumber",pid)
	
	f date=stDate:1:endDate d
	.s ord=0
	.f  s ord=$o(^OEORDi(0,"SPECCOLLDATE",date,ord)) q:ord=""  d
	..s admId=+^OEORD(ord)
	..s admType=$p(^PAADM(admId),"^",2)
	..q:(admType'="O")&&(admType'="E")
	..s itm=0
	..f  s itm=$o(^OEORDi(0,"SPECCOLLDATE",date,ord,itm)) q:itm=""  d
	...s sub=0
	...f  s sub=$o(^OEORDi(0,"SPECCOLLDATE",date,ord,itm,sub)) q:sub=""  d
	....s specCollUserId=$p(^OEORD(ord,"I",itm,"X",sub,"NUR"),"^",10)	;采血人
	....q:(execUserId'="")&&(execUserId'=specCollUserId)&&(type="D")	;查明细才过滤
	....s labNo=$p($g(^OEORD(ord,"I",itm,3)),"^",20)	;标本号
	....s ordExecId=ord_"||"_itm_"||"_sub
	....s ^TMPData("web.BloodStatis","listData",pid,labNo,ordExecId)=""
	....d $i(^TMPData("web.BloodStatis","listTotalData","ordNumber",pid,specCollUserId))	;医嘱数
	....i '$d(TMPData("ordSpec",labNo)) d
	.....d $i(^TMPData("web.BloodStatis","listTotalData","specNumber",pid,specCollUserId))	;标本数
	.....s TMPData("ordSpec",labNo)=""
	....;d $i(TMPData("bloodData","execOrdNumber",specCollUserId))
	d:type="T" outTotal
	d:type="D" outDetail
	
	k ^TMPData("web.BloodStatis","listData",pid)
    k ^TMPData("web.BloodStatis","listTotalData","ordNumber",pid)
	k ^TMPData("web.BloodStatis","listTotalData","specNumber",pid)
    q ""


outTotal
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()
	s count=0
	s tmpTitle="specCollUserId^specCollUser^ordTotalNumber^specTotalNumber"
	s specCollUserId=""
	f  s specCollUserId=$o(^TMPData("web.BloodStatis","listTotalData","ordNumber",pid,specCollUserId)) q:specCollUserId=""  d
	.s specCollUser=$p(^SSU("SSUSR",specCollUserId),"^",2)
	.s ordTotalNumber=^TMPData("web.BloodStatis","listTotalData","ordNumber",pid,specCollUserId)
	.s specTotalNumber=^TMPData("web.BloodStatis","listTotalData","specNumber",pid,specCollUserId)
	.s count=count+1
  	.q:count<start
  	.q:count>end
    .w $case(count,start:"",:",")
    .s specCollUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",specCollUser) //hxy 2022-12-16
    .s tmpData=specCollUserId_"^"_specCollUser_"^"_ordTotalNumber_"^"_specTotalNumber
    .w ##class(web.DHCEMJsonCommon).getJsonData(tmpTitle,tmpData)
    w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count)
	q ""
	
outDetail
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()
	s count=0
	s tmpTitle="specCollUser^specCollDate^specCollTime^patName^age^ordName^specDesc^tubeColor"
	s labNo=""
	f  s labNo=$o(^TMPData("web.BloodStatis","listData",pid,labNo)) q:labNo=""  d
	.s oneExecId=$o(^TMPData("web.BloodStatis","listData",pid,labNo,""))
	.s ord=+oneExecId,itm=$p(oneExecId,"||",2),sub=$p(oneExecId,"||",3)
	.s admId=+^OEORD(+ord)
	.s patientId=+^PAADM(admId)
	.s ordName=""					;医嘱名称
	.s ordExecId=0
	.f  s ordExecId=$o(^TMPData("web.BloodStatis","listData",pid,labNo,ordExecId)) q:ordExecId=""  d
	..s itemOrd=+ordExecId
	..s itemItm=$p(ordExecId,"||",2)
	..s itemOrdName=##class(web.DHCEMOrdInfoVO).getArcimDesc(itemOrd,itemItm)
	..s:ordName'="" ordName=ordName_","_itemOrdName
	..s:ordName="" ordName=itemOrdName
	.s patName=##class(web.DHCEMOrdInfoVO).getPatName(ord)
	.s age=##class(web.DHCEMOrdInfoVO).getPatAge(ord)
	.s specCollUserId=$p(^OEORD(ord,"I",itm,"X",sub,"NUR"),"^",10)	;采血人
	.s specCollUser=$p(^SSU("SSUSR",specCollUserId),"^",2)
	.s specCollDate=$p(^OEORD(ord,"I",itm,"X",sub,"NUR"),"^",11)	;采血日期
	.s specCollDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(specCollDate)
	.s specCollTime=$p(^OEORD(ord,"I",itm,"X",sub,"NUR"),"^",12)	;采血时间
	.s specCollTime=$zt(specCollTime,2)
	.s specCode=$p($g(^OEORD(ord,"I",itm,"SPEC",1)),"^")			;标本code
	.s specDesc=##class(web.DHCEMOrdInfoVO).getSpecDesc(ord,itm)	;标本
	.s tubeColor=##class(web.DHCEMOrdInfoVO).getTubeColor(ord,itm)	;管颜色
	.s count=count+1
  	.q:count<start
  	.q:count>end
    .w $case(count,start:"",:",")
    .s specCollUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",specCollUser) //hxy 2022-12-16
    .s tmpData=specCollUser_"^"_specCollDate_"^"_specCollTime_"^"_patName_"^"_age_"^"_ordName_"^"_specDesc_"^"_tubeColor
    .w ##class(web.DHCEMJsonCommon).getJsonData(tmpTitle,tmpData)
    w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count)
    q ""
}

}
