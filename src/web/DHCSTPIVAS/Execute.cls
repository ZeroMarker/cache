/// Description: 配液状态执行
Class web.DHCSTPIVAS.Execute Extends web.DHCSTPIVAS.Common
{

/// Debug:       w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Execute","OrdExeData","")
Query OrdExeData(pJsonStr = "{}") As websys.Query(ROWSPEC = "warnInfo, pog, doseDateTime, batNo, drugsArr, patNo, patName, bedNo, freqDesc, instrucDesc, freqDesc, pogItmCnt, wardDesc, sameFlag, check, packFlag, altFlag, mDsp, workTypeDesc, pivaCatDesc, barCode, priDesc, psDesc, passResultDesc")
{
}

ClassMethod OrdExeDataExecute(ByRef qHandle As %Binary, pJsonStr = "{}") As %Status
{
#;    s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.Execute","OrdExeData")=pJsonStr
    //s pJsonStr = ^TMPDHCSTPARAMS("web.DHCSTPIVAS.Execute","OrdExeData")
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s pJson = ##class(web.DHCSTPIVAS.Util).DataToJson(pJsonStr)
    q:'$IsObject(pJson) $$$OK
    
    s pLoc = pJson.loc
    s pPsNumber = pJson.psNumber
    s dispFlag = ..PsDispFlag(pLoc, pPsNumber)
    s packDispFlag = ..PsDispFlag(pLoc, pPsNumber, "P")
    s auditTimes = ##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", pLoc, "OeAudit", "AuditTimes")
    d ..Collect(pJsonStr, .collectData)
    d ..SortOrdExeData(.collectData, .calcData)
    k collectData
    
    s check = "Y"
    
    /* 输出 */
    s pogCnt= 0, seqNo = 0, lastPatNo = "", altCnt = 0
    s i = ""
    for {
        s i = $o(calcData(i))
        q:i=""
        s pog = calcData(i)
        s pogItmCnt = ..GetPogItmCnt(pog)
        s pogData = $g(^PIVA(pog))
        s mDsp = $p(pogData, "^", 1)
        s batNo = $p(pogData, "^", 3)
        s ps = $p(pogData, "^", 6)
        s psDesc = $p(^PIVAS(ps), "^", 2)
        
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
            s bedNo = $s(bedNo '= "" : bedNo_"床", 1:"")
        }
        
        s doseDateTime = ..DateShortFormat(doseDate)_" "_..TimeShortFormat(doseTime)        
        s freqDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(mOeori), "^", 3)
        s instrucDesc=$p(..OeoriInstruc(mOeori), "^", 2)
        s docName=$p(..OeoriDoctor(mOeori), "^", 2)
        s workType = ..GetWorkTypeByPog(pog)
        s workTypeDesc = ##class(PHA.PIVAS.Data.Base).PIVAWorkTypeDesc(+workType)
        s pivaCatDesc = $p(..GetOrdPivaCat(mOeori), "^", 2)
        s passResultDesc = $p(..GetOrdPassState(mOeori, doseDate, auditTimes, pLoc), "^", 2)
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
        s barCode = ..OeoreToBarCode(mOeore)
        s warnInfo = ""

        s priDesc = $p(..OeoriPriority(mOeori), "^", 3)

        s lbData = $lb(warnInfo, pog, doseDateTime, batNo, drugsArr)
                 _ $lb(patNo, patName, bedNo, freqDesc, instrucDesc)
                 _ $lb(freqDesc, pogItmCnt, wardDesc, sameFlag, check)
                 _ $lb(packFlag, altFlag, mDsp, workTypeDesc, pivaCatDesc)
                 _ $lb(barCode, priDesc, psDesc, passResultDesc)
        s ^CacheTemp(repid,ind) = lbData    
        s ind = ind + 1 
        
    }
    q $$$OK
}

