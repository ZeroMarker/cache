/// creator:    yunhaibao
/// createdate: 2018-10-19
/// description:住院发药输出数据,仅用于传递参数转换格式输出界面
Class web.DHCINPHA.Disp.Display Extends %RegisteredObject
{

/// description: 住院发药-汇总
/// w ##class(web.DHCINPHA.Disp.Display).JqGetDispTotal("1","9999","317!!55!!23/10/2018!!25/10/2018!!4638!!!!0!!0||NOEmOrd||!!0!!KF##971504!!!!!!!!00:00!!23:59!!","")
ClassMethod JqGetDispTotal(page, rows, InputStr, Pid)
{
    s $zt="ThrowJqGetDispTotal"
    s EndRow=page*rows              // 结束行
    s StartRow=((page-1)*rows)+1    // 开始行
    q:InputStr="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    s retData=##class(web.DHCINPHA.Disp.Query).GetDispTotal(StartRow, EndRow, InputStr, Pid)
    q:retData="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    s newPid=$p(retData,"^",1)
    s total=$p(retData,"^",2)
    q:(newPid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    s count=0
    s colNameStr1="TPID^TCollStat^TDesc^TQty^TUom"
    s colNameStr2="TSp^TAmt^TDrugForm^TQtyBed^TBarcode"
    s colNameStr3="TManufacture^TIncstk^TInsuCode^TInsuDesc"
    s colNameStr=colNameStr1_"^"_colNameStr2_"^"_colNameStr3
    s outputI=""
    f  s outputI=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","OutPut",newPid,outputI)) q:outputI=""  d
    .s colDataStr=^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","OutPut",newPid,outputI)
    .s count=count+1
    .i count=1 d
    ..w ##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(total,rows)
    ..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
    .e  d
    ..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
    d ##class(web.DHCINPHA.Disp.Global).KillJqDispOutput(newPid)
    i count>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
    e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    q ""
ThrowJqGetDispTotal
    s errRet=$$JsonErrorRecord^DHCSTERROR()
    q ""
}

/// description: 住院发药-明细
/// w ##class(web.DHCINPHA.Disp.Display).JqGetDispDetail("1","50","98!!!!22/09/2018!!24/10/2018!!663!!!!0!!0||NOEmOrd||!!0!!JSDM^PTFY^KFBY^OUT#!!280!!!!!!00:00!!23:59!!","")
ClassMethod JqGetDispDetail(page, rows, InputStr, Pid)
{
    //s ^TMPDHCSTPARAMS("web.DHCINPHA.Disp.Query","JqGetDispDetail")=$lb(page, rows, InputStr, Pid)
    s EndRow=page*rows              // 结束行
    s StartRow=((page-1)*rows)+1    // 开始行
    q:InputStr="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    s $zt="ThrowJqGetDispDetail"
    s retData=##class(web.DHCINPHA.Disp.Query).GetDispDetail(StartRow, EndRow, InputStr, Pid)
    q:retData="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    s newPid=$p(retData,"^",1)
    s total=$p(retData,"^",2)
    q:(newPid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    s count=0     
    s colNameStr1="TPID^TInsuType^TAdmLoc^TBedNo^TPaName^TRegNo^TDesc^TQty^TUom^TSalePrice"
    s colNameStr2="TOrdStatus^TPhaCat^TDoseQty^TFreq^TInstruction^TDuration^TPrescNo^TBatchNo^Toedis^TAudited"
    s colNameStr3="TGeneric^TForm^TBarcode^TManufacture^TIncStk^TAmt^TUserAdd^TTimeAdd^TDiagnose^TAge"
    s colNameStr4="Taction^Tsex^Tstr^TEncryptLevel^TPatLevel^TMainOrd^TTimeDosing^TUrgent^Tcooktype^Tseqno"
    s colNameStr5="TDispIdStr^TSelect^TCollStat^Tseqno^TNurseAuditDate"
    s colNameStr=colNameStr1_"^"_colNameStr2_"^"_colNameStr3_"^"_colNameStr4_"^"_colNameStr5
    s outputI=""
    f  s outputI=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispDetail","OutPut",newPid,outputI)) q:outputI=""  d
    .s colDataStr=^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispDetail","OutPut",newPid,outputI)
    .s count=count+1
    .i count=1 d
    ..w ##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(total,rows)
    ..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
    .e  d
    ..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
    d ##class(web.DHCINPHA.Disp.Global).KillJqDispOutput(newPid)
    i count>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
    e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    q ""
ThrowJqGetDispDetail
    s errRet=$$JsonErrorRecord^DHCSTERROR()
    q ""
}

/// description: 住院发药-病区
/// w ##class(web.DHCINPHA.Disp.Display).JqGetDispWardCats("1","9999","2020-02-18!!00:00:00!!2020-02-20!!23:59:59!!246!!!!!!!!")
ClassMethod JqGetDispWardCats(page, rows, InputStr)
{
    //s ^TMPDHCSTPARAMS("web.DHCINPHA.Disp.Display","JqGetDispWardCats")=$lb(page,rows,InputStr)
    s $zt="Throw"
    q:InputStr="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    s PhaLocId=$p(InputStr,"!!",5)
    s ret=##class(web.DHCINPHA.Disp.Query).GetDispWardCats(InputStr)
    s pid=$p(ret,"^",1)
    q:pid="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    // 默认勾选发药类别
    s phaLocation=$o(^DHCPL(0,"Loc",PhaLocId,""),-1)
    s defCheck=$p($g(^DHCPL(+phaLocation)),"^",25)
    s phaDispTypeStr=##class(web.DHCINPHA.InfoCommon).GetPhaDispType(PhaLocId)
    q:phaDispTypeStr="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    s colNameStr="TWardRowid^TWard^"_phaDispTypeStr 
    s count=0
    s sortIndex=""
    f  s sortIndex=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispWardCats",pid,sortIndex)) q:sortIndex=""  d
    .s index=""
    .f  s index=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispWardCats",pid,sortIndex,index)) q:index=""  d
    ..s toLocId = $lg(index,1)
    ..s floor = $lg(index,2)
    ..s toLocDesc=##class(PHA.COM.Data.Base).LocDesc(toLocId)
    ..s floorDesc = $s(floor '= 0 : $p($g(^CT("CTLB", +floor, "Floor", +$p(floor, "||", 2))), "^", 1), 1 : "")
    ..i floorDesc'="" s toLocDesc = toLocDesc _ " # " _ floorDesc
    ..s colDataStr=toLocId_"#"_floor_"^"_toLocDesc
    ..k wardWarnDATA
    ..s wardWarn=""
    ..s colI=3
    ..f colI=3:1:$l(colNameStr,"^") d
    ...s colDispType=$p(colNameStr,"^",colI)
    ...i $d(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispWardCats",pid,sortIndex,index,colDispType)) d
    ....s $p(colDataStr,"^",colI)="Y"
    ....s ordSpecInfo=^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispWardCats",pid,sortIndex,index,colDispType)
    ....i ordSpecInfo'="" d
    .....q:$d(wardWarnDATA(ordSpecInfo))
    .....s wardWarnDATA(ordSpecInfo)=""
    .....s wardWarn=$s(wardWarn="":ordSpecInfo,1:wardWarn_","_ordSpecInfo)
    ..i wardWarn'="" s $p(colDataStr,"^",2)=$p(colDataStr,"^",2)_"<div style='color:#ff584c;'>"_wardWarn_"</div>"
    ..s count=count+1 
    ..i count=1 d
    ...w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(9999)
    ...w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr)
    ..e  d
    ...w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr)
    d ##class(web.DHCINPHA.Disp.Global).KillGetDispWardCats(pid)
    i count>0   w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
    e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    q ""
Throw
    s errRet=$$JsonErrorRecord^DHCSTERROR()
    q ""
}

/// description: 住院发药-就诊列表

}
