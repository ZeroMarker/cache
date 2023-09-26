Import SQLUser

Class web.UDHCAccCardManage Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 204;

/// /合肥省立医院专用
/// /磁卡的校验码，
/// /在卡中已有不需要写比较特别
/// /需要特别注意
ClassMethod CardColInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardColInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CardInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardInfoExecute ]
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
	
	s:StDate="" StDate=..%SysDate()
	s:EndDate="" EndDate=..%SysDate()
	
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
	...s myOperDate=$zd(myDate,3)_" "_..%ZT(myTime)
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

ClassMethod CardInfoExecute(ByRef qHandle As %Binary, CardNo As %String, UserCode As %String, StDate As %String, EndDate As %String, PAPMINo As %String, PatName As %String, Sex As %String) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;d ##class(%ResultSet).RunQuery("web.UDHCAccCardManage","CardInfo","","",+$h-10,+$h,"")
	
	;No, TPatName, TSex, TDOB, TCardNo, TPAPMINo,
	;TCredType, TCredFlag, TCFDateTime,TCardStatus
	
	if (StDate["-")!(StDate["/") d
	.s StDate=$zdh(BDate,3)
	i EndDate["-" d
	.s EndDate=$zdh(EndDate,3)
	
	s:StDate="" StDate=..%SysDate()
	s:EndDate="" EndDate=..%SysDate()
	
	i PAPMINo'="" d
	.s mylen=$l(PAPMINo)
	.s PAPMINo=$e("00000000",1,8-mylen)_PAPMINo
	
	d ResetVariablesCI
	;^DHCCARDi("CF",0,"CSDate",{CSC_Date},{DHC_CardRef.CF_RowID},"CSC",{CSC_Sub}) 
	;^DHCCARD("CF",{DHC_CardRef.CF_RowID},"CSC",{CSC_Sub})
	
	s myIdx=0
	s myAccRowID=0
	;f  s myAccRowID=$o(^TMPAcc($j,myAccRowID)) q:(myAccRowID="")  d
	
	f myDate=EndDate:-1:StDate d
	.s myCardRowID=""
	.f  s myCardRowID=$o(^DHCCARDi("CF",0,"CSDate",myDate,myCardRowID),-1) q:(myCardRowID="")  d
	..q:(+myCardRowID=0)
	..
	..s myTime=$p(^DHCCARD("CF",myCardRowID),"^",8)
	..s myOperDate=$zd(myDate,3)_" "_..%ZT(myTime)
	..s TCFDateTime=myOperDate
	..s myCardStatus=""
	..s TCardStatus=""
	..s myCardStatusCode=$p(^DHCCARD("CF",myCardRowID),"^",10)
	..i myCardStatusCode="N" s myCardStatus="正常"
	..i myCardStatusCode="S" s myCardStatus="挂失"
	..i myCardStatusCode="R" s myCardStatus="回收"
	..i myCardStatusCode="D" s myCardStatus="作废"
	..s myUseDR=$p(^DHCCARD("CF",myCardRowID),"^",9)
	..s TCardStatus=myCardStatus
	..s myUserCode=""
	..i (myUseDR'="") d
	...s myOperName=$p(^SSU("SSUSR",myUseDR),"^",2)
	...s myUserCode=$p(^SSU("SSUSR",myUseDR),"^",1)
	..q:(UserCode'="")&(UserCode'=myUserCode)
	..s myAccRowID=$p(^DHCCARD("CF",myCardRowID),"^",1)
	..s TCredType=""
	..i myAccRowID'=""  d
	...s CredTypeDR=$p(^DHCACD("AccM",myAccRowID),"^",17)
	...s TCredType=$p(^DHCACCCredType(CredTypeDR),"^",2)
	..s myCredNo=$p(^DHCACD("AccM",myAccRowID),"^",18)
	..s TCredFlag=0
	..i myCredNo'="" d
	...s TCredFlag=1
	..s myCardNo=$p(^DHCCARD("CF",myCardRowID),"^",2)
	..q:((CardNo'="")&(CardNo'=myCardNo))
	..s myPAPMDR=$p(^DHCCARD("CF",myCardRowID),"^",4)
	..s myPatName=$p(^PAPER(myPAPMDR,"ALL"),"^",1)
	..q:(PatName'="")&(myPatName'[PatName)
	..s myPAPMNo=$p(^DHCCARD("CF",myCardRowID),"^",6)
	..q:(PAPMINo'="")&(PAPMINo'=myPAPMNo)
	..s SexDR=$p(^PAPER(myPAPMDR,"ALL"),"^",7)
	..s TSex=$p(^CT("SEX",SexDR),"^",2)
	..q:(Sex'="")&(Sex'=TSex)
	..s TDOB=$p(^PAPER(myPAPMDR,"ALL"),"^",6)
	..s TDOB=$zd(TDOB,3)
	..
	..s myIdx=+myIdx+1
	..s No=myIdx
	..d OutputCI

	;No, TPatName, TSex, TDOB, TCardNo, TPAPMINo,
	;TCredType, TCredFlag, TCFDateTime,TCardStatus
	
	Quit $$$OK
ResetVariablesCI
	;
	quit
OutputCI
	s Data=$lb(No, myPatName, TSex, TDOB, myCardNo, myPAPMNo,TCredType, TCredFlag, TCFDateTime,TCardStatus )
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod regnocon(regno1 As %String) As %String
{
	q:regno1=""
	s reglen=$l(regno1)
	f i=reglen:1:7  d
	.s regno1="0"_regno1
    q regno1
}

ClassMethod CardInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardInfoExecute ]
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
	s ^TMPHHHHH=str
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
	;s securityno=..GetCardCheckNo($p(str,"^",1))
	s securityno=$p(str,"^",10)
	s securityno1=##class(web.UDHCAccEnrypt).Encrypt(securityno)
	s PLIST(3)=$p(str,"^",4)
	s PLIST(4)=securityno1
 	s PLIST(5)=$p(str,"^",2)
 	s PLIST(6)=$p(str,"^",3)
 	s PLIST(7)=$p(str,"^",1)
 	s PLIST(8)=..%SysDate()
 	s PLIST(9)=..%SysTime()
 	s PLIST(10)=$p(str,"^",8)
 	s PLIST(11)="N"
 	s datefrom=$p(str,"^",6)
 	s dateto=$p(str,"^",7)
 	i datefrom["/"  s PLIST(12)=$zdh(datefrom,4)
 	i dateto["/"  s PLIST(13)=$zdh(dateto,4)
	
	s ren=##Class(web.UDHCCardRef).INSERT()
	
	i ren=0  d  s ren=..CardStatusRecord(myRowID,"N",$p(str,"^",8),$p(str,"^",9),"")
	
	q ren_"^"_securityno_"^"_myRowID
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
 	s PLIST(8)=..%SysDate()
 	s PLIST(9)=..%SysTime()
 	s PLIST(10)=$p(str,"^",8)
 	s PLIST(11)="N"
 	s datefrom=$p(str,"^",6)
 	s dateto=$p(str,"^",7)
 	i datefrom["/"  s PLIST(12)=$zdh(datefrom,4)
 	i dateto["/"  s PLIST(13)=$zdh(dateto,4)
 	i datefrom=""  s PLIST(12)=..%SysDate()
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
 	.s RLdiff=..%SysDate()-RLdate
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
 	s PLIST(8)=..%SysDate()
 	s PLIST(9)=..%SysTime()
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

ClassMethod CardStatusChange(cfrowid As %String, status As %String, userid As %String, IP As %String, RLinfo As %String, LogonHospDR As %String) As %String
{
	;w ##class(web.UDHCAccCardManage).CardStatusChange(cfrowid, status, userid , IP , RLinfo)
	k PLIST
 	s PLIST(11)=status
 	s PLIST(14)=..%SysDate()
	s PLIST(15)=..%SysTime()
	s PLIST(16)=userid
	s ren=##Class(web.UDHCCardRef).UPDATE(cfrowid)
	i ren=0  d  s ren=..CardStatusRecord(cfrowid,status,userid,IP,RLinfo,LogonHospDR)
	q ren
}

ClassMethod CardStatusRecord(cfrowid As %String, status As %String, userid As %String, IP As %String, RLinfo As %String, LogonHospDR As %String) As %String
{
	k PLIST
	s PLIST(0)=cfrowid
	s PLIST(3)=..%SysDate()
	s PLIST(4)=..%SysTime()
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
	s PLIST(20)=LogonHospDR //CSCHospDR
	s ren=##Class(web.UDHCCardStatusChange).INSERT()

	q ren
}

ClassMethod GetCardCheckNo(PAPMINo As %String) As %String
{
	;此卡对于每个人来说，应该是唯一的
	;对于此卡号来讲要求校验码唯一，或不同
	;^DHCCARDi("CF",0,"CardNo",{CF_CardNo},{CF_RowID})
	;w ##class(web.UDHCAccCardManage).GetCardCheckNo("00000001")
	;+$h_
	i PAPMINo'=""{
		s myCheckNo=PAPMINo_""_..%SysTime()
	}else{
	    s time=..%SysTime()
		s myCheckNo=PAPMINo_""_+$h_$e("00000",1,5-$l(time))_time  //凌晨不能建卡
		//s myCheckNo=PAPMINo_""_+$h_..%SysTime()
	}
	
	
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
	;d ##class(%ResultSet).RunQuery("web.UDHCAccCardManage","ReadCardExInfo","","",63923,63928,"","李坤")
	
	;No, myCardNo, myPatName, myPAPMNo, myOperName, myCardStatus,
	;myOperDate, myComIP, myAppName, myAppAddress,
	;myAppIDType, myAppIDNo, myAppTelNo, myRemark
	
	/*if (StDate["-") d
	.s StDate=$zdh(StDate,3)
	if (StDate["/") d
	.s StDate=$zdh(StDate,4)
	i EndDate["-" d
	.s EndDate=$zdh(EndDate,3)*/
	
	
	i StDate'="" s StDate=..%ZDH(StDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
	;s ^TMPDD=BDate_"^"_BTime_"^"_EndDate_"^"_EndTime
	s:StDate="" StDate=..%SysDate()
	;s:BTime="" BTime=..%SysTime()
	s:EndDate="" EndDate=..%SysDate()
	;s:EndTime="" EndTime=..%SysTime()
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
	...s myOperDate=..%ZD(myDate)_" "_..%ZT(myTime) //$zd(myDate,3)_" "_..%ZT(myTime)
	...s myCardStatusCode=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",3)
	...q:(CardStatus'="")&(CardStatus'=myCardStatusCode)
	...i myCardStatusCode="N" s myCardStatus="正常"
	...e  i myCardStatusCode="S" s myCardStatus="挂失"
	...e  i myCardStatusCode="R" s myCardStatus="回收"
	...e  i myCardStatusCode="D" s myCardStatus="作废"
	...e  i myCardStatusCode="STD" s myCardStatus="补卡后作废"
	...e  i myCardStatusCode="ETD" s myCardStatus="换卡后作废"
	...e  i myCardStatusCode="E" s myCardStatus="换卡后有效"
	...e  i myCardStatusCode="RN" s myCardStatus="补卡后有效"
	...e  s myCardStatus=myCardStatusCode
	...s myUseDR=$p(^DHCCARD("CF",myCardRowID,"CSC",mySub),"^",4)
	...s myOperName=""
	...s myUserCode=""
	...i (myUseDR'="") d
	....s myOperName=$p(^SSU("SSUSR",myUseDR),"^",2)
	....s myUserCode=$p(^SSU("SSUSR",myUseDR),"^",1)
	...q:(UserCode'="")&(UserCode'=myUserCode)
	...//q:(UserCodeA'="")&(UserCodeA'=myUserCode)
	...q:(UserCodeA'="")&(UserCodeA'=myOperName)
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
	....s myAppIDType=$p($g(^PAC("CARD",myRLCredDR)),"^",2)
	...;myCardNo, myPatName, myPAPMNo, myOperName
	...;^DHCCARD("CF",myCardRowID)
	...s myCardNo=$p(^DHCCARD("CF",myCardRowID),"^",2)
	...q:((CardNo'="")&(CardNo'=myCardNo))
	...s CFCardTypeDR=$p($g(^DHCCARD("CF",myCardRowID)),"^",16)
	...s myCardType=""
	...s:CFCardTypeDR'="" myCardType=$p(^DHCCARDTYPEDef(CFCardTypeDR),"^",2)
	...s myPAPMDR=$p(^DHCCARD("CF",myCardRowID),"^",4)
	...s myPatName=$p(^PAPER(myPAPMDR,"ALL"),"^",1)
	...i myAppName="" s myAppName=myPatName
	...i myAppAddress="" s myAppAddress=$G(^PAPER(myPAPMDR,"PER","ADD",1))
	...i myAppIDType="" d
	....s myCredTypeID=$p($g(^PAPER(myPAPMDR,"PAT",3)),"^",7)
	....s:myCredTypeID'="" myAppIDType=$p($g(^PAC("CARD",myCredTypeID)),"^",2)
	...i myAppIDNo="" s myAppIDNo=$p($g(^PAPER(myPAPMDR,"PAT",3)),"^",6)
	...i myAppTelNo="" s myAppTelNo=$p(^PAPER(myPAPMDR,"PER",1),"^",11)
	...s myPAPMNo=$p(^DHCCARD("CF",myCardRowID),"^",6)
	...s TPoliticalLevel="",TSecretLevel=""
	...s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(myPAPMDR,.ErrMsg)
	...i PatEncryptLevel'="" d
	....s TPoliticalLevel=$p(PatEncryptLevel,"^",2)
	....s TSecretLevel=$p(PatEncryptLevel,"^",4)
	...s myIdx=+myIdx+1
	...s No=myIdx
	...d OutputFR
	
	Quit $$$OK
ResetVariablesFR
	s (No,myAccRID,myPAPMINo,myPAName,myCADateT, myPreLeftSum,myPreSum,myRefPreSum, myCPSum, myCurLeftSum, myAccStatus)=""
	s (No, myCardNo, myPatName, myPAPMNo, myOperName, myCardStatus, myOperDate, myComIP, myAppName, myAppAddress,myAppIDType, myAppIDNo, myAppTelNo, myRemark,TPoliticalLevel,TSecretLevel,myCardType)=""
	;
	quit
OutputFR
	s Data=$lb(No, myCardNo, myPatName, myPAPMNo, myOperName, myCardStatus, myOperDate, myComIP, myAppName, myAppAddress,myAppIDType, myAppIDNo, myAppTelNo, myRemark,TPoliticalLevel,TSecretLevel,myCardType)
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

/// 办理卡的查询列表
Query CardInfo(CardNo As %String, UserCode As %String, StDate As %String, EndDate As %String, PAPMINo As %String, PatName As %String, Sex As %String) As %Query(ROWSPEC = "No:%String,TPatName:%String,TSex:%String,TDOB:%String,TCardNo:%String,TPAPMINo:%String,TCredType:%String,TCredFlag:%String,TCFDateTime:%String,TCardStatus:%String")
{
}

Query ReadCardExInfo(CardNo As %String, UserCode As %String, StDate As %String, EndDate As %String, CardStatus As %String, UserCodeA As %String) As %Query(ROWSPEC = "No:%String:序号, CardNo:%String:卡号, PatName:%String:姓名, PAPMNo:%String:登记号, OperName:%String:操作员, CardStatus:%String:卡状态, OperDate:%String:操作时间, ComIP:%String:办理机器, AppName:%String:申请人姓名, AppAddress:%String:申请人地址, AppIDType:%String:申请人证件类型, AppIDNo:%String:申请人证件号码, AppTelNo:%String:申请人电话号码, Remark:%String:备注,TPoliticalLevel:%String:患者级别,TSecretLevel:%String:患者密级,TCardType:%String:卡类型")
{
}

/// w ##class(web.UDHCAccCardManage).GetCardTypeStatus()
ClassMethod GetCardTypeStatus()
{
	s json="["
	s myCardStatusCode="N" s myCardStatus="正常"
	s OneJsonData="{""text"":"""_myCardStatus_""",""id"":"""_myCardStatusCode_""""_""
	s OneJsonData=OneJsonData_"}"
	s json=json_OneJsonData
	s myCardStatusCode="S" s myCardStatus="挂失"
	s OneJsonData="{""text"":"""_myCardStatus_""",""id"":"""_myCardStatusCode_""""_""
	s OneJsonData=OneJsonData_"}"
	s json=json_","_OneJsonData
	s myCardStatusCode="R" s myCardStatus="回收"
	s OneJsonData="{""text"":"""_myCardStatus_""",""id"":"""_myCardStatusCode_""""_""
	s OneJsonData=OneJsonData_"}"
	s json=json_","_OneJsonData
	s myCardStatusCode="D" s myCardStatus="作废"
	s OneJsonData="{""text"":"""_myCardStatus_""",""id"":"""_myCardStatusCode_""""_""
	s OneJsonData=OneJsonData_"}"
	s json=json_","_OneJsonData
	s myCardStatusCode="STD" s myCardStatus="补卡后作废"
	s OneJsonData="{""text"":"""_myCardStatus_""",""id"":"""_myCardStatusCode_""""_""
	s OneJsonData=OneJsonData_"}"
	s json=json_","_OneJsonData
	s myCardStatusCode="ETD" s myCardStatus="换卡后作废"
	s OneJsonData="{""text"":"""_myCardStatus_""",""id"":"""_myCardStatusCode_""""_""
	s OneJsonData=OneJsonData_"}"
	s json=json_","_OneJsonData
	s myCardStatusCode="E" s myCardStatus="换卡后有效"
	s OneJsonData="{""text"":"""_myCardStatus_""",""id"":"""_myCardStatusCode_""""_""
	s OneJsonData=OneJsonData_"}"
	s json=json_","_OneJsonData
	s myCardStatusCode="RN" s myCardStatus="补卡后有效"
	s OneJsonData="{""text"":"""_myCardStatus_""",""id"":"""_myCardStatusCode_""""_""
	s OneJsonData=OneJsonData_"}"
	s json=json_","_OneJsonData
	s json=json_"]"  
	q json
}

}
