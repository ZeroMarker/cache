Import sqluser

/// Creator：      LouLina
/// CreatDate：    2011-10-12
/// Description:   住院医保医嘱审核功能 包括在院,出院未结算,出院已结算的病人
Class web.INSUAuditIP Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// Query IPAuditApp(RegNo, StartDate, EndDate, CheckAuditType, DepList, CheckInPat, CheckAuditFlag, ReceiveFlag, MediCare) As %Query(ROWSPEC = "TabRegNo,TabPatName,TabCTDesc,TabPatType,TabDiagDesc,TabAuditFlag,TabAuditUserName,TabAuditDate,TabAuditTime,TabDemo,TabAdmRowid,TabAdmDate,TabDischgDate,TabPoint,TabTolAmount,TabBillDr,TabSex,TabReceiveFlag,TMediCare")

Query IPAuditApp(RegNo, StartDate, EndDate, CheckAuditType, DepList, CheckInPat, CheckAuditFlag, ReceiveFlag, MediCare, HospDr) As %Query(ROWSPEC = "TabCheckFlag,TabRegNo,TabPatName,TabCTDesc,TabPatType,TabDiagDesc,TabAuditFlag,TabAuditUserName,TabAuditDate,TabAuditTime,TabDemo,TabAdmRowid,TabAdmDate,TabDischgDate,TabPoint,TabTolAmount,TabBillDr,TabSex,TabReceiveFlag,TMediCare,TabDays,TabAge,TabConfirmDate,TabInsuStrAuditDate,TabAuditMainInfo,TabVisitStatus,TabPBDateFrom,TabPBDateTo,TabBedCode")
{
}

