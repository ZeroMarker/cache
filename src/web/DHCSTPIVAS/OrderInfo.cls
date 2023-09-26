/// Description: 辅助审核相关信息
Class web.DHCSTPIVAS.OrderInfo Extends web.DHCSTPIVAS.Common
{

/// Description: 获取医嘱详细信息
/// Input:       MOeori (主医嘱ID)
/// w ##class(web.DHCSTPIVAS.OrderInfo).GetOrderJson("1093||48")
ClassMethod GetOrderJson(MOeori, Loc)
{
    s retJson={}
    s order={}
    s drugs={}
    /* 基本用药信息 */
    s mOrd=+MOeori
    s mOrdItm=$p(MOeori,"||",2)                         
    s admId=$p(^OEORD(mOrd),"^",1) 
    s patId=$p(^PAADM(admId),"^",1)                                         
    s patName=$p(^PAPER(patId,"ALL"),"^",1)
    s patNo=$P(^PAPER(patId,"PAT",1),"^",1)
    s bedId=$P(^PAADM(admId),"^",73)
    s bedNo="*" 
    i bedId'="" s bedNo=$p($g(^PAWARD(+bedId,"BED",+$p(bedId,"||",2))),"^",1)
    s patSex=$p($g(^PAPER(patId,"ALL")),"^",7)
    s patSex=##class(PHA.COM.Data.Base).SexDesc(patSex)
    s patAge=##class(web.DHCSTKUTIL).GetAge(patId,admId)
    s medNo=##class(web.DHCSTInterfaceFromElse).IGetMrNoByPatientID(patId)          //病案号
    s freqDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(MOeori),"^",3)
    s instrucDesc=$p(##class(web.DHCSTPIVAS.Common).OeoriInstruc(MOeori),"^",2)
    s doctorName=$p(##class(web.DHCSTPIVAS.Common).OeoriDoctor(MOeori),"^",2)
    s passResultStr=##Class(web.DHCSTPIVAS.Common).GetOrdPassState(MOeori,"",1)
    s phaOrdId=$p(passResultStr,"^",3)
    s passResultDesc=$p(passResultStr,"^",2)
    i passResultDesc="审核通过" s passResultDesc="通过"
    e  i passResultDesc="审核拒绝" s passResultDesc="拒绝"
    i passResultDesc="" s passResultDesc="未审"
    i phaOrdId'="" d
    .i $p(^DHCPHORDM(phaOrdId),"^",8)="A" s passResultDesc="申诉"
    s pivaCatStr=##class(web.DHCSTPIVAS.Common).GetOrdPivaCat(MOeori)
    s pivaCatDesc=$p(pivaCatStr,"^",3)
    s patWeight=##class(web.DHCSTPIVAS.Common).GetMrObsItm(admId,"weight")
    i patWeight="" s patWeight=##class(web.DHCSTPIVAS.Common).GetPatWeight(admId)
    s patHeight=##class(web.DHCSTPIVAS.Common).GetMrObsItm(admId,"height")
    i patHeight="" s patHeight=##class(web.DHCSTPIVAS.Common).GetPatHeight(admId)
    s diag=##class(PHA.COM.Order).MrDiagnose(admId,", ")
    s ivgttSpeed=##class(web.DHCSTPIVAS.Common).OeoriIvgttSpeed(MOeori)
    s area=##class(web.DHCSTPIVAS.Common).CalcuSurfaceArea(patSex,patHeight,patWeight)
    s docRemark=##class(web.DHCSTPIVAS.Common).OeoriRemark(MOeori)
    s exceedReason=$p(##class(web.DHCSTPIVAS.Common).OeoriExceedReason(MOeori,""),"^",2)
    i exceedReason'="" d
    .s docRemark=$s(docRemark="":"超量原因:"_exceedReason,1:docRemark_" ; "_"超量原因:"_exceedReason)
    s fOrdItmExe=$o(^OEORD(+MOeori,"I",+$p(MOeori,"||",2),"X",""),-1)
    s liquid=##class(web.DHCSTPIVAS.Common).OrderLiquid(MOeori,MOeori_"||"_fOrdItmExe)
    s patSpec=##class(web.DHCSTPIVAS.Common).GetPatSpec(admId)
    s warnStyle="color:#ff584c;font-weight:bold;"
    i patSpec'="" d
    .s patSpec="<span style="_warnStyle_">"_patSpec_"</span>"
    .s diag=patSpec_"  "_diag
    i patHeight="" s patHeight="<span style="_warnStyle_">"_..Translate("无身高")_"</span>"
    i patWeight="" s patWeight="<span style="_warnStyle_">"_..Translate("无体重")_"</span>"
    s orderRemark = ##class(web.DHCSTPIVAS.Remark).Get("PIVASOrder", MOeori)
    s executeRemark = ##class(web.DHCSTPIVAS.Remark).Get("PIVASExecute", MOeori)
    s labelRemark = ##class(web.DHCSTPIVAS.Remark).Get("PIVASLabel", MOeori)    
    s phaRemark = ##class(web.DHCSTPIVAS.Common).ConnactString("; ", orderRemark, executeRemark, labelRemark)
    s order.oeBedNo=bedNo
    s order.oePatNo=patNo
    s order.oePatName=patName
    s order.oePatSex=patSex
    s order.oePatAge=patAge
    s order.oePatHeight=patHeight
    s order.oePatWeight=patWeight
    s order.oeFreq=freqDesc
    s order.oeInstruc=instrucDesc
    s order.oeDoctor=doctorName
    s order.oePriDesc=$e($p(##class(web.DHCSTPIVAS.Common).OeoriPriority(MOeori),"^",3),1,2)
    s order.oePassDesc=passResultDesc
    s order.oeDocRemark=docRemark
    s order.oePivaCat=pivaCatDesc
    s order.oeDiag=diag
    s order.oeIvgttSpeed=ivgttSpeed
    s order.oePhaRemark=phaRemark
    s order.oePatArea=area
    s order.oeLiquid=liquid_"ml"
    // 前台默认出发的查询
    s kwWord=""
    s order.kwWord=kwWord
    /* 药品医嘱,主要在前 */
    s drugs.total=999
    s rows=[]   
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
    .s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
    .s qty=$P(^DHCOEDISQTY(dspId),"^",11)
    .s bUom=$p(^INCI(incId,1),"^",10)
    .s compFlag=##class(web.DHCSTPIVAS.Common).DosageCompFlag(oeori,bUom)
    .s moreFlag=$s(qty>1:"Y",1:"N")
    .s incDescStyle="!!"_moreFlag_"!!"_compFlag
    .s drugIObj={}
    .s drugIObj.oeoriName=incDesc
    .s drugIObj.spec=incSpec
    .s drugIObj.dosage=dosage
    .s drugIObj.arcim=$P($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",2)
    .s drugIObj.incDescStyle=incDescStyle
    .d rows.%Push(drugIObj)
    s drugs.rows=rows
    s retJson.order=order
    s retJson.drugs=drugs
    q retJson.%ToJSON()
}

/// Description: 用药历史记录,遍历患者历次就诊,执行记录为已执行的
/// Input:       ^1(就诊Id),^2(类型)(化疗药<Chemotherapeutic>)
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.OrderInfo","MedHistory","4^Chemotherapeutic")
Query MedHistory(InputStr) As websys.Query(ROWSPEC = "doseDate,oeoriInfo")
{
}

ClassMethod MedHistoryExecute(ByRef qHandle As %Binary, InputStr) As %Status
{
    k MedHistoryDATA
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    q:InputStr="" $$$OK
    s Adm=$p(InputStr,"^",1)
    s MedType=$p(InputStr,"^",2)
    q:(Adm="")||(MedType="") $$$OK
    s lastDate=+$h-1
    s patId=$p(^PAADM(Adm),"^",1)
    s admType=""
    f  s admType=$o(^PAPERdr(patId,"ADM",admType)) q:admType=""  d
    .q:admType'="I"
    .s admId=""
    .f  s admId=$o(^PAPERdr(patId,"ADM",admType,admId)) q:admId=""  d
    ..s ordId=$o(^OEORD(0,"Adm",admId,""))
    ..q:ordId=""
    ..s ordItm=""
    ..f  s ordItm=$o(^OEORD(ordId,"I",ordItm)) q:ordItm=""  d
    ...q:+ordItm=0
    ...s oeori=ordId_"||"_ordItm
    ...s arcim=$p($g(^OEORD(+ordId,"I",+ordItm,1)),"^",2)
    ...q:arcim=""
    ...q:(MedType="Chemotherapeutic")&&(##class(web.DHCSTPIVAS.Common).GetChemotherapeuticByArc(arcim)'="Y") // 化疗药
    ...q:'$d(^DHCOEDISQTY(0,"OEORI",oeori))
    ...q:$p(##class(web.DHCSTPIVAS.Common).GetArcItmCatByOeori(oeori),"^",4)'="R"
    ...s ordExe=""
    ...f  s ordExe=$o(^OEORD(ordId,"I",ordItm,"X",ordExe)) q:ordExe=""  d
    ....q:+ordExe=0
    ....s oeore=oeori_"||"_ordExe
    ....s dspId=$o(^DHCOEDISQTY(0,"OEORE",oeore,""))
    ....q:dspId=""
    ....s DHCOEDISQTY=$g(^DHCOEDISQTY(dspId))
    ....s doseDate=$p(DHCOEDISQTY,"^",21)
    ....q:doseDate=""
    ....q:doseDate>lastDate
    ....s oeoreStatus=$p(^OEORD(+oeore,"I",+$p(oeore,"||",2),"X",+$p(oeore,"||",3)),"^",16) 
    ....q:oeoreStatus=""
    ....q:(oeoreStatus'="")&&($p($g(^OEC("STAT",oeoreStatus)),"^",1)'="F")  
    ....s MedHistoryDATA(doseDate,+oeori,+$p(oeori,"||",2))=oeori
    s doseDate=""
    f  s doseDate=$o(MedHistoryDATA(doseDate)) q:doseDate=""  d
    .s doseDateH=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(doseDate)
    .s ordId="" 
    .f  s ordId=$o(MedHistoryDATA(doseDate,ordId)) q:ordId=""  d
    ..s ordItm=""
    ..f  s ordItm=$o(MedHistoryDATA(doseDate,ordId,ordItm)) q:ordItm=""  d
    ...s arcim=$p(^OEORD(+ordId,"I",+ordItm,1),"^",2)
    ...s arcimDesc=##class(PHA.COM.Data.Base).ArcimDesc(arcim)
    ...s dosage=##class(web.DHCSTPIVAS.Common).OeoriDosage(ordId_"||"_ordItm)
    ...s freqDesc=$p(##class(web.DHCSTPIVAS.Common).OeoriFreq(ordId_"||"_ordItm),"^",2)
    ...s oeoriInfo=arcimDesc_" / "_dosage_" / "_freqDesc
    ...s ^CacheTemp(repid,ind)=$lb(doseDateH,oeoriInfo) 
    ...s ind=ind+1
    q $$$OK
}

/// Description: 药品说明信息
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.OrderInfo","OrderMedInfo","108||14",248)
Query OrderMedInfo(MOeori = "", LocId = "") As websys.Query(ROWSPEC = "arcimDesc,drugInfo,sameCnt")
{
}

ClassMethod OrderMedInfoExecute(ByRef qHandle As %Binary, MOeori = "", LocId = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    q:MOeori=""
    s liquid=##class(web.DHCSTPIVAS.Common).OrderLiquid(MOeori)
    s oeoriStr=##class(web.DHCSTPIVAS.Common).GetOeoriStrOrderByMP(MOeori,LocId)
    // 按医嘱项合并,同样主药在前
    s oeoriI=""
    f oeoriI=1:1:$l(oeoriStr,"^") d
    .s oeori=$p(oeoriStr,"^",oeoriI)
    .q:oeori=""
    .s arcim=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",2)
    .s doseMG=##class(web.DHCSTPIVAS.Common).GetDoseEqualQtyWithUom(oeori,"MG")
    .i '$d(OrderMedInfoDATA("Arc",arcim)) d
    ..s OrderMedInfoDATA("Arc",arcim)=doseMG_"^"_1_"^"_oeori    // 相同医嘱,留一个oeori调知识库
    ..s OrderMedInfoDATA("SortArc",oeoriI,arcim)="" 
    .e  d
    ..s $p(OrderMedInfoDATA("Arc",arcim),"^",1)=$p(OrderMedInfoDATA("Arc",arcim),"^",1)+doseMG
    ..s $p(OrderMedInfoDATA("Arc",arcim),"^",2)=$p(OrderMedInfoDATA("Arc",arcim),"^",2)+1
    
    s sort=""
    f  s sort=$o(OrderMedInfoDATA("SortArc",sort)) q:sort=""  d
    .s arcim=""
    .f  s arcim=$o(OrderMedInfoDATA("SortArc",sort,arcim)) q:arcim=""  d
    ..k OrderMedInfoDATA("OneData")
    ..s data=OrderMedInfoDATA("Arc",arcim)
    ..s sameCnt=$p(data,"^",2)
    ..i sameCnt>1 s OrderMedInfoDATA("OneData",$i(rowICnt),"药品重复")=sameCnt
    ..s doseMG=$p(data,"^",1)
    ..s oeori=$p(data,"^",3)
    ..s arcimDesc=##class(PHA.COM.Data.Base).ArcimDesc(arcim)
    ..s phcdfId=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcim)
    ..s phcdId=+phcdfId
    ..q:phcdId=0
    ..i (+doseMG>0)&&(+liquid>0) d
    ...s calcuVal=$fn(doseMG/liquid,"",2)_" mg/ml"
    ...s OrderMedInfoDATA("OneData",$i(rowICnt),"浓度")=calcuVal
    ..s ivgttSpeed=$p($g(^PHCD(phcdId,"DF",1,"DHC")),"^",13)
    ..i ivgttSpeed'="" s OrderMedInfoDATA("OneData",$i(rowICnt),"滴速")=ivgttSpeed
    ..s inci=$o(^INCI(0,"ARCIM_DR",+arcim,""))
    ..i inci'="" d
    ...s inciCh=$o(^INCI("IL_LOC",LocId,inci,""))
    ...q:inciCh=""
    ...s incil=inci_"||"_inciCh
    ...s dhcIncil=$o(^DHCINCIL(0,"INCIL",incil,""))
    ...q:dhcIncil=""
    ...s useInfo=$p($g(^DHCINCIL(dhcIncil,"PIVAS")),"^",1)
    ...i useInfo'="" s OrderMedInfoDATA("OneData",$i(rowICnt),"用药说明")=useInfo
    ..// 调知识库数据
    ..d ##class(web.DHCSTPIVAS.Common).GetLibPhaMedTips(.MedTips,oeori)
    ..s tipSort=""
    ..f  s tipSort=$o(MedTips(tipSort)) q:tipSort=""  d
    ...s tipType=""
    ...f  s tipType=$o(MedTips(tipSort,tipType)) q:tipType=""  d
    ....s OrderMedInfoDATA("OneData",$i(rowICnt),tipType)=MedTips(tipSort,tipType)
    ..q:'$d(OrderMedInfoDATA("OneData"))
    ..s drugInfo=""
    ..s rowI="" 
    ..f  s rowI=$o(OrderMedInfoDATA("OneData",rowI)) q:rowI=""  d
    ...s desc=""
    ...f  s desc=$o(OrderMedInfoDATA("OneData",rowI,desc)) q:desc=""  d
    ....// 单行div
    ....s titleHtml="<div style=float:left;text-align-last:justify;width:4em;color:#777777;>"_desc_"</div><div style=float:left;padding-left:5px;padding-right:5px;;color:#777777;>:</div>"
    ....s dataHtml="<div style=float:left;width:350px;>"_OrderMedInfoDATA("OneData",rowI,desc)_"</div>"
    ....s oneData="<div style=clear:both;line-height:20px>"_titleHtml_dataHtml_"</div>"
    ....i drugInfo="" s drugInfo=oneData
    ....e  s drugInfo=drugInfo_oneData
    ..q:drugInfo="" 
    ..s Data=$lb(arcimDesc,drugInfo,sameCnt)
    ..s ^CacheTemp(repid,ind)=Data    
    ..s ind=ind+1
    Quit $$$OK
}

}
