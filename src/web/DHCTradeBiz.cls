Class web.DHCTradeBiz Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod GetRows() As %String
{
	Q $O(^TMPErrorCheckPrint($j,""),-1)
}

ClassMethod GetRowInfo(Row As %String) As %String
{
	Q $g(^TMPErrorCheckPrint($j,Row))
}

ClassMethod GetPath() As %String
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

ClassMethod ErrorCheckClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ErrorCheckExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 差异帐目统计
ClassMethod ErrorCheckExecute(ByRef qHandle As %Binary, HospitalId As %String = "002", BankCode As %String = "CCB", StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	;w ##class(%ResultSet).RunQuery("web.DHCTradeBiz","ErrorCheck","002","CCB",61947,"")
	s ^gry("Query","ErrorCheck")=HospitalId_","_BankCode_","_StartDate_","_EndDate
	K ^TMPErrorCheck($j)
	K ^TMPErrorCheckPrint($j)
	s Num=0
	if $l(StartDate,"/")=3 s StartDate=$zdh(StartDate,4)
	if $l(EndDate,"/")=3 s EndDate=$zdh(EndDate,4)
	if StartDate="" s StartDate=+$H
	if EndDate="" s EndDate=+$H
	
	Set rset=##Class(%ResultSet).%New("web.DHCTradeBiz:TradeBiz")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(HospitalId,BankCode,StartDate,EndDate)
		If 'Status Quit
		;Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s CheckDate=rset.Data("CheckDate")
			s CheckFee=rset.Data("CheckFee")
			s BookCount=rset.Data("BookCount")
			s ReBookCount=rset.Data("ReBookCount")
			s PayCount=rset.Data("PayCount")
			s PayFee=rset.Data("PayFee")
			s RePayCount=rset.Data("RePayCount")
			s RePayFee=rset.Data("RePayFee")
			if CheckDate="" continue
			if $l(CheckDate,"-")=3 s CheckDate=$zdh(CheckDate,3)
			if $l(CheckDate,"/")=3 s CheckDate=$zdh(CheckDate,4)
			s ^TMPErrorCheck($j,CheckDate)=CheckFee_"^"_BookCount_"^"_ReBookCount_"^"_PayCount_"^"_PayFee_"^"_RePayCount_"^"_RePayFee
		}
	}
	;比较开始
	for Date=StartDate:1:EndDate {
		do ResetVariables
		s BCRowid=0
		for {
			s BCRowid=$O(^DHCBCi(0,"CheckDate",Date,BCRowid))
			Q:BCRowid=""
			b
			;银行预约总数量
			s YHCompBookCount=$p($g(^DHCBC(BCRowid)),"^",6)
			s YHCompReBookCount=$p($g(^DHCBC(BCRowid)),"^",13)
			s YHCompAllCount=YHCompBookCount-YHCompReBookCount
			;银行付费总数量
			s YHCompPayCount=$p($g(^DHCBC(BCRowid)),"^",7)
			s YHCompRePayCount=$p($g(^DHCBC(BCRowid)),"^",15)
			s YHCompAllPayCount=YHCompPayCount-YHCompRePayCount
			;银行对账总金额
			s YHCompCheckFee=$P(^DHCBC(BCRowid),"^",8)
			
			;医院预约总数量
			s CompBookCount=$p($g(^TMPErrorCheck($j,Date)),"^",2)
			s CompReBookCount=$p($g(^TMPErrorCheck($j,Date)),"^",3)
			s CompAllCount=CompBookCount-CompReBookCount
			;医院付费总数量
			s CompPayCount=$p($g(^TMPErrorCheck($j,Date)),"^",4)
			s CompRePayCount=$p($g(^TMPErrorCheck($j,Date)),"^",6)
			s CompAllPayCount=CompPayCount-CompRePayCount
			;医院对账总金额
			s CompCheckFee=$p($g(^TMPErrorCheck($j,Date)),"^",1)
			s ^gry("CompCheck",Date)=CompCheckFee_"!"_YHCompCheckFee_"^"_CompAllCount_"!"_YHCompAllCount_"^"_CompAllPayCount_"!"_YHCompAllPayCount
			if (+CompCheckFee'=+YHCompCheckFee)||(+CompAllCount'=+YHCompAllCount)||(+CompAllPayCount'=+YHCompAllPayCount) {
				;医院
				s HTBCheckFee=$p($g(^TMPErrorCheck($j,Date)),"^",1)
				s HTBBookCount=$p($g(^TMPErrorCheck($j,Date)),"^",2)
				s HTBReBookCount=$p($g(^TMPErrorCheck($j,Date)),"^",3)
				s HTBPayCount=$p($g(^TMPErrorCheck($j,Date)),"^",4)
				s HTBPayFee=$p($g(^TMPErrorCheck($j,Date)),"^",5)
				s HTBRePayCount=$p($g(^TMPErrorCheck($j,Date)),"^",6)
				s HTBRePayFee=$p($g(^TMPErrorCheck($j,Date)),"^",7)
				
				;银行
				s BCBookCount=$p($g(^DHCBC(BCRowid)),"^",6)
				s BCCheckDate=$p($g(^DHCBC(BCRowid)),"^",4)
				s BCCheckFee=$p($g(^DHCBC(BCRowid)),"^",8)
				s BCCheckFlag=$p($g(^DHCBC(BCRowid)),"^",12)
				s BCCheckTime=$p($g(^DHCBC(BCRowid)),"^",5)
				s BCClientAddress=$p($g(^DHCBC(BCRowid)),"^",3)
				s BCPayCount=$p($g(^DHCBC(BCRowid)),"^",7)
				s BCPayFee=$p($g(^DHCBC(BCRowid)),"^",14)
				s BCReBookCount=$p($g(^DHCBC(BCRowid)),"^",13)
				s BCRePayCount=$p($g(^DHCBC(BCRowid)),"^",15)
				s BCRePayFee=$p($g(^DHCBC(BCRowid)),"^",16)
				s BCRemark=$g(^DHCBC(BCRowid,"BCR",1))
				s BCTransactionId=$p($g(^DHCBC(BCRowid)),"^",1)
				s BCUpdateDate=$p($g(^DHCBC(BCRowid)),"^",9)
				s BCUpdateTime=$p($g(^DHCBC(BCRowid)),"^",10)
				s BCUpdateUser=$p($g(^DHCBC(BCRowid)),"^",11)
				s BCUserID=$p($g(^DHCBC(BCRowid)),"^",2)
				;转换
				s BCPayFee=+BCPayFee,BCRePayFee=+BCRePayFee
				if BCCheckDate'="" s BCCheckDate=$zd(BCCheckDate,3)
				if BCUpdateDate'="" s BCUpdateDate=$zd(BCUpdateDate,3)
				if BCCheckTime'="" s BCCheckTime=$zt(BCCheckTime,1)
				if BCUpdateTime'="" s BCUpdateTime=$zt(BCUpdateTime,1)
				if BCUpdateUser'="" s BCUpdateUser=$p(^SSU("SSUSR",BCUpdateUser),"^",2)
				;判断
				;
				
				s TransactionId=BCTransactionId
				s UserID=BCUserID
				s ClientAddress=BCClientAddress
				s CheckDate=BCCheckDate
				s BookCount=BCBookCount-HTBBookCount
				s ReBookCount=BCReBookCount-HTBReBookCount
				s PayCount=BCPayCount-HTBPayCount
				s PayFee=BCPayFee-HTBPayFee
				s RePayCount=BCRePayCount-HTBRePayCount
				s RePayFee=BCRePayFee-(-HTBRePayFee)
				s CheckFee=BCCheckFee-HTBCheckFee
				s TRowid=BCRowid
				;交易流水号,用户,客户端地址,对账日期,预约笔数,取消预约笔数,支付笔数,支付金额,取消支付笔数,取消支付金额,对账总金额,行Rowid
				s Num=Num+1
				s ^TMPErrorCheckPrint($j,Num)=TransactionId_"^"_UserID_"^"_ClientAddress_"^"_CheckDate_"^"_BookCount_"^"_ReBookCount_"^"_PayCount_"^"_PayFee_"^"_RePayCount_"^"_RePayFee_"^"_CheckFee_"^"_TRowid
				do OutputRow
			}
		}
	}

 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(TransactionId,UserID,ClientAddress,CheckDate,BookCount,ReBookCount,PayCount,PayFee,RePayCount,RePayFee,CheckFee,TRowid)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables
	;set (repid)=0
	set (TransactionId,UserID,ClientAddress,CheckDate,BookCount,ReBookCount,PayCount,PayFee,RePayCount,RePayFee,CheckFee,TRowid)=""
	quit
}

