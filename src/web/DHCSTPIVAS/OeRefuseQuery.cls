/// creator:	 yunhaibao
/// createdate:  2018-06-25
/// description: 拒绝配液医嘱查询
/// 
Class web.DHCSTPIVAS.OeRefuseQuery Extends web.DHCSTPIVAS.Common
{

/// creator:	yunhaibao
/// createdate: 2018-06-25
/// description:拒绝配液查询,对应配液拒绝业务,按执行记录
/// input:		^1:就诊Id,^2:登陆科室Id,^3:用药开始日期,^4:用药结束日期,^5:登记号
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.OeRefuseQuery","QueryOeRefuse","78^151^2020-01-26^2020-02-04^0000000069")
Query QueryOeRefuse(inputStr = "") As websys.Query(ROWSPEC = "oeoriSign,mDsp,patNo,patName,freqDesc,instrucDesc,docName,doseDateTime,batNo,packFlag,incDesc,incSpec,dosage,qty,bUomDesc,ordRemark,priDesc,bedNo,colColor,pogId,wardDesc,warnInfo,operReason")
{
}

ClassMethod QueryOeRefuseExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
#;	s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.OeRefuseQuery","QueryOeRefuse")=inputStr
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s AdmId=$p(inputStr,"^",1)
	q:AdmId="" $$$OK
	s LocId=$p(inputStr,"^",2)
	q:LocId="" $$$OK
	s StDate=$p(inputStr,"^",3)
	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	s EdDate=$p(inputStr,"^",4)
	s EdDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EdDate)
	i StDate="" s StDate=+$h-1
	i EdDate="" s EdDate=+$h+1
	s PatNo=$p(inputStr,"^",5)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s dspStatusStr="C^TC"
	s dspStatusLen=$l(dspStatusStr,"^")
	k PIVALOCDATA
	s psId=0
	f  s psId=$o(^PIVAS(psId)) q:psId=""  d
	.s psData=^PIVAS(psId)
	.s ctLoc=$p(psData,"^",7)
	.q:$p(psData,"^",3)'="Y"
	.s ctHospId=$p(^CTLOC(ctLoc),"^",22)
	.q:HospId'=ctHospId	
	.s PIVALOCDATA(ctLoc)=""
	s ctLocId=""
	f  s ctLocId=$o(PIVALOCDATA(ctLocId)) q:ctLocId=""  d	
	.s ordId=$o(^OEORD(0,"Adm",AdmId,""))
	.q:ordId=""
	.s calcuDate=""
	.f calcuDate=StDate:1:EdDate d
 	..s dspI=""
 	..f dspI=1:1:dspStatusLen d
 	...s dspStatus=$p(dspStatusStr,"^",dspI)
	...s dspId=""
	...f  s dspId=$o(^DHCOEDISQTY(0,"ADM",ctLocId,calcuDate,dspStatus,AdmId,dspId)) q:dspId=""  d
	....q:+dspId=0
	....s grpNo=$p(^DHCOEDISQTY(dspId),"^",4)
	....s mDsp=##class(web.DHCSTPIVAS.Common).GetMainDspId(dspId,grpNo)
	....q:$d(QueryOeRefuseArr("mDsp",mDsp))
	....s QueryOeRefuseArr("mDsp",mDsp)=""
	....s mDspData=^DHCOEDISQTY(mDsp)
	....s mOeore=$p(mDspData,"^",3)
	....// 过滤-停止执行记录
	....q:##class(web.DHCSTPIVAS.Common).CheckOeoreStat(mOeore)'=1
	....s pogId=$o(^PIVA(0,"OEGRP",mDsp,grpNo,""))
	....q:pogId=""
	....s pogOper=$P(^PIVA(pogId),"^",8) 
	....q:pogOper'="R"
	....s sortIndex="1"
	....s QueryOeRefuseData(sortIndex,mDsp)=""
	s colColor=0
	s sortIndex=""
	f  s sortIndex=$o(QueryOeRefuseData(sortIndex)) q:sortIndex=""  d
	.s mDsp=""
	.f  s mDsp=$o(QueryOeRefuseData(sortIndex,mDsp)) q:mDsp=""  d
	..s grpNo=$p(^DHCOEDISQTY(mDsp),"^",4)
    ..s pogId=$o(^PIVA(0,"OEGRP",mDsp,grpNo,""))
    ..s mOeori=$p(^DHCOEDISQTY(mDsp),"^",1)
    ..s mOeore=$p(^DHCOEDISQTY(mDsp),"^",3)
	..s mOrdId=+mOeori
    ..s doseDate=$p(^DHCOEDISQTY(mDsp),"^",21)
    ..s doseTime=$p(^DHCOEDISQTY(mDsp),"^",20)
    ..s doseDTHtml=##class(web.DHCSTPIVAS.Common).DateShortFormat(doseDate)_" "_##class(web.DHCSTPIVAS.Common).TimeShortFormat(doseTime)
	..s curPsId=$P(^PIVA(pogId),"^",6)
    ..s batNo=$p(^PIVA(pogId),"^",3)
	..s admId=$p(^OEORD(+mOeori),"^",1) 
	..s patId=$p(^PAADM(admId),"^",1)                    						
	..s patName=$p(^PAPER(patId,"ALL"),"^",1)
	..s patNo=$p(^PAPER(patId,"PAT",1),"^",1)
	..q:(PatNo'="")&&(patNo'=PatNo)
	..s bedId=$p(^PAADM(admId),"^",73)
	..s bedNo="*"
 	..i bedId'="" s bedNo=$P($g(^PAWARD(+bedId,"BED",+$p(bedId,"||",2))),"^",1)
	..s freqDesc=$p(##class(web.DHCSTPIVAS.Common).OeoriFreq(mOeori),"^",2)
	..s instrucDesc=$p(##class(web.DHCSTPIVAS.Common).OeoriInstruc(mOeori),"^",2)
	..s docName=$p(##class(web.DHCSTPIVAS.Common).OeoriDoctor(mOeori),"^",2)
	..s packFlag=##class(web.DHCSTPIVAS.Common).DspPackFlag(mDsp)
	..s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
	..s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,"")) 
	..s wardDesc=##class(PHA.COM.Data.Base).WardDesc(wardId)
	..s pogOper=$p(^PIVA(pogId),"^",8)
	..s warnInfo=""
	..i pogOper="R" s warnInfo=..Translate("配液拒绝")  // @translate
	..s operReasonId=$p(^PIVA(pogId),"^",9)
	..s operReason=##class(PHA.COM.Data.Base).PIVAOperReasonDesc(operReasonId)
    ..s pogNum=$o(^PIVA(pogId,"I",""),-1)
    ..s colColor=colColor+1,pogItmCnt=0
    ..s pogItm=""
    ..f  s pogItm=$o(^PIVA(pogId,"I",pogItm)) q:pogItm=""  d
    ...q:+pogItm=0
    ...s dspId=$p(^PIVA(pogId,"I",pogItm),"^",1)
    ...d GetOeDspData
	q $$$OK
GetOeDspData
	s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
 	s incStr=##class(web.DHCSTPIVAS.Common).GetIncItmByOeori(oeori)
 	s incId=$P(incStr,"^",1)
 	q:incId=""
 	s incDesc=$P(incStr,"^",3) 
 	s incSpec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",incId)
	s dosage=##class(web.DHCSTPIVAS.Common).OeoriDosage(oeori)
	s qty=$fn($P(^DHCOEDISQTY(dspId),"^",11),"N")
	s bUom=$p(^INCI(incId,1),"^",10)
	s bUomDesc=##class(PHA.COM.Data.Base).UomDesc(bUom)
	s ordRemark=##class(web.DHCSTPIVAS.Common).OeoriRemark(oeori)
	s priDesc=$p(##class(web.DHCSTPIVAS.Common).OeoriPriority(oeori),"^",3)  
	s (oeoriSign)=""
	s pogItmCnt=pogItmCnt+1
	i pogItmCnt'=1 d
	.s oeoriSign=##class(web.DHCSTPIVAS.Common).OeoriSign(0)
	i pogItmCnt=1 s oeoriSign=##class(web.DHCSTPIVAS.Common).OeoriSign(-1)
	i pogItmCnt=pogNum s oeoriSign=##class(web.DHCSTPIVAS.Common).OeoriSign(1)
	i pogNum=1 s oeoriSign=""
	i pogItmCnt>1 d
	.s (patNo,patName,bedNo,doseDTHtml,batNo,packFlag,operReason)=""
	s data1=oeoriSign_"^"_mDsp_"^"_patNo_"^"_patName_"^"_freqDesc
	s data2=instrucDesc_"^"_docName_"^"_doseDTHtml_"^"_batNo_"^"_packFlag
	s data3=incDesc_"^"_incSpec_"^"_dosage_"^"_qty_"^"_bUomDesc
	s data4=ordRemark_"^"_priDesc_"^"_bedNo_"^"_colColor_"^"_pogId
	s data5=wardDesc_"^"_warnInfo_"^"_operReason
	s data=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5
	s ^CacheTemp(repid,ind)=$lfs(data,"^")    
	s ind=ind+1
	q ""
}

}
