Class DHCWL.Query Extends %Persistent
{

ClassMethod BedNum(Date, LocOrWardFlag, LocOrWardId) As %String
{
	s MRRowId=""
	s Return=0_"^"_0_"^"_0
	i $d(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId))  d
	.s MRRowId=$o(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId,"")) ;Only One
	e  d
	.s Date=$o(^DHCMRBed(0,LocOrWardFlag,LocOrWardId,"Date",Date),-1)
	.i Date'="" s MRRowId=$o(^DHCMRBed(0,"Date",Date,LocOrWardFlag,LocOrWardId,"")) ;Only One Or No Exist
	q:MRRowId="" Return
	s MRGDNum=$p(^DHCMRBed(MRRowId),"^",3)
	s MRSYNum=$p(^DHCMRBed(MRRowId),"^",4)
	s MRBZNum=$p(^DHCMRBed(MRRowId),"^",5)
	s Return=MRGDNum_"^"_MRSYNum_"^"_MRBZNum
	q Return
}

ClassMethod GetOutFee(BeginDate, EndDate, Scope, SessionId)
{
	s sDate=$zdh(BeginDate,3)
	s eDate=$zdh(EndDate,3)
	f day=sDate:1:eDate d
	.s wlRowid=0 f  s wlRowid=$o(^DHCWorkLoad(0,"ORDDATE",day,wlRowid)) q:wlRowid=""  d
	..q:$p(^DHCWorkLoad(wlRowid),"^",4)'="O"
	..q:($p(^DHCWorkLoad(wlRowid),"^",3)'=Scope)&(Scope'="")
	..s adm=$p(^DHCWorkLoad(wlRowid),"^",12) //adm号
	..s admFee=$p(^DHCWorkLoad(wlRowid),"^",16) //费用
	..s ^TEMPQuery(SessionId,"Adm",adm)=$g(^TEMPQuery(SessionId,"Adm",adm))+$g(admFee)
	s allAdmNum=0
	s admRowid=0 f  s admRowid=$o(^TEMPQuery(SessionId,"Adm",admRowid)) q:admRowid=""  d
	.s allFee=$g(allFee)+$g(^TEMPQuery(SessionId,"Adm",admRowid))
	.s allAdmNum=$g(allAdmNum)+1
	i +$g(allAdmNum)>0 s tmpFee=+$g(allFee)/$g(allAdmNum)
	i +$g(allAdmNum)<1 s tmpFee=0
	s ^TEMPQuery(SessionId,"Result",1)="门诊总收入^"_$j($g(allFee),2,2)_"^1^O"
	s ^TEMPQuery(SessionId,"Result",2)="门诊人次^"_$j($g(allAdmNum),2,2)_"^2^O"
	s ^TEMPQuery(SessionId,"Result",3)="诊次收入^"_$j($g(tmpFee),2,2)_"^3^O"
	q
}

ClassMethod GetInPutFee(BeginDate, EndDate, Scope, SessionId)
{
	s sDate=$zdh(BeginDate,3)
	s eDate=$zdh(EndDate,3)
	f day=sDate:1:eDate d
	.s wlRowid=0 f  s wlRowid=$o(^DHCWorkLoad(0,"ORDDATE",day,wlRowid)) q:wlRowid=""  d
	..q:$p(^DHCWorkLoad(wlRowid),"^",4)'="I"
	..q:($p(^DHCWorkLoad(wlRowid),"^",3)'=Scope)&(Scope'="")
	..s admFee=$p(^DHCWorkLoad(wlRowid),"^",16) //费用
	..s allFee=$g(allFee)+$g(admFee)
	.s mrRowid=0 f  s mrRowid=$o(^MRIPdaily("MRIP_DATE",day,mrRowid)) q:mrRowid=""  d
	..s locDr=$p(^MRIPdaily(mrRowid),"^",7)
	..q:locDr=""
	..q:(locDr'=Scope)&(Scope'="")
	..s xycr=$p(^MRIPdaily(mrRowid),"^",18)+$g(xycr)
	..s tmpSYCR=""
	..s tmpSYCR=..BedNum(day,"Loc",locDr)
	..s sycs=$p(tmpSYCR,"^",2)+$g(sycs)
	i +$g(xycr)>0 s crsr=allFee/xycr
	i +$g(sycs)>0 s bcsyl=$j((+$g(xycr)/sycs)*100,2,2)_"%"
	i +$g(sycs)<1 s bcsyl="0.00%"
	s ^TEMPQuery(SessionId,"Result",1)="住院总收入^"_$j(+$g(allFee),2,2)_"^1^I"
	s ^TEMPQuery(SessionId,"Result",2)="实际占用床日^"_$j(+$g(xycr),2,2)_"^2^I"
	s ^TEMPQuery(SessionId,"Result",3)="床日收入^"_$j(+$g(crsr),2,2)_"^3^I"
	s ^TEMPQuery(SessionId,"Result",4)="病床使用率^"_bcsyl_"^4^I"
	q
}