ClassMethod ErrorCheckFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ErrorCheckExecute ]
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

Query ErrorCheck(HospitalId As %String = "002", BankCode As %String = "CCB", StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "TransactionId,UserID,ClientAddress,CheckDate,BookCount,ReBookCount,PayCount,PayFee,RePayCount,RePayFee,CheckFee,TRowid")
{
}

ClassMethod TradeBizClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TradeBizExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 医院帐目统计
/// d ##class(%ResultSet).RunQuery("web.DHCTradeBiz","TradeBiz","002","CCB","61954","61954")
ClassMethod TradeBizExecute(ByRef qHandle As %Binary, HospitalId As %String = "002", BankCode As %String = "CCB", StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	K ^TMPBankCheckDetail
	if $l(StartDate,"/")=3 s StartDate=$zdh(StartDate,4)
	if $l(EndDate,"/")=3 s EndDate=$zdh(EndDate,4)
	if StartDate="" s StartDate=+$H
	if EndDate="" s EndDate=+$H
	
	s (TransactionId,UserID,ClientAddress,CheckDate,BookCount,ReBookCount,PayCount,PayFee,RePayCount,RePayFee,CheckFee,TRowid)=""
	for Date=StartDate:1:EndDate {
		do ResetVariables
		s HTBRowid=0
		for {
			;d ResetVariables
			s HTBRowid=$O(^HXTB(0,"Status","TradeBDate",Date,HTBRowid))
			Q:HTBRowid=""
			s HTBBizType=$p($g(^HXTB(HTBRowid)),"^",1)
			s HTBChannel=$p($g(^HXTB(HTBRowid)),"^",2)
			s HTBFlag=$p($g(^HXTB(HTBRowid)),"^",20)
			s HTBInitDR=$p($g(^HXTB(HTBRowid)),"^",19)
			s HTBMerchantKey=$p($g(^HXTB(HTBRowid)),"^",3)
			s HTBMerchantNo=$p($g(^HXTB(HTBRowid)),"^",4)
			s HTBPatientID=$p($g(^HXTB(HTBRowid)),"^",5)
			s HTBPayAgency=$p($g(^HXTB(HTBRowid)),"^",22)
			s HTBPayCardNo=$p($g(^HXTB(HTBRowid)),"^",23)
			s HTBPayUser=$p($g(^HXTB(HTBRowid)),"^",24)
			s HTBStatus=$p($g(^HXTB(HTBRowid)),"^",6)
			s HTBTradeAmt=$p($g(^HXTB(HTBRowid)),"^",9)
			s HTBTradeBDate=$p($g(^HXTB(HTBRowid)),"^",14)
			s HTBTradeBTime=$p($g(^HXTB(HTBRowid)),"^",21)
			s HTBTradeDate=$p($g(^HXTB(HTBRowid)),"^",7)
			s HTBTradeKey=$p($g(^HXTB(HTBRowid)),"^",12)
			s HTBTradeNo=$p($g(^HXTB(HTBRowid)),"^",10)
			s HTBTradeTime=$p($g(^HXTB(HTBRowid)),"^",8)
			s HTBTradeType=$p($g(^HXTB(HTBRowid)),"^",11)

			;转换
			s HTBTradeAmt=+HTBTradeAmt
			if HTBTradeBDate'="" s HTBTradeBDate=$zd(HTBTradeBDate,3)
			if HTBTradeDate'="" s HTBTradeDate=$zd(HTBTradeDate,3)
			if HTBTradeBTime'="" s HTBTradeBTime=$zt(HTBTradeBTime,1)
			if HTBTradeTime'="" s HTBTradeTime=$zt(HTBTradeTime,1)
			;判断
			if HTBChannel'=1 continue   ;只统计1为银行的
			if (BankCode'="")&&(HTBPayUser'=BankCode) continue ;只统计支付过的
			;计算，存入临时Global
			;s CheckFee=+CheckFee+HTBTradeAmt
			
			s TradeSub=0
			for {
				s TradeSub=$O(^HXTB(0,"Status","TradeBDate",Date,HTBRowid,TradeSub))
				Q:TradeSub=""
				s TransactionId="医院"
				s UserID="1334"
				s ClientAddress=""
				s CheckDate=Date
				s SubTradeType=$P(^HXTB(HTBRowid,"Status",TradeSub),"^",2)
				s SubTradeAmt=$P(^HXTB(HTBRowid,"Status",TradeSub),"^",9)
				if SubTradeType=1 s BookCount=+BookCount+1
				if SubTradeType=3 s ReBookCount=+ReBookCount+1
				if SubTradeType=2 {
					;s BookCount=+BookCount-1
					s PayCount=+PayCount+1
					s PayFee=+PayFee+(+SubTradeAmt)
				}
				if SubTradeType=4 {
					s ReBookCount=+ReBookCount+1
					s RePayCount=+RePayCount+1
					s RePayFee=RePayFee+(+SubTradeAmt)	
				}
				s CheckFee=+CheckFee+SubTradeAmt
				
				s TRowid=HTBRowid
				s ^TMPBankCheckDetail(TransactionId,CheckDate)=TransactionId_"^"_UserID_"^"_ClientAddress_"^"_CheckDate_"^"_BookCount_"^"_ReBookCount_"^"_PayCount_"^"_PayFee_"^"_RePayCount_"^"_RePayFee_"^"_CheckFee_"^"_TRowid
				;交易流水号,用户,客户端地址,对账日期,预约笔数,取消预约笔数,支付笔数,支付金额,取消支付笔数,取消支付金额,对账总金额,行Rowid
			}
		}
	}
	
	b ;Query finsh
	s TmpFirstID=0
	for {
		s TmpFirstID=$O(^TMPBankCheckDetail(TmpFirstID)) Q:TmpFirstID=""
		s TmpSecondID=0
		for {
			s TmpSecondID=$O(^TMPBankCheckDetail(TmpFirstID,TmpSecondID)) Q:TmpSecondID=""
			s TransactionId=$P(^TMPBankCheckDetail(TmpFirstID,TmpSecondID),"^",1)
			s UserID=$P(^TMPBankCheckDetail(TmpFirstID,TmpSecondID),"^",2)
			s ClientAddress=$P(^TMPBankCheckDetail(TmpFirstID,TmpSecondID),"^",3)
			s CheckDate=$P(^TMPBankCheckDetail(TmpFirstID,TmpSecondID),"^",4)
			s BookCount=$P(^TMPBankCheckDetail(TmpFirstID,TmpSecondID),"^",5)
			s ReBookCount=$P(^TMPBankCheckDetail(TmpFirstID,TmpSecondID),"^",6)
			s PayCount=$P(^TMPBankCheckDetail(TmpFirstID,TmpSecondID),"^",7)
			s PayFee=$P(^TMPBankCheckDetail(TmpFirstID,TmpSecondID),"^",8)
			s RePayCount=$P(^TMPBankCheckDetail(TmpFirstID,TmpSecondID),"^",9)
			s RePayFee=$P(^TMPBankCheckDetail(TmpFirstID,TmpSecondID),"^",10)
			s CheckFee=$P(^TMPBankCheckDetail(TmpFirstID,TmpSecondID),"^",11)
			s TRowid=$P(^TMPBankCheckDetail(TmpFirstID,TmpSecondID),"^",12)
			do OutputRow
		}
	}

 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(TransactionId,UserID,ClientAddress,CheckDate,BookCount,ReBookCount,PayCount,PayFee,RePayCount,RePayFee,CheckFee,TRowid)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables
	;set (repid)=0
	set (TransactionId,UserID,ClientAddress,CheckDate,BookCount,ReBookCount,PayCount,PayFee,RePayCount,RePayFee,CheckFee,TRowid)=""
	quit
}

