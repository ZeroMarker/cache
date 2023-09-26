/// 为宁波提供的报表
Class web.udhcOPFinBalance4 Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 135;

ClassMethod FootItemQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FootItemQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查询结算后的门诊项目分类
ClassMethod ReadFootItem(JSFunName As %String, StDate As %String = "", EndDate As %String = "") As %String
{
	;w ##class(web.udhcOPFinBalance4).ReadFootItem("","28/11/2005","30/11/2005")
	n (JSFunName, EndDate, StDate)
	d ..KillTMP()
	
	;生成Global
	s myrtn=##class(web.udhcOPFinBalance4).GetFinFootData(StDate, EndDate)
	
	;^TMPOPFOper($j,myHisRowID, myUserDR
	;^TMPItmCat($j,INVRepRowID,i)
	s myItemLen=+$g(^TMPTar($j))
	s myHisRowID=""
	s myNo=0
	s myItemInfo=""
	f  s myHisRowID=$o(^TMPOPFOper($j,myHisRowID)) q:(myHisRowID="")  d
	.s myNo=myNo+1
	.s myItemInfo=""
	.s myUserDR=$o(^TMPOPFOper($j,myHisRowID,""))
	.s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
	.s mySum=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Sum"))
	.;序号，操作员，RowID，
	.f i=1:1:myItemLen  d
	..s myItemInfo=myItemInfo_"^"_$fn(+$g(^TMPItmCat($j,myHisRowID,i)),"",2)
	.;b		;myItemInfo
	.;合计，记账收入(讨论一下这个怎么，为空)，收款收入
	.s myRepInfo=myItemLen_"^"_myNo_"^"_myUserName_"^"_myHisRowID_myItemInfo_"^"_mySum_"^"_"^"_mySum
	.s rtnval=JSFunName_"('"_$ZCVT($g(myRepInfo),"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.
	
	;累加金额
	s myCashSum=0
	s myCheckSum=0
	s myCredPaySum=0
	s myOtherPaySum=0
	s myTSum=0
	b		;;;
	s myHisRowID=""
	f  s myHisRowID=$o(^TMPOPFOper($j,myHisRowID)) q:(myHisRowID="")  d
	.s myUserDR=""
	.f  s myUserDR=$o(^TMPOPFOper($j,myHisRowID, myUserDR)) q:(myUserDR="")  d
	..s myCashSum=+$g(myCashSum)++$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Cash"))
	..s myCheckSum=+$g(myCheckSum)+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Check"))
	..s myCredPaySum=+$g(myCredPaySum)+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"CredPay"))
	..s myOtherPaySum=+$g(myOtherPaySum)+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"OtherPay"))
	..s myTSum=$g(myTSum)+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Sum"))
	
	s myCashSum=$fn(myCashSum,"",2)
	s myCheckSum=$fn(myCheckSum,"",2)
	s myCredPaySum=$fn(myCredPaySum,"",2)
	s myOtherPaySum=$fn(myOtherPaySum,"",2)
	s myTSum=$fn(myTSum,"",2)
	
	d ..KillTMP()
	
	q 0_"^"_myCashSum_"^"_myCheckSum_"^"_myCredPaySum_"^"_myOtherPaySum_"^"_myTSum_"^"_myItemLen
}

