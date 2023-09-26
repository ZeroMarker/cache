/// description: 门诊打印获取数据公共方法
/// 			 处方、配药单、发药单
/// 			 {Templet:模板名,Para:{a:1,b:2},List:[,,,]}
Class web.DHCOUTPHA.Common.Print Extends %RegisteredObject
{

/// 横版草药处方一行放几个药品
Parameter CyColsNum = 4;

/// 竖版草药处方一行放几个药品
Parameter CyVerColsNum = 3;

/// description: 处方数据,因为预览与打印的模板相同,具体内容直接由参数控制,不再单写了,不纠结了,反正就这点代码,全在这
/// input:		 PrescNo(处方号)、ZfFlag(正方、底方)、PrtType(DISPPREVIEW:发药预览)
/// w ##class(web.DHCOUTPHA.Common.Print).PrescPrintData("O190329000001")
ClassMethod PrescPrintData(PrescNo, ZfFlag = "", PrtType = "")
{
	//s ^hlh($h)=$lb(PrescNo,ZfFlag,PrtType)
	s printObj={}
	q:PrescNo="" printObj.%ToJSON()
	q:'$d(^OEORD(0,"PrescNo",PrescNo)) printObj.%ToJSON()
	s queId=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).PrescCYQueId(PrescNo)
	s cyFlag=$s(queId>0:"Y",1:"")
	s prescOrdObj=..GetPrescOrdData(PrescNo)
	q:prescOrdObj.%Size()=0 printObj.%ToJSON()
	s phdId=$o(^DHCPHDISPi("PRESCNO",PrescNo,""))
	i phdId'="" s phdMainObj=..GetPhdMainData(phdId)
	e  s phdMainObj={}
	s fyFlag=phdMainObj.fyFlag
	k PrescPrintDataData
	s ordId=0
	f  s ordId=$o(^OEORD(0,"PrescNo",PrescNo,ordId))  q:ordId=""  d 
	.s admId=$p(^OEORD(ordId),"^",1)
	.s admType=$p(^PAADM(admId),"^",2)
	.s ordItm=0
	.f  s ordItm=$o(^OEORD(0,"PrescNo",PrescNo,ordId,ordItm)) q:ordItm=""  d
	..s oeori=ordId_"||"_ordItm
	..s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	..q:dspId=""
	..s dspStatus=$p(^DHCOEDISQTY(dspId),"^",7)
	..s quitFlag=""
	..s priStr=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriPriority(oeori)
	..// 过滤-自备
	..q:priStr["OM"
	..s billFlag=$p(^OEORD(ordId,"I",ordItm,3),"^",5) 
	..s oeoriStatCode=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriStat(oeori),"^",1)
	..q:(dspStatus'="C")&&(billFlag'="P")&&(oeoriStatCode'="V")&&(oeoriStatCode'="E")
	..s arcItmId=$p(^OEORD(ordId,"I",ordItm,1),"^",2)
 	..s arcItmDesc=$p(^ARCIM(+arcItmId,1,1),"^",2)
    ..s phcdfId=$p(^ARCIM(+arcItmId,1,1),"^",12)
    ..s phcUomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
	..s recLocId=$p(^OEORD(ordId,"I",ordItm,3),"^",6) 
	..s hospId=$p(^CTLOC(recLocId),"^",22)
	..s perv="^^^^"_hospId_"^DHC"
	..s dspSub=0
	..// 打包子表汇总
	..f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
	...s dspSubId=dspId_"||"_dspSub
	...s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
	...s inclb=$p(dspSubData,"^",1)
	...s incId=$p(dspSubData,"^",5)
	...s qty=$p(dspSubData,"^",2)
	...s dspQty=qty
	...s retQty=..GetRetedQtyByDspBatch(dspSubId)
	...i PrtType="" s qty=qty-retQty
	...q:(PrtType="")&&(qty<=0)
	...// 转药学基本单位数量
	...s bUomId=$p(^INCI(incId,1),"^",10)
	...s fac=##class(web.DHCSTCOMMONSRV).UOMFac(bUomId,phcUomId)
	...s qty=qty*fac
	...i (billFlag="P")&&(admType'="H") d
	....s prtPriceStr=##class(web.DHCOutPhCommon).GetBasePriceByOe(oeori,dspSubId)
	....s sp=$p(prtPriceStr,"^",1)
	....s spAmt=$p(prtPriceStr,"^",2)
	....i PrtType="" s spAmt=(spAmt*(dspQty-retQty))/dspQty
	...e  d
	....s spDate=$p($g(^OEORD(ordId,"I",ordItm,3)),"^",7)
	....s:inclb="" inclb=incId
	....s sp=##class(web.DHCSTPRICE).GetSp(inclb,spDate,"",hospId,"","")
	....s sp=sp/fac
	....s spAmt=sp*qty
	....s spAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(spAmt,perv,"FmtSA",1)
	...s uniqueIndex=arcItmId
	...s itmDesc=arcItmDesc
	...i $d(PrescPrintDataData(oeori,uniqueIndex)) d
	....s $p(PrescPrintDataData(oeori,uniqueIndex),"^",3)=$p(PrescPrintDataData(oeori,uniqueIndex),"^",3)+qty
	....s $p(PrescPrintDataData(oeori,uniqueIndex),"^",4)=$p(PrescPrintDataData(oeori,uniqueIndex),"^",4)+spAmt
	...e  d
	....s PrescPrintDataData(oeori,uniqueIndex)=itmDesc_"^"_oeori_"^"_qty_"^"_spAmt_"^"_phcUomId_"^"_incId
	...
	..
	.
	q:'$d(PrescPrintDataData) -1
	s templetStr=##class(web.DHCOutPhCommon).GetPrescFmtProp("",recLocId,"")
	i cyFlag="Y" s templetCode=$p(templetStr,"^",2),cyColsNum=$s(templetCode["Ver":..#CyVerColsNum,1:..#CyColsNum)
	e  s templetCode=$p(templetStr,"^",1)
	s spAmtTotal=0
	s listObjArr=[]
	s pid=##class(web.DHCOUTPHA.Common.CommonUtil).NewPid($this)
	s seqindNo=1
	s oeori=""
	f  s oeori=$o(PrescPrintDataData(oeori)) q:oeori=""  d
	.s oeoriObj=..GetOeoriData(oeori)
	.s dispUomId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),"DHC")),"^",13)
	.s uniqueIndex=""
	.f  s uniqueIndex=$o(PrescPrintDataData(oeori,uniqueIndex)) q:uniqueIndex=""  d
	..s drgData=PrescPrintDataData(oeori,uniqueIndex)
	..s drgDesc=$p(drgData,"^",1)
	..s qty=$p(drgData,"^",3)
	..s spAmt=$p(drgData,"^",4)
	..i cyFlag="Y" d
	...s uomId=$p(drgData,"^",5)
	..e  d
	...s incId=$p(drgData,"^",6)
	...i dispUomId="" d
	....s fmtQtyUom=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(incId,qty)
	...e  d
	....s fmtQtyUom=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,qty,dispUomId)
	...s qty=$p(fmtQtyUom,"^",1)
	...s uomId=$p(fmtQtyUom,"^",2)
	...s fac=$p(fmtQtyUom,"^",3)
	..s uomDesc=$p(^CT("UOM",uomId),"^",2)
	..s spAmtTotal=spAmtTotal+spAmt
	..// 可以$c(13,10)换行,注意模板list间距
	..i cyFlag="Y" d // 草药
	...s oneQty=qty/prescOrdObj.duraFac
	...s prescSign=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).CheckIfShowSign(oeori)
	...s NoPrecFlag=##class(web.DHCPHACOM.ComInterface.FaceInFromDHC).ChkIfNoPrecByOeri(oeori)
	...s:NoPrecFlag=1 drgDesc="*"_drgDesc
	...s listStr=drgDesc_" "_oneQty_uomDesc_"^"_oeoriObj.remark_" "_prescSign
	...d listObjArr.%Push(listStr)  
	..e  d
	...//增加打印序号
	...s mainOeori=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetMainOeori(oeori)
	...s ^TMP("DHCOUTPHA",$this,"PrescPrintData",pid,"OrdItem",oeori)=seqindNo
	...i '$d(^TMP("DHCOUTPHA",$this,"PrescPrintData",pid,"SEQPOINT",mainOeori)) d
	....s ^TMP("DHCOUTPHA",$this,"PrescPrintData",pid,"SEQPOINT",mainOeori)=0
	...i mainOeori'=oeori d
	....i '$d(^TMP("DHCOUTPHA",$this,"PrescPrintData",pid,"OrdItem",mainOeori))  d
	.....s ^TMP("DHCOUTPHA",$this,"PrescPrintData",pid,"OrdItem",mainOeori)=seqindNo
	....s ^TMP("DHCOUTPHA",$this,"PrescPrintData",pid,"SEQPOINT",mainOeori)=+$G(^TMP("DHCOUTPHA",$this,"PrescPrintData",pid,"SEQPOINT",mainOeori))+1
	....s oeseqNo=^TMP("DHCOUTPHA",$this,"PrescPrintData",pid,"OrdItem",mainOeori)_"."_^TMP("DHCOUTPHA",$this,"PrescPrintData",pid,"SEQPOINT",mainOeori)
	...e  d
	....s oeseqNo=seqindNo
	....s seqindNo=seqindNo+1
	...//西药输出
	...s qty=##class(web.DHCST.Common.UtilCommon).AddZero(qty)
	...s listStr=oeseqNo_"、"_drgDesc_"  X  "_qty_uomDesc
	...d listObjArr.%Push(listStr) 
	...s listStr="              用法：每次"_oeoriObj.dosage_" "_oeoriObj.instrucDesc_" "_oeoriObj.freqDesc_" "_oeoriObj.oeoriRemark
	...d listObjArr.%Push(listStr)
	..
	.
	k ^TMP("DHCOUTPHA",$this,"PrescPrintData",pid) 
	i cyFlag="Y" s listObjArr=..FmtCyList(listObjArr,cyColsNum)
	//处方头部
	s printObj.Templet=templetCode
	s paraObj={}
	s titleType=$s(cyFlag="Y":"中药",1:"西药")
	s paraObj.Title=prescOrdObj.hospDesc_titleType_"处方笺"
	s paraObj.ZDF="["_ZfFlag_"]"
	s paraObj.PrescTitle="【"_prescOrdObj.prescTitle_"】"
	s paraObj.PrescNo=prescOrdObj.prescNo
	s paraObj.BarCode="*"_prescOrdObj.prescNo_"*"
	s diagDesc=prescOrdObj.diagDesc
	s paraObj.Diagnose1=$p(diagDesc,",",1)	
	s paraObj.Diagnose2=$p(diagDesc,",",2)
	s paraObj.Diagnose3=$p(diagDesc,",",3)
	s paraObj.Diagnose4=$p(diagDesc,",",4)
	s paraObj.Diagnose5=$p(diagDesc,",",5)
	s paraObj.Diagnose6=$p(diagDesc,",",6)
	s paraObj.Name=prescOrdObj.patName	
	s paraObj.PatName=prescOrdObj.patName		
	s paraObj.PANo=prescOrdObj.patNo	
	s paraObj.PatNo=prescOrdObj.patNo	
	s paraObj.Age=prescOrdObj.patAge
	s paraObj.PatAge=prescOrdObj.patAge
	s paraObj.Sex=prescOrdObj.patSex
	s paraObj.PatSex=prescOrdObj.patSex
	s paraObj.AdmDep=prescOrdObj.docLocDesc
	s paraObj.PatLoc=prescOrdObj.docLocDesc
	s paraObj.Doctor=prescOrdObj.docName
	s paraObj.UserAddName=prescOrdObj.docName	
	s paraObj.MRNo=prescOrdObj.mrNo					// 病案号
	s paraObj.RecLoc=$p(^CTLOC(recLocId),"^",2)		// 接收科室
	s paraObj.Company=prescOrdObj.patCompany
	s paraObj.OrdDate=prescOrdObj.ordDate	// 开具日期
	s paraObj.PatH=prescOrdObj.patHeight
	s paraObj.PatWeight=prescOrdObj.patWeight
	s paraObj.PatICD=prescOrdObj.diagDesc
	s paraObj.PatCall=prescOrdObj.patPhone
	s paraObj.PatAdd=prescOrdObj.patAddr
	s paraObj.PatNation=prescOrdObj.patNation
	s paraObj.patCardNo=prescOrdObj.patCardNo
	s userId=%session.Data("LOGON.USERID")
	s prescSerialNo=##class(web.DHCPHACOM.ComInterface.FaceInFromDHC).GetSerialNoByPresc(PrescNo,userId,PrtType)
	s paraObj.PrescSerialNo=prescSerialNo
	s paraObj.BillType=prescOrdObj.feeType
	i cyFlag="Y" d
	.s ordDate=prescOrdObj.ordDate
	.i ordDate["/" s paraObj.Year=$p(ordDate,"/",3),paraObj.Month=$p(ordDate,"/",2),paraObj.Day=$p(ordDate,"/",1)
	.e  s paraObj.Year=$p(ordDate,"-",1),paraObj.Month=$p(ordDate,"-",2),paraObj.Day=$p(ordDate,"-",3)
	.s paraObj.CookType=prescOrdObj.cookType
	.s paraObj.queTypeDesc=prescOrdObj.queTypeDesc
	.s paraObj.MBDiagnos=prescOrdObj.mbDiagDesc
	//处方尾部
	i (spAmtTotal<1)&&(spAmtTotal[".")&&($p(spAmtTotal,".",1)="") s spAmtTotal=0_spAmtTotal
	s paraObj.Sum=spAmtTotal_"元"
	i cyFlag="Y" d
	.s paraObj.QueRemark=prescOrdObj.queRemark
	.s paraObj.PrescCount=prescOrdObj.prescCount
	.s paraObj.YFSM="共"_prescOrdObj.duraFac_"付("_paraObj.PrescCount_"味) 用法:"_prescOrdObj.instrucDesc_" "_prescOrdObj.freqDesc_"  一次用量:"_prescOrdObj.orderQty_" "_paraObj.QueRemark
	.s paraObj.TotalMoney="单付:"_$fn(spAmtTotal/prescOrdObj.duraFac,"",2)_"元  合计:"_spAmtTotal_"元"
	s paraObj.AuditName=prescOrdObj.auditName
	s paraObj.PyName=phdMainObj.pyUserName
	s paraObj.FyName=phdMainObj.fyUserName	
	s printObj.Para=paraObj
	s printObj.List=listObjArr
	q printObj.%ToJSON()
}

/// description: 发药单数据,按医嘱+库存项汇总
/// input:		 RePrint((补))
/// w ##class(web.DHCOUTPHA.Common.Print).PhdPrintData(279) // 已发
/// w ##class(web.DHCOUTPHA.Common.Print).PhdPrintData(497) // 已配
ClassMethod PhdPrintData(PhdId, RePrt = "") As %String
{
	s printObj={}
	q:PhdId="" printObj.%ToJSON()
	q:'$d(^DHCPHDISP(PhdId)) printObj
	s prescNo=$p(^DHCPHDISP(PhdId,2),"^",1)
	s phdMainObj=..GetPhdMainData(PhdId)
	q:phdMainObj.%Size()=0 printObj.%ToJSON()
	s prescOrdObj=..GetPrescOrdData(prescNo)
	q:prescOrdObj.%Size()=0 printObj.%ToJSON()
	s fyFlag=$p(^DHCPHDISP(PhdId),"^",4)
	s repeatFlag=""
	i RePrt="" d
	.s pharId=""
	.f  s pharId=$o(^DHCPHARi("PRESCNO",prescNo,pharId)) q:pharId=""  d
	..s pharData=$g(^DHCPHARW(pharId))
	..q:$p(pharData,"^",13)'=1
	..i $p(pharData,"^",7)=1 d
	...i repeatFlag="" s repeatFlag="▼"
	...e  s repeatFlag=repeatFlag_"▼"	
	s phdItm=""
	f  s phdItm=$o(^DHCPHDI(PhdId,"PHDI",phdItm)) q:phdItm=""  d
	.q:phdItm=0
	.s oeori=$p(^DHCPHDI(PhdId,"PHDI",phdItm),"^",5)
	.i fyFlag=1 d
	..d CalcuIncByPhd
	.e  d CalcuIncByOeori
	q:'$d(PhdPrintDataData) printObj.%ToJSON()
	s que1Id=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).PrescCYQueId(prescNo)
	// 拼接数据
	i que1Id>0 s printObj.Templet="DHCOutPhPYDCY"	// 草药
	e  s printObj.Templet="DHCOutPhPYDXY"			// 西成药
	s paraObj={}
	s paraObj.HospName=prescOrdObj.hospDesc
	s paraObj.Title=prescOrdObj.recLocDesc_"配药单"_$s(RePrt="":repeatFlag,1:"("_RePrt_")")
	s paraObj.Diagnos=prescOrdObj.diagDesc
	s paraObj.PatName=prescOrdObj.patName
	s paraObj.PatNo=prescOrdObj.patNo
	s paraObj.PatAge=prescOrdObj.patAge
	s paraObj.PatSex=prescOrdObj.patSex
	s paraObj.PrescNo=prescOrdObj.prescNo
	s paraObj.AdmDepDesc=prescOrdObj.docLocDesc
	s paraObj.PYDate=phdMainObj.pyDate_" "_phdMainObj.pyTime
	s paraObj.PhwinDesc=phdMainObj.winDesc
	s printObj.Para=paraObj
	s listObjArr=[]
	i que1Id>0 s line="-------------------------------------^^^"
	e  s line="-------------------------------^^^^"
	d listObjArr.%Push(line)
	s spAmtTotal=0
	s oeori=""
	f  s oeori=$o(PhdPrintDataData(oeori)) q:oeori=""  d
	.s oeoriObj=..GetOeoriData(oeori)
	.s dispUomId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),"DHC")),"^",13)
	.s incId=""
	.f  s incId=$o(PhdPrintDataData(oeori,incId)) q:incId=""  d
	..s incDesc=oeoriObj.skinTest_$p(^INCI(incId,1),"^",2) // 发药单不需要用通用名
	..s qty=$p(PhdPrintDataData(oeori,incId),"^",2) // 基本单位
	..i dispUomId="" d
	...s fmtQtyUom=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(incId,qty)
	..e  d
	...s fmtQtyUom=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,qty,dispUomId)
	..s qty=$p(fmtQtyUom,"^",1)
	..s uomId=$p(fmtQtyUom,"^",2)
	..s uomDesc=$p(^CT("UOM",uomId),"^",2)
	..s spAmt=##class(web.DHCST.Common.UtilCommon).AddZero($p(PhdPrintDataData(oeori,incId),"^",3))
	..s spAmtTotal=##class(web.DHCST.Common.UtilCommon).AddZero(spAmtTotal+spAmt)
	..s sp=$fn(spAmt/qty,"",2)
	..i que1Id="" d	// 西药
	...s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",incId)
	...s listStr=incDesc_spec_"^^^^"
	...d listObjArr.%Push(listStr)
	...s listStr="^单价:"_sp_"^数量:"_qty_uomDesc_"^小计:"_spAmt_"^"
	...d listObjArr.%Push(listStr)
	...s listStr="^^^^"_oeoriObj.instrucDesc_"　"_oeoriObj.freqDesc_"　每次"_oeoriObj.dosage
	...d listObjArr.%Push(listStr)
	..e  d			// 草药
	...s onceQty=qty/prescOrdObj.duraFac
	...s firstDesc=##class(web.DHCSTKUTIL).SubString(incDesc,14,0)
	...s secondDesc=$replace(incDesc,firstDesc,"")
	...s listStr=firstDesc_"^"_sp_"^"_onceQty_uomDesc_"^"_oeoriObj.remark
	...d listObjArr.%Push(listStr)
	...i secondDesc'="" d
	....s listStr=secondDesc_"^"_""_"^"_""_"^"_""
	....d listObjArr.%Push(listStr)
	d listObjArr.%Push(line)
	i que1Id>0 d
	.s listStr="共"_prescOrdObj.duraFac_"剂"_" "_"用法:"_prescOrdObj.instrucDesc_"  一次用量:"_prescOrdObj.orderQty_"^^^"
	.d listObjArr.%Push(listStr)
	.s listStr=prescOrdObj.freqDesc_"^^^"
	.d listObjArr.%Push(listStr)
	.s singleSpAmt=spAmtTotal/prescOrdObj.duraFac
	.s listStr="一付金额:"_$fn(singleSpAmt,"",2)_"  合计金额:"_$fn(spAmtTotal,"",2)_"   "_"^^^"
	.d listObjArr.%Push(listStr)
	.s listStr="配药人:"_phdMainObj.pyUserName_"^^^"
	.d listObjArr.%Push(listStr)
	.s listStr=phdMainObj.pyDate_" "_phdMainObj.pyTime_"^^^"
	.d listObjArr.%Push(listStr)
	.s listStr="提示：1、药品当面点清，遵医嘱或说明书使用！^^^"
	.d listObjArr.%Push(listStr)	
	.s listStr="　　　2、已发药品无特殊原因概不退换！^^^"
	.d listObjArr.%Push(listStr)
	e  d
	.s listStr="^医生:"_prescOrdObj.docName_"	"_"金额:"_spAmtTotal_"元   配药人:"_phdMainObj.pyUserName_"^^^"
	.d listObjArr.%Push(listStr)	
	.s listStr="^提示：1、药品当面点清，遵医嘱或说明书使用！^^^"
	.d listObjArr.%Push(listStr)	
	.s listStr="^　　　2、已发药品无特殊原因概不退换！^^^"
	.d listObjArr.%Push(listStr)	
	s printObj.List=listObjArr
	q printObj.%ToJSON()
