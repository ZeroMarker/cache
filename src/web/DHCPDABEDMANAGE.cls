Class web.DHCPDABEDMANAGE Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod BedOccupy(BedDr As %String, User As %String, StDate As %String, StTime As %String, ToDate As %String, ToTime As %String, ReasonDr As %String) As %String
{
 //标记占床
	k PLIST
	//s BedDr=$List(^TMP(11),1)
	//s User=$List(^TMP(11),2)
	//s StDate=$List(^TMP(11),3)
	//s StTime=$List(^TMP(11),4)
	//s ToDate=$List(^TMP(11),5)
	//s ToTime=$List(^TMP(11),6)
	//s ReasonDr=$List(^TMP(11),7)

	&sql(select * into PLIST() from sqluser.PAC_Bed where Bed_RowId=:BedDr)
	TSTART
	s PLIST(8)=2 
	&sql(update sqluser.Pac_Bed Values PLIST() where Bed_RowId=:BedDr)
	if SQLCODE'=0 TROLLBACK  q "标记占床失败"
	k PLIST
	s statchl=0 s statchl=$O(^PAWARDA(+BedDr,"BED",$P(BedDr,"||",2),"STAT",statchl)) 
	if statchl'=""{
		&sql(select * into PLIST() from sqluser.PAC_BedStatusChange where stat_Parref=:BedDr)
	   	s PLIST(3)=$ZDH(StDate,3)
	    s PLIST(4)=$ZTH(StTime)
        if ToDate'=0 s PLIST(7)=$ZDH(ToDate,3)
        e  s PLIST(7)=""
	    if ToTime'=0 s PLIST(8)=$ZTH(ToTime)
	    e  s PLIST(8)=""
	    if ReasonDr'=0 s PLIST(9)=ReasonDr
	    s PLIST(10)=+$H
	    s PLIST(11)=$P($H,",",2)
	    s BedDr=BedDr_"||"_statchl
	    &sql(update sqluser.PAC_BedStatusChange values PLIST() where stat_RowId=:BedDr)
		}else{
		 s PLIST(0)=BedDr
	     s PLIST(3)=$ZDH(StDate,3)
	     s PLIST(4)=$ZTH(StTime)
	     s PLIST(5)=2
	     s PLIST(6)=User
	     if ToDate'=0 s PLIST(7)=$ZDH(ToDate,3)
	     if ToTime'=0 s PLIST(8)=$ZTH(ToTime)
	     if ReasonDr'=0 s PLIST(9)=ReasonDr
	     s PLIST(10)=+$H
	     s PLIST(11)=$P($H,",",2)
	     &sql(insert into sqluser.PAC_BedStatusChange values PLIST())
		b
		}
	if SQLCODE'=0 TROLLBACK  q "标记占床记录失败"
   if SQLCODE=0  TCOMMIT  q "OK"
}

ClassMethod DelOccupy(BedDr As %String, User As %String) As %String
{
}

