/// Decription: 排批算法
Class web.DHCSTPIVAS.Data.Batch Extends web.DHCSTPIVAS.Common
{

/// 进程号 - 暂不用
Property pid [ InitialExpression = {$j} ];

/// 静配中心
Property loc;

/// 所在病区
Property ward;

/// 病人ID
Property pat;

/// 用药记录
Property mDspDimData [ MultiDimensional ];

/// 用药记录 - 规则排序后
Property sortDimData [ MultiDimensional ];

/// 容积规则
Property cubageDimData [ MultiDimensional ];

/// 可移动批次相关信息以及液体量
Property batDimData [ MultiDimensional ];

/// 记录排序节点
Property mDspSortDimData [ MultiDimensional ];

/// 已确定批次
Property finalDimData [ MultiDimensional ];

/// 不需要参与容积规则
Property decludeLiquidDimData [ MultiDimensional ];

/// 是否参照昨日
Property paramReferBefore;

/// Y - 优先大液体量, N - 优先小液体量
Property paramCubFlag;

/// 超上限是否移动规则为本批, Y - 归本批, N - 归下批
Property paramConFlag;

/// 上移批次分组
Property paramBatNoGroupDimData [ MultiDimensional ];

/// 频次可上移或者下移的配置
Property paramFreqFlagDimData [ MultiDimensional ];

/// 首批批次名称
Property firstBatNo;

/// Description: 
/// w ##class(web.DHCSTPIVAS.Data.Batch).Test(143497)
ClassMethod Test(mDsp)
{
    s calcMoveData(174956)=""
    s calcMoveData(174957)=""
    s calcMoveData(174958)=""
    s calcMoveData(176356)=""
    s calcMoveData(176359)=""
    
    s obj = ..%New()
    s obj.loc = 89
    merge obj.mDspDimData = calcMoveData
    d obj.Calc(.finalBatchData)
    zw finalBatchData
    q ""
}

/// Description: 移动批次
Method Calc(Output finalBatchData)
{
    s dsp = $o(..mDspDimData(""))
    s wardLoc = $p(^DHCOEDISQTY(dsp), "^", 22)
    s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, ""))
    s ..ward = ward
    d ..SetParam()
    d ..SortMDsp()
    d ..Move()
    d ..SetFinal()
    merge finalBatchData = ..finalDimData
}

Method SetParam()
{
    s other = $o(^PIVAOTHR(0, "Loc", ..loc, ""), -1)
    s otherData = $g(^PIVAOTHR(+other))
    s ..paramCubFlag = $p(otherData, "^", 1)
    s ..paramConFlag = $p(otherData, "^", 2)
    s ..paramReferBefore = ##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", ..loc, "BatUpdate", "ReferBeforeBat")
    s batNoGroup = ##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", ..loc, "Com", "BatNoGroup")
    d ##class(web.DHCSTPIVAS.Data.Batch).ConnactStrToDimData(batNoGroup, .paramBatNoGroupDimData)
    merge ..paramBatNoGroupDimData=paramBatNoGroupDimData
}