CalcuIncByPhd
	s phdItmLb=0
	f  s phdItmLb=$o(^DHCPHDI(PhdId,"PHDI",phdItm,"INCLB",phdItmLb)) q:phdItmLb=""  d
	.s phdItmLbData=^DHCPHDI(PhdId,"PHDI",phdItm,"INCLB",phdItmLb)
	.s inclb=$p(phdItmLbData,"^",3)
	.s incId=+inclb
	.s qty=$p(phdItmLbData,"^",1)
	.s spAmt=$p(phdItmLbData,"^",8)
	.s sortIndex=phdItm
	.i $d(PhdPrintDataData(oeori,incId)) d
	..s $p(PhdPrintDataData(oeori,incId),"^",2)=$p(PhdPrintDataData(oeori,incId),"^",2)+qty
	..s $p(PhdPrintDataData(oeori,incId),"^",3)=$p(PhdPrintDataData(oeori,incId),"^",3)+spAmt
	.e  d
	..s PhdPrintDataData(oeori,incId)=oeori_"^"_qty_"^"_spAmt
	q
CalcuIncByOeori
	s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	q:dspId=""
	s ordId=+oeori
	s ordItm=$p(oeori,"||",2)
	s admId=$p(^OEORD(ordId),"^",1)
	s admType=$p(^PAADM(admId),"^",2)
	s billFlag=$p(^OEORD(ordId,"I",ordItm,3),"^",5)
	s oeoriStatCode=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriStat(oeori),"^",1)
	q:(billFlag'="P")&&(oeoriStatCode'="V")&&(oeoriStatCode'="E")
	s recLocId=$p(^DHCOEDISQTY(dspId),"^",24)
	s hospId=$p(^CTLOC(recLocId),"^",22)
	s perv="^^^^"_hospId_"^DHC"
	s dspSub=0
	f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
	.s dspSubId=dspId_"||"_dspSub
	.s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
	.s inclb=$p(dspSubData,"^",1)
	.s incId=$p(dspSubData,"^",5)	// 肯定不为空
	.s qty=$p(dspSubData,"^",2)	
	.i (billFlag="P")&&(admType'="H") d
	..s prtPriceStr=##class(web.DHCOutPhCommon).GetBasePriceByOe(oeori,dspSubId)
	..s sp=$p(prtPriceStr,"^",1)
	..s spAmt=$p(prtPriceStr,"^",2)
	.e  d
	..s getSpInc=incId
	..i inclb'="" s getSpInc=inclb
	..s sp=##class(web.DHCSTPRICE).GetSp(getSpInc,+$h,"",hospId,"","")
	..s spAmt=sp*qty
	..s spAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(spAmt,perv,"FmtSA",1)
	.i $d(PhdPrintDataData(oeori,incId)) d
	..s $p(PhdPrintDataData(oeori,incId),"^",2)=$p(PhdPrintDataData(oeori,incId),"^",2)+qty
	..s $p(PhdPrintDataData(oeori,incId),"^",3)=$p(PhdPrintDataData(oeori,incId),"^",3)+spAmt
	.e  d
	..s PhdPrintDataData(oeori,incId)=oeori_"^"_qty_"^"_spAmt
	q
}

/// description: 用药标签,按医嘱打印,主要体现用法用量
/// return:[{数据1},{数据2}...]
/// w ##class(web.DHCOUTPHA.Common.Print).LabelPrintData("O181106000053")
ClassMethod LabelPrintData(PrescNo) As %String
{
	s $zt="ThrowLabelPrintData"
	s printObjArr=[]
	q:PrescNo="" printObjArr
	q:'$d(^OEORD(0,"PrescNo",PrescNo)) printObjArr
	s prescObj={}
  	s ordId=""
    f  s ordId=$o(^OEORD(0,"PrescNo",PrescNo,ordId)) q:ordId=""  d 
    .q:+ordId=0
    .s ordItm=""
    .f  s ordItm=$o(^OEORD(0,"PrescNo",PrescNo,ordId,ordItm) ) q:ordItm=""  d
    ..q:+ordItm=0
    ..s oeori=ordId_"||"_ordItm
	..s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	..q:dspId=""
    ..s recLocId=$p(^OEORD(ordId,"I",ordItm,3),"^",6)
    ..q:recLocId=""
    ..s instrucStr=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriInstruc(oeori)
    ..s instrucId=$p(instrucStr,"^",1)
    ..q:instrucId=""
    ..// 过滤-未维护用法
    ..s existFlag=""
    ..s intrLocId=""
    ..f  s intrLocId=$o(^DHCGLobIntrLoc("LOC",recLocId,intrLocId)) q:(intrLocId="")||(existFlag'="")  d
    ...q:intrLocId=""
    ...i instrucId=$p(^DHCGLobIntrLoc("LOC",recLocId,intrLocId),"^",2) s existFlag=1
    ..q:existFlag=""
    ..s oeoriStatCode=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriStat(oeori),"^",1)
    ..// 过滤-停止
    ..q:(oeoriStatCode'="V")&&(oeoriStatCode'="E")
    ..i prescObj.%Size()=0 s prescObj=..GetPrescOrdData(PrescNo)
	..s arcItmId=$p(^OEORD(ordId,"I",ordItm,1),"^",2)
	..s arcItmDesc=$p(^ARCIM(+arcItmId,1,1),"^",2)
	..s tmpIncId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
	..s qty=$p(^DHCOEDISQTY(dspId),"^",5)
	..// 是否一对多
 	..s stkGrpStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(tmpIncId)
 	..q:$p(stkGrpStr,"^",3)'="G" 
 	..s struModeFlag=$p(stkGrpStr,"^",7)
 	..i struModeFlag="Y" d
 	...s phcdfId=$p(^ARCIM(+arcItmId,1,1),"^",12)
    ...s uomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
 	..e  d
    ...s dispUomId=$p($g(^OEORD(ordId,"I",ordItm,"DHC")),"^",13)
    ...i dispUomId'="" d
    ....s fmtQtyUom=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(tmpIncId,qty,dispUomId)
    ...e  d
    ....s fmtQtyUom=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(tmpIncId,qty)
    ...s uomId=$p(fmtQtyUom,"^",2)
    ...s qty=$p(fmtQtyUom,"^",1)
    ..s uomDesc=$p(^CT("UOM",uomId),"^",2)
	..s oeoriObj=..GetOeoriData(oeori)
	..s printObj={}
	..s printObj.Templet="DHCOutPharmacyKFBQ"
	..s paraObj={}
	..s paraObj.PatName=prescObj.patName
	..s paraObj.PatSex=prescObj.patSex
	..s paraObj.ALLYF=oeoriObj.instrucDesc_" "_oeoriObj.freqDesc_" 每次"_oeoriObj.dosage
	..s paraObj.PhDesc=arcItmDesc
	..s paraObj.PhQtyUom=qty_uomDesc
	..s paraObj.RQ=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h) //_" "_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p($h,",",1))
	..s printObj.Para=paraObj
	..d printObjArr.%Push(printObj)
    q printObjArr.%ToJSON()
ThrowLabelPrintData
	s errRet=$$ErrorRecord^DHCSTERROR("DHCSTOUTPHA","打印门诊标签取数据失败","PrescNo:"_PrescNo_","_$ze)
	q "[]"
}