/// d ##class(%ResultSet).RunQuery("web.INSUAuditIP","IPAuditApp","","2020-04-20","2020-06-15","","","2","","","",2)
/// CheckInPat  在院病人",1  待审核病人",2  已结算病人",3d   
/// CheckAuditFlag  待审核",1   审核中",2   已完成",3 
/// ReceiveFlag    已接收",1    未接收",2
ClassMethod IPAuditAppExecute(ByRef qHandle As %Binary, RegNo, StartDate, EndDate, CheckAuditType, DepList, CheckInPat, CheckAuditFlag, ReceiveFlag = "", MediCare, HospDr) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	k ^CacheTemp("IPAudit",$j)
	i StartDate="" s StartDate=+$H
	i EndDate="" s EndDate=+$H
	s i=1
	;i CheckAuditFlag="" Set qHandle=$lb(0,repid,0) q $$$OK
	s ^HH("IPAuditApp")= RegNo_"\"_StartDate_"\"_EndDate_"\"_CheckAuditType_"\"_DepList_"\"_CheckInPat_"\"_CheckAuditFlag_"\"_ReceiveFlag_"\"_MediCare_"\"_HospDr
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    s RtnStr=$$GetPatList^DHCINSUAuditIP(RegNo, StartDate, EndDate, CheckAuditType, DepList, CheckInPat, CheckAuditFlag, ReceiveFlag, MediCare,HospDr)
    s j=""
    f  s j=$o(^CacheTemp("IPAudit",$j,j)) q:j=""  d 
	.s PaadmDr=$g(^CacheTemp("IPAudit",$j,j))
	.s TabAdmRowid=PaadmDr
	.;s TabAdmDate=$zd($p(^PAADM(PaadmDr),"^",6),3) ;注视掉 2016-01-13 DingSH
	.;s TabDischgDate=$p(^PAADM(PaadmDr),"^",17) 注视掉 2016-01-13 DingSH
	.;s:TabDischgDate'="" TabDischgDate=$zd(TabDischgDate,3) 注视掉 2016-01-13 DingSH
	.; st-DingSH 入院日期和出院日期修改 2016-01-13 DingSH
	.;s TabAdmDate=$p(##class(web.DHCDischargeHistory).GetAdminDateTime(PaadmDr),"^",1)	;入院日期 [离院日期]按护理配置取值
	.;s TabDischgDate=$p(##class(web.DHCDischargeHistory).GetDischargeDateTime(PaadmDr),"^",1)	;出院日期 [离院日期]按护理配置取值
	.; st-DingSH 入院日期和出院日期修改 2016-02-19 DingSH
	.;modefy by zhangdongliang at 2017-03-27 for 变量TabAdmDate 在OutPatPresc 中被篡改，所以此处不适用以Tab开头的变量名
	.;TabAdmDate->AdmDate,TabDischgDate->DischgDate
	.s AdmDate=$p(##class(web.DHCINSUPortUse).GetAdminDateTime(PaadmDr),"^",1)	;入院日期 按护理配置取值
	.s DischgDate=$p(##class(web.DHCINSUPortUse).GetDischargeDateTime(PaadmDr),"^",1)	;离院日期 按护理配置取值
	.s:AdmDate'="" AdmDate=$zd(AdmDate,3)
	.s:DischgDate'="" DischgDate=$zd(DischgDate,3)
	.; ed-DingSH 入院日期和出院日期修改 2016-02-19 DingSH

	.;TabAdmDat可能为空
	.;i TabDischgDate'=""  d
	.;.s TabDays=$zdh(TabDischgDate,3)-$zdh(TabAdmDate,3)    
	.;e    d
	.;.s TabDays=+$h-$zdh(TabAdmDate,3)   
	.s Type=$p($g(^PAADM(PaadmDr)),"^",2)
	.q:(Type'="I")       ;不是住院病人退出
	.s TabRegNo=$p(^PAPER(+^PAADM(PaadmDr),"PAT",1),"^",1)	  //1登记号
	.;s TMediCare=$p(^PAPER(+^PAADM(PaadmDr),"PAT",1),"^",22) //住院号
	.s TMediCare=##class(web.DHCINSUPortUse).IGetMrNoByEpisodeID(PaadmDr,"","") //取病案号 +DingSH 20200512
	.;q:(RegNo'="")&&(RegNo'=MediCare)
	.q:(RegNo'="")&&(RegNo'=TabRegNo)
	.s MediCare=$$ALPHAUP^SSUTIL4(MediCare)
	.q:(MediCare'="")&&(MediCare'=TMediCare)  ;add  2012-01-09  hwq
	.s TabPatName=$p(^PAPER(+^PAADM(PaadmDr),"ALL"),"^",1)			;2姓名
	.s TabSex=$p(^PAPER(+^PAADM(PaadmDr),"ALL"),"^",7)
	.s TabSex=$p(^CT("SEX",TabSex),"^",2)        //性别 2011-10-22
	 .s Dob=$p(^PAPER(+^PAADM(PaadmDr),"ALL"),"^",6)       //生日
 	.s TabAge=$$CalAge^DHCINSUPatInfo(Dob,$h)                    //年龄  add liusf 2012 06 12
	.s CTLocDr=$p($g(^PAADM(PaadmDr)),"^",70) ;改为Ward指针
	.q:(RegNo'="")&&(RegNo'=TabRegNo)&&(RegNo'=TabPatName)
	.q:(MediCare'="")&&(MediCare'=TMediCare)  ;add  2012-01-09  hwq
	.q:(DepList'="")&&(DepList'[CTLocDr) ;科室删选 2011-10-14
	
	
	.;s Flag=##class(web.INSUAuditIP).GetDepListFlag(DepList,CTLocDr)   //add 2012 03 30
	.;w "Flag="_Flag,!
	.;q:Flag="N"
	
	.i CTLocDr="" d
	..s TabCTDesc=""
	.e  d
	..;s TabCTDesc=$p(^CTLOC(CTLocDr),"^",2)							;3科室描述
	..s TabCTDesc=$p(^PAWARD(CTLocDr),"^",2)       ;病区
	.i TabCTDesc[")-"  d
	..s TabCTDesc=$p(TabCTDesc,")-",2)
	.e  d
	..i TabCTDesc["-" d
	...i $l(TabCTDesc,"-")>2  d  s TabCTDesc=$p(TabCTDesc,"-",$l(TabCTDesc,"-"))
	...e  s TabCTDesc=$p(TabCTDesc,"-",2)
	

	.s WardID=$p(^PAADM(PaadmDr),"^",70) //病区
	.i (WardID="") d
	..s WardCode="" 
	..s WardDesc="" 
	.e          d
	..i ('$d(^PAWARD(WardID)))    d
	...s WardCode=""
	...s WardDesc=""
	..e       d
	...s WardCode=$p(^PAWARD(WardID),"^",1)
	...s WardDesc=$p(^PAWARD(WardID),"^",2)
	.s BedID=$p(^PAADM(PaadmDr),"^",73) //床位
	.i (BedID="")!(WardID="") d
	..s BedCode=""
	.e       d
	..i ('$d(^PAWARD(WardID,"BED",$p(BedID,"||",2))))  d
	...s BedCode=""   d
	..e        d
	...s BedCode= $p(^PAWARD(WardID,"BED",$p(BedID,"||",2)),"^",1) 
	
	.s admReasonDr=$P($g(^PAADM(PaadmDr,1)),"^",7)
	.q:admReasonDr=""
	.s TabPatType=$P($G(^PAC("ADMREA",admReasonDr)),"^",2)			;4病人类型
	.s admReasonSource=$P($g(^PAC("ADMREA",admReasonDr)),"^",9)
	.s admReasonNational=$P($g(^PAC("ADMREA",admReasonDr)),"^",5)
	.;b ;ao
	.q:(+admReasonSource<1)&&(+admReasonNational<1)
	.;add by zhangdongliang at 2015-10-12 for 根据医生站接口，取诊断信息描述。
	.s MRadm=$p($g(^PAADM(PaadmDr)),"^",61) 
	.;s TabDiagDesc=$$GetMRDiagnos^DHCINSUPatInfo(28) ;$$GetDiagnosInfoByAdmDr^DHCINSUFacadeBJ(PaadmDr)	;5诊断
	.s DiagInfo=##class(web.DHCMRDiagnos).GetMRDiagnosDesc(MRadm,"|")
	.;s TabDiagDesc=$p(TabDiagDesc,"!",1)
	.s TabDiagDesc=DiagInfo	;$p(TabDiagDesc,"^",3)
	.s PBDr=""
	.f  s PBDr=$o(^DHCPB(0,"ADM",PaadmDr,PBDr)) q:PBDr=""  d
	..s TabPatName=$p(^PAPER(+^PAADM(PaadmDr),"ALL"),"^",1)
    ...b ;t02
	..;-----------此处不使用，需计费修改程序配合
	..;modefy by zhangdongliang at 2014-04-25 for 计费组未导入相关程序，无此函数。
	..;s ConfirmFlag=""
	..;s ConfirmFlag=##class(web.DHCIPBillConfirm).GetConfirmFlag(PBDr)
	..;s confdr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",PBDr,""))     ;add by lilizhi 2013-02-22    住院处审核时间
    ..;i confdr'="" d
    ...;s confflag=$p(^DHCIPBillPatFeeConfirm(confdr),"^",9)
    ...;i confflag="C"  d
    ....;s ConfirmDate=$p(^DHCIPBillPatFeeConfirm(confdr),"^",6)
    ....;s:ConfirmDate'="" ConfirmDate=$zd(ConfirmDate,3)
    ....;s ConfirmTime=$p(^DHCIPBillPatFeeConfirm(confdr),"^",7)
    ....;s:ConfirmTime'="" ConfirmTime=$zt(ConfirmTime)
    ....;s TabConfirmDate=ConfirmDate_"  "_ConfirmTime
	..;q:((CheckAuditFlag="1")||(CheckAuditFlag="2"))&&(ConfirmFlag'="Y") ;待审核或审核中的数据,必须在财务审核之后
	..;w "ConfirmFlag="_ConfirmFlag,!
	..;q:(CheckInPat'="1")&&(ConfirmFlag'="Y")   ;在院病人可查看财务未审核的，其他都查财务审核后的
	..;q:(CheckInPat="1")&&(ConfirmFlag="N") 
	..;q:(ConfirmFlag="N")  ;调试测试
	..;b---------------------
	
	
	..s PrtRowid=""   ;add 2012 02 03
	..s PrtRowid=$o(^DHCINVPRTZY("0","AR",PBDr,PrtRowid))
	..;q:PrtRowid'=""         //add 2012 03 30 liusf
	..s PayedFlag=$p($g(^DHCPB(PBDr)),"^",16)   // add by lilizhi 2012-04-05 原来是通过paadm表判断的，因为一次就诊可能有多张账单，现在通过账单表判断  
	..i PrtRowid=""  d
	...s PrtFlag=""
	..e    d
	...s PrtFlag=$p(^DHCINVPRTZY(PrtRowid),"^",8)   //对应上面中途结算拆分账单的情况
	..;w "PayedFlag="_PayedFlag,!
	..;b
	..;modefy by zhangdongliang at 2016-05-13 for 只使用医保办审核功能。
	..q:(CheckInPat="1")&&(PayedFlag="P")    //add by lilizhi  2013-1-9 查询在院病人，把中途结算的q掉                      
	..q:(CheckInPat="2")&&(PayedFlag="P") 
	..q:(CheckInPat="3")&&(PayedFlag'="P") 
	..;q:(CheckInPat="2")&&(PayedFlag="P")&&((PrtFlag="N")||(PrtFlag="I"))    //add by lilizhi  2012-04-09 如果His已经结算但是没打发票，也放在待审核病人中 
	..q:(CheckInPat="3")&&(PayedFlag="P")&&(PrtFlag'="N")&&(PrtFlag'="I")    //add by lilizhi  2012-04-09 如果His已经结算并且打发票，放在已结算病人中
	..s TabTolAmount=$p($g(^DHCPB(PBDr)),"^",8)
	..;add by zhangdongliang at 2014-06-05 for 增加帐单开始日期、结束日期
	..s TabPBDateFrom=$p($g(^DHCPB(PBDr)),"^",6)
	..s:TabPBDateFrom'="" TabPBDateFrom=$zd(TabPBDateFrom,3)
	..s TabPBDateTo=$p($g(^DHCPB(PBDr)),"^",7)
	..s:TabPBDateTo'="" TabPBDateTo=$zd(TabPBDateTo,3)
	..q:+TabTolAmount=0
	..s TabBillDr=PBDr
	..s TabAuditFlag="",TabDemo="",TabAuditUserName="",TabAuditDate="",TabAuditTime="",TabReceiveFlag=""
	..;add by zhangdongliang at 2014-05-09 for 增加主记录rowid返回值等
	..s TabAuditMainInfo="" s TabVisitStatus=""
	..s AuditDr=""
	..f  s AuditDr=$o(^DHCINAUD("0","PBDr",PBDr,AuditDr)) q:AuditDr=""  d
	...;q:TabAuditFlag'=""
	...s AuditInfo=$p(^DHCINAUD(AuditDr),"^",11)
	...q:AuditInfo'=0		;主记录此字段为0，明细记录为1
	...s TempTabAuditFlag=$p(^DHCINAUD(AuditDr),"^",16)
	...s:TempTabAuditFlag'="" TabAuditFlag=TempTabAuditFlag
	...s TabAuditUserName=$p(^DHCINAUD(AuditDr),"^",13)
	...s TabAuditDate=$p(^DHCINAUD(AuditDr),"^",14)
	...s TabAuditTime=$p(^DHCINAUD(AuditDr),"^",15)
	...s:TabAuditDate'="" TabAuditDate=$zd(TabAuditDate,3)
	...s:TabAuditTime'="" TabAuditTime=$zt(TabAuditTime)
	...i TabAuditFlag="开始审核"  d
	....s TabInsuStrAuditDate=TabAuditDate_"  "_TabAuditTime    ;add by lilizhi 2013-02-22 加一列医保办开始审核时间 
	....s TabAuditMainInfo=AuditDr
	...s TabDemo=$p(^DHCINAUD(AuditDr),"^",17)
	...s TabReceiveFlag=$p(^DHCINAUD(AuditDr),"^",18)  //2011-11-21 住院处导出接收标志
	...s TabVisitStatus=$p(^DHCINAUD(AuditDr),"^",19)
	...s:TabVisitStatus="N" TabVisitStatus="禁止"
	...s:TabVisitStatus="Y" TabVisitStatus="允许"
	
	
	..;q:(CheckAuditFlag="1")&&(TabAuditFlag="完成") //Lou 2011-11-10
	..;q:(CheckAuditFlag="1")&&(TabAuditFlag="开始审核") //hwq 2011-11-11
	..;CheckAuditFlag  待审核",1   审核中",2   已完成",3
	
	
	..;;modefy by zhangdongliang at 2016-05-13 for 只使用医保办审核
	..;CheckAuditFlag  待审核",1   审核中",2   已完成",3
	..q:(CheckAuditFlag="1")&&(TabAuditFlag'="") 
	..q:(CheckAuditFlag="3")&&(TabAuditFlag'="完成")
	..q:(CheckAuditFlag="2")&&(TabAuditFlag'="开始审核")
	
	
	..;ReceiveFlag    已接收",1    未接收",2
	..;q:(ReceiveFlag="1")&&(TabReceiveFlag'="Y")  //接收情况查询  2011-11-21
	..;q:(ReceiveFlag="2")&&(TabReceiveFlag="Y")
	..;q:(ReceiveFlag="")&&(TabAuditFlag="完成")  //审核完成后，审核人员不能看到,除非选择接受方式2011 12 26
	..;i $g(^INSUTmp("有特批项",PBDr))="Y" d //Lou 2011-10-26
	..;.s TabPatName=TabPatName_"(#)"
	..i TabDemo="" d
	...s RtnStr=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(PaadmDr)
	...s TabDemo=$p(RtnStr,"^",41)
	..s TabPoint=..GetZLPoint(PBDr)	 //Lou 2011-08-24   2012 06 11
	..;q:TabPoint=0 ;0的时候没有明细数据,如果有数据会是0.00%
	

	..d OutPatPresc
	//k ^CacheTemp("IPAudit",$j)
	b ;1
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutPatPresc
	;set Data=$lb(TabRegNo,TabPatName,TabCTDesc,TabPatType,TabDiagDesc,TabAuditFlag,TabAuditUserName,TabAuditDate,TabAuditTime,TabDemo,TabAdmRowid,TabAdmDate,TabDischgDate,TabPoint,TabTolAmount,TabBillDr,TabSex,TabReceiveFlag,TMediCare)
 	;Zhan 20170317--->
 	i AdmDate'="" d
 	.s tmpTabAdmDate=$zdh(AdmDate,3)
 	.s TabAdmDate=##class(websys.Conversions).DateLogicalToHtml(tmpTabAdmDate)
 	i DischgDate'="" d
 	.s tmpTabDischgDate=$zdh(DischgDate,3)
 	.s TabDischgDate=##class(websys.Conversions).DateLogicalToHtml(tmpTabDischgDate)
 	i TabAuditDate'="" d
 	.s tmpTabAuditDate=$zdh(TabAuditDate,3)
 	.s TabAuditDate=##class(websys.Conversions).DateLogicalToHtml(tmpTabAuditDate)
 	i TabPBDateFrom'="" d
 	.s tmpTabPBDateFrom=$zdh(TabPBDateFrom,3)
 	.s TabPBDateFrom=##class(websys.Conversions).DateLogicalToHtml(tmpTabPBDateFrom)
 	i TabPBDateTo'="" d
 	.s tmpTabPBDateTo=$zdh(TabPBDateTo,3)
 	.s TabPBDateTo=##class(websys.Conversions).DateLogicalToHtml(tmpTabPBDateTo)
	;<----------------
 	set Data=$lb(TabCheckFlag,TabRegNo,TabPatName,TabCTDesc,TabPatType,TabDiagDesc,TabAuditFlag,TabAuditUserName,TabAuditDate,TabAuditTime,TabDemo,TabAdmRowid,TabAdmDate,TabDischgDate,TabPoint,TabTolAmount,TabBillDr,TabSex,TabReceiveFlag,TMediCare,TabDays,TabAge,TabConfirmDate,TabInsuStrAuditDate,TabAuditMainInfo,TabVisitStatus,TabPBDateFrom,TabPBDateTo,BedCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod IPAuditAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IPAuditAppExecute ]
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

ClassMethod IPAuditAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IPAuditAppExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^CacheTemp("IPAudit",$j)	;Zhan 20170621
	Quit $$$OK
}

Query IPAuditAppDetail(AdmDr As %String, BillDr As %String) As %Query(ROWSPEC = "TTarDesc,Txmdj,TPrice,TQty,TAmount,TInsuFlag,TOrderDate,TOrderTime,TDocName,Tybbz,TTarDr,TOEORI,TUomDesc,TDemo,TListFlag,TDHCTarCate,TarInsuFlag,TArcimDesc,TInsuTarCode,TInsuTarDesc,TTarCode,MotherAdmFlag,TmpOutDrugFlag")
{
}

/// d ##class(%ResultSet).RunQuery("web.INSUAuditIP","IPAuditAppDetail","131","137")
ClassMethod IPAuditAppDetailExecute(ByRef qHandle As %Binary, AdmDr As %String, BillDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i (AdmDr="")||(BillDr="") 
 	{
	 	Set qHandle=$lb(0,repid,0)
	 	Quit $$$OK
	}
	;s ^HH(1111)=AdmDr_"!"_BillDr
	k ^CacheTemp("INSUAuditDetail","InsuFlag",BillDr)
	;k ^CacheTemp("INSUAuditDetail","Sum",BillDr)		;
	k ^CacheTemp("INSUAuditDetail","Sum",$j,BillDr)	;住院医保医嘱审核双击数量显示为正确数量*2	upt HanZH 20230309
	;k ^CacheTemp("INSUAuditDetail","List",BillDr)
	k ^CacheTemp("INSUAuditDetail","List",$j,BillDr)
	;k ^CacheTemp("INSUAuditIPDetail")  ;add 2011 11 15 hwq 
	k ^CacheTemp("INSUAuditIPDetail",$j)  ;upt HanZH 20230309
	;k ^CacheTemp("INSUAuditDetail","ListPrint")  ;add 2012 01 06 hwq
	k ^CacheTemp("INSUAuditDetail","ListPrint",$j)  ;upt HanZH 20230309
	k ^CacheTemp("INSUAuditDetail","YBBZ")  ;add 2012-01-09  hwq
	s Num=1
 	s (TTarDesc,Txmdj,TPrice,TQty,TAmount,TInsuFlag,TOrderDate,TOrderTime,TDocName,Tybbz,TTarDr,TOEORI)=""
 	;Zhan 20160413
	s mCurrRowPatientBill=$g(^DHCPB(BillDr))
	s AdmDr=$p(mCurrRowPatientBill,"^",1)
	s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) //+ DingSH 20200603
	s AdmreasonDr=$p($g(^PAADM(AdmDr,1)),"^",7)
	s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmreasonDr,6,HospDr)
	//s:InsuType="" InsuType="BJ"
	s RtnStr=$$GetBillInfoByBillDr^DHCINSUFacade(BillDr,InsuType)
	;w "RtnStr="_RtnStr,!
	s DetailNum=$p(RtnStr,"|",1)
	s InsuPID=$p(RtnStr,"|",2)
	f i=1:1:DetailNum d
	.s PatBillDetailsInfo=$p($g(^CacheTemp("BillInfo",InsuPID ,i)),"=",3)
	.s PBDTARIInfo=$p($g(^CacheTemp("BillInfo",InsuPID ,i)),"=",4)
	.s OEORDInfo=$p($g(^CacheTemp("BillInfo",InsuPID ,i)),"=",5)
	.s OEORDExecInfo=$p($g(^CacheTemp("BillInfo",InsuPID ,i)),"=",6)
	.s OEORDDr=$p(OEORDInfo,"^",9)
	.s OEORIDr=$p(OEORDInfo,"^",10)
	.s OEORIRowId=OEORDDr_"||"_OEORIDr
  	.s OEOREChildsub=$p(OEORDInfo,"^",3)
	.s OEORERowId=OEORDDr_"||"_OEORIDr_"||"_OEOREChildsub
	.s OEORDExecDr=$p(OEORDExecInfo,"^",21)
	.;w "OEORDExecDr:",OEORDExecDr,!
	.s ItmMastDr=$p(OEORDInfo,"^",15)   ;add hwq 2012-01-10
	.s OutDrugFlag=$p(OEORDInfo,"^",8)   ;add hwq 2012 01 13 出院带药
	.s TArcimDesc=$p(^ARCIM($p(ItmMastDr,"||",1),$p(ItmMastDr,"||",2),1),"^",2)	;13医嘱名称
	.s TOEORI=OEORIRowId										;19找明细用的医嘱明细表rowid
	.s TOrderDate=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",7)		;7开医嘱日期
	.s TOrderTime=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",17)		;8开医嘱时间
	.s TOrderDate=$zd(TOrderDate,3)
	.s TOrderTime=$zt(TOrderTime,1)
	.s OEORIDoctorDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",11)	
	.i OEORIDoctorDR="" d
	..s TDocName=""
	.e  d
	..s TDocName=$p($g(^CTPCP(OEORIDoctorDR,1)),"^",2)		;9开医嘱医生
	.;modefy by zhangdongliang at 2015-10-12 for 标准版 DHC_Tarcate Code字段为数字，所以此处改为Desc字段。
	.;s TDHCTarCate=$p(PBDTARIInfo,"^",8)     ;类别DHC_Tarcate  add 2011 11 11 hwq
	.s TDHCTarCate=$p(PBDTARIInfo,"^",9) 
	.s TDHCTarCatDr=$p(PBDTARIInfo,"^",7)   ;add hwq 2012-01-06
	.s TQty=+$p(PatBillDetailsInfo,"^",5)
	.q:TQty=0	;数量为0的退出Zhan20160120
	.s TPrice=+$p(PatBillDetailsInfo,"^",6)
	.i +TPrice<1 d
	..s TPrice=$fn(TPrice,"",2)		;modefy zhangdongliang at 2018-12-25 for 单价<1时,保留2位小数.避免下面global节点TPrice出现 .02 与0.02不一致
	.s TAmount=+$p(PatBillDetailsInfo,"^",7)
	.s TTarCode=$p(PBDTARIInfo,"^",2)
	.s TTarDesc=$p(PBDTARIInfo,"^",3)
	.;w TTarCode_TTarDesc,!
	.s TUomDesc=$p(PBDTARIInfo,"^",6)
	.i $p(PBDTARIInfo,"^",55)="Null" d
	..s Txmdj="未对照"
	..s TInsuTarCode="未对照"
	..s TInsuTarDesc="未对照"
	.e  d
	..;modefy by zhangdongliang at 2018-03-21 for 非北京医保使用INTIM_tjdm字段存储 收费等级
	..s Txmdj=$p(PBDTARIInfo,"^",77)			;$p(PBDTARIInfo,"^",61)
    ..s:Txmdj="1" Txmdj="甲类"
    ..s:Txmdj="2" Txmdj="乙类"
    ..s:Txmdj="3" Txmdj="丙类"
    ..s TInsuTarCode=$p(PBDTARIInfo,"^",57)
	..s TInsuTarDesc=$p(PBDTARIInfo,"^",58)
    ..s Tybbz=$p(PBDTARIInfo,"^",76)
    .s TarDr=$p(PBDTARIInfo,"^",1)
    .s BZLen=$l(Tybbz)  ;add 2011 12 31 若限制信息过长，则使用超链接  hwq
    .s ^CacheTemp("INSUAuditDetail","YBBZ",TarDr)=Tybbz   ;add 2012-01-09
    .;i BZLen>8  s Tybbz="限制信息"     ;_"#"_Tybbz
	.s TarInsuFlag=$p(^DHCTARI(TarDr),"^",24) //2011-10-26
	.i TarInsuFlag["#" d
	..s TTarDesc="(限)"_TTarDesc
	.i OutDrugFlag="出院带药" s TTarDesc="(出)"_TTarDesc   ;add hwq 2012-01-13 出院带药做出标记
	.s TInsuFlag="N"
  	.s InsuFlag=$p(^OEORD(OEORDDr,"I",OEORIDr,3),"^",3)
  	.s TDemo=""
  	.;s AuditDr=$o(^DHCINAUD("0","OEORI_Tar",OEORDDr_"||"_OEORIDr,TarDr,""),-1) //取医保审核的标志
	.;s OEORDExecDr=OEORDDr_"||"_OEORIDr	;如果没有执行记录就放开此行 Zhan 20160413
  	.s AuditDr=$o(^DHCINAUD("0","OEORI_Tar",OEORDExecDr,TarDr,""),-1) //取医保审核的标志
  	.i AuditDr'="" d
  	..s AuditInsuFlag=$p(^DHCINAUD(AuditDr),"^",6)
  	..s:AuditInsuFlag'="" InsuFlag=AuditInsuFlag
  	..s TDemo=$p(^DHCINAUD(AuditDr),"^",17)
  	.s:InsuFlag="" InsuFlag="Y"
  	.s:InsuFlag="N" TInsuFlag="Y" ;调整为自费勾打上
  	.s:InsuFlag="Y" TInsuFlag="N" 
  	.s:TInsuFlag="Y" Txmdj=Txmdj_"->丙类" ;Lou 2011-08-24
  	.s TTarDr=TarDr
  	
    .s BabyAdmDr=$p(^OEORD(OEORDDr),"^",1)
  	.s MotherAdm=$p(^PAADM(BabyAdmDr),"^",75) ;若此字段有值则为小孩
  	.i MotherAdm'=""  d
  	..s MotherAdmFlag="2Baby"
  	..s TTarDesc="(婴)"_TTarDesc
  	.e                d
  	..s MotherAdmFlag="1Mother"
  	.i OutDrugFlag="出院带药"  d
  	..s TmpOutDrugFlag="2Y"
  	.e   d
  	..s TmpOutDrugFlag="1N"
  	
  	.s ^CacheTemp("INSUAuditDetail","InsuFlag",BillDr,TarDr,OEORDExecDr)=InsuFlag_"^"_TDemo //记录查询时的医保状态,用于保存日志时比较是比较有修改
	.;DO InsuAuditDetail
  	.s Str=TTarDesc_"^"_Txmdj_"^"_TPrice_"^"_TQty_"^"_TAmount_"^"_TInsuFlag_"^"_TOrderDate_"^"_TOrderTime_"^"_TDocName_"^"_Tybbz_"^"_TTarDr_"^"_TOEORI_"^"_TUomDesc_"^"_TDemo_"^"_TDHCTarCate_"^"_TarInsuFlag_"^"_TArcimDesc_"^"_TInsuTarCode_"^"_TInsuTarDesc_"^"_TTarCode
  	.;生成打印的global
  	.;s ^CacheTemp("INSUAuditDetail","List",$j,BillDr,TarDr,OEORDDr_"||"_OEORIDr)=Str
  	.i $d(^CacheTemp("INSUAuditDetail","List",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TarDr,TPrice,OEORDExecDr))  d
  	..s $p(^CacheTemp("INSUAuditDetail","List",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TarDr,TPrice,OEORDExecDr),"^",4)=$p(Str,"^",4)+$p(^CacheTemp("INSUAuditDetail","List",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TarDr,TPrice,OEORDExecDr),"^",4)
  	..s $p(^CacheTemp("INSUAuditDetail","List",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TarDr,TPrice,OEORDExecDr),"^",5)=$p(Str,"^",5)+$p(^CacheTemp("INSUAuditDetail","List",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TarDr,TPrice,OEORDExecDr),"^",5)
  	..;s tmplistid=+$o(^CacheTemp("INSUAuditDetail","List",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TarDr,TPrice,OEORDDr_"||"_OEORIDr_"||"_OEOREChildsub,""),-1)+1
  	..;s ^CacheTemp("INSUAuditDetail","List",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TarDr,TPrice,OEORDDr_"||"_OEORIDr_"||"_OEOREChildsub,tmplistid)=Str
  	..;w OEORDDr_"||"_OEORIDr_"||"_OEOREChildsub_","_tmplistid_"    "
  	.e  d
  	..s ^CacheTemp("INSUAuditDetail","List",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TarDr,TPrice,OEORDExecDr)=Str

  	
  	.i OutDrugFlag="出院带药" s TDHCTarCatDr="CYDY"  ;add hwq 2012 01 13 用于导出时出院带院单为一个分类
  	.;s InsuTarCatDr=$p($$QueryByCode^DHCINSUDicData("InCatCon",TDHCTarCatDr),"^","6") ;add 2012 01 06 hwq
  	.s InsuTarCatDr=TDHCTarCatDr
  	.i $d(^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr,InsuTarCatDr,TarDr,TInsuFlag))  d
  	..s $p(^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr,InsuTarCatDr,TarDr,TInsuFlag),"^",4)=$p(Str,"^",4)+$p($g(^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr,InsuTarCatDr,TarDr,TInsuFlag)),"^",4)
  	..s $p(^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr,InsuTarCatDr,TarDr,TInsuFlag),"^",5)=$p(Str,"^",5)+$p($g(^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr,InsuTarCatDr,TarDr,TInsuFlag)),"^",5)
  	.e  d
  	..s ^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr,InsuTarCatDr,TarDr,TInsuFlag)=Str   
	.;add by Lou 2011-08-24 汇总相同项目
	.i $d(^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr,TPrice)) d
	..;如果有一条项目调整为自费,打上标记
	..if (TInsuFlag="Y")||($p($g(^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr,TPrice)),"^",6)="Y") d
	...s ^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr,TPrice,"Y")="0"
	..;如果所有项目都调整为自费,打上标记
	..if (TInsuFlag="Y")&&($p($g(^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr,TPrice)),"^",6)="Y") d
	...s ^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr,TPrice,"Y")="1"
	..;全都没有调整,打上标记
	..if (TInsuFlag="N")&&($p($g(^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr,TPrice)),"^",6)="N")&&('$d(^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr,TPrice,"Y"))) d
	...s ^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr,TPrice,"Y")="2"
	..s $p(Str,"^",4)=$p(Str,"^",4)+$p($g(^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr,TPrice)),"^",4)
	..s $p(Str,"^",5)=$p(Str,"^",5)+$p($g(^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr,TPrice)),"^",5)
	..s ^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr,TPrice)=Str
	.e  d
	..s ^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr,TPrice)=Str
	
    .;add by Lou 2011-08-24 汇总相同项目
	s MotherAdmFlag=""
	f  s MotherAdmFlag=$o(^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag)) q:MotherAdmFlag=""  d
	.s TmpOutDrugFlag=""
	.f  s TmpOutDrugFlag=$o(^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag)) q:TmpOutDrugFlag=""  d
	..s TDHCTarCatDr=""
	..f  s TDHCTarCatDr=$o(^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr)) q:TDHCTarCatDr=""  d
	...s TarDr=""
	...f  s TarDr=$o(^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr)) q:TarDr=""  d
	....s TPrice=""
	....f  s TPrice=$o(^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr,TPrice)) q:TPrice=""  d
	.....s mCorr=$g(^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr,TPrice))
	.....s TTarDesc=$p(mCorr,"^",1),Txmdj=$p(mCorr,"^",2),TPrice=$p(mCorr,"^",3),TQty=$p(mCorr,"^",4),TAmount=$p(mCorr,"^",5),TInsuFlag=$p(mCorr,"^",6),TOrderDate=$p(mCorr,"^",7),TOrderTime=$p(mCorr,"^",8)
	.....s TDocName=$p(mCorr,"^",9),Tybbz=$p(mCorr,"^",10),TTarDr=$p(mCorr,"^",11),TOEORI=$p(mCorr,"^",12),TUomDesc=$p(mCorr,"^",13),TDemo=$p(mCorr,"^",14),TDHCTarCate=$p(mCorr,"^",15),TarInsuFlag=$p(mCorr,"^",16),TArcimDesc=$p(mCorr,"^",17)
	.....s TDeptDesc=$p(mCorr,"^",18)  ;+ liusf 2012 05 08
	.....s Usage=$p(mCorr,"^",19)  ;add by lilizhi 2013-06-13
	.....s TTarCode=$p(mCorr,"^",20)
	.....s TInsuTarCode=$p(mCorr,"^",18)
	.....s TInsuTarDesc=$p(mCorr,"^",19)
	.....s TListFlag=""
	.....s Tbftz=""
	.....;TPrice,"Y")代表此收费项汇总下，有多条PBO
	.....i $d(^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr,TPrice,"Y")) d
	......s TListFlag="明细"
	......s Flag=$g(^CacheTemp("INSUAuditDetail","Sum",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TDHCTarCatDr,TarDr,TPrice,"Y"))
	......i Flag="1" d ;如果全部都调整为自费
	.......s TInsuFlag="Y"
	.......s:Txmdj'["->" Txmdj=Txmdj_"->丙类"	
	......i Flag="0" d ;如果有一条项目调整为自费
	.......s TInsuFlag="N"
	.......s:Txmdj'["->" Txmdj=Txmdj_"->丙类"
	.......s Tbftz="部分调整"   ;add by lilizhi   2012-07-19    添加部分调整标志 

	......i (Flag'="0")&&(Flag'="1") d ;如果不是全部调整为自费,则不勾
	.......s TInsuFlag="N"
	.....;;add 2011 11 15 hwq 
	.....s ^CacheTemp("INSUAuditIPDetail",$j,Num)=TTarDesc_"^"_Txmdj_"^"_TPrice_"^"_TQty_"^"_TAmount_"^"_TInsuFlag_"^"_TOrderDate_"^"_TOrderTime_"^"_TDocName_"^"_Tybbz_"^"_TTarDr_"^"_TOEORI_"^"_TUomDesc_"^"_TDemo_"^"_TListFlag_"^"_TDHCTarCate_"^"_TarInsuFlag
	.....s Num=Num+1
	
	.....;add by zhangdongliang at 2014-05-30 for 过滤部分数据不可见。医保办不过滤，其他安全组按照不同规则过滤。
	.....;  8  住院收费;    9 住院收费组长
	.....s OutFlag="Y"
	.....;目的是根据安全组或者操作员rowid，让主任只须看到被改过的数据即可
	.....;modefy by zhangdongliang at 2014-08-11 for 根据CheckAuditFlag控制明细显示
	.....;i (GROUPID="8") || (GROUPID="9")  d
	.....;.i (TDemo="") && (Txmdj'["->丙类")   d			;
	.....;..s OutFlag="N"
	.....;i (CheckAuditFlag="4")  d
	......;i (TDemo="") && (Txmdj'["->丙类")   d			;
	.......;s OutFlag="N"
	
	.....;w "CheckAuditFlag="_CheckAuditFlag_"||"_OutFlag,!
	.....i OutFlag'="N"  d
	......DO InsuAuditDetail
	k ^CacheTemp("BillInfo",$j)

  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
InsuAuditDetail
	q:TQty=0	;数量为0的退出Zhan20160120
	s TmpTPrice=TPrice 
	s TmpTAmount=TAmount
	s:$p(TmpTPrice,".",1)="" TmpTPrice="0"_TmpTPrice
	s:$p(TmpTAmount,".",1)="" TmpTAmount="0"_TmpTAmount
	s tmpTOrderDate=$zdh(TOrderDate,3)
	s TOrderDate=##class(websys.Conversions).DateLogicalToHtml(tmpTOrderDate)
	set Data=$lb(TTarDesc,Txmdj,TmpTPrice,TQty,TmpTAmount,TInsuFlag,TOrderDate,TOrderTime,TDocName,Tybbz,TTarDr,TOEORI,TUomDesc,TDemo,TListFlag,TDHCTarCate,TarInsuFlag,TArcimDesc,TInsuTarCode,TInsuTarDesc,TTarCode,MotherAdmFlag,TmpOutDrugFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod IPAuditAppDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IPAuditAppDetailExecute ]
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

ClassMethod IPAuditAppDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IPAuditAppDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

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

/// 将审核内容保存到审核日志表中 Lou 2011-08-05
ClassMethod SaveAuditLog(InString As %String) As %String
{
	n (InString)
	s rtn=1
	;s ^zmc("SaveAuditLog")=InString
	s AdmDr=$p(InString,"^",2)
	q:AdmDr="" -1
	s BillDr=$p(InString,"^",3)
	s OEORIDr=$p(InString,"^",4)
	s TarDr=$p(InString,"^",5)
	s InsuFlag=$p(InString,"^",7)
	s AuditFlag=$p(InString,"^",12)
	s Demo=$p(InString,"^",18)
	i AuditFlag="0" d ;审核就诊记录
	.s rtn=$$Save^DHCINSUAudit(InString)
	e   d ;审核明细
	.i OEORIDr="" d ;如果是汇总项
	..f  s OEORIDr=$o(^CacheTemp("INSUAuditDetail","InsuFlag",BillDr,TarDr,OEORIDr)) q:OEORIDr=""  d
	...s tmpInsuFlag="",tmpDemo=""
  	...s AuditDr=$o(^DHCINAUD("0","OEORI_Tar",OEORIDr,TarDr,""),-1) //取医保审核的标志
  	...i AuditDr'="" d
  	....s tmpInsuFlag=$p(^DHCINAUD(AuditDr),"^",6)
  	....s tmpDemo=$p(^DHCINAUD(AuditDr),"^",17)
	...s InsuFlag=$p(^CacheTemp("INSUAuditDetail","InsuFlag",BillDr,TarDr,OEORIDr),"^",1)
	...s $p(InString,"^",7)=InsuFlag
	...s $p(InString,"^",4)=OEORIDr
	...if (InsuFlag'=tmpInsuFlag)||(Demo'=tmpDemo) d ;Modify by Lou 2011-08-24
	....s rtn=$$Save^DHCINSUAudit(InString)
	.e  d ;非汇总项
	..s tmpInsuFlag="",tmpDemo=""
  	..s AuditDr=$o(^DHCINAUD("0","OEORI_Tar",OEORIDr,TarDr,""),-1) //取医保审核的标志
  	..i AuditDr'="" d
  	...s tmpInsuFlag=$p(^DHCINAUD(AuditDr),"^",6)
  	...s tmpDemo=$p(^DHCINAUD(AuditDr),"^",17)
	..s InsuFlag=$p(^CacheTemp("INSUAuditDetail","InsuFlag",BillDr,TarDr,OEORIDr),"^",1)
	..s $p(InString,"^",7)=InsuFlag
	..if (InsuFlag'=tmpInsuFlag)||(Demo'=tmpDemo) d ;Modify by Lou 2011-08-24
	...s rtn=$$Save^DHCINSUAudit(InString)
	q rtn
}

/// 保存审核的医保类别 Lou 2011-08-25
ClassMethod SaveInsuFlag(BillDr As %String, TarDr As %String, OEORIDr As %String, InsuFlag As %String) As %String
{
	n (BillDr,TarDr,OEORIDr,InsuFlag)
	;s ^Lou(0)=BillDr_"^"_TarDr_"^"_OEORIDr_"^"_InsuFlag
	q:(BillDr="")||(TarDr="")||(InsuFlag="") 0
	i OEORIDr="" d ;如果为空表示为汇总项,需要循环所有明细项
	.f  s OEORIDr=$o(^CacheTemp("INSUAuditDetail","InsuFlag",BillDr,TarDr,OEORIDr)) q:OEORIDr=""  d
	..s $p(^CacheTemp("INSUAuditDetail","InsuFlag",BillDr,TarDr,OEORIDr),"^",1)=InsuFlag
	e  d
	.s $p(^CacheTemp("INSUAuditDetail","InsuFlag",BillDr,TarDr,OEORIDr),"^",1)=InsuFlag
	q 0
}

/// 获得自理项目所占的比重 已不用Lou 2011-10-20 改为按账单号走
ClassMethod GetZLPointold(AdmDr As %String) As %String
{
	n (AdmDr)
	s OEORDDr="",SumAmount=0,ZlAmount=0,Point=0
	f  s OEORDDr=$o(^OEORD(0,"Adm",AdmDr,OEORDDr)) q:OEORDDr=""  d
	.s OEORIDr="0"
	.f  s OEORIDr=$o(^OEORD(OEORDDr,"I",OEORIDr)) q:OEORIDr=""  d
	..s OEORIRowId=OEORDDr_"||"_OEORIDr
	..s ItmMastDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",2)
	..s BillSubDr=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",9)
	..q:(BillSubDr="3||1")||(BillSubDr="4||1") ;挂号和诊疗费退出Lou 2011-08-03
	..s OrderDate=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",7)		;7开医嘱日期
	..s OEORIPhQtyOrd=##Class(web.DHCCLCom).GetOrderBaseQty(OEORIRowId)
	..s ExecuDate=""
	..f  s ExecuDate=$o(^DHCOLT(0,"ARCIM",ItmMastDR,"Z",ExecuDate)) q:ExecuDate=""  d
	...q:ExecuDate>OrderDate
	...s OLT=""
	...f  s OLT=$o(^DHCOLT(0,"ARCIM",ItmMastDR,"Z",ExecuDate,OLT)) q:OLT=""  d
	....s EndDate=$p(^DHCOLT(OLT),"^",5)
	....i EndDate="" s EndDate=+$H+31
	....q:EndDate<OrderDate
	....s qty0=$p(^DHCOLT(OLT),"^",3)
	....;w "ItmMastDR=",ItmMastDR,!
	....s TarDr=$p(^DHCOLT(OLT),"^",2)
	....s Price=$p(##Class(web.UDHCJFPRICE).GetItmPrice(TarDr, +$h, "", "", "", ""),"^",1)	
	....s Price=$fn(Price,"",4)*qty0							;10医嘱单位价格	
	....s Amount=$fn(Price*OEORIPhQtyOrd,"",2)				;12医嘱总价  
  	....s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TarDr,"BJ","")
    ....s xmdj=$p(TarItemInsuInfo,"^",7)               //项目等级
  	....s AuditDr=$o(^DHCINAUD("0","OEORI_Tar",OEORIRowId,TarDr,""),-1) //取医保审核的标志
  	....i AuditDr'="" d
  	.....s AuditInsuFlag=$p(^DHCINAUD(AuditDr),"^",6)
  	.....i AuditInsuFlag="N" s xmdj="3" ;审核为丙类的项目
    ....i xmdj="3" d
    .....s ZlAmount=ZlAmount+Amount
    .....;w "TarDr=",TarDr,!
    ....s SumAmount=SumAmount+Amount
    ....;w Amount_"^"_SumAmount_"^"_ZlAmount,!
    ....s Point=$fn((ZlAmount/SumAmount)*100,"",2)
    ....s Point=Point_"%"
    q Point
}

/// 获得自理项目所占的比重 2011-10-20 改为按账单号走
/// w ##class(web.INSUAuditIP).GetZLPoint(248715)
ClassMethod GetZLPoint(strBillDr As %String) As %String
{
	n (strBillDr)
	k ^INSUTmp("有特批项",strBillDr) //Lou 2011-10-26
	s OEORDDr="",SumAmount=0,ZlAmount=0,Point=0
	s mCurrRowPatientBill=$g(^DHCPB(strBillDr))
	s PBTotal=($p(mCurrRowPatientBill,"^",8))
	s PBOChildSub="0"
	f  s PBOChildSub=$o(^DHCPB(strBillDr,"O",PBOChildSub)) q:(PBOChildSub="")  d
	.s OEORIRowId=$p($g(^DHCPB(strBillDr,"O",PBOChildSub)),"^",4) 
	.q:OEORIRowId=""  
	.s oeExeDr=$p($g(^DHCPB(strBillDr,"O",PBOChildSub)),"^",20) 
	.s InsuFlag=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),3)),"^",3)
	.s PBDChildSub="0"
	.f  s PBDChildSub=$o(^DHCPB(strBillDr,"O",PBOChildSub,"D",PBDChildSub)) q:(PBDChildSub="")  d
	..s mCurrRowPatBillDetails=$g(^DHCPB(strBillDr,"O",PBOChildSub,"D",PBDChildSub))
	..s PBPayedFlag=$p(mCurrRowPatientBill,"^",16)
	..s TarDr=$p(mCurrRowPatBillDetails,"^",3)
	..s Amount=$j($p(mCurrRowPatBillDetails,"^",7),3,2)
	..q:Amount=0
	..s TarInsuFlag=$p(^DHCTARI(TarDr),"^",24) //2011-10-26
	..;i TarInsuFlag["#" d
	...;s ^INSUTmp("有特批项",strBillDr)="Y"
	..;Zhan 20160415--->
	..s InsuType=""
	..s mCurrRowPatientBill=$g(^DHCPB(strBillDr))
	..s AdmDr=$p(mCurrRowPatientBill,"^",1)
	..s AdmreasonDr=$p($g(^PAADM(AdmDr,1)),"^",7)
	..s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
	..s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmreasonDr,6,HospDr)
	..;s:InsuType="" InsuType="BJ"
  	..;s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TarDr,"BJ","","")
  	..s TariSpecialFlag=$p($$QueryByCode^DHCINSUDicData("HISPROPerty"_InsuType,"TariSpecialFlag",HospDr),"^",4) //是否启用特殊收费项目对照 +DingSH 20200828
    ..i TariSpecialFlag="Y" d
    ...s ARCIMType=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),"DHC")),"^",3)	 ;Zhan 20151119 OEORI_InsurCat_DR 医保类别指针医保适应症代码(医保组)
    ...s tmpTarDr=##class(web.DHCINSUTarConTar).QueryTarConId(TarDr, ARCIMType,HospDr)   //+DingSH 20200828
    ...i tmpTarDr'=""  d
    ....s TarDr=tmpTarDr
	..//s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType,HospDr),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
	..s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("HISPROPerty"_InsuType,"TariInsuFlag",HospDr),"^",4) 
  	..s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TarDr,InsuType,"",TariInsuFlag,HospDr)
  	..s zfbl=+$p(TarItemInsuInfo,"^",18)               //Zhan 20160415自付比例,这个要看各个医院，有的医院存的是报销比例
  	..;<--------------//
    ..s xmdj=$p(TarItemInsuInfo,"^",7)               //项目等级,北京用
    ..;s xmdj=$p(TarItemInsuInfo,"^",23)               //1,2,3:甲乙丙等，医保类别，北京版本是项目等级 Zhan 20160415
    ..s:zfbl=1 xmdj="3"
    ..i InsuFlag="N" s xmdj="3" ;2011-10-26
    
  	..;s AuditDr=$o(^DHCINAUD("0","OEORI_Tar",OEORIRowId,TarDr,""),-1) //取医保审核的标志，如果有执行记录就用下边的代码
  	..s AuditDr=$o(^DHCINAUD("0","OEORI_Tar",oeExeDr,TarDr,""),-1) //取医保审核的标志Zhan 20160415
  	..i AuditDr'="" d
  	...s AuditInsuFlag=$p(^DHCINAUD(AuditDr),"^",6)
  	...i AuditInsuFlag="N" s xmdj="3" ;审核为丙类的项目
  	...i AuditInsuFlag="Y" s xmdj=$p(TarItemInsuInfo,"^",7)  ;
    ..i xmdj="3" d
    ...s ZlAmount=ZlAmount+Amount
    ..s SumAmount=SumAmount+Amount
    ;w ZlAmount_"^"_SumAmount,!
    
    i SumAmount'=0 d
    .s Point=$fn((ZlAmount/SumAmount)*100,"",2)
    .s Point=Point_"%"
    q Point
}