ClassMethod UpdateBed(Adm As %String, BedDr As %String, PreBedDr As %String, User As %String) As %String
{
  s Adm=$List(^TMP(0),1)
  s BedDr=$List(^TMP(0),2)
  s PreBedDr=$List(^TMP(0),3)
  s User=$List(^TMP(0),4)
  s ward=+BedDr
  s chl=$P(BedDr,"||",2)
  s BG=^PAWARD(ward,"BED",chl)
  s BedTyp=$P(BG,"^",2)
  s RoomDr=$P(BG,"^",3)
  s PreWard=+PreBedDr
  s PreChl=$P(PreBedDr,"||",2)
  s PreBG=^PAWARD(PreWard,"BED",PreChl)
  s tranchl="" s tranchl=$O(^PAADMi("TransBed",PreBedDr,Adm,tranchl))
  if tranchl="" q "转床记录不存在"
    TSTART

  if tranchl'="" {
	  k PLIST
	  s PLIST="" 
	  s tranrowid=Adm_"||"_tranchl
	  &sql(select * into PLIST() from sqluser.PA_AdmTransaction where TRANS_RowId=:tranrowid)
	  s PLIST(5)=+$H
	  s PLIST(6)=$P($H,",",2)  
	  s PLIST(16)=+$H
	  s PLIST(17)=$P($H,",",2)  
	  s PLIST(14)=4
	&sql(update sqluser.PA_AdmTransaction Values PLIST() where TRANS_RowId=:tranrowid)
    if SQLCODE'=0 TROLLBACK  q "更新转床记录失败"
      k PLIST
      //s PLIST=""
      s PLIST(0)=Adm
	  s PLIST(3)=+$H
	  s PLIST(4)=$P($H,",",2)  
	  s PLIST(9)=RoomDr  
	  s PLIST(10)=ward 
	  s PLIST(14)=5  
	  s PLIST(16)=+$H  
	  s PLIST(17)=$P($H,",",2)    
	  s PLIST(11)=BedDr
	  s PLIST(18)=User  
	  s PLIST(34)=BedTyp 
	 // m ^TMP(10)=PLIST
	  &sql(INSERT INTO sqluser.PA_AdmTransaction Values PLIST())
	  if SQLCODE'=0 TROLLBACK  q "插入转床记录失败"
	  s Ret3=%ROWID
	      if (Ret3'="")
	      {
		      &sql(delete from sqluser.pac_bedadm where adm_paadm_dr=:Adm)
		      if SQLCODE'=0 TROLLBACK  q "删除占床记录失败"
		      k PLIST
		      s PLIST=""
		      s PLIST(4)="O"
		      s PLIST(3)=Adm
		      s PLIST(0)=BedDr
		      s PLIST(5)=Ret3
		      &sql(insert into sqluser.PAC_BedAdm values PLIST())
		      if SQLCODE'=0 TROLLBACK  q "插入占床记录失败"
		      s PLIST=""
	          s curDate=+$h,curTime=$p($h,",",2)
         	&sql(update sqluser.PA_ADM set PAADM_UpdateDate=:curDate,PAADM_UpdateTime=:curTime,
         	PAADM_CurrentBed_DR=:BedDr,
         	PAADM_CurrentRoom_DR=:RoomDr,
         	PAADM_UpdateUser_DR=:User 
			where PAADM_RowId=:Adm)
			b
			if SQLCODE'=0 TROLLBACK  q "更新就诊记录失败"
            if SQLCODE=0  TCOMMIT  q "OK"
		  }
	  }
}

ClassMethod GetWardBedExecute(ByRef qHandle As %Binary, Loc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	s ward="" 
	s ward=$O(^PAWARD(0,"WARD_LocationDR",Loc,ward))
    if ward="" 	Quit $$$OK
    s room=0  f  s room=$O(^PAWARD("BED_Room_DR",room)) q:room=""  d
    .s bedchl=0 f  s bedchl=$O(^PAWARD("BED_Room_DR",room,ward,bedchl)) q:bedchl=""  d
    ..s bedrowid=ward_"||"_bedchl
    ..s RcFlag=$P(^PAWARD(ward,"BED",bedchl),"^",4) //床位激活标志
    ..q:RcFlag="N"
    ..s PLIST=""
    ..&sql(select * into PLIST() from sqluser.pac_bed where bed_rowid=:bedrowid)
    ..s flag=PLIST(18)
    ..s stat=PLIST(8)
    ..s Adm="",patname="",ctlocDesc="",RegNo=""
    ..if flag="N" d
    ...s admchl=..getoccupybedchl(ward,bedchl)
    ...s Adm=$P(^PAWARDA(ward,"BED",bedchl,"ADM",admchl),"^",1)
    ...s papmi=$P(^PAADM(Adm),"^",1)
    ...s patname=$P(^PAPER(papmi,"ALL"),"^",1)
    ...s RegNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
    ...s ctlocId=$p(^PAADM(Adm),"^",4)
	...s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)
	...s status="占"
	..e   d
	...if stat=2 d
	....s status=..getoccupyStr(ward,bedchl)
	...e  s status="空"	
	..s BedCode=PLIST(4)
	..s image=..setimage(Adm)
   	..Do OutwardRow
	Quit $$$OK
OutwardRow
	set Data=$lb(BedCode,status,$G(ctlocDesc),$G(patname),$G(Adm),bedrowid,$G(image),$G(RegNo),$G(papmi))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getoccupybedchl(ward, bedchl)
{
 //取占床的记录
     s rw=""
     s admchl=0 f  s admchl=$O(^PAWARDA(ward,"BED",bedchl,"ADM",admchl)) q:admchl=""  d
     .s stat=$p(^PAWARDA(ward,"BED",bedchl,"ADM",admchl),"^",2)
     .if stat="O" s rw=admchl
     q rw
}