/// 欠药单数据-todo
ClassMethod OwePrintData(OweId)
{
}

/// 退药单数据-todo
ClassMethod ReturnPrintData(PhdId)
{
}

/// 退药申请单数据-todo
ClassMethod RequestPrintData(PhdId)
{
}

/// description: 处方主数据
/// w ##class(web.DHCOUTPHA.Common.Print).GetPrescOrdData("E190107000040")
ClassMethod GetPrescOrdData(PrescNo) As %Library.DynamicObject
{
	s prescObj={}
	q:PrescNo="" prescObj
	s ordId=$o(^OEORD(0,"PrescNo",PrescNo,""))
	q:ordId="" prescObj
	s ordItm=$o(^OEORD(0,"PrescNo",PrescNo,ordId,""))
	q:ordItm="" prescObj
	s oeori=ordId_"||"_ordItm
	s recLocId=$p(^OEORD(ordId,"I",ordItm,3),"^",6)
	s hospId=$p(^CTLOC(recLocId),"^",22)
	s recLocDesc=$p(^CTLOC(recLocId),"^",2)
	s hospDesc=$p($g(^CT("HOSP",+hospId)),"^",2)
	s admId=$p(^OEORD(ordId),"^",1)
	s patInfoStr=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(admId)
	s patNo=$p(patInfoStr,"^",1)
	s patCardNo=$p(patInfoStr,"^",2)
	s patName=$p(patInfoStr,"^",3)
	s patSex=$p(patInfoStr,"^",4)			
	s patAge=$p(patInfoStr,"^",5)
	s patPhone=$p(patInfoStr,"^",6)
	s patAddr=$p(patInfoStr,"^",7)
	s patCompany=$p(patInfoStr,"^",8)	
 	s patWeight=$p(patInfoStr,"^",10)
 	s patHeight=$p(patInfoStr,"^",11)
 	s mrNo=$p(patInfoStr,"^",12)
 	s patNation=$p(patInfoStr,"^",14)
	s queId=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).PrescCYQueId(PrescNo)
	s cyFlag=$s(queId'="":"Y",1:"")
	i cyFlag="Y" d	// 草药
	.s diagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(admId,",","GC")
	.i diagDesc="" s diagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(admId,",","")
	e  d
	.s diagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(admId,",","")
	s docLocDesc=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriDocLoc(oeori),"^",2)
	s docName=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriDoctor(oeori),"^",2)
	s oeoriDate=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriDateTime(oeori)," ",1)
	s auditName=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPhaomInfo(PrescNo),"^",3)
	s feeType=##class(web.DHCOutPhCommon).GetPrescFeeType(PrescNo)
	s prescTitle=##class(web.DHCOutPhCommon).GetPrescTitle(PrescNo)
	//
	s prescObj.prescNo=PrescNo
	s prescObj.recLocDesc=recLocDesc
	s prescObj.hospDesc=hospDesc
	s prescObj.docLocDesc=docLocDesc
	s prescObj.docName=docName
	s prescObj.patNo=patNo
	s prescObj.patName=patName
	s prescObj.patAge=patAge
	s prescObj.patSex=patSex
	s prescObj.patCardNo=patCardNo
	s prescObj.diagDesc=diagDesc 
	s prescObj.ordDate=oeoriDate 
	s prescObj.patHeight=patHeight
	s prescObj.patWeight=patWeight
	s prescObj.mrNo=mrNo				// 病历号
	s prescObj.patCompany=patCompany
	s prescObj.patAddr=patAddr
	s prescObj.patPhone=patPhone
	s prescObj.auditName=auditName
	s prescObj.feeType=feeType
	s prescObj.patNation=patNation
	s prescObj.prescTitle=prescTitle
	i cyFlag="Y" d
	.// 草药处方信息
	.s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(PrescNo)
	.s instrucDesc=$p(prescStr,"^",1)							// 用法
	.s duraFac=$p(prescStr,"^",2)								// 付数,剂数
	.s orderQty=$p(prescStr,"^",3) 								// 用量										
	.s queDate=$p(prescStr,"^",4)								// 开始时间
	.s queXDate=$p(prescStr,"^",5)
	.s queRemark=$p(prescStr,"^",6)								// 草药方备注							
	.s cookType=$p(prescStr,"^",7)								// 煎药方式
	.s queTypeDesc=$p(prescStr,"^",8)							// 处方剂型													
	.s freqDesc=$p(prescStr,"^",9) 								// 频次
	.s freqFac=$p(prescStr,"^",16) 
	.s prescTitle=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetCYPrescTitle(PrescNo)
	.s mbDiagDesc=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescMBDiagnos(PrescNo)
	.s prescCount=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPrescNoCount(PrescNo)	//处方味数
	.//给对象赋值
	.s prescObj.instrucDesc=instrucDesc
	.s prescObj.duraFac=duraFac
	.s prescObj.orderQty=orderQty
	.s prescObj.queDate=queDate
	.s prescObj.queXDate=queXDate
	.s prescObj.cookType=cookType
	.s prescObj.queRemark=queRemark
	.s prescObj.freqDesc=freqDesc
	.s prescObj.freqFac=freqFac
	.s prescObj.prescTitle=prescTitle
	.s prescObj.queTypeDesc=queTypeDesc
	.s prescObj.mbDiagDesc=mbDiagDesc
	.s prescObj.prescCount=prescCount
	q prescObj
	q prescObj.%ToJSON()
}