ClassMethod GetRegFinFootData(BDate As %String = "", EDate As %String = "") As %String
{
	i BDate["/" d
	.s BDate=$zdh(BDate,4)
	i EDate["/" d
	.s EDate=$zdh(EDate,4)
	s myDate=BDate-1
	
    
    s CKFCatRowid=$O(^DHCTarC("TOC",0,"Code","CKF",0))
    s GBFCatRowid=$O(^DHCTarC("TOC",0,"Code","GBF",0))
    s GHFCatRowid=$O(^DHCTarC("TOC",0,"Code","GHF",0))
    f k=BDate:1:EDate d
	.s myHisRowID=0 for  s myHisRowID=$o(^DHCOPRegInvReports(0,"Date",k,myHisRowID)) q:myHisRowID=""  d   
	 ..s myUserDR=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",45)
	 ..s uname=$p($g(^SSU("SSUSR",myUserDR)),"^",2)
	 ..s sda=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",42) 
	 ..s stime=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",43) 
	 ..s eda=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",21) 
	 ..s etime=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",22)
	 ..;挂号费
	 ..s gh=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",27)
	 ..;侦查费
	 ..s zc=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",28)
	 ..;病历费
	 ..s bl=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",29)
	 ..;磁卡费
	 ..s ck=$p($g(^DHCOPRegInvReports(myHisRowID)),"^",47)
	 ..s ze=gh+zc+bl+ck
	 ..s ^TMPOPFOper($j,myHisRowID, myUserDR,"Sum")=ze
	 ..s ^TMPOPFOper($j,myHisRowID, myUserDR,"TotalSum")=ze
	 ..s ^TMPOPFOper($j,myHisRowID, myUserDR,"PatPaySum")=ze
	 ..s ^TMPOPFOper($j,myHisRowID,myUserDR,"Cash")=ze
	 ..f i=1:1:$g(^TMPTar($j)) d
	 ...i CKFCatRowid=$g(^TMPTar($j,i)) d
	 ....s ^TMPItmCat($j,myHisRowID,i)=ck
	 ...i GBFCatRowid=$g(^TMPTar($j,i)) d
	 ....s ^TMPItmCat($j,myHisRowID,i)=bl
	 ...i GHFCatRowid=$g(^TMPTar($j,i)) d
	 ....s ^TMPItmCat($j,myHisRowID,i)=gh
	
	q 0
}

ClassMethod FootItemQueryExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance4","FootItemQuery",+$h-10,+$h)
	New repid, index
	Set repid=$I(^CacheTemp)
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance4","ReadUnFootINV")
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;生成Global,  然后输出，  
	;最后加上合计
	
	d ResetVariablesFI
	
	i (StDate="")!(EndDate=""){
		d OutputFI
		Quit $$$OK
	}
	
	b
	d ..KillTMP()
	
	;生成Global
	;挂号
	;d ##class(web.udhcOPFinBalanceIF).GetRegFinFootData(StDate,EndDate,"","")
	;收费
	s myrtn=##class(web.udhcOPFinBalance4).GetFinFootData(StDate,EndDate )
	
	;^TMPOPFOper($j,myHisRowID, myUserDR
	;^TMPItmCat($j,INVRepRowID,i)
	s myItemLen=+$g(^TMPTar($j))
	s myHisRowID=""
	s myNo=0
	s myItemInfo=""
	s myListSum=0
	s myPatShareSum=0
	s myJZSum=0
	s JZSum=0
	
	f  s myHisRowID=$o(^TMPOPFOper($j,myHisRowID)) q:(myHisRowID="")  d
	.s myNo=myNo+1
	.s myItemInfo=""
	.s myUserDR=$o(^TMPOPFOper($j,myHisRowID,""))
	.s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
	.s mySum=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Sum"))
	.s myYBPaySum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"YBSum"))
	.s myYBPaySum=$fn(myYBPaySum,"",2)
	.s TYBPaySum=+$g(TYBPaySum)+myYBPaySum
	.s myFeeYHSum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"TotalSum"))
	.s myFeeYHSum=+myFeeYHSum-$g(^TMPOPFOper($j,myHisRowID, myUserDR,"PatPaySum"))
	.s myFeeYHSum=$fn(myFeeYHSum,"",2)
	.s TFeeYHSum=+$g(TFeeYHSum)+myFeeYHSum
	.s PatShareSum=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Cash"))
	.s myJZSum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"JIZHANG"))
	.b	;;
	.;序号，操作员，RowID，
	.f i=1:1:myItemLen  d
	..s myItemInfo=myItemInfo_"^"_$fn(+$g(^TMPItmCat($j,myHisRowID,i)),"",2)
	.;b		;myItemInfo
	.;合计，记账收入(讨论一下这个怎么，为空)，收款收入
	.s myRepInfo=myItemLen_"^"_myNo_"^"_myUserName_"^"_myHisRowID_myItemInfo_"^"_mySum_"^"_"^"_mySum
	.s TNO=myNo
	.s UserName=myUserName
	.s RepRowID=myHisRowID
	.s TCAT1=$fn(+$g(^TMPItmCat($j,myHisRowID,1)),"",2)
	.s TCATSum1=$g(TCATSum1)+TCAT1
	.s TCAT2=$fn(+$g(^TMPItmCat($j,myHisRowID,2)),"",2)
	.s TCATSum2=$g(TCATSum2)+TCAT2
	.s TCAT3=$fn(+$g(^TMPItmCat($j,myHisRowID,3)),"",2)
	.s TCATSum3=$g(TCATSum3)+TCAT3
	.s TCAT4=$fn(+$g(^TMPItmCat($j,myHisRowID,4)),"",2)
	.s TCATSum4=$g(TCATSum4)+TCAT4
	.s TCAT5=$fn(+$g(^TMPItmCat($j,myHisRowID,5)),"",2)
	.s TCATSum5=$g(TCATSum5)+TCAT5
	.s TCAT6=$fn(+$g(^TMPItmCat($j,myHisRowID,6)),"",2)
	.s TCATSum6=$g(TCATSum6)+TCAT6
	.s TCAT7=$fn(+$g(^TMPItmCat($j,myHisRowID,7)),"",2)
	.s TCATSum7=$g(TCATSum7)+TCAT7
	.s TCAT8=$fn(+$g(^TMPItmCat($j,myHisRowID,8)),"",2)
	.s TCATSum8=$g(TCATSum8)+TCAT8
	.s TCAT9=$fn(+$g(^TMPItmCat($j,myHisRowID,9)),"",2)
	.s TCATSum9=$g(TCATSum9)+TCAT9
	.s TCAT10=$fn(+$g(^TMPItmCat($j,myHisRowID,10)),"",2)
	.s TCATSum10=$g(TCATSum10)+TCAT10
	.s TCAT11=$fn(+$g(^TMPItmCat($j,myHisRowID,11)),"",2)
	.s TCATSum11=$g(TCATSum11)+TCAT11
	.s TCAT12=$fn(+$g(^TMPItmCat($j,myHisRowID,12)),"",2)
	.s TCATSum12=$g(TCATSum12)+TCAT12
	.s TCAT13=$fn(+$g(^TMPItmCat($j,myHisRowID,13)),"",2)
	.s TCATSum13=$g(TCATSum13)+TCAT13
	.s TCAT14=$fn(+$g(^TMPItmCat($j,myHisRowID,14)),"",2)
	.s TCATSum14=$g(TCATSum14)+TCAT14
	.s TCAT15=$fn(+$g(^TMPItmCat($j,myHisRowID,15)),"",2)
	.s TCATSum15=$g(TCATSum15)+TCAT15
	.s TCAT16=$fn(+$g(^TMPItmCat($j,myHisRowID,16)),"",2)
	.s TCATSum16=$g(TCATSum16)+TCAT16
	.s TCAT17=$fn(+$g(^TMPItmCat($j,myHisRowID,17)),"",2) 
	.s TCATSum17=$g(TCATSum17)+TCAT17
	.s TCAT18=$fn(+$g(^TMPItmCat($j,myHisRowID,18)),"",2)
	.s TCATSum18=$g(TCATSum18)+TCAT18
	.s TCAT19=$fn(+$g(^TMPItmCat($j,myHisRowID,19)),"",2)
	.s TCATSum19=$g(TCATSum19)+TCAT19
	.s TCAT20=$fn(+$g(^TMPItmCat($j,myHisRowID,20)),"",2)
	.s TCATSum20=$g(TCATSum20)+TCAT20
	.s TSum=$fn(mySum,"",2) ;mySum_"^"_"^"_mySum
	.s InsSum=$fn(myJZSum,"",2)
	.s JZSum=JZSum+myJZSum
	.s PatShareSum=$fn(PatShareSum,"",2)
	.s myPatShareSum=$g(myPatShareSum)+PatShareSum
	.s myListSum=+$g(myListSum)+mySum
	.d OutputFI
	
	;合计
	i myNo'=0 d
	.s TNO="",UserName="合计",RepRowID=""
	.s TCAT1=$fn(TCATSum1,"",2)
	.s TCAT2=$fn(TCATSum2,"",2)
	.s TCAT3=$fn(TCATSum3,"",2)
	.s TCAT4=$fn(TCATSum4,"",2)
	.s TCAT5=$fn(TCATSum5,"",2)
	.s TCAT6=$fn(TCATSum6,"",2)
	.s TCAT7=$fn(TCATSum7,"",2)
	.s TCAT8=$fn(TCATSum8,"",2)
	.s TCAT9=$fn(TCATSum9,"",2)
	.s TCAT10=$fn(TCATSum10,"",2)
	.s TCAT11=$fn(TCATSum11,"",2)
	.s TCAT12=$fn(TCATSum12,"",2)
	.s TCAT13=$fn(TCATSum13,"",2)
	.s TCAT14=$fn(TCATSum14,"",2)
	.s TCAT15=$fn(TCATSum15,"",2)
	.s TCAT16=$fn(TCATSum16,"",2)
	.s TCAT17=$fn(TCATSum17,"",2)
	.s TCAT18=$fn(TCATSum18,"",2)
	.s TCAT19=$fn(TCATSum19,"",2)
	.s TCAT20=$fn(TCATSum20,"",2)
	.s TSum=$fn(myListSum,"",2) ;mySum_"^"_"^"_mySum
	.s InsSum=$fn(JZSum,"",2)
	.s PatShareSum=$fn(myPatShareSum,"",2)
	.s myFeeYHSum=$fn(TFeeYHSum,"",2)
	.s myYBPaySum=$fn(TYBPaySum,"",2)
	.d OutputFI
	b		;kill  
	
	d ..KillTMP()
	
	
	Quit $$$OK
