/// description: 住院打印获取数据公共方法
///              处方
///              {Templet:模板名,Para:{a:1,b:2},List:[,,,]}
Class web.DHCINPHA.Common.Print Extends %RegisteredObject
{

/// 横版草药处方一行放几个药品
Parameter CyColsNum = 4;

/// 竖版草药处方一行放几个药品
Parameter CyVerColsNum = 3;

/// description: 处方数据,因为预览与打印的模板相同,具体内容直接由参数控制,不再单写了,不纠结了,反正就这点代码,全在这
/// input:       PrescNo(处方号)、ZfFlag(正方、底方)、PrtType(DISPPREVIEW:发药预览)、UseFlag-(1-医生站，2-审方，3-已审未发，4-已发，5-打印)
/// w ##class(web.DHCINPHA.Common.Print).PrescPrintData("MJ23050900001","","DISPPREVIEW","1",+$h)
ClassMethod PrescPrintData(PrescNo, ZfFlag = "", PrtType = "", UseFlag = "", PrintDate = "", phacId = "")
{
    //s ^PHATMP("MYQ",$this,"PrescPrintData")=$lb(PrescNo,ZfFlag,PrtType,UseFlag,PrintDate)
    s printObj={}
    q:PrescNo="" printObj.%ToJSON()
    q:'$d(^OEORD(0,"PrescNo",PrescNo)) printObj.%ToJSON()
    s queId=##class(PHA.COM.Order).PrescCYQueId(PrescNo)
    s cyFlag=$s(queId>0:"Y",1:"")
    s prescOrdObj=##class(PHA.OP.COM.Print).GetPrescOrdData(PrescNo)
    q:prescOrdObj.%Size()=0 printObj.%ToJSON()
    s printDate=##class(PHA.FACE.IN.Com).DateHtmlToLogical(PrintDate)
    i printDate="" s printDate=+$h
    i phacId="" s phacId=$o(^DHCPHACi("PRESCNO",PrescNo,""),-1)
    i phacId'="" s phacMainObj=..GetPhacMainData(phacId)
    e  s phacMainObj={}

    if (phacId '= ""){
        s phaPhlId = +$p(^DHCPHAC(phacId), "^", 1)
    }
    else {
        s ordId = +$o(^OEORD(0, "PrescNo", PrescNo, ""))
        s itmId = +$o(^OEORD(0, "PrescNo", PrescNo, ordId, ""))
        s phaLocId = $p(^OEORD(ordId, "I", itmId, 3), "^", 6)
    }

    k PrescPrintDataData
    s ordId=0
    f  s ordId=$o(^OEORD(0,"PrescNo",PrescNo,ordId))  q:ordId=""  d 
    .s admId=$p(^OEORD(ordId),"^",1)
    .s ordItm=0
    .f  s ordItm=$o(^OEORD(0,"PrescNo",PrescNo,ordId,ordItm)) q:ordItm=""  d
    ..s oeori=ordId_"||"_ordItm
    ..// 过滤-自备
    ..s priStr=##class(PHA.COM.Order).OeoriPriority(oeori)
    ..q:priStr["OM"
    ..s phaLocId=$p(^OEORD(ordId,"I",ordItm,3),"^",6) 
    ..s hospId=$p(^CTLOC(phaLocId),"^",22)
    ..s perv="^^^^"_hospId_"^DHC"
    ..s ifLongOrd=##class(PHA.FACE.IN.Com).ChkIfLongOrder(oeori)
    ..s oeoriStatCode=$p(##class(PHA.COM.Order).OeoriStat(oeori),"^",1)
    ..s arcItmId=$p(^OEORD(ordId,"I",ordItm,1),"^",2)
    ..s arcItmDesc=$p(^ARCIM(+arcItmId,1,1),"^",2)
    ..s phcdfId=$p(^ARCIM(+arcItmId,1,1),"^",12)
    ..s phcUomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
    ..s dspId=""
    ..f  s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,dspId)) q:dspId=""  d
    ...// 过滤-长期医嘱按照天打印
    ...s dspData=^DHCOEDISQTY(dspId)
    ...s dspDate=$p(dspData,"^",21)
    ...s oeore=$p(dspData,"^",3)
    ...q:(ifLongOrd="Y")&&(printDate'="")&&(printDate'=dspDate)
    ...// 过滤-停医嘱 
    ...s dspStatus=$p(dspData,"^",7)
    ...s oeoreStatCode=$p(##class(PHA.COM.Order).OeoreStat(oeore),"^",1)
    ...q:(ifLongOrd'="Y")&&(UseFlag'="2")&&(dspStatus="TC")&&(oeoriStatCode'="V")&&(oeoriStatCode'="E") // 临时直接判断医嘱作废, 长期按执行记录判断停止, 2023-02-13, yunhaobao
    ...q:(ifLongOrd ="Y")&&(UseFlag'="2")&&(dspStatus="TC")&&(oeoreStatCode="D")
    ...// 打包子表汇总
    ...s dspSub=0
    ...f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
    ....s dspSubId=dspId_"||"_dspSub
    ....s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
    ....s inclb=$p(dspSubData,"^",1)
    ....s incId=$p(dspSubData,"^",5)
    ....s qty=$p(dspSubData,"^",2)
    ....i dspStatus="R" s qty = -1 * qty // 需要按照发退合计显示,2023-05-06, yunhaibao
    ....s sp=$p(dspSubData,"^",4)
    ....s spAmt=sp*qty
    ....s spAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(spAmt,perv,"FmtSA",1)
    ....// 转药学基本单位数量
    ....s bUomId=$p(^INCI(incId,1),"^",10)
    ....s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(bUomId,phcUomId)
    ....s qty=qty*fac
    ....s uniqueIndex=arcItmId
    ....i $d(PrescPrintDataData(oeori,uniqueIndex)) d
    .....s $p(PrescPrintDataData(oeori,uniqueIndex),"^",3)=$p(PrescPrintDataData(oeori,uniqueIndex),"^",3)+qty
    .....s $p(PrescPrintDataData(oeori,uniqueIndex),"^",4)=$p(PrescPrintDataData(oeori,uniqueIndex),"^",4)+spAmt
    ....e  d
    .....s PrescPrintDataData(oeori,uniqueIndex)=arcItmDesc_"^"_oeori_"^"_qty_"^"_spAmt_"^"_phcUomId_"^"_incId
    ....
    ...
    ..
    q:'$d(PrescPrintDataData) printObj.%ToJSON()
    /* 处方打印配置 */
    s prescParamStr = ##class(PHA.OP.COM.Method).GetPrescFmtProp("",phaLocId,"")
    i cyFlag = "Y" d
    .s templetCode = $p(prescParamStr,"^",3)
    .s cyColsNum = $s(templetCode["Ver":..#CyVerColsNum, 1:..#CyColsNum)
    e  d
    .i (prescOrdObj.prescTitle["毒")||(prescOrdObj.prescTitle["麻")||(prescOrdObj.prescTitle["精一") d
    ..//s templetCode = $p(prescParamStr,"^",5) // 门诊毒麻处方模板
    ..s templetCode = $p(prescParamStr,"^",6)   // 住院毒麻处方模板
    .e  d
    ..s templetCode = $p(prescParamStr,"^",1)
    
    s spAmtTotal=0
    s listObjArr=[]
    s pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
    k ^TMP("DHCINPHA",$this,"PrescPrintData",pid)
    s seqindNo=1
    s oeori=""
    f  s oeori=$o(PrescPrintDataData(oeori)) q:oeori=""  d
    .s oeoriObj=##class(PHA.OP.COM.Print).GetOeoriData(oeori)
    .s uniqueIndex=""
    .f  s uniqueIndex=$o(PrescPrintDataData(oeori,uniqueIndex)) q:uniqueIndex=""  d
    ..s drgData=PrescPrintDataData(oeori,uniqueIndex)
    ..s drgDesc=$p(drgData,"^",1)
    ..s qty=$p(drgData,"^",3)
    ..q:(+qty <= 0)
    ..s spAmt=$p(drgData,"^",4)
    ..i cyFlag="Y" d
    ...s uomId=$p(drgData,"^",5)
    ..e  d
    ...s incId=$p(drgData,"^",6)
    ...s fmtQtyUom=##class(PHA.COM.Method).BQtyToInUomQty(incId,qty)
    ...s qty=$p(fmtQtyUom,"^",1)
    ...s uomId=$p(fmtQtyUom,"^",2)
    ...s fac=$p(fmtQtyUom,"^",3)
    ..s uomDesc=$p(^CT("UOM",uomId),"^",2)
    ..s spAmtTotal=spAmtTotal+spAmt
    ..// 可以$c(13,10)换行,注意模板list间距
    ..i cyFlag="Y" d // 草药
    ...s oneQty=qty/prescOrdObj.duraFac
    ...s oneQty = $fn(oneQty,"N")
    ...s prescSign=##class(PHA.COM.Order).CheckIfShowSign(oeori)
    ...s NoPrecFlag=##class(PHA.FACE.IN.Com).ChkIfNoPrecByOeri(oeori)
    ...s:NoPrecFlag=1 drgDesc="*"_drgDesc
    .../* 判断当前库存 */
    ...s incId = $p(drgData, "^", 6)
    ...s phcUomId = $p(drgData, "^", 5)
    ...s curBQty = ##class(web.DHCSTSTKQTY).GetIncilValidQty(incId,phaLocId,1)
    ...s bUomId = $p(^INCI(incId, 1), "^", 10)
    ...s phcUomFac = ##class(web.DHCST.Common.UtilCommon).UOMFac(bUomId, phcUomId)
    ...s curPhcQty = curBQty*phcUomFac      // 药学基本单位对应数量
    ...s stkFlag = curPhcQty - qty
    ...s stkFlag = $s(stkFlag <= 0: $c(1),1 : "")
    ...
    ...s listStr=drgDesc_" "_oneQty_uomDesc_ stkFlag _"^"_oeoriObj.remark_" "_prescSign
    ...d listObjArr.%Push(listStr)  
    ..e  d
    ...//增加打印序号
    ...s mainOeori=##class(PHA.COM.Order).GetMainOeori(oeori)
    ...s ^TMP("DHCINPHA",$this,"PrescPrintData",pid,"OrdItem",oeori)=seqindNo
    ...i '$d(^TMP("DHCINPHA",$this,"PrescPrintData",pid,"SEQPOINT",mainOeori)) d
    ....s ^TMP("DHCINPHA",$this,"PrescPrintData",pid,"SEQPOINT",mainOeori)=0
    ...i mainOeori'=oeori d
    ....i '$d(^TMP("DHCINPHA",$this,"PrescPrintData",pid,"OrdItem",mainOeori))  d
    .....s ^TMP("DHCINPHA",$this,"PrescPrintData",pid,"OrdItem",mainOeori)=seqindNo
    ....s ^TMP("DHCINPHA",$this,"PrescPrintData",pid,"SEQPOINT",mainOeori)=+$G(^TMP("DHCINPHA",$this,"PrescPrintData",pid,"SEQPOINT",mainOeori))+1
    ....s oeseqNo=^TMP("DHCINPHA",$this,"PrescPrintData",pid,"OrdItem",mainOeori)_"."_^TMP("DHCINPHA",$this,"PrescPrintData",pid,"SEQPOINT",mainOeori)
    ...e  d
    ....s oeseqNo=seqindNo
    ....s seqindNo=seqindNo+1
    ...//西药输出
    ...s qty=##class(PHA.COM.Util).AddZero(qty)
    ...s listStr=oeseqNo_"、"_drgDesc_"  X  "_qty_uomDesc
    ...d listObjArr.%Push(listStr) 
    ...s listStr="              用法：每次"_oeoriObj.dosage_" "_oeoriObj.instrucDesc_" "_oeoriObj.freqDesc_" "_oeoriObj.oeoriRemark
    ...d listObjArr.%Push(listStr)
    ..
    .
    k ^TMP("DHCINPHA",$this,"PrescPrintData",pid) 
    i cyFlag="Y" s listObjArr=##class(PHA.OP.COM.Print).FmtCyList(listObjArr,cyColsNum)
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
    // 诊断 - 竖版
    s diagNoseLen = $l(diagDesc)
    s verDiagDesc1 =$e(diagDesc,1,30)
    s verDiagDesc2 = $e(diagDesc,31,70)
    i diagNoseLen>70 s verDiagDesc2 = verDiagDesc2_"..."
    s paraObj.verDiagDesc1 = verDiagDesc1
    s paraObj.verDiagDesc2 = verDiagDesc2
    // 诊断 - 横版
    s diagDescNum = 0
    s diagNum = $l(diagDesc,",")
    f j = 1 : 1 : diagNum  d
    .s diagNose = $p(diagDesc,",",j)
    .s diagNoseLen = $l(diagNose)
    .s diagNoseNum = (diagNoseLen\11) + 1
    .f t = 1 : 1 : diagNoseNum  d
    ..s newDiagNose = $e(diagNose, 11*t - 10, 11*t)
    ..s diagDescNum = diagDescNum + 1
    ..s ArrDiagDesc(diagDescNum) = newDiagNose
    s paraObj.Diagnose1 = $g(ArrDiagDesc(1))
    s paraObj.Diagnose2 = $g(ArrDiagDesc(2))
    s paraObj.Diagnose3 = $g(ArrDiagDesc(3))
    s paraObj.Diagnose4 = $g(ArrDiagDesc(4))
    s paraObj.Diagnose5 = $g(ArrDiagDesc(5))
    s paraObj.Diagnose6 = $g(ArrDiagDesc(6))
    s paraObj.Diagnose7 = $g(ArrDiagDesc(7))
    s paraObj.Diagnose8 = $g(ArrDiagDesc(8))

    s paraObj.Name=prescOrdObj.patName  
    s paraObj.PatName=prescOrdObj.patName       
    s paraObj.PANo=prescOrdObj.patNo    
    s paraObj.PatNo=prescOrdObj.patNo   
    s paraObj.PatNoBarCode = "*"_prescOrdObj.patNo_"*"  
    s paraObj.Age=prescOrdObj.patAge
    s paraObj.PatAge=prescOrdObj.patAge
    s paraObj.Sex=prescOrdObj.patSex
    s paraObj.PatSex=prescOrdObj.patSex
    s paraObj.AdmDep=prescOrdObj.docLocDesc
    s paraObj.PatLoc=prescOrdObj.docLocDesc
    s paraObj.Doctor=prescOrdObj.docName
    s paraObj.UserAddName=prescOrdObj.docName   
    s paraObj.MRNo=prescOrdObj.mrNo                 // 病案号
    s paraObj.RecLoc=$p(^CTLOC(phaLocId),"^",2)     // 接收科室
    s paraObj.Company=prescOrdObj.patCompany
    s paraObj.OrdDate=prescOrdObj.ordDate   // 开具日期
    s paraObj.PatH=prescOrdObj.patHeight
    s paraObj.PatWeight=prescOrdObj.patWeight
    s paraObj.PatICD=prescOrdObj.diagDesc
    s paraObj.PatCall=prescOrdObj.patPhone
    s paraObj.PatAdd=prescOrdObj.patAddr
    s paraObj.PatNation=prescOrdObj.patNation
    s paraObj.patCardNo=prescOrdObj.patCardNo   
    s ordId=$o(^OEORD(0,"PrescNo",PrescNo,""))
    s admId=$p(^OEORD(ordId),"^",1)
    s paraObj.BedNo = $p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(admId),"^",2)
    s userId=%session.Data("LOGON.USERID") 
    s prescSerialNo=##class(PHA.IP.COM.Print).GetPrtSerialNo(PrescNo,printDate)
    s paraObj.PrescSerialNo=prescSerialNo   
    s paraObj.BillType=prescOrdObj.feeType
    s paraObj.patDVAnumber = prescOrdObj.patDVAnumber
    s paraObj.agencyName = prescOrdObj.agencyName
    s paraObj.aencyCredNo = prescOrdObj.aencyCredNo

    i cyFlag="Y" d
    .s ordDate=prescOrdObj.ordDate
    .i ordDate["/" s paraObj.Year=$p(ordDate,"/",3),paraObj.Month=$p(ordDate,"/",2),paraObj.Day=$p(ordDate,"/",1)
    .e  s paraObj.Year=$p(ordDate,"-",1),paraObj.Month=$p(ordDate,"-",2),paraObj.Day=$p(ordDate,"-",3)
    .s paraObj.CookType=prescOrdObj.cookType
    .s paraObj.queTypeDesc=prescOrdObj.queTypeDesc
    .// modified by MaYuqiang 20200521 诊断只显示50个字符
    .//s paraObj.MBDiagnos=prescOrdObj.mbDiagDes
    .s patDiag = prescOrdObj.mbDiagDes
    .i patDiag="" d
    ..s patDiag = prescOrdObj.diagDesc  
    .i templetCode["Ver" d
    ..s diagLen=35
    .e  d
    ..s diagLen=50
    .i $l(patDiag)>diagLen d
    ..s patDiag=$e(patDiag,1,diagLen)_" ..." 
    .s paraObj.PatICD=patDiag
    //处方尾部
    i (spAmtTotal<1)&&(spAmtTotal[".")&&($p(spAmtTotal,".",1)="") s spAmtTotal=0_spAmtTotal
    s paraObj.Sum=spAmtTotal_"元"
    i cyFlag="Y" d
    .s paraObj.QueRemark=prescOrdObj.queRemark
    .s paraObj.PrescCount=prescOrdObj.prescCount
    .s paraObj.YFSM="共"_prescOrdObj.duraFac_"付("_paraObj.PrescCount_"味) 用法:"_prescOrdObj.instrucDesc_" "_prescOrdObj.freqDesc_"  一次用量:"_prescOrdObj.orderQty_" "_paraObj.QueRemark
    .s paraObj.TotalMoney="单付:"_$fn(spAmtTotal/prescOrdObj.duraFac,"",2)_"元  合计:"_spAmtTotal_"元"
    
    s paraObj.AuditName=prescOrdObj.auditName
    i cyFlag = "Y" d
    .s pyUserName = $p(##class(PHA.HERB.Com.Data).GetPrescPYInfo(PrescNo), "^", 2)
    .s fyUserName = $p(##class(PHA.HERB.Com.Data).GetPrescFYInfo(PrescNo), "^", 2)
    e  d
    .s pyUserName = phacMainObj.pyUserName
    .s fyUserName = phacMainObj.fyUserName
    s paraObj.PyName = pyUserName
    s paraObj.FyName = fyUserName
    s printObj.Para=paraObj
    s printObj.List=listObjArr
    q printObj.%ToJSON()
}

/// 发药单主数据
/// s a=##class(web.DHCINPHA.Common.Print).GetPhacMainData(2361)
ClassMethod GetPhacMainData(PhacId) As %Library.DynamicObject
{
    s phacObj={}
    q:PhacId="" phacObj
    q:'$d(^DHCPHAC(PhacId)) phacObj
    s pyUserId=$p(^DHCPHAC(PhacId),"^",5)
    s pyUserName=$p(##class(PHA.COM.Method).GetUserInfoById(pyUserId),"^",2)
    s pyDate=$p(^DHCPHAC(PhacId),"^",18)
    s pyDate=##class(PHA.FACE.IN.Com).DateLogicalToHtml(pyDate)
    s pyTime=$p(^DHCPHAC(PhacId),"^",19)
    s pyTime=##class(PHA.FACE.IN.Com).TimeLogicalToHtml(pyTime)
    s fyUserId=$p(^DHCPHAC(PhacId),"^",13)
    s fyUserName=$p(##class(PHA.COM.Method).GetUserInfoById(fyUserId),"^",2)
    s fyDate=$p(^DHCPHAC(PhacId),"^",2)
    s fyDate=##class(PHA.FACE.IN.Com).DateLogicalToHtml(fyDate)
    s fyTime=$p(^DHCPHAC(PhacId),"^",3)
    s fyTime=##class(PHA.FACE.IN.Com).TimeLogicalToHtml(fyTime)
    s phacObj.pyUserName=pyUserName
    s phacObj.fyUserName=fyUserName
    s phacObj.pyDate=pyDate
    s phacObj.pyTime=pyTime
    s phacObj.fyDate=fyDate
    s phacObj.fyTime=fyTime
    q phacObj
}

}
