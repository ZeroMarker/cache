Import SQLUser

Class BILL.COM.ModifyINVPayMode Extends BILL.COM.Abstract
{

/// Creator: tangzf
/// CreatDate: 2021-03-18
/// Description: 按发票号 或 日期及操作员 查询发票支付方式等信息
/// Table:  dhc_invprt dhc_invpaymode
/// Input:  StDate EndDate 日期范围 Inv发票号 User默认当前登录的人
/// Output: RowID， 发票号，患者姓名，登记号，发票金额，支付方式及支付金额    
/// Return: 
/// Others: do ##class(%ResultSet).RunQuery("BILL.COM.ModifyINVPayMode","FindInvPayModeInfo",62823,63492,"","","OP")
Query FindInvPayModeInfo(StDate, EndDate, InvNo, Type As %String, PatientNo, SessionStr As %String) As websys.Query(ROWSPEC = "PrtRowID:%String:发票ID,PrtInv:%String:发票号,PatName:%String:患者姓名,RegNo:%String:登记号,PrtAcount:%Float:发票金额,PatShareAmt:%Float:自付金额,PrtDate:%String:收费日期,PrtTime:%String:收费时间,HandFlag:%String:日结ID,Deposit:%Float:冲押金金额,PrtFlag:%String:发票状态,DiscAmt:%Float:折扣金额,PayorAmt:%Float:记账金额")
{
}

ClassMethod FindInvPayModeInfoExecute(ByRef qHandle As %Binary, StDate, EndDate As %String, InvNo As %String, Type As %String, PatientNo, SessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("FindInvPayModeInfo")=$lb(StDate, EndDate, InvNo, Type, PatientNo, SessionStr)
 	if (Type="") quit $$$OK
 	
 	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
 	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 	
 	set UserId=$p(SessionStr,"^",1)
 	set HospId=$p(SessionStr,"^",4)

	set PatientId=$s((PatientNo'=""):$o(^PAPERi("PAPMI_PatNo",PatientNo,"")),1:"")
 	
    if (Type="OP"){
	 	if (InvNo'="") {
		 	set PrtRowID=$o(^DHCINVPRT(0,"INV",InvNo,0))
		 	if (PrtRowID'="") {
			 	do BuildOPINVInfo(PrtRowID)
			}
	 		quit $$$OK
	 	}
	 	
	 	if (PatientId'="") {
		 	set PrtRowID=0
			while($o(^DHCINVPRT(0,"PAPMI",PatientId,PrtRowID))) {
				set PrtRowID=$o(^DHCINVPRT(0,"PAPMI",PatientId,PrtRowID))
				do BuildOPINVInfo(PrtRowID)
			}
		 	quit $$$OK
	 	}
	 	
	 	for Date=StDate:1:EndDate {
		 	set PrtRowID=0
		 	while($o(^DHCINVPRT(0,"Date",Date,PrtRowID))) {
			 	set PrtRowID=$o(^DHCINVPRT(0,"Date",Date,PrtRowID))
			 	do BuildOPINVInfo(PrtRowID)
			}
	 	}
	 	quit $$$OK
    }
    
    if (Type="IP") {
	 	if (InvNo'="") {
	 		set PrtRowID=$o(^DHCINVPRTZY(0,"INV",InvNo,0))
	 		if (PrtRowID'="") {
		 		do BuildIPINVInfo
		 	}
		 	quit $$$OK
	 	}
	 	
		if (PatientId'="") {
		 	set PrtRowID=0
		 	while($o(^DHCINVPRTZY(0,"PAPMI",PatientId,PrtRowID))) {
			 	set PrtRowID=$o(^DHCINVPRTZY(0,"PAPMI",PatientId,PrtRowID))
			 	do BuildIPINVInfo
			}
		 	quit $$$OK
	    }
	    
	 	for Date=StDate:1:EndDate {
		 	set PrtRowID=0
		 	while($o(^DHCINVPRTZY(0,"DATE",Date,PrtRowID))) {
			 	set PrtRowID=$o(^DHCINVPRTZY(0,"DATE",Date,PrtRowID))
			 	do BuildIPINVInfo
			}
	 	}
	}
    
	quit $$$OK
BuildOPINVInfo(PrtRowID)
	set PrtData=$g(^DHCINVPRT(PrtRowID))
 	set HospDR=$p(PrtData,"^",39)
 	quit:(HospDR'=HospId)
 	set PrtFlag=$p(PrtData,"^",8)
 	quit:(PrtFlag'="N")
	set HandDr=$p(PrtData,"^",6)
	set Deposit=""
 	set PrtInv=$p(PrtData,"^",14)     //发票号
 	set PrtAcount=$p(PrtData,"^",1)   //发票金额
 	set PrtAcount=$fn(PrtAcount,"",2)
 	set PAPMIDr=$p(PrtData,"^",15) 
 	set PatName=$p(^PAPER(PAPMIDr,"ALL"),"^",1)      //患者姓名
 	set PatIPNo=$p(^PAPER(PAPMIDr,"PAT","1"),"^",1)  //登记号
 	set PrtDate=$p(PrtData,"^",5)
 	set PrtTime=$p(PrtData,"^",20)
 	set PrtDate=##class(websys.Conversions).DateLogicalToHtml(PrtDate)
 	set PrtTime=##class(websys.Conversions).TimeLogicalToHtml(PrtTime)
 	set PatShareAmt=$p(PrtData,"^",16)
 	set PatShareAmt=$fn(PatShareAmt,"",2)
 	set DiscAmt=$p(PrtData,"^",7)
 	set DiscAmt=$fn(DiscAmt,"",2)
 	set PayorAmt=$p(PrtData,"^",18)
 	set PayorAmt=$fn(PayorAmt,"",2)
 	do OutputRow
	quit
BuildIPINVInfo
	set PrtData=$g(^DHCINVPRTZY(PrtRowID))
 	set HospDR=$p(PrtData,"^",35)
 	quit:(HospDR'=HospId)
	set PrtInv=$p(PrtData,"^",1)   //发票号
	set PrtFlag=$p(PrtData,"^",8)
	quit:(" N I "'[(" "_PrtFlag_" "))
	set HandDr=$p(PrtData,"^",23)
	set Deposit=$p(PrtData,"^",22)
	set Deposit=$fn(Deposit,"",2)
	set Adm=$p(PrtData,"^",4)
	set PAPMIDr=$p(^PAADM(Adm),"^",1)
	set PrtDate=$p(PrtData,"^",2)
	set PrtTime=$p(PrtData,"^",3)
	set PrtDate=##class(websys.Conversions).DateLogicalToHtml(PrtDate)
	set PrtTime=##class(websys.Conversions).TimeLogicalToHtml(PrtTime)
	set PatName=$p(^PAPER(PAPMIDr,"ALL"),"^",1)     //患者姓名
	set PatIPNo=$p(^PAPER(PAPMIDr,"PAT","1"),"^",1) //登记号
	set Bill=$p(PrtData,"^",5)
	set BillData=$g(^DHCPB(Bill))
	set PatShareAmt=$p(BillData,"^",12)
	set PatShareAmt=$fn(PatShareAmt,"",2)
	set PrtAcount=$p(PrtData,"^",6) //发票金额
	set PrtAcount=$fn(PrtAcount,"",2)
	set DiscAmt=$p(BillData,"^",9)
	set DiscAmt=$fn(DiscAmt,"",2)
 	set PayorAmt=$p(BillData,"^",11)
 	set PayorAmt=$fn(PayorAmt,"",2)
	do OutputRow
	quit

OutputRow
	set Data=$lb(PrtRowID,PrtInv,PatName,PatIPNo,PrtAcount,PatShareAmt,PrtDate,PrtTime,HandDr,Deposit,PrtFlag,DiscAmt,PayorAmt)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// do ##class(%ResultSet).RunQuery("BILL.COM.ModifyINVPayMode","FindPayModeByRowID","2021-03-04","2021-06-07","","12173","OP","ALL","")  
Query FindPayMode(PayModeCode, HospDr) As websys.Query(ROWSPEC = "PayModeDesc:%String,PayModeCode:%String,CTRowID:%String")
{
}

ClassMethod FindPayModeExecute(ByRef qHandle As %Binary, PayModeCode, HospDr) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1

	set IPAllowPayMStr=##class(BILL.CFG.COM.DicDataCom).GetDicInfoByTypeCode("IPModifyPayMode", PayModeCode, HospDr)   //改为配置
	set IPAllowPayMStr=$p(IPAllowPayMStr,"^",6)
	set IPAllowPayMStrLen=$l(IPAllowPayMStr,"|")
	for idx=1:1:IPAllowPayMStrLen {
		set PayModeCode=$p(IPAllowPayMStr,"|",idx)
		continue:(PayModeCode="")
		set CTRowID=$o(^CT("CTPM",0,"Code",PayModeCode,0))
		continue:(CTRowID="")
		set PayModeDesc=$p(^CT("CTPM",CTRowID),"^",2)
		do OutputRow
	}
	quit $$$OK
OutputRow
	set Data=$lb(PayModeDesc,PayModeCode,CTRowID)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

Query FindPayModeByRowID(RowID As %String, Type As %String, LangId As %String = "") As websys.Query(ROWSPEC = "PayMSubRowID:%String,PayMDesc:%String,PayMAmt:%Float,PayMDR:%String,UnitDR:%String,Unit:%String")
{
}

ClassMethod FindPayModeByRowIDExecute(ByRef qHandle As %Binary, RowID As %String, Type As %String, LangId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	if (RowID="")  quit $$$OK
	
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
 	if (Type="OP") {
	 	set paymSub=0
	 	while($o(^DHCINVPRT(RowID,"P",paymSub))) {
		 	set paymSub=$o(^DHCINVPRT(RowID,"P",paymSub))
		 	set paymData=$g(^DHCINVPRT(RowID,"P",paymSub))
			set paymSubId=RowID_"||"_paymSub
			set paymDR=$p(paymData,"^",1)
			continue:(paymDR="")
			set paymDesc=$p(^CT("CTPM",paymDR),"^",2) //支付方式
			set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, LangId)
			set paymAmt=$p(paymData,"^",3)    //金额
			set paymAmt=$fn(paymAmt,"",2)
			set unitDR=$p(paymData,"^",9)  //公费单位
			set unit=$s((+unitDR'=0):$p($g(^CT("HCP",unitDR)),"^",2),1:"")
			set unit=##class(User.CTHealthCareProvider).GetTranByDesc("HCPDesc", unit, LangId)
			do OutputPMList
		}
		quit $$$OK
 	}
 	
 	if (Type="IP") {
	 	set paymSub=0
	 	while($o(^DHCINVPRTZY(RowID,"P",paymSub))) {
		 	set paymSub=$o(^DHCINVPRTZY(RowID,"P",paymSub))
		 	set paymData=$g(^DHCINVPRTZY(RowID,"P",paymSub))
		 	set paymSubId=RowID_"||"_paymSub
			set paymDR=$p(paymData,"^",1)
			continue:(paymDR="")
		 	set paymDesc=$p(^CT("CTPM",paymDR),"^",2)  //支付方式
		 	set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, LangId)
			set paymAmt=$p(paymData,"^",3)
			set paymAmt=$fn(paymAmt,"",2)
			set unitDR=$p(paymData,"^",8)  //公费单位
			set unit=$s((+unitDR'=0):$p($g(^CT("HCP",unitDR)),"^",2),1:"")
			set unit=##class(User.CTHealthCareProvider).GetTranByDesc("HCPDesc", unit, LangId)
		 	do OutputPMList
		}
	}

	quit $$$OK
OutputPMList
	set Data=$lb(paymSubId,paymDesc,paymAmt,paymDR,unitDR,unit)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// PayModeStr: CTPayMode.RowId1 & 支付方式对应金额1 & 修改操作时发票支付方式的主索引 ^ CTPayMode.RowId2 & 支付方式对应金额2 & 修改操作时发票支付方式的主索引 ……
/// insert
/// Debug: w ##class(BILL.COM.ModifyINVPayMode).InsertPayMode("2&4826.88&837||1","17275","IP","837")
ClassMethod InsertPayMode(PayModeStr As %String, UpUser As %String, Type As %String, ParentId As %String) As %String
{
	set ^TMP("InsertPayMode")=$lb(PayModeStr, UpUser, Type, ParentId)
	
	set UpateDate=+$h
	set UpateTime=$p($h,",",2)
	set rtn=0
	
	ts
	
 	set len=$l(PayModeStr,"^")
 	if (Type="IP") {     //住院
	 	for idx=1:1:len {
		 	set tmpPayMStr=$p(PayModeStr,"^",idx)
		 	set tmpPayMId=$p(tmpPayMStr,"&",1)
		 	set tmpPayMAmt=$p(tmpPayMStr,"&",2)
		 	continue:(tmpPayMId="")
		 	set OldInvPayDr=$p(tmpPayMStr,"&",3)
		 	//日志Start
		 	set TableClassName="USER.DHCINVPRTZYPAYMODE"
		 	set TableRowId=""
		 	set OptType=""
		 	set OldData=""
		 	set NewData=""
		 	//日志End
		 	if (+OldInvPayDr=0) {
			 	set OptType="INSERT"
			 	&SQL(
			 		INSERT INTO DHC_INVPRTZYPayMode (
			 			IPM_PRT_ParRef, IPM_PayMode_DR, IPM_Amt, IPM_InsuFlag, IPM_OptUser_DR
			 		)
			 		VALUES (
			 			:ParentId, :tmpPayMId, :tmpPayMAmt, 'N', :UpUser
			 		)
			 	)
			 	set rtn=SQLCODE
			 	if (+rtn) {
				 	set rtn=rtn_"^"_$g(%msg)
				 	quit
				}
			 	set TableRowId=%ROWID
				set NewData=$g(^DHCINVPRTZY(+TableRowId,"P",$p(TableRowId,"||",2)))
		 	}else {
			 	set OptType="UPDATE"
			 	set OldData=OldInvPayDr_"^"_$g(^DHCINVPRTZY(+OldInvPayDr,"P",$p(OldInvPayDr,"||",2)))
			 	&SQL(
			 		UPDATE DHC_INVPRTZYPayMode
			 		SET IPM_PayMode_DR = :tmpPayMId, IPM_Amt = :tmpPayMAmt
			 		WHERE %ID = :OldInvPayDr
			 	)
			 	set rtn=SQLCODE
			 	if (+rtn) {
				 	set rtn=rtn_"^"_$g(%msg)
				 	quit
				}
			 	set TableRowId=%ROWID
				set NewData=$g(^DHCINVPRTZY(+OldInvPayDr,"P",$p(OldInvPayDr,"||",2)))
		 	}
		 	//日志记录
		 	job ##class(INSU.COM.Tools).SaveLog(TableClassName, TableRowId, "IP", OptType, UpateDate, UpateTime, UpUser, OldData, NewData)::2
	 	}
 	}else {
	 	//门诊
	 	for idx=1:1:len {
		 	set tmpPayMStr=$p(PayModeStr,"^",idx)
		 	set tmpPayMId=$p(tmpPayMStr,"&",1)
		 	set tmpPayMAmt=$p(tmpPayMStr,"&",2)
		 	continue:(tmpPayMId="")
		 	set OldInvPayDr=$p(tmpPayMStr,"&",3)
		 	set tmpUnitDR=$p(tmpPayMStr,"&",4)
		 	//日志Start
		 	set TableClassName="USER.DHCINVPAYMODE"
		 	set TableRowId=""
		 	set OptType=""
		 	set OldData=""
		 	set NewData=""
		 	//日志End
		 	if (+OldInvPayDr=0) {
			 	set OptType="INSERT"
			 	&SQL(
			 		INSERT INTO DHC_INVPayMode (
			 			IPM_PRT_ParRef, IPM_PayMode_DR, IPM_Amt, IPM_Date, IPM_Time, IPM_Note3
			 		)
			 		VALUES (
			 			:ParentId, :tmpPayMId, :tmpPayMAmt, :UpateDate, :UpateTime, 1
			 		)
			 	)
			 	set rtn=SQLCODE
			 	if (+rtn) {
				 	set rtn=rtn_"^"_$g(%msg)
				 	quit
				}
			 	set TableRowId=%ROWID
				set NewData=^DHCINVPRT(+OldInvPayDr,"P",$p(OldInvPayDr,"||",2))
		 	}else {
			 	set OptType="UPDATE"
			 	set OldData=OldInvPayDr_"^"_$g(^DHCINVPRT(+OldInvPayDr,"P",$p(OldInvPayDr,"||",2)))
			 	&SQL(
			 		UPDATE DHC_INVPayMode
			 		SET IPM_PayMode_DR = :tmpPayMId, IPM_Amt = :tmpPayMAmt, IPM_Unit_DR = :tmpUnitDR
			 		WHERE %ID = :OldInvPayDr
			 	)
			 	set rtn=SQLCODE
			 	if (+rtn) {
				 	set rtn=rtn_"^"_$g(%msg)
				 	quit
				}
			 	set TableRowId=%ROWID
				set NewData=$g(^DHCINVPRT(+OldInvPayDr,"P",$p(OldInvPayDr,"||",2)))
		 	}
		 	//日志记录
		 	job ##class(INSU.COM.Tools).SaveLog(TableClassName, TableRowId, "OP", OptType, UpateDate, UpateTime, UpUser, OldData, NewData)::2
	 	}
 	}
 	if (+rtn) tro  quit rtn
 	
 	if ($tl>0) tc
 	
	quit rtn
}

/// Lid
/// 2015-08-05
/// 判断发票记录是否已经做财务结算
/// Debug: w ##class(BILL.COM.ModifyINVPayMode).IsHandin()
ClassMethod IsHandin(prtRowID As %String, Type As %String) As %String
{
	quit:(prtRowID="") ""
	if (Type="OP"){
		set reportDr=$p(^DHCINVPRT(prtRowID),"^",6)
		if (reportDr="") set flag="N"
		else  set flag="Y"
	}else {
		set reportDr=$p(^DHCINVPRTZY(prtRowID),"^",23)
		if (reportDr="") set flag="N"
		else  set flag="Y"
	}
	quit flag
}

ClassMethod GetHCPDescByID(HCPDescId As %String)
{
	quit:(HCPDescId="") ""
	quit $p($g(^CT("HCP",HCPDescId)),"^",2)
}

ClassMethod GetPayModeDescByID(PayModeId As %String, langId As %String = "")
{
	quit:(PayModeId="") ""
	set PayModeDesc=$p($g(^CT("CTPM",PayModeId)),"^",2)
	set PayModeDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", PayModeDesc, langId)
	quit PayModeDesc
}

}
