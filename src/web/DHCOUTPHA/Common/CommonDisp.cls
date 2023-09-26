Class web.DHCOUTPHA.Common.CommonDisp Extends %Library.RegisteredObject
{

/// Creator		zzd
/// Creatdate	2018-11-7
/// Description	根据发药子表id和 库存项，获取已经发药(包欠药)数量
/// Input		发药子表id和 库存项id
/// Output		已经发药(包欠药)数量
/// w ##class(web.DHCOUTPHA.Common.CommonDisp).GetAlreadyDispQty("470||4",548)
ClassMethod GetAlreadyDispQty(orditm, inci)
{
	q:orditm="" 0
	q:inci="" 0
	s ownqty=..GetOwnQty(orditm,inci)
	s dispqty=..GetDispQty(orditm,inci)
	s dispenqty=0
	s dispenqty=dispqty+ownqty
	q dispenqty
}

/// Creator		zzd
/// Creatdate	2018-11-7
/// Description	根据发药子表id和 库存项，获取欠药数量
/// Input		发药子表id和 库存项id
/// Output		当前欠药数量
/// w ##class(web.DHCOUTPHA.Common.CommonDisp).GetOwnQty()
/// 
ClassMethod GetOwnQty(orditm, inci)
{
	q:orditm="" 0
	s ord=+orditm
	s itm=$p(orditm,"||",2)
	s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	
	s adm=$p(^OEORD(ord),"^",1)
	q:adm="" 0
    s papmi=$p(^PAADM(adm),"^",1)
    q:papmi="" 0
	
	s totalownqty=0
	s phow=0
	f  s phow=$o(^DHCPHOWi(0,"PAPMI",papmi,prescno,phow)) q:phow=""  d
	.s ownstatus=$p(^DHCPHOW(phow),"^",8)
	.q:ownstatus'=""			//已完成的欠药  不考虑
	.s retdate=$p(^DHCPHOW(phow),"^",10)
	.q:retdate'=""
	.s sub=0
	.f  s sub=$o(^DHCPHOW(phow,"I",sub)) q:sub=""  d
	..s tmpoeori=$p(^DHCPHOW(phow,"I",sub),"^",1)
	..q:(tmpoeori'=orditm)
	..s tmpinci=$p(^DHCPHOW(phow,"I",sub),"^",5)
	..q:tmpinci'=inci
	..s ownqty=$p(^DHCPHOW(phow,"I",sub),"^",2)
	..s totalownqty=totalownqty+ownqty
	q totalownqty
}

/// Creator		zzd
/// Creatdate	2018-11-7
/// Description	根据发药子表id和 库存项，获取欠药数量
/// Input		发药子表id和 库存项id
/// Output		当前欠药退药数量
/// w ##class(web.DHCOUTPHA.Common.CommonDisp).GetOwnRetQty()
/// 
ClassMethod GetOwnRetQty(orditm, inci)
{
	q:orditm="" 0
	s ord=+orditm
	s itm=$p(orditm,"||",2)
	s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	
	s adm=$p(^OEORD(ord),"^",1)
	q:adm="" 0
    s papmi=$p(^PAADM(adm),"^",1)
    q:papmi="" 0
	
	s totalownqty=0
	s phow=0
	f  s phow=$o(^DHCPHOWi(0,"PAPMI",papmi,prescno,phow)) q:phow=""  d
	.s ownstatus=$p(^DHCPHOW(phow),"^",8)
	.q:ownstatus'=""			//已完成的欠药  不考虑
	.s retdate=$p(^DHCPHOW(phow),"^",10)
	.q:retdate=""
	.s sub=0
	.f  s sub=$o(^DHCPHOW(phow,"I",sub)) q:sub=""  d
	..s tmpoeori=$p(^DHCPHOW(phow,"I",sub),"^",1)
	..q:(tmpoeori'=orditm)
	..s tmpinci=$p(^DHCPHOW(phow,"I",sub),"^",5)
	..q:tmpinci'=inci
	..s ownqty=$p(^DHCPHOW(phow,"I",sub),"^",2)
	..s totalownqty=totalownqty+ownqty
	q totalownqty
}

/// Creator		zzd
/// Creatdate	2018-11-7
/// Description	根据发药子表id和 库存项，获取发药数量
/// Input		发药子表id和 库存项id
/// Output		当前发药数量
/// w ##class(web.DHCOUTPHA.Common.CommonDisp).GetDispQty()
ClassMethod GetDispQty(orditm, inci)
{
	q:orditm="" 0
	s ord=+orditm
	s itm=$p(orditm,"||",2)
	s prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	
	s adm=$p(^OEORD(ord),"^",1)
	q:adm="" 0
    s papmi=$p(^PAADM(adm),"^",1)
    q:papmi="" 0
	s queId = +##class(PHA.HERB.Com.Method).PrescCYQueId(prescno)
	
	s totaldispqty=0
	i (queId = 0) d
	.s phdrowid=0
	.f  s phdrowid=$o(^DHCPHDISPi("PRESCNO",prescno,phdrowid)) q:phdrowid=""  d
	..s fyflag=$p(^DHCPHDISP(phdrowid),"^",4)
	..q:fyflag'=1			//未发不考虑
	..s phdirowid=0
	..f  s phdirowid=$o(^DHCPHDI(phdrowid,"PHDI",phdirowid))  q:phdirowid=""  d
	...s oeori=$p(^DHCPHDI(phdrowid,"PHDI",phdirowid),"^",5)
	...q:orditm'=oeori
	...s phdclb=0
	...f  s phdclb=$o(^DHCPHDI(phdrowid,"PHDI",phdirowid,"INCLB",phdclb))  q:phdclb=""  d
	....s inclb=$p(^DHCPHDI(phdrowid,"PHDI",phdirowid,"INCLB",phdclb),"^",3)
	....s Inc=+inclb
	....q:Inc'=inci
	....s dispqty=$p(^DHCPHDI(phdrowid,"PHDI",phdirowid,"INCLB",phdclb),"^",1)   //
	....s totaldispqty=totaldispqty+dispqty
	e  d
	.s phbdId = ""
	.f  s phbdId = $o(^BS.PHA.HERB.DISPENI("PrescNo", prescno, phbdId)) q:(phbdId = "")  d
	..s phbdItm = ""
	..f  s phbdItm = $o(^BS.PHA.HERB.DISPEND(phbdId, "I", phbdItm)) q:(phbdItm = "")  d
	...s phbdItmData = $g(^BS.PHA.HERB.DISPEND(phbdId, "I", phbdItm))
	...s oeori = $lg(phbdItmData, 3)
	...q:(orditm '= oeori)
	...s phbdic = ""
	...f  s phbdic = $o(^BS.PHA.HERB.DISPEND(phbdId, "I", phbdItm, "B", phbdic)) q:(phbdic = "")  d
	....s phbdicData = $g(^BS.PHA.HERB.DISPEND(phbdId, "I", phbdItm, "B", phbdic))
	....s dispqty = $lg(phbdicData, 2)
	....s totaldispqty=totaldispqty+dispqty
	q totaldispqty
}

/// Creator		zzd
/// Creatdate	2018-11-9
/// Description	根据用户代码，和门诊药房id获取配药人员id
/// Input		用户代码，和门诊药房id
/// Output		配药人员id
/// w ##class(web.DHCOUTPHA.Common.CommonDisp).GetPhpFrUserCode()
ClassMethod GetPhpFrUserCode(usercode, phloc)
{
	s userrow="",phprow="",ret=""
	s usercode=$ZCVT(usercode,"U")
	s userrow=$o(^SSU("SSUSR",0,"SSUSR_Initials",usercode,""))
	q:userrow="" ""
	f  s phprow=$o(^DHCPHPERi("USR",userrow,phprow)) q:(phprow="")||(ret'="")  d
	.s phploc=""
	.s phploc=+$p(^DHCPHPER(phprow),"^",3)
	.q:phploc'=phloc
	.s ret=phprow
	q ret
}

/// Creator		zzd
/// Creatdate	2018-11-9
/// Description	获取处方审核结果(审核过程:处方审核-》发药拒发。获取方式:先发药拒绝结果-》处方审核结果)
/// Input		处方号
/// Output		
/// w ##class(web.DHCOUTPHA.Common.CommonDisp).GetPrescAuditFlag("E181109000005")
ClassMethod GetPrescAuditFlag(prescno)
{
	
	s ssresult=##class(web.DHCOutPhCommon).GetOrdRefResultByPresc(prescno)
	i ssresult="S" d
	.s appealreason=##class(web.DHCOutPhCommon).GetOrdAppealReasonByPresc(prescno) //申诉理由
	.s ssresult="申诉拒绝"_"("_appealreason_")"
	i ssresult="N" s ssresult="拒绝发药"
	i ssresult="A" s ssresult="拒绝发药(接受)"
	i ssresult="Y" s ssresult="通过"
	i ssresult="" d				//发药拒绝为空 -》处方审核
	.s auditflag=##class(web.DHCOutPhCommon).GetOrdAuditResultByPresc(prescno)
	.i auditflag="N" s ssresult="拒绝"
	.i auditflag="Y" s ssresult="通过"
	.i auditflag="S" s ssresult="申诉"
	q ssresult
}

/// 检查其他未发药科室,没有返回"",有就返回科室串
/// w ##class(web.DHCOUTPHA.Common.CommonDisp).ChkUnFyOtherLoc("2017-08-03","2017-08-03","0000000222","2","2")
ClassMethod ChkUnFyOtherLoc(stdate, enddate, pmino, gphl, gphw = "")
{
	//s ^hlh($h)=$lb(stdate, enddate, pmino, gphl, gphw)
	s pmidr=""
	q:pmino="" -1
 	s pmidr=$o(^PAPERi("PAPMI_PatNo",pmino,""))
 	q:pmidr="" -2
 	s adm="",retadm=""
 	s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate)
 	s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
 	s fstdate=stdate
 	s fenddate=enddate
 	//已经收费的
 	s retInfo1=""
	f phadate=fstdate:1:fenddate  d
	.s phl=""
	.f  s phl=$o(^DHCPHARWi(phadate,phl)) q:phl=""  d
	..q:$d(findflag(phl))
	..s pha="",findflag=0
	..f  s pha=$o(^DHCPHARWi(phadate,phl,pha)) q:pha=""  d
	...s finflag=$p(^DHCPHARW(pha),"^",6)
	...q:(finflag="1")
	...s nouse=$p(^DHCPHARW(pha),"^",7)
	...q:nouse="1"
	...s retflag=$p(^DHCPHARW(pha),"^",13)
	...q:retflag'="1"
	...s prt=+$p(^DHCPHARW(pha),"^",1)
	...s papmidr=$p($g(^DHCINVPRT(prt)),"^",15)
	...q:pmidr'=papmidr
	...s phaphw=$p(^DHCPHARW(pha),"^",4)
	...q:phaphw=""
	...q:(gphl=phl)&&((gphw=phaphw)||(gphw=""))  // 科室+窗口相同不提示
	...s ctloc=$p($g(^DHCPHLOC(phl)),"^",1)
	...q:ctloc=""
	...s ctlocdesc=$p($g(^CTLOC(ctloc)),"^",2)
	...i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2)
	...s phwdesc=$p(^DHCPHWIN(phaphw),"^",1)
	...s tmpRetInfo=ctlocdesc_":"_phwdesc
	...q:$d(ChkUnFyOtherLoc(tmpRetInfo))
	...s ChkUnFyOtherLoc(tmpRetInfo)=""
	...s retInfo1=$s(retInfo1="":"　　"_tmpRetInfo,1:retInfo1_"</br>　　"_tmpRetInfo)
	i retInfo1'="" s retInfo1="待取药信息:</br>"_retInfo1
	k ChkUnFyOtherLoc
	s groupid=$s($d(%session):%session.Data("LOGON.GROUPID"),1:"")
	//未收费的
	s retInfo2=""
	s ordRet=..CheckCard(stdate, enddate, pmino, groupid, "") // ^1321||4^ 分隔的未交费串
	s ordI=0
	f ordI=1:1:$l(ordRet,"^") q:ordRet=0  d
	.s ordItm=$p(ordRet,"^",ordI)
	.q:ordRet=0
	.q:ordItm=""
	.s PayDispFlag=##class(PHA.OP.COM.Method).GetDispBeforePay(ordItm)
	.q:PayDispFlag="Y"
	.s priStr=##class(PHA.COM.Order).OeoriPriority(ordItm)
	.s priorCode=$p(priStr,"^",2)
	.q:priorCode["OM"
	.s recLocDr=$p(^OEORD(+ordItm,"I",$p(ordItm,"||",2),3),"^",6)
	.q:recLocDr=""
	.s PrescNo=$p(^OEORD(+ordItm,"I",$p(ordItm,"||",2),1),"^",14)
	.q:PrescNo=""
	.q:'$d(^DHCPHLOCi("LOC",+recLocDr))
	.q:$d(ChkUnFyOtherLoc(recLocDr))
	.s ChkUnFyOtherLoc(recLocDr)=1 
	.s ctlocdesc=$p($g(^CTLOC(recLocDr)),"^",2)
	.i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2)
	.s retInfo2=$s(retInfo2="":"　　"_ctlocdesc,1:retInfo2_"</br>　　"_ctlocdesc)
	i retInfo2'="" s retInfo2="待交费信息:</br>"_retInfo2
	k ChkUnFyOtherLoc
	s retInfo=retInfo1
	i retInfo2'="" s retInfo=retInfo_"</br>"_retInfo2
	q retInfo
}

ClassMethod CheckCard(stdate, enddate, pmino, groupid, ctloc)
{
 s pmidr="",ret=""
 s pmidr=$o(^PAPERi("PAPMI_PatNo",pmino,""))
 s adm="",retadm=""
 s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate)
 s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
 i pmidr="" q 0
 f  s adm=$o(^PAPERdr(pmidr,"ADM","O",adm)) q:adm=""  d
   .s admdate=""
   .s admdate=$p(^PAADM(adm),"^",6)
   .s status=""
   .s status=$p(^PAADM(adm),"^",20)
   .q:status["C"
   .q:admdate<stdate
   .q:admdate>enddate
   .i retadm'="" s retadm=retadm_"^"_adm 
   .e  s retadm=adm
  i retadm="" d
	.s retadm=##class(web.DHCDocEmergencyPatientList).GetEmergencyEpisode(pmidr, "" ,"")
 s ret=##class(web.udhcOPBillIF).ReadUFAdmOrder(retadm,"","",ctloc,"")
 i ret="" s ret=0
 q ret
}

/// creator:yunhaibao
/// createdate:20160602
/// description:根据发药记录判断皮试状态是否允许发药
/// 0-允许,1-不允许
/// w ##class(web.DHCOUTPHA.Common.CommonDisp).CheckSkinTestByPhd("147")
ClassMethod CheckSkinTestByPhd(phdrow)
{
	q:phdrow="" 0
	s checkskintest=1
	s dhcphditm=""
	f  s dhcphditm=$o(^DHCPHDI(phdrow,"PHDI",dhcphditm)) q:(dhcphditm="")!(checkskintest=0)  d
	.q:'$d(^DHCPHDI(phdrow,"PHDI",dhcphditm))
    .s oeori=$p(^DHCPHDI(phdrow,"PHDI",dhcphditm),"^",5)
    .s skintest=##class(web.DHCSTCOMMONORDER).OeoriSkinTest(oeori)
    .s:+$p(skintest,"^")'<0 checkskintest=0
	q checkskintest
}

}
