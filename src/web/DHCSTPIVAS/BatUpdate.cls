/// Description: 配液排批
Class web.DHCSTPIVAS.BatUpdate Extends web.DHCSTPIVAS.Common
{

/// w ##class(web.DHCSTPIVAS.BatUpDateNew).Collect("{}",.collectData)
ClassMethod Collect(pJsonStr = "{}", Output collectData)
{
    q:pJsonStr="{}" ""
    s pJson = ##class(PHA.COM.Json).Parse(pJsonStr)
    q:'$IsObject(pJson) ""
    
    s pStartDate = pJson.startDate, pEndDate = pJson.endDate, pStartTime = pJson.startTime, pEndTime = pJson.endTime
    s pLoc = pJson.loc, pWardStr = pJson.wardStr, pLocGrp =  pJson.locGrp, pPivaCat = pJson.pivaCat
    s pWorkType = pJson.workType, pInci = pJson.inci
    s pBatNoStr = pJson.batNoStr, pAdm = pJson.adm, pPriority = pJson.priority, pPatNo = pJson.patNo
    s pUpdateStat = pJson.updateStat, pPrtStat = pJson.prtStat, pPackFlag = pJson.packFlag
    
    s pStartDate = $$$zdh(pStartDate), pEndDate = $$$zdh(pEndDate)
    s pStartTime = $$$zth(pStartTime), pEndTime = $$$zth(pEndTime)
    s pBatNoList = $lfs(pBatNoStr)
    s pWardList = $lfs(pWardStr)
    q:(pLoc = "") ""
    s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", pLoc, "OeAudit", "AuditTimes")
    s needNurAudit=##class(web.DHCSTPIVAS.Settings).GetNeedNurseAudit(pLoc)
    s referBefore=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", pLoc, "BatUpdate", "ReferBeforeBat")
    k calcMoveData, calcValidData, calcTmpData
    for calcDate = pStartDate : 1 : pEndDate {
        s status = ""
        for {
            s status = $o(^DHCOEDISQTY(0, "REC", pLoc, calcDate, status))
            q:(status = "")
            continue:(status '= "TC")&&(status '= "C")
            s wardLoc = 0
            for {
                s wardLoc = $o(^DHCOEDISQTY(0, "REC", pLoc, calcDate, status, wardLoc))
                q:(wardLoc = "")
                continue:(pLocGrp '= "")&&(..IsInLocGrp(pLocGrp, wardLoc) '= "Y")
                s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, ""))
                continue:(pWardList '= "")&&($lf(pWardList, ward) = 0)
                s dsp = 0
                for {
                    s dsp = $o(^DHCOEDISQTY(0, "REC", pLoc, calcDate, status, wardLoc, 0, dsp))
                    q:(dsp = "")
                    s dspData = $g(^DHCOEDISQTY(dsp))
                    s oeori = $p(dspData, "^", 1), ord = +oeori, ordItm = +$p(oeori, "||", 2) 
                    s oeore = $p(dspData, "^", 3)
                    s adm = $p(dspData, "^", 26)
                    s admType = $p($g(^PAADM(adm)), "^", 2)
                    continue:(admType '= "I") 
                    continue:(pAdm '= "")&&(pAdm '= adm) 
                    if (pPatNo '= "") {
                        s pat = $p(^PAADM(adm), "^", 1)
                        s patNo = $p(^PAPER(pat, "PAT", 1), "^", 1)
                        continue:(pPatNo '= "")&&(pPatNo '= patNo)
                    }
                    s mDsp = ..GetMainDspId(dsp)
                    s mDspData = $g(^DHCOEDISQTY(mDsp))
                    s mOeore = $p(mDspData, "^", 3)
                    s mOeori = $p(mOeore, "||", 1, 2)
                    continue:$d(calcValidData("mDsp", mDsp))
                    continue:$d(calcValidData("mOeori", mOeori))
                    continue:$d(calcMoveData(adm, mDsp))
                    
                    /* 执行记录停止, 不用考虑退药, 退药必然已停止 */
                    if (..CheckOeoreStat(mOeore) '= 1) {
                        s calcValidData("mDsp", mDsp) = ""
                        continue
                    }
                    /* 预停 */
                    if (..IsOrderPreStop(mOeore) = $$$YES) {
                        s calcValidData("mDsp", mDsp) = ""
                        continue
                    }
                    /* 医嘱处理 */
                    if ($p(..GetNurseSeeType(mOeori,pLoc), "^", 1) = "N"){
                        s calcValidData("mDsp", mDsp) = ""
                        continue                
                    }
                    /* 领药审核 */
                    s nurAuditFlag = ..NurAuditFlagByMDsp(mDsp)
                    if (needNurAudit = "Y")&&(nurAuditFlag '= "Y") {
                        s calcValidData("mDsp", mDsp) = ""
                        continue                
                    }
                    /* 配伍审核 */
                    s passStat=$p(..GetOrdPassState(mOeori, calcDate, auditTimes, pLoc), "^", 1)
                    continue:(passStat '= "SHTG")
                    
                    /* 全自备 */
                    if (..OrdPriority(mOeori) [ "OM") {
                        s calcValidData("mOeori", mOeori) = ""
                        continue                        
                    }

                    /* 出院结算 */
                    s arcCatStr = ..GetArcItmCatByOeori(mOeori)
                    s arcCat = $p(arcCatStr, "^", 1)
                    s arcCatType=$p(arcCatStr, "^", 4)
                    continue:(arcCatType '= "R")
                    s collAllow = ##Class(web.DHCSTCOMMONSRV).IfCollectDrugAllowed(adm, arcCat)
                    if (collAllow '= 1) {
                        s calcValidData("mOeori", mOeori) = ""
                        continue                        
                    }  
                    #; 配液拒绝
                    if (..IsPivasRefused(mDsp) = $$$YES){
                        s calcValidData("mDsp", mDsp) = ""
                        continue   
                    } 
                    s doseDate = $p(dspData, "^", 21)       
                    s calcMoveData(adm, doseDate, mDsp) = ""
                    
                }               
            }
        }
    }

    /* 排批规则计算 */
    k calcData
    s adm = ""
    for {
        s adm = $o(calcMoveData(adm))
        q:(adm = "")
        s doseDate = ""
        for {
            s doseDate = $o(calcMoveData(adm, doseDate))
            q:(doseDate = "")
            s batchObj = ##class(web.DHCSTPIVAS.Data.Batch).%New()
            s batchObj.loc = pLoc
            merge batchObj.mDspDimData = calcMoveData(adm, doseDate)
            d batchObj.Calc(.finalBatchData)
            s mDsp = ""
            for {
                s mDsp = $o(calcMoveData(adm, doseDate, mDsp))
                q:(mDsp = "")
                s calcData(mDsp) = $g(finalBatchData(mDsp)) 
            }
        }
    }
    k calcMoveData
    
    s autoPackList = ##class(web.DHCSTPIVAS.BatUpdate).GetAutoPackBatNoList(pLoc)
    /* 过滤条件 */
    s mDsp = ""
    for {
        s mDsp = $o(calcData(mDsp))
        q:(mDsp = "")
        s data = calcData(mDsp)
        s batNo = $lg(data, 1)
        s mDspData = $g(^DHCOEDISQTY(mDsp))
        s mOeore = $p(mDspData, "^", 3)
        s mOeori = $p(mOeore, "||", 1, 2)   
        s pog = $o(^PIVA(0, "DSP", mDsp, ""))
        s pNo = $p($g(^PIVA(+pog)), "^", 11)
        #; 此处更新打包状态, 非空代表人为处理过, 则不能再由系统处理
        s packFlag = $p(mDspData, "^", 28)
        if (packFlag = ""){
            if (($lf(autoPackList, batNo) > 0))||(..NeedPack(mOeore) = "Y"){
               d ##class(web.DHCSTPIVAS.DataHandler).UpdateOeDspToPack(mDsp, "P")
            }
        }
        continue:(pPivaCat '= "")&&(pPivaCat '= $p(..GetOrdPivaCat(mOeori), "^", 1))
        continue:(pWorkType '= "")&&(pWorkType '= +..OrdWorkType(mOeore))
        continue:(pPriority '= "")&&(pPriority '= +..OrdPriority(mOeori))
        continue:(pInci '= "")&&(..IsInciInOrder(mOeori, pInci) '= "Y") 
        continue:(pUpdateStat = "Y")&&(pog = "")
        continue:(pUpdateStat = "N")&&(pog '= "")
        continue:(pPrtStat = "Y")&&(pNo = "")
        continue:(pPrtStat = "N")&&(pNo '= "")  
        continue:($lf(pBatNoList, batNo) = 0)
        continue:(pPackFlag '= "")&&(..CheckDspPack(mDsp,pPackFlag) '= "Y") 
        s collectData(mDsp) = data
    }
    q
}

/// Description: 排批病区
/// Debug:       w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.BatUpDateNew","WardData","")
Query WardData(pJsonStr = "{}") As websys.Query(ROWSPEC = "ward, wardDesc, cnt")
{
}

ClassMethod WardDataExecute(ByRef qHandle As %Binary, pJsonStr = "{}") As %Status
{
    #; s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.BatUpDateNew","WardData")=pJsonStr
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    
    d ..Collect(pJsonStr,.collectData)
    k calcData, calcCntData
    s mDsp = 0
    for {
        s mDsp = $o(collectData(mDsp))
        q:(mDsp = "")
        s mDspData = $g(^DHCOEDISQTY(mDsp))
        s wardLoc = $p(mDspData, "^", 22)   
        s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, 0))  
        continue:(ward = "")
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

/// Description: 取病区病人树形结构数据
/// Return:      Json Str
/// w ##class(web.DHCSTPIVAS.BatUpdateNew).GetPatTreeData()
ClassMethod GetPatTreeData(pJsonStr = "{}")
{
    s retJson = []
    d ..Collect(pJsonStr,.collectData)
    k calcData, calcCntData
    s mDsp = 0
    for {
        s mDsp = $o(collectData(mDsp))
        q:(mDsp = "")
        s mDspData = $g(^DHCOEDISQTY(mDsp))
        s wardLoc = $p(mDspData, "^", 22)   
        s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, 0))  
        continue:(ward = "")

        s wardDesc= ##class(PHA.PIVAS.Data.Base).LocDesc(wardLoc)
        s adm = $p(mDspData, "^", 26)
        s pat = $p($g(^PAADM(adm)), "^", 1)
        s patNo = $p(^PAPER(pat, "PAT", 1), "^", 1)
        s patName = $p(^PAPER(pat, "ALL"), "^", 1)
        s bedNo = $p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(adm, wardLoc), "^", 2)
        if (bedNo = ""){
            s patIndex = $lb($$$MaxStr, patNo)
        }else {
            s patIndex = $lb(bedNo, patNo)
        }
        s wardIndex = $j(ward, 5)
        
        s calcData(wardIndex) = $lb(ward, wardDesc)
        s calcData(wardIndex, patIndex) = $lb(adm, pat, bedNo, patNo, patName)
        s calcCntData(ward, pat) = $g(calcCntData(ward, pat)) + 1
    }   
    s wardIndex = ""
    for {
        s wardIndex = $o(calcData(wardIndex))
        q:(wardIndex = "")
        s wardData = calcData(wardIndex)
        s ward = $lg(wardData, 1)
        s wardDesc = $lg(wardData, 2)
        s rowData = {
            "id": (ward),
            "text": (wardDesc),
            "state": "open",
            "children":[]
        }
        s rowChild = []
        s patIndex = ""
        for {
            s patIndex = $o(calcData(wardIndex, patIndex))
            q:(patIndex = "")
            s patData = calcData(wardIndex, patIndex)
            s pat = $lg(patData, 2)
            s patDspCnt = $g(calcCntData(ward, pat))
            s textJson = {
                "adm" : ($lg(patData, 1)),
                "pat" : ($lg(patData, 2)),
                "bedNo" : ($lg(patData, 3)),
                "patNo" : ($lg(patData, 4)),
                "patName" : ($lg(patData, 5)),
                "cnt": (patDspCnt)
            }
            d rowChild.%Push({
                "id": ($lg(patData, 1)),
                "text": (textJson)
            })
            
        }
        s rowData.children = rowChild
        d retJson.%Push(rowData)
    }
    q retJson.%ToJSON()
}

Query OrdExeData(pJsonStr = "{}") As websys.Query(ROWSPEC = "pog, mDsp, doseDateTime, batNo, drugsArr, patNo, patName, bedNo, instrucDesc, freqDesc, itmCnt, wardDesc, sameFlag, check, packFlag, altFlag, workTypeDesc, pivaCatDesc, updateFlag, updateType, canUpdate, liquid, check, priDesc, wardPat, adm")
{
}

/// Description: 排批明细 - 单行模式
/// Debug:       w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.LabelPrint","OrdExeData","")
ClassMethod OrdExeDataExecute(ByRef qHandle As %Binary, pJsonStr = "{}") As %Status
{
    #; s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.BatUpdate","OrdExeData")=pJsonStr
    s repid=$i(^CacheTemp)
    s qHandle=$lb(0, repid, 0)
    s ind=1
    
    s pJson = ##class(web.DHCSTPIVAS.Util).DataToJson(pJsonStr)
    q:'$IsObject(pJson) $$$OK
    
    s pLoc = pJson.loc
    d ..Collect(pJsonStr, .collectData)
    
    s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", pLoc, "OeAudit", "AuditTimes")
    s needNurAudit=##class(web.DHCSTPIVAS.Settings).GetNeedNurseAudit(pLoc)
    s referBefore=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", pLoc, "BatUpdate", "ReferBeforeBat") 
    
    /* 排序取数据 */
    k calcTmpData, calcData
    s mDsp = 0
    for {
        s mDsp = $o(collectData(mDsp))
        q:(mDsp = "")
        s mDspData = $g(^DHCOEDISQTY(mDsp))
        s wardLoc = $p(mDspData, "^", 22)   
        s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, 0))  
        continue:(ward = "")
        
        s adm = $p(mDspData, "^", 26)
        if ('$d(calcTmpData("adm", adm))) {
            s pat = $p($g(^PAADM(adm)), "^", 1)
            s calcTmpData("adm", adm, "patNo") = $p(^PAPER(pat, "PAT", 1), "^", 1)
            s calcTmpData("adm", adm, "patName") = $p(^PAPER(pat, "ALL"), "^", 1)
            s calcTmpData("adm", adm, "bedNo") = $p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(adm, wardLoc), "^", 2)
        }
        
        s patNo = calcTmpData("adm", adm, "patNo")
        s patName = calcTmpData("adm", adm, "patName")
        s bedNo = calcTmpData("adm", adm, "bedNo")
        
        if (bedNo = ""){
            s bedIndex = $$$MaxStr
        }else {
            s bedIndex = $j(bedNo, 5)
        }
        
        s doseDate = $p(mDspData, "^", 21)
        s wardIndex = ward
        s batNo = $lg(collectData(mDsp), 1)
        s batSort = $lg(collectData(mDsp), 2)
        s sortIndex = $lts($lb(wardIndex, bedNo, patNo, doseDate, batNo, batSort, mDsp))
        s calcData(sortIndex) = $lb(mDsp, batNo)
    }   
    k collectData

    s check = "N"
    /* 输出 */
    s pogCnt= 0, seqNo = 0, lastPatNo = "", altCnt = 0
    s sortIndex = ""
    for {
        s sortIndex = $o(calcData(sortIndex))
        q:(sortIndex = "")
        s data = calcData(sortIndex)
        s mDsp = $lg(data, 1)
        s batNo = $lg(data, 2)
        s pog = $o(^PIVA(0, "DSP", mDsp, 0 ))
        
        s dspData = $g(^DHCOEDISQTY(mDsp))
        s mOeori = $p(dspData, "^", 1)
        s mOeore = $p(dspData, "^", 3)
        s seqNo = $p(dspData, "^", 4)
        
        s doseTime=$p(dspData,"^",20)
        s doseDate=$p(dspData,"^",21)
        
        s wardLoc = $p(dspData, "^", 22)
        s wardDesc= ##class(PHA.PIVAS.Data.Base).LocDesc(wardLoc)
        
        s adm = $p(dspData, "^", 26)
        
        s pat = $p(^PAADM(adm), "^", 1)                                         
        s patName = $g(calcTmpData("adm", adm, "patName"))
        s patNo = $g(calcTmpData("adm", adm, "patNo"))
        s bedNo = $g(calcTmpData("adm", adm, "bedNo"))
        s doseDateTime = ..DateShortFormat(doseDate) _ " " _ ..TimeShortFormat(doseTime)        
        s freqDesc = $p(..OeoriFreq(mOeori), "^", 2)
        s instrucDesc = $p(..OeoriInstruc(mOeori), "^", 2)
        s workType = ..OrdWorkType(mOeore)
        s workTypeDesc = $p(workType, "^", 3)
        s pivaCatDesc = $p(..GetOrdPivaCat(mOeori), "^", 2)
        s passResultDesc = ""
        s packFlag = ..DspPackFlag(mDsp)
        s drugsArr = ..GetOeoreDrugsArr(mOeore)
        s liquid = ..OrderLiquid(,mOeore)
        if (liquid '= "") {
            s liquid = liquid _ "ml"
        }
        s priDesc = $p(..OeoriPriority(mOeori), "^", 3)
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

        s itmCnt = ""
        s updateFlag = $s(pog '= "" : "Y" , 1 : "")
        s updateType = ..GetBatUpdType(mDsp)
        s canUpdate = ..CanBatNoUpdate(mDsp)
        s check = "N"
        s wardPat = $lts($lb(wardLoc, patNo), "||")
        s lbData = $lb(pog, mDsp, doseDateTime, batNo, drugsArr)
                 _ $lb(patNo, patName, bedNo, instrucDesc, freqDesc)
                 _ $lb(itmCnt, wardDesc, sameFlag, check, packFlag)
                 _ $lb(altFlag, workTypeDesc, pivaCatDesc, updateFlag, updateType)
                 _ $lb(canUpdate, liquid, check, priDesc,wardPat,adm)
        s ^CacheTemp(repid,ind) = lbData    
        s ind = ind + 1 
    }
    q $$$OK
}

/// description: 前台修改批次调用
/// input:       mDsp(主打包Id),userId(登陆人Id)
/// output:      
/// others:      暂不做控制
/// tables:      PIVA_BatUp,PIVA_OrdGrp
/// w ##class(web.DHCSTPIVAS.BatUpdate).UpdateBatch(13414,1,1234)
ClassMethod UpdateBatch(mDsp, batNo, userId, batRemark = "用户修改")
{
    q:batNo="" "-1^批号为空"
    q:mDsp="" "-1^打包Id为空"
    q:userId="" "-1^操作人为空"
    q:(##class(web.DHCSTPIVAS.Common).CanBatBeUpdated(mDsp) = $$$NO) "-1^已配置, 无法修改"
    s mOeore=$p(^DHCOEDISQTY(mDsp),"^",3)
    q:##class(web.DHCSTPIVAS.Common).CheckOeoreStat(mOeore)=0 "-1^执行记录已停"
    s grpNo=$p(^DHCOEDISQTY(mDsp),"^",4)
    s lockRet=##class(web.DHCSTPIVAS.Common).Lock("DHCOEDispensing",mDsp)
    q:lockRet'=0 "-1^加锁失败"
    s errInfo=""
    s updFlag=""
    ts
    // 处理PIVA_OrdGrp
    s pogId=$o(^PIVA(0,"DSP",mDsp,""))
    i pogId'="" d
    .s updFlag="Y"
    .&SQL(UPDATE PIVA_OrdGrp SET POG_BatNo=:batNo WHERE POG_RowId=:pogId)
    .i SQLCODE'=0 d
    ..s errInfo="-2^"_SQLCODE_":"_%msg
    ..d ErrorUpdateBatch
    q:errInfo'="" errInfo
    // 处理PIVA_BatUp
    s insRet=..InsertPIVABatUp(mDsp, grpNo, batNo, userId, updFlag, batRemark)
    i +insRet'=0 d
    .s errInfo=insRet
    .tro
    .d UnLockUpdateBatch
    q:errInfo'="" errInfo
    tc
    d UnLockUpdateBatch
    q "0^修改成功"
UnLockUpdateBatch
    d ##class(web.DHCSTPIVAS.Common).UnLock("DHCOEDispensing",mDsp)
    q
ErrorUpdateBatch
    s errMsgInfo="##class(web.DHCSTPIVAS.BatUpdate).UpdateBatch("_$lts($lb(mDsp, batNo, userId))_")"
    d ErrorRecord^DHCSTERROR("DHCSTINPIVA",errMsgInfo,SQLCODE_":"_%msg)
    d UnLockUpdateBatch
    q
}

/// Description: 保存排批
/// w ##class(web.DHCSTPIVAS.BatUpdate).SaveData("[{""mDsp"":""24777"",""batNo"":""2""},{""mDsp"":""24778"",""batNo"":""3""},{""mDsp"":""25263"",""batNo"":""1""},{""mDsp"":""25264"",""batNo"":""空""}]","711")
ClassMethod SaveData(dataJsonStr = "[]", user)
{
    q:(dataJsonStr = "[]") "-1^没有可排批的数据"
    q:(user = "") "-1^获取不到登录用户"
    s $zt = "ThrowSaveData"
    s dataJson = ##class(web.DHCSTPIVAS.Util).DataToJson(dataJsonStr)
    s succCnt = 0
    for {
        s mDspJson = dataJson.%Pop()
        q:(mDspJson = "")
        
        s mDsp = mDspJson.%Get("mDsp")
        q:(mDsp = "")
        
        s batNo = mDspJson.%Get("batNo")
        q:(batNo = "")

        
        s lockRet = ..Lock("DHCOEDispensing", mDsp)
        continue:(+lockRet < 0)
        s canRet = ..CanInsOrdGrp(mDsp)
        if (canRet = "N") {
            d ..UnLock("DHCOEDispensing", mDsp)
            continue
        }
        s mDspData = $g(^DHCOEDISQTY(mDsp))
        s seqNo = $p(mDspData, "^", 4)
        s pbu = $o(^PIVABU(0, "OEGRP", mDsp, seqNo, ""), -1)
        s err = ""
        
        ts
        
        /* 处理批次记录 */
        s insRet = ..SavePIVABatUp(mDsp, seqNo, batNo, user, "Y", "系统生成")
        if (+insRet '= 0) {
            tro
            d ..UnLock("DHCOEDispensing", mDsp)
            continue
        }
        
        /* 处理配液表 */
        s insRet = ..SavePIVAOrdGrp(mDsp, batNo, user)      
        if (+insRet '= 0) {
            tro
            d ..UnLock("DHCOEDispensing", mDsp)
            continue
        }   
        
        tc
        d ..UnLock("DHCOEDispensing", mDsp)
        d ##class(web.DHCSTPIVAS.DataCenter).UpdateSystemStatus(3, mDsp, user)
        s succCnt = succCnt + 1
    }
    q succCnt

ThrowSaveData
    i $d(mDsp) d ..UnLock("DHCOEDispensing", mDsp)
    s errMsgInfo="##class(web.DHCSTPIVAS.BatUpdate).SaveData"
    s errZE = $tr($ze, "^", "-")
    d ErrorRecord^DHCSTERROR("DHCSTINPIVA", errMsgInfo, errZE)
    q "-2^" _ errZE
}

ClassMethod SavePIVABatUp(mDsp, grpNo, batNo, user, updFlag, batRemark = "")
{
    s err = ""
    s mDspData = $g(^DHCOEDISQTY(mDsp))
    s seqNo = $p(mDspData, "^", 4)
    s pbu = $o(^PIVABU(0, "OEGRP", mDsp, seqNo, ""), -1)
    if (pbu = "") {
        s insRet = ..InsertPIVABatUp(mDsp, seqNo, batNo, user, "Y", "系统生成")
        if (+insRet '= 0) {
            s err = insRet
        }
    } else {
        &SQL(
            UPDATE
                PIVA_BatUp
            SET
                PBU_UpdFlag = 'Y'
            WHERE
                PBU_RowID = :pbu
        )
        if (SQLCODE '= 0){
            s err = "-1^更新批次状态失败"
        }
    }
    q err
}

/// Description: 判断是否能够排批
/// Return:      Y - 能够, N - 不能
ClassMethod CanInsOrdGrp(mDsp)
{
    q:($d(^PIVA(0, "DSP", mDsp))) "N"
    s mDspData = $g(^DHCOEDISQTY(mDsp))
    s mOeori = $p(mDspData, "^", 1)
    s mOeore = $p(mDspData, "^", 3)
    s recLoc = $p(mDspData, "^", 24)
    q:(..CheckOeoreStat(mOeore) '= 1) "N"
    q:(..IsOrderPreStop(mOeore) = $$$YES) "N"
    s nurSeeFlag = $p(..GetNurseSeeType(mOeori, recLoc), "^", 3)
    q:(nurSeeFlag = "N") "N"
    q "Y"
}

/// creator:     yunhaibao
/// createdate:  2018-03-08
/// description: 插入批次更新表
ClassMethod InsertPIVABatUp(mDsp, grpNo, batNo, userId, updFlag, batRemark = "")
{
    s errMsgInfo=""
    s curDate=+$h
    s curTime=$p($h,",",2)
    &SQL(
        INSERT INTO PIVA_BatUp
        (PBU_OEORI_Dr,PBU_GrpNo,PBU_BatNo,PBU_SSUSR_Dr,PBU_Date,PBU_Time,PBU_UpdFlag,PBU_Remark)
        Values
        (:mDsp,:grpNo,:batNo,:userId,:curDate,:curTime,:updFlag,:batRemark)
    )
    i SQLCODE'=0 d
    .s errInfo="-2^"_SQLCODE_":"_%msg
    .s errMsgInfo="##class(web.DHCSTPIVAS.BatUpdate).InsertPIVABatUp"
    .d ErrorRecord^DHCSTERROR("DHCSTINPIVA",errMsgInfo,SQLCODE_":"_%msg)
    q:errMsgInfo'="" errMsgInfo
    q "0^成功"
}

/// creator:     yunhaibao
/// createdate:  2018-03-08
/// description: 保存至配液表
/// tables:      PIVA_OrdGrp,PIVA_OrdGrpItm,PIVA_OrdGrpState
/// 外层事务,本方法不写事务
/// w ##class(web.DHCSTPIVAS.BatUpdate).SavePIVAOrdGrp("32279","1","711")
ClassMethod SavePIVAOrdGrp(mDsp, batNo, userId)
{
    s errInfo=""
    s DHCOEDISQTY=$g(^DHCOEDISQTY(mDsp))
    s mOeori=$p(DHCOEDISQTY,"^",1)
    s mOeore=$p(DHCOEDISQTY,"^",3)
    s grpNo=$p(DHCOEDISQTY,"^",4)
    s doseDate=$p(DHCOEDISQTY,"^",21)
    s doseTime=$p(DHCOEDISQTY,"^",20)
    s recLocId=$p(DHCOEDISQTY,"^",24)
    s psId=##class(web.DHCSTPIVAS.Common).LocPsIdByPsNumber(recLocId,"3")
    s workTypeId=$p(##class(web.DHCSTPIVAS.Common).OrdWorkType(mOeore),"^",1)
    q:workTypeId="" "-1^工作组为空"
    s operFlag="N" 
    &SQL(
        INSERT INTO PIVA_OrdGrp
        (POG_OEORI_Dr,POG_GrpNo,POG_BatNo,POG_OrdDate,POG_OrdTime,POG_PS_Dr,POG_Ctloc_dr,POG_Oper,POG_WorkType)
        VALUES
        (:mDsp,:grpNo,:batNo,:doseDate,:doseTime,:psId,:recLocId,:operFlag,:workTypeId)
    )
    s pogId=$P(%ROWID,$C(1))
    i SQLCODE'=0 d
    .d ErrorSavePIVAOrdGrp
    q:errInfo'="" errInfo
        
    /* 医嘱重新排序 */
    k calcData
    s ordIndex = ..GetOeoriOrdIndex(mOeori,recLocId)
    s calcData(ordIndex, $p(mOeori, "||", 2)) = mOeore _ "^" _ mDsp
    s ordItm=""
    f  s ordItm=$O(^OEORDi(0,"OEORI",+mOeori,mOeori,ordItm)) Q:(ordItm="")||(errInfo'="")  D
    .s oeori=+mOeori_"||"_ordItm
    .s dspId=$o(^DHCOEDISQTY(0,"SEQNO",oeori,doseDate,grpNo,""))
    .q:dspId=""
    .s oeore=$p(^DHCOEDISQTY(dspId),"^",3)
    .q:##class(web.DHCSTPIVAS.Common).CheckOeoreStat(oeore)'="1"    // 执行记录已停
    .q:(..IsOrderPreStop(oeore) = $$$YES)
    .q:$p(##class(web.DHCSTPIVAS.Common).GetArcItmCatByOeori(oeori),"^",4)'="R"
    .s ordIndex = ..GetOeoriOrdIndex(oeori,recLocId)
    .s calcData(ordIndex, $p(oeori, "||", 2)) = oeore _ "^" _ dspId
    s ordIndex = ""
    f  s ordIndex = $o(calcData(ordIndex)) q:ordIndex=""  d
    .s itm = ""
    .f  s itm = $o(calcData(ordIndex, itm)) q:itm=""  d
    ..s oeore = $p($g(calcData(ordIndex, itm)), "^", 1)
    ..s dspId = $p($g(calcData(ordIndex, itm)), "^", 2)
    ..s childSub=$o(^PIVA(pogId,"I",""),-1)+1
    ..&SQL(
        INSERT INTO PIVA_OrdGrpItm 
        (POGI_POG_Parref,POGI_ChildSub,POGI_DSP_Dr)
        VALUES
        (:pogId,:childSub,:dspId)
      )
    ..i SQLCODE'=0 d
    ...d ErrorSavePIVAOrdGrp
    ..q:errInfo'=""
    q:errInfo'="" errInfo
    s insRet=##class(web.DHCSTPIVAS.DataHandler).InsOrdGrpState(pogId,userId,psId)
    i +insRet'=0 s errInfo=insRet
    q:errInfo'="" errInfo   
    q "0^成功"
ErrorSavePIVAOrdGrp
    s errInfo="-2^"_SQLCODE_":"_%msg 
    s errMsgInfo="##class(web.DHCSTPIVAS.BatUpdate).SavePIVAOrdGrp"
    d ErrorRecord^DHCSTERROR("DHCSTINPIVA",errMsgInfo,SQLCODE_":"_%msg)
    q
}

/// creator:    yunhaibao
/// createdate: 2018-07-20
/// description:取消多条记录排批
ClassMethod DeleteBatUpdateMulti(mDspStr, userId)
{
    q:mDspStr="" "-1^无可用数据"
    s errCode=""
    s succCnt=0
    s mDspLen=$l(mDspStr,"^")
    f mDspI=1:1:mDspLen d
    .s mDsp=$p(mDspStr,"^",mDspI)
    .q:mDsp=""
    .s delRet=..DeleteBatUpdate(mDsp,userId)
    .i +$p(delRet,"^",1)<0 d
    ..s delErrInfo=$p(delRet,"^",2)
    ..i errCode="" s errCode="-1^"_delErrInfo
    ..e  d
    ...i errCode'[delErrInfo s errCode=errCode_"</br>"_delErrInfo
    .e  s succCnt=succCnt+1
    q:errCode'="" errCode_"^"_succCnt
    q 0
}

/// creator:    yunhaibao
/// createdate: 2018-07-20
/// description:取消单条记录排批
ClassMethod DeleteBatUpdate(mDsp, userId)
{
    q:mDsp="" "-1^打包Id为空"
    s pogId=$o(^PIVA(0,"DSP",mDsp,""))
    q:pogId="" "-1^尚未排批,无法取消"
    #; 先加锁, 再进行状态判断
    s lockRet=##class(web.DHCSTPIVAS.Common).Lock("DHCOEDispensing",mDsp)
    q:lockRet'=0 "-1^加锁失败"

    s psId=$p(^PIVA(pogId),"^",6)
    s psNumber=$p($g(^PIVAS(+psId)),"^",1)
    s psName=$p($g(^PIVAS(+psId)),"^",2)
    //i +psNumber>3 d DeleteFail q "-1^已"_psName_",无法取消"
    s grpNo=$p(^DHCOEDISQTY(mDsp),"^",4)
    s errInfo=""
    ts
    d ##class(web.DHCSTPIVAS.DataCenter).UpdateSystemStatus(3, mDsp, userId, "", "", "CANCEL")
    // 删除-PIVA_OrdGrp
    &SQL(DELETE FROM PIVA_OrdGrp WHERE POG_RowId=:pogId)
    i SQLCODE'=0 d DeleteFail  q "-1^删除配液主表失败"
    // 删除-PIVA_BatUp,不删除,更新状态
    //&SQL(DELETE FROM PIVA_BatUp WHERE PBU_OEORI_DR=:mDsp and PBU_GrpNo=:grpNo)
    //i SQLCODE'=0 d DeleteFail  q "-1^删除排批记录失败"
    &SQL(UPDATE PIVA_BatUp SET PBU_UpdFlag=NULL WHERE PBU_OEORI_DR=:mDsp and PBU_GrpNo=:grpNo)
    d ##class(web.DHCSTPIVAS.Common).UnLock("DHCOEDispensing",mDsp)
    tc
    q 0
DeleteFail
    d ##class(web.DHCSTPIVAS.Common).UnLock("DHCOEDispensing",mDsp)
    tro
    q
}

/// description: 批量修改批次
ClassMethod UpdateBatchMulti(mDspStr, batNo, userId)
{
    q:mDspStr="" "-1^无可用数据"
    q:batNo="" "-1^批次为空"
    q:userId="" "-1^用户Id为空"
    s errCode=""
    s mDspLen=$l(mDspStr,"^")
    f mDspI=1:1:mDspLen d
    .s mDsp=$p(mDspStr,"^",mDspI)
    .q:mDsp=""
    .s curPSStr=##class(web.DHCSTPIVAS.Common).CurPsState(mDsp)
    .i +$p(curPSStr,"^",1)>3 s delRet="-1^已"_$p(curPSStr,"^",2)
    .e  s delRet=..UpdateBatch(mDsp,batNo,userId)
    .i +$p(delRet,"^",1)<0 d
    ..s delErrInfo=$p(delRet,"^",2)
    ..i errCode="" s errCode="-1^"_delErrInfo
    ..e  s errCode=errCode_"</br>"_delErrInfo
    q:errCode'="" errCode
    q 0
}

/// description: 拼接提示信息
ClassMethod MakeWarnInfo(WTDesc)
{
    s sortNum=0
    i WTDesc="" s sortNum=sortNum+1,MakeWarnInfoData(sortNum)="<span style='color:black;font-weight:bold;font-size:12px'>工作组为空</span>"
    q:'$d(MakeWarnInfoData) ""
    s collStr=""
    s sortNum=0
    f  s sortNum=$o(MakeWarnInfoData(sortNum)) q:sortNum=""  d
    .s info=MakeWarnInfoData(sortNum)
    .i collStr="" s collStr=info
    .e  s collStr=collStr_"</br>"_info
    q collStr
}

/// Description: 查询明细后的汇总数据
/// Return:      Json 转换成字符串
ClassMethod GetSumDetailData(dataJsonStr = "[]")
{
    s retJson = []  
    q:(dataJsonStr = "[]") retJson.%ToJSON()
    s dataJson = ##class(web.DHCSTPIVAS.Util).DataToJson(dataJsonStr)
    s succCnt = 0
    for {
        s mDspJson = dataJson.%Pop()
        q:(mDspJson = "")
        
        s mDsp = mDspJson.%Get("mDsp")
        q:(mDsp = "")
        
        s batNo = mDspJson.%Get("batNo")
        q:(batNo = "")
        
        s calcuData(batNo) = $g(calcuData(batNo)) + 1
    }
    
    s batNo = ""
    for {
        s batNo = $o(calcuData(batNo))
        q:(batNo = "")
        s row = {
            "batNo": (batNo),
            "cnt": (calcuData(batNo))
        }
        d retJson.%Push(row)
    }
    q retJson.%ToJSON()
}

}
