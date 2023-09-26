Class web.INSUTest Extends %RegisteredObject
{

ClassMethod INVQUERYClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = INVQUERYExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod INVQUERYExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, PatientName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s i=0
	;增加查询条件：如果PRT_Inv=""   同时myInvDR=""  的原发票不再查询出来
	;而对于作废或红冲的纪录，需要查询原纪录，来看看是否能够显示此纪录
	;为了能够综合查询，所有的发票
	;sFlag=INV		;票据查询
	;sFlag=ALL		;所有纪录(DHC_INVPRT+DHC_AccPayINV)查询
	;sFlag=PRT		;只查询DHC_INVPRT表所有纪录，而不查询DHC_AccPayINV表
	;sFlag=APP		;只查询DHC_INVPRT表中账户支付的记录
	;sFlag=API		;只查询DHC_AccPayINV表中的纪录
	;
	;审批标志AuditFlag  只在DHC_INVPRT表中
	;=""  或"ALL"			查询所有的计费记录
	;="A"		;查询审批过的 计费记录
	;="C"		;查询没有审批计费记录DHC_INVPRT
	;s ^TMPDDsFlag=sFlag_"^"_StartDate_"^"_EndDate
	;************************************************************************
	;查询不同状态的发票
	;INVStatus
	;=""  或 ALL   查询所有发票
	;=N				查询正常发票
	;=SA            查询作废或红冲发票
	;************************************************************************
	;增加安全组和登陆科室参数
	;gLocDR  安全组的RowID
	;ULoadLocDR 登陆科室的RowID
	;
	;************************************************************************
	;************************************************************************
	;增加一个结算判断标志
	;INVFootFlag
	;=""  全部发票
	;=Y   表示结算
	;=N
	;************************************************************************
	
	
	;s ^TMPAuditFlag=AuditFlag_"^"_gLocDR_"^"_ULoadLocDR
	
	s myPAPMIStr=""
	/*i CardNo'=""{
		s myPAPMIStr=##class(web.DHCBL.CARD.UCardRefInfo).GetPAPMIBunchByCardNo(CardNo)
	}
	
	i (ReceipNO'=""){
		s ReceipNO=$ZCVT(ReceipNO,"U")
	}
	*/
	//i sFlag="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
	i StartDate="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
	i EndDate="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
	;i (((PatientNO'="")||$l(PatientNO)'=0)&&($l(PatientNO)<8)) d
	;.s mylen=$l(PatientNO)
	;.s tmpPNO=$EXTRACT("00000000",1,8-mylen)_PatientNO
	;.s PatientNO=tmpPNO
	//i PatientNO'="" d
	//.s PatientNO=##Class(web.DHCOPCashier).FormatPatientNo(PatientNO)
	
	;f PRTDate=StartDate:1:EndDate  d
	f PRTDate=EndDate:-1:StartDate  d
	.//q:(sFlag="API")
	.q:'$D(^DHCINVPRT(0,"Date",PRTDate))
	.s PrtRowid=""
	.f  s PrtRowid=$o(^DHCINVPRT(0,"Date",PRTDate,PrtRowid),-1) q:PrtRowid=""  d
	..s FairType=$p($G(^DHCINVPRT(PrtRowid)),"^",34)
	..q:FairType'="F"
	..s Abortflag=0,refundflag=0,handflag=0
	..s PrtUsrDR=$p($G(^DHCINVPRT(PrtRowid)),"^",21)	;;User Invitial
	..s PrtUsr=""
	..s myPrtUserName=""
	..i PrtUsrDR'="" d
	...s PrtUsr=$p($g(^SSU("SSUSR",PrtUsrDR)),"^",1)
	...s myPrtUserName=$p($g(^SSU("SSUSR",PrtUsrDR)),"^",2)
	..//q:((PrtUsr'=ChargeUser)&(ChargeUser'=myPrtUserName))&(ChargeUser'="")
	..//q:(PrtUsr'=ChargeUserA)&(ChargeUserA'="")
	..s SsusrName=""
	..i PrtUsrDR'=""  d
	...s SsusrName=$P($G(^SSU("SSUSR",PrtUsrDR)),"^",2)
	..s PrtNO=$p($G(^DHCINVPRT(PrtRowid)),"^",14)
	..s myapi=$p($G(^DHCINVPRT(PrtRowid)),"^",4)
	..i myapi'="" d
	...s PrtNO=$p($G(^DHCINVPRTAP(myapi)),"^",6)
	..//q:(PrtNO'=ReceipNO)&(ReceipNO'="")
	..s PapmiNo="",PapmiName=""
	..s PrtPapmiDR=$p($G(^DHCINVPRT(PrtRowid)),"^",15)
	..//q:((CardNo'="")&&(("^"_myPAPMIStr_"^")'[("^"_PrtPapmiDR_"^")))
	..;;;INSU
	..s strPat=$$GetPatInfoByPatID^DHCINSUPatInfo(PrtPapmiDR)
    ..s Name3=$p(strPat,"^",11) ;手册号
    ..q:Name3=""
    ..;;;;
	..i PrtPapmiDR'=""  d
	...s PapmiNo=$P($G(^PAPER(PrtPapmiDR,"PAT",1)),"^",2)
	...s PapmiName=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",1)
	..//q:(PapmiNo'=PatientNO)&(PatientNO'="")
	..q:(PapmiName'=PatientName)&(PatientName'="")
	..s Acount=$fn(+$p($G(^DHCINVPRT(PrtRowid)),"^",16),"",2)
	..s TotSum=$fn(+$p($G(^DHCINVPRT(PrtRowid)),"^",1),"",2)
	..s Flag=$p($G(^DHCINVPRT(PrtRowid)),"^",8)
	..s Handin=$p($G(^DHCINVPRT(PrtRowid)),"^",10)
	..s sTime=$p($G(^DHCINVPRT(PrtRowid)),"^",20)
	..s myInvDR=$p($G(^DHCINVPRT(PrtRowid)),"^",13)
	..//q:((PrtNO="")&(myInvDR="")&&(sFlag="INV"))			;查询发票时, 正常的支付小条退出
	..;对于账户支付的小条,查询
	..//q:((sFlag="APP")&(PrtNO'="")&(myInvDR=""))
	..s myInvNo=$p($G(^DHCINVPRT(PrtRowid)),"^",14)
	..;^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"P",{IPM_Sub})
	..s myPayMode=""
	..s myPMSub=$o(^DHCINVPRT(PrtRowid,"P",0))
	..s myPMDR=""
	..s:(myPMSub'="") myPMDR=$p($g(^DHCINVPRT(PrtRowid,"P",myPMSub)),"^",1)
	..i myPMDR'="" d
	...s myPayMode=$p(^CT("CTPM",myPMDR),"^",2)
	..s myVer=##class(web.DHCOPConfig).GetVersion()
	..i +myVer=7 d
	...s myPayMode=""
	...s myPMSub=0
	...f  s myPMSub=$o(^DHCINVPRT(PrtRowid,"P",myPMSub))  q:(myPMSub="")  d
	....s myPMDR=$p($g(^DHCINVPRT(PrtRowid,"P",myPMSub)),"^",1)
	....s myTMPPMSum=$p($g(^DHCINVPRT(PrtRowid,"P",myPMSub)),"^",3)
	....q:(+myTMPPMSum=0)
	....q:(myPMDR="")
	....i myPayMode="" d
	.....s myPayMode=$p($g(^CT("CTPM",myPMDR)),"^",2)
	....e  d
	.....s myPayMode=myPayMode_", "_$p(^CT("CTPM",myPMDR),"^",2)
	..q:((myInvDR'="")&&(myInvNo=""))
	..//q:((INVFlag'="")&(INVFlag'=Flag))
	..i Flag="A"  s Abortflag=1
	..i Flag="S"  s refundflag=1
	..//q:(INVStatus'="")&(INVStatus'=Flag)
	..i Handin="Y"  s handflag=1
	..q:handflag'=1
	..s myHandin=Handin
	..i myHandin="" s myHandin="N"
	..//q:(INVFootFlag'="")&(INVFootFlag'=myHandin)
	..s PRTParkDate=""
	..s sParkTime=""
	..s ParkUserName=""
	..i (Flag'="N") d
	...s ParkINVDR=$o(^DHCINVPRT(0,"InitInvDR",PrtRowid,0))
	...q:ParkINVDR=""
	...s PRTParkDate=$p($G(^DHCINVPRT(ParkINVDR)),"^",5)
	...s sParkTime=$p($G(^DHCINVPRT(ParkINVDR)),"^",20)
	...s ParkUserDR=$p($G(^DHCINVPRT(ParkINVDR)),"^",21)
	...s:ParkUserDR'="" ParkUserName=$p($g(^SSU("SSUSR",ParkUserDR)),"^",2)
	..i PRTParkDate'="" d
	...s PRTParkDate=$zd(PRTParkDate,3)
	..i sParkTime'="" d
	...s sParkTime=$zt(sParkTime,1)
	..s TabFlag="PRT"
	..s myYBPaySum=+$p($G(^DHCINVPRT(PrtRowid)),"^",31)
	..s myYBPaySum=$fn(myYBPaySum,"",2)
	..s myAllRefundUser=$p($G(^DHCINVPRT(PrtRowid)),"^",25)		;$p($G(^DHCINVPRT(PrtRowid)),"^",31)
	..s myAuditFlag="C"
	..;gLocDR As %String, ULoadLocDR As %String
	..;接口配置参数
	..//s myExpStr=gLocDR_"^"_ULoadLocDR
	..s myExpStr=""_"^"_""
	..s myrtn=##class(web.UDHCPRTOEAuthIF).ReadINVAuthFlag(PrtRowid, myExpStr)
	..s myAF=$p(myrtn,"^",1)
	..s myOEMixFlag=$p(myrtn,"^",2)
	..s myINVAuditLimit=$p(myrtn,"^",3)
	..q:(myINVAuditLimit="Y")			;对于安全组受限发票配置
	..i myAF="Y"  d
	...s myAuditFlag="A"
	..;增加处方科室和处方医生  专门针对大同来做
	..s myBillConINVDR=$o(^DHCBCI(0,"INV",PrtRowid,0))
	..s myAdmDR=$p(^DHCBCI(myBillConINVDR),"^",3)
	..S AdmDept=$p($g(^PAADM(myAdmDR)),"^",4)
	..S AdmDeptDesc=$p($g(^CTLOC(AdmDept)),"^",2)
	..;查找OE_OrdItem表的Doctor
	..s AdmDocName=##class(web.UDHCOEORDOPIF).ReadDOCByPRTRowID(PrtRowid,"")
	..If AdmDeptDesc["-" Set AdmDeptDesc=$p(AdmDeptDesc,"-",2)
	..;q:(AuditFlag'="")&(AuditFlag'=myAuditFlag)&(AuditFlag'="ALL")&(myOEMixFlag="")
	..s myaccpinvdr=$p($G(^DHCINVPRT(PrtRowid)),"^",4)
	..i myaccpinvdr'=""  d
	...s PrtNO=$p($G(^DHCINVPRTAP(myaccpinvdr)),"^",6)
	..s i=i+1
	..Do OutputRowINVQUERY
	
	;因为审批在DHC_INVPRT
	/*i ((AuditFlag'="")&(AuditFlag'="ALL")){
		;Set qHandle=$lb(0,repid,0)	
		;Quit $$$OK
	}
	
	i ((sFlag="PRT")!(sFlag="APP")){
		Set qHandle=$lb(0,repid,0)	
		Quit $$$OK
	}*/
	;加入集中打印发票的明细
	
	;f PRTDate=StartDate:1:EndDate  d
	f PRTDate=EndDate:-1:StartDate  d
	.q:'$D(^DHCINVPRTAPi(0,"Date",PRTDate))
	.s PrtRowid=""
	.f  s PrtRowid=$o(^DHCINVPRTAPi(0,"Date",PRTDate,PrtRowid),-1) q:PrtRowid=""  d
	..s Abortflag=0,refundflag=0,handflag=0
	..s PrtUsrDR=$p($G(^DHCINVPRTAP(PrtRowid)),"^",5)	;;User Invitial
	..s PrtUsr=""
	..s myPrtUserName=""
	..i PrtUsrDR'="" d
	...s PrtUsr=$p(^SSU("SSUSR",PrtUsrDR),"^",1)
	...s myPrtUserName=$p(^SSU("SSUSR",PrtUsrDR),"^",2)
	..//q:(PrtUsr'=ChargeUser)&(ChargeUser'="")&(ChargeUser'=myPrtUserName)
	..//q:(PrtUsr'=ChargeUserA)&(ChargeUserA'="")
	..s SsusrName=""
	..i PrtUsrDR'=""  d
	...s SsusrName=$P($G(^SSU("SSUSR",PrtUsrDR)),"^",2)
	..s PrtNO=$p($G(^DHCINVPRTAP(PrtRowid)),"^",6)
	..//q:(PrtNO'=ReceipNO)&(ReceipNO'="")
	..s PapmiNo="",PapmiName=""
	..s PrtPapmiDR=$p($G(^DHCINVPRTAP(PrtRowid)),"^",11)
	..;;;;INSU
	..s strPat=$$GetPatInfoByPatID^DHCINSUPatInfo(PrtPapmiDR)
    ..s Name3=$p(strPat,"^",11)  ;手册号
    ..q:Name3=""
    ..;;;
	..//q:((CardNo'="")&&(("^"_myPAPMIStr_"^")'[("^"_PrtPapmiDR_"^")))
	..i PrtPapmiDR'=""  d
	...s PapmiNo=$P($G(^PAPER(PrtPapmiDR,"PAT",1)),"^",2)
	...s PapmiName=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",1)
	..//q:(PapmiNo'=PatientNO)&(PatientNO'="")
	..q:(PapmiName'=PatientName)&(PatientName'="")
	..s Acount=$fn(+$p($G(^DHCINVPRTAP(PrtRowid)),"^",13),"",2)
	..s TotSum=$fn(+$p($G(^DHCINVPRTAP(PrtRowid)),"^",1),"",2)
	..s Flag=$p($G(^DHCINVPRTAP(PrtRowid)),"^",2)
	..;s Handin=$p($G(^DHCINVPRTAP(PrtRowid)),"^",10)
	..s myCheckDate=$p($G(^DHCINVPRTAP(PrtRowid)),"^",7)
	..s sTime=$p($G(^DHCINVPRTAP(PrtRowid)),"^",4)
	..s myInvDR=$p($G(^DHCINVPRTAP(PrtRowid)),"^",10)
	..q:((PrtNO="")&(myInvDR=""))			;被作废的小票退出
	..s myInvNo=$p($G(^DHCINVPRTAP(PrtRowid)),"^",6)
	..;^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"P",{IPM_Sub})  API_AccMan_DR
	..s myPayMode=""
	..s myPMSub=$o(^DHCINVPRTAP(PrtRowid,"P",0))
	..s myPMDR=""
	..s:(myPMSub'="") myPMDR=$p($g(^DHCINVPRTAP(PrtRowid,"P",myPMSub)),"^",1)
	..i myPMDR'="" d
	...s myPayMode=$p(^CT("CTPM",myPMDR),"^",2)
	..q:((myInvDR'="")&&(myInvNo=""))
	..i Flag="A"  s Abortflag=1
	..i Flag="S"  s refundflag=1
	..//q:(INVStatus'="")&(INVStatus'=Flag)
	..i myCheckDate'=""  s handflag=1
	..q:handflag'=1
	..s myHandin=""
	..i myCheckDate'="" s myHandin="Y"
	..i myHandin="" s myHandin="N"
	..//q:(INVFootFlag'="")&(INVFootFlag'=myHandin)
	..s PRTParkDate=""
	..s sParkTime=""
	..s ParkUserName=""
	..i (Flag'="N") d
	...s ParkINVDR=$o(^DHCINVPRTAPi(0,"APIDR",PrtRowid,0))
	...q:ParkINVDR=""
	...s PRTParkDate=$p($G(^DHCINVPRTAP(ParkINVDR)),"^",3)
	...s sParkTime=$p($G(^DHCINVPRTAP(ParkINVDR)),"^",4)
	...s ParkUserDR=$p($G(^DHCINVPRTAP(ParkINVDR)),"^",5)
	...s:ParkUserDR'="" ParkUserName=$p($g(^SSU("SSUSR",ParkUserDR)),"^",2)
	..i PRTParkDate'="" d
	...s PRTParkDate=$zd(PRTParkDate,3)
	..i sParkTime'="" d
	...s sParkTime=$zt(sParkTime,1)
	..s TabFlag="API"
	..s myYBPaySum=$p($G(^DHCINVPRTAP(PrtRowid)),"^",17)	;API_SelfYBPay
	..s myYBPaySum=$fn(myYBPaySum,"",2)
	..s AdmDocName=""
	..s AdmDeptDesc=""
	..s i=i+1
	..Do OutputRowINVQUERY
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowINVQUERY
	set Data=$lb(PrtRowid,PrtNO,PapmiNo,PapmiName,Acount,Abortflag,refundflag,handflag,SsusrName,$zd(PRTDate,3),$zt(sTime,1),PRTParkDate,sParkTime,ParkUserName,TotSum, myPayMode, TabFlag, myYBPaySum,Name3,i)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod INVQUERYFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = INVQUERYExecute ]
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

Query INVQUERY(StartDate As %String, EndDate As %String, PatientName As %String) As %Query(ROWSPEC = "TINVRowid:%String,TINVNO:%String,TPatID:%String,TPatName:%String,TAcount:%String,TAbort:%String,TRefund:%String,THandin:%String,TUser:%String,TDate:%String,TTime:%String,TParkDate:%String,TParkTime:%String,TParUName:%String,TotSum:%String,TPayMode:%String,TabFlag:%String,TYBSum:%String,Name3:%String,num:%String")
{
}

ClassMethod TestClassBack() As User.INSUDicData
{
	;s obj =##class(User.INSUDicData).%new()
	s obj =##class(User.INSUDicData).%OpenId(290)
	;w obj.INDIDDicCode,!
	q obj
}

}