ClassMethod TradeBizFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TradeBizExecute ]
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

Query TradeBiz(HospitalId As %String = "002", BankCode As %String = "CCB", StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "TransactionId,UserID,ClientAddress,CheckDate,BookCount,ReBookCount,PayCount,PayFee,RePayCount,RePayFee,CheckFee,TRowid")
{
}

ClassMethod TradeBizDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TradeBizDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 医院帐目明细
ClassMethod TradeBizDetailExecute(ByRef qHandle As %Binary, HospitalId As %String = "002", BankCode As %String = "CCB", StartDate As %String, EndDate As %String, ParRefID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	if $l(StartDate,"/")=3 s StartDate=$zdh(StartDate,4)
	if $l(EndDate,"/")=3 s EndDate=$zdh(EndDate,4)
	if StartDate="" s StartDate=+$H
	if EndDate="" s EndDate=+$H
	;因为医院的帐目在夫页面的时候是通过统计所得,所以没有固定ParRefID,需要通过时间段才能统计正确
	s ParRefID=""
	if ParRefID'="" {
		s Date=$p($g(^HXTB(ParRefID)),"^",14)
		do getOutByParRef
	}else{
		for Date=StartDate:1:EndDate {
			s ParRefID=0
			for {
				;s ParRefID=$O(^HXTB(0,"TradeBDate",Date,ParRefID))
				s ParRefID=$O(^HXTB(0,"Status","TradeBDate",Date,ParRefID))
				Q:ParRefID=""
	    		do getOutByParRef
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
getOutByParRef
	s HTBBizType=$p($g(^HXTB(ParRefID)),"^",1)
	s HTBChannel=$p($g(^HXTB(ParRefID)),"^",2)
	s HTBFlag=$p($g(^HXTB(ParRefID)),"^",20)
	s HTBInitDR=$p($g(^HXTB(ParRefID)),"^",19)
	s HTBMerchantKey=$p($g(^HXTB(ParRefID)),"^",3)
	s HTBMerchantNo=$p($g(^HXTB(ParRefID)),"^",4)
	s HTBPatientID=$p($g(^HXTB(ParRefID)),"^",5)
	s HTBPayAgency=$p($g(^HXTB(ParRefID)),"^",22)
	s HTBPayCardNo=$p($g(^HXTB(ParRefID)),"^",23)
	s HTBPayUser=$p($g(^HXTB(ParRefID)),"^",24)
	s HTBStatus=$p($g(^HXTB(ParRefID)),"^",6)
	s HTBTradeAmt=$p($g(^HXTB(ParRefID)),"^",9)
	s HTBTradeBDate=$p($g(^HXTB(ParRefID)),"^",14)
	s HTBTradeBTime=$p($g(^HXTB(ParRefID)),"^",21)
	s HTBTradeDate=$p($g(^HXTB(ParRefID)),"^",7)
	s HTBTradeKey=$p($g(^HXTB(ParRefID)),"^",12)
	s HTBTradeNo=$p($g(^HXTB(ParRefID)),"^",10)
	s HTBTradeTime=$p($g(^HXTB(ParRefID)),"^",8)
	s HTBTradeType=$p($g(^HXTB(ParRefID)),"^",11)
	;转换
	s HTBTradeAmt=+HTBTradeAmt
	if HTBTradeBDate'="" s HTBTradeBDate=$zd(HTBTradeBDate,3)
	if HTBTradeDate'="" s HTBTradeDate=$zd(HTBTradeDate,3)
	if HTBTradeBTime'="" s HTBTradeBTime=$zt(HTBTradeBTime,1)
	if HTBTradeTime'="" s HTBTradeTime=$zt(HTBTradeTime,1)
	;判断
	if HTBChannel'=1 quit   ;只统计1为银行的
	if (BankCode'="")&&(HTBPayUser'=BankCode) quit ;只统计支付过的
	
    s TradeSub=0
    for {
	    s TradeSub=$O(^HXTB(0,"Status","TradeBDate",Date,ParRefID,TradeSub))
	    Q:TradeSub=""
	    s MerchantNo=$p(^HXTB(ParRefID,"Status",TradeSub),"^",1)
	    s TradeAmt=$p(^HXTB(ParRefID,"Status",TradeSub),"^",9)
	    s TradeBDate=$p(^HXTB(ParRefID,"Status",TradeSub),"^",6)
	    s TradeBTime=$p(^HXTB(ParRefID,"Status",TradeSub),"^",13)
	    s TradeChannel=$p(^HXTB(ParRefID,"Status",TradeSub),"^",11)
	    s TradeDate=$p(^HXTB(ParRefID,"Status",TradeSub),"^",4)
	    s TradeMessage=$p(^HXTB(ParRefID,"Status",TradeSub),"^",3)
	    s TradePRTDR=$p(^HXTB(ParRefID,"Status",TradeSub),"^",12)
	    s TradePayAgency=$p(^HXTB(ParRefID,"Status",TradeSub),"^",10)
	    s TradePayCardNo=$p(^HXTB(ParRefID,"Status",TradeSub),"^",7)
	    s TradePayUser=$p(^HXTB(ParRefID,"Status",TradeSub),"^",8)
	    s TradeTime=$p(^HXTB(ParRefID,"Status",TradeSub),"^",5)
	    s TradeType=$p(^HXTB(ParRefID,"Status",TradeSub),"^",2)
	    
	    if TradeType=1 s TradeType="预约"
	    if TradeType=2 s TradeType="确认支付"
	    if TradeType=3 s TradeType="取消预约"
	    if TradeType=4 s TradeType="取消挂号"
	    if TradeType=5 s TradeType="PayOK"
	    if TradeType=6 s TradeType="其他"
	    s PatName="",PatSex="",PatDob=""
		if HTBPatientID'="" {
			s PatName=$P($g(^PAPER(HTBPatientID,"ALL")),"^",1)
			s PatSex=$P($g(^PAPER(HTBPatientID,"ALL")),"^",7)
			if PatSex'="" s PatSex=$p($g(^CT("SEX",PatSex)),"^",2)
			s PatDob=$P($g(^PAPER(HTBPatientID,"ALL")),"^",6)
			if PatDob'="" s PatDob=$zd(PatDob,3)
		}
		s AppDate="",AppDep="",AppDoc="",AppOPUser="",AppOPDate="",AppOPTime="",AppSeqNo=""
		if HTBTradeKey'="" {
			s RESRowid=$p(HTBTradeKey,"||",1)
			s ASRowid=$p(HTBTradeKey,"||",2)
			s APPTRowid=$p(HTBTradeKey,"||",3)
			s AppDate=$p(^RBAS(RESRowid,ASRowid),"^",1)
			if AppDate'="" s AppDate=$zd(AppDate,3)
			s AppDep=$p(^RB("RES",RESRowid),"^",1)
			if AppDep'="" s AppDep=$p(^CTLOC(AppDep),"^",2)
			s AppDoc=$p(^RB("RES",RESRowid),"^",2)
			if AppDoc'="" s AppDoc=$p(^CTPCP(AppDoc,1),"^",2)
			s AppOPUser=$p(^RBAS(RESRowid,ASRowid,"APPT",APPTRowid),"^",11)
			if AppOPUser'="" s AppOPUser=$p(^SSU("SSUSR",AppOPUser),"^",2)
			s AppOPDate=$p(^RBAS(RESRowid,ASRowid,"APPT",APPTRowid),"^",8)
			if AppOPDate'="" s AppOPDate=$zd(AppOPDate,3)
			s AppOPTime=$p(^RBAS(RESRowid,ASRowid,"APPT",APPTRowid),"^",9)
			if AppOPTime'="" s AppOPTime=$zt(AppOPTime,1)
			s AppSeqNo=$p(^RBAS(RESRowid,ASRowid,"APPT",APPTRowid),"^",5)
		}
		
		;同步到医院账单的变量字段上
		s HTBMerchantNo=MerchantNo
		s HTBPatientID=HTBPatientID
		s HTBTradeKey=HTBTradeKey
		s HTBTradeAmt=TradeAmt
		
		do OutputRow
    }
    quit
OutputRow
	set Data=$lb(HTBMerchantNo,HTBPatientID,HTBTradeKey,HTBTradeAmt,PatName,PatSex,PatDob,AppDate,AppDep,AppDoc,AppOPUser,AppOPDate,AppOPTime,AppSeqNo,TradeType)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables
	;set (repid)=0
	set (HTBMerchantNo,HTBPatientID,HTBTradeKey,HTBTradeAmt,PatName,PatSex,PatDob,AppDate,AppDep,AppDoc,AppOPUser,AppOPDate,AppOPTime,AppSeqNo,TradeType)=""
	quit
}

