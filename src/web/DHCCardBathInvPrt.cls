Class web.DHCCardBathInvPrt Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod SaveData(myData As %String) As %String
{
	q:$g(myData)="" -100
	
	
	s myCardType=$p(myData,"^",1)
	s myCardNo=$p(myData,"^",2)
	s myCardSerialNo=$p(myData,"^",3)
	s myPatName=$p(myData,"^",4)
	s myPatientID=$p(myData,"^",5)
	s myPayType=$p(myData,"^",6)
	s myPayAmount=+$p(myData,"^",7)
	if myPayType="R"
	{
		s myPayAmount=0-myPayAmount
		}
	s myUserID=$p(myData,"^",8)
	s myDate=+$H
	s myTime=$p($H,",",2)
	
	s obj = ##class(User.DHCCardBathInvPrt).%New()
	s obj.CardType=myCardType
	s obj.CardNo=myCardNo
	s obj.CardSerialNo=myCardSerialNo
	s obj.PatName=myPatName
	s obj.PatientID=myPatientID
	s obj.PayType=myPayType
	s obj.PayAmount=myPayAmount
	s obj.UserID=myUserID
	s obj.AddDate=myDate
	s obj.AddTime=myTime
	Set sc = obj.%Save()
	if ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Quit -100
	}
	
	Quit 0
}

ClassMethod CardBathTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardBathTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CardBathTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	s Code="01"
	s Desc="充值"
	Do OutputRow
	;s Code="02"
	;s Desc="职工"
	;Do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(Desc,Code)
	Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod CardBathTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardBathTypeExecute ]
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

Query CardBathType() As %Query(ROWSPEC = "TypeDesc:%String,TypeCode:%String")
{
}

ClassMethod ReadCardBathType(JSFunName As %String = "", ListName As %String = "") As %String
{
	s mydes="充值"
	s myval="01"
	s myIdx=0
	s mySelFlag="Y"
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	&javascript<#(rtnval)#>
	;s myIdx=myIdx+1
	;s mydes="职工"
	;s myval="02"
	;s mySelFlag=""
	;s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	;s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	;&javascript<#(rtnval)#>
	q 0
}

ClassMethod getPatInfo(PatientID As %String = "") As %String
{
	
	s rtn="100"
	q:PatientID="" rtn
	q:'$d(^PAPER(PatientID)) rtn 
	s rtn="0"
	s PatientName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
	s adm=$o(^PAPERdr(PatientID,"ADM","I",""),-1)
	s PatWard="",WardCode=""   ;,CardNo=""
	if adm'="" {
		s CurrentWard=$p($g(^PAADM(adm)),"^",70)
		if CurrentWard'=""
			{
				s LocDr=$p($g(^PAWARD(CurrentWard)),"^",5)
				if LocDr'=""{
					s PatWard=$p($g(^CTLOC(LocDr)),"^",2)
					s WardCode=$p($g(^CTLOC(LocDr)),"^",41)
					}
				
				}
		}
	s rtn=rtn_"^"_PatientName_"^"_PatWard_"^"_WardCode
	q rtn
}

