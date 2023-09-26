Class web.UDHCJFOPCardInvRepts Extends DHCDoc.Util.RegisteredObject
{

ClassMethod CardInvReptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardInvReptExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFOPCardInvRepts","CardInvRept","62948","62948","1","639","0")
ClassMethod CardInvReptExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, OwnFlag As %String, UserID As %String, HandinFlag As %String) As %Status
{
   
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	//i (StartDate="")||(EndDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	i (StartDate="")&&(EndDate="") s StartDate=..%SysDate(),EndDate=..%SysDate()
	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
	k ^TMP("CardInvRept",$j)
	s (TUserID,TUserCode,TUserName,TDate,TIssueCardNum,TIssueCardAmt,TReclaimCardNum,TReclaimCardAmt,TCardNum,TCardAmt,TTime)=""
	s (TIssueCardNumSum,TIssueCardAmtSum,TReclaimCardNumSum,TReclaimCardAmtSum,TCardNumSum,TCardAmtSum)=0
	s myDate=StartDate-1
	f  s myDate=$o(^DHCCARDINVPRTi(0,"Date",myDate)) q:(myDate="")||(myDate>EndDate)  d
	.s myID=""
	.f  s myID=$o(^DHCCARDINVPRTi(0,"Date",myDate,myID)) q:myID=""  d
	..s myVal=$g(^DHCCARDINVPRT(myID))
	..q:myVal=""
	..s myUserID=$p(myVal,"^",6),myFlag=$p(myVal,"^",2),myAmt=+$p(myVal,"^",3),ReptDr=$p(myVal,"^",9)
	..s myPapmi=$p(myVal,"^",1),myDate=$p(myVal,"^",4),myTime=$p(myVal,"^",5)
	..q:(OwnFlag="1")&&(myUserID'=UserID)
	..q:(HandinFlag="1")&&(ReptDr="")
	..Q:myUserID=""   //CIP_PUser_Dr  为空，如果是数据问题，可将此句去掉，修改数据  郭荣勇
	..s myNowdate=..%SysDate()
	..;此处2013.05.15修改并无变化 by add 郭荣勇
	..q:myAmt=0
	..i myAmt>0 d
	...s ^TMP("CardInvRept",$j,myUserID,myNowdate,"INum")=+$g(^TMP("CardInvRept",$j,myUserID,myNowdate,"INum"))+1
	...s ^TMP("CardInvRept",$j,myUserID,myNowdate,"IAmt")=+$g(^TMP("CardInvRept",$j,myUserID,myNowdate,"IAmt"))+myAmt
	..e  d
	...s ^TMP("CardInvRept",$j,myUserID,myNowdate,"RNum")=+$g(^TMP("CardInvRept",$j,myUserID,myNowdate,"RNum"))+1
	...s ^TMP("CardInvRept",$j,myUserID,myNowdate,"RAmt")=+$g(^TMP("CardInvRept",$j,myUserID,myNowdate,"RAmt"))+myAmt
	
	s (TExChangeNum,TReNewNum,TReNewAmt)=""
	s (TExChangeNumSum,TReNewNumSum,TReNewAmtSum)=0
	
	s myDate=StartDate-1
	f  s myDate=$o(^DHCCARDi("CF",0,"CSDate",myDate)) q:(myDate="")||(myDate>EndDate)  d
	.s myCardID=""
	.f  s myCardID=$o(^DHCCARDi("CF",0,"CSDate",myDate,myCardID)) q:(myCardID="")  d
	..s mySub=""
	..f  s mySub=$o(^DHCCARDi("CF",0,"CSDate",myDate,myCardID,"CSC",mySub)) q:(mySub="")  d
	...s myVal=$g(^DHCCARD("CF",myCardID,"CSC",mySub))
	...q:myVal=""
	...s myCurStatus=$p(myVal,"^",3),myUserID=$p(myVal,"^",4)
	...q:(OwnFlag="1")&&(myUserID'=UserID)
	...s myNowdate=..%SysDate()
	...if myCurStatus="N"  d
	....s CFCardINVPRTDR=$P($G(^DHCCARD("CF",myCardID)),"^",17)
	....s CFCardINVPRTDR="1" //卡费用日报表只统计及卡发票表数据
	....;考虑是否发票中统计过
	....if CFCardINVPRTDR="" d
	.....s ^TMP("CardInvRept",$j,myUserID,myNowdate,"INum")=+$g(^TMP("CardInvRept",$j,myUserID,myNowdate,"INum"))+1
	...i myCurStatus="ETD" d
	....s ^TMP("CardInvRept",$j,myUserID,myNowdate,"ETD")=+$g(^TMP("CardInvRept",$j,myUserID,myNowdate,"ETD"))+1
	...i myCurStatus="RN" d
	....s ^TMP("CardInvRept",$j,myUserID,myNowdate,"RN")=+$g(^TMP("CardInvRept",$j,myUserID,myNowdate,"RN"))+1
	....s myCardInvID=$p($g(^DHCCARD("CF",myCardID)),"^",17)
	....q:myCardInvID=""
	....s myCardAmt=+$p($g(^DHCCARDINVPRT(myCardInvID)),"^",3)
	....s ^TMP("CardInvRept",$j,myUserID,myNowdate,"RNAmt")=+$g(^TMP("CardInvRept",$j,myUserID,myNowdate,"RNAmt"))+myCardAmt
	
	
	s myUserID=""
	f  s myUserID=$o(^TMP("CardInvRept",$j,myUserID)) q:myUserID=""  d
	.s myDate=""
	.f  s myDate=$o(^TMP("CardInvRept",$j,myUserID,myDate)) q:myDate=""  d
	..s TUserID=myUserID
	..s TUserCode=$p($g(^SSU("SSUSR",myUserID)),"^",1),TUserName=$p($g(^SSU("SSUSR",myUserID)),"^",2)
	..s TDate=..%ZD(myDate) //$ZD(myDate,4)
	..s TDate=""
	..s TIssueCardNum=+$g(^TMP("CardInvRept",$j,myUserID,myDate,"INum"))
	..s TIssueCardAmt=+$g(^TMP("CardInvRept",$j,myUserID,myDate,"IAmt"))
	..s TReclaimCardNum=+$g(^TMP("CardInvRept",$j,myUserID,myDate,"RNum"))
	..s TReclaimCardAmt=+$g(^TMP("CardInvRept",$j,myUserID,myDate,"RAmt"))
	..s TExChangeNum=+$g(^TMP("CardInvRept",$j,myUserID,myNowdate,"ETD"))
	..s TReNewNum=+$g(^TMP("CardInvRept",$j,myUserID,myNowdate,"RN"))
	..s TReNewAmt=+$g(^TMP("CardInvRept",$j,myUserID,myNowdate,"RNAmt"))
	..s TCardNum=TIssueCardNum-TReclaimCardNum
	..s TCardAmt=TIssueCardAmt+TReclaimCardAmt
	..s TIssueCardNumSum=TIssueCardNumSum+TIssueCardNum
	..s TIssueCardAmtSum=TIssueCardAmtSum+TIssueCardAmt
	..s TReclaimCardNumSum=TReclaimCardNumSum+TReclaimCardNum
	..s TReclaimCardAmtSum=TReclaimCardAmtSum+TReclaimCardAmt
	..s TCardNumSum=TCardNumSum+TCardNum
	..s TCardAmtSum=TCardAmtSum+TCardAmt
	..s TExChangeNumSum=TExChangeNumSum+TExChangeNum
	..s TReNewNumSum=TReNewNumSum+TReNewNum
	..s TReNewAmtSum=TReNewAmtSum+TReNewAmt
	..Do OutputRow
	s (TUserID,TUserCode,TUserName,TDate,TIssueCardNum,TIssueCardAmt,TReclaimCardNum,TReclaimCardAmt,TCardNum,TCardAmt,TTime)=""
	s (TExChangeNum,TReNewNum,TReNewAmt)=""
	i $d(^TMP("CardInvRept",$j))  d
	.s TUserName="合计"
	.s TIssueCardNum=TIssueCardNumSum
	.s TIssueCardAmt=TIssueCardAmtSum
	.s TReclaimCardNum=TReclaimCardNumSum
	.s TReclaimCardAmt=TReclaimCardAmtSum
	.s TCardNum=TCardNumSum
	.s TCardAmt=TCardAmtSum
	.s TExChangeNum=TExChangeNumSum
	.s TReNewNum=TReNewNumSum
	.s TReNewAmt=TReNewAmtSum
	.i OwnFlag="1" s TUserID=UserID
	.Do OutputRow
	.
	
	k ^TMP("CardInvRept",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(TUserID,TUserCode,TUserName,TDate,TIssueCardNum,$j(TIssueCardAmt,"",4),TReclaimCardNum,$j(TReclaimCardAmt,"",4),TCardNum,$j(TCardAmt,"",4),TTime,TExChangeNum,TReNewNum,$j(TReNewAmt,"",4))
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CardInvReptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardInvReptExecute ]
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

Query CardInvRept(StartDate As %String, EndDate As %String, OwnFlag As %String, UserID As %String, HandinFlag As %String) As %Query(ROWSPEC = "TUserID,TUserCode:%String,TUserName:%String,TDate,TIssueCardNum,TIssueCardAmt,TReclaimCardNum,TReclaimCardAmt,TCardNum,TCardAmt,TTime,TExChangeNum,TReNewNum,TReNewAmt")
{
}

ClassMethod CardInvDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardInvDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CardInvDetailsExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, OwnFlag As %String, UserID As %String, HandinFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	//i (StartDate="")||(EndDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	i (StartDate="")&&(EndDate="") s StartDate=..%SysDate(),EndDate=..%SysDate()
	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
	k ^TMP("CardInvDetails",$j)
	k ^TMP("CardInvDetailsOTHer",$j)
	;发票统计
	s (TUserCode,TUserName,TInvFlag,TCardAmt,TCardNo,TDate,TTime,TPatName,TID)=""
	
	s myDate=StartDate-1
	f  s myDate=$o(^DHCCARDINVPRTi(0,"Date",myDate)) q:(myDate="")||(myDate>EndDate)  d
	.s myID=""
	.f  s myID=$o(^DHCCARDINVPRTi(0,"Date",myDate,myID)) q:myID=""  d
	..s myVal=$g(^DHCCARDINVPRT(myID))
	..q:myVal=""
	..s myUserID=$p(myVal,"^",6),myFlag=$p(myVal,"^",2),myAmt=+$p(myVal,"^",3),ReptDr=$p(myVal,"^",9)
	..s myPapmi=$p(myVal,"^",1),myDate=$p(myVal,"^",4),myTime=$p(myVal,"^",5)
	..q:(OwnFlag="1")&&(myUserID'=UserID)
	..q:(HandinFlag="1")&&(ReptDr="")
	..q:myUserID=""
	..s ^TMP("CardInvDetails",$j,myUserID,myDate,myID)=myAmt_"^"_myPapmi_"^"_myTime
	..
	
	;无发票统计
	/*s myDate=StartDate-1
	f  s myDate=$o(^DHCCARDi("CF",0,"CSDate",myDate)) q:(myDate="")||(myDate>EndDate)  d
	.s myCardID=""
	.f  s myCardID=$o(^DHCCARDi("CF",0,"CSDate",myDate,myCardID)) q:(myCardID="")  d
	..s mySub=""
	..f  s mySub=$o(^DHCCARDi("CF",0,"CSDate",myDate,myCardID,"CSC",mySub)) q:(mySub="")  d
	...s myVal=$g(^DHCCARD("CF",myCardID,"CSC",mySub))
	...q:myVal=""
	...s myCurStatus=$p(myVal,"^",3),myUserID=$p(myVal,"^",4)
	...s myTime=$p(myVal,"^",2)
	...q:(OwnFlag="1")&&(myUserID'=UserID)
	...s myNowdate=..%SysDate()
	...s CFCardINVPRTDR=$P($G(^DHCCARD("CF",myCardID)),"^",17)
	...s myPapmi=$P($G(^DHCCARD("CF",myCardID)),"^",4)
	...Q:CFCardINVPRTDR'=""
	...if myCurStatus="N"  d
	....;发卡
	....s Sub=($O(^TMP("CardInvDetailsOTHer",$j,myUserID,myDate,"IN",""),-1)+1)
	....s ^TMP("CardInvDetailsOTHer",$j,myUserID,myDate,"IN",Sub)=0_"^"_myPapmi_"^"_myTime_"^"_myCardID
	...i myCurStatus="ETD" d
	....;换卡
	....s Sub=($O(^TMP("CardInvDetailsOTHer",$j,myUserID,myDate,"ETD",""),-1)+1)
	....s ^TMP("CardInvDetailsOTHer",$j,myUserID,myDate,"ETD",Sub)=0_"^"_myPapmi_"^"_myTime_"^"_myCardID
	...i myCurStatus="RN" d
	....;补卡
	....s Sub=($O(^TMP("CardInvDetailsOTHer",$j,myUserID,myDate,"RN",""),-1)+1)
	....s ^TMP("CardInvDetailsOTHer",$j,myUserID,myDate,"RN",Sub)=0_"^"_myPapmi_"^"_myTime_"^"_myCardID
	...i myCurStatus="R"
	....;退卡
	....s Sub=($O(^TMP("CardInvDetailsOTHer",$j,myUserID,myDate,"R",""),-1)+1)
	....s ^TMP("CardInvDetailsOTHer",$j,myUserID,myDate,"R",Sub)=0_"^"_myPapmi_"^"_myTime_"^"_myCardID
	...else  d
	....;其他
	....;s Sub=($O(^TMP("CardInvDetailsOTHer",$j,myUserID,myDate,"OT",""),-1)+1)
	....;s ^TMP("CardInvDetailsOTHer",$j,myUserID,myDate,"OT",Sub)=0_"^"_myPapmi_"^"_myTime_"^"_myCardID
	*/
	//发票
	s myUserID=""
	f  s myUserID=$o(^TMP("CardInvDetails",$j,myUserID)) q:myUserID=""  d
	.s myDate=""
	.f  s myDate=$o(^TMP("CardInvDetails",$j,myUserID,myDate)) q:myDate=""  d
	..s myID=""
	..f  s myID=$o(^TMP("CardInvDetails",$j,myUserID,myDate,myID)) q:myID=""  d
	...s TUserCode=$p($g(^SSU("SSUSR",myUserID)),"^",1),TUserName=$p($g(^SSU("SSUSR",myUserID)),"^",2)
	...s TDate=..%ZD(myDate) //$ZD(myDate,4)
	...s myVal=^TMP("CardInvDetails",$j,myUserID,myDate,myID)
	...s TCardAmt=$p(myVal,"^",1),Papmi=$p(myVal,"^",2),TTime=$p(myVal,"^",3)
	...s TTime=..%ZT(TTime)
	...s myCardID=""
	...q:TCardAmt=0
	...i TCardAmt>0  d
	....s TInvFlag="发卡"
	....s myCardID=$o(^DHCCARDi("CF",0,"INVPRT",myID,""))
	....
	...e  d
	....s TInvFlag="退卡"
	....s myPayID=$p($g(^DHCCARDINVPRT(myID)),"^",8)
	....i myPayID'="" s myCardID=$o(^DHCCARDi("CF",0,"INVPRT",myPayID,""))
	...s TCardNo=""
	...i myCardID'="" s TCardNo=$p($g(^DHCCARD("CF",myCardID)),"^",2)
	...s TPatName=$p($g(^PAPER(Papmi,"ALL")),"^",1)
	...s TID=myID
	...Do OutputRow1
	
	//无发票
	/*s myUserID=""
	f  s myUserID=$o(^TMP("CardInvDetailsOTHer",$j,myUserID)) q:myUserID=""  d
	.s myDate=""
	.f  s myDate=$o(^TMP("CardInvDetailsOTHer",$j,myUserID,myDate)) q:myDate=""  d
	..s myIDType=""
	..f  s myIDType=$o(^TMP("CardInvDetailsOTHer",$j,myUserID,myDate,myIDType)) q:myIDType=""  d
	...if myIDType="IN" s TInvFlag="发卡"
	...e  i myIDType="ETD" s TInvFlag="换卡"
	...e  i myIDType="RN" s TInvFlag="补卡"
	...e  i myIDType="R" s TInvFlag="退卡"
	...e  s TInvFlag="其他"
	...s SubID=""
	...f  s SubID=$o(^TMP("CardInvDetailsOTHer",$j,myUserID,myDate,myIDType,SubID)) q:SubID=""  d
	....s TUserCode=$p($g(^SSU("SSUSR",myUserID)),"^",1),TUserName=$p($g(^SSU("SSUSR",myUserID)),"^",2)
	....s TDate=$ZD(myDate,4)
	....s myVal=$G(^TMP("CardInvDetailsOTHer",$j,myUserID,myDate,myIDType,SubID))
	....s TCardAmt=$p(myVal,"^",1),Papmi=$p(myVal,"^",2),TTime=$p(myVal,"^",3),myCardID=$p(myVal,"^",4)
	....s TTime=..%ZT(TTime)
	....q:myCardID=""
	....s TCardNo=""
	....i myCardID'="" s TCardNo=$p($g(^DHCCARD("CF",myCardID)),"^",2)
	....s TPatName=$p($g(^PAPER(Papmi,"ALL")),"^",1)
	....s TID=myCardID
	....Do OutputRow1*/
	
	
	k ^TMP("CardInvDetails",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(TUserCode,TUserName,TInvFlag,$j(TCardAmt,"",4),TCardNo,TDate,TTime,TPatName,TID)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CardInvDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardInvDetailsExecute ]
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

Query CardInvDetails(StartDate As %String, EndDate As %String, OwnFlag As %String, UserID As %String, HandinFlag As %String) As %Query(ROWSPEC = "TUserCode:%String,TUserName:%String,TInvFlag,TCardAmt,TCardNo,TDate,TTime,TPatName,TID")
{
}

ClassMethod FindCardStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCardStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCardStatusExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Status As %String, UserID As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.UDHCJFOPCardInvRepts","FindCardStatus","61102","61159","N","7")
	Set repid=$I(^CacheTemp)
	s ind=1
	//i (StartDate="")||(EndDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	i StartDate="" s StartDate=..%SysDate()
	i EndDate="" s EndDate=..%SysDate()
	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
	i (Status="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	//i (UserID="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	f CSCdate=StartDate:1:EndDate d 
	.s CarparDr=""
	.f  s CarparDr=$o(^DHCCARDi("CF",0,"CSDate",CSCdate,CarparDr)) q:CarparDr=""  d
	..s CarsubDr=""
	..f  s CarsubDr=$o(^DHCCARDi("CF",0,"CSDate",CSCdate,CarparDr,"CSC",CarsubDr)) q:CarsubDr=""  d
	...s TCardStatus=$p(^DHCCARD("CF",CarparDr,"CSC",CarsubDr),"^",3)
	...q:TCardStatus'=Status
	...s TUserId=$p(^DHCCARD("CF",CarparDr,"CSC",CarsubDr),"^",4)
	...q:((UserID'="")&&(TUserId'=UserID))
	...s TUserId=$p(^SSU("SSUSR",TUserId),"^",2)
	...s TCscTime=$p(^DHCCARD("CF",CarparDr,"CSC",CarsubDr),"^",2)
	...i TCscTime'=""  s TCscTime=..%ZT(TCscTime,1)
	...s TCscDate=$p(^DHCCARD("CF",CarparDr,"CSC",CarsubDr),"^",1)
	...i TCscDate'=""  s TCscDate=..%ZD(TCscDate) //$zd(TCscDate,3)
	...s PapmiDr=$p(^DHCCARD("CF",CarparDr),"^",4)
	...s TCardNo=$p(^DHCCARD("CF",CarparDr),"^",2)
	...s TPatName=$P(^PAPER(PapmiDr,"ALL"),"^",1)
	...Do OutputRow10
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow10
	set Data=$lb(TCardNo,TPatName,TUserId,TCscDate,TCscTime)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCardStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCardStatusExecute ]
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

Query FindCardStatus(StartDate As %String, EndDate As %String, Status As %String, UserID As %String) As %Query(ROWSPEC = "TCardNo:%String,TPatName:%String,TUserId:%String,TCscDate:%String,TCscTime:%String")
{
}

}
