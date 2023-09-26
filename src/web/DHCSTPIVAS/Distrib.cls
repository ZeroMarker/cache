/// Description: 物流交接
///              状态60 - 物流配送
///              状态70 - 物流接收
Class web.DHCSTPIVAS.Distrib Extends web.DHCSTPIVAS.Common
{

/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Distrib","DistribData","{""distribNo"":""S10JMYWPZZXP20220803001"",""loc"":""248""}")
Query DistribData(pJsonStr = "{}") As websys.Query(ROWSPEC = "propDesc, propVal, pogsNo")
{
}

ClassMethod DistribDataExecute(ByRef qHandle As %Binary, pJsonStr = "{}") As %Status
{
    s repid = $i(^CacheTemp)
    s qHandle = $lb(0, repid, 0)
    s ind = 1
    s pJson = ##class(PHA.COM.Json).Parse(pJsonStr)
    q:'$IsObject(pJson) $$$OK
    s pNo = pJson.distribNo
    q:(pNo = "") $$$OK
    s pLoc = pJson.loc
    
    s pog = ##class(web.DHCSTPIVAS.Common).GetFirstPogByNo(pNo,pLoc)
    q:(pog = "") {}.%ToJSON()
    s sub = $o(^PIVA(0, "PogsNo", pNo, pog, ""))
    q:(sub = "") {}.%ToJSON()
    s pogsData = $g(^PIVA(pog, "S", sub))
    s createUser = $p(pogsData, "^", 3)
    s createUserName = ##class(PHA.COM.Data.Base).UserName(createUser)
    s createDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(pogsData, "^", 4))
    s createTime = ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p(pogsData, "^", 5))
    s tmpKey = ..Translate("交接单号")  // @translate
    s calcData($i(indexNum)) = $lb(tmpKey,  pNo)
    s tmpKey = ..Translate("单据信息")  // @translate
    s calcData($i(indexNum)) = $lb(tmpKey, createDate _ " " _ createTime _ " " _ createUserName)

    s phb = ..GetPhbByNo(pNo)
    if (phb '= ""){
        s phbData = $g(^DHCPHBOX(phb))
        s phbLogUser = $p(phbData, "^", 6) // 不是指向
        s phbPhHandDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(phbData, "^", 4))
        s phbPhHandTime = ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p(phbData, "^", 5))
        s tmpKey = ..Translate("配送信息")  // @translate
        s calcData($i(indexNum)) = $lb(tmpKey, phbPhHandDate _ " " _ phbPhHandTime _ "　　" _ phbLogUser)
        s phbPhUser = $p(phbData, "^", 3) 
        s phbPhUserName = ##class(PHA.COM.Data.Base).UserName(phbPhUser)
        s tmpKey = ..Translate("交接信息")  // @translate
        s calcData($i(indexNum)) = $lb(tmpKey, phbPhHandDate _ " " _ phbPhHandTime _ "　　" _ phbPhUserName)
        s phbWardUser=$p(phbData, "^", 7)
        if (phbWardUser '= ""){
            s phbWardHandDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(phbData, "^", 8))
            s phbWardHandTime = ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p(phbData, "^", 9))          
            s phbWardHandDateTime = phbWardHandDate _ " " _ phbWardHandTime
            s phbWardUserName = ##class(PHA.COM.Data.Base).UserName(phbWardUser)
            s tmpKey = ..Translate("接收信息")  // @translate
            s calcData($i(indexNum)) = $lb(tmpKey, phbWardHandDate _ " " _ phbWardHandTime _ "　　" _ phbWardUserName)
        }       
    }else{
        s tmpKey = ..Translate("配送信息")  // @translate
        s tmpValue = ..Translate("尚未配送")  // @translate
        s calcData($i(indexNum)) = $lb(tmpKey, tmpValue)
    }
    s totalTitle = ..Translate("病区合计") // @translate
    s wardBatArr = ..GetWardBatData(pNo)
    s len = wardBatArr.%Size()
    for i = 1 : 1 : len {
        s wardBatStr = wardBatArr.%Get(i - 1)
        s title = $s(i > 1 : "" , 1 : totalTitle)
        s calcData($i(indexNum)) = $lb(title, wardBatStr)
    }
    
    s sortIndex = ""
    for {
        s sortIndex = $o(calcData(sortIndex))
        q:(sortIndex = "")
        s ^CacheTemp(repid, ind) = calcData(sortIndex) _ $lb(pNo)
        s ind = ind + 1     
        
    }
    q $$$OK
}

