Class web.DHCNURHISTORYPRINT Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod GetUserWardId(usid, loc)
{
 ///获得用户病区
  //n (usid,loc)
  //s loc=$P(^SSU("SSUSR",usid),"^",4)
  s warddes=$P(^CTLOC(loc),"^",2)
  s loctyp=$P(^CTLOC(loc),"^",13)
  q:loctyp'="W" ""  //ward
  s wardid=$O(^PAWARD(0,"WARD_LocationDR",loc,""),-1)
  s ctcpt=$P(^SSU("SSUSR",usid),"^",14)
  i $G(ctcpt)'="" s typid=$P(^CTPCP(ctcpt,1),"^",4)
  i $G(typid)'="" s typdes=$P(^CT("CPT",typid),"^",4)
  i ($G(typdes)="NURSE") s res=warddes_"^"_wardid
  s paroom=0 f  s paroom=$o(^PAADMi("CurrWard",wardid,paroom)) q:(paroom="")!($G(ctloc)'="")  d
  .s admId=0 f  s admId=$o(^PAADMi("CurrWard",wardid,paroom,admId)) q:(admId="")!($G(ctloc)'="")  d
  ..s ctlocdr=$P(^PAADM(admId),"^",4)
  ..q:ctlocdr=loc
  ..i ctlocdr'="" s ctloc=$P(^CTLOC(ctlocdr),"^",2)
  i $G(res)'="" s res=res_"|"_$G(ctloc)_"^"_$G(ctlocdr) 
  q $G(res)
}

ClassMethod GetWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetWardExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s sub=0 f  s sub=$O(^PAWARD(sub)) q:(sub="")!(sub="BED_BedType_DR")  d
    .q:$P(^PAWARD(sub),"^",6)'="Y"
    .s desc=$P(^PAWARD(sub),"^",2)
    .q:((desc'[code)&(code'=""))
   	.Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(desc,sub)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardExecute ]
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

Query GetWard(code As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod GetPrintedDataHFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintedDataHExecute ]
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

ClassMethod GetPrintedDataHExecute(ByRef qHandle As %Binary, fDateStr As %String, tDateStr As %String, curWardId As %String, loc = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	if (fDateStr="")!(tDateStr="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s resStr=-1,num=0
 //	s fromDate=$zdh(fDateStr,3),toDate=$zdh(tDateStr,3)
    s wardId=curWardId
 	s fromDate=fDateStr,toDate=tDateStr
	f pDate=fromDate:1:toDate d
	    .s pTime=""
	    .f  s pTime=$o(^DHCOrdExec(0,"PrnDate",wardId,pDate,pTime)) q:pTime=""  d
	    ..s querytyp="" f  s querytyp=$O(^DHCOrdExec(0,"PrnDate",wardId,pDate,pTime,querytyp)) q:querytyp=""  d
	    ...s user=""  f  s user=$O(^DHCOrdExec(0,"PrnDate",wardId,pDate,pTime,querytyp,user)) q:user=""  d
	    ....s pdateTime=$ZD(pDate,4)_"|"_..FormatTime(pTime)
	    ....//s wardDesc=$p(^PAWARD(wardId),"^",2)
	    ....s formType=querytyp
	    ....s FormDes=$P(^DHCCLNurseExec("VarDef",formType),"^",1)
	    ....s userDesc=$p(^SSU("SSUSR",user),"^",2)
        ....Do OutRow2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow2
	set Data=$lb(pdateTime,formType,userDesc,FormDes)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPrintedDataHClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintedDataHExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod UndoPrinted(pDateTimeStr, wardId, querytyp = "")
{
 //	&js<alert("here  "+"#(pDateTimeStr)#"+"/"+"#(wardId)#"+"/"+"#(wardId)#");>
	q:(pDateTimeStr="")!(wardId="") -3
	s pDateStr=$p(pDateTimeStr,"|",1)
	s pTimeStr=$p(pDateTimeStr,"|",2)
	q:(pDateStr="")!(pTimeStr="") -2
	//&js<alert("here  "+"#(pDateStr)#"+"/"+"#(pTimeStr)#");>
	s pDate=$zdh(pDateStr,4),pTime=$zth(pTimeStr)
	//&js<alert("  "+"#(pDate)#"+"/"+"#(pTime)#"+"/"+"#(wardId)#");>
	//s queryTypeCode=$p(^DHCCLNurseExec("Printed",pDate,pTime,wardId),"^")
	//s ^ypzTmp("printed")=pDate_","_pTime_","_wardId_"/"_querytyp
	s oeoriId=""
	s ^TM=pDate_"^"_pTime_"^"_pTimeStr_"^"_wardId_"^"_querytyp_"^"
	//s pDate=pDateStr,pTime=pTimeStr
	s user="" f  s user=$O(^DHCOrdExec(0,"PrnDate",wardId,pDate,pTime,querytyp,user)) q:user=""  d
    .s ^TM=user
    .s rw=""  f  s rw=$O(^DHCOrdExec(0,"PrnDate",wardId,pDate,pTime,querytyp,user,rw)) q:rw=""  d
	..s $P(^DHCOrdExec(rw),"^",3)="" //,$P(^DHCOrdExec(rw),"^",6)=""
    q 0
}

Query GetPrintedDataH(fDateStr As %String, tDateStr As %String, curWardId As %String, loc = "") As %Query(ROWSPEC = "pdateTime,formType,userDesc,FormDes")
{
}

ClassMethod FormatTime(timeVal As %String)
{
	q:timeVal="" ""
	q $zt(timeVal)
}

ClassMethod GetPrintedItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintedItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetPrintedItemExecute(ByRef qHandle As %Binary, pDateStr As %String, pTimeStr As %String, wardId As %String, querytyp As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s ^TM=pDateStr_"|"_pTimeStr
 	s PrintUser=%session.Data("LOGON.USERID")
 	k ^TMP("Printed",PrintUser)  //清除临时数据
 	if (pDateStr="")!(wardId="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	if (pDateStr="")!(pTimeStr="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	//&js<alert("here  "+"#(pDateStr)#"+"/"+"#(pTimeStr)#");>
 	//s pDate=$zdh(pDateStr,4),pTime=$zth(pTimeStr)
	//w !,pDateStr,"^",pTimeStr,"^",wardId,"^",querytyp
	s pDate=pDateStr,pTime=pTimeStr
	s i=0
	s ^TMP("Printed",PrintUser,"J")=$J
	s user="" f  s user=$O(^DHCOrdExec(0,"PrnDate",wardId,pDate,pTime,querytyp,user)) q:user=""  d
    .s rw=""  f  s rw=$O(^DHCOrdExec(0,"PrnDate",wardId,pDate,pTime,querytyp,user,rw)) q:rw=""  d
    ..s oeore=$P(^DHCOrdExec(rw),"^",1) 
    ..s flag=$P(^DHCOrdExec(rw),"^",3)
    ..q:flag'["Y"
    ..s ord=$P(oeore,"||"),chl=$P(oeore,"||",2)
    ..s oeoriId=ord_"||"_chl
    ..s i=i+1
    ..s ^TMP("Printed",PrintUser,$J,i)=oeoriId
	..s arcimId=$p($g(^OEORD(ord,"I",chl,1)),"^",2)
	..s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
	..s str=..patinfo(oeoriId)
	..s regNo=$P(str,"|",1)
    ..s patName=$P(str,"|",2)
    ..s bedCode=$P(str,"|",3)
    ..Do OutRow1
    s ^TMP("Printed",PrintUser,$J)=i
    set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow1
	set Data=$lb(regNo,patName,bedCode,oeoriId,arcimDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod patinfo(oeoriId)
{
	s oeordId=$P(oeoriId,"||",1)
	s papmiId=+^PAADM($p($g(^OEORD(oeordId)),"^",1))
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    s roomdr=$P(^PAADM($p($g(^OEORD(oeordId)),"^",1)),"^",69)
    s bedSub=$p($p($g(^PAADM($p($g(^OEORD(oeordId)),"^",1))),"^",73),"||",2)
    s curWardId=$p($g(^PAADM($p($g(^OEORD(oeordId)),"^",1))),"^",70)
    if (roomdr'="") s room=$P(^PAROOM(roomdr),"^",2)
    //&js<alert("come in oeore else "+"#(curWardId)#"+"/"+"#(admId)#"+"/");>
    if bedSub'="" s bedCode=$G(room)_"-"_$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    e  s bedCode=""
  q regNo_"|"_patName_"|"_bedCode
}

ClassMethod GetPrintedItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintedItemExecute ]
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

Query GetPrintedItem(pDateStr As %String, pTimeStr As %String, wardId As %String, querytyp As %String) As %Query(ROWSPEC = "regNo,patName,bedCode,oeoriId,arcimDesc")
{
}

ClassMethod GetTmpPrintedDataNum(user) As %String
{
	//n (user)
	s proc=^TMP("Printed",user,"J")
	q ^TMP("Printed",user,proc)
}

ClassMethod GetTmpPrintedData(user, num) As %String
{
 //qse add 061213
	//n (user,num)
	s proc=^TMP("Printed",user,"J")
	q ^TMP("Printed",user,proc,num)
}

Storage Default
{
<Data name="DHCNURHISTORYPRINTDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCNURHISTORYPRINTD</DataLocation>
<DefaultData>DHCNURHISTORYPRINTDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCNURHISTORYPRINTD</IdLocation>
<IndexLocation>^web.DHCNURHISTORYPRINTI</IndexLocation>
<StreamLocation>^web.DHCNURHISTORYPRINTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
