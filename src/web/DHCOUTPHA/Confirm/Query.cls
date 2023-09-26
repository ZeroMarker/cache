Import SQLUSER

/// creator:	yunhaibao
/// createdate: 2018-11-05
/// description:配药确认
Class web.DHCOUTPHA.Confirm.Query Extends %RegisteredObject
{

/// description: 查询,按药品汇总输出
/// w ##class(web.DHCOUTPHA.Confirm.Query).GetConfirmPYData("O181101000036")
ClassMethod GetConfirmPYData(InputStr)
{
	q:InputStr="" ""
	s PrescNo=$p(InputStr,"^",1)
	q:PrescNo="" ""
	s PhdId=..GetPhdByPrescNo(PrescNo)
	q:PhdId="" ""
	s PhLocId=$p(^DHCPHDISP(PhdId,1),"^",1)
	s PhaLocId=$p(^DHCPHLOC(PhLocId),"^",1)
	s HospId=$p($g(^CTLOC(+PhaLocId)),"^",22)
	s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag(HospId)	
	s phdItm=0
	f  s phdItm=$o(^DHCPHDI(PhdId,"PHDI",phdItm)) q:phdItm=""  d
	.s phdItmData=^DHCPHDI(PhdId,"PHDI",phdItm)
	.s oeori=$p(phdItmData,"^",5)
	.s admId=$p(^OEORD(+oeori),"^",1)
	.s admType=$p(^PAADM(admId),"^",2)
	.s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	.q:dspId=""
	.s ordId=+oeori
	.s ordItm=+$p(oeori,"||",2)
	.s billFlag=$p(^OEORD(ordId,"I",ordItm,3),"^",5) 
	.//(oeori,incId)
	.s dspSub=0
	.f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
	..s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
	..s incId=$p(dspSubData,"^",5)	
	..s inclb=$p(dspSubData,"^",1)	// 批次价有
	..s qty=$p(dspSubData,"^",2)
	..// 如果已经收费,按收费金额显示
	..i (billFlag="P")&&(admType'="H") d
	...s prtPriceStr=##class(web.DHCOutPhCommon).GetBasePriceByOe(oeori,dspId_"||"_dspSub)
	...s sp=$p(prtPriceStr,"^",1)
	...s spAmt=$p(prtPriceStr,"^",2)
	..e  d
	...s sp=$p(dspSubData,"^",4)
	...s spAmt=qty*sp
	..i '$d(GetConfirmPYDataData(oeori,incId)) d
	...s GetConfirmPYDataData(oeori,incId)=qty_"^"_spAmt
	..e  d
	...s $p(GetConfirmPYDataData(oeori,incId),"^",1)=qty+$p(GetConfirmPYDataData(oeori,incId),"^",1) 
	...s $p(GetConfirmPYDataData(oeori,incId),"^",2)=spAmt+$p(GetConfirmPYDataData(oeori,incId),"^",2) 
	// 详细输出数据
	s count=0
	s pid=..NewPid()
	s oeori=""
	f  s oeori=$o(GetConfirmPYDataData(oeori)) q:oeori=""  d
	.s ordId=+oeori
	.s ordItm=+$p(oeori,"||",2)
	.s dosage=##class(web.DHCSTCOMMONORDER).OeoriDosage(oeori)
	.s freqDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(oeori),"^",4)
	.s instrucDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriInstruc(oeori),"^",2)
	.s duraDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriDuration(oeori),"^",2)
	.s docName=$p(##class(web.DHCSTCOMMONORDER).OeoriDoctor(oeori),"^",2)
	.s oeoriStat=$p(##class(web.DHCSTCOMMONORDER).OeoriStat(oeori),"^",2)
	.s admId=$p(^OEORD(ordId),"^",1)
	.s patId=$p(^PAADM(admId),"^",1)
	.s patName=$p(^PAPER(patId,"ALL"),"^",1) 
	.s patNo=$p(^PAPER(patId,"PAT",1),"^",1) 
	.s admLocId=$p(^PAADM(admId),"^",4)
	.s admLocDesc=$p(^CTLOC(admLocId),"^",2)
	.s dispUomId=$p($g(^OEORD(ordId,"I",ordItm,"DHC")),"^",13)
    .i EncryptFlag=1 d
 	..s encryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(patId,"")
 	..s encryptLevel=$p(encryptLevelInfo,"^",1)
 	..s patLevel=$p(encryptLevelInfo,"^",2)
 	.e  s (encryptLevel,patLevel)=""
	.s incId=""
	.f  s incId=$o(GetConfirmPYDataData(oeori,incId)) q:incId=""  d
	..s incDesc=$p(^INCI(incId,1),"^",2)
	..s incCode=$p(^INCI(incId,1),"^",1)
	..s qty=$p(GetConfirmPYDataData(oeori,incId),"^",1)
	..s spAmt=$p(GetConfirmPYDataData(oeori,incId),"^",2)
	..i dispUomId'="" d
	...s fmtQtyUom=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,qty,dispUomId)
	..e  d
	...s fmtQtyUom=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(incId,qty)
	..s qty=$p(fmtQtyUom,"^",1)
	..s uomId=$p(fmtQtyUom,"^",2)
	..s fac=$p(fmtQtyUom,"^",3)
	..s sp=spAmt/qty // 转换完单位再除
	..s uomDesc=$p(^CT("UOM",uomId),"^",2)
	..s data1=incCode_"^"_incDesc_"^"_qty_"^"_uomDesc_"^"_dosage
	..s data2=freqDesc_"^"_instrucDesc_"^"_duraDesc_"^"_docName_"^"_patName
	..s data3=patNo_"^"_PhdId_"^"_encryptLevel_"^"_patLevel_"^"_sp
	..s data4=spAmt_"^"_PrescNo_"^"_oeoriStat
	..s data=data1_"^"_data2_"^"_data3_"^"_data4
	..s count=count+1
	..s ^TMP("DHCST",$ClassName(),"GetConfirmPYData",pid,count)=data
	q pid
}

