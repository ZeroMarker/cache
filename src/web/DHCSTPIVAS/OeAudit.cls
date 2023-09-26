/// Description: 配伍审核
Class web.DHCSTPIVAS.OeAudit Extends web.DHCSTPIVAS.Common
{

/// w ##class(web.DHCSTPIVAS.OeAudit).Collect("{""loc"":""186"",""wardStr"":"""",""locGrp"":"""",""startDate"":""2022-09-25"",""endDate"":""2022-11-22"",""cat"":"""",""workType"":"""",""priority"":"""",""passStat"":""0"",""passResult"":"""",""inci"":"""",""nurAudit"":""1"",""phaMark"":""""}")
ClassMethod Collect(pJsonStr = "{}", Output collectData)
{
    q:pJsonStr="{}" ""
    s pJson = ##class(PHA.COM.Json).Parse(pJsonStr)
    q:'$IsObject(pJson) ""
    
    s pLoc = pJson.loc, pWardStr = pJson.wardStr, pLocGrp =  pJson.locGrp
    s pStartDate = pJson.startDate, pEndDate = pJson.endDate
    s pStartTime = pJson.startTime, pEndTime = pJson.endTime
    s pCat = pJson.cat, pWorkType = pJson.workType, pInci = pJson.inci
    s pAdm = pJson.adm, pPhaMark = pJson.phaMark, pPriority = pJson.priority
    s pPassStat = pJson.passStat, pPassResult = pJson.passResult, pPatNo = pJson.patNo
    s pWardList = $lfs(pWardStr, ",")
    s pStartDate = $$$zdh(pStartDate)
    s pEndDate = $$$zdh(pEndDate)
    s pStartTime= $$$zth(pStartTime)
    s pEndTime = $$$zth(pEndTime)
    s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", pLoc, "OeAudit", "AuditTimes")
    s needNurAudit ="Y"
    
    /* 为提交查询速度的暂存数据 */
    k calcMainData, calcValidData 
    
    for calcDate = pStartDate : 1 : pEndDate {
        s status = ""
        for {
            s status = $o(^DHCOEDISQTY(0, "REC", pLoc, calcDate, status))
            q:(status = "")
            continue:(status = "R")
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
                    s dspTimeDos = $p(dspData, "^", 20)
                    continue:(pStartTime '= "")&&(calcDate = pStartDate)&&(pStartTime > dspTimeDos)
                    continue:(pEndTime '= "")&&(calcDate = pEndDate)&&(pEndTime < dspTimeDos)
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
                       
                    s mOeore = ..GetMainOeore(oeore)
                    continue:$d(calcMainData(mOeore))
                    
                    s calcMainData(mOeore) = ""
                    s mOeori = $p(mOeore, "||", 1, 2)
                    s mDrugOeori = ..GetMainDrugOeori(mOeori)
                    
                    continue:(mDrugOeori = "")
                    continue:(mDrugOeori'=mOeori)
                    s oeoriStatCode = ..GetOeoriStatCode(mOeori)
                    
                    if auditTimes '= ""  {
                        s lastDate=##class(web.DHCSTPIVAS.Common).GetDoseDateByTimes(mOeori, auditTimes, pLoc)
                        continue:(calcDate>lastDate)
                    }   
                    
                    continue:($d(calcValidData("dateMOeori", mOeori, calcDate)))
                    continue:($d(collectData(wardLoc, mOeori, calcDate)))
                    continue:(pPriority '= "")&&(pPriority '= $p(..OeoriPriority(mOeori), "^", 1))
                    continue:(oeoriStatCode '= "V")&&(oeoriStatCode '= "E")&&(..CheckOeoreStat(mOeore) '= 1)
                    continue:(pCat '= "")&&(pCat '= +..GetOrdPivaCat(mOeori))
                    continue:(pWorkType '= "")&&(pWorkType '= +..OrdWorkType(mOeore))
                    continue:(pPhaMark = "Y")&&(..GetPhaOrdRemark(mOeori) = "")
                                        
                    //continue:(needNurAudit = "Y")&&(..NurAuditFlagByMDsp(mDsp)'= "Y")
                    if (pInci '= "") {
                        s ret = ..IsInciInOrder(mOeori,pInci)
                        continue:(ret '= "Y")
                    }
                    // 仅配伍审核控制
                    s passStatStr = ..GetOrdPassState(mOeori, calcDate, auditTimes, pLoc)
                    s passStat = $p(passStatStr, "^", 1)  
                    s phaOrd = $p(passStatStr, "^", 3)
                    if phaOrd '= "" {
                        s phaOrdResult = $p(^DHCPHORDM(phaOrd), "^", 2)
                        continue:(pPassStat = 3)&&(phaOrdResult '= "A")
                        i phaOrdResult = "A" s passStat = "" // 医生申诉视为未审核
                    }
                    continue:(pPassStat = 3)&&(phaOrd = "")
                    if (pPassResult '= "")&&(pPassResult '= passStat) {
                        s calcValidData("dateMOeori", mOeori, calcDate) = ""
                        continue
                    }
                    if (pPassStat = 1)&&(passStat '= "") {
                        s calcValidData("dateMOeori", mOeori, calcDate) = ""
                        continue        
                    }
                    if (pPassStat = 2)&&(passStat = "") {
                        s calcValidData("dateMOeori", mOeori, calcDate) = ""
                        continue        
                    }   
                    
                    /* 出院结算 */
                    continue:(mDrugOeori = "")
                    s arcCatStr = ..GetArcItmCatByOeori(mDrugOeori)
                    s arcCat = $p(arcCatStr, "^", 1)
                    s arcCatType=$p(arcCatStr, "^", 4)
                    continue:(arcCatType '= "R")
                    s collAllow = ##Class(web.DHCSTCOMMONSRV).IfCollectDrugAllowed(adm, arcCat_"^"_$p(..OeoriPriority(mOeori), "^", 1)_"^"_oeori)
                    continue:(collAllow '= 1)
                    s collectData(wardLoc, mOeori,calcDate) = ""
                    
                }
            }
        }   
    }
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.OeAudit","WardData",^PHATMP("MYQ","web.DHCSTPIVAS.OeAudit","WardData"))
Query WardData(pJsonStr = "{}") As websys.Query(ROWSPEC = "ward, wardDesc, cnt")
{
}

/// d ##class(%ResultSet.RunQuery).("web.DHCSTPIVAS.OeAudit","WardData","{""loc"":""186"",""wardStr"":"""",""locGrp"":"""",""startDate"":""2022-02-11"",""endDate"":""2022-02-11"",""cat"":"""",""workType"":"""",""priority"":"""",""passStat"":""1"",""passResult"":"""",""inci"":"""",""nurAudit"":""1"",""phaMark"":"""",""grpView"":""Y""}")
ClassMethod WardDataExecute(ByRef qHandle As %Binary, pJsonStr = "{}") As %Status
{
    s repid = $i(^CacheTemp)
    s qHandle = $lb(0, repid, 0)
    s ind = 1
    d ..Collect(pJsonStr, .collectData)

    k calcData, calcCntData
    s wardLoc = ""
    for {
        s wardLoc = $o(collectData(wardLoc))
        q:(wardLoc = "")
        s wardLocDesc = ##class(PHA.PIVAS.Data.Base).LocDesc(wardLoc)
        s sort = wardLocDesc _ $j(wardLoc, 5)
        s calcData(sort) = wardLoc
        s mOeori = ""
        for {
            s mOeori = $o(collectData(wardLoc, mOeori))
            q:(mOeori = "")
            s calcDate = ""
            for {
                s calcDate = $o(collectData(wardLoc, mOeori, calcDate))
                q:(calcDate = "")
                s calcCntData(wardLoc) = $g(calcCntData(wardLoc)) + 1
            }
        }
    }
    s sort= ""
    for {
        s sort = $o(calcData(sort))
        q:(sort = "")
        s wardLoc = $p(calcData(sort), "^", 1)
        s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, ""))
        s wardDesc = ##class(PHA.PIVAS.Data.Base).WardDesc(ward)
        s cnt = +$g(calcCntData(wardLoc))
        s ^CacheTemp(repid,ind) = $lb(ward, wardDesc, cnt)    
        s ind = ind + 1
    }
    q $$$OK
}

/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.OeAudit","OrderData","{""loc"":""186"",""wardStr"":"""",""locGrp"":"""",""startDate"":""2022-09-25"",""endDate"":""2022-11-22"",""cat"":"""",""workType"":"""",""priority"":"""",""passStat"":""0"",""passResult"":"""",""inci"":"""",""nurAudit"":""1"",""phaMark"":""""}")
Query OrderData(pJsonStr = "{}") As websys.Query(ROWSPEC = "mOeori, wardLocDesc, bedNo, patNo, patName, adm, patAge, patWeight, patHeight, diagDesc, drugsArr, oeoriDateTime, doseDate, dateMOeori, instrucDesc, passResultDesc, passResultStat, pivaCatDesc, freqDesc, warnInfo, doctorName, phaOrdRemark, nurSeeFlag, nurSeeDesc, sameFlag, altFlag, priDesc, patSex, patSpec, exceedReasonDesc, wardPat, passResult, banInfo")
{
}

ClassMethod OrderDataExecute(ByRef qHandle As %Binary, pJsonStr = "{}") As %Status
{
    //s pJsonStr=^TMPDHCSTPARAMS("web.DHCSTPIVAS.OeAudit","OrderData")
    s repid = $i(^CacheTemp)
    s qHandle = $lb(0, repid, 0)
    s ind = 1
    
    s pJson = ##class(PHA.COM.Json).Parse(pJsonStr)
    q:'$IsObject(pJson) $$$OK
    
    s pLoc = pJson.loc
    s pGrp = pJson.grpView
    s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", pLoc, "OeAudit", "AuditTimes")
    
    d ..Collect(pJsonStr, .collectData)
    
    /* 排序 */
    k calcData, calcTmpData
    s sameFlag = "", altFlag = ""
    s wardLoc = ""
    for {
        s wardLoc = $o(collectData(wardLoc))
        q:(wardLoc = "")
        s wardLocDesc = ##class(PHA.PIVAS.Data.Base).LocDesc(wardLoc)
        s mOeori = ""
        for {
            s mOeori = $o(collectData(wardLoc, mOeori))
            q:(mOeori = "")
            s adm = $p(^OEORD(+mOeori), "^", 1)
            d GetAdmData
            s patNo = $g(calcTmpData("ADM", adm, "patNo"))
            s patName =  $g(calcTmpData("ADM", adm, "patName"))
            s patAge = $g(calcTmpData("ADM", adm, "patAge"))
            s bedNo = $g(calcTmpData("ADM", adm, "bedNo"))  
            s patSex = $g(calcTmpData("ADM", adm, "patSex"))    
            s patWeight = $g(calcTmpData("ADM", adm, "patWeight"))  
            s patHeight = $g(calcTmpData("ADM", adm, "patHeight"))
            s diagDesc = $g(calcTmpData("ADM", adm, "diagDesc"))
            s patSpec = $g(calcTmpData("ADM", adm, "patSpec"))
            s wardPat = $lts($lb(wardLoc, patNo), "||")
                    
            s oeoriDateTime = ..OeoriDateTime(mOeori)
            s instrucDesc = $p(..OeoriInstruc(mOeori), "^", 2)
            s pivaCatDesc = $p(..GetOrdPivaCat(mOeori), "^", 3)
            s freqDesc = $p(..OeoriFreq(mOeori), "^", 2)
            s doctorName = $p(..OeoriDoctor(mOeori),"^",2)
            s pivasOrdRemark = ##class(web.DHCSTPIVAS.Remark).Get("PIVASOrder", mOeori)
            s pivasExeRemark = ##class(web.DHCSTPIVAS.Remark).Get("PIVASExecute", mOeori)
            s pivasLabelRemark = ##class(web.DHCSTPIVAS.Remark).Get("PIVASLabel", mOeori)
            s phaOrdRemark = ##class(web.DHCSTPIVAS.Common).GetPhaOrdRemark(mOeori, "</br>")
            s nurSeeTypeStr = ..GetNurseSeeType(mOeori, pLoc)
            s nurSeeFlag = $p(nurSeeTypeStr, "^", 1)
            s nurSeeDesc = $p(nurSeeTypeStr, "^", 3)
            s priDesc = $p(..OeoriPriority(mOeori), "^", 3)
            s exceedReasonDesc = $p(..OeoriExceedReason(mOeori), "^", 2)
            s warnInfo = ""
            if (pGrp = ""){
                s %zwebDHCSTPIVASCommon("IsOeoriDosage") = $$$YES
                s drugsArr = ..GetOeoreDrugsArr(mOeori _"||" _ 1)
            }else {
                s drugsArr = ..GetOeoriDrugsHtml(mOeori, pLoc)
            }
            s banInfo = ""
            s mDrugOeori = ..GetMainDrugOeori(mOeori)
            if (mDrugOeori '= mOeori){
                s banInfo = "主医嘱非药品"
            }
            s calcDate = ""
            for {
                s calcDate = $o(collectData(wardLoc, mOeori, calcDate))
                q:(calcDate = "")
                s dateMOeori = mOeori _ "-" _ calcDate
                s passResultStr = ..GetOrdPassState(mOeori, calcDate, auditTimes, pLoc)
                s passResultStat = $p(passResultStr, "^", 1)
                s passResultDesc = $p(passResultStr, "^", 2)
                s passResultDesc = $s(passResultDesc '= "" : ..Translate(passResultDesc) , 1 : passResultDesc)
                s passResult = $p(passResultStr, "^", 4)
                s sort = $lb(wardLocDesc, $j(wardLoc, 5), $j(bedNo, 5), patNo, $j(adm, 10), $j($p(mOeori, "||", 2), 10),calcDate)
                s sort = $lts(sort)
                s doseDate = ..DateShortFormat(calcDate)
                #; if (bedNo '= "")&&(bedNo '[ "床") {
                #;     s bedNo = bedNo _ "床"
                #; }
                s calcData(sort) = $lb(mOeori, wardLocDesc, bedNo, patNo, patName)
                                 _ $lb(adm, patAge, patWeight, patHeight, diagDesc)   
                                 _ $lb(drugsArr, oeoriDateTime, doseDate, dateMOeori, instrucDesc)   
                                 _ $lb(passResultDesc, passResultStat, pivaCatDesc, freqDesc, warnInfo)
                                 _ $lb(doctorName, phaOrdRemark, nurSeeFlag, nurSeeDesc, sameFlag)
                                 _ $lb(altFlag, priDesc, patSex, patSpec, exceedReasonDesc)
                                 _ $lb(wardPat, passResult, banInfo)
            }
        }
        
    }   
    /* 输出 */
    s lastPatNo = "", altCnt = 0
    s sort = ""
    for {
        s sort = $o(calcData(sort))
        q:(sort = "")
        s lbData = $g(calcData(sort))
        s patNo = $lg(lbData, 4)
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
        s $list(lbData, 25) = sameFlag
        s $list(lbData, 26) = altFlag
        s ^CacheTemp(repid,ind) = lbData
        s ind = ind + 1 
    }
    q $$$OK
    
GetAdmData
    q:($d(calcTmpData("ADM", adm)))
    s admData = $g(^PAADM(adm))
    s pat = $p(admData,"^",1)
    s patNo = $p(^PAPER(pat, "PAT", 1), "^", 1)
    s patName =  $p(^PAPER(pat, "ALL"), "^", 1) 
    s patAge = ##class(PHA.FACE.IN.Com).GetAge(pat,adm)
    s patSex = $p($g(^PAPER(pat, "ALL")), "^", 7)
    s patSex = ##class(PHA.PIVAS.Data.Base).SexDesc(patSex)
    s patWeight = ..GetMrObsItm(adm, "weight")
    if patWeight = "" {
        s patWeight=..GetPatWeight(adm)
    }
    s patHeight = ##class(web.DHCSTPIVAS.Common).GetMrObsItm(adm, "height")
    i patHeight = "" {
        s patHeight = ..GetPatHeight(adm)
    }
    s bedNo = $p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(adm), "^", 2)
    s patSpec = ..GetPatSpec(adm)
    s diagDesc = "" //##class(web.DHCSTCOMMONORDER).MrDiagnose(adm, ",")
    s calcTmpData("ADM", adm, "patNo") = patNo
    s calcTmpData("ADM", adm, "patName") = patName
    s calcTmpData("ADM", adm, "patAge") = patAge
    s calcTmpData("ADM", adm, "patSex") = patSex
    s calcTmpData("ADM", adm, "patWeight") = patWeight
    s calcTmpData("ADM", adm, "patHeight") = patHeight
    s calcTmpData("ADM", adm, "bedNo") = bedNo
    s calcTmpData("ADM", adm, "patSpec") = patSpec
    s calcTmpData("ADM", adm, "diagDesc") = diagDesc
    
    q
}

/// creator:    yunhaibao
/// createdate: 2017-12-01
/// description:配伍审核操作
///             隔日配液医嘱子表记录接收科室仍然为配液中心
/// input:      mOeoriStr-(主医嘱+用药日期)串,userId-用户Id,passType-(SHTG,ZCDB),passReason-(非正常打包原因)
/// w ##class(web.DHCSTPIVAS.OeAudit).PivasPass("207||11-65100","711","SHTG","")
ClassMethod PivasPass(dateMOeoriStr, userId, passType = "", passReasonData = "")
{
    #; s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.OeAudit","PivasPass")=$lb(dateMOeoriStr, userId, passType, passReasonData)
    s errFlag=""
    s passResult="",phNote=""
    i passType="SHTG" s passResult="Y"
    e  i passType="SHJJ" s passResult="N"
    i passReasonData'="" s phNote=$p(passReasonData,"|@|",2)
    s passReasonStr=$p(passReasonData,"|@|",1)
    ts
    s appType="PIVAS"
    s mLen=$l(dateMOeoriStr,"^")
    f mI=1:1:mLen q:errFlag'=""  d
    .s curDate=+$h
    .s curTime=$p($h,",",2)
    .s dateMOeori=$p(dateMOeoriStr,"^",mI)
    .s mOeori=$p(dateMOeori,"-",1)
    .s doseDate=$p(dateMOeori,"-",2)
    .q:(mOeori="")||(doseDate="")
    .s mOrd=+mOeori
    .s mOrdItm=$p(mOeori,"||",2)
    .s adm=$p(^OEORD(mOrd),"^",1)
    .s locId=$p(^OEORD(mOrd,"I",mOrdItm,3),"^",6)
    .s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",locId,"OeAudit","AuditTimes")
    .s passResultStr=##Class(web.DHCSTPIVAS.Common).GetOrdPassState(mOeori,doseDate,auditTimes,locId)
    .q:$p(passResultStr,"^",1)'=""  // 需先撤销审核
    .s nurSeeTypeStr=##class(web.DHCSTPIVAS.Common).GetNurseSeeType(mOeori,locId)
    .i $p(nurSeeTypeStr,"^",1)="N"  s errFlag="-1^护士"_$p(nurSeeTypeStr,"^",3)_"医嘱" q  // 护士处理
    .s orderSkinTestVal=##class(PHA.COM.Order).OrderSkinTest(mOeori)
    .i orderSkinTestVal<0 s errFlag="-1^" _ $s(orderSkinTestVal = "-2" : "皮试阳性", orderSkinTestVal = "-1" : "未做皮试", 1 : "") q  // 皮试不合格
    .s phaOrdMonitor=..InsertPHAORDMONITOR(userId,passResult,curDate,curTime,locId,appType,phNote)
    .i phaOrdMonitor'>0 s errFlag=-1_"^插入主表失败" tro
    .q:errFlag'=""
    .//s ordPassInfo=userId_","_curDate_","_curTime_","_passType
    .//s $p(^OEORD(mOrd,"I",mOrdItm,7),"^",3)=ordPassInfo
    .i passReasonData="" d
    ..s phaOrdMoList=..InsertPHAORDMONITORLIST(phaOrdMonitor, mOeori, 1, "", adm,"",doseDate)
    ..i +phaOrdMoList'>0 s errFlag=-1_"^插入子表失败" tro
    .e  d
    ..s prLen=$l(passReasonStr,"!!")
    ..s prI=""
    ..f prI=1:1:prLen q:errFlag'=""  d
    ...s passReason=$p(passReasonStr,"!!",prI)
    ...q:+passReason=0
    ...s phaOrdMoList=..InsertPHAORDMONITORLIST(phaOrdMonitor, mOeori, 1, "", adm,passReason,doseDate)
    ...i +phaOrdMoList'>0 s errFlag=-1_"^插入子表失败" tro
    .q:errFlag'=""
    .d ##class(web.DHCSTInterfaceMessage).SendAppealOrderMonitor(phaOrdMonitor, "Exec")
    .i passResult="N" d
    ..s msgRet=##class(web.DHCSTInterfaceMessage).SendRefuseOrderMonitor(phaOrdMonitor,"Send")
    .s statusCode = $s(passResult = "Y" : "PR", 1 : "RPR")
    .d ##class(web.DHCSTPIVAS.DataCenter).UpdateSystemStatus4OeAudit(statusCode, mOeori, userId, locId, "", "")
    i errFlag'="" tro  q errFlag
    tc
    q 0_"^"_"成功"
}

/// creator:    yunhaibao
/// createdate: 2017-12-01
/// description:按顺序插入医嘱审核表
/// return:<0-失败,否则返回rowid
ClassMethod InsertPHAORDMONITOR(PHAOMUserDr, PHAOMResult, PHAOMDate, PHAOMTime, PHAOMLocDr, PHAOMAppType, PHAOMPhNote, PHAOMMarkFlag = "")
{
    &sql(
        INSERT INTO DHC_PHAORDMONITOR  
        (PHAOM_User_Dr,PHAOM_Result,PHAOM_Date,PHAOM_Time,PHAOM_Loc_Dr,PHAOM_AppType,PHAOM_PhNote,PHAOM_MarkFlag)
        VALUES 
        (:PHAOMUserDr,:PHAOMResult,:PHAOMDate,:PHAOMTime,:PHAOMLocDr,:PHAOMAppType,:PHAOMPhNote,:PHAOMMarkFlag)
     )
     i SQLCODE'=0 s sqlRet=$$ErrorRecord^DHCSTERROR("Insert:DHC_PHAORDMONITOR","插入",SQLCODE_":"_%msg)
     q:SQLCODE'=0 -101
     q %ROWID
}

/// description: 按顺序插入医嘱审核表
/// creator:     yunhaibao
/// createdate:  2019-12-13
/// return:      <0-失败,否则返回rowid
ClassMethod UpdatePHAORDMONITOR(PHAOMROWID, PHAOMUserDr, PHAOMDate, PHAOMTime, PHAOMPhNote)
{
    &sql(
        UPDATE DHC_PHAORDMONITOR 
        SET  PHAOM_User_Dr=:PHAOMUserDr,PHAOM_Date=:PHAOMDate,PHAOM_Time=:PHAOMTime,PHAOM_PhNote=:PHAOMPhNote
        WHERE PHAOM_ROWID=:PHAOMROWID
     )
     i SQLCODE'=0 s sqlRet=$$ErrorRecord^DHCSTERROR("Insert:DHC_PHAORDMONITOR","插入",SQLCODE_":"_%msg)
     q:SQLCODE'=0 -101
     q %ROWID
}

/// creator:    yunhaibao
/// createdate: 2017-12-01
/// description:按顺序插入医嘱审核子表
/// return:<0-失败,否则返回rowid
ClassMethod InsertPHAORDMONITORLIST(PCTLPHAOMParRef, PCTLOrdItemDr, PCTLGrpNo, PCTLPrescNo, PCTLAdmDr, PCTLAuditReasonDr, PCTLDoseDate)
{
    s PCTLChildSub=+$o(^DHCPHORDM(PCTLPHAOMParRef,"I",""),-1)+1
    &sql(
        INSERT INTO DHC_PHAORDMONITORLIST  
        (PCTL_PHAOM_ParRef, PCTL_ChildSub,PCTL_OrdItem_Dr, PCTL_GrpNo, PCTL_PrescNo, PCTL_Adm_Dr,PCTL_AuditReason_Dr,PCTL_DoseDate)
        VALUES 
        (:PCTLPHAOMParRef,:PCTLChildSub, :PCTLOrdItemDr, :PCTLGrpNo, :PCTLPrescNo, :PCTLAdmDr,:PCTLAuditReasonDr,:PCTLDoseDate)
     )
     i SQLCODE'=0 s sqlRet=$$ErrorRecord^DHCSTERROR("Insert:DHC_PHAORDMONITORLIST","插入",SQLCODE_":"_%msg)
     q:SQLCODE'=0 -101
     q %ROWID
}

/// description: 配伍审核记录查询
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.OeAudit","OeAuditRecord","178||47-65611")
Query OeAuditRecord(dateMOeori = "") As websys.Query(ROWSPEC = "passResult,userName,dateTime,reasonDesc,docAgree,docNotes,oeoriStat,cancelUserName,cancelDateTime,passResultFlag") [ SqlProc ]
{
}

ClassMethod OeAuditRecordExecute(ByRef qHandle As %Binary, dateMOeori = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s oeori=$p(dateMOeori,"-",1)
    s doseDate=$p(dateMOeori,"-",2)
    q:(oeori="")||(doseDate="") $$$OK
    s mOeori=##class(web.DHCSTPIVAS.Common).GetMainOeori(oeori)
    q:'$d(^DHCPHORDM(0,"OrdItem",mOeori)) $$$OK
    s phaOrd=""
    f  s phaOrd=$o(^DHCPHORDM(0,"DateOrdItem",mOeori,doseDate,phaOrd),-1) q:phaOrd=""  d
    .q:+phaOrd=0
    .s DHCPHORDM=^DHCPHORDM(+phaOrd)
    .s phaOrdResult=$p(DHCPHORDM,"^",2)
    .q:phaOrdResult="D" // 药师标注不算
    .s phaOrdDate=$p(DHCPHORDM,"^",3)
    .i phaOrdDate'="" s phaOrdDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phaOrdDate)
    .s phaOrdTime=$p(DHCPHORDM,"^",4)
    .i phaOrdTime'="" s phaOrdTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(phaOrdTime)
    .s dateTime=phaOrdDate_" "_phaOrdTime
    .s userDr=$p(DHCPHORDM,"^",1)
    .s userName=##class(PHA.COM.Data.Base).UserName(userDr)
    .s phNotes=$p(^DHCPHORDM(phaOrd),"^",6)
    .s passResultStr=##class(web.DHCSTPIVAS.Common).GetPhaOrdResult(phaOrd)
    .s passResult=$p(passResultStr,"^",2)
    .s passResultFlag=$p(passResultStr,"^",4)
    .i phNotes["|@|" s phNotes=$p(phNotes,"|@|",3)
    .s phOrdReason=##class(web.DHCSTPIVAS.Common).GetOrdPassReason(phaOrd,"</br>")
    .i phNotes'="" s phOrdReason=phOrdReason_"</br>"_phNotes
    .s docNotes=$p(DHCPHORDM,"^",7)
    .s docAgree=$p(DHCPHORDM,"^",8)
    .S oeoriStat=##class(web.DHCSTPIVAS.Common).OeoriStat(mOeori) //医嘱状态
    .s oeoriStat=$p(oeoriStat,"^",2)
    .s (cancelUserName,cancelDateTime)=""
    .s cancelUser=$p(DHCPHORDM,"^",12)
    .s cancelDate=$p(DHCPHORDM,"^",13)
    .s cancelTime=$p(DHCPHORDM,"^",14)
    .i cancelUser'="" d
    ..s cancelUserName=##class(PHA.COM.Data.Base).UserName(cancelUser)
    ..i cancelDate'="" s cancelDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(cancelDate)
    ..i cancelTime'="" s cancelTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(cancelTime)
    ..s cancelDateTime=cancelDate_" "_cancelTime
    .i passResult'="" s passResult=..Translate(passResult)
    .i cancelUser'="" s passResult=passResult_"</br>" _..Translate("已取消") // @translate
    .s ^CacheTemp(repid,ind)=$lb(passResult,userName,dateTime,phOrdReason,docAgree,docNotes,oeoriStat,cancelUserName,cancelDateTime,passResultFlag) 
    .s ind=ind+1
    q $$$OK
}

/// description: 配伍审核-取消审核
/// w ##class(web.DHCSTPIVAS.OeAudit).CancelPivasPass("218||124-65068","711")
ClassMethod CancelPivasPass(dateMOeori, userId)
{
    s oeori=$p(dateMOeori,"-",1)
    s doseDate=$p(dateMOeori,"-",2)
    q:oeori="" "-1^医嘱Id为空"
    q:doseDate="" "-1^用药日期为空"
    q:userId="" "-1^登录用户为空"
    s curDate=+$h
    s curTime=$p($h,",",2)  
    s mOeori=##class(web.DHCSTPIVA).GetMainOeori(oeori)
    s phaOrdId=##class(web.DHCSTPIVAS.Common).GetValidPhaOrdId(mOeori,doseDate)
    q:phaOrdId="" "-1^尚未审核,不需要取消"
    s result=$p(^DHCPHORDM(phaOrdId),"^",2)
    q:result="" "-1^无审核意见标志"
    q:result="A" "-1^当前为医生申诉状态,无法取消,请操作审核"
    q:$p(^DHCPHORDM(phaOrdId),"^",8)="Y" "-1^当前为审核拒绝医生接受状态,无法取消"
    // 增加已发药判断,根据审核天数控制判断发药
    s recLocId=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),3),"^",6)
    s nurSeeTypeStr=##class(web.DHCSTPIVAS.Common).GetNurseSeeType(mOeori,recLocId)
    q:$p(nurSeeTypeStr,"^",1)="N" "-1^护士"_$p(nurSeeTypeStr,"^",3)_",无法操作"   // 护士处理
    s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",recLocId,"OeAudit","AuditTimes")
    s lastDate=##class(web.DHCSTPIVAS.Common).GetDoseDateByTimes(mOeori,auditTimes,recLocId)
    i doseDate>lastDate s doseDate=lastDate
    // 判断doseDate的发药数据,主医嘱即可
    s dispFlag=""
    s seqNo=""
    f  s seqNo=$o(^DHCOEDISQTY(0,"SEQNO",mOeori,doseDate,seqNo)) q:(seqNo="")||(dispFlag'="")  d
    .q:+seqNo=0
    .s dspId=""
    .f  s dspId=$o(^DHCOEDISQTY(0,"SEQNO",mOeori,doseDate,seqNo,dspId)) q:(dspId="")||(dispFlag'="")  d
    ..q:+dspId=0
    ..s dspData=^DHCOEDISQTY(dspId)
    ..s mOeore=$p(dspData,"^",3)
    ..q:##class(web.DHCSTPIVAS.Common).CheckOeoreStat(mOeore)'="1"
    ..s dspStatus=$p(dspData,"^",7)
    ..i dspStatus="C" s dispFlag=1
    q:dispFlag'="" "-1^需要取消的医嘱已发药"
    s admId=$p(^OEORD(+mOeori),"^",1)
    s errCode=""
    &SQL(
        UPDATE DHC_PHAORDMONITOR 
        SET PHAOM_CancelUser_Dr=:userId,PHAOM_CancelDate=:curDate,PHAOM_CancelTime=:curTime
        WHERE PHAOM_ROWID=:phaOrdId
    )
    i SQLCODE'=0 d
    .s errCode="-1^取消失败,SQLCODE:"_SQLCODE_$g(%msg)
    // 撤回消息
    d ##class(web.DHCSTInterfaceMessage).SendRefuseOrderMonitor(phaOrdId,"Exec")
    s phaOrdResult = $p($g(^DHCPHORDM(phaOrdId)), "^", 2)
    s statusCode = $case(phaOrdResult, "N" : "RPR" , "Y" : "PR", : "")
    i statusCode'="" d ##class(web.DHCSTPIVAS.DataCenter).UpdateSystemStatus4OeAudit(statusCode, mOeori, userId, recLocId, "", "CANCEL")

    q errCode
}

/// Description: 批量取消
ClassMethod CancelPivasPassMulti(DateMOeoriStr, UserId)
{
    q:DateMOeoriStr="" "-1^没有需要取消审核的记录"
    s errCode=""
    s len=$l(DateMOeoriStr,"^")
    s i=""
    f i=1:1:len d
    .s dateMOeori=$p(DateMOeoriStr,"^",i)
    .q:dateMOeori=""
    .s cancelRet=..CancelPivasPass(dateMOeori,UserId)
    .i $p(cancelRet,"^",1)<0 d
    ..s errInfo=$p(cancelRet,"^",2)
    ..i errCode="" s errCode="-1^"_errInfo
    ..e  s errCode=errCode_"</br>"_errInfo
    q:errCode'="" errCode
    q ""
}

/// description: 取消审核时给与界面的提示
ClassMethod GetCancelWarnInfo(dateMOeori)
{
    s mOeori=$p(dateMOeori,"-",1)
    s warnInfo=""
    s passOrdStatStr=##class(web.DHCSTPIVAS.Common).GetOrdPassState(mOeori)
    s passStat=$p(passOrdStatStr,"^",2)
    i passStat="" s passStat="未审核"
    s warnInfo="当前状态:"_passStat
    s firstDspId=$o(^DHCOEDISQTY(0,"OEORI",mOeori,""))
    q:firstDspId="" ""
    s recLocDr=$p(^DHCOEDISQTY(firstDspId),"^",24)
    k GetCancelWarnInfoArr
    s dspId=""
    f  s dspId=$o(^DHCOEDISQTY(0,"OEORI",mOeori,dspId)) q:dspId=""  d
    .q:+dspId=0
    .q:$p(^DHCOEDISQTY(dspId),"^",7)="R"
    .s grpNo=$p(^DHCOEDISQTY(dspId),"^",4)
    .i $d(^PIVABU(0,"OEGRP",dspId,grpNo)) s GetCancelWarnInfoArr("01:排批")=$g(GetCancelWarnInfoArr("01:排批"))+1
    .s pogId=$o(^PIVA(0,"OEGRP",dspId,grpNo,""))
    .i pogId'="" d
    ..s psNumber=""
    ..f  s psNumber=$o(^PIVAS(0,"FN","Y","N",psNumber)) q:psNumber=""  d
    ...q:+psNumber=0
    ...s psId=""
    ...f  s psId=$o(^PIVAS(0,"FN","Y","N",psNumber,psId)) q:psId=""  d
    ....s psLoc=$p(^PIVAS(psId),"^",7)
    ....q:psLoc'=recLocDr
    ....s psType=$p(^PIVAS(psId),"^",9)
    ....q:psType'="I"
    ....s psName=$p(^PIVAS(psId),"^",2)
    ....s sortIndex=psNumber_":"_psName
    ....i $d(^PIVA(0,"PS",psId,pogId)) s GetCancelWarnInfoArr(sortIndex)=$g(GetCancelWarnInfoArr(sortIndex))+1
    s sortIndex=""
    f  s sortIndex=$o(GetCancelWarnInfoArr(sortIndex)) q:sortIndex=""  d
    .s warnNum=$p(sortIndex,":",2)_"次数:"_+GetCancelWarnInfoArr(sortIndex)
    .s warnInfo=warnInfo_"^"_warnNum
    q warnInfo
}

/// description: 清除查询的所有数据明细
ClassMethod KillOeAudit(pid)
{
    q:pid="" ""
    k ^TMP("DHCST","web.DHCSTPIVAS.OeAudit","CollectOeAudit","GetOeAuditDetail",pid)
    q ""
}

ClassMethod NewPid() As %String
{
    Q ##class(web.DHCSTKUTIL).NewPid($this,"PIVA")
}

ClassMethod GetOeoriDrugsHtml(MOeori, Loc)
{
    s drugs=""
    s oeoriStr=##class(web.DHCSTPIVAS.Common).GetOeoriStrOrderByMP(MOeori,Loc)
    s oeoriLen=$l(oeoriStr,"^")
    f i=1:1:oeoriLen d
    .s oeori=$p(oeoriStr,"^",i)
    .s incStr=##class(web.DHCSTPIVAS.Common).GetIncItmByOeori(oeori)
    .s incId=$p(incStr,"^",1)
    .q:incId=""
    .s incDesc=$P(incStr,"^",3) 
    .s incSpec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",incId)
    .s dosage=##class(web.DHCSTPIVAS.Common).OeoriDosage(oeori)
    .s leftColor="#019BC1"
    .s priDesc=$p(##class(web.DHCSTPIVAS.Common).OeoriPriority(oeori),"^",3)  
    .i (priDesc["自备")||(priDesc["嘱托") s leftColor="#ff584c"
    .e  i priDesc["临时" s leftColor="#ffba42"
    .s incDesc="<div style='width:125px;overflow:hidden;float:left;border-left:5px solid "_leftColor_";padding-left:5px'>"_incDesc_"</div>"
    .s dosage="<div style=width:50px;overflow:hidden;float:left;padding-left:10px>"_dosage_"</div>"
    .s iDrug="<div style=float:left;padding-left:10px;>"_incDesc_dosage_"</div>"
    .i drugs="" s drugs=iDrug
    .e  s drugs=drugs_iDrug
    q drugs
}

/// Description: 配伍审核-药师标注,单独方法方便处理,不判断日期,直接对医嘱
/// Creator:     yunhaibao
/// Createdate:  2019-12-13
/// Input:   
/// Debug:       w ##class(web.DHCSTPIVAS.OeAudit).PivasRemark("34||68-65359","711","你真的")
ClassMethod PivasRemark(dateMOeoriStr, userId, ordRemark, exeRemark, labelRemark)
{
    s mOeori = $p(dateMOeoriStr, "-", 1)
    ts
    s ret = ##class(web.DHCSTPIVAS.Remark).Save("PIVASOrder", mOeori, ordRemark, userId)
    if (+ret < 0){
        tro
        q ret
    }
    s ret = ##class(web.DHCSTPIVAS.Remark).Save("PIVASExecute", mOeori, exeRemark, userId)
    if (+ret < 0){
        tro
        q ret
    }
    s ret = ##class(web.DHCSTPIVAS.Remark).Save("PIVASLabel", mOeori, labelRemark, userId)
    if (+ret < 0){
        tro
        q ret
    }
    tc
    q "0^成功"
}

ClassMethod GetPivasRemark(dateMOeoriStr)
{
    s mOeori = $p(dateMOeoriStr, "-", 1)
    q {
        "orderRemark": (##class(web.DHCSTPIVAS.Remark).Get("PIVASOrder", mOeori)),
        "executeRemark": (##class(web.DHCSTPIVAS.Remark).Get("PIVASExecute", mOeori)),
        "labelRemark": (##class(web.DHCSTPIVAS.Remark).Get("PIVASLabel", mOeori))
    }.%ToJSON()
}

/// Description: 结合前台warnFlag列的提醒
ClassMethod WarnFlagInfoHtml(dateMOeori)
{
    q:'$d(%session) ""
    s locId=%session.Data("LOGON.CTLOCID")
    q:dateMOeori="" ""
    s mOeori=$p(dateMOeori,"-",1)
    s mOeoriDate=$p(dateMOeori,"-",2)
    s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",locId,"OeAudit","AuditTimes")
    s passResultStr=##Class(web.DHCSTPIVAS.Common).GetOrdPassState(mOeori,mOeoriDate,auditTimes,locId)
    s passResultDesc=$p(passResultStr,"^",2)
    s phaOrd=$p(passResultStr,"^",3)
    s passResult=$p(passResultStr,"^",4)
    s passResultStat=$p(passResultStr,"^",1)
    //s labelSign="<div style='height:14px;margin-top: 3px;border-left:5px solid #007ACF;float:left;'></div>"
    s retHtml=""
    i phaOrd'="" d
    .s DHCPHORDM=$g(^DHCPHORDM(phaOrd))
    .i passResult["A" d
    ..s phaDocNote=$p(DHCPHORDM,"^",7)
    ..s retHtml="<div><b>"_passResultDesc_"：</b><span style='padding-left:5px'>"_phaDocNote_"</span>"   
    s phaOrdRemark=$p(..GetPhaOrdRemark(mOeori),"^",2)  
    i phaOrdRemark'="" d
    .s retHtml=retHtml_"<div><b>药师标注：</b><span style='padding-left:5px'>"_phaOrdRemark_"</span>"
    q retHtml
}

/// Description: 表格操作更新返回值
/// w ##class(web.DHCSTPIVAS.OeAudit).GetRowData("5522||178")
ClassMethod GetRowData(dateMOeori)
{
    q:'$d(%session) ""
    s locId = %session.Data("LOGON.CTLOCID")
    s mOeori=$p(dateMOeori,"-",1)
    s mOeoriDate=$p(dateMOeori,"-",2)
    s ret = {}
    s phaRemark = ##class(web.DHCSTPIVAS.Remark).Get("PIVASOrder", mOeori)
    s exeRemark = ##class(web.DHCSTPIVAS.Remark).Get("PIVASExecute", mOeori)
    s labelRemark = ##class(web.DHCSTPIVAS.Remark).Get("PIVASLabel", mOeori)
    s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",locId,"OeAudit","AuditTimes")
    s passResultStr=##Class(web.DHCSTPIVAS.Common).GetOrdPassState(mOeori,mOeoriDate,auditTimes,locId)
    s passResultDesc=$p(passResultStr,"^",2)
    s phaOrd=$p(passResultStr,"^",3)
    s passResult=$p(passResultStr,"^",4)
    s passResultStat=$p(passResultStr,"^",1)
    if (exeRemark '= ""){
        s phaRemark = $s(phaRemark = "" : exeRemark , 1 : phaRemark _ "</br>" _ exeRemark)
    }
    if (labelRemark '= ""){
        s phaRemark = $s(phaRemark = "" : labelRemark , 1 : phaRemark _ "</br>" _ labelRemark)
    }
    s ret.phaOrdRemark = phaRemark
    s ret.passResultDesc = passResultDesc
    s ret.passResult = passResult
    s ret.passResultStat = passResultStat
    q ret.%ToJSON()
}

/// Description: 取病区病人树形结构数据
/// Return:      Json Str
/// w ##class(web.DHCSTPIVAS.BatUpdateNew).GetPatTreeData()
ClassMethod GetPatTreeData(pJsonStr = "{}")
{
    s retJson = []
    d ..Collect(pJsonStr, .collectData)
    k calcData, calcCntData
    
    s wardLoc = ""
    for {
        s wardLoc = $o(collectData(wardLoc))
        q:(wardLoc = "")
        s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, 0))
        s wardDesc = ##class(PHA.PIVAS.Data.Base).LocDesc(wardLoc)
        s mOeori = ""
        for {
            s mOeori = $o(collectData(wardLoc, mOeori))
            q:(mOeori = "")
            s adm = $p(^OEORD(+mOeori), "^", 1)
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
            
            k collectData(wardLoc, mOeori)      
        }
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

}
