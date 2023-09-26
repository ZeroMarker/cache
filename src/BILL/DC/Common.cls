Class BILL.DC.Common Extends (%RegisteredObject, %XML.Adaptor, %ZEN.DataModel.Adaptor, BILL.DC.Utils.Enum.LogType)
{

/// Creator: tangzf
/// CreateDate: 2022-05-23
/// Descript: 查询
/// Table : CT_BILL_DC.DicData
/// Input:  HospDr ExpStr:是否输出一个全部Y 输出 ,默认不输出|……
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.DC.Common","QueryClass","")
Query QueryClass(keyCode = "") As websys.Query(ROWSPEC = "DicCode,DicDesc") [ SqlProc ]
{
}

ClassMethod QueryClassExecute(ByRef qHandle As %Binary, keyCode = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    s ^CacheTemp("BILL.DC.BL.DicDataCtl","QueryInfo")=$lb(keyCode)
    s ClassNameStr="User.PAPatMas|基本信息表^User.PAAdm|就诊表^User.DHCINVPRT|门诊发票表^User.PatientBill|账单主表"
    s tCodeAndDesc=$$ALPHAUP^SSUTIL4(keyCode)

    for i=1:1:$l(ClassNameStr,"^")  d
    .s tmpClassName=$p(ClassNameStr,"^",i)
    .s DicCode=$p(tmpClassName,"|",1)
    .s DicDesc=$p(tmpClassName,"|",2)
    .d QueryPortList
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
QueryPortList
    set Data=$lb(DicCode,DicDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// Creator: tangzf
/// CreateDate: 2022-05-23
/// Descript: 查询
/// Table : CT_BILL_DC.DicData
/// Input:  HospDr ExpStr:是否输出一个全部Y 输出 ,默认不输出|……
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.DC.Common","QueryClass","")
Query QueryProperty(ClsInfo, keyCode = "") As websys.Query(ROWSPEC = "DicCode,DicDesc") [ SqlProc ]
{
}

ClassMethod QueryPropertyExecute(ByRef qHandle As %Binary, ClsInfo, keyCode = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    s ^CacheTemp("BILL.DC.BL.DicDataCtl","QueryInfo")=$lb(keyCode)
    s ClassNameStr="User.PAPatMas|基本信息表^User.PAAdm|就诊表^User.DHCINVPRT|门诊发票表^User.PatientBill|账单主表"
    s tCodeAndDesc=$$ALPHAUP^SSUTIL4(keyCode)

    s rsltSt = ##class(%ResultSet).%New("%Dictionary.PropertyDefinition:Summary")
    b //116
    d rsltSt.Execute(ClsInfo)
    If rsltSt.QueryIsValid() { 
        While(rsltSt.Next()) {
            s DicDesc=rsltSt.Name
            s DicCode=rsltSt.Name
            continue:DicCode["Child"
            d QueryPortList
        }
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
QueryPortList
    set Data=$lb(DicCode,DicDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 新增
/// Table : CT.BILL.DC.IndicatorDef
/// Input:  LogType = 参考 BILL.DC.Utils.Enum.LogType
/// Output: 
/// Return: 
/// w ##class(BILL.DC.Common).Log(InJson)
ClassMethod Log(LogType, Input...)
{
    s $zt="BILLDCLOGErr"
    s LogJob=$i(^CacheTemp("BILL.DC.Common","Log"))
    s Date=$zts
    s tmpInput=""
    f i=1:1:$g(Input,0){
        s tmpInput1=$g(Input(i),"<NULL>")
        if (tmpInput=""){
            s tmpInput=tmpInput1
        }else{
            s tmpInput=tmpInput_","_tmpInput1
        }
    }
    if (LogType=..#Recommendation){
        
    }elseif(LogType=..#Normal){
        
    }
    elseif(LogType=..#Important){
        
    }
    elseif(LogType=..#Exceptions){
        
    }else{
    }
    s ^CacheTemp("BILL.DC.Log","Log",LogType,Date,LogJob)=tmpInput
    q ""
BILLDCLOGErr
    s Date=$zts
    s ^CacheTemp("BILL.DC.Log","LogErr",Date)=""
    q ""
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 清除核查结果信息
/// Table : 
/// Input:  DataSrc 表名 ，DataId 表ID
/// Output: 
/// Return: ArrayList
/// d ##class(BILL.DC.Common).DelCKResult()
ClassMethod DelCKResult()
{

    &sql(TRUNCATE TABLE BILL_DC_PO.CheckResult)
    &sql(TRUNCATE TABLE BILL_DC_PO.CheckResultDet)
    // d ##class(BILL.DC.PO.CheckResultDet).%BuildIndices()
}

/// w ##class(BILL.DC.Common).Test()
ClassMethod Test()
{
    s $zt="TestErr"
    //d ##class(User.DHCPatientBill).%BuildIndices()
    //Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("User.PAPatMas1")
    /// d ##class(%ResultSet).RunQuery("%Dictionary.PropertyDefinition","Summary","User.PAPatMas")
    //zww ##class(%Dictionary.PropertyDefinition).%ExistsId("User.PAPatMas||%Open")
    s rsltSt = ##class(%ResultSet).%New("%Dictionary.PropertyDefinition:Summary")
    b //116
    d rsltSt.Execute("User.PAPatMas")
    If rsltSt.QueryIsValid() { 
        While(rsltSt.Next()) {
            b //119
        }
    }
    /*
    for i=1:1:80 d
    .s a=$lg(^CacheTemp("CT.BILL.DC.IndicatorDef","Save"),1)
    .s b=$lg(^CacheTemp("CT.BILL.DC.IndicatorDef","Save"),2)
    .s $p(a,"^",1)=""
    .s rtn=##class(BILL.DC.BL.IndicatorDefCtl).Save(a,b)
    .;b //2
    .w rtn,!
    */
TestErr
    b //130
    q
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 查询
/// Table : BILL_DC_PO.CheckResult
/// Input:  HospDr
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.DC.Common","QueryBillBalanceError","2022-1-1","2022-6-6","","")
Query QueryBillBalanceError(StartDate, EndDate, StartTime = "", EndTime = "", ExpStr = "") As websys.Query(ROWSPEC = "Rowid,ErrBill,ShowPBO,ShowPBD,PBAmount,PBPatientShare,PBOToTalAmount,PBOPatientShare,PBDTotalAmount,PBDPatientShare,_parentId,RegNo,PatName,PBDBillDate") [ SqlProc ]
{
}

ClassMethod QueryBillBalanceErrorExecute(ByRef qHandle As %Binary, StartDate, EndDate, StartTime = "", EndTime = "", ExpStr = "") As %Status
{
    
    
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    s ^CacheTemp("INSU.MI.PortCommonCom","QueryByBusinessAndCode")=$lb(StartDate, EndDate, StartTime, EndTime, ExpStr)
    //s IndexIndicatorId=$o()
    s (Bill,PBO,PBD,PBAmount,PBPatientShare,PBOToTalAmount,PBOPatientShare,PBDTotalAmount,PBDPatientShare)=0
    s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    s:StartTime'="" StartTime=$zth(StartTime)
    s:EndTime'="" EndTime=$zth(EndTime)
    q:(StartDate="")||(EndDate="") "-2DC^核查日期不能为空"
    k ^||CacheTemp("QueryBillBalanceError")
    s RegNo=$p(ExpStr,"|",1)
    s InputBill=$p(ExpStr,"|",2)
    s AdmId=$p(ExpStr,"|",3)
    s PatName=$p(ExpStr,"|",4)
    s HospitalDr=$p(ExpStr,"|",5)
    if (InputBill'="")
    {
        s ^||CacheTemp("QueryBillBalanceError",InputBill)=""
    }
#;    else
#;    {
#;        s CRID=""
#;        for  s CRID=$o(^BILL.DC.PO.CheckResultI("IndexIndicator","OPBILL","02",CRID)) q:CRID=""  d
#;        .s CRDID=""
#;        .for  s CRDID=$o(^BILL.DC.PO.CheckResultDetI("IndexParID",CRID,CRDID)) q:CRDID=""  d
#;        ..s BillRowid=+$lg(^BILL.DC.PO.CheckResultDetD(CRDID),3)
#;        ..s ^||CacheTemp("QueryBillBalanceError",BillRowid)=""
#;    }

    //如果未使用 数据核查系统 可放开下段注释
    else
    {
	    f UpdateDate=StartDate:1:EndDate  
	    {
	        s BillRowid=0
	        while $o(^DHCPB(0,"Date",UpdateDate,BillRowid))  
	        {
	            s BillRowid=$o(^DHCPB(0,"Date",UpdateDate,BillRowid))
	            continue:BillRowid=""
	            if (HospitalDr'="")
	            {
		            s PAADMDr=$p($g(^DHCPB(BillRowid)),"^",1) //通过查询就诊科室查询账单所属院区
		            s PAADMDepCodeDR=$p($g(^PAADM(PAADMDr)),"^",4) //就诊科室
		            s CTLOCHospitalDR=$p($g(^CTLOC(PAADMDepCodeDR)),"^",22) //院区
		            continue:HospitalDr'=CTLOCHospitalDR
	            }
	            set BillData=$g(^DHCPB(BillRowid))
	            set PBAmount=$fn(+$p(BillData,"^",8),"",2) //账单主表 本次计费的总额
	            set PBPatientShare=$fn(+$p(BillData,"^",12),"",2) //账单主表 本次费用病人自付额
	            set TPBOTotalAmt=0 //病人医嘱费用明细表 病人医嘱总费用之和
	            set TPBOPatientAmt=0 //病人医嘱费用明细表 病人自费部分之和
	            set PBOChildSub=0
	            while ($o(^DHCPB(BillRowid,"O",PBOChildSub))) {

	                set PBOChildSub=$o(^DHCPB(BillRowid,"O",PBOChildSub))
	                set PBOData=$g(^DHCPB(BillRowid,"O",PBOChildSub))
	                set PBOToTalAmount=$fn(+$p(PBOData,"^",8),"",2) //病人医嘱费用明细表 病人医嘱总费用
	                set PBOPatientShare=$fn(+$p(PBOData,"^",11),"",2) //病人医嘱费用明细表 病人自费部分
	                set TPBOTotalAmt=TPBOTotalAmt+PBOToTalAmount 
	                set TPBOPatientAmt=TPBOPatientAmt+PBOPatientShare 
	                set PBDChildSub=0
	                set TPBDTotalAmt=0 //账单收费项目明细表 发生总数之和
	                set TPBDPatientAmt=0 //账单收费项目明细表 病人自费数之和
	                set DetailNum=1
	                while ($o(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))) {
	                    set PBDChildSub=$o(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))
	                    set PBDData=$g(^DHCPB(BillRowid,"O",PBOChildSub,"D",PBDChildSub))
	                    set PBDTotalAmount=$fn(+$p(PBDData,"^",7),"",2) //账单收费项目明细表 发生总数
	                    set PBDPatientShare=$fn(+$p(PBDData,"^",10),"",2) //账单收费项目明细表 病人自费数
	                    set TPBDPatientAmt=TPBDPatientAmt+PBDPatientShare
	                    set TPBDTotalAmt=TPBDTotalAmt+PBDTotalAmount
	                    // PBD相关校验开始
	                }
	                if +PBOPatientShare'=+TPBDPatientAmt{
	                    
	                    s ^||CacheTemp("QueryBillBalanceError",BillRowid)=""
	                }
	                if +PBOToTalAmount'=+TPBDTotalAmt{
	                    s ^||CacheTemp("QueryBillBalanceError",BillRowid)=""
	                }
	            }
	            if (+PBAmount'=+TPBOTotalAmt) {
	                s ^||CacheTemp("QueryBillBalanceError",BillRowid)=""
	            }
	            if +PBPatientShare'=+TPBOPatientAmt {
	                s ^||CacheTemp("QueryBillBalanceError",BillRowid)=""
	            }
	        }       
	    }
    }
    s ErrBill=""
    for  s ErrBill=$o(^||CacheTemp("QueryBillBalanceError",ErrBill))  q:ErrBill=""  d
    .;q:(InputBill'="")&&(InputBill'=ErrBill)
    .;PAPMIInfo
    .q:$g(^DHCPB(ErrBill))=""
    .s PAADM=$p(^DHCPB(ErrBill),"^",1)
    .q:(AdmId'="")&&(AdmId'=PAADM)
    .s PAPMI=$p(^PAADM(PAADM),"^",1)
    .s PatAdmInfo=##class(web.UDHCJFBaseCommon).GetPatAdmInfo(PAADM,PAPMI,ErrBill)
    .s PatInfo=$p(PatAdmInfo,"#",1)
    .s AdmInfo=$p(PatAdmInfo,"#",2)
    .q:(PatName'="")&&($p(PatInfo,"^",2)'[PatName)
    .q:(RegNo'="")&&(RegNo'=$p(PatInfo,"^",1))
    .;;-
    .s PBO=0
    .set BillData=$g(^DHCPB(ErrBill))
    .set tPBOAmt=0
    .set tPBOSelfAmt=0
    .//开始循环PBO
    .for  s PBO=$o(^DHCPB(ErrBill,"O",PBO))  q:PBO=""  d
    ..set PBD=0
    ..set tPBDAmt=0
    ..set tPBDSelfAmt=0
    ..// 开始循环PBD
    ..for  s PBD=$o(^DHCPB(ErrBill,"O",PBO,"D",PBD))  q:PBD=""  d
    ...set PBDData=$g(^DHCPB(ErrBill,"O",PBO,"D",PBD))
    ...set PBDTotalAmount=$fn(+$p(PBDData,"^",7),"",2) //账单收费项目明细表 发生总数
    ...set PBDPatientShare=$fn(+$p(PBDData,"^",10),"",2) //账单收费项目明细表 病人自费数
    ...set PBDBillDate=$p(PBDData,"^",11) //账单日期
    ...s DateFormat=##class(web.DHCAPPCommonUtil).DateFormat()
    ...s:PBDBillDate'="" PBDBillDate=$zd(PBDBillDate,DateFormat)
    ...set (PBOToTalAmount,PBOPatientShare)=""
    ...set PBAmount=""
    ...set PBPatientShare=""
    ...set BillPar=ErrBill_"O"_PBO
    ...set Rowid=ErrBill_"O"_PBO_"D"_PBD
    ...set ShowPBO=""
    ...set tPBDAmt=$i(tPBDAmt,+PBDTotalAmount)
    ...set tPBDSelfAmt=$i(tPBDSelfAmt,+PBDPatientShare)
    ...set ShowPBD=ErrBill_"||"_PBO_"||"_PBD
    ...set (OPatName,ORegNo)=""
    ...set itmDR=$p(PBDData,"^",3)
    ...set PBOToTalAmount="收费项名称："
    ...set PBOPatientShare=$s((+itmDR'=0):$p($g(^DHCTARI(itmDR)),"^",2),1:"")
    ...d QueryBillBalance
    ..//输出PBO层
    ..set (Rowid,ShowPBD,PBPatientShare,PBOToTalAmount,PBOPatientShare,PBDTotalAmount,PBDPatientShare,BillPar)=""
    ..set PBOData=$g(^DHCPB(ErrBill,"O",PBO))
    ..set PBOToTalAmount=$fn(+$p(PBOData,"^",8),"",2) //病人医嘱费用明细表 病人医嘱总费用
    ..set PBOPatientShare=$fn(+$p(PBOData,"^",11),"",2) //病人医嘱费用明细表 病人自费部分
    ..set tPBOAmt=$i(tPBOAmt,+PBOToTalAmount)
    ..set tPBOSelfAmt=$i(tPBOSelfAmt,+PBOPatientShare)
    ..set BillPar=ErrBill
    ..set ShowPBO=ErrBill_"||"_PBO
    ..set Rowid=ErrBill_"O"_PBO
    ..set PBDTotalAmount="小计:"_$fn(tPBDAmt,"",2)
    ..set PBDPatientShare="小计:"_$fn(tPBDSelfAmt,"",2)
    ..set (OPatName,ORegNo)=""
    ..set arcim=$p(PBOData,"^",3)
    ..set ArcItmDesc=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)
    ..set PBAmount="医嘱名称："
    ..set PBPatientShare=ArcItmDesc
    ..d QueryBillBalance
    .//输出PB层
    .s (BillPar,Bill,ShowPBO,ShowPBD,PBOToTalAmount,PBOPatientShare,PBDTotalAmount,PBDPatientShare)=""
    .set PBOToTalAmount="小计:"_$fn(tPBOAmt,"",2)
    .set PBOPatientShare="小计:"_$fn(tPBOSelfAmt,"",2)
    .set PBAmount=$fn(+$p($g(^DHCPB(ErrBill)),"^",8),"",2) //账单主表 本次计费的总额
    .set PBPatientShare=$fn(+$p($g(^DHCPB(ErrBill)),"^",12),"",2) //账单主表 本次费用病人自付额
    .set Rowid=ErrBill
    .set OPatName=$p(PatInfo,"^",2)
    .set ORegNo=$p(PatInfo,"^",1)
    .d QueryBillBalance
    K ^||CacheTemp("QueryBillBalanceError")
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

QueryBillBalance
    set Data=$lb(Rowid,ErrBill,ShowPBO,ShowPBD,PBAmount,PBPatientShare,PBOToTalAmount,PBOPatientShare,PBDTotalAmount,PBDPatientShare,BillPar,ORegNo,OPatName,PBDBillDate)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod ClearData()
{
    &sql(delete from CF_BILL_DC.UnAuditItm)
    &sql(delete from BILL_DC_PO.CheckResult)
    &sql(delete from BILL_DC_PO.CheckResultDet)
}

}
