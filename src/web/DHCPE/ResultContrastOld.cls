Class web.DHCPE.ResultContrastOld Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 197;

/// 查找患者的体检记录(按报告－完成的体检) 
/// d ##class(web.DHCPE.ResultContrast).SearchIReport("10001","","","","^NA^A^P^S^")
ClassMethod SearchIReport(RegNo As %String = "", PatName As %String = "", DateFrom As %String = "", DateTo As %String = "", ReportStatus As %String = "")
{
    k ^TMPResultContrast("IReport")
    if (""=RegNo)&(""=PatName)&(""=DateFrom)&(""=DateTo)&(""=ReportStatus) {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    // ^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
    s PAPMIRowId=""
    s PAPMIRowId=$O(^PAPERi("PAPMI_PatNo",RegNo,PAPMIRowId))
    if (""=PAPMIRowId) {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    
    s ReportStatus="^"_ReportStatus_"^"
    
    s RegNo=+RegNo
    s Ptype=""
    f  s Ptype=$O(^PAPERdr(PAPMIRowId,"ADM",Ptype)) Q:(""=Ptype)  d
    .// PA_ADM
    .s IADMPAADMDR=0
    .f  s IADMPAADMDR=$O(^PAPERdr(PAPMIRowId,"ADM",Ptype,IADMPAADMDR)) Q:(""=IADMPAADMDR)  d
    ..
    ..//DHC_PE_IADM
    ..s IADMDR=0
    ..s IADMDR=$O(^DHCPEIADM(0,"PAADM",IADMPAADMDR,IADMDR))
    ..Q:(""=IADMDR)
    ..
    ..//DHC_PE_Report
    ..s RPTRowId=0
    ..s RPTRowId=$O(^DHCPERPT(0,"IADM",IADMDR,RPTRowId))
    ..
    ..s CurData=$g(^DHCPERPT(RPTRowId)) 
    ..//IADM_RegDate    DHC_PE_IADM 登记日期
    ..s RegDate=$p($g(^DHCPEIADM(IADMDR)),"^",5)
    ..//b //w  RegDate_";"_DateFrom_";"_DateTo
    ..q:(""'=DateFrom)&(RegDate<DateFrom)
    ..q:(""'=DateTo)&(RegDate>DateTo)
    ..i ""'=RegDate s RegDate=##class(websys.Conversions).DateLogicalToHtml(RegDate)
    ..
    ..//RPT_Status
    ..s Status="^"_$p(CurData,"^",2)_"^"                //报告状态
    ..//b // w ReportStatus_"  "_Status
    ..q:(""'=ReportStatus)&('(ReportStatus[Status))
    ..// 输出 按登记日期排序
    ..s ^TMPResultContrast("IReport","RegDate",RegDate)=IADMPAADMDR_"^"_IADMDR_"^"_RPTRowId
    ..// 输出 按ADM号
    ..s ^TMPResultContrast("IReport","ADM",IADMPAADMDR)=IADMPAADMDR_"^"_IADMDR_"^"_RPTRowId_"^"_RegDate
    ..
}

/// 获取患者的莫项目(医嘱项目)d的体检结果    DHC_PE_Result
/// d ##Class(web.DHCPE.ResultContrast).GetResult(9642)
ClassMethod GetPatientResult(PAAdmRowid As %String = "", ARCIM As %String = "")
{
    
    k ^TMPResultContrast("Result")

    s RLTRowid="" 
    s Delimit="^"
    
    f  s RLTRowid=$o(^DHCPERLT(0,"ADM",PAAdmRowid,RLTRowid)) q:RLTRowid=""  d
    .s RLTOEORIDR=$p(^DHCPERLT(RLTRowid),"^",9)
    .//RLT_ARCIM_DR 医嘱项目
    .s OEORDRowId=$P(RLTOEORIDR,"||",1) // OE_Order.OEORD_RowId
    .s OEORIChildsub=$P(RLTOEORIDR,"||",2) // OE_Order.OEORI_Childsub
    .s ARCIMDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
    .Q:(""'=ARCIM)&(ARCIM'=ARCIMDR)
    .s ARCIMSubScript=$p(ARCIMDR,"||",1)    //ARCIM_Desc 医嘱名称 Arc_ItmMast
    .s ARCIMVersion=$p(ARCIMDR,"||",2)
    .s ARCIMCode=$p($g(^ARCIM(ARCIMSubScript,ARCIMVersion,1)),"^",1)
    .s ARCIMDesc=$p($g(^ARCIM(ARCIMSubScript,ARCIMVersion,1)),"^",2)
    .//RLT_OD_DR    细项
    .s ODRowId=$p(^DHCPERLT(RLTRowid),"^",3)     
    .s STRowId=$p(ODRowId,"||",1)           //站点编码
    .s ODChildSub=$p(ODRowId,"||",2)        //项目编码
    .q:ODChildSub=""         //wangbigan
    .s ODDesc=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",1)   //细项名称
    .q:ODDesc=""    
    .// 参考范围
    .s Standard=..GetStandard(STRowId,ODChildSub)
    .// 单位 OD_Unit
    .s ODUnit=$p($G(^DHCPEST(STRowId,"OD",ODChildSub)),"^",4)
    .if (""'=ODUnit) s ODUnit=$p($g(^CT(ODUnit)),"^",2) //CT_UOM
    .
    .// 检验结果
    .s RLTResult=$p(^DHCPERLT(RLTRowid),"^",4)
    .
    .//RLT_User_DR  检查医师
    .s RLTUser=$p(^DHCPERLT(RLTRowid),"^",5)
    .i (""'=RLTUser) d
    ..s RLTUser=$p($g(^SSU("SSUSR",RLTUser)),"^",2) //检查医师名称    SS_User
    .
    .//检验日期
    .s RLTUpdateDate=$p(^DHCPERLT(RLTRowid),"^",6)
    .i (""'=RLTUpdateDate) d
    ..s RLTUpdateDate=##class(websys.Conversions).DateLogicalToHtml(RLTUpdateDate)
    .
    .//是否正常
    .s RLTNormal=$p(^DHCPERLT(RLTRowid),"^",7)
    .
    .s:(""=RLTNormal) RLTNormal=1
    .//s:(1=+RLTNormal) RLTNormal="正常"
    .//s:(0=+RLTNormal) RLTNormal="异常"
    .
    .s RLTAdvice=$p(^DHCPERLT(RLTRowid),"^",8)
    .
    .// 输出 按项目名称排序
    .s ^TMPResultContrast("Result","Desc",PAAdmRowid,ARCIMDesc)=RLTUser_Delimit_RLTUpdateDate
    .s ^TMPResultContrast("Result","Desc",PAAdmRowid,ARCIMDesc,ODDesc)=RLTResult_Delimit_Standard_Delimit_ODUnit_Delimit_Delimit_RLTNormal_Delimit_RLTAdvice
    .
    .// 输出 按项目编码排序
    .//                                         医嘱项目名称          检验人             检验日期
    .s ^TMPResultContrast("Result","ID",PAAdmRowid,ARCIMDR)=ARCIMDesc_Delimit_RLTUser_Delimit_RLTUpdateDate
    .//                                                 子项名称            检验结果            参考范围            结果单位                是否正常            建议      
    .s ^TMPResultContrast("Result","ID",PAAdmRowid,ARCIMDR,ODRowId)=ODDesc_Delimit_RLTResult_Delimit_Standard_Delimit_ODUnit_Delimit_RLTNormal_Delimit_RLTAdvice
}

/// 获取患者的历史检验结果，比对检验数据
/// d ##class(web.DHCPE.ResultContrast).GetPatResultHistory("00060208","8569||5","","60598")
ClassMethod GetPatResultHistory(RegNo As %String = "", ARCIM As %String = "", DateFrom As %String = "", DateTo As %String = "")
{
    k ^TMPResultContrast("ResultHistory")
    Q:(""=RegNo)||(""=ARCIM) 0
    s PatName=""
    s ReportStatus="^C^NA^A^P^S^" //测试阶段，选择查询全部地数据
    //s ReportStatus="^C^A^P^S^" //测试阶段，选择查询全部地数据
    // 查询患者地检验记录
    d ..SearchIReport(RegNo, PatName, DateFrom, DateTo, ReportStatus)
    
    b // GetPatResultHistory
    
    s PAADMdr=""
    f  s PAADMdr=$O(^TMPResultContrast("IReport","ADM",PAADMdr),-1) Q:(""=PAADMdr)  d
    .d ..GetPatientResult(PAADMdr,ARCIM)
    .s RegDate=$P($G(^TMPResultContrast("IReport","ADM",PAADMdr)),"^",4)
    .
    .
    .s ARCIMdr="0" 
    .f  s ARCIMdr=$O(^TMPResultContrast("Result","ID",PAADMdr,ARCIMdr)) Q:(""=ARCIMdr)  d
    ..s ODDr="0"
    ..f  s ODDr=$O(^TMPResultContrast("Result","ID",PAADMdr,ARCIMdr,ODDr)) Q:(""=ODDr)  d
    ...s CurData=$G(^TMPResultContrast("Result","ID",PAADMdr,ARCIMdr,ODDr))
    ...
    ...// 输出 患者的检验项目
    ...s ^TMPResultContrast("ResultHistory", "ODDesc", ODDr)=$P(CurData,"^",1)
    ...
    ...// 输出 体检日期
    ...s ^TMPResultContrast("ResultHistory", "RegDate", RegDate)=RegDate
    ...
    ...// 检验项目在某次体检的结果
    ...s ^TMPResultContrast("ResultHistory", "Result", ODDr,  RegDate)=$P(CurData,"^",2)_"^"_$P(CurData,"^",5)
    ...
    ...
    ...
    Q 1
}

/// 将患者的历史体检数据输出到HTML中
/// d ##class(web.DHCPE.ResultContrast).OutPatResultHistoryToHTML("10001","","","","^NA^A^P^S^")
/// d ##class(web.DHCPE.ResultContrast).OutPatResultHistoryToHTML("","","","")
ClassMethod OutPatResultHistoryToHTML(RegNo As %String = "", ARCIM As %String = "", DateFrom As %String = "", DateTo As %String = "")
{
    
    k ^TMPResultContrast
    d ..GetPatResultHistory(RegNo, ARCIM, DateFrom, DateTo)
    w "<button id='export' class='hisui-linkbutton' plain=true iconCls='icon-export'>导出</button>"
    w "<table id=""tPatResultHistory"" Name=""tPatResultHistory"" width='100%'>",!
    
    // 表格第一行 输出体检登记日期
    w "<THEAD>",!
    w "<TH>项目/登记日期</TH>",!
    s RegDate=""
    f  s RegDate=$O(^TMPResultContrast("ResultHistory", "RegDate",RegDate),-1) Q:(""=RegDate)  d
    .w "<TH NOWRAP>"_RegDate_"</TH>",!
    w "</THEAD>",!
    
    s RegDate=""
    s ODdr=""
    f  s ODdr=$O(^TMPResultContrast("ResultHistory", "ODDesc", ODdr)) Q:(""=ODdr)  d
    .s CurData=$G(^TMPResultContrast("ResultHistory", "ODDesc", ODdr))
    .
    .w "<tr>",!
    .
    .// 表格第一列 输入检验项目
    .w "<td>"_CurData_"</td>",!
    .
    .s Result=""
    .s RegDate=0
    .f  s RegDate=$O(^TMPResultContrast("ResultHistory", "Result", ODdr, RegDate)) Q:(""=RegDate)  d
    ..s CurData=$g(^TMPResultContrast("ResultHistory", "Result", ODdr, RegDate))
    ..s Result=$P(CurData,"^",1)
    ..s Normal=+$P(CurData,"^",2)
    ..i 0=Normal d
    ...w "<td>"_Result_"</td>",!
    ..e  d
    ...w "<td>"_Result_"</td>",!
    .w "</tr>",!
    .
    w "</table>",!
}

/// d ##Class(web.DHCPE.ResultContrast).OueTestListToWeb("10001")
ClassMethod OueTestListToWeb(RegNo As %String = "")
{
    s PatName=""
    s DateFrom=""
    s DateTo=""
    s ReportStatus="^NA^A^P^S^"
    d ..SearchIReport(RegNo, PatName, DateFrom, DateTo, ReportStatus)
    
    k ^TMPResultContrast("ResultHistory")
    s id=0
    f  s id=$O(^TMPResultContrast("IReport","ADM",id)) Q:(""=id)  d
    .d ..GetPatientResult(id,ARCIM)
    .
}

/// d ##Class(web.DHCPE.ResultContrast).OutResultToWeb()
/// 输出检验检查结果到网页
ClassMethod OutResultToWeb()
{
    
    w "<xml id=xmlReport>",!
    w "<ReportList>"
    
    s ARCIM=""
    f  s ARCIM=$O(^TMPResultContrast("Result",ARCIM)) Q:(""=ARCIM)  d
    .s CurData=$G(^TMPResultContrast("Result",ARCIM))
    .
    .w "<Report>",!
    .w "<ARCIMDesc>"_ARCIM_"</ARCIMDesc>",!
    .w "<Checker>"_$P(CurData,"^",1)_"</Checker>",!
    .w "<TestDate>"_$P(CurData,"^",2)_"</TestDate>",!
    .
    .w "<Result>",!
    .
    .s OD=""
    .f  s OD=$O(^TMPResultContrast("Result",ARCIM,OD)) Q:(""=OD)  d
    ..s CurData=$g(^TMPResultContrasts("Result",ARCIM,OD))
    ..w " <Value>",!
    ..w "  <TestName>"_OD_"</TestName>",!
    ..w "  <TestValue>"_$P(CurData,"^",1)_"</TestValue>",!
    ..w "  <Standard>"_$P(CurData,"^",2)_"</Standard>",!
    ..w "  <TestUnit>"_$P(CurData,"^",3)_"</TestUnit>",!
    ..w "  <Normal>"_$P(CurData,"^",4)_"</Normal>",!
    ..w "  <Advice>"_$P(CurData,"^",5)_"</Advice>",!
    ..w " </Value>",!
    .
    .w " </Result>",!
    .
    .
    .
    .w "</Report>",!
    w "</ReportList>",!
    w "</xml>",!
}

ClassMethod QueryResult(PatientId As %String)
{
    
    k ^xwmTest("GeneralAdvice") 

    s IADMRowId=""
    s IADMRowId=$O(^DHCPEIADM(0,"PAADM",PAAdmRowid,IADMRowId))
    q:(""=IADMRowId) 0
     
    s RowId=""
    f  s RowId=$o(^DHCPEGA(0,"IADM",IADMRowId,RowId)) q:RowId=""  d
    .
    .//GA_AduitUser_DR
    .s AduitUser=$p(^DHCPEGA(RowId,1),"^",3)    //审核人
    .i (""'=AduitUser) s AduitUser=$p($g(^SSU("SSUSR",AduitUser)),"^",2)    //检查医师名称    SS_User
    .s ^xwmTest("GeneralAdvice","AduitUser")=AduitUser
    .
    .//GA_AduitDate
    .s AduitDate=$p(^DHCPEGA(RowId,1),"^",2)    //审核日期
    .i (""'=AduitDate) s AduitDate=$ZD(AduitDate,3)
    .s ^xwmTest("GeneralAdvice","AduitDate")=AduitDate
    .
    .//
    .s Advice=$G(^DHCPEGA(RowId,"A"))   //建议
    .s ^xwmTest("GeneralAdvice","Advice")=Advice
    q 1
}

/// 获取参考范围 DHC_PE_ODStandard
ClassMethod GetStandard(STRowId, ODChildSub)
{
    s RowId=""  
    s Rangs=""
    f  s RowId=$o(^DHCPEST(STRowId,"OD",ODChildSub,"ODS",RowId)) q:RowId=""  d
    .s CurData=$g(^DHCPEST(STRowId,"OD",ODChildSub,"ODS",RowId))
    .s ODSNatureValue=$P(CurData,"^",6)
    .q:("Y"'=ODSNatureValue)
    .//ODS_Min,ODS_Max
    .s Rangs=$P(CurData,"^",4)_"-"_$P(CurData,"^",5)
    if ("-"=Rangs)  s Rangs=""
    q Rangs
}

/// d ##Class(web.DHCPE.ReportOutToWeb).OutSummarizeToWeb()
ClassMethod OutSummarizeToWeb()
{
    w "<xml id=xmlSummarize>",!
    w " <SummarizeList>",!
    
    s id=""
    f  s id=$O(^xwmTest("Summarize",id)) Q:(""=id)  d
    .w " <Summarize>",!
    .w "  <Station>"_id_"</Station>",!
    .w "  <Desc>"_"<![CDATA["_$G(^xwmTest("Summarize",id))_"]]>"_"</Desc>",!
    .w "  <AduitUser>"_$G(^xwmTest("Summarize",id,"AduitUser"))_"</AduitUser>",!
    .w "  <AduitDate>"_$G(^xwmTest("Summarize",id,"AduitDate"))_"</AduitDate>",!
    .w " </Summarize>",!
    
    w " </SummarizeList>",!
    w "</xml>",!
}

/// 科室小结
/// d ##Class(web.DHCPE.ReportOutToWeb).GetSummarize(9642)
ClassMethod GetSummarize(PAAdmRowid)
{
    
    //站点（科室）小结 DHC_PE_StationSummarize （所有阳性体症）
    k ^xwmTest("Summarize") 

    s Delimit="^"
    s IADMRowId=""
    s IADMRowId=$O(^DHCPEIADM(0,"PAADM",PAAdmRowid,IADMRowId))
    q:(""=IADMRowId) 0
    
    s SRowId="" //科室编码
    s RowId=""  //小结编码  
    f  s SRowId=$o(^DHCPESS(0,"IADM",IADMRowId,SRowId)) q:SRowId=""  d
    .s SDesc=$p($G(^DHCPEST(SRowId)),"^",2) //站点名称
    .
    .f  s RowId=$o(^DHCPESS(0,"IADM",IADMRowId,SRowId,RowId)) q:RowId=""  d
    ..//GA_AduitUser_DR
    ..s AduitUser=$p(^DHCPESS(RowId,1),"^",4)   //审核人
    ..i (""'=AduitUser) s AduitUser=$p($g(^SSU("SSUSR",AduitUser)),"^",2)   //检查医师名称    SS_User
    ..
    ..//GA_AduitDate
    ..s AduitDate=$p(^DHCPESS(RowId,1),"^",3)   //审核日期
    ..i (""'=AduitDate) s AduitDate=$ZD(AduitDate,3)
    ..
    ..s ^xwmTest("Summarize", SDesc)=$p(^DHCPESS(RowId,"S"),"^",5)
    ..s ^xwmTest("Summarize", SDesc, "AduitUser")=AduitUser
    ..s ^xwmTest("Summarize", SDesc, "AduitDate")=AduitDate
    ..
    
    Q 1
}

/// d ##Class(web.DHCPE.ReportOutToWeb).OutGeneralAdviceToWeb()
ClassMethod OutGeneralAdviceToWeb()
{
    w "<xml id=xmlGeneralAdvice>",!
    w " <GeneralAdvice>",!
    
    w "  <AduitUser>"_$G(^xwmTest("GeneralAdvice", "AduitUser"))_"AduitUser",!
    w "  <AduitDate>"_$G(^xwmTest("GeneralAdvice", "AduitDate"))_"</AduitDate>",!
    w "  <Advice>"_"<![CDATA["_$G(^xwmTest("GeneralAdvice", "Advice"))_"]]>"_"</Advice>",!
    
    w " </GeneralAdvice>",!
    w "</xml>",!
}

/// 总检建议 DHC_PE_GeneralAdvice ^DHCPEGA
/// d ##Class(web.DHCPE.ReportOutToWeb).GetGeneralAdvice(9642)
ClassMethod GetGeneralAdvice(PAAdmRowid)
{
    k ^xwmTest("GeneralAdvice") 

    s IADMRowId=""
    s IADMRowId=$O(^DHCPEIADM(0,"PAADM",PAAdmRowid,IADMRowId))
    q:(""=IADMRowId) 0
     
    s RowId=""
    f  s RowId=$o(^DHCPEGA(0,"IADM",IADMRowId,RowId)) q:RowId=""  d
    .
    .//GA_AduitUser_DR
    .s AduitUser=$p(^DHCPEGA(RowId,1),"^",3)    //审核人
    .i (""'=AduitUser) s AduitUser=$p($g(^SSU("SSUSR",AduitUser)),"^",2)    //检查医师名称    SS_User
    .s ^xwmTest("GeneralAdvice","AduitUser")=AduitUser
    .
    .//GA_AduitDate
    .s AduitDate=$p(^DHCPEGA(RowId,1),"^",2)    //审核日期
    .i (""'=AduitDate) s AduitDate=$ZD(AduitDate,3)
    .s ^xwmTest("GeneralAdvice","AduitDate")=AduitDate
    .
    .//
    .s Advice=$G(^DHCPEGA(RowId,"A"))   //建议
    .s ^xwmTest("GeneralAdvice","Advice")=Advice
    q 1
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.ResultContrast","ContrastWithLast","992")

Query ContrastWithLast(PAADM As %Library.String = "") As %Query(ROWSPEC = "TARCIMItem:%String, TLastTime:%String, TCurrentTime:%String")
{
}

ClassMethod ContrastWithLastExecute(ByRef qHandle As %Binary, PAADM As %Library.String = "") As %Status
{


    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    k ^DHCPETMPContrast
    k ^DHCPETMPNormalFlag
    s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
    Q:(""=PAADM) $$$OK
    s PAPMIDR=$p(^PAADM(PAADM),"^",1)
    S Num=0
    s PAADMRowID=""
    f  s PAADMRowID=$o(^PAPERdr(PAPMIDR,"ADM","H",PAADMRowID),-1)  Q:((PAADMRowID="")||(PAADMRowID=0)||(Num>=2))  d
    .q:(PAADMRowID>PAADM)
    .s IADM=0
    .s IADM=$O(^DHCPEIADM(0,"PAADM",PAADMRowID,0))
    .Q:IADM=""
    .s IADMStatus=$p(^DHCPEIADM(IADM),"^",8)
    .q:((IADMStatus'="ARRIVED")&&(IADMStatus'="REGISTERED"))
    .s IADMDate=$zd($p(^DHCPEIADM(IADM),"^",5),3)
    .s Num=Num+1
    .s ^DHCPETMPContrast("PAADM",PAADMRowID)=IADMDate
    .s ^DHCPETMPContrast("IADMDate")=$g(^DHCPETMPContrast("IADMDate"))_"^"_IADMDate
    .s ^DHCPETMPContrast("IADM",IADM)=IADMDate
    
    s AdmId="",num=0
    f  s AdmId=$o(^DHCPETMPContrast("PAADM",AdmId),-1)  q:(AdmId="")||(AdmId=0)  d
    .s num=num+1
    .s RLTRowid=0
    .f  s RLTRowid=$o(^DHCPERLT(0,"ADM",AdmId,RLTRowid)) q:RLTRowid=""  d
    ..s RLTOEORIDR=$p(^DHCPERLT(RLTRowid),"^",9)
    ..s Normal=$p(^DHCPERLT(RLTRowid),"^",7)
    ..s ARCIMDR=$p(^DHCPERLT(RLTRowid),"^",2)
    ..s STID=0
    ..s STID=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMDR,0))
    ..s OEORDRowId=$P(RLTOEORIDR,"||",1) 
    ..s OEORIChildsub=$P(RLTOEORIDR,"||",2)
    ..s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
    ..q:OEORIItemStatDR=4
    ..s ODDR=$p(^DHCPERLT(RLTRowid),"^",3)
    ..Q:ODDR=""
    ..s ODDesc=$p($g(^DHCPEST($p(ODDR,"||",1),"OD",$p(ODDR,"||",2))),"^",1)
    ..s RLTResult=$p(^DHCPERLT(RLTRowid),"^",4)
    ..s RLTTeplete=$p(^DHCPERLT(RLTRowid),"^",10)
    ..i '$d(^DHCPETMPNormalFlag(STID,ARCIMDR,num)) s ^DHCPETMPNormalFlag(STID,ARCIMDR,num)="N"
    ..i Normal="0"  d
    ...s ^DHCPETMPNormalFlag(STID,ARCIMDR,num)="Y"
    ...i ("^"_RisStation_"^")[("^"_STID_"^")  d
    ....s Str="诊断意见:"_$p(RLTResult,";诊断意见:",2)
    ...else  s Str=ODDesc_"("_RLTResult_"  "_RLTTeplete_")"
    ...s ^DHCPETMPContrast("ARCIM",STID,ARCIMDR,num)=$g(^DHCPETMPContrast("ARCIM",STID,ARCIMDR,num))_"  "_Str
    
    
    
    s STID=0
    f  s STID=$o(^DHCPETMPNormalFlag(STID))  q:STID=""  d
    .s ARCIMDR=0
    .f  s ARCIMDR=$o(^DHCPETMPNormalFlag(STID,ARCIMDR)) q:ARCIMDR=""  d
    ..s num=0
    ..f  s num=$o(^DHCPETMPNormalFlag(STID,ARCIMDR,num))  q:num=""  d
    ...i ^DHCPETMPNormalFlag(STID,ARCIMDR,num)="N"  s ^DHCPETMPContrast("ARCIM",STID,ARCIMDR,num)="未见异常"
    
    s IADM="",num=0
    f  s IADM=$o(^DHCPETMPContrast("IADM",IADM),-1)  q:(IADM="")||(IADM=0)  d
    .s GSRowId=0
    .s DiagnoseConclusStr=""
    .f  s GSRowId=$o(^DHCPEGS(0,"IADM",IADM,GSRowId))  q:GSRowId=""  d
    ..s num=num+1
    ..s GSDChildSub=0
    ..f  s GSDChildSub=$o(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub))  q:GSDChildSub=""  d
    ...s GSDEDDR=$p(^DHCPEGS(GSRowId,"Diagnosis",GSDChildSub),"^",1)
    ...q:GSDEDDR=""
    ...s EDDiagnoseConclus=$p(^DHCPEED(GSDEDDR,1),"^",1)
    ...i DiagnoseConclusStr=""  s DiagnoseConclusStr=EDDiagnoseConclus
    ...else  s DiagnoseConclusStr=DiagnoseConclusStr_","_EDDiagnoseConclus
    ...s ^DHCPETMPContrast("Diagnose",num)=DiagnoseConclusStr

    
    s DateTitle=$g(^DHCPETMPContrast("IADMDate"))
    s LastResult=$p(DateTitle,"^",3)
    s CurrentResult=$p(DateTitle,"^",2)
    s ARCIMDesc="医嘱"
    d OutOItemStatusForAdm
    
    
    s StationID=0
    f  s StationID=$o(^DHCPETMPContrast("ARCIM",StationID))  q:StationID=""  d
    .s ARCIMDR=0
    .f  s ARCIMDR=$o(^DHCPETMPContrast("ARCIM",StationID,ARCIMDR))  q:ARCIMDR=""  d
    ..s CurrentResult=$g(^DHCPETMPContrast("ARCIM",StationID,ARCIMDR,1))
    ..s LastResult=$g(^DHCPETMPContrast("ARCIM",StationID,ARCIMDR,2))
    ..s ARCIMSubscript=$P(ARCIMDR,"||",1)
    ..s ARCIMVersion=$P(ARCIMDR,"||",2)
    ..q:ARCIMVersion=""
    ..s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,$g(ARCIMVersion),1)),"^",2)
    ..d OutOItemStatusForAdm
    

    
    
    s ARCIMDesc="诊断"
    s CurrentResult=$g(^DHCPETMPContrast("Diagnose",1)) 
    s LastResult=$g(^DHCPETMPContrast("Diagnose",2)) 
    d OutOItemStatusForAdm
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutOItemStatusForAdm
               //TOEORIRowId, TOEORIItmMastDR, TItemName, TSpecNo,TSpecName,TDate,TTime,TUserName,TOSTATDesc)
    set Data=$lb(ARCIMDesc,LastResult, CurrentResult)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod ContrastWithLastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ContrastWithLastExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod ContrastWithLastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ContrastWithLastExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 将患者的历史体检数据输出到HTML中
/// d ##class(web.DHCPE.ResultContrastOld).OutPatResultHistoryToHTMLNew("","","","")
ClassMethod OutPatResultHistoryToHTMLNew(RegNo As %String = "", ARCIM As %String = "", DateFrom As %String = "", DateTo As %String = "")
{
    k ^TMPResultContrast
    d ..GetPatResultHistory(RegNo, ARCIM, DateFrom, DateTo)
    
    w "<table class=tblList cellspacing='0' cellpadding='0' style='white-space:normal; word-break:break-all;' id=""tPatResultHistory"" Name=""tPatResultHistory"" width='100%'>",!
    w "<TR class='panel-header-gray' height=34px border=0><td width=80px style='border-radius:4px 0px 0px 0px;border-right:1px solid #ccc;border-left:0px solid #ccc;padding:0px 0px 0px 10px;color:#000000;'>"_##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepatresulthistory.old.csp","医嘱名称")_"</td>"
    s ADMNum=0
    s RegDate=""
    f  s RegDate=$O(^TMPResultContrast("ResultHistory", "RegDate",RegDate)) Q:(""=RegDate)  d
    .s ADMNum=ADMNum+1
    .s ^TMPResultContrast("RegDate",ADMNum)=RegDate
    f i=1:1:ADMNum  d
    .i i=ADMNum d
    ..w "<td style='border-right:0px solid #ccc;padding:0px 0px 0px 10px;color:#000000;'>"_$g(^TMPResultContrast("RegDate",i))_"</td>"
    .e  d
    ..w "<td style='border-right:1px solid #ccc;padding:0px 0px 0px 10px;color:#000000;'>"_$g(^TMPResultContrast("RegDate",i))_"</td>"
    w "</tr>",!
    
    
    s RegDate=""
    s ODdr=""
    f  s ODdr=$O(^TMPResultContrast("ResultHistory", "ODDesc", ODdr)) Q:(""=ODdr)  d
    .s CurData=$G(^TMPResultContrast("ResultHistory", "ODDesc", ODdr))
    .
    .w "<tr height=34px>",!
    .
    .// 表格第一列 输入检验项目
    .w "<td style='padding:0px 0px 0px 10px;border-right:1px solid #ccc;'>"_CurData_"</td>",!
    .
    .s Result=""
    .s RegDate=0
    .f  s RegDate=$O(^TMPResultContrast("ResultHistory", "Result", ODdr, RegDate)) Q:(""=RegDate)  d
    ..s CurData=$g(^TMPResultContrast("ResultHistory", "Result", ODdr, RegDate))
    ..s Result=$P(CurData,"^",1)
    ..s Normal=+$P(CurData,"^",2)
    ..i 0=Normal d
    ...w "<td style='padding:0px 0px 0px 10px;border-right:1px solid #ccc;'>"_Result_"</td>",!
    ..e  d
    ...w "<td style='padding:0px 0px 0px 10px;border-right:1px solid #ccc;'>"_Result_"</td>",!
    .w "</tr>",!
    .
    w "</table>",!
}

}
