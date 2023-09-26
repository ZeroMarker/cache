Import sqluser

/// creator:yunhaibao
/// createdate:20160929
/// descirpiton:住院医生科室发药
Class web.DHCINPHA.DispDocLoc Extends %RegisteredObject [ ProcedureBlock ]
{

/// creator:yunhaibao
/// createdate:20160929
/// descirpiton:获取医生科室发药科室列表
/// w ##class(web.DHCINPHA.DispDocLoc).jsQueryDispDocLocList(1,30,"2016-01-28!!2016-09-30!!98")
ClassMethod jsQueryDispDocLocList(page, rows, params, style)
{
    q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
    s page=1
    s rows=1000
    s endpage=page*rows  //结束行
    s stpage=((page-1)*rows)+1 //开始行
    s cellSplit="!!"
    s startDate=$p(params,cellSplit,1)
    
    s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
    s endDate=$p(params,cellSplit,2)
    s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
    s phaLoc=$p(params,cellSplit,3)
    s ReturnPid=##class(web.DHCSTPCHCOLLSDOCLOC).CollectDispDocLoc(phaLoc,startDate,endDate,"","")
    q:ReturnPid="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
    s phaDispTypeStr=##class(web.DHCINPHA.InfoCommon).GetPhaDispType(phaLoc)
    s colNameStr="TDocLocRowID^TDocLoc^"_phaDispTypeStr
    s collength=$l(colNameStr,"^")
    s count=0
    s doclocrowid=""
    f  s doclocrowid=$o(^TMP("dhcpha",ReturnPid,"DocLoc","DispCat",doclocrowid)) q:doclocrowid=""  d
    .s doclocdesc=##class(PHA.COM.Data.Base).LocDesc(doclocrowid)
    .s outputdata=doclocrowid_"^"_doclocdesc
    .s coli=0
    .f coli=3:1:collength d
    ..s coldisptype=$p(colNameStr,"^",coli)
    ..i $d(^TMP("dhcpha",ReturnPid,"DocLoc","DispCat",doclocrowid,coldisptype)) d
    ...s $p(outputdata,"^",coli)="Y"
    ..e  s $p(outputdata,"^",coli)=""
    .q:outputdata=""
    .s count=count+1 
    .I count=stpage d
    ..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(1)
    ..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
    .e  d
    ..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
    i count>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
    k ^TMP("dhcpha",ReturnPid,"DocLoc","DispCat")
    q:count=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
    q ""
}

/// creator:yunhaibao
/// createdate:20160929
/// description:住院医生科室发药汇总明细统一入口,json版本
/// w ##CLASS(web.DHCINPHA.DispDocLoc).jsQueryInDispDocLoc(1,999,"98!!2017-02-09!!2017-02-11!!578!!PTFY!!10!!!!","total","","")
ClassMethod jsQueryInDispDocLoc(page, rows, params, querytype, ProcessId = "", style = "")
{
    //s ^yunhaibao("jsQueryInDispDocLoc")=params
    s EmptyJson=##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    q:params="" EmptyJson
    s jsQueryInDispDocLoc="INPHA"_..NewPid()
    s cellSplit="!!"
    s endpage=page*rows  //结束行
    s stpage=((page-1)*rows)+1 //开始行
    s displocrowid=$p(params,cellSplit,1)
    s startdate=$p(params,cellSplit,2)
    s startdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startdate)
    s enddate=$p(params,cellSplit,3)
    s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
    s userid =$p(params,cellSplit,4)
    s dispcatlist=$p(params,cellSplit,5)
    s doctorlocrowid =$p(params,cellSplit,6)
    s RegNo=$p(params,cellSplit,7)
    s incirowid=$p(params,cellSplit,8)
    i ProcessId'="" d
    .i querytype="total" d OutPutTotal
    .i querytype="detail" d OutPutDetail
    q:ProcessId'="" ""
    q:displocrowid="" EmptyJson
    q:startdate="" EmptyJson
    q:enddate="" EmptyJson
    q:doctorlocrowid="" EmptyJson
    s PID=##class(web.DHCSTPCHCOLLSDOCLOC).CollectDisp(displocrowid, startdate, enddate, userid, dispcatlist, doctorlocrowid, RegNo, incirowid)
    q:PID="" EmptyJson 
    s ProcessId=PID
    // 就诊欠费
    s admId=""
    f  s admId=$o(^TMP("DHCST","web.DHCSTPCHCOLLS","ADMBILLAMT",ProcessId,admId)) q:admId=""  d
    .s oeoreStr=^TMP("DHCST","web.DHCSTPCHCOLLS","ADMBILLAMT",ProcessId,admId)
    .s amtRet=##class(web.DHCSTPCHCOLLS2).CheckArrearsNew(ProcessId,admId,oeoreStr,displocrowid)
    .i amtRet="N" d
    ..s ^TMP("DHCST","web.DHCSTPCHCOLLS","AdmOweFee",ProcessId,admId)=""
    i querytype="total" d OutPutTotal
    i querytype="detail" d OutPutDetail
    q ""
OutPutTotal
    s Title1="TDesc$$TUom$$TDrugForm$$TQty$$TQtyBed$$TSp$$TBarcode$$TManufacture$$TIncstk$$TAmt"
    s Title2="TGeneric$$TPID$$TCollStat"
    s Title=Title1_"$$"_Title2
    s countrecords=0
    s AmtTotal=0
    s TmpCat=""
    f  s TmpCat=$o(^TMP("dhcpha",ProcessId,"D","DispCat",TmpCat)) q:TmpCat=""  d
    .s SubStr=""
    .f  s SubStr=$o(^TMP("dhcpha",ProcessId,"D","DispCat",TmpCat,SubStr)) q:SubStr=""  d
    ..s DataStr=^TMP("dhcpha",ProcessId,"D","DispCat",TmpCat,SubStr)
    ..Q:TmpCat="Filter"
    ..s DspIdStr=$p(DataStr,"^",18)
    ..q:$d(^TMP("dhcpha",ProcessId,"D","DispCat","Filter",DspIdStr))
    ..s DspQty=$p(DataStr,"^",8)
    ..s TolPrice=$p(DataStr,"^",22)
    ..s Inci=$p(DataStr,"^",35)
    ..s RecLocId=$p(DataStr,"^",36)
    ..s IL=$o(^INCI("IL_LOC",RecLocId,Inci,""))
    ..s InciQty=0 
    ..i IL'=""  d
    ...s Incil=Inci_"||"_IL
    ...s InciQty=##class(web.DHCSTSTKQTY).GetPhaQty(Incil,DspQty)  ;1,够发，0：不可发
    ..i $d(^TMP("DHCST","web.DHCINPHA.DispDocLoc","jsQueryInDispDocLoc",ProcessId,"DOCTOTAL",Inci)) d 
    ...s $p(^TMP("DHCST","web.DHCINPHA.DispDocLoc","jsQueryInDispDocLoc",ProcessId,"DOCTOTAL",Inci),"^",8)=$p(^TMP("DHCST","web.DHCINPHA.DispDocLoc","jsQueryInDispDocLoc",ProcessId,"DOCTOTAL",Inci),"^",8)+DspQty
    ...s $p(^TMP("DHCST","web.DHCINPHA.DispDocLoc","jsQueryInDispDocLoc",ProcessId,"DOCTOTAL",Inci),"^",22)=$p(^TMP("DHCST","web.DHCINPHA.DispDocLoc","jsQueryInDispDocLoc",ProcessId,"DOCTOTAL",Inci),"^",22)+TolPrice
    ..e  d
    ...s ^TMP("DHCST","web.DHCINPHA.DispDocLoc","jsQueryInDispDocLoc",ProcessId,"DOCTOTAL",Inci)=^TMP("dhcpha",ProcessId,"D","DispCat",TmpCat,SubStr)   
    ..s TCollStat=""
    ..i InciQty=0 s $p(^TMP("DHCST","web.DHCINPHA.DispDocLoc","jsQueryInDispDocLoc",ProcessId,"DOCTOTAL",Inci),"^",38)="库存不足"
    s inci=""
    f  s inci=$o(^TMP("DHCST","web.DHCINPHA.DispDocLoc","jsQueryInDispDocLoc",ProcessId,"DOCTOTAL",inci)) q:inci=""  d
    .s result=^TMP("DHCST","web.DHCINPHA.DispDocLoc","jsQueryInDispDocLoc",ProcessId,"DOCTOTAL",inci)
    .s TDesc=$p(result,"^",7)
    .s TQty=$p(result,"^",8)
    .s TUom=$p(result,"^",9)
    .S TSp=$p(result,"^",10)
    .s TSp=$fn(TSp,"",4)
    .s TQtyBed=""
    .s TDrugForm=$p(result,"^",26)
    .s TBarcode=$p(result,"^",27)
    .s TManufacture=$p(result,"^",28)
    .s TIncstk=$p(result,"^",31)
    .s TAmt=$p(result,"^",22)
    .s TAmt=$fn(TAmt,"",2)
    .s TGeneric=$p(result,"^",25)
    .s TCollStat=$p(result,"^",38)
    .s AmtTotal=AmtTotal+TAmt
    .i TQty["." d
    ..i $l($p(TQty,".",2))>5 s TQty=+$fn(TQty,"",3)
    ..i TQty<1 s TQty="0"_TQty
    .s OutPutData1=TDesc_"$$"_TUom_"$$"_TDrugForm_"$$"_TQty_"$$"_TQtyBed_"$$"_TSp_"$$"_TBarcode_"$$"_TManufacture_"$$"_TIncstk_"$$"_TAmt
    .s OutPutData2=TGeneric_"$$"_ProcessId_"$$"_TCollStat
    .s OutPutData=OutPutData1_"$$"_OutPutData2
    .s countrecords=countrecords+1
    .q:countrecords<stpage
    .q:countrecords>endpage
    .I countrecords=stpage d
    ..w ##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(countrecords,rows)
    ..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,OutPutData,"$$")
    .e  d
    ..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,OutPutData,"$$")
    i countrecords>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
    e  w EmptyJson
    k ^TMP("DHCST","web.DHCINPHA.DispDocLoc","jsQueryInDispDocLoc",ProcessId,"DOCTOTAL")
    q ""
