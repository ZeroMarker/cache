Import SQLUser

/// 体检收费结帐查询
/// 
Class web.DHCPE.FeeReport.RcptPayDetail Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 127;

ClassMethod RcptPayDetailStatistic(UserID As %String = "", BeginDate As %String = "", EndDate As %String = "", PayMode As %String = "")
{
	k ^DHCPEQRDTMP
	s ^DHCPEQRDTMP("QueryRcptPayDetail")=""""_UserID_""", """_BeginDate_""", """_EndDate_""", """_PayMode_""""

	// CT_PayMode.{ CTPM_Desc }
	s PayModeDesc=$P(^CT("CTPM",PayMode),"^",2)
	s ^DHCPEQRDTMP("QueryRcptPayDetail", "PayMode", PayMode)=PayModeDesc
	
	// DHC_PE_USERREPORT.{ RP_DATE }
	f fdate=BeginDate:1:EndDate  d
	.
	.
	.// DHC_PE_USERREPORT.{ RP_ROWID }
	.s RPRowid=0
	.f  s RPRowid=$o(^DHCPEUSERREPORT(0,"DATE",fdate,RPRowid))  q:RPRowid=""  d
	..//w !,"fdate:"_fdate_" RPRowid"_RPRowid
	..
	..// 收费员信息 DHC_PE_USERREPORT.{ RP_USER_DR }
	..s User=$p(^DHCPEUSERREPORT(RPRowid),"^",1)
	..q:((UserID'="")&&(User'=UserID))
	..i User'="" d
	...s UserName=$p($g(^SSU("SSUSR", User)),"^",2)
	...s UserCode=$p($g(^SSU("SSUSR", User)),"^",1)
	..e  d
	...s UserName=""
	...s UserCode=""
	..
	..s NormalAmount=0	// 收费金额
	..s NormalNum=0		// 收费单据
	..s RefundAmount=0	// 退费金额
	..s RefundNum=0		// 退费单据
	..//s InceptUser=""	// 签字(空)
	..s PayAmount=0		// 总计
	..s Flag=0
	..// DHC_PE_UserReportPayMode.{ RPM_ChildSub }
	..s RPMRowId=0
	..f  s RPMRowId=$o(^DHCPEUSERREPORT(0,"USERPAYMODE", RPRowid, PayMode, RPMRowId))  q:RPMRowId=""  d
	...s Flag=1
	...s CurData=$G(^DHCPEUSERREPORT(RPRowid, "PAYMODE",RPMRowId))
	...
	...// DHC_PE_UserReportPayMode.{ RPM_PayAmount }
	...s PayAmount=PayAmount+$P(CurData,"^",2)
	...
	...// DHC_PE_UserReportPayMode.{ RPM_NormalAmount }
	...s NormalAmount=NormalAmount+$P(CurData,"^",3)
	...// DHC_PE_UserReportPayMode.{ RPM_NormalNum }
	...s NormalNum=NormalNum+$P(CurData,"^",4)
	...
	...// DHC_PE_UserReportPayMode.{ RPM_RefundAmount }
	...s RefundAmount=RefundAmount+$P(CurData,"^",5)
	...// DHC_PE_UserReportPayMode.{ RPM_RefundNum }
	...s RefundNum=RefundNum+$P(CurData,"^",6)
	...
	..Q:(0=Flag)
	..s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", User)=UserCode_"^"_UserName
	..s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "PayAmount")=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "PayAmount"))+PayAmount
	..s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "NormalAmount")=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "NormalAmount"))+NormalAmount
	..s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "NormalNum")=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "NormalNum"))+NormalNum
	..s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "RefundAmount")=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "RefundAmount"))+RefundAmount
	..s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "RefundNum")=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "RefundNum"))+RefundNum
 	
 	s User=0
	f  s User=$O(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User)) Q:(""=User)  d
	.
	.s PayAmount=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "PayAmount"))
	.s NormalAmount=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "NormalAmount"))
	.s NormalNum=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "NormalNum"))
	.s RefundAmount=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "RefundAmount"))
	.s RefundNum=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "RefundNum"))

	.s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "PayAmount")=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "PayAmount"))+PayAmount
	.s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "PayAmount")=$J(PayAmount,3,2)
	.
	.s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "NormalAmount")=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "NormalAmount"))+NormalAmount
	.s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "NormalAmount")=$J(NormalAmount,3,2)
	.
	.s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "NormalNum")=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "NormalNum"))+NormalNum
	.s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "NormalNum")=$J(NormalNum,3,2)
	.
	.s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "RefundAmount")=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "RefundAmount"))+RefundAmount
	.s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "RefundAmount")=$J(RefundAmount,3,2)
	.
	.s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "RefundNum")=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "RefundNum"))+RefundNum
	.s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "RefundNum")=$J(RefundNum,3,2)
	.
	.

	s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total")="总计^"
	s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "PayAmount")=$J(+$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "PayAmount")), 3, 2)
	s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "NormalAmount")=$J(+$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "NormalAmount")), 3, 2)
	s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "NormalNum")=$J(+$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "NormalNum")), 3, 2)
	s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "RefundAmount")=$J(+$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "RefundAmount")), 3, 2)
	s ^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "RefundNum")=$J(+$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", "Total", "RefundNum")), 3, 2)
	
	Q 1
}

