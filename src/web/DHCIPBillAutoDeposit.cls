Import SQLUser

/// Creator:Lid
/// CreatDate:2013-0219
/// Desc:住院自助机交押金业务
Class web.DHCIPBillAutoDeposit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:Lid
/// CreatDate:2012-02-07
/// Desc: 根据卡号及日期查询就诊记录
/// Input:
/// Return:
/// Debug:w ##class(web.DHCIPBillAutoDeposit).GetIPPatientInfo(^Lid(111))
ClassMethod GetIPPatientInfo(Input As %String) As %String
{
	Set $ZT="GetIPPatientInfoET"
	New (Input)
	Set InputObj=##class(web.DHCEntity.PCA.IPPatientInfoRequest).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    
    Set TerminalID=InputObj.TerminalID
    Set HospitalId=InputObj.HospitalId
    Set ExtUserID=InputObj.ExtUserID
    Set CardNo=InputObj.PatientCard
    Set CardType=InputObj.CardType
    Set SecrityNo=InputObj.SecrityNo
  	;
  	Set OutputXML=""
  	Set OutputObj=##class(web.DHCEntity.PCA.IPPatientInfoResponse).%New()
    if ((CardNo="")!($p(CardNo,$c(0))="")){
	   Set OutputObj.ResultCode=-1
	   Set OutputObj.ResultContent="此卡号不存在"
	   Set OutputXML=""
	   Do OutputObj.XMLExportToString(.OutputXML,"Response")
	   Do OutputObj.%Close()
	}
	Quit:CardNo="" OutputXML
    ;
    Set BaseInfo=..GetPatCommInfoByCardNo(CardNo,SecrityNo)
    set AdmID=$p(BaseInfo,"^",1)
    Set OutputObj.PatientID=$p(BaseInfo,"^",2)
    Set OutputObj.PatientName=$p(BaseInfo,"^",3)
    Set OutputObj.SexCode=$p(BaseInfo,"^",4)
    Set OutputObj.Sex=$p(BaseInfo,"^",5)
    Set OutputObj.DOB=$p(BaseInfo,"^",6)
    Set OutputObj.MRID=$p(BaseInfo,"^",7)
    Set OutputObj.Address=$p(BaseInfo,"^",8)
    Set OutputObj.IDTypeCode=$p(BaseInfo,"^",9)
    Set OutputObj.IDType=$p(BaseInfo,"^",10)
    Set OutputObj.IDNo=$p(BaseInfo,"^",11)
    Set OutputObj.PatType=$p(BaseInfo,"^",12)
    Set OutputObj.AdmID=$p(BaseInfo,"^",1)
    Set OutputObj.AdmDate=$p(BaseInfo,"^",14)
    Set OutputObj.AdmLoc=$p(BaseInfo,"^",15)
    Set OutputObj.DepositAmount=$p(BaseInfo,"^",16)
    If (AdmID'=""){
		Set OutputObj.ResultCode=0
		Set OutputObj.ResultContent="获取就诊记录成功"    
	}Else{
		Set OutputObj.ResultCode=-3
		Set OutputObj.ResultContent="此病人不在院."	
	}
	Do OutputObj.XMLExportToString(.OutputXML,"Response") 
	b ;111
 	Do OutputObj.%Close()
	Quit OutputXML
	;
GetIPPatientInfoET
	Set OutputObj=##class(web.DHCEntity.PCA.IPPatientInfoResponse).%New()
	Set OutputObj.ResultCode=-10
	Set OutputObj.ResultContent="程序处理错误:"_$ZERROR
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	Quit OutputXML
}