/// 发药单主数据
/// s a=##class(web.DHCOUTPHA.Common.Print).GetPhdMainData(2361)
ClassMethod GetPhdMainData(PhdId) As %Library.DynamicObject
{
	s phdObj={}
	q:PhdId="" phdObj
	q:'$d(^DHCPHDISP(PhdId)) phdObj
	s fyPerId=$p(^DHCPHDISP(PhdId,1),"^",2)
	s pyPerId=$p(^DHCPHDISP(PhdId,1),"^",3)
	s pyUserName=$s(pyPerId'="":$p($g(^DHCPHPER(pyPerId)),"^",2),1:"")
	s fyUserName=$s(fyPerId'="":$p($g(^DHCPHPER(fyPerId)),"^",2),1:"")
    s pyDate=$p(^DHCPHDISP(PhdId,1),"^",5)
    i pyDate'="" s pyDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(pyDate)
    s pyTime=$p(^DHCPHDISP(PhdId,1),"^",7)
    i pyTime'="" s pyTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(pyTime)
    s fyDate=$p(^DHCPHDISP(PhdId),"^",3)
    i fyDate'="" s fyDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(fyDate)
    s fyTime=$p(^DHCPHDISP(PhdId),"^",5)
    i fyTime'="" s fyTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(fyTime)
    s winId=$p(^DHCPHDISP(PhdId,1),"^",4)
    s winDesc=$s(winId'="":$p($g(^DHCPHWIN(winId)),"^",1),1:"")
    s fyFlag=$p(^DHCPHDISP(PhdId),"^",4)
	s phdObj.pyUserName=pyUserName
	s phdObj.fyUserName=fyUserName
	s phdObj.pyDate=pyDate
	s phdObj.pyTime=pyTime
	s phdObj.fyDate=fyDate
	s phdObj.fyTime=fyTime
	s phdObj.winDesc=winDesc
	s phdObj.fyFlag=fyFlag
	q phdObj
	q phdObj.%ToJSON() // 测数据用
}

/// description: 获取医嘱明细信息
ClassMethod GetOeoriData(Oeori) As %Library.DynamicObject
{
	s oeoriObj={}
	s freqDesc=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriFreq(Oeori),"^",4)
	s instrucDesc=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriInstruc(Oeori),"^",2)
	s duraDesc=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriDuration(Oeori),"^",2)
	s dosage=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriDosage(Oeori)
	s remark=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),2)),"^",8)
	i remark="" s remark=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriRemark(Oeori)
	s skinTest=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriSkinTest(Oeori),"^",2)
	s oeoriStatCode=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriStat(Oeori),"^",1)
	s oeoriObj.freqDesc=freqDesc
	s oeoriObj.instrucDesc=instrucDesc
	s oeoriObj.duraDesc=duraDesc
	s oeoriObj.dosage=dosage
	s oeoriObj.remark=remark
	s oeoriObj.skinTest=skinTest
	s oeoriObj.statCode=oeoriStatCode
	q oeoriObj
}