ClassMethod setimage(adm) As %String
{
	//即刻 临时 长期 停止
	
	s (retSTAT,retNORM,retS,retStop,flag)=0
	s retSTAT=##class(web.DHCSETIMAGE).IfNewOrdItem(adm,1)
	s retNORM=##class(web.DHCSETIMAGE).IfNewOrdItem(adm,2)
	//s retS=..IfNewOrdItem(adm,58)
	if retSTAT="1" s flag="1"
	if retNORM="1" s flag="1"
	//if retS="1" s flag="1"
	
	
	s retStop=0
	s str=flag_"|"_0_"|"_0_"|"_retStop_"|||"
	// s ret=1 //##class(web.DHCSETIMAGE).IfNewPatient(adm)
	// s str=str_ret_"|"
	// w !,str,",",adm
  q str
}

ClassMethod IfNewOrdItem(AdmNo, OrdPriorityFlag) As %String
{
 // n (AdmNo,OrdPriorityFlag)
 q:$g(AdmNo)="" 0
 s ord=$o(^OEORD(0,"Adm",AdmNo,""))
 q:ord="" 0
 s ret=0
 s chl=""
 s fl=0
 
 f  s chl=$o(^OEORDi(0,"StDt",+$h,ord,chl)) q:(chl="")!(fl=1)  d
 .q:'$d(^OEORD(ord,"I",chl,1))
 .q:$P($G(^OEORD(ord,"I",chl,9)),"^",12)'=""
 .s ItemStatDR=$p(^OEORD(ord,"I",chl,1),"^",13)
 .s PriorDR=$P($G(^OEORD(ord,"I",chl,1)),"^",8)     ;OEC_Priority
 .s priorCode=$P(^OECPR(PriorDR),"^",1)
 .q:ItemStatDR'=1
 .//s subCat=##class(web.DHCSETIMAGE).GetOrdSubCate(ord, chl) ;根据医嘱子类确定是否显示
 .//q:subCat="293"  ;会诊医嘱不提示
 .s arcimDR=$P($G(^OEORD(ord,"I",chl,1)),"^",2)
 .q:arcimDR="16163||1"  ;床旁心电图不显示
 .s catdesc=##class(web.DHCSETIMAGE).GetOrdCat(ord, chl)
 .q:(catdesc="消耗材料")!(catdesc="普通项目")!(catdesc="EXAM")!(catdesc="检验")!(catdesc="卫生材料")
 .s fillerNo="" 
 .i $d(^OEORD(ord,"I",chl,9)) s fillerNo=$p(^OEORD(ord,"I",chl,9),"^",12)    ;Filler_No
 .q:$g(fillerNo)'=""
 .s cptype=""
 .i $d(^OEORD(ord,"I",chl,7)) d
 .. s adduser=$p(^OEORD(ord,"I",chl,7),"^",1)
 .. q:adduser=""
 .. i $d(^SSU("SSUSR",adduser)) s cpdr=$p(^SSU("SSUSR",adduser),"^",14) 
 .. q:$g(cpdr)=""
 .. i $d(^CTPCP(cpdr,1)) s cptypedr=$p(^CTPCP(cpdr,1),"^",4)
 .. q:$g(cptypedr)="NURSE"
 .. i $d(^CT("CPT",cptypedr)) s cptype=$p(^CT("CPT",cptypedr),"^",4)
 .;w !,"cptype=",cptype
 .q:cptype="NURSE"
 .s retul=##class(web.DHCSETIMAGE).getloc(ord,chl)
 .q:retul=""
 .s ech="" 
 .s thisexec=0       ;先定此医嘱未被执行
 .s flag=0
 .f  s ech=$o(^OEORD(ord,"I",chl,"X",ech)) q:(ech="")!(flag=1)  d
 ..q:'$d(^OEORD(ord,"I",chl,"X",ech))
 ..s execdate=$p(^OEORD(ord,"I",chl,"X",ech),"^",19)   ;执行日期
 ..s execcp=$p(^OEORD(ord,"I",chl,"X",ech),"^",15)     ;执行人
 ..i (execdate'="")&(execcp'="") d
 ...s thisexec=1   ;此医嘱已经被执行  
 ...s flag=1 
 .//i (thisexec=0)&(($g(priorCode)="STAT")!(priorCode="NORM")) d
 .//.s ret=1
 .i ((thisexec=0)&&(OrdPriorityFlag[PriorDR))  d
 ..s ret=1
 ..b
 q ret
}

ClassMethod getoccupyStr(ward, bedchl) As %String
{
	s today=((+$H*86400)+$P($H,",",2))
	s statchl=$O(^PAWARDA(ward,"BED",bedchl,"STAT",0))
	q:statchl="" ""
	if statchl'="" s statgl=^PAWARDA(ward,"BED",bedchl,"STAT",statchl)
	s stdate=$P(statgl,"^",1),sttime=$P(statgl,"^",2)
	s todate=$P(statgl,"^",5),totime=$P(statgl,"^",6)
	i todate="" s retstr="占From"_$ZD(stdate,3)_"|"_$ZT(sttime)
	e  d
	.s totdatetim=((todate*86400)+totime)
	.b
	.if totdatetim<today s retstr="空"
	.e  s retstr="占From"_$ZD(stdate,3)_"|"_$ZT(sttime)_"To"_$ZD(todate,3)_"|"_$ZT(totime)
	q $G(retstr)
}

ClassMethod GetWardBedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardBedExecute ]
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