ResetVariablesFI
	s (TNO,UserName,RepRowID,TCAT1,TCAT2,TCAT3,TCAT4,TCAT5,TCAT6,TCAT7, TCAT8, TCAT9, TCAT10,TCAT11, TCAT12, TCAT13, TCAT14, TCAT15, TCAT16, TCAT17, TCAT18, TCAT19, TCAT20)=""
	s (TSum, InsSum, PatShareSum)=""
	s (TFeeYHSum, TYBPaySum)=""
	s myUserDR=""
	quit
OutputFI
	s Data=$lb(TNO,UserName,RepRowID,TCAT1,TCAT2,TCAT3,TCAT4,TCAT5,TCAT6,TCAT7, TCAT8, TCAT9, TCAT10,TCAT11, TCAT12, TCAT13, TCAT14, TCAT15, TCAT16, TCAT17, TCAT18, TCAT19, TCAT20, TSum, InsSum, PatShareSum, myYBPaySum, myFeeYHSum, myUserDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
}

ClassMethod GetFinFootData(BDate As %String = "", EDate As %String = "") As %String
{
	;财务报表结算，只有一个开始和结算日期时间
	;w ##class(web.udhcOPFinBalance4).GetFinFootData("28/11/2005","30/11/2005")
	n (BDate, BTime, EDate, ETime)
	
	d ..KillTMP()
	;k ^TMPOPFOper($j)

	s n=1
	s itmrowid=0 f  s itmrowid=$o(^DHCTarC("TOC",itmrowid)) q:itmrowid=""  d
	.s itm=$p(^DHCTarC("TOC",itmrowid),"^",2)
	.s ^TMPTar($j)=n
	.s ^TMPTar($j,n)=itmrowid
	.s n=n+1
	
	i BDate["/" d
	.s BDate=$zdh(BDate,4)
	i EDate["/" d
	.s EDate=$zdh(EDate,4)
	s myDate=BDate-1
	
	;b		;GetFinFootData
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:((myDate="")!(myDate>EDate))  d
	.s myHisRowID=""
	.f  s myHisRowID=$o(^DHCOPInsFootI(0,"Date",myDate,myHisRowID)) q:(myHisRowID="")  d
	..s myTime=$p(^DHCOPInsFoot(myHisRowID),"^",7)
	..;q:((myDate=BDate)&&(myTime<BTime))
	..;q:((myDate=EDate)&&(myTime>ETime))
	..s myINSFDate=$p(^DHCOPInsFoot(myHisRowID),"^",13)
	..;q:(myINSFDate'="")
	..s myUserDR=$p(^DHCOPInsFoot(myHisRowID),"^",8)
	..s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
	..;退费金额
	..d ..GetFinFootRefundData(myHisRowID)
	..s ^TMPOPFOper($j,myHisRowID,myUserDR)=myUserName
	..s myCashSum=$p(^DHCOPInsFoot(myHisRowID),"^",18)
	..;s myCashSum=+myCashSum+$p(^DHCOPInsFoot(myHisRowID),"^",22)
	..;s myCashSum=+myCashSum+$p(^DHCOPInsFoot(myHisRowID),"^",24)
	..s ^TMPOPFOper($j,myHisRowID,myUserDR,"Cash")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Cash"))+myCashSum
	..s myCheckSum=$p(^DHCOPInsFoot(myHisRowID),"^",20)
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"Check")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Check"))+myCheckSum
	..s myCredPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",45)
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"CredPay")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"CredPay"))+myCredPaySum				;信用卡支付
	..s myOtherPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",28)
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"OtherPay")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"OtherPay"))+myOtherPaySum			;其他支付
	..s myYBPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",30)		;HIS_YBSum
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"YBSum")=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"YBSum"))+myYBPaySum
	..s myJZSum=+$p(^DHCOPInsFoot(myHisRowID),"^",52)		;HIS_PRDGetSum
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"JIZHANG")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"JIZHANG"))+myJZSum
	..;
	..;+myCashSum+myCheckSum+myCredPaySum+myOtherPaySum
	..;需要注意，每次增加支付类型都需要在此重新取值
	..s myCashSum=+$g(^TMPOPFOper($j,myHisRowID,myUserDR,"Cash"))
	..s myCheckSum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Check"))
	..s myCredPaySum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"CredPay"))
	..s myOtherPaySum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"OtherPay"))
	..s myYBPaySum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"YBSum"))
	..s myJZSum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"JIZHANG"))
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"Sum")=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Sum"))+myCashSum+myCheckSum+myCredPaySum+myOtherPaySum+myYBPaySum+myJZSum
	..s myTotalSum=+$p(^DHCOPInsFoot(myHisRowID),"^",1)		;HIS_Amount
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"TotalSum")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"TotalSum"))+myTotalSum
	..s myPatPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",16)		;HIS_Amount
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"PatPaySum")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"PatPaySum"))+myPatPaySum
	..d ..STATtoCAT(myHisRowID)
	..
	
	q 0
}