/*
/// 统计收费员结帐信息
/// 参考 web.DHCPE.DHCPEUSERREPORT->UserReportStatExecute
/// d ##class(%ResultSet).RunQuery("web.DHCPE.FeeReport.RcptPayDetail","QueryRcptPayDetail", "", "60904", "60925", "")
Query QueryRcptPayDetail(UserID As %String = "", BeginDate As %String = "", EndDate As %String = "", PayMode As %String = "") As %Query(ROWSPEC = "RPD_User_ID:%String, RPD_User_Code:%String, RPD_User_Name:%String, RPD_NormalAmount:%String, RPD_NormalNum:%String, RPD_RefundAmount:%String, RPD_RefundNum:%String, RPT_PayAmount:%String, RPT_InceptUser_ID:%String, RPT_InceptUser_Name:%String, RPT_PayMode_ID:%String, RPT_PayMode_Desc:%String")
{
}

ClassMethod QueryRcptPayDetailExecute(ByRef qHandle As %Binary, UserID As %String = "", BeginDate As %String = "", EndDate As %String = "", PayMode As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	i (""=BeginDate)||(""=EndDate)||(""=PayMode) {
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK		
	}
 	
 	// 统计
 	d ..RcptPayDetailStatistic(UserID, BeginDate, EndDate, PayMode)
 	Set ind=1
 	
 	s PayModeDesc=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "PayMode", PayMode))
 	s User=0
	f  s User=$O(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User)) Q:(""=User)  d
	.s UserCode=$P($G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User)),"^",1)
	.s UserName=$P($G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User)),"^",2)
	.s PayAmount=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "PayAmount"))
	.s NormalAmount=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "NormalAmount"))
	.s NormalNum=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "NormalNum"))
	.s RefundAmount=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "RefundAmount"))
	.s RefundNum=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "RefundNum"))
	.s InceptUserID=""
	.s InceptUserName=""
	.set Data=$lb(User, UserCode, UserName, NormalAmount, NormalNum, RefundAmount, RefundNum, PayAmount, InceptUserID, InceptUserName, PayMode, PayModeDesc)
 	.
 	.Do OutputRcptPayDetail
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRcptPayDetail
	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryRcptPayDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRcptPayDetailExecute ]
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

ClassMethod QueryRcptPayDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRcptPayDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}
*/
/// 统计收费员结帐信息
/// 参考 web.DHCPE.DHCPEUSERREPORT->UserReportStatExecute
/// d ##class(%ResultSet).RunQuery("web.DHCPE.FeeReport.RcptPayDetail","QueryRcptPayDetail", "", "60904", "60925", "")
Query QueryRcptPayDetail(UserID As %String = "", BeginDate As %String = "", EndDate As %String = "", PayMode As %String = "") As %Query(ROWSPEC = "UserName:%String, TotalAmount:%String, Amount1:%String, Amount2:%String, Amount3:%String, Amount4:%String, Amount5:%String, Amount6:%String, Amount7:%String, Amount8:%String, Amount9:%String, Amount10:%String,Amount11:%String, Amount12:%String, Amount13:%String, Amount14:%String, Amount15:%String, Amount16:%String,Amount17:%String, Amount18:%String, Amount19:%String, Amount20:%String, Amount21:%String, Amount22:%String, Amount23:%String")
{
}