ClassMethod GetDataSumaryExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, IoFlag As %String, Scope As %String, SessionId As %Integer) As %Status
{
	k ^TEMPQuery(SessionId)
	Set repid=$I(^CacheTemp)
    s ind=1
	i IoFlag="O" d ..GetOutFee(BeginDate,EndDate,Scope,SessionId) 
	i IoFlag="I" d ..GetInPutFee(BeginDate,EndDate,Scope,SessionId)
	;s rowid=0 f  s rowid=$o(^TEMPQuery(SessionId,"Result",rowid)) q:rowid=""  d
	;.s DataPartName=$p(^TEMPQuery(SessionId,"Result",rowid),"^",1)
	;.s DataPartValue=$p(^TEMPQuery(SessionId,"Result",rowid),"^",2)
	;.s DataPartId=$p(^TEMPQuery(SessionId,"Result",rowid),"^",3)
	;.s IoFalg=$p(^TEMPQuery(SessionId,"Result",rowid),"^",4)
	;.d OutputRow1
	i '$d(^TEMPQuery(SessionId)) s ^TEMPQuery(SessionId)=""
    Set qHandle=$lb(0,repid,0)
    
	Quit $$$OK
OutputRow1
	set Data=$lb(DataPartName,DataPartValue,DataPartId,IoFalg)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	Quit $$$OK
}

ClassMethod GetDataSumaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataSumaryExecute ]
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
	Quit $$$OK
}

ClassMethod GetDataSumaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataSumaryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//sDate,eDate(格式 2009-09-01) admType(I 住院;O 门诊;E 急诊;空 全部)

Query GetDataSumary(BeginDate, EndDate, IoFlag, Scope, SessionId) As %Query(ROWSPEC = "DataPartName:%String,DataPartValue:%String,DataPartId:%String,IoFalg:%String")
{
}

ClassMethod GetFeeDetail(BeginDate, EndDate, DataPartId, Scope, SessionId)
{
	i DataPartId=1 s type="O"
	i DataPartId=4 s type="I"
	s sDate=$zdh(BeginDate,3)
	s eDate=$zdh(EndDate,3)
	f day=sDate:1:eDate d
	.s wlRowid=0 f  s wlRowid=$o(^DHCWorkLoad(0,"ORDDATE",day,wlRowid)) q:wlRowid=""  d
	..q:$p(^DHCWorkLoad(wlRowid),"^",4)'=type
	..s ctLoc=$p(^DHCWorkLoad(wlRowid),"^",3)
	..q:(ctLoc'=Scope)&(Scope'="")
	..s totalPrice=$p(^DHCWorkLoad(wlRowid),"^",16)
	..s ^TEMPQuery(SessionId,"LocFee",ctLoc)=$g(^TEMPQuery(SessionId,"LocFee",ctLoc))+$g(totalPrice)	
	s num=1
	s locDr=0 f  s locDr=$o(^TEMPQuery(SessionId,"LocFee",locDr)) q:locDr=""  d
	.s locCode=$p(^CTLOC(locDr),"^",1)
	.s locDesc=$p(^CTLOC(locDr),"^",2)
	.s locFee=$g(^TEMPQuery(SessionId,"LocFee",locDr))
	.s ^TEMPQuery(SessionId,"Result",num)=$g(locCode)_"^"_$g(locDesc)_"^"_$g(locFee)
	.s num=num+1
	q
}