Query AuditDetailsList(AdmDr, BillDr, TarDr, MotherAdmFlag, TmpOutDrugFlag, Price) As %Query(ROWSPEC = "TTarDesc,Txmdj,TPrice,TQty,TAmount,TInsuFlag,TOEORIDr,TOeordDate,TOeordTime,TArcimDesc,TOEExeDr")
{
}

ClassMethod AuditDetailsListExecute(ByRef qHandle As %Binary, AdmDr, BillDr, TarDr, MotherAdmFlag, TmpOutDrugFlag, Price) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i (BillDr="")||(TarDr="")
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	;w BillDr,"_", TarDr,!
	;s ^zmc("abr")=BillDr_","_TarDr_","_MotherAdmFlag_","_TmpOutDrugFlag_","_Price
  	;s Str=TTarDesc_"^"_Txmdj_"^"_TPrice_"^"_TQty_"^"_TAmount_"^"_TInsuFlag_"^"_TOrderDate_"^"_TOrderTime_"^"_TDocName_"^"_Tybbz_"^"_TTarDr_"^"_TOEORI_"^"_TUomDesc_"^"_TDemo
	s OEORIRowid=""
	f  s OEORIRowid=$o(^CacheTemp("INSUAuditDetail","List",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TarDr,Price,OEORIRowid)) q:OEORIRowid=""  d
	.s ListStr=$g(^CacheTemp("INSUAuditDetail","List",$j,BillDr,MotherAdmFlag,TmpOutDrugFlag,TarDr,Price,OEORIRowid))
	.s TTarDesc=$p(ListStr,"^",1)
	.s TTarCode=$p($g(^DHCTARI(TarDr)),"^",1)
	.;i TTarCode="OTHER0001"  d   
    .;.s DepProcNotes=$g(^OEORD($p(OEORIRowid,"||",1),"I",$p(OEORIRowid,"||",2),"DEP",1))  ;add by lilizhi 2012-07-31 如果收费项目是 "临时采购高值材料费",收费项名称 后面拼 医嘱备注
	.;.s TTarDesc=TTarDesc_"("_DepProcNotes_")"
	.s Txmdj=$p(ListStr,"^",2)
	.s TPrice=$p(ListStr,"^",3)
	.s TQty=$p(ListStr,"^",4)
	.s TAmount=$p(ListStr,"^",5)
	.s TInsuFlag=$p(ListStr,"^",6)
	.;modefy by zhangdongliang at 2014-05-08 改为取执行记录时间
	.s OEOREDateExecuted=$p($g(^OEORD($p(OEORIRowid,"||",1),"I",$p(OEORIRowid,"||",2),"X",$p(OEORIRowid,"||",3))),"^",1)
	.s OEORETimeExecuted=$p($g(^OEORD($p(OEORIRowid,"||",1),"I",$p(OEORIRowid,"||",2),"X",$p(OEORIRowid,"||",3))),"^",2)
	.;w "  OEOREDateExecuted:",OEOREDateExecuted,"__",$p(ListStr,"^",7)
	.i OEOREDateExecuted="" d
	..s TOeordDate=$p(ListStr,"^",7)
	.e  d
	..s TOeordDate=$zd(OEOREDateExecuted,3)	;$p(ListStr,"^",7)  ;add hwq 2012 01 10
	.i OEORETimeExecuted="" d
	..s TOeordTime=$p(ListStr,"^",8)
	.e  d
	..s TOeordTime=$zt(OEORETimeExecuted,1)	;$p(ListStr,"^",8)
	.s TArcimDesc=$p(ListStr,"^",17)
	.s DeptDesc=$p(ListStr,"^",18)
	.s Usage=$p(ListStr,"^",19)
	.;InsuFlag=Y医保范围内
	.i $d(^CacheTemp("INSUAuditDetail","InsuFlag",BillDr,TarDr,OEORIRowid)) d
	..i $p(^CacheTemp("INSUAuditDetail","InsuFlag",BillDr,TarDr,OEORIRowid),"^",1)="Y" d ;审核过为医保内项目的,调整为自费的勾不选
	...s TInsuFlag="N"
	..i $p(^CacheTemp("INSUAuditDetail","InsuFlag",BillDr,TarDr,OEORIRowid),"^",1)="N" d ;审核过非医保内项目的,调整为自费的勾选中
	...s TInsuFlag="Y"
	
	
	.;什么时候发生下面情况，待观察。
	.i (TInsuFlag="N")&&(Txmdj["->") d ;如果未勾调整为自费且类别上包含了转换,则去掉转换
	..s Txmdj=$p(Txmdj,"->",1)
	
	.i (TInsuFlag="Y")&&(Txmdj'["->") d ;如果勾中调整为自费且类别上不包含了转换,则加上转换
	..s Txmdj=Txmdj_"->丙类"
	
	.s TOEORIDr=$p(ListStr,"^",12)
	.s TOEExeDr=OEORIRowid
	.d AuditDetailsList
	
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
AuditDetailsList
	s tmpTOrderDate=""
	s:$l(TOeordDate,"-")=3 tmpTOrderDate=$zdh(TOeordDate,3)
	s TOeordDate=##class(websys.Conversions).DateLogicalToHtml(tmpTOrderDate)
	set Data=$lb(TTarDesc,Txmdj,TPrice,TQty,TAmount,TInsuFlag,TOEORIDr,TOeordDate,TOeordTime,TArcimDesc,TOEExeDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod AuditDetailsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AuditDetailsListExecute ]
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

ClassMethod AuditDetailsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AuditDetailsListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获得科室列表 Lou 2011-10-14
/// PAC_AdmTypeLocation 通过该表得出住院所用科室
/// 如果是急诊留观,通过该表的O类型,然后再到ct_loc表中的type为EM类型来筛选
ClassMethod getiploc() As %String
{
	s ind="",n=0,ReturnStr=""
	;f  s ind=$o(^PAC("ADMLOC",0,"AdmType","I",ind)) q:ind=""  d
	f  s ind=$o(^PAWARD(ind)) q:ind=""  d
	.;s s=$g(^CTLOC(ind))
	.s s=$g(^PAWARD(ind))
	.s AcitveFlag=$p(s,"^",6)  ;add hwq 2012 01 12
	.q:AcitveFlag="N"
	.s depdesc=$p(s,"^",2)
	.q:depdesc=""
	.i depdesc[")-"  d
	..s depdesc=$p(depdesc,")-",2)
	.e  d
	..i depdesc["-" d
	...i $l(depdesc,"-")>2  d  s depdesc=$p(depdesc,"-",$l(depdesc,"-"))
	...e  s depdesc=$p(depdesc,"-",2)
	.s str=ind_"^"_depdesc
	.i ReturnStr="" s ReturnStr=str
	.e  s ReturnStr=ReturnStr_"!"_str
	.s n=n+1
	q ReturnStr
}

/*
/// 根据就诊Dr获取医生录入诊断
///    DingSH 20200923 从函数作废 请从 web.DHCINSUPortUse.cls 调用
Query GetDiagnosInfo(AdmDr, DiagType As %String = "", ExpStr As %String = "") As %Query(ROWSPEC = "DiagnosNum,DiagnosCodeRowid,ICDCode,DiagName,MedicalRecord,DiagnosType,DiagnosDate,DiagnosOnsetDate,DiagStat,DiagnosLeavel,MainDiagFlag,DiagnosPrefix,InsuDiagCode,InsuDiagDesc")
{
}
*/

// 按操作员存储科室模板  2011 11 14

ClassMethod SaveDepInfo(UserDr As %String, StrDepList As %String) As %String
{
	n (UserDr,StrDepList)
	q:(UserDr="")||(StrDepList="") -1
	k ^INSUAuditLoc("Loc",UserDr)
	s ^INSUAuditLoc("Loc",UserDr)=StrDepList
	q 0
}

// 根据操作员ID提取科室模板   2011 11 14

// w ##class(web.INSUAuditIP).GetDepInfo(3901)

ClassMethod GetDepInfo(UserDr As %String) As %String
{
	n (UserDr)
	q:(UserDr="") -1
	i $d(^INSUAuditLoc("Loc",UserDr))'=0 d
	.s StrDepList=^INSUAuditLoc("Loc",UserDr)
	e  s StrDepList=-1
	q StrDepList
}

// 根据Global获取明细总数 用于从global打印导出  2011 11 15

ClassMethod GetAuditDetailNumOLD(qhanld As %String) As %String
{
	s Index="",Num=0
	;f  s Index=$o(^CacheTemp("INSUAuditIPDetail",$j,Index)) q:Index=""  d
	;add hwq 2012-01-06
	s BillDr=""
	f  s BillDr=$o(^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr))  q:BillDr=""  d
	.s DHCTarCate=""
	.f  s DHCTarCate=$o(^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr,DHCTarCate))  q:DHCTarCate=""  d
	..s TarDr=""
	..f  s TarDr=$o(^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr,DHCTarCate,TarDr))  q:TarDr=""  d
	...s InsuFlag=""
	...f  s InsuFlag=$o(^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr,DHCTarCate,TarDr,InsuFlag)) q:InsuFlag=""  d
	....s ^CacheTemp("INSUAuditDetail","ListPrintNum",Num)=^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr,DHCTarCate,TarDr,InsuFlag)
	....s Num=Num+1
	q Num
}

