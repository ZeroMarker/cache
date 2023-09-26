Import sqluser

/// Creator：      zhangdongliang
/// CreatDate：    2010-06-09
/// Description:   医嘱审批功能 61736^61746
/// d ##class(%ResultSet).RunQuery("web.INSUAudit","OPAuditApp","0000187583","61738","61738","")
Class web.INSUAudit Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query OPAuditApp(RegNo, StartDate, EndDate, CheckAuditType) As %Query(ROWSPEC = "TabRegNo,TabPatName,TabCTDesc,TabPatType,TabDiagDesc,TabPrescNo,TabOEORIDate,TabOEORITimeOrd,TabOEORIDoctorDesc,TabPrescPrice,TabOEORIPhQty,TabTotalAmount,TabArcimDesc,TabPhcfrCode,TabDoseQtyUnit,TabPhOrdQtyUnit,TabPackNum,TabAuditFlag,TabOEORIRowId,TabAuditUserName,TabAuditDate,TabAuditTime")
{
}

ClassMethod OPAuditAppExecute(ByRef qHandle As %Binary, RegNo, StartDate, EndDate, CheckAuditType) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	i StartDate="" s StartDate=+$H
	i EndDate="" s EndDate=+$H
	
	i RegNo'="" d
	.s PapmiDr=""
	.s PapmiDr=$o(^PAPERi("PAPMI_PatNo",RegNo,PapmiDr))  ;$$ALPHAUP
	.s PaadmType=""
	.f  s PaadmType=$o(^PAPERdr(PapmiDr,"ADM",PaadmType)) q:PaadmType=""  d
	..;q:PaadmType="I"			;判断住院 or 门诊
	..s PaadmDr=""
	..f  s PaadmDr=$o(^PAPERdr(PapmiDr,"ADM",PaadmType,PaadmDr)) q:PaadmDr=""  d
	...s (visitstatus,Type,TabRegNo,TabPatName,TabCTDesc,TabPatType,TabDiagDesc,TabPrescNo,TabOEORIDate,TabOEORITimeOrd,TabOEORIDoctorDesc,TabPrescPrice,TabOEORIPhQty,TabTotalAmount,TabArcimDesc,TabPhcfrCode,TabDoseQtyUnit,TabPhOrdQtyUnit,TabPackNum,TabAuditFlag,TabOEORIRowId)=""
	...s PaadmInfo=$g(^PAADM(PaadmDr))
	...q:PaadmInfo=""
	...s visitstatus=$p($g(^PAADM(PaadmDr)),"^",20)
	...q:(visitstatus="")||(visitstatus="C")
	...s Type=$p($g(^PAADM(PaadmDr)),"^",2)
	...s TabRegNo=$p(^PAPER(+^PAADM(PaadmDr),"PAT",1),"^",1)			;1登记号
	...s TabPatName=$p(^PAPER(+^PAADM(PaadmDr),"ALL"),"^",1)			;2姓名
	...s CTLocDr=$p($g(^PAADM(PaadmDr)),"^",4)
	...i CTLocDr="" d
	....s TabCTDesc=""
	...e  d
	....s TabCTDesc=$p(^CTLOC(CTLocDr),"^",2)							;3科室描述
	...s admReasonDr=$P($g(^PAADM(PaadmDr,1)),"^",7)
	...q:admReasonDr=""
	...s TabPatType=$P($G(^PAC("ADMREA",admReasonDr)),"^",2)			;4病人类型
	...s admReasonSource=$P($g(^PAC("ADMREA",admReasonDr)),"^",9)
	...s admReasonNational=$P($g(^PAC("ADMREA",admReasonDr)),"^",5)
	...q:admReasonNational'=1
	...s TabDiagDesc=##Class(web.DHCNurInsAudit).GetMRDiagnos(PaadmDr)	;5诊断	
	...;w TabRegNo_"^"_TabPatName_"^"_TabCTDesc_"^"_TabPatType_"^"_TabDiagDesc,!
	
	...s OEORDDr=""
	...f  s OEORDDr=$o(^OEORD(0,"Adm",PaadmDr,OEORDDr)) q:OEORDDr=""  d
	....s OEORIDr=""
	....f  s OEORIDr=$o(^OEORD(OEORDDr,"I",OEORIDr)) q:OEORIDr=""  d
	.....s (TabPrescNo,TabOEORIDate,TabOEORITimeOrd,TabOEORIDoctorDesc,TabPrescPrice,TabOEORIPhQty,TabTotalAmount,TabArcimDesc,TabPhcfrCode,TabDoseQtyUnit,TabPhOrdQtyUnit,TabPackNum,TabAuditFlag,TabOEORIRowId)=""
	.....s (AuditUserDr,TabAuditUserName,TabAuditDate,TabAuditTime)=""
	.....s OEORIRowId=OEORDDr_"||"_OEORIDr
	.....s TabOEORIRowId=OEORIRowId										;19找明细用的医嘱明细表rowid
	.....s DHCORIDr=""
	.....s DHCORIDr=$o(^DHCORDItem(0,OEORIRowId,DHCORIDr))
	.....q:DHCORIDr=""													
	.....s YNFlag=$p($g(^DHCORDItem(DHCORIDr,2)),"^",8)					;判断是否需要审批
	.....q:YNFlag=""
	.....s TabAuditFlag=$p($g(^DHCORDItem(DHCORIDr,2)),"^",1)			;18判断审批是否通过标志位置
	.....q:(CheckAuditType="")&&(TabAuditFlag'="")
	.....q:(CheckAuditType'="")&&(TabAuditFlag="")
	.....s:TabAuditFlag="Y" TabAuditFlag="审核通过"
	.....s:TabAuditFlag="N" TabAuditFlag="审核未通过"
	.....s AuditUserDr=$p($g(^DHCORDItem(DHCORIDr,2)),"^",2)			;20审核人
	.....i AuditUserDr'="" d
	......s TabAuditUserName=$p($g(^SSU("SSUSR",AuditUserDr)),"^",2)
	......s TabAuditDate=$zd($p($g(^DHCORDItem(DHCORIDr,2)),"^",3),3)			;21审核日期
	......s TabAuditTime=$zt($p($g(^DHCORDItem(DHCORIDr,2)),"^",4),1)			;22审核时间
	
	.....s TabPrescNo=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",14)		;6处方号
	.....s TabOEORIDate=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",7)		;7开医嘱日期
	.....s TabOEORITimeOrd=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",17)		;8开医嘱时间
	.....q:(TabOEORIDate<StartDate)!(TabOEORIDate>EndDate)
	.....s TabOEORIDate=$zd(TabOEORIDate,3)
	.....s TabOEORITimeOrd=$zt(TabOEORITimeOrd,1)
	.....s TabOEORIDoctorDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",11)	
	.....i TabOEORIDoctorDR="" d
	......s TabOEORIDoctorDesc=""
	.....e  d
	......s TabOEORIDoctorDesc=$p($g(^CTPCP(TabOEORIDoctorDR,1)),"^",2)		;9开医嘱医生
	
	.....s OEORIPhQtyOrd=##Class(web.DHCCLCom).GetOrderBaseQty(OEORIRowId)		
	.....s TabOEORIPhQty=OEORIPhQtyOrd										;11医嘱数量
	.....s ItmMastDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",2)				
	.....i ItmMastDR="" d
	......s TabPrescPrice=""
	.....e  d
	......s TabPrescPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("","",ItmMastDR,+$h,"","","",""),"^",4)	
	......s TabPrescPrice=$fn(TabPrescPrice,"",2)								;10医嘱单位价格	
	......s TabTotalAmount=$fn(TabPrescPrice*OEORIPhQtyOrd,"",2)				;12医嘱总价   
	......s TabArcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)	;13医嘱名称
	......s phcfrId=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",4)				
	......q:phcfrId=""
	......s TabPhcfrCode=$p($g(^PHCFR(phcfrId)),"^",3) 							;14医嘱频次                                                              	
   	......s doseQty=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",1)                           
	......i doseQty'="" s unitUomId=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",3)           
	......i $g(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)		            
	......s TabDoseQtyUnit=$g(doseQty)_" "_$g(unitDesc)							;15剂量
	......s phOrdQty=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",12)                         
	......s TabPhOrdQtyUnit=phOrdQty_" "_$g(unitDesc)							;16总量																		;5单价        
  	......s TabPackNum=##Class(web.DHCNurDrugAudit).GetPackQty(OEORDDr,OEORIDr)	;17整包数量
	.....DO OutPatPresc
	
	
	i RegNo="" d
	.f PAADMDate=StartDate:1:EndDate d
	..s PaadmDr=""
	..f  s PaadmDr=$o(^PAADMi("PAADM_AdmDate",PAADMDate,PaadmDr)) q:PaadmDr=""  d
	...s (visitstatus,Type,TabRegNo,TabPatName,TabCTDesc,TabPatType,TabDiagDesc,TabPrescNo,TabOEORIDate,TabOEORITimeOrd,TabOEORIDoctorDesc,TabPrescPrice,TabAuditFlag)=""
	...s PaadmInfo=$g(^PAADM(PaadmDr))
	...q:PaadmInfo=""
	...s visitstatus=$p($g(^PAADM(PaadmDr)),"^",20)
	...q:(visitstatus="")||(visitstatus="C")
	...s Type=$p($g(^PAADM(PaadmDr)),"^",2)
	...q:PaadmDr'="27032"
	...;q:(Type="I")
	...s TabRegNo=$p(^PAPER(+^PAADM(PaadmDr),"PAT",1),"^",1)			;1登记号
	...s TabPatName=$p(^PAPER(+^PAADM(PaadmDr),"ALL"),"^",1)			;2姓名
	...s CTLocDr=$p($g(^PAADM(PaadmDr)),"^",4)
	...i CTLocDr="" d
	....s TabCTDesc=""
	...e  d
	....s TabCTDesc=$p(^CTLOC(CTLocDr),"^",2)							;3科室描述
	...s admReasonDr=$P($g(^PAADM(PaadmDr,1)),"^",7)
	...q:admReasonDr=""
	...s TabPatType=$P($G(^PAC("ADMREA",admReasonDr)),"^",2)			;4病人类型
	...s admReasonSource=$P($g(^PAC("ADMREA",admReasonDr)),"^",9)
	...s admReasonNational=$P($g(^PAC("ADMREA",admReasonDr)),"^",5)
	...q:admReasonNational'=1
	...s TabDiagDesc=##Class(web.DHCNurInsAudit).GetMRDiagnos(PaadmDr)	;5诊断
	...s OEORDDr=""
	...f  s OEORDDr=$o(^OEORD(0,"Adm",PaadmDr,OEORDDr)) q:OEORDDr=""  d
	....s OEORIDr=""
	....f  s OEORIDr=$o(^OEORD(OEORDDr,"I",OEORIDr)) q:OEORIDr=""  d
	.....s (TabPrescNo,TabOEORIDate,TabOEORITimeOrd,TabOEORIDoctorDesc,TabPrescPrice,TabOEORIPhQty,TabTotalAmount,TabArcimDesc,TabPhcfrCode,TabDoseQtyUnit,TabPhOrdQtyUnit,TabPackNum,TabAuditFlag,TabOEORIRowId)=""
	.....s (AuditUserDr,TabAuditUserName,TabAuditDate,TabAuditTime)=""
	.....s OEORIRowId=OEORDDr_"||"_OEORIDr
	.....s TabOEORIRowId=OEORIRowId										;19找明细用的医嘱明细表rowid
	.....s DHCORIDr=""
	.....s DHCORIDr=$o(^DHCORDItem(0,OEORIRowId,DHCORIDr))
	.....q:DHCORIDr=""													
	.....s YNFlag=$p($g(^DHCORDItem(DHCORIDr,2)),"^",8)					;判断是否需要审批
	.....q:YNFlag=""
	.....s TabAuditFlag=$p($g(^DHCORDItem(DHCORIDr,2)),"^",1)			;18判断审批是否通过标志位置
	.....q:(CheckAuditType="")&&(TabAuditFlag'="")
	.....q:(CheckAuditType'="")&&(TabAuditFlag="")
	.....s:TabAuditFlag="Y" TabAuditFlag="审核通过"
	.....s:TabAuditFlag="N" TabAuditFlag="审核未通过"
	.....s AuditUserDr=$p($g(^DHCORDItem(DHCORIDr,2)),"^",2)			;20审核人
	.....i AuditUserDr'="" d
	......s TabAuditUserName=$p($g(^SSU("SSUSR",AuditUserDr)),"^",2)
	......s TabAuditDate=$zd($p($g(^DHCORDItem(DHCORIDr,2)),"^",3),3)			;21审核日期
	......s TabAuditTime=$zt($p($g(^DHCORDItem(DHCORIDr,2)),"^",4),1)			;22审核时间
	
	.....s TabPrescNo=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",14)		;6处方号
	.....s TabOEORIDate=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",7)		;7开医嘱日期
	.....s TabOEORITimeOrd=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",17)		;8开医嘱时间
	.....q:(TabOEORIDate<StartDate)!(TabOEORIDate>EndDate)
	.....s TabOEORIDate=$zd(TabOEORIDate,3)
	.....s TabOEORITimeOrd=$zt(TabOEORITimeOrd,1)
	.....s TabOEORIDoctorDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",11)	
	.....i TabOEORIDoctorDR="" d
	......s TabOEORIDoctorDesc=""
	.....e  d
	......s TabOEORIDoctorDesc=$p($g(^CTPCP(TabOEORIDoctorDR,1)),"^",2)		;9开医嘱医生
	
	.....s OEORIPhQtyOrd=##Class(web.DHCCLCom).GetOrderBaseQty(OEORIRowId)		
	.....s TabOEORIPhQty=OEORIPhQtyOrd										;11医嘱数量
	.....s ItmMastDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",2)				
	.....i ItmMastDR="" d
	......s TabPrescPrice=""
	.....e  d
	......s TabPrescPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("","",ItmMastDR,+$h,"","","",""),"^",4)	
	......s TabPrescPrice=$fn(TabPrescPrice,"",2)								;10医嘱单位价格	
	......s TabTotalAmount=$fn(TabPrescPrice*OEORIPhQtyOrd,"",2)				;12医嘱总价   
	......s TabArcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)	;13医嘱名称
	......s phcfrId=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",4)				
	......q:phcfrId=""
	......s TabPhcfrCode=$p($g(^PHCFR(phcfrId)),"^",3) 							;14医嘱频次                                                              	
   	......s doseQty=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",1)                           
	......i doseQty'="" s unitUomId=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",3)           
	......i $g(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)		            
	......s TabDoseQtyUnit=$g(doseQty)_" "_$g(unitDesc)							;15剂量
	......s phOrdQty=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",12)                         
	......s TabPhOrdQtyUnit=phOrdQty_" "_$g(unitDesc)							;16总量																		;5单价        
  	......s TabPackNum=##Class(web.DHCNurDrugAudit).GetPackQty(OEORDDr,OEORIDr)	;17整包数量
	.....DO OutPatPresc

  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutPatPresc
	i TabOEORIDate'="" d
	.s tmpTabOEORIDate=$zdh(TabOEORIDate,3)
	.s TabOEORIDate=##class(websys.Conversions).DateLogicalToHtml(TabOEORIDate)
	i TabAuditDate'="" d
	.s tmpTabAuditDate=$zdh(TabAuditDate,3)
	.s TabAuditDate=##class(websys.Conversions).DateLogicalToHtml(tmpTabAuditDate)
	set Data=$lb(TabRegNo,TabPatName,TabCTDesc,TabPatType,TabDiagDesc,TabPrescNo,TabOEORIDate,TabOEORITimeOrd,TabOEORIDoctorDesc,TabPrescPrice,TabOEORIPhQty,TabTotalAmount,TabArcimDesc,TabPhcfrCode,TabDoseQtyUnit,TabPhOrdQtyUnit,TabPackNum,TabAuditFlag,TabOEORIRowId,TabAuditUserName,TabAuditDate,TabAuditTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod OPAuditAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPAuditAppExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OPAuditAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPAuditAppExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// Query OPAuditAppDetail(PrescNo As %String) As %Query(ROWSPEC = "TabPrescNo:%String,TabArcimDesc:%String,TabOECPRDesc:%String,TabPhcfrCode:%String,TabDoseQtyUnit:%String,TabPhOrdQtyUnit:%String,TabPrice:%String,TabTotalAmount:%String,TabOEOrdId:%String,TabDspStat:%String,TabPackNum:%String,TabStDate:%String,TabStTime:%String")

// {

// }

/// w ##class(web.INSUAudit).MedAudit("28176||26^28176||31^28176||32^28176||56^28176||57^28176||58^28176||59","Y","220")
ClassMethod MedAudit(TabOEORIRowIdStr As %String = "", State As %String = "Y", Guser As %String = "") As %String
{
	////存储医嘱明细扩展表审核数据 TabOEORIRowIdStr 医嘱明细表rowid串  State "Y" 审核通过  "N"  拒绝 
	;n (TabOEORIRowIdStr,State,Guser)
	q:TabOEORIRowIdStr="" 0
	s userId=Guser
	s curDate=$P($H,",",1)
	s curTime=$P($H,",",2)
	s len=$L(TabOEORIRowIdStr,"^")
	f i=1:1:len d
	.s OEORIRowId=$P(TabOEORIRowIdStr,"^",i)
	.s DHCORIRowid=$O(^DHCORDItem(0,OEORIRowId,""))
	.q:DHCORIRowid=""
	.i State'="" d 
	..&SQL(UpDate DHC_OE_OrdItem set DHCORI_Approved=:State,DHCORI_ApprovedUser_dr=:userId,DHCORI_ApprovedDate=:curDate,DHCORI_ApprovedTime=:curTime where dhcori_rowid=:DHCORIRowid)
	.e  d
	..&SQL(UpDate DHC_OE_OrdItem set DHCORI_Approved=Null,DHCORI_ApprovedUser_dr=Null,DHCORI_ApprovedDate=Null,DHCORI_ApprovedTime=Null where dhcori_rowid=:DHCORIRowid)
	q SQLCODE
}

/// w ##class(web.INSUAudit).GetOEORIInfo("28176||26^28176||31^28176||32^28176||56^28176||57^28176||58^28176||59","Y","220")
ClassMethod GetOEORIInfo(OEORIRowId As %String) As %String
{
	s OutStr=-1
	q:OEORIRowId="" OutStr
	s (TabPrescNo,TabOEORIDate,TabOEORITimeOrd,TabOEORIDoctorDesc,TabPrescPrice,TabOEORIPhQty,TabTotalAmount,TabArcimDesc,TabPhcfrCode,TabDoseQtyUnit,TabPhOrdQtyUnit,TabPackNum,TabAuditFlag,TabOEORIRowId)=""
	;s OEORIRowId=OEORDDr_"||"_OEORIDr
	s OEORDDr=$p(OEORIRowId,"||",1)
	s OEORIDr=$p(OEORIRowId,"||",2)
	s TabOEORIRowId=OEORIRowId										;19找明细用的医嘱明细表rowid
	s DHCORIDr=""
	s DHCORIDr=$o(^DHCORDItem(0,OEORIRowId,DHCORIDr))
	q:DHCORIDr="" OutStr													
	s YNFlag=$p($g(^DHCORDItem(DHCORIDr,2)),"^",8)					;判断是否需要审批
	q:YNFlag="" OutStr
	s TabAuditFlag=$p($g(^DHCORDItem(DHCORIDr,2)),"^",1)			;18判断审批是否通过标志位置
	q:(CheckAuditType="")&&(TabAuditFlag'="") OutStr
	q:(CheckAuditType'="")&&(TabAuditFlag="") OutStr
	s:TabAuditFlag="Y" TabAuditFlag="审核通过"
	s:TabAuditFlag="N" TabAuditFlag="审核未通过"
	
	s TabPrescNo=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",14)		;6处方号
	s TabOEORIDate=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",7)		;7开医嘱日期
	s TabOEORITimeOrd=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",17)		;8开医嘱时间
	q:(TabOEORIDate<StartDate)!(TabOEORIDate>EndDate) OutStr
	;s TabOEORIDate=$zd(TabOEORIDate,3)
	s TabOEORIDate=##class(websys.Conversions).DateLogicalToHtml(TabOEORIDate)
	s TabOEORITimeOrd=$zt(TabOEORITimeOrd,1)
	s TabOEORIDoctorDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",11)	
	i TabOEORIDoctorDR="" d
	.s TabOEORIDoctorDesc=""
	e  d
	.s TabOEORIDoctorDesc=$p($g(^CTPCP(TabOEORIDoctorDR,1)),"^",2)		;9开医嘱医生
	
	s OEORIPhQtyOrd=##Class(web.DHCCLCom).GetOrderBaseQty(OEORIRowId)		
	s TabOEORIPhQty=OEORIPhQtyOrd										;11医嘱数量
	s ItmMastDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",2)				
	i ItmMastDR="" d
	.s TabPrescPrice=""
	e  d
	.s TabPrescPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("","",ItmMastDR,+$h,"","","",""),"^",4)	
	.s TabPrescPrice=$fn(TabPrescPrice,"",2)								;10医嘱单位价格	
	.s TabTotalAmount=$fn(TabPrescPrice*OEORIPhQtyOrd,"",2)				;12医嘱总价   
	.s TabArcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)	;13医嘱名称
	.s phcfrId=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",4)				
	.q:phcfrId=""
	.s TabPhcfrCode=$p($g(^PHCFR(phcfrId)),"^",3) 							;14医嘱频次                                                              	
    .s doseQty=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",1)                           
	.i doseQty'="" s unitUomId=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",3)           
	.i $g(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)		            
	.s TabDoseQtyUnit=$g(doseQty)_" "_$g(unitDesc)							;15剂量
	.s phOrdQty=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",12)                         
	.s TabPhOrdQtyUnit=phOrdQty_" "_$g(unitDesc)							;16总量																		;5单价        
    .s TabPackNum=##Class(web.DHCNurDrugAudit).GetPackQty(OEORDDr,OEORIDr)	;17整包数量
    s OutStr=TabPrescNo_"^"_TabOEORIDate_"^"_TabOEORITimeOrd_"^"_TabOEORIDoctorDesc_"^"_TabPrescPrice_"^"_TabOEORIPhQty_"^"_
    			TabTotalAmount_"^"_TabArcimDesc_"^"_TabPhcfrCode_"^"_TabDoseQtyUnit_"^"_TabPhOrdQtyUnit_"^"_TabPackNum_"^"_TabAuditFlag_"^"_TabOEORIRowId
    q
}

}