ClassMethod GetAdmNum(BeginDate, EndDate, DataPartId, Scope, SessionId)
{
	s sDate=$zdh(BeginDate,3)
	s eDate=$zdh(EndDate,3)
	f day=sDate:1:eDate d
	.s wlRowid=0 f  s wlRowid=$o(^DHCWorkLoad(0,"ORDDATE",day,wlRowid)) q:wlRowid=""  d
	..q:$p(^DHCWorkLoad(wlRowid),"^",4)'="O"
	..s ctLoc=$p(^DHCWorkLoad(wlRowid),"^",3)
	..q:(ctLoc'=Scope)&(Scope'="")
	..s adm=$p(^DHCWorkLoad(wlRowid),"^",12)
	..s admFee=$p(^DHCWorkLoad(wlRowid),"^",16)
	..s ^TEMPQuery(SessionId,"LocNum",ctLoc,adm)=$g(^TEMPQuery(SessionId,"LocNum",ctLoc,adm))+$g(admFee)
	s num=1
	s locDr=0 f  s locDr=$o(^TEMPQuery(SessionId,"LocNum",locDr)) q:locDr=""  d
	.s locNum=0,admFee=0
	.s admRowid=0 f  s admRowid=$o(^TEMPQuery(SessionId,"LocNum",locDr,admRowid)) q:admRowid=""  d
	..s locNum=locNum+1
	..s admFee=$g(admFee)+$g(^TEMPQuery(SessionId,"LocNum",locDr,admRowid))
	.s locCode=$p(^CTLOC(locDr),"^",1)
	.s locDesc=$p(^CTLOC(locDr),"^",2)
	.i DataPartId=2 s reValue=locNum
	.i (DataPartId=3)&(locNum'=0) s reValue=$j((admFee/locNum),2,2)
	.s ^TEMPQuery(SessionId,"Result",num)=$g(locCode)_"^"_$g(locDesc)_"^"_$g(reValue)
	.s num=num+1
	q
}

ClassMethod GetMRIPDay(BeginDate, EndDate, DataPartId, Scope, SessionId)
{
	s sDate=$zdh(BeginDate,3)
	s eDate=$zdh(EndDate,3)
	f day=sDate:1:eDate d
	.s wlRowid=0 f  s wlRowid=$o(^DHCWorkLoad(0,"ORDDATE",day,wlRowid)) q:wlRowid=""  d
	..q:$p(^DHCWorkLoad(wlRowid),"^",4)'="I"
	..q:($p(^DHCWorkLoad(wlRowid),"^",3)'=Scope)&(Scope'="")
	..s admFee=$p(^DHCWorkLoad(wlRowid),"^",16) //费用
	..s ctLoc=$p(^DHCWorkLoad(wlRowid),"^",3)
	..s ^TEMPQuery(SessionId,ctLoc,"LocFee")=$g(^TEMPQuery(SessionId,ctLoc,"LocFee"))+$g(admFee)
	.s mrRowid=0 f  s mrRowid=$o(^MRIPdaily("MRIP_DATE",day,mrRowid)) q:mrRowid=""  d
	..s locDr=$p(^MRIPdaily(mrRowid),"^",7)
	..q:locDr=""
	..q:(locDr'=Scope)&(Scope'="")
	..s xycs=$p(^MRIPdaily(mrRowid),"^",18)
	..s tmpSYCR=..BedNum(day,"Loc",locDr)
	..s sycs=$p(tmpSYCR,"^",2)
	..s ^TEMPQuery(SessionId,locDr,"XYCS")=$g(^TEMPQuery(SessionId,locDr,"XYCS"))+xycs
	..s ^TEMPQuery(SessionId,locDr,"SYCS")=$g(^TEMPQuery(SessionId,locDr,"SYCS"))+sycs
	s num=1
	s locRowid=0 f  s locRowid=$o(^TEMPQuery(SessionId,locRowid)) q:+$g(locRowid)=0  d
	.s locCode=$p(^CTLOC(locRowid),"^",1)
	.s locDesc=$p(^CTLOC(locRowid),"^",2)
	.s reValue=""
	.i DataPartId=5 s reValue=$g(^TEMPQuery(SessionId,locRowid,"XYCS"))
	.i DataPartId=6 d
	..s xycs=$g(^TEMPQuery(SessionId,locRowid,"XYCS"))
	..i +$g(xycs)'=0 s reValue=SessionId($g(^TEMPQuery(SessionId,locRowid,"LocFee"))/xycs,2,2)
	.i DataPartId=7 d
	..s xycs=$g(^TEMPQuery(SessionId,locRowid,"XYCS"))
	..s sycs=$g(^TEMPQuery(SessionId,locRowid,"SYCS"))
	..i +$g(sycs)'=0 s reValue=$j((xycs/sycs),2,4)*100_"%"
	.q:$g(reValue)=""
	.s ^TEMPQuery(SessionId,"Result",num)=$g(locCode)_"^"_$g(locDesc)_"^"_$g(reValue)
	.s num=num+1
}

ClassMethod GetDataDetailsExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, DataPartId As %String, Scope As %String, SessionId As %Integer) As %Status
{
	k ^TEMPQuery(SessionId)
	Set repid=$I(^CacheTemp)
    s ind=1
	i (DataPartId=1)!(DataPartId=4) d ..GetFeeDetail(BeginDate,EndDate,DataPartId,Scope,SessionId)
	i (DataPartId=2)!(DataPartId=3) d ..GetAdmNum(BeginDate,EndDate,DataPartId,Scope,SessionId)
	i (DataPartId=5)!(DataPartId=6)!(DataPartId=7) d ..GetMRIPDay(BeginDate,EndDate,DataPartId,Scope,SessionId)
    ;s num=0 f  s num=$o(^TEMPQuery(SessionId,"Result",num)) q:num=""  d
    ;.s DeptId=$p(^TEMPQuery(SessionId,"Result",num),"^",1)
    ;.s DeptName=$p(^TEMPQuery(SessionId,"Result",num),"^",2)
    ;.s Values=$p(^TEMPQuery(SessionId,"Result",num),"^",3)
    ;.Do OutputRow1
    i '$d(^TEMPQuery(SessionId)) s ^TEMPQuery(SessionId)=""
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(DeptId,DeptName,Values)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	Quit $$$OK
}

