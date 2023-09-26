Class web.DHCBPCMessage Extends %RegisteredObject
{

/// 查询
/// d ##class(%ResultSet).RunQuery("web.DHCBPCMessage","GetBPCMessage")
/// 
Query GetBPCMessage(BPCMDesc As %String = "", LocId As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,SourceType:%String,ReceiveType:%String,FreqMonth:%String,AheadDay:%String,FixedMonth:%String,BPPatRegisterId:%String,PatName:%String,PatBPNo:%String,RegNo:%String,PapmiMedicare:%String")
{
}

ClassMethod GetBPCMessageExecute(ByRef qHandle As %Binary, BPCMDesc As %String = "", LocId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s bpcmCode=""
 	f  s bpcmCode=$o(^DHCBPC("Message",0,"CodePat",bpcmCode)) q:bpcmCode=""  d
 		.s bpprId=""
 		.f  s bpprId=$o(^DHCBPC("Message",0,"CodePat",bpcmCode,bpprId)) q:bpprId=""  d
			..s tRowId=$o(^DHCBPC("Message",0,"CodePat",bpcmCode,bpprId,""))
			..q:tRowId=""
			..s tBPCMDesc=$lg(^DHCBPC("Message",tRowId),2)
			..q:(BPCMDesc'="")&&(BPCMDesc'=tBPCMDesc)
			..s tBPCMSourceType=$lg(^DHCBPC("Message",tRowId),3)
			..s tBPCMReceiveType=$lg(^DHCBPC("Message",tRowId),4)
			..s tBPCMFreqMonth=$lg(^DHCBPC("Message",tRowId),5)
			..s tBPCMAheadMonth=$lg(^DHCBPC("Message",tRowId),6)
			..s tBPCMFixedMonth=$lg(^DHCBPC("Message",tRowId),7)
			..//s bpprId=$lg(^DHCBPC("Message",tRowId),8)
			..s patName="",patBPNo="",regNo="",papmiMedicare="",patLocId="",patStatus=""
			..i +bpprId>0 d
				...s patBPNo=$lg($g(^DHCBPPatRegister(+bpprId)),17)
				...s papmiId=$lg($g(^DHCBPPatRegister(+bpprId)),1)
				...s regNo=$p($g(^PAPER(+papmiId,"PAT",1)),"^",1)
				...//s papmiMedicare=$p($g(^PAPER(+papmiId,"PAT",1)),"^",22) //20200515统一走病案接口
				...s admId=$lg($g(^DHCBPPatRegister(+bpprId)),26)
				...q:admId=""
				...s paadmtype=$p($g(^PAADM(admId)),"^",2)
				...s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
				...s patName=$p($g(^PAPER(+papmiId,"ALL")),"^",1)
				...s patLocId=$lg($g(^DHCBPPatRegister(+bpprId)),34)			
				...s patStatus=$lg($g(^DHCBPPatRegister(+bpprId)),14)
			..q:(patStatus'="")&&(patStatus="D")
			..q:(LocId'="")&&(patLocId'="")&&(patLocId'=LocId)
			..d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tRowId,bpcmCode,tBPCMDesc,tBPCMSourceType,tBPCMReceiveType,tBPCMFreqMonth,tBPCMAheadMonth,tBPCMFixedMonth,bpprId,patName,patBPNo,regNo,papmiMedicare)
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

/// 批量保存血液净化消息码表数据
/// orderParaList由血液净化消息数据串拼接而成，以"^"分割的多个bpPatRegisterId。数据串以$c(3)分割，按照表DHC_BPC_Message的SqlColumnNumber顺序拼接而成。
/// 返回结果为0
/// 
/// w ##class(web.DHCBPCMessage).SaveBPCMessage("HBSAG","乙肝","L","P","1","7","","")
ClassMethod SaveBPCMessage(bpcmCode As %String, bpcmDesc As %String, bpcmSourceType As %String, bpcmReceiveType As %String, bpcmFreqMonth As %String, bpcmAheadDay As %String, bpcmFixedMonth As %String, bpPatRegisterIdStr As %String(MAXLEN=65535)) As %String
{
	q:bpcmCode="" ""
	s result="0"
	f i=1:1:$l(bpPatRegisterIdStr,"^")  d
		.s bpPatRegisterId=+$p(bpPatRegisterIdStr,"^",i)
		.s bpcmId=$o(^DHCBPC("Message",0,"CodePat",bpcmCode,bpPatRegisterId,""),-1)
		.i bpcmId="" s obj=##class(User.DHCBPCMessage).%New()
		.e  s obj=##class(User.DHCBPCMessage).%OpenId(bpcmId)
		.q:obj=""
		.s obj.BPCMCode=bpcmCode
		.s obj.BPCMDesc=bpcmDesc
		.s obj.BPCMSourceType=bpcmSourceType
		.s obj.BPCMReceiveType=bpcmReceiveType
		.s obj.BPCMFreqMonth=bpcmFreqMonth
		.s obj.BPCMAheadDay=bpcmAheadDay
		.s obj.BPCMFixedMonth=bpcmFixedMonth
		.s obj.BPCMBPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(bpPatRegisterId)
		.s result=obj.%Save()
		.d obj.%Close()
	q +result
}

/// w ##class(web.DHCBPCMessage)DeleteBPCMessage("HBSAG","14")
ClassMethod DeleteBPCMessage(bpcmCode, bpPatRegisterId) As %String
{
	q:(bpcmCode="") "代码不能为空!"
	s bpcmId=$o(^DHCBPC("Message",0,"CodePat",bpcmCode,+bpPatRegisterId,""))
	w bpcmId,!
	q:bpcmId="" "ID不能为空!"
	q:'##class(User.DHCBPCMessage).%ExistsId(bpcmId) "指针无对应记录!"
	s deleteStatus=##class(User.DHCBPCMessage).%DeleteId(bpcmId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

}
