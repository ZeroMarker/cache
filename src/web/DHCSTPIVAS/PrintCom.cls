Import sqluser

/// description: 配液打印标签公共
Class web.DHCSTPIVAS.PrintCom Extends web.DHCSTPIVAS.Common
{

/// Description: 根据打印单号打印
/// Createdate:  2020-07-21
/// Creator:     yunhaibao
/// Input:       pogsNoStr - 打印单号1^打印单号2
/// Return:      JSON - 数组 - String
/// w ##class(web.DHCSTPIVAS.PrintCom).LabelsJsonByPogsNo("S10P20191104001")
ClassMethod LabelsJsonByPogsNo(pogsNoStr)
{
    k calcData
    s len = $l(pogsNoStr, "^")
    for i = 1 : 1 : len {
        s pogsNo = $p(pogsNoStr, "^", i)
        i pogsNo = "" q
        s pog = ""
        for {
            s pog = $o(^PIVA(0, "PogsNo", pogsNo, pog))
            i pog = "" q
            s pNo = $p(^PIVA(pog), "^", 11)
            i pNo = "" continue
            s calcData(pNo, pog) = ""
        }
    }
    q:'$d(calcData) "[]"
    
    w "["
    s cnt = 0
    s pNo = ""
    for {
        s pNo = $o(calcData(pNo))
        i pNo = "" q
        s pog = ""
        for {
            s pog = $o(calcData(pNo, pog))
            i pog = "" q
            s cnt = cnt + 1
            
            s labelData = ..GetLabelJson(pog, "Y")
            if (cnt > 1) {
                w ","
            }
            w labelData.%ToJSON()

        }
    }
    w "]"
    q ""
}

/// Description:根据配液主表串打印
/// Creator:    yunhaibao
/// Createdate: 2019-04-11
/// w ##class()
ClassMethod LabelsJsonByPogStr(pogStr)
{
    s pogLen=$l(pogStr,"^")
    q:(pogLen=0)||(pogStr="") "[]"
    s count=0
    s pogI=""
    f pogI=1:1:pogLen d
    .s pogId=$p(pogStr,"^",pogI)
    .q:+pogId=0
    .q:'$d(^PIVA(pogId))
    .i count=0 w "["
    .i count>0 w ","
    .w ..GetLabelJson(pogId, "Y").%ToJSON()
    .s count=count+1
    q:count=0 "[]"
    w "]"
    q ""
}

/// description: 更新配液打包表记录的打印顺序号
ClassMethod UpdatePogPNo(pogId, pNo)
{
    q ##class(web.DHCSTPIVAS.DataCenter).UpdatePogPNo(pogId, pNo)
}

/// Description: 按规则重排顺序,数量只能在药品前或者后
///              节点内数据最多250个汉字,区分中英文
/// Return:      转换数据
/// Input:       
/// Output:      病区>批次>主药>数量>主药>数量>溶媒>数量>溶媒>数量>床号  转换后如下
///              病区-1>批次-1>主药-1&数量>主药-2&数量>溶媒-1&数量>床号-1
/// w ##class(web.DHCSTPIVAS.PrintCom).ReSortPrtWay("病区>批次>数量>主药>主药>数量>溶媒>数量>溶媒>数量>床号>溶媒>数量")
ClassMethod ReSortPrtWay(SortStr)
{
    s sortStr=SortStr
    s retSortStr=""
    s drugTypeLB=$lb("主药","溶媒","辅药")
    s drugQtyLB=$lb("数量")
    k ReSortPrtWayDATA,ReSortPrtWayCNT
    s len=$l(sortStr,">")
    f i=1:1:len d
    .s type=$p(sortStr,">",i)
    .q:type=""
    .s typeCnt=$i(ReSortPrtWayDATA("CNT",type))
    .s hasFlag=""
    .i $lf(drugQtyLB,type)>0 d                  // 数量在前
    ..s tmpNextType=$p(sortStr,">",i+1)
    ..s hasFlag=1
    ..i $lf(drugTypeLB,tmpNextType)>0 d 
    ...s typeCnt=$i(ReSortPrtWayDATA("CNT",tmpNextType))
    ...s newType=type_"&"_tmpNextType_"-"_typeCnt
    ...s ReSortPrtWayDATA("DATA",$i(ReSortPrtWayCNT))=newType
    ...s i=i+1                      // 跳过下一个
    .e  i $lf(drugTypeLB,type)>0 d              // 数量在后
    ..s tmpNextType=$p(sortStr,">",i+1)
    ..i $lf(drugQtyLB,tmpNextType)>0 d  
    ...s newType=type_"-"_typeCnt_"&"_tmpNextType
    ...s ReSortPrtWayDATA("DATA",$i(ReSortPrtWayCNT))=newType
    ...s i=i+1,hasFlag=1                        // 跳过下一个
    .q:hasFlag'=""
    .s ReSortPrtWayDATA("DATA",$i(ReSortPrtWayCNT))=type_"-"_typeCnt
    s i=""
    f  s i=$o(ReSortPrtWayDATA("DATA",i)) q:i=""  d
    .s iData=$g(ReSortPrtWayDATA("DATA",i))
    .s retSortStr=$s(retSortStr="":iData,1:retSortStr_">"_iData)
    i retSortStr="" s retSortStr="病区>批次>登记号"
    q retSortStr
}

/// Description: 获取某一组药的标签出签顺序,整体规则固定,确保不为空,否则容易漏签
///              数量特指药品剂量,紧随药品
/// w ##class(web.DHCSTPIVAS.PrintCom).GetPOGPrtSort(85,"病区-1>批次-1>床号-1>配液大类-1")
ClassMethod GetPOGPrtSort(POGId, SortStr)
{
    //s ^PHATMP("MYQ", $this, "GetPOGPrtSort") = $Lb(POGId, SortStr)
    k GetPOGPrtSortDATA
    k GetPOGPrtSortCNT
    // 准备药品数据
    s pogItm=0
    f  s pogItm=$o(^PIVA(POGId,"I",pogItm)) q:pogItm=""  d
    .s dspId=$p(^PIVA(POGId,"I",pogItm),"^",1)
    .s DHCOEDISQTY=$g(^DHCOEDISQTY(dspId))
    .s oeori=$p(DHCOEDISQTY,"^",1)
    .s qty=$p(DHCOEDISQTY,"^",5)
    .s arcItmId=$P($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",2) 
    .q:arcItmId=""
    .// 医嘱录入顺序不可确定,此处按医嘱Id统一排序
    .s sortArcIndex=$j(arcItmId,10)_$j(pogItm,2)
    .s GetPOGPrtSortDATA("SORTARC",sortArcIndex)=arcItmId_"^"_(10000-qty)
    s sortArcIndex=""
    f  s sortArcIndex=$o(GetPOGPrtSortDATA("SORTARC",sortArcIndex)) q:sortArcIndex=""  d
    .s sortArcData=GetPOGPrtSortDATA("SORTARC",sortArcIndex)
    .s arcItmId=$p(sortArcData,"^",1)
    .s drugType=##class(web.DHCSTPIVAS.Common).GetDrugType(arcItmId)
    .i drugType="" s drugType="Z" // 没维护在最后
    .i drugType["P" d
    ..s GetPOGPrtSortDATA("主药",$i(GetPOGPrtSortCNT("主药")))=sortArcData
    .e  i drugType["Y" d
    ..s GetPOGPrtSortDATA("溶媒",$i(GetPOGPrtSortCNT("溶媒")))=sortArcData
    s mDsp=$p(^PIVA(POGId),"^",1)
    s DHCOEDISQTY=$g(^DHCOEDISQTY(mDsp))
    s mOeori=$p(DHCOEDISQTY,"^",1)
    s doseDate=$P(DHCOEDISQTY,"^",21) 
    s wardLocId=$p(DHCOEDISQTY,"^",22)
    s batNo=$p(^PIVA(POGId),"^",3)
    s admId=$p(^OEORD(+mOeori),"^",1)
    s patId=$p(^PAADM(admId),"^",1) 
    s patNo=$p($g(^PAPER(+patId,"PAT",1)),"^",1)
    s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
    q:+wardId=0 ""
    s wardDesc=$p(^PAWARD(wardId),"^",2)
    s bedId=$P(^PAADM(admId),"^",73)
    i bedId'="" s bedNo=$p($g(^PAWARD(+$p(bedId,"||",1),"BED",+$p(bedId,"||",2))),"^",1)
    e  s bedNo="*"
    s batNoIndex=doseDate_"||"_batNo
    s len=$l(SortStr,">")
    f i=1:1:len d
    .s type=$p(SortStr,">",i)
    .q:type=""
    .i type["病区" d
    ..s GetPOGPrtSortDATA("DATA",$i(GetPOGPrtSortCNT))=$j(wardId,5)
    .e  i type["批次" d
    ..s GetPOGPrtSortDATA("DATA",$i(GetPOGPrtSortCNT))=batNoIndex
    .e  i type["登记号" d
    ..s GetPOGPrtSortDATA("DATA",$i(GetPOGPrtSortCNT))=patNo
    .e  i type["床号" d
    ..s GetPOGPrtSortDATA("DATA",$i(GetPOGPrtSortCNT))=bedNo
    .e  i (type["数量")||(type["主药")||(type["溶媒")||(type["辅药") d
    ..s typeNum=+$p(type,"-",2)
    ..s drugType=$p($replace($replace(type,"数量",""),"&",""),"-",1)
    ..s drugTypeData=$g(GetPOGPrtSortDATA(drugType,typeNum))
    ..i drugTypeData="" s drugTypeData="9999999||1^0"
    ..i type["数量" d
    ...i $p(type,"&",1)="数量" s drugTypeData=$j($p(drugTypeData,"^",2),5)_$j($p(drugTypeData,"^",1),10)
    ...e  s drugTypeData=$j($p(drugTypeData,"^",1),10)_$j($p(drugTypeData,"^",2),5)
    ..e  d
    ...s drugTypeData=$j($p(drugTypeData,"^",1),10)
    ..s GetPOGPrtSortDATA("DATA",$i(GetPOGPrtSortCNT))=drugTypeData
    .e  i (type["配液大类") d
    ..s ordCatId = +$p(##class(web.DHCSTPIVAS.Common).GetOrdPivaCat(oeori), "^", 1)
    ..s ordCatSeqNo = +$p($g(^POLI(+ordCatId)), "^", 4)
    ..s GetPOGPrtSortDATA("DATA",$i(GetPOGPrtSortCNT)) = ordCatSeqNo
    .
    s retSortData=""
    s i=""
    f  s i=$o(GetPOGPrtSortDATA("DATA",i)) q:i=""  d
    .s iData=$g(GetPOGPrtSortDATA("DATA",i))
    .s retSortData=$s(retSortData="":iData,1:retSortData_">"_iData)
    q retSortData
}

/// Description: 保存打印日志
/// w ##class(web.DHCSTPIVAS.PrintCom).SavePrintLog("PIVAOrd","111","")
ClassMethod SavePrintLog(type, pointer, remark)
{
    s type = $zcvt(type, "U")
    s curDate = +$h
    s curTime = $p($h, ",", 2)
    s stkType = "G"
    s maxTimes = ..GetPrintLogMaxTimes(type, pointer) + 1
    &SQL(
        INSERT
            INTO
            SQLUSER.PHAIN_PrintLog (PPL_Date,
            PPL_Time,
            PPL_StkType,
            PPL_Type,
            PPL_Pointer,
            PPL_PrintTimes,
            PPT_Remark)
        VALUES (:curDate,
        :curTime,
        :stkType,
        :type,
        :pointer,
        :maxTimes,
        :remark)
    )
    q:(SQLCODE '= 0) ""
    q $p(%ROWID, $c(1))
}

/// Description: 获取最大打印次数
ClassMethod GetPrintLogMaxTimes(type, pointer)
{
    s id = ""
    for {
        s id = $o(^BS.ST.PHAIN.PLOGi(0, "TypePointer", $zcvt(type, "U"), pointer, id))
        q:(id = "")
        s times = +$p($g(^BS.ST.PHAIN.PLOG(id)), "^", 7)
        s calcData(+times) = ""
    }
    q:('$d(calcData)) 0
    q $o(calcData(""), -1)
}

/// w ##class(web.DHCSTPIVAS.PrintCom).GetLabelJson(258).%ToJSON()
ClassMethod GetLabelJson(pog, printFlag = "") As %DynamicObject
{
    q:'$d(^PIVA(+pog)) {}
    
    s pogData = ^PIVA(pog)
    s mDsp = $p(pogData, "^", 1)
    s grpNo = $p(pogData, "^", 2)
    s batNo = $p(pogData, "^", 3), origBatNo = batNo
    s phaLoc = $p(pogData, "^", 7)
    s pNo = $p(pogData, "^", 11)     // 标签记录的序号
    s cPNo = $p(pogData, "^", 18)    // 停止签单号
    s user30 = $p(pogData, "^", 25) 
    s user40 = $p(pogData, "^", 26)
    s operFlag = $p(pogData, "^", 8)
    s mDspData = $g(^DHCOEDISQTY(mDsp))
    s mOeore = $p(mDspData, "^", 3)
    s mOeori = $p(mDspData, "^", 1)
    s packFlag = $p(mDspData, "^", 28)
    s wardLoc = $p(mDspData, "^", 22)   
    
    s adm = $p(^OEORD(+mOeori), "^", 1)
    s admType = $p(^PAADM(adm), "^", 2)
    s ioType = $s(admType = "I" : "I" , 1 : "O")
    s ps10 = $o(^PIVAS(0, "LOCTYPENUMBER", phaLoc, ioType, 10, ""))
    s pogsSub = $o(^PIVA("0", "PS", ps10, pog, ""))
    s prtNo = $p(^PIVA(pog, "S", pogsSub), "^", 7)

    s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", phaLoc, "OeAudit", "AuditTimes")

    s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, ""))  
    s wardDesc = $p($g(^PAWARD(+ward)), "^", 2)
    s priDesc = $p(..OeoriPriority(mOeori), "^", 3)
    s priDesc = $e(priDesc, 1, 2)
    
    s freqDesc = $p(..OeoriFreq(mOeori), "^", 2)
    s instrucDesc = $p(..OeoriInstruc(mOeori), "^", 2)
    s doseDate = $p(mDspData, "^", 21)
    s doseTime = $p(mDspData, "^", 20)
    s doseDateTime = ..DateShortFormat(doseDate) _ " " _ ..TimeShortFormat(doseTime)
    s specType = ""
    if (operFlag = "R"){
        s specType = "拒"
    }
    if (..CheckOeoreStat(mOeore) = 0) {
        s specType = "停"
    }
    s docName = $p(..OeoriDoctor(mOeori), "^", 2)

    if (packFlag '= "")&&(packFlag '= "N"){
        s packFlag = "P"
    }
    s dis = $o(^PIVADIS(0, "DODIS", mDsp, 0))
    if (dis '= "")&&($p($g(^PIVADIS(dis)), "^", 3) = "Y"){
        s packFlag = "P"
    }
    
    s ordRemark = ..OeoriRemark(mOeori)
    
    s pivaCatStr = ..GetOrdPivaCat(mOeori)  
    s pivaCat = $p(pivaCatStr, "^", 2)
    s pivaCat = $e(pivaCat, 1, 1)
    i pivaCat = "其" s pivaCat = ""
    s workType = $p(pogData, "^", 24) 
    s workTypeDesc = $e($p($g(^PIVAWT(+workType)), "^", 3), 1, 1)
    s pivaCat = "【" _ pivaCat _ "】"
    
    
    s bed = $p(^PAADM(adm), "^", 73)
    s pat = $p(^PAADM(adm), "^", 1) 
    s wardSub = +bed
    s bedSub = +$p(bed, "||", 2)
    s bedNo = $p($g(^PAWARD(wardSub, "BED", bedSub)), "^", 1), origBedNo = bedNo
    s patWeight = ..GetPatWeight(adm)
    s patName = $p(^PAPER(pat, "ALL"), "^", 1)
    s patNo = $p(^PAPER(pat, "PAT",1), "^", 1)
    s patSex = +$p(^PAPER(pat, "ALL"), "^", 7)
    s patSex = $p($g(^CT("SEX", patSex)), "^", 2)
    s patAge = ##class(PHA.FACE.IN.Com).GetAge(pat, adm)
    s ivSpeed = ..OeoriIvgttSpeed(mOeori)
    s phaLocDesc = $p($g(^CTLOC(phaLoc)), "^", 2)
    s orderSkin = ##class(web.DHCSTCOMMONORDER).OrderSkinTest(mOeori)
    s orderSkin = $case(orderSkin,
                        "-2": "R(+)",
                        "-1": "R()",
                        :orderSkin)
    s totalLiquid = ""
    s retJson = {
        "pog": (pog),
        "batNo": (batNo),
        "phaLocDesc": (phaLocDesc),
        "wardDesc": (wardDesc),
        "prtNo": (prtNo),
        "pNo": (pNo),
        "cPNo": (cPNo),
        "priDesc": (priDesc),
        "freqDesc": (freqDesc),
        "instrucDesc": (instrucDesc),
        "doseDateTime": (doseDateTime),
        "totalLiquid": (totalLiquid),
        "specType": (specType),
        "patWeight": (patWeight),
        "docName": (docName),
        "packFlag": (packFlag),
        "bedNo": (bedNo),
        "ordRemark": (ordRemark),
        "patNo": (patNo),
        "patName": (patName),
        "patSex": (patSex),
        "patAge": (patAge),
        "pivaCat": (pivaCat),
        "ivSpeed": (ivSpeed),
        "orderSkin": (orderSkin),
        "user30Name": ($p($g(^SSU("SSUSR", +user30)), "^", 2)),
        "user40Name": ($p($g(^SSU("SSUSR", +user40)), "^", 2)),
        "ps10UserName": ($p(..GetStateUser(pog, "10"), "^", 2)),
        "ps30UserName": ($p(..GetStateUser(pog, "30"), "^", 2)),    
        "ps40UserName": ($p(..GetStateUser(pog, "40"), "^", 2)),
        "passUserName": ($p(..GetOrdPassUser(mOeori, doseDate, auditTimes), "^", 2)),
        "phaLabelRemark": (##class(web.DHCSTPIVAS.Remark).Get("PIVASLabel", mOeori))
    }
    s retJson.barCode = mOeore
    s (useInfo, storeInfo) = ""
    
    s rows = []
    s itm = ""
    for {
        s itm = $o(^PIVA(pog, "I", itm), 1, itmData)
        q:(itm = "")
        s (spec, sign, moreFlag) = ""
        s dsp = $p(itmData, "^", 1)
        s dspData = $g(^DHCOEDISQTY(dsp))
        continue:(dspData = "")
        s oeori = $p(dspData, "^", 1)
        s oeore = $p(dspData, "^", 3)
        s qty = $fn($p(dspData, "^", 5), "N")
        s dosage = ..OeoreDosage(oeore)
        
        s arcim = $p(^OEORD(+oeori, "I", +$p(oeori, "||", 2), 1), "^", 2)
        s inci = $o(^INCI(0, "ARCIM_DR", +arcim, ""))
        continue:(inci = "")
        s inciDesc = $p(^INCI(inci, 1), "^", 2)
        s itmAdd = $o(^DHCITMINFO(0, "INCI",inci, "")) 
        if (itmAdd '= ""){
            s itmAddData = $g(^DHCITMINFO(itmAdd))
            s spec = $p(itmAddData, "^", 27)
            s sign = $p(itmAddData, "^", 116)
        }
        s inciDesc = $replace(inciDesc, spec, "")
        s inciDesc = $replace(inciDesc, "[]", "")
        s manfDesc = ..SubString($p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci), "^", 3), 8)
        s bUom = $p(^INCI(inci, 1), "^", 10)
        s bUomDesc = $p($g(^CT("UOM", bUom)), "^", 2)
        s uomDesc = bUomDesc
        s priCode = $p(..OeoriPriority(oeori),"^",2)
        s omFlag = $s(priCode [ "ZT" : "[嘱托]" ,  priCode [ "OM" : "[自备]" , 1 : "")
        s skinTest = $p(##class(web.DHCSTCOMMONORDER).OeoriSkinTest(oeori), "^", 2)
        s drugType = ..GetDrugType(arcim)
        s compFlag = ..DosageCompFlag(oeori, bUom)
        if (compFlag = "N"){
            s compFlag = "" // 不能为N,N时handlebars会认为true
        }
        if (drugType [ "Y")&&(qty > 1) {
            s moreFlag = "Y"
        }
        s rowData = {
            "inciDesc": (skinTest _ omFlag _ sign _ inciDesc),
            "dosage": (dosage),
            "manfDesc": (manfDesc),
            "spec": (spec),
            "compFlag": (compFlag),
            "moreFlag": (moreFlag),
            "qty":(qty)
        }
        d rows.%Push(rowData)
        
        /* 汇总其他药品信息相关 */
        s inciCh = $o(^INCI("IL_LOC", phaLoc, inci, ""))
        s dhcIncil = $o(^DHCINCIL(0,"INCIL",inci _ "||" _ inciCh, ""))
        if (dhcIncil '= ""){
            s incilPivasData = $g(^DHCINCIL(dhcIncil, "PIVAS"))
            s inciUseInfo = $p(incilPivasData, "^", 1)
            s inciStoreInfo = $p(incilPivasData, "^", 2) 
            if (inciUseInfo '= "")&&('$d(calcData("USE", inciUseInfo))){
                s calcData("USE", inciUseInfo) = ""
                s useInfo = $s(useInfo = "" : inciUseInfo, 1 : useInfo _ "," _ inciUseInfo)
            }
            if (inciStoreInfo '= "")&&('$d(calcData("STORE", inciStoreInfo))){
                s calcData("STORE", inciStoreInfo) = ""
                s storeInfo = $s(storeInfo = "" : inciStoreInfo, 1 : storeInfo _ "," _ inciStoreInfo)
            }               
        }
        
    }
    s retJson.rows = rows
    s retJson.printTimes = ""
    /* 增加打印记录 */
    if (printFlag = "Y"){
        s prtRemark = {
            "bedNo": (origBedNo),
            "batNo": (origBatNo)
        }.%ToJSON()
        s prtLog = ..SavePrintLog("PIVAOrdGrp", pog, prtRemark)
        s maxTimes = ..GetPrintLogMaxTimes("PIVAOrdGrp", pog)
        s rePrintTimes = +maxTimes - 1
        if (+rePrintTimes > 0){
            s retJson.printTimes = rePrintTimes
        }
    }
    s retJson.barCode = $replace(mOeore, "||", "-")
    s retJson.useInfo = useInfo
    s retJson.storeInfo = storeInfo
    
    q retJson
}

}
