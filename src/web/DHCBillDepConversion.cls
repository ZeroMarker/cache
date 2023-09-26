/// 名称: web.DHCBillDepConversion.cls
/// 描述: 门诊预交金转住院押金，住院押金转门诊预交金业务逻辑类
/// 编写者: xiongwang
/// 编写日期: 2018-03-14
/// 产品组：计费医保组
Class web.DHCBillDepConversion Extends BILL.COM.Abstract
{

/// Creator: xiongwang
/// CreateDate: 2018-03-14
/// Description: 门诊账户与住院押金互转支付方式(程序写死代码为：DEPZZ)
ClassMethod GetDEPZZPayModeID()
{
	quit $o(^CT("CTPM",0,"Code","DEPZZ",0))
}

/// Creator: xiongwang
/// CreateDate: 2018-03-14
/// Description: 根据账户ID获取病人在院记录
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBillDepConversion","QueryIPAdmByAccountID","1","2")
Query QueryIPAdmByAccountID(AccountID As %String, SessionStr As %String) As websys.Query(ROWSPEC = "RowID:%String,AdmNo:%String,PatNo:%String,PatName:%String,AdmDate:%String,AdmTime:%String,AdmDep:%String,AdmWard:%String,AdmBed:%String,AdmStatus:%String")
{
}

ClassMethod QueryIPAdmByAccountIDExecute(ByRef qHandle As %Binary, AccountID As %String, SessionStr As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
    if (AccountID="")  quit $$$OK
	
	set HospId=$p(SessionStr,"^",4)
	set LangId=$p(SessionStr,"^",5)
	
	set Papmi=$p($g(^DHCACD("AccM",+AccountID)),"^",2)
	if (Papmi="") quit $$$OK
	
	set PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
	set PatName=$p($g(^PAPER(Papmi,"ALL")),"^",1)

	set RowID=0
	while($o(^PAPERdr(Papmi,"ADM","I",RowID))) {
		set RowID=$o(^PAPERdr(Papmi,"ADM","I",RowID))
		set AdmNo=$p(^PAADM(RowID),"^",81)
		set BillFlag=$p(^PAADM(RowID),"^",45)
		continue:(BillFlag="Y")
		set AdmStatus=$p(^PAADM(RowID),"^",20)
		continue:(AdmStatus="C")
		set AdmStatus=$case(AdmStatus,"A":"在院","D":"出院","P":"预住院",:"")
		set AdmStatus=##class(websys.Translation).Get("", AdmStatus, LangId)
		set AdmInOutDateInfo=##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(RowID)
		set AdmDate=$p(AdmInOutDateInfo,"^",1)
		set AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
		set AdmTime=$p(AdmInOutDateInfo,"^",2)
		set AdmTime=##class(websys.Conversions).TimeLogicalToHtml(AdmTime, 1)
		set AdmDepID=$p(^PAADM(RowID),"^",4)
		set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(AdmDepID)
		continue:((HospId'="")&&(HospId'=admHospDR))
		set AdmDep=$p($g(^CTLOC(AdmDepID)),"^",2)
		set AdmDep=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", AdmDep, LangId)
		set AdmWardID=$p(^PAADM(RowID),"^",70)
		continue:(AdmWardID="")
		set AdmWard=$p($g(^PAWARD(AdmWardID)),"^",2)
		set AdmWard=##class(User.PACWard).GetTranByDesc("WARDDesc", AdmWard, LangId)
		set AdmBed=##class(web.DHCBillCommon).GetPatBedCode(RowID)
		do OutputIPAdmList
	}

	quit $$$OK
OutputIPAdmList
	set Data=$lb(RowID,AdmNo,PatNo,PatName,AdmDate,AdmTime,AdmDep,AdmWard,AdmBed,AdmStatus)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: xiongwang
/// CreateDate: 2018-03-14
/// Description: 门诊账户转住院押金
/// Debug: w ##class(web.DHCBillDepConversion).AcountTransDeposit("36475^2^4632^^^^^45^^^^^^^^R^2","1^2^45^^^^^289^000000255^303^4632^000000700^^^^^^^2")
ClassMethod AcountTransDeposit(RefAcountStr As %String, AddDepositStr As %String) As %String
{
	set ^TMP("AcountTransDeposit")=$lb(RefAcountStr, AddDepositStr)
	
 	set $zt="ERROR"
 	ts
 	
 	//退门诊账户
 	set AccRowID=$p(RefAcountStr,"^",1)
 	set RefAmt=$p(RefAcountStr,"^",2)
 	set UserId=$p(RefAcountStr,"^",3)
 	set BackReason=$p(RefAcountStr,"^",4)
 	set Password=$p(RefAcountStr,"^",5)
 	set PayModeId=$p(RefAcountStr,"^",6)
	set BankCardType=$p(RefAcountStr,"^",7)
 	set ChequeNo=$p(RefAcountStr,"^",8)
 	set Bank=$p(RefAcountStr,"^",9)
 	set Company=$p(RefAcountStr,"^",10)
 	set PayAccNo=$p(RefAcountStr,"^",11)
 	set ChequeDate=$p(RefAcountStr,"^",12)
	set Remark=$p(RefAcountStr,"^",13)
 	set PDType=$p(RefAcountStr,"^",14)
 	set HospId=$p(RefAcountStr,"^",15)
 	
 	set AccPDInfo=RefAmt_"^"_UserId_"^"_BackReason_"^"_Password_"^"_PDType_"^"_Remark_"^"_HospId
 	set AccPMInfo=PayModeId_"^"_Bank_"^"_ChequeNo_"^"_BankCardType_"^"_Company_"^"_ChequeDate_"^"_PayAccNo_"^"_RefAmt
 	set RtnValue=##class(web.UDHCAccAddDeposit).AddDeposit(AccRowID, AccPDInfo, AccPMInfo)
 	set Rtn=$p(RtnValue,"^",1)
 	set OPDepRowID=$p(RtnValue,"^",2)
 	if (+Rtn) tro  quit RtnValue
	
	//交住院押金
	set DepTypeId=$p(AddDepositStr,"^",1)
	set PayAmt=$p(AddDepositStr,"^",2)
	set PayMId=$p(AddDepositStr,"^",3)
	set Company=$p(AddDepositStr,"^",4)
	set Bank=$p(AddDepositStr,"^",5)
	set ChequeNo=$p(AddDepositStr,"^",6)
	set PayAccNo=$p(AddDepositStr,"^",7)
	set Adm=$p(AddDepositStr,"^",8)
	set CtLocId=$p(AddDepositStr,"^",9)
	set UserId=$p(AddDepositStr,"^",10)
	set Remark=$p(AddDepositStr,"^",11)
	set TransferFlag=$p(AddDepositStr,"^",12)
	set HospId=$p(AddDepositStr,"^",13)
	set BankCardTypeId=""
	set ChequeDate=""
	
	set DepositStr=DepTypeId_"^"_PayAmt_"^"_Adm_"^"_Remark_"^"_TransferFlag
				
	set PaymStr=PayMId_"^"_Bank_"^"_ChequeNo_"^"_BankCardTypeId_"^"_Company_"^"_ChequeDate_"^"_PayAccNo_"^"_PayAmt
	
	set GroupId=""
	set SessionStr=UserId_"^"_GroupId_"^"_CtLocId_"^"_HospId
	
	set RtnValue=##class(web.DHCIPBillDeposit).InsertDeposit(DepositStr, PaymStr, SessionStr)
	set Rtn=$p(RtnValue,"^",1)
	set IPDepRowID=$p(RtnValue,"^",2)
	if (+Rtn) tro  quit RtnValue

 	if ($tl>0) tc
 	
	quit Rtn_"^"_OPDepRowID_"^"_IPDepRowID

ERROR
	quit ..AppException()
}

/// Creator: xiongwang
/// CreateDate: 2018-03-14
/// Description: 住院押金转门诊账户
/// Debug: w ##class(web.DHCBillDepConversion).DepositTransAcount("3103^10000.00^^43","2622^10000.00^12173^^^^43^^^^^^^^P^2","12173^241^222^2")
ClassMethod DepositTransAcount(DepositStr As %String, AccPreDepStr As %String, SessionStr As %String) As %String
{
	set ^TMP("DepositTransAcount")=$lb(DepositStr, AccPreDepStr, SessionStr)
	
 	set $zt="ERROR"
 	ts
 	
 	//退住院押金
 	set PrtRowID=$p(DepositStr,"^",1)
 	set RefundAmt=$p(DepositStr,"^",2)
 	set RefReaID=$p(DepositStr,"^",3)
 	set PayMID=$p(DepositStr,"^",4)
 	set RtnValue=##class(web.DHCIPBillDeposit).RefundDepositIF(PrtRowID, RefundAmt, PayMID, SessionStr, RefReaID)
 	set Rtn=$p(RtnValue,"^",1)
  	set IPDepRowID=$p(RtnValue,"^",2)
 	if (+Rtn) tro  quit RtnValue
 	
 	set AccRowID=$p(AccPreDepStr,"^",1)
 	set PayAmt=$p(AccPreDepStr,"^",2)
 	set UserId=$p(AccPreDepStr,"^",3)
 	set BackReason=$p(AccPreDepStr,"^",4)
 	set Password=$p(AccPreDepStr,"^",5)
 	set PayModeId=$p(AccPreDepStr,"^",6)
	set BankCardType=$p(AccPreDepStr,"^",7)
 	set ChequeNo=$p(AccPreDepStr,"^",8)
 	set Bank=$p(AccPreDepStr,"^",9)
 	set Company=$p(AccPreDepStr,"^",10)
 	set PayAccNo=$p(AccPreDepStr,"^",11)
 	set ChequeDate=$p(AccPreDepStr,"^",12)
	set Remark=$p(AccPreDepStr,"^",13)
 	set PDType=$p(AccPreDepStr,"^",14)
 	set HospId=$p(AccPreDepStr,"^",15)
 	
 	set AccPDInfo=PayAmt_"^"_UserId_"^"_BackReason_"^"_Password_"^"_PDType_"^"_Remark_"^"_HospId
 	set AccPMInfo=PayModeId_"^"_Bank_"^"_ChequeNo_"^"_BankCardType_"^"_Company_"^"_ChequeDate_"^"_PayAccNo_"^"_PayAmt
 	
	set RtnValue=##class(web.UDHCAccAddDeposit).AddDeposit(AccRowID, AccPDInfo, AccPMInfo)
	set Rtn=$p(RtnValue,"^",1)
	set OPDepRowID=$p(RtnValue,"^",2)
 	if (+Rtn) tro  quit RtnValue
 	
 	if ($tl>0) tc
 	
	quit Rtn_"^"_IPDepRowID_"^"_OPDepRowID
ERROR
	quit ..AppException()
}

}