// 根据Global获取明细总数 用于从global打印导出  2011 11 15

ClassMethod GetAuditDetailNum(qhanld As %String) As %String
{
	s Index="",Num=1,LSTarCate=""
	k ^CacheTemp("INSUAuditDetail","ListPrintNum")  ;2012 01 13
	k ^CacheTemp("INSUAuditDetail","ListPrintCate")   ;2012 01 13
	;f  s Index=$o(^CacheTemp("INSUAuditIPDetail",$j,Index)) q:Index=""  d
	;add hwq 2012-01-06
	s BillDr=""
	f  s BillDr=$o(^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr))  q:BillDr=""  d
	.s DHCTarCate=""
	.f  s DHCTarCate=$o(^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr,DHCTarCate))  q:DHCTarCate=""  d
	..s TarDr=""
	..f  s TarDr=$o(^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr,DHCTarCate,TarDr))  q:TarDr=""  d
	...s InsuFlag=""
	...f  s InsuFlag=$o(^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr,DHCTarCate,TarDr,InsuFlag)) q:InsuFlag=""  d
	....i (LSTarCate'="")&&(LSTarCate'=DHCTarCate)  d
	.....s InTarCatDesc=$p($$QueryByCode^DHCINSUDicData("InCatType",LSTarCate),"^",4)
	.....s ^CacheTemp("INSUAuditDetail","ListPrintNum",Num)=InTarCatDesc_"^小计:^^^"_$g(^CacheTemp("INSUAuditDetail","ListPrintCate",LSTarCate))_"^^^^^^^^^^^^^^"
	.....s Num=Num+1
	.....s ^CacheTemp("INSUAuditDetail","ListPrintNum",Num)="^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"  ;add 2012 01 14 打印小计之后空一行
	.....s Num=Num+1
	....s ^CacheTemp("INSUAuditDetail","ListPrintNum",Num)=^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr,DHCTarCate,TarDr,InsuFlag)
	....i $d(^CacheTemp("INSUAuditDetail","ListPrintCate"))  d	
	.....s ^CacheTemp("INSUAuditDetail","ListPrintCate",DHCTarCate)=$g(^CacheTemp("INSUAuditDetail","ListPrintCate",DHCTarCate))+$p(^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr,DHCTarCate,TarDr,InsuFlag),"^",5)
	....e  s ^CacheTemp("INSUAuditDetail","ListPrintCate",DHCTarCate)=$p(^CacheTemp("INSUAuditDetail","ListPrint",$j,BillDr,DHCTarCate,TarDr,InsuFlag),"^",5)
	....s LSTarCate=DHCTarCate
	....s LastCate=DHCTarCate
	....s Num=Num+1
	s InTarCatDesc=$p($$QueryByCode^DHCINSUDicData("InCatType",LastCate),"^",4)
	s ^CacheTemp("INSUAuditDetail","ListPrintNum",Num)=InTarCatDesc_"^小计:^^^"_$g(^CacheTemp("INSUAuditDetail","ListPrintCate",LSTarCate))_"^^^^^^^^^^^^^^"
	q Num
}