ClassMethod TradeBizDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TradeBizDetailExecute ]
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

Query TradeBizDetail(HospitalId As %String = "002", BankCode As %String = "CCB", StartDate As %String, EndDate As %String, ParRefID As %String = "") As %Query(ROWSPEC = "HTBMerchantNo,HTBPatientID,HTBTradeKey,HTBTradeAmt,PatName,PatSex,PatDob,AppDate,AppDep,AppDoc,AppOPUser,AppOPDate,AppOPTime,AppSeqNo,OperType")
{
}

ClassMethod BankCheckClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BankCheckExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 银行帐目统计
ClassMethod BankCheckExecute(ByRef qHandle As %Binary, HospitalId As %String = "002", BankCode As %String = "CCB", StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s ^gry("Query","BankCheck")=HospitalId_","_BankCode_","_StartDate_","_EndDate
	if $l(StartDate,"/")=3 s StartDate=$zdh(StartDate,4)
	if $l(EndDate,"/")=3 s EndDate=$zdh(EndDate,4)
	if StartDate="" s StartDate=+$H
	if EndDate="" s EndDate=+$H
	
	for Date=StartDate:1:EndDate {
		s BCRowid=0
		for {
			;d ResetVariables
			s BCRowid=$O(^DHCBCi(0,"CheckDate",Date,BCRowid))
			Q:BCRowid=""
			s BCBookCount=$p($g(^DHCBC(BCRowid)),"^",6)
			s BCCheckDate=$p($g(^DHCBC(BCRowid)),"^",4)
			s BCCheckFee=$p($g(^DHCBC(BCRowid)),"^",8)
			s BCCheckFlag=$p($g(^DHCBC(BCRowid)),"^",12)
			s BCCheckTime=$p($g(^DHCBC(BCRowid)),"^",5)
			s BCClientAddress=$p($g(^DHCBC(BCRowid)),"^",3)
			s BCPayCount=$p($g(^DHCBC(BCRowid)),"^",7)
			s BCPayFee=$p($g(^DHCBC(BCRowid)),"^",14)
			s BCReBookCount=$p($g(^DHCBC(BCRowid)),"^",13)
			s BCRePayCount=$p($g(^DHCBC(BCRowid)),"^",15)
			s BCRePayFee=$p($g(^DHCBC(BCRowid)),"^",16)
			s BCRemark=$g(^DHCBC(BCRowid,"BCR",1))
			s BCTransactionId=$p($g(^DHCBC(BCRowid)),"^",1)
			s BCUpdateDate=$p($g(^DHCBC(BCRowid)),"^",9)
			s BCUpdateTime=$p($g(^DHCBC(BCRowid)),"^",10)
			s BCUpdateUser=$p($g(^DHCBC(BCRowid)),"^",11)
			s BCUserID=$p($g(^DHCBC(BCRowid)),"^",2)
			s BCAutoPayCount=$p($g(^DHCBC(BCRowid)),"^",17)
			s BCAutoPayFee=$p($g(^DHCBC(BCRowid)),"^",18)
			s BCReAutoPayCount=$p($g(^DHCBC(BCRowid)),"^",19)
			s BCReAutoPayFee=$p($g(^DHCBC(BCRowid)),"^",20)
			;转换,冲正的归纳到支付和取消支付部分,冲正的金额业务都是在医院进行,此部分只对数量不对金额
			s BCPayCount=+BCPayCount,BCRePayCount=+BCRePayCount
			s BCPayFee=+BCPayFee,BCRePayFee=+BCRePayFee
			s BCPayCount=BCPayCount+(+BCAutoPayCount),BCRePayCount=BCRePayCount+(+BCReAutoPayCount)
		    ;s BCPayFee=BCPayFee+(+BCAutoPayFee),BCRePayFee=BCRePayFee+(+BCReAutoPayFee)
			if BCCheckDate'="" s BCCheckDate=$zd(BCCheckDate,3)
			if BCUpdateDate'="" s BCUpdateDate=$zd(BCUpdateDate,3)
			if BCCheckTime'="" s BCCheckTime=$zt(BCCheckTime,1)
			if BCUpdateTime'="" s BCUpdateTime=$zt(BCUpdateTime,1)
			if BCUpdateUser'="" s BCUpdateUser=$p(^SSU("SSUSR",BCUpdateUser),"^",2)
			;判断
			;
			
			s TransactionId=BCTransactionId
			s UserID=BCUserID
			s ClientAddress=BCClientAddress
			s CheckDate=BCCheckDate
			s BookCount=BCBookCount
			s ReBookCount=BCReBookCount
			s PayCount=BCPayCount
			s PayFee=BCPayFee
			s RePayCount=BCRePayCount
			s RePayFee=BCRePayFee
			s CheckFee=BCCheckFee
			s TRowid=BCRowid
			;交易流水号,用户,客户端地址,对账日期,预约笔数,取消预约笔数,支付笔数,支付金额,取消支付笔数,取消支付金额,对账总金额,行Rowid
			do OutputRow
		}
	}

 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(TransactionId,UserID,ClientAddress,CheckDate,BookCount,ReBookCount,PayCount,PayFee,RePayCount,RePayFee,CheckFee,TRowid)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables
	;set (repid)=0
	set (TransactionId,UserID,ClientAddress,CheckDate,BookCount,ReBookCount,PayCount,PayFee,RePayCount,RePayFee,CheckFee,TRowid)=""
	quit
}