ClassMethod GetDataDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataDetailsExecute ]
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
	Quit $$$OK
}

ClassMethod GetDataDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataDetailsExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//sDate,eDate(格式 2009-09-01) admType(I 住院;O 门诊;E 急诊;空 全部)

Query GetDataDetails(BeginDate, EndDate, DataPartId, Scope, SessionId) As %Query(ROWSPEC = "DeptId:%String,DeptName:%String,Values:%String")
{
}

ClassMethod GetDataSumaryDataSetExecute(ByRef qHandle As %Binary, SessionId As %Integer) As %Status
{
	
	Set repid=$I(^CacheTemp)
    s ind=1
	s rowid=0 f  s rowid=$o(^TEMPQuery(SessionId,"Result",rowid)) q:rowid=""  d
	.s DataPartName=$p(^TEMPQuery(SessionId,"Result",rowid),"^",1)
	.s DataPartValue=$p(^TEMPQuery(SessionId,"Result",rowid),"^",2)
	.s DataPartId=$p(^TEMPQuery(SessionId,"Result",rowid),"^",3)
	.s IoFalg=$p(^TEMPQuery(SessionId,"Result",rowid),"^",4)
	.d OutputRow1
    Set qHandle=$lb(0,repid,0)
    
	Quit $$$OK
OutputRow1
	set Data=$lb(DataPartName,DataPartValue,DataPartId,IoFalg)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	Quit $$$OK
}

ClassMethod GetDataSumaryDataSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataSumaryDataSetExecute ]
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
	Quit $$$OK
}

ClassMethod GetDataSumaryDataSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataSumaryDataSetExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//sDate,eDate(格式 2009-09-01) admType(I 住院;O 门诊;E 急诊;空 全部)

Query GetDataSumaryDataSet(SessionId) As %Query(ROWSPEC = "DataPartName:%String,DataPartValue:%String,DataPartId:%String,IoFalg:%String")
{
}

ClassMethod GetDataDetailsDataSetExecute(ByRef qHandle As %Binary, SessionId As %Integer) As %Status
{
	
	Set repid=$I(^CacheTemp)
    s ind=1
	s rowid=0 f  s rowid=$o(^TEMPQuery(SessionId,"Result",rowid)) q:rowid=""  d
	.s DataPartName=$p(^TEMPQuery(SessionId,"Result",rowid),"^",1)
	.s DataPartValue=$p(^TEMPQuery(SessionId,"Result",rowid),"^",2)
	.s DataPartId=$p(^TEMPQuery(SessionId,"Result",rowid),"^",3)
	.s IoFalg=$p(^TEMPQuery(SessionId,"Result",rowid),"^",4)
	.d OutputRow1
    Set qHandle=$lb(0,repid,0)
    
	Quit $$$OK
OutputRow1
	set Data=$lb(DataPartName,DataPartValue,DataPartId,IoFalg)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	Quit $$$OK
}

ClassMethod GetDataDetailsDataSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataDetailsDataSetExecute ]
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
	Quit $$$OK
}

ClassMethod GetDataDetailsDataSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataDetailsDataSetExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//sDate,eDate(格式 2009-09-01) admType(I 住院;O 门诊;E 急诊;空 全部)

Query GetDataDetailsDataSet(SessionId) As %Query(ROWSPEC = "DataPartName:%String,DataPartValue:%String,DataPartId:%String,IoFalg:%String")
{
}

Storage Default
{
<Data name="QueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCWL.QueryD</DataLocation>
<DefaultData>QueryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.QueryD</IdLocation>
<IndexLocation>^DHCWL.QueryI</IndexLocation>
<StreamLocation>^DHCWL.QueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
