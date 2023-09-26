Import SQLUser

Class web.UDHCJFORDCHK Extends BILL.COM.Abstract
{

ClassMethod getpatshare(adm)
{
	q:(adm="") "^^^^^^"
	s sum=0, NotPaySum=0
	s total=0, disamt=0, payorshare=0, patshare=0
	s pb=""
	f  s pb=$o(^DHCPB(0,"ADM",adm,pb))  q:pb=""  d
    .s payedflag=$p(^DHCPB(pb),"^",16)
    .;q:payedflag="P"
    .s patshare=patshare+$p(^DHCPB(pb),"^",12)
    .s total=total+$p(^DHCPB(pb),"^",8)
    .i (payedflag'="P") d
    ..s NotPaySum=NotPaySum+$p(^DHCPB(pb),"^",12)
    .s disamt=disamt+$p(^DHCPB(pb),"^",9)
    .s payorshare=payorshare+$p(^DHCPB(pb),"^",11)
    .s YBZFPay=##Class(web.DHCINSUPort).GetDividePreByPBDr(pb)    ;医保预结算
    .i (payedflag="P")  d
    ..s insuStr=##class(web.DHCINSUPort).GetDivideByPBDr("",pb)    ;已经结算取结算数据  Add zhangli 17.8.14
    ..s insuStr1=$p(insuStr,"!^",2)
    ..s cash=$p(insuStr1,"^",15)
	..s bcbxf0=+$p(insuStr1,"^",7)				;总费用
	..s YBZFPay=bcbxf0-cash
    .s ZFPay=patshare-YBZFPay
    .;s YBZFPay=$p(YBPay,"^",2),ZFPay=$p(YBPay,"^",1)
    .;i (+YBZFPay++ZFPay="0") s ZFPay=sum
    
	q total_"^"_$g(YBZFPay)_"^"_$g(ZFPay)_"^"_disamt_"^"_payorshare_"^"_patshare_"^"_NotPaySum
}

/// w ##class(web.UDHCJFORDCHK).getpayinfo("","",608,"I")
ClassMethod getpayinfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", PatType As %String = "")
{
	set deposit=0,totalamount=0,balance=0
	set adm0=val
 
	;add by wangjian 2015-01-15 增加病人密级和级别
	set EncryptLevel="",PatLevel=""
	if (adm0'="") {
		set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel("", adm0)
		set EncryptLevel=$p(PatEncryptLevel,"^",1)
		set PatLevel=$p(PatEncryptLevel,"^",2)
	}
	;end
	if ((adm0'="")&&(PatType="O")) {
	 	//取门诊病人信息
	 	set tmp=##class(web.DHCOPBillEPManageCLS).getCurrAcountID(adm0)
	 	set deposit=$p(tmp,"^",3)	//急诊留观病人押金
	 	set tmp=##class(web.DHCOPBillStayCharge).GetStayTotalAmt(adm0, "", "")
	 	set totalamount=$p(tmp,"^",1)
	 	set disamt=$p(tmp,"^",2)
	 	set payorshare=$p(tmp,"^",3)
	 	set patshare=$p(tmp,"^",4)
	 	set YBZFPay=0	;急诊留观医保支付默认是0
	 	set balance=deposit-totalamount
	 }else {
		 //取住院病人信息
		 set deposit=##class(web.UDHCJFCKD).deposit(adm0)
		 set totalamountstr=..getpatshare(adm0)
		 set totalamount=$p(totalamountstr,"^",1)
		 set YBZFPay=$p(totalamountstr,"^",2)
		 set disamt=$p(totalamountstr,"^",4)
		 set payorshare=$p(totalamountstr,"^",5)
		 set patshare=$p(totalamountstr,"^",6)
		 set NotPatShareSum=$p(totalamountstr,"^",7)
		 set balance=deposit-NotPatShareSum
		 if (+YBZFPay'=0) {
			 set patshare=totalamount-YBZFPay
			 set balance=deposit-(totalamount-YBZFPay)
		 }
		 set AdmWarrantSum=##class(web.UDHCJFZYDB).GetWarrAmt(adm0) 
	 }
 
	 set str=$j(deposit,3,2)_"^"_$j(totalamount,3,2)_"^"_$j(balance,3,2)_"^"_$j(YBZFPay,3,2)_"^"_$j(disamt,3,2)_"^"_$j(payorshare,3,2)_"^"_$j(patshare,3,2)_"^"_EncryptLevel_"^"_PatLevel_"^"_$g(AdmWarrantSum)_"^"_+$G(NotPatShareSum)
	 set retval=itmjs_"('"_$zcvt(str,"O","JS")_"');"
	 if itmjsex'="""" set retval=retval_itmjsex_"('"_$zcvt(str,"O","JS")_"');"
	 &javascript<#(retval)#>
	 
	 quit 1
}

/// do ##class(%ResultSet).RunQuery("web.UDHCJFORDCHK","getadmno","0000000003","O")
Query getadmno(RegNo As %String, PatType As %String = "I") As websys.Query(ROWSPEC = "admno:%String,admdate:%String,admloc:%String,admtype:%String")
{
}

ClassMethod getadmnoExecute(ByRef qHandle As %Binary, RegNo As %String, PatType As %String = "I") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
	if (RegNo="")  quit $$$OK
	
	s RegNo=##class(web.UDHCJFBaseCommon).regnocon(RegNo)
	s admdate="",admloc=""
	s papmi=0
	f  s papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,papmi)) q:papmi=""  d
	.s name=$p(^PAPER(papmi,"ALL"),"^",1)
	.s type=""
	.f  s type=$o(^PAPERdr(papmi,"ADM",type)) q:type=""  d
	..q:(PatType="I")&&(type'="I")
	..q:(PatType="O")&&(type'="E")	;2015-03-26 Lid 只查询急诊的就诊记录，否则太多了
	..s adm=""
	..f  s adm=$o(^PAPERdr(papmi,"ADM",type,adm),-1) q:adm=""  d
	...s Rtn=##class(web.UDHCJFBaseCommon).GetPatAdmStayStat(adm)
	...s StayFlag=$p(Rtn,"^",1)
	...//q:(PatType="O")&&(StayFlag'="Y")	;门诊只查询留观就诊记录
	...s admloc=$p(^CTLOC($p(^PAADM(adm),"^",4)),"^",2)
	...s admdate=##class(websys.Conversions).DateLogicalToHtml($p(^PAADM(adm),"^",6))
	...s admtype="住院"
	...d OutputRow1
	
	quit $$$OK
	
OutputRow1
	set Data=$lb(adm,admdate,admloc,admtype)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod deposit(adm) As %String
{
	s x1="",depAmt=0                        ;table - AR_RcptAlloc
	f  s x1=$o(^ARRCP("Adm_DR",adm,x1)) q:x1=""  d
	.s x2="" 
	.f  s x2=$o(^ARRCP("Adm_DR",adm,x1,x2)) q:x2=""  d
	..q:+$p(^ARRCP(x1,"RAL",x2),"^",18)'=0
	..s deposit=$p(^ARRCP(x1,"RAL",x2),"^",2)
	..s depAmt=depAmt+deposit
	q +$g(depAmt)
}

Query ordcatlookup(desc As %String) As websys.Query(ROWSPEC = "ordcat:%String,ordcatid:%String")
{
}

ClassMethod ordcatlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	s rowid=0
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=desc_"%"
	&SQL(declare ordcat cursor  for 
	select orcat_rowid,orcat_desc from SQLUser.OEC_OrderCategory where orcat_desc like :desc)
	&SQL(open ordcat)
	f  &SQL(fetch ordcat into :ordcatrowid,:ordcatdesc) q:SQLCODE  d
 	.d OutputRow2
 	&SQL(close ordcat)
 	
	quit $$$OK
    
OutputRow2
	set Data=$lb(ordcatdesc,ordcatrowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// do ##class(%ResultSet).RunQuery("web.UDHCJFORDCHK","orderlookup","ys")
Query orderlookup(desc As %String) As websys.Query(ROWSPEC = "order:%String,orderid:%String")
{
}

ClassMethod orderlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	s rowid=0
	s ordDescStr=""
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s desc=desc_"%"
	&SQL(declare orderc cursor  for 
	select distinct alias_arcim_dr,alias_arcim_dr->arcim_desc
    from SQLUser.arc_ALIAS 
	              WHERE (UPPER(ALIAS_text) like :desc))
	&SQL(open orderc)
	f  &SQL(fetch orderc into :orderrowid,:orderdesc) q:SQLCODE  d
	.q:orderdesc=""
	.s ordDescStr=orderdesc
 	.Do OutputRow3 	 	
 	&SQL(close orderc)
 	if (ordDescStr="") d
 	.&SQL(declare orderc1 cursor  for 
	 select distinct alias_arcim_dr,alias_arcim_dr->arcim_desc
     from SQLUser.arc_ALIAS 
	              WHERE (UPPER(ALIAS_Desc) like :desc))
 	.&SQL(open orderc1)
	.f  &SQL(fetch orderc1 into :orderrowid,:orderdesc) q:SQLCODE  d
	..q:orderdesc=""
 	..do OutputRow3	
 	.&SQL(close orderc1)
 	
	quit $$$OK
    
OutputRow3
	set Data=$lb(orderdesc,orderrowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod Judge(Adm)
{
	q:(Adm="") "0^^"
	s AdmType=$p(^PAADM(Adm),"^",2)
	s n=0
	s rowid="", payedflag=""
	s pb=0
	f  s pb=$o(^DHCPB(0,"ADM",Adm,pb)) q:(pb="")  d
	.s payedflag=$p(^DHCPB(pb),"^",16)
	.s PaidCAcountFlag=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(pb)
	.q:((payedflag="P")&&(PaidCAcountFlag'="Y"))
	.s n=n+1
	.s rowid=pb
	q n_"^"_rowid_"^"_payedflag_"^"_AdmType
}

Query getpatbill(adm As %String, langId As %String = "") As websys.Query(ROWSPEC = "Tpatname:%String,Tpatno:%String,Tadmdate:%String,Tdisdate:%String,Tpatfee:%String,Tbillno:%String,Tstatus:%String")
{
}

ClassMethod getpatbillExecute(ByRef qHandle As %Binary, adm As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (+adm=0) quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set papmi=$p(^PAADM(adm),"^",1)
	set patName=$p(^PAPER(papmi,"ALL"),"^",1)
	set patNo=$p(^PAPER(papmi,"PAT",1),"^",1)

	set admInOutStr=##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(adm)
	set admDate=$p(admInOutStr,"^",5)
	set disDate=$p(admInOutStr,"^",7)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set disDate=##class(websys.Conversions).DateLogicalToHtml(disDate)

	set pb=0
	while($o(^DHCPB(0,"ADM",adm,pb))) {
		set pb=$o(^DHCPB(0,"ADM",adm,pb))
		set pbData=$g(^DHCPB(pb))
		set patfee=$p(pbData,"^",8)
		set patfee=$fn(patfee,"",2)
		set refundFlag=$p(pbData,"^",17)
		continue:(refundFlag'="")
		set prtRowId=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(pb)
		if (+prtRowId'=0) {
			set status="已结算"
		}else {
			set isCloseAcount=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(pb)
			set status=$case(isCloseAcount,"Y":"已封账",:"未结算")
		}
		set status=##class(websys.Translation).Get("", status, langId)
		do OutputPatBill
	}
	
	quit $$$OK
OutputPatBill
	set Data=$lb(patName,patNo,admDate,disDate,patfee,pb,status)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Debug: w ##class(web.UDHCJFORDCHK).getmotheradm(4)
ClassMethod getmotheradm(adm As %String) As %String
{
    set babyFlag="false"
    set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	set cfgId=##class(web.DHCBillCommon).GetTarParaId(hospDR)
	set newBornToMother=$s((+cfgId'=0):$p(^DHCTarC("CF",cfgId),"^",5),1:"")
	set mother=$p(^PAADM(adm),"^",75)
    if ((mother'="")&&(newBornToMother="Y")) {
    	set babyFlag="true"
    }
    quit babyFlag
}

/// Creator: Lid
/// CreatDate: 2015-06-08
/// Description: 根据婴儿Adm获取母亲Adm
/// Input: adm: 婴儿就诊号
/// Return：是否是婴儿的标志^母亲就诊id
/// Debug: w ##class(web.UDHCJFORDCHK).GetMotherAdmByBabyAdm(723)
ClassMethod GetMotherAdmByBabyAdm(adm As %String) As %String
{
    set babyFlag="false"
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	set cfgId=##class(web.DHCBillCommon).GetTarParaId(hospDR)
	set newBornToMother=$s((+cfgId'=0):$p(^DHCTarC("CF",cfgId),"^",5),1:"")
	set mother=$p(^PAADM(adm),"^",75)
    if ((mother'="")&&(newBornToMother="Y")) {
	    set babyFlag="true"
	}
    quit babyFlag_"^"_mother
}

/// 财务结算时增加审核费用标志
/// 修改PA_Adm表的信息，paadm_codingupdatedate,paadm_codingupddatetime,paadm_codingupdateuser_dr
ClassMethod UpdateCodingFlag(Adm, Guser)
{
	s confirmflag=..GetCodingFlag(Adm)
	s visitstatus=$p(confirmflag,"^",1)
	s ConfirmFlag=$p(confirmflag,"^",2)
	q:(visitstatus'="D") ""
	q:((visitstatus="D")&&(ConfirmFlag="Y")) "Y"
	s upddate=+$h
	s updtime=$p($h,",",2)
	&SQL(
		UPDATE PA_Adm
		SET PAADM_CodingUpdateDate = :upddate, PAADM_CodingUpdateTime = :updtime,PAADM_CodingUpdateUser_DR = :Guser
		WHERE %ID = :Adm
	)
	s rtn=SQLCODE
	i (+rtn) q rtn_"^"_$g(%msg)
	s ^DHCZYJFConfirm("Confirm",Guser,upddate,updtime,Adm)=upddate_"^"_updtime_"^"_Adm_"^"_Guser
	q rtn
}

/// 判断是否已经审核，如果做了最终结算才判断是否审核，中途结算不判断
ClassMethod GetCodingFlag(Adm)
{
	s ConfirmFlag="N"
	s VisitStatus=$p(^PAADM(Adm),"^",20)
	i (VisitStatus'="D") s ConfirmFlag="Y"
	i (VisitStatus="D") d
	.s CodingUpdateUser=$p(^PAADM(Adm,2),"^",92)
	.i $g(CodingUpdateUser)="" s ConfirmFlag="N"
	.e  s ConfirmFlag="Y"
	
	q VisitStatus_"^"_ConfirmFlag
}

ClassMethod ConfirmOrder(User As %String, ConfOrdStr As %String, ConfPBOStr As %String, Status As %String, Reason As %String)
{
	s $zt="ERROR"
	
	q:(User="") "UserNull^"
	q:(Status="D")&&(Reason="") -101
	s rtn=0	
	
	ts
    
    s DrugNum=0
   
	i ConfOrdStr'=""   d
	.s len=$l(ConfOrdStr,"^")
	.f i=1:1:len  q:(+rtn)  d
	..s orditm=$p(ConfOrdStr,"^",i)
	..q:(orditm="")||(orditm'["||")
	..s Itm=+orditm,Cld=$p(orditm,"||",2)
	..q:'$d(^OEORD(Itm,"I",Cld))
	..s PrioDr=$p(^OEORD(Itm,"I",Cld,1),"^",8)
	..s itmstat=$p(^OEORD(Itm,"I",Cld,1),"^",13)
    ..s itmstat=$p(^OEC("OSTAT",itmstat),"^",1)
    ..s Priority=$s((+PrioDr'=0):$p($g(^OECPR(PrioDr)),"^",1),1:"")
	..s DrugAuditFlag=1
	..i (Priority="OUT")&&(itmstat'="D")&&(itmstat'="U")&&(Status["C") d
	...s DrugAuditFlag=##class(web.DHCSTKUTIL).GetDrugAuditFlag(orditm)   ;判断出院带药是否有审核,如果没有审核则不允许审核
	...i (DrugAuditFlag=0) s DrugNum=DrugNum+1
	..q:(Priority="OUT")&&(DrugAuditFlag=0)&&(Status["C")
    ..s Cbill=0
    ..f  s Cbill=$o(^DHCPBi(0,"OEORI",orditm,Cbill))  q:(Cbill="")   d
    ...s pbData=$g(^DHCPB(Cbill))
    ...q:(pbData="")
    ...s billFlag=$p(pbData,"^",16)
    ...q:(billFlag="P")
    ...s BillNo=Cbill
    ...s pbo=0
    ...f  s pbo=$o(^DHCPBi(0,"OEORI",orditm,BillNo,pbo)) q:(pbo="")  d
    ....s pboData=$g(^DHCPB(BillNo,"O",pbo))
    ....q:(pboData="")
    ....s Cpbo=BillNo_"||"_pbo
	....s confdr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",+BillNo,""))
	....s confflag=""
	....s confsub=$s((confdr'=""):$o(^DHCIPBillPatFeeConfirmi(0,"PBO",Cpbo,confdr,""),-1),1:"")
	....q:(confsub'="")
	....i (confdr="") d
	.....k PLIST
	.....s PLIST(2)=BillNo
	.....s PLIST(6)="U"
	.....s PLIST(10)="U"
	.....s PLIST(7)=+$h
	.....s PLIST(8)=$p($h,",",2)
	.....s PLIST(9)=User
	.....&SQL(INSERT INTO DHC_IPBillPatFeeConfirm VALUES PLIST())
	.....s rtn=rtn+SQLCODE
	.....q:(+rtn)
	.....s confdr=$g(%ROWID)
	....i (confdr="") s rtn=-102
	....q:(+rtn)
	....s confdate=+$h
	....s conftime=$p($h,",",2)
	....s confflag=Status
	....k PLIST
	....s PLIST(0)=confdr
	....s PLIST(3)=orditm
	....s PLIST(4)=confdate
	....s PLIST(5)=conftime
	....s PLIST(6)=User
	....s PLIST(7)=confflag
	....s PLIST(8)=Cpbo
	....s PLIST(9)=Reason
	....&SQL(INSERT INTO DHC_IPBillPatOrderConfirm VALUES PLIST())
	....s rtn=rtn+SQLCODE
	....//modify 2014-03-24 增加 DHC_IPBillPatDetailConfirm 表记录账单dhc_patbilldetails表审核记录
	....s conforddr=$g(%ROWID)
	....i (rtn=0) d
	.....s PBDSub=0
	.....f  s PBDSub=$o(^DHCPB(BillNo,"O",pbo,"D",PBDSub))  q:(PBDSub="")  d 
	......s PBDRowid=BillNo_"||"_pbo_"||"_PBDSub
	......s PBDTotalAmt=$p(^DHCPB(BillNo,"O",pbo,"D",PBDSub),"^",7)
	......s PBDPayorAmt=$p(^DHCPB(BillNo,"O",pbo,"D",PBDSub),"^",9)
	......s PBDDiscAmt=$p(^DHCPB(BillNo,"O",pbo,"D",PBDSub),"^",8)
	......s PBDPatAmt=$p(^DHCPB(BillNo,"O",pbo,"D",PBDSub),"^",10)
	......k PLIST
	......s PLIST(2)=confdr
	......s PLIST(3)=conforddr
	......s PLIST(4)=orditm
	......s PLIST(5)=PBDRowid
	......s PLIST(6)=confdate
	......s PLIST(7)=conftime
	......s PLIST(8)=User
	......s PLIST(9)=confflag
	......s PLIST(10)=PBDTotalAmt
	......s PLIST(11)=PBDPayorAmt
	......s PLIST(12)=PBDDiscAmt
	......s PLIST(13)=PBDPatAmt
	......s PLIST(14)=Reason
	......&SQL(INSERT INTO DHC_IPBillPatDetailConfirm VALUES PLIST())
	......s rtn=rtn+SQLCODE
	...q:(+rtn)
	i (ConfOrdStr="")&&(ConfPBOStr'="")  d
	.s len=$l(ConfPBOStr,"^")
	.f i=1:1:len  q:(+rtn)  d
	..s pbodr=$p(ConfPBOStr,"^",i)
	..q:(pbodr="")||(pbodr'["||")
	..s Cbill=+pbodr, Cbord=$p(pbodr,"||",2) 
	..q:'$d(^DHCPB(Cbill,"O",Cbord))
	..s orditm=$p(^DHCPB(Cbill,"O",Cbord),"^",4)
	..s Itm=+orditm, Cld=$p(orditm,"||",2)
	..s PrioDr=$p(^OEORD(Itm,"I",Cld,1),"^",8)
	..s itmstat=$p(^OEORD(Itm,"I",Cld,1),"^",13)
    ..s itmstat=$p(^OEC("OSTAT",itmstat),"^",1)
    ..s Priority=$s((+PrioDr'=0):$p($g(^OECPR(PrioDr)),"^",1),1:"")
	..s DrugAuditFlag=1
	..i (Priority="OUT")&&(itmstat'="D")&&(itmstat'="U")&&(Status["C") d
	...s DrugAuditFlag=##class(web.DHCSTKUTIL).GetDrugAuditFlag(orditm)   ;判断出院带药是否有审核,如果没有审核则不允许审核
	...i DrugAuditFlag=0 s DrugNum=DrugNum+1
	..q:(Priority="OUT")&&($g(DrugAuditFlag)=0)&&(Status["C")
    ..s billFlag=$p(^DHCPB(Cbill),"^",16)
    ..q:(billFlag="P")
    ..s BillNo=Cbill
   	..s confdr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",+BillNo,""))
	..s confsub=$s((confdr'=""):$o(^DHCIPBillPatFeeConfirmi(0,"PBO",pbodr,confdr,""),-1),1:"")
	..s confflag=$s((confsub'=""):$p(^DHCIPBillPatFeeConfirm(confdr,"O",confsub),"^",3),1:"")
	..q:(confflag=Status)
	..q:((Status["R")&&(confsub=""))||((Status["D")&(Reason=""))
	..i (confdr="") d
	...k PLIST
	...s PLIST(2)=BillNo
	...s PLIST(6)="U"
	...s PLIST(10)="U"
	...s PLIST(7)=+$h
	...s PLIST(8)=$p($h,",",2)
	...s PLIST(9)=User
	...&SQL(INSERT INTO DHC_IPBillPatFeeConfirm VALUES PLIST())
	...s rtn=rtn+SQLCODE
	...q:(+rtn)
	...s confdr=$g(%ROWID)
	..i (confdr="")  s rtn=-102 
	..q:(+rtn)
	..i $g(confsub)'=""  d
	...s conford=confdr_"||"_confsub
	...s confdate=+$h
	...s conftime=$p($h,",",2)
	...s confusr=User
	...s confflag=Status
	...s refreason=$p(^DHCIPBillPatFeeConfirm(confdr,"O",confsub),"^",7)
	...i (Status["D") s refreason=Reason
	...&SQL(UPDATE DHC_IPBillPatOrderConfirm set ConfSub_ConfirmDate=:confdate,ConfSub_ConfirmTime=:conftime,ConfSub_ConfirmUser=:confusr,ConfSub_ConfirmStatus=:confflag,ConfSub_RefReason=:refreason WHERE ConfSub_Rowid=:conford)
	...s rtn=rtn+SQLCODE
	...//modify 2014-03-24 增加 DHC_IPBillPatDetailConfirm 表记录账单dhc_patbilldetails表审核记录
	...i (rtn=0) d
	....s PBDSub=0
	....f  s PBDSub=$o(^DHCPB(BillNo,"O",Cbord,"D",PBDSub))  q:(PBDSub="")  d
	.....s PBDData=$g(^DHCPB(BillNo,"O",Cbord,"D",PBDSub))
	.....q:(PBDData="")
	.....s PBDRowid=BillNo_"||"_Cbord_"||"_PBDSub
	.....s PBDTotalAmt=$p(PBDData,"^",7)
	.....s PBDPayorAmt=$p(PBDData,"^",9)
	.....s PBDDiscAmt=$p(PBDData,"^",8)
	.....s PBDPatAmt=$p(PBDData,"^",10)
	.....s ConfDRowid=$o(^DHCIPBillPatDetailConfirm(0,"PatDetail",PBDRowid,"0"))
	.....s refreason=$p(^DHCIPBillPatDetailConfirm(ConfDRowid),"^",13)
	.....i (Status["D") s refreason=Reason
	.....i (ConfDRowid'="")  d
	......&SQL(
			update DHC_IPBillPatDetailConfirm
	   		set ConfD_Date=:confdate,ConfD_Time=:conftime,ConfD_User=:User,ConfD_Status=:confflag,ConfD_TotalAmt=:PBDTotalAmt,
	         	ConfD_PayorAmt=:PBDPayorAmt,ConfD_DiscAmt=:PBDDiscAmt,ConfD_PatientAmt=:PBDPatAmt,ConfD_Note1=:refreason
			where %ID=:ConfDRowid)
    ......s rtn=rtn+SQLCODE
    .....e  d 
	......k PLIST
	......s PLIST(2)=confdr
	......s PLIST(3)=conford
	......s PLIST(4)=orditm
	......s PLIST(5)=PBDRowid
	......s PLIST(6)=confdate
	......s PLIST(7)=conftime
	......s PLIST(8)=User
	......s PLIST(9)=confflag
	......s PLIST(10)=PBDTotalAmt
	......s PLIST(11)=PBDPayorAmt
	......s PLIST(12)=PBDDiscAmt
	......s PLIST(13)=PBDPatAmt
	......s PLIST(14)=Reason
	......&SQL(INSERT INTO DHC_IPBillPatDetailConfirm VALUES PLIST())
	......s rtn=rtn+SQLCODE
	..e    d
	...//modify 2014-03-24 增加 DHC_IPBillPatDetailConfirm 表记录账单dhc_patbilldetails表审核记录
	...s confdate=+$h
	...s conftime=$p($h,",",2) 
	...s confflag=Status
	...K PLIST
	...s PLIST(0)=confdr
	...s PLIST(3)=orditm
	...s PLIST(4)=confdate
	...s PLIST(5)=conftime
	...s PLIST(6)=User
	...s PLIST(7)=confflag
	...s PLIST(8)=pbodr
	...s PLIST(9)=Reason
	...&SQL(INSERT INTO DHC_IPBillPatOrderConfirm VALUES PLIST())
	...s rtn=rtn+SQLCODE
	...//modify 2014-03-24 增加 DHC_IPBillPatDetailConfirm 表记录账单dhc_patbilldetails表审核记录
	...s conforddr=$P($g(%ROWID),$C(1))
	...i (rtn=0) d
	....s PBDSub=0
	....f  s PBDSub=$o(^DHCPB(BillNo,"O",Cbord,"D",PBDSub))  q:(PBDSub="")  d
	.....s PBDData=$g(^DHCPB(BillNo,"O",Cbord,"D",PBDSub))
	.....s PBDRowid=BillNo_"||"_Cbord_"||"_PBDSub
	.....s PBDTotalAmt=$p(PBDData,"^",7)
	.....s PBDPayorAmt=$p(PBDData,"^",9)
	.....s PBDDiscAmt=$p(PBDData,"^",8)
	.....s PBDPatAmt=$p(PBDData,"^",10)
	.....k PLIST
	.....s PLIST(2)=confdr
	.....s PLIST(3)=conforddr
	.....s PLIST(4)=orditm
	.....s PLIST(5)=PBDRowid
	.....s PLIST(6)=confdate
	.....s PLIST(7)=conftime
	.....s PLIST(8)=User
	.....s PLIST(9)=confflag
	.....s PLIST(10)=PBDTotalAmt
	.....s PLIST(11)=PBDPayorAmt
	.....s PLIST(12)=PBDDiscAmt
	.....s PLIST(13)=PBDPatAmt
	.....s PLIST(14)=Reason
	.....&SQL(INSERT INTO DHC_IPBillPatDetailConfirm VALUES PLIST())
	.....s rtn=rtn+SQLCODE
	..q:(+rtn)
	
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn_"^"_DrugNum

ERROR
	quit ..AppException()
}

/// Creator: zhuangna
/// CreatDate: 2015-08-24
/// Description: 费用核对:退费
/// Input: OrdExcRowID,Type,Guser,ctLoc,Group
/// Return: 
/// Debug: w ##class(web.UDHCJFORDCHK).CheckStopOrder()
ClassMethod CheckStopOrderbak(OrdExcRowID, Type, Guser, ctLoc, Group) As %String
{
	s rtn=0
	q:OrdExcRowID="" "医嘱执行记录为空!"
	s Order=$p(OrdExcRowID,"||",1)										//医嘱
	s OrdItem=$p(OrdExcRowID,"||",2)									//医嘱子表
	s OrdItemExec=$p(OrdExcRowID,"||",3)								//医嘱执行记录sub
  	s PriorityDR=$p($g(^OEORD(Order,"I",OrdItem,1)),"^",8)				//2015-08-20 zhuangna 医嘱类型
  	s PriorityCode=$p($g(^OECPR(PriorityDR)),"^",1)						//2015-08-20 zhuangna 医嘱类型code
  	s OeoriRowId=Order_"||"_OrdItem
  	i (PriorityCode="NORM")  d
  	.s flag=0
	.s rtn=##class(appcom.OEOrdItem).CheckSingleStop(OeoriRowId,Guser)  //判断是否可以单独停止的子医嘱
    .i rtn=1 s flag=1
	.s:flag=0 flag = ##class(web.DHCDocMain).CheckCancelOrder(OeoriRowId,Guser,ctLoc,Group)
	.if flag=0 d    //值得商榷
	..s OrdUserId=$p($g(^OEORD(Order,"I",OrdItem,7)),"^",1)	;开单用户
	..i (OrdUserId=1) s flag=1  //系统规则生成的医嘱 放开护士可以退费
	.i (flag=1) d
	..s OrderStatusdr=$p(^OEORD(Order,"I",OrdItem,"X",OrdItemExec),"^",16)
  	..i OrderStatusdr=1 d  //只有已执行才先取消执行
	...s rtn=##class(appcom.OEOrdExec).UpdateStatus(OrdExcRowID,"C",Guser)
	..s rtn=##class(appcom.OEOrdItem).CancelMulti(OeoriRowId,Guser,"N","N")
	.e  d
	..s str1 = ^OEORD(+OeoriRowId,"I",$p(OeoriRowId,"||",2),1)
	..s ItmMastDR=$p(str1,"^",2)
	..s TOrderDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	;医嘱名称
	..s rtn = "您无权撤销 "_TOrderDesc_" 医嘱!"
  	i (PriorityCode="S")  d
  	.s OrderStatusdr=$p(^OEORD(Order,"I",OrdItem,"X",OrdItemExec),"^",16)
  	.i OrderStatusdr=1 d  //只有已执行才先取消执行
	..s rtn=##class(appcom.OEOrdExec).UpdateStatus(OrdExcRowID,"C",Guser)
	..i (rtn=0) s rtn=##class(appcom.OEOrdExec).UpdateStatus(OrdExcRowID,"D",Guser)
	..e  q:rtn
	.e  d
	..s rtn=##class(appcom.OEOrdExec).UpdateStatus(OrdExcRowID,"D",Guser)
	
	q rtn
}

/// Creator: zhuangna
/// CreatDate: 2015-08-24
/// Description: 费用核对:退费
/// Input: OrdExcRowID,Type,Guser,ctLoc,Group
/// Return:	
/// Debug: w ##class(web.UDHCJFORDCHK).CheckStopOrder()
ClassMethod CheckStopOrder(OrdExcRowID, Type, Guser, ctLoc, Group) As %String
{
	s rtn=0
	q:OrdExcRowID="" "医嘱执行记录为空"
	s Order=$p(OrdExcRowID,"||",1)										//医嘱
	s OrdItem=$p(OrdExcRowID,"||",2)									//医嘱子表
	s OrdItemExec=$p(OrdExcRowID,"||",3)								//医嘱执行记录sub
  	s PriorityDR=$p($g(^OEORD(Order,"I",OrdItem,1)),"^",8)				//2015-08-20 zhuangna 医嘱类型
  	s PriorityCode=$p($g(^OECPR(PriorityDR)),"^",1)						//2015-08-20 zhuangna 医嘱类型code
  	s OeoriRowId=Order_"||"_OrdItem
  	i (PriorityCode="NORM") d
  	.s str1=$g(^OEORD(+OeoriRowId,"I",$p(OeoriRowId,"||",2),1))
	.s ItmMastDR=$p(str1,"^",2)
	.s TOrderDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	//医嘱名称
  	.s flag=0
  	.//判断子类
  	.s ItmMastDR=$p($g(^OEORD(Order,"I",OrdItem,1)),"^",2)
	.s mastItemCat=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)			;护士站配置 子类	
    .if $g(^DHCOEOrdPrintSet("NotSordCat"))[("^"_mastItemCat_"^") s flag=1
    .s arcicOrdCatDR=$p(^ARC("IC",mastItemCat),"^",8)      //护士站配置 大类
    .if $g(^DHCOEOrdPrintSet("NotOrdCat"))[("^"_arcicOrdCatDR_"^") s flag=1
    .s DoctorDr=$p($g(^OEORD(Order,"I",OrdItem,1)),"^",11) 
	.i (DoctorDr="") s flag=1   //绑定医护人员为空的项目 晚上滚动的项目
  	.//s rtn=##class(appcom.OEOrdItem).CheckSingleStop(OeoriRowId,Guser)  //判断是否可以单独停止的子医嘱
    .i (flag=0) d
    ..s rtn="您无权撤销 "_TOrderDesc_" 医嘱,非可停的子类!"
    .//判断科室
    .i (flag=1) d
  	..s Linkloc="",DeptStr=""
  	..s OrdDeptId=$p($g(^OEORD(Order,"I",OrdItem,7)),"^",2)	;开单科室
    ..i (OrdDeptId'="") d
    ...s DeptStr=OrdDeptId
    ...s Linkloc=##class(web.DHCDocOrderCommon).GetLocLinkLocation(OrdDeptId)
    ...i (Linkloc'="") s DeptStr=DeptStr_"^"_Linkloc
    ...if (DeptStr'="")&&("^"_DeptStr_"^")[("^"_ctLoc_"^") d
    ....s rtn="您无权撤销 "_TOrderDesc_" 医嘱,非本科人员!"
    ....s flag=0
	.i (flag=1) d
	..s OrderStatusdr=$p(^OEORD(Order,"I",OrdItem,"X",OrdItemExec),"^",16)
  	..i (OrderStatusdr=1) d  //只有已执行才先取消执行
	...s rtn=##class(appcom.OEOrdExec).UpdateStatus(OrdExcRowID,"C",Guser)
	..
	..s rtn=##class(appcom.OEOrdItem).CancelMulti(OeoriRowId,Guser,"N","N")
  	i (PriorityCode="S")  d
  	.s OrderStatusdr=$p(^OEORD(Order,"I",OrdItem,"X",OrdItemExec),"^",16)
  	.i OrderStatusdr=1 d  //只有已执行才先取消执行
	..s rtn=##class(appcom.OEOrdExec).UpdateStatus(OrdExcRowID,"C",Guser)
	..i (rtn=0) s rtn=##class(appcom.OEOrdExec).UpdateStatus(OrdExcRowID,"D",Guser)
	..e  q:rtn
	.e  d
	..s rtn=##class(appcom.OEOrdExec).UpdateStatus(OrdExcRowID,"D",Guser)
	
	q rtn
}

}