OutPutDetail
    s Title1="TSelect$$TPID$$TAdmLoc$$TBedNo$$TPaName$$TRegNo$$TDesc$$TQty$$TUom$$TSalePrice"
    s Title2="TOrdStatus$$Toetype$$TPhaCat$$TDoseQty$$TFreq$$TInstruction$$TDuration$$TPrescNo$$Taudited$$Tgenedesc"
    s Title3="Tphcform$$Tbarcode$$Tmanf$$Tgoods$$Tolp$$Tdoctor$$Tdatetime$$Tdiagnose$$TPaold$$Taction"
    s Title4="TInsuType$$Tstr$$TDispIdStr$$Toedis$$TBatchNo$$TCollStat"
    s Title=Title1_"$$"_Title2_"$$"_Title3_"$$"_Title4
    s countrecords=0
    s TmpCat=""
    f  s TmpCat=$o(^TMP("dhcpha",ProcessId,"D","DispCat",TmpCat)) q:TmpCat=""  d
    .s SubStr=""
    .f  s SubStr=$o(^TMP("dhcpha",ProcessId,"D","DispCat",TmpCat,SubStr)) q:SubStr=""  d
    ..s dispitm=^TMP("dhcpha",ProcessId,"D","DispCat",TmpCat,SubStr)
    ..s AdmDr=$p(SubStr,"^",1)
    ..i $d(^TMP("DHCST","web.DHCSTPCHCOLLS","AdmOweFee",ProcessId,AdmDr)) s oweFlag="欠费"
    ..e  s oweFlag=""
    ..s DateDosing=$p(SubStr,"^",2)
    ..s OrdItmRowid=$p(SubStr,"^",3)
    ..s issutype=$p(dispitm,"^",2)
    ..s admloc=$p(dispitm,"^",21) 
    ..s bedno=$p(dispitm,"^",4)
    ..s paname=$p(dispitm,"^",5)
    ..s registerno=$p(dispitm,"^",6)
    ..s arcimdesc=$p(dispitm,"^",7)
    ..s qty=$p(dispitm,"^",8)
    ..s uom=$p(dispitm,"^",9)
    ..s sp=$p(dispitm,"^",10)
    ..s sp=$fn(sp,"",4)
    ..s ordstatus=$p(dispitm,"^",39)
    ..s phatype=$p(dispitm,"^",12)
    ..s dosage=$p(dispitm,"^",13)
    ..s freq=$p(dispitm,"^",14)
    ..s instr=$p(dispitm,"^",15)
    ..s duration=$p(dispitm,"^",16)
    ..s prescno=$p(dispitm,"^",17)
    ..s batno =$p(dispitm,"^",18)
    ..s ordis =$p(dispitm,"^",19)
    ..s tolp=$p(dispitm,"^",22)
    ..s tolp=$fn(tolp,"",2)
    ..s dispitmdatetime=$p(dispitm,"^",23)
    ..s dispitmdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(dispitmdatetime,",",1),"IP")
    ..s dispitmtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p(dispitmdatetime,",",2),"IP")
    ..s datetime=dispitmdate_" "_dispitmtime
    ..s Paold=$p(dispitm,"^",24)
    ..s genedesc=$p(dispitm,"^",25)
    ..s phcform=$p(dispitm,"^",26)
    ..s Specifaction=$p(dispitm,"^",27)
    ..s manf=$p(dispitm,"^",28)
    ..s doctor=$p(dispitm,"^",29)
    ..s oetype=$p(dispitm,"^",30)
    ..s goods=$p(dispitm,"^",31)
    ..s diagnose=$p(dispitm,"^",32)
    ..s audited=$p(dispitm,"^",33)  //现在作为护士审核标志
    ..//i audited<0 s audited="N"
    ..//e  s audited="Y"
    ..s action=$p(dispitm,"^",34)
    ..s dspidstr=$p(dispitm,"^",18)
    ..s InciId=$p(dispitm,"^",35)
    ..s RecLocId=$p(dispitm,"^",36)
    ..s IL=$o(^INCI("IL_LOC",RecLocId,InciId,""))
    ..s InciQty=0 
    ..i IL'=""  d
    ...s Incil=InciId_"||"_IL
    ...s InciQty=##class(web.DHCSTSTKQTY).GetPhaQty(Incil,qty)  ;1,够发，0：不可发
    ..s $p(Tstr,"^",7)=InciQty
    ..s TCollStat=""
    ..i InciQty=0 s TCollStat=##class(PHA.COM.Base).Get("库存不足")
    ..i qty["." d
    ...i $l($p(qty,".",2))>5 s qty=+$fn(qty,"",3)
    ...i qty<1 s qty="0"_qty
    ..i oweFlag'="" s TCollStat=$s(TCollStat'="":TCollStat_"</br>"_oweFlag,1:oweFlag)
    ..i $p(^PAADM(AdmDr),"^",2)="E" d
    ...s skinTestStr=##class(web.DHCSTCOMMONORDER).OeoriSkinTest(OrdItmRowid)
    ...s skinTestValue=$p(skinTestStr,"^",1)
    ...s skinTestDesc=$p(skinTestStr,"^",2)
    ...i skinTestDesc'="" d
    ....i skinTestDesc="(-)" d
    .....s arcimdesc="<span style=color:#04AD6B;font-weight:bold>"_skinTestDesc_"</span>"_arcimdesc
    ....e  i skinTestDesc="(+)" d
    .....s arcimdesc="<span style=color:#FF694C;font-weight:bold>"_skinTestDesc_"</span>"_arcimdesc
    ....e  d
    .....i skinTestValue<0 d
    ......s arcimdesc="<span style=color:red;font-weight:bold>"_skinTestDesc_"</span>"_arcimdesc
    .....e  s arcimdesc="<span style=font-weight:bold>"_skinTestDesc_"</span>"_arcimdesc
    ..s TSelect="Y"
    ..s OutPutData1=TSelect_"$$"_ProcessId_"$$"_admloc_"$$"_bedno_"$$"_paname_"$$"_registerno_"$$"_arcimdesc_"$$"_qty_"$$"_uom_"$$"_sp
    ..s OutPutData2=ordstatus_"$$"_oetype_"$$"_phatype_"$$"_dosage_"$$"_freq_"$$"_instr_"$$"_duration_"$$"_prescno_"$$"_audited_"$$"_genedesc
    ..s OutPutData3=phcform_"$$"_Specifaction_"$$"_manf_"$$"_goods_"$$"_tolp_"$$"_doctor_"$$"_datetime_"$$"_diagnose_"$$"_Paold_"$$"_action
    ..s OutPutData4=issutype_"$$"_Tstr_"$$"_dspidstr_"$$"_ordis_"$$"_batno_"$$"_TCollStat
    ..s OutPutData=OutPutData1_"$$"_OutPutData2_"$$"_OutPutData3_"$$"_OutPutData4
    ..s countrecords=countrecords+1
    ..q:countrecords<stpage
    ..q:countrecords>endpage
    ..I countrecords=stpage d
    ...w ##class(web.DHCSTJQUERYCOMMON).getJsonRowSign()
    ...W ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,OutPutData,"$$")
    ..e  d
    ...W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,OutPutData,"$$")
    i countrecords>0 d
    .w ##class(web.DHCSTJQUERYCOMMON).getJsonEndStringJqGrid(countrecords,rows)
    e  w ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    q ""
}

ClassMethod KillTmp(pid)
{
    k ^TMP("dhcpha",pid,"D","DISPM")
    k ^TMP("dhcpha",pid,"D","DispCat")
    k ^TMP("dhcpha",pid,"D","DispCat","Filter")
    k ^TMP("DHCST","web.DHCSTPCHCOLLS","ADMBILLAMT",pid)
    k ^TMP("DHCST","web.DHCSTPCHCOLLS","AdmOweFee",pid)
    q ""
}

ClassMethod NewPid()
{
    q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"IP")
}

}
