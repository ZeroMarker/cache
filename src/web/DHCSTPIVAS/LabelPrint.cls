/// Description: 配液打签
/// CreateDate:  2018-03-06
/// Creator:     yunhaibao
Class web.DHCSTPIVAS.LabelPrint Extends web.DHCSTPIVAS.Common
{

/// Description: 配液打签病区列明细
/// Debug:       w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.LabelPrint","WardData","")
Query WardData(pJsonStr = "{}") As websys.Query(ROWSPEC = "ward, wardDesc, cnt")
{
}

ClassMethod WardDataExecute(ByRef qHandle As %Binary, pJsonStr = "{}") As %Status
{
    //s pJsonStr=^TMPDHCSTPARAMS("web.DHCSTPIVAS.LabelPrint","LabelPrintWard") //=pJsonStr
    //s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.LabelPrint","LabelPrintWard")=pJsonStr
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    
    d ..Collect(pJsonStr,.collectData)
    k calcData, calcCntData
    s pog = 0
    for {
        s pog = $o(collectData(pog))
        i pog = "" q
        s pogData = $g(^PIVA(pog))
        s mDsp = $p(pogData, "^", 1)
        s dspData = $g(^DHCOEDISQTY(mDsp))
        s wardLoc = $p(dspData, "^", 22)    
        s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, 0))  
        i ward = "" q
        s sortIndex = ward
        s calcCntData(ward) = $g(calcCntData(ward)) + 1
        s calcData(sortIndex, ward) = ""

    }
    s sortIndex = ""
    for {
        s sortIndex = $o(calcData(sortIndex))
        i sortIndex = "" q
        s ward = ""
        for {
            s ward = $o(calcData(sortIndex, ward))
            i ward = "" q
            s wardDesc = ##class(PHA.PIVAS.Data.Base).WardDesc(ward)
            s cnt = $g(calcCntData(ward))
            s ^CacheTemp(repid,ind) = $lb(ward, wardDesc, cnt)    
            s ind = ind + 1
        }
    }
    q $$$OK
}

/// Description: 配液打签病区列明细 - 单行模式
/// Debug:       w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.LabelPrint","OrdExeData","")
Query OrdExeData(pJsonStr = "{}") As websys.Query(ROWSPEC = "seqNo, pog, doseDateTime, batNo, drugsArr, patNo, patName, bedNo, freqDesc, instrucDesc, freqDesc, itmCnt, wardDesc,sameFlag,check,packFlag,altFlag, mDsp, workTypeDesc, pivaCatDesc")
{
}