ClassMethod QueryRcptPayDetailExecute(ByRef qHandle As %Binary, UserID As %String = "", BeginDate As %String = "", EndDate As %String = "", PayMode As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	i PayMode="" w "支付方式不能为空"
	
	i (""=PayMode) {
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK		
	}
 	s:""=BeginDate BeginDate=62000
 	s:""=EndDate EndDate= +$H
 	s footIDStr=##Class(web.DHCPE.DHCPEUSERREPORT).GetFootIDStrByDate($ZD(BeginDate,3),$ZD(EndDate,3))
 	i (""=footIDStr) {
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK		
	}
 	s job=$J
 	//分类信息组成的串DHC_TarOC
 	s catInfostr="4^5^6^3^8^14^16^2^17^1^9^19^99999999"
	s m=$L(catInfostr,"^")
	k ^TempDHCPE("UserTotal",$J)
 	s i=$L(footIDStr,"^")
 	f j=1:1:i  d
 	.s footID=$P(footIDStr,"^",j)
 	.s userID=$P(^DHCPEUSERREPORT(footID),"^",1)
 	.//i userID'="" s userID=$P(^SSU("SSUSR",userID),"^",2)
 	.f n=1:1:m d
 	..s tarECID=$p(catInfostr,"^",n)
 	..q:tarECID="AccFee"
	..s ^TempDHCPE("UserTotal",$J,"CatID",n)=tarECID
 	..s NormalAmt=+$G(^DHCPEUserReportEx("CatFee",footID,tarECID,PayMode,"Normal"))
 	..s RefundAmt=+$G(^DHCPEUserReportEx("CatFee",footID,tarECID,PayMode,"Refund"))
 	..s OtherAmt=+$G(^DHCPEUserReportEx("CatFee",footID,tarECID,PayMode,"Other"))
 	..s amt=NormalAmt-RefundAmt
 	..s oldAmt=+$P($G(^TempDHCPE("UserTotal",$J,"UserCat",userID,footID,"JK")),"^",n) //收费员这个分类的金额
 	..//交款信息的串
 	..s $P(^TempDHCPE("UserTotal",$J,"UserCat",userID,footID,"JK"),"^",n)=amt+oldAmt
 	..//其它退费汇总
 	..s oldOtherAmt=+$P($G(^TempDHCPE("UserTotal",$J,"Other")),"^",n) //收费员这个分类的金额
 	..s $P(^TempDHCPE("UserTotal",$J,"Other"),"^",n)=OtherAmt+oldOtherAmt
 	Set ind=1
 	//输出标题
 	s sort=""
 	f  s sort=$O(^TempDHCPE("UserTotal",$J,"CatID",sort)) q:sort=""  d
 	.s tarECID=$G(^TempDHCPE("UserTotal",$J,"CatID",sort))
 	.i tarECID="99999999" d
 	..s tarECDesc="舍入费"
 	.e  d
 	..s tarECDesc=$p($G(^DHCTarC("TOC",tarECID)),"^",2)
 	.s onePLIST(sort)=tarECDesc
 	s Data=$lb("收费员", "总金额", "社保自付金",$G(onePLIST(1)), $G(onePLIST(2)), $G(onePLIST(3)), $G(onePLIST(4)), $G(onePLIST(5)), $G(onePLIST(6)), $G(onePLIST(7)), $G(onePLIST(8)), $G(onePLIST(9)), $G(onePLIST(10)),$G(onePLIST(11)),$G(onePLIST(12)),$G(onePLIST(13)),$G(onePLIST(14)),$G(onePLIST(15)), $G(onePLIST(16)), $G(onePLIST(17)),$G(onePLIST(18)),$G(onePLIST(19)),$G(onePLIST(20)),$G(onePLIST(21)),$G(onePLIST(22)))
 	d OutputRcptPayDetail
 	//输出收费员分类金额
 	k TotalPLIST
 	s userID=""
 	f  s userID=$O(^TempDHCPE("UserTotal",$J,"UserCat",userID)) q:userID=""  d
 	.s userName=$P(^SSU("SSUSR",userID),"^",2)
 	.s userInfo=$G(^TempDHCPE("UserTotal",$J,"UserCat",userID))
 	.s footID=0
 	.f  s footID=$O(^TempDHCPE("UserTotal",$J,"UserCat",userID,footID)) q:footID=""  d
 	.k onePLIST
 	.s sort=""
 	.f  s sort=$O(^TempDHCPE("UserTotal",$J,"CatID",sort)) q:sort=""  d
 	..s amt=$P($G(^TempDHCPE("UserTotal",$J,"UserCat",userID,footID,"JK")),"^",sort)
 	..s TotalPLIST(sort)=+$G(TotalPLIST(sort))+amt
 	..s onePLIST(sort)=amt
 	..s onePLIST(0)=+$G(onePLIST(0))+amt
 	..s TotalPLIST(0)=+$G(TotalPLIST(0))+amt
 	.s Data=$lb(userName, $G(onePLIST(0)),"", $G(onePLIST(1)), $G(onePLIST(2)), $G(onePLIST(3)), $G(onePLIST(4)), $G(onePLIST(5)), $G(onePLIST(6)), $G(onePLIST(7)), $G(onePLIST(8)), $G(onePLIST(9)), $G(onePLIST(10)),$G(onePLIST(11)),$G(onePLIST(12)),$G(onePLIST(13)),$G(onePLIST(14)),$G(onePLIST(15)), $G(onePLIST(16)), $G(onePLIST(17)),$G(onePLIST(18)),$G(onePLIST(19)),$G(onePLIST(20)),$G(onePLIST(21)),$G(onePLIST(22)))
 	.d OutputRcptPayDetail
 	//输出交款合计
 	s Data=$lb("交款合计", $G(TotalPLIST(0)),"", $G(TotalPLIST(1)), $G(TotalPLIST(2)), $G(TotalPLIST(3)), $G(TotalPLIST(4)), $G(TotalPLIST(5)), $G(TotalPLIST(6)), $G(TotalPLIST(7)), $G(TotalPLIST(8)), $G(TotalPLIST(9)), $G(TotalPLIST(10)),$G(TotalPLIST(11)),$G(TotalPLIST(12)),$G(TotalPLIST(13)),$G(TotalPLIST(14)),$G(TotalPLIST(15)), $G(TotalPLIST(16)),$G(TotalPLIST(17)),$G(TotalPLIST(18)),$G(TotalPLIST(19)),$G(TotalPLIST(20)),$G(TotalPLIST(21)),$G(TotalPLIST(22)))
 	d OutputRcptPayDetail
 	//输出其它合计
 	s sort=""
 	k onePLIST
 	f  s sort=$O(^TempDHCPE("UserTotal",$J,"CatID",sort)) q:sort=""  d
 	.s amt=$P($G(^TempDHCPE("UserTotal",$J,"Other")),"^",sort)
 	.s TotalPLIST(sort)=+$G(TotalPLIST(sort))-amt
 	.s onePLIST(sort)=amt
 	.s onePLIST(0)=+$G(onePLIST(0))+amt
 	.s TotalPLIST(0)=+$G(TotalPLIST(0))-amt
 	s Data=$lb("其它退费", $G(onePLIST(0)),"", $G(onePLIST(1)), $G(onePLIST(2)), $G(onePLIST(3)), $G(onePLIST(4)), $G(onePLIST(5)), $G(onePLIST(6)), $G(onePLIST(7)), $G(onePLIST(8)), $G(onePLIST(9)), $G(onePLIST(10)),$G(onePLIST(11)),$G(onePLIST(12)),$G(onePLIST(13)),$G(onePLIST(14)),$G(onePLIST(15)), $G(onePLIST(16)), $G(onePLIST(17)),$G(onePLIST(18)),$G(onePLIST(19)),$G(onePLIST(20)),$G(onePLIST(21)),$G(onePLIST(22)))
 	d OutputRcptPayDetail
 	//输出总计
 	s Data=$lb("总计", $G(TotalPLIST(0)),"", $G(TotalPLIST(1)), $G(TotalPLIST(2)), $G(TotalPLIST(3)), $G(TotalPLIST(4)), $G(TotalPLIST(5)), $G(TotalPLIST(6)), $G(TotalPLIST(7)), $G(TotalPLIST(8)), $G(TotalPLIST(9)), $G(TotalPLIST(10)),$G(TotalPLIST(11)),$G(TotalPLIST(12)),$G(TotalPLIST(13)),$G(TotalPLIST(14)),$G(TotalPLIST(15)), $G(TotalPLIST(16)),$G(TotalPLIST(17)),$G(TotalPLIST(18)),$G(TotalPLIST(19)),$G(TotalPLIST(20)),$G(TotalPLIST(21)),$G(TotalPLIST(22)))
 	d OutputRcptPayDetail
 	
 	k ^TempDHCPE("UserTotal",$J)
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRcptPayDetail
	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryRcptPayDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRcptPayDetailExecute ]
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