/// Creator:wangjian
/// CreatDate:2013-02-19
/// Description:通过卡号得到病人基本信息和就诊信息
/// w ##class(web.DHCIPBillAutoDeposit).GetPatCommInfoByCardNo("000000003665904","")
ClassMethod GetPatCommInfoByCardNo(cardno, secrityno)
{
	n (cardno,secrityno)
	s rtn=""
	s cardid=0
	f  s cardid=$o(^DHCCARDi("CF",0,"CardNo",cardno,cardid)) q:(cardid="")  d
	.b ;
	.s ActiveFlag=$p(^DHCCARD("CF",cardid),"^",10)
	.q:ActiveFlag'="N"
	.s papmiid=$p(^DHCCARD("CF",cardid),"^",4)
    .s adm=""
    .f  s adm=$o(^PAPERdr(papmiid,"ADM","I",adm)) q:adm=""  d
    ..s PaitentID=$p(^PAADM($g(adm)),"^",1)
    ..s dep=$p(^PAADM(adm),"^",4),currward=$p(^PAADM(adm),"^",70)
	..s admtype=$p(^PAADM(adm),"^",2)
	..q:admtype'="I"
	..s visitstatus=$p(^PAADM(adm),"^",20)
	..q:visitstatus'="A"
	..i currward'=""  d  s patward=$p(^PAWARD(currward),"^",2)
	..e  d  s patward=""
	..s papmi=$p(^PAADM(adm),"^",1),patname=$p(^PAPER(papmi,"ALL"),"^",1),patregno=$p(^PAPER(papmi,"PAT",1),"^",1)
	..s sexid=$p(^PAPER(papmi,"ALL"),"^",7),sex=$p(^CT("SEX",sexid),"^",2),sexcode=$p(^CT("SEX",sexid),"^",1)
	..s zyno=$p(^PAPER(papmi,"PAT",1),"^",22)
	..i $d(^PAPER(papmi,"PER","ADD",1)) d
	...s Address=^PAPER(papmi,"PER","ADD",1)  ;地址 
	..s admdate=$zd($p(^PAADM(adm),"^",6),3)
	..s patloc=$p(^CTLOC(dep),"^",2)
	..s billflag=$p(^PAADM(adm),"^",45)
	..i billflag'["Y"  d
	...s patfee=##class(web.UDHCJFCKD).totalamount(adm) 
	...s deposit=##class(web.UDHCJFCKD).deposit(adm) 
	...s remain=deposit-patfee
	..s admreas=$p(^PAADM(adm,1),"^",7)
	..s:(admreas'="")&&($d(^PAC("ADMREA",admreas))) admreas=$p($g(^PAC("ADMREA",admreas)),"^",2)
	..s curDate=$zd($h,3)
	..s dobDate=$zd($p($g(^PAPER(papmi,"ALL")),"^",6),3)
	..s patAge=##class(web.DHCDTHealthCommon).GetAgeDesc(dobDate,curDate)
	..;s patNum=
	..s AdmNo=$p(^PAADM(adm),"^",81) ;就诊号
	..s patcardtypeno=$p($g(^PAPER(papmi,"PAT",3)),"^",6) ;证件号
	..s patcardtypedr=$p($g(^PAPER(papmi,"PAT",3)),"^",7) ;证件类型指针
	..i patcardtypedr'="" s patcardcode=$p(^PAC("CARD",patcardtypedr),"^",1),patcarddesc=$p(^PAC("CARD",patcardtypedr),"^",2)
	..e  s patcardcode="",patcarddesc=""
	..s rtn=adm_"^"_patregno_"^"_patname_"^"_sexcode_"^"_sex_"^"_dobDate_"^"_zyno_"^"_Address
	..s rtn=rtn_"^"_patcardcode_"^"_patcarddesc_"^"_patcardtypeno
	..s rtn=rtn_"^"_admreas_"^"_AdmNo_"^"_admdate_"^"_patward_"^"_remain
	q rtn
}

/// Creator:wangjian
/// CreatDate:2013-02-20
/// Desc:住院预交金充值业务
/// Input:
/// Return:
/// Debug:w ##class(web.DHCIPBillAutoDeposit).AddIPPatDeposit(^wangjian)
ClassMethod AddIPPatDeposit(Input As %String) As %String
{
	Set $ZT="GetAddIPDepositET"
	New (Input)
	Set InputObj=##class(web.DHCEntity.PCA.IPAddDepositRequest).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    
    Set TradeCode=InputObj.TradeCode ;交易代码
    Set TerminalID=InputObj.TerminalID ;终端编码
    Set HospitalId=InputObj.HospitalId ;医院唯一编号
    Set ExtUserID=InputObj.ExtUserID ;操作员Code
    Set PatientCard=InputObj.PatientCard ;卡号
    Set CardTypeCode=InputObj.CardTypeCode ;卡类型
    
    Set PatientID=InputObj.PatientID ;患者ID
    Set Adm=InputObj.Adm ;就诊号
    Set Amount=InputObj.Amount ;充值金额
    Set PayModeCode=InputObj.PayModeCode ;支付方式
    Set TransactionId=InputObj.TransactionId ;交易流水号
    Set BankCode=InputObj.BankCode ;交易银行
  	;
  	Set BankAccDate=InputObj.BankAccDate ;银行交易日期
    Set BankTransactionId=InputObj.BankTransactionId ;银行交易流水号
    Set BankCardNo=InputObj.BankCardNo ;银行卡号
   
  	Set OutputXML=""
  	Set OutputObj=##class(web.DHCEntity.PCA.IPAddDepositResponse).%New()
    if ((Adm="")!($p(Adm,$c(0))="")){
	   Set OutputObj.ResultCode=-1
	   Set OutputObj.ResultContent="没有就诊记录"
	   Set OutputXML=""
	   Do OutputObj.XMLExportToString(.OutputXML,"Response")
	   Do OutputObj.%Close()
	}
	Quit:Adm="" OutputXML
	;转换成his字段
	Set UserCode="",UserId="",Gloc="",Grup=""
	Set:ExtUserID'="" UserCode=$$ALPHAUP^SSUTIL4(ExtUserID)
	Set:UserCode'="" UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	Set:UserId'="" Gloc=$p($g(^SSU("SSUSR",UserId)),"^",4)	;SSUSR_DefaultDept
	Set:UserId'="" Grup=$p($g(^SSU("SSUSR",UserId)),"^",5)	;SSUSR_Group
	Set RcptInfo=##class(web.UDHCJFBaseCommon).GetRcptNo("","",UserId,"住院押金")
	Set Curno=$p(RcptInfo,"^",3)
	Set Endno=$p(RcptInfo,"^",2)	
	Set Title=$p(RcptInfo,"^",4)
	Set RcptRowid=$p(RcptInfo,"^",1)
	Set Paymode=##class(DHCExternalService.RegInterface.GetRelate).GetHisPayModeID(PayModeCode)
	Set Bank=""
    ;拼串
    Set mydeptype="1"
    Set mypayamt=Amount
    Set mypaymode=Paymode
    Set mycompany=""
    Set mybank=Bank ;需转换
    Set mycardno=BankCardNo
    Set myauthno=BankCardNo
    Set myadm=Adm
    Set mycurno=Curno
    Set mygloc=Gloc
    Set myuserid=UserId
    Set myendno=Endno
    Set mytitle=Title
    Set mybanksub=""
    Set mycomment=""
    Set mypassword=""
    Set myrcptrowid=RcptRowid
    Set dep=mydeptype_"^"_mypayamt_"^"_mypaymode_"^"_mycompany_"^"_mybank_"^"_mycardno_"^"_myauthno
    Set dep=dep_"^"_myadm_"^"_mycurno_"^"_mygloc_"^"_myuserid_"^"_myendno_"^"_mytitle_"^"_mybanksub
    Set dep=dep_"^"_mycomment_"^"_mypassword_"^"_myrcptrowid
    Set BankRequset=TradeCode_"^"_TerminalID_"^"_HospitalId_"^"_ExtUserID_"^"_PatientCard_"^"_CardTypeCode
    Set BankRequset=BankRequset_"^"_Adm_"^"_Amount_"^"_PayModeCode_"^"_TransactionId_"^"_BankCode
    Set BankRequset=BankRequset_"^"_BankAccDate_"^"_BankTransactionId_"^"_BankCardNo
    ;
    Set DepositInfo=..InsertDeposit(dep,BankRequset) ;交押金
    set ResultFlag=$p(DepositInfo,"^",1) ;判断返回值
    b ;DepositInfo
    If (ResultFlag=0){
		Set Prtrowid=$p(DepositInfo,"^",2)
		Set Patfee=##class(web.UDHCJFCKD).totalamount(myadm) 
		Set Deposit=##class(web.UDHCJFCKD).deposit(myadm) 
		Set Remain=Deposit-Patfee
		Set Prtno=$p($p(^DHCSFPRINTDETAIL(Prtrowid),"^",1),$c(1))
		;
	    Set OutputObj.DepositAmount=Remain
	    Set OutputObj.InvoiceNo=Prtno
		Set OutputObj.ResultCode=0
		Set OutputObj.ResultContent="交押金成功"    
	}Else{
		Set OutputObj.ResultCode=ResultFlag
		Set OutputObj.ResultContent="交押金失败."	
	}
	Do OutputObj.XMLExportToString(.OutputXML,"Response") 
 	Do OutputObj.%Close()
	Quit OutputXML
	;
GetAddIPDepositET
	Set OutputObj=##class(web.DHCEntity.PCA.IPAddDepositResponse).%New()
	Set OutputObj.ResultCode=-10
	Set OutputObj.ResultContent="程序处理错误:"_$ZERROR
	Do OutputObj.XMLExportToString(.OutputXML,"Response")
	Quit OutputXML
}

/// Creator:wangjian
/// CreatDate:2013-02-20
/// Desc:为不影响正常交押金把自助交押金单独插入押金表
ClassMethod InsertDeposit(dep, BankRequset) As %String
{
	n (dep, BankRequset)
	;向表ar_receipts,ar_rcptalloc,ar_rcptpaymode,dhc_sfprintdetail插入数据
    s deptype=$p(dep,"^",1)
    s payamt=$p(dep,"^",2)
    s paymode=$p(dep,"^",3)
    s company=$p(dep,"^",4)
    s bank=$p(dep,"^",5)
    s cardno=$p(dep,"^",6)
    s authno=$p(dep,"^",7)
    s adm=$p(dep,"^",8)
    s curno=$p(dep,"^",9)
    s gloc=$p(dep,"^",10)
    s userid=$p(dep,"^",11)
    s endno=$p(dep,"^",12)
    s title=$p(dep,"^",13)
    s banksub=$p(dep,"^",14)
    s comment=$p(dep,"^",15)
    s password=$p(dep,"^",16)
    s rcptrowid=$p(dep,"^",17)
    s rcptrowid=$g(rcptrowid)
    i adm'="" s papmi=$p(^PAADM(adm),"^",1)
    b   ;;;;;Add  by zhl shenyang  The same number with different title  S
    i $d(^DHCSFPRINTDETAIL(0,"RcptNo",curno))  d
    .s SameNoDr="",SameFlag="N"
    .f  s SameNoDr=$o(^DHCSFPRINTDETAIL(0,"RcptNo",curno,SameNoDr))  q:(SameNoDr="")||(SameFlag="Y")  d
    ..s DataStr=$g(^DHCSFPRINTDETAIL(SameNoDr))
    ..s SameNoTitle=$p(DataStr,"^",29)
    ..i SameNoTitle=title  s SameFlag="Y"
    
    q:($d(^DHCSFPRINTDETAIL(0,"RcptNo",curno))'=0)&&($g(SameFlag)="Y") "-2"
       ;;;;;;;;zhl  E
    d ..tb()
    s payamt=+payamt
    k PLIST(1)
    s PLIST(7)=+$h
    s PLIST(11)=0,PLIST(49)=userid,PLIST(52)=papmi,PLIST(3)=gloc,PLIST(48)=gloc_"||"
    &sql(insert into ar_receipts values :PLIST())
    i SQLCODE'=0 Trollback
    q:SQLCODE'=0 SQLCODE
    s id=$g(%ROWID)
    k PLIST
    s PLIST(0)=id
    s PLIST(5)=payamt,PLIST(3)=paymode,PLIST(4)=bank,PLIST(21)=company,PLIST(6)=cardno,PLIST(7)=authno
    &sql(insert into ar_rcptpaymode values :PLIST())
    b
    i SQLCODE'=0 Trollback
    q:SQLCODE'=0 SQLCODE
    K PLIST
    s PLIST(0)=id
    S PLIST(9)=adm,PLIST(4)=payamt,PLIST(17)=deptype
	&sql(insert into ar_rcptalloc values :PLIST())
	b
	i SQLCODE'=0 Trollback
	q:SQLCODE'=0 SQLCODE	
	k PLSIT(1)
	s PLIST(2)=curno
    s PLIST(3)=$p($h,",")
    s PLIST(4)=$p($h,",",2)
    s PLIST(5)=adm
    s PLIST(6)=id
    s PLIST(7)=payamt
    s PLIST(8)=""
    s PLIST(9)="1"
    s PLIST(10)=paymode
    s PLIST(11)=bank
    s PLIST(12)=cardno
    s PLIST(13)=company
    s PLIST(14)=deptype
    s PLIST(15)=userid
    s PLIST(21)=userid
    s PLIST(22)="N"
    s PLIST(30)=""
    s PLIST(30)=title
    s PLIST(33)=""
    s PLIST(34)=comment
    s PLIST(35)=password
    s PLIST(36)=banksub  
    s PLIST(40)="N"  
    &sql(insert into dhc_sfprintdetail VALUES :PLIST())
    b  ;sfprint
    s prtrowid=$g(%ROWID)
    i SQLCODE'=0 Trollback
    q:SQLCODE'=0 SQLCODE
    s deptypedesc=$p(^ARC("ARCDT",deptype),"^",2)
    s retcode=..Ok(curno,endno,userid,rcptrowid)
    i retcode'=0 Trollback
    ;s retcode=retcode+retcode1
    q:retcode'=0 retcode   
    ;add by wangjian 2013-02-20 将请求入参插入DHCIPAutoDepBankData表
    s retcode=..InsertAutoDepBankData(BankRequset,prtrowid)
    i retcode'=0 Trollback
    q:retcode'=0 retcode
    
    ;s retval=itmjs_"('"_$ZCVT(SQLCODE_"^"_prtrowid_"^"_id,"O","JS")_"');"
    ;s retval=itmjs_"('"_$ZCVT(retcode_"^"_prtrowid_"^"_id,"O","JS")_"');"
    ;i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
    ;&javascript<#(retval)#>
	d ..tc()
	q retcode_"^"_prtrowid_"^"_id
}

ClassMethod tb()
{
	n SQLCODE
	;TSTART  s SQLCODE=$zu(34)
	TSTART
	q
}

ClassMethod tc()
{
 n SQLCODE
 ;i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
 i $$intp^%qartp TCOMMIT
 q
}

ClassMethod Ok(rcptno, endno, userid, rcptrowid)
{
   s ^xcr(3)=rcptno_"^"_endno_"^"_userid_"^"_rcptrowid
   s rcptrowid=$g(rcptrowid)
   q:(rcptrowid="") "-1"
    i rcptno=endno d 
    .s endflag="0"
    e  d
    .s rcptno=..incre("","",rcptno)
    .s endflag="1"
    b ;ok
    s retcode=0
    s retcode1=0
    s rcptid=""
    s startno=""
    i endflag="1"  d
    .&sql(update dhc_sfreceipt set Rcpt_currentno=:rcptno 
          where rcpt_rowid=:rcptrowid)
    .s retcode=retcode+SQLCODE
    e  d
    .&sql(update dhc_sfreceipt set Rcpt_currentno=:rcptno,
          Rcpt_useflag='2'
          where rcpt_rowid=:rcptrowid)
    .s retcode=retcode+SQLCODE	
	.&sql(select nvl(rcpt_rowid,""),Rcpt_startno 
	      into :rcptid,:startno
	      from dhc_sfreceipt 
	     where (rcpt_useflag is null or rcpt_useflag="") and Rcpt_lquser=:userid)
	.i (rcptid'="")&(SQLCODE=0)  d
	..&sql(update dhc_sfreceipt set Rcpt_currentno=:startno,
	              Rcpt_useflag='1'
	        where Rcpt_rowid=:rcptid)
	..s retcode=retcode+SQLCODE
	.e  d
	..s retcode1=retcode1+SQLCODE
	q retcode
}

ClassMethod incre(itmjs As %Library.String = "", itmjsex As %Library.String = "", invno As %String) As %String
{
 ;发票号自动累加1
	s lng=$l(invno)
	s ret=invno+1
	s l=$l(ret)
	f i=lng:(-1):(l+1) d
	.s ret="0"_""_ret
	s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
    &javascript<#(retval)#>
	q ret
}

ClassMethod InsertAutoDepBankData(BankRequset, prtrowid)
{
	s mybankdate=$p(BankRequset,"^",12)
	i mybankdate["/" s mybankdate=$zdh(mybankdate,4)
	i mybankdate["-" s mybankdate=$zdh(mybankdate,3)
	K PLIST	
	s PLIST(2)=$p(BankRequset,"^",1)
    s PLIST(3)=$p(BankRequset,"^",2)
    s PLIST(4)=$p(BankRequset,"^",3)
    s PLIST(5)=$p(BankRequset,"^",4)
    s PLIST(6)=$p(BankRequset,"^",5)
    s PLIST(7)=$p(BankRequset,"^",6)
    s PLIST(8)=$p(BankRequset,"^",7)
    s PLIST(9)=$p(BankRequset,"^",9)
    s PLIST(10)=$p(BankRequset,"^",10)
    s PLIST(11)=$p(BankRequset,"^",11)
    s PLIST(12)=mybankdate
    s PLIST(13)=""
    s PLIST(14)=+$h
    s PLIST(15)=""
    s PLIST(16)=$p(BankRequset,"^",13)
    s PLIST(17)=$p(BankRequset,"^",14)
    s PLIST(18)=$p(BankRequset,"^",8)
    s PLIST(19)=prtrowid
    &sql(insert into DHCIPAutoDepBankData VALUES :PLIST())
	
	q SQLCODE
}

}
