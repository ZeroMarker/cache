Import sqluser

/// Creator：      zhangdongliang
/// CreatDate：    2010-06-09
/// Description:   医嘱审批功能 61736^61746
/// d ##class(%ResultSet).RunQuery("web.INSUAuditOP","OPAuditApp","0000000693","2022-10-31","2022-10-31","","1","1","2")
Class web.INSUAuditOP Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query OPAuditApp(RegNo, StartDate, EndDate, CheckAuditType, RType, Price800, HospDr) As %Query(ROWSPEC = "TabRegNo,TabPatName,TabPatNo,TabPatID,TabCTDesc,TabPatType,TabDiagDesc,TabPrescNo,TabOEORIDate,TabOEORITimeOrd,TabOEORIDoctorDesc,TabPrescPrice,TabOEORIPhQty,TabTotalAmount,TabArcimDesc,TabPhcfrCode,TabDoseQtyUnit,TabPhOrdQtyUnit,TabPackNum,TabAuditFlag,TabOEORIRowId,TabAuditUserName,TabAuditDate,TabAuditTime,job,TblRType,TabAdmRowid,TabPackUOM")
{
}

ClassMethod OPAuditAppExecute(ByRef qHandle As %Binary, RegNo, StartDate, EndDate, CheckAuditType, RType, Price800, HospDr) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s i=0
 	i StartDate="" s StartDate=+$H
	i EndDate="" s EndDate=+$H
	s ^TempAuditOP("AuditOP")=$lb(RegNo,StartDate,EndDate,CheckAuditType,RType,Price800,HospDr)
	;w CheckAuditType_"_"_RType_"_"_Price800
	;"全部价钱","1,"800以下","2","800以上","3"
	;"全部","1","门特","2","特检特治","3",DHC_OE_OrdItem.DHCORI_ApproveType
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s TmpPrintFlag=1
	s TabArcimDescStr3="",TabArcimDescStr4="",TabTotalAmount3="",TabTotalAmount4="",TabArcimDescStrT="",TabTotalAmountT=""
	
	#dim AdmLst As list of %String = ##class(%Library.ListOfDataTypes).%New()
	
	/*#1 登记号不为空时取就诊记录LIST*/
	i RegNo'="" d
	.i $l(+RegNo)>0 d
	..s tmpRegNo="000000000"_RegNo
	..s RegNo=$Extract(tmpRegNo,$l(tmpRegNo)-9,$l(tmpRegNo))
	.s PapmiDr=""
	.s PapmiDr=$o(^PAPERi("PAPMI_PatNo",RegNo,PapmiDr))  ;$$ALPHAUP
	.q:PapmiDr=""
	.s PaadmType=""
	.f  s PaadmType=$o(^PAPERdr(PapmiDr,"ADM",PaadmType)) q:PaadmType=""  d
	..q:PaadmType="I"			;判断住院 or 门诊
	..s PaadmDr=""
	..f  s PaadmDr=$o(^PAPERdr(PapmiDr,"ADM",PaadmType,PaadmDr)) q:PaadmDr=""  d
	...s tHospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(PaadmDr) 
	...q:(tHospDr'=HospDr)&&(HospDr'="")
    ...d AdmLst.Insert(PaadmDr)
    
	/*#2 登记号为空时取就诊记录LIST*/
	i RegNo="" d
	.f PAADMDate=StartDate:1:EndDate d
	..s PaadmDr="",ADMDate=$zd(PAADMDate,3)
	..f  s PaadmDr=$o(^PAADMi("PAADM_AdmDate",PAADMDate,PaadmDr)) q:PaadmDr=""  d
	...s PaadmType=$p($g(^PAADM(PaadmDr)),"^",2)
	...q:PaadmType="I"
	...s tHospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(PaadmDr) 
	...q:(tHospDr'=HospDr)&&(HospDr'="")
	...d AdmLst.Insert(PaadmDr)
	
    /*#2 根据就诊记录取医嘱信息(需要优化)20200604*/
	f index = 1 : 1 : AdmLst.Count()  d
    .s PaadmDr=AdmLst.GetAt(index)
	.s (visitstatus,Type,TabRegNo,TabPatName,TabCTDesc,TabPatType,TabDiagDesc,TabPrescNo,TabOEORIDate,TabOEORITimeOrd,TabOEORIDoctorDesc,TabPrescPrice,TabOEORIPhQty,TabTotalAmount,TabArcimDesc,TabPhcfrCode,TabDoseQtyUnit,TabPhOrdQtyUnit,TabPackNum,TabAuditFlag,TabOEORIRowId)=""
	.s (PaSex,Age,IPNO,TabTotalAmount3,company,TabArcimDescStr3)=""
	.s PaadmInfo=$g(^PAADM(PaadmDr))
	.q:PaadmInfo=""
	.s visitstatus=$p($g(^PAADM(PaadmDr)),"^",20)
	.q:(visitstatus="")||(visitstatus="C")
	.s TabRegNo=$p($g(^PAPER(+^PAADM(PaadmDr),"PAT",1)),"^",1)			;1登记号
	.s TabPatName=$p($g(^PAPER(+^PAADM(PaadmDr),"ALL")),"^",1)			;2姓名
	.//s TabPatNo=$p(^PAPER(+^PAADM(PaadmDr),"ALL"),"^",19)		        ;3个人编号
	.s TabPatNo=$p($g(^PAPER(+^PAADM(PaadmDr),"PAT",3)),"^",12)		    ;3个人编号 +DingSH 20200917
	.s TabPatID=$p($g(^PAPER(+^PAADM(PaadmDr),"ALL")),"^",9)			;4身份证号
	.s ADMDate=$zd($p(^PAADM(PaadmDr),"^",6),3)
	.s CTLocDr=$p($g(^PAADM(PaadmDr)),"^",4)
	.s tHospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(PaadmDr) 
	.i CTLocDr="" d
	..s TabCTDesc=""
	.e  d
	..s TabCTDesc=$p(^CTLOC(CTLocDr),"^",2)							;5科室描述
	.s admReasonDr=$P($g(^PAADM(PaadmDr,1)),"^",7)
	.q:admReasonDr=""
	.s TabPatType=$P($G(^PAC("ADMREA",admReasonDr)),"^",2)			;6病人类型
	.s admReasonSource=$P($g(^PAC("ADMREA",admReasonDr)),"^",9)
	.s admReasonNational=$P($g(^PAC("ADMREA",admReasonDr)),"^",5)
	.;modefy by zhangdongliang at 2017-08-25 for 只显示医保费别的数据
	.q:+admReasonSource<1
	.s MRAdmDr=$p(^PAADM(PaadmDr),"^",61)
	.s TabDiagDesc=##class(web.DHCMRDiagnos).GetMRDiagnosDesc(MRAdmDr,"|")
	.;end
	.s OEORDDr=""
	.f  s OEORDDr=$o(^OEORD(0,"Adm",PaadmDr,OEORDDr)) q:OEORDDr=""  d
	..s OEORIDr=""
	..f  s OEORIDr=$o(^OEORD(OEORDDr,"I",OEORIDr)) q:OEORIDr=""  d
	...s (TabPrescNo,TabOEORIDate,TabOEORITimeOrd,TabOEORIDoctorDesc,TabPrescPrice,TabOEORIPhQty,TabTotalAmount,TabArcimDesc,TabPhcfrCode,TabDoseQtyUnit,TabPhOrdQtyUnit,TabPackNum,TabAuditFlag,TabOEORIRowId)=""
	...s (AuditUserDr,TabAuditUserName,TabAuditDate,TabAuditTime,YNFlag)=""
	...s YNFlagType="普通"
	...s OEORIRowId=OEORDDr_"||"_OEORIDr
	...;add by gn 2017-07-27   
	...;q:$d(^DHCOPIPADMCON("OPADMORDER","OPAdm",PaadmDr,OEORIRowId))>0
	...q:+##class(web.DHCBillInterface).IOrdIsOPToIPByOEORI(OEORIRowId)>0
	...;end gn  过滤门诊转住院的医嘱
	...s TabOEORIRowId=OEORIRowId										;19找明细用的医嘱明细表rowid
	...s BBExtCode=$p($g(^OEORD(OEORDDr,"I",OEORIDr,11)),"^",18)        ;2011 08 29 wty 存放的是费别，用于取特病(费别与处方类型对应，医保病人可能看自费或者医保)
	...s DHCORIDr="",TabAuditFlag="",TabAuditUserName="",TabAuditDate="",TabAuditTime=""
	...s DHCORIDr=$o(^DHCORDItem(0,OEORIRowId,DHCORIDr))
	...q:(RType'=1)&(RType'="")&(DHCORIDr="")
	...i DHCORIDr'="" d
	....s YNFlag=$p($g(^DHCORDItem(DHCORIDr,2)),"^",8)	;DHCORI_ApproveType		;判断是否需要审批
	....;q:(YNFlag'="3")&(YNFlag'="4")  ;3特检特治 4门特
	....s:YNFlag="3" YNFlagType="特检特治"
	....s:YNFlag="4" YNFlagType="门诊特病"
	....q:((RType'=1)&(RType'=""))&(RType'=YNFlag)
	....s TabAuditFlag=$p($g(^DHCORDItem(DHCORIDr,3)),"^",1)			;18判断审批是否通过标志位置
	....s:TabAuditFlag="Y" TabAuditFlag="审核通过"
	....s:TabAuditFlag="N" TabAuditFlag="审核未通过"
	....s AuditUserDr=$p($g(^DHCORDItem(DHCORIDr,3)),"^",4)			;20审核人
	....i AuditUserDr'="" d
	.....s TabAuditUserName=$p($g(^SSU("SSUSR",AuditUserDr)),"^",2)
	.....s TabAuditDate=$zd($p($g(^DHCORDItem(DHCORIDr,3)),"^",2),3)			;21审核日期
	.....s TabAuditTime=$zt($p($g(^DHCORDItem(DHCORIDr,3)),"^",3),1)			;22审核时间
	...q:((RType'=1)&(RType'=""))&(RType'=YNFlag)
	...q:(CheckAuditType="")&&(TabAuditFlag'="")
	...q:(CheckAuditType'="")&&(TabAuditFlag="")
	...;Zhan 20160414，不显示停止和作废的医嘱
	...s ordstr1=$g(^OEORD(OEORDDr,"I",OEORIDr,1))
	...s OrdStatusDR=$p(ordstr1,"^",13)
	...s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
	...s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
	...q:"U,D"[OrdStatusCode
	...;add by zhangdongliang at 2016-10-18 for 已收费医嘱不再显示，因为门诊审核功能是放在收费之前，未审核禁止结算。
	...s OEORIBilled=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",5)
	...q:OEORIBilled="P"
	...;end
	...;s TabPrescNo=YNFlagType ;$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",14)		;6处方号
	...s TabPrescNo=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",14)		;6处方号
	...s TabOEORIDate=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",7)		;7开医嘱日期
	...s TabOEORITimeOrd=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",17)	;8开医嘱时间
	...q:(TabOEORIDate<StartDate)!(TabOEORIDate>EndDate)
	...s TabOEORIDate=$zd(TabOEORIDate,3)
	...s TabOEORITimeOrd=$zt(TabOEORITimeOrd,1)
	...;modefy by zhangdongliang at 2016-09-29 for 此处没有问题，应该显示的是开医嘱医生，而不是下医嘱人。
	...s TabOEORIDoctorDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",11)	
	...i TabOEORIDoctorDR="" d
	....s TabOEORIDoctorDesc=""
	...e  d
	....s TabOEORIDoctorDesc=$p($g(^CTPCP(TabOEORIDoctorDR,1)),"^",2)		;9开医嘱人（可以是护士、收费员等）
	...;s OrderMesage=##class(web.DHCDocOrderCommon).GetOrderMesage(OEORIRowId)
	...;s TabOEORIDoctorDesc=$p(OrderMesage,"^",15)
	...;end
	...s ItmMastDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",2)
	...s PackUOM=##class(web.DHCBillCommon).GetPackUom(ItmMastDR, OEORIRowId) //单位
	...s PackQty=##class(BILL.OP.COM.Method).GetOrdEffectivePackQty(OEORIRowId) //数量
	...q:(+PackQty=0)  //过滤数量为0的记录
	...s IsReChged=##class(BILL.OP.COM.Method).IsReChgedOEORI(OEORIRowId)   //是否退费后重新收费标识(1:是,0:否)
	...s SttDate=$s((IsReChged=1):$p($g(^OEORD(OEORDDr,"I",OEORIDr,9)),"^",15),1:+$h)
	...s InsTypeDR=$p($g(^OEORD(+OEORDDr,"I",OEORIDr,11)),"^",18)     //OEORI_BBExtCode
	...s OrdAmtCost=..GetOrdTarItmCost(OEORIRowId, InsTypeDR, SttDate, tHospDr)
	...s TotalAmt=+$p(OrdAmtCost,"^",1)
	...s PatAmt=+$p(OrdAmtCost,"^",2)                                      //金额
	...s Price=TotalAmt/PackQty  
	...s Price=$fn(Price,"",6)                                             //单价 
	...s TabOEORIPhQty=PackQty 
	...s TabTotalAmount=PatAmt 
	...s TabPrescPrice=Price 
	
	...//s OEORIPhQtyOrd=##Class(web.DHCCLCom).GetOrderBaseQty(OEORIRowId)
	...//s Factor=##class(web.DHCBillCommon).GetUomConvFactor(ItmMastDR, OEORIRowId)	
	...//s OEORIPhQtyOrd = OEORIPhQtyOrd * Factor
	...//s OEORIPhQtyOrd=$p(##class(web.DHCINSUPortUse).GetOEQty(OEORIRowId),"^",1) //- DingSH 20200604
	...//s TabOEORIPhQty=OEORIPhQtyOrd										;11医嘱数量
	...//s arcimId=ItmMastDR
	...;s Flag=##class(web.INSUAudit).ArcimLinkInsuList(ItmMastDR, admReasonDr)
	...;q:Flag'="Y"                                   ;没有特检特治不显示				
	...i ItmMastDR="" d
	....s TabPrescPrice=""
	...e  d
	....//s tmpTabPrescPrice=+$p(^OEORD(OEORDDr,"I",OEORIDr,3),"^",25)
	....//;modefy by zhangdongliang at 2017-03-01 for 取药品批次价格
	....//;ExpStr:挂号优惠设置^医嘱RowID^执行记录RowID^就诊RowID^接收科室RowID^
	....//s ExpStr=""_"^"_OEORIRowId_"^"_""_"^"_PaadmDr_"^"_""_"^"_""
	....//s TabPrescPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("",admReasonDr,ItmMastDR,+$h,"","","","",tHospDr,ExpStr),"^",4)	
	....//s:(TabPrescPrice'=tmpTabPrescPrice)&(tmpTabPrescPrice'=0) TabPrescPrice=tmpTabPrescPrice
	....//s TabPrescPrice=$fn(TabPrescPrice,"",4)								;10医嘱单位价格	
	....//;s:tmpTabPrescPrice'=TabPrescPrice TabPrescPrice=tmpTabPrescPrice
	....//s TabTotalAmount=$fn(TabPrescPrice*OEORIPhQtyOrd,"",4)				;12医嘱总价  
	....s TabArcimDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	    ;13医嘱名称2
	....s phcfrId=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",4)				
	....q:phcfrId=""
	....s TabPhcfrCode=$p($g(^PHCFR(phcfrId)),"^",3) 							;14医嘱频次                                                              	
   	....//s doseQty=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",1) 
   	....s doseQty=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(OEORIRowId) 	                          
	....i doseQty'="" s unitUomId=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",3)   
	....;add by zhangdongliang at 2015-10-12 for初始化变量
	....s unitDesc=""      
	....;end  
	....i $g(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)          	
	....;modefy by zhangdongliang at 2016-10-10 for 当doseQty不为空时，TabDoseQtyUnit才能赋值。  
	....i doseQty'="" d       
	.....s TabDoseQtyUnit=$g(doseQty)_" "_$g(unitDesc)							;15剂量
	....;end
	....s phOrdQty=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",12)                 
	....;modefy by zhangdongliang at 2016-10-10 for 当phOrdQty不为空时，TabPhOrdQtyUnit才能赋值。
	....i phOrdQty'="" d  
	.....s TabPhOrdQtyUnit=phOrdQty_" "_$g(unitDesc)							;16总量	
	.....;modefy by zhangdongliang at 2019-02-20 for 总量改为使用医生站开医嘱界面总量字段
	.....s CNMedItemFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(ItmMastDR,tHospDr)
	.....i CNMedItemFlag="0" d 
	......s PackAndQty=..GetPackAndQty(OEORIRowId)
	......s TabPhOrdQtyUnit=$p(PackAndQty,"^",1)_" "_$p(PackAndQty,"^",2)
	
	
		
		
   	....;end
  	....;s TabPackNum=##Class(web.DHCNurDrugAudit).GetPackQty(OEORDDr,OEORIDr)	;17整包数量  //- DingSH 20200604
  	....//s TabPackNumstr=##class(web.DHCINSUPortUse).GetOEQty(OEORIRowId)	        ;Zhan 20160414
  	....//s TabPackNum=$p(TabPackNumstr,"$",3)
  	....;s:$p($p(TabPackNumstr,"$",4),"^",2)'="" TabPackNum=$tr($p(TabPackNumstr,"$",4),"^","|")
  	....//s:$p($p(TabPackNumstr,"$",4),"^",2)'="" TabPackNum=$p(TabPackNumstr,"$",4)
  	....//s TabPackNum=$tr(TabPackNum,"^","|")
  	....s TabPackNum=$p($g(^OEORD(OEORDDr,"I",OEORIDr,9)),"^",4)	     //整包数量 OEORIQtyPackUOM
  	....i (phOrdQty'="")&&(doseQty="") d  
	.....s TabPhOrdQtyUnit="" //phOrdQty_" "_$p($p(TabPackNumstr,"$",1),"^",2) //- DingSH 20200604
	...DO OutPatPresc
	

  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
 
OutPatPresc
  	s i=i+1
  	i ADMDate'="" d
  	.s:$l(ADMDate,"-")=3 tmpADMDate=$zdh(ADMDate,3)
  	.s:$l(ADMDate,"/")=3 tmpADMDate=$zdh(ADMDate,4)
  	.s ADMDate=##class(websys.Conversions).DateLogicalToHtml(tmpADMDate)
  	i TabOEORIDate'="" d
  	.s tmpTabOEORIDate=$zdh(TabOEORIDate,3)
  	.s TabOEORIDate=##class(websys.Conversions).DateLogicalToHtml(tmpTabOEORIDate)
  	i TabAuditDate'="" d
  	.s tmpTabAuditDate=$zdh(TabAuditDate,3)
  	.s TabAuditDate=##class(websys.Conversions).DateLogicalToHtml(tmpTabAuditDate)
  	s ^TemInsuAudit("Audit",$j,i)=$G(YNFlag)_"^"_TabPatName_"^"_PaSex_"^"_Age_"^"_TabDiagDesc_"^"_IPNO_"^"_TabCTDesc_"^"_TabPatNo_"^"_ADMDate_"^"_TabTotalAmountT_"^"_company_"^"_TabArcimDescStrT_"^"_TabPatType_"^"_TabOEORIDate_"^"_$g(INRPTZZ)

	q:(Price800=2)&(TabTotalAmount>800) 
	q:(Price800=3)&(TabTotalAmount<=800) 
	;modefy by zhangdongliang at 2016-10-10 for 当总量为空时，显示空，不再显示0
	;s:$p(TabPhOrdQtyUnit,".",1)="" TabPhOrdQtyUnit="0"_TabPhOrdQtyUnit
	;end
	set Data=$lb(TabRegNo,TabPatName,TabPatNo,TabPatID,TabCTDesc,TabPatType,TabDiagDesc,TabPrescNo,TabOEORIDate,TabOEORITimeOrd,TabOEORIDoctorDesc,TabPrescPrice,TabOEORIPhQty,TabTotalAmount,TabArcimDesc,TabPhcfrCode,TabDoseQtyUnit,TabPhOrdQtyUnit,TabPackNum,TabAuditFlag,TabOEORIRowId,TabAuditUserName,TabAuditDate,TabAuditTime,$j,YNFlagType,PaadmDr,PackUOM)
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
	;s ^zmc(1)=TabOEORIRowIdStr_"_"_State_"_"_Guser
	q:TabOEORIRowIdStr="" 0
	s SQLCODE="-1"
	s userId=Guser
	s curDate=$P($H,",",1)
	s curTime=$P($H,",",2)
	s len=$L(TabOEORIRowIdStr,"^")
	f i=1:1:len d
	.s OEORIRowId=$P(TabOEORIRowIdStr,"^",i)
	.s DHCORIRowid=$O(^DHCORDItem(0,OEORIRowId,""))
	.;q:DHCORIRowid=""
	.i DHCORIRowid="" d
	..&SQL(INSERT INTO DHC_OE_OrdItem (dhcori_oeori_dr) VALUES (:OEORIRowId))
	..s DHCORIRowid=$O(^DHCORDItem(0,OEORIRowId,""))
	.q:DHCORIRowid=""
	.i State'="" d 
	..&SQL(UpDate DHC_OE_OrdItem set DHCORI_ConfirmFlag=:State,DHCORI_ConfirmUser=:userId,DHCORI_ConfirmDate=:curDate,DHCORI_ConfirmTime=:curTime where dhcori_rowid=:DHCORIRowid)
	.e  d
	..&SQL(UpDate DHC_OE_OrdItem set DHCORI_ConfirmFlag=Null,DHCORI_ConfirmUser=Null,DHCORI_ConfirmDate=Null,DHCORI_ConfirmTime=Null where dhcori_rowid=:DHCORIRowid)
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
	s AdmDr=$P(^OEORD(OEORDDr),"^",1)
	s tHospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) 
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
	s TabOEORIDate=$zd(TabOEORIDate,3)
	s TabOEORITimeOrd=$zt(TabOEORITimeOrd,1)
	s TabOEORIDoctorDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",11)	
	i TabOEORIDoctorDR="" d
	.s TabOEORIDoctorDesc=""
	e  d
	.s TabOEORIDoctorDesc=$p($g(^CTPCP(TabOEORIDoctorDR,1)),"^",2)		;9开医嘱医生
	
	;s OEORIPhQtyOrd=##Class(web.DHCCLCom).GetOrderBaseQty(OEORIRowId)	
	s OEORIPhQtyOrd=$p(##class(web.DHCINSUPortUse).GetOEQty(OEORIRowId),"^",1)
	s TabOEORIPhQty=OEORIPhQtyOrd										;11医嘱数量
	s ItmMastDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",2)		
	s arcimId=ItmMastDR		
	i ItmMastDR="" d
	.s TabPrescPrice=""
	e  d
	.s TabPrescPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("","",ItmMastDR,+$h,"","","","",tHospDr,""),"^",4)	
	.s TabPrescPrice=$fn(TabPrescPrice,"",4)								;10医嘱单位价格	
	.s TabTotalAmount=$fn(TabPrescPrice*OEORIPhQtyOrd,"",4)				;12医嘱总价   
	.s TabArcimDesc=$p(^ARCIM(+arcimId,+$p(arcimId,"||",2),1),"^",2)	;13医嘱名称1
	.s phcfrId=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",4)				
	.q:phcfrId=""
	.s TabPhcfrCode=$p($g(^PHCFR(phcfrId)),"^",3) 							;14医嘱频次                                                              	
    .s doseQty=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",1)                           
	.i doseQty'="" s unitUomId=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",3)       
	.;add by zhangdongliang at 2015-10-12 for初始化变量
	.s unitDesc=""      
	.;end      
	.i $g(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)		            
	.s TabDoseQtyUnit=$g(doseQty)_" "_$g(unitDesc)							;15剂量
	.s phOrdQty=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",12)                         
	.s TabPhOrdQtyUnit=phOrdQty_" "_$g(unitDesc)							;16总量																		;5单价        
    .s TabPackNum=##Class(web.DHCNurDrugAudit).GetPackQty(OEORDDr,OEORIDr)	;17整包数量
    s OutStr=TabPrescNo_"^"_TabOEORIDate_"^"_TabOEORITimeOrd_"^"_TabOEORIDoctorDesc_"^"_TabPrescPrice_"^"_TabOEORIPhQty_"^"_
    			TabTotalAmount_"^"_TabArcimDesc_"^"_TabPhcfrCode_"^"_TabDoseQtyUnit_"^"_TabPhOrdQtyUnit_"^"_TabPackNum_"^"_TabAuditFlag_"^"_TabOEORIRowId
    q
}

ClassMethod QueryTariByOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTariByOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.INSUAuditOP","QueryTariByOrd","3883||38","")
ClassMethod QueryTariByOrdExecute(ByRef qHandle As %Binary, OeOrdDr As %String, ExpStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	;b ;00
	q:OeOrdDr="" $$$OK
	s OEORIRowId=$p(OeOrdDr,"||",1)
	s OEORIChildsub=$p(OeOrdDr,"||",2)
	s ArcimRowid=$p(^OEORD(OEORIRowId,"I",OEORIChildsub,1),"^",2)
	s PaadmDr=$P(^OEORD(+OeOrdDr),"^",1)
    s admReasonDr=$P($g(^PAADM(PaadmDr,1)),"^",7)
	s OEORDAdmDR=$p($g(^OEORD(OEORIRowId)),"^",1)	
	s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(OEORDAdmDR)
	//s PAADMAdmReasonDR=$p(^PAADM(OEORDAdmDR,1),"^",7) //病人计费类别
	s BBExtCode=$p($g(^OEORD(OEORIRowId,"I",OEORIChildsub,11)),"^",18) 
	s InsuType=$p($$QueryByCode^DHCINSUDicData("AdmReasonDrToDLLType",BBExtCode,HospDr),"^",6)   //取PacAdmReason到医保医保目录的对照
	kill temptariAry
	do ##class(BILL.OP.COM.Method).GetOrdTarItmList(OeOrdDr, BBExtCode, +$h, HospDr, .temptariAry)
	set index=0
	while($o(temptariAry(index))) {
		set index=$o(temptariAry(index))
		set data=$g(temptariAry(index))
		set tari=$lg(data,1) //TariDr
		set TariDr=tari
		set tarCode=$p($g(^DHCTARI(tari)),"^",1)
		set tarDesc=$p($g(^DHCTARI(tari)),"^",2)
		set uomDesc=""
		set uomDR=$p(^DHCTARI(tari),"^",3)          //单位
    	set uomDesc=$s((+uomDR'=0):$p($g(^CT("UOM",uomDR)),"^",2),1:"")
		set price=$lg(data,2)
		set price=$fn(price,"N")
		//set discPrice=$lg(data,3)
		//set discPrice=$fn(discPrice,"N")
		//set payorPrice=$lg(data,4)
		//set payorPrice=$fn(payorPrice,"N")
		set patPrice=$lg(data,5)
		set patPrice=$fn(patPrice,"N")
		set qty=$lg(data,6)
		set qty=$fn(qty,"N")
		set totalAmt=$lg(data,7)
		set totalAmt=$fn(totalAmt,"",2)
		//set discAmt=$lg(data,8)
		//set discAmt=$fn(discAmt,"",2)
		//set payorAmt=$lg(data,9)
		//set payorAmt=$fn(payorAmt,"",2)
		set patAmt=$lg(data,10)
		set patAmt=$fn(patAmt,"",2)
		do TarItmInsu
	}
	kill temptariAry
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
TarItmInsu
    q:$g(TariDr)=""
    s TariSpecialFlag=$p($$QueryByCode^DHCINSUDicData("HISPROPerty"_InsuType,"TariSpecialFlag",HospDr),"^",4) //是否启用特殊收费项目对照 +DingSH 20200828
    i TariSpecialFlag="Y" d
    .s ARCIMType=$p($g(^OEORD(OEORIRowId,"I",OEORIChildsub,"DHC")),"^",3)	 ;Zhan 20151119 OEORI_InsurCat_DR 医保类别指针医保适应症代码(医保组)
    .s tmpTariDr=##class(web.DHCINSUTarConTar).QueryTarConId(TariDr, ARCIMType,HospDr) //+DingSH 20200828
    .i tmpTariDr'=""  d
	..s mCurrRowTarItem=$g(^DHCTARI(tmpTariDr))
    ..//s TARICode=$p(mCurrRowTarItem,"^",1)
    ..//s TARIDesc=$p(mCurrRowTarItem,"^",2)
    ..s TariDr=tmpTariDr
	//s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType,HospDr),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
	s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("HISPROPerty"_InsuType,"TariInsuFlag",HospDr),"^",4) 
	s InsuString=$$GetConInfo^DHCINSUTarContrast(TariDr,InsuType,"",TariInsuFlag,HospDr)
	s InsuCode=$p(InsuString,"^",3)
	s InsuDesc=$p(InsuString,"^",4)
	s xmlb=$p(InsuString,"^",7)
	s xmlbDesc=""
	//s xmlbDesc=$p($$QueryByCode^DHCINSUDicData("AKE003"_InsuType,xmlb,HospDr),"^",4)
	s xmlbDesc=$p($$QueryByCode^DHCINSUDicData("list_type"_InsuType,xmlb,HospDr),"^",4)
	s:xmlbDesc="" xmlbDesc=xmlb
	d Build
	q 
 
	
 
Build
	set Data=$lb(TariDr,tarCode,tarDesc,patPrice,InsuCode,InsuDesc,xmlb,qty,patPrice,patAmt,xmlbDesc,uomDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryTariByOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTariByOrdExecute ]
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

Query QueryTariByOrd(OeOrdDr As %String, ExpStr As %String) As %Query(ROWSPEC = "TariDr:%String,TariCode:%String,TariDesc:%String,Price:%String,InsuCode:%String,InsuDesc:%String,xmlb:%String,sl:%String,Price:%String,Amount:%String,xmlbDesc:%String,uomDesc:%String")
{
}

ClassMethod ArcimLinkInsuList(ArcimRowid, AdmReasonDr) As %String
{
	///w ##class(web.INSUAudit).ArcimLinkInsuList("2882||1","3")	
	n (ArcimRowid, AdmReasonDr)
	;w !,"ArcimRowid",ArcimRowid,"AdmReasonDr=",AdmReasonDr
	s Flag="N"
	s Str=##class(web.DHCINSUPort).ArcimLinkInsuList(ArcimRowid, AdmReasonDr)
	s Num=$l(Str,"!")
	s i=0
	f  s i=i+1 q:i>Num  d
	.s TmpStr=$p(Str,"!",i)
    .i $p(TmpStr,"^",7)=1 d
    ..s Flag="Y"
	q Flag
}

// w ##class(web.INSUAuditOP).GetNum("","",8628)

ClassMethod GetNum(itmjs As %Library.String = "", itmjsex As %Library.String = "", job As %Library.String) As %Library.String
{
  q:+$g(job)=0 -1 ; 修改 2016-01-13 加判断 DingSH 
  q:$d(^TemInsuAudit("Audit"))=0 -1 ;修改 2016-01-13 加判断 DingSH 
  s gnum=$o(^TemInsuAudit("Audit",job,""),-1) 
  q gnum
}

ClassMethod List(itmjs As %Library.String = "", itmjsex As %Library.String = "", job, gnum) As %Library.String
{
  q:+$g(job)=0 -1 ; 修改 2016-01-13 加判断 DingSH 
  q:(+($g(gnum)<0)!(gnum="")) -1  ;修改 2016-01-13 加判断 DingSH 
  q:$d(^TemInsuAudit("Audit"))=0 -1 ;修改 2016-01-13 加判断 DingSH 
 s str=$g(^TemInsuAudit("Audit",job,gnum)) ;修改 2016-01-13 加$g() DingSH
 q str
}

// 入参医嘱ID

// 返回 整包装数量 计价单位 计价单位ID

// w ##class(web.INSUAuditOP).GetPackAndQty("2041||3)

ClassMethod GetPackAndQty(OrderDr) As %Library.String
{
	s OrderID=+OrderDr
	s SubID=$P(OrderDr,"||",2)
	s ArcimID=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",2)
	s OrderPackQty=$P($G(^OEORD(OrderID,"I",SubID,9)),"^",4)
	s ARCIMBillingUOM=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),8),"^",14) 
	q:ARCIMBillingUOM="" "^^"
	s OrderPackUOM=$p($g(^CT("UOM",ARCIMBillingUOM)),"^",2)
	s ProtocolPackUOMDR=$p($g(^OEORD(OrderID,"I",SubID,"DHC")),"^",13)
	i ProtocolPackUOMDR'="" d
	. s ARCIMBillingUOM=ProtocolPackUOMDR
	. s OrderPackUOM=$p($g(^CT("UOM",ARCIMBillingUOM)),"^",2)
	s OrderPackQty=$P($G(^OEORD(OrderID,"I",SubID,9)),"^",4)
	s ItemCatDr=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",10) 
	if ItemCatDr'="" d
	.s OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
	.i OrderType'="R" d
	..s DoseqtySum=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",12)
	..s OrderPackQty=DoseqtySum
	q OrderPackQty_"^"_OrderPackUOM_"^"_ARCIMBillingUOM
}

/// Description: 医嘱对应收费项金额
/// Input: oeitm:OE_OrdItem.RowId, insTypeId:PAC_AdmReason.RowId, priceDate:取价格日期, hospId:CT_Hospital.RowId
/// Return: 
ClassMethod GetOrdTarItmCost(OEORIRowid As %String, InsTypeDR As %String, PriceDate As %String, HospId As %String)
{
	   set TotalAmt=0
		set DiscAmt=0
		set PayorAmt=0
		kill tmptariAry
		do ##class(BILL.OP.COM.Method).GetOrdTarItmCost(OEORIRowid, InsTypeDR, PriceDate, HospId, .tmptariAry)
		set tmptari=0
		while($o(tmptariAry(tmptari))) {
			set tmptari=$o(tmptariAry(tmptari))
			set tariData=$g(tmptariAry(tmptari))
			set tarTotalAmt=$lg(tariData,1)
			set tarDiscAmt=$lg(tariData,2)
			set tarPayorAmt=$lg(tariData,3)
			set TotalAmt=$i(TotalAmt, tarTotalAmt)
			set DiscAmt=$i(DiscAmt, tarDiscAmt)
			set PayorAmt=$i(PayorAmt, tarPayorAmt)
		}
		kill tmptariAry
		set TotalAmt=$fn(TotalAmt,"",2)
		set DiscAmt=$fn(DiscAmt,"",2)
		set PayorAmt=$fn(PayorAmt,"",2)
		set PatAmt=$fn((TotalAmt-DiscAmt-PayorAmt),"",2)
		
		q TotalAmt_"^"_PatAmt_"^"_DiscAmt_"^"_PayorAmt
}

/*
ClassMethod OPAuditAppExecuteOld(RegNo, StartDate, EndDate, CheckAuditType, RType, Price800) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s i=0
 	i StartDate="" s StartDate=+$H
	i EndDate="" s EndDate=+$H
	s ^GuoAuditOP("AuditOP")=RegNo_","_StartDate_","_EndDate_","_CheckAuditType_","_RType_","_Price800
	;w CheckAuditType_"_"_RType_"_"_Price800
	;"全部价钱","1,"800以下","2","800以上","3"
	;"全部","1","门特","2","特检特治","3",DHC_OE_OrdItem.DHCORI_ApproveType
	
	
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s TmpPrintFlag=1
	s TabArcimDescStr3="",TabArcimDescStr4="",TabTotalAmount3="",TabTotalAmount4="",TabArcimDescStrT="",TabTotalAmountT=""
	i RegNo'="" d
	.i $l(+RegNo)>0 d
	..s tmpRegNo="000000000"_RegNo
	..s RegNo=$Extract(tmpRegNo,$l(tmpRegNo)-9,$l(tmpRegNo))
	.s PapmiDr=""
	.s PapmiDr=$o(^PAPERi("PAPMI_PatNo",RegNo,PapmiDr))  ;$$ALPHAUP
	.q:PapmiDr=""
	.s PaadmType=""
	.f  s PaadmType=$o(^PAPERdr(PapmiDr,"ADM",PaadmType)) q:PaadmType=""  d
	..q:PaadmType="I"			;判断住院 or 门诊
	..s PaadmDr=""
	..f  s PaadmDr=$o(^PAPERdr(PapmiDr,"ADM",PaadmType,PaadmDr)) q:PaadmDr=""  d
	...s (visitstatus,Type,TabRegNo,TabPatName,TabCTDesc,TabPatType,TabDiagDesc,TabPrescNo,TabOEORIDate,TabOEORITimeOrd,TabOEORIDoctorDesc,TabPrescPrice,TabOEORIPhQty,TabTotalAmount,TabArcimDesc,TabPhcfrCode,TabDoseQtyUnit,TabPhOrdQtyUnit,TabPackNum,TabAuditFlag,TabOEORIRowId)=""
	...s (PaSex,Age,IPNO,TabTotalAmount3,company,TabArcimDescStr3)=""
	...s PaadmInfo=$g(^PAADM(PaadmDr))
	...q:PaadmInfo=""
	...s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(PaadmDr) 
	...s visitstatus=$p($g(^PAADM(PaadmDr)),"^",20)
	...q:(visitstatus="")||(visitstatus="C")
	...s Type=$p($g(^PAADM(PaadmDr)),"^",2)
	...s TabRegNo=$p(^PAPER(+^PAADM(PaadmDr),"PAT",1),"^",1)			;1登记号
	...s TabPatName=$p(^PAPER(+^PAADM(PaadmDr),"ALL"),"^",1)			;2姓名
	...s TabPatNo=$p(^PAPER(+^PAADM(PaadmDr),"ALL"),"^",19)			    ;3个人编号
	...s TabPatID=$p(^PAPER(+^PAADM(PaadmDr),"ALL"),"^",9)			    ;3身份证号
	...s ADMDate=$zd($p(^PAADM(PaadmDr),"^",6),3)
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
	...;modefy by zhangdongliang at 2017-08-25 for 只显示医保费别的数据
	...q:+admReasonSource<1
	...;q:admReasonNational'=1
	...;s TabDiagDesc=##Class(web.DHCNurInsAudit).GetMRDiagnos(PaadmDr)	;5诊断	
	...;w TabRegNo_"^"_TabPatName_"^"_TabCTDesc_"^"_TabPatType_"^"_TabDiagDesc,!
	...s MRAdmDr=$p(^PAADM(PaadmDr),"^",61)
	...;modefy by zhangdongliang at 2015-10-12 for取诊断信息，调用函数实现。
	...;s childsub="0"
	...;f  s childsub=$o(^MR(MRAdmDr,"DIA",childsub))   q:childsub=""  d
	...;.s mrciddx=$p(^MR(MRAdmDr,"DIA",childsub),"^",1)
	...;.s:mrciddx'="" TabDiagDesc=$p(^MRC("ID",mrciddx),"^",2) ;_"|"_$p(^MRC("ID",mrciddx),"^",1)
	...s TabDiagDesc=##class(web.DHCMRDiagnos).GetMRDiagnosDesc(MRAdmDr,"|")
	...;end
	...s OEORDDr=""
	...f  s OEORDDr=$o(^OEORD(0,"Adm",PaadmDr,OEORDDr)) q:OEORDDr=""  d
	....s OEORIDr=""
	....f  s OEORIDr=$o(^OEORD(OEORDDr,"I",OEORIDr)) q:OEORIDr=""  d
	.....s (TabPrescNo,TabOEORIDate,TabOEORITimeOrd,TabOEORIDoctorDesc,TabPrescPrice,TabOEORIPhQty,TabTotalAmount,TabArcimDesc,TabPhcfrCode,TabDoseQtyUnit,TabPhOrdQtyUnit,TabPackNum,TabAuditFlag,TabOEORIRowId)=""
	.....s (AuditUserDr,TabAuditUserName,TabAuditDate,TabAuditTime,YNFlag)=""
	.....s YNFlagType="普通"
	.....s OEORIRowId=OEORDDr_"||"_OEORIDr
	.....;add by gn 2017-07-27   
	.....;q:$d(^DHCOPIPADMCON("OPADMORDER","OPAdm",PaadmDr,OEORIRowId))>0
	.....q:+##class(web.DHCBillInterface).IOrdIsOPToIPByOEORI(OEORIRowId)>0
	.....;end gn  过滤门诊转住院的医嘱
	.....s TabOEORIRowId=OEORIRowId										;19找明细用的医嘱明细表rowid
	.....s BBExtCode=$p($g(^OEORD(OEORDDr,"I",OEORIDr,11)),"^",18)     ;2011 08 29 wty 存放的是费别，用于取特病(费别与处方类型对应，医保病人可能看自费或者医保)
	.....s DHCORIDr="",TabAuditFlag="",TabAuditUserName="",TabAuditDate="",TabAuditTime=""
	.....s DHCORIDr=$o(^DHCORDItem(0,OEORIRowId,DHCORIDr))
	.....q:(RType'=1)&(RType'="")&(DHCORIDr="")
	.....i DHCORIDr'="" d
	......s YNFlag=$p($g(^DHCORDItem(DHCORIDr,2)),"^",8)	;DHCORI_ApproveType		;判断是否需要审批
	......;q:(YNFlag'="3")&(YNFlag'="4")  ;3特检特治 4门特
	......s:YNFlag="3" YNFlagType="特检特治"
	......s:YNFlag="4" YNFlagType="门诊特病"
	......q:((RType'=1)&(RType'=""))&(RType'=YNFlag)
	......s TabAuditFlag=$p($g(^DHCORDItem(DHCORIDr,3)),"^",1)			;18判断审批是否通过标志位置
	......s:TabAuditFlag="Y" TabAuditFlag="审核通过"
	......s:TabAuditFlag="N" TabAuditFlag="审核未通过"
	......s AuditUserDr=$p($g(^DHCORDItem(DHCORIDr,3)),"^",4)			;20审核人
	......i AuditUserDr'="" d
	.......s TabAuditUserName=$p($g(^SSU("SSUSR",AuditUserDr)),"^",2)
	.......s TabAuditDate=$zd($p($g(^DHCORDItem(DHCORIDr,3)),"^",2),3)			;21审核日期
	.......s TabAuditTime=$zt($p($g(^DHCORDItem(DHCORIDr,3)),"^",3),1)			;22审核时间
	.....q:((RType'=1)&(RType'=""))&(RType'=YNFlag)
	.....q:(CheckAuditType="")&&(TabAuditFlag'="")
	.....q:(CheckAuditType'="")&&(TabAuditFlag="")
	.....;Zhan 20160414，不显示停止和作废的医嘱
	.....s ordstr1=$g(^OEORD(OEORDDr,"I",OEORIDr,1))
	.....s OrdStatusDR=$p(ordstr1,"^",13)
	.....s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
	.....s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
	.....q:"U,D"[OrdStatusCode
	.....;add by zhangdongliang at 2016-10-18 for 已收费医嘱不再显示，因为门诊审核功能是放在收费之前，未审核禁止结算。
	.....s OEORIBilled=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",5)
	.....q:OEORIBilled="P"
	.....;end

	.....;s TabPrescNo=YNFlagType ;$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",14)		;6处方号
	.....s TabPrescNo=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",14)		;6处方号
	.....s TabOEORIDate=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",7)		;7开医嘱日期
	.....s TabOEORITimeOrd=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",17)		;8开医嘱时间
	.....q:(TabOEORIDate<StartDate)!(TabOEORIDate>EndDate)
	.....s TabOEORIDate=$zd(TabOEORIDate,3)
	.....s TabOEORITimeOrd=$zt(TabOEORITimeOrd,1)
	.....;modefy by zhangdongliang at 2016-09-29 for 此处没有问题，应该显示的是开医嘱医生，而不是下医嘱人。
	.....s TabOEORIDoctorDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",11)	
	.....i TabOEORIDoctorDR="" d
	......s TabOEORIDoctorDesc=""
	.....e  d
	......s TabOEORIDoctorDesc=$p($g(^CTPCP(TabOEORIDoctorDR,1)),"^",2)		;9开医嘱人（可以是护士、收费员等）
	.....;s OrderMesage=##class(web.DHCDocOrderCommon).GetOrderMesage(OEORIRowId)
	.....;s TabOEORIDoctorDesc=$p(OrderMesage,"^",15)
	.....;end
	.....;s OEORIPhQtyOrd=##Class(web.DHCCLCom).GetOrderBaseQty(OEORIRowId)	
	.....//s OEORIPhQtyOrd=$p(##class(web.DHCINSUPortUse).GetOEQty(OEORIRowId),"^",1) //- DingSH 20200604
	.....s OEORIPhQtyOrd=$p($g(^OEORD(OEORDDr,"I",OEORIDr,9)),"^",4)	     //整包数量 OEORIQtyPackUOM
	.....s TabOEORIPhQty=OEORIPhQtyOrd										;11医嘱数量
	.....s ItmMastDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",2)
	.....s arcimId=ItmMastDR
	.....;s Flag=##class(web.INSUAudit).ArcimLinkInsuList(ItmMastDR, admReasonDr)
	.....;q:Flag'="Y"                                   ;没有特检特治不显示				
	.....i ItmMastDR="" d
	......s TabPrescPrice=""
	.....e  d
	......s tmpTabPrescPrice=+$p(^OEORD(OEORDDr,"I",OEORIDr,3),"^",25)
	......;modefy by zhangdongliang at 2017-03-01 for 取药品批次价格
	......b ;g1
	......;ExpStr:挂号优惠设置^医嘱RowID^执行记录RowID^就诊RowID^接收科室RowID^
	......s ExpStr=""_"^"_OEORIRowId_"^"_""_"^"_PaadmDr_"^"_""_"^"_""
	......s TabPrescPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("",admReasonDr,ItmMastDR,+$h,"","","","",HospDr,ExpStr),"^",4)	
	......s:(TabPrescPrice'=tmpTabPrescPrice)&(tmpTabPrescPrice'=0) TabPrescPrice=tmpTabPrescPrice
	......s TabPrescPrice=$fn(TabPrescPrice,"",4)								;10医嘱单位价格	
	......;s:tmpTabPrescPrice'=TabPrescPrice TabPrescPrice=tmpTabPrescPrice
	......s TabTotalAmount=$fn(TabPrescPrice*OEORIPhQtyOrd,"",4)				;12医嘱总价  
	......b ;g2
	......s TabArcimDesc=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",2)	;13医嘱名称2
	
	......s phcfrId=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",4)				
	......q:phcfrId=""
	......s TabPhcfrCode=$p($g(^PHCFR(phcfrId)),"^",3) 							;14医嘱频次                                                              	
   	......s doseQty=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",1)                           
	......i doseQty'="" s unitUomId=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",3)   
	......;add by zhangdongliang at 2015-10-12 for初始化变量
	......s unitDesc=""      
	......;end  
	......i $g(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)		           	
	......;modefy by zhangdongliang at 2016-10-10 for 当doseQty不为空时，TabDoseQtyUnit才能赋值。  
	......i doseQty'="" d       
	.......s TabDoseQtyUnit=$g(doseQty)_" "_$g(unitDesc)							;15剂量
	......;end
	......s phOrdQty=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",12)                 
	......;modefy by zhangdongliang at 2016-10-10 for 当phOrdQty不为空时，TabPhOrdQtyUnit才能赋值。
	......i phOrdQty'="" d  
	.......s TabPhOrdQtyUnit=phOrdQty_" "_$g(unitDesc)							;16总量	
	.......;modefy by zhangdongliang at 2019-02-20 for 总量改为使用医生站开医嘱界面总量字段
	.......s CNMedItemFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(ItmMastDR,HospDr)
	.......i CNMedItemFlag="0" d 
	........s PackAndQty=..GetPackAndQty(OEORIRowId)
	........s TabPhOrdQtyUnit=$p(PackAndQty,"^",1)_" "_$p(PackAndQty,"^",2)
   	......;end
  	......;s TabPackNum=##Class(web.DHCNurDrugAudit).GetPackQty(OEORDDr,OEORIDr)	;17整包数量  //- DingSH 20200604
  	......//s TabPackNumstr=##class(web.DHCINSUPortUse).GetOEQty(OEORIRowId)	        ;Zhan 20160414
  	......//s TabPackNum=$p(TabPackNumstr,"$",3)
  	......;s:$p($p(TabPackNumstr,"$",4),"^",2)'="" TabPackNum=$tr($p(TabPackNumstr,"$",4),"^","|")
  	......//s:$p($p(TabPackNumstr,"$",4),"^",2)'="" TabPackNum=$p(TabPackNumstr,"$",4)
  	......//s TabPackNum=$tr(TabPackNum,"^","|")
  	......s TabPackNum=$p($g(^OEORD(OEORDDr,"I",OEORIDr,9)),"^",4)	     //整包数量 OEORIQtyPackUOM
  	
  	......i (phOrdQty'="")&&(doseQty="") d  
	.......s TabPhOrdQtyUnit="" //phOrdQty_" "_$p($p(TabPackNumstr,"$",1),"^",2) //20200604
	.....DO OutPatPresc
	
	s i=0
	i RegNo="" d
	.f PAADMDate=StartDate:1:EndDate d
	..s PaadmDr="",ADMDate=$zd(PAADMDate,3)
	..f  s PaadmDr=$o(^PAADMi("PAADM_AdmDate",PAADMDate,PaadmDr)) q:PaadmDr=""  d
	...s visitstatus="",Type="",TabRegNo="",TabPatName="",TabCTDesc="",TabPatType="",TabDiagDesc="",TabPrescNo="",TabOEORIDate="",TabOEORITimeOrd="",TabOEORIDoctorDesc="",TabPrescPrice="",TabAuditFlag=""
	...s TabArcimDescStr3="",TabArcimDescStr4="",TabTotalAmount3="",TabTotalAmount4="",TabArcimDescStrT="",TabTotalAmountT=""
	...s (PaSex,Age,IPNO)=""
	...s PaadmInfo=$g(^PAADM(PaadmDr))
	...q:PaadmInfo=""
	...s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(PaadmDr) 
	...s visitstatus=$p($g(^PAADM(PaadmDr)),"^",20)
	...q:(visitstatus="")||(visitstatus="C")
	...s Type=$p($g(^PAADM(PaadmDr)),"^",2)
	...q:Type="I"
	...s TabRegNo=$p(^PAPER(+^PAADM(PaadmDr),"PAT",1),"^",1)			;1登记号
	...s TabPatName=$p(^PAPER(+^PAADM(PaadmDr),"ALL"),"^",1)			;2姓名
	...;s TabPatNo=$p(^PAPER(+^PAADM(PaadmDr),"ALL"),"^",19)			;3医保个人编号
	...s Papmidr=$p($g(^PAADM(PaadmDr)),"^",1)
	...s PAPMIHealthFundNo=$p($g(^PAPER(Papmidr,"PAT",3)),"^",12)   //modefy by zhangdongliang at 2017-08-07 需求序号: 421565 医保手册号取PAPMI_HealthFundNo字段
	...s TabPatNo=PAPMIHealthFundNo
	...s TabPatID=$p(^PAPER(+^PAADM(PaadmDr),"ALL"),"^",9)			;3身份证号
	...s Dob=$p(^PAPER(+^PAADM(PaadmDr),"ALL"),"^",6)       //生日
	...s Age=$$CalAge^DHCINSUPatInfo(Dob,$h)                    //年龄
	...s PaSex=$p(^PAPER(+^PAADM(PaadmDr),"ALL"),"^",7) //
	...s PaSex=$p(^CT("SEX",PaSex),"^",2)        //性别
	...s Tel=$p(^PAPER(+^PAADM(PaadmDr),"PER",1),"^",1)   //电话
	...s company=$g(^PAPER(+^PAADM(PaadmDr),"PER","ADD",1)) //工作单位
	...s TabPatID=$p(^PAPER(+^PAADM(PaadmDr),"ALL"),"^",9) //身份证号
	...s:TabPatID="" TabPatID=$p($g(^PAPER($p(^PAADM(PaadmDr),"^",1),"PAT",3)),"^",6)	;身份证号
	...;if TabPatID=""  w ^PAPER($p(^PAADM(PaadmDr),"^",1),"PAT",3)
	...s IPNO=$p(^PAADM(PaadmDr),"^",81) //就诊号
	...s INADMRowid=$o(^DHCINADM("0","ADM",PaadmDr,""),-1)
	...I INADMRowid'="" D
	....s company=$p($G(^DHCINADM(INADMRowid)),"^",6) ;单位
	....s TabPatID=$p($G(^DHCINADM(INADMRowid)),"^",34) ;身份证号
	....s PaSex=$p($G(^DHCINADM(INADMRowid)),"^",36)    //性别
	...s CTLocDr=$p($g(^PAADM(PaadmDr)),"^",4)
	...i CTLocDr="" d
	....s TabCTDesc=""
	...e  d
	....s TabCTDesc=$p(^CTLOC(CTLocDr),"^",2)							;3科室描述
	...s admReasonDr=$P($g(^PAADM(PaadmDr,1)),"^",7)
	...q:admReasonDr=""
	...q:admReasonDr=1
	...s TabPatType=$P($G(^PAC("ADMREA",admReasonDr)),"^",2)			;4病人类型
	...s admReasonSource=$P($g(^PAC("ADMREA",admReasonDr)),"^",9)
	...s admReasonNational=$P($g(^PAC("ADMREA",admReasonDr)),"^",5)
	...;q:admReasonNational'=1
	...;modefy by zhangdongliang at 2017-08-25 for 只显示医保费别的数据
	...q:+admReasonSource<1
	...;s TabDiagDesc=##Class(web.DHCNurInsAudit).GetMRDiagnos(PaadmDr)	;5诊断 wty 20110823
	...s MRAdmDr=$p(^PAADM(PaadmDr),"^",61)
	...;modefy by zhangdongliang at 2015-10-12 for取诊断信息，调用函数实现。
	...;s childsub="0"
	...;f  s childsub=$o(^MR(MRAdmDr,"DIA",childsub))   q:childsub=""  d
	...;.s mrciddx=$p(^MR(MRAdmDr,"DIA",childsub),"^",1)
	...;.q:mrciddx=""
	...;.s TabDiagDesc=$p(^MRC("ID",mrciddx),"^",2) ;_"|"_$p(^MRC("ID",mrciddx),"^",1)
	...s TabDiagDesc=##class(web.DHCMRDiagnos).GetMRDiagnosDesc(MRAdmDr,"|")
	...;end
	
	...s OEORDDr=""
	...f  s OEORDDr=$o(^OEORD(0,"Adm",PaadmDr,OEORDDr)) q:OEORDDr=""  d
	....s OEORIDr=""
	....f  s OEORIDr=$o(^OEORD(OEORDDr,"I",OEORIDr)) q:OEORIDr=""  d
	.....s (TabPrescNo,TabOEORIDate,TabOEORITimeOrd,TabOEORIDoctorDesc,TabPrescPrice,TabOEORIPhQty,TabTotalAmount,TabArcimDesc,TabPhcfrCode,TabDoseQtyUnit,TabPhOrdQtyUnit,TabPackNum,TabAuditFlag,TabOEORIRowId)=""
	.....s (AuditUserDr,TabAuditUserName,TabAuditDate,TabAuditTime,YNFlag)=""
	.....s YNFlagType="普通"
	.....s OEORIRowId=OEORDDr_"||"_OEORIDr
	.....s TabOEORIRowId=OEORIRowId										;19找明细用的医嘱明细表rowid
	.....;add by gn 2017-07-27   
	.....;q:$d(^DHCOPIPADMCON("OPADMORDER","OPAdm",PaadmDr,OEORIRowId))>0
	.....q:+##class(web.DHCBillInterface).IOrdIsOPToIPByOEORI(OEORIRowId)>0
	.....;end gn  过滤门诊转住院的医嘱
	.....;s BBExtCode=$p($g(^OEORD(OEORDDr,"I",OEORIDr,11)),"^",18)     ;2011 08 29 wty 存放的是费别，用于取特病(费别与处方类型对应，医保病人可能看自费或者医保)
	.....s DHCORIDr="",TabAuditFlag="",TabAuditUserName="",TabAuditDate="",TabAuditTime=""
	.....s DHCORIDr=$o(^DHCORDItem(0,OEORIRowId,DHCORIDr))
	.....q:(RType'=1)&(RType'="")&(DHCORIDr="")
	.....i DHCORIDr'="" d
	......s YNFlag=$p($g(^DHCORDItem(DHCORIDr,2)),"^",8)	;DHCORI_ApproveType		;判断是否需要审批
	......;q:(YNFlag'="3")&(YNFlag'="4")  ;3特检特治 4门特
	......s:YNFlag="3" YNFlagType="特检特治"
	......s:YNFlag="4" YNFlagType="门诊特病"

	......s TabAuditFlag=$p($g(^DHCORDItem(DHCORIDr,3)),"^",1)			;18判断审批是否通过标志位置
	......s:TabAuditFlag="Y" TabAuditFlag="审核通过"
	......s:TabAuditFlag="N" TabAuditFlag="审核未通过"
	......s AuditUserDr=$p($g(^DHCORDItem(DHCORIDr,3)),"^",4)			;20审核人
	......i $g(AuditUserDr)'="" d
	.......s TabAuditUserName=$p($g(^SSU("SSUSR",AuditUserDr)),"^",2)
	.......s TabAuditDate=$zd($p($g(^DHCORDItem(DHCORIDr,3)),"^",2),3)			;21审核日期
	.......s TabAuditTime=$zt($p($g(^DHCORDItem(DHCORIDr,3)),"^",3),1)			;22审核时间
	.....q:((RType'=1)&(RType'=""))&(RType'=YNFlag)
	.....q:(CheckAuditType="")&&(TabAuditFlag'="")
	.....q:(CheckAuditType'="")&&(TabAuditFlag="")
	.....;Zhan 20160414，不显示停止和作废的医嘱
	.....s ordstr1=$g(^OEORD(OEORDDr,"I",OEORIDr,1))
	.....s OrdStatusDR=$p(ordstr1,"^",13)
	.....s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
	.....s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
	.....q:"U,D"[OrdStatusCode
	.....;add by zhangdongliang at 2016-10-18 for 已收费医嘱不再显示，因为门诊审核功能是放在收费之前，未审核禁止结算。
	.....s OEORIBilled=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",5)
	.....q:OEORIBilled="P"
	.....;end
	
	.....;s TabPrescNo=YNFlagType ;$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",14)		;6处方号
	.....s TabPrescNo=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",14)		;6处方号
	.....s TabOEORIDate=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",7)		;7开医嘱日期
	.....s TabOEORITimeOrd=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",17)		;8开医嘱时间
	.....q:(TabOEORIDate<StartDate)!(TabOEORIDate>EndDate)
	.....;b ;12
	.....s TabOEORIDate=$zd(TabOEORIDate,3)
	.....s TabOEORITimeOrd=$zt(TabOEORITimeOrd,1)
	.....s TabOEORIDoctorDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",11)	
	.....i TabOEORIDoctorDR="" d
	......s TabOEORIDoctorDesc=""
	.....e  d
	......s TabOEORIDoctorDesc=$p($g(^CTPCP(TabOEORIDoctorDR,1)),"^",2)		;9开医嘱医生
	
	.....;s OEORIPhQtyOrd=##Class(web.DHCCLCom).GetOrderBaseQty(OEORIRowId)		
	.....//s OEORIPhQtyOrd=$p(##class(web.DHCINSUPortUse).GetOEQty(OEORIRowId),"^",1)
	.....s OEORIPhQtyOrd=$p($g(^OEORD(OEORDDr,"I",OEORIDr,9)),"^",4)	     //整包数量 OEORIQtyPackUOM
	.....s TabOEORIPhQty=OEORIPhQtyOrd										;11医嘱数量
	.....s ItmMastDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",2)
	.....s arcimId=ItmMastDR
	.....;s Flag=##class(web.INSUAudit).ArcimLinkInsuList(ItmMastDR, admReasonDr)
	.....;q:Flag'="Y"          ;没有特检特治不显示（医生站已经控制，这里可以不判断）
	.....i ItmMastDR="" d
	......s TabPrescPrice=""
	.....e  d
	......s tmpTabPrescPrice=+$p(^OEORD(OEORDDr,"I",OEORIDr,3),"^",25)	;Zhan 20160323自定义价格，下边的接口有坑
	......;modefy by zhangdongliang at 2017-03-01 for 取药品批次价格
	......;ExpStr:挂号优惠设置^医嘱RowID^执行记录RowID^就诊RowID^接收科室RowID^
	......s ExpStr=""_"^"_OEORIRowId_"^"_""_"^"_PaadmDr_"^"_""_"^"_""
	......s TabPrescPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("",admReasonDr,ItmMastDR,+$h,"","","","",HospDr,ExpStr),"^",4)	
	......s:(TabPrescPrice'=tmpTabPrescPrice)&(tmpTabPrescPrice'=0) TabPrescPrice=tmpTabPrescPrice
	......s TabPrescPrice=$fn(TabPrescPrice,"",4)								;10医嘱单位价格
	......;s:+TabPrescPrice=0 TabPrescPrice=$p(^OEORD(OEORDDr,"I",OEORIDr,3),"^",25)	
	......;s tmpTabPrescPrice=$fn($p(^OEORD(OEORDDr,"I",OEORIDr,3),"^",25),"",4)
	......;s:tmpTabPrescPrice'=TabPrescPrice TabPrescPrice=tmpTabPrescPrice
	......s TabTotalAmount=$fn(TabPrescPrice*OEORIPhQtyOrd,"",4)				;12医嘱总价  
	......s TabArcimDesc=$p(^ARCIM(+arcimId,+$p(arcimId,"||",2),1),"^",2)	;13医嘱名称3
	......s TabArcimDescStrT=TabArcimDesc_"||"_TabArcimDescStrT  ;DingSH 20160513 批量打印医嘱项目
	......s TabTotalAmountT=+TabTotalAmountT+TabTotalAmount      ;DingSH 20160513 批量打印医嘱项目
	......i $G(YNFlag)="3" d ;
	.......s TabArcimDescStr3=TabArcimDesc_"||"_TabArcimDescStr3
	.......s TabTotalAmount3=+TabTotalAmount3+TabTotalAmount
	.......s DISrowid=""
 	.......&sql(select DIS_Rowid into :DISRowid from DHCRBC_IllStatus where DIS_Oeorditem_DR =:OEORIRowId and DIS_PaAdm_DR=:PaadmDr)
 	.......i DISRowid'=""  d
 	........s INRPTZZ=$p(^DHCRBCApp("IllStatus",DISRowid),"^",3)					;症状
	......i $G(YNFlag)="4" d
	.......s TabArcimDescStr4=TabArcimDesc_"||"_TabArcimDescStr4
	.......s TabTotalAmount4=+TabTotalAmount4+TabTotalAmount
	.......i $d(^OEORD(OEORDDr,"I",OEORIDr,"DHC"))=1 s DigCodedr=$p(^OEORD(OEORDDr,"I",OEORIDr,"DHC"),"^",23)
	.......;b ;2
	.......I $g(DigCodedr)'="" D
	........s str=$$sBuildData^DHCINSUDicData(DigCodedr)
	........s TabDiagDesc=$p(str,"^",4)									;
	.......s INRPTRowid=$o(^INSURPT("0","OEORD",OEORIRowId,""),-1)
	.......Q:INRPTRowid=""
	.......s INRPTZZ=$p(^INSURPT(INRPTRowid),"^",38)					;症状

	......s phcfrId=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",4)				
	......q:phcfrId=""
	......s TabPhcfrCode=$p($g(^PHCFR(phcfrId)),"^",3) 							;14医嘱频次                                                              	
   	......s doseQty=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",1)                           
	......i doseQty'="" s unitUomId=$p($g(^OEORD(OEORDDr,"I",OEORIDr,2)),"^",3)  
	......;add by zhangdongliang at 2015-10-12 for初始化变量
	......s unitDesc=""      
	......;end           
	......i $g(unitUomId)'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)		
	......;modefy by zhangdongliang at 2016-10-10 for 当doseQty不为空时，TabDoseQtyUnit才能赋值。  
	......i doseQty'="" d       
	.......s TabDoseQtyUnit=$g(doseQty)_" "_$g(unitDesc)							;15剂量
	......;end
	......s phOrdQty=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",12)                 
	......;modefy by zhangdongliang at 2016-10-10 for 当phOrdQty不为空时，TabPhOrdQtyUnit才能赋值。
	......i phOrdQty'="" d  
	.......s TabPhOrdQtyUnit=phOrdQty_" "_$g(unitDesc)							;16总量	
   	.......;modefy by zhangdongliang at 2019-02-20 for 总量改为使用医生站开医嘱界面总量字段
	.......s CNMedItemFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(ItmMastDR)
	.......i CNMedItemFlag="0" d 
	........s PackAndQty=..GetPackAndQty(OEORIRowId)
	........s TabPhOrdQtyUnit=$p(PackAndQty,"^",1)_" "_$p(PackAndQty,"^",2)
   	......;end
	
		
	......;end																	;5单价        
  	......;s TabPackNum=##Class(web.DHCNurDrugAudit).GetPackQty(OEORDDr,OEORIDr)	;17整包数量
  	......//s TabPackNumstr=##class(web.DHCINSUPortUse).GetOEQty(OEORIRowId)	;Zhan 20160414
  	......//s TabPackNum=$p(TabPackNumstr,"$",3)
  	......;s:$p($p(TabPackNumstr,"$",4),"^",2)'="" TabPackNum=$tr($p(TabPackNumstr,"$",4),"^","|")
  	......//s:$p($p(TabPackNumstr,"$",4),"^",2)'="" TabPackNum=$p(TabPackNumstr,"$",4)
  	......//s TabPackNum=$tr(TabPackNum,"^","|")
  	......s TabPackNum=$p($g(^OEORD(OEORDDr,"I",OEORIDr,9)),"^",4)	     //整包数量 OEORIQtyPackUOM
  			
  	......i (phOrdQty'="")&&(doseQty="") d  
	.......s TabPhOrdQtyUnit=phOrdQty_" "_$p($p(TabPackNumstr,"$",1),"^",2)	
  	.....DO OutPatPrescOLD
	
	...;i TmpPrintFlag="1" d
	....;i TabArcimDescStr3'="" d
  	.....;s i=i+1
  	.....;s ^TemInsuAudit("Audit",$j,i)="3"_"^"_TabPatName_"^"_PaSex_"^"_Age_"^"_TabDiagDesc_"^"_IPNO_"^"_TabCTDesc_"^"_TabPatNo_"^"_$zd(PAADMDate,3)_"^"_TabTotalAmount3_"^"_company_"^"_TabArcimDescStr3_"^"_TabPatType_"^"_TabOEORIDate_"^"_INRPTZZ
  	....;i TabArcimDescStr4'="" d
  	.....;s i=i+1
  	.....;s ^TemInsuAudit("Audit",$j,i)="4"_"^"_TabPatName_"^"_PaSex_"^"_Age_"^"_TabDiagDesc_"^"_IPNO_"^"_TabCTDesc_"^"_TabPatNo_"^"_$zd(PAADMDate,3)_"^"_TabTotalAmount4_"^"_company_"^"_TabArcimDescStr4_"^"_TabPatType_"^"_TabOEORIDate_"^"_INRPTZZ
  	
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
 
OutPatPrescOLD
  	s i=i+1
  	i ADMDate'="" d
  	.s:$l(ADMDate,"-")=3 tmpADMDate=$zdh(ADMDate,3)
  	.s:$l(ADMDate,"/")=3 tmpADMDate=$zdh(ADMDate,4)
  	.s ADMDate=##class(websys.Conversions).DateLogicalToHtml(tmpADMDate)
  	i TabOEORIDate'="" d
  	.s tmpTabOEORIDate=$zdh(TabOEORIDate,3)
  	.s TabOEORIDate=##class(websys.Conversions).DateLogicalToHtml(tmpTabOEORIDate)
  	i TabAuditDate'="" d
  	.s tmpTabAuditDate=$zdh(TabAuditDate,3)
  	.s TabAuditDate=##class(websys.Conversions).DateLogicalToHtml(tmpTabAuditDate)
  	s ^TemInsuAudit("Audit",$j,i)=$G(YNFlag)_"^"_TabPatName_"^"_PaSex_"^"_Age_"^"_TabDiagDesc_"^"_IPNO_"^"_TabCTDesc_"^"_TabPatNo_"^"_ADMDate_"^"_TabTotalAmountT_"^"_company_"^"_TabArcimDescStrT_"^"_TabPatType_"^"_TabOEORIDate_"^"_$g(INRPTZZ)

	q:(Price800=2)&(TabTotalAmount>800) 
	q:(Price800=3)&(TabTotalAmount<=800) 
	;modefy by zhangdongliang at 2016-10-10 for 当总量为空时，显示空，不再显示0
	;s:$p(TabPhOrdQtyUnit,".",1)="" TabPhOrdQtyUnit="0"_TabPhOrdQtyUnit
	;end
	set Data=$lb(TabRegNo,TabPatName,TabPatNo,TabPatID,TabCTDesc,TabPatType,TabDiagDesc,TabPrescNo,TabOEORIDate,TabOEORITimeOrd,TabOEORIDoctorDesc,TabPrescPrice,TabOEORIPhQty,TabTotalAmount,TabArcimDesc,TabPhcfrCode,TabDoseQtyUnit,TabPhOrdQtyUnit,TabPackNum,TabAuditFlag,TabOEORIRowId,TabAuditUserName,TabAuditDate,TabAuditTime,$j,YNFlagType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}*/
}