ClassMethod QueryRcptPayDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRcptPayDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCPE.FeeReport.RcptPayDetail).GetRcptPayDetail("","","^1/10/2007^22/10/2007^3")
ClassMethod GetRcptPayDetail(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{
	
 	s UserID=$P(Instring,"^",1)
 	s BeginDate=$P(Instring,"^",2)
 	s EndDate=$P(Instring,"^",3)
 	s PayMode=$P(Instring,"^",4)
 	Q:((""=BeginDate)||(""=EndDate)||(""=PayMode)) "Err 01"
 	
 	d ..RcptPayDetailStatistic(UserID, $ZDH(BeginDate,4), $ZDH(EndDate,4), PayMode)
	// 标题栏
	s PayModeDesc=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "PayMode", PayMode))
	s Datas="工号"_"^"_"收费员"_"^"_"收"_PayModeDesc_"^"_"收单据数"_"^"_"退"_PayModeDesc_"^"_"退单据数"_"^"_"小计"_"^"_"签字"
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Datas,"O","JS")_"');"
	.&javascript<#(retval)#>
	
 	s Datas=""
 	s User=0
	f  s User=$O(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User)) Q:(""=User)  d
	.s UserCode=$P($G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User)),"^",1)
	.s UserName=$P($G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User)),"^",2)
	.s PayAmount=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "PayAmount"))
	.s NormalAmount=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "NormalAmount"))
	.s NormalNum=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "NormalNum"))
	.s RefundAmount=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "RefundAmount"))
	.s RefundNum=$G(^DHCPEQRDTMP("QueryRcptPayDetail", "User", User, "RefundNum"))
	.s InceptUserID=""
	.s InceptUserName=""
	.s Data=UserCode_"^"_UserName_"^"_NormalAmount_"^"_NormalNum_"^"_RefundAmount_"^"_RefundNum_"^"_PayAmount_"^"_""
	.s Datas=Datas_Data_";"
	.i ""'=itmjs d
	..s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	..&javascript<#(retval)#>
	.//w Datas

	Q Datas
}

