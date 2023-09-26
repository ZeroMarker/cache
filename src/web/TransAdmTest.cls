Class web.TransAdmTest Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// debug: d ##class(%ResultSet).RunQuery("web.TransAdmTest","FindTransAdm","")
Query FindTransAdm(FDate As %String, TDate As %String, RegNo As %String, locid As %String, TUserName As %String, PName As %String) As %Query(ROWSPEC = "TransAdmType:%String,PatNo:%String,PatName:%String,AdmReasonDesc:%String,AdmDepLoc:%String,Tarcdesc:%String,TUserDesc:%String,TransDate:%String,TransTime:%String,TDepLocDesc:%String,TFeeDocDesc:%String,TTotal:%String")
{
}

ClassMethod FindTransAdmExecute(ByRef qHandle As %Binary, FDate As %String, TDate As %String, RegNo As %String, locid As %String, TUserName As %String, PName As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s LogonHospID=%session.Get("LOGON.HOSPID")
    s ^Tempyzs("FindTransAdmExecute")=FDate_"^"_TDate_"^"_RegNo_"^"_locid_"^"_TUserName_"^"_PName
    k ^TMTransAdmQuery($j)
    Set langid=..%LanguageID()
    s TTotal=0
    if (FDate="")||(TDate="") {
	    Set qHandle=$lb(0,repid,0) Quit $$$OK
	}
    s FDate=..%ZDH(FDate)
    s TDate=..%ZDH(TDate)
    f sDate=FDate:1:TDate d 
    .s TransID=""
    .f  s TransID=$o(^DHCOPTransAdmI("Date",sDate,TransID)) q:(TransID="")  d
    ..s TransAdm=$p(^DHCOPTransAdm(TransID),"^",1)
    ..s TransAdmDep=$p(^DHCOPTransAdm(TransID),"^",2)
    ..q:(locid'="")&(TransAdmDep'=locid)                             ;原科室
    ..s CTLocHospDr=$p(^CTLOC(TransAdmDep),"^",22)
    ..q:(LogonHospID'="")&&(CTLocHospDr'=LogonHospID)
    ..s AdmDepLoc1=$p(^CTLOC(TransAdmDep),"^",2)
    ..s AdmDepLoc1=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",AdmDepLoc1,langid)
    ..s AdmDepLoc1=##class(web.DHCOPAdmReg).LocDescFormate(AdmDepLoc1)
    ..s Admi=TransAdm
    ..s RegisFeeid=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))      ;挂号表
    ..Q:RegisFeeid="" 
    ..s Tarcdrid=$list(^User.DHCRegistrationFeeD(RegisFeeid),19)
    ..//s Tarcdesc=$p(^RBC("SESS",Tarcdrid),"^",2)                     ;出诊级别
    ..s RBASRowID=$list(^User.DHCRegistrationFeeD(RegisFeeid),18)
    ..//s OldAdmDoc=$p($g(^RB("RES",+RBASRowID)),"^",2)
    ..//s Tarcdesc=$p($g(^CTPCP(OldAdmDoc,1)),"^",2)      
    ..s TransAdmDoc=$p(^DHCOPTransAdm(TransID),"^",3)
    ..s TransDocDesc=$p($g(^CTPCP(TransAdmDoc,1)),"^",2)                 ;转诊后医生
    ..s TransDocDesc=##class(DHCDoc.Common.Translate).GetTransDoc(TransDocDesc,langid)
    ..s Tarcdesc=TransDocDesc //转诊原号别
    ..s TransAdmType=$p(^DHCOPTransAdm(TransID),"^",14)
    ..i TransAdmType="O" s TransAdmType="门诊"
    ..i TransAdmType="E" s TransAdmType="急诊"                       ;类型
    ..s TransAdmType=##class(websys.Translation).Get("opdoc.transadmquery.hui.csp",TransAdmType)
    ..s TransDate1=$p(^DHCOPTransAdm(TransID),"^",12)
    ..s TransDate=..%ZD(TransDate1) //$zd(TransDate1,3)
    ..s TransTime1=$p(^DHCOPTransAdm(TransID),"^",13)
    ..s TransTime=..%ZT(TransTime1,1)
    ..s TransUser=$P(^DHCOPTransAdm(TransID),"^",11)                 ;转诊日期时间
    ..s TUserDesc=$p($g(^SSU("SSUSR",TransUser)),"^",2)
    ..s TUserDesc=##class(DHCDoc.Common.Translate).GetTransUser(TUserDesc,langid)
    ..Q:(TUserName'="")&(TUserDesc'=TUserName)
    ..s TransAdm=$p(^DHCOPTransAdm(TransID),"^",1)
    ..s PaadmDr=$p(^PAADM(TransAdm),"^",1)
    ..s AdmReasonDr=$P($g(^PAADM(TransAdm,1)),"^",7)
    ..s AdmReasonDesc=$p(^PAC("ADMREA",AdmReasonDr),"^",2)           ;费别
    ..s AdmReasonDesc=##class(DHCDoc.Common.Translate).GetTransAdmReason(AdmReasonDesc,langid)
    ..s PatNo=$p($g(^PAPER(PaadmDr,"PAT",1)),"^",1)
    ..Q:(PatNo'=RegNo)&(RegNo'="")
    ..s PatName=$P($g(^PAPER(PaadmDr,"ALL")),"^",1)
    ..Q:(PName'="")&(PatName'=PName)
    ..s TransRegFeeDep=$P(^DHCOPTransAdm(TransID),"^",16) 
    ..i TransRegFeeDep="" s TransRegFeeDep=$p(^PAADM(TransAdm),"^",4)
    ..s TDepLocDesc2=$p(^CTLOC(TransRegFeeDep),"^",2)   
    ..s TDepLocDesc2=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",TDepLocDesc2,langid)             ;转诊后科室
    ..i (TDepLocDesc2["-")&&($p(TDepLocDesc2,"-",2)'="") d 
    ...s TDepLocDesc=$p(TDepLocDesc2,"-",2)
    ..e  s TDepLocDesc=TDepLocDesc2
    ..s TransRegFeeDoc=$P(^DHCOPTransAdm(TransID),"^",17) 
    ..i TransRegFeeDoc="" s TransRegFeeDoc=$p(^PAADM(TransAdm),"^",9)
    ..s TFeeDocDesc=$p($g(^CTPCP(TransRegFeeDoc,1)),"^",2)               ;原就诊医生
    ..s TFeeDocDesc=##class(DHCDoc.Common.Translate).GetTransDoc(TFeeDocDesc,langid)
    ..s TTotal=TTotal+1 ;计总数
    ..s AdmDepLoc=AdmDepLoc1
    ..i (AdmDepLoc1["-")&&($p(AdmDepLoc1,"-",2)'="") s AdmDepLoc=$p(AdmDepLoc1,"-",2)
    ..s ^TMTransAdmQuery($j,TTotal)=$lb(TransAdmType,PatNo,PatName,AdmReasonDesc,AdmDepLoc,Tarcdesc,TUserDesc,TransDate,TransTime,TDepLocDesc,TFeeDocDesc,TTotal)
    
    ..//Do OutputRow2
    s STTotal=TTotal
    f k=1:1:STTotal  d
    .s Data=^TMTransAdmQuery($j,k)
    .s $list(Data,12)=STTotal
    .Do OutputRow2
    k ^TMTransAdmQuery($j)
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow2
    //i AdmDepLoc1["-" s AdmDepLoc=$p(AdmDepLoc1,"-",2)
    //set Data=$lb(TransAdmType,PatNo,PatName,AdmReasonDesc,AdmDepLoc,Tarcdesc,TUserDesc,TransDate,TransTime,TDepLocDesc,TFeeDocDesc,TTotal)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
    Quit $$$OK
}

ClassMethod FindTransAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTransAdmExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod FindTransAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTransAdmExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
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

Query SearchLoc(TLocDesc As %String, hospid As %String = "") As %Query(ROWSPEC = "TLocDesc:%String,TLocRowid:%String")
{
}

ClassMethod SearchLocExecute(ByRef qHandle As %Binary, TLocDesc As %String, hospid As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    
    If $g(ind)="" Set ind=1
    s langid=..%LanguageID()
    s rowid=0
    /*i $g(TLocDesc)=""  d
    .s TLocDesc="%"
    e  d
    .s TLocDesc=$$ALPHAUP^SSUTIL4(TLocDesc)
    .s TLocDesc=TLocDesc_"%"
    &sql(declare ctloc cursor  for 
    select distinct ctloc_desc,ctloc_rowid
                  from SQLUser.ct_loc 
                  WHERE (UPPER(ctloc_desc) like :TLocDesc))
    &sql(open ctloc)
    f  &sql(fetch ctloc into :ctlocdesc,:ctlocrowid) q:SQLCODE  d
    .s CTLocHospDr=$p(^CTLOC(ctlocrowid),"^",22)
    .q:(hospid'="")&&(CTLocHospDr'=hospid)
    .Do OutputRow       
    &sql(close ctloc)*/
    s LocTypeStr="O^E"
    for i=1:1:$l(LocTypeStr,"^") d
    .s LocType=$p(LocTypeStr,"^",i)
    .s ctlocrowid=""
    .f  s ctlocrowid=$o(^PAC("ADMLOC",0,"AdmType",LocType,ctlocrowid))  q:ctlocrowid=""  d
    ..q:($d(^CTLOC(ctlocrowid))=0)
    ..s DepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(ctlocrowid)
    ..q:((hospid'=DepHosDr)&&(hospid'=""))
    ..s ctlocdesc=$p(^CTLOC(ctlocrowid),"^",2)
    ..q:##class(web.DHCOPAdmReg).CheckLocDesc(ctlocrowid,TLocDesc,langid)'=1 
    ..s LocDateTo=$p($g(^CTLOC(ctlocrowid)),"^",25)
	..q:(LocDateTo'="")&&(LocDateTo<+$H)
	..q:($P(^CTLOC(ctlocrowid),"^",14)'="Y")
    ..s ctlocdesc=##class(DHCDoc.Common.Translate).GetTransLoc(ctlocdesc,langid)
    ..d OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ctlocdesc,ctlocrowid)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
    Quit $$$OK
}

ClassMethod SearchLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchLocExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SearchLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchLocExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
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

Query FindUser(TUserName As %String, locid As %String = "", HospID As %String = "") As %Query(ROWSPEC = "UserName:%String,UserRowid:%String")
{
}

ClassMethod FindUserExecute(ByRef qHandle As %Binary, TUserName As %String, locid As %String = "", HospID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s langid=..%LanguageID()
    s ind=1
    s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
    s ^tempscl("FindUser")=TUserName_","_locid
    i TUserName'="" d
    .s TUserName=$$ALPHAUP^SSUTIL4(TUserName)
    .s UserRowid=""
    .f  s UserRowid=$o(^SSU("SSUSR",UserRowid)) q:(UserRowid="")  d
    ..Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",UserRowid,HospID)="N"
    ..s Username=$p(^SSU("SSUSR",UserRowid),"^",2)
    ..q:Username=""
    ..s USRActive=$p(^SSU("SSUSR",UserRowid),"^",19)
	..q:USRActive'="Y"
    ..s SSUSRCareProvDR=$p(^SSU("SSUSR",UserRowid),"^",14)
    ..q:(SSUSRCareProvDR'="")&&(locid'="")&&'$d(^RB("RES",0,"CTPCP",SSUSRCareProvDR,locid))
    ..q:(SSUSRCareProvDR="")&&(locid'="")
    ..Q:Username=""
    ..i ##class(DHCDoc.Util.Base).CheckUserName("SS_User",UserRowid,TUserName,langid) d
    ...Do OutputRow3 
    e  d
    .s UserRowid=""
    .f  s UserRowid=$o(^SSU("SSUSR",UserRowid)) q:(UserRowid="")  d
    ..Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",UserRowid,HospID)="N"
    ..s SSUSRCareProvDR=$p(^SSU("SSUSR",UserRowid),"^",14)
    ..q:(SSUSRCareProvDR'="")&&(locid'="")&&'$d(^RB("RES",0,"CTPCP",SSUSRCareProvDR,locid))
    ..q:(SSUSRCareProvDR="")&&(locid'="")
    ..s USRActive=$p(^SSU("SSUSR",UserRowid),"^",19)
	..q:USRActive'="Y"
    ..s Username=$p(^SSU("SSUSR",UserRowid),"^",2)
    ..Q:Username=""
    ..Do OutputRow3
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow3
	set Username=##class(DHCDoc.Common.Translate).GetTransUser(Username,langid)
    set Data=$lb(Username,UserRowid)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
    Quit $$$OK
}

ClassMethod FindUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUserExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod FindUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUserExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
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

}
