Import SQLUser

Class web.UDHCAccCardManage0 Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 204;

/// /积水潭医院专用的
/// /所有的校验码需要重新生成，然后写到DHC_CardRef中
ClassMethod CardColInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardColInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CardColInfoExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, SSUseDR As %String) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;d ##class(%ResultSet).RunQuery("web.UDHCAccCardManage","CardColInfo",+$h,+$h)
	
	;No, myCardNo, myPatName, myPAPMNo, myOperName, myCardStatus,
	;myOperDate, myComIP, myAppName, myAppAddress,
	;myAppIDType, myAppIDNo, myAppTelNo, myRemark
	
	if (StDate["-")!(StDate["/") d
	.s StDate=$zdh(BDate,3)
	i EndDate["-" d
	.s EndDate=$zdh(EndDate,3)
	
	s:StDate="" StDate=+$h
	s:EndDate="" EndDate=+$h
	
	;s ^TMPDD=BDate_"^"_BTime_"^"_EndDate_"^"_EndTime
	
	k ^TMPCardColInfo($j)
	
	d ResetVariablesCCI
	
	s myIdx=0
	s myAccRowID=0
	;f  s myAccRowID=$o(^TMPAcc($j,myAccRowID)) q:(myAccRowID="")  d
	f myDate=EndDate:-1:StDate d
	.s myCardRowID=0
	.f  s myCardRowID=$o(^DHCCARDi("CF",0,"CSDate",myDate,myCardRowID)) q:(myCardRowID="")  d
	..s mySub=0
	..f  s mySub=$o(^DHCCARDi("CF",0,"CSDate",myDate,myCardRowID,"CSC", mySub)) q:(mySub="")  d
	...s myTime=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",2)
	...s myOperDate=$zd(myDate,3)_" "_$zt(myTime)
	...s myCardStatusCode=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",3)
	...;q:(CardStatus'="")&(CardStatus'=myCardStatusCode)
	...i myCardStatusCode="N" s myCardStatus="正常"
	...i myCardStatusCode="S" s myCardStatus="挂失"
	...i myCardStatusCode="R" s myCardStatus="回收"
	...i myCardStatusCode="D" s myCardStatus="作废"
	...s myUseDR=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",4)
	...s myOperName=""
	...s myUserCode=""
	...i (myUseDR'="") d
	....s myOperName=$p(^SSU("SSUSR",myUseDR),"^",2)
	....s myUserCode=$p(^SSU("SSUSR",myUseDR),"^",1)
	...s ^TMPCardColInfo($j,myUseDR)=myOperName
	...i myCardStatusCode="N"  d
	....s ^TMPCardColInfo($j,myUseDR,"N")=+$g(^TMPCardColInfo($j,myUseDR,"N"))+1
	...i myCardStatusCode="S" d
	....s ^TMPCardColInfo($j,myUseDR,"L")=+$g(^TMPCardColInfo($j,myUseDR,"L"))+1
	...i myCardStatusCode="R" d
	....s ^TMPCardColInfo($j,myUseDR,"E")=+$g(^TMPCardColInfo($j,myUseDR,"E"))+1
	
	s No=0
	s myTNNum=0
	s myTLNum=0
	s myTENum=0
	s myUserDR=0
	s myUserName=""
	f  s myUserDR=$o(^TMPCardColInfo($j,myUserDR)) q:(myUserDR="")  d
	.s myUserName=$g(^TMPCardColInfo($j,myUserDR))
	.s myNNum=+$g(^TMPCardColInfo($j,myUserDR,"N"))
	.s myTNNum=myTNNum+myNNum
	.s myLNum=+$g(^TMPCardColInfo($j,myUserDR,"L"))
	.s myTLNum=+myTLNum+myLNum
	.s myENum=+$g(^TMPCardColInfo($j,myUserDR,"E"))
	.s myTENum=+myTENum+myENum
	.s No=No+1
	.d OutputCCI
	
	d ResetVariablesCCI
	
	s myUserName="合计"
	s myNNum=myTNNum
	s myLNum=myTLNum
	s myENum=myTENum
	d OutputCCI
	
	k ^TMPCardColInfo($j)
	
	Quit $$$OK
	
ResetVariablesCCI
	s (No, myUserName, myNNum, myLNum, myENum)=""
	quit
OutputCCI
	s Data=$lb(No, myUserName, myNNum, myLNum, myENum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod getpatinfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", regno As %Library.String = "", patientid As %Library.String = "", cardno As %Library.String = "", cardverify As %Library.String = "", idno As %Library.String = "")
{
 s RegNo="",Papmi="",name="",IDCardNo="",CardNo="",SecurityNO="",ActiveFlag="",DateFrom="",DateTo="",CardID="",FlagName=""
 s Balance="",CredTypeID="",CredType="",CredNo="",cardverify1="",cardverify2=""
 i cardverify'=""  s cardverify1=##class(web.UDHCAccEnrypt).Encrypt(cardverify)
 i patientid'=""  d
 .s Papmi=patientid
 .;&sql(select papmi_no into :RegNo from SQLUser.pa_patmas where papmi_rowid=:Papmi)
 .s name=$p(^PAPER(Papmi,"ALL"),"^",1)
 .s IDCardNo=$p(^PAPER(Papmi,"ALL"),"^",9)
 .s cfrowid="0"
 .f  s cfrowid=$o(^DHCCARDi("CF",0,"PAPMIDR",Papmi,cfrowid))  q:cfrowid=""  d
 ..s ActiveFlag=$p(^DHCCARD("CF",cfrowid),"^",10)
 ..q:(ActiveFlag'="N")&(ActiveFlag'="S")
 ..s CardID=cfrowid
 ..s CardNo=$p(^DHCCARD("CF",cfrowid),"^",2)
 ..s cardverify2=$p(^DHCCARD("CF",cfrowid),"^",3)
 ..s cardverify2=##class(web.UDHCAccEnrypt).Decrypt(cardverify2)
 ..
 ..s IDCardNo=$p(^DHCCARD("CF",cfrowid),"^",5)
 ..s RegNo=$p(^DHCCARD("CF",cfrowid),"^",6)
 ..s DateFrom=$p(^DHCCARD("CF",cfrowid),"^",11)
 ..s DateTo=$p(^DHCCARD("CF",cfrowid),"^",12)
 ..s accrowid="0"
 ..f  s accrowid=$o(^DHCACDi("AccM",0,"PAPMI",Papmi,accrowid))  q:accrowid=""  d
 ...s AccStatus=$p(^DHCACD("AccM",accrowid),"^",13)
 ...q:(AccStatus'="N")&(AccStatus'="S")
 ...;s AccID=accrowid
 ...;s AccNo=$p(^DHCACD("AccM",accrowid),"^",1)
 ...;s RegNo=$p(^DHCACD("AccM",accrowid),"^",3)
 ...;s CardNo=$p(^DHCACD("AccM",accrowid),"^",4)
 ...s Balance=$p(^DHCACD("AccM",accrowid),"^",8)
 ...;s DepPrice=$p(^DHCACD("AccM",accrowid),"^",14)
 ...;s AccType=$p(^DHCACD("AccM",accrowid),"^",16)
 ...s CredTypeID=$p(^DHCACD("AccM",accrowid),"^",17)
 ...s CredNo=$p(^DHCACD("AccM",accrowid),"^",18)
 ...i CredTypeID=""  s CredType=""
 ...i (CredTypeID'="")&&($d(^DHCACCCredType(CredTypeID))) s CredType=$p(^DHCACCCredType(CredTypeID),"^",1)
 i regno'=""  d
 .s papno=..regnocon(regno)
 .s papmi="0"
 .f  s papmi=$o(^PAPERi("PAPMI_PatNo",papno,papmi)) q:papmi=""  d
 ..s RegNo=papno
 ..s Papmi=papmi
 ..s name=$p(^PAPER(papmi,"ALL"),"^",1)
 ..s IDCardNo=$p(^PAPER(papmi,"ALL"),"^",9)
 ..s cfrowid="0"
 ..f  s cfrowid=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,cfrowid))  q:cfrowid=""  d
 ...s ActiveFlag=$p(^DHCCARD("CF",cfrowid),"^",10)
 ...q:(ActiveFlag'="N")&(ActiveFlag'="S")
 ...s CardID=cfrowid
 ...s CardNo=$p(^DHCCARD("CF",cfrowid),"^",2)
 ...s cardverify2=$p(^DHCCARD("CF",cfrowid),"^",3)
 ...s cardverify2=##class(web.UDHCAccEnrypt).Decrypt(cardverify2)
 ...s IDCardNo=$p(^DHCCARD("CF",cfrowid),"^",5)
 ...s ActiveFlag=$p(^DHCCARD("CF",cfrowid),"^",10)
 ...s DateFrom=$p(^DHCCARD("CF",cfrowid),"^",11)
 ...s DateTo=$p(^DHCCARD("CF",cfrowid),"^",12)
 ...s accrowid="0"
 ...f  s accrowid=$o(^DHCACDi("AccM",0,"PAPMI",Papmi,accrowid))  q:accrowid=""  d
 ....s AccStatus=$p(^DHCACD("AccM",accrowid),"^",13)
 ....q:(AccStatus'="N")&(AccStatus'="S")
 ....;s AccID=accrowid
 ....;s AccNo=$p(^DHCACD("AccM",accrowid),"^",1)
 ....;s RegNo=$p(^DHCACD("AccM",accrowid),"^",3)
 ....;s CardNo=$p(^DHCACD("AccM",accrowid),"^",4)
 ....s Balance=$p(^DHCACD("AccM",accrowid),"^",8)
 ....;s DepPrice=$p(^DHCACD("AccM",accrowid),"^",14)
 ....;s AccType=$p(^DHCACD("AccM",accrowid),"^",16)
 ....s CredTypeID=$p(^DHCACD("AccM",accrowid),"^",17)
 ....s CredNo=$p(^DHCACD("AccM",accrowid),"^",18)
 ....i CredTypeID=""  s CredType=""
 ....i (CredTypeID'="")&&($d(^DHCACCCredType(CredTypeID))) s CredType=$p(^DHCACCCredType(CredTypeID),"^",1)
 i cardno'=""  d
 .s cfrowid="0"
 .f  s cfrowid=$o(^DHCCARDi("CF",0,"CardNo",cardno,cfrowid)) q:cfrowid=""  d
 ..s SecurityNO=$p(^DHCCARD("CF",cfrowid),"^",3)
 ..q:SecurityNO'=cardverify1
 ..s ActiveFlag=$p(^DHCCARD("CF",cfrowid),"^",10)
 ..q:(ActiveFlag'="N")&(ActiveFlag'="S")
 ..s cardverify2=cardverify
 ..s CardID=cfrowid
 ..s CardNo=$p(^DHCCARD("CF",cfrowid),"^",2)
 ..s IDCardNo=$p(^DHCCARD("CF",cfrowid),"^",5)
 ..s ActiveFlag=$p(^DHCCARD("CF",cfrowid),"^",10)
 ..s DateFrom=$p(^DHCCARD("CF",cfrowid),"^",11)
 ..s DateTo=$p(^DHCCARD("CF",cfrowid),"^",12)
 ..s Papmi=$p(^DHCCARD("CF",cfrowid),"^",4)
 ..s RegNo=$p(^DHCCARD("CF",cfrowid),"^",6)
 ..s name=$p(^PAPER(Papmi,"ALL"),"^",1)
 ..s accrowid=$p(^DHCCARD("CF",cfrowid),"^",1)
 ..q:accrowid=""
 ..s AccStatus=$p(^DHCACD("AccM",accrowid),"^",13)
 ..q:(AccStatus'="N")&(AccStatus'="S")
 ..;s AccID=accrowid
 ..;s AccNo=$p(^DHCACD("AccM",accrowid),"^",1)
 ..;s RegNo=$p(^DHCACD("AccM",accrowid),"^",3)
 ..;s CardNo=$p(^DHCACD("AccM",accrowid),"^",4)
 ..s Balance=$p(^DHCACD("AccM",accrowid),"^",8)
 ..;s DepPrice=$p(^DHCACD("AccM",accrowid),"^",14)
 ..s AccType=$p(^DHCACD("AccM",accrowid),"^",16)
 ..s CredTypeID=$p(^DHCACD("AccM",accrowid),"^",17)
 ..s CredNo=$p(^DHCACD("AccM",accrowid),"^",18)
 ..i CredTypeID=""  s CredType=""
 ..i (CredTypeID'="")&&($d(^DHCACCCredType(CredTypeID))) s CredType=$p(^DHCACCCredType(CredTypeID),"^",1)
 i idno'="" d
 .
 i DateFrom'=""  s DateFrom=$zd(DateFrom,4)
 i DateTo'=""  s DateTo=$zd(DateTo,4)
 i ActiveFlag="N" s FlagName="正常"
 i ActiveFlag="S" s FlagName="挂失"
 i ActiveFlag="D" s FlagName="作废"
 i ActiveFlag="R" s FlagName="回收"
 s str=RegNo_"^"_Papmi_"^"_name_"^"_IDCardNo_"^"_CardNo_"^"_cardverify2_"^"_ActiveFlag_"^"_DateFrom_"^"_DateTo_"^"_CardID_"^"_FlagName_"^"_Balance_"^"_CredNo_"^"_CredType_"^"_CredTypeID
 s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(str,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod CardColInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardColInfoExecute ]
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

ClassMethod regnocon(regno1 As %String) As %String
{
	q:regno1=""
	s reglen=$l(regno1)
	f i=reglen:1:7  d
	.s regno1="0"_regno1
    q regno1
}

ClassMethod getcardbypapmi(papmi As %Library.String) As %Library.String
{
	q:papmi="" "-301"
	s bPAPMI="1"
	s cfrowid="0"
	f  s cfrowid=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,cfrowid))  q:cfrowid=""  d
 	.s ActiveFlag=$p(^DHCCARD("CF",cfrowid),"^",10)
 	.q:(ActiveFlag'="N")&(ActiveFlag'="S")
 	.s bPAPMI="-302"
	q bPAPMI
}

ClassMethod grantcard(itmjs As %Library.String = "", itmjsex As %Library.String = "", str As %Library.String = "") As %String
{
	s $ZT="ERROR^DHCSSERR"
	
	;需求更改；如果卡被回收，可以发卡
	
	d ##Class(web.UDHCCardRef).tb()
	s rtn=..grantcardNEW(str)
	
	i $p(rtn,"^",1)=0  d 
	.d ##Class(web.UDHCCardRef).tc()
	e  d  
	.TROLLBACK
	
	q rtn
}

ClassMethod grantcardNEW(str As %Library.String = "") As %String
{
	n (str)
	//str=RegNo_"^"_papmi_"^"_IDCardNo_"^"_CardNo_"^"_SecurityNO_"^"_
	//DateFrom_"^"_DateTo_"^"_user_"^"_IP
 	s rtn=0
	
	s papmi=$p(str,"^",2)
	q:papmi="" "-301^"
	s ren=..getcardbypapmi(papmi)
	q:ren'="1" ren_"^"
	s cardno=$p(str,"^",4)
	q:cardno="" "-303^"
	
	;需求更改；如果卡被回收，可以发卡
	;^DHCCARDi("CF",0,"CardNo",{CF_CardNo},{CF_RowID})
	s myCardRowID=0
	f  s myCardRowID=$o(^DHCCARDi("CF",0,"CardNo",cardno,myCardRowID)) q:((myCardRowID="")!(+rtn'=0))  d
	.;^DHCCARD("CF",{CF_RowID})
	.s myCardFlag=$p($g(^DHCCARD("CF",myCardRowID)),"^",10)
	.;如果卡是正常或是挂失，不能重发，只能换卡，或补卡
	.;只有卡被作废，回收后能够重发
	.i (myCardFlag="N")!(myCardFlag="S")!(myCardFlag="") d
	..s rtn=-304
	
	q:rtn rtn_"^"
	
	k PLIST
	s ren=""
	s securityno=$p(str,"^",10)
	s securityno1=##class(web.UDHCAccEnrypt).Encrypt(securityno)
	s PLIST(3)=$p(str,"^",4)
	s PLIST(4)=securityno1
 	s PLIST(5)=$p(str,"^",2)
 	s PLIST(6)=$p(str,"^",3)
 	s PLIST(7)=$p(str,"^",1)
 	s PLIST(8)=+$H
 	s PLIST(9)=$p($H,",",2)
 	s PLIST(10)=$p(str,"^",8)
 	s PLIST(11)="N"
 	s datefrom=$p(str,"^",6)
 	s dateto=$p(str,"^",7)
 	i datefrom["/"  s PLIST(12)=$zdh(datefrom,4)
 	i dateto["/"  s PLIST(13)=$zdh(dateto,4)
	s PLIST(17)=$p(str,"^",11)
	
	s ren=##Class(web.UDHCCardRef).INSERT()
	
	s myCardRowID=PLIST(1)
	i ren=0  d  s ren=..CardStatusRecord(myRowID,"N",$p(str,"^",8),$p(str,"^",9),"")
	
	q ren_"^"_securityno_"^"_myCardRowID
}

ClassMethod grantcardUpdate(str As %Library.String = "") As %String
{
	n (str)
	//RegNoObj.value+"^"+PatientID+"^"+IDCardNo1Obj.value+"^"+CardNoObj.value+"^"+CardVerify
	//+"^"+""+"^"+""+"^"+Guser+"^"+computername+"^"+CardID+"^"+mySecrityNo
	//str=RegNo_"^"_papmi_"^"_IDCardNo_"^"_CardNo_"^"_SecurityNO_"^"_DateFrom_"^"_DateTo_"^"_user_"^"_IP_"^"_CardID
 	s papmi=$p(str,"^",2)
 	q:papmi="" "-301^"
 	s ren=..getcardbypapmi(papmi)
 	q:ren'="1" ren_"^"
 	s cardno=$p(str,"^",4)
 	q:cardno="" "-303^"
 	s cardid=$p(str,"^",10)
 	q:cardid="" "-303^"
 	q:'$d(^DHCCARD("CF",cardid)) "-303^"
 	//q:$d(^DHCCARDi("CF",0,"CardNo",cardno)) "-304^"
 	k PLIST
 	s ren=""
 	s securityno=..GetCardCheckNo($p(str,"^",1))
 	s securityno=$p(str,"^",11)				;CF_SecurityNO
	
 	s securityno1=##class(web.UDHCAccEnrypt).Encrypt(securityno)
 	s PLIST(3)=$p(str,"^",4)			;CF_CardNo
 	s PLIST(4)=securityno1				;CF_SecurityNO
 	s PLIST(5)=$p(str,"^",2)			; CF_PAPMI_DR
 	s PLIST(6)=$p(str,"^",3)			;
 	s PLIST(7)=$p(str,"^",1)
 	s PLIST(8)=+$H
 	s PLIST(9)=$p($H,",",2)
 	s PLIST(10)=$p(str,"^",8)
 	s PLIST(11)="N"
 	s datefrom=$p(str,"^",6)
 	s dateto=$p(str,"^",7)
 	i datefrom["/"  s PLIST(12)=$zdh(datefrom,4)
 	i dateto["/"  s PLIST(13)=$zdh(dateto,4)
 	i datefrom=""  s PLIST(12)=+$H
 	//s $ZT="ERROR^DHCSSERR" d ##Class(web.UDHCCardRef).tb()
	
	s ren=##Class(web.UDHCCardRef).UPDATE(cardid)
	i ren=0  d  s ren=..CardStatusRecord(cardid,"N",$p(str,"^",8),$p(str,"^",9),"")
 	
	q ren_"^"_securityno
}

ClassMethod exchangecard(itmjs As %Library.String = "", itmjsex As %Library.String = "", str As %Library.String = "", RLinfo As %String = "") As %String
{
	s $ZT="ERROR^DHCSSERR" 
 	d ##Class(web.UDHCCardRef).tb()
 	
 	s rtn=..exchangecardNEW(str,RLinfo)
 	
 	;写入状态
	
	i ($p(rtn,"^",1)=0)  d 
	.d ##Class(web.UDHCCardRef).tc()
	e  TROLLBACK
	
	q rtn
}

ClassMethod exchangecardNEW(str As %Library.String = "", RLinfo As %String = "") As %String
{
	n (str,RLinfo)
	//str=CardID_"^"_CardNo_"^"_SecurityNO_"^"_user_"^"_IP_"^"_oldcardstatus
 	s newcardid=""
 	s CardID=$p(str,"^",1)
 	s CardNo=$p(str,"^",2)
 	s SecurityNO=$p(str,"^",3)
 	q:(CardID="")!(CardNo="") "100^"
 	
 	s RegNo=$p(^DHCCARD("CF",CardID),"^",6)
 	s SecurityNO=..GetCardCheckNo(RegNo)
 	s SecurityNO=$p(str,"^",7)
 	s SecurityNO1=##class(web.UDHCAccEnrypt).Encrypt(SecurityNO)
 	s ren=##Class(web.UDHCCardRef).SELECT(CardID)
 	q:ren'=0 "100^"
 	m mPLIST=PLIST
 	s cardflag=$p(^DHCCARD("CF",CardID),"^",10)
 	//s CardReqSuspend=##Class(web.UDHCAccManageCLS).getCardReqSuspend()
 	s SDateDiff=##Class(web.UDHCAccManageCLS).getSDateDiff()
 	q:('$d(^DHCCARD("CF",CardID,"CSC")))&(cardflag="S") "-310^"
 	s RLdiff=0
 	i cardflag="S"  d
 	.s pscsub=$o(^DHCCARD("CF",CardID,"CSC",""),-1)
 	.s RLdate=$p(^DHCCARD("CF",CardID,"CSC",pscsub),"^",1)
 	.s RLdiff=+$H-RLdate
 	s rday=SDateDiff-RLdiff
 	q:(RLdiff<SDateDiff)&(cardflag="S") "-311^"_rday
 	
 	//s $ZT="ERROR^DHCSSERR" d ##Class(web.UDHCCardRef).tb()
 	s ren=..CardStatusChange(CardID,$p(str,"^",6),$p(str,"^",4),$p(str,"^",5),"")
	
 	q:ren'=0 ren_"^"
 	i cardflag="S" d
 	.s accid=$p(^DHCCARD("CF",CardID),"^",1)
 	.q:accid=""
 	.s accstatus=$p(^DHCACD("AccM",accid),"^",13)
 	.q:accstatus'="S"
 	.s ren=##Class(web.UDHCAccManageCLS).AccountStatusChange(accid,"S","N",$p(str,"^",4),$p(str,"^",5),RLinfo)
 	
 	q:ren'=0 ren_"^111"
 	k PLIST
 	m PLIST=mPLIST
 	k PLIST(1),PLIST(14),PLIST(15),PLIST(16)
 	s PLIST(3)=CardNo
 	s PLIST(4)=SecurityNO1
 	s PLIST(8)=+$H
 	s PLIST(9)=$p($H,",",2)
 	s PLIST(10)=$p(str,"^",4)
 	s PLIST(11)="N"
 	;s datefrom=$p(str,"^",6)
 	;s dateto=$p(str,"^",7)
 	;i datefrom["/"  s PLIST(12)=$zdh(datefrom,4)
 	;i dateto["/"  s PLIST(13)=$zdh(dateto,4)
 	
	s ren=##Class(web.UDHCCardRef).INSERT()
	
	i ren=0  d  
	.s newcardid=myRowID
	.s ren=..CardStatusRecord(myRowID,"N",$p(str,"^",4),$p(str,"^",5),RLinfo)
	//i ren=0  d ##Class(web.UDHCCardRef).tc()
	//e  TROLLBACK
 	
	q ren_"^"_SecurityNO_"^"_newcardid_"^"_CardNo
}

ClassMethod reportlosscard(itmjs As %Library.String = "", itmjsex As %Library.String = "", str As %Library.String = "", RLinfo As %String = "") As %String
{
	s $ZT="ERROR^DHCSSERR" d ##Class(web.UDHCCardRef).tb()
 	s rtn=..reportlosscardNEW(str,RLinfo)
 	i rtn=0  d ##Class(web.UDHCCardRef).tc()
	e  TROLLBACK
	q rtn
}

ClassMethod reportlosscardNEW(str As %Library.String = "", RLinfo As %String = "") As %String
{
 	n (str,RLinfo)
 	//str=CardID_"^"_user_"^"_IP
 	s CardID=$p(str,"^",1)
 	s user=$p(str,"^",2)
 	s IP=$p(str,"^",3)
 	q:CardID="" "100"
 	q:'$d(^DHCCARD("CF",CardID)) "100"
 	s cardstatus=$p(^DHCCARD("CF",CardID),"^",10)
 	q:cardstatus'="N" "100"
 	//s $ZT="ERROR^DHCSSERR" d ##Class(web.UDHCCardRef).tb()
 	s ren=..CardStatusChange(CardID,"S",user,IP,RLinfo)
 	q:ren'=0 ren
 	s accid=$p(^DHCCARD("CF",CardID),"^",1)
 	q:accid="" "100"
 	s accstatus=$p(^DHCACD("AccM",accid),"^",13)
 	q:accstatus'="N" "100"
 	s ren=##Class(web.UDHCAccManageCLS).AccountStatusChange(accid,"N","S",user,IP,RLinfo)
	q ren
}

ClassMethod refundcard(itmjs As %Library.String = "", itmjsex As %Library.String = "", str As %Library.String = "") As %String
{
	s $ZT="ERROR^DHCSSERR" d ##Class(web.UDHCCardRef).tb()
 	s rtn=..refundcardNEW(str)
 	i rtn=0  d ##Class(web.UDHCCardRef).tc()
	e  TROLLBACK
	q rtn
}

ClassMethod refundcardNEW(str As %Library.String = "") As %String
{
 	n (str)
 	//str=CardID_"^"_user_"^"_IP
 	s CardID=$p(str,"^",1)
 	s user=$p(str,"^",2)
 	s IP=$p(str,"^",3)
 	q:CardID="" "100"
 	q:'$d(^DHCCARD("CF",CardID)) "100"
 	s cardstatus=$p(^DHCCARD("CF",CardID),"^",10)
 	q:cardstatus'="N" "100"
 	s accid=$p(^DHCCARD("CF",CardID),"^",1)
 	s accstatus=""
 	i accid'=""  s accstatus=$p(^DHCACD("AccM",accid),"^",13)
 	q:(accid'="")&(accstatus'="F") "notfoot" 	
 	s ren=..CardStatusChange(CardID,"R",user,IP,"")
	q ren
}

ClassMethod CardStatusChange(cfrowid As %String, status As %String, userid As %String, IP As %String, RLinfo As %String) As %String
{
	;w ##class(web.UDHCAccCardManage).CardStatusChange(cfrowid, status, userid , IP , RLinfo)
	k PLIST
 	s PLIST(11)=status
 	s PLIST(14)=+$H
	s PLIST(15)=$p($H,",",2)
	s PLIST(16)=userid
	s ren=##Class(web.UDHCCardRef).UPDATE(cfrowid)
	i ren=0  d  s ren=..CardStatusRecord(cfrowid,status,userid,IP,RLinfo)
	q ren
}

ClassMethod CardStatusRecord(cfrowid As %String, status As %String, userid As %String, IP As %String, RLinfo As %String) As %String
{
	k PLIST
	s PLIST(0)=cfrowid
	s PLIST(3)=+$H
	s PLIST(4)=$p($H,",",2)
	s PLIST(5)=status
	s PLIST(6)=userid
	s PLIST(7)=IP
	i RLinfo'=""  d
	.s PLIST(13)=$p(RLinfo,"^",1)
	.s PLIST(14)=$p(RLinfo,"^",2)
	.s PLIST(15)=$p(RLinfo,"^",3)
	.s PLIST(16)=$p(RLinfo,"^",4)
	.s PLIST(17)=$p(RLinfo,"^",5)
	.s PLIST(18)=$p(RLinfo,"^",6)
	.s PLIST(19)=$p(RLinfo,"^",7)
	s ren=##Class(web.UDHCCardStatusChange).INSERT()

	q ren
}

ClassMethod GetCardCheckNo(PAPMINo As %String) As %String
{
	;此卡对于每个人来说，应该是唯一的
	;对于此卡号来讲要求校验码唯一，或不同
	;^DHCCARDi("CF",0,"CardNo",{CF_CardNo},{CF_RowID})
	;w ##class(web.UDHCAccCardManage).GetCardCheckNo("00000001")
	s myCheckNo=PAPMINo_""_+$h_$p($h,",",2)
	
	q myCheckNo
}

ClassMethod ReadACardByPANo(CardNo As %String) As %String
{
	;通过卡号获取校验码
	;w ##class(web.UDHCAccCardManage).ReadACardByPANo("")
	s mySecrityNo=""
	s PAPMINo=""
	
	q:(CardNo="") ""
	
	;^DHCCARDi("CF",0,"CardNo",{CF_CardNo},{CF_RowID})
	s myCFRowID=0
	f  s myCFRowID=$o(^DHCCARDi("CF",0,"CardNo",CardNo, myCFRowID)) q:(myCFRowID="")  d
	.q:($d(^DHCCARD("CF",myCFRowID))=10)
	.s myCardFlag=$p($g(^DHCCARD("CF",myCFRowID)),"^",10)			;ActiveFlag
	.q:myCardFlag'="N"
	.s mySecrityNo=$p($g(^DHCCARD("CF",myCFRowID)),"^",3)			;CF_SecurityNO
	.s PAPMINo=$p($g(^DHCCARD("CF",myCFRowID)),"^",6)			;CF_PAPMINo
	
	s mySecrityNo=##class(web.UDHCAccEnrypt).Decrypt(mySecrityNo)
	
	q mySecrityNo_"^"_PAPMINo
}

ClassMethod ReadCardExInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadCardExInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ReadCardExInfoExecute(ByRef qHandle As %Binary, CardNo As %String, UserCode As %String, StDate As %String, EndDate As %String, CardStatus As %String, UserCodeA As %String) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;d ##class(%ResultSet).RunQuery("web.UDHCAccCardManage","ReadCardExInfo","","",+$h-10,+$h,"")
	
	;No, myCardNo, myPatName, myPAPMNo, myOperName, myCardStatus,
	;myOperDate, myComIP, myAppName, myAppAddress,
	;myAppIDType, myAppIDNo, myAppTelNo, myRemark
	
	if (StDate["-")!(StDate["/") d
	.s StDate=$zdh(BDate,3)
	i EndDate["-" d
	.s EndDate=$zdh(EndDate,3)
	
	s:StDate="" StDate=+$h
	;s:BTime="" BTime=$p($h,",",2)
	s:EndDate="" EndDate=+$h
	;s:EndTime="" EndTime=$p($h,",",2)
	
	;s ^TMPDD=BDate_"^"_BTime_"^"_EndDate_"^"_EndTime
	
	d ResetVariablesFR
	;^DHCCARDi("CF",0,"CSDate",{CSC_Date},{DHC_CardRef.CF_RowID},"CSC",{CSC_Sub}) 
	;^DHCCARD("CF",{DHC_CardRef.CF_RowID},"CSC",{CSC_Sub})
	
	s myIdx=0
	s myAccRowID=0
	;f  s myAccRowID=$o(^TMPAcc($j,myAccRowID)) q:(myAccRowID="")  d
	f myDate=EndDate:-1:StDate d
	.s myCardRowID=0
	.f  s myCardRowID=$o(^DHCCARDi("CF",0,"CSDate",myDate,myCardRowID)) q:(myCardRowID="")  d
	..s mySub=0
	..f  s mySub=$o(^DHCCARDi("CF",0,"CSDate",myDate,myCardRowID,"CSC", mySub)) q:(mySub="")  d
	...s myTime=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",2)
	...s myOperDate=$zd(myDate,3)_" "_$zt(myTime)
	...s myCardStatusCode=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",3)
	...q:(CardStatus'="")&(CardStatus'=myCardStatusCode)
	...i myCardStatusCode="N" s myCardStatus="正常"
	...i myCardStatusCode="S" s myCardStatus="挂失"
	...i myCardStatusCode="R" s myCardStatus="回收"
	...i myCardStatusCode="D" s myCardStatus="作废"
	...s myUseDR=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",4)
	...s myOperName=""
	...s myUserCode=""
	...i (myUseDR'="") d
	....s myOperName=$p(^SSU("SSUSR",myUseDR),"^",2)
	....s myUserCode=$p(^SSU("SSUSR",myUseDR),"^",1)
	...q:(UserCode'="")&(UserCode'=myUserCode)
	...q:(UserCodeA'="")&(UserCodeA'=myUserCode)
	...s myComIP=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",5)
	...;myAppName, myAppAddress,myAppIDType, myAppIDNo, myAppTelNo, myRemark
	...s myAppName=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",11)
	...s myAppIDNo=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",12)
	...s myAppAddress=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",13)
	...s myAppTelNo=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",14)
	...s myRemark=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",16)
	...s myRLCredDR=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",17)
	...s myAppIDType=""
	...i myRLCredDR'="" d
	....s myAppIDType=$p(^DHCACCCredType(myRLCredDR),"^",2)
	...;myCardNo, myPatName, myPAPMNo, myOperName
	...;^DHCCARD("CF",myCardRowID)
	...s myCardNo=$p(^DHCCARD("CF",myCardRowID),"^",2)
	...q:((CardNo'="")&(CardNo'=myCardNo))
	...s myPAPMDR=$p(^DHCCARD("CF",myCardRowID),"^",4)
	...s myPatName=$p(^PAPER(myPAPMDR,"ALL"),"^",1)
	...s myPAPMNo=$p(^DHCCARD("CF",myCardRowID),"^",6)
	...s myIdx=+myIdx+1
	...s No=myIdx
	...d OutputFR
	
	Quit $$$OK
ResetVariablesFR
	s (No,myAccRID,myPAPMINo,myPAName,myCADateT, myPreLeftSum,myPreSum,myRefPreSum, myCPSum, myCurLeftSum, myAccStatus)=""
	s (No, myCardNo, myPatName, myPAPMNo, myOperName, myCardStatus, myOperDate, myComIP, myAppName, myAppAddress,myAppIDType, myAppIDNo, myAppTelNo, myRemark)=""
	;
	quit
OutputFR
	s Data=$lb(No, myCardNo, myPatName, myPAPMNo, myOperName, myCardStatus, myOperDate, myComIP, myAppName, myAppAddress,myAppIDType, myAppIDNo, myAppTelNo, myRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod ReadCardExInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadCardExInfoExecute ]
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

Query CardColInfo(StDate As %String, EndDate As %String, SSUseDR As %String) As %Query(ROWSPEC = "No:%String,TUserName:%String,TNNum:%String,TLNum:%String,TENum:%String")
{
}

Query ReadCardExInfo(CardNo As %String, UserCode As %String, StDate As %String, EndDate As %String, CardStatus As %String, UserCodeA As %String) As %Query(ROWSPEC = "No:%String, CardNo:%String, PatName:%String, PAPMNo:%String, OperName:%String, CardStatus:%String, OperDate:%String, ComIP:%String, AppName:%String, AppAddress:%String, AppIDType:%String, AppIDNo:%String, AppTelNo:%String, Remark:%String")
{
}

}
