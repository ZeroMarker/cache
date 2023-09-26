Import sqluser

Class web.DHCOUTPHA.DispQuery.Query Extends %RegisteredObject
{

/// description: 发药列表
/// FyFlag:0(已配药),1(已发药),2(未发药),3(未配药),4(已打配药单)
/// 0,4,1 遍历发药表
/// 2,3	  遍历中间以及医嘱表
/// 排序没写,非统计类的,没啥大用,一旦排序就得获取全数据了
/// ("13/01/2017|@|13/11/2017|@|100)
ClassMethod CollDispMain(InputStr)
{
	q:InputStr="" ""
	s CS="|@|"
	s StartDate=$p(InputStr,CS,1)
	s EndDate=$p(InputStr,CS,2)
	s PhaLocId=$p(InputStr,CS,3)
	s PatNo=$p(InputStr,CS,4)
	s PatName=$p(InputStr,CS,5)
	s PrescNo=$p(InputStr,CS,6)	// 修改为处方号
	s IncId=$p(InputStr,CS,7)
	s PyPersonId=$p(InputStr,CS,8)
	s FyPersonId=$p(InputStr,CS,9)
	s FyFlag=$p(InputStr,CS,10)
	s StartTime=$p(InputStr,CS,11)
	s EndTime=$p(InputStr,CS,12)
	i (StartTime="00:00")||(StartTime="00:00:00") s StartTime=""
	i (EndTime="23:59")||(EndTime="23:59:59") s EndTime=""
	s ManaFlag=$p(InputStr,CS,13)
	s DocLocId=$p(InputStr,CS,14)
	q:PhaLocId="" ""
	s PhLocId=$o(^DHCPHLOCi("LOC",PhaLocId,""))
	q:PhLocId="" ""
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s pid=..NewPid()
	s calcuDate=""
	i FyFlag="1" d	
	./************************************************已发药-按发药日期**********/						
	.f calcuDate=StartDate:1:EndDate d
	..s phdId=0
	..f  s phdId=$o(^DHCPHDISPi("FYDATE",calcuDate,PhLocId,phdId)) q:phdId=""  d
	...s chkRet=$$CheckByPhdId(phdId)
	...q:chkRet'=1
	...s uniqueIndex=phdId
	...s prescNo=$p(^DHCPHDISP(phdId,2),"^",1)
	...q:(PrescNo'="")&&(PrescNo'=prescNo)
	...s ^TMP("DHCST",$ClassName(),"CollDispMain",pid,uniqueIndex)=prescNo_"^"_phdId
	...s prescNo=$p(^DHCPHDISP(phdId,2),"^",1)
	...// 索引+数据
	e  i (FyFlag="0")||(FyFlag="4") d		
	./************************************************已配未发,已打配药单-按配药日期**********/
	.f calcuDate=StartDate:1:EndDate d
	..s phdId=0
	..f  s phdId=$o(^DHCPHDISPi(calcuDate,PhLocId,phdId)) q:phdId=""  d
	...s chkRet=$$CheckByPhdId(phdId)
	...q:chkRet'=1
	...s prescNo=$p(^DHCPHDISP(phdId,2),"^",1)
	...q:(PrescNo'="")&&(PrescNo'=prescNo)
	...s uniqueIndex=phdId
	...s ^TMP("DHCST",$ClassName(),"CollDispMain",pid,uniqueIndex)=prescNo_"^"_phdId
	...// 索引+数据
	e  i (FyFlag="2")||(FyFlag="3") d		
	./************************************************未发未配**********/
	.f calcuDate=StartDate:1:EndDate d	
	../***********************************************已缴费未发**********/
	..s pharId=0
	..f  s pharId=$o(^DHCPHARWi(calcuDate,PhLocId,pharId)) q:pharId=""  d
	...s pharData=^DHCPHARW(pharId)
	...q:$p(pharData,"^",7)=1
	...s prescNo=$p(pharData,"^",16)
	...q:prescNo=""
	...q:(PrescNo'="")&&(PrescNo'=prescNo)
	...s GetDispMainData("PrescNo",prescNo)=""
	...// 过滤-已发
	...q:$p(pharData,"^",6)="1"
	...// 过滤条件-未配
	...q:(FyFlag="3")&&($p(pharData,"^",8)=1)
	...q:$$CheckByPrescNo(prescNo)'="1"
	...s tmpOrd=$o(^OEORD(0,"PrescNo",prescNo,""))
	...s tmpOrdItm=$o(^OEORD(0,"PrescNo",prescNo,tmpOrd,""))
	...q:##class(PHA.OP.COM.Method).GetDispBeforePay(tmpOrd_"||"_tmpOrdItm)="Y"
	...s uniqueIndex=+(tmpOrd_"."_tmpOrdItm)
	...s ^TMP("DHCST",$ClassName(),"CollDispMain",pid,uniqueIndex)=prescNo
	../************************************************先发药后交费未发**********/
	..s ordId=0
	..f  s ordId=$o(^OEORDi(0,"LocStDtArr",PhaLocId,0,calcuDate,ordId)) q:ordId=""  d
	...s admId=$p(^OEORD(ordId),"^",1) 
	...s ordItm=0
	...f  s ordItm=$o(^OEORDi(0,"LocStDtArr",PhaLocId,0,calcuDate,ordId,ordItm)) q:ordItm=""  d
	....s prescNo=$p(^OEORD(ordId,"I",ordItm,1),"^",14)
	....q:prescNo=""
	....q:(PrescNo'="")&&(PrescNo'=prescNo)
	....q:$d(GetDispMainData("PrescNo",prescNo))
	....s billFlag=$p(^OEORD(ordId,"I",ordItm,3),"^",5)
	....s oeoriStatCode=$p(##class(web.DHCSTCOMMONORDER).OeoriStat(ordId_"||"_ordItm),"^",1)
	....q:(billFlag'="P")&&((oeoriStatCode'="V")&&(oeoriStatCode'="E"))
	....s GetDispMainData("PrescNo",prescNo)=""
	....s dspId=$o(^DHCOEDISQTY(0,"OEORI",ordId_"||"_ordItm,""))
	....q:dspId=""
	....q:$p(^DHCOEDISQTY(dspId),"^",7)="C"				// 已发直接q
	....q:##class(PHA.OP.COM.Method).GetDispBeforePay(ordId_"||"_ordItm)'="Y"	// 非先发药后交费q
	....q:$$CheckByPrescNo(prescNo)'="1"				// 不合条件q
	....s uniqueIndex=+(ordId_"."_ordItm)
	....s ^TMP("DHCST",$ClassName(),"CollDispMain",pid,uniqueIndex)=prescNo
	q pid
CheckByPrescNo(prescNo)
	s chkRet="1"
	s tmpOrd=$o(^OEORD(0,"PrescNo",prescNo,""))
	q:tmpOrd="" ""
	s tmpOrdItm=$o(^OEORD(0,"PrescNo",prescNo,tmpOrd,""))
	s admId=$p(^OEORD(tmpOrd),"^",1) 
	s patId=$p(^PAADM(admId),"^",1)
	i (PatName'="")||(PatNo'="") d
	.s patName=$p(^PAPER(patId,"ALL"),"^",1)
	.i (PatName'="")&&(patName'[PatName) s chkRet="" q
	.s patNo=$p(^PAPER(patId,"PAT",1),"^",2)
	.i (PatNo'="")&&(PatNo'=patNo)  s chkRet=""
	// 过滤条件-管理药|药品
	i (IncId'="")||(ManaFlag="Y") d
	.s exist=""
	.s ordItm=""
	.f  s ordItm=$o(^OEORD(0,"PrescNo",prescNo,tmpOrd,ordItm)) q:ordItm=""  d
	..s oeori=tmpOrd_"||"_ordItm
	..q:..CheckMainCondition(PhaLocId, oeori, IncId, ManaFlag)'="Y"
	..s exist=1
	.i exist="" s chkRet=""
	q chkRet
CheckByPhdId(phdId)
	s chkRet="1"	// 默认符合条件
	s phdN1Data=$g(^DHCPHDISP(phdId,1))
	// 过滤条件-状态(0已配,1已发,4已打)
	s fyFlag=$p(^DHCPHDISP(phdId),"^",4)
	s pyFlag=$p(phdN1Data,"^",6)
	s printFlag=$p(phdN1Data,"^",9)
	i (FyFlag=1)&&(fyFlag'=1) q ""
	i (FyFlag'=1)&&(fyFlag=1) q ""	
	i (FyFlag=0)&&(pyFlag'=1) q ""	
	i (FyFlag=4)&&(printFlag'=1) q ""	
	// 过滤条件-时间
	i (StartTime'="")||(EndTime'="") d
	.i FyFlag=1 d
	..i StartTime'="" d
	...i (calcuDate=StartDate)&&($p(^DHCPHDISP(phdId),"^",5)<StartTime) s chkRet=""  q
	..i EndTime'="" d
	...i (calcuDate=EndDate)&&($p(^DHCPHDISP(phdId),"^",5)>EndTime) s chkRet="" q
	q:chkRet'=1 chkRet
	// 过滤条件-发药人
	i (FyPersonId'="")&&(FyPersonId'=$p(phdN1Data,"^",2)) q ""
	// 过滤条件-配药人
	i (PyPersonId'="")&&(PyPersonId'=$p(phdN1Data,"^",3)) q ""
	// 过滤条件-姓名登记号
	i (PatNo'="")||(PatName'="") d
	.s patId=$p(^DHCPHDISP(phdId),"^",7)
	.s patName=$p(^PAPER(patId,"ALL"),"^",1)
	.i (PatName'="")&&(patName'[PatName) s chkRet="" q
	.s patNo=$p(^PAPER(patId,"PAT",1),"^",2)
	.i (PatNo'="")&&(PatNo'=patNo)  s chkRet=""
	q:chkRet'=1 chkRet
	// 过滤条件-管理药|药品
	i (IncId'="")||(ManaFlag="Y") d
	.s exist=""
	.s phdItm=0
	.f  s phdItm=$o(^DHCPHDI(phdId,"PHDI",phdItm)) q:(phdItm="")||(exist'="")  d
	..s oeori=$p(^DHCPHDI(phdId,"PHDI",phdItm),"^",5)
	..q:..CheckMainCondition(PhaLocId, oeori, IncId, ManaFlag)'="Y"
	..s exist=1
	.i exist="" s chkRet=""
	q chkRet
}

/// description: 发药列表
/// w ##class(web.DHCOUTPHA.DispQuery.Query).GetDispMain(1,100,"2018-10-13|@|2018-11-13|@|308|@|0000000008|@||@||@||@||@||@|0|@|00:00|@|23:59|@|0|@||@|","") 
ClassMethod GetDispMain(StartRow, EndRow, InputStr, Pid = "")
{
	s ^TMPDHCSTPARAMS("web.DHCOUTPHA.DispQuery.Query","GetDispMain")=$lb(StartRow, EndRow, InputStr, Pid)
	i Pid'="" s pid=Pid
	e  s pid=..CollDispMain(InputStr)
	q:pid="" ""
	s PhaLocId=$p(InputStr,"|@|",3)
	s HospId=$p(^CTLOC(PhaLocId),"^",22)
	s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag(HospId)
	s count=0
	s uniqueIndex=""
	f  s uniqueIndex=$o(^TMP("DHCST",$ClassName(),"CollDispMain",pid,uniqueIndex)) q:uniqueIndex=""  d
	.s count=count+1
	.q:count<StartRow
    .q:count>EndRow
	.s collData=^TMP("DHCST",$ClassName(),"CollDispMain",pid,uniqueIndex)
	.s prescNo=$p(collData,"^",1)
	.s phdId=$p(collData,"^",2)
	.s tmpOrd=$o(^OEORD(0,"PrescNo",prescNo,""))
	.s tmpOrdItm=$o(^OEORD(0,"PrescNo",prescNo,tmpOrd,""))
	.s admId=$p(^OEORD(tmpOrd),"^",1) 
	.s patId=$p(^PAADM(admId),"^",1)
	.s patName=$p(^PAPER(patId,"ALL"),"^",1)
	.s patNo=$p(^PAPER(patId,"PAT",1),"^",2)
    .i EncryptFlag=1 d
 	..s encryptLevelInfo=##class(web.DHCSTInterfaceFromElse).GetPatEncryptLevel(patId)
 	..s encryptLevel=$p(encryptLevelInfo,"^",1)
 	..s patLevel=$p(encryptLevelInfo,"^",2)
 	.e  s (encryptLevel,patLevel)=""
	.s tmpOeori=tmpOrd_"||"_tmpOrdItm
	.s docLocDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriDocLoc(tmpOeori),"^",2)
	.s oeoriDateTime=##class(web.DHCSTCOMMONORDER).OeoriDateTime(tmpOeori)
	.s diagDesc=##class(web.DHCSTCOMMONORDER).MrDiagnose(admId,",")
	.s admReasonDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriAdmReason(tmpOeori),"^",2)
	.s curWardId=$p(^PAADM(admId),"^",70)
	.i curWardId'="" d
	..s curWardLocId=$p(^PAWARD(curWardId),"^",5)
	..s wardDesc=$p(^CTLOC(curWardLocId),"^",2)
	..i wardDesc["-" s wardDesc=$p(wardDesc,"-",2)
	..s docLocDesc=docLocDesc_"["_wardDesc_"]"
	.s prescRemark=""
	.i $d(^PAQUE1(0,"PrescNo",prescNo)) d
	..s queId=$o(^PAQUE1(0,"PrescNo",prescNo,""))
	..s prescRemark=$P($g(^PAQUE1(+queId,"DHC")),"^",21)
	.s (pyUserName,fyUserName,pyDate,fyDate,pyTime,fyTime,phdOweId)=""
	.i phdId'="" d
	..s fyPersonId=$p(^DHCPHDISP(phdId,1),"^",2)
	..s pyPersonId=$p(^DHCPHDISP(phdId,1),"^",3)
	..s fyDate=$p(^DHCPHDISP(phdId),"^",3)
	..s fyTime=$p(^DHCPHDISP(phdId),"^",5)
	..s pyDate=$p(^DHCPHDISP(phdId,1),"^",5)
	..s pyTime=$p(^DHCPHDISP(phdId,1),"^",7)
	..s fyUserName=$p($g(^DHCPHPER(+fyPersonId)),"^",2)
	..s pyUserName=$p($g(^DHCPHPER(+pyPersonId)),"^",2)
	..s fyDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(fyDate)
	..s pyDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(pyDate)
	..s fyTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(fyTime)
	..s pyTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(pyTime)
	..s phdOweId=$p(^DHCPHDISP(phdId,2),"^",2)
	.i (phdId'="")&&($p(^DHCPHDISP(phdId),"^",4)=1) d
	..s amtData=..GetPhdAmtData(phdId)
	..s spAmt=$p(amtData,"^",1)
	.e  d
	..s spAmtStr=##class(web.DHCOutPhDisp).GetPrescAmt(prescNo,PhaLocId,"")
	..s spAmt=$p(spAmtStr,"^",1)
	.s pharId=$o(^DHCPHARi("PRESCNO",prescNo,""),-1)
	.s (prtTime,prtDate)=""
	.i pharId'="" d
	..s prtDate=$p(^DHCPHARW(pharId),"^",2)
	..s prtTime=$p(^DHCPHARW(pharId),"^",5)
	..s prtDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(prtDate)
	..s prtTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(prtTime)
	.s data1=phdId_"^"_prescNo_"^"_patNo_"^"_patName_"^"_spAmt
	.s data2=pyUserName_"^"_fyUserName_"^"_admReasonDesc_"^"_docLocDesc_"^"_prescRemark
	.s data3=diagDesc_"^"_oeoriDateTime_"^"_prtDate_"^"_pyDate_"^"_fyDate
	.s data4=prtTime_"^"_pyTime_"^"_fyTime_"^"_phdOweId_"^"_pid
	.s data5=encryptLevel_"^"_patLevel
	.s data=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5	
	.s ^TMP("DHCST",$ClassName(),"GetDispMain",pid,count)=data
	q pid_"^"_count
}

/// description: 药品汇总明细
/// w ##class(web.DHCOUTPHA.DispQuery.Query).GetDispIncDetail("|@|E181128000003|@|309")
ClassMethod GetDispIncDetail(InputStr)
{
	s ^TMPDHCSTPARAMS("web.DHCOUTPHA.DispQuery.Query","GetDispIncDetail")=InputStr
	s cName=$ClassName()
	s mName="CollDispDetail"
	s gName="GetDispIncDetail"
	s pid=..CollDispDetail(InputStr,"GetDispIncDetail")
	q:pid="" ""
	s PhaLocId=$p(InputStr,"|@|",3)
	s count=0
	s oeori=""
	f  s oeori=$o(^TMP("DHCST",cName,mName,gName,pid,oeori)) q:oeori=""  d
	.s ordId=+oeori
	.s ordItm=+$p(oeori,"||",2)
	.s freqDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(oeori),"^",4)
	.s oeoriStatDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriStat(oeori),"^",2)
	.s instrucDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriInstruc(oeori),"^",2)
	.s dosage=##class(web.DHCSTCOMMONORDER).OeoriDosage(oeori)
	.s duraDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriDuration(oeori),"^",2)
	.s oeoriRemark=$p($g(^OEORD(ordId,"I",ordItm,2)),"^",8)
	.i oeoriRemark="" s oeoriRemark=##class(web.DHCSTCOMMONORDER).OeoriRemark(oeori)
	.s docName=$p(##class(web.DHCSTCOMMONORDER).OeoriDoctor(oeori),"^",2)
	.i docName="" d	// 非医生开单,doctordr为空
	..s userAddId=$p($g(^OEORD(ordId,"I",ordItm,1)),"^",11)
	..i userAddId'="" s docName=$p($g(^SSU("SSUSR",userAddId)),"^",2)	
	.s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	.s dispUomId=$p($g(^OEORD(ordId,"I",ordItm,"DHC")),"^",13)
	.s incId=""
	.f  s incId=$o(^TMP("DHCST",cName,mName,gName,pid,oeori,incId)) q:incId=""  d
	..s tmpData=^TMP("DHCST",cName,mName,gName,pid,oeori,incId)
	..s dspQty=##class(web.DHCSTCOMMONSRV).GetDspInciQtyByDsp(dspId,incId)
	..s qty=$p(tmpData,"^",2)
	..s spAmt=$p(tmpData,"^",3)
	..s retQty=$p(tmpData,"^",4)
	..s incDesc=$p(^INCI(incId,1),"^",2)
	..s incCh=$o(^INCI("IL_LOC",PhaLocId,incId,""))
	..i incCh'="" s stkBinStr=$p(##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incId_"||"_incCh,",","",""),":",2) 
	..e  s stkBinStr=""
	..i dispUomId="" d
	...s fmtQtyUom=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(incId,qty)
	..e  d
	...s fmtQtyUom=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,qty,dispUomId)
	..s qty=$p(fmtQtyUom,"^",1)
	..s uomId=$p(fmtQtyUom,"^",2)
	..s fac=$p(fmtQtyUom,"^",3)
	..s dspQty=dspQty/fac
	..s retQty=retQty/fac
	..s uomDesc=$p(^CT("UOM",uomId),"^",2)
	..s data1=incDesc_"^"_qty_"^"_uomDesc_"^"_spAmt_"^"_retQty
	..s data2=freqDesc_"^"_instrucDesc_"^"_duraDesc_"^"_dosage_"^"_oeoriStatDesc
	..s data3=stkBinStr_"^"_oeoriRemark_"^"_docName_"^"_dspQty
	..s data=data1_"^"_data2_"^"_data3
	..s count=count+1
	..s ^TMP("DHCST",$ClassName(),"GetDispIncDetail",pid,count)=data
	k ^TMP("DHCST",cName,mName,gName,pid)
	q pid_"^"_count
}

/// description: 药品批次明细
/// w ##class(web.DHCOUTPHA.DispQuery.Query).GetDispInclbDetail("53|@|O181105000016|@|308")
ClassMethod GetDispInclbDetail(InputStr)
{
	s ^TMPDHCSTPARAMS("web.DHCOUTPHA.DispQuery.Query","GetDispInclbDetail")=InputStr
	s cName=$ClassName()
	s mName="CollDispDetail"
	s gName="GetDispInclbDetail"
	s pid=..CollDispDetail(InputStr,"GetDispInclbDetail")
	q:pid="" ""
	s PhaLocId=$p(InputStr,"|@|",3)
	s count=0
	s oeori=""
	f  s oeori=$o(^TMP("DHCST",cName,mName,gName,pid,oeori)) q:oeori=""  d
	.s ordId=+oeori
	.s ordItm=+$p(oeori,"||",2)
	.s dispUomId=$p($g(^OEORD(ordId,"I",ordItm,"DHC")),"^",13)
	.s incld=""
	.f  s incld=$o(^TMP("DHCST",cName,mName,gName,pid,oeori,incld)) q:incld=""  d
	..s tmpData=^TMP("DHCST",cName,mName,gName,pid,oeori,incld)
	..s qty=$p(tmpData,"^",2)
	..s spAmt=$p(tmpData,"^",3)
	..s retQty=$p(tmpData,"^",4)
	..s sp=$p(tmpData,"^",5)
	..s inclb=$p(tmpData,"^",6)
	..s incId=+inclb
	..s incDesc=$p(^INCI(incId,1),"^",2)
	..i dispUomId="" d
	...s fmtQtyUom=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(incId,qty)
	..e  d
	...s fmtQtyUom=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,qty,dispUomId)
	..s qty=$p(fmtQtyUom,"^",1)
	..s uomId=$p(fmtQtyUom,"^",2)
	..s fac=$p(fmtQtyUom,"^",3)
	..s sp=sp*fac
	..s retQty=retQty/fac
	..s uomDesc=$p(^CT("UOM",uomId),"^",2)
	..s incib=$p(^INCI(incId,"IL",+$p(inclb,"||",2),"LB",+$p(inclb,"||",3)),"^",1)
	..s incIb=+$p(incib,"||",2)
	..s batNo=$p($g(^INCI(incId,"IB",incIb)),"^",1)
	..s expDate=$p($g(^INCI(incId,"IB",incIb)),"^",2)
	..s expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate)
	..s data1=incDesc_"^"_qty_"^"_uomDesc_"^"_spAmt_"^"_retQty
	..s data2=batNo_"^"_expDate_"^"_sp_"^"_inclb
	..s data=data1_"^"_data2
	..s count=count+1
	..s ^TMP("DHCST",$ClassName(),"GetDispInclbDetail",pid,count)=data
	k ^TMP("DHCST",cName,mName,gName,pid)
	q pid_"^"_count
}

/// description: 发药明细,发药表有数据以发药表为准,已发以孙表为准,其他以医嘱表为准
/// 药品明细按药品汇总(批不批次都这样)
/// 药品批次明细	   同理完全按批次汇总(已发药的按发药表没毛病,未发药不显示)
/// QueryType:GetDispIncDetail
/// QueryType:GetDispInclbDetail
ClassMethod CollDispDetail(InputStr, QueryType)
{
	s PhdId=$p(InputStr,"|@|",1)
	s PrescNo=$p(InputStr,"|@|",2)
	s PhaLocId=$p(InputStr,"|@|",3)
	q:PrescNo="" ""
	q:PhaLocId="" ""
	s pid=..NewPid()
	s HospId=$p(^CTLOC(PhaLocId),"^",22)
	s Perv="^^^^"_HospId_"^DHC"
	s FyFlag=""
	i PhdId'="" s FyFlag=$p(^DHCPHDISP(PhdId),"^",4)
	i FyFlag=1 d CalcuByPhdItmLb
	e  d CalcuByPrescNo
	q pid
CalcuByPhdItmLb
	s phdItm=""
	f  s phdItm=$o(^DHCPHDI(PhdId,"PHDI",phdItm)) q:phdItm=""  d
	.s oeori=$p(^DHCPHDI(PhdId,"PHDI",phdItm),"^",5)
	.s phdItmLb=0
	.f  s phdItmLb=$o(^DHCPHDI(PhdId,"PHDI",phdItm,"INCLB",phdItmLb)) q:phdItmLb=""  d
	..s phdItmLbData=^DHCPHDI(PhdId,"PHDI",phdItm,"INCLB",phdItmLb)
	..s inclb=$p(phdItmLbData,"^",3)
	..s incId=+inclb
	..s qty=$p(phdItmLbData,"^",1)
	..s spAmt=$p(phdItmLbData,"^",8)
	..s retQty=$p(phdItmLbData,"^",2)
	..s dspSubId=$p(phdItmLbData,"^",9)
	..s sp=$p(phdItmLbData,"^",7)
	..i QueryType="GetDispIncDetail" d SetDispIncDetail
	..e  i QueryType="GetDispInclbDetail" d SetDispInclbDetail
	q
CalcuByPrescNo
	s ordId=0
	f  s ordId=$o(^OEORD(0,"PrescNo",PrescNo,ordId))  q:ordId=""  d 
	.s ordItm=0
	.f  s ordItm=$o(^OEORD(0,"PrescNo",PrescNo,ordId,ordItm)) q:ordItm=""  d
	..s oeori=ordId_"||"_ordItm
	..s billFlag=$p(^OEORD(ordId,"I",ordItm,3),"^",5)  		// P已缴费
	..s quitFlag=""
	..i PhdId'="" d
	...i '$d(^DHCPHDI(0,"OEORI",oeori,PhdId)) s quitFlag=1	// 不存在即不符合发药条件
	..e  d
	...s priStr=##class(web.DHCSTCOMMONORDER).OeoriPriority(oeori)
	...// 过滤-自备
	...i priStr["OM" s quitFlag=1	
	...s oeoriStatCode=$p(##class(web.DHCSTCOMMONORDER).OeoriStat(oeori),"^",1)
	...// 过滤-未交费停医嘱
	...i (billFlag'="P")&&((oeoriStatCode'="V")&&(oeoriStatCode'="E")) s quitFlag=1
	..q:quitFlag'=""
	..s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	..q:dspId=""
	..s dspSub=0
	..f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
	...s dspSubId=dspId_"||"_dspSub
	...s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
	...s inclb=$p(dspSubData,"^",1)
	...s incId=$p(dspSubData,"^",5)
	...s qty=$p(dspSubData,"^",2)
	...s dspQty=qty
	...i billFlag="P" d
	....s prtPriceStr=##class(web.DHCOutPhCommon).GetBasePriceByOe(oeori,dspSubId)
	....s sp=$p(prtPriceStr,"^",1)
	....s spAmt=$p(prtPriceStr,"^",2)
	...e  d
	....s getSpInc=incId
	....i inclb'="" s getSpInc=inclb
	....s sp=##class(web.DHCSTPRICE).GetSp(getSpInc,+$h,"",HospId,"","")
	....s spAmt=sp*qty
	....s spAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(spAmt,Perv,"FmtSA",1)
	...s retQty=0
	...i QueryType="GetDispIncDetail" d SetDispIncDetail
	q
SetDispIncDetail
	i '$d(^TMP("DHCST",$ClassName(),"CollDispDetail",QueryType,pid,oeori,incId)) d
	.s ^TMP("DHCST",$ClassName(),"CollDispDetail",QueryType,pid,oeori,incId)=oeori_"^"_qty_"^"_spAmt_"^"_retQty
	e  d
	.s $p(^TMP("DHCST",$ClassName(),"CollDispDetail",QueryType,pid,oeori,incId),"^",2)=qty+$p(^TMP("DHCST",$ClassName(),"CollDispDetail",QueryType,pid,oeori,incId),"^",2)
	.s $p(^TMP("DHCST",$ClassName(),"CollDispDetail",QueryType,pid,oeori,incId),"^",3)=spAmt+$p(^TMP("DHCST",$ClassName(),"CollDispDetail",QueryType,pid,oeori,incId),"^",3)
	.s $p(^TMP("DHCST",$ClassName(),"CollDispDetail",QueryType,pid,oeori,incId),"^",4)=retQty+$p(^TMP("DHCST",$ClassName(),"CollDispDetail",QueryType,pid,oeori,incId),"^",4)
	q
SetDispInclbDetail
	// 按批次+售价的先分开
	s inclbIndex=inclb_"^"_sp
	i '$d(^TMP("DHCST",$ClassName(),"CollDispDetail",QueryType,pid,oeori,inclbIndex)) d
	.s ^TMP("DHCST",$ClassName(),"CollDispDetail",QueryType,pid,oeori,inclbIndex)=oeori_"^"_qty_"^"_spAmt_"^"_retQty_"^"_sp_"^"_inclb
	e  d
	.s $p(^TMP("DHCST",$ClassName(),"CollDispDetail",QueryType,pid,oeori,inclbIndex),"^",2)=qty+$p(^TMP("DHCST",$ClassName(),"CollDispDetail",QueryType,pid,oeori,inclbIndex),"^",2)
	.s $p(^TMP("DHCST",$ClassName(),"CollDispDetail",QueryType,pid,oeori,inclbIndex),"^",3)=spAmt+$p(^TMP("DHCST",$ClassName(),"CollDispDetail",QueryType,pid,oeori,inclbIndex),"^",3)
	.s $p(^TMP("DHCST",$ClassName(),"CollDispDetail",QueryType,pid,oeori,inclbIndex),"^",4)=retQty+$p(^TMP("DHCST",$ClassName(),"CollDispDetail",QueryType,pid,oeori,inclbIndex),"^",4)
	q
}

/// description: 根据医嘱id判断药品管理药
/// return:		 Y(存在)
ClassMethod CheckMainCondition(PhaLocId, Oeori, IncId, ManaFlag)
{
	s dspId=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""))
	q:dspId="" ""
	s exist=""
	s dspSub=0
	k CheckMainCondition
	f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:(dspSub="")||(exist'="")  d
	.s incId=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",5)
	.q:incId=""
	.q:$d(CheckMainConditionArr("IncId",incId))
	.s quitFlag=""
	.s CheckMainConditionArr("IncId",incId)=""
	.s incCh=$o(^INCI("IL_LOC",PhaLocId,incId,""))
	.q:incCh=""
	.i ManaFlag="Y" d
	..s incil=incId_"||"_incCh
	..s dhcIncil=$o(^DHCINCIL(0,"INCIL",incil,""))
	..i dhcIncil="" s quitFlag=1 q
	..s manaFlag=$p(^DHCINCIL(dhcIncil),"^",9)  //1,0
	..i (ManaFlag="Y")&&(manaFlag'=1) s quitFlag=1 q
	.q:(IncId'="")&&(incId'=IncId)
	.q:quitFlag'=""
	.s exist="Y"
	q exist
}

/// description: 获取已发药+已退的总金额
/// return:		 金额
ClassMethod GetPhdAmtData(PhdId)
{
	q:PhdId="" ""
	s phdSpAmt=0
	s phdItm=0
	f  s phdItm=$o(^DHCPHDI(PhdId,"PHDI",phdItm)) q:phdItm=""  d
	.s phdItmLb=0
	.f  s phdItmLb=$o(^DHCPHDI(PhdId,"PHDI",phdItm,"INCLB",phdItmLb)) q:phdItmLb=""  d
	..s phdItmLbData=^DHCPHDI(PhdId,"PHDI",phdItm,"INCLB",phdItmLb)
	..s spAmt=$p(phdItmLbData,"^",8)
	..s phdSpAmt=phdSpAmt+spAmt
	q phdSpAmt
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"OP")
}

}
