Class web.DHCOPBILLINVSeatch Extends %RegisteredObject
{

/// Creator: wangjian
/// CreatDate: 2011-07-15
/// Description: 按发票号  查询总金额，医保支付金额
/// Table： DHC_INVPRT, DHC_AccPayINV, DHC_INVPRTZY
/// Input： 发票号范围
/// Return：总金额 TotalAcount，退款票张数和金额
/// Others： 
/// Debug: w ##class(web.DHCOPBILLINVSeatch).GetInvInfoByInv("1002019","1002024","O","")
ClassMethod GetInvInfoByInv(StInv As %String, EnInv As %String, AdmType As %String, Exp As %String, HospId As %String)
{
	s ^TMP("GetInvInfoByInv")=$lb(StInv, EnInv, AdmType, Exp, HospId)
	
    s Inv="", TotalAcount=0, Renum=0, ReSum=0
    s Voidnum=0, VoidSum=0, NormSum=0, NormNum=0
    
    i (AdmType="O") d
    .f Inv=StInv:1:EnInv d
 	..s InvLen=$l(EnInv)-$l(Inv)
 	..s Inv=##class(BILL.Util.Tools).FormatNO(Inv, InvLen)
 	..s PrtInv=Exp_Inv
 	..s PrtRowID=0
 	..f  s PrtRowID=$o(^DHCINVPRT("0","INV",PrtInv,PrtRowID))  q:(PrtRowID="")  d
	...s HospDR=$p(^DHCINVPRT(PrtRowID),"^",39)
 	...q:(HospDR'=HospId)
 	...s PrtFlag=$p(^DHCINVPRT(PrtRowID),"^",8)
 	...s Account=$p(^DHCINVPRT(PrtRowID),"^",1)
 	...s TotalAcount=$g(TotalAcount)+Account	
 	...i (PrtFlag="N") d
 	....s NormNum=$g(NormNum)+1
 	....s NormSum=$g(NormSum)+Account
 	...i (PrtFlag="A") d
    ....s Voidnum=$g(Voidnum)+1
 	....s VoidSum=$g(VoidSum)+Account
 	...i (PrtFlag="S") d
 	....s Renum=$g(Renum)+1
 	....s ReSum=$g(ReSum)+Account
 	..//2018-12-27 ZhYW 集中打印发票
 	..s accPInv=0
 	..f  s accPInv=$o(^DHCINVPRTAPi("0","INVNo",PrtInv,accPInv))  q:(accPInv="")  d
 	...s accPInvInfo=$g(^DHCINVPRTAP(accPInv))
 	...q:(accPInvInfo="")
 	...s accPHospDR=$p(accPInvInfo,"^",30)
 	...q:(accPHospDR'=HospId)
 	...s PrtFlag=$p(accPInvInfo,"^",2)
 	...s Account=$p(accPInvInfo,"^",1)
 	...s TotalAcount=$i(TotalAcount, Account)
 	...i (PrtFlag="N") d
 	....s NormNum=$i(NormNum)
 	....s NormSum=$i(NormSum, Account)
 	...i (PrtFlag="A") d
    ....s Voidnum=$i(Voidnum)
 	....s VoidSum=$i(VoidSum, Account)
 	...i (PrtFlag="S") d
 	....s Renum=$i(Renum)
 	....s ReSum=$i(ReSum, Account)
 	e  d
 	.f Inv=StInv:1:EnInv d
 	..s InvLen=$l(EnInv)-$l(Inv)
 	..s Inv=##class(BILL.Util.Tools).FormatNO(Inv, InvLen)
 	..s PrtInv=Exp_Inv
 	..s PrtRowID=0
  	..f  s PrtRowID=$o(^DHCINVPRTZY(0,"INV",PrtInv,PrtRowID))  q:(PrtRowID="")  d
	...s HospDR=$p(^DHCINVPRTZY(PrtRowID),"^",35)
 	...q:(HospDR'=HospId)
 	...s Account=$p(^DHCINVPRTZY(PrtRowID),"^",6)
 	...s TotalAcount=$g(TotalAcount)+Account
 	...s PrtFlag=$p(^DHCINVPRTZY(PrtRowID),"^",8)
 	...i ((PrtFlag="N")||(PrtFlag="I")) d
 	....s NormNum=$g(NormNum)+1
 	....s NormSum=$g(NormSum)+Account
 	...i (PrtFlag="A") d
    ....s Voidnum=$g(Voidnum)+1
 	....s VoidSum=$g(VoidSum)+Account
 	...i (PrtFlag="S") d
 	....s Renum=$g(Renum)+1
 	....s ReSum=$g(ReSum)+Account
 	
 	s rtn=$fn(NormSum,"",2)_"^"_Renum_"^"_$fn(ReSum,"",2)_"^"_Voidnum_"^"_$fn(VoidSum,"",2)
 	s rtn=rtn_"^"_NormNum_"^"_$fn(TotalAcount,"",2)
 	q rtn
}

/// Creator: fuh
/// CreatDate: 2019-11-23
/// Description: 按发票号  查询总金额，医保支付金额
/// Input: 发票号范围
/// Output: 总金额 TotalAcount，退款票张数和金额
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBILLINVSeatch","FindInvInfoByInv","","","","")
Query FindInvInfoByInv(StInv As %String, EnInv As %String, AdmType As %String, Exp As %String, HospId As %String) As websys.Query(ROWSPEC = "StInv:%String,EnInv:%String,NormSum:%Float,Renum:%Integer,ReSum:%Float,Voidnum:%Integer,VoidSum:%Float,NormNum:%Integer,TotalAcount:%Float,PrintDate:%String") [ SqlProc ]
{
}

ClassMethod FindInvInfoByInvExecute(ByRef qHandle As %Binary, StInv As %String, EnInv As %String, AdmType As %String, Exp As %String, HospId As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	
	set PrintDate=##class(websys.Conversions).DateLogicalToHtml(+$h)
	set Inv="", TotalAcount=0, Renum=0, ReSum=0
	set Voidnum=0, VoidSum=0, NormSum=0, NormNum=0
	
	set StaInv=Exp_StInv
  	set EndInv=Exp_EnInv
  	
    i (AdmType="O") d
    .f Inv=StInv:1:EnInv d
 	..s InvLen=$l(EnInv)-$l(Inv)
 	..s Inv=##class(BILL.Util.Tools).FormatNO(Inv, InvLen)
 	..s PrtInv=Exp_Inv
 	..s PrtRowID=0
 	..f  s PrtRowID=$o(^DHCINVPRT("0","INV",PrtInv,PrtRowID))  q:(PrtRowID="")  d
	...s HospDR=$p(^DHCINVPRT(PrtRowID),"^",39)
 	...q:(HospDR'=HospId)
 	...s PrtFlag=$p(^DHCINVPRT(PrtRowID),"^",8)
 	...s Account=$p(^DHCINVPRT(PrtRowID),"^",1)
 	...s TotalAcount=$g(TotalAcount)+Account
 	...i (PrtFlag="N") d
 	....s NormNum=$g(NormNum)+1
 	....s PrtAcount=$p(^DHCINVPRT(PrtRowID),"^",1) //发票金额
 	....s NormSum=$g(NormSum)+PrtAcount
 	...i (PrtFlag="A") d
    ....s Voidnum=$g(Voidnum)+1
    ....s VoidAcount=$p(^DHCINVPRT(PrtRowID),"^",1)
 	....s VoidSum=$g(VoidSum)+VoidAcount
 	...i (PrtFlag="S") d
 	....s Renum=$g(Renum)+1
 	....s ReAcount=$p(^DHCINVPRT(PrtRowID),"^",1)
 	....s ReSum=$g(ReSum)+ReAcount
 	..//2018-12-27 ZhYW 集中打印发票
 	..s accPInv=0
 	..f  s accPInv=$o(^DHCINVPRTAPi("0","INVNo",PrtInv,accPInv))  q:(accPInv="")  d
 	...s accPInvInfo=$g(^DHCINVPRTAP(accPInv))
 	...q:(accPInvInfo="")
	...s accPHospDR=$p(accPInvInfo,"^",30)
 	...q:(accPHospDR'=HospId)
 	...s PrtFlag=$p(accPInvInfo,"^",2)
 	...s Account=$p(accPInvInfo,"^",1)
 	...s TotalAcount=$i(TotalAcount, Account)
 	...i (PrtFlag="N") d
 	....s NormNum=$i(NormNum)
 	....s NormSum=$i(NormSum, Account)
 	...i (PrtFlag="A") d
    ....s Voidnum=$i(Voidnum)
 	....s VoidSum=$i(VoidSum, Account)
 	...i (PrtFlag="S") d
 	....s Renum=$i(Renum)
 	....s ReSum=$i(ReSum, Account)
 	.d OutputInvInfo
 	e  d
 	.f Inv=StInv:1:EnInv d
 	..s InvLen=$l(EnInv)-$l(Inv)
 	..s Inv=##class(BILL.Util.Tools).FormatNO(Inv, InvLen)
 	..s PrtInv=Exp_Inv
 	..s PrtRowID=0
  	..f  s PrtRowID=$o(^DHCINVPRTZY(0,"INV",PrtInv,PrtRowID))  q:(PrtRowID="")  d
	...s PRtHospDR=$p(^DHCINVPRTZY(PrtRowID),"^",35)
 	...q:(PRtHospDR'=HospId)
 	...s Account=$p(^DHCINVPRTZY(PrtRowID),"^",6)
 	...s TotalAcount=$g(TotalAcount)+Account
 	...s PrtFlag=$p(^DHCINVPRTZY(PrtRowID),"^",8)
 	...i ((PrtFlag="N")||(PrtFlag="I")) d
 	....s NormNum=$g(NormNum)+1
 	....s PrtAcount=$p(^DHCINVPRTZY(PrtRowID),"^",6) //发票金额
 	....s NormSum=$g(NormSum)+PrtAcount
 	...i (PrtFlag="A") d
    ....s Voidnum=$g(Voidnum)+1
    ....s VoidAcount=$p(^DHCINVPRTZY(PrtRowID),"^",6)
 	....s VoidSum=$g(VoidSum)+VoidAcount
 	...i (PrtFlag="S") d
 	....s Renum=$g(Renum)+1
 	....s ReAcount=$p(^DHCINVPRTZY(PrtRowID),"^",6)
 	....s ReSum=$g(ReSum)+ReAcount
	.d OutputInvInfo
	
	quit $$$OK

OutputInvInfo
	set Data=$lb(StaInv,EndInv,$fn(NormSum,"",2),Renum,$fn(ReSum,"",2),Voidnum,$fn(VoidSum,"",2),NormNum,$fn(TotalAcount,"",2),PrintDate)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

}