ClassMethod FootItemQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FootItemQueryExecute ]
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

ClassMethod GetFinFootRefundData(HISRowID As %String) As %String
{
	;w ##class(web.udhcOPFinBalance4).GetFinFootRefundData(1696)
	n (HISRowID)
	
	s mySub=0
	s mySub=$o(^DHCOPInsFoot(HISRowID,"P",mySub))
	while (mySub'="") {
		s myPMDR=$p(^DHCOPInsFoot(HISRowID,"P",mySub),"^",2)
		s myRefAmt=+$p(^DHCOPInsFoot(HISRowID,"P",mySub),"^",4)
		s myUserDR=$p(^DHCOPInsFoot(HISRowID),"^",8)
		if ((myPMDR'="")&(+myRefAmt'=0)){
			s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
			if ((myPMCode="CASH")!(myPMCode="CASHA")!(myPMCode="CASHB")!(myPMCode="CASHC")!(myPMCode="CASHD")){
				s ^TMPOPFOper($j,HISRowID,myUserDR,"Cash")=+$g(^TMPOPFOper($j,HISRowID,myUserDR,"Cash"))+myRefAmt
			}elseif(myPMCode="CHEQUES"){
				s ^TMPOPFOper($j,HISRowID, myUserDR,"Check")=+$g(^TMPOPFOper($j,HISRowID, myUserDR,"Check"))+myRefAmt
			}elseif(myPMCode="POS"){
				s ^TMPOPFOper($j,HISRowID, myUserDR,"CredPay")=+$g(^TMPOPFOper($j,HISRowID, myUserDR,"CredPay"))+myRefAmt
			}elseif(myPMCode="JIZHANG"){
				s ^TMPOPFOper($j,HISRowID, myUserDR,"JIZHANG")=+$g(^TMPOPFOper($j,HISRowID, myUserDR,"JIZHANG"))+myRefAmt
			}elseif((myPMCode="GBJJZF")!(myPMCode="TCZF")!(myPMCode="JZZF")!(myPMCode="SHJZZF")!(myPMCode="DNGZ")!(myPMCode="LNGZ")){
				s ^TMPOPFOper($j,HISRowID, myUserDR,"YBSum")=$g(^TMPOPFOper($j,HISRowID, myUserDR,"YBSum"))+myRefAmt
			}else{
				s ^TMPOPFOper($j,HISRowID, myUserDR,"OtherPay")=+$g(^TMPOPFOper($j,HISRowID, myUserDR,"OtherPay"))+myRefAmt
			}
		}
		s mySub=$o(^DHCOPInsFoot(HISRowID,"P",mySub))
	}
	
	q 0
}