Query SearchUSER(Desc As %Library.String = "") As %SQLQuery(ROWSPEC = "SSUSR_Initials:%String,SSUSR_Name:%String, SSUSR_RowId:%String")
{
	select SSUSR_Initials, SSUSR_Name, SSUSR_RowId
	from SS_USER
	where SSUSR_Name %STARTSWITH :Desc
}

Query QueryPayModeDetail(GBID As %String = "", BeginDate As %String = "", EndDate As %String = "", PayModeDR As %String = "") As %Query(ROWSPEC = "TGDesc:%String, TDate:%String,TPayMode1:%String, TPayMode2:%String, TPayMode3:%String, TPayMode4:%String, TPayMode5:%String, TPayMode6:%String, TPayMode7:%String, TPayMode8:%String, TPayMode9:%String, TPayMode10:%String, TPayMode11:%String")
{
}

ClassMethod QueryPayModeDetailExecute(ByRef qHandle As %Binary, GBID As %String = "", BeginDate As %String = "", EndDate As %String = "", PayModeDR As %String = "") As %Status
{

	k ^TempDHCPE($J,"PayModeDetail")
	Set repid=$I(^CacheTemp)
	i (""=BeginDate)&&(""=EndDate)&&(""=PayModeDR)&&(GBID="") {
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK		
	}
	d SetTotalDefault
	Set ind=200
	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
 	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
 	
 	i BeginDate="" s BeginDate=0
 	i EndDate="" s EndDate=+$H
 	i GBID'="" d
 	.s TGDesc=$P($G(^DHCPEGBI(GBID)),"^",2)
 	.s GADM=0
 	.f  s GADM=$o(^DHCPEGADM(0,"GBI",GBID,GADM)) q:GADM=""  d
 	..s PAADM=$P(^DHCPEGADM(GADM),"^",3)
 	..s InvID=0
 	..f  s InvID=$O(^DHCPEINVPRT(0,"ADM",PAADM,InvID)) q:InvID=""  d
 	...d GetOneInfoDetail
 	e  d
 	.s Date=BeginDate-1
 	.f  s Date=$O(^DHCPEINVPRT(0,"DATE",Date)) q:(Date="")||(Date>EndDate)  d
 	..s InvID=0
 	..f  s InvID=$O(^DHCPEINVPRT(0,"DATE",Date,InvID)) q:(InvID="")  d
 	...s PAADM=$p(^DHCPEINVPRT(InvID),"^",2)
 	...s GADM=$O(^DHCPEGADM(0,"DelegateADM",PAADM,0))
 	...q:GADM=""
 	...s GBI=$P(^DHCPEGADM(GADM),"^",1)
 	...s TGDesc=$P(^DHCPEGBI(GBI),"^",2)
 	...d GetOneInfoDetail
 	//输出标题
 	s ind=1
 	d SetDefault
 	s TGDesc="名称"
 	s TDate="日期"
 	s i=+$G(^TempDHCPE($J,"PayModeDetail"))
 	f j=1:1:i  d
 	.s PayModeID=$G(^TempDHCPE($J,"PayModeDetail","ID",j))
 	.
 	.s TPayMode(j)=$p($g(^CT("CTPM",PayModeID)),"^",2)
 	d OutputPayModeDetail
 	//输出合计
 	d SetDefault
 	s TGDesc="合计"
 	s TDate=""
 	m TPayMode=TPayModeTotal
 	d OutputPayModeDetail
 	
 	
 	k ^TempDHCPE($J,"PayModeDetail")
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
GetOneInfoDetail
	d SetDefault
	s InvDate=$p(^DHCPEINVPRT(InvID),"^",11)
	s TDate=##class(websys.Conversions).DateLogicalToHtml(InvDate)
	s PayModeInfo=##class(web.DHCPE.Cashier).GetPayModeInfo(InvID)
	s i=$L(PayModeInfo,"&")
	f j=1:1:i  d
	.s OnePayModeInfo=$P(PayModeInfo,"&",j)
	.s PayModeID=$P(OnePayModeInfo,"^",1)
	.q:(PayModeDR'="")&&(PayModeDR'=PayModeID)
	.s PayAmount=$P(OnePayModeInfo,"^",3)
	.i '$D(^TempDHCPE($J,"PayModeDetail",PayModeID)) d
	..s ^TempDHCPE($J,"PayModeDetail")=+$G(^TempDHCPE($J,"PayModeDetail"))+1
	..s ^TempDHCPE($J,"PayModeDetail",PayModeID)=+$G(^TempDHCPE($J,"PayModeDetail"))
	..s ^TempDHCPE($J,"PayModeDetail","ID",+$G(^TempDHCPE($J,"PayModeDetail")))=PayModeID
	.s TPayMode(+$G(^TempDHCPE($J,"PayModeDetail",PayModeID)))=PayAmount
	.s TPayModeTotal(+$G(^TempDHCPE($J,"PayModeDetail",PayModeID)))=+TPayModeTotal(+$G(^TempDHCPE($J,"PayModeDetail",PayModeID)))+PayAmount
	.d OutputPayModeDetail
	q
OutputPayModeDetail
 	set Data=$lb(TGDesc,TDate,TPayMode(1), TPayMode(2), TPayMode(3), TPayMode(4), TPayMode(5), TPayMode(6), TPayMode(7), TPayMode(8), TPayMode(9), TPayMode(10), TPayMode(11))
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
SetDefault
	s (TDate,TPayMode(1), TPayMode(2), TPayMode(3), TPayMode(4), TPayMode(5), TPayMode(6), TPayMode(7), TPayMode(8), TPayMode(9), TPayMode(10), TPayMode(11))=""
	q
SetTotalDefault
	s (TPayModeTotal(1), TPayModeTotal(2), TPayModeTotal(3), TPayModeTotal(4), TPayModeTotal(5), TPayModeTotal(6), TPayModeTotal(7), TPayModeTotal(8), TPayModeTotal(9), TPayModeTotal(10), TPayModeTotal(11))=""
	q
}