/// description: 草药明细List转换
/// from:		 ["1^2","3^4","5^6","7^8","9^0"]
/// to:			 ["1^2^3^4^5^6^7^8","9^0^^^^^^"]
/// w ##class(web.DHCOUTPHA.Common.Print).FmtCyList("","4")
ClassMethod FmtCyList(ListArr As %Library.DynamicObject, ColsNum) As %Library.DynamicObject
{
	q:ColsNum=1 ListArr
	s listSize=ListArr.%Size()
	s newListArr=[]
	q:listSize=0 ListArr
	s cellListStr=ListArr.%Get(0)
	s cellLen=$l(cellListStr,"^")
	s colsCnt=cellLen*ColsNum
	s listI=0,listCnt=0
	f listI=0:1:(listSize-1)  d
	.s listCnt=listCnt+1
	.i listCnt#ColsNum=1 d	// 换行首个
	..s listStr=ListArr.%Get(listI)
	.e  d
	..s listStr=listStr_"^"_ListArr.%Get(listI)
	.i listCnt#ColsNum=0 d newListArr.%Push(listStr)
	i listCnt#ColsNum'=0 d
	.s $p(listStr,"^",colsCnt)=""
	.d newListArr.%Push(listStr)
	q newListArr
	q newListArr.%ToJSON()
}

