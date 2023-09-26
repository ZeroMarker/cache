Import SQLUser

Class web.DHCBPMessage Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPMessage","FindBPMessage",38)
Query FindBPMessage(bpprId As %String) As %Query(ROWSPEC = "Desc,LatestDate,ComfirmDate,bpcmId,userDesc,FreqMonth")
{
}

ClassMethod FindBPMessageExecute(ByRef qHandle As %Binary, bpprId As %String) As %Status
{
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s isSingle=1
	s bpcmCode=""
	f  s bpcmCode=$o(^DHCBPC("Message",0,"CodePat",bpcmCode)) q:bpcmCode=""  d
		.s bpcmId="",userDesc=""
		.i bpprId'="" s bpcmId=$o(^DHCBPC("Message",0,"CodePat",bpcmCode,bpprId,""))
		.i bpcmId="" s bpcmId=$o(^DHCBPC("Message",0,"CodePat",bpcmCode,0,""))
		.q:bpcmId=""
		.s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.s bpcmDesc=$lg(^DHCBPC("Message",bpcmId),2)
		.s bpcmSourceType=$lg(^DHCBPC("Message",bpcmId),3)
		.s bpcmFreqMonth=$lg(^DHCBPC("Message",bpcmId),5)
		.s bpcmAheadDay=$lg(^DHCBPC("Message",bpcmId),6)
		.i bpcmSourceType="L" d
			..s bpprDate=$lg(^DHCBPPatRegister(bpprId),8)
			..s STX=$c(2)
			..s ETX=$c(3)
			..s testStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", bpcmCode, bpprDate, "0", $h, "0", isSingle)		
			..s latestDate=$p(testStr,STX,4)
			..s durFromDate=latestDate
			..i durFromDate="" s durFromDate=bpprDate
			..s durMonth=##class(web.DHCClinicCom).CalAge(latestDate,($h+bpcmAheadDay),0,"M")
			..s patBPNo=$lg(^DHCBPPatRegister(bpprId),17)
			..//w bpprId_"/"_patBPNo_"/"_bpprDate_"/"_durMonth_"/"_testStr,!
			..q:##class(web.DHCClinicCom).CalAge(latestDate,($h+bpcmAheadDay),0,"M")<bpcmFreqMonth
			..s bpmDate=$o(^DHCBPMessage(0,"MessPatDate",bpcmId,bpprId,""),-1)
			..i bpmDate'="" d
			...s bpmId=$o(^DHCBPMessage(0,"MessPatDate",bpcmId,bpprId,bpmDate,""),-1)			
			...i bpmId'="" s userId=$lg(^DHCBPMessage(bpmId),6)
			...i userId'="" s userDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
			..;i bpmDate<latestDate s bpmDate=""
			..i bpmDate>latestDate s bpmDate=$zd(bpmDate,3)
			..e  s bpmDate="",userDesc=""
			..i latestDate'="" s latestDate=$zd(latestDate,3)			
			..d OutputRow

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	set Data=$lb(bpcmDesc,latestDate,bpmDate,bpcmId,userDesc,bpcmFreqMonth)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPMessageExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBPMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPMessageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 批量保存血液净化消息数据
/// orderParaList由血液净化消息数据串拼接而成，以"^"分割。数据串以$c(3)分割，按照表DHC_BP_Message的SqlColumnNumber顺序拼接而成。
/// 返回结果为0
/// s messageParaList=1_$c(3)_38_$c(3)_$c(3)_$c(3)_"test"_$c(3)_221_"^"_2_$c(3)_38_$c(3)_$c(3)_$c(3)_"test"_$c(3)_221
/// w ##class(web.DHCBPMessage).SaveBPMessage(messageParaList)
ClassMethod SaveBPMessage(messageParaList As %String(MAXLEN=65535)) As %String
{
	s result="0"
	f i=1:1:$l(messageParaList,"^")  d
		.s messagePara=$p(messageParaList,"^",i)
		.q:messagePara=""
		.s obj=##class(User.DHCBPMessage).%New()
		.s obj.BPMBPCMDr=##class(User.DHCBPCMessage).%OpenId($p(messagePara,$c(3),1))
		.s obj.BPMBPPatRegisterDr=$p(messagePara,$c(3),2)
		.s obj.BPMDate=+$h
		.s obj.BPMTime=$p($h,",",2)
		.s obj.BPMNote=$p(messagePara,$c(3),5)
		.s obj.BPMUserDr=$p(messagePara,$c(3),6)
		.s result=obj.%Save()
		.d obj.%Close()
	q result
}

/// 查询
/// d ##class(%ResultSet).RunQuery("web.DHCBPMessage","GetBPCMessage")
/// 
Query GetBPCMessage(BPCMDesc As %String = "") As %Query(ROWSPEC = "tRowId:%String,tDBPCMCode:%String,tDBPCMDesc:%String,tBPCMSourceType:%String,tBPCMReceiveType:%String,tBPCMFreqMonth:%String,tBPCMAheadDay:%String,tBPCMFixedMonth:%String,tBPCMBPPatRegisterDr:%String")
{
}

ClassMethod GetBPCMessageExecute(ByRef qHandle As %Binary, BPCMDesc As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tRowId=0
	for  s tRowId=$o(^DHCBPC("Message",tRowId)) q:tRowId=""  d
	.s tBPCMCode=$lg(^DHCBPC("Message",tRowId),1)
	.s tBPCMDesc=$lg(^DHCBPC("Message",tRowId),2)
	.q:(BPCMDesc'="")&&(BPCMDesc'=tBPCMDesc)
	.s tBPCMSourceType=$lg(^DHCBPC("Message",tRowId),3)
	.s tBPCMReceiveType=$lg(^DHCBPC("Message",tRowId),4)
	.s tBPCMFreqMonth=$lg(^DHCBPC("Message",tRowId),5)
	.s tBPCMAheadMonth=$lg(^DHCBPC("Message",tRowId),6)
	.s tBPCMFixedMonth=$lg(^DHCBPC("Message",tRowId),7)
	.s tBPCMBPPatRegisterDr=$lg(^DHCBPC("Message",tRowId),8)
	.d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tRowId,tBPCMCode,tBPCMDesc,tBPCMSourceType,tBPCMReceiveType,tBPCMFreqMonth,tBPCMAheadMonth,tBPCMFixedMonth,tBPCMBPPatRegisterDr)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetBPCMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBPCMessageExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetBPCMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBPCMessageExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
