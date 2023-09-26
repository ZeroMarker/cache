Import SQLUser

Class web.DHCOrdCatSubRecLoc Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 118;

// creat guoshibao 

// creat 2012-02-19

ClassMethod SaveSet(SelCatSubStr, PatLocStr, RecLocStr, YDYflag, DDDflag, Defflag) As %String
{
	//n (SelCatSubStr,PatLocStr,RecLocStr,YDYflag,YDDflag,DDYflag)
	s UserId=$G(%session.Data("LOGON.USERID"))
	k ^TMPRecLocData($j,UserId)
	s SelCatSublen=$l(SelCatSubStr,"^")
	s ^TMPRecLocData($j,UserId,"CatSub")=SelCatSublen
	s PatLoclen=$l(PatLocStr,"^")
	s ^TMPRecLocData($j,UserId,"PatLoc")=PatLoclen
	s RecLoclen=$l(RecLocStr,"^")
	s ^TMPRecLocData($j,UserId,"RecLoc")=RecLoclen
	
	s i=1
	f i=1:1:PatLoclen  d
	.s ^TMPRecLocData($j,UserId,"PatLoc",i)=$tr($p(PatLocStr,"^",i),"|","^")
	
	s j=1
	f j=1:1:RecLoclen  d
	.s ^TMPRecLocData($j,UserId,"RecLoc",j)=$tr($p(RecLocStr,"^",j),"|","^")
	
	s k=1
	f k=1:1:SelCatSublen d
	.s ^TMPRecLocData($j,UserId,"CatSub",k)=$tr($P(SelCatSubStr,"^",k),"|","^")
	
	s CatSubMaxNo=$g(^TMPRecLocData($j,UserId,"CatSub"))
	s PatLocMaxNo=$g(^TMPRecLocData($j,UserId,"PatLoc"))
	s RecLocMaxNo=$g(^TMPRecLocData($j,UserId,"RecLoc"))
	
	s CatSubStr="^^^",RecLocStr="^^^"
	i CatSubMaxNo=1 s CatSubStr=$g(^TMPRecLocData($j,UserId,"CatSub",1))
	if CatSubStr="" q "-1^医嘱子类不能为空"
	i RecLocMaxNo=1 s RecLocStr=$g(^TMPRecLocData($j,UserId,"RecLoc",1))
	if RecLocStr="" q "-1^接收科室不能为空"
	
	//s ^tmpgsb00=YDYflag_"^"_RecLocMaxNo_"^"_PatLocMaxNo_"^"_Defflag
	if (YDYflag=0)&(RecLocMaxNo>1)&(Defflag="Y") q "-1^默认规则出错!默认只能运用于病人科室与接收科室 一对一或 空对多的情况."
	
	if (YDYflag=0)&(RecLocMaxNo'="")&(CatSubMaxNo'="") d
	.s m="" f  s m=$O(^TMPRecLocData($j,UserId,"CatSub",m)) q:m=""  d
	..s CatSubdr=$P(^TMPRecLocData($j,UserId,"CatSub",m),"^",1)
	..s CatSubDesc=$P(^TMPRecLocData($j,UserId,"CatSub",m),"^",2)
	..s i="" f  s i=$O(^TMPRecLocData($j,UserId,"PatLoc",i)) q:i=""  d
	...s patlocdr=$P(^TMPRecLocData($j,UserId,"PatLoc",i),"^",1)
	...s patlocdesc=$P(^TMPRecLocData($j,UserId,"PatLoc",i),"^",2)
	...s j="" f  s j=$O(^TMPRecLocData($j,UserId,"RecLoc",j))  q:j=""  d
	....s reclocdr=$P(^TMPRecLocData($j,UserId,"RecLoc",j),"^",1)
	....s reclocdesc=$P(^TMPRecLocData($j,UserId,"RecLoc",j),"^",2)
	....i (CatSubdr'="")&(reclocdr'="") d
	.....s ^TMPRecLocData($j,UserId,"Data",CatSubdr,i,j)=CatSubdr_"^"_CatSubDesc_"^"_patlocdr_"^"_patlocdesc_"^"_reclocdr_"^"_reclocdesc_"^"_Defflag
	
	if (YDYflag=1)&(RecLocMaxNo'="")&(CatSubMaxNo'="") d
	.i PatLocMaxNo>RecLocMaxNo  s len=RecLocMaxNo
	.e  s len=PatLocMaxNo 
	.s m="" f  s m=$O(^TMPRecLocData($j,UserId,"CatSub",m)) q:m=""  d
	..s CatSubdr=$P(^TMPRecLocData($j,UserId,"CatSub",m),"^",1)
	..s CatSubDesc=$P(^TMPRecLocData($j,UserId,"CatSub",m),"^",2)
	..f i=1:1:len  d
	...s patlocdr=$P(^TMPRecLocData($j,UserId,"PatLoc",i),"^",1)
	...s patlocdesc=$P(^TMPRecLocData($j,UserId,"PatLoc",i),"^",2)
	...s reclocdr=$P(^TMPRecLocData($j,UserId,"RecLoc",i),"^",1)
	...s reclocdesc=$P(^TMPRecLocData($j,UserId,"RecLoc",i),"^",2)
	...i (CatSubdr'="")&(reclocdr'="") d
	....s ^TMPRecLocData($j,UserId,"Data",CatSubdr,i,j)=CatSubdr_"^"_CatSubDesc_"^"_patlocdr_"^"_patlocdesc_"^"_reclocdr_"^"_reclocdesc_"^"_Defflag
   q "0^"_$j
}