// 根据Global获取明细信息  用于从global打印导出  2011 11 15

ClassMethod GetAuditDetailData(Index As %String) As %String
{
	n (Index)
	s String=""
	;s String=$g(^CacheTemp("INSUAuditIPDetail",$j,Index)) 
	s String=$g(^CacheTemp("INSUAuditDetail","ListPrintNum",Index)) ;add hwq 2012-01-06
	q String
}

/// 根据账单号获得医保审核数据,导出后置上接收标志
/// hwq 2011-11-21 w ##class(web.INSUAuditIP).SaveOutPutFlag("203340")
ClassMethod SaveOutPutFlag(BillDr) As %String
{
	n (BillDr)
	s OutFlag="-1"
	s AuditDr=""
	f  s AuditDr=$o(^DHCINAUD("0","PBDr",BillDr,AuditDr)) q:AuditDr=""  d
	.s AuditInfo=$g(^DHCINAUD(AuditDr))
	.s AuditInfoFlag=$p(^DHCINAUD(AuditDr),"^",11)
	.q:AuditInfoFlag'=0
	.s $p(AuditInfo,"^",18)="Y"
	.s InString=AuditDr_"^"_AuditInfo
	s OutFlag=$$Update^DHCINSUAudit(InString)
	q OutFlag
}