ClassMethod KillTMP() As %String
{
	k ^TMPOPFOper($j)
	k ^TMPTar($j)
	k ^TMPItmCat($j)
}

ClassMethod ReadFootSum(BDate As %String = "", EDate As %String = "") As %String
{
	;w ##class(web.udhcOPFinBalance4).ReadFootSum("20/03/2007","20/03/2007")
	n (JSFunName, BDate, EDate)
	d ..KillTMP()
	
	;生成Global
	
	i BDate["/" d
	.s BDate=$zdh(BDate,4)
	i EDate["/" d
	.s EDate=$zdh(EDate,4)
	s myDate=BDate-1
	
	s myLen=0
	s itmrowid=0 f  s itmrowid=$o(^DHCTarC("TOC",itmrowid)) q:itmrowid=""  d
	.s itm=$p(^DHCTarC("TOC",itmrowid),"^",2)
	.s myLen=myLen+1
	
	;^DHCOPInsFootI(0,"Date",{HIS_Date},{HIS_Rowid})
	f  s myDate=$o(^DHCOPInsFootI(0,"Date",myDate)) q:((myDate="")!(myDate>EDate))  d
	.s myHisRowID=""
	.f  s myHisRowID=$o(^DHCOPInsFootI(0,"Date",myDate,myHisRowID)) q:(myHisRowID="")  d
	..s myTime=$p(^DHCOPInsFoot(myHisRowID),"^",7)
	..;q:((myDate=BDate)&&(myTime<BTime))
	..;q:((myDate=EDate)&&(myTime>ETime))
	..s myINSFDate=$p(^DHCOPInsFoot(myHisRowID),"^",13)
	..;q:(myINSFDate'="")
	..d ..GetFinFootRefundData(myHisRowID)
	..s myUserDR=$p(^DHCOPInsFoot(myHisRowID),"^",8)
	..s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
	..s ^TMPOPFOper($j,myHisRowID,myUserDR)=myUserName
	..s myCashSum=$p(^DHCOPInsFoot(myHisRowID),"^",18)
	..;s myCashSum=+myCashSum+$p(^DHCOPInsFoot(myHisRowID),"^",22)
	..;s myCashSum=+myCashSum+$p(^DHCOPInsFoot(myHisRowID),"^",24)
	..s ^TMPOPFOper($j,myHisRowID,myUserDR,"Cash")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Cash"))+myCashSum
	..s myCheckSum=$p(^DHCOPInsFoot(myHisRowID),"^",20)
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"Check")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Check"))+myCheckSum
	..s myCredPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",45)
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"CredPay")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"CredPay"))+myCredPaySum				;信用卡支付
	..s myOtherPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",28)
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"OtherPay")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"OtherPay"))+myOtherPaySum			;其他支付
	..s myYBPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",30)		;HIS_YBSum
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"YBSum")=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"YBSum"))+myYBPaySum
	..
	..;s ^TMPOPFOper($j,myHisRowID, myUserDR,"CredPay")=0.00				;信用卡支付
	..;s ^TMPOPFOper($j,myHisRowID, myUserDR,"OtherPay")=0.00			;其他支付
	..;s myOPYBSum=+$p(^DHCOPInsFoot(myHisRowID),"^",)
	..;需要每次重新取值
	..s myCashSum=+$g(^TMPOPFOper($j,myHisRowID,myUserDR,"Cash"))
	..s myCheckSum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Check"))
	..s myCredPaySum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"CredPay"))
	..s myOtherPaySum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"OtherPay"))
	..s myYBPaySum=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"YBSum"))
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"Sum")=$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Sum"))+myCashSum+myCheckSum+myCredPaySum+myOtherPaySum+myYBPaySum
	..s myTotalSum=+$p(^DHCOPInsFoot(myHisRowID),"^",1)		;HIS_Amount
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"TotalSum")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"TotalSum"))+myTotalSum
	..s myPatPaySum=+$p(^DHCOPInsFoot(myHisRowID),"^",16)		;HIS_Amount
	..s ^TMPOPFOper($j,myHisRowID, myUserDR,"PatPaySum")=+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"PatPaySum"))+myPatPaySum
	
	;累加金额
	s myCashSum=0
	s myCheckSum=0
	s myCredPaySum=0
	s myOtherPaySum=0
	s myTSum=0
	s myYBSum=0
	s myHospYHSum=0
	
	s myHisRowID=""
	f  s myHisRowID=$o(^TMPOPFOper($j,myHisRowID)) q:(myHisRowID="")  d
	.s myUserDR=""
	.f  s myUserDR=$o(^TMPOPFOper($j,myHisRowID, myUserDR)) q:(myUserDR="")  d
	..s myCashSum=+$g(myCashSum)++$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Cash"))
	..s myCheckSum=+$g(myCheckSum)+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Check"))
	..s myCredPaySum=+$g(myCredPaySum)+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"CredPay"))
	..s myOtherPaySum=+$g(myOtherPaySum)+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"OtherPay"))
	..s myTSum=$g(myTSum)+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"Sum"))
	..s myYBSum=myYBSum+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"YBSum"))
	..s myHospYHSum=myHospYHSum+$g(^TMPOPFOper($j,myHisRowID, myUserDR,"TotalSum"))
	..s myHospYHSum=myHospYHSum-$g(^TMPOPFOper($j,myHisRowID, myUserDR,"PatPaySum"))
	
	s myCashSum=$fn(myCashSum,"",2)
	s myCheckSum=$fn(myCheckSum,"",2)
	s myCredPaySum=$fn(myCredPaySum,"",2)
	s myOtherPaySum=$fn(myOtherPaySum,"",2)
	s myTSum=$fn(myTSum,"",2)
	s myYBSum=$fn(myYBSum,"",2)
	s myHospYHSum=$fn(myHospYHSum,"",2)
	b
	d ..KillTMP()
	
	q 0_"^"_myCashSum_"^"_myCheckSum_"^"_myCredPaySum_"^"_myOtherPaySum_"^"_myTSum_"^"_myLen_"^"_myHospYHSum_"^"_myYBSum
}