/// Description: 排序
ClassMethod SortOrdExeData(ByRef inData, Output outData)
{
    k outData
    s pog = 0
    for {
        s pog = $o(inData(pog))
        q:(pog = "")
        s pogData = $g(^PIVA(pog))
        s mDsp = $p(pogData, "^", 1)
        s batNo = $p(pogData, "^", 3)
        s dspData = $g(^DHCOEDISQTY(mDsp))
        s mOeori = $p(dspData, "^", 1)
        s doseDate=$p(dspData,"^",21)
        s wardLoc = $p(dspData, "^", 22)
        s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, ""))
        s adm = $p(dspData, "^", 26)
        s pat = $p(^PAADM(adm), "^", 1)                                         
        s patNo = $p(^PAPER(pat, "PAT", 1), "^", 1)
        s bedId = $p(^PAADM(adm),"^",73)
        s bedNo = "*"
        i bedId '= "" {
            s bedNo=$p($g(^PAWARD(+bedId, "BED", +$p(bedId, "||", 2))), "^", 1)
        }
        s index = doseDate _ "^" _ $j(ward, 5) _ "^" _ $j(bedNo,10) _ "^" _ patNo _ "^" _ $j(batNo, 3) _ $j(pog, 10)
        s outData(index) = pog
    }
}

ClassMethod SortWardData()
{
}

ClassMethod Collect(pJsonStr = "{}", Output collectData)
{
    q:pJsonStr="{}" ""
    s pJson = ##class(PHA.COM.Json).Parse(pJsonStr)
    
    q:'$IsObject(pJson) ""
    
    s pLoc = pJson.loc, pPrtStartDate = pJson.prtStartDate, pPrtEndDate = pJson.prtEndDate, pOrdStartDate = pJson.ordStartDate, pOrdEndDate = pJson.ordEndDate
    s pWardStr = pJson.wardStr, pLocGrp =  pJson.locGrp, pCat = pJson.cat, pPsNumber = pJson.psNumber, pPivaCat = pJson.pivaCat
    s pWorkType = pJson.workType, pInci = pJson.inci, pInstruc = pJson.instruc, pPackFlag = pJson.packFlag, pBatNoStr = pJson.batNoStr
    s pPriority = pJson.priority, pPogsNo=pJson.pogsNo, pPatNo = pJson.patNo
    
    s pWardList = $lfs(pWardStr), pBatNoList = $lfs(pBatNoStr)
    s pPrtStartDate = $$$zdh(pPrtStartDate), pPrtEndDate = $$$zdh(pPrtEndDate), pOrdStartDate = $$$zdh(pOrdStartDate), pOrdEndDate = $$$zdh(pOrdEndDate)
    q:(pLoc = "")||(pPrtStartDate = "")||(pPrtEndDate = "")||(pOrdStartDate = "")||(pOrdEndDate = "")||(pPsNumber = "")||(pBatNoStr = "") ""
    s ps10ID=$o(^PIVAS(0, "LOCTYPENUMBER", pLoc, "I", 10, "")) // todo 也许没用
    q:ps10ID="" ""
    
    s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", pLoc, "OeAudit", "AuditTimes")
    s needNurAudit=##class(web.DHCSTPIVAS.Settings).GetNeedNurseAudit(pLoc)

    d ..GetPSDict(pLoc, .psDictData)

    if pPogsNo '= "" {
        s pog = ""
        for {
            s pog = $o(^PIVA(0, "PogsNo", pPogsNo, pog))
            q:(pog="")
            d CalcuPogData
        }
    } else {
        for calcDate = pOrdStartDate : 1 : pOrdEndDate {
            s pog = ""
            for {
                s pog = $o(^PIVA(0, "LOCORDDATE", pLoc, calcDate, pog))
                q:(pog = "")
                d CalcuPogData
            }   
        }

    }
    q ""