/// description: 根据打包字表Id,获取已退数量(基本单位),找退药索引累加
/// 根据发药走退药索引,退药表打包索引字段不知道以后会不会变成对应的打包中退药记录Id
ClassMethod GetRetedQtyByDspBatch(DspSubId)
{
	q:DspSubId="" 0
	s retQty=0
	s phdId=""
	f  s phdId=$o(^DHCPHDIi("DSPB",DspSubId,phdId))  q:(phdId="")  d
	.s phdItm=""
	.f  s phdItm=$o(^DHCPHDIi("DSPB",DspSubId,phdId,phdItm))  q:(phdItm="")  d
	..s phdItmLb=""
	..f  s phdItmLb=$o(^DHCPHDIi("DSPB",DspSubId,phdId,phdItm,phdItmLb))  q:(phdItmLb="")  d
	...q:'$d(^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdItmLb)) 
	...s phdItmLbId=phdId_"||"_phdItm_"||"_phdItmLb
	...s retId=0
	...f  s retId=$o(^DHCPHRTIi("PHDICDR",phdItmLbId,retId)) q:retId=""  d
	....s retItm=0
	....f  s retItm=$o(^DHCPHRTIi("PHDICDR",phdItmLbId,retId,retItm)) q:retItm=""  d
	.....s qty=$p(^DHCPHRTI(retId,"RTI",retItm),"^",3)
	.....s retQty=retQty+qty
	q retQty
}