ClassMethod QueryPayModeDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPayModeDetailExecute ]
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

ClassMethod QueryPayModeDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPayModeDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OutPayModeToHtml(ContrlWidth As %String = "155", DefaultValue As %String = "")
{
	;s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='PayModeDR' id='PayModeDR' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''> </option>",!
	s id=0
	f  s id=$O(^CT("CTPM",id)) q:id=""  d
	.s selected=""
	.s:DefaultValue=id selected="selected"
	.w "<option value='"_id_"' "_selected_">"_$P($G(^CT("CTPM",id)),"^",2)_"</option>",! 
	w "</select>",!
	Quit $$$OK
}

// d ##class(web.DHCPE.FeeReport.RcptPayDetail).DHCPEFeePort(vStDate, vStTime, vEndDate, vEndTime, vPaymde, vGuser, vUserId, vjob)

ClassMethod DHCPEFeePort(vStDate, vStTime, vEndDate, vEndTime, vPaymde, vGuser, vUserId, vjob)
{
	//^TempDHCPEFeePort(vjob,vGuser,vPaymde,vUserId,Date,FootID)
	n (StDate,StTime,EndDate,EndTime,Paymde,Guser,UserId,job)
	k ^TempDHCPEFeePort(vjob,vGuser,vPaymde,vUserId)
	s footIDStr=##Class(web.DHCPE.DHCPEUSERREPORT).GetFootIDStrByDate($ZD(vStDate,3),$ZD(vEndDate,3))
 	q:(""=footIDStr) ""
 	s i=$L(footIDStr,"^")
 	f j=1:1:i  d
 	.s footID=$P(footIDStr,"^",j)
 	.s userID=$P(^DHCPEUSERREPORT(footID),"^",1)
 	.q:(vUserId'="")&&(vUserId'=userID)
 	.s Date=$P(^DHCPEUSERREPORT(footID),"^",2)
 	.s tarECID=""
 	.f  s tarECID=$O(^DHCPEUserReportEx("CatFee",footID,tarECID)) q:tarECID=""  d
 	..q:tarECID="AccFee"
 	..s NormalAmt=+$G(^DHCPEUserReportEx("CatFee",footID,tarECID,vPaymde,"Normal"))
 	..s ^TempDHCPEFeePort(vjob,vGuser,vPaymde,vUserId,Date,footID,tarECID,"Normal")=NormalAmt
 	..s NormalAmt=+$G(^DHCPEUserReportEx("CatFee",footID,tarECID,vPaymde,"Refund"))
 	..s ^TempDHCPEFeePort(vjob,vGuser,vPaymde,vUserId,Date,footID,tarECID,"Refund")=NormalAmt
 	..s NormalAmt=+$G(^DHCPEUserReportEx("CatFee",footID,tarECID,vPaymde,"Other"))
 	..s ^TempDHCPEFeePort(vjob,vGuser,vPaymde,vUserId,Date,footID,tarECID,"Other")=NormalAmt
 	i vPaymde="4" d //4为银行卡支付方式、5为银行卡支付方式
 	.d ..DHCPEFeePort(vStDate, vStTime, vEndDate, vEndTime, "5", vGuser, vUserId, vjob)
}

