Import SQLUser

Include Nur.DateFormat

/// 病人的其他数据维护
/// web.DHCADMQTREC
Class web.DHCADMQTREC Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 3;

// 判断病人是否分配过床位

// 返回1表示分过床位

ClassMethod GetAdmTransBed(EpisodeID As %String = "") As %String
{
	n (EpisodeID)
    q:EpisodeID="" ""
    s TRANSChildsub=0,Flag=0
    f  s TRANSChildsub=$o(^PAADM(EpisodeID,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(Flag=1)  d
    .s TRANBed=$p(^PAADM(EpisodeID,"TRANS",TRANSChildsub),"^",8)
    .q:TRANBed=""
    .i TRANBed'="" s Flag=1 q
    q Flag
}

// 判断病人转科后是否分配过床位

// 返回1表示分过床位

ClassMethod GetAdmTransLocBedOLD(Adm As %String)
{
    n (Adm)
    s flag=0,flag1=0
  	s chl="" f  s chl=$O(^PAADM(Adm,"TRANS",chl),-1) q:(chl="")!(flag1=1)!(flag=1)  d
  	.s loc=$P(^PAADM(Adm,"TRANS",chl),"^",6)
  	.s stdate=$P(^PAADM(Adm,"TRANS",chl),"^",1)
  	.s sttime=$P(^PAADM(Adm,"TRANS",chl),"^",2)
  	.s enddate=$P(^PAADM(Adm,"TRANS",chl),"^",3)
    .s endtime=$P(^PAADM(Adm,"TRANS",chl),"^",4)
    .s transward=$P(^PAADM(Adm,"TRANS",chl),"^",9)
    .s transbed=$P(^PAADM(Adm,"TRANS",chl),"^",8)
    .i (transward'="")&&(transbed="") s flag1=1 q
    .i (transward'="")&&(transbed'="") s flag=1 q
    q flag
}

// 判断病人转科后是否分配过床位

// 返回1表示分过床位

ClassMethod GetAdmTransLocBed(Adm As %String)
{
    n (Adm)
    s TransBed=..GetAdmTransBed(Adm)
    q:TransBed="0" "1"
    s flag=0,flag1=0,oldloc="",oldstdate="",oldsttime=""
  	s chl="" f  s chl=$O(^PAADM(Adm,"TRANS",chl),-1) q:(chl="")!(flag1=1)  d
  	.s loc=$P(^PAADM(Adm,"TRANS",chl),"^",6)  //科室
  	.i (oldloc'=loc)&&(oldloc'="")&&(loc'="") s flag1=1 q
  	.i loc'="" s data(loc)=chl,oldloc=loc
  	s num="" s num=$o(data(num)) q:num="" 0
  	s num=data(num)
  	s sub="" f  s sub=$O(^PAADM(Adm,"TRANS",sub),-1) q:(sub="")!(sub<num)!(flag=1)  d
  	.s transbed=$P(^PAADM(Adm,"TRANS",sub),"^",8)
  	.i transbed'="" s flag=1 q
    q flag
}

ClassMethod QtDelete(rowid As %String) As %String
{
	&sql(delete from DHC_ADMQTREC where QTREC_ROWID=:rowid)
	q SQLCODE
}

ClassMethod QtInsert(Adm As %String, ADate As %String, ATime As %String, Typ As %String, user As %String, orderId = "") As %String
{
	n (Adm ,ADate,ATime,Typ ,user,orderId)
	s PLIST(2)=Adm
	i ADate="" s PLIST(3)=+$h
	e  s PLIST(3)=$$$ZDH(ADate,3)
	i ATime="" s PLIST(4)=$p($h,",",2)
	e  s PLIST(4)=##class(websys.Conversions).TimeHtmlToLogical(ATime)
	s PLIST(5)=Typ
	s PLIST(6)=$P($H,",")
	s PLIST(7)=$P($H,",",2)
	s PLIST(8)=user
	i orderId'="" d
	.s PLIST(9)=orderId
	&sql(insert into DHC_ADMQTREC values PLIST())
	q SQLCODE
}

ClassMethod QtUpdate(rowid As %String, ADate As %String, ATime As %String, Typ As %String, user As %String) As %String
{
  &sql(select *  into PLIST() from DHC_ADMQTREC where QTREC_ROWID=:rowid)
  i ADate="" s PLIST(3)=+$h
  e  s PLIST(3)=$$$ZDH(ADate,3)
  i ATime="" s PLIST(4)=$p($h,",",2)
  e  s PLIST(4)=$ZTH(ATime)
  s PLIST(5)=Typ
  s PLIST(6)=$P($H,",")
  s PLIST(7)=$P($H,",",1)
  s PLIST(8)=user
  &sql(update DHC_ADMQTREC values PLIST() where QTREC_ROWID=:rowid)
  q SQLCODE
}

ClassMethod QtListExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=##class(web.DHCADMQTREC).QtPatAdmDate(Adm)
	s ret=##class(web.DHCThreeNew).SyncEventByOrder(Adm)
	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:rw=""  d
	.s ADate=$P(^DHCADMQTREC("QTREC",rw),"^",2)
	.if ADate'="" s ADate=$$$ZD(ADate,3)
	.s ATime=$P(^DHCADMQTREC("QTREC",rw),"^",3)
	.if ATime'="" s ATime=$ZT(ATime,2)
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.s Typ=""
	.if (TypDr'="")&&($G(^DHCQTRECTYP("typ",TypDr))'="") s Typ=$P(^DHCQTRECTYP("typ",TypDr),"^",2)
	.s UserDr=$p(^DHCADMQTREC("QTREC",rw),"^",7)
    .if UserDr'="" s User=$p(^SSU("SSUSR",UserDr),"^",2)
	.d outqt
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outqt
	//set Data=$lb(ADate,ATime,Typ,User,rw,TypDr)
	set Data=$lb(ADate,ATime,Typ,$G(User),rw,TypDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QtListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QtListExecute ]
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

Query QtList(Adm As %String) As %Query(ROWSPEC = "ADate,ATime,Typ,User,rw,TypDr")
{
}

ClassMethod QtListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QtListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QtTypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QtTypExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QtTypExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    s rw=0  f  s rw=$o(^DHCQTRECTYP("typ",rw)) q:rw=""  d
    .s typ=$P(^DHCQTRECTYP("typ",rw),"^",2)
    .d outtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp
	set Data=$lb(typ,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QtTypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QtTypExecute ]
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

Query QtTyp() As %Query(ROWSPEC = "desc,rw")
{
}

ClassMethod WCReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WCReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod WCReasonExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    s typ="不在",rw=1
    d outtyp1
    s typ="未见病人",rw=2
    d outtyp1
    s typ="拒测",rw=3
    d outtyp1
    s typ="",rw=4
    d outtyp1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp1
	set Data=$lb(typ,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod WCReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WCReasonExecute ]
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

Query WCReason() As %Query(ROWSPEC = "desc,rw")
{
}

ClassMethod CRItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CRItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod CRItemExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id="" f  s id=$O(^User.DHCQtIOItemD(id)) q:id=""  d
 	.s a=##class(User.DHCQtIOItem).%OpenId(id)
   	.s code=a.Code
	.s typ=a.ItmDesc
	.s flag=a.StopFlag
	.s rw=id
	.q:flag="N"
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(typ,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CRItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CRItemExecute ]
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

Query CRItem() As %Query(ROWSPEC = "desc,rw")
{
}

/// Creator: LiuLei
/// CreatDate: 2009-10-26
/// Description: 生命体征自动添加入院时间
/// Table：DHC_QTRECTYP,DHC_ADMQTREC
/// Input：Adm: 病人就诊ID
/// Return:
ClassMethod QtPatAdmDate(Adm As %String) As %String
{
	s ret=1
	s user=""
	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:(rw="")!(ret=0)  d
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.i TypDr'="" s Typ=$p($G(^DHCQTRECTYP("typ",TypDr)),"^",2)
	.i Typ="入院" s ret=0
	i ret'=0 d
	.s ADate=$ZD($p(^PAADM(Adm),"^",6),3)
	.s ATime=$ZT($p(^PAADM(Adm),"^",7))
	.s Typ=1
	.s ret=..PACInPatDateBed(Adm)
	.s ADate=$P(ret,"^",1)
	.i ADate'="" s ADate=$zd(ADate,3)
	.s ATime=$P(ret,"^",2)
	.i ATime'="" s ATime=$zt(ATime)
	.s user=$P(ret,"^",3)
	.d ..QtInsert(Adm,ADate,ATime,Typ,user)
	q ""
}

ClassMethod PACInPatDateBed(EpisodeID As %String = "") As %String
{
	n (EpisodeID)
    q:EpisodeID="" ""
    s ret=""
    s TRANSChildsub=0,Flag=0
    f  s TRANSChildsub=$o(^PAADM(EpisodeID,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(Flag=1)  d
    .s TRANBed=$p(^PAADM(EpisodeID,"TRANS",TRANSChildsub),"^",8)
    .q:TRANBed=""
    .i TRANBed'="" s Flag=1
    .s TRANDate=$p(^PAADM(EpisodeID,"TRANS",TRANSChildsub),"^",1)
    .s TRANTime=$p(^PAADM(EpisodeID,"TRANS",TRANSChildsub),"^",2)
    .s userDr=$p(^PAADM(EpisodeID,"TRANS",TRANSChildsub),"^",16)
    .s ret=TRANDate_"^"_TRANTime_"^"_userDr
    .;s ret=userDr
    q ret
}

ClassMethod getinhs(Adm) As %String
{
	s ret=""
	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:rw=""  d
	.s ADate=$P(^DHCADMQTREC("QTREC",rw),"^",2)
	.if ADate'="" s ADate=$ZD(ADate,3)
	.s ATime=$P(^DHCADMQTREC("QTREC",rw),"^",3)
	.if ATime'="" s ATime=$ZT(ATime,2)
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.if TypDr'="" s Typ=$P(^DHCQTRECTYP("typ",TypDr),"^",2)
	.if Typ="入院" s ret=ADate_"^"_ATime
	q ret
}

/// 取体温单事件维护
/// 2010-11-15
ClassMethod GetQtTyp(funname As %String) As %String
{
	
	s rw=0  f  s rw=$o(^DHCQTRECTYP("typ",rw)) q:rw=""  d
	.s typ=$P(^DHCQTRECTYP("typ",rw),"^",2)
 	.s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(typ),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	q 0
}

}
