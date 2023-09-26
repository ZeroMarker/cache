Class web.DHCOPBillUnHand Extends BILL.COM.Abstract
{

/// do ##class(%ResultSet).RunQuery("web.DHCOPBillUnHand","FindUnHandDetail","",2)
Query FindUnHandDetail(UserDr As %String, HospId As %String, LangId As %String = "") As websys.Query(ROWSPEC = "TUserName:%String:收费员,TyfAmtSum:%Float:药费收入,TylAmtSum:%Float:医疗收入,TAllSum:%Float:合计,TNorNum:%Integer:收据张数,TAborNum:%Integer:作废张数,TStrNum:%Integer:红冲张数,Tjob:%Integer:进程号,TUserRowid:%String:操作员ID") [ SqlProc ]
{
}

ClassMethod FindUnHandDetailExecute(ByRef qHandle As %Binary, UserDr As %String, HospId As %String, LangId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
   	
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}

	kill userAry
   	set rset=##class(%ResultSet).%New("web.DHCBillOtherLB:QryInvUser")
	do rset.Execute("O", HospId, LangId)
	while (rset.Next()) {
		set userDR=rset.Get("id")
		continue:((UserDr'="")&&(UserDr'=userDR))
		set userAry(userDR)=""
	}
	
	set job=$j
	kill ^TMP($this,job)

	set userId=0
	while($o(^DHCINVPRT(0,"HandIn","N",userId))) {
		set userId=$o(^DHCINVPRT(0,"HandIn","N",userId))
		continue:('$d(userAry(userId)))
		set userName=$p($g(^SSU("SSUSR",userId)),"^",2)
		set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, LangId)
		set (yfSum, ylSum, allSum)=0
		set (norNum, abortNum, strikeNum)=0
		set prtRowId=0
		while($o(^DHCINVPRT(0,"HandIn","N",userId,prtRowId))) {
			set prtRowId=$o(^DHCINVPRT(0,"HandIn","N",userId,prtRowId))
			set prtData=$g(^DHCINVPRT(prtRowId))
			set hospDR=$p(prtData,"^",39)
			continue:(hospDR'=HospId)
			set prtFlag=$p(prtData,"^",8)
			continue:(prtFlag="TP")
			set prtAcount=$p(prtData,"^",1)
			set prtAcount=$fn(prtAcount,"",2)
			set prtDiscAmt=$p(prtData,"^",7)
			set prtDiscAmt=$fn(prtDiscAmt,"",2)
			set prtPatShare=$p(prtData,"^",16)
			set prtPatShare=$fn(prtPatShare,"",2)
			set allSum=$i(allSum, prtPatShare)
			set prtPayOrShare=$p(prtData,"^",18)
			set prtPayOrShare=$fn(prtPayOrShare,"",2)
			set prtDate=$p(prtData,"^",5)
			set prtInv=$p(prtData,"^",14)
		    set initInvDR=$p(prtData,"^",13)
			set prtFlagDesc=$case(prtFlag,"N":"正常","A":"作废","S":$s((+initInvDR'=0):"红冲",1:"正常"))
			set prtFlagDesc=##class(websys.Translation).Get("", prtFlagDesc, LangId)
			if (initInvDR'="")  {     //负记录
				set abortNum=$i(abortNum,(prtFlag="A"))    //作废数
				set abortNum=$i(abortNum,(prtFlag="S"))    //红冲数
			}else {
				set norNum=$i(norNum)
			}
			set rtnValue=..GetFeeDetails(prtRowId)
			set yfAmt=$p(rtnValue,"^",1)
			set ylAmt=$p(rtnValue,"^",2)
			set yfSum=$i(yfSum,yfAmt)
			set ylSum=$i(ylSum,ylAmt)
			set papmi=$p($g(prtData),"^",15)
			set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",2)
			set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
			//add by wangjian 2015-01-15 增加病人密级和级别
		 	set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(papmi, "")
			set EncryptLevel=$p(PatEncryptLevel,"^",1)
			set PatLevel=$p(PatEncryptLevel,"^",2)
			//end
			set prtDate=##class(websys.Conversions).DateLogicalToHtml(prtDate)
			set ^TMP($this,job,userId,$i(^TMP($this,job,userId)))=$lb(regNo,patName,prtAcount,prtDiscAmt,prtPayOrShare,prtPatShare,prtFlagDesc,prtDate,prtInv,EncryptLevel,PatLevel)
		}
		do OutputUnHandDetail
	}

	quit $$$OK
OutputUnHandDetail
	set Data=$lb(userName,$fn(yfSum,"",2),$fn(ylSum,"",2),$fn(allSum,"",2),norNum,abortNum,strikeNum,job,userId)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod GetFeeDetails(prtRowId As %String) As %String
{
	set (yfAmt, ylAmt)=0
	set billConInv=0
	while($o(^DHCBCI(0,"INV",prtRowId,billConInv))) {
		set billConInv=$o(^DHCBCI(0,"INV",prtRowId,billConInv))
		set pb=$p($g(^DHCBCI(billConInv)),"^",2)
		set pbo=0
		while($o(^DHCPB(pb,"O",pbo))) {
			set pbo=$o(^DHCPB(pb,"O",pbo))
			set pboData=$g(^DHCPB(pb,"O",pbo))
			continue:(pboData="")
			set arcim=$p(pboData,"^",3)
			continue:(arcim="")
			//set amt=+$p(pboData,"^",8)
			set amt=+$p(pboData,"^",11)
			set orderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(arcim, 0)
			if (orderType="R") set yfAmt=$i(yfAmt, amt)
			else  set ylAmt=$i(ylAmt, amt)
		}
	}

	quit yfAmt_"^"_ylAmt
}

/// do ##class(%ResultSet).RunQuery("web.DHCOPBillUnHand","FindUnHandDetailByUser","5","4880")
Query FindUnHandDetailByUser(UserRowid As %String, Job As %String) As websys.Query(ROWSPEC = "TPatNo:%String:登记号,TPatName:%String:患者姓名,TPrtAcout:%Float:费用总额,TPrtDiscAmt:%Float:折扣金额,TPrtPayOrShare:%Float:记账金额,TPrtPatShare:%Float:自付金额,TPrtFlag:%String:收费状态,TPrtDate:%String:收费日期,TPrtInv:%String:票据号,TEncryptLevel:%String:密级,TPatLevel:%String:级别")
{
}

ClassMethod FindUnHandDetailByUserExecute(ByRef qHandle As %Binary, UserRowid As %String, Job As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    set ^TMP("FindUnHandDetailByUser")=$lb(UserRowid, Job)
    if ((UserRowid="")||(Job="")) quit $$$OK
    
	set UserNum=0
	while($o(^TMP($this,Job,UserRowid,UserNum))) {
		set UserNum=$o(^TMP($this,Job,UserRowid,UserNum))
		set DetailStr=$g(^TMP($this,Job,UserRowid,UserNum))
		set PatNo=$lg(DetailStr,1)
		set PatName=$lg(DetailStr,2)
		set PrtAcout=$lg(DetailStr,3)
		set PrtDiscAmt=$lg(DetailStr,4)
		set PrtPayOrShare=$lg(DetailStr,5)
		set PrtPatShare=$lg(DetailStr,6)
		set PrtFlag=$lg(DetailStr,7)
		set PrtDate=$lg(DetailStr,8)
		set PrtInv=$lg(DetailStr,9)
		set EncryptLevel=$lg(DetailStr,10)
		set PatLevel=$lg(DetailStr,11)
		do OutputDetailByUser
	}
	
	quit $$$OK
	
OutputDetailByUser
	set Data=$lb(PatNo,PatName,PrtAcout,PrtDiscAmt,PrtPayOrShare,PrtPatShare,PrtFlag,PrtDate,PrtInv,EncryptLevel,PatLevel)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

}