CalcuPogData
    s pogData = $g(^PIVA(pog))
    s psID = $p(pogData, "^", 6)
    q:(psID = "")
    s psNumber = $p(^PIVAS(psID) ,"^", 1)
    s mDsp = $p(pogData, "^", 1)
    q:(needNurAudit = "Y")&&(..NurAuditFlagByMDsp(mDsp) '= "Y")
    s packFlag=..DspPackFlag(mDsp)
    s psDictType = $s(packFlag = "P" : "PACKDICT" , 1 : "DICT")
    s nextPsNumber = $o(psDictData(psDictType, psNumber))
    q:(nextPsNumber = "")
    s nextPsID = $g(psDictData(psDictType, nextPsNumber))
    q:(pPsNumber '= nextPsNumber)
    q:(pPackFlag '= "")&&(..CheckDspPack(mDsp, pPackFlag) '= "Y")
    s dspData = $g(^DHCOEDISQTY(mDsp))
    s mOeori = $p(dspData, "^", 1)
    s mOeore = $p(dspData, "^", 3)
    s mOrd = +mOeori
    s adm = $p(^OEORD(mOrd), "^", 1)
    s admData = $g(^PAADM(adm))
    q:(admData = "")
    q:$p(admData, "^", 2)'="I"
    s patId = $p(admData, "^", 1)
    s patNo = $p(^PAPER(patId, "PAT", 1), "^", 1)
    q:(pPatNo '= "")&&(pPatNo '= patNo)
    s wardLoc = $p(dspData, "^", 22)
    s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, ""))
    q:(ward = "")
    q:(pWardList '= "")&&($lf(pWardList, ward) = 0)
    q:(pLocGrp '= "")&&(..CheckLocGrp(pLocGrp, ward) = 0)
    s batNo=$p(pogData, "^", 3)
    q:($lf(pBatNoList, batNo) = 0)
    
    /* 限制条件 */
    q:(+##class(web.DHCSTPIVAS.Common).GetNeedStopState(pog, pPsNumber) < 0)
    s oper = $p(pogData, "^", 8)
    q:(oper = "R")
    s pcp = $p(pogData, "^", 18)
    q:(pcp '= "")
    s doseDate = $p(dspData, "^", 21)
    s passCode=$p(..GetOrdPassState(mOeori, doseDate, auditTimes, pLoc), "^", 1)
    q:passCode'="SHTG" "-1^配伍审核未通过"
    s prtSub = $o(^PIVA(0, "PS", ps10ID, pog, ""))
    q:(prtSub = "")
    s prtDate = $p(^PIVA(pog, "S", prtSub), "^", 4)
    q:(prtDate < pPrtStartDate)||(prtDate > pPrtEndDate)
    q:(pPriority '= "")&&(pPriority '= $p(..OeoriPriority(mOeori), "^", 1))
    q:(pPivaCat '= "")&&(pPivaCat '= $p(..GetOrdPivaCat(mOeori), "^", 1))
    q:(pWorkType '= "")&&(pWorkType '= $p(pogData, "^", 24))
    q:(pInci '= "")&&(..CheckOeoriIncExist(mOeori,pInci) '= 1)
    s collectData(pog) = ""
    q
}

/// Description: 初始化病区批次表格抬头
/// Debug:       w ##class(web.DHCSTPIVAS.ExecuteWeb).GetWardBatColumns(248)
ClassMethod GetWardBatColumns(loc)
{
    s retArr = []
    d retArr.%Push({
        "field" : "wardId",
        "title" : "wardId",
        "width" : "250",
        "hidden": "true"        
    })

    d retArr.%Push({
        "field" : "wardDesc",
        "title" : "病区",
        "width" : 150       
    })
    
    d retArr.%Push({
        "field" : "batNoSum",
        "title" : "合计",
        "width" : 50
    })

    s batNoStr = ..PivasLocBatList(loc)

    s len = $l(batNoStr, "^")
    f i = 1 : 1 : len {
        s batNoData = $p(batNoStr, "^", i)
        continue:(batNoData = "")
        s batNoId = $p(batNoData, ",", 1)
        s batNo = $p(batNoData, ",", 2)
        d retArr.%Push({
            "field" : (batNo),
            "title" : (batNo),
            "width" : 50        
        })  
    }
    q retArr.%ToJSON()
}

/// w ##class(web.DHCSTPIVAS.Execute).GetWardData("")
ClassMethod GetWardData(pJsonStr = "{}")
{
    s pJson = ##class(web.DHCSTPIVAS.Util).DataToJson(pJsonStr)
    q:'$IsObject(pJson) $$$OK
    
    s pLoc = pJson.loc
    d ..Collect(pJsonStr, .collectData)
    s batNoStr = ..PivasLocBatList(pLoc)
    /* 汇总病区数据 */
    k calcWardData,calcWardBatData, calcTotalData, calcWardPogData
    s pog = 0
    for {
        s pog = $o(collectData(pog))
        i pog = "" q
        s pogData = $g(^PIVA(pog))
        s mDsp = $p(pogData, "^", 1)
        s batNo = $p(pogData, "^", 3)
        s dspData = $g(^DHCOEDISQTY(mDsp))
        s wardLoc = $p(dspData, "^", 22)    
        s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, 0))  
        q:(ward = "")
        
        s calcWardData(ward) = $g(calcWardData(ward)) + 1
        s calcWardData(ward, batNo) = $g(calcWardData(ward, batNo)) + 1
        
        s calcWardData("total") = $g(calcWardData("total")) + 1
        s calcWardData("total", batNo) = $g(calcWardData("total", batNo)) + 1

        s calcWardPogData(ward, pog) = ""
    }
    k calcWardSortData
    s ward = ""
    for {
        s ward = $o(calcWardData(ward))
        q:(ward = "")
        continue:(ward = "total")
        s wardCnt = $g(calcWardData(ward))
        s calcWardSortData(+wardCnt, ward) = ""
    }
    s retJson = {
        "rows":[],
        "total":0,
        "footer":[]
    }
    s totalCnt = 0
    s rowsArr= []
    s wardIndex = ""
    for {
        s wardIndex = $o(calcWardSortData(wardIndex))
        q:(wardIndex = "")
        s ward = ""
        for {
            s ward = $o(calcWardSortData(wardIndex,ward))
            q:(ward = "")
            s wardCnt = calcWardData(ward)
            s totalCnt = totalCnt + wardCnt
            s wardDesc = ##class(PHA.PIVAS.Data.Base).WardDesc(ward)
            s rowData = {}
            d GetWardRow
            d rowsArr.%Push(rowData)
        }
    }
    s retJson.rows = rowsArr
    
    /* footer 合计 */
    s footerArr = []
    s rowData = {}
    s ward = "total"
    s wardDesc = ##class(websys.Translation).Get("配液中心-字典","合计")
    s wardCnt = totalCnt
    d GetWardRow
    d footerArr.%Push(rowData)  
    s retJson.footer = footerArr
    w retJson.%ToJSON()
    q ""
GetWardRow
    s rowData.ward = ward
    s rowData.wardDesc = wardDesc
    s rowData.batNoSum = +$g(wardCnt)
    s len = $l(batNoStr, "^")
    f i = 1 : 1 : len {
        s batNoData = $p(batNoStr, "^", i)
        q:(batNoData = "")
        s batNo = $p(batNoData, ",", 2)
        s wardBatCnt = +$g(calcWardData(ward, batNo))
        d rowData.%Set(batNo,wardBatCnt)
    }
    s pogArr = []
    if ward '= "total" { 
        s pog = ""
        for {
            s pog = $o(calcWardPogData(ward, pog))
            q:(pog = "")
            d pogArr.%Push(pog)
        }
    }
    s rowData.pogData = pogArr
    q
}

