/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 公共Query
Class DHCDoc.PW.COM.Query Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 
/// DESC: 查询HIS成员
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.PW.COM.Query","QryHisDoc","姜春梅","",9)
Query QryHisDoc(Desc As %String = "", LocId = "", InHosp = "") As %Query(ROWSPEC = "id,text,code")
{
}

ClassMethod QryHisDocExecute(ByRef qHandle As %Binary, Desc As %String = "", LocId = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i (Desc="") {
	 	//Set qHandle=$lb(0,repid,0)
		//Quit $$$OK
	}
	s ^QP("QryHisDoc")=$LB(Desc,LocId,InHosp)
	s langid=##class(DHCDoc.PW.COM.Method).%LanguageID()
	S Desc=$zcvt(Desc,"U")
	i LocId="" { 
		Set id=0
		f  s id=$o(^CTPCP(id)) q:id=""  d
		.s uid=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(id)
		.q:uid=""
		.s userCode=$p(^SSU("SSUSR",uid),"^",1)
		.s StartDate=$p(^SSU("SSUSR",uid),"^",96)
		.s EndDate=$p(^SSU("SSUSR",uid),"^",97)
		.s SActive=$p(^SSU("SSUSR",uid),"^",19)
		.q:SActive'="Y"
		.q:(StartDate'="")&&(StartDate>+$H)
		.q:(EndDate'="")&&(EndDate<+$H)
		.s userCode=$zcvt(userCode,"U")
		.s text=$p(^CTPCP(id,1),"^",2)
		.s code=$p(^CTPCP(id,1),"^",1)
		.s othername=$p(^CTPCP(id,3),"^",28)
		.q:(userCode'[Desc)&&(text'[Desc)&&(othername'[Desc)
		.s AllHosp=$p(^SSU("SSUSR",uid),"^",98)	;
	    .s sub=""
		.f  s sub=$o(^SSU("SSUSR",uid,"OTHLL",sub)) q:sub=""  d
		..s cHosp=$p(^SSU("SSUSR",uid,"OTHLL",sub),"^",3)
		..q:cHosp=""
		..i AllHosp="" s AllHosp=cHosp
		..e  d
		...i ##class(DHCAnt.KSS.Common.Method).InArray(AllHosp,cHosp)'=1 s AllHosp=AllHosp_","_cHosp
	    .q:(InHosp'="")&&(##class(DHCAnt.KSS.Common.Method).InArray(AllHosp,InHosp)'=1)
	 	.d output8
	} else {
		s dep=""
	    f  s dep=$o(^RB("RES",0,"CTLOC",dep))  q:dep=""  d
	    .q:(LocId'="")&&(dep'=LocId)
	    .s RowId=""
	    .f  s RowId=$o(^RB("RES",0,"CTLOC",dep,RowId))  q:RowId=""  d
	    ..s docdr=$p($g(^RB("RES",RowId)),"^",2) 
	    ..q:docdr=""
	    ..s uid=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(docdr)
		..q:uid=""
		..s StartDate=$p(^SSU("SSUSR",uid),"^",96)
		..s EndDate=$p(^SSU("SSUSR",uid),"^",97)
		..s SActive=$p(^SSU("SSUSR",uid),"^",19)
		..q:SActive'="Y"
		..q:(StartDate'="")&&(StartDate>+$H)
		..q:(EndDate'="")&&(EndDate<+$H)
	    ..;s docdesc=$p(^CTPCP(docdr,1),"^",2)
	    ..s CTCarPrvTpDR=$P($g(^CTPCP(docdr,1)),"^",4)
		..;s CTCarPrvTpdesc=$P($g(^CTPCP(docdr,1)),"^",2)
		..s userCode=$p(^SSU("SSUSR",uid),"^",1)
		..s userCode=$zcvt(userCode,"U")
		..s text=$p(^CTPCP(docdr,1),"^",2)
		..s code=$p(^CTPCP(docdr,1),"^",1)
		..s othername=$p(^CTPCP(docdr,3),"^",28)
		..q:(userCode'[Desc)&&(text'[Desc)&&(othername'[Desc)
	    ..d output8
	}
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output8
	s text= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",text,langid)
	set Data=$lb(uid,text,code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryHisDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHisDocExecute ]
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

ClassMethod QryHisDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHisDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// CTOR: QP
/// DESC: 科室
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCDoc.PW.COM.Query","QryGetdep","I","2")
Query QryGetdep(TypeList As %String = "", InHosp = "", InMID = "", InDesc = "") As %Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryGetdepExecute(ByRef qHandle As %Binary, TypeList As %String = "", InHosp = "", InMID = "", InDesc = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    /*Set Desc=$zcvt(Desc,"U")
    if (Desc="") {
	    //Set qHandle=$lb(0,repid,0)
    	//Quit $$$OK
	  }*/
    k TList
    s langid=..%LanguageID()
    d ##class(DHCDoc.PW.RPX.NMain).GetBCOtherLoc(InMID,.TList)
    S HospId=InHosp
	k TempList
	s InDesc=$zcvt(InDesc,"U")
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	f itype=1:1:$L(TypeList,"^")  d
	.s loctype=$P(TypeList,"^",itype)
	.q:loctype=""
	.if loctype="I"  d
	..s rowid=""
	..f  s rowid=$o(^PAC("ADMLOC",0,"AdmType",loctype,rowid))  q:rowid=""  d
	...q:($d(^CTLOC(rowid))=0)
	...q:($p($g(^CTLOC(rowid)),"^",13)'="E")
	...s ActiveDateTo=$p($g(^CTLOC(rowid)),"^",25)
	...q:(ActiveDateTo'="")&&(ActiveDateTo<+$h)
 	...s Desc=$p($g(^CTLOC(rowid)),"^",2)
    ...Q:(Desc["门诊")
    ...i $p(Desc,"-",2)'="" s Desc=$p(Desc,"-",2)
    ...s ContactName=$p($g(^CTLOC(rowid)),"^",43)
    ...s:ContactName["-" ContactName=$p(ContactName,"-",1)
    ...s ContactName=$zcvt(ContactName,"U")
    ...s DescU=$zcvt(Desc,"U")
    ...q:(InDesc'="")&&(ContactName'[InDesc)&&(DescU'[InDesc)
    ...s HospitalDr=$p($g(^CTLOC(rowid)),"^",22)
	...q:HospitalDr'=HospId
	...q:(TList("type")="L")&&('$D(TList(rowid)))
	...q:(TList("type")="C")&&($D(TList(rowid)))
    ...s TempList(Desc,rowid)=Desc
    .else  d
    ..s rowid=""
	..f  s rowid=$o(^PAC("ADMLOC",0,"AdmType",loctype,rowid))  q:rowid=""  d
	...q:($d(^CTLOC(rowid))=0)
	...s ActiveDateTo=$p($g(^CTLOC(rowid)),"^",25)
	...q:(ActiveDateTo'="")&&(ActiveDateTo<+$h)
 	...s Desc=$p($g(^CTLOC(rowid)),"^",2)
 	...i $p(Desc,"-",2)'="" s Desc=$p(Desc,"-",2)
    ...s ContactName=$p($g(^CTLOC(rowid)),"^",43)
    ...s:ContactName["-" ContactName=$p(ContactName,"-",1)
    ...s HospitalDr=$p($g(^CTLOC(rowid)),"^",22)
	...q:HospitalDr'=HospId
    ...s TempList(Desc,rowid)=Desc
    
    s sub1=0
    f  s sub1=$O(TempList(sub1)) Q:sub1=""  d
    .s sub2=0
    .f  s sub2=$O(TempList(sub1,sub2)) Q:sub2=""  d
    ..s desc=$G(TempList(sub1,sub2))
    ..s desc= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",desc,langid)
    ..s rowid=sub2
   	..d output7
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
output7
    set Data=$lb(rowid,desc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryGetdepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetdepExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryGetdepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetdepExecute ]
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

/// CTOR: QP
/// DESC: 院区
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCDoc.PW.COM.Query","QryHosp")
Query QryHosp() As %Query(ROWSPEC = "id:%String,text:%String,code")
{
}

ClassMethod QryHospExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    s langid=..%LanguageID()
    s id=0
  	f  s id=$o(^CT("HOSP",id)) q:id=""  d
  	.s text=$p(^CT("HOSP",id),"^",2)
  	.s text= ##class(User.CTHospital).GetTranByDesc("HOSPDesc",text,langid)
    .d OutputRow22
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow22
    set Data=$lb(id,text)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryHospClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryHospFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospExecute ]
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

}