ClassMethod InsertData(job) As %String
{
	s UserId=$G(%session.Data("LOGON.USERID"))
	q:job="" "失败!"
	s n=1
   	s i="" f  s i=$O(^TMPRecLocData(job,UserId,"Data",i)) q:i=""  d
 	.s j="" f  s j=$O(^TMPRecLocData(job,UserId,"Data",i,j)) q:j=""  d
 	..s m="" f  s m=$O(^TMPRecLocData(job,UserId,"Data",i,j,m)) q:m=""  d
 	...s str=$g(^TMPRecLocData(job,UserId,"Data",i,j,m))
 	...s TCatSubId=$P(str,"^",1)
 	...s TCatSubDesc=$P(str,"^",2)
 	...s TPatLocId=$P(str,"^",3)
 	...s TPatLocDesc=$P(str,"^",4)
 	...s TRecLocId=$P(str,"^",5)
 	...s TRecLocDesc=$P(str,"^",6)
 	...s Defflag=$P(str,"^",7)
 	...s retstr=..TestData(TCatSubId,TPatLocId,TRecLocId,Defflag)
 	...i $P(retstr,"^",1)="Y" s ^TMPRecLocData(job,UserId,"Journal",n)=TCatSubDesc_" # "_TPatLocDesc_" # "_TRecLocDesc_"^"_"已存在数据"
	...i $P(retstr,"^",2)="Y" s ^TMPRecLocData(job,UserId,"Journal",n_"/"_1)=TCatSubDesc_" # "_TPatLocDesc_" # "_TRecLocDesc_"^"_"已存在默认规则"
	...i TPatLocId'="" d
	....i '$d(^CTLOC(TPatLocId))  d
	.....s ^TMPRecLocData(job,UserId,"Journal",n_"/"_2)=TCatSubDesc_" # "_TPatLocDesc_" # "_TRecLocDesc_"^"_"病人科室不存在"
	.....q
	...i TRecLocId'="" d
	....i '$d(^CTLOC(TRecLocId)) d 
	.....s ^TMPRecLocData(job,UserId,"Journal",n_"/"_3)=TCatSubDesc_" # "_TPatLocDesc_" # "_TRecLocDesc_"^"_"接收科室不存在"
	.....q
	...i TCatSubId'="" d
	....i '$d(^ARC("IC",TCatSubId)) d
	.....s ^TMPRecLocData(job,UserId,"Journal",n_"/"_4)=TCatSubDesc_" # "_TPatLocDesc_" # "_TRecLocDesc_"^"_"医嘱子类不存在"
	.....q
 	...i (retstr'["Y")  d
 	....k PLIST 
 	....s PLIST(0)=TCatSubId,PLIST(3)=TPatLocId,PLIST(4)=TRecLocId,PLIST(5)="Execute",PLIST(6)=Defflag,PLIST(10)=..%SysDate()
    ....&SQL(INSERT INTO ARC_ItemCatRecLoc VALUES :PLIST())
 	....if $g(SQLCODE)  s ^TMPRecLocData(job,UserId,"Journal",n)=TCatSubDesc_" # "_TPatLocDesc_" # "_TRecLocDesc_"^"_"没导入成功"
 	...s n=n+1
 	q "ok"
}

ClassMethod TestData(TCatSubId, TPatLocId, TRecLocId, Defflag) As %String
{
	s ret="N",ret1="N"
	s sub=""  f  s sub=$O(^ARC("IC",TCatSubId,"RL",sub))  q:sub=""  d
	.s patlocdr=$P(^ARC("IC",TCatSubId,"RL",sub),"^",2)
	.s reclocdr=$P(^ARC("IC",TCatSubId,"RL",sub),"^",3)
	.s defaultflag=$P(^ARC("IC",TCatSubId,"RL",sub),"^",4)
	.i (patlocdr="")&(reclocdr=TRecLocId) s ret="Y"
	.i (patlocdr'="")&(patlocdr=TPatLocId)&(reclocdr=TRecLocId) s ret="Y"
	.i (patlocdr="")&(reclocdr=TRecLocId)&(defaultflag="Y") s ret1="Y"
	.i (patlocdr'="")&(patlocdr=TPatLocId)&(defaultflag="Y")&(Defflag="Y") s ret1="Y"
	q ret_"^"_ret1
}

ClassMethod UpDateTestData(TCatSubId, TPatLocId, TRecLocId, Defflag) As %String
{
	s ret="N",ret1="N"
	s sub=""  f  s sub=$O(^ARC("IC",TCatSubId,"RL",sub))  q:sub=""  d
	.s patlocdr=$P(^ARC("IC",TCatSubId,"RL",sub),"^",2)
	.s reclocdr=$P(^ARC("IC",TCatSubId,"RL",sub),"^",3)
	.s defaultflag=$P(^ARC("IC",TCatSubId,"RL",sub),"^",4)
	.i (patlocdr="")&(reclocdr=TRecLocId)&(defaultflag="Y") s ret1="Y"
	.i (patlocdr'="")&(patlocdr=TPatLocId)&(defaultflag="Y")&(Defflag="Y") s ret1="Y"
	q ret_"^"_ret1
}

Query GetDepGrP() As %SQLQuery(CONTAINID = 1, ROWSPEC = "DEP_RowId:%Integer,DEP_Desc:%String")
{
	 select DEP_RowId,DEP_Desc  from RBC_DepartmentGroup
}

ClassMethod ctloclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ctloclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ctloclookupExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    s ctlocrowid=0 f  s ctlocrowid=$o(^CTLOC(ctlocrowid)) q:ctlocrowid=""  d
    . q:'$d(^CTLOC(ctlocrowid))
    . s ctlocdesc=$p(^CTLOC(ctlocrowid),"^",2)
    . s ctlocdesc=$p(ctlocdesc,"-",2)
 	.Do OutputRow4
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(ctlocrowid,ctlocdesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ctloclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ctloclookupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save qHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query ctloclookup() As %Query(ROWSPEC = "ctlocid:%String,ctloc:%String")
{
}

ClassMethod GetPatLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatLocExecute ]
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

ClassMethod GetPatLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatLocExecute(ByRef qHandle As %Binary, Job As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    i Job="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
    s UserId=$G(%session.Data("LOGON.USERID")) 
 	s i=0 f  s i=$O(^TMPRecLocData(Job,UserId,"PatLoc",i)) q:i=""  d
 	.s rw=$P(^TMPRecLocData(Job,UserId,"PatLoc",i),"^",1)
 	.s desc=$P(^TMPRecLocData(Job,UserId,"PatLoc",i),"^",2)
 	.d Outputcat2	
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat2
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetPatLoc(Job As %String) As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod GetRecLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRecLocExecute ]
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

ClassMethod GetRecLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRecLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRecLocExecute(ByRef qHandle As %Binary, Job As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    i Job="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
    s UserId=$G(%session.Data("LOGON.USERID")) 
    s i=0 f  s i=$O(^TMPRecLocData(Job,UserId,"RecLoc",i)) q:i=""  d
 	.s rw=$P(^TMPRecLocData(Job,UserId,"RecLoc",i),"^",1)
 	.s desc=$P(^TMPRecLocData(Job,UserId,"RecLoc",i),"^",2)
 	.d Outputcat
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetRecLoc(Job As %String) As %Query(ROWSPEC = "rw,desc")
{
}

Query GetOrdCat() As %SQLQuery(CONTAINID = 1, ROWSPEC = "orcat_rowid:%Integer,orcat_Desc:%String")
{
	 select orcat_rowId,orcat_desc from OEC_OrderCategory
}

ClassMethod GetOrdCatSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdCatSubExecute ]
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

ClassMethod GetOrdCatSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdCatSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetOrdCatSubExecute(ByRef qHandle As %Binary, OrdCatId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s ^TT=OrdCatId
 	s rw=0 f  s rw=$O(^ARC("IC",rw)) q:rw=""  d
 	.s desc=$P($g(^ARC("IC",rw)),"^",2)
 	.s ordid=$P($g(^ARC("IC",rw)),"^",8)
 	.q:(ordid'=OrdCatId)&(OrdCatId'="")
	.Do Outputcat3

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat3
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetOrdCatSub(OrdCatId As %String) As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod GetSelCatSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSelCatSubExecute ]
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

ClassMethod GetSelCatSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSelCatSubExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSelCatSubExecute(ByRef qHandle As %Binary, Job As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i Job="" {
	 	Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	 }
    s UserId=$G(%session.Data("LOGON.USERID"))
 	s i=0 f  s i=$O(^TMPRecLocData(Job,UserId,"CatSub",i)) q:i=""  d
 	.s rw=$P(^TMPRecLocData(Job,UserId,"CatSub",i),"^",1)
 	.s desc=$P(^TMPRecLocData(Job,UserId,"CatSub",i),"^",2)
 	.d Outputcat4	
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat4
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetSelCatSub(Job As %String) As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod GetArcItemCat(OrdCatId) As %String
{
	//n (OrdCatId)
	s rw=""
	f  s rw=$O(^ARC("IC",rw)) q:rw=""  d
 	.s desc=$P($g(^ARC("IC",rw)),"^",2)
 	.s ordid=$P($g(^ARC("IC",rw)),"^",8)
 	.q:(ordid'=OrdCatId)&(OrdCatId'="")
 	.s CatStr=$G(CatStr)_rw_"!"_desc_"^"
 	q $G(CatStr)
}

ClassMethod GetDepartment(HosId, DepGrpId) As %String
{
	n (HosId,DepGrpId)
	s rw="" f  s rw=$O(^CTLOC(0,"DepGrp",DepGrpId,rw)) q:rw=""  d
	.s mhosid=$P(^CTLOC(rw),"^",22)
	.;q:mhosid=""
	.q:(mhosid'=HosId)&(HosId'="")&(mhosid'="")
	.s desc="",desc1=""
 	.s desc=$P(^CTLOC(rw),"^",2)
 	.s desc1=$P(desc,"-",2)
 	.i desc1="" s desc1=desc
 	.s LocStr=$G(LocStr)_rw_"!"_desc1_"^"
 	q $G(LocStr)
}

ClassMethod FindRecLocDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRecLocDataExecute ]
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

ClassMethod FindRecLocDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRecLocDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod FindRecLocDataExecute(ByRef qHandle As %Binary, Job As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i Job="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
    s UserId=$G(%session.Data("LOGON.USERID"))
 	s i="" f  s i=$O(^TMPRecLocData(Job,UserId,"Data",i)) q:i=""  d
 	.s j="" f  s j=$O(^TMPRecLocData(Job,UserId,"Data",i,j)) q:j=""  d
 	..s m="" f  s m=$O(^TMPRecLocData(Job,UserId,"Data",i,j,m)) q:m=""  d
 	...s str=$g(^TMPRecLocData(Job,UserId,"Data",i,j,m))
 	...s TCatSubId=$P(str,"^",1)
 	...s TCatSubDesc=$P(str,"^",2)
 	...s TPatLocId=$P(str,"^",3)
 	...s TPatLocDesc=$P(str,"^",4)
 	...s TRecLocId=$P(str,"^",5)
 	...s TRecLocDesc=$P(str,"^",6)
 	...s Defflag=$P(str,"^",7)
 	...d Output3	
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output3
	set Data=$lb($g(TCatSubDesc),$g(TPatLocDesc),$g(TRecLocDesc),$g(Defflag),$g(TCatSubId),$g(TPatLocId),$g(TRecLocId))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query FindRecLocData(Job As %String) As %Query(ROWSPEC = "TCatSubDesc:%String,TPatLocDesc:%String,TRecLocDesc:%String,TDefflag:%String,TCatSubId:%String,TPatLocId:%String,TRecLocId:%String,Tjob:%String")
{
}

ClassMethod FindJournalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindJournalExecute ]
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

ClassMethod FindJournalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindJournalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod FindJournalExecute(ByRef qHandle As %Binary, Job As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i Job="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
    s UserId=$G(%session.Data("LOGON.USERID"))
 	s i="" f  s i=$O(^TMPRecLocData(Job,UserId,"Journal",i)) q:i=""  d
 	.s TText=$P(^TMPRecLocData(Job,UserId,"Journal",i),"^",1)
 	.s Talert=$P(^TMPRecLocData(Job,UserId,"Journal",i),"^",2)
 	.d Output4	
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output4
	set Data=$lb($g(TText),$g(Talert))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query FindJournal(Job As %String) As %Query(ROWSPEC = "TText:%String,Talert:%String")
{
}

ClassMethod FindCatRecLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatRecLocExecute ]
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

ClassMethod FindCatRecLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCatRecLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod FindCatRecLocExecute(ByRef qHandle As %Binary, CatSubId As %String, PatLocId As %String, RecLocId As %String, HosId As %String, Default As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s UserId=$G(%session.Data("LOGON.USERID"))
    i CatSubId="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
    ;s ^ttt=PatLocId_"#"_RecLocId
 	s sub=0 f  s sub=$O(^ARC("IC",CatSubId,"RL",sub)) q:sub=""  d
 	.s OrdLoc="",RecLoc="",DateFrom="",DateTo="",OrdLocHos="",RecLocHos="",Rowid="",CatSub=""
 	.s CatSub=$P(^ARC("IC",CatSubId),"^",2)
 	.s OrdLocDr=$P(^ARC("IC",CatSubId,"RL",sub),"^",2)
 	.q:(PatLocId'="")&(OrdLocDr'=PatLocId)
 	.s mpathosid=""
 	.s:OrdLocDr'="" mpathosid=$P(^CTLOC(OrdLocDr),"^",22)
 	.q:(mpathosid'="")&(HosId'="")&(mpathosid'=HosId)
 	.s:OrdLocDr'="" OrdLoc=$P(^CTLOC(OrdLocDr),"^",2)
 	.s OrdLoc1=$P(OrdLoc,"-",2)
 	.i OrdLoc1'="" s OrdLoc=OrdLoc1
 	.s RecLocDr=$P(^ARC("IC",CatSubId,"RL",sub),"^",3)
 	.q:(RecLocId'="")&(RecLocDr'=RecLocId)
 	.s mrechosid=""
 	.s:RecLocDr'="" mrechosid=$P(^CTLOC(RecLocDr),"^",22)
 	.;q:(mrechosid'="")&(HosId'="")&(mrechosid'=HosId)
 	.s:RecLocDr'="" RecLoc=$P(^CTLOC(RecLocDr),"^",2)
 	.s RecLoc1=$P(RecLoc,"-",2)
 	.i RecLoc1'="" s RecLoc=RecLoc1
 	.s Def=$P(^ARC("IC",CatSubId,"RL",sub),"^",4)
 	.i Def'="Y" s Def=""
 	.q:(Def'=Default)&(Default="Y")
 	.s DateFrom=$P(^ARC("IC",CatSubId,"RL",sub),"^",8)
 	.s DateTO=$P(^ARC("IC",CatSubId,"RL",sub),"^",9)
 	.s:DateFrom'="" DateForm=..%ZD(DateFrom) //$zd(DateFrom,3)
 	.s:DateTo'="" DateTo=..%ZD(DateTo) //$zd(DateTo,3)
 	.i OrdLocDr'="" d 
 	..s OrdLocHosDr=$P(^CTLOC(OrdLocDr),"^",22)
 	..s:OrdLocHosDr'="" OrdLocHos=$P(^CT("HOSP",OrdLocHosDr),"^",2)
 	.i RecLocDr'="" d 
 	..s RecLocHosDr=$P(^CTLOC(RecLocDr),"^",22)
 	..s:RecLocHosDr'="" RecLocHos=$P(^CT("HOSP",RecLocHosDr),"^",2)
 	.s Rowid=CatSubId_"||"_sub
 	.s len=5-$l(sub)
 	.s Tsub="T"_$e("00000",1,len)_sub
 	.d Output5	
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output5
	set Data=$lb($g(OrdLoc),$g(RecLoc),$g(Def),$g(DateForm),$g(DateTo),$g(OrdLocHos),$g(RecLocHos),$g(Rowid),$g(CatSub),$g(OrdLocDr),$g(RecLocDr),$g(Tsub))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query FindCatRecLoc(CatSubId As %String, PatLocId As %String, RecLocId As %String, HosId As %String, Default As %String) As %Query(ROWSPEC = "TPatLoc:%String,TRecLoc:%String,TDefalut:%String,TDateFrom:%String,TDateTo:%String,TPatHospital:%String,TRecHospital:%String,TRowid:%String,TCatSub:%String,TPatLocId:%String,TRecLocId:%String,Tsub:%String")
{
}

ClassMethod GetPatLocStr() As %String
{
	s HosId=%request.Get("HosId")
	;s HosId=""
	s ret1="",ret=""
    s rowid=0 f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
    .s mhosid=$P($g(^CTLOC(rowid)),"^",22)
    .q:(mhosid'="")&(HosId'="")&(mhosid'=HosId)
    .s CTType=$p($g(^CTLOC(rowid)),"^",13)
	.q:(CTType="O")!(CTType="OR")
	.s CTDesc=$p($g(^CTLOC(rowid)),"^",2)
	.s CTDesc=$ZCVT(CTDesc,"U")
	.s CTContactNameTem=""
	.i $L(CTDesc,"-")>1 s CTContactNameTem=$P(CTDesc,"-",1) s CTDesc=$P(CTDesc,"-",2)
	.;用作放助记码的地方
	.s CTContactName=$p($g(^CTLOC(rowid)),"^",43)
	.s CTContactName=$ZCVT(CTContactName,"U")
	.i CTContactName="" s CTContactName=CTContactNameTem
	.s ret=rowid_$c(1)_CTDesc_"-"_CTContactName
	.i ret1="" s ret1=ret
	.e  s ret1=ret_"^"_ret1
	Q ret1
}

ClassMethod GetRecLocStr() As %String
{
	;s HosId=%request.Get("HosId")
	s HosId=""
	s ret1="",ret=""
    s rowid=0 f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
    .s mhosid=$P($g(^CTLOC(rowid)),"^",22)
    .q:(mhosid'="")&(HosId'="")&(mhosid'=HosId)
    .s CTType=$p($g(^CTLOC(rowid)),"^",13)
	.q:(CTType="O")!(CTType="OR")
	.s CTDesc=$p($g(^CTLOC(rowid)),"^",2)
	.s CTDesc=$ZCVT(CTDesc,"U")
	.s CTContactNameTem=""
	.i $L(CTDesc,"-")>1 s CTContactNameTem=$P(CTDesc,"-",1) s CTDesc=$P(CTDesc,"-",2)
	.;用作放助记码的地方
	.s CTContactName=$p($g(^CTLOC(rowid)),"^",43)
	.s CTContactName=$ZCVT(CTContactName,"U")
	.i CTContactName="" s CTContactName=CTContactNameTem
	.s ret=rowid_$c(1)_CTDesc_"-"_CTContactName
	.i ret1="" s ret1=ret
	.e  s ret1=ret_"^"_ret1
	Q ret1
}

ClassMethod AddData(itmjs As %Library.String = "", itmjsex As %Library.String = "", CatSubId As %Library.String, PatLocId As %Library.String = "", RecLocId As %Library.String, Default As %Library.String = "") As %String
{
	i (RecLocId="") d
	.s ret="03"
	.s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
    .i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
    .&javascript<#(retval)#>
    q:(RecLocId="")
    i (CatSubId="") d
    .s ret="02"
	.s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
    .i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
    .&javascript<#(retval)#>
    q:(CatSubId="")
	s retstr=..TestData(CatSubId,PatLocId,RecLocId,Default)
	i ($p(retstr,"^",1)="Y")  d
	.s ret="04"
	.s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
    .i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
    .&javascript<#(retval)#>
    q:($p(retstr,"^",1)="Y")
    i ($p(retstr,"^",2)="Y")  d
    .s ret="05"
	.s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
    .i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
    .&javascript<#(retval)#>
    q:($p(retstr,"^",2)="Y")
    k PLIST 
    s PLIST(0)=CatSubId,PLIST(3)=PatLocId,PLIST(4)=RecLocId,PLIST(5)="Execute",PLIST(6)=Default,PLIST(10)=..%SysDate()
    &SQL(INSERT INTO ARC_ItemCatRecLoc VALUES :PLIST())
 	i $g(SQLCODE) s ret="06"
 	e  s ret="01"
 	s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
    &javascript<#(retval)#>  
 	q 0
}

ClassMethod UpdateData(itmjs As %Library.String = "", itmjsex As %Library.String = "", Rowid As %Library.String, CatSubId As %Library.String = "", PatLocId As %Library.String = "", RecLocId As %Library.String, Default As %Library.String = "") As %String
{
	i (Rowid="") d
	.s ret="07"
	.s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
    .i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
    .&javascript<#(retval)#>
    q:(Rowid="")
    i (CatSubId="") d
    .s ret="02"
	.s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
    .i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
    .&javascript<#(retval)#>
    q:(CatSubId="")
    i (RecLocId="") d
    .s ret="03"
	.s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
    .i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
    .&javascript<#(retval)#>
    q:(RecLocId="")
	s retstr=..UpDateTestData(CatSubId,PatLocId,RecLocId,Default)
	i ($p(retstr,"^",1)="Y")  d
	.s ret="04"
	.s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
    .i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
    .&javascript<#(retval)#>
    q:($p(retstr,"^",1)="Y")
    i ($p(retstr,"^",2)="Y")  d
    .s ret="05"
	.s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
    .i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
    .&javascript<#(retval)#>
    q:($p(retstr,"^",2)="Y")
    s ^ttt=Rowid
    &SQL(Update ARC_ItemCatRecLoc set RL_OrdLoc_DR=:PatLocId,RL_RecLoc_DR=:RecLocId,RL_DefaultFlag=:Default where RL_RowId=:Rowid)
 	i $g(SQLCODE) s ret="06"
 	e  s ret="01"
 	s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
    &javascript<#(retval)#>  
 	q 0
}

ClassMethod SelDeleteData(RowidStr As %Library.String = "") As %String
{
    s len=$l(RowidStr,"^")
    f i=1:1:len d
    .s Rowid=$P(RowidStr,"^",i)
    .&SQL(Delete From SQLUser.ARC_ItemCatRecLoc where RL_RowId=:Rowid)
 	q
}

ClassMethod GetCatSubStr() As %String
{
	s ret1=""
    s rw=""  f  s rw=$O(^ARC("IC",rw))  q:rw=""  d
    .q:'$d(^ARC("IC",rw))
    .s desc=$P(^ARC("IC",rw),"^",2)
    .s str=rw_$c(1)_desc_"-"_desc
    .i ret1="" s ret1=str
	.e  s ret1=str_"^"_ret1
	Q ret1
}

ClassMethod GetHosStr() As %String
{
	s ret1="",str=""
    s rw=""  f  s rw=$O(^CT("HOSP",rw))  q:rw=""  d
    .q:'$d(^CT("HOSP",rw))
    .s desc=$P(^CT("HOSP",rw),"^",2)
    .s str=rw_$c(1)_desc
    .i ret1="" s ret1=str
	.e  s ret1=str_"^"_ret1
	Q ret1
}

}
