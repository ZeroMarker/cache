Import SQLUser

Class web.UDHCJFQFDEAL Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// do ##class(%ResultSet).RunQuery("web.UDHCJFQFDEAL","FindQfDetail","2020-06-01","2020-06-01","",2)
Query FindQfDetail(stDate As %String, endDate As %String, patientNo As %String, hospId As %String) As websys.Query(ROWSPEC = "Tpapno:%String,Tpapname:%String,Tadmid:%String,Tsex:%String,Tadmreason:%String,TAdmDept:%String,TAdmWard:%String,TDate:%String,TTime:%String,Tamount:%String,Tflag:%String,Tpaymode:%String,Tcomment:%String,Tcurrentno:%String,Tstatus:%String,Trowid:%String,TBillRowid:%String,TARRCP:%String,TQFFlag:%String")
{
}

ClassMethod FindQfDetailExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, patientNo As %String, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
    set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
    set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
    
    set papmi=""
    if (patientNo'="") do
    .set patientNo=##class(web.UDHCJFBaseCommon).regnocon(patientNo)
    .set papmi=$o(^PAPERi("PAPMI_PatNo",patientNo,""))
    
	s qfsum=0, bjsum=0
	i (papmi'="") d
	.s adm="0"
    .f  s adm=$o(^PAPERdr(papmi,"ADM","I",adm)) q:(adm="")  d
    ..s rowid="0"
    ..f  s rowid=$o(^DHCJFQFTOTAL(0,"Adm",adm,rowid)) q:(rowid="")  d
    ...d GetQFDetail(rowid)
    e  d
 	.f prtdate=stDate:1:endDate d
	..s rowid="0"
	..f  s rowid=$o(^DHCJFQFTOTAL(0,"Date",prtdate,rowid)) q:(rowid="")  d
	...d GetQFDetail(rowid)

    d InitOutput
    s papno="合计"
    s amount=$fn((qfsum-bjsum),"",2)
    d OutputQfDetail
    
	quit $$$OK
	
InitOutput
	set (papno, name, admno, sex, admReaDesc, admDept, admWard, date, time, flag, currentno)=""
    set (status, paymode, rowid, TBillRowid, TARRCP, TQFFlag, comment)=""
    set amount=0
	quit

GetQFDetail(rowid)
    s admno=$p(^DHCJFQFTOTAL(rowid),"^",1)
    q:(admno="")
	q:'$d(^PAADM(admno))
    s hospDR=$p(^DHCJFQFTOTAL(rowid),"^",18)
    q:(hospDR'=hospId)
	s paprowid=$p(^PAADM(admno),"^",1)
	s admDeptDR=$p(^PAADM(admno),"^",4)
	s admDept=$s((admDeptDR'=""):$p($g(^CTLOC(admDeptDR)),"^",2),1:"")
	i (admDept["-") s admDept=$p(admDept,"-",2)
	s admWardDR=$p(^PAADM(admno),"^",70)
	s admWard=$s((admWardDR'=""):$p($g(^PAWARD(admWardDR)),"^",2),1:"")
	i (admWard["-") s admWard=$p(admWard,"-",2)
	s admReaDR=$p($g(^PAADM(admno,1)),"^",7)
	s admReaDesc=$s((+admReaDR'=0):$p($g(^PAC("ADMREA",admReaDR)),"^",2),1:"")
	s papno=$p(^PAPER(paprowid,"PAT",1),"^",1)
	s name=$p(^PAPER(paprowid,"ALL"),"^",1)
	s sexDR=$p(^PAPER(paprowid,"ALL"),"^",7)
	s sex=$s((sexDR'=""):$p(^CT("SEX",sexDR),"^",2),1:"")
	s date=$p(^DHCJFQFTOTAL(rowid),"^",2)
	s date=##class(websys.Conversions).DateLogicalToHtml(date)
	s time=$p(^DHCJFQFTOTAL(rowid),"^",3)
	s time=##class(websys.Conversions).TimeLogicalToHtml(time)
	s amount=$p(^DHCJFQFTOTAL(rowid),"^",4)
	s amount=$fn(amount,"",2)
	s flag=$p(^DHCJFQFTOTAL(rowid),"^",5)
	s status=$p(^DHCJFQFTOTAL(rowid),"^",8)
	s TQFFlag=flag
	i ((flag="Q")&&(status="N")) s flag="欠费", qfsum=qfsum+amount
	i (flag="B") s flag="补交", bjsum=bjsum+amount
	i ((flag="Q")&&(status="S")) s flag="欠费", qfsum=qfsum+amount
	i (flag="T") s flag="退回", qfsum=qfsum+amount
	i ((flag="C")&&(status="N")) s qfsum=qfsum+amount
	i (flag="C") s flag="结存"
	i (status="N") s status="正常"
	i (status="A") s status="作废"
	i (status="S") s status="红冲"
	s paymDR=$p(^DHCJFQFTOTAL(rowid),"^",13)
	s paymode=$s((+paymDR'=0):$p($g(^CT("CTPM",paymDR)),"^",2),1:"")
	s comment=$p(^DHCJFQFTOTAL(rowid),"^",7)
	s currentno=$p(^DHCJFQFTOTAL(rowid),"^",21)
	s TARRCP=$p(^DHCJFQFTOTAL(rowid),"^",9)
	s TBillRowid=$p(^DHCJFQFTOTAL(rowid),"^",10)
	
	d OutputQfDetail
    q
OutputQfDetail
	set Data=$lb(papno,name,admno,sex,admReaDesc,admDept,admWard,date,time,amount,flag,paymode,comment,currentno,status,rowid,TBillRowid,TARRCP,TQFFlag)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// w ##class(web.UDHCJFQFDEAL).GetPatInfo(12)
ClassMethod GetPatInfo(patientNo As %String) As %String
{
	new (patientNo)
	set obj={}
    set patientNo=##class(web.UDHCJFBaseCommon).regnocon(patientNo)
	set patientId="", patName=""
    if (patientNo'="") {
	    set patientId=$o(^PAPERi("PAPMI_PatNo",patientNo,""))
	    if (patientId'="") {
		    set patName=$p($g(^PAPER(patientId,"ALL")),"^",1)
		}
	}
	set obj.patientNo=patientNo
	set obj.patientId=patientId
	set obj.patName=patName
	quit obj.%ToJSON()
}

/// w ##class(web.UDHCJFQFDEAL).Insert("4^100.00^T^671^1^dfafsf^004^2968^3627")
ClassMethod Insert(str As %String, sessionStr) As %String
{
	new (str, sessionStr)
	set ^TMP("Insert")=$lb(str, sessionStr)
    set RetVal=0
    
    set adm=$p(str,"^",1)
    set amount=$p(str,"^",2)
    set flag=$p(str,"^",3)
    set paymode=$p(str,"^",4)
    set comment=$p(str,"^",5)
    set currNo=$p(str,"^",6)
    set arrcpRowId=$p(str,"^",7)
    set billRowId=$p(str,"^",8)
    
    set userId=$p(sessionStr,"^",1)
    set groupID=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
    
	quit:((+arrcpRowId=0)||(+billRowId=0)) "InvNull"
	
    set paymCode=$s((+paymode'=0):$p($g(^CT("CTPM",paymode)),"^",1),1:"")
    quit:(" QF JC "[(" "_paymCode_" ")) -1
    
	set invRowId=""
	set myPrtRowID=""
	while($o(^DHCINVPRTZY(0,"AR",billRowId,myPrtRowID),-1)&&(invRowId="")) {
		set myPrtRowID=$o(^DHCINVPRTZY(0,"AR",billRowId,myPrtRowID),-1)
		set myPrtStatus=$p(^DHCINVPRTZY(myPrtRowID),"^",8)
		continue:(" A S "[(" "_myPrtStatus_" "))
		continue:($d(^DHCINVPRTZY(0,"InitInv",myPrtRowID))=10)
		set myARRCPDR=$p(^DHCINVPRTZY(myPrtRowID),"^",17)
		continue:(myARRCPDR'=arrcpRowId)
		set invRowId=myPrtRowID
	}	
	quit:(+invRowId=0) "InvNull"
	
	ts
	set amountToPaid=$p(^DHCINVPRTZY(invRowId),"^",28)
	if (+amountToPaid'=0) {
		if (flag="B") {
			set amountToPaid=amountToPaid-amount
		}
		if (flag="T") {
			set amountToPaid=amountToPaid+amount
		}
		&sql(UPDATE DHC_INVPRTZY SET PRT_DiscretOutstAmt=:amountToPaid WHERE PRT_Rowid=:invRowId)
		set RetVal=RetVal+SQLCODE
	}
    if (+RetVal) tro  quit RetVal
    
	kill PLIST
	set PLIST(2)=adm
	set PLIST(3)=+$h
	set PLIST(4)=$p($h,",",2)
	set PLIST(5)=amount
	set PLIST(6)=flag
	set PLIST(7)=userId
	set PLIST(14)=paymode
	set PLIST(8)=comment
	set PLIST(9)="N"
	set PLIST(10)=arrcpRowId
	set PLIST(11)=billRowId
	set PLIST(15)="N"
	set PLIST(19)=hospId
	set PLIST(22)=currNo
	set RtnValue=##class(web.DHCJFQFTotal).INSERT()
	set RetVal=$p(RtnValue,"^",1)
	if (+RetVal) tro  quit RetVal
	
	set myRowID=$p(RtnValue,"^",2)

	tc
	
	quit RetVal_"^"_myRowID
}

ClassMethod Abort(QFRowId As %String, UserId As %String) As %String
{
	new (QFRowId, UserId)
	
	set flag=$p(^DHCJFQFTOTAL(QFRowId),"^",5)
	quit:(" Q C "[(" "_flag_" ")) "-1^欠费或结存记录不能作废"
	set status=$p(^DHCJFQFTOTAL(QFRowId),"^",8)
	quit:(status'="N") "-2^已作废记录不能再作废"
	
	set BillNo=$p(^DHCJFQFTOTAL(QFRowId),"^",10)
	set RefundFlag=$p($g(^DHCPB(BillNo)),"^",17)
	quit:(RefundFlag'="") "-3^账单已取消结算，不能作废"
	
	set InvRowID=$o(^DHCINVPRTZY(0,"AR",BillNo,""),-1)
	
	set QFUserDR=$p(^DHCJFQFTOTAL(QFRowId),"^",6)
	set QFJKDR=$p(^DHCJFQFTOTAL(QFRowId),"^",17)
	
	set SFlag=$s(((+QFJKDR=0)&&(QFUserDR=UserId)):"A",1:"S")   //作废/红冲
	
	ts
	set err=0
	
	kill PLIST
	//更新原记录
	set PLIST(9)=SFlag
	set err=##class(web.DHCJFQFTotal).UPDATE(QFRowId)
	if (+err) tro  quit err_"^更新状态失败"
	
	//新增记录
	kill PLIST
	set err=##class(web.DHCJFQFTotal).SELECT(QFRowId)
	kill PLIST(1)
	set PLIST(3)=+$h
	set PLIST(4)=$p($h,",",2)
	set PLIST(5)=-PLIST(5)
	set PLIST(7)=UserId
	set PLIST(9)=SFlag
	set PLIST(15)="N"
	set PLIST(16)=""
	set PLIST(17)=""
	set PLIST(18)=""
	set PLIST(20)=QFRowId
	set PLIST(22)=""
	set err=##class(web.DHCJFQFTotal).INSERT()
	if (+err) tro  quit err_"^插入负记录失败"
		
	set QFAmt=$p(^DHCJFQFTOTAL(QFRowId),"^",4)
	set flag=$p(^DHCJFQFTOTAL(QFRowId),"^",5)
	if (InvRowID'="") {
		set DiscretAmt=$p(^DHCINVPRTZY(InvRowID),"^",28)
		if (flag="T") {
			set DiscretAmt=DiscretAmt-QFAmt
		}else {
			set DiscretAmt=DiscretAmt+QFAmt
		}
		&sql(UPDATE DHC_INVPRTZY SET PRT_DiscretOutstAmt=:DiscretAmt WHERE PRT_Rowid=:InvRowID)
		set err=SQLCODE
	}
	if (err) tro  quit err_"^更新发票表失败"
	
	tc
	
	quit err
}

ClassMethod getqfamount(Adm)
{
	n (Adm)
	q:(Adm="") 0
	
	s qfamount=0
	s rowid=0
    f  s rowid=$o(^DHCJFQFTOTAL(0,"Adm",Adm,rowid)) q:(rowid="")  d
	.s amt=$p(^DHCJFQFTOTAL(rowid),"^",4)
	.s flag=$p(^DHCJFQFTOTAL(rowid),"^",5)
	.s status=$p(^DHCJFQFTOTAL(rowid),"^",8)
	.q:(status="A")
	.i (" Q C "[(" "_flag_" ")) d
	..s qfamount=qfamount+amt
	.i (flag="B") d
	..s qfamount=qfamount-amt
	.i (flag="T") d
	..s qfamount=qfamount+amt

    q $fn(qfamount,"",2)
}

ClassMethod getqfrowid(adm)
{
	n (adm)
	s row=0
	s rowid="0"
	f  s rowid=$o(^DHCJFQFTOTAL(0,"Adm",adm,rowid)) q:(rowid="")  d
	.s flag=$p(^DHCJFQFTOTAL(rowid),"^",5)
	.i (flag="Q") d
	..s row=row+1
	i (row=0) s row=""
	q row
}

/// w ##class(web.UDHCJFQFDEAL).GetPrintInfo("", 1)
ClassMethod GetPrintInfo(JSFunName As %String, QFRowId As %String) As %String
{
	new (JSFunName, QFRowId)
	set ^TMP("GetPrintInfo")=$lb(JSFunName, QFRowId)
   	set adm=$p(^DHCJFQFTOTAL(QFRowId),"^",1)
   	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
   	set hospital=$s((+hospDR'=0):$p($g(^CT("HOSP",hospDR)),"^",2),1:"")
	set patinfo=##class(web.DHCIPBillDeposit).GetPatInfo(adm)
	set patname=$p(patinfo,"^",1)
	set patdep=$p(patinfo,"^",3)
	set patward=$p(patinfo,"^",4)
	set patbed=$p(patinfo,"^",5)
	set patno=$p(patinfo,"^",8)
	set medicareNo=$p(patinfo,"^",10)
	set admreason=$p(patinfo,"^",13)
	set rcptno=$p(^DHCJFQFTOTAL(QFRowId),"^",21)
	set userDR=$p(^DHCJFQFTOTAL(QFRowId),"^",6)
	set username=$s((+userDR'=0):$p($g(^SSU("SSUSR",userDR)),"^",2),1:"")
	set payamt=$p(^DHCJFQFTOTAL(QFRowId),"^",4)
	set flag=$p(^DHCJFQFTOTAL(QFRowId),"^",5)
	if (flag="T") {
		set payamt=-payamt
	}
	set payamt=$fn(payamt,"",2)
	set amtdx=##class(web.UDHCJFBaseCommon).RMBDXXZH(payamt)
	set paymDR=$p(^DHCJFQFTOTAL(QFRowId),"^",13)
	set paymode=$s((+paymDR'=0):$p($g(^CT("CTPM",paymDR)),"^",2),1:"")
	set patward=$p(patinfo,"^",4)
	set prtDateTime=$zdt($h,17,1)
	
	set jsonObj=##class(ext.util.JsonObject).%New()
	do jsonObj.Put("patname",patname)
	do jsonObj.Put("patno",patno)
	do jsonObj.Put("medicareNo",medicareNo)
	do jsonObj.Put("patward",patward)
	do jsonObj.Put("payamt",payamt)
	do jsonObj.Put("paymode",paymode)
	do jsonObj.Put("amtdx",amtdx)
	do jsonObj.Put("rcptno",rcptno)
	do jsonObj.Put("prtDateTime",prtDateTime)
	do jsonObj.Put("username",username)
	do jsonObj.Put("hospital",hospital)
	set prtTxtInfo=jsonObj.GetPrintData()
	
	set prtListInfo=""
	set rtnVal=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"');"
	&javascript<#(rtnVal)#>
	
	quit ""
}

/// w ##class(web.UDHCJFQFDEAL).GetCurrentNo(2)
ClassMethod GetCurrentNo(hospId As %String) As %String
{
	n (hospId)
	s rowid="", curNo="", lastNo="" ,lastNo1=""
	f  s rowid=$o(^DHCJFQFTOTAL(rowid),-1) q:((rowid="")||(lastNo'=""))  d
	.s tmp=$g(^DHCJFQFTOTAL(rowid))
	.q:(tmp="")
	.s pb=$p(tmp,"^",10)
	.q:(pb="")
	.s adm=$p($g(^DHCPB(pb)),"^",1)
	.s admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	.q:((admHospDR'="")&&(admHospDR'=hospId))
	.s lastNo=$p(tmp,"^",21)
	.s lastNo1=lastNo
	i (lastNo'="") s curNo=$i(lastNo)
	
	f i=1:1:($l(lastNo1)-$l($i(lastNo))) d
	.s curNo="0"_curNo
	
	q curNo
}

/// 取结算汇总信息
Query Findrcptdetail(InvprtRowid) As websys.Query(ROWSPEC = "Tpaymode:%String,Tmodeid:%String,Tamt:%String,Tprtdate:%String,Tprttime:%String,Tuser:%String,Trowid:%String")
{
}

ClassMethod FindrcptdetailExecute(ByRef qHandle As %Binary, InvprtRowid) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (InvprtRowid="") quit $$$OK
    
	set flag=$p($g(^DHCINVPRTZY(InvprtRowid)),"^",8)
	if (flag="I") set flag="N"
	if (flag'["N")  quit $$$OK
	set billno=$p(^DHCINVPRTZY(InvprtRowid),"^",5)
	if (billno="") quit $$$OK
	
	s adm=$p($g(^DHCINVPRTZY(InvprtRowid)),"^",4)
	s prtdate=$p($g(^DHCINVPRTZY(InvprtRowid)),"^",2)
	s prtdate=##class(websys.Conversions).DateLogicalToHtml(prtdate)
	s prttime=$p($g(^DHCINVPRTZY(InvprtRowid)),"^",3)
	s prttime=##class(websys.Conversions).TimeLogicalToHtml(prttime)
	s user=$p($g(^DHCINVPRTZY(InvprtRowid)),"^",7)
	s:(user'="") user=$p($g(^SSU("SSUSR",user)),"^",2)
	s rcptid="0"
	f  s rcptid=$o(^ARRCP("ARPBL",billno,rcptid))  q:(rcptid="")  d
	.s arralid="0"
	.f  s arralid=$o(^ARRCP("ARPBL",billno,rcptid,arralid))  q:(arralid="")  d
	..s depositdr=$p(^ARRCP(rcptid,"RAL",arralid),"^",9)
	..q:(depositdr'="")
	..s paysum=0
	..s payid=0
	..f  s payid=$o(^ARRCP(rcptid,"PAYM",payid)) q:(payid="")  d
	...s modeid=$p($g(^ARRCP(rcptid,"PAYM",payid)),"^",1)
	...q:(+modeid=0)
	...s pmode=$p($g(^CT("CTPM",modeid)),"^",2)
	...s amt=$p($g(^ARRCP(rcptid,"PAYM",payid)),"^",3)
	...s paysum=paysum+amt
	...s rowid=rcptid_"||"_payid
	...d OutputRow11
	
    set pmode="合计",amt=paysum,rowid=rcptid,modeid="",prtdate="",prttime="",user=""
    do OutputRow11
    
    quit $$$OK
    
OutputRow11
	set Data=$lb(pmode,modeid,amt,prtdate,prttime,user,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod UpdateDebtPaymode(PayRowid, PayStr, InvUser)
{
	n (PayRowid, PayStr, InvUser)
	s InvDate=+$h, InvTime=$p($h,",",2)
	s $ZT="ERROR^DHCSSERR" d ..tb()
	s ArrcpRowid=+PayRowid
	&sql(DELETE FROM AR_RcptPayMode WHERE PAYM_ParRef=:ArrcpRowid)
	s err=SQLCODE
	i (err'=0) tro  q err
	
	s PayLen=$l(PayStr,"&")
	f i=1:1:PayLen q:(err'=0)  d
	.s PayModeStr=$p(PayStr,"&",i)
	.s PayModeDesc=$p(PayModeStr,"^",1)
	.s PayAmt=$p(PayModeStr,"^",2)
	.s PayModeId=$o(^CT("CTPM",0,"Desc",PayModeDesc,""))
	.&sql(INSERT INTO AR_RcptPayMode (PAYM_ParRef, PAYM_PayMode_DR, PAYM_Amt, PAYM_InvUser, PAYM_InvDate, PAYM_InvTime)
		VALUES(:ArrcpRowid, :PayModeId, :PayAmt, :InvUser, :InvDate, :InvTime))
	.s err=SQLCODE
	
	i (err'=0) tro  q err
  
	d ..tc()
	
	q err
}

ClassMethod tb()
{
   	n SQLCODE
   	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
	i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
	q
}

/// Creator: yyx
/// CreateDate: 2009-07-17
/// Description: 取病人欠费标志，病人没有补交记录时，或全部都补齐时可以取消结算，否则不允许取消结算
/// Input: BillNo
/// Return: Flag:0 表示不允许取消结算；1,2允许取消结算
/// Debug: w ##class(web.UDHCJFQFDEAL).GetAdmToPayFlag(2767)
ClassMethod GetAdmToPayFlag(BillNo)
{
	n (BillNo)
	s Flag=2
	q:(+BillNo=0) Flag
	
	s AmountToPaidStr=..GetBillQFAmount(BillNo)       //判断欠费金额
	s AmountToPaid=+$p(AmountToPaidStr,"^",1)
	s QFNum=+$p(AmountToPaidStr,"^",2)
	q:(QFNum=0) 1
	//s PrtAmountToPaid=""
	s PrtRowID=$o(^DHCINVPRTZY(0,"AR",BillNo,""))
	i (PrtRowID'="") s PrtAmountToPaid=$p(^DHCINVPRTZY(PrtRowID),"^",28)
	i (AmountToPaid'=0)&&(AmountToPaid=$g(PrtAmountToPaid)) d
	.s Flag=1           ;刚置成欠费没有补交记录
	i ($g(PrtAmountToPaid)=0) d
	.s Flag=2           ;补交完成
	i (AmountToPaid'=$g(PrtAmountToPaid))&&($g(PrtAmountToPaid)'=0) d      
	.s Flag=0           ;补交部分时不允许取消结算
	
	q Flag
}

/// Creator: yyx
/// CreateDate: 2009-07-17
/// Function: 取消结算时，当没有补交记录时，则红冲欠费记录
/// Input: Adm
/// OutPut: Flag:0 成功，1失败
/// Debug: w ##class(web.UDHCJFQFDEAL).StrikeDiscretAmount(174, 2767, 1)
ClassMethod StrikeDiscretAmount(Adm, BillNo, User = "")
{
	new (Adm, BillNo, User)
	set RetVal=0
	set QFFlag=##class(web.UDHCJFQFDEAL).GetAdmToPayFlag(BillNo)
	set PrtRowID=$o(^DHCINVPRTZY(0,"AR",BillNo,""))
	
	ts
	
	if (PrtRowID'="") {
		&sql(UPDATE DHC_INVPRTZY SET PRT_DiscretOutstAmt=0 WHERE PRT_Rowid=:PrtRowID)
		set RetVal=SQLCODE
	}
	if (RetVal'=0) tro  quit RetVal
	if (QFFlag'=1) tc  quit RetVal  //没有补交记录时退出，不再红冲欠费表
	
	set QFRowIdStr=""
	set QFRowId=0
	while ($o(^DHCJFQFTOTAL(0,"Pbdr",BillNo,QFRowId))) {
		set QFRowId=$o(^DHCJFQFTOTAL(0,"Pbdr",BillNo,QFRowId))
		set QFRowIdStr=$s((QFRowIdStr=""):QFRowId,1:(QFRowIdStr_"^"_QFRowId))
	}
	for i=1:1:$l(QFRowIdStr,"^") {
		set QFRowId=$p(QFRowIdStr,"^",i)
		continue:(QFRowId="")
		set RetVal=##class(web.DHCJFQFTotal).SELECT(QFRowId)
		kill PLIST(1)
		set PLIST(3)=+$h
		set PLIST(4)=$p($h,",",2)
		set PLIST(5)=-PLIST(5)
		set PLIST(7)=User   //红冲的UserID 日期时间
		set PLIST(9)="S"
		&sql(INSERT INTO DHC_JFQFTotal VALUES:PLIST())
		set RetVal=SQLCODE
		quit:(RetVal'=0)
	}
	
	if (RetVal'=0) tro  quit RetVal
	
	tc
	
	quit RetVal
}

/// w ##class(web.UDHCJFQFDEAL).GetBillQFAmount(2767)
ClassMethod GetBillQFAmount(BillNo)
{
	n (BillNo)
	q:(+BillNo=0) 0_"^"_0
	
	s payamount=0, qfamount=0, QFNum=0
	
	s rowid=0
    f  s rowid=$o(^DHCJFQFTOTAL(0,"Pbdr",BillNo,rowid)) q:(rowid="")  d
	.s flag=$p(^DHCJFQFTOTAL(rowid),"^",5)
	.s amt=$p(^DHCJFQFTOTAL(rowid),"^",4)
	.q:(+amt=0)
	.s status=$p(^DHCJFQFTOTAL(rowid),"^",8)
	.q:(status="A")
	.i (" Q C "[(" "_flag_" ")) d
	..s qfamount=qfamount+amt
	..s QFNum=QFNum+1
	.;(" B T "[(" "_flag_" ")) d
	..;s qfamount=qfamount-amt
	i (qfamount'=0) d
	.s payamount=qfamount
	
    q payamount_"^"_QFNum
}

/// w ##class(web.UDHCJFQFDEAL).GetBJPayInfo(1465)
ClassMethod GetBJPayInfo(BillNo)
{
	n (BillNo)
	q:(+BillNo=0) ""
	
	k PayMAry
	
	s BJNum=0
	s BJStr="", TKStr=""
	
	s rowid=0
    f  s rowid=$o(^DHCJFQFTOTAL(0,"Pbdr",BillNo,rowid)) q:(rowid="")  d
    .s tmp=$g(^DHCJFQFTOTAL(rowid))
    .q:(tmp="")
	.s flag=$p(tmp,"^",5)
	.q:(" B T "'[(" "_flag_" "))
	.s status=$p(tmp,"^",8)
	.q:(status'="N")
	.s amt=$p(tmp,"^",4)
	.s PaymDR=$p(tmp,"^",13)
	.i (flag="B") d
	..s PayMAry(PaymDR,"BJ")=+$g(PayMAry(PaymDR,"BJ"))+amt
	..s BJNum=BJNum+1
	.e  i (flag="T") d
	..s PayMAry(PaymDR,"TK")=+$g(PayMAry(PaymDR,"TK"))+amt
	..s BJNum=BJNum+1
	
	s PaymDR=0
	f  s PaymDR=$o(PayMAry(PaymDR))  q:(PaymDR="")  d
	.//补交
	.s Amt=$fn($g(PayMAry(PaymDR,"BJ")),"",2)
	.i (+Amt'=0)  d
	..s tmpStr=PaymDR_"^"_Amt
	..s BJStr=$s((BJStr=""):tmpStr,1:(BJStr_$c(2)_tmpStr))
	.//退款
	.s Amt=$fn($g(PayMAry(PaymDR,"TK")),"",2)
	.i (+Amt'=0)  d
	..s tmpStr=PaymDR_"^"_Amt
	..s TKStr=$s((TKStr=""):tmpStr,1:(TKStr_$c(2)_tmpStr))
	
	s BJPayInfo=BJNum_$c(3)_BJStr_$c(3)_TKStr
	
	q BJPayInfo
}

/// w ##class(web.UDHCJFQFDEAL).getqfamountbill(2763)
ClassMethod getqfamountbill(BillNo)
{
	n (BillNo)
	q:(+BillNo=0) 0
	
	s qfamount=0
	
	s rowid=0
    f  s rowid=$o(^DHCJFQFTOTAL(0,"Pbdr",BillNo,rowid)) q:(rowid="")  d
	.s amt=$p(^DHCJFQFTOTAL(rowid),"^",4)
	.s flag=$p(^DHCJFQFTOTAL(rowid),"^",5)
	.s status=$p(^DHCJFQFTOTAL(rowid),"^",8)   //QF_Status
	.q:(status="A")
	.i (" Q C "[(" "_flag_" ")) d
	..s qfamount=qfamount+amt
	.i (flag="B") d
	..s qfamount=qfamount-amt
	.i (flag="T") d
	..s qfamount=qfamount+amt
	
    q $fn(qfamount,"",2)
}

}