/// Descritpion: 汇总病区批次数据
/// Debug:       w ##class(web.DHCSTPIVAS.Distrib).GetWardBatData("SCANP20200722024").%ToJSON()
ClassMethod GetWardBatData(pogsNo) As %DynamicArray
{
    s ret = []
    s pog = ""
    for {
        s pog = $o(^PIVA(0, "PogsNo", pogsNo, pog))
        q:(pog = "")
        s pogData = $g(^PIVA(pog))
        s batNo = $p(pogData, "^", 3)
        continue:(batNo = "")
        s calcTmpData("batNoCnt", batNo) = $g(calcTmpData("batNoCnt", batNo)) + 1
        s mDsp = $p(pogData, "^", 1)
        s dspData = $g(^DHCOEDISQTY(mDsp))
        s wardLoc = $p(dspData, "^", 22)
        s wardLocDesc = ##class(PHA.COM.Data.Base).LocDesc(wardLoc)
        s calcTmpData("wardLoc", wardLocDesc, batNo) = $g(calcTmpData("wardLoc", wardLocDesc, batNo)) + 1
    }
    s wardLocDesc = ""
    for {
        s wardLocDesc = $o(calcTmpData("wardLoc", wardLocDesc))
        q:(wardLocDesc = "")
        s batNo = "", batNoStr  = ""
        for {
            s batNo = $o(calcTmpData("wardLoc", wardLocDesc, batNo), 1, cnt)
            q:(batNo = "")
            s batNoDesc = batNo
            #; if (batNo = +batNo)&&(batNo '[ "[批"){
            #;     s batNoDesc = batNoDesc _ "批"
            #; }
            s batNoCnt = batNoDesc _ " : " _ cnt
            s batNoStr = $s(batNoStr = "" : batNoCnt, 1 : batNoStr _ " ; " _ batNoCnt)
        }
        s outputData = wardLocDesc _ "【 " _ batNoStr_ " 】"
        d ret.%Push(outputData)
    }   
    q ret
}

/// Description: 获取扫描执行成功的一条数据
/// w ##class(web.DHCSTPIVAS.Distrib).GetRowData("{""distribNo"":""S80P20221214013""}")
ClassMethod GetRowData(pJsonStr = "{}")
{
    s ret = {}
    s pJson = ##class(PHA.COM.Json).Parse(pJsonStr)
    q:'$IsObject(pJson) {}.%ToJSON()
    s pNo = pJson.distribNo
    
    s pog = $o(^PIVA(0, "PogsNo", pNo, ""))
    q:(pog = "") {}.%ToJSON()
    s sub = $o(^PIVA(0, "PogsNo", pNo, pog, ""))
    q:(sub = "") {}.%ToJSON()
    s pogsData = $g(^PIVA(pog, "S", sub))
    s createUser = $p(pogsData, "^", 3)
    s createUserName = ##class(PHA.COM.Data.Base).UserName(createUser)
    s createDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(pogsData, "^", 4))
    s createTime = ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p(pogsData, "^", 5))
    
    s phb = ..GetPhbByNo(pNo)
    if (phb '= ""){
        s phbData = $g(^DHCPHBOX(phb))
        s phbLogUser = $p(phbData, "^", 6) // 配送人员
        s phbPhHandDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(phbData, "^", 4))
        s phbPhHandTime = ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p(phbData, "^", 5))
        s ret.phbDateTime = phbPhHandDate _ " " _ phbPhHandTime
        s ret.phbDateTimeDesc = ..Translate("配送时间")  // @translate
        s ret.phbLogUser = phbLogUser
        s ret.phbLogUserDesc = ..Translate("配送人员")  // @translate
        s phbPhUser = $p(phbData, "^", 3) 
        s ret.phbPhUserName = ##class(PHA.COM.Data.Base).UserName(phbPhUser)
        s ret.phbPhUserNameDesc = ..Translate("交接人员")  // @translate
        s phbWardUser=$p(phbData, "^", 7)
        if (phbWardUser '= ""){
            s phbWardHandDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(phbData, "^", 8))
            s phbWardHandTime = ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p(phbData, "^", 9))          
            s ret.phbWardHandDateTime = phbWardHandDate _ " " _ phbWardHandTime
            s ret.phbWardHandDateTimeDesc = ..Translate("接收时间")  // @translate
            s ret.phbWardUserName = ##class(PHA.COM.Data.Base).UserName(phbWardUser)
            s ret.phbWardUserNameDesc = ..Translate("接收人员")  // @translate
        }
        
    }
    s ret.no = pNo
    s ret.noDesc = ..Translate("交接单号")  // @translate
    s ret.createUserName = createUserName
    s ret.createDateTime = createDate _ " " _ createTime
    s ret.wardBatStrDesc = ..Translate("明细信息")  // @translate
    s ret.wardBatStr = ..ArrayJoin(..GetWardBatData(pNo), "<span style='color:#017bec;font-weight:bold;'>;</span> ")
    q ret.%ToJSON()
}