ClassMethod SaveData(pogJsonStr = "[]", psNumber, user, grpWay = "")
{
    s $zt = "ErrorSaveData"
    s pogJson = ##class(web.DHCSTPIVAS.Util).DataToJson(pogJsonStr)
    q:pogJson="[]" "-1^没有可保存的数据"
    for {
        s pog = pogJson.%Pop()
        q:(pog = "")
        s index = "1"
        if grpWay '= "" {
            s pogData = $g(^PIVA(pog))
            s mDsp = $p(pogData, "^", 1)
            s wardLoc = $p(^DHCOEDISQTY(mDsp), "^", 22)
            s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, ""))
            s batNo = $p(pogData, "^", 3)
            if grpWay = 1 {
                s index = ward
            } elseif (grpWay = 2) {
                s index = ward _ "||" _ batNo
            } else {
                s index = 1
            }
        }
        s calcData(index, pog) = ""
    }   
    q:'$d(calcData) "-1^没有可保存的数据"
    q ..Save(.calcData,psNumber,user)
ErrorSaveData
    q "-2^" _ $replace($ze, "^", "-")
}

/// Description: 按单号拆分病区保存,目前仅用于扫描执行直接触发打印交接单使用
/// Input:       grpWay(拆分方式:1<按病区>,2<按病区批次>)
ClassMethod SaveDataByPOGSNo(pogsNo, userId, psNumber, grpWay = "1")
{
    k calcData
    s fPOGId=$o(^PIVA(0,"PogsNo",pogsNo,""))
    q:fPOGId="" "-1^没有需要保存的数据"
    s pog=""
    for {
        s pog = $o(^PIVA(0, "PogsNo", pogsNo, pog))
        q:(pog = "")
        s pogData  = $g(^PIVA(pog))
        s mDsp = $p(pogData, "^", 1)
        s wardLoc = $p(^DHCOEDISQTY(mDsp), "^", 22)
        s ward = $o(^PAWARD(0, "WARD_LocationDR",wardLoc, ""))
        q:(ward = "")
        s batNo = $p(pogData, "^", 3)
        s index = 1
        if (grpWay = 1){
            s index = ward
        } else {
            s index = index _ "||" _ batNo
        }
        s calcData(index, pog) = "" 
    }
    q:'$d(calcData) "-1^没有可保存的数据"
    q ..Save(.calcData, psNumber, userId)
}

