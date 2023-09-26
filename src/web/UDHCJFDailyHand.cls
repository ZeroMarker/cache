Class web.UDHCJFDailyHand Extends BILL.COM.Abstract
{

/// Creator: wangjian
/// CreatDate: 2015-02-07
/// Description: 住院收费未结算汇总，查询所有的未结算的数据
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFDailyHand","FindNotHandin","2022-04-08","","2")
Query FindNotHandin(EndDate As %String, UserId As %String, HospId As %String, LangId As %String = "") As websys.Query(ROWSPEC = "UserName:%String:收费员,DepNormalSum:%Float:收押金总额,DepNormalNum:%Integer:收押金张数,DepAbortSum:%Float:作废押金金额,DepAbortNum:%Integer:作废押金张数,DepStrikeSum:%Float:红冲押金金额,DepStrikeNum:%Integer:红冲押金张数,InvNormalSum:%Float:发票金额,InvNormalNum:%Integer:发票张数,InvAbortSum:%Float:作废发票金额,InvAbortNum:%Integer:作废发票张数,InvStrikeSum:%Float:红冲发票金额,InvStrikeNum:%Integer:红冲发票张数") [ SqlProc ]
{
}

ClassMethod FindNotHandinExecute(ByRef qHandle As %Binary, EndDate As %String, UserId As %String, HospId As %String, LangId As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
	set ind=1
	set UserId=$p(UserId,$c(0),1)
	set ^TMP("FindNotHandin")=$lb(EndDate, UserId, HospId, LangId)
	
	 if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
    set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    
    kill NotHandinAry
    
    //住院押金
	set UserDR=0
	while($o(^DHCSFPRINTDETAIL(0,"JKFLAG","N",UserDR))) {
		set UserDR=$o(^DHCSFPRINTDETAIL(0,"JKFLAG","N",UserDR))
		continue:((UserId'="")&&(UserId'=UserDR))
		set PrtRowID=0
		while($o(^DHCSFPRINTDETAIL(0,"JKFLAG","N",UserDR,PrtRowID))) {
			set PrtRowID=$o(^DHCSFPRINTDETAIL(0,"JKFLAG","N",UserDR,PrtRowID))
			set DepData=$g(^DHCSFPRINTDETAIL(PrtRowID))
			set HospDR=$p(DepData,"^",44)
			continue:(HospDR'=HospId)
			set PrtDate=$p(DepData,"^",2)
			continue:(PrtDate>EndDate)
			set PrtStatus=$p(DepData,"^",8)
			set PayAmt=$p(DepData,"^",6)
			set PayMode=$p(DepData,"^",9)
			set refRcptDR=$p(DepData,"^",43)
			if (" 1 4 "[(" "_PrtStatus_" ")) {
				set $li(NotHandinAry(UserDR),1)=$lg($g(NotHandinAry(UserDR)),1)+PayAmt
				set $li(NotHandinAry(UserDR),2)=$lg($g(NotHandinAry(UserDR)),2)+1
			}
			if ((+PrtStatus=2)&&(+PayAmt<0)) {
				set $li(NotHandinAry(UserDR),3)=$lg($g(NotHandinAry(UserDR)),3)+PayAmt
				set $li(NotHandinAry(UserDR),4)=$lg($g(NotHandinAry(UserDR)),4)+1
			}
		    if ((+PrtStatus=3)&&(+PayAmt<0)) {
				set $li(NotHandinAry(UserDR),5)=$lg($g(NotHandinAry(UserDR)),5)+PayAmt
				set $li(NotHandinAry(UserDR),6)=$lg($g(NotHandinAry(UserDR)),6)+1
		    }
		}
	}
   	
   	//发票信息
    set UserDR=0
    while($o(^DHCINVPRTZY(0,"HandIn","N",UserDR))) {
	    set UserDR=$o(^DHCINVPRTZY(0,"HandIn","N",UserDR))
	 	continue:((UserId'="")&&(UserId'=UserDR))
		set InvRowID=0
		while($o(^DHCINVPRTZY(0,"HandIn","N",UserDR,InvRowID))) {
			set InvRowID=$o(^DHCINVPRTZY(0,"HandIn","N",UserDR,InvRowID))
			set InvData=$g(^DHCINVPRTZY(InvRowID))
			set HospDR=$p(InvData,"^",35)
			continue:(HospDR'=HospId)
			set PrtDate=$p(InvData,"^",2)
			continue:(PrtDate>EndDate)
			set PrtStatus=$p(InvData,"^",8)
		    set PayAmt=$p(InvData,"^",6)
		    set PBRowID=$p(InvData,"^",5)
		    set AdmReason=$p(InvData,"^",9)
		    set Deposit=$p(InvData,"^",22)
		    set InitInvDR=$p(InvData,"^",13)
		    if (" N I "[(" "_PrtStatus_" ")) {
				set $li(NotHandinAry(UserDR),7)=$lg($g(NotHandinAry(UserDR)),7)+PayAmt
				set $li(NotHandinAry(UserDR),8)=$lg($g(NotHandinAry(UserDR)),8)+1
		    }
			if ((PrtStatus="A")&&(+InitInvDR'=0)) {
				set $li(NotHandinAry(UserDR),9)=$lg($g(NotHandinAry(UserDR)),9)+PayAmt
				set $li(NotHandinAry(UserDR),10)=$lg($g(NotHandinAry(UserDR)),10)+1
			}
		    if (PrtStatus="S") {
				set $li(NotHandinAry(UserDR),11)=$lg($g(NotHandinAry(UserDR)),11)+PayAmt
				set $li(NotHandinAry(UserDR),12)=$lg($g(NotHandinAry(UserDR)),12)+1
		    }
		}
	}
    
    //集中打印发票 ShangXuehao
    set UserDR=0
    while($o(^BILL.IP.SummaryPrtInvI("HandinUserDR","N",UserDR))) {
	    set UserDR=$o(^BILL.IP.SummaryPrtInvI("HandinUserDR","N",UserDR))
		continue:((UserId'="")&&(UserId'=UserDR))
	    set SpiRowId=0
	    while($o(^BILL.IP.SummaryPrtInvI("HandinUserDR","N",UserDR,SpiRowId))) {
		    set SpiRowId=$o(^BILL.IP.SummaryPrtInvI("HandinUserDR","N",UserDR,SpiRowId))
			set SummInvData=$g(^BILL.IP.SummaryPrtInvD(SpiRowId))
		    set HospDR=$lg(SummInvData,14)
		    continue:(HospDR'=HospId)
		    set InvDate=$lg(SummInvData,7)
		    continue:(InvDate>EndDate)
		    set InvFlag=$lg(SummInvData,6)
			set InitInvDR=$lg(SummInvData,9)
		    set PrtRowID=##class(BILL.IP.BL.SummaryPrtInv).GetPrtRowIdStrBySPI(SpiRowId)
		    set PayAmt=$p(^DHCINVPRTZY(PrtRowID),"^",6)
		    set PayAmt=$s((+InitInvDR'=0):-PayAmt,1:PayAmt)   //作废/红冲记录，金额显示为负数
		    if (" N I "[(" "_InvFlag_" ")) {
				set $li(NotHandinAry(UserDR),7)=$lg($g(NotHandinAry(UserDR)),7)+PayAmt
				set $li(NotHandinAry(UserDR),8)=$lg($g(NotHandinAry(UserDR)),8)+1
		    }
		    if ((InvFlag="A")&&(+InitInvDR'=0)) {
				set $li(NotHandinAry(UserDR),9)=$lg($g(NotHandinAry(UserDR)),9)+PayAmt
				set $li(NotHandinAry(UserDR),10)=$lg($g(NotHandinAry(UserDR)),10)+1
		    }
		    if (InvFlag="S") {
				set $li(NotHandinAry(UserDR),11)=$lg($g(NotHandinAry(UserDR)),11)+PayAmt
				set $li(NotHandinAry(UserDR),12)=$lg($g(NotHandinAry(UserDR)),12)+1
		    }
		}
	}
    
    set UserDR=0
    while($o(NotHandinAry(UserDR))) {
	    set UserDR=$o(NotHandinAry(UserDR))
	    set UserName=$p(^SSU("SSUSR",UserDR),"^",2)
	    set UserName=##class(User.SSUser).GetTranByDesc("SSUSRName", UserName, LangId)
	    set OutData=$g(NotHandinAry(UserDR))
		set DepNormalSum=+$lg(OutData,1)
		set DepNormalSum=$fn(DepNormalSum,"",2)
		set DepNormalNum=+$lg(OutData,2)
		set DepAbortSum=+$lg(OutData,3)
		set DepAbortSum=$fn(DepAbortSum,"",2)
		set DepAbortNum=+$lg(OutData,4)
		set DepStrikeSum=+$lg(OutData,5)
		set DepStrikeSum=$fn(DepStrikeSum,"",2)
		set DepStrikeNum=+$lg(OutData,6)
		set InvNormalSum=+$lg(OutData,7)
		set InvNormalSum=$fn(InvNormalSum,"",2)
		set InvNormalNum=+$lg(OutData,8)
		set InvAbortSum=+$lg(OutData,9)
		set InvAbortSum=$fn(InvAbortSum,"",2)
		set InvAbortNum=+$lg(OutData,10)
		set InvStrikeSum=+$lg(OutData,11)
		set InvStrikeSum=$fn(InvStrikeSum,"",2)
		set InvStrikeNum=+$lg(OutData,12)
		do OutputNotHandin
	}
    
    quit $$$OK
    
OutputNotHandin
	set Data=$lb(UserName,DepNormalSum,DepNormalNum,DepAbortSum,DepAbortNum,DepStrikeSum,DepStrikeNum,InvNormalSum,InvNormalNum,InvAbortSum,InvAbortNum,InvStrikeSum,InvStrikeNum) 
	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

}
