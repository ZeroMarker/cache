Import sqluser

/// Creator：      hwq
/// CreatDate：    2011-07-01
/// Description:   收费项审批功能 61736^61746(公费、保健专用)
/// d ##class(%ResultSet).RunQuery("web.DHCINSUAuditLocal","LocalAuditApp","0000042912","78087","13","SDA")
/// 登记号 开始 结束日期 标志  RegNo, StartDate, EndDate, CheckAuditType,
/// 项目名称 代码 诊断 日期 时间 金额 数量 单价 比例  审核标志 审核日期
Class web.DHCINSUAuditLocal Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod LocalAuditAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocalAuditAppExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod LocalAuditAppExecute(ByRef qHandle As %Binary, RegNo As %String, AdmDr As %String, AdmReaDr As %String, AuditCheck) As %Status
{

	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s ^HH(1010)=RegNo_"^"_AdmDr_"^"_AdmReaDr_"^"_AuditCheck
	k ^CacheTemp("TmpAudit")
	k ^CacheTemp("InsuTar")
	q:RegNo="" $$$OK
	s i=1
	s TotSelf=0,SumAmount=0,TotFund=0
	s TabTotSelf="",TabTotFund="",TabTotFund="",TabSumAmount=""
	s OEORDDr="",ZFBLreal="",NewZFBL=""
	f  s OEORDDr=$o(^OEORD(0,"Adm",AdmDr,OEORDDr)) q:OEORDDr=""  d
	.s OEORIDr=""
	.f  s OEORIDr=$o(^OEORD(OEORDDr,"I",OEORIDr)) q:OEORIDr=""  d
	..s (TabPrescNo,TabOEORIDate,TabOEORITimeOrd,TabOEORIDoctorDesc,TabPrescPrice,TabOEORIPhQty,TaTotalAmount,TabArcimDesc,TabPhcfrCode,TabDoseQtyUnit,TabPhOrdQtyUnit,TabPackNum,TabAuditFlag,TabOEORIRowId)=""
	..s (AuditUserDr,AuditUserName,AuditDate,AuditTime,TAuditDate,TAuditTime)=""
	..s (FundPay,Self)=""
	..s OEORIRowId=OEORDDr_"||"_OEORIDr
	..s TabOEORIRowId=OEORIRowId										;19找明细用的医嘱明细表rowid
	..s AdmReaCode=$P($g(^PAC("ADMREA",AdmReaDr)),"^",1)
	..s DHCORIDr=""
	..s TabPrescNo=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",14)		;6处方号
	..s TabOEORIDate=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",7)		;7开医嘱日期
	..s TabOEORITimeOrd=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",17)		;8开医嘱时间
	..s TabOEORIDate=$zd(TabOEORIDate,3)
	..s TabOEORITimeOrd=$zt(TabOEORITimeOrd,1)
	..s TabOEORIDoctorDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",11)
	..s OEORIState=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",13)	  ;医嘱状态 1核实  4停止
	..i TabOEORIDoctorDR="" d
	...s TabOEORIDoctorDesc=""
	..e  d
	...s TabOEORIDoctorDesc=$p($g(^CTPCP(TabOEORIDoctorDR,1)),"^",2)		;9开医嘱医生
	..s OEORIPhQtyOrd=##Class(web.DHCCLCom).GetOrderBaseQty(OEORIRowId)		
	..s TabOEORIPhQty=OEORIPhQtyOrd										;11医嘱数量
  	..s StBillQty=TabOEORIPhQty
	..s ItmMastDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",2)				
	..i ItmMastDR="" d
	...s TabPrescPrice=""
	..e  d
	...s TabPrescPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("","",ItmMastDR,+$h,"","","",""),"^",4)	
	...;s TabPrescPrice=$fn(TabPrescPrice,"",2)								;10医嘱单位价格	
	...s TaTotalAmount=$fn(TabPrescPrice*OEORIPhQtyOrd,"",2)				;12医嘱总价  
	...s TabArcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)	;13医嘱名称
	...s phcfrId=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",4)			
	...;q:phcfrId=""
	...;s TabPhcfrCode=$p($g(^PHCFR(phcfrId)),"^",3) 							;14医嘱频次                                                              	
   	...s doseQty=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",1)                           
	...i doseQty'="" s unitUomId=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",3)  
  	...i $g(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)		            
	...s TabDoseQtyUnit=$g(doseQty)_" "_$g(unitDesc)							;15剂量
	...s phOrdQty=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",12)                         
	...s TabPhOrdQtyUnit=phOrdQty_" "_$g(unitDesc)							;16总量																		;5单价        
  	...s TabPackNum=##Class(web.DHCNurDrugAudit).GetPackQty(OEORDDr,OEORIDr)	;17整包数量
  	...s DrugFlag=$$GetDrugFlagBy^DHCINSUFacade(arcimId)   ;add hwq 2010 12 13
  	...q:(OEORIState="4")  ;停止医嘱退出
	...s tardr=""
	...q:$d(^DHCOLT(0,"ARTTA",arcimId))=0 	  ;DHC_OrderLinkTar 
	...f  s tardr=$o(^DHCOLT(0,"ARTTA",arcimId,tardr))  q:tardr=""  d
	....s OLTStDate=""
	....f  s OLTStDate=$o(^DHCOLT(0,"ARTTA",arcimId,tardr,OLTStDate))  q:OLTStDate=""  d  ;add hwq 判断医嘱对应的收费项是否停止
	.....s DHCOLTDr=""
	.....f  s DHCOLTDr=$o(^DHCOLT(0,"ARTTA",arcimId,tardr,OLTStDate,DHCOLTDr))  q:DHCOLTDr=""  d
	......s OLTEndDate=$p(^DHCOLT(DHCOLTDr),"^",5)
	......s ToDate=$p($h,",",1)
	......q:(OLTEndDate'="")&&(OLTEndDate<ToDate)  ;添加医嘱停止
	......s OLTQty=$p(^DHCOLT(DHCOLTDr),"^",3)
	......s BillQty=StBillQty*OLTQty
	......s TarInfo=$g(^DHCTARI(tardr))
	......s AuditFlag=$p($g(^TempInsu("Audit",AdmDr,OEORIRowId,tardr)),"^",3)	
	......q:(AuditCheck="")&&(AuditFlag'="")
	......q:(AuditCheck'="")&&(AuditFlag="")
	......s TAuditFlag=""
	......s:AuditFlag="Y" TAuditFlag="审核通过"
	......s:AuditFlag="N" TAuditFlag="审核未通过"
	......s AuditUserDr=$p($g(^TempInsu("Audit",AdmDr,OEORIRowId,tardr)),"^",4)
	......i AuditUserDr'="" d
	.......s AuditUserName=$p($g(^SSU("SSUSR",AuditUserDr)),"^",2)
	.......s AuditDate=$p(^TempInsu("Audit",AdmDr,OEORIRowId,tardr),"^",5)
	.......s TAuditDate=$zd(AuditDate,3)
	.......s AuditTime=$p(^TempInsu("Audit",AdmDr,OEORIRowId,tardr),"^",6)
	.......s TAuditTime=$zt(AuditTime,1)
	.......s NewZFBL=$p(^TempInsu("Audit",AdmDr,OEORIRowId,tardr),"^",2)
	......s ChangFlag=$p($g(^TempInsu("Audit",AdmDr,OEORIRowId,tardr)),"^",7)
	......s TarCode=$p(TarInfo,"^",1)
	......s TarDesc=$p(TarInfo,"^",2)
	......s UnitPrice=$p(##class(web.UDHCJFPRICE).GetItmPrice(tardr,$h,"","",""),"^",1)
	......s UnitPrice=$fn(UnitPrice,"",4)
	......s TotalAmount=$fn(BillQty*UnitPrice,"",2)
	......s InsuType=$p(##class(web.INSUDicDataCom).QueryByCode("AdmReasonDrToDLLType",AdmReaDr),"^",6)  ;通过AdmReasonDr判断目录类别
	......s PBDTARIInfo=$$GetPBDTARIByTARIDr^DHCINSUFacade(tardr,arcimId,InsuType,TabOEORIDate,OEORDDr)   
	......s TarCate=$p(PBDTARIInfo,"^",7)
	......s ZFBL=$p(PBDTARIInfo,"^",72)
	......s:(NewZFBL'="") ZFBL=NewZFBL
	......s:(ZFBL="") ZFBL="100"
 	......s ZFBLreal=ZFBL*0.01
 	......s Self=TotalAmount*ZFBLreal
	......s FundPay=TotalAmount-Self
	......s:(ZFBL'="0") ZFBL=ZFBL_"!"_"0"
	......;                                                                       5                              7                                                   11                                                                   16
	......s TmpStr=TarCode_"^"_TarDesc_"^"_TabOEORIDate_"^"_TabOEORITimeOrd_"^"_TarCate_"^"_TotalAmount_"^"_BillQty_"^"_UnitPrice_"^"_ZFBL_"^"_TAuditFlag_"^"_tardr_"^"_AuditUserName_"^"_TAuditDate_"^"_TAuditTime_"^"_TabOEORIRowId
	......s TmpStr=TmpStr_"^"_FundPay_"^"_Self
	......s ^CacheTemp("TmpAudit",AdmDr,TabOEORIDate,i)=TmpStr
	......s ^TempInsu("Audit",AdmDr,TabOEORIRowId,tardr)=ZFBL_"^"_NewZFBL_"^"_AuditFlag_"^"_AuditUserDr_"^"_AuditDate_"^"_AuditTime_"^"_ChangFlag
	......s i=i+1  
	
	//从global 按日期、类型取数据
	s OrdDate=""
	s (TarCode,TarDesc,TabOEORIDate,TabOEORITimeOrd,InsuTarCat,TotalAmount,BillQty,UnitPrice,ZFBL,TAuditFlag,PBDTARIDR,TabAuditUserName,TabAuditDate,TabAuditTime,TabOEORIRowId,TabFundPay,TabDWPay,TabSelf,TabScalSelf,TabTotSelf,TabTotScalSelf)=""
	f  s OrdDate=$o(^CacheTemp("TmpAudit",AdmDr,OrdDate))  q:OrdDate=""  d
	.s num=""
	.f  s num=$o(^CacheTemp("TmpAudit",AdmDr,OrdDate,num))  q:num=""  d
	..s TarCode=$p(^CacheTemp("TmpAudit",AdmDr,OrdDate,num),"^",1)
	..s TarDesc=$p(^CacheTemp("TmpAudit",AdmDr,OrdDate,num),"^",2)
	..s TabOEORIDate=$p(^CacheTemp("TmpAudit",AdmDr,OrdDate,num),"^",3)
	..s TabOEORITimeOrd=$p(^CacheTemp("TmpAudit",AdmDr,OrdDate,num),"^",4)
	..s TotalAmount=$p(^CacheTemp("TmpAudit",AdmDr,OrdDate,num),"^",6)
	..s BillQty=$p(^CacheTemp("TmpAudit",AdmDr,OrdDate,num),"^",7)
	..s UnitPrice=$p(^CacheTemp("TmpAudit",AdmDr,OrdDate,num),"^",8)
	..s ZFBL=$p(^CacheTemp("TmpAudit",AdmDr,OrdDate,num),"^",9)
	..s TAuditFlag=$p(^CacheTemp("TmpAudit",AdmDr,OrdDate,num),"^",10)
	..s PBDTARIDR=$p(^CacheTemp("TmpAudit",AdmDr,OrdDate,num),"^",11)
	..s TabAuditUserName=$p(^CacheTemp("TmpAudit",AdmDr,OrdDate,num),"^",12)
	..s TabAuditDate=$p(^CacheTemp("TmpAudit",AdmDr,OrdDate,num),"^",13)
	..s TabAuditTime=$p(^CacheTemp("TmpAudit",AdmDr,OrdDate,num),"^",14)
	..s TabOEORIRowId=$p(^CacheTemp("TmpAudit",AdmDr,OrdDate,num),"^",15)
	..s TabFundPay=$p(^CacheTemp("TmpAudit",AdmDr,OrdDate,num),"^",16)
	..s TabSelf=$p(^CacheTemp("TmpAudit",AdmDr,OrdDate,num),"^",17)
	..s TabTotSelf=TabTotSelf+TabSelf
	..s TabTotFund=TabTotFund+TabFundPay
	..s TabSumAmount=TabSumAmount+TotalAmount
	..DO OutPatPresc
	s TarCode="合计"
	s TabSelf=TabTotSelf 
	s TotalAmount=TabSumAmount		;总金额
	s TabFundPay=TabTotFund
	s (TarDesc,TabOEORIDate,TabOEORITimeOrd,BillQty,UnitPrice,ZFBL,TAuditFlag,PBDTARIDR,TabAuditUserName,TabAuditDate,TabAuditTime,TabOEORIRowId)=""
	s (TabTotSelf,TabSumAmount,TabTotFund)=""
	DO OutPatPresc
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutPatPresc
	set Data=$lb(TarCode,TarDesc,TabOEORIDate,TabOEORITimeOrd,TotalAmount,BillQty,UnitPrice,ZFBL,TAuditFlag,PBDTARIDR,TabAuditUserName,TabAuditDate,TabAuditTime,TabOEORIRowId,TabFundPay,TabSelf)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LocalAuditAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocalAuditAppExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query LocalAuditApp(RegNo, AdmDr, AdmReaDr, AuditCheck) As %Query(ROWSPEC = "TarCode:%String,TarDesc:%String,TabOEORIDate:%String,TabOEORITimeOrd:%String,TotalAmount:%String,BillQty:%String,UnitPrice:%String,ZFBL:%String,TAuditFlag:%String,PBDTARIDR:%String,TabAuditUserName:%String,TabAuditDate:%String,TabAuditTime:%String,TabOEORIRowId:%String,TabFundPay:%String,TabSelf:%String")
{
}

/// 根据登记号，返回病人就诊信息
/// w ##class(web.DHCINSUAuditLocal).GetAdmInfo("0000008831")
ClassMethod GetAdmInfo(RegNo As %String) As %String
{
	s PapmiDr=""
	s OutStr=""
	s PapmiDr=$o(^PAPERi("PAPMI_PatNo",RegNo,PapmiDr)) 
	s PaadmType=""
	f  s PaadmType=$o(^PAPERdr(PapmiDr,"ADM",PaadmType)) q:PaadmType=""  d
	.;q:PaadmType="I"			;判断住院 or 门诊
	.s Name=$p(^PAPER(PapmiDr,"ALL"),"^",1)
	.s Name3=$p(^PAPER(PapmiDr,"ALL"),"^",19)  ;即InsuNo
	.s PaadmDr=""
	.f  s PaadmDr=$o(^PAPERdr(PapmiDr,"ADM",PaadmType,PaadmDr),-1) q:PaadmDr=""  d
	..s (visitstatus,Type,TabPatType,admReasonDr,AdmReaDesc,DiagDesc)=""
	..s PaadmInfo=$g(^PAADM(PaadmDr))
	..q:PaadmInfo="" 
	..s visitstatus=$p($g(^PAADM(PaadmDr)),"^",20)  ;就诊状态 如等待，到达
	..q:(visitstatus="")||(visitstatus="C") 
	..s Type=$p($g(^PAADM(PaadmDr)),"^",2)
	..s admReasonDr=$p($g(^PAPER(PapmiDr,"INSUTRAD")),"^",1)   ;add hwq 2011 09 17 医生站配置建卡是公费病人身份底下的明细费别
	..;s admReasonDr=$P($g(^PAADM(PaadmDr,1)),"^",7)
	..s AdmReaCode=$P($g(^PAC("ADMREA",admReasonDr)),"^",1)
	..s AdmReaDesc=$P($g(^PAC("ADMREA",admReasonDr)),"^",2)
	..s MRADMDR=$p($g(^PAADM(PaadmDr)),"^",61)
	..s DiagDesc=##Class(web.DHCMRDiagnos).GetMRDiagnosDesc(MRADMDR,"|")	;5诊断
	..s OutStr=RegNo_"^"_Name_"^"_admReasonDr_"^"_AdmReaDesc_"^"_DiagDesc_"^"_Name3
	..;i OutStr="" s OutStr=RegNo_"^"_Name_"^"_admReasonDr_"^"_AdmReaDesc_"^"_DiagDesc
	..;e  s OutStr=OutStr_"|"_RegNo_"^"_Name_"^"_admReasonDr_"^"_AdmReaDesc_"^"_DiagDesc
	q OutStr
}

/// 根据登记号查询出病人就诊记录（包括住院、门诊）
/// w ##class(web.DHCINSUAuditLocal).GetPaAdmListByPatNoReg("","","0000055244")
ClassMethod GetPaAdmListByPatNoReg(itmjs As %Library.String = "", itmjsex As %Library.String = "", PapmiNo As %Library.String = "")
{
	q:PapmiNo=""
	s outstr=""
    s PatmasID="0"
    
    q:$d(^PAPERi("PAPMI_PatNo",PapmiNo))=0 outstr
    s PatmasID=$o(^PAPERi("PAPMI_PatNo",PapmiNo,PatmasID))
    s PaadmType=""
    f  s PaadmType=$o(^PAPERdr(PatmasID,"ADM",PaadmType))  q:PaadmType=""  d
    .s PaadmRowID="0"
    .f  s PaadmRowID=$o(^PAPERdr(PatmasID,"ADM",PaadmType,PaadmRowID)) q:PaadmRowID=""  d
    ..s BillFlag=$P(^PAADM(PaadmRowID),"^",45)
    ..q:BillFlag="Y"  d
    ..s DepNameId=$P(^PAADM(PaadmRowID),"^",4)
    ..s outstr=$p($g(^PAADM(PaadmRowID)),"^",81)_"!"_PaadmRowID_"!"_$p(^PAPER(PatmasID,"ALL"),"^",1)_"!"_$p(^CTLOC(DepNameId),"^",2)_"!"_$ZD($p(^PAADM(PaadmRowID),"^",6),3)_"^"_outstr
    s outstr=outstr  ;""_"^"_
    q outstr
}

/// w ##class(web.DHCINSUAuditLocal).ModAuditInfo("0000008831")
/// 医嘱审核，将审核标志存入临时Global
ClassMethod ModAuditInfo(AdmDr As %String, TarOrdStr As %String, State As %String, Guser As %String) As %String
{
	q:TarOrdStr="" 0
	s userId=Guser
	s curDate=$P($H,",",1)
	s curTime=$P($H,",",2)
	s TarRowIdStr=$p(TarOrdStr,"=",1)
	s OrdRowIdStr=$p(TarOrdStr,"=",2)
	s TabZFBL=$p(TarOrdStr,"=",3)
	s len=$L(TarRowIdStr,"^")
	f i=1:1:len d
	.s DHCTarRowId=$P(TarRowIdStr,"^",i)
	.i TabZFBL="" d
	..s ZFBL=""
	.e  d
	..s ZFBL=$P(TabZFBL,"^",i)  ;add hwq 2010 12 14 支付比例
	.s OEORIRowId=$p(OrdRowIdStr,"^",i)	
	.s RealZFBL=$p(^TempInsu("Audit",AdmDr,OEORIRowId,DHCTarRowId),"^",1) ;原来显示比例
	.s OldZFBL=$p(RealZFBL,"!","1")
	.;s ^HH("bl")=OldZFBL_"^"_ZFBL
	.i ZFBL'=OldZFBL  d
	..s $p(^TempInsu("Audit",AdmDr,OEORIRowId,DHCTarRowId),"^",7)="Y"
	.i State="" d
	..s ^TempInsu("Audit",AdmDr,OEORIRowId,DHCTarRowId)=RealZFBL_"^^^^^^"
	.e  d
	..s ^TempInsu("Audit",AdmDr,OEORIRowId,DHCTarRowId)=RealZFBL_"^"_ZFBL_"^"_State_"^"_userId_"^"_curDate_"^"_curTime_"^"_$p(^TempInsu("Audit",AdmDr,OEORIRowId,DHCTarRowId),"^",7)
	q 0
}

}