ClassMethod ArrayJoin(arr, split = ",")
{
    s ret = ""
    s len = arr.%Size()
    for i = 1 : 1 : len {
        s cell = arr.%Get(i - 1)
        s ret = $s(ret '= "" : ret _ split _ cell, 1 : cell)
    }
    q ret
}

/// w ##class(web.DHCSTPIVAS.Distrib).GetPhbByNo("S80P20191106057")
ClassMethod GetPhbByNo(no)
{
    &SQL(
        SELECT PHB_RowID INTO :phb FROM DHC_PHBox WHERE PHB_No = :no AND PHB_Remark='PIVAS'
    )
    q $g(phb)
}

/// Description: 保存交接信息
/// w ##class(web.DHCSTPIVAS.Distrib).SaveHandler("{""distribNo"":""S30P20200724006"",""userCode"":""yf01"",""loc"":""248"",""stat"":70,""user"":""711""}")
/// 
ClassMethod SaveHandler(dataStr)
{
    s dataJson = ##class(PHA.COM.Json).Parse(dataStr)
    s chkRet = ..CheckSave(dataJson)
    q:(+chkRet < 0) chkRet
    s dataJson.phb = ..GetPhbByNo(dataJson.distribNo)
    s saveRet = ..Save(dataJson)
    if (saveRet = 0){
        if (dataJson.stat = 60){
            s remarks = "物流人员: " _ dataJson.userCode
            d ##class(web.DHCSTPIVAS.Distrib).UpdateSystemStatus4Distrib("Distrib60", dataJson.distribNo, dataJson.user, dataJson.loc, remarks)
        }
    }
    q saveRet
}

ClassMethod CheckSave(dataJson)
{
    s no = dataJson.distribNo
    s status = dataJson.stat
    s userCode = dataJson.userCode
    q:(userCode = "") ..Translate("-1^获取不到交接人员")  // @translate
    q:(status '= 60)&&(status '= 70) "-1^交接状态代码错误"

    s phb = ..GetPhbByNo(no)
    s phbStatus = $p($g(^DHCPHBOX(+phb)), "^", 13)
    q:(status = 70)&&(phb = "") ..Translate("-1^尚未配送，无法接收")  // @translate
    q:(status = 60)&&(phb '= "") ..Translate("-1^已经配送")  // @translate
    q 0
}

ClassMethod Save(dataJson)
{
    s no = dataJson.distribNo
    s status = dataJson.stat
    s userCode = dataJson.userCode
    s loc = dataJson.loc
    s user = dataJson.user // 登录HIS的用户
    s curDate = +$h
    s curTime = $p($h, ",", 2)
    s phb = dataJson.phb
    if (status = 60){
        &SQL(
            INSERT INTO DHC_PHBox (PHB_No, PHB_DatePhHand, PHB_TimePhHand, PHB_UserLogistics_Dr,
                                   PHB_Status, PHB_FLoc_Dr, PHB_UserCreate_Dr,
                                   PHB_DateCreate, PHB_TimeCreate, PHB_Remark, PHB_UserPhHand_Dr)
            VALUES (:no, :curDate, :curTime, :userCode,
                    '60', :loc, :user,
                    :curDate, :curTime, 'PIVAS', :user) 
        )
    }elseif (status = 70){
        &SQL(
            UPDATE DHC_PHBox
            SET PHB_Status = '70',PHB_DateWardHand = :curDate,PHB_TimeWardHand = :curTime, 
                PHB_UserWardHand_Dr = :user
            WHERE PHB_RowID = :phb
        )
    }else{
        return "-1^状态错误"
    }
    q:(SQLCODE = 0) 0
    q $$$pivasError4Sql(%msg)
}

/// Description: 物流交接传状态
/// Debug:       ##class(web.DHCSTPIVAS.Distrib).UpdateSystemStatus4Distrib(disNumber, distribNo, user, loc, remarks)
ClassMethod UpdateSystemStatus4Distrib(disNumber, distribNo, user, loc, remarks)
{
    s pog = 0
    for {
        s pog = $o(^PIVA(0, "PogsNo", distribNo, pog)) q:(pog = "")
        s pogData = $g(^PIVA(pog))
        continue:(loc '= $p(pogData, "^", 7))
        s mDsp = $p(pogData, "^", 1)
        d ##class(web.DHCSTPIVAS.DataCenter).UpdateSystemStatus(disNumber, mDsp, user, loc, remarks)
    }
    q $$$OK
}

}