/// Creator: xy
/// CreatDate: 2019-04-28
/// Description: 取团体支付方式汇总明细列头
/// Input: 
/// Output: 
/// Return: 
/// Debug: w ##class(web.DHCPE.FeeReport.RcptPayDetail).GetGPaymodeDetailColumns()
ClassMethod GetGPaymodeDetailColumns(LocID As %String = "") As %String
{
	kill columnAry
	set i=0
	set columnAry($i(i))="TGDesc^团体名称"
	set columnAry($i(i))="TDate^日期"

	
	set paymIndex=0
	set paymId=0
	for  set paymId=$o(^CT("CTPM",paymId))  quit:(paymId="")  do
	.;Q:$g(^DHCPESetting("DHCPE","CashierMode",paymId))'="Y"
	 .Q:$g(^DHCPESetting("DHCPE","CashierMode",LocID,paymId))'="Y"
	.set paymInfo=$g(^CT("CTPM",paymId))
	.quit:(paymInfo="")
	.set colField="TPayMode"_$i(paymIndex)
	.set colTitle=$p(paymInfo,"^",2)
	.set columnAry($i(i))=colField_"^"_colTitle
	
	set jsonStr=""
	set index=0
	for  set index=$o(columnAry(index)) quit:(index="")  do
	.set field=$p(columnAry(index),"^",1)
	.set title=$p(columnAry(index),"^",2)
	.set align="left"
	.if (field["TPayMode") do
	..set align="right"
	.set myJson="{""field"":"""_field_""",""title"":"""_title_""",""align"":"""_align_""",""width"":"_130_"}"
	.if (jsonStr="") do
	..set jsonStr=myJson
	.else  do
	..set jsonStr=jsonStr_","_myJson

	set jsonStr="["_jsonStr_"]"
	
	quit jsonStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.FeeReport.RcptPayDetail","QueryPayModeDetailNew", "", "2019-04-09", "", "")
Query QueryPayModeDetailNew(GBID As %String = "", BeginDate As %String = "", EndDate As %String = "", PayModeDR As %String = "", LocID As %String = "") As %Query(ROWSPEC = "TGDesc:%String,TDate:%String,TPayMode1:%Float,TPayMode2:%Float,TPayMode3:%Float,TPayMode4:%Float,TPayMode5:%Float,TPayMode6:%Float,TPayMode7:%Float,TPayMode8:%Float,TPayMode9:%Float,TPayMode10:%Float,TPayMode11:%Float")
{
}

ClassMethod QueryPayModeDetailNewExecute(ByRef qHandle As %Binary, GBID As %String = "", BeginDate As %String = "", EndDate As %String = "", PayModeDR As %String = "", LocID As %String = "") As %Status
{

	
	Set repid=$I(^CacheTemp)
	i (""=BeginDate)&&(""=EndDate)&&(""=PayModeDR)&&(GBID="") {
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK		
	}
	set job=$j
	kill ^||TMPPAYMODE("TOTAL",job)    //存放支付方式汇总金额
	
	Set ind=1
	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
 	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
 	
 	i BeginDate="" s BeginDate=0
 	i EndDate="" s EndDate=+$H
 	

 	s TGDesc=""
 	i GBID'="" d
 	.s TGDesc=$P($G(^DHCPEGBI(GBID)),"^",2)
 	.s GADM=0
 	.f  s GADM=$o(^DHCPEGADM(0,"GBI",GBID,GADM)) q:GADM=""  d
 	..s PAADM=$P(^DHCPEGADM(GADM),"^",3)
 	..s InvID=0
 	..f  s InvID=$O(^DHCPEINVPRT(0,"ADM",PAADM,InvID)) q:InvID=""  d
 	...d GetOneInfoDetailNew
 	e  d
 	.s Date=BeginDate-1
 	.f  s Date=$O(^DHCPEINVPRT(0,"DATE",Date)) q:(Date="")||(Date>EndDate)  d
 	..s InvID=0
 	..f  s InvID=$O(^DHCPEINVPRT(0,"DATE",Date,InvID)) q:(InvID="")  d
 	...s PAADM=$p(^DHCPEINVPRT(InvID),"^",2)
 	...s GADM=$O(^DHCPEGADM(0,"DelegateADM",PAADM,0))
 	...q:GADM=""
 	...s GBI=$P(^DHCPEGADM(GADM),"^",1)
 	...s TGDesc=""
 	...s TGDesc=$P(^DHCPEGBI(GBI),"^",2)
 	...d GetOneInfoDetailNew
 	
 	//输出合计
 	s TGDesc="合计"
 	s TDate=""
 	d BuildPaymAmtAry("TOTAL")
 	d OutputPayModeDetailNew
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 
    
GetOneInfoDetailNew
	
	kill ^||TMPPAYMODE("SINGLE",job)      
	s InvDate=$p($g(^DHCPEINVPRT(InvID)),"^",11)
	s invNo=$p($g(^DHCPEINVPRT(InvID)),"^",1)
	q:invNo["DHCPEYJS" 
	s paadm=$p($g(^DHCPEINVPRT(InvID)),"^",2)
	s IsFeeLocFlag=$g(^DHCPESetting("DHCPE","IsFeeLocFlag",LocID))
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",paadm,LocID,IsFeeLocFlag)
  	q:LocFlag=1  
	s TDate=""
	s TDate=##class(websys.Conversions).DateLogicalToHtml(InvDate)
	s PayModeInfo=##class(web.DHCPE.Cashier).GetPayModeInfo(InvID)
	s i=$L(PayModeInfo,"&")
	f j=1:1:i  d
	.s OnePayModeInfo=$P(PayModeInfo,"&",j)
	.s PayModeID=$P(OnePayModeInfo,"^",1)
	.q:(PayModeDR'="")&&(PayModeDR'=PayModeID)
	.s PayAmount=$P(OnePayModeInfo,"^",3)
	.i PayModeID'="" d
    ..s ^||TMPPAYMODE("SINGLE",job,PayModeID)=+$g(^||TMPPAYMODE("SINGLE",job,PayModeID))+PayAmount
	..s ^||TMPPAYMODE("TOTAL",job,PayModeID)=$g(^||TMPPAYMODE("TOTAL",job,PayModeID))+PayAmount
	
	d BuildPaymAmtAry("SINGLE")
	
	s flag=0
	f k=1:1:paymIndex d
	.q:flag=1
	.i paym(k)'="0.00" d
	..s flag=1
	i flag=1 d OutputPayModeDetailNew
	q
	
BuildPaymAmtAry(note)
   
	kill paym
	set paymIndex=0
	set paymDR="0"
	for  set paymDR=$o(^CT("CTPM",paymDR))  quit:(paymDR="")  do
	.q:$g(^CT("CTPM",paymDR))=""
	.;Q:$g(^DHCPESetting("DHCPE","CashierMode",paymDR))'="Y"
	.Q:$g(^DHCPESetting("DHCPE","CashierMode",LocID,paymDR))'="Y"
	.set paymAmt=+$g(^||TMPPAYMODE(note,job,paymDR))
	.s paymIndex=paymIndex+1
	.set paym(paymIndex)=$j(paymAmt,3,2)
	kill ^||TMPPAYMODE(note,job)
	quit 	
    
OutputPayModeDetailNew
 	set Data=$lb(TGDesc,TDate,paym(1),paym(2),paym(3),paym(4),paym(5),paym(6),paym(7),paym(8),paym(9),paym(10),paym(11))
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryPayModeDetailNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPayModeDetailNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryPayModeDetailNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPayModeDetailNewExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