ClassMethod GetWardBedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardBedExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetWardBed(Loc As %String) As %Query(ROWSPEC = "BedCode,Status,ctlocDes,patname,Adm,BedRowid,Image,RegNo,papmi")
{
}

Query GetOecpr(userid As %String) As %Query(ROWSPEC = "oecpr_rowid:%Integer,oecpr_Desc:%String,Sel")
{
}

ClassMethod GetOecprExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
   s chl=0  f  s chl=$O(^OECPR(chl))  q:chl=""  d
    .s des=$P(^OECPR(chl),"^",2)
    .s rw="^"_chl_"^"
    .if $G(^DHCPdaNurSCHSet("default","Prior",userid))[rw s sel="√"
    .e  s sel=0
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(chl,des,sel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOecprFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOecprExecute ]
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

ClassMethod GetOecprClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOecprExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOrdStat(userid As %String) As %Query(ROWSPEC = "OStat_rowid:%Integer,OStat_Desc:%String,Sel")
{
}

ClassMethod GetOrdStatExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s chl=0  f  s chl=$O(^OEC("OSTAT",chl) )  q:chl=""  d
    .s des=$P(^OEC("OSTAT",chl) ,"^",2)
    .s rw="^"_chl_"^"
    .if $G(^DHCPdaNurSCHSet("default","OrdStat",userid))[rw s sel="√"
    .e  s sel=0
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(chl,$TR(des,"-",""),sel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOrdStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdStatExecute ]
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

ClassMethod GetOrdStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOrcat(userid As %String) As %Query(ROWSPEC = "ORCAT_Rowid:%Integer,ORCAT_Desc:%String,Sel")
{
}

ClassMethod GetOrcatExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s chl=0  f  s chl=$O(^OEC("ORCAT",chl))  q:chl=""  d
    .s des=$P(^OEC("ORCAT",chl),"^",2)
    .s rw="^"_chl_"^"
    .if $G(^DHCPdaNurSCHSet("default","OrdCat",userid))[rw s sel="√"
    .e  s sel=0
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(chl,des,sel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOrcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrcatExecute ]
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

ClassMethod GetOrcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrcatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPhcin(userid As %String) As %Query(ROWSPEC = "phcin_rowid:%Integer,phcin_Desc1:%String,Sel:%String")
{
}

ClassMethod GetPhcinExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s chl=0  f  s chl=$O(^PHCIN(chl) )  q:chl=""  d
    .s des=$P(^PHCIN(chl) ,"^",2)
    .s rw="^"_chl_"^"
    .if $G(^DHCPdaNurSCHSet("default","PhcIn",userid))[rw s sel="√"
    .e  s sel=0
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(chl,des,sel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPhcinFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhcinExecute ]
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

ClassMethod GetPhcinClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPhcinExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetReasonNotAvail() As %Query(ROWSPEC = "Rw:%Integer,Desc:%String")
{
}

ClassMethod GetReasonNotAvailExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s chl=0  f  s chl=$O(^PAC("RNAV", chl) )  q:chl=""  d
    .s des=$P(^PAC("RNAV", chl),"^",2)
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(chl,des)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetReasonNotAvailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReasonNotAvailExecute ]
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

ClassMethod GetReasonNotAvailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReasonNotAvailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="DHCPDABEDMANAGEDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPDABEDMANAGED</DataLocation>
<DefaultData>DHCPDABEDMANAGEDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPDABEDMANAGED</IdLocation>
<IndexLocation>^web.DHCPDABEDMANAGEI</IndexLocation>
<StreamLocation>^web.DHCPDABEDMANAGES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