ClassMethod STATtoCAT(INVRepRowID As %String) As %String
{
	;w ##class(web.udhcOPFinBalance4).STATtoCAT("1077")
	n (INVRepRowID)
	
	s iteminfo=""
	
	s INVPRTRowid=0
	;^DHCINVPRT(0,"Report",{PRT_DHCINVPRTR_DR},{PRT_Rowid})
	f  s INVPRTRowid=$o(^DHCINVPRT(0,"Report",INVRepRowID, INVPRTRowid)) q:(INVPRTRowid="")  d
	.s conRowid=0 F  S conRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,conRowid)) Quit:conRowid=""  d
	..S Bill=$p(^DHCBCI(conRowid),"^",2)
	..q:'$D(^DHCPB(Bill))
	..S Ord="" F  S Ord=$o(^DHCPB(Bill,"O",Ord)) q:Ord=""  d
	...S Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) q:Itm=""  Do
	....S ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	....S TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	....S DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	....S PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	....S PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)	
	....S ItmOPSubCat=$p($g(^DHCTARI(ItmDr)),"^",15)
	....i $g(ItmOPSubCat)="" d
	.....s ^TMPTestItmSubCat(ItmDr)=ItmDr
	....;赵加入的测试
	....q:$g(ItmOPSubCat)=""
	....S ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	....q:$g(ItmOPCat)=""
	....s OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	....f i=1:1:$g(^TMPTar($j)) d
	.....i ItmOPCat=$g(^TMPTar($j,i)) d
	......s ^TMPItmCat($j,INVRepRowID,i)=+$g(^TMPItmCat($j,INVRepRowID,i))+TotalAmount
	.....q:ItmOPCat=$g(^TMPTar($j,i))
	
	q 0
}

