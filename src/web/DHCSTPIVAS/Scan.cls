Class web.DHCSTPIVAS.Scan Extends web.DHCSTPIVAS.Common
{

/// Description: 开始扫描生成单号
/// w ##class(web.DHCSTPIVAS.Scan).GeneNo(248)
ClassMethod GeneNo(loc, psNumber = "")
{
    q ##class(web.DHCSTPIVAS.Common).GetAppNo(psNumber, loc)
}

/// Description: 
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Scan","WardData")
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Scan","WardData","{""loc"":""248"",""startDate"":""2019-06-30"",""endDate"":""2020-07-09"",""psNumber"":""70"",""batNoStr"":"""",""catStr"":""53""}")
Query WardData(pJsonStr = "{}") As websys.Query(ROWSPEC = "wardLoc, wardLocDesc, unScaned:%Integer, scaned:%Integer")
{
}

ClassMethod WardDataExecute(ByRef qHandle As %Binary, pJsonStr = "{}") As %Status
{
    s ^TMPPIVASPARAMS("WardData")=pJsonStr
    s repid = $i(^CacheTemp)
    s qHandle = $lb(0, repid, 0)
    s ind = 1
    
    d ..Collect(pJsonStr, .collectData)
    q:'$d(collectData) $$$OK
    
    s pog=0
    for {
        s pog = $o(collectData(pog))
        q:(pog = "")
        s pogData = $g(^PIVA(pog))
        s mDsp = $p(pogData, "^", 1)
        s wardLoc= $p(^DHCOEDISQTY(mDsp),"^",22)
        if '$d(WardData(wardLoc)) {
            s WardData(wardLoc) = $lb(0, 0) 
        }
        s $list(WardData(wardLoc), 1) = $list(WardData(wardLoc), 1) + 1 
    }

    s wardLoc = ""
    for {
        s wardLoc = $o(WardData(wardLoc))
        q:(wardLoc = "")
        s lbData = WardData(wardLoc)
        s wardLocDesc = ##class(PHA.PIVAS.Data.Base).LocDesc(wardLoc)
        s ^CacheTemp(repid, ind) = $lb(wardLoc, wardLocDesc, $lg(lbData, 1), $lg(lbData, 2))
        s ind = ind + 1
    }
    q $$$OK
}

/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Scan","GetScanData")
Query LabelData(pJsonStr = "{}") As websys.Query(ROWSPEC = "barCode,batNo,drugsArr,pivaCatDesc,wardLocDesc,patBedNo,patName,patNo,doseDTHtml,freqDesc,instrucDesc,packFlag")
{
}

ClassMethod LabelDataExecute(ByRef qHandle As %Binary, pJsonStr = "{}") As %Status
{
    k LabelData
    s ind = 1
    s repid = $i(^CacheTemp)
    s qHandle = $lb(0, repid, 0)
    
    s pJson = ##class(PHA.COM.Json).Parse(pJsonStr)
    q:'$IsObject(pJson) $$$OK
    s pBarCode = pJson.barCode
    if pBarCode'="" {
        s pog = ##class(web.DHCSTPIVAS.Common).BarCodeToPog(pBarCode)
        if (pog '= "") {
            s collectData(pog)=""
        }
    } else {
        d ..Collect(pJsonStr, .collectData)
    }
    q:'$d(collectData) $$$OK
    
    s pog = 0
    for {
        s pog  = $o(collectData(pog))
        q:(pog = "")
        s pogData = $g(^PIVA(pog))
        s mDsp = $p(pogData, "^", 1)
        s dspData = $g(^DHCOEDISQTY(mDsp))
        s mOeore = $p(dspData, "^", 3)
        s wardLocId = $p(dspData, "^", 22)
        s wardLocDesc = ##class(PHA.PIVAS.Data.Base).LocDesc(wardLocId)
        s batNo = $p(pogData, "^", 3)
        s barCode = $replace(mOeore, "||", "-")
        s admId = $p(^OEORD(+mOeore), "^", 1)   
        s patId = $p(^PAADM(admId), "^", 1) 
        s patName = $p(^PAPER(patId, "ALL"), "^", 1)
        s patNo = $p(^PAPER(patId, "PAT", 1), "^", 1)

        s mOeori = $p(dspData, "^", 1)
        s mOeore = $p(dspData, "^", 3)
        s doseTime = $p(dspData,"^",20)
        s doseDate = $p(dspData,"^",21)
        s doseDTHtml = ..DateShortFormat(doseDate) _ " " _ ..TimeShortFormat(doseTime)      
        s freqDesc = $p(##class(web.DHCSTCOMMONORDER).OeoriFreq(mOeori), "^", 3)
        s instrucDesc = $p(..OeoriInstruc(mOeori), "^", 2)
        s pivaCatDesc = $p(..GetOrdPivaCat(mOeori), "^", 2)
        s patBedNo = $p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(admId), "^", 2)
        s drugsArr= ..GetPogDrugsArr(pog)
        s packFlag = ..DspPackFlag(mDsp)
        s lbData=$lb(barCode, batNo, drugsArr, pivaCatDesc,wardLocDesc, patBedNo, patName, patNo, doseDTHtml, freqDesc, instrucDesc, packFlag)
        s ^CacheTemp(repid, ind) = lbData
        s ind = ind + 1
    
    }

    q $$$OK
}

ClassMethod Collect(pJsonStr, Output collectData)
{
    q:pJsonStr="{}"
    s pJson = ##class(PHA.COM.Json).Parse(pJsonStr)
    q:'$IsObject(pJson) $$$OK
    s pLoc = pJson.loc
    s pStartDate = pJson.startDate
    s pEndDate = pJson.endDate
    s pPSNumber = pJson.psNumber
    s pScanStatus = pJson.pScanStatus
    s pStartDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(pStartDate)
    s pEndDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(pEndDate)

    d ##class(web.DHCSTPIVAS.Common).GetPSDict(pLoc,.psDict)

    s pArr = ##class(%ArrayOfDataTypes).%New()
    d pArr.SetAt($lfs(pJson.batNoStr), "batNoList")
    d pArr.SetAt($lfs(pJson.wardLocStr), "wardLocList")
    d pArr.SetAt($lfs(pJson.catStr), "catList")
    for calcDate = pStartDate : 1 : pEndDate {
        s pog = ""
        for {
            s pog = $o(^PIVA(0, "LOCORDDATE", pLoc, calcDate, pog))
            q:(pog = "")
            s pogData = $g(^PIVA(pog))
            s mDsp = $p(pogData, "^", 1)
            s adm =$p($g(^DHCOEDISQTY(mDsp)), "^", 26)
            s admType = $p(^PAADM(adm), "^", 2)
            continue:(admType '= "I")
            s psId = $p(pogData, "^", 6)
            s psNumber = $p(^PIVAS(psId), "^", 1)
            s psStat = ..GetPogStat(pog, pPSNumber, .psDict)
            continue:(pScanStatus="allScan")&&(psStat'=1)
            continue:(pScanStatus="")&&(psStat'=1)
            continue:(pScanStatus="unScaned")&&(psStat'=1)
            continue:(pScanStatus="scaned")&&(psStat'=2)
            continue:+..FilterPog(pog, pPSNumber)<0
            continue:+..FilterCondition(pog, pArr)<0
            s collectData(pog)=""   
        }
    }
    q
}

/// Description: 条件判断
/// Return:      -1^错误信息
ClassMethod FilterCondition(pog, pArr As %ArrayOfDataTypes)
{
    s pogData = $g(^PIVA(pog))
    s mDsp = $p(pogData, "^", 1)
    s batNo = $p(pogData, "^", 3)
    s mOeori = $p(^DHCOEDISQTY(mDsp), "^", 3)
    s batNoList = pArr.GetAt("batNoList")
    q:(batNoList'="")&&($lf(batNoList,batNo)=0) "-1^批次不符"
    s catList = pArr.GetAt("catList")
    q:(catList'="")&&($lf(catList, $p(##class(web.DHCSTPIVAS.Common).GetOrdPivaCat(mOeori),"^",1)) = 0) "-1^配液大类不符"
    s wardLocList = pArr.GetAt("wardLocList")
    s wardLoc= $p(^DHCOEDISQTY(mDsp),"^",22)
    q:(wardLocList'="")&&($lf(wardLocList, wardLoc)=0) "-1^病区不符"
    q 0
}

/// Description: 判断预执行状态
/// Return:      1 - 处于预执行, 2 - 处于执行, 3 - 执行已过
ClassMethod GetPogStat(pog, psNumber, ByRef psDict)
{
    s pogData = $g(^PIVA(pog))
    s mDsp = $p(pogData, "^", 1)
    s curPS = $p(pogData, "^", 6)
    s packFlag = ##class(web.DHCSTPIVAS.Common).DspPackFlag(mDsp)
    s curPSNumber = $p($g(^PIVAS(curPS)),"^",1)
    s nextType = $s(packFlag="P" : "PACKDICT", 1: "DICT")
    s nextNumber = $o(psDict(nextType, curPSNumber))
    q:psNumber=nextNumber 1
    q:curPSNumber=psNumber 2
    q:curPSNumber>psNumber 3
    q 0
}

/// Description: 强制不可扫,执行记录停止等
/// Return:      -1^错误信息
ClassMethod FilterPog(pog, psNumber)
{
    s pogData = $g(^PIVA(pog))
    s mDsp = $p(pogData, "^", 1)
    s loc = $p(pogData, "^", 7)
    s dspData = $g(^DHCOEDISQTY(mDsp))
    s mOeori = $p(dspData, "^", 1)
    s mOeore = $p(dspData, "^", 3)
    s doseDate = $p(dspData, "^", 21)
    s adm = $p(dspData, "^", 26) 
    s needStopInfo = ##class(web.DHCSTPIVAS.Common).GetNeedStopState(pog, psNumber)
    q:(+needStopInfo < 0) needStopInfo
    q:$p(pogData, "^", 8)="R" "-1^已配液拒绝"
    q:$p(pogData, "^", 18)'="" "-1^已打印停止签"
    s nurAuditFlag = ##class(web.DHCSTPIVAS.Settings).GetNeedNurseAudit(loc)
    q:(nurAuditFlag="Y")&&(##class(web.DHCSTPIVAS.Common).NurAuditFlagByMDsp(mDsp)'="Y") "-1^未领药审核"
    s auditTimes = ##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", loc, "OeAudit", "AuditTimes")
    s passCode=$p(##Class(web.DHCSTPIVAS.Common).GetOrdPassState(mOeori, doseDate, auditTimes, loc), "^", 1)
    q:passCode'="SHTG" "-1^配伍审核未通过"
    s arcCat = $p(##class(web.DHCSTPIVAS.Common).GetArcItmCatByOeori(mOeori), "^", 1)
    q:##Class(web.DHCSTCOMMONSRV).IfCollectDrugAllowed(adm, arcCat)'=1 "-1^已出院"
    q 0
}

/// w ##class(web.DHCSTPIVAS.Scan).Execute()
ClassMethod Execute(pJsonStr = "{}")
{
    s pJson = ##class(PHA.COM.Json).Parse(pJsonStr)
    q:'$IsObject(pJson) "error|$|JSON条件转换失败|$|"
    s barCode = pJson.barCode
    s psNumber = pJson.psNumber
    s user = pJson.user
    s pogsNo = pJson.pogsNo

    s pArr = ##class(%ArrayOfDataTypes).%New()
    d pArr.SetAt($lfs(pJson.batNoStr), "batNoList")
    d pArr.SetAt($lfs(pJson.wardLocStr), "wardLocList")
    d pArr.SetAt($lfs(pJson.catStr), "catList")
    
    s pog = ##class(web.DHCSTPIVAS.Common).BarCodeToPog(barCode)
    q:(pog = "") "warning|$|" _ "不存在该条码" _ "|$|"
    s conRet=..FilterCondition(pog, pArr)
    q:+conRet<0 "warning|$|" _ $p(conRet, "^", 1) _ "|$|"

    s loc=$p(^PIVA(pog), "^", 7)
    s ret = ##class(web.DHCSTPIVAS.DataHandler).Execute(pog, psNumber, user, loc, pogsNo)
    s retWarn = "success", retMsg = "扫描成功"
    i +ret<0 d
    .s retWarn = "warning", retMsg = $p(ret, "^", 2)
    
    s labelData=##class(web.DHCSTPIVAS.PrintCom).GetLabelJson(pog).%ToJSON()
    if (retWarn = "success") {
        d ##class(web.DHCSTPIVAS.DataCenter).UpdateSystemStatus(psNumber, $p($g(^PIVA(pog)), "^", 1), user)
    }
    q retWarn_"|$|"_retMsg_"|$|"_labelData
}

}