/// Description: 状态执行的统一入口,得传数组进来
/// Input:       ExecuteDATA(引用)
///              ExecuteDATA(病区Id,pogId)
ClassMethod Save(ByRef executeData, psNumber, userId)
{
    q:'$d(executeData) "-1^没有需要保存的数据"
    s fIndex = $o(executeData(""))
    s fPog = $o(executeData(fIndex, ""))
    s pivaLocId = $p($g(^PIVA(fPog)), "^", 7)
    s pogsNoStr=""
    s succCnt=0
    s errCode=""
    s grpIndex=""
    for {
        s grpIndex = $o(executeData(grpIndex))
        q:grpIndex=""
        s pogsNo = ##class(web.DHCSTPIVAS.Common).GetAppNo(psNumber,pivaLocId)
        if ($p(pogsNo, "^", 1) = "-1") {
            s errCode = pogsNo
            continue
        }
        s grpSuccCnt=0
        s pog = ""
        for {
            s pog = $o(executeData(grpIndex, pog))
            q:(pog="")
            s ret = ##class(web.DHCSTPIVAS.DataHandler).Execute(pog, psNumber, userId,pivaLocId,pogsNo)
            if $p(ret,"^",1) '= 0  {
                s errCode = pog_":"_$p(ret,"^",2)
                continue
            }
            s succCnt = succCnt + 1
            s grpSuccCnt = grpSuccCnt + 1
            s pogData  = $g(^PIVA(pog))
            d ##class(web.DHCSTPIVAS.DataCenter).UpdateSystemStatus(psNumber, $p(pogData, "^", 1), userId)
        }
        if grpSuccCnt > 0 {
            s pogsNoStr = $s(pogsNoStr  ="" : pogsNo, 1 : pogsNoStr _ "!!" _ pogsNo)
        }
    }
    q:succCnt=0 "-2^保存失败</br>"_errCode
    q 0_"^"_pogsNoStr
}