/// 根据收费项rowid，获取医保限制信息
/// hwq 2012-01-09 w ##class(web.INSUAuditIP).GetYBDemoByTarDr("203340")
ClassMethod GetYBDemoByTarDr(TarDr) As %String
{
	n (TarDr)	
	s Demo=""
    s Demo=$g(^CacheTemp("INSUAuditDetail","YBBZ",TarDr))
    q Demo
}

/// 查询审核明细(住院处界面没有明细js，所以单独调用下query)
/// hwq 2012-02-04 w ##class(web.INSUAuditIP).GetAuditDetailsIP("29","204823")
ClassMethod GetAuditDetailsIP(itmjs As %Library.String = "", AdmDr As %String, BillDr As %String) As %String
{
	n (AdmDr,BillDr)
	s n=0
	;s str=##class(%ResultSet).RunQuery("web.INSUAuditIP","IPAuditAppDetail",AdmDr,BillDr)
	;q 0
	s Input=AdmDr_"^"_BillDr
	s rset=##class(%ResultSet).%New("web.INSUAuditIP:IPAuditAppDetail")
	;Input=AppDepRowid_"^"_UserId_"^"_AppDate_"^"_PatientID_"^"_TimeRangRowid_"^"_AppDocRowid_"^"_GroupRowId
	;Set rset=##Class(%ResultSet).%New("web.DHCOPAdmReg:OPDocList")
	If rset.QueryIsValid() {
		Set Status=rset.Execute(AdmDr,BillDr)
		If 'Status Quit
		;s msgobj.ResultCode=0
		;s msgobj.ErrorMsg=""
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			set ret=""
		    For col = 1:1:columns {
			   i ret="" s ret=rset.GetData(col)
		       e  s ret= ret_"^"_rset.GetData(col)
		    }
		    
	       s n=n+1
	      // i (ret'="") {
		   		//s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
				//&javascript<#(retval)#>
	      // }
		}
		d rset.Close()
	}
		Q n
}

