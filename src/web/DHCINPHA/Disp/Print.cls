Import SQLUser

/// Creator: Huxt 2019-11-26
/// Desc: 住院发药 & 发药查询打印公共
Class web.DHCINPHA.Disp.Print Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator: Huxt 2019-11-27
/// Desc: 住院发药打印明细时返回json数据(多发药单一起打印),入参可以是多个主表的ID
/// Input: phacStr - phac1^phac2^phac3
/// Output: json: [{mian:{}, detail:[{},{}]}, {{mian:{}, detail:[{},{}]}, ...]
/// w ##class(web.DHCINPHA.Disp.Print).GetDetailJsonData("2817")
ClassMethod GetDetailJsonData(phacStr, otherStr = "")
{
    #; q ..GetDetailJsonGroupByPat(phacStr, otherStr)
    s retArr = ##class(web.DHCST.Array).%New()
    s retStr = ..GetPhaCollData(phacStr, otherStr, "Detail")
    s count = $p(retStr,"^",1)
    s pid = $p(retStr,"^",2)
    q:count<0 retStr
    q:count=0 retArr.ToJSON()
    
    s mainIndex = ""
    f  s mainIndex = $o(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData", pid, mainIndex)) q:mainIndex=""  d
    .s oneMainStr = ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData", pid, mainIndex)
    .s main = ##class(web.DHCST.Object).%New()
    .s main.wardDesc = $p(oneMainStr,"^",1)
    .s main.phaType = $p(oneMainStr,"^",2)
    .s main.dispNo = $p(oneMainStr,"^",3)
    .s main.phaDate = $p(oneMainStr,"^",4)
    .s main.sysDateTime = $p(oneMainStr,"^",5)
    .s main.phaUserName = $p(oneMainStr,"^",6)
    .s main.phaCollectUserName = $p(oneMainStr,"^",7)
    .s main.phaCollateUserName = $p(oneMainStr,"^",8)
    .s amtSum = 0
    .
    .//明细
    .s detail = ##class(web.DHCST.Array).%New()
    .s subIndex = ""
    .f  s subIndex = $o(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData", pid, mainIndex, subIndex)) q:subIndex=""  d
    ..s packFlag = ""
    ..f  s packFlag = $o(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData", pid, mainIndex, subIndex, packFlag)) q:packFlag=""  d
    ...s oeori = ""
    ...f  s oeori = $o(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData", pid, mainIndex, subIndex, packFlag, oeori)) q:oeori=""  d
    ....s oneDetailStr = ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData", pid, mainIndex, subIndex, packFlag, oeori)
    ....s amtSum = amtSum + $p(oneDetailStr,"^",20)
    ....s oneDetail = ##class(web.DHCST.Object).%New()
    ....s oneDetail.bedNo = $p(oneDetailStr,"^",6)
    ....s oneDetail.patNo = $p(oneDetailStr,"^",1)
    ....s oneDetail.patName = $p(oneDetailStr,"^",2)
    ....s oneDetail.inciDesc = $p(oneDetailStr,"^",11)
    ....s oneDetail.doseQty = $p(oneDetailStr,"^",14)
    ....s oneDetail.uomDesc = $p(oneDetailStr,"^",17)
    ....s oneDetail.freqDesc = $p(oneDetailStr,"^",15)
    ....s oneDetail.instDesc = $p(oneDetailStr,"^",22)
    ....s oneDetail.timeDosingStr = $p(oneDetailStr,"^",47)
    ....s oneDetail.spec = $p(oneDetailStr,"^",31)
    ....s oneDetail.qty = $fn($p(oneDetailStr,"^",16), "N")
    ....s oneDetail.oeori = $p(oneDetailStr,"^",50)
    ....d detail.Insert(oneDetail)
    .s main.amtSum = ..FormatDecimal(amtSum)
    .
    .//分组
    .s oneGroupData = ##class(web.DHCST.Object).%New()
    .s oneGroupData.main = main
    .s oneGroupData.detail = detail
    .d retArr.Insert(oneGroupData)
    k ^||TMP("DHCST","web.DHCINPHA.Disp.Print", "SetDetailData", pid)
    d retArr.WriteJSON()
    q ""
}

/// Creator: Huxt 2019-11-27
/// Desc: 住院发药打印按药品汇总时返回json数据(多发药单一起打印), 入参可以是多个主表的ID
/// Input: phacStr - phac1^phac2^phac3
/// Output: json: [{patInfo:{}, drugList:[{},{}]}, {{patInfo:{}, drugList:[{},{}]}, ...]
/// w ##class(web.DHCINPHA.Disp.Print).GetTotalJsonData("170")
ClassMethod GetTotalJsonData(phacStr, otherStr = "")
{
    s retArr = ##class(web.DHCST.Array).%New()
    s retStr = ..GetPhaCollData(phacStr, otherStr, "Total")
    s count = $p(retStr,"^",1)
    s pid = $p(retStr,"^",2)
    q:count<0 retStr
    q:count=0 retArr.ToJSON()
    
    s mainIndex = ""
    f  s mainIndex = $o(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetTotalData",pid, mainIndex)) q:mainIndex=""  d
    .s oneMainStr = ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetTotalData",pid, mainIndex)
    .s main = ##class(web.DHCST.Object).%New()
    .s main.wardDesc = $p(oneMainStr,"^",1)
    .s main.phaType = $p(oneMainStr,"^",2)
    .s main.dispNo = $p(oneMainStr,"^",3)
    .s main.phaDate = $p(oneMainStr,"^",4)
    .s main.sysDateTime = $p(oneMainStr,"^",5)
    .s main.phaUserName = $p(oneMainStr,"^",6)
    .s main.phaCollectUserName = $p(oneMainStr,"^",7)
    .s main.phaCollateUserName = $p(oneMainStr,"^",8)
    .s amtSum = 0
    .
    .//明细
    .s detail = ##class(web.DHCST.Array).%New()
    .s sortIndex = ""
    .f  s sortIndex = $o(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetTotalData",pid, mainIndex, sortIndex)) q:sortIndex=""  d
    ..s inci = ""
    ..f  s inci = $o(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetTotalData",pid, mainIndex, sortIndex, inci)) q:inci=""  d
    ...s oneDetailStr = ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetTotalData", pid, mainIndex, sortIndex, inci)
    ...s facQty = $p(oneDetailStr,"^",14)
    ...s facQty = ..GetPackQty(inci, facQty)
    ...s ordQty = $p(oneDetailStr,"^",5)
    ...s ordQty = ..GetPackQty(inci, ordQty)
    ...s resQty = $p(oneDetailStr,"^",10)
    ...s resQty = ..GetPackQty(inci, resQty)
    ...s amt = $p(oneDetailStr,"^",6)
    ...s amtSum = amtSum + amt
    ...//oneDetail
    ...s oneDetail = ##class(web.DHCST.Object).%New()
    ...s oneDetail.inciDesc = $p(oneDetailStr,"^",2)
    ...s oneDetail.spec = $p(oneDetailStr,"^",13)
    ...s oneDetail.stkBin = $p(oneDetailStr,"^",11)
    ...s oneDetail.amt = $s(amt > 0.01 : $fn(amt, "", 2), 1 : $fn(amt, "N"))
    ...s oneDetail.facQty = facQty
    ...s oneDetail.ordQty = ordQty
    ...s oneDetail.resQty = resQty
    ...s oneDetail.bedQty = ..GetBedQtyData(pid,mainIndex,inci)
    ...d detail.Insert(oneDetail)
    .
    .s main.amtSum = $s(amtSum > 0.01 : $fn(amtSum, "", 2), 1 : $fn(amtSum, "N"))
    .
    .//分组
    .s oneGroupData = ##class(web.DHCST.Object).%New()
    .s oneGroupData.main = main
    .s oneGroupData.detail = detail
    .d retArr.Insert(oneGroupData)
    
    k ^||TMP("DHCST","web.DHCINPHA.Disp.Print", "SetTotalData", pid)
    k ^||TMP("DHCST","web.DHCINPHA.Disp.Print", "BedInciTotal", pid)
    d retArr.WriteJSON()
    q ""
}

/// Creator: Huxt 2019-11-27
/// Desc: 住院发药打印口服药标签返回json数据
/// Input: phacStr - phac1^phac2^phac3
/// Output: json: [{patInfo:{}, drugList:[{},{}]}, {{patInfo:{}, drugList:[{},{}]}, ...]
/// w ##class(web.DHCINPHA.Disp.Print).GetKFYLabelJsonData("131^132^133")
ClassMethod GetKFYLabelJsonData(phacStr, otherStr = "")
{
    s retArr = ##class(web.DHCST.Array).%New()
    s retStr = ..GetPhaCollData(phacStr, otherStr, "Label")
    s count = $p(retStr,"^",1)
    s pid = $p(retStr,"^",2)
    q:count<0 retStr
    q:count=0 retArr.ToJSON()
    
    s patInfo = ""
    f  s patInfo = $o(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetKFYLabelData",pid,patInfo)) q:patInfo=""  d
    .s oneMainStr = ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetKFYLabelData",pid, patInfo)
    .s main = ##class(web.DHCST.Object).%New()
    .s main.wardDesc = $p(oneMainStr,"^",1)
    .s main.patNo = $p(oneMainStr,"^",2)
    .s main.patName = $p(oneMainStr,"^",3)
    .s main.patSex = $p(oneMainStr,"^",4)
    .s main.bedCode = $p(oneMainStr,"^",5)
    .
    .//明细
    .s detail = ##class(web.DHCST.Array).%New()
    .s dspID = ""
    .f  s dspID = $o(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetKFYLabelData",pid,patInfo,dspID)) q:dspID=""  d
    ..s oneDetailStr = ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetKFYLabelData",pid,patInfo,dspID)
    ..s oneDetail = ##class(web.DHCST.Object).%New()
    ..s oneDetail.arcimDesc = $p(oneDetailStr,"^",1)
    ..s oneDetail.instDesc = $p(oneDetailStr,"^",2)
    ..s oneDetail.freqDesc = $p(oneDetailStr,"^",3)
    ..s oneDetail.dodisDate = $p(oneDetailStr,"^",4)
    ..s oneDetail.dodisTime = $p(oneDetailStr,"^",5)
    ..d detail.Insert(oneDetail)
    .
    .//分组
    .s oneGroupData = ##class(web.DHCST.Object).%New()
    .s oneGroupData.main = main
    .s oneGroupData.detail = detail
    .d retArr.Insert(oneGroupData)
    
    k ^||TMP("DHCST","web.DHCINPHA.Disp.Print", "SetKFYLabelData", pid)
    d retArr.WriteJSON()
    q ""
}

/// Creator: Huxt 2019-11-26
/// Desc: 获取数据存入临时Global中
/// Input: phacStr - phac1^phac2^phac3; getType-获取数据后的汇总方式
/// Output: pid
/// Others: 本方法不考虑草药, 草药按处方打印, 不考虑明细和汇总
/// w ##class(web.DHCINPHA.Disp.Print).GetPhaCollData("2817")
ClassMethod GetPhaCollData(phacStr, otherStr = "", getType = "")
{
    q:phacStr="" ""
    s gGroupID = $p(otherStr, "^", 1)
    s gUserID = $p(otherStr, "^", 2)
    s sysDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h)
    s sysTime = ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p($h,",",2))
    s sysDateTime = sysDate_" "_sysTime
    s packedCat = ##class(web.DHCSTPCHCOLLS).getPackedCat()
    
    s $ZT = "GetPhaCollDatasError"
    s pid = ..NewPid()
    s phacLen = $l(phacStr,"^")
    s count = 0
    f i=1:1:phacLen d
    .s iPhac = $p(phacStr, "^", i)
    .q:iPhac=""
    .s wardID = $p(^DHCPHAC(iPhac),"^",4)       //病区
    .s phaLocID = $p(^DHCPHAC(iPhac),"^",1)     //发药科室
    .s phaLocDesc = $s(phaLocID'="":$p(^CTLOC(phaLocID),"^",2), 1:"")
    .s:phaLocDesc["-" phaLocDesc=$p(phaLocDesc,"-",2)
    .s hospID = $p($g(^CTLOC(phaLocID)),"^",22) //医院
    .s hospDesc = $p(^CT("HOSP",hospID),"^",2)
    .s PrnTotalSortIndex=""
    .i $zcvt(getType,"U")["TOTAL" d
    ..s Params=gGroupID_"^"_phaLocID_"^"_gUserID_"^"_hospID
    ..s PrnTotalSortIndex=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTORDDISP","PrnTotalSortIndex",Params) 
    .s phacType = $p(^DHCPHAC(iPhac),"^",12)    //发药类别代码
    .s phacTypeDesc = ..GetTypeDescByCode(phacType,hospID)
    .s phaUserID = $p(^DHCPHAC(iPhac),"^",5)    //配药人
    .s phaUserName = $s(phaUserID'="":$p(^SSU("SSUSR",phaUserID),"^",2), 1:"")
    .s phaCollectUserID = $p(^DHCPHAC(iPhac),"^",13)    //发药人
    .s phaCollectUserName = $s(phaCollectUserID'="":$p(^SSU("SSUSR",phaCollectUserID),"^",2), 1:"")
    .s phaCollateUserID = $p($g(^DHCPHAC(iPhac,1)),"^",14)      //核对人
    .s phaCollateUserName = $s(phaCollateUserID'="":$p(^SSU("SSUSR",phaCollateUserID),"^",2), 1:"")
    .s phaDateH = $p(^DHCPHAC(iPhac),"^",7)     //发药日期
    .s phaDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phaDateH)
    .s dispNo = $p(^DHCPHAC(iPhac),"^",14)
    .s toDocLoc = $p(^DHCPHAC(iPhac, 1),"^",10)
    .s floor = $p(^DHCPHAC(iPhac, 1),"^",15)
    .s floorDesc = $s(floor '= "" : $p($g(^CT("CTLB", +floor, "Floor", +$p(floor, "||", 2))), "^", 1) , 1 : "")
    .i wardID '= "" s toLocDesc = $p(^PAWARD(wardID), "^", 2)
    .e  s toLocDesc = $p(^CTLOC(toDocLoc), "^", 2)
    .i floorDesc '= "" s toLocDesc = toLocDesc _ " # " _ floorDesc
    .s chl = ""
    .f  s chl = $o(^DHCPHAC(iPhac,"I",chl))  q:chl=""  d
    ..q:+chl=0
    ..s data = ^DHCPHAC(iPhac,"I",chl)
    ..//患者信息
    ..s adm = $p(data,"^",3)
    ..s papmi = $p(^PAADM(adm),"^",1)
    ..s patNo = $p(^PAPER(papmi,"PAT",1),"^",1)
    ..s patName = $p(^PAPER(papmi,"ALL"),"^",1)
    ..s patAge = ##class(PHA.FACE.IN.Com).GetAge(papmi,adm)
    ..s sex = $p(^PAPER(papmi,"ALL"),"^",7 )
    ..s patSex = $p(^CT("SEX",sex),"^",2)
    ..s homeTel = $p($g(^PAPER(papmi,"PER",1)),"^",11)
    ..s workTel = $p($g(^PAPER(papmi,"PER",1)),"^",9)
    ..s handtel = $p($g(^PAPER(papmi,"PER",4)),"^",21)
    ..s mrAdmDr = $p(^PAADM(adm),"^",61)
    ..s patWeight = $p(^MR(mrAdmDr,"PRO",1),"^",27)
    ..s oeStatus = $p(data,"^",10)
    ..s admLoc = $p(data,"^",11)
    ..s admLocDesc = $s(admLoc'="":$p(^CTLOC(+admLoc),"^",2))
    ..s:admLocDesc["-" admLocDesc=$p(admLocDesc,"-",2)
    ..s bedCode = $p(data,"^",8)
    ..s:(wardID'="")&&(wardID'=$p(^PAADM(adm),"^",70)) bedCode=bedCode_"(转)"
    ..s wardDesc = ..getWardDesc(adm)
    ..//实际用药时间
    ..s dodis = $p(data,"^",13)
    ..s dodisnum = $l(dodis,",")
    ..s dodistimestr = ..GetDodisTimeStr(dodis)
    ..//医嘱信息
    ..s prescNo = $p(data,"^",5)
    ..s oeori = $p(data,"^",7)
    ..s ord = +oeori
    ..s itm = $p(oeori,"||",2)
    ..s note = ..GetNotes(oeori)
    ..//医嘱项名称
    ..s arcim = $p(^OEORD(ord,"I",itm,1),"^",2)
    ..q:arcim=""
    ..s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
    ..q:(sub="")||(ver="")
    ..s arcimDesc = $p(^ARCIM(sub,ver,1),"^",2)
    ..//医嘱状态
    ..s ordStatusDr = $p(^OEORD(ord,"I",itm,1),"^",13)
    ..s ordStatus = $p(^OEC("OSTAT",ordStatusDr),"^",2)
    ..//频次
    ..s freqStr=##class(web.DHCSTCOMMONORDER).OeoriFreq(oeori)
    ..s freqRowid=$p(freqStr,"^",1)
    ..s freqDesc1=$p(freqStr,"^",4)
    ..s freqDesc2=freqDesc1
    ..//医生
    ..s doctor = $p(^OEORD(ord,"I",itm,1),"^",11)
    ..s doctorName = $s(doctor'="":$p(^CTPCP(+doctor,1),"^",2), 1:"")
    ..//用法
    ..s instdr = $p($g(^OEORD(ord,"I",itm,2)),"^",7)
    ..s instDesc1 = $p($g(^PHCIN(+instdr)),"^",2)
    ..//疗程
    ..s duration = $p($g(^OEORD(ord,"I",itm,2)),"^",6)
    ..s duration = $s(duration'="":$p($g(^PHCDU(+duration)),"^",3), 1:"")
    ..//用量(剂量) & 剂量单位
    ..s doseQty =##class(web.DHCSTCOMMONORDER).OeoriDosage(ord_"||"_itm)
    ..s doseQtyUom = "" //..getBUomDoseQty(ord,itm),此处默认空,标库以医嘱实际剂量为准
    ..s doseQty2 = "" //$p(doseQtyUom,"^",1)
    ..s doseUom2 = "" //$p(doseQtyUom,"^",2)
    ..//整包装数量
    ..s packQty = $p($g(^OEORD(ord,"I",itm,9)),"^",4)
    ..//不知是计算啥???
    ..s freqFac = $p($g(^PHCFR(+freqRowid)),"^",2)
    ..s confirms = $s(+freqFac'=0:dodisnum/freqFac,1:"")
    ..s freqtime = ##class(web.DHCSTKUTIL).GetFreqTimeByFreq(freqRowid)
    ..//医嘱子类
    ..s ordSubCatDr = $p(^ARCIM(sub,ver,1),"^",10)
    ..s arcicCode = $p(^ARC("IC",ordSubCatDr),"^",1)
    ..s arcicDesc = $p(^ARC("IC",ordSubCatDr),"^",2)
    ..//剂型 & 通用名
    ..s Phcdf = ##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcim)
    ..s drugFormStr = ##class(web.DHCST.Common.DrugInfoCommon).GetFormByPhcdf(Phcdf)
    ..s drugform = $p(drugFormStr,"^",2)
    ..s geneStr = ##class(web.DHCST.Common.DrugInfoCommon).GetGeneByPhcd(Phcdf)
    ..s generic = $p(geneStr,"^",2)
    ..//主医嘱
    ..s moeori = ##class(web.DHCSTKUTIL).GetMainOeori(oeori)
    ..//关联序号
    ..s seqno = $p(^OEORD(ord,"I",itm,3),"^",4)
    ..//医嘱时间
    ..s ordDate = $p(^OEORD(ord,"I",itm,3),"^",7)
    ..s ordDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ordDate)
    ..s ordTime = $p(^OEORD(ord,"I",itm,1),"^",17)
    ..s ordTime = ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ordTime)
    ..//医嘱优先级
    ..s pri = $p($g(^OEORD(ord,"I",itm,1)),"^",8)
    ..q:pri=""
    ..s priority = $P($g(^OECPR(pri)),"^",2)
    ..//诊断
    ..s disgType = $s(phacType="ZCY":"GC",1:"")
    ..s padiagnose = ##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(adm,",",disgType)
    ..s fac = ..getPackUomConFac(ord, itm)
    ..s freqFac = $p($g(^PHCFR(+freqRowid)),"^",2)
    ..s sub = 0 
    ..f  s sub = $o(^DHCPHAC(iPhac,"I",chl,"B",sub))  q:sub=""  d
    ...q:+sub=0
    ...s iPhacChlSub=iPhac_"||"_chl_"||"_sub
    ...s subData = ^DHCPHAC(iPhac,"I",chl,"B",sub)
    ...s inclb = $P(subData,"^",1)
    ...s inci = +inclb
    ...s inciCode = $p(^INCI(inci,1),"^",1)
    ...s inciDesc = $p(^INCI(inci,1),"^",2)
    ...s bUom = $p(^INCI(inci,1),"^",10)
    ...s bUomDesc = $p($g(^CT("UOM",+bUom)),"^",2)
    ...s pUom = $p($g(^INCI(inci,3)),"^",6)
    ...s pUomDesc = $p($g(^CT("UOM",+pUom)),"^",2)
    ...//整包装价格
    ...s exStr = oeori_"^"
    ...s pSp = ##Class(web.DHCSTPRICE).GetSp(inci, phaDateH, pUom, hospID, "", exStr)
    ...//数量&单价&金额
    ...s qty = $P(subData,"^",2)
    ...s sp = $P(subData,"^",5)
    ...s amt = $P(subData,"^",6)
    ...//规格
    ...s spec = ##class(web.DHCSTKUTIL).GetSpec(inci)
    ...//批次厂家
    ...s incib = $P(^INCI(inci,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
    ...s manf = $p(##class(web.DHCST.Common.DrugStkCommon).VendManfByIncIb(incib),"^",4)
    ...//货位码
    ...s incil = inci_"||"_$p(inclb,"||",2)
    ...s stkbin = ##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","")
    ...s stkbin = $p(stkbin,":",2)
    ...//不知有什么用???
    ...s resqty = +$p(subData,"^",8)
    ...s resqty = ..ZeroPad(resqty)
    ...//数了几顿的药???
    ...s qtyfac = $s(+freqFac'=0:qty\freqFac,1:"")
    ...
    ...s s01 = patNo_"^"_patName_"^"_patSex_"^"_patAge_"^"_wardDesc //5
    ...s s02 = bedCode_"^"_admLocDesc_"^"_prescNo_"^"_doctorName_"^"_inciCode //10
    ...s s03 = inciDesc_"^"_arcimDesc_"^"_oeStatus_"^"_doseQty_"^"_freqDesc1 //15
    ...s s04 = qty_"^"_bUomDesc_"^"_sp_"^"_pSp_"^"_amt //20
    ...s s05 = priority_"^"_instDesc1_"^"_duration_"^"_moeori_"^"_seqno //25
    ...s s06 = note_"^"_inci_"^"_manf_"^"_drugform_"^"_resqty //30
    ...s s07 = spec_"^"_stkbin_"^"_ordDate_"^"_ordTime_"^"_padiagnose //35
    ...s s08 = generic_"^"_ordSubCatDr_"^"_arcicDesc_"^"_qtyfac_"^"_doseQty2 //40
    ...s s09 = doseUom2_"^"_inci_"^"_freqtime_"^"_confirms_"^"_patWeight //45
    ...s s10 = packQty_"^"_dodistimestr_"^"_iPhac_"^"_phacType_"^"_oeori //50
    ...s s11 = phacTypeDesc
    ...s dataStr = s01_"^"_s02_"^"_s03_"^"_s04_"^"_s05_"^"_s06_"^"_s07_"^"_s08_"^"_s09_"^"_s10_"^"_s11
    ...s count = count + 1
    ...
    ...//汇总数据
    ...s getType = $zcvt(getType,"U")
    ...i getType["DETAIL" d SetDetailData
    ...i getType["TOTAL" d SetTotalData
    ...i getType["LABEL" d SetKFYLabelData
    ...i getType["KFYBAG" d SetKFYBag
    q count_"^"_pid
    
SetDetailData
    s mainIndex = iPhac
    s index = "BED"_patNo_"^"_bedCode_"^"_pri
    //1.主表数据
    i '$d(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData", pid, mainIndex)) d
    .s mainStr = toLocDesc_"^"_phacTypeDesc_"^"_dispNo_"^"_phaDate_"^"_sysDateTime_"^"_phaUserName_"^"_phaCollectUserName_"^"_phaCollateUserName
    .s ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData", pid, mainIndex) = mainStr
    //2.明细数据: 需分散整包装打印的情况
    i $f(packedCat,phacType)>0 d 
    .i packQty="" d
    ..//散包装医嘱
    ..i $d(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"0",oeori)) d
    ...s tStr = ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"0",oeori)
    ...s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"0",oeori),"^",16) = $p(tStr,"^",16)+qty
    ...s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"0",oeori),"^",44) = $p(tStr,"^",44)+confirms
    ...s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"0",oeori),"^",20) = $p(tStr,"^",20)+amt
    ...s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"0",oeori),"^",48) = $p(tStr,"^",48)_$c(13,10)_dodistimestr
    ..e  d
    ...s ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"0",oeori) = dataStr
    .e  d
    ..//整包装医嘱
    ..i $d(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"1",oeori)) d
    ...s tStr = ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"1",oeori)
    ...s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"1",oeori),"^",16) = $p(tStr,"^",16)+qty
    ...s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"1",oeori),"^",44) = $p(tStr,"^",44)+confirms
    ...s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"1",oeori),"^",20) = $p(tStr,"^",20)+amt
    ...s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"1",oeori),"^",48) = $p(tStr,"^",48)_$c(13,10)_dodistimestr
    ..e  d
    ...s ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"1",oeori) = dataStr
    //3.明细数据: 不分整散打印的情况
    i $f(packedCat,phacType)=0 d
    .i $d(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"0",oeori)) d
    ..s tStr = ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"0",oeori)
    ..s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"0",oeori),"^",16) = $p(tStr,"^",16)+qty
    ..s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"0",oeori),"^",44) = $p(tStr,"^",44)+confirms
    ..s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"0",oeori),"^",20) = $p(tStr,"^",20)+amt
    ..s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"0",oeori),"^",48) = $p(tStr,"^",48)_$c(13,10)_dodistimestr
    .e  d
    ..s ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid,mainIndex,index,"0",oeori) = dataStr
    q 1
    