ClassMethod OrdExeDataExecute(ByRef qHandle As %Binary, pJsonStr = "{}") As %Status
{
    #; s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.LabelPrint","OrdExeData")=pJsonStr
    //s pJsonStr = ^TMPDHCSTPARAMS("web.DHCSTPIVAS.LabelPrint","OrdExeData")
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s prtWayGrp = 2
    s pJson = ##class(web.DHCSTPIVAS.Util).DataToJson(pJsonStr)
    q:'$IsObject(pJson) $$$OK
    
    s pLoc = pJson.loc
    s prtWayArr = pJson.prtWayArr
    d ..Collect(pJsonStr, .collectData)
    d ..SortPogData(.collectData, .calcData, prtWayArr)
    k collectData
    
    s dispFlag = ..PsDispFlag(pLoc, "10")
    s check = "Y"
    /* 输出 */
    s pogCnt= 0, seqNo = 0, lastPatNo = "", altCnt = 0
    s i = ""
    for {
        s i = $o(calcData(i))
        q:(i = "")
        s pog = calcData(i)
        s pogItmCnt = ..GetPogItmCnt(pog)
        s pogData = $g(^PIVA(pog))
        s mDsp = $p(pogData, "^", 1)
        s batNo = $p(pogData, "^", 3)   
        s dspData = $g(^DHCOEDISQTY(mDsp))
        s mOeori = $p(dspData, "^", 1)
        s mOeore = $p(dspData, "^", 3)
        s doseTime=$p(dspData,"^",20)
        s doseDate=$p(dspData,"^",21)
        s wardLoc = $p(dspData, "^", 22)
        s wardDesc= ##class(PHA.PIVAS.Data.Base).LocDesc(wardLoc)
        s adm = $p(dspData, "^", 26)
        s packFlag = ..DspPackFlag(mDsp)
        s patId = $p(^PAADM(adm), "^", 1)                                           
        s patName = $p(^PAPER(patId, "ALL"), "^", 1)
        s patNo = $p(^PAPER(patId, "PAT", 1), "^", 1)
        s bedId = $p(^PAADM(adm),"^",73)
        s bedNo = "*"
        i bedId '= "" {
            s bedNo=$p($g(^PAWARD(+bedId, "BED", +$p(bedId,"||",2))), "^", 1)
            s bedNo = $s(bedNo '= "" : bedNo, 1:"")
        }
    
        s doseDTHtml = ..DateShortFormat(doseDate) _ " " _ ..TimeShortFormat(doseTime)      
        s freqDesc = $p(##class(web.DHCSTCOMMONORDER).OeoriFreq(mOeori), "^", 3)
        s instrucDesc = $p(..OeoriInstruc(mOeori), "^", 2)
        s docName = $p(..OeoriDoctor(mOeori), "^", 2)
        s workType = ..GetWorkTypeByPog(pog)
        s workTypeDesc = ##class(PHA.PIVAS.Data.Base).PIVAWorkTypeDesc(+workType)
        s pivaCatDesc = $p(..GetOrdPivaCat(mOeori), "^", 2)
        s passResultDesc = ""
        s oeoriSign = ""
        s seqNo = seqNo + 1
        s drugsArr = ..GetPogDrugsArr(pog)
        s sameFlag = "" 
        if (lastPatNo = patNo) {
            s sameFlag = "Y"
        }
        if (lastPatNo '= patNo){
            s altFlag = "N"
            s altCnt = altCnt + 1
            i altCnt = 2 s altFlag = "Y", altCnt = 0    
        }
        s lastPatNo = patNo

        s lbData = $lb(seqNo, pog, doseDTHtml, batNo, drugsArr)
                 _ $lb(patNo, patName, bedNo, freqDesc, instrucDesc)
                 _ $lb(freqDesc, pogItmCnt, wardDesc, sameFlag, check)
                 _ $lb(packFlag, altFlag, mDsp, workTypeDesc, pivaCatDesc)
        s ^CacheTemp(repid,ind) = lbData    
        s ind = ind + 1 
    }
    q $$$OK
}

/// Description: 排序
ClassMethod SortPogData(ByRef inData, Output outData, prtWayArr As %DynamicArray)
{
    if $IsObject(prtWayArr) {
        s len = prtWayArr.%Size()
        for i = 1 : 1 : len {
            s pwtObj= prtWayArr.%Get(i - 1)
            s pwt = pwtObj.%Get("pwt")
            s prtWay = pwtObj.%Get("prtWay")
            s prtWay = ##class(web.DHCSTPIVAS.PrintCom).ReSortPrtWay(prtWay)
            s workTypePrtData(pwt) = prtWay
        }
    }
    k sortPogData
    s pog = 0
    for {
        s pog = $o(inData(pog))
        q:pog=""
        s pogData = $g(^PIVA(pog))
        s workType = ..GetWorkTypeByPog(pog)
        if workType="" {
            continue
        }
        s workTypeData = $g(^PIVAWT(workType)) 
        s workTypeCode = $p(workTypeData, "^", 2)
        s prtWaySortStr = $p(workTypeData, "^", 3)
        if $d(workTypePrtData(workType)) {
            s prtWaySortStr = $g(workTypePrtData(workType))
        }
        s prtSortIndex = ##class(web.DHCSTPIVAS.PrintCom).GetPOGPrtSort(pog, prtWaySortStr)
        s prtWayGrp=""
        i prtWayGrp = "Ward" s workTypeIndex = 1
        e  s workTypeIndex = $j(workTypeCode, 5) _ "^" _ $j(workType, 3)
        i prtSortIndex = "" s prtSortIndex = $$$MaxStr
        s sortIndex = workTypeIndex _ "^" _ prtSortIndex
        s sortPogData(sortIndex, pog) = "" 
    }
    s sortIndex = ""
    for {
        s sortIndex = $o(sortPogData(sortIndex))
        q:sortIndex=""
        s pog = ""
        for {
            s pog = $o(sortPogData(sortIndex, pog))
            q:pog=""
            s outData($i(cnt)) = pog
        }
    }
}

/// Description: 工作组汇总数据
/// Debug:       w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.LabelPrint","WorkTypeData","[]")
Query WorkTypeData(pJsonStr = "[]") As websys.Query(ROWSPEC = "workType, workTypeCode, workTypeDesc, prtWayDesc, batCntData, cnt, pivasCnt, packCnt")
{
}

ClassMethod WorkTypeDataExecute(ByRef qHandle As %Binary, pJsonStr = "[]") As %Status
{
    s repid = $i(^CacheTemp)
    s qHandle = $lb(0, repid, 0)
    s ind = 1
    s pJsonArr = ##class(web.DHCSTPIVAS.Util).DataToJson(pJsonStr)
    k calcData, calcBatData, calcTotalData
    for {
        s pog = pJsonArr.%Pop()
        if pog = "" {
            q
        }
        s pogData = $g(^PIVA(pog))
        s mDsp = $p(pogData, "^", 1)
        s batNo = $p(pogData, "^", 3)
        s packFlag = ##class(web.DHCSTPIVAS.Common).DspPackFlag(mDsp)
        s workType = ..GetWorkTypeByPog(pog)
        s workTypeData = ^PIVAWT(workType)
        s workTypeCode = $p(workTypeData, "^", 2)
        s sortIndex = workTypeCode
        s calcData(sortIndex, workType) = $g(calcData(sortIndex, workType)) + 1
        s calcBatData(workType, batNo) = $g(calcData(workType, batNo)) + 1
        if (packFlag = "P") {
            s calcTotalData(workType, "P") = $g(calcTotalData(workType, "P")) + 1
        } else {
            s calcTotalData(workType) = $g(calcTotalData(workType)) + 1
        }
    }
    
    s sortIndex = ""
    for {
        s sortIndex = $o(calcData(sortIndex))
        i sortIndex = "" q
        s workType = ""
        for {
            s workType = $o(calcData(sortIndex, workType))
            i workType = "" q   
            s workTypeData = ^PIVAWT(workType)
            s workTypeCode = $p(workTypeData, "^", 2)
            s workTypeDesc = $p(workTypeData, "^", 3)
            s prtWayDesc = $p(workTypeData, "^", 4)
            s batCntData = ""
            d GetBatCntData
            s pivasCnt = $g(calcTotalData(workType))
            s packCnt = $g(calcTotalData(workType, "P"))
            s cnt = pivasCnt + packCnt
            s lbData = $lb(workType, workTypeCode, workTypeDesc, prtWayDesc, batCntData, cnt, pivasCnt, packCnt)        
            s ^CacheTemp(repid, ind) = lbData
            s ind = ind + 1 
        }
    }
    q $$$OK
    
GetBatCntData
    s batCntJson = ##class(%DynamicArray).%New()
    s batNo = ""
    for {
        s batNo = $o(calcBatData(workType, batNo))
        i batNo = "" q
        s cnt = calcBatData(workType, batNo)
        s batCntObj = ##class(%DynamicObject).%New()
        d batCntObj.%Set("batNo", batNo)
        d batCntObj.%Set("cnt", cnt)
        d batCntJson.%Push(batCntObj)
    }
    s batCntData = batCntJson.%ToJSON()
    q
}

ClassMethod Collect(pJsonStr = "{}", Output collectData)
{
    q:pJsonStr="{}" ""
    s pJson = ##class(PHA.COM.Json).Parse(pJsonStr)
    q:'$IsObject(pJson) ""
    
    s pLoc = pJson.loc, pStartDate = pJson.startDate, pEndDate = pJson.endDate, pStartTime = pJson.startTime
    s pEndTime = pJson.endTime, pLoc = pJson.loc, pWardStr = pJson.wardStr, pLocGrp =  pJson.locGrp, pCat = pJson.cat
    s pWorkType = pJson.workType, pInci = pJson.inci, pInstruc = pJson.instruc, pPackFlag = pJson.packFlag
    s pBatNoStr = pJson.batNoStr, pAdm = pJson.adm, pPriority = pJson.priority
    
    s pStartDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(pStartDate)
    s pEndDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(pEndDate)
    s pStartTime= ##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(pStartTime)
    s pEndTime = ##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(pEndTime)
    s pBatNoList = $lfs(pBatNoStr)
    s pWardList = $lfs(pWardStr)
    q:(pLoc="") ""
    s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",pLoc,"OeAudit","AuditTimes")
    s needNurAudit=##class(web.DHCSTPIVAS.Settings).GetNeedNurseAudit(pLoc)
    
    for calcDate = pStartDate : 1 : pEndDate {
        s pog = 0
        for {
            s pog = $o(^PIVA(0, "LOCORDDATE", pLoc, calcDate, pog))
            i pog = "" q
            s pogData = $g(^PIVA(pog))
            s mDsp = $p(pogData, "^", 1)
            s batNo = $p(pogData, "^", 3)
            s ps = $p(pogData, "^", 6)
            s psNumber = $p(^PIVAS(ps), "^", 1)
            s dspData = $g(^DHCOEDISQTY(mDsp))
            s mOeori = $p(dspData, "^", 1)
            s mOeore = $p(dspData, "^", 3)
            s wardLoc = $p(dspData, "^", 22)
            s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, 0))
            s adm = $p(dspData, "^", 26)
            s admType = $p(^PAADM(adm),"^",2)
            s packFlag = ..DspPackFlag(mDsp)
            continue:(psNumber '= 3) 
            continue:(admType '= "I") 
            continue:(pAdm '= "")&&(pAdm '= adm) 
            continue:(..CheckOeoreStat(mOeore) '= 1 )
            continue:(..IsOrderPreStop(mOeore) = $$$YES )
            continue:(..IsPivasRefused(mDsp) = $$$YES)
            continue:(pWardList '= "")&&($lf(pWardList, ward) = 0)
            continue:(pLocGrp '= "")&&(..CheckLocGrp(pLocGrp,wardLoc) = 0)
            continue:(needNurAudit = "Y")&&(..NurAuditFlagByMDsp(mDsp)'= "Y")
            continue:$p(##class(web.DHCSTPIVAS.Common).GetNurseSeeType(mOeori, pLoc), "^", 1)="N"
            continue:(pPackFlag '= "")&&(..CheckDspPack(mDsp,pPackFlag) '= "Y")
            s passStat=$p(..GetOrdPassState(mOeori, calcDate, auditTimes, pLoc), "^", 1)
            continue:(passStat = "SHJJ")||(passStat = "")
            continue:(pInstruc '="" )&&(pInstruc '= $p(..OeoriInstruc(mOeori), "^", 1))
            continue:(pCat '= "")&&(pCat '= $p(..GetOrdPivaCat(mOeori), "^", 1))
            continue:(pWorkType '= "")&&(pWorkType '= $p(pogData, "^", 24))
            continue:(pInci '= "")&&(..IsInciInPog(pog, pInci) '= "Y")
            continue:($lf(pBatNoList, batNo) = 0)
            continue:(pPriority '= "")&&(pPriority '= $p(..OeoriPriority(mOeori),"^",1))
            s arcCatStr=##class(web.DHCSTPIVAS.Common).GetArcItmCatByOeori(mOeori)
            continue:##Class(web.DHCSTCOMMONSRV).IfCollectDrugAllowed(adm,$p(arcCatStr,"^",1))'=1
            s collectData(pog) = ""
        }
    }
    q ""
}

/// Description: 保存打签数据
/// Debug:       w ##class(web.DHCSTPIVAS.LabelPrint).SaveData([547].%ToJSON(),,711,"","","")
ClassMethod SaveData(pogJsonStr = "[]", prtJsonStr = "[]", user, user30, user40, user50)
{
    s $zt = "ErrorSaveData"
    s pogJson = ##class(web.DHCSTPIVAS.Util).DataToJson(pogJsonStr)
    q:pogJson="[]" "-1^没有可保存的数据"
    /* 排序 */
    d ..SortSaveData(pogJson,.calcData)
    
    s firstWard = $o(calcData(""))
    s firstPog = $o(calcData(firstWard, ""))
    s recLoc = $p(^PIVA(firstPog), "^", 7)
    s curDate = +$h
    /* 保存 */
    s pogsNo = ""
    s pogsNo=##class(web.DHCSTPIVAS.Common).GetAppNo("10", recLoc)
    s cntData("success") = 0
    s ward = ""
    for {
        s phac = ""
        s ward = $o(calcData(ward))
        i ward = "" q
        s cntData("wardSuccess", ward) = 0
        s pog = ""
        for {
            s pog = $o(calcData(ward, pog))
            if pog = "" {
                q
            }
            s pogData = $g(^PIVA(pog))

            s lockRet = ..Lock("PIVAOrdGrp", pog)
            if +lockRet < 0 {
                q
            }
            /* 事务 */
            ts
            &SQL(
                UPDATE PIVA_OrdGrp 
                SET 
                    POG_User30_Dr = :user30, 
                    POG_User40_Dr = :user40, 
                    POG_User50_Dr = :user50 
                WHERE POG_RowId=:pog
            )
            s exeRet=##class(web.DHCSTPIVAS.DataHandler).Execute(pog, "10", user, recLoc, pogsNo)
            if $p(exeRet,"^",1)<0 {
                tro
                d ..UnLock("PIVAOrdGrp", pog)
                d ErrorRecord^DHCSTERROR("DHCSTINPIVA","pogId:"_pog,exeRet) 
                s lastError = exeRet
                q
            }
            tc
            d ..UnLock("PIVAOrdGrp", pog)
            s wardSuccCnt = $i(cntData("wardSuccess", ward))    
            s succCnt = $i(cntData("success"))
            /* 用于累加标签流水号 */
            s successPogData(pog) = ""
            d ##class(web.DHCSTPIVAS.DataCenter).UpdateSystemStatus(10, $p(pogData, "^", 1), user)
        }
        #; 20231012 插入发药主表在真实处理库存处处理
        #; if (cntData("wardSuccess", ward) = 0)&&(phac '= "") {
        #;     d ##class(web.DHCSTPIVAS.DataHandler).DeleteDHCPHACollected(phac)
        #; }   
    }
    if ($g(cntData("success")) = 0){
        q:($d(lastError)) lastError
        q "-1^没有可打印的数据"
    } 
    d ..ReSavePogPNo(pogJson, .successPogData)
    q pogsNo
ErrorSaveData
    s errMsgInfo="##class(web.DHCSTPIVAS.LabelPrint).SaveData"
    d ErrorRecord^DHCSTERROR("DHCSTINPIVA",errMsgInfo,$ze)  
    q "-2^"_$tr($ze,"^","-")
}

ClassMethod SortSaveData(arrData As %DynamicArray, Output calcData)
{
    s len = arrData.%Size()
    s dataLen = len - 1
    for i = 0 : 1 : dataLen {
        s pog = arrData.%Get(i)
        continue:(pog = "")
        s pogData = $g(^PIVA(pog))
        s mDsp = $p(pogData, "^", 1)
        s dspData = $g(^DHCOEDISQTY(mDsp))
        s wardLoc = $p(dspData, "^", 22)    
        s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, 0))  
        s calcData(ward, pog) = ""      
    }
    q ""
}

/// Debug:       w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.LabelPrint","WorkType","248")
Query WorkType(loc) As websys.Query(ROWSPEC = "pwt, pwtDesc, pwtPrtWay")
{
}

ClassMethod WorkTypeExecute(ByRef qHandle As %Binary, loc) As %Status
{
    s repid = $i(^CacheTemp)
    s qHandle = $lb(0, repid, 0)
    s ind = 1
    q:loc="" $$$OK
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT PIVAWT_Rowid as pwt, PIVAWT_Desc as pwtDesc,PIVAWT_PrtWay as pwtPrtWay "
             _ "FROM PIVA_WorkType "
             _ "WHERE PIVAWT_LOC_DR = " _ loc _ " AND PIVAWT_UseFlag = 'Y'"
             _ "ORDER BY PIVAWT_Code"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next()) {
        s ^CacheTemp(repid, ind) = $lb(result.Data("pwt"), result.Data("pwtDesc"), result.Data("pwtPrtWay"))    
        s ind = ind + 1
    }
    d result.Close()
    q $$$OK
}

/// Description: 保存完成后, 重新按照前台的顺序重置顺序号
/// Input:       pogArr - 前台的标签的顺序
///              successPogData - 保存成功的数组
///                  w ##class(web.DHCSTPIVAS.LabelPrint).ReSavePogPNo()
ClassMethod ReSavePogPNo(pogArr, ByRef successPogData)
{
    s pNoMode = ""
    s curDate = +$h
    s pNo = 0
    s len = pogArr.%Size()
    s dataLen = len - 1
    for i = 0 : 1 : dataLen {
        s pog = pogArr.%Get(i)
        if ($d(successPogData(pog))){
            s recLoc = $p(^PIVA(pog), "^", 7)
            if (pNoMode = ""){
                s pNoMode = ##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", recLoc, "LabelPrint", "PNoMode")
                if (pNoMode = ""){
                    s pNoMode = "ONCE"
                }
            }
            s pDateNo = $i(^web.DHCSTPIVAS.LabelPrintD("DateNo", curDate, recLoc))  
            s pNo = pNo + 1
            if (pNoMode = "DAY"){
                s pNo = pDateNo
            }
            d ##class(web.DHCSTPIVAS.DataCenter).UpdatePogPNo(pog, pNo, pDateNo)
        }
    }
    q $$$OK
}

}