/// 将审核内容保存到审核日志表中 Lou 2011-08-05
/// w ##class(web.INSUAuditIP).SendAuditInfo()
ClassMethod SendAuditInfo(InString As %String) As %String
{
	n (InString)
	s rtn=0
	s InPutMessage="",tmpInsuFlag=""
	s AdmDr=$p(InString,"^",2)
	q:AdmDr="" -1
	s BillDr=$p(InString,"^",3)
	s OEORIDr=$p(InString,"^",4)
	s TarDr=$p(InString,"^",5)
	s InsuFlag=$p(InString,"^",7)
	s AuditFlag=$p(InString,"^",12)
	q:AuditFlag="0" 
	s AuditUser=$p(InString,"^",14)
	s Demo=$p(InString,"^",18)
	s PatName=$p(^PAPER(+^PAADM(AdmDr),"ALL"),"^",1)	;2姓名
	s TabSex=$p(^PAPER(+^PAADM(AdmDr),"ALL"),"^",7)
	s TabSex=$p(^CT("SEX",TabSex),"^",2)        ;性别 2011-10-22
	s AdmDate=$zd($p(^PAADM(AdmDr),"^",6),3)  ;日期
	s CTLocDr=$p($g(^PAADM(AdmDr)),"^",70) ;改为Ward指针
	i CTLocDr="" d
	.s TabCTDesc=""
	e  d						;3科室描述
	.s TabCTDesc=$p(^PAWARD(CTLocDr),"^",2)
	i TabCTDesc[")-"  d
	.s TabCTDesc=$p(TabCTDesc,")-",2)
	e  d
	.i TabCTDesc["-" d
	..i $l(TabCTDesc,"-")>2  d  s TabCTDesc=$p(TabCTDesc,"-",$l(TabCTDesc,"-"))
	..e  s TabCTDesc=$p(TabCTDesc,"-",2)

	s TarDesc=$p(^DHCTARI(TarDr),"^",2)  ;收费项名称
	s ^HH("send")=InString
	i OEORIDr="" d ;如果是汇总项
	.f  s OEORIDr=$o(^CacheTemp("INSUAuditDetail","InsuFlag",BillDr,TarDr,OEORIDr)) q:OEORIDr=""  d
	..s tmpInsuFlag=""
  	..s AuditDr=$o(^DHCINAUD("0","OEORI_Tar",OEORIDr,TarDr,""),-1) //取医保审核的标志
  	..q:AuditDr="" 
  	..s tmpInsuFlag=$p(^DHCINAUD(AuditDr),"^",6)
	..q:tmpInsuFlag'="N"
	..s OEORIDoctorDR=$p($g(^OEORD(+OEORIDr,"I",$p(OEORIDr,"||",2),1)),"^",11)
	..q:OEORIDoctorDR=""
	..i OEORIDoctorDR="" d
	...s DocName=""
	..e  d
	...s DocName=$p($g(^CTPCP(OEORIDoctorDR,1)),"^",2)		;9开医嘱医生
	..s UserID=$o(^SSU("SSUSR",0,"CTPCP",OEORIDoctorDR,""))
	..s OrderDate=$p($g(^OEORD(+OEORIDr,"I",$p(OEORIDr,"||",2),3)),"^",7)		;7开医嘱日期
	..s ItmMastDr=$p($g(^OEORD(+OEORIDr,"I",$p(OEORIDr,"||",2),1)),"^",2) 
	..s ArcimDesc=$p($g(^ARCIM(+ItmMastDr,+$p(ItmMastDr,"||",2),1)),"^",2)	;13医嘱名称
	..s InPutMessage=PatName_","_TabCTDesc_","_ArcimDesc_",医嘱日期"_AdmDate_","_TarDesc_"由医保办"_AuditUser_",调整为自费"
	..;modefy by zhangdongliang at 2014-05-04 for 无此相关类，无法发送消息，待项目增加。
	..;s flag=##class(web.SSMessage).InsertMessageToUser(InPutMessage,UserID)
	..;i flag=0 s rtn="-1"  ;失败
	..;e  s rtn=0
	..s rtn=0
	..;;;;;;;;;;;;;;;;;;;
	e  d
  	.s AuditDr=$o(^DHCINAUD("0","OEORI_Tar",OEORIDr,TarDr,""),-1)  //取医保审核的标志
  	.q:AuditDr="" 
  	.s tmpInsuFlag=$p(^DHCINAUD(AuditDr),"^",6)  ;N 调整为自费  Y未调整
	.q:tmpInsuFlag'="N"
	.s OEORIDoctorDR=$p($g(^OEORD(+OEORIDr,"I",$p(OEORIDr,"||",2),1)),"^",11)
	.q:OEORIDoctorDR=""
	.i OEORIDoctorDR="" d
	..s DocName=""
	.e  d
	..s DocName=$p($g(^CTPCP(OEORIDoctorDR,1)),"^",2)		;9开医嘱医生
	.;w "DocName"_DocName,!
	.s UserID=$o(^SSU("SSUSR",0,"CTPCP",OEORIDoctorDR,""))
	.s OrderDate=$p($g(^OEORD(+OEORIDr,"I",$p(OEORIDr,"||",2),3)),"^",7)		;7开医嘱日期
	.s ItmMastDr=$p($g(^OEORD(+OEORIDr,"I",$p(OEORIDr,"||",2),1)),"^",2) 
	.s ArcimDesc=$p($g(^ARCIM(+ItmMastDr,+$p(ItmMastDr,"||",2),1)),"^",2)	;13医嘱名称
	.s InPutMessage=PatName_","_TabCTDesc_","_ArcimDesc_",医嘱日期"_AdmDate_","_TarDesc_"由医保办"_AuditUser_",调整为自费"
	.;modefy by zhangdongliang at 2014-05-04 for 无此相关类，无法发送消息，待项目增加。
	.;s flag=##class(web.SSMessage).InsertMessageToUser(InPutMessage,UserID)
	.;i flag=0 s rtn="-1"  ;失败
	.;e  s rtn=0
	.s rtn=0
	q rtn
}

/// w ##class(web.INSUAuditIP).GetDepListFlag("","")
ClassMethod GetDepListFlag(DepList As %String, CTLocDr As %String) As %String
{
 n (DepList,CTLocDr)
 s Flag="N"
 s:DepList="" Flag="Y"
 s len=$l(DepList,"^")
 f k=1:1:len  d
 .s Tmp=$p(DepList,"^",k)
 .i Tmp=CTLocDr  d
 ..s Flag="Y"
 q Flag
}

/// add by zhangdongliang at 2014-05-09 for 更新允许护士召回标志
/// w ##class(web.INSUAuditIP).UpdateVisitStatus("176","Y")
ClassMethod UpdateVisitStatus(INAUDDr, Flag) As %String
{
	q:INAUDDr="" -1
	q:Flag="" -1
	&SQL(UpDate INSU_Audit set INAUD_Demo2=:Flag where INAUD_rowid=:INAUDDr)
	q SQLCODE
}

/// GetDivideFlagByPBDr
/// Creator:  guoning 2017-10-30
/// Description:检验是否存在预结算或者结算数据
/// Input：PBDr：DHC_PatientBill表Rowid，insu_dividepre
/// CreatDate:1010-07-07
/// Others: w ##class(web.INSUAuditIP).GetDivideFlagByPBDr("261387")
/// Output: 医保支付
ClassMethod GetDivideFlagByPBDr(PBDr As %String) As %String
{
	n (PBDr)
	s OutStr="Y"
	s PreId="",DivId="",PreFLag="",DivFlag=""
	s PreId=$O(^DHCINDIVPre("0","DHCPB",PBDr,""),-1)
	s DivId=$O(^DHCINDIV("0","DHCPB",PBDr,""),-1)
	s:PreId'="" PreFLag=$p(^DHCINDIVPre(PreId),"^",5)
	s:DivId'="" DivFlag=$p(^DHCINDIV(DivId),"^",5)
	s:(PreFLag="D")!(DivFlag="D")!(DivFlag="I") OutStr="N"
	q OutStr
}

/// 根据就诊判断是否做过医保医嘱审核
/// lc 2022-01-10 w ##class(web.INSUAuditIP).GetAuditFlagByAdm("203340")
/// out:1:审已核 或 0:未审核
ClassMethod GetAuditFlagByAdm(PaadmDr) As %String
{
	s AuditDr="",TabAuditFlag="未审核",TabAuditUserName=""
	s AuditDr=$o(^DHCINAUD("0","AdmDr",PaadmDr,AuditDr),-1)
	i AuditDr'="" d
	.s TabAuditUserName=$p(^DHCINAUD(AuditDr),"^",13)
	.s TabAuditDate=$p(^DHCINAUD(AuditDr),"^",14)
	.s TabAuditTime=$p(^DHCINAUD(AuditDr),"^",15)
	.s:TabAuditDate'="" TabAuditDate=$zd(TabAuditDate,3)
	.s:TabAuditTime'="" TabAuditTime=$zt(TabAuditTime)
	s:TabAuditUserName'="" TabAuditFlag="已审核"
	s:TabAuditUserName="" TabAuditFlag="未审核"
	s TabAuditFlag=$case(TabAuditFlag,"已审核":"1",:"0")
	q TabAuditFlag
}

/// 根据就诊或账单号判断是否做过医保医嘱审核
/// w ##class(web.INSUAuditIP).CheckAuditFlag("1911")
/// DingSH 20221129 
/// 入参说明：PaadmDr：pa_adm.Rowid; PbBillDr:DHC_PatientBill.Rowid；ExpStr：扩展串：预留
/// 出参苏后面:Y:已审核 或 N:未审核 或 小于0^错误信息
ClassMethod CheckAuditFlag(PaadmDr, PbBillDr, ExpStr = "") As %String
{
	n (PaadmDr,PbBillDr,ExpStr)
	s $zt="CheckAuditFlagEx"
	q:($g(PaadmDr)="")&&($g(PbBillDr)="") "-1^就诊号和账单号不能同时为空"
	 //^DHCINAUD("0","AdmDr",{INAUD_Adm_Dr},{INAUD_Rowid})
	 //^DHCINAUD("0","PBDr",{INAUD_PB_Dr},{INAUD_Rowid})
    s RtnFlag = "N"
	i + PbBillDr >0 {
		s INAUDRowid="" ,RtnFlag="N"
		f  s INAUDRowid=$O(^DHCINAUD("0","PBDr",PbBillDr,INAUDRowid),-1) q:(INAUDRowid="")||(RtnFlag="Y")  d
		.d checkFlag
	} 
	
    i +PaadmDr >0 {
		s INAUDRowid="" ,RtnFlag="N"
		f  s INAUDRowid=$O(^DHCINAUD("0","AdmDr",PaadmDr,INAUDRowid),-1) q:(INAUDRowid="")||(RtnFlag="Y")  d
		.d checkFlag
	}
  
    q RtnFlag

checkFlag 
	s tOEORDIDr = $P($g(^DHCINAUD(INAUDRowid)),"^",3)
    s AuditFlag = $P($g(^DHCINAUD(INAUDRowid)),"^",16) //开始审核、审核完成或完成
    i (tOEORDIDr="")&&((AuditFlag="审核完成")||(AuditFlag="完成")) d
    .s RtnFlag="Y"
    q 
CheckAuditFlagEx 
 s $zt=""
 b ;CheckAuditFlagEx 
 q "-99^程序异常："_$ze
}

}
