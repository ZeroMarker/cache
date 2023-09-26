Class web.DHCSTPIVAS.Face Extends %RegisteredObject
{

/// Description: 判断是否允许更新打包表打包标志
///              提供给护理组领药审核用, 返回$$$YES则不允许更新 DHC_OEDispensing.DSP_PogFlag
/// Debug:       ##class(web.DHCSTPIVAS.Face).CanUpdatePogFlag(打包表ID)
ClassMethod CanUpdatePogFlag(dsp) As %Boolean
{
    s pog = $o(^PIVA(0, "DSP", dsp, 0))
    q:(pog '= "") $$$NO
    q $$$YES
}

/// Description: 静配中心预存设定批次
ClassMethod SaveNursePIVABat(dsp, batNo, user)
{
    
    q:(+dsp = 0) "-1^打包记录ID为空"
    s mDsp = ##class(web.DHCSTPIVAS.Common).GetMainDspId(dsp)
    q:(mDsp = "") "-1^打包记录的主记录为空"
    s mDspData = $g(^DHCOEDISQTY(mDsp))
    s seqNo = $p(mDspData, "^", 4)
    s dspCate = $p(mDspData, "^", 27)
    q:(dspCate '= 0) "-1^不是配液中心需要配置的医嘱, 不需要操作"
    q:(##class(web.DHCSTPIVAS.Common).DspPackFlag(mDsp) '= "") "-1^打包的医嘱, 不需要修改批次"
    s recLoc = $p(mDspData, "^", 24)
    q:('$d(^PIVAS(0, "LOCNUMBER", recLoc))) "-1^不是配液中心需要配置的医嘱, 不需要操作"
    s pog = $o(^PIVA(0, "DSP" ,mDsp, ""))
    if (pog '= ""){
        s psId = $p(^PIVA(pog),"^",6)
        s psNumber = $p($g(^PIVAS(+psId)),"^",1)
        if (psNumber >= 10){
            return "-1^该组医嘱已经打签，请联系静配中心进行修改"
        }
    }
    s pbu = $o(^PIVABU(0, "OEGRP", mDsp, seqNo, ""), -1)
    s pbuBatNo = $p($g(^PIVABU(+pbu)),"^",3)
    q:(pbuBatNo = batNo) "-1^该组医嘱已经为" _ batNo _ "批，不需要修改"
    s insRet = ##class(web.DHCSTPIVAS.BatUpdate).UpdateBatch(mDsp, batNo, user, "护士延迟批次")
    if (+insRet '= 0) {
        return insRet
    }
    q insRet
}

/// Description:获取配液中心的所有在用批次信息
/// Creator:    hulihua
/// CreateDate: 2021-11-29
/// Table:      PIVA_BatTime
/// Input:      lob 静配科室ID
/// Output:     
/// Return： 批次串, 以$$分割
/// Others:     
/// Debug:      w ##class(web.DHCSTPIVAS.Face).GetPivasBatNo(89)
ClassMethod GetPivasBatNo(loc)
{
    q:(loc = "") ""
    s ret = ""
    s pbtId = 0
    for {
        s pbtId = $o(^PIVABT(pbtId), 1, pbtData)
        q:(pbtId = 0)||(pbtId = "")
        s pbtLocDr = $p(pbtData,"^",4)
        continue:(pbtLocDr '= loc)
        s wardDr = $p(pbtData,"^",6)
        continue:(wardDr '= "")
        s batNo = $p(pbtData,"^",3)
#;      打包批次的无需延迟
        continue:(batNo [ "空")||(batNo [ "包")||($p(pbtData,"^",10) = "Y")       
        s fromTime = $p(pbtData,"^",1)
        s toTime = $p(pbtData,"^",2)
#;      特定批次不需要, 无时间规则用于固定批次
        continue:(fromTime ="" )&&(toTime = "")     
        s fromTime = ##class(web.DHCSTPIVAS.Common).TimeShortFormat(fromTime)
        s toTime = ##class(web.DHCSTPIVAS.Common).TimeShortFormat(toTime)
        s calcData(batNo)=batNo_" ("_fromTime_" ~ "_toTime_")"
    }
    s (batNo, retStr) = ""
    for {
        s batNo = $o(calcData(batNo), 1, batNoStr) q:(batNo = "")
        s ret = ret _ $lb(batNoStr)
    }
    q $lts(ret, "$$")
}

/// Description: 护理PDA扫描接收配液中心配送的药品
ClassMethod ExePivasState4NurRec(oeore, user) As %String
{
    s dsp = $o(^DHCOEDISQTY(0, "OEORE", oeore, 0))
    s recLocID = $p(^DHCOEDISQTY(dsp), "^", 24)
    s barCode = ##class(web.DHCSTPIVAS.Common).OeoreToBarCode(oeore)
    s ret = ##class(web.DHCSTPIVAS.DataHandler).ExecuteByBarCode(oeore, "90", user, recLocID)
    q:(+ret < 0) ret
    q $$$OK
}

/// Description: 账单接口
ClassMethod BILLN(adm, userId, oeorestr, flag = 1)
{
    q ##Class(web.UDHCJFBILL).BILLN(adm, userId, oeorestr, flag)
}

}