ClassMethod GetPhdByPrescNo(PrescNo)
{
	s finalPhdId=""
	s phdId=0
	f  s phdId=$o(^DHCPHDISPi("PRESCNO",PrescNo,phdId)) q:phdId=""  d
	.s pyFlag=$p(^DHCPHDISP(phdId,1),"^",6)
	.s fyFlag=$p(^DHCPHDISP(phdId),"^",4)
	.q:pyFlag="1" 
	.q:fyFlag="1"
	.s finalPhdId=phdId
	q finalPhdId
}

/// creator:	 yunhaibao
/// createdate:  20160823
/// description: 统计当天某药房配药人的配药数,按配药日期
/// w ##class(web.DHCOUTPHA.Confirm.Query).RankOfDispConfirm("308^4638")
ClassMethod RankOfDispConfirm(InputStr)
{
	s RankPersons=[]
	s RankI=0
	s RankCount=10
	s LocId=$p(InputStr,"^",1)
	s UserId=$p(InputStr,"^",2)
	q:LocId="" ""
	s phLocId=$o(^DHCPHLOCi("LOC",LocId,""))
	q:(phLocId="")||(UserId="")||(LocId="") ""
	s pyDate=+$h //今天啊
	s phdId=""
	f  s phdId=$o(^DHCPHDISPi(pyDate,phLocId,phdId)) q:phdId=""  d 
	.s pyPerson=+$p(^DHCPHDISP(phdId,1),"^",3)
	.q:pyPerson=0
	.s pyUserId=+$p(^DHCPHPER(pyPerson),"^",5)
	.i $d(RankOfDispConfirmData(pyUserId)) d
	..s $p(RankOfDispConfirmData(pyUserId),"^",1)=$p(RankOfDispConfirmData(pyUserId),"^",1)+1
	.e  d
	..s RankOfDispConfirmData(pyUserId)=1
	s pyUserId=""
	f  s pyUserId=$o(RankOfDispConfirmData(pyUserId)) q:pyUserId=""  d
	.s count=+RankOfDispConfirmData(pyUserId)
	.q:+count=0
	.s RankOfDispConfirmSortData(count,pyUserId)="" //存在并列
	s includeMe=""
	s Title="id^name^count"
	s countRecords=0
	s outputI=""
	f  s outputI=$o(RankOfDispConfirmSortData(outputI),-1) q:(outputI="")||(countRecords>10)  d
	.s outputJ=""
	.f  s outputJ=$o(RankOfDispConfirmSortData(outputI,outputJ),-1) q:(outputJ="")||(countRecords>10)  d
	..s countRecords=countRecords+1 
	..q:countRecords>RankCount
	..s pyUserId=+outputJ
	..s count=+outputI
	..i $d(^SSU("SSUSR",pyUserId))  s pyUserName=$p($g(^SSU("SSUSR",pyUserId)),"^",2)
	..e  s pyUserName="未知"
	..s RankPerson={}
	..s RankPerson.id=pyUserId
	..s RankPerson.name=pyUserName
	..s RankPerson.count=count
	..d RankPersons.%Push(RankPerson)
	..i pyUserId=UserId s includeMe=1 
	..s RankI=RankI+1
	//登录人计数
	i includeMe="" d
	.s meCount=+$g(RankOfDispConfirmData(UserId))
	.s meName=$p($g(^SSU("SSUSR",UserId)),"^",2)
	.s RankPerson={}
	.s RankPerson.id=UserId
	.s RankPerson.name=meName
	.s RankPerson.count=meCount
	.d RankPersons.%Push(RankPerson)
	k RankOfDispConfirmData
	k RankOfDispConfirmSortData
	q RankPersons.%ToJSON()
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"OP")
}

}