SetTotalData
    s mainIndex = iPhac
    s index = "BED"_patNo_"^"_bedCode_"^"_pri
    //1.主表数据
    i '$d(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetTotalData", pid, mainIndex)) d
    .s mainStr = toLocDesc_"^"_phacTypeDesc_"^"_dispNo_"^"_phaDate_"^"_sysDateTime_"^"_phaUserName_"^"_phaCollectUserName_"^"_phaCollateUserName
    .s ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetTotalData", pid, mainIndex) = mainStr
    //2.按药品汇总明细
    s sortIndex=""
    i PrnTotalSortIndex="STKBIN" d
    .s sortStkbin=""
    .i stkbin'="" d
    ..s stkbinDem="-"  //货位码拼接符
    ..s stkbinLen=$l(stkbin,stkbinDem)
    ..f kk=1:1:stkbinLen d
    ...s tmpDepStkbin=$p(stkbin,stkbinDem,kk)
    ...s sortStkbin=sortStkbin_$j(tmpDepStkbin,10)
    .s sortIndex = $s(sortStkbin'="":sortStkbin, 1:"Z")
    e  i PrnTotalSortIndex="CODE" s sortIndex = inciCode
    e  i PrnTotalSortIndex="DESC" d
    .s inciDescPY=##class(ext.util.String).ToChineseSpell(inciDesc)
    .s sortIndex = inciDescPY
    s:sortIndex="" sortIndex = $s(stkbin'="":stkbin, 1:"Z")
    s patInfoStr = bedCode_"||"_patName
    s facqty = qty - resqty //冲减后实际需要发的数量
    i $d(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetTotalData",pid, mainIndex, sortIndex, inci)) d
    .s tStr = ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetTotalData",pid, mainIndex, sortIndex, inci)
    .s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetTotalData",pid, mainIndex, sortIndex, inci),"^",5)  = $p(tStr,"^",5) + qty
    .s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetTotalData",pid, mainIndex, sortIndex, inci),"^",6)  = $p(tStr,"^",6) + amt
    .s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetTotalData",pid, mainIndex, sortIndex, inci),"^",10) = $p(tStr,"^",10) + resqty
    .s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetTotalData",pid, mainIndex, sortIndex, inci),"^",14) = $p(tStr,"^",14) + facqty
    .s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetTotalData",pid, mainIndex, sortIndex, inci),"^",15) = $p(tStr,"^",15)_","_patInfoStr
    e  d
    .s ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetTotalData",pid, mainIndex, sortIndex, inci) = inciCode_"^"_inciDesc_"^"_sp_"^"_bUomDesc_"^"_qty_"^"_amt_"^"_inci_"^"_manf_"^"_drugform_"^"_resqty_"^"_stkbin_"^"_generic_"^"_spec_"^"_facqty_"^"_patInfoStr_"^"_bUomDesc //16
    //3.计算某患者某一药品的总数量
    i '$d(^||TMP("DHCST","web.DHCINPHA.Disp.Print","BedInciTotal",pid, mainIndex, inci, patInfoStr)) d
    .s ^||TMP("DHCST","web.DHCINPHA.Disp.Print","BedInciTotal",pid, mainIndex, inci, patInfoStr) = qty_"^"_bUomDesc
    e  d
    .s $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","BedInciTotal",pid, mainIndex, inci, patInfoStr),"^",1) = $p(^||TMP("DHCST","web.DHCINPHA.Disp.Print","BedInciTotal",pid, mainIndex, inci, patInfoStr),"^",1) + qty
    //4.计算冲减了哪些患者的药
    s resId=0
    f  s resId=$o(^DHCPRES(0,"TypePointer","P",iPhacChlSub,resId)) q:resId=""  d
    .s resItm=0
    .f  s resItm=$o(^DHCPRES(0,"TypePointer","P",iPhacChlSub,resId,resItm)) q:resItm=""  d
    ..s resItmSub=0
    ..f  s resItmSub=$o(^DHCPRES(resId,"DET",resItm,"SUB",resItmSub)) q:resItmSub=""  d
    ...q:+resItmSub=0
    ...s DHCPRESDETSUB=^DHCPRES(resId,"DET",resItm,"SUB",resItmSub)
    ...s retItmLbId=$p(DHCPRESDETSUB,"^",1)
    ...s resItmLbQty=$p(DHCPRESDETSUB,"^",2)
    ...s admId=$p(^PHARET(+retItmLbId,"I",$p(retItmLbId,"||",2)),"^",8)
    ...s patId=$p($g(^PAADM(+admId)),"^",1)
    ...s bedId=$p(^PHARET(+retItmLbId,"I",$p(retItmLbId,"||",2)),"^",10)
    ...s patName=$p(^PAPER(patId,"ALL"),"^",1) 
    ...i bedId'="" d
    ....s bedNo=$p($g(^PAWARD(+$p(bedId,"||",1),"BED",+$p(bedId,"||",2))),"^",1)
    ...e  s bedNo=""
    ...s patInfoStr = bedNo_"||"_patName_"||"_patId
    ...i $d(^||TMP("DHCST",$ClassName(),"BedInciResTotal",pid,mainIndex,inci,patInfoStr)) d
    ....s $p(^||TMP("DHCST",$ClassName(),"BedInciResTotal",pid,mainIndex,inci,patInfoStr),"^",1) = resItmLbQty + $p(^||TMP("DHCST",$ClassName(),"BedInciResTotal",pid,mainIndex,inci,patInfoStr),"^",1)
    ...e  d
    ....s ^||TMP("DHCST",$ClassName(),"BedInciResTotal",pid,mainIndex,inci,patInfoStr)=resItmLbQty_"^"_bUomDesc_"^"_patInfoStr
    q 1
    
SetKFYLabelData
    q:instDesc1'["口服" 1
    s mainIndex = bedCode_"||"_patName
    s byOrd = 0
    
    //1.有些医院按患者医嘱打印用法标签(只需要修改参数byOrd=1即可)
    i byOrd=1 d
    .//患者信息
    .i '$d(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetKFYLabelData", pid, mainIndex)) d
    ..s mainStr = wardDesc_"^"_patNo_"^"_patName_"^"_patSex_"^"_bedCode
    ..s ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetKFYLabelData", pid, mainIndex) = mainStr
    .//医嘱频次明细
    .i '$d(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetKFYLabelData", pid, mainIndex, oeori)) d
    ..s detailStr = arcimDesc_"^"_instDesc1_"^"_freqDesc1_"^"_""_"^"_""
    ..s ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetKFYLabelData", pid, mainIndex, oeori) = detailStr
    q:byOrd=1 1
    
    //2.按患者用药频次打印用法标签
    s dodisLen = $l(dodis,",")
    f ids=1:1:dodisLen d
    .s iDodis = $p(dodis,",",ids)
    .s iDodisTime = $p($g(^DHCOEDISQTY(iDodis)),"^",20)
    .s iDodisTime = ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(iDodisTime)
    .s iDodisDate = $p($g(^DHCOEDISQTY(iDodis)),"^",21)
    .s iDodisDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(iDodisDate)
    .//患者信息
    .i '$d(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetKFYLabelData", pid, mainIndex)) d
    ..s mainStr = wardDesc_"^"_patNo_"^"_patName_"^"_patSex_"^"_bedCode
    ..s ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetKFYLabelData", pid, mainIndex) = mainStr
    .//医嘱频次明细
    .i '$d(^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetKFYLabelData", pid, mainIndex, iDodis)) d
    ..s detailStr = arcimDesc_"^"_instDesc1_"^"_freqDesc1_"^"_iDodisDate_"^"_iDodisTime
    ..s ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetKFYLabelData", pid, mainIndex, iDodis) = detailStr
    q 1
SetKFYBag   
    // 长期口服药打印药袋 
    q:(phacTypeDesc'["口服")||(priority'="长期医嘱") 1   
    s iDodisTime = $p($g(^DHCOEDISQTY(dodis)),"^",20)
    s iDodisDate = $p($g(^DHCOEDISQTY(dodis)),"^",21)
    s mainIndex = bedCode_"||"_patName_"||"_iDodisDate_"||"_iDodisTime_"||"_instDesc1
    s index2 = dodis
    s iDodisTime = ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(iDodisTime)
    s iDodisDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(iDodisDate)
    //主签
    i '$d(^||TMP("DHCST",$classname(),"SetKFYBagData", pid, mainIndex)) d
    .s ^||TMP("DHCST",$classname(),"SetKFYBagDataPerson", pid,wardDesc_"^"_patNo)=$g(^||TMP("DHCST",$classname(),"SetKFYBagDataPerson", pid,wardDesc_"^"_patNo))+1
    .s mainStr = wardDesc_"^"_patNo_"^"_patName_"^"_patSex_"^"_bedCode_"^"_ patAge _"^"_ sysDateTime_"^"_iDodisDate_"^"_iDodisTime_"^"_instDesc1
    .s ^||TMP("DHCST",$classname(),"SetKFYBagData", pid, mainIndex) = mainStr
    //药品
    s detailStr = arcimDesc_"^"_freqDesc1_"^"_ doseQty _"^"_ spec 
    s ^||TMP("DHCST",$classname(),"SetKFYBagData", pid, mainIndex, index2) = detailStr

    q 1 
GetPhaCollDatasError
    s $ZT = ""
    k ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetDetailData",pid)
    k ^||TMP("DHCST","web.DHCINPHA.Disp.Print","SetTotalData",pid)
    k ^||TMP("DHCST","web.DHCINPHA.Disp.Print","BedInciTotal",pid)
    k ^||TMP("DHCST","web.DHCINPHA.Disp.Print", "SetKFYLabelData",pid)
    q -100_"^"_$ZE
}

/// Creator: Huxt 2019-11-27
/// Desc: 冲减退药单明细
/// Input: phacStr - phac1^phac2^phac3
/// Output: json字符串
/// w ##class(web.DHCINPHA.Disp.Print).ResRetDetailJsonData("68^90^95")
ClassMethod ResRetDetailJsonData(phacStr, otherStr = "")
{
    s retArr = ##class(web.DHCST.Array).%New()
    q:phacStr="" retArr.ToJSON()
    s $ZT = "ResRetDetailJsonDataError"
    s pid = ..NewPid()
    s phacLen = $l(phacStr,"^")
    s count = 0
    f i=1:1:phacLen d
    .s iPhac = $p(phacStr, "^", i)
    .q:iPhac=""
    .s wardID = $p(^DHCPHAC(iPhac),"^",4)       //病区
    .q:wardID=""
    .s wardDesc = $p($g(^PAWARD(wardID)),"^",2)
    .s phaLocID = $p(^DHCPHAC(iPhac),"^",1)     //发药科室
    .s phaLocDesc = $s(phaLocID'="":$p(^CTLOC(phaLocID),"^",2), 1:"")
    .s:phaLocDesc["-" phaLocDesc=$p(phaLocDesc,"-",2)
    .s hospID = $p($g(^CTLOC(phaLocID)),"^",22) //医院
    .s hospDesc = $p(^CT("HOSP",hospID),"^",2)
    .s phacType = $p(^DHCPHAC(iPhac),"^",12)    //发药类别代码
    .s phacTypeDesc = ..GetTypeDescByCode(phacType,hospID)
    .s phaUserID = $p(^DHCPHAC(iPhac),"^",5)    //发药人
    .s phaUserName = $s(phaUserID'="":$p(^SSU("SSUSR",phaUserID),"^",2), 1:"")
    .s phaDateH = $p(^DHCPHAC(iPhac),"^",2)     //发药日期
    .s phaDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phaDateH)
    .s dispNo = $p(^DHCPHAC(iPhac),"^",14)
    .
    .s chl = 0
    .f  s chl = $o(^DHCPHAC(iPhac,"I",chl))  q:chl=""  d
    ..s data = ^(chl)
    ..s prescNo = $p(data,"^",5)
    ..s bedCode = $p(data,"^",8)
    ..s adm = $p(data,"^",3)
    ..s papmi = $p(^PAADM(adm),"^",1)
    ..s patNo = $p(^PAPER(papmi,"PAT",1),"^",1)
    ..s patName = $p(^PAPER(papmi,"ALL"),"^",1)
    ..s patAge = ##class(PHA.FACE.IN.Com).GetAge(papmi,adm)
    ..s sex = $p(^PAPER(papmi,"ALL"),"^",7 )
    ..s patSex = $p(^CT("SEX",sex),"^",2)
    ..
    ..s sub = 0
    ..f  s sub = $o(^DHCPHAC(iPhac,"I",chl,"B",sub))  q:sub=""  d
    ...s phaItmLb = iPhac_"||"_chl_"||"_sub
    ...s inci = +$p(^DHCPHAC(iPhac,"I",chl,"B",sub),"^",1)
    ...s inciCode = $p(^INCI(inci,1),"^",1)
    ...s inciDesc = $p(^INCI(inci,1),"^",2)
    ...s arcim = $p(^INCI(inci,1),"^",3)
    ...s arcimDesc = $p(^ARCIM(+arcim,$p(arcim,"||",2),8),"^",21)
    ...s spec = ##class(web.DHCSTKUTIL).GetSpec(inci)
    ...
    ...s ResID = ""
    ...f  s ResID = $o(^DHCPRES(0,"TypePointer", "P", phaItmLb, ResID)) q:ResID=""  d
    ....s ResChl = ""
    ....f  s ResChl = $o(^DHCPRES(0,"TypePointer", "P", phaItmLb, ResID, ResChl)) q:ResChl=""  d
    .....//一个发药记录可能有多个退药申请单
    .....s ResSub=""
    .....f  s ResSub = $o(^DHCPRES(ResID,"DET",ResChl,"SUB",ResSub),-1) q:ResSub=""  d
    ......//冲减数量(大包装)
    ......s resQty = $p(^DHCPRES(ResID,"DET",ResChl,"SUB",ResSub),"^",2)
    ......s resQty = ..GetPackQty(inci, resQty)
    ......s resQty = ..FormatDecimal(resQty)
    ......//DHC_PhaReturnItm
    ......s phaRetItm = $p(^DHCPRES(ResID,"DET",ResChl,"SUB",ResSub),"^",1)
    ......s phaRetID = +phaRetItm
    ......s phaRetSub = $p(phaRetItm,"||",2)
    ......s oeori = $p(^PHARET(phaRetID,"I",phaRetSub),"^",1)
    ......s dodis = $p(^PHARET(phaRetID,"I",phaRetSub),"^",13)
    ......s retAdm = $p(^OEORD(+oeori),"^",1)
    ......s retPapmi = $p(^PAADM(retAdm),"^",1)
    ......s retPatNo = $p(^PAPER(retPapmi,"PAT",1),"^",1)
    ......s retPatName = $p(^PAPER(retPapmi,"ALL"),"^",1)
    ......s reqInfoStr = ..GetReqInfo(phaRetID,inci,oeori,dodis)
    ......s reqNo = $p(reqInfoStr,"^",1)
    ......s reqQty = $p(reqInfoStr,"^",2)
    ......
    ......//按phac分组(如不分组,s mianIndex=0)
    ......s mianIndex = iPhac_"|"_retPapmi
    ......b:iPhac=95
    ......s INCIArr(mianIndex) = dispNo_"^"_wardDesc_"^"_reqNo_"^"_bedCode_"^"_patNo_"^"_patName_"^"_patSex
    ......
    ......//每个phac按药品汇总
    ......i $d(INCIArr(mianIndex,patNo,inciCode)) d
    .......s $p(INCIArr(mianIndex,patNo,inciCode),"^", 7) = $p(INCIArr(mianIndex,patNo,inciCode),"^",7) + reqQty
    .......s $p(INCIArr(mianIndex,patNo,inciCode),"^", 8) = $p(INCIArr(mianIndex,patNo,inciCode),"^",8) + resQty
    .......s $p(INCIArr(mianIndex,patNo,inciCode),"^", 9) = $p(INCIArr(mianIndex,patNo,inciCode),"^",9)_","_reqNo
    .......s $p(INCIArr(mianIndex,patNo,inciCode),"^",10) = $p(INCIArr(mianIndex,patNo,inciCode),"^",10)_","_retPatName
    ......e  d
    .......s INCIArr(mianIndex,patNo,inciCode) = patNo_"^"_patName_"^"_patSex_"^"_bedCode_"^"_inciDesc_"^"_spec_"^"_reqQty_"^"_resQty_"^"_reqNo_"^"_retPatName
    b ;0
    
    s mIndex = ""
    f  s mIndex = $o(INCIArr(mIndex)) q:mIndex=""  d
    .s oneMainStr = INCIArr(mIndex)
    .s main = ##class(web.DHCST.Object).%New()
    .s main.dispNo = $p(oneMainStr,"^",1)
    .s main.wardDesc = $p(oneMainStr,"^",2)
    .s main.reqNo = $p(oneMainStr,"^",3)
    .s main.bedCode = $p(oneMainStr,"^",4)
    .s main.patNo = $p(oneMainStr,"^",5)
    .s main.patName = $p(oneMainStr,"^",6)
    .s main.patSex = $p(oneMainStr,"^",7)
    .
    .//明细
    .s detail = ##class(web.DHCST.Array).%New()
    .s pNo = ""
    .f  s pNo = $o(INCIArr(mIndex,pNo)) q:pNo=""  d
    ..s inciCode = ""
    ..f  s inciCode = $o(INCIArr(mIndex,pNo,inciCode)) q:inciCode=""  d
    ...s oneDetailStr = INCIArr(mIndex,pNo,inciCode)
    ...s oneDetail = ##class(web.DHCST.Object).%New()
    ...s oneDetail.patNo = $p(oneDetailStr,"^",1)
    ...s oneDetail.patName = $p(oneDetailStr,"^",2)
    ...s oneDetail.patSex = $p(oneDetailStr,"^",3)
    ...s oneDetail.bedCode = $p(oneDetailStr,"^",4)
    ...s oneDetail.inciDesc = $p(oneDetailStr,"^",5)
    ...s oneDetail.spec = $p(oneDetailStr,"^",6)
    ...s oneDetail.reqQty = $p(oneDetailStr,"^",7)
    ...s oneDetail.resQty = $p(oneDetailStr,"^",8)
    ...s oneDetail.reqNo = $p(oneDetailStr,"^",9)
    ...s oneDetail.retPatName = $p(oneDetailStr,"^",10)
    ...d detail.Insert(oneDetail)
    .
    .//分组
    .s oneGroupData = ##class(web.DHCST.Object).%New()
    .s oneGroupData.main = main
    .s oneGroupData.detail = detail
    .d retArr.Insert(oneGroupData)
    
    d retArr.WriteJSON()
    q ""
    
ResRetDetailJsonDataError
    s $ZT = ""
    q $ZE
}

/// Creator: Huxt 2019-11-27
/// Desc: 打印库存不足时返回数据
/// Input: Pid - 发药时产生的Pid
/// Output: json字符串
/// w ##class(web.DHCINPHA.Disp.Print).GetNoStock(1)
ClassMethod GetNoStock(Pid)
{
    s retArr = ##class(web.DHCST.Array).%New()
    q:Pid="" retArr.ToJSON()
    s dspId="" 
    f  s dspId=$o(^TMP("DHCST","web.DHCINPHA.Disp.Save","SaveData","NoStock",Pid,dspId)) q:dspId=""  d
    .s mGetNoStockD(dspId)=""
    q ..GetNoStockByDspData(.mGetNoStockD)
}

/// Creator: Huxt 2019-11-27
/// Desc: 草药处方打印的时候按照处方打印时获取处方号
/// Input: phacStr - phac1^phac2^phac3
/// Output: json字符串
/// w ##class(web.DHCINPHA.Disp.Print).GetPrescNoArr("131^132^133")
ClassMethod GetPrescNoArr(phacStr)
{
    s retArr = ##class(web.DHCST.Array).%New()
    s phacLen = $l(phacStr,"^")
    s count = 0
    f i=1:1:phacLen d
    .s iPhac = $p(phacStr, "^", i)
    .q:iPhac=""
    .s chl = ""
    .f  s chl = $o(^DHCPHAC(iPhac,"I",chl))  q:chl=""  d
    ..q:+chl=0
    ..s prescNo = $p($g(^DHCPHAC(iPhac,"I",chl)),"^",5)
    ..q:prescNo=""
    ..q:$d(prescNoArr(prescNo)) //去重
    ..s prescNoArr(prescNo) = ""
    ..d retArr.Insert(prescNo)
    d retArr.WriteJSON()
    q ""
}

/// Description: 住院发药打印口服药药袋返回json数据(一个袋子里面装一次用药的所有药)
/// Author:      zhaoxinlong 
/// CreatDate:   2022-04-20
/// Input: phacStr - phac1^phac2^phac3
/// Output: json: [{patInfo:{}, drugList:[{},{}]}, {{patInfo:{}, drugList:[{},{}]}, ...]
/// w ##class(web.DHCINPHA.Disp.Print).GetKFYBagJsonData("1723")
ClassMethod GetKFYBagJsonData(phacStr, otherStr = "", prtType = "")
{
    s retArr = ##class(web.DHCST.Array).%New()
    s retStr = ..GetPhaCollData(phacStr, otherStr, "KFYBag")
    s count = $p(retStr,"^",1)
    s pid = $p(retStr,"^",2)
    q:count<0 retStr
    q:count=0 retArr.ToJSON()
    s index1 = ""
    f  s index1 = $o(^||TMP("DHCST",$classname(),"SetKFYBagData", pid,index1)) q:index1=""  d
    .s oneMainStr = ^||TMP("DHCST",$classname(),"SetKFYBagData",pid, index1)
    .s main = ##class(web.DHCST.Object).%New()
    .s main.wardDesc = $p(oneMainStr,"^",1)
    .s main.patNo = $p(oneMainStr,"^",2)
    .s main.patName = $p(oneMainStr,"^",3)
    .s main.patSex = $p(oneMainStr,"^",4)
    .s main.bedCode = $p(oneMainStr,"^",5)
    .s main.patAge = $p(oneMainStr,"^",6)
    .s main.sysDateTime = $p(oneMainStr,"^",7)
    .s main.dosDate = $p(oneMainStr,"^",8)
    .s main.dosTime = $p(oneMainStr,"^",9)
    .s main.instDesc = $p(oneMainStr,"^",10)
    .i prtType="Total" d
    ..s ^||TMP("DHCST",$classname(),"SetKFYBagDataPatSeq", pid,$p(oneMainStr,"^",1)_"^"_$p(oneMainStr,"^",2))=$g(^||TMP("DHCST",$classname(),"SetKFYBagDataPatSeq", pid,$p(oneMainStr,"^",1)_"^"_$p(oneMainStr,"^",2)))+1
    ..s bagSeqNo = ^||TMP("DHCST",$classname(),"SetKFYBagDataPatSeq", pid,$p(oneMainStr,"^",1)_"^"_$p(oneMainStr,"^",2))
    ..s personBagNum =$g(^||TMP("DHCST",$classname(),"SetKFYBagDataPerson", pid,$p(oneMainStr,"^",1)_"^"_$p(oneMainStr,"^",2)))
    ..s bagSeqNo = bagSeqNo_"/"_personBagNum
    ..s main.bagSeqNo = bagSeqNo
    .//明细
    .s detail = ##class(web.DHCST.Array).%New()
    .s index2 = ""
    .f  s index2 = $o(^||TMP("DHCST",$classname(),"SetKFYBagData",pid,index1,index2)) q:index2=""  d
    ..s oneDetailStr = ^||TMP("DHCST",$classname(),"SetKFYBagData",pid,index1,index2)
    ..s oneDetail = ##class(web.DHCST.Object).%New()
    ..s oneDetail.arcimDesc = $p(oneDetailStr,"^",1)
    ..s oneDetail.freqDesc = $p(oneDetailStr,"^",2)
    ..s oneDetail.doseQty = $p(oneDetailStr,"^",3)
    ..s oneDetail.spec = $p(oneDetailStr,"^",4)
    ..d detail.Insert(oneDetail)
    .
    .//分组
    .s oneGroupData = ##class(web.DHCST.Object).%New()
    .s oneGroupData.main = main
    .s oneGroupData.detail = detail
    .d retArr.Insert(oneGroupData)
    
    k ^||TMP("DHCST",$classname(), "SetKFYBagData", pid)
    k ^||TMP("DHCST",$classname(),"SetKFYBagDataPatSeq", pid)
    k ^||TMP("DHCST",$classname(),"SetKFYBagDataPerson", pid)
    d retArr.WriteJSON()
    q ""
}

/// =========================以下为工具类方法=========================
/// Descript: 取病区
/// w ##class(web.DHCINPHA.Disp.Print).getWardDesc()
ClassMethod getWardDesc(adm As %String) As %String
{
    q:adm="" ""
    q:'$d(^PAADM(+adm)) ""
    s ward=$p(^PAADM(adm),"^",70)
    q:ward="" ""
    q:'$d(^PAWARD(+ward)) ""
    s warddesc=$p(^PAWARD(+ward),"^",2)
    q warddesc
}

/// Desc: 取医嘱备注
/// w ##class(web.DHCINPHA.Disp.Print).GetNotes()
ClassMethod GetNotes(moeori As %String) As %String
{
    Q:moeori="" ""
    s Notes=""
    S ord=$P(moeori,"||",1) Q:ord="" ""
    S itm=$P(moeori,"||",2) Q:itm="" ""
    f rnum=1:1:$G(^OEORD(ord,"I",itm,"DEP",0)) d
    .s Notes=Notes_$G(^OEORD(ord,"I",itm,"DEP",rnum))
    i $G(Notes)="" s Notes=""
    Q Notes
}

/// Desc: 草药医嘱的用法备注
/// w ##class(web.DHCINPHA.Disp.Print).GetCYNotes()
ClassMethod GetCYNotes(moeori As %String)
{
    s ord=$P(moeori,"||",1) Q:ord="" ""
    s itm=$P(moeori,"||",2) Q:itm="" ""
    q $p($g(^OEORD(ord,"I",itm,2)),"^",8)
}

ClassMethod GetBedQtyData(pid, mIndex, inci)
{
    s bedQtyData = ""
    s bedQtyStr = ..GetBedQtyStr(pid,mIndex,inci)
    s resQtyStr = ..GetBedResQtyStr(pid,mIndex,inci)
    i resQtyStr="" s bedQtyData=bedQtyStr
    e  d
    .s bedQtyData = "<div style='border-bottom:1px dashed black;'>"_bedQtyStr_"</div>"
    .s bedQtyData = bedQtyData_"<div>"_resQtyStr_"</div>"
    q bedQtyData
}

/// Desc:  获取床位发药数量字符串
/// w ##class(web.DHCINPHA.Disp.Print).GetBedQtyStr()
ClassMethod GetBedQtyStr(pid, mIndex, inci) As %String
{
    s bedQtyStr = ""
    s patIndex = ""
    f  s patIndex = $o(^||TMP("DHCST","web.DHCINPHA.Disp.Print","BedInciTotal",pid, mIndex, inci, patIndex)) q:patIndex=""  d
    .s bedQtyData = ^||TMP("DHCST","web.DHCINPHA.Disp.Print","BedInciTotal",pid, mIndex, inci, patIndex)
    .s bedQty = $p(bedQtyData,"^",1)
    .s bedQtyUom = $p(bedQtyData,"^",2)
    .s:$l($p(bedQty,".",2))>5 bedQty=$fn(bedQty,"",5) //最多5位小数
    .s bedQty = ..FormatDecimal(bedQty)
    .s bedNo = $p(patIndex,"||",1)
    .s patName = $p(patIndex,"||",2)
    .s bedPat=patName
    .i bedNo'="" s bedPat=bedNo_" "_bedPat
    .s oneBedQty = bedPat_"("_bedQty_bedQtyUom_")"
    .i bedQtyStr="" d
    ..s bedQtyStr = oneBedQty
    .e  d
    ..s bedQtyStr = bedQtyStr_","_oneBedQty
    q bedQtyStr
}

/// Desc:  获取床位发药数量字符串
/// w ##class(web.DHCINPHA.Disp.Print).GetBedResQtyStr()
ClassMethod GetBedResQtyStr(pid, mIndex, inci) As %String
{
    s bedQtyStr = ""
    s patIndex = ""
    f  s patIndex = $o(^||TMP("DHCST","web.DHCINPHA.Disp.Print","BedInciResTotal",pid,mIndex, inci, patIndex)) q:patIndex=""  d
    .s bedQtyData = ^||TMP("DHCST","web.DHCINPHA.Disp.Print","BedInciResTotal",pid,mIndex, inci, patIndex)
    .s bedQty = $p(bedQtyData,"^",1)
    .s bedQtyUom = $p(bedQtyData,"^",2)
    .q:+bedQty<=0
    .s:$l($p(bedQty,".",2))>5 bedQty=$fn(bedQty,"",5) //最多5位小数
    .s bedQty = ..FormatDecimal(-bedQty)
    .s bedNo = $p(patIndex,"||",1)
    .s patName = $p(patIndex,"||",2)
    .s bedPat=patName
    .i bedNo'="" s bedPat=bedNo_" "_bedPat
    .s oneBedQty = bedPat_"("_bedQty_bedQtyUom_")"
    .i bedQtyStr="" d
    ..s bedQtyStr = oneBedQty
    .e  d
    ..s bedQtyStr = bedQtyStr_","_oneBedQty
    q bedQtyStr
}

/// zdm,2010-11-12,徐州口服摆药单数量显示为一次用量
/// 如果剂量单位和基本单位能够整除，转换为基本单位对应量
/// 如果有小数，显示为原始剂
ClassMethod getBUomDoseQty(ord, itm)
{
    s doseqty=$p(^OEORD(ord,"I",itm,2),"^",1)
    q:doseqty="" ""
    s doseqty=##class(web.DHCSTKUTIL).NN(doseqty)  ;调整数字（使小数点前的"0"能够显示）
    s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
    s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
    s phcdf=$p(^ARCIM(sub,ver,1),"^",12)
    s doseunit=$p(^OEORD(ord,"I",itm,2),"^",3)
    q:phcdf="" ""   
    &sql(select PHCDF_CTUOM_DR into :buom
        from phc_drgform where phcdf_rowid=:phcdf)
    s qty=doseqty
    s uom=doseunit
    i $g(buom)'=doseunit  d
    .s fac=..getEquivQty(phcdf,doseunit)
    .q:fac=""
    .i '$f(doseqty/fac,".") d
    ..s qty=doseqty/fac
    ..s uom=buom
    s uomdesc=$p(^CT("UOM",uom),"^",2)
    q qty_"^"_uomdesc
}

ClassMethod getEquivQty(phcdf, doseUom)
{
    &sql(Select eq_qty into :doseequiv From PHC_FormDoseEquiv
         Where EQ_ParRef=:phcdf and EQ_CTUOM_DR=:doseUom)
    q:SQLCODE'=0 ""
    s doseequiv=##class(web.DHCSTKUTIL).NN(doseequiv) 
    q $g(doseequiv)
}

/// 获取用药时间字符串
/// w ##class(web.DHCINPHA.Disp.Print).GetDodisTimeStr("202469,202470,203998,203999")
ClassMethod GetDodisTimeStr(dodis)
{
    k mGetDodisTimeStrD
    s dodisnum = $l(dodis,",")
    s dodisi=0
    f dodisi=1:1:dodisnum d
    .s tmpdodis=$p(dodis,",",dodisi)
    .q:tmpdodis=""
    .s dodisitime=$p($g(^DHCOEDISQTY(tmpdodis)),"^",20)
    .s dodisdate=$p($g(^DHCOEDISQTY(tmpdodis)),"^",21)
    .s dodisdate=$p($zd(dodisdate,3),"-",2,3)
    .q:dodisitime=""
    .s dodisitime=$zt(dodisitime,2)
    .//i dodisitime["A" s dodisitime=+dodisitime_"a"
    .//e  s dodisitime=+dodisitime_"p"
    .
    .i $g(mGetDodisTimeStrD(dodisdate))="" s mGetDodisTimeStrD(dodisdate)=dodisdate_" "_dodisitime
    .e  d
    ..i $l(mGetDodisTimeStrD(dodisdate),",")<6 d
    ...s mGetDodisTimeStrD(dodisdate)=mGetDodisTimeStrD(dodisdate)_","_dodisitime
    ..e  d
    ...i mGetDodisTimeStrD(dodisdate)'["..." s mGetDodisTimeStrD(dodisdate)=mGetDodisTimeStrD(dodisdate)_"..."
    s dodistimestr = ""
    s dodisdate = ""
    f  s dodisdate=$o(mGetDodisTimeStrD(dodisdate),1,data) q:(dodisdate="")  d
    .i dodistimestr="" s dodistimestr=data
    .e  s dodistimestr=dodistimestr_";"_data
    q dodistimestr
}

ClassMethod getPackUomConFac(ord, itm)
{
    s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
    s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
    s phcdf=$p(^ARCIM(sub,ver,1),"^",12)
    s doseunit=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
    i doseunit'="" s doseunit=$p(^CT("UOM",doseunit),"^",2)
    q:phcdf="" ""
    &sql(select PHCDF_CTUOM_DR->ctuom_desc into :buom
        from phc_drgform where phcdf_rowid=:phcdf)
    s fac=##class(web.DHCSTCOMMONSRV).CTUOMFactor(doseunit,buom)
    q $g(fac)
}

/// Desc: 补零
/// w ##class(web.DHCINPHA.Disp.Print).ZeroPad(.1111)
ClassMethod ZeroPad(enum) As %String
{
    q $j(enum,"",$l($p(enum,".",2)))
}

/// 数字补0
/// w ##class(web.DHCINPHA.Disp.Print).FormatDecimal("-.5盒")
ClassMethod FormatDecimal(inputStr)
{
    q:inputStr'["." inputStr
    s num = $p(inputStr,".",1)
    q:num="-" "-0."_$p(inputStr,".",2,*)
    q:num="" "0"_inputStr
    q inputStr
}

/// 根据发药类别代码取发药类别描述
/// w ##class(web.DHCINPHA.Disp.Print).GetTypeDescByCode("ZJ")
ClassMethod GetTypeDescByCode(sdgCode, hosp = "")
{
    q:sdgCode="" ""
    s finalSDG=""
    s sdgId = ""
    f  s sdgId=$o(^DHCSTDRUGGRP(0,"Code",sdgCode,sdgId)) q:sdgId=""  d
    .q:+sdgId=0
    .q:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHCStkDrugGroup",sdgId,hosp)="N"
    .s finalSDG=sdgId
    q:finalSDG="" ""
    q $p($g(^DHCSTDRUGGRP(finalSDG)),"^",2)
}

/// Desc: 取包装单位数量
/// Input: inci-库存项ID; qty-基本单位数量
/// Output: 大单位数量 + 小单位数量,例如: 1盒2片
/// w ##class(web.DHCINPHA.Disp.Print).GetPackQty()
ClassMethod GetPackQty(inci, qty) As %String
{
    q:+qty=0 0
    s result = ""
    s buom = +$p(^INCI(inci,1),"^",10)
    s puom = +$p(^INCI(inci,3),"^",6)
    s:puom="" puom=buom
    s buomdesc = $p(^CT("UOM",buom),"^",2)
    s puomdesc = $p(^CT("UOM",puom),"^",2)
    s fac = ##class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)
    s packqty = qty\fac
    s restqty = qty-(packqty*fac)
    i packqty'=0 d
    . s result = packqty_""_puomdesc
    i (packqty<0)&(restqty<0) s restqty = -restqty
    s fmtrestqty = restqty
    i $l($p(fmtrestqty,".",2))>5 s fmtrestqty = $fn(fmtrestqty,"",5)
    s fmtrestqty = ..FormatDecimal(fmtrestqty)
    i restqty'=0 d
    .i result'="" d
    ..s result = result_""_fmtrestqty_""_buomdesc
    .e  d
    ..s result = fmtrestqty_""_buomdesc
    q result
}

/// Desc: 获取频率分发时间
/// w ##class(web.DHCINPHA.Disp.Print).GetFreqDispensingTime(11)
ClassMethod GetFreqDispensingTime(Freqrowid As %String) As %String
{
    s TPHCDTTime = ""
    s PHCDTTime = ""
    s Plist = ""
    s PHCDTChildSub = 0
    f  s PHCDTChildSub = $o(^PHCFR(Freqrowid,"DT",PHCDTChildSub)) q:PHCDTChildSub=""  d
    .s TStr = ^PHCFR(Freqrowid,"DT",PHCDTChildSub)
    .s TPHCDTTime = $p(TStr,"^",1)
    .s PHCDTTime = $zt(TPHCDTTime,1)
    .s Plist = Plist_","_PHCDTTime
    i Plist'="" s Plist=$p(Plist,",",2,$l(Plist,","))
    q Plist
}

/// Desc: 获取退药申请单信息
/// Table: DHC_PhaRetRequest
/// w ##class(web.DHCINPHA.Disp.Print).GetReqInfo()
ClassMethod GetReqInfo(phaRetID, inci, oeori, dodis)
{
    q:phaRetID="" ""
    s phaReqDr = $p(^PHARET(phaRetID),"^",4)
    q:phaReqDr="" ""
    s phaReqNo = ""
    s reqQtySum = 0
    s phaReqLen = $l(phaReqDr,",")
    f iReq = 1:1:phaReqLen d
    .s reqID = $p(phaReqDr,",",iReq)
    .q:reqID=""
    .q:'$d(^RETRQ(reqID))
    .s reqNo = $p($g(^RETRQ(reqID)),"^",1)
    .s:phaReqNo="" phaReqNo = reqNo
    .s phaReqNo = $s((phaReqNo[reqNo):phaReqNo, 1:phaReqNo_","_reqNo)
    .s phaReqChl = ""
    .f  s phaReqChl = $o(^RETRQ(reqID,"I",phaReqChl)) q:phaReqChl=""  d
    ..s reqQty = $p(^RETRQ(reqID,"I",phaReqChl),"^",3) //申请数量
    ..s reqOeori = $p(^RETRQ(reqID,"I",phaReqChl),"^",1)
    ..q:reqOeori'=oeori
    ..s reqDodis=$p(^RETRQ(reqID,"I",phaReqChl),"^",11)
    ..q:reqDodis'=dodis
    ..s reqQtySum = reqQtySum + reqQty
    s reqQtySum = ..GetPackQty(inci,reqQtySum)
    s reqQtySum = ..FormatDecimal(reqQtySum)
    q phaReqNo_"^"_reqQtySum
}

/// Desc: 打印标题前缀
/// w ##class(web.DHCINPHA.Disp.Print).GetTitlePrefix(246)
ClassMethod GetTitlePrefix(locID)
{
    q:locID="" ""
    s locDesc = $p($g(^CTLOC(locID)),"^",2)
    s:locDesc["-" locDesc = $p(locDesc,"-",2)
    s hospID = $p($g(^CTLOC(locID)),"^",22)
    q:hospID="" locDesc
    s hospDesc = $p(^CT("HOSP",hospID),"^",2)
    s:hospDesc["-" hospDesc = $p(hospDesc,"-",2)
    q hospDesc_locDesc
}

/// Desc: 获取发药类别 (返回类别代码)
/// w ##class(web.DHCINPHA.Disp.Print).GetDispType()
ClassMethod GetDispType(phac As %String = "") As %String
{
    q:phac="" ""
    q $p($g(^DHCPHAC(phac)),"^",12)
}

/// Creator: Huxt 2019-02-14
/// Desc: 根据科室获取住院药房打印配置
/// Input: locID - 登录科室ID
/// Output: json, 包含信息: 打印标题
/// w ##class(web.DHCINPHA.Disp.Print).GetPrintConfig(246)
ClassMethod GetPrintConfig(locID)
{
    q:locID="" "{}"
    s retJson = ##class(PHA.COM.Object).%New()
    s titlePrefix = ..GetTitlePrefix(locID)
    s retJson.titlePrefix = titlePrefix
    s plRowID = ""
    f  s plRowID = $o(^DHCPL(0,"Loc",locID,plRowID)) q:plRowID=""  d
    .s plChl = ""
    .f  s plChl = $o(^DHCPL(plRowID,"DIS",plChl)) q:plChl=""  d
    ..q:+plChl=0
    ..s drugTypeDR = $p($g(^DHCPL(plRowID,"DIS",plChl)),"^",1)
    ..q:drugTypeDR=""
    ..s drugTypeData = $g(^DHCSTDRUGGRP(drugTypeDR))
    ..s drugTypeCode = $p(drugTypeData,"^",1)
    ..q:drugTypeCode=""
    ..s oneObj = ##class(PHA.COM.Object).%New()
    ..s oneObj.printDetail = +$p(drugTypeData,"^",9)
    ..s oneObj.printTotal = +$p(drugTypeData,"^",10)
    ..s oneObj.printOther = $p(drugTypeData,"^",11)
    ..s oneObj.printResRet = +$p(drugTypeData,"^",12)
    ..s oneObj.isPreview = +$p(drugTypeData,"^",13)
    ..s oneObj.printNoStock = +$p(drugTypeData,"^",14)
    ..s oneObj.detailGroupByPat = ""
    ..i $p(drugTypeData,"^",11) = "ControlPrintOutGroupByPat" d
    ...s oneObj.printOther = $replace(oneObj.printOther, "ControlPrintOutGroupByPat" ,"") // 带有control标记, 用于打印控制而已, 2023-02-02, yunhaibao
    ...s oneObj.detailGroupByPat = 1
    ..d retJson.Set(drugTypeCode, oneObj)
    q retJson.ToJSON()
}

/// w ##class(web.DHCINPHA.Disp.Print).NewPid()
ClassMethod NewPid()
{
    q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"IP")
}

/// w ##class(web.DHCINPHA.Disp.Print).GetNoStockByPhac(2036)
ClassMethod GetNoStockByPhac(phacIDStr)
{
    for i = 1 : 1 : $l(phacIDStr, "^") {
        s phacID = $p(phacIDStr, "^", i)
        continue:(phacID = "")
        s dsp = ""
        for {
            s dsp = $o(^BS.PHA.IP.NoStocki("PHACDSP", phacID, dsp)) q:(dsp = "")
            s mGetNoStockByPhacD(dsp) = ""
        }   
    }
    q ..GetNoStockByDspData(.mGetNoStockByPhacD)
}

ClassMethod GetNoStockByDspData(ByRef pDspData)
{
    s retArr = ##class(web.DHCST.Array).%New()
    s dspId="" 
    f  s dspId=$o(pDspData(dspId)) q:dspId=""  d
    .s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
    .s wardLocId=$p(^DHCOEDISQTY(dspId),"^",22)
    .s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
    .s wardDesc=$p(^PAWARD(wardId),"^",2)
    .s admId=$p(^OEORD(+oeori),"^",1)
    .s patId=$p(^PAADM(admId),"^",1)
    .s patName=$p(^PAPER(patId,"ALL"),"^",1) 
    .s patNo=$p(^PAPER(patId,"PAT",1),"^",1) 
    .s bedNo=$p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(admId,wardLocId),"^",2)
    .i bedNo="" s bedNo="*"
    .s patSex=$p($g(^PAPER(patId,"ALL")),"^",7)
    .s patSex=$p($g(^CT("SEX",+patSex)),"^",2)
    .s recLocId=$p($g(^DHCOEDISQTY(dspId)),"^",24)
    .s recLocDesc=$p(^CTLOC(recLocId),"^",2)
    .s dspSub=""
    .f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
    ..q:+dspSub=0
    ..s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
    ..s incId=$p(dspSubData,"^",5)
    ..s qty=$p(dspSubData,"^",2)
    ..//主信息
    ..i '$d(PrintNoStockData(wardId,patNo)) d
    ...s PrintNoStockData(wardId,patNo) = wardDesc_"^"_patNo_"^"_patName_"^"_bedNo_"^"_patSex
    ..//明细
    ..i '$d(PrintNoStockData(wardId,patNo,incId)) d
    ...s incDesc=$p(^INCI(incId,1),"^",2)
    ...s uomId=$p(^INCI(incId,1),"^",10)
    ...s uomDesc=$p(^CT("UOM",uomId),"^",2)
    ...s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",incId)
    ...s data1=wardId_"^"_wardDesc_"^"_patNo_"^"_patName_"^"_patSex
    ...s data2=bedNo_"^"_incId_"^"_incDesc_"^"_qty_"^"_uomDesc
    ...s data3=spec_"^"_recLocDesc
    ...s data=data1_"^"_data2_"^"_data3
    ...s PrintNoStockData(wardId,patNo,incId)=data
    ..e  d
    ...s $p(PrintNoStockData(wardId,patNo,incId),"^",9)=$p(PrintNoStockData(wardId,patNo,incId),"^",9)+qty
    
    //输出JSON
    s wardId = ""
    f  s wardId = $o(PrintNoStockData(wardId)) q:wardId=""  d
    .s patNo = ""
    .f  s patNo = $o(PrintNoStockData(wardId,patNo)) q:patNo=""  d
    ..s oneMainStr = PrintNoStockData(wardId,patNo)
    ..s main = ##class(web.DHCST.Object).%New()
    ..s main.wardDesc = $p(oneMainStr,"^",1)
    ..s main.patNo = $p(oneMainStr,"^",2)
    ..s main.patName = $p(oneMainStr,"^",3)
    ..s main.bedCode = $p(oneMainStr,"^",4)
    ..s main.patSex = $p(oneMainStr,"^",5)
    ..
    ..//明细
    ..s detail = ##class(web.DHCST.Array).%New()
    ..s incId = ""
    ..f  s incId = $o(PrintNoStockData(wardId,patNo,incId)) q:incId=""  d
    ...s oneDetailStr = PrintNoStockData(wardId,patNo,incId)
    ...s oneDetail = ##class(web.DHCST.Object).%New()
    ...s oneDetail.wardId = $p(oneDetailStr,"^",1)
    ...s oneDetail.wardDesc = $p(oneDetailStr,"^",2)
    ...s oneDetail.patNo = $p(oneDetailStr,"^",3)
    ...s oneDetail.patName = $p(oneDetailStr,"^",4)
    ...s oneDetail.patSex = $p(oneDetailStr,"^",5)
    ...s oneDetail.bedNo = $p(oneDetailStr,"^",6)
    ...s oneDetail.incId = $p(oneDetailStr,"^",7)
    ...s oneDetail.incDesc = $p(oneDetailStr,"^",8)
    ...s oneDetail.qty = $p(oneDetailStr,"^",9)
    ...s oneDetail.uomDesc = $p(oneDetailStr,"^",10)
    ...s oneDetail.spec = $p(oneDetailStr,"^",11)
    ...s oneDetail.recLocDesc = $p(oneDetailStr,"^",12)
    ...d detail.Insert(oneDetail)
    ..
    ..//分组
    ..s oneGroupData = ##class(web.DHCST.Object).%New()
    ..s oneGroupData.main = main
    ..s oneGroupData.detail = detail
    ..d retArr.Insert(oneGroupData)
    d retArr.WriteJSON()
    q ""
}

/// Description: 将明细按照患者信息拆分存到数组的
/// Creator:     yunhaibao
/// CreateDate:  2023-02-02
/// Input:       phacStr - phac1^phac2^phac3
/// Return:      .%ToJSON
/// Output:      [{main:{}, detail:[{},{}]}, {{main:{}, detail:[{},{}]}, ...]
/// w ##class(web.DHCINPHA.Disp.Print).GetDetailJsonGroupByPat("2961")
ClassMethod GetDetailJsonGroupByPat(phacStr, otherStr = "")
{
    s retArr = [] // ##class(web.DHCST.Array).%New()
    s retStr = ..GetPhaCollData(phacStr, otherStr, "Detail")
    s count = $p(retStr, "^", 1)
    s pid = $p(retStr, "^", 2)
    q:(count < 0) retStr
    q:(count = 0) retArr.%ToJSON()
    
    #; 按发药单患者排序
    merge mTmpData = ^||TMP("DHCST", "web.DHCINPHA.Disp.Print", "SetDetailData", pid)
    k ^||TMP("DHCST", "web.DHCINPHA.Disp.Print",  "SetDetailData", pid)
    s mainIndex = ""
    for {
        s mainIndex = $o(mTmpData(mainIndex), 1, oneMainStr) q:(mainIndex = "")

        s dispNo = $p(oneMainStr, "^", 3)
        s subIndex = 0
        for {
            s subIndex = $o(mTmpData(mainIndex, subIndex), 1, oneMainStr) q:(subIndex = "")
            s packFlag = ""
            for {
                s packFlag = $o(mTmpData(mainIndex, subIndex, packFlag), 1) q:(packFlag = "")
                s oeori = ""
                for {
                    s oeori = $o(mTmpData(mainIndex, subIndex, packFlag, oeori), 1, oneDetailStr) q:(oeori = "")
                    s patNo = $p(oneDetailStr, "^", 1)
                    s oneDetail = {}
                    s oneDetail.bedNo = $p(oneDetailStr,"^",6)
                    s oneDetail.patNo = $p(oneDetailStr,"^",1)
                    s oneDetail.patName = $p(oneDetailStr,"^",2)
                    s oneDetail.inciDesc = $p(oneDetailStr,"^",11)
                    s oneDetail.doseQty = $p(oneDetailStr,"^",14)
                    s oneDetail.uomDesc = $p(oneDetailStr,"^",17)
                    s oneDetail.freqDesc = $p(oneDetailStr,"^",15)
                    s oneDetail.instDesc = $p(oneDetailStr,"^",22)
                    s oneDetail.timeDosingStr = $p(oneDetailStr,"^",47)
                    s oneDetail.spec = $p(oneDetailStr,"^",31)
                    s oneDetail.qty = $fn($p(oneDetailStr,"^",16), "N")
                    s oneDetail.oeori = $p(oneDetailStr,"^",50)
                    s oneDetail.amtSum = $p(oneDetailStr,"^",20)
                    if ('$d(mGetDetailJsonGroupByPatD(dispNo, patNo))){
                        s main = {}
                        s main.patName = oneDetail.patName
                        s main.patNo = oneDetail.patNo
                        s main.bedNo = oneDetail.bedNo
                        s main.wardDesc = $p(oneMainStr,"^",1)
                        s main.phaType = $p(oneMainStr,"^",2)
                        s main.dispNo = $p(oneMainStr,"^",3)
                        s main.phaDate = $p(oneMainStr,"^",4)
                        s main.sysDateTime = $p(oneMainStr,"^",5)
                        s main.phaUserName = $p(oneMainStr,"^",6)
                        s main.phaCollectUserName = $p(oneMainStr,"^",7)
                        s main.phaCollateUserName = $p(oneMainStr,"^",8)
                        s mGetDetailJsonGroupByPatD(dispNo, patNo) = main
                    }
                    s itmIndex = oeori
                    s mGetDetailJsonGroupByPatD(dispNo, patNo, itmIndex) = oneDetail
                }
            }
        }
    }
    #; 仅输出
    s retArr = []
    s dispNo = ""
    for {
        s dispNo = $o(mGetDetailJsonGroupByPatD(dispNo)) q:(dispNo = "")
        s patNo = ""
        for {
            s patNo = $o(mGetDetailJsonGroupByPatD(dispNo, patNo)) q:(patNo = "")
            s amtSum = 0
            s detailArr = []
            s itmIndex = ""
            for {
                s itmIndex = $o(mGetDetailJsonGroupByPatD(dispNo, patNo, itmIndex)) q:(itmIndex = "")
                s detailObj = $g(mGetDetailJsonGroupByPatD(dispNo, patNo, itmIndex))
                d detailArr.%Push(detailObj)
                s amtSum = amtSum + detailObj.amtSum
            }
            s row = {}
            s row.main = mGetDetailJsonGroupByPatD(dispNo, patNo)
            s row.main.amtSum = ..FormatDecimal(amtSum)
            s row.detail = detailArr
            d retArr.%Push(row)
        }
    }
    d retArr.%ToJSON()
    q ""
}

}