ClassMethod BankCheckFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BankCheckExecute ]
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

Query BankCheck(HospitalId As %String = "002", BankCode As %String = "CCB", StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "TransactionId,UserID,ClientAddress,CheckDate,BookCount,ReBookCount,PayCount,PayFee,RePayCount,RePayFee,CheckFee,TRowid")
{
}

ClassMethod BankCheckDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BankCheckDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 银行帐目明细
ClassMethod BankCheckDetailExecute(ByRef qHandle As %Binary, HospitalId As %String = "002", BankCode As %String = "CCB", StartDate As %String, EndDate As %String, ParRefID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s ^gry("Query","BankCheckDetail")=HospitalId_","_BankCode_","_StartDate_","_EndDate_","_ParRefID
	if $l(StartDate,"/")=3 s StartDate=$zdh(StartDate,4)
	if $l(EndDate,"/")=3 s EndDate=$zdh(EndDate,4)
	if StartDate="" s StartDate=+$H
	if EndDate="" s EndDate=+$H
	;if ParRefID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	if ParRefID'="" {
		do getOutByParRef
	}else{
		for Date=StartDate:1:EndDate {
			s ParRefID=0
			for {
				s ParRefID=$O(^DHCBCi(0,"CheckDate",Date,ParRefID))
				Q:ParRefID=""
				do getOutByParRef
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
getOutByParRef
	s ChildSub=0
	for {
		s ChildSub=$O(^DHCBC(ParRefID,ChildSub))
		Q:ChildSub=""
		s BCSPatientID=$p(^DHCBC(ParRefID,ChildSub),"^",1)
		s BCSApptId=$p(^DHCBC(ParRefID,ChildSub),"^",2)
		s BCSPayFee=$p(^DHCBC(ParRefID,ChildSub),"^",3)
		s BCSPayFlag=$p(^DHCBC(ParRefID,ChildSub),"^",4)
		s BCSTransactionId=$p(^DHCBC(ParRefID,ChildSub),"^",5)
		s BCSOperType=$p(^DHCBC(ParRefID,ChildSub),"^",6)
		if BCSOperType=0 s BCSOperType="预约"
		if BCSOperType=1 s BCSOperType="取消预约"
		if BCSOperType=2 s BCSOperType="确认支付"
		if BCSOperType=3 s BCSOperType="取消"
		
		if (BCSApptId'="")&&(BCSApptId'["||") {
			s HTBRowid=$O(^HXTB(0,"TradeNo",BCSApptId,""))
			if HTBRowid'="" s BCSApptId=$p(^HXTB(HTBRowid),"^",12)
		}
		if BCSApptId="" continue
		s PatName="",PatSex="",PatDob=""
		if BCSPatientID'="" {
			s PatName=$P($g(^PAPER(BCSPatientID,"ALL")),"^",1)
			s PatSex=$P($g(^PAPER(BCSPatientID,"ALL")),"^",7)
			if PatSex'="" s PatSex=$p($g(^CT("SEX",PatSex)),"^",2)
			s PatDob=$P($g(^PAPER(BCSPatientID,"ALL")),"^",6)
			if PatDob'="" s PatDob=$zd(PatDob,3)
		}
		s AppDate="",AppDep="",AppDoc="",AppOPUser="",AppOPDate="",AppOPTime="",AppSeqNo=""
		if BCSApptId'="" {
			s RESRowid=$p(BCSApptId,"||",1)
			s ASRowid=$p(BCSApptId,"||",2)
			s APPTRowid=$p(BCSApptId,"||",3)
			s AppDate=$p(^RBAS(RESRowid,ASRowid),"^",1)
			if AppDate'="" s AppDate=$zd(AppDate,3)
			s AppDep=$p(^RB("RES",RESRowid),"^",1)
			if AppDep'="" s AppDep=$p(^CTLOC(AppDep),"^",2)
			s AppDoc=$p(^RB("RES",RESRowid),"^",2)
			if AppDoc'="" s AppDoc=$p(^CTPCP(AppDoc,1),"^",2)
			s AppOPUser=$p(^RBAS(RESRowid,ASRowid,"APPT",APPTRowid),"^",11)
			if AppOPUser'="" s AppOPUser=$p(^SSU("SSUSR",AppOPUser),"^",2)
			s AppOPDate=$p(^RBAS(RESRowid,ASRowid,"APPT",APPTRowid),"^",8)
			if AppOPDate'="" s AppOPDate=$zd(AppOPDate,3)
			s AppOPTime=$p(^RBAS(RESRowid,ASRowid,"APPT",APPTRowid),"^",9)
			if AppOPTime'="" s AppOPTime=$zt(AppOPTime,1)
			s AppSeqNo=$p(^RBAS(RESRowid,ASRowid,"APPT",APPTRowid),"^",5)
		}
		
		;同步到医院账单的变量字段上
		s HTBMerchantNo=BCSTransactionId
		s HTBPatientID=BCSPatientID
		s HTBTradeKey=BCSApptId
		s HTBTradeAmt=BCSPayFee
		d OutputRow
	}

 	quit
OutputRow
	set Data=$lb(HTBMerchantNo,HTBPatientID,HTBTradeKey,HTBTradeAmt,PatName,PatSex,PatDob,AppDate,AppDep,AppDoc,AppOPUser,AppOPDate,AppOPTime,AppSeqNo,BCSOperType)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables
	;set (repid)=0
	set (HTBMerchantNo,HTBPatientID,HTBTradeKey,HTBTradeAmt,PatName,PatSex,PatDob,AppDate,AppDep,AppDoc,AppOPUser,AppOPDate,AppOPTime,AppSeqNo,BCSOperType)=""
	quit
}

ClassMethod BankCheckDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BankCheckDetailExecute ]
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

Query BankCheckDetail(HospitalId As %String = "002", BankCode As %String = "CCB", StartDate As %String, EndDate As %String, ParRefID As %String) As %Query(ROWSPEC = "HTBMerchantNo,HTBPatientID,HTBTradeKey,HTBTradeAmt,PatName,PatSex,PatDob,AppDate,AppDep,AppDoc,AppOPUser,AppOPDate,AppOPTime,AppSeqNo,OperType")
{
}

}