/// Description: 生成交接单
/// Input:       type - 1 : 按病区
///              type - 2 : 按病区+批次
///              type - 0 : 不判断病区与批次
/// Return:      产生的新单号的串 - 单号1^单号2^单号3
/// Debug:       w ##class(web.DHCSTPIVAS.Execute).ReGenePogsNo("[""SCANP20200728010""]",2)
ClassMethod ReGenePogsNo(pJsonStr = "[]", geneWay = "")
{
    s pJson = ##class(web.DHCSTPIVAS.Util).DataToJson(pJsonStr)
    q:'$IsObject(pJson) ""
    q:pJson="[]" "-1^没有可以生成的数据"
    for {
        s pogsNo = pJson.%Pop()
        q:(pogsNo = "")
        s pog = ""
        for {
            s pog = $o(^PIVA(0, "PogsNo", pogsNo, pog))
            q:(pog = "")
            s pogData  = $g(^PIVA(pog))
            s mDsp = $p(pogData, "^", 1)
            s wardLoc = $p(^DHCOEDISQTY(mDsp), "^", 22)
            s ward = $o(^PAWARD(0, "WARD_LocationDR",wardLoc, ""))
            continue:(ward = "")
            s batNo = $p(pogData, "^", 3)
            if geneWay = 1 {
                s index = ward
            } elseif (geneWay = 2) {
                s index = ward _ "||" _ batNo
            } else {
                s index = 1
            }
            s itm = $o(^PIVA(0, "PogsNo", pogsNo, pog, 0))
            s calcData(index, pog, itm) = ""
        }
    }   
    q:'$d(calcData) "-1^没有可以生成的数据"
    s fIndex = $o(calcData(""))
    s fPog = $o(calcData(fIndex,""))
    s loc = $p($g(^PIVA(fPog)), "^", 7)
    s ps = $p($g(^PIVA(fPog)), "^", 6)
    s psNumber = $p(^PIVAS(ps), "^", 1)
    s errCode = ""
    ts
    s index = ""
    for {
        q:(errCode '= "")
        s index = $o(calcData(index))
        q:(index = "")
        s pogsNo = ##class(web.DHCSTPIVAS.Common).GetAppNo(psNumber,loc)
        if ($p(pogsNo, "^", 1) = "-1") {
            s errCode = pogsNo
            q
        }
        s pog = ""
        for {
            q:(errCode '= "")
            s pog = $o(calcData(index, pog))
            q:(pog = "")
            s itm = $o(calcData(index, pog, 0))
            s pogsId = pog _ "||" _ itm
            s ret = ##class(web.DHCSTPIVAS.DataHandler).UpdateOrdGrpState(pogsId, pogsNo)
            if $p(ret, "^", 1) '= 0  {
                s errCode = ret
                q
            }
            s retPogsNoData(pogsNo) = ""

        }
    }
    if (errCode '= ""){
        tro
        q "-1^生成失败," _ $p(errCode, "^", 2)
    }       
    tc
    q:'$d(retPogsNoData) "-1^没有可以生成的数据"
    s retStr = ""
    s pogsNo = ""
    for {
        s pogsNo = $o(retPogsNoData(pogsNo))
        q:(pogsNo = "")
        s retStr = $s(retStr = "" : pogsNo , 1 : retStr _ "!!" _ pogsNo)
    }
    q "0^" _ retStr
}

/// Description: 按条件, 生成指定预计流程的所有数据
ClassMethod SaveByCondition(pJsonStr = "{}")
{
    q:pJsonStr="{}" "-1^没有指定条件"
    s pJson = ##class(PHA.COM.Json).Parse(pJsonStr)
    q:'$IsObject(pJson) $$$OK
    s pLoc = pJson.loc
    s pStartDate = pJson.startDate // 用药日期, 今天不会送明天的, 即使需要日期加1即可
    s pEndDate = pJson.endDate
    s pPSNumber = pJson.psNumber
    s pUser = pJson.user
    s pStartDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(pStartDate)
    s pEndDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(pEndDate)

    s pogStr = ""
    
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
            s packFlag = ##class(web.DHCSTPIVAS.Common).DspPackFlag(mDsp)
            s nextExeStr = ##class(web.DHCSTPIVAS.Common).GetNextPsState(psId, pLoc, "I", packFlag)
            s nextPsnumber = $p(nextExeStr,"^",2)
            continue:(pPSNumber '= nextPsnumber)
            continue:+##class(web.DHCSTPIVAS.Scan).FilterCondition(pog, pArr)<0
            if (pogStr = ""){
                s pogStr = pog
            }else{
                s pogStr = pogStr _ "^" _pog
            }
        }
    }
    q ##class(web.DHCSTPIVAS.Execute).SaveDataByPog(pogStr, pUser, pPSNumber, "1")
}

}