ClassMethod ReadUnFootINVClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadUnFootINVExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReadUnFootINVExecute(ByRef qHandle As %Binary) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;d ##class(%ResultSet).RunQuery("web.udhcOPFinBalance4","ReadUnFootINV")
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;生成Global,  然后输出，  
	;最后加上合计
	
	d ResetVariablesUF
	
	k ^TMPOPFOper($j)
	
	;获取最大的结算日期
	;^DHCINVPRT(0,"HandDate",{PRT_HandinDate},{PRT_Rowid})
	;^DHCINVPRT(0,"User",{PRT_Usr},{PRT_Rowid})
	;找到所有用户的没有结算的最小日期
	s myCurDate=$zd(+$h,3)
	s myDate=""
	s myUserRID=""
	f  s myUserRID=$o(^DHCINVPRT(0,"User",myUserRID)) q:(myUserRID="")  d
	.s mystr=##class(web.udhcOPHandin).GetDate(myUserRID,myCurDate)
	.q:(myDate'="")&&(+myDate<+$p(mystr,"^",1))
	.;b		;;
	.s myDate=+$p(mystr,"^",1)
	
	;No,UserDR,UserName,CashSum,ChequesSum,BankSum,TSum
	
	if (myDate=""){
		d OutputUF
		Quit $$$OK
	}
	
	s myDate=myDate-1
	s EndDate=+$h
	s EndTime=$p($h,",",2)
	
	f pdate=myDate:1:EndDate  d
	.q:$d(^DHCINVPRT(0,"Date",pdate))=0
	.s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d
	..s myUserDR=$p(^DHCINVPRT(PRTrowid),"^",21)
	..;q:PRTUser'=hUser
	..s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	..q:(pdate=EndDate)&(PRTTime>EndTime)
	..s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	..q:Handin="Y"
	..q:(myUserDR="")
	..s myUserName=$p(^SSU("SSUSR",myUserDR),"^",2)
	..s ^TMPOPFOper($j,myUserDR)=myUserName
	..s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)
	..s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)
	..s PrtNO=$p(^DHCINVPRT(PRTrowid),"^",14)
	..s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	..s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	..;本收款员收取的票据
	..i ((Flag="N")||((PrtinvDr="")&&(Flag'="N")))  d
	...;s PatPaySum=PatPaySum+$g(PrtPatPay)
	...;s jybs=jybs+1
	...s ^TMPOPFOper($j,myUserDR,"INVSum")=+$g(^TMPOPFOper($j,myUserDR,"INVSum"))+PrtPatPay
	...s ^TMPOPFOper($j,myUserDR,"INVNum")=+$g(^TMPOPFOper($j,myUserDR,"INVNum"))+1
	..;本收款员作废的单据?	下面的数据都依存于原帐单?
	..i ((Flag="A")!((Flag="S")))&&(PrtinvDr'="")  d
	...s ^TMPOPFOper($j,myUserDR,"ParkSum")=+$g(^TMPOPFOper($j,myUserDR,"ParkSum"))+PrtPatPay
	...s ^TMPOPFOper($j,myUserDR,"ParkNum")=+$g(^TMPOPFOper($j,myUserDR,"ParkNum"))+1
	...;s AbPatPaySum=AbPatPaySum+$g(PrtPatPay)
	..;本收款员红冲得单据   
	..i (Flag="S")&&(PrtinvDr'="")  d
	
	;b		;;;TMP
	;费用总额
	
	s myUserID=""
	s myIdx=0
	s myTNum=0
	s myTSum=0
	s myParkTNum=0
	s myParkTSum=0
	
	f  s myUserID=$o(^TMPOPFOper($j, myUserID))  q:(myUserID="")  d
	.s myIdx=myIdx+1
	.s No=myIdx
	.s UserDR=myUserID
	.s UserName=$g(^TMPOPFOper($j, myUserID))
	.s INVNum=+$g(^TMPOPFOper($j, myUserID,"INVNum"))
	.s myTNum=myTNum+INVNum
	.s INVSum=+$g(^TMPOPFOper($j, myUserID,"INVSum"))
	.s myTSum=myTSum+INVSum
	.s ParkNum=+$g(^TMPOPFOper($j, myUserID,"ParkNum"))
	.s myParkTNum=myParkTNum+ParkNum
	.s ParkSum=+$g(^TMPOPFOper($j, myUserID,"ParkSum"))
	.s myParkTSum=myParkTSum+ParkSum
	.s TSum=+$g(^TMPOPFOper($j, myUserID,"ParkSum"))+$g(^TMPOPFOper($j, myUserID,"INVSum"))
	.d OutputUF
	
	;合计
	s No=""
	s UserDR=""
	s UserName="合计:"
	s INVNum=myTNum
	s INVSum=myTSum
	s ParkNum=myParkTNum
	s ParkSum=myParkTSum
	s TSum=+INVSum+ParkSum
	d OutputUF
	
	k ^TMPOPFOper($j)
	
	Quit $$$OK
ResetVariablesUF
	s (No,UserDR,UserName,INVNum,INVSum,ParkNum,ParkSum,TSum)=""
	quit
OutputUF
	s Data=$lb(No,UserDR,UserName,INVNum,INVSum,ParkNum,ParkSum,TSum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
}

ClassMethod ReadUnFootINVFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadUnFootINVExecute ]
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

Query FootItemQuery(StDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "TNO:%String,UserName:%String,RepRowID:%String,TCAT1:%String,TCAT2:%String,TCAT3:%String,TCAT4:%String,TCAT5:%String,TCAT6:%String,TCAT7:%String, TCAT8:%String, TCAT9:%String, TCAT10:%String,TCAT11:%String, TCAT12:%String, TCAT13:%String, TCAT14:%String, TCAT15:%String, TCAT16:%String, TCAT17:%String, TCAT18:%String, TCAT19:%String, TCAT20:%String, TSum:%String, InsSum:%String, PatShareSum:%String, YBPaySum:%String, FeeYHSum:%String, UserRowID:%String")
{
}

/// 查询未结算的信息，形成RS    No,,,,,,,
Query ReadUnFootINV() As %Query(ROWSPEC = "No:%String,UserDR:%String,UserName:%String,INVNum:%String,INVSum:%String,ParkNum:%String,ParkSum:%String,TSum:%String")
{
}

}
