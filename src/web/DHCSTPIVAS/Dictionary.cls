Import SQLUser

/// creator:     yunhaibao
/// createdate:  2018-01-22
/// description: 住院配液公共字典,包括下拉以及表格数据Query
Class web.DHCSTPIVAS.Dictionary Extends %RegisteredObject [ ProcedureBlock ]
{

/// deccription:配液分类
/// table:      User.PIVAOrderLink
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PIVAOrderLink",,"2")
Query PIVAOrderLink(inputStr = "", hosp = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PIVAOrderLinkExecute(ByRef qHandle As %Binary, inputStr = "", hosp = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT POL_Rowid as RowId, POL_Desc as Description FROM PIVA_OrderLink"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("PIVA_OrderLink",RowId,hosp)="N"
        s Description = ##class(PHA.PIVAS.Data.Base).PIVAOrderLinkDesc(RowId)
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:配液原因|配液拒绝原因
/// table:      User.PIVAOperReason
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PIVAOperReason","UNP")
Query PIVAOperReason(reasonType = "", hosp = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PIVAOperReasonExecute(ByRef qHandle As %Binary, reasonType = "", hosp = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT POR_RowId as RowId,POR_Desc as Description FROM PIVA_OperReason where POR_Flag='Y' and POR_Type='"_reasonType_"'"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        continue:(##class(PHA.FACE.IN.Com).GetShowDataFlag("PIVA_OperReason",RowId,hosp)="N")
        s Description = ##class(PHA.PIVAS.Data.Base).PIVAOperReasonDesc(RowId)
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:配液批次
/// table:      User.PIVABatTime
/// input:      inputParams^1:静配中心科室Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PIVABatTime","101")
Query PIVABatTime(inputParams = "", filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PIVABatTimeExecute(ByRef qHandle As %Binary, inputParams = "", filterText = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s locId=$p(inputParams,"^",1)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr ="SELECT PBT_RowId as RowId,PBT_BatNo as Description FROM PIVA_BatTime WHERE PBT_Ctloc_Dr="_locId_" ORDER BY PBT_BatNo,PBT_SeqFlag asc"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:(filterText'="")&&(Description'[filterText)
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:就诊记录
/// table:      User.PaAdm
/// input:      inputParams^1:登记号
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PaAdmByPatNo","0000000305^2")
Query PaAdmByPatNo(inputParams = "") As websys.Query(ROWSPEC = "admId,admLoc,admDate,admTime,curWard,curBed,curDoc,curWardId,patNo")
{
}

ClassMethod PaAdmByPatNoExecute(ByRef qHandle As %Binary, inputParams = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s patNo=$p(inputParams,"^",1)
    q:patNo="" $$$OK
    s papmi=$o(^PAPERi("PAPMI_PatNo",patNo,""))
    q:papmi="" $$$OK
    s hosp=$p(inputParams,"^",2)
    s adm="" 
    f  s adm=$o(^PAPERdr(papmi,"ADM","I",adm),-1) q:adm=""  d
    .q:$p(^PAADM(adm),"^",2)'="I"  
    .s depDesc=""    
    .s depcodedr=$p(^PAADM(adm),"^",4) 
    .q:(hosp'="")&&(hosp'=$p($g(^CTLOC(+depcodedr)),"^",22))
    .s depDesc=##class(PHA.PIVAS.Data.Base).LocDesc(depcodedr)
    .s admDate=$p(^PAADM(adm),"^",6)
    .s admDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(admDate,"PIVAS") 
    .s admTime=$p(^PAADM(adm),"^",7) 
    .s admTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(admTime,"PIVAS") 
    .s curWardDesc=""
    .s curWard=$p(^PAADM(adm),"^",70) 
    .s curWardDesc=##class(PHA.PIVAS.Data.Base).WardDesc(curWard)
    .s curBedcode="*"
    .s curBed=$p(^PAADM(adm),"^",73) 
    .i curBed'="" d
    ..s curBedW=+curBed,curBedB=$p(curBed,"||",2) q:(curBedW="")!(curBedB="")
    ..s curBedcode=$p(^PAWARD(curBedW,"BED",curBedB),"^",1)
    .s doctor=$p(^PAADM(adm),"^",9)
    .s doctor=##class(PHA.PIVAS.Data.Base).CareProvDesc(doctor)
    .d outputRow
    Quit $$$OK
outputRow  
    s Data=$lb(adm,depDesc,admDate,admTime,curWardDesc,curBedcode,doctor,curWard,patNo)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// hisui版本后, 弃用
/// deccription:配液维护的医嘱优先级
/// table:      User.PIVAOecpr
/// input:      inputParams^1:静配中心科室Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PIVAOecpr","250")
Query PIVAOecpr(inputParams = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PIVAOecprExecute(ByRef qHandle As %Binary, inputParams = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s locId=$p(inputParams,"^",1)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr ="SELECT PO_OECPR_Dr as RowId,PO_OECPR_Dr->OECPR_Desc as Description FROM PIVA_Oecpr Where PO_Ctloc_Dr="_locId
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:配液状态
/// table:      User.PIVAState
/// input:      inputStr^1:静配中心科室Id,inputStr^2:不需显示的流程(,分隔),inputStr^3:对应业务功能
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PIVAState","313^3,10")
Query PIVAState(inputStr = "", filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PIVAStateExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "") As %Status
{
    #; s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.Dictionary","PIVAState")=$lb(inputStr,filterText)
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s locId=$p(inputStr,"^",1)
    q:locId="" $$$OK
    s noShowNumStr=$p(inputStr,"^",2)
    s noShowNumList=$lfs(noShowNumStr,",")
    s busiType=$p(inputStr,"^",3)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr ="SELECT PS_RowID as psRowId, PS_Number AS RowId,PS_Name AS Description,PS_SingleFlag as SingleFlag FROM PIVA_State WHERE PS_Loc_Dr="_locId_" AND PS_TypeFlag='I' AND PS_Flag='Y' ORDER BY PS_Number asc"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId")  // 流程中主要使用PS_Number字段
        continue:(noShowNumStr'="")&&($lf(noShowNumList,RowId)>0)
        s singleFlag=result.Data("SingleFlag")  // 单独执行
        continue:(busiType="execute")&&(singleFlag="Y")
        s Description = result.Data("Description")
        s Description = ##class(PHA.COM.Data.Base).PIVASStateName(result.Data("psRowId"))
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:药品列表
/// table:      User.IncItm
/// input:      inputParams^1:别名
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","IncItm","","lsn")
Query IncItm(inputParams = "", filterText = "", hosp = "", loc = "") As websys.Query(ROWSPEC = "incRowId,incCode,incDesc,incSpec,manfDesc,goodName")
{
}

ClassMethod IncItmExecute(ByRef qHandle As %Binary, inputParams = "", filterText = "", hosp = "", loc = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    //q:inputParams="" $$$OK
    s IncDesc=$p(inputParams,"^",1)
    q:(IncDesc="")&&(filterText="") $$$OK
    s inputText=filterText
    s inputText="%"_$$ALPHAUP^SSUTIL4(inputText)_"%"
    s result = ##class(%Library.ResultSet).%New()
    s StkGrpType="G"
    if (IncDesc'="") {
        s sqlStr ="select distinct inci_rowid as incId from inc_itm  where inci_desc='"_IncDesc_"'"
    }else {
        s sqlStr ="select distinct inca_inci_dr as incId from inc_alias "_
        "where %ALPHAUP(inca_text) like '"_inputText_"' and inca_inci_dr->inci_incsc_dr in "_ 
        "(Select scgr_stkcat_dr from dhc_stkcatgrprelations Where scgr_scg_parref->SCG_Type='"_StkGrpType_"')"
    }
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s incId = result.Data("incId")
        continue:(hosp'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_Itm",incId,hosp)="N")
        continue:(loc'="")&&('$d(^INCI("IL_LOC", loc,incId)))
        s incDesc=##class(PHA.PIVAS.Data.Base).InciDesc(incId)
        s incCode=$p(^INCI(incId,1),"^",1)
        s itmAdd=$o(^DHCITMINFO(0,"INCI",incId,"")) 
        s incSpec=$p($g(^DHCITMINFO(+itmAdd)),"^",27)
        continue:incDesc=""
        s infoRowId=$o(^DHCITMINFO(0,"INCI",incId,"")) continue:infoRowId=""
        s ordEndDate=$p(^DHCITMINFO(infoRowId),"^",113)
        continue:((ordEndDate'="")&&(ordEndDate<+$h)) //库存项医嘱截止日期
        s ArcId=$p(^INCI(incId,1),"^",3)
        s ArcStopDate=##class(web.DHCST.Common.DrugInfoCommon).GetArcItmStopDate(ArcId)  //医嘱项医嘱截止日期
        s ArcStopDate=+$p(ArcStopDate,"^",1)
        continue:((ArcStopDate'="0")&&(ArcStopDate<+$h))
        #; s manfDesc = $p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(incId),"^",3)
        s manfDesc = $lg(##class(PHA.COM.Drug).GetManf(incId), 3)
        s goodName = ##class(web.DHCST.Common.DrugInfoCommon).GetGoodName(incId)        
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow  
    s Data=$lb(incId,incCode,incDesc,incSpec,manfDesc,goodName)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:配液科室
/// table:      User.CtLoc
/// input:      inputParams^1:登录科室Id,filterText:模糊匹配字符
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PIVALoc","2")
Query PIVALoc(inputParams = "", filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PIVALocExecute(ByRef qHandle As %Binary, inputParams = "", filterText = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s locId=$p(inputParams,"^",1)
    q:locId="" $$$OK
    s hospId=$p(^CTLOC(locId),"^",22)
    s psId=0
    f  s psId=$o(^PIVAS(psId)) q:psId=""  d
    .s psData=^PIVAS(psId)
    .s ctLoc=$p(psData,"^",7)
    .q:$p(psData,"^",9)'="I"
    .q:$p(psData,"^",3)'="Y"
    .s ctHospId=$p(^CTLOC(ctLoc),"^",22)
    .q:hospId'=ctHospId
    .s PIVALocData(ctLoc)=""
    s ctLoc=""
    f  s ctLoc=$o(PIVALocData(ctLoc)) q:ctLoc=""  d
    .s ctLocDesc=##class(PHA.PIVAS.Data.Base).LocDesc(ctLoc)
    .d outputRow
    Quit $$$OK
outputRow  
    s Data=$lb(ctLoc,ctLocDesc)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:药学成分字典
/// table:      User.PHCIngredient
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PHCIngredient","")
Query PHCIngredient(inputStr = "", filterText = "", HospId = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PHCIngredientExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "", HospId = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT INGR_RowId as RowId,INGR_Desc as Description FROM PHC_Ingredient"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("PHC_Ingredient",RowId,HospId) //医院级别授权
        continue:flag="N"
        s Description = ##class(PHA.COM.Data.Base).PHCIngredientDesc(RowId)
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// description: 获取药学成分字典,用于前台拼接buttons
/// w ##class(web.DHCSTPIVAS.Dictionary).PHCIngredientButtons()
ClassMethod PHCIngredientButtons(HospId = "")
{
    s result=##class(%Library.ResultSet).%New("web.DHCSTPIVAS.Dictionary:PHCIngredient")
    s sc=result.Execute("","",HospId)
    s colNum=result.GetColumnCount()
    s colNameStr=""
    f i=1:1:colNum d
    .i colNameStr="" s colNameStr=result.GetColumnName(i)
    .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
    s btnHtml=""
    While(result.Next())
    { 
        s description=result.%Get("Description")
        s btnHtml=$s(btnHtml="":description,1:btnHtml_"^"_description)
    }
    q btnHtml
}

/// deccription:用法,配液的用法,过滤一些非配液的用法
/// @todo 院区过滤
/// table:      User.PHCInstruc
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PHCInstruc","k")
Query PHCInstruc(filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PHCInstrucExecute(ByRef qHandle As %Binary, filterText = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s filterText=$zcvt(filterText,"U")
    s sqlStr = "SELECT PHCIN_RowId AS RowId, PHCIN_DESC1 AS Description,PHCIN_ActiveFlag AS ActiveFlag from PHC_Instruc order by PHCIN_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = ##class(PHA.COM.Data.Base).InstDesc(RowId)
        
        s ActiveFlag = result.Data("ActiveFlag")
        continue:Description["废"
        continue:Description=""
        continue:ActiveFlag="N"
        i filterText'="" s descPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(Description)
        continue:(filterText'="")&&(descPY'[filterText)&&(Description'[filterText)
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// 获取用法-ext
/// w ##class(web.DHCSTPIVAS.Dictionary).ExtPHCInstruc()
ClassMethod ExtPHCInstruc()
{
    s result=##class(%Library.ResultSet).%New("web.DHCSTPIVAS.Dictionary:PHCInstruc")
    s sc=result.Execute("")
    s colNum=result.GetColumnCount()
    s colNameStr=""
    f i=1:1:colNum d
    .i colNameStr="" s colNameStr=result.GetColumnName(i)
    .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
    s count=0
    w "["
    While(result.Next())
    { 
        s count = count+1
        s colDataStr=""
        f i=1:1:colNum d
        .i colDataStr="" s colDataStr=result.GetData(i)
        .e  s colDataStr=colDataStr_"^"_result.GetData(i)
        I count=1 d
        .W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr)
        e  d
        .W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr)
    }
    w "]"
    q ""
}

/// description: 配液记录状态记录追踪,各界面均由此调入
/// input:       barcode-条码(或执行记录Id)
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","LabelExeRecords","530-341-1")
Query LabelExeRecords(inputStr = "") As websys.Query(ROWSPEC = "pivasState,dateTime,userName")
{
}

ClassMethod LabelExeRecordsExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s split=##class(web.DHCSTPIVAS.Common).Split()
    s barCode=$p(inputStr,split,1)
    q:barCode="" $$$OK
    s sortIndex=10  
    s:barCode["-" barCode=$p(barCode,"-",1)_"||"_$p(barCode,"-",2)_"||"_$p(barCode,"-",3)
    s dspId=$o(^DHCOEDISQTY(0,"OEORE",barCode,""))
    q:dspId="" $$$OK
    s oeore=$p(^DHCOEDISQTY(dspId),"^",3)
    s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
    s ordId=+oeore  
    s ordItm=+$p(oeore,"||",2)
    s ordItmExe=+$p(oeore,"||",3)   
    s ctcpDesc=""
    s sttDate=$p($g(^OEORD(ordId,"I",ordItm,"X",ordItmExe)),"^",1)   //keep dup
    s sttTime=$p($g(^OEORD(ordId,"I",ordItm,"X",ordItmExe)),"^",2)  //keep dup
    s oeoriDate=$p($g(^OEORD(ordId,"I",ordItm,3)),"^",7)
    s oeoriTimeOrd=$p($g(^OEORD(ordId,"I",ordItm,1)),"^",17)
    s user=$p($g(^OEORD(ordId,"I",ordItm,7)),"^",1)
    i user'="" s ctcpId=$p(^SSU("SSUSR",user),"^",14)
    i ctcpId'="" s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
    i ctcpDesc'="" d
    .s psName=##class(PHA.FACE.IN.Com).Translate(,"开医嘱")
    .s sortIndex=sortIndex+1
    .s oeoriDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(oeoriDate)
    .s oeoriTimeHtml=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(oeoriTimeOrd)
    .s ctcpDesc="***"
    .s data=psName_"^"_oeoriDateHtml_" "_oeoriTimeHtml_"^"_ctcpDesc
    .s sort = oeoriDate_","_$j(oeoriTimeOrd,5)_","_sortIndex
    .s LabelExeRecordsArr(sort)=data
    
    s dspData=$g(^DHCOEDISQTY(dspId))
    s grpNo=$p(dspData,"^",4)
    s doseDate=$p(dspData,"^",21)
    s recLocId=$p(dspData,"^",24)
    s adm=$p(dspData,"^",26)
    s admType =$p(^PAADM(adm),"^",2)
    s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",recLocId,"OeAudit","AuditTimes")
    s lastDate=##class(web.DHCSTPIVAS.Common).GetDoseDateByTimes(oeori,auditTimes,recLocId)
    i doseDate>lastDate s doseDate=lastDate
    s phaOrd=##class(web.DHCSTPIVAS.Common).GetValidPhaOrdId(oeori,doseDate)
    i phaOrd'="" d
    .s phaOrdResultStr=##class(web.DHCSTPIVAS.Common).GetPhaOrdResult(phaOrd)
    .s phaOrdDate=$p($g(^DHCPHORDM(phaOrd)),"^",3)
    .s phaOrdTime=$p($g(^DHCPHORDM(phaOrd)),"^",4)
    .s phaOrdDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phaOrdDate)
    .s phaOrdTimeHtml=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(phaOrdTime)
    .s phUser=$p($g(^DHCPHORDM(phaOrd)),"^",1)
    .s psUser=##class(PHA.PIVAS.Data.Base).UserName(phUser)
    .s sortIndex=sortIndex+1
    .s psName=$p(phaOrdResultStr,"^",2)
    .s psDate=phaOrdDateHtml_" "_phaOrdTimeHtml
    .s data=psName_"^"_psDate_"^"_psUser
    .s sort = phaOrdDate_","_$j(phaOrdTime,5)_","_sortIndex
    .s LabelExeRecordsArr(sort)=data

    s auditUserDr=$p(^DHCOEDISQTY(dspId),"^",12)
    i auditUserDr'="" d
    .s auditDate=$p(^DHCOEDISQTY(dspId),"^",18) 
    .s auditTime=$p(^DHCOEDISQTY(dspId),"^",19) 
    .s auditUser=##class(PHA.PIVAS.Data.Base).UserName(+auditUserDr)
    .s psName=##class(PHA.FACE.IN.Com).Translate(,"领药审核")
    .s sortIndex=sortIndex+1
    .s auditDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(auditDate)
    .s auditTimeHtml=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(auditTime)
    .s data=psName_"^"_auditDateHtml_" "_auditTimeHtml_"^"_auditUser
    .s sort = auditDate_","_$j(auditTime,5)_","_sortIndex
    .s LabelExeRecordsArr(sort)=data
    s pog = $o(^PIVA(0,"DSP",dspId,0))
    i pog'=""  d
    .s sub="0"
    .f  s sub=$o(^PIVA(pog,"S",sub)) q:sub=""  d
    ..S psStatdr=$P(^PIVA(pog,"S",sub),"^",2)
    ..S psName=$P($G(^PIVAS(psStatdr)),"^",2)
    ..S psUser=$P(^PIVA(pog,"S",sub),"^",3)
    ..s:psUser'="" psUser=##class(PHA.PIVAS.Data.Base).UserName(psUser)
    ..S statDate=$P(^PIVA(pog,"S",sub),"^",4)
    ..s statDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(statDate)
    ..S statTime=$P(^PIVA(pog,"S",sub),"^",5)
    ..s statTimeHtml=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(statTime)
    ..s psDate=statDateHtml_" "_statTimeHtml
    ..s:psName="病区接收" psName = $tr(psName, "病区", "")
    ..s data=psName_"^"_psDate_"^"_psUser
    ..s sortIndex=sortIndex+1
    ..s sort= statDate_","_$j(statTime,5)_","_sortIndex
    ..s LabelExeRecordsArr(sort)=data

    s oeoreStatusDr=$p(^OEORD(ordId,"I",ordItm,"X",ordItmExe),"^",16) // 护士执行状态 OEC_Order_AdminStatus
    i oeoreStatusDr'=""  d
    .s oeoreFlag=$p(^OEC("STAT",oeoreStatusDr),"^",1) 
    .s oeoreDesc=$p(^OEC("STAT",oeoreStatusDr),"^",2) 
    .s ctPcpDr=$p(^OEORD(ordId,"I",ordItm,"X",ordItmExe),"^",15)
    .s oeoreUserName=##class(PHA.PIVAS.Data.Base).CareProvDesc(+ctPcpDr)
    .s oeoreExeDate=$p(^OEORD(ordId,"I",ordItm,"X",ordItmExe),"^",19)
    .s oeoreExeTime=$p(^OEORD(ordId,"I",ordItm,"X",ordItmExe),"^",20)
    .s oeoreExeDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(oeoreExeDate)
    .s oeoreExeTimeHtml=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(oeoreExeTime)
    .s oeoreExeDateTimeHtml=oeoreExeDateHtml_" "_oeoreExeTimeHtml
    .s sortIndex=sortIndex+1
    .s data=oeoreDesc_"^"_oeoreExeDateTimeHtml_"^"_oeoreUserName
    .s sort=oeoreExeDate_","_$j(oeoreExeTime,5)_","_sortIndex
    .s LabelExeRecordsArr(sort)=data

    s notOMOeore = ##class(web.DHCSTPIVAS.Common).GetNotOMOeore(barCode)
    i notOMOeore = "" s notOMOeore = oeore
    s firstDsp=$o(^DHCOEDISQTY(0,"OEORE",notOMOeore,""))
    s firstDspSub=$o(^DHCOEDISQTY(firstDsp,"I",0))
    s firstDspSubID = firstDsp _ "||" _ firstDspSub
    i admType="I" d
    .s phac = $o(^DHCPHACi("DSPB",firstDspSubID, "")) 
    .q:phac=""
    .s phacItm = $o(^DHCPHACi("DSPB",firstDspSubID, phac,""))
    .q:phacItm=""
    .s phacItmLb = $o(^DHCPHACi("DSPB",firstDspSubID,phac,phacItm,""))
    .q:phacItmLb=""
    .s phar=$o(^PHARETi("PHDICDR",phac_"||"_phacItm_"||"_phacItmLb, ""))
    .q:(phar = "")
    .s pharetData=^PHARET(+phar)
    .s retDate=$p(pharetData,"^",1)
    .s retTime=$p(pharetData,"^",2)
    .s retUserId=$p(pharetData,"^",3)
    .s:retUserId'="" psUser=##class(PHA.PIVAS.Data.Base).UserName(+retUserId)
    .s retDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(retDate)
    .s retTimeHtml=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(retTime)
    .s retDateTimeHtml=retDateHtml_" "_retTimeHtml
    .s psName=##class(PHA.FACE.IN.Com).Translate(,"退药")
    .s sortIndex=sortIndex+1
    .s data=psName_"^"_retDateTimeHtml_"^"_psUser
    .s sort=retDate_","_$j(retTime,5)_","_sortIndex
    .s LabelExeRecordsArr(sort)=data
    e  d
    .s phd=$o(^DHCPHDIi("DSPB",firstDspSubID, "")) 
    .q:phd=""
    .s phdItm=$o(^DHCPHDIi("DSPB",firstDspSubID,phd,""))
    .q:phdItm=""
    .s phdItmLb=$o(^DHCPHDIi("DSPB",firstDspSubID,phd,phdItm,""))
    .q:phdItmLb=""
    .s phr=$o(^DHCPHRTIi("PHDICDR",phd_"||"_phdItm_"||"_phdItmLb,""))
    .q:phr=""
    .s phrData=$g(^DHCPHRET(+phr))
    .q:$p(phrData,"^",19)="Y"
    .s retDate=$p(phrData,"^",2)
    .s retTime=$p(phrData,"^",10)
    .s retPhPerson=$p(phrData,"^",8)
    .s retUserId=$p($g(^DHCPHPER(+retPhPerson)),"^",5)
    .s:retUserId'="" psUser=##class(PHA.PIVAS.Data.Base).UserName(retUserId)
    .s retDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(retDate)
    .s retTimeHtml=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(retTime)
    .s retDateTimeHtml=retDateHtml_" "_retTimeHtml
    .s psName=##class(PHA.FACE.IN.Com).Translate(,"退药")
    .s sortIndex=sortIndex+1
    .s data=psName_"^"_retDateTimeHtml_"^"_psUser
    .s sort=retDate_","_$j(retTime,5)_","_sortIndex
    .s LabelExeRecordsArr(sort)=data

    i $$$comMemberDefined("Nur.PDA.InterFace","m","getInfusionInfo")  d
    .s retJsonStr = ##class(Nur.PDA.InterFace).getInfusionInfo(barCode)
    .s retJson = {}.%FromJSON(retJsonStr)
    .s infuStDateTime=retJson.%Get("infusionSttDateTime")
    .s infuStUserName=retJson.%Get("infusionSttUser")
    .s infuEdDateTime=retJson.%Get("infusionEndDateTime")
    .s infuEdUserName=retJson.%Get("infusionEndUser")
    .i infuStUserName'="" d
    ..s data = "开始输液^"_infuStDateTime_"^"_infuStUserName
    ..s LabelExeRecordsArr("99999,99999,98")=data
    .i infuEdUserName'="" d
    ..s data = "结束输液^"_infuEdDateTime_"^"_infuEdUserName
    ..s LabelExeRecordsArr("99999,99999,99")=data
    q:'$d(LabelExeRecordsArr) $$$OK
    s sortIndex=""
    f  s sortIndex=$o(LabelExeRecordsArr(sortIndex)) q:sortIndex=""  d
    .s data=LabelExeRecordsArr(sortIndex)
    .s Data=$lfs(data,"^")
    .s ^CacheTemp(repid,ind)=Data    
    .s ind=ind+1
    q $$$OK
}

/// deccription:配置台
/// table:      User.PIVAConfigTable
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PIVAConfigTable","102")
Query PIVAConfigTable(inputStr = "", filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PIVAConfigTableExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s locId=$p(inputStr,"^",1)
    q:locId="" $$$OK
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT PIVACT_Rowid as RowId,PIVACT_Desc as Description FROM PIVA_ConfigTable WHERE PIVACT_LOC_DR="_locId_" order by PIVACT_Code"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = ##class(PHA.PIVAS.Data.Base).PIVAConfigTableDesc(RowId)
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:工作组
/// table:      User.PIVAWorkType
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PIVAWorkType","101")
Query PIVAWorkType(inputStr = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PIVAWorkTypeExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s locId=$p(inputStr,"^",1)
    q:locId="" $$$OK
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT PIVAWT_Rowid as RowId,PIVAWT_Desc as Description FROM PIVA_WorkType WHERE PIVAWT_LOC_DR="_locId_" order by PIVAWT_Code"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = ##class(PHA.PIVAS.Data.Base).PIVAWorkTypeDesc(RowId)
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:打印方式
/// table:      User.DHCStkComDictionary
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PIVAPrtWay","")
Query PIVAPrtWay(inputStr = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PIVAPrtWayExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT SCDI_RowId as RowId,SCDI_Desc as Description FROM DHC_StkComDictionary WHERE SCDI_Type='PivasPrtWay'"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:配液小类
/// table:      User.DHCPHCPivaCat
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","DHCPHCPivaCat")
Query DHCPHCPivaCat(inputStr = "", hosp = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod DHCPHCPivaCatExecute(ByRef qHandle As %Binary, inputStr = "", hosp = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT PHCPivaCat_RowId as RowId, PHCPivaCat_Desc as Description FROM DHC_PHCPivaCat"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_PHCPivaCat",RowId,hosp) //医院级别授权
        continue:flag="N"
        s Description = ##class(PHA.PIVAS.Data.Base).PHCPivaCatDesc(RowId)
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:医嘱项列表
/// table:      User.ARCItmMast
/// input:      inputParams^1:别名
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","ArcItmMast","zsq",2)
Query ArcItmMast(filterText = "", HospId = "") As websys.Query(ROWSPEC = "arcItmId:%String,arcItmCode:%String,arcItmDesc:%String")
{
}

ClassMethod ArcItmMastExecute(ByRef qHandle As %Binary, filterText = "", HospId = "") As %Status
{
    s repid = $i(^CacheTemp)
    s qHandle = $lb(0, repid, 0)
    s ind = 1
    q:(filterText = "") $$$OK
    s pAlias = $zcvt(filterText, "U")
    
    s sqlStr = "SELECT ARCIM_RowId, ARCIM_Code, ARCIM_Desc, ARCIM_EffDateTo FROM ARC_ItmMast WHERE ARCIM_ItemCat_DR->ARCIC_OrderType != 'R'"

    s sqlStatement = ##class(%SQL.Statement).%New()
    s sqlStatus = sqlStatement.%Prepare(sqlStr)
    s sqlResult = sqlStatement.%Execute()
    while (sqlResult.%Next()){
        s arcim = sqlResult.%Get("ARCIM_RowId")
        s dateTo = sqlResult.%Get("ARCIM_EffDateTo")
        continue:(dateTo'="")&&(dateTo<+$h)
        continue:(##class(PHA.FACE.IN.Com).GetShowDataFlag("ARC_ItmMast", arcim, HospId) '= "Y")
        continue:(##class(web.DHCSTPIVAS.Dictionary).CheckArcAliasExist(arcim, pAlias) '= 1)
        s arcimDesc = ##class(PHA.PIVAS.Data.Base).ArcimDesc(arcim)
        s ^CacheTemp(repid, ind) = $lb(arcim, sqlResult.%Get("ARCIM_Code"), arcimDesc)    
        s ind = ind + 1
    }   
    q $$$OK
}

/// creator:    yunhaibao
/// createdate: 2017-06-29
/// description:根据医嘱项ID+别名,匹配别名表
/// input:      arcItmID(医嘱项ID),aliasDesc(别名)
/// return:     +retval<0 不存在
/// w ##class(web.DHCSTPIVAS.Dictionary).CheckArcAliasExist("858||1","amxl")
ClassMethod CheckArcAliasExist(arcItmId, inputAlias)
{
    s inputAlias=$zcvt(inputAlias,"U")
    q:inputAlias="" "-1^入参别名为空"
    q:arcItmId="" -1_"^医嘱项ID为空"
    s aliasId="",exist=-1
    f  s aliasId=$o(^ARC("ALIAS",0,"ARCIM",arcItmId,aliasId)) q:(aliasId="")||(exist'<0)  d
    .q:+aliasId=0
    .s aliasDesc=$p(^ARC("ALIAS",aliasId),"^",6)
    .s aliasDesc=$zcvt(aliasDesc,"U")
    .i aliasDesc[inputAlias s exist=1
    q exist
}

/// deccription:流程单记录
/// table:      User.PIVAOrdGrpState
/// input:      inputParams^1
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PIVAOrdGrpState","101^^2018-06-01")
Query PIVAOrdGrpState(strParams = "") As websys.Query(ROWSPEC = "psName,pogsNo,pogsDate,pogsTime,pogsUserName,psNumber")
{
}

ClassMethod PIVAOrdGrpStateExecute(ByRef qHandle As %Binary, strParams = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s PivaLocId=$p(strParams,"^",1)
    s PsNumber=$p(strParams,"^",2)
    s CalcuDate=$p(strParams,"^",3)
    s CalcuDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CalcuDate) 
    q:(PivaLocId="")||(CalcuDate="") $$$OK
    s psId=""
    f  s psId=$o(^PIVA(0,"DATELOC",PivaLocId,CalcuDate,psId)) q:psId=""  d
    .q:+psId=0
    .s psNumber=$p(^PIVAS(psId),"^",1)
    .q:(PsNumber'="")&&(PsNumber'=psNumber)
    .s pogId=""
    .f  s pogId=$o(^PIVA(0,"DATELOC",PivaLocId,CalcuDate,psId,pogId)) q:pogId=""  d
    ..q:+pogId=0
    ..s mDsp = $p(^PIVA(pogId), "^", 1)
    ..s adm = $p(^DHCOEDISQTY(mDsp),"^",26)
    ..q:($p(^PAADM(adm),"^",2)'="I")
    ..s pogsSub=""
    ..f  s pogsSub=$o(^PIVA(0,"DATELOC",PivaLocId,CalcuDate,psId,pogId,pogsSub)) q:pogsSub=""  d
    ...q:+pogsSub=0
    ...s pogsData=^PIVA(pogId,"S",pogsSub)
    ...s pogsNo=$p(pogsData,"^",7)
    ...q:pogsNo=""
    ...s pogsTime=$p(pogsData,"^",5)
    ...i '$d(PIVAOrdGrpStateData("PogsNo",psNumber,pogsNo)) s PIVAOrdGrpStateData("PogsNo",psNumber,pogsNo)=pogsTime_"^"_pogsTime_"^"_pogId_"||"_pogsSub_"^"_psId
    ...e  d
    ....i pogsTime<$p(PIVAOrdGrpStateData("PogsNo",psNumber,pogsNo),"^",1) s $p(PIVAOrdGrpStateData("PogsNo",psNumber,pogsNo),"^",1)=pogsTime
    ....i pogsTime>$p(PIVAOrdGrpStateData("PogsNo",psNumber,pogsNo),"^",2) s $p(PIVAOrdGrpStateData("PogsNo",psNumber,pogsNo),"^",2)=pogsTime
    s psNumber=""
    f  s psNumber=$o(PIVAOrdGrpStateData("PogsNo",psNumber)) q:psNumber=""  d
    .s pogsNo=""
    .f  s pogsNo=$o(PIVAOrdGrpStateData("PogsNo",psNumber,pogsNo)) q:pogsNo=""  d
    ..s pogsNoData=PIVAOrdGrpStateData("PogsNo",psNumber,pogsNo)
    ..s pogsStTime=$p(pogsNoData,"^",1)
    ..s pogsEdTime=$p(pogsNoData,"^",2)
    ..s pogsId=$p(pogsNoData,"^",3)
    ..s psId=$p(pogsNoData,"^",4)
    ..s pogsData=^PIVA(+pogsId,"S",$p(pogsId,"||",2))
    ..s pogsUser=$p(pogsData,"^",3)
    ..s pogsUserName=##class(PHA.COM.Data.Base).UserName(pogsUser)
    ..s pogsDate=$p(pogsData,"^",4)
    ..s psName=##class(PHA.COM.Data.Base).PIVASStateName(psId)
    ..s pogsDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(pogsDate,"PIVAS") 
    ..s pogsStTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(pogsStTime,"PIVAS") 
    ..s pogsEdTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(pogsEdTime,"PIVAS") 
    ..s pogsTime=pogsStTime_" - "_pogsEdTime
    ..s Data=$lb(psName,pogsNo,pogsDate,pogsTime,pogsUserName,psNumber)
    ..s ^CacheTemp(repid,ind)=Data    
    ..s ind=ind+1
    k PIVAOrdGrpStateData
    q $$$OK
}

/// deccription:库存分类
/// table:      User.INCStkCat
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","INCSCStkGrp","","西")
Query INCSCStkGrp(inputStr = "", filterText = "", HospId = "", LocId = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod INCSCStkGrpExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "", HospId = "", LocId = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s filterText=$zcvt(filterText,"U")
    i LocId'="" s HospId=$p($g(^CTLOC(LocId)),"^",22)
    s ind=1
    s stkCatId=0
    f  s stkCatId=$o(^INC("SC",stkCatId)) q:+stkCatId'>0  d 
    .s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_StkCat",stkCatId,HospId) //医院级别授权
    .q:flag="N"
    .q:'$d(^DHCSCG("STKCAT",stkCatId))
    .s stkGrpId=$o(^DHCSCG("STKCAT",stkCatId,"")) 
    .q:stkGrpId=""
    .q:(inputStr'="")&&(inputStr'=stkGrpId)
    .s stkType=$p(^DHCSCG(stkGrpId),"^",3)
    .q:stkType'="G"
    .s stkCatDesc=##class(PHA.PIVAS.Data.Base).StkCatDesc(stkCatId)
    .i filterText'="" s stkCatPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(stkCatDesc)
    .q:(filterText'="")&&(stkCatPY'[filterText)&&(stkCatDesc'[filterText)
    .d outputRow
    Quit $$$OK
outputRow  
    s Data=$lb(stkCatId,stkCatDesc)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:科室类组
/// table:      User.DHCStkLocCatGroup
/// input:      inputStr^1:科室Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","DHCStkLocCatGroup","101","西")
Query DHCStkLocCatGroup(inputStr = "", filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod DHCStkLocCatGroupExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s filterText=$zcvt(filterText,"U")
    s ind=1
    s locId=$p(inputStr,"^",1)
    q:locId="" $$$OK
    s stkGrpId=""
    f  s stkGrpId=$o(^DHCSLCG(0,"LOCCAT",locId,stkGrpId)) q:stkGrpId=""  d
    .q:+stkGrpId=0
    .s stkType=$p(^DHCSCG(stkGrpId),"^",3)
    .q:stkType'="G"
    .s stkGrpDesc=##class(PHA.PIVAS.Data.Base).StkCatGrpDesc(stkGrpId)
    .i filterText'="" s stkGrpPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(stkGrpDesc)
    .q:(filterText'="")&&(stkGrpPY'[filterText)&&(stkGrpDesc'[filterText)
    .d outputRow
    Quit $$$OK
outputRow  
    s Data=$lb(stkGrpId,stkGrpDesc)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:配液批次,表格内用,不单独格式化,影响表格加载速度
/// table:      User.PIVABatTime
/// input:      inputStr^1:静配中心科室Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PIVALocBatNo","101")
Query PIVALocBatNo(inputStr = "") As websys.Query(ROWSPEC = "batNo:%String,batNo:%String")
{
}

ClassMethod PIVALocBatNoExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s locId=$p(inputStr,"^",1)
    s pbtId=0
    f  s pbtId=$o(^PIVABT(pbtId)) q:(pbtId=0)||(pbtId="")  d
    .s pbtLocDr=$p(^PIVABT(pbtId),"^",4)
    .q:pbtLocDr'=locId
    .s wardDr=$p(^PIVABT(pbtId),"^",6)
    .q:wardDr'=""
    .s batNo=$p(^PIVABT(pbtId),"^",3)
    .s PIVALocBatNoData(batNo)=batNo_","_batNo
    s batNo=""
    f  s batNo=$o(PIVALocBatNoData(batNo)) q:batNo=""  d
    .s (RowId,Description)=batNo
    .d outputRow
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:病区
/// table:      User.PACWard
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PACWard")
Query PACWard(inputStr = "", filterText = "", hosp = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PACWardExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "", hosp = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    i filterText'="" s inputStr=filterText
    s inputStr=$zcvt(inputStr,"U")
    s warddr=0
    f  s warddr=$o(^PAWARD(warddr), 1, wardData) q:(warddr="")||(+warddr=0)  d
    .s warddesc=##class(PHA.PIVAS.Data.Base).WardDesc(warddr)
    .s locdr=$p(wardData,"^",5)
    .q:locdr=""
    .q:($p(wardData, "^", 6) '= "Y")
    .s locData = $g(^CTLOC(locdr))
    .q:(locData = "")
    .q:(hosp'="")&&(hosp'=$p(locData,"^",22))
    .s locconname=$zcvt($p(locData,"^",43),"U")
    .s warddescpy=##class(web.DHCST.Common.AppCommon).GetCNCODE(warddesc)
    .q:(inputStr'="")&&($zcvt(warddesc,"U")'[inputStr)&&(locconname'[inputStr)&&(warddescpy'[inputStr)
    .q:warddesc=""
    .s activeDateFrom = $p(locData,"^",24)
    .q:(activeDateFrom'="")&(activeDateFrom>+$h) // 未开始
    .s activeDateTo = $p(locData,"^",25)
    .q:(activeDateTo'="")&(activeDateTo<+$h) // 已截止
    .d outputRow
    Quit $$$OK
outputRow  
    s Data=$lb(warddr,warddesc)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:频次
/// table:      User.PHCFreq
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PHCFreq")
Query PHCFreq(inputStr = "", filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod PHCFreqExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s filterText=$zcvt(filterText,"U")
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT phcfr_RowId AS RowId, phcfr_desc1 AS Description FROM phc_freq order by phcfr_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s quitFlag=""
        s RowId = result.Data("RowId") 
        s Description = ##class(PHA.PIVAS.Data.Base).FreqDesc(RowId)
        continue:Description=""
        s phcFreqData=$g(^PHCFR(RowId))
        continue:$p(phcFreqData,"^",6)="N" // PHCFR_ActiveFlag
        i filterText'="" d
        .s DescPY=$zcvt(##class(web.DHCST.Common.AppCommon).GetCNCODE(Description),"U")
        .i (DescPY'[filterText)&&(Description'[filterText) s quitFlag=1
        continue:quitFlag'=""
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:医嘱优先级
/// table:      User.OECPriority
/// input:      inputParams^1:静配中心科室Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","OECPriority","")
Query OECPriority(inputParams = "", filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod OECPriorityExecute(ByRef qHandle As %Binary, inputParams = "", filterText = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s locId=$p(inputParams,"^",1)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr ="SELECT OECPR_RowId as RowId,OECPR_Desc as Description FROM OEC_Priority"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = ##class(PHA.PIVAS.Data.Base).OrdPriDesc(RowId)
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:科室组
/// table:      User.DHCStkLocGroup
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","DHCStkLocGroup","50")
Query DHCStkLocGroup(inputStr = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod DHCStkLocGroupExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s phaLoc=$p(inputStr,"^",1)
    s combotext=""
    s inputLen=$l(inputStr,"^")
    i inputLen>1 s combotext=$p(inputStr,"^",inputLen)
    s result=##class(%Library.ResultSet).%New("web.DHCSTKUTIL:GetLocGroupQuery")
    s sc=result.Execute("G",combotext,phaLoc)
    While(result.Next())
    {
        s RowId = result.Data("Rowid") 
        s Description = ##class(PHA.PIVAS.Data.Base).LocGroupDesc(RowId)
        d outputRow
    }
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:医生科室
/// table:      User.CTLOC
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","DocLoc","xn")
Query DocLoc(inputStr = "", filterText = "", hosp = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod DocLocExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "", hosp = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s comboText=filterText
    s locId=0
    f  s locId=$o(^CTLOC(locId), 1, locData) q:locId=""  d
    .s locDesc=##class(PHA.PIVAS.Data.Base).LocDesc(locId)
    .s locConName=$p(locData,"^",43)
    .q:(hosp'="")&&(hosp'=$p(locData,"^",22))
    .q:($p(^CTLOC(locId),"^",13)'="E")
    .s activeDateFrom = $p(locData,"^",24)
    .q:(activeDateFrom'="")&(activeDateFrom>+$h) // 未开始
    .s activeDateTo = $p(locData,"^",25)
    .q:(activeDateTo'="")&(activeDateTo<+$h) // 已截止
    .s matchFlag=""
    .i comboText="" s matchFlag=1
    .i (comboText'="")&&($zcvt(locDesc,"U")[$zcvt(comboText,"U")) s matchFlag=1
    .i (comboText'="")&&($zcvt(locConName,"U")[$zcvt(comboText,"U")) s matchFlag=1
    .q:matchFlag=""
    .d outputRow
    Quit $$$OK
outputRow  
    s Data=$lb(locId,locDesc)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:科室用户
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","LocUser","101")
Query LocUser(inputStr = "", filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod LocUserExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s locId=$p(inputStr,"^",1)
    s onlyDef=$p(inputStr,"^",2)
    s userId=0,num=0
    f  s userId=$o(^SSU("SSUSR",userId)) q:userId=""  d
    .s locDr=+$p(^SSU("SSUSR",userId),"^",4)
    .i locId=locDr s LocUserArr(userId)=""
    .q:onlyDef="Y"
    .s otherUserId=""
    .f  s otherUserId=$o(^SSU("SSUSR",userId,"OTHLL",otherUserId)) q:otherUserId=""  d
    ..s locDr=+$p(^SSU("SSUSR",userId,"OTHLL",otherUserId),"^",1)
    ..i locDr=locId s LocUserArr(userId)=""
    s userId=""
    f  s userId=$o(LocUserArr(userId)) q:userId=""  d
    .s userName=##class(PHA.PIVAS.Data.Base).UserName(userId)
    .s useractive=$p(^SSU("SSUSR",userId),"^",19)  //激活标志
    .q:useractive'="Y"
    .s dateto=$p(^SSU("SSUSR",userId),"^",97)  //过期时间   
    .s dateto=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(dateto)
    .q:(dateto'="")&&(dateto<+$h)
    .s userPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(userName)
    .s matchFlag=""
    .i filterText="" s matchFlag=1
    .i (filterText'="")&&($zcvt(userName,"U")[$zcvt(filterText,"U")) s matchFlag=1
    .i (filterText'="")&&($zcvt(userPY,"U")[$zcvt(filterText,"U")) s matchFlag=1
    .q:matchFlag=""
    .d outputRow
    Quit $$$OK
outputRow  
    s Data=$lb(userId,userName)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:班次类型
/// input:      ^1:配液中心Id
/// table:      User.PIVASchedulType
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PIVASchedulType",101)
Query PIVASchedulType(inputStr = "") As websys.Query(ROWSPEC = "RowId,Description")
{
}

ClassMethod PIVASchedulTypeExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s PivaLocId=$p(inputStr,"^",1)
    q:+PivaLocId=0 $$$OK
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT * FROM PIVA_SchedulType where PST_RowId>0"
    i PivaLocId'="" s sqlStr=sqlStr_" and PST_Loc_Dr="_"'"_PivaLocId_"'"
    s sqlStr=sqlStr_" order by PST_Loc_Dr"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId= result.Data("PST_RowId") 
        s Description= result.Data("PST_Desc") 
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:班次字典
/// input:      ^1:配液中心Id
/// table:      User.PIVASchedul
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PIVASchedul",101)
Query PIVASchedul(inputStr = "", filterText = "") As websys.Query(ROWSPEC = "RowId,Description")
{
}

ClassMethod PIVASchedulExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "") As %Status
{
    s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.Dictionary","PIVASchedul")=$lb(inputStr,filterText)
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s PivaLocId=$p(inputStr,"^",1)
    q:+PivaLocId=0 $$$OK
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT * FROM PIVA_Schedul where PS_RowId>0"
    i PivaLocId'="" s sqlStr=sqlStr_" and PS_Loc_Dr="_"'"_PivaLocId_"'"
    s sqlStr=sqlStr_" order by PS_Loc_Dr"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId= result.Data("PS_RowId") 
        s Description= result.Data("PS_Desc") 
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// description: 请假类型
/// table:       User.PIVALeaveType
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","PIVALeaveType")
Query PIVALeaveType() As %SQLQuery(CONTAINID = 1)
{
    SELECT PLT_RowId as RowId,PLT_Desc as Description FROM  PIVA_LeaveType
    where PLT_RowId>0
}

/// deccription:退药原因
/// table:      User.BLCReasonForRefund
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","RetReason")
Query RetReason(inputStr = "", hosp = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod RetReasonExecute(ByRef qHandle As %Binary, inputStr = "", hosp = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT RFR_RowId FROM BLC_ReasonForRefund"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Get("RFR_RowId") 
        continue:(hosp'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("BLC_ReasonForRefund",RowId,hosp)="N")
        s Description = ##class(PHA.COM.Data.Base).RefundReasonDesc(RowId)
        s ^CacheTemp(repid, ind) = $lb(RowId, Description)    
        s ind = ind + 1
    }
    d result.Close()
    Quit $$$OK
}

/// deccription:药学成分可能涉及的单位,比较固定
/// table:      User.BLCReasonForRefund
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","CtUom")
Query CtUom(inputStr = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod CtUomExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
    s CtUomArr("ML")=""
    s CtUomArr("L")=""
    s CtUomArr("G")=""
    s CtUomArr("MMOL")=""
    s CtUomArr("IU")=""
    s CtUomArr("KCAL")=""
    s CtUomArr("J")=""
    s CtUomArr("KJ")=""
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT CTUOM_RowId as RowId, CTUOM_Desc as Description FROM CT_UOM"
    d result.Prepare(sqlStr)
    d result.Execute()
    s RowId="",Description="　"
    d outputRow 
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        // 配液可能涉及的单位
        s UpperDesc=$zcvt(Description,"U")
        continue:'$d(CtUomArr(UpperDesc))
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow  
    s Data=$lb(RowId,Description)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:所有科室
/// table:      User.CTLOC
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","CTLoc","89^D")
Query CTLoc(inputStr = "", filterText = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod CTLocExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s comboText=filterText
    s locId=$p(inputStr,"^",1)
    q:locId="" $$$OK
    s locType=$p(inputStr,"^",2)
    s hospId=$p($g(^CTLOC(locId)),"^",22)
    s ctLocId=""
    i locType'="" d
    .f  s ctLocId=$o(^CTLOC(0,"LocType",locType,ctLocId)) q:ctLocId=""  d
    ..d GetCTLoc
    .e  d
    ..f  s ctLocId=$o(^CTLOC(ctLocId)) q:ctLocId=""  d
    ...d GetCTLoc
    q $$$OK
GetCTLoc
    s locData = ^CTLOC(ctLocId)
    s ctLocDesc=##class(PHA.PIVAS.Data.Base).LocDesc(ctLocId)
    q:(ctLocDesc["停")||(ctLocDesc["废")
    s ctLocConName=$p(locData,"^",43)
    q:hospId'=$p(locData,"^",22)
    s activeDateFrom = $p(locData,"^",24)
    q:(activeDateFrom'="")&(activeDateFrom>+$h) // 未开始
    s activeDateTo = $p(locData,"^",25)
    q:(activeDateTo'="")&(activeDateTo<+$h) // 已截止
    s matchFlag=""
    i comboText="" s matchFlag=1
    i (comboText'="")&&($zcvt(ctLocDesc,"U")[$zcvt(comboText,"U")) s matchFlag=1
    i (comboText'="")&&($zcvt(ctLocConName,"U")[$zcvt(comboText,"U")) s matchFlag=1
    q:matchFlag="" 
    s Data=$lb(ctLocId,ctLocDesc)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// deccription:药品药学成分可选的每单位,基本单位与等效单位
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","DrugUom","2||1")
Query DrugUom(inputStr = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod DrugUomExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
    k DrugUomDATA
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s phcdf=$p(inputStr,"^",1)
    q:phcdf="" $$$OK
    s phcd=+phcdf
    s phcdForm=+$p(phcdf,"||",2)
    s phcBUomId=$p($g(^PHCD(phcd,"DF",phcdForm,2)),"^",4)
    q:phcBUomId="" $$$OK
    s DrugUomDATA(phcBUomId)=""
    s eqSub=0
    f  s eqSub=$O(^PHCD(phcd,"DF",phcdForm,"EQ",eqSub)) q:eqSub=""  d
    .s eqUomDr=$P(^PHCD(phcd,"DF",phcdForm,"EQ",eqSub),"^",1)
    .q:eqUomDr=""
    .s eqQty=$P(^PHCD(phcd,"DF",phcdForm,"EQ",eqSub),"^",2)
    .q:+eqQty<=0
    .s DrugUomDATA(eqUomDr)=""
    s uomId=""
    f  s uomId=$o(DrugUomDATA(uomId)) q:uomId=""  d
    .s Data=$lb(uomId,##class(PHA.PIVAS.Data.Base).UomDesc(uomId))
    .s ^CacheTemp(repid,ind)=Data    
    .s ind=ind+1
    q $$$OK
}

/// deccription:医嘱项combo
/// table:      User.ARCItmMast
/// input:      inputParams^1:别名
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","ArcItmMastStore","a")
Query ArcItmMastStore(filterText = "", HospId = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod ArcItmMastStoreExecute(ByRef qHandle As %Binary, filterText = "", HospId = "") As %Status
{
    s repid = $i(^CacheTemp)
    s qHandle = $lb(0, repid, 0)
    s ind = 1
    q:(filterText = "") $$$OK
    s pAlias = $zcvt(filterText, "U")
    
    s sqlStr = "SELECT ARCIM_RowId, ARCIM_Desc  FROM ARC_ItmMast"

    s sqlStatement = ##class(%SQL.Statement).%New()
    s sqlStatus = sqlStatement.%Prepare(sqlStr)
    s sqlResult = sqlStatement.%Execute()
    while (sqlResult.%Next()){
        s arcim = sqlResult.%Get("ARCIM_RowId")
        continue:(##class(PHA.FACE.IN.Com).GetShowDataFlag("ARC_ItmMast", arcim, HospId) '= "Y")
        continue:(##class(web.DHCSTPIVAS.Dictionary).CheckArcAliasExist(arcim, pAlias) '= 1)
        s arcimDesc = ##class(PHA.PIVAS.Data.Base).ArcimDesc(arcim)
        s ^CacheTemp(repid, ind) = $lb(arcim, arcimDesc)    
        s ind = ind + 1
    }   
    q $$$OK
}

/// Description: 楼宇楼层
/// Debug:       w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Dictionary","BuildingFloor","")   
Query BuildingFloor(filterText = "", hosp = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod BuildingFloorExecute(ByRef qHandle As %Binary, filterText = "", hosp = "") As %Status
{
    s ind = 1
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s filterText = $zcvt(filterText, "U")
    
    s buildingID = 0 
    for {
        s buildingID = $o(^CT("CTLB", buildingID), 1, data)
        q:(buildingID = "")
        continue:(hosp '= "")&&(hosp '= $p(data, "^", 6))
        s stDate = $p(data, "^", 3)
        continue:(stDate '= "")&&(stDate > +$h)
        s edDate = $p(data, "^", 4)
        continue:(edDate '= "")&&(edDate < +$h)
        s itm = 0
        for {
            s itm = $o(^CT("CTLB", buildingID, "Floor", itm), 1, itmData)
            q:(itm = "")
            s stDate = $p(itmData, "^", 2)
            continue:(stDate '= "")&&(stDate > +$h)
            s edDate = $p(itmData, "^", 3)
            continue:(edDate '= "")&&(edDate < +$h) 
            s floorDesc = $p(data, "^", 2) _ "-" _ $p(itmData, "^", 1)
            if (filterText '= ""){
                s floorDescPY = ##class(ext.util.String).ToChineseSpell(floorDesc)
                continue:(floorDescPY '[ filterText)&&(floorDesc '[ filterText)
            }
            s ^CacheTemp(repid, ind) = $lb(buildingID _ "||" _ itm, floorDesc)    
            s ind = ind + 1             
        }
    }
    q $$$OK
}

/// Description: 药品属性通用字典,代码为ID
/// Creator:     yunhaibao
/// CreateDate:  2019-07-24  
/// Table:       DHC_StkComDictionary
/// Input：       ScdType-字典类型
/// d ##class(%ResultSet).RunQuery("PHA.STORE.Drug","StkComDictionary","HighRiskType")
Query StkComDictionaryAsCode(inputStr As %String = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod StkComDictionaryAsCodeExecute(ByRef qHandle As %Binary, inputStr As %String = "") As %Status
{
    s ScdType = $p(inputStr, "^", 1)
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    q:ScdType="" $$$OK
    s ScdType=$$ALPHAUP^SSUTIL4(ScdType)
    s Dict=""
    f  s Dict=$o(^DHCSTSCDI(0,"TYPE",ScdType,Dict)) q:Dict=""  d
    .q:+Dict'>0 
    .s Code=$p(^DHCSTSCDI(Dict),"^",1)
    .s Description=##class(PHA.COM.Data.Base).StkComDictionaryDesc(Dict)
    .s Data=$lb(Code,Description)
    .s ^CacheTemp(repid,ind)=Data    
    .s ind=ind+1
    q $$$OK
}

/// Description: 配伍审核原因
/// Debug:       w ##class(web.DHCSTPIVAS.Dictionary).GetAuditReasonJson(2)
ClassMethod GetAuditReasonJson(hosp = "", params = "")
{
    s nullJson = {"total": 0, "rows":[]}
    s retObj = {}
    s wayId = ##class(web.DHCSTPIVAS.Common).PivasWayCode()
	q:(wayId = "") nullJson.%ToJSON()
    
    s retRows = []
    s level = ""
    for {
        s level = $o(^DHCPCREASON(0, "Level", wayId, level)) q:(level = "")
        s reasonId = 0
        for {
            s reasonId = $o(^DHCPCREASON(0, "Level", wayId, level, reasonId)) q:(reasonId = "")
            continue:(##class(PHA.FACE.IN.Com).GetShowDataFlag(##class(web.DHCSTPIVAS.AuditReason).#TableName, reasonId ,hosp)="N")
            s reasonData = $g(^DHCPCREASON(reasonId))
            s reasonCode = $p(reasonData, "^", 1)
            s reasonDesc = ##class(PHA.COM.Data.Base).CNTSReasonDesc(reasonId)
            s rowData = {
                "reasonId": (reasonId),
                "reasonCode": (reasonCode),
                "reasonDesc": (reasonDesc),
                "_parentId": (level)
            }
            d retRows.%Push(rowData)
        }
    }
    d retRows.%Push({
        "reasonId": (0),
        "reasonCode": ("配伍审核原因"),
        "reasonDesc": ("配伍审核原因")
    })
    s retObj.total = retRows.%Size()
    s retObj.rows = retRows
    q retObj.%ToJSON()
}

/// w ##class(web.DHCSTPIVAS.Dictionary).GetAuditReasonTreeStore(,2)
ClassMethod GetAuditReasonTreeStore(Params = "", HospId = "")
{
	s wayId = ##class(web.DHCSTPIVAS.Common).PivasWayCode()
	q:(wayId = 0) "[]"

	s desc = $p(Params, "^", 2)
	
	k reasonDataArr
	s level = ""
	for {
		s level = $o(^DHCPCREASON(0, "Level", wayId, level)) 
		q:(level = "")
		s reasonId = ""
		for {
			s reasonId = $o(^DHCPCREASON(0, "Level", wayId, level, reasonId))	
			q:(reasonId = "")
			continue:(##class(PHA.FACE.IN.Com).GetShowDataFlag(##class(web.DHCSTPIVAS.AuditReason).#TableName, reasonId, HospId) = "N")
			s reasonData = $g(^DHCPCREASON(reasonId))
			s reasonDesc = $p(reasonData, "^", 2)
			continue:(desc '= "")&&(reasonDesc '[ desc)		//&&(level '= 0)
			s reasonDataArr("Level", level, reasonId)=reasonDesc
		}
	}

	q:('$d(reasonDataArr)) "[]"
	s retJsonArr = []
	
		s level=0
		for {  
			s level = $o(reasonDataArr("Level", level)) 
			q:(level = "")
			s tmpObj = ..GetReasonChildren(level, .reasonDataArr)
			continue:tmpObj="" 
			d retJsonArr.%Push(tmpObj)
		}
	
	q retJsonArr.%ToJSON()
}

ClassMethod GetReasonChildren(sub, ByRef reasonDataArr)
{
	q:(sub = "") ""
	s reasonObj = {}
	s reasonObj.id = sub
	s reasonDesc = $p($g(^DHCPCREASON(+sub)), "^", 2)
	s reasonObj.text = reasonDesc
	s reasonObj.level = +$p($g(^DHCPCREASON(+sub)), "^", 3)
	s reasonObj.state = "open"
	s reasonObj.isLeaf = "N"
	s reasonObj.children = []
    s level=sub
    #; b //22
    if ($o(reasonDataArr("Level", sub, "")) = ""){
        s reasonObj.isLeaf = "Y"
    }
	#; if (sub = 0) {
	#; 	s reasonId = +$o(reasonDataArr("Level", sub, ""))
	#; 	s reasonObj.id = reasonId
	#; 	s reasonDesc = $p($g(^DHCPCREASON(+reasonId)), "^", 2)
	#; 	s reasonObj.text = reasonDesc
	#; 	s reasonObj.isLeaf = "Y"
	#; 	s level = $o(reasonDataArr("Level", sub))
	#; }
	#; else {
	#; 	s level = sub	
	#; }
	if (level '= "") {
		s reasonId = ""
		for {
			s reasonId = $o(reasonDataArr("Level", level, reasonId))	
			q:(reasonId = "")
			s childObj = ..GetReasonChildren(reasonId, .reasonDataArr)
			continue:(childObj = "")
			#; s reasonObj.isLeaf = "Y"
			d reasonObj.children.%Push(childObj)
            k reasonDataArr("Level", level, reasonId)
		} 
	}	

	q reasonObj
}

}
