/// Creator：      zhouxin
/// CreatDate：    2019-06-12
/// Description:： 不良事件统计用到的函数
Class web.DHCADVModelFun Extends (%RegisteredObject, %XML.Adaptor)
{

/// 获取一天住院人数
ClassMethod GetInPatNum(par)
{
	s date=$p(par,"^",1)
	s pid=$p(par,"^",2)
	q:$d(^TMP("web.DHCADVModel","tmpData",pid,"GetInPatNum",date)) ^TMP("web.DHCADVModel","tmpData",pid,"GetInPatNum",date)
	s count=0
	s IPDERowid="" f  s IPDERowid=$o(^MRIPdaily("MRIP_DATE",date,IPDERowid)) q:IPDERowid=""  d
 	.s rowid="" f  s rowid=$o(^DHCMRIPDetail(0,"IPType",IPDERowid,"ZYRS",rowid)) q:rowid=""  d
 	..s admid=$p(^DHCMRIPDetail(rowid),"^",1)
 	..s personid=$p(^PAADM(admid),"^",1)
 	..s name=$p(^PAPER(personid,"ALL"),"^",1) ;姓名
 	..q:(name["baby")
 	..s count=count+1
 	s ^TMP("web.DHCADVModel","tmpData",pid,"GetInPatNum",date)=count
 	q count
}

/// 获取护理病历记录的跌倒数
/// w ##class(web.DHCADVModelFun).GetNurEmrFall)()
ClassMethod GetNurEmrFall(par)
{
	s date=$p(par,"^",1)
	s pid=$p(par,"^",2)
	
 	q ""
}

/// 获取总数
/// w ##class(web.DHCADVModelFun).GetTotalNum()
ClassMethod GetTotalNum(par)
{
	s date=$p(par,"^",1)
	s pid=$p(par,"^",2)
	q $g(^TMP("web.DHCADVModel","TotalCount",pid,date))
}

/// 获取跌倒率
/// w ##class(web.DHCADVModelFun).GetFallRate()
ClassMethod GetFallRate(par)
{

	s Num=##class(web.DHCADVModelFun).GetTotalNum(par)
	q:+Num=0 ""
	s total=##class(web.DHCADVModelFun).GetInPatNum(par)
	q:+total=0 ""
	q $fn(Num/total*100,"",2)_"%"
}

/// 获取跌倒造成伤害事件数
/// w ##class(web.DHCADVModelFun).GetNurEmrFall)()
ClassMethod GetDamageNum(par)
{
	s date=$p(par,"^",1)
	s pid=$p(par,"^",2)
	s attrId=$p(par,"^",3)
	s model=$p(^DHCADVMODELATTR(attrId),"^",1)
	q:$d(^TMP("web.DHCADVModel","tmpData",pid,"GetDamageNum",date)) ^TMP("web.DHCADVModel","tmpData",pid,"GetDamageNum",date)
	s count=0
	s adv="" f  s adv=$o(^DHCADVMASTER(0,"RepDate",date,adv)) q:adv=""  d
	.s recordId=$p(^DHCADVMASTER(adv),"^",1)
	.q:##class(web.DHCADVModelFilter).CheckModelFilter(model,recordId)=0
	.q:##class(web.DHCADVModelFilter).CheckIncludeDic(recordId,"NurFallLevel-1762^NurFallLevel-1763^NurFallLevel-1764^NurFallLevel-1765")=0
	.s count=count+1
 	q count
}

/// 获取跌倒造成伤害率
/// w ##class(web.DHCADVModelFun).GetDamageRate()
ClassMethod GetDamageRate(par)
{
	s num=##class(web.DHCADVModelFun).GetDamageNum(par)
	q:+num=0 ""
	s total=##class(web.DHCADVModelFun).GetTotalNum(par)
	q:+total=0 ""
	q $fn(num/total*100,"",2)_"%"
}

/// 获取管路滑脱造成伤害率
ClassMethod GetUnpExtubateRate(par)
{
	s num=##class(web.DHCADVModelFun).GetTotalNum(par)
	q:+num=0 ""
	s total=##class(web.DHCADVModelFun).GetInPatNum(par)
	q:+total=0 ""
	q $fn(num/total*100,"",2)_"%"
}

/// 获取科室
/// w ##class(web.DHCADVModelFun).GetLoc()
ClassMethod GetLoc(par)
{
	s adv=$p(par,"^",1)
	q:+adv=0 ""
	s loc=$p(^DHCADVMASTER(adv),"^",7)
	q:+loc=0 ""
	q $p(^CTLOC(loc),"^",2)
}

/// 获取住院号
/// w ##class(web.DHCADVModelFun).GetMedNo()
ClassMethod GetMedNo(par)
{
	s AdmNo=""
	s adv=$p(par,"^",1)
	q:+adv=0 ""
	s adm=$p(^DHCADVMASTER(adv),"^",16)
	q:+adm=0 ""
	S papRowid=$p(^PAADM(adm),"^",1)
	q:+papRowid=0 ""
	s:adm'="" AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID(adm,"") 
	s:(papRowid'="")&&(AdmNo="") AdmNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID("",papRowid)
	q AdmNo
}

/// 获取患者姓名
/// w ##class(web.DHCADVModelFun).GetPatName()
ClassMethod GetPatName(par)
{
	s adv=$p(par,"^",1)
	q:+adv=0 ""
	s adm=$p(^DHCADVMASTER(adv),"^",16)
	q:+adm=0 ""
	S papRowid=$p(^PAADM(adm),"^",1)
	q:+papRowid=0 ""
	q $p(^PAPER(papRowid,"ALL"),"^",1)
}

/// 获取患者年龄
/// w ##class(web.DHCADVModelFun).GetPatAge()
ClassMethod GetPatAge(par)
{
	s adv=$p(par,"^",1)
	q:+adv=0 ""
	s adm=$p(^DHCADVMASTER(adv),"^",16)
	q:+adm=0 ""
	S papRowid=$p(^PAADM(adm),"^",1)
	q:+papRowid=0 ""
	q ##Class(web.DHCSTKUTIL).GetAge(papRowid)
}

/// 获取上报日期
ClassMethod GetRepDate(par)
{
	s adv=$p(par,"^",1)
	q:+adv=0 ""
	s repDate=$p(^DHCADVMASTER(adv),"^",4)
	q:repDate="" ""
	q $zd(repDate,3)
}

/// 获取上报类型
ClassMethod GetRepType(par)
{
	s adv=$p(par,"^",1)
	q:+adv=0 ""
	s recordId=$p(^DHCADVMASTER(adv),"^",1)
	s formId=$LG(^User.DHCAdvFormRecordD(recordId),2)
	q $LG(^User.DHCAdvFormNameD(formId),3)
}

/// 获取上报级别
ClassMethod GetLev(par)
{
	s adv=$p(par,"^",1)
	q:+adv=0 ""
	s recordId=$p(^DHCADVMASTER(adv),"^",1)
	s ret=""
	s dicStr="UlcerAdvEventLevel-95222^UlcerAdvEventLevel-95223^UlcerAdvEventLevel-95224^UlcerAdvEventLevel-95225^UlcerAdvEventLevel-95226^UlcerAdvEventLevel-95227"
	f i=1:1:$l(dicStr,"^") d
	.s dicCode=$p(dicStr,"^",i)
	.s dic=##class(web.DHCADVCOMMONPRINT).GetDiscIdByCode(dicCode)
	.s:ret="" ret=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordId,dic)
	q ret
}

/// 获取发生日期
ClassMethod GetOccDate(par)
{
	s adv=$p(par,"^",1)
	q:+adv=0 ""
	s recordId=$p(^DHCADVMASTER(adv),"^",1)
	s dicStr="HappenTime^NurOccTime^OccurTime"
	s ret=""
	f i=1:1:$l(dicStr,"^") d
	.s dicCode=$p(dicStr,"^",i)
	.s:ret="" ret=##class(web.DHCADVCOMMONPART).GetRecordValueByDic(recordId,dicCode)
	q ret
}

}
