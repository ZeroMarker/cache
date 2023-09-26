/// 为兼容性考虑只能新增方法，修正方法，不能修改入参顺序（可后面新增，设置默认值），
Class web.DHCWLTJSCommonFunction Extends %RegisteredObject
{

/// 获取就诊号的主要诊断 没有的返回“Null”
/// chenyi
/// 2019-09-20
/// w ##class(web.DHCWLTJSCommonFunction).GetMainDiagTimeByAdm(54)
ClassMethod GetMainDiagTimeByAdm(admId)
{
 q:$g(admId)="" "Null"
 q:'$d(^PAADM(admId)) "Null"
 s admMainDR=$p(^PAADM(admId),"^",61)
 q:$g(admMainDR)="" "Null"
 q:'$d(^MR(admMainDR,"DIA")) "Null"
 s ret="Null"
 s mrdiaSub=0 f  s mrdiaSub=$o(^MR(admMainDR,"DIA",mrdiaSub)) q:(mrdiaSub="")!($g(mrcidDesc)'="")  d
 .s mainFlag=$p(^MR(admMainDR,"DIA",mrdiaSub,1),"^",20)
 .q:mainFlag'="Y" //主要诊断标记
 .s mrdiaIcdCode=$p(^MR(admMainDR,"DIA",mrdiaSub),"^")
 .s reMark=$g(^MR(admMainDR,"DIA",mrdiaSub,"DES",1))
 .i mrdiaIcdCode'=""  d
 ..i $d(^MRC("ID",mrdiaIcdCode))  d
 ...s mrcidDesc=$p($g(^MRC("ID",mrdiaIcdCode)),"^",2)
 ...s mrcidCode=$p($g(^MRC("ID",mrdiaIcdCode)),"^",4)
 ...s ret=mrcidDesc_"^"_mrcidCode
 .e  d
 ..i reMark'="" d
 ...s mrcidDesc=reMark_"*"  //串上一个*，表示取的备注诊断名称
 ...s mrcidCode=""
 ...s ret=mrcidDesc_"^"_mrcidCode
 q ret
}

/// 获取住院患者的第一个科室，病区，管床医生
/// chenyi
/// 2019-07-24
/// w ##class(web.DHCWLTJSCommonFunction).GetFirstDepWardDoc(123)
ClassMethod GetFirstDepWardDoc(admid)
{
	s locdr="",warddr="",docdr="999999"
	s transsub=0 f  s transsub=$o(^PAADM(admid,"TRANS",transsub)) q:(transsub="")||(warddr'="")  d    //!(flag=2)
	.s warddr=$p(^PAADM(admid,"TRANS",transsub),"^",9)
	
	s transsub=0 f  s transsub=$o(^PAADM(admid,"TRANS",transsub)) q:(transsub="")||(locdr'="")  d    //!(flag=2)
	.s locdr=$p(^PAADM(admid,"TRANS",transsub),"^",6) 

	s transsub=0 f  s transsub=$o(^PAADM(admid,"TRANS",transsub)) q:(transsub="")||((docdr'="999999")&&(docdr'=""))  d    //!(flag=2)
	.s docdr=$p(^PAADM(admid,"TRANS",transsub),"^",5)   //医生
	s:+docdr=0 docdr="999999"
	q warddr_"^"_locdr_"^"_docdr
}

/// 获取住院患者那天过夜的病区、科室、医生
/// chenyi
/// 2019-06-13
/// w ##class(web.DHCWLTJSCommonFunction).GetWardLocDoc($zdh("2019-06-01",3),123)
ClassMethod GetWardLocDoc(date, admid)
{
	s currlocdr="",currwarddr="",currdocdr="999999"
	s transsub=0 f  s transsub=$o(^PAADM(admid,"TRANS",transsub)) q:(transsub="")||(currwarddr'="")  d    //!(flag=2)
	.s warddr=$p(^PAADM(admid,"TRANS",transsub),"^",9)
	.s mTransSDate=$p(^PAADM(admid,"TRANS",transsub),"^",1)
	.s mTransSTime=$p(^PAADM(admid,"TRANS",transsub),"^",2)
	.q:$G(mTransSDate)=""
	.;q:$G(mTransSDate)'=$G(date)
	.q:$g(warddr)=""
	.i $G(mTransSDate)'>$G(date) d  ;转科时间小于或等于 当时时间
	..s currwarddr=warddr
	
	s transsub=0 f  s transsub=$o(^PAADM(admid,"TRANS",transsub)) q:(transsub="")||(currlocdr'="")  d    //!(flag=2)
	.s locdr=$p(^PAADM(admid,"TRANS",transsub),"^",6) 
	.s mTransSDate=$p(^PAADM(admid,"TRANS",transsub),"^",1)
	.s mTransSTime=$p(^PAADM(admid,"TRANS",transsub),"^",2)
	.q:$G(mTransSDate)=""
	.;q:$G(mTransSDate)'=$G(date)
	.q:$g(locdr)=""
	.i $G(mTransSDate)'>$G(date) d  ;转科时间小于或等于 当时时间
	..s currlocdr=locdr
	
	s transsub=0 f  s transsub=$o(^PAADM(admid,"TRANS",transsub)) q:(transsub="")||((currdocdr'="999999")&&(currdocdr'=""))  d    //!(flag=2)
	.s docdr=$p(^PAADM(admid,"TRANS",transsub),"^",5)   //医生
	.s mTransSDate=$p(^PAADM(admid,"TRANS",transsub),"^",1)
	.s mTransSTime=$p(^PAADM(admid,"TRANS",transsub),"^",2)
	.q:$G(mTransSDate)=""
	.;q:$G(mTransSDate)'=$G(date)
	.q:$g(docdr)=""
	.i $G(mTransSDate)'>$G(date) d  ;转科时间小于或等于 当时时间
	..s currdocdr=docdr
	s:+currdocdr=0 currdocdr=999999
	q currwarddr_"^"_currlocdr_"^"_currdocdr
}

/// 获取就诊号的结算时间 未结算的返回空 （只能统计门诊的结算时间）
/// chenyi
/// 2019-08-06
/// w ##class(web.DHCWLTJSCommonFunction).GetPRTTimeByAdm(2)
ClassMethod GetPRTTimeByAdm(admid)
{
	s ret=""
	s bciDr=0
	s bciDr=$o(^DHCBCI(0,"ADM",admid,""),-1)
	q:bciDr="" ret
	s prtDr=$p(^DHCBCI(bciDr),"^",1)
	s date=$P(^DHCINVPRT(prtDr),"^",5)
	s time=$P(^DHCINVPRT(prtDr),"^",20)
	i date'="" s ret=date_"^"_time
	q ret
}

/// 获取就诊号在dhc_workload表中的总费用
/// chenyi
/// 2019-06-13
/// w ##class(web.DHCWLTJSCommonFunction).GetTotalFeeByAdm(123)
ClassMethod GetTotalFeeByAdm(admid)
{
	s totalFee=0
	s wlId="" f  s wlId=$o(^DHCWorkLoad(0,"PAADM",admid,wlId)) q:wlId=""  d
	.s fee=$p(^DHCWorkLoad(wlId),"^",16)
	.s totalFee=totalFee+fee
	q totalFee
}

/// 获取就诊号的挂号时间
/// chenyi
/// 2019-08-06
/// w ##class(web.DHCWLTJSCommonFunction).GetRegTimeByAdm(2)
ClassMethod GetRegTimeByAdm(admid)
{
	s ret=""
	s regDr=$o(^User.DHCRegistrationFeeI("ADM"," "_admid,""),-1)
	q:regDr="" ret
	s date=$list(^User.DHCRegistrationFeeD(regDr),15)
	s time=$list(^User.DHCRegistrationFeeD(regDr),16)
	
 	s ret=date_"^"_time
	q ret
}

/// 获取就诊号的第一条医嘱时间 未开医嘱的返回空
/// 若项目想改成取医生的第一条医嘱时间,可以过滤开单医生是挂号员的医嘱
/// chenyi
/// 2019-08-06
/// w ##class(web.DHCWLTJSCommonFunction).GetFirstOeoriTimeByAdm(2)
ClassMethod GetFirstOeoriTimeByAdm(admid)
{
	s ret=""
	s ordDr=0
 	f  s ordDr=$o(^OEORD(0,"Adm",admid,ordDr)) q:(ordDr="")||($g(date)'="")  d
 	.;s date=$p(^OEORD(ordDr),"^",2)
 	.;s time=$p(^OEORD(ordDr),"^",3)
 	.s oeSubDr=0 f  s oeSubDr=$o(^OEORD(ordDr,"I",oeSubDr)) q:(oeSubDr="")||($g(date)'="")  d
 	..s date=$p(^OEORD(ordDr,"I",oeSubDr,3),"^",7)
 	..s time=$p(^OEORD(ordDr,"I",oeSubDr,1),"^",17)
 	..s ret=date_"^"_time
	q ret
}

/// 获取就诊号的第一条诊断时间 未开诊断的返回空
/// chenyi
/// 2019-08-06
/// w ##class(web.DHCWLTJSCommonFunction).GetFirstDiagTimeByAdm(54)
ClassMethod GetFirstDiagTimeByAdm(admid)
{
	s ret=""
	s mrAdm=$p(^PAADM(admid),"^",61)
 	s subDr=0 f  s subDr=$o(^MR(mrAdm,"DIA",subDr)) q:(subDr="")||($g(date)'="")  d
 	.s date=$p(^MR(mrAdm,"DIA",subDr),"^",7)
 	.s time=$p(^MR(mrAdm,"DIA",subDr),"^",8)
 	.s ret=date_"^"_time
	q ret
}

/// 获取就诊号的预约时间 未预约的返回空
/// chenyi
/// 2019-08-06
/// w ##class(web.DHCWLTJSCommonFunction).GetAppointmentTimeByAdm(2)
ClassMethod GetAppointmentTimeByAdm(admid)
{
	s ret=""
	s resource=0
	f  s resource=$o(^RBAS("ADM",admid,resource)) q:(resource="")||(+$g(ret)'=0)  d
	.s apptSchedule=0 f  s apptSchedule=$o(^RBAS("ADM",admid,resource,apptSchedule)) q:(apptSchedule="")||(+$g(ret)'=0)  d
	..s childSub=0 f  s childSub=$o(^RBAS("ADM",admid,resource,apptSchedule,childSub)) q:(childSub="")||(+$g(ret)'=0)  d
	...s mStatus=$p(^RBAS(resource,apptSchedule,"APPT",childSub),"^",3)         ;预约状态
 	...q:(mStatus="X")!(mStatus="J")  ;//取消和违约的不统计
 	...s transDate=$p(^RBAS(resource,apptSchedule,"APPT",childSub),"^",8)      ;预约日期
 	...s transTime=$p(^RBAS(resource,apptSchedule,"APPT",childSub),"^",9)      
 	...s ret=transDate_"^"_transTime        ;预预约日期时间
	q ret
}

/// 获取就诊号在的到达时间
/// chenyi
/// 2019-07-09
/// w ##class(web.DHCWLTJSCommonFunction).GetArriveTimeByAdm(2)
ClassMethod GetArriveTimeByAdm(admid)
{
	s ret=""
	s queId=0
	f  s queId=$o(^User.DHCQueueI("QuePaadmDrIndex",admid,queId)) q:queId=""  d
	.s statuDr=$li(^User.DHCQueueD(queId),14)
	.s statuDesc=$li(^User.DHCPerStateD(statuDr),4)
	.q:statuDesc'["到达"
	.s aDate=$li(^User.DHCQueueD(queId),19)
	.s aTime=$li(^User.DHCQueueD(queId),17)
	.s ret=aDate_"^"_aTime
	//如果不点到达按钮,直接下诊断,这个版本对列表没有变成到达状态,但是界面流程上显示到达,应这里是开诊断触发的到达,所以等于这里的时间
	i ret="" s ret=##class(web.DHCWLTJSCommonFunction).GetFirstDiagTimeByAdm(admid)  
	q ret
}

/// 将字符传转换为数组
/// w ##class(web.DHCWLTJSCommonFunction).ToArrayFromString("1,3,11,55,66",",",.depArr) 
ClassMethod ToArrayFromString(calString, spilitCode, ByRef array) As %String
{
	k array
	s num=$l($g(calString),spilitCode)
	i $g(calString)'="" d
	.f i=1:1:num d
	..s id=$p($g(calString),spilitCode,i)
	..s array(id)=i
	
	q 1
}

/// 获取该就诊号之前（含当次）全部的挂号次数
/// chenyi
/// 2019-07-09
/// w ##class(web.DHCWLTJSCommonFunction).GetRegNumByAdm(31)
ClassMethod GetRegNumByAdm(admid)
{
	s total=0,cancelTotal=0
	s papmi=$p(^PAADM(admid),"^",1)
	k data
	s data("E")=1
	s data("O")=1
	s type=""
	f  s type=$o(data(type)) q:type=""  d
	.s adm=admid+1 f  s adm=$o(^PAPERdr(papmi,"ADM",type,adm),-1) q:adm=""  d
	..s wrId=0 f  s wrId=$o(^DHCWorkRegReport(0,"PAADM",adm,wrId)) q:wrId=""  d
	...s regNum=$p($g(^DHCWorkRegReport(wrId)),"^",29)
	...s total=total+regNum					//挂号人数，已去除退号的患者
	...i regNum=-1 s cancelTotal=cancelTotal-regNum   //得到退号次数
	q total_"^"_cancelTotal
}

/// 获取该就诊号所有的发票号
/// chenyi
/// 2019-07-18
/// w ##class(web.DHCWLTJSCommonFunction).GetPRTNoByAdm(31)
ClassMethod GetPRTNoByAdm(admid)
{
	s ret=""
	s bciDr=""
	f  s bciDr=$o(^DHCBCI(0,"ADM",admid,bciDr)) q:bciDr=""  d
	.s prtId=$p(^DHCBCI(bciDr),"^",1)
	.s prtNo=""
	.i ret="" s ret=prtId
	.e  s ret=ret_","_prtId
	q ret
}

/// 获取该就诊号在出入转中的住院天数(出院患者不用传日期，在院患者传在院日期)
/// chenyi
/// 2019-07-18
/// w ##class(web.DHCWLTJSCommonFunction).GetZYRSFromCRZByAdm(adm,date)
ClassMethod GetZYRSFromCRZByAdm(admid, date)
{
	s num=0
	q:admid="" 0
	s zyDetailDr=0 f  s zyDetailDr=$o(^DHCMRIPDetail(0,"TYPE","ZYRS","ADM",admid,zyDetailDr)) q:zyDetailDr=""  d
	.s zyMRIPDr=$p(^DHCMRIPDetail(zyDetailDr),"^",3)
	.s zyLocDr=$p(^MRIPdaily(zyMRIPDr),"^",7) 
	.q:zyLocDr=""   //过滤掉院区数据
	.s zyDate=$p(^MRIPdaily(zyMRIPDr),"^",6) 
	.q:(zyDate>date)&&(date'="")
	.s num=num+1
	q num
}

}