/// Description:获取打印中药调剂单的内容
/// Creator:	MaYuqiang
/// CreateDate:	2020-06-30
/// Table:      
/// Input:		phd-发药主表ID
/// Output:		主信息串！！明细信息串
/// Return： 	0-不可发药,1-可发药 
/// Others:		
/// Debug:		w ##class(web.DHCINPHA.MTCommon.PublicPrintMethod).GetPrtDispSheetInfo("230")
ClassMethod GetPrtDispSheetInfo(phd As %String) As %Library.String
{
	q:phd="" ""
	s phl=$p(^DHCPHDISP(phd,1),"^",1)
	q:phl="" ""
	s PhaLocDr=$p(^DHCPHLOC(phl),"^",1)   			//发药科室
	s PhaLocDesc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(PhaLocDr),"^",2)
	s prescNo=$p($g(^DHCPHDISP(phd,2)),"^",1)	//处方号
	q:prescNo="" ""
	s Ward=""				//病区
	s Phor=$o(^DHCPHORDM(0,"PrescNo",prescNo,""))
	s ChkUser=""
	i Phor'="" d
	.s ChkUserdr=$p(^DHCPHORDM(Phor),"^",1)
	.s ChkUser=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(ChkUserdr),"^",2)  //审核人
	s prescOrdInfo=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPreOrdInfo(prescNo)
	s DocLoc=$p(prescOrdInfo,"^",1)  														//开单科室	
	s prescInfoStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	s Instruc=$p(prescInfoStr,"^",1)														//用法
	s Factor=$p(prescInfoStr,"^",2)															//付数
	s StDate=$p(prescInfoStr,"^",4)															//开始日期
	s CoookType=$p(prescInfoStr,"^",7)														//煎药方式
	s:CoookType["代" CoookType="煎"
	s:CoookType["免" CoookType="免"
	s:CoookType["自" CoookType="自"
	s PrescForm=$p(prescInfoStr,"^",8) 														//处方剂型
	s PrescMoney=0																			//处方金额
	s FreqDesc=$p(prescInfoStr,"^",9)  														//频次
	s PreConfig=$p(prescInfoStr,"^",10)														//配置
	s OrderQtyDesc=$p(prescInfoStr,"^",11)													//用量
	s DrugInfo=$p(prescInfoStr,"^",12) 														//功效（解表类 一般类 滋补类）
	s PrescName=$p(prescInfoStr,"^",13)														//处方名
	s Doctor=$p(prescInfoStr,"^",26)  														//开单医生
	s admDr=$p(prescInfoStr,"^",27)															//就诊ID
	s patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(admDr,"")
	s PatNo=$p(patInfo,"^",1)
	s PatName=$p(patInfo,"^",3)
	s PameNo=$p(patInfo,"^",12)																//病案号
	s curBedcode=$p(patInfo,"^",13)															//床号
	s PrescCount=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescNoCount(prescNo)	//处方味数
	//先取处方的关联诊断，如果取空了再取该患者的中医诊断！
	//s PadiagNose=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescDiagnos(prescNo) 	//诊断
	s PadiagNose=##class(PHA.FACE.IN.Com).GetMRDiagnosDesc(prescNo,",")				//取处方关联诊断
    s:PadiagNose="" PadiagNose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(admDr,",","GC")
	s LabelType="门诊"
	s PreString1=PhaLocDesc_"^"_PatNo_"^"_PatName_"^"_PadiagNose_"^"_LabelType
	s PreString2=Instruc_"^"_Factor_"^"_StDate_"^"_PreConfig_"^"_PrescName
	s PreString3=DocLoc_"^"_Doctor_"^"_PrescCount_"^"_PrescMoney_"^"_prescNo
	s PreString4=FreqDesc_"^"_DrugInfo_"^"_PrescForm_"^"_ChkUser_"^"_Ward
	s PreString5=curBedcode_"^"_PameNo_"^"_CoookType_"^"_OrderQtyDesc
	s PreString=PreString1_"^"_PreString2_"^"_PreString3_"^"_PreString4_"^"_PreString5
	//以下为明细
	s child="",medstring=""
	f  s child=$o(^DHCPHDI(phd,"PHDI",child))  q:child=""  d
	.s sub=""
	.f  s sub=$o(^DHCPHDI(phd,"PHDI",child,"INCLB",sub))  q:sub=""  d
	..s Inclb=$p(^DHCPHDI(phd,"PHDI",child,"INCLB",sub),"^",3)
	..q:Inclb=""
	..s Inci=+Inclb
	..s InciDesc=$p(^INCI(Inci,1),"^",2)
	..s Qty=$p(^DHCPHDI(phd,"PHDI",child,"INCLB",sub),"^",1)
	..s Qty=Qty/Factor
	..s Qty=##Class(web.DHCSTPCHCOLLPRN).getPackQty(Inci,Qty)
	..s SpAmt=$p(^DHCPHDI(phd,"PHDI",child,"INCLB",sub),"^",8)
	..s PrescMoney=PrescMoney+SpAmt
	..s tmpsting=InciDesc_"^"_Qty
	..i medstring="" d
	...s medstring=tmpsting
	..e  d
	...s medstring=medstring_"@"_tmpsting
	..
	.
	s $p(PreString,"^",14)=PrescMoney 
	q PreString_"!!"_medstring
}

}