ClassMethod CardBathReptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardBathReptExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CardBathReptExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, OwnFlag As %String, UserID As %String, HandinFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	i (StartDate="")||(EndDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	k ^TMP("CardBathRept",$j)
	s (TUserID,TUserCode,TUserName,TDate,TIssueCardNum,TIssueCardAmt,TReclaimCardNum,TReclaimCardAmt,TCardNum,TCardAmt,TTime)=""
	s (TIssueCardNumSum,TIssueCardAmtSum,TReclaimCardNumSum,TReclaimCardAmtSum,TCardNumSum,TCardAmtSum)=0
	s myDate=StartDate-1
	f  s myDate=$o(^DHCCardBathInvPrt(0,"Date",myDate)) q:(myDate="")||(myDate>EndDate)  d
	.s myID=""
	.f  s myID=$o(^DHCCardBathInvPrt(0,"Date",myDate,myID)) q:myID=""  d
	..s myVal=$g(^DHCCardBathInvPrt(myID))
	..s myUserID=$p(myVal,"^",8),myFlag=$p(myVal,"^",6),myAmt=+$p(myVal,"^",7),myHandinFlag=$p(myVal,"^",11)
	..s myDate=$p(myVal,"^",9),myTime=$p(myVal,"^",10)
	..q:(OwnFlag="1")&&(myUserID'=UserID)
	..q:(HandinFlag="1")&&(myHandinFlag="")
	..s myNowDate=+$H
	..i myFlag="N" d
	...s ^TMP("CardBathRept",$j,myUserID,myNowDate,"INum")=+$g(^TMP("CardBathRept",$j,myUserID,myNowDate,"INum"))+1
	...s ^TMP("CardBathRept",$j,myUserID,myNowDate,"IAmt")=+$g(^TMP("CardBathRept",$j,myUserID,myNowDate,"IAmt"))+myAmt
	..e  d
	...s ^TMP("CardBathRept",$j,myUserID,myNowDate,"RNum")=+$g(^TMP("CardBathRept",$j,myUserID,myNowDate,"RNum"))+1
	...s ^TMP("CardBathRept",$j,myUserID,myNowDate,"RAmt")=+$g(^TMP("CardBathRept",$j,myUserID,myNowDate,"RAmt"))+myAmt
	
	s myUserID=""
	f  s myUserID=$o(^TMP("CardBathRept",$j,myUserID)) q:myUserID=""  d
	.s myDate=""
	.f  s myDate=$o(^TMP("CardBathRept",$j,myUserID,myDate)) q:myDate=""  d
	..s TUserID=myUserID
	..s TUserCode=$p($g(^SSU("SSUSR",myUserID)),"^",1),TUserName=$p($g(^SSU("SSUSR",myUserID)),"^",2)
	..s TDate=$ZD(myDate,4)
	..s TDate=""
	..s TIssueCardNum=+$g(^TMP("CardBathRept",$j,myUserID,myDate,"INum"))
	..s TIssueCardAmt=+$g(^TMP("CardBathRept",$j,myUserID,myDate,"IAmt"))
	..s TReclaimCardNum=+$g(^TMP("CardBathRept",$j,myUserID,myDate,"RNum"))
	..s TReclaimCardAmt=+$g(^TMP("CardBathRept",$j,myUserID,myDate,"RAmt"))
	..s TCardNum=TIssueCardNum-TReclaimCardNum
	..s TCardAmt=TIssueCardAmt+TReclaimCardAmt
	..s TIssueCardNumSum=TIssueCardNumSum+TIssueCardNum
	..s TIssueCardAmtSum=TIssueCardAmtSum+TIssueCardAmt
	..s TReclaimCardNumSum=TReclaimCardNumSum+TReclaimCardNum
	..s TReclaimCardAmtSum=TReclaimCardAmtSum+TReclaimCardAmt
	..s TCardNumSum=TCardNumSum+TCardNum
	..s TCardAmtSum=TCardAmtSum+TCardAmt
	..Do OutputRow
	s (TUserID,TUserCode,TUserName,TDate,TIssueCardNum,TIssueCardAmt,TReclaimCardNum,TReclaimCardAmt,TCardNum,TCardAmt,TTime)=""
	i $d(^TMP("CardBathRept",$j))  d
	.s TUserName="合计"
	.s TIssueCardNum=TIssueCardNumSum
	.s TIssueCardAmt=TIssueCardAmtSum
	.s TReclaimCardNum=TReclaimCardNumSum
	.s TReclaimCardAmt=TReclaimCardAmtSum
	.s TCardNum=TCardNumSum
	.s TCardAmt=TCardAmtSum
	.Do OutputRow
	.
	
	k ^TMP("CardBathRept",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(TUserID,TUserCode,TUserName,TDate,TIssueCardNum,TIssueCardAmt,TReclaimCardNum,TReclaimCardAmt,TCardNum,TCardAmt,TTime)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CardBathReptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardBathReptExecute ]
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

Query CardBathRept(StartDate As %String, EndDate As %String, OwnFlag As %String, UserID As %String, HandinFlag As %String) As %Query(ROWSPEC = "TUserID,TUserCode:%String,TUserName:%String,TDate,TIssueCardNum,TIssueCardAmt,TReclaimCardNum,TReclaimCardAmt,TCardNum,TCardAmt,TTime")
{
}

ClassMethod CardBathDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardBathDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CardBathDetailsExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, OwnFlag As %String, UserID As %String, HandinFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	i (StartDate="")||(EndDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	k ^TMP("CardBathDetails",$j)
	s (TUserCode,TUserName,TInvFlag,TCardAmt,TCardNo,TDate,TTime,TPatName,TID)=""
	
	s myDate=StartDate-1
	f  s myDate=$o(^DHCCardBathInvPrt(0,"Date",myDate)) q:(myDate="")||(myDate>EndDate)  d
	.s myID=""
	.f  s myID=$o(^DHCCardBathInvPrt(0,"Date",myDate,myID)) q:myID=""  d
	..s myVal=$g(^DHCCardBathInvPrt(myID))
	..s myUserID=$p(myVal,"^",8),myFlag=$p(myVal,"^",6),myAmt=+$p(myVal,"^",7),myHandinFlag=$p(myVal,"^",11)
	..s myPapmi=$p(myVal,"^",5),myDate=$p(myVal,"^",9),myTime=$p(myVal,"^",10)
	..q:(OwnFlag="1")&&(myUserID'=UserID)
	..q:(HandinFlag="1")&&(myHandinFlag="")
	..
	..s ^TMP("CardBathDetails",$j,myUserID,myDate,myID)=""
	..
	
	
	s myUserID=""
	f  s myUserID=$o(^TMP("CardBathDetails",$j,myUserID)) q:myUserID=""  d
	.s myDate=""
	.f  s myDate=$o(^TMP("CardBathDetails",$j,myUserID,myDate)) q:myDate=""  d
	..s myID=""
	..f  s myID=$o(^TMP("CardBathDetails",$j,myUserID,myDate,myID)) q:myID=""  d
	...s TUserCode=$p($g(^SSU("SSUSR",myUserID)),"^",1),TUserName=$p($g(^SSU("SSUSR",myUserID)),"^",2)
	...s TDate=$ZD(myDate,4)
	...s myVal=$g(^DHCCardBathInvPrt(myID))
	...s TCardAmt=$p(myVal,"^",7),Papmi=$p(myVal,"^",5),TTime=$p(myVal,"^",10)
	...s TTime=$ZT(TTime)
	...s myFlag=$p(myVal,"^",6)
	...s myCardID=""
	...i myFlag="N"  d
	....s TInvFlag="收款"
	....
	...e  d
	....s TInvFlag="退款"
	....
	...s TCardNo=$p(myVal,"^",2)
	...s TPatName=$p($g(^PAPER(Papmi,"ALL")),"^",1)
	...s TID=myID
	...Do OutputRow1
	
	
	k ^TMP("CardBathDetails",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(TUserCode,TUserName,TInvFlag,TCardAmt,TCardNo,TDate,TTime,TPatName,TID)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CardBathDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardBathDetailsExecute ]
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

Query CardBathDetails(StartDate As %String, EndDate As %String, OwnFlag As %String, UserID As %String, HandinFlag As %String) As %Query(ROWSPEC = "TUserCode:%String,TUserName:%String,TInvFlag,TCardAmt,TCardNo,TDate,TTime,TPatName,TID")
{
}

}