/// Description: 移动批次都是从1批开始连续往后,知道某批结束,一般限于上午批
Method Move()
{
    d ..SetBatDict()
    d ..SetCubageRule(..loc, ..ward)
    d ..SetFreqFlagData(..loc)
    q:('$d(..cubageDimData)) 
    s batNoIndex = ""
    for {
        s batNoIndex = $o(..batDimData(batNoIndex))
        q:(batNoIndex = "")
        s batNo = ..batDimData(batNoIndex)
        s cubageData = $g(..cubageDimData(batNo))
        s cubageMin = $lg(cubageData, 1)
        s cubageMax = $lg(cubageData, 2)    
        s batLiquid = +$g(..sortDimData(batNo))
        if (batLiquid < cubageMin){
            // 低于下限 - 后续批次上移
            d ..MoveUp(batNo, batLiquid, cubageMin, cubageMax)
        }
        if (batLiquid > cubageMax) {
            // 高于上限 - 下移
            s nextIndex = $o(..batDimData(batNoIndex))
            q:(nextIndex = "")
            s nextBatNo = ..batDimData(nextIndex)
            d ..MoveDown(batNo, nextBatNo, batLiquid, cubageMin, cubageMax)
        }
    }
    q
}

/// Description: 定最终批次
Method SetFinal()
{
    s batNo = ""
    for {
        s batNo = $o(..sortDimData(batNo))
        q:(batNo = "")
        s sort = ""
        for {
            s sort = $o(..sortDimData(batNo, sort))
            q:(sort = "")
            s mDsp = ""
            for {
                s mDsp = $o(..sortDimData(batNo, sort, mDsp))
                q:(mDsp = "")
                continue:($d(..finalDimData(mDsp)))
                s ..finalDimData(mDsp) = $lb(batNo)
            }
        }
    }
    s mDsp = ""
    for {
        s mDsp = $o(..finalDimData(mDsp))
        q:(mDsp = "")
        s $list(..finalDimData(mDsp), 2) = $g(..mDspSortDimData(mDsp))
    }
}

/// Description: 上移, 下批正序, 满足下限即停止, 遍历后续批次向本批次移动
Method MoveUp(curBatNo, curBatLiquid, cubageMin, cubageMax)
{
    s quitFlag = ""
    s patBatNo = curBatNo
    q:('$d(..paramBatNoGroupDimData(curBatNo))) "药库参数设置中, 未定义上移批次分组不能处理上移"
    for {
        q:(quitFlag '= "")
        s patBatNo = $o(..sortDimData(patBatNo))
        q:(patBatNo = "")
        if ($d(..paramBatNoGroupDimData(patBatNo), batGroupList)){
            continue:($lf(batGroupList, curBatNo) = 0) 
        }else{
            continue
        }
        s batLiquid = ..sortDimData(patBatNo)
        s sort = ""
        for {
            q:(quitFlag '= "")
            s sort = $o(..sortDimData(patBatNo, sort))
            q:(sort = "")
            continue:(sort [ "0F") // 已确定批次
            s mDsp = ""
            for {
                q:(quitFlag '= "")
                s mDsp = $o(..sortDimData(patBatNo, sort, mDsp))
                q:(mDsp = "")
                continue:($d(..finalDimData(mDsp)))
                continue:(##class(web.DHCSTPIVAS.Data.Batch).HasOrderPassedBatEndTime(mDsp, curBatNo) = $$$YES)
                s oeori = $p(^DHCOEDISQTY(mDsp), "^", 1)
                s freq = $p($g(^OEORD(+oeori, "I", +$p(oeori, "||", 2), 2)), "^", 4)
                s freqFlagList = $g(..paramFreqFlagDimData(freq))
                continue:($lg(freqFlagList, 1) '= $$$YES)
                s liquid = ..sortDimData(patBatNo, sort, mDsp)
                s afterBatLiquid = curBatLiquid + liquid
                
                /* 大于上限, 直接退出 */
                if (afterBatLiquid >= cubageMax) {
                    s quitFlag = "Y"
                    q
                }
                
                /* 增加到移动后的批次 */
                s ..sortDimData(curBatNo) = $g(..sortDimData(curBatNo)) + liquid
                s ..sortDimData(curBatNo, sort, mDsp) = liquid
                s curBatLiquid = afterBatLiquid 
                
                /* 删除原数据 */
                s ..sortDimData(patBatNo) = $g(..sortDimData(patBatNo)) - liquid
                k ..sortDimData(patBatNo, sort, mDsp)
                
                /* 移动完超过下限, 退出 */
                if (afterBatLiquid >= cubageMin) {
                    s quitFlag = "Y"
                }
            }
        }
    }
}

/// Description: 下移, 本批倒序, 外层正序循环, 因此仅移动到下一批
Method MoveDown(curBatNo, nextBatNo, curBatLiquid, cubageMin, cubageMax)
{
    s quitFlag = ""
    q:'$d(..sortDimData(curBatNo))
    s sort = ""
    for {
        q:(quitFlag '= "")
        s sort = $o(..sortDimData(curBatNo, sort), -1)
        q:(sort = "")
        continue:(sort [ "0F") // 已确定批次
        s mDsp = ""
        for {
            q:(quitFlag '= "")
            s mDsp = $o(..sortDimData(curBatNo, sort, mDsp), -1)
            q:(mDsp = "")
            continue:($d(..finalDimData(mDsp)))
            s oeori = $p(^DHCOEDISQTY(mDsp), "^", 1)
            s freq = $p($g(^OEORD(+oeori, "I", +$p(oeori, "||", 2), 2)), "^", 4)
            s freqFlagList = $g(..paramFreqFlagDimData(freq))
            continue:($lg(freqFlagList, 2) '= $$$YES)
            s liquid = ..sortDimData(curBatNo, sort, mDsp)
            s afterBatLiquid = curBatLiquid - liquid
            /* 已减至小于上限, 退出 */
            if (afterBatLiquid <= cubageMax)&&(curBatLiquid <= cubageMax) {
                s quitFlag = "Y"
                q
            }
            
            /* 是否归到本批 */
            if (..paramConFlag = "Y")||(..IsBatLastOrder(curBatNo) = "Y") { // 归本批占下批
                if (afterBatLiquid < cubageMax) {
                    s minusLiquid = curBatLiquid - cubageMax
                    s $list(..cubageDimData(nextBatNo), 2) = $list(..cubageDimData(nextBatNo), 2) - minusLiquid
                    s quitFlag = "Y"
                }
            }
            q:(quitFlag '= "")
            
            /* 增加到移动后的批次 */
            s ..sortDimData(nextBatNo) = $g(..sortDimData(nextBatNo)) + liquid
            s ..sortDimData(nextBatNo, sort, mDsp) = liquid
            s curBatLiquid = afterBatLiquid 

            /* 删除原数据 */
            s ..sortDimData(curBatNo) = $g(..sortDimData(curBatNo)) - liquid
            k ..sortDimData(curBatNo, sort, mDsp)
        }
    }
}

/// Description: 判断是否为1批最后一组药
/// Return:      Y - 是, N - 否
Method IsBatLastOrder(curBatNo)
{
    s cnt = 0
    q:(curBatNo '= ..firstBatNo) "N"
    s sort = ""
    for {
        s sort = $o(..sortDimData(curBatNo, sort))
        q:(sort = "")
        q:(cnt>1)
        s mDsp = ""
        for {
            s mDsp = $o(..sortDimData(curBatNo, sort, mDsp))
            q:(mDsp = "")
            q:(cnt>1)
            s cnt = cnt + 1
        }
    }
    q:(cnt>1) "N"
    q "Y"
}

/// Description: 按顺序排序
Method SortMDsp()
{
    s mDsp = ""
    for {
        s mDsp = $o(..mDspDimData(mDsp))
        q:(mDsp = "")
        s batNo = ..GetBat(mDsp)
        continue:(batNo = "")
        s sort = ..GetSort(mDsp)
        s mOeore = $p($g(^DHCOEDISQTY(mDsp)), "^", 3)
        s liquid = $s('$d(..decludeLiquidDimData(mDsp)) : ..OrderLiquid(, mOeore) , 1 : 0)
        s ..sortDimData(batNo) = $g(..sortDimData(batNo)) + liquid
        s ..sortDimData(batNo, sort, mDsp) = liquid
        
        s ..mDspSortDimData(mDsp) = sort
        
    }
}

/// Description: 获取排序节点
Method GetSort(mDsp)
{
    s fixOrder= ..GetFixOrder(mDsp)
    s freqOrder = ..GetFreqOrder(mDsp)
    s inciOrder = ..GetInciBatOrder(mDsp)
    s liquidOrder = ..GetLiquidOrder(mDsp)
    s sortOrder = ..GetSortBatOrder(mDsp)
    s ret = $lb(fixOrder, inciOrder, sortOrder, liquidOrder, freqOrder) // inciOrder 不再用, 顺序使用 GetSortBatOrder, 2021-12-03, yunhaibao
    q $lts(ret)
}

/// Description: 获取批次
/// 
Method GetBat(mDsp)
{
    /* 人为修改或已排批 */
    s batNo = ..GetUpdatedBat(mDsp)
    if (batNo '= "") {
        s ..finalDimData(mDsp) = $lb(batNo)
        q batNo
    }
    
    /* 参照昨日 */
    if ..paramReferBefore = "Y" {
        s batNo = ..GetBeforeBat(mDsp)
        if (batNo '= "") {
            s ..finalDimData(mDsp) = $lb(batNo)
            q batNo
        }
    }
    q:(batNo '= "") batNo
    
    /* 固定批次 */
    s batNo = ..GetInstrFixedBat(mDsp)
    if (batNo '= "") {
        s ..finalDimData(mDsp) = $lb(batNo)
        q batNo
    }
    s batNo = ..GetInciFixedBat(mDsp)
    if (batNo '= "") {
        s ..finalDimData(mDsp) = $lb(batNo)
        q batNo
    }   
    s batNo = ..GetOrdLinkFixedBat(mDsp)
    if (batNo '= "") {
        s ..finalDimData(mDsp) = $lb(batNo)
        q batNo
    }   
    /* 时间规则批次 */
    s batNo = ..GetTimeBat(mDsp)
    q batNo
}

/// Description: 已修改的批次
Method GetUpdatedBat(mDsp)
{
    q:(mDsp = "") ""
    s grpNo = $p(^DHCOEDISQTY(mDsp), "^", 4)
    s pbu = $o(^PIVABU(0, "OEGRP", mDsp, grpNo, ""), -1)
    q:(pbu = "") ""
    q $p(^PIVABU(pbu), "^", 3)
}

/// Description: 昨日相同用药时间的批次
/// Modify:      2023-03-14, yunhaibao, 按执行记录匹配要求分发时间参照昨日
Method GetBeforeBat(mDsp)
{
    q:(mDsp = "") ""
    s mDspData = $g(^DHCOEDISQTY(mDsp))
    s mOeore = $p(mDspData, "^", 3)
    s ord = +mOeore, ordItm = +$p(mOeore, "||", 2), ordExe = +$p(mOeore, "||", 3)
    s mOeoreData = $g(^OEORD(ord, "I", ordItm, "X", ordExe))
    s doseDate = $p(mOeoreData, "^", 1)
    s doseTime = $p(mOeoreData, "^", 2)
    s lastDoseDate = $o(^OEORDi(0, "Date", ord, doseDate), -1)
    q:(lastDoseDate = "") ""
    s lastOrdExe = $o(^OEORDi(0, "Date", ord, lastDoseDate, +doseTime, ordItm, ""))
    q:(lastOrdExe = "") ""
    s lastDsp = $o(^DHCOEDISQTY(0, "OEORE", ord _ "||" _ ordItm _ "||" _ lastOrdExe, ""))
    q:(lastDsp = "") ""
    s pog = $o(^PIVA(0, "DSP", lastDsp, 0))
    q:(pog = "") ""
    q $p($g(^PIVA(pog)), "^", 3)
}

/// Description: 用法固定批次, 先取病区, 再取院区
Method GetInstrFixedBat(mDsp)
{
    s batNo = ""
    s mDspData = $g(^DHCOEDISQTY(mDsp))
    s oeori = $p(mDspData, "^", 1)
    s instr = $p($g(^OEORD(+oeori, "I", +$p(oeori, "||", 2), 2)), "^", 7)
    
    /* 先按病区取 */
    s wardLoc = $p($g(^DHCOEDISQTY(mDsp)), "^", 22)
    s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc , ""))
    s plbat = $o(^PIVALBAT(0,"LocWard", ..loc, ward, ""))
    if (plbat '= "") {
        if $d(^PIVALBAT(0, "Instr", plbat, "FIX")) {
            s sub = $o(^PIVALBAT(0, "Instr", plbat, "FIX", instr, ""))
            if (sub '= "") {
                s batNo = $p($g(^PIVALBAT(plbat, "Itm", sub)), "^", 3)
            }
        }
    }
    q:(batNo '= "") batNo
    
    /* 再按配液中心取 */
    s plbat = $o(^PIVALBAT(0,"Loc", ..loc, ""))
    if (plbat '= "") {
        s sub = $o(^PIVALBAT(0, "Instr", plbat, "FIX", instr, ""))
        if (sub '= "") {
            s batNo = $p($g(^PIVALBAT(plbat, "Itm", sub)), "^", 3)
        }
    }   
    q batNo
}

/// Description: 药品固定批次, 先取病区, 再取院区, 取批次靠前
Method GetInciFixedBat(mDsp)
{
    k calcData
    s batNo = ""
    s mDspData = $g(^DHCOEDISQTY(mDsp))
    s mOeori = $p(mDspData, "^", 1)
    s oeori = mOeori
    d CalcInciFixedBat
    s itm = ""
    for {
        s itm = $o(^OEORDi(0, "OEORI", +mOeori, mOeori, itm))
        q:(itm = "")
        s oeori = +mOeori _ "||" _ itm
        d CalcInciFixedBat  
    }
    q $o(calcData(""))
CalcInciFixedBat
    s arcim = $p($g(^OEORD(+oeori, "I", $p(oeori, "||", 2), 1)), "^", 2)
    s inci = $o(^INCI(0, "ARCIM_DR", +arcim, ""))
    q:(inci = "")
    /* 先按病区取 */
    s wardLoc = $p($g(^DHCOEDISQTY(mDsp)), "^", 22)
    s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc , ""))
    s plbat = $o(^PIVALBAT(0,"LocWard", ..loc, ward, ""))
    if (plbat '= "") {
        if $d(^PIVALBAT(0, "Inci", plbat, "FIX")) {
            s sub = $o(^PIVALBAT(0, "Inci",plbat, "FIX", inci, ""))
            if (sub '= "") {
                s batNo = $p($g(^PIVALBAT(plbat, "Itm", sub)), "^", 3)
                s calcData(batNo) = ""
            }
        }
    }
    q:(batNo '= "")
    /* 再按配液中心取 */
    s plbat = $o(^PIVALBAT(0,"Loc", ..loc, ""))
    if (plbat '= "") {
        s sub = $o(^PIVALBAT(0, "Inci",plbat, "FIX", inci, ""))
        if (sub '= "") {
            s batNo = $p($g(^PIVALBAT(plbat, "Itm", sub)), "^", 3)
            s calcData(batNo) = ""
        }
    }
    q
}

/// Description: 配液大类固定批次, 先取病区, 再取院区
Method GetOrdLinkFixedBat(mDsp)
{
    s batNo = ""
    s mDspData = $g(^DHCOEDISQTY(mDsp))
    s oeori = $p(mDspData, "^", 1)
    s ordLink = $p(##class(web.DHCSTPIVAS.Common).GetOrdPivaCat(oeori), "^", 1)
    q:(ordLink = "") ""
    
    /* 先按病区取 */
    s wardLoc = $p($g(^DHCOEDISQTY(mDsp)), "^", 22)
    s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc , ""))
    s plbat = $o(^PIVALBAT(0,"LocWard", ..loc, ward, ""))
    d ComGetOrdLinkFixedBat
    q:(batNo '= "") batNo

    /* 再按配液中心取 */
    s plbat = $o(^PIVALBAT(0,"Loc", ..loc, ""))
    d ComGetOrdLinkFixedBat
    q batNo
ComGetOrdLinkFixedBat
    if (plbat '= "") {
        s sub = $o(^PIVALBAT(0, "OrdLink", plbat, "FIX", ordLink, ""))
        if (sub '= "") {
            s subData = $g(^PIVALBAT(plbat, "Itm", sub))
            s batNo = $p(subData, "^", 3)
            if ($p(subData, "^", 11) = $$$NO){
                s ..decludeLiquidDimData(mDsp) = $$$YES
            }
        }
    }
    q
}

/// Description: 获取药品顺序规则, 取优先级最高, 要么按病区, 要么按院区
Method GetInciBatOrder(mDsp)
{
    k calcData
    s batNo = ""
    s mDspData = $g(^DHCOEDISQTY(mDsp))
    s mOeori = $p(mDspData, "^", 1)
    s oeori = mOeori
    d CalcInciBatOrder
    s itm = ""
    for {
        s itm = $o(^OEORDi(0, "OEORI", +mOeori, mOeori, itm))
        q:(itm = "")
        s oeori = +mOeori _ "||" _ itm
        d CalcInciBatOrder  
    }
    s ordCode = $o(calcData(""))
    q:(ordCode '= "") ordCode
    q 999999
CalcInciBatOrder
    s arcim = $p($g(^OEORD(+oeori, "I", $p(oeori, "||", 2), 1)), "^", 2)
    s inci = $o(^INCI(0, "ARCIM_DR", +arcim, ""))
    q:(inci = "")
    s quitFlag = ""
    /* 先按病区取 */
    s wardLoc = $p($g(^DHCOEDISQTY(mDsp)), "^", 22)
    s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc , ""))
    s plbat = $o(^PIVALBAT(0,"LocWard", ..loc, ward, ""))
    if (plbat '= "") {
        if $d(^PIVALBAT(0, "Inci", plbat, "ORDER")) {
            s quitFlag = "Y"
            s sub = $o(^PIVALBAT(0, "Inci",plbat, "ORDER", inci, ""))
            if (sub '= "") {
                s ordCode = +$p($g(^PIVALBAT(plbat, "Itm", sub)), "^", 4)
                if (ordCode = 0) {
                    s ordCode = 99999
                }
                s ordCode = ordCode + 100000
                s calcData(ordCode) = ""
            }
        }
    }
    q:(quitFlag '= "")
    
    /* 再按配液中心取 */
    s plbat = $o(^PIVALBAT(0,"Loc", ..loc, ""))
    if (plbat '= "") {
        s sub = $o(^PIVALBAT(0, "Inci", plbat, "ORDER", inci, ""))
        if (sub '= "") {
            s ordCode = +$p($g(^PIVALBAT(plbat, "Itm", sub)), "^", 4)
            if (ordCode = 0) {
                s ordCode = 99999
            }
            s ordCode = ordCode + 100000
            s calcData(ordCode) = ""
        }
    }
    q
}

/// Description: 获取顺序规则, 取优先级最高, 药品>小类, 病区>院区
Method GetSortBatOrder(mDsp)
{
    k calcData
    s batNo = ""
    s mDspData = $g(^DHCOEDISQTY(mDsp))
    s mOeori = $p(mDspData, "^", 1)
    s oeori = mOeori
    s factor = 100000
    d CalcSortBatOrder
    s itm = ""
    for {
        s itm = $o(^OEORDi(0, "OEORI", +mOeori, mOeori, itm))
        q:(itm = "")
        s oeori = +mOeori _ "||" _ itm
        d CalcSortBatOrder  
    }
    s ordCode = $o(calcData(""))
    q:(ordCode '= "") ordCode
    q 999999
CalcSortBatOrder
    s arcim = $p($g(^OEORD(+oeori, "I", $p(oeori, "||", 2), 1)), "^", 2)
    s inci = $o(^INCI(0, "ARCIM_DR", +arcim, ""))
    q:(inci = "")
    s quitFlag = ""
    
    s wardLoc = $p($g(^DHCOEDISQTY(mDsp)), "^", 22)
    s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc , ""))
    /* 先按病区取 */
    s plbat = $o(^PIVALBAT(0, "LocWard", ..loc, ward, ""))
    if (plbat '= "")&&($o(^PIVALBAT(plbat, "Sort", ""), -1) > 0){
        d GetSortCode
    }else{
        /* 再按配液中心取 */
        s plbat = $o(^PIVALBAT(0, "Loc", ..loc, ""))
        if (plbat '= "")&&($o(^PIVALBAT(plbat, "Sort", ""), -1) > 0){
        d GetSortCode   
        }   
    }
    q
GetSortCode
    s phcdf = $p(^ARCIM(+arcim, +$p(arcim, "||", 2), 1), "^", 12)
    s cat = $p($g(^PHCD(+phcdf, "DF", +$p(phcdf, "||", 2), "DHC")), "^", 24)
    s sortCode = 99999 + factor
    s calcData(sortCode) = ""
    
    s sortSub = $o(^PIVALBAT(0, "TypePointer", plbat, "User.INCItm", inci, 0))
    if (sortSub '= ""){
        s sortCode = $p($g(^PIVALBAT(plbat, "Sort", sortSub)), "^", 3) + factor
        s calcData(sortCode) = ""
    }
    s sortSub = $o(^PIVALBAT(0, "TypePointer", plbat, "User.DHCPHCPivaCat", +cat, 0))
    if (sortSub '= ""){
        s sortCode = $p($g(^PIVALBAT(plbat, "Sort", sortSub)), "^", 3) + factor
        s calcData(sortCode) = ""
    }
    q
}

Method GetFixOrder(mDsp)
{
    q:$d(..finalDimData(mDsp)) "0F"
    q "1O"
}

Method GetFreqOrder(mDsp)
{
    s mOeori = $p($g(^DHCOEDISQTY(mDsp)), "^", 1)
    s freq = $p($g(^OEORD(+mOeori, "I", +$p(mOeori, "||", 2), 2)), "^", 4)
    s pfr = $o(^PIVAFREQR(0,"Freq", ..loc, freq, ""))
    s freqOrder = +$p($g(^PIVAFREQR(+pfr)), "^", 2) + 10000 // 没维护的优先级在前边, 因为不能移动
    q freqOrder
}

Method GetLiquidOrder(mDsp)
{
    s mDspData = $g(^DHCOEDISQTY(mDsp))
    s mOeore = $p(mDspData, "^", 3)
    s liquid = $s('$d(..decludeLiquidDimData(mDsp)) : ..OrderLiquid(, mOeore) , 1 : 0)
    if (..paramCubFlag = "Y") {     // 优先大液体量
        s liquid = 100000 - liquid
    } else {                        // 优先小液体量
        s liquid = 100000 + liquid
    }
    q liquid
}

/// Description: 时间规则批次
/// w ##class(web.DHCSTPIVAS.Data.Batch).%New().GetTimeBat(9501)
/// w a.GetTimeBat(69752)
Method GetTimeBat(mDsp)
{
    s mDspData = $g(^DHCOEDISQTY(mDsp))
    s grpNo = $p(mDspData, "^", 4)
    s mOeori = $p(mDspData, "^", 1)
    s recLoc = $p(mDspData, "^", 24)
    s doseTime = $p(mDspData, "^", 20)
    s wardLoc = $p(mDspData, "^", 22)
    s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, ""))
    s pri = $p($g(^OEORD(+mOeori, "I", +$p(mOeori,"||",2), 1)), "^", 8)
    s seqFlag = ..OrdSeqFlag(mOeori)
    s batNo = ""
    for {
        s batNo = $o(^PIVABT(0, "BatNo", recLoc, batNo))
        q:(batNo = "")
        s pbt = ""
        for {
            s pbt = $o(^PIVABT(0, "BatNo", recLoc, batNo, pbt))
            q:(pbt = "")
            s pbtData = $g(^PIVABT(pbt))
            s pbtSeq = $p(pbtData,"^",5)
            continue:(seqFlag '= "")&&(pbtSeq '= "")&&(seqFlag '= $p(pbtData,"^",5))
            s fromTime = $p(pbtData,"^",1)
            s toTime = $p(pbtData,"^",2)
            continue:(doseTime < fromTime)||(doseTime > toTime)
            s ptbWard = +$p(pbtData, "^", 6)
            s ptbPri = +$p(pbtData, "^", 8)
            s calcData($lb(recLoc, ptbWard, ptbPri)) = batNo
        }
    }
    s batNo = $g(calcData($lb(recLoc, +ward, +pri))) 
    q:(batNo '= "") batNo
    s batNo = $g(calcData($lb(recLoc, 0, +pri))) 
    q:(batNo '= "") batNo
    s batNo = $g(calcData($lb(recLoc, 0, 0))) 
    q:(batNo '= "") batNo   
    q batNo
}

/// Description: 容积规则
/// w ##class(web.DHCSTPIVAS.Data.Batch).GetCubageRule(248,3)
Method SetCubageRule(loc, ward)
{
    s plbat = $o(^PIVALBAT(0,"LocWard", loc, ward, "")) 
    if (plbat '= "")&&('$d(^PIVALBATCU(plbat, "Cub"))) {
        s plbat = ""
    }
    if (plbat = "") {
        s plbat = $o(^PIVALBAT(0,"Loc", loc, ""))   
    }
    q:(plbat = "") 
    s cub = ""
    for {
        s cub = $o(^PIVALBATCU(plbat, "Cub", cub))
        q:(cub = "")
        s cubData = $g(^PIVALBATCU(plbat, "Cub", cub))
        s maxCubage = $p(cubData, "^", 1)
        s minCubage = $p(cubData, "^", 3)
        s batNo = $p(cubData, "^", 2)
        s ..cubageDimData(batNo) = $lb(minCubage, maxCubage)
    }
    
    /* 没有维护的, 补充数据为 0 ~ 999999 */
    s batNoIndex= ""
    for {
        s batNoIndex = $o(..batDimData(batNoIndex))
        q:(batNoIndex = "")
        s batNo = ..batDimData(batNoIndex)
        if '$d(..cubageDimData(batNo)) {
            s ..cubageDimData(batNo) = $lb(0, 9999999)
        }
    }
    q
}

/// Description: 频次规则
Method SetFreqFlagData(loc)
{
    if ($d(%zparamFreqFlagDimData)){
        merge ..paramFreqFlagDimData = %zparamFreqFlagDimData
        q
    }
    s freq = 0
    for {
        s freq = $o(^PIVAFREQR(0, "Freq", loc, freq)) q:(freq = "")
        s rowID = 0
        for {
            s rowID = $o(^PIVAFREQR(0, "Freq", loc, freq, rowID)) q:(rowID = "")
            s rowData = $g(^PIVAFREQR(rowID))
            s ..paramFreqFlagDimData(freq) = $lb($p(rowData, "^", 4), $p(rowData, "^", 5))
        }
    }
    merge %zparamFreqFlagDimData = ..paramFreqFlagDimData
}

/// Description: 获取批次字典 - 正序数据
Method SetBatDict()
{
    s batNo = ""
    for {
        s batNo = $o(^PIVABT(0, "BatNo", ..loc, batNo))
        q:(batNo = "")
        continue:(batNo '= +batNo)
        s batNoIndex =  batNo
        s ..batDimData(batNoIndex) = batNo
    }
    s batIndex = $o(..batDimData(""))
    s ..firstBatNo = $g(..batDimData(batIndex))
}

/// w ##class(PHA.Tmp).ConnactStrToDimData("[1,2,3][4,5,6]", .a)
ClassMethod ConnactStrToDimData(pStr, Output batNoGroupData)
{
    try{
        s arrStr = "[" _ $replace(pStr, "][", "],[") _ "]"
        s arr = [].%FromJSON(arrStr)
        for i = 0 : 1 : (arr.%Size() - 1) {
            s iRow = arr.%Get(i)
            s iRowList = $lfs($tr(iRow.%ToJSON(), "[]", ""))
                for j = 0 : 1 : (iRow.%Size() - 1) {
                    s batNo = iRow.%Get(j)
                    continue:(batNo = "")
                    s batNoGroupData(batNo) = iRowList
                }
        }
    }catch(e){
        return $ze
    }
    q $$$OK
}

/// 判断当前时间是否已超过某批次时间范围, 如果超过是不允许上移
/// w ##class(web.DHCSTPIVAS.Data.Batch).HasOrderPassedBatEndTime(183995,1)
ClassMethod HasOrderPassedBatEndTime(mDsp, batNo)
{
    q:(batNo [ "空")||(batNo [ "包") $$$YES
    s curDate = +$h, curTime = $p($h, ",", 2)
    s mDspData = $g(^DHCOEDISQTY(mDsp))
    s doseDate = $p(mDspData,"^",21)
    s recLoc = $p(mDspData, "^", 24)
    q:(doseDate > curDate) $$$NO
    q:(doseDate < curDate) $$$YES
    s mOeori = $p(mDspData, "^", 1)
    s pri = $p($g(^OEORD(+mOeori, "I", +$p(mOeori,"||",2), 1)), "^", 8)
    s seqFlag = ..OrdSeqFlag(mOeori)
    s (pbt, toTime) = ""
    for {
        s pbt = $o(^PIVABT(0, "BatNo", recLoc, batNo, pbt))
        q:(pbt = "")
        s pbtData = $g(^PIVABT(pbt))
        s pbtSeq = $p(pbtData,"^",5)
        continue:(seqFlag '= "")&&(pbtSeq '= "")&&(seqFlag '= pbtSeq)
        s ptbPri = $p(pbtData, "^", 8)
        continue:(pri '= "")&&(ptbPri '= "")&&(pri '= ptbPri)
        s toTime = $p(pbtData,"^",2)
    }
    q:(toTime '= "")&&((curTime + 1200) > toTime) $$$YES // 提前20分钟
    q $$$NO
}

}
