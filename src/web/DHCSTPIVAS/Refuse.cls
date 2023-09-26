/// Description: 配液拒绝
Class web.DHCSTPIVAS.Refuse Extends web.DHCSTPIVAS.Common
{

/// 该流程后不可拒绝
Parameter CANTREFNUMBER = 70;

ClassMethod Collect(pJsonStr = "{}", Output collectData)
{
    q:pJsonStr="{}" ""
    s pJson = ##class(PHA.COM.Json).Parse(pJsonStr)
    q:'$IsObject(pJson) ""
    
    s pLoc = pJson.loc, pLocGrp = pJson.locGrp
    s pOrdStartDate = pJson.ordStartDate, pOrdEndDate = pJson.ordEndDate, pOrdStartTime = pJson.ordStartTime, pOrdEndTime = pJson.ortEndTime
    s pPrtStartDate = pJson.prtStartDate, pPrtEndDate = pJson.prtEndDate, pPrtStartTime = pJson.prtStartTime, pPrtEndTime = pJson.prtEndTime
    s pPatNo = pJson.patNo
    s pBarCode= pJson.barCode, pPogsNo = pJson.pogsNo
    s pPriority = pJson.priority
    s pPassResult = pJson.passResult
    s pOeoreStat = pJson.oeoreStat
    s pWorkType = pJson.workType
    s pInci = pJson.inci
    s pBatNoList = $lfs(pJson.batNoStr), pWardList = $lfs(pJson.wardStr) 
    s pRefuse = pJson.refuseStat
    s pPivaCat = pJson.pivaCat
    s pPack  = pJson.packFlag
    s pOrdStartDate = $$$zdh(pOrdStartDate), pOrdEndDate = $$$zdh(pOrdEndDate), pOrdStartTime= $$$zth(pOrdStartTime), pOrdEndTime = $$$zth(pOrdEndTime)
    s pPrtStartDate = $$$zdh(pPrtStartDate), pPrtEndDate = $$$zdh(pPrtEndDate), pPrtStartTime= $$$zth(pPrtStartTime), pPrtEndTime = $$$zth(pPrtEndTime)
    
    s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", pLoc, "OeAudit", "AuditTimes")
    s ps10 = ..LocPsIdByPsNumber(pLoc, 10)
    
    /* 走不同索引 */
    k calcData
    if pBarCode '= "" {
        s mOeore = ..BarCodeToOeore(pBarCode)
        q:(mOeore = "")
        s mDsp = $o(^DHCOEDISQTY(0, "OEORE", mOeore, 0))
        q:(mDsp = "")
        s pog = $o(^PIVA(0, "DSP", mDsp, 0))
        q:(pog = "")
        s calcData(pog) = ""
    } elseif pPogsNo '= "" {
        s pog = 0
        for {
            s pog = $o(^PIVA(0, "PogsNo", pPogsNo, pog)) 
            q:(pog = "")
            s calcData(pog) = ""
        }
    } else {
        for calcDate = pOrdStartDate : 1 : pOrdEndDate {
            s pog = 0
            for {
                s pog = $o(^PIVA(0, "LOCORDDATE", pLoc, calcDate, pog))
                q:(pog = "")
                s calcData(pog) = ""
            }
        }
    }
    
    /* 筛选 */
    s pog = ""
    for {
        s pog = $o(calcData(pog))
        q:(pog = "")
        k calcData(pog)
        s pogs10 = $o(^PIVA(0, "PS", ps10, pog, 0))
        //continue:(pogs10 = "")
        s pogData = $g(^PIVA(pog))
        s mDsp = $p(pogData, "^", 1)
        s batNo = $p(pogData, "^", 3)
        s ps = $p(pogData, "^", 6)
        s specStat = $p(pogData, "^", 8)        // 特殊状态
        s pNo = $p(pogData, "^", 11)
        s workType = $p(pogData, "^", 24)   
        s psNumber = $P(^PIVAS(ps), "^", 1)
        s mDspData = $g(^DHCOEDISQTY(mDsp))
        s mOeori = $p(mDspData, "^", 1)
        s mOeore = $p(mDspData, "^", 3)

        s doseDate = $p(mDspData, "^", 21)
        s wardLoc = $p(mDspData, "^", 22)
        s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, 0))
        s packFlag = ..DspPackFlag(mDsp)
        s mOrd = +mOeori
        s mOrdItm = +$p(mOeori, "||", 2)
        s adm = $P(^OEORD(mOrd), "^", 1)
        s admType = $p(^PAADM(adm), "^", 2)
        s ioType = $s(admType = "I" : "I" , 1 : "O")
        continue:(ioType '= "I")
        s pat = $p(^PAADM(adm), "^", 1)
        s patNo = $p(^PAPER(pat, "PAT", 1), "^", 1)
        continue:(psNumber > ..#CANTREFNUMBER)
        continue:(..CheckDspPack(mDsp, pPack) '= "Y")
        continue:($lf(pBatNoList, batNo) = 0)
        continue:(pPatNo '= "")&(pPatNo '= patNo)
        continue:(pInci '= "")&&(..IsInciInPog(pog, pInci) '= "Y")
        continue:(pPivaCat '= "")&&(pPivaCat '= +..GetOrdPivaCat(mOeori))
        continue:(pPriority '= "")&&(pPriority '= +..OrdPriority(mOeori))
        continue:(pPassResult '= "")&&(pPassResult '= $p(..GetOrdPassState(mOeori, doseDate, auditTimes), "^", 1))
        continue:(pOeoreStat = 1)&&(..CheckOeoreStat(mOeore) '= 1)
        continue:(pOeoreStat = 2)&&(..CheckOeoreStat(mOeore) = 1)
        continue:(pWorkType '= "")&&(pWorkType '= workType)

        continue:(pRefuse = "Y")&&(specStat '= "R")
        continue:(pRefuse = "N")&&(specStat = "R")

        continue:(pLocGrp '= "")&&(..CheckLocGrp(pLocGrp,wardLoc) = 0)
        continue:(pWardList '= "")&&($lf(pWardList, ward) = 0)
        s pogs10Data = $g(^PIVA(pog, "S", +pogs10))
        s prtDate = $p(pogs10Data, "^", 4)
        s prtTime = $p(pogs10Data, "^", 5)
        continue:(pPrtStartDate '= "")&&(prtDate < pPrtStartDate)
        continue:(pPrtEndDate '= "")&&(prtDate > pPrtEndDate)
        continue:(prtDate = pPrtStartDate)&&(pPrtStartTime '= "")&&(prtTime < pPrtStartTime)
        continue:(prtDate = pPrtEndDate)&&(pPrtEndTime '= "")&&(prtTime < pPrtEndTime)
        
        s bedNo = $p(pogData, "^", 34)
        
        s sortIndex = "1"
        if pPogsNo '= "" {
            s sortIndex = pNo
        } else {
            s sortIndex = doseDate _ "||" _ $j(wardLoc, 5) _ "||" _ $j(bedNo, 5) _ "||" _ patNo _ "||" _ $j(batNo, 5)
        }
    
        s collectData(sortIndex, pog) = ""      
    
    }
}

Query OrdExeData(pJsonStr = "{}") As websys.Query(ROWSPEC = "pog, mDsp, patNo, patName, freqDesc, instrucDesc, docName, doseDateTime, passResultDesc, batNo, packFlag, drugsArr, priDesc, bedNo, wardDesc, nurSeeDesc, refUserName, refDate, refTime, refReasonDesc, barCode, sameFlag, altFlag, xDateTime, oeoriStatDesc, oeoreStatDesc, phaOrdDateTime, phaOrdUser, psName, psNumber")
{
}

ClassMethod OrdExeDataExecute(ByRef qHandle As %Binary, pJsonStr = "{}") As %Status
{
    s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.OeAudit","OrderData")=pJsonStr
    s repid = $i(^CacheTemp)
    s qHandle = $lb(0, repid, 0)
    s ind = 1
    s pJson = ##class(PHA.COM.Json).Parse(pJsonStr)
    q:'$IsObject(pJson) $$$OK
    d ..Collect(pJsonStr, .collectData)
    s pLoc = pJson.loc
    s auditTimes = ##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", pLoc, "OeAudit", "AuditTimes")
    s lastPatNo = "", altCnt = 0
    s sortIndex = ""
    for {
        s sortIndex = $o(collectData(sortIndex))
        q:(sortIndex = "")
        s pog = ""
        for {
            s pog = $o(collectData(sortIndex, pog))
            q:(pog = "")
            s pogData = $g(^PIVA(pog))
            s mDsp = $p(pogData, "^", 1)
            s ps = $p(pogData, "^", 6)
            s mDspData = $g(^DHCOEDISQTY(mDsp))
            s mOeore = $p(mDspData, "^", 3)
            s mOeori = $p(mDspData, "^", 1)
            s mOeore = $p(mDspData, "^", 3)
            s doseTime=$p(mDspData,"^",20)
            s doseDate=$p(mDspData,"^",21)
            s wardLoc = $p(mDspData, "^", 22)
            s wardDesc= ##class(PHA.COM.Data.Base).LocDesc(wardLoc)
            s adm = $p(mDspData, "^", 26)
            /* 病人信息 */
            s admData = $g(^PAADM(adm))
            s pat = $p(admData, "^", 1)
            s patNo = $p(^PAPER(pat, "PAT", 1), "^", 1)
            s bedNo = $p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(adm), "^", 2)
            s patName = $p(^PAPER(pat, "ALL"), "^", 1)
            s patSex = $p(^PAPER(pat, "ALL"), "^", 7)
            s patSex = ##class(PHA.COM.Data.Base).SexDesc(patSex)
            s patAge = ##class(PHA.FACE.IN.Com).GetAge(pat, adm)    
                
            /* 用药信息 */   
            s packFlag = ..DspPackFlag(mDsp)
            s doseDateTime = ..DateShortFormat(doseDate)_" "_..TimeShortFormat(doseTime)        
            s freqDesc=$p(..OeoriFreq(mOeori), "^", 2)
            s instrucDesc=$p(..OeoriInstruc(mOeori), "^", 2)
            s docName=$p(..OeoriDoctor(mOeori), "^", 2)
            s pivaCatDesc = $p(..GetOrdPivaCat(mOeori), "^", 2)
            s (phaOrdDate, phaOrdTime, phaOrdUser, passResultDesc) = ""
            s phaOrdResultStr=..GetOrdPassState(mOeori, doseDate, auditTimes, pLoc)
            s phaOrd = $p(phaOrdResultStr, "^", 3)
            if (phaOrd '= ""){
                s phaOrdData = $g(^DHCPHORDM(phaOrd))
                s phaOrdDate = $p(phaOrdData,"^",3)
                s phaOrdTime = $p(phaOrdData, "^",4)
                s phaOrdDateTime =  $$$zd(phaOrdDate) _ " " _ $$$zt(phaOrdTime)
                s phaOrdUser = $p($g(^DHCPHORDM(phaOrd)), "^", 1)
                s phaOrdUser = $p($g(^SSU("SSUSR", +phaOrdUser)), "^", 2)   
                s passResultDesc = $p(phaOrdResultStr, "^", 2)
            }
            s batNo = $p(pogData, "^", 3)
            s psStr = ..CurPsState(mDsp)
            s psNumber = $p(psStr, "^", 1)
            s psDesc = $p(psStr, "^", 2)
            s priDesc=$p(..OeoriPriority(mOeori), "^", 3)
            s drugsArr = ..GetPogDrugsArr(pog)
            s nurSeeDesc = $p(..GetNurseSeeType(mOeori, pLoc), "^", 3)
            s oper=$p(pogData, "^", 8)
            if (oper = "R") {
                s refReasonDesc = ..PogRefuseReason(pog)
                s refUser = $p(pogData, "^", 12)
                s refUserName  =$p($g(^SSU("SSUSR", +refUser)), "^", 2)
                s refDate = $p(pogData, "^", 13)
                s refTime = $p(pogData, "^", 14)
                s refDate = $$$zd(refDate)
                s refTime = $$$zt(refTime)          
            } else {
                s (refReasonDesc, refUserName, refDate, refTime)=""
            }

            s barCode = ..OeoreToBarCode(mOeore)
            s oeoreXData = $g(^OEORD(+mOeore, "I", +$p(mOeore, "||", 2), "X", +$p(mOeore, "||", 3)))
            s xDate = $p(oeoreXData, "^", 12)
            s xTime = $p(oeoreXData, "^", 14)
            s xDateTime = $$$zd(xDate) _ " " _ $$$zt(xTime)
            s oeoriStatDesc = $p(..OeoriStat(mOeori), "^", 2)
            s oeoreStatDesc = $p(..OeoreStat(mOeore), "^", 2)
            s psName = ##class(PHA.COM.Data.Base).PIVASStateName(ps)
            /* 换行相关 */
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
            
            s ^CacheTemp(repid,ind) = $lb(pog, mDsp, patNo, patName, freqDesc)    
                                    _ $lb(instrucDesc, docName, doseDateTime, passResultDesc, batNo)
                                    _ $lb(packFlag, drugsArr, priDesc, bedNo, wardDesc)
                                    _ $lb(nurSeeDesc, refUserName, refDate, refTime, refReasonDesc)
                                    _ $lb(barCode, sameFlag, altFlag, xDateTime, oeoriStatDesc)
                                    _ $lb(oeoreStatDesc, phaOrdDateTime, phaOrdUser, psName, psNumber)
            s ind = ind + 1
            
        }
    }
    q $$$OK
}

/// w ##class(web.DHCSTPIVAS.Refuse).SaveData("[""98""]","711","81","R")
ClassMethod SaveData(pogJsonStr = "[]", user, reason, exeType)
{
    q:(user = "") "-1^用户为空"
    q:(exeType = "R")&&(reason = "") "-1^配液拒绝原因为空"
    s pogJson = ##class(web.DHCSTPIVAS.Util).DataToJson(pogJsonStr)
    q:(pogJson = "[]") "-1^没有需要处理的数据"
    s pogLen = pogJson.%Size()
    s errCode = "", succCnt = 0
    for {
        s pog = pogJson.%Pop()
        q:(pog = "")
        s pogData = $g(^PIVA(pog))
        s mDsp = $p(pogData, "^", 1)
        s ps = $p(pogData, "^", 6)
        continue:(ps = "")
        s psNumber = +$p(^PIVAS(ps),"^",1)
        if (exeType = "R")&&(psNumber >= ..#CANTREFNUMBER)  {
            s errCode = "已复核"
            continue
        }

        s lockRet = ..Lock("DHCOEDispensing", mDsp) 
        if (lockRet '= 0) {
            s errCode = pog _ ":加锁失败" 
            d ..UnLock("DHCOEDispensing", mDsp)
            continue
        }
        
        ts
        s ret=..UpdatePog(pog, user, exeType, reason)
        if ($p(ret, "^", 1) '= 0) {
            s errCode = pog _ ":处理拒绝数据失败" 
            d ..UnLock("DHCOEDispensing", mDsp)
            tro
            continue
            
        }
        tc
        d ..UnLock("DHCOEDispensing", mDsp)
        s succCnt = succCnt + 1     
    }
    q:(succCnt = pogLen) "0^保存成功"
    q:(succCnt > 0) "-1^部分保存失败</br>" _ errCode
    q "-2^"_errCode
}

ClassMethod UpdatePog(pogId, userId, oper, reasonId)
{
    s curDate=+$h,curTime=$p($h,",",2)
    &SQL(
        UPDATE
            PIVA_OrdGrp
        SET
            POG_Oper =:oper,
            POG_POR_Dr =:reasonId,
            POG_CUser_Dr =:userId,
            POG_CDate =:curDate,
            POG_CTime =:curTime
        WHERE
            POG_RowId =:pogId
    )
    q:SQLCODE'=0 "-2^更新失败" _ $g(%msg)
    q 0
}

/// Description: 配液拒绝, 主要针对未排批的数据, 也兼容已排批
/// Debug:       w ##class(web.DHCSTPIVAS.Refuse).MultiSaveData4Dsp("[{""mDsp"":""93602"",""batNo"":""1""},{""mDsp"":""93617"",""batNo"":""1""}]","711","85")
ClassMethod MultiSaveData4Dsp(dataArrStr = "[]", user, reason)
{
    #dim ret = $$$OK
    try {
        i (user = "") s ret = "-1^用户为空" q
        i (reason = "") s ret = "-1^配液拒绝原因为空" q
        s dataArr = ##class(web.DHCSTPIVAS.Util).DataToJson(dataArrStr)
        i (dataArr = "[]") s ret = "-1^没有需要处理的数据" q
        s size = dataArr.%Size()
        
        ts
        for i = 0 : 1 : (size - 1) {
            s rowData = dataArr.%Get(i)
            continue:(rowData = "")
            s mDsp = rowData.mDsp
            continue:(mDsp = "")
            s sRet = ..SaveData4Dsp(mDsp, rowData.batNo, user, reason)
            if (sRet '= $$$OK){
                s ret = sRet
                q
            }
        }
        if (+ret < 0){
            tro
        }else{
            tc
        }
        
    }catch ex {
        tro
        s ret = "-1^" _ $tr($ze, "^", "~")
    }
    q ret
}

/// Description: 拒绝一条记录
ClassMethod SaveData4Dsp(mDsp, batNo, user, reason)
{
    #dim ret as %String = "" 
    d ..Lock("DHCOEDispensing", mDsp)
    try{
        s pog = $o(^PIVA(0, "DSP", mDsp, 0))
        if (pog = ""){
            s mDspData = $g(^DHCOEDISQTY(mDsp))
            s seqNo = $p(mDspData, "^", 4)
            #; 处理批次记录 
            s insRet = ##class(web.DHCSTPIVAS.BatUpdate).SavePIVABatUp(mDsp, seqNo, batNo, user, "Y", "系统生成")
            if (+insRet '= 0) {
                s ret = insRet
                q
            }
            
            #; 处理配液表 
            s insRet = ##class(web.DHCSTPIVAS.BatUpdate).SavePIVAOrdGrp(mDsp, batNo, user)      
            if (+insRet '= 0) {
                s ret = insRet
                q
            } 
            s pog = $o(^PIVA(0, "DSP", mDsp, 0))
        }
        s insRet = ##class(web.DHCSTPIVAS.Refuse).SaveData([(pog)].%ToJSON(), user, reason, "R")
        if (+insRet '= 0){
            s ret = insRet
            q   
        }
        s ret = $$$OK
    } catch ex {
        s ret = "-1^" _ $tr($ze, "^", "~")
    } 
    d ..UnLock("DHCOEDispensing", mDsp)
    q ret
}

}
