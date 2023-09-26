Class web.DHCCRM.GetBaseInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

// w ##class(web.DHCCRM.GetBaseInfo).GetLoc("")

/*
ClassMethod GetLoc(LocDesc)
{  
    n (LocDesc)
    i LocDesc'="" d
    .s LocDesc=$ZCVT(LocDesc,"U")
    .s Desc=$o(^CTLOC(0,"Desc",LocDesc),-1)
    e  d
    .s Desc=""
    s json=##class(dhc.ca.cache.comm.JsonObj).%New()
    s jsonTitle="RowID^Name"
    s count=0
    f  s Desc=$o(^CTLOC(0,"Desc",Desc)) q:(Desc="")||(Desc'[LocDesc)  d
    .s RowID=0
    .f  s RowID=$o(^CTLOC(0,"Desc",Desc,RowID)) q:(RowID="")  d
    ..s Name=$P(^CTLOC(RowID),"^",2)
    ..s Name=..Replace(Name, $C(13), "")
    ..s Name=..Replace(Name, $C(9), "")
    ..s Name=..Replace(Name, $C(10), "")
    ..s tmp=RowID_"^"_Name
    ..d json.InsertRowData(tmp)
    ..s count=count+1
    s jsonStr = json.getJsonData(jsonTitle,count)
    k json
    q jsonStr
}
*/
Query FindHospital() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindHospitalExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s RowId=0
    s NowDate=+$H
    f  s RowId=$o(^CT("HOSP",RowId)) q:(RowId="")  d
    .s Name=$p(^CT("HOSP",RowId),"^",2) 
    .q:($p(^CT("HOSP",RowId),"^",9)>NowDate)&&($p(^CT("HOSP",RowId),"^",9)'="")
    .q:($p(^CT("HOSP",RowId),"^",10)<NowDate)&&($p(^CT("HOSP",RowId),"^",10)'="")
    .s ^CacheTemp(repid,ind)=$lb(RowId,Name)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// w ##class(web.DHCCRM.GetBaseInfo).GetYuanQu()
ClassMethod GetYuanQu()
{
    
    s json=##class(dhc.ca.cache.comm.JsonObj).%New()
    s jsonTitle="RowID^Name"
    s count=0
    s RowId=0
    s NowDate=+$H
    f  s RowId=$o(^CT("HOSP",RowId)) q:(RowId="")  d
    .s Name=$p(^CT("HOSP",RowId),"^",2) 
    .q:($p(^CT("HOSP",RowId),"^",9)>NowDate)&&($p(^CT("HOSP",RowId),"^",9)'="")
    .q:($p(^CT("HOSP",RowId),"^",10)<NowDate)&&($p(^CT("HOSP",RowId),"^",10)'="")
    .s tmp=RowId_"^"_Name
    .d json.InsertRowData(tmp)
    .s count=count+1
    s jsonStr = json.getJsonData(jsonTitle,count)

    k json
    q jsonStr
}

Query FindSex() As websys.Query(ROWSPEC = "id:%String,sex:%String")
{
}

ClassMethod FindSexExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^CT("SEX",id)) q:id=""  d
    .s sex=$P($G(^CT("SEX",id)),"^",2)
    .s ^CacheTemp(repid,ind)=$lb(id,sex)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

// w ##class(web.DHCCRM.GetBaseInfo).GetSex("")

ClassMethod GetSex(SexDesc)
{
   
    n (SexDesc)
    i SexDesc'="" d
    .s SexDesc=$ZCVT(SexDesc,"U")
    .s Desc=$o(^CTLOC(0,"Desc",SexDesc),-1)
    e  d
    .s Desc=""
    s json=##class(dhc.ca.cache.comm.JsonObj).%New()
    s jsonTitle="RowID^Name"
    s count=0
    f  s Desc=$o(^CT("SEX",0,"Desc",Desc)) q:(Desc="")||(Desc'[SexDesc)  d
    .s RowID=0
    .f  s RowID=$o(^CT("SEX",0,"Desc",Desc,RowID)) q:(RowID="")  d
    ..s Name=$p(^CT("SEX",RowID),"^",2) 
    ..s tmp=RowID_"^"_Name
    ..d json.InsertRowData(tmp)
    ..s count=count+1
    s jsonStr = json.getJsonData(jsonTitle,count)

    k json
    q jsonStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.GetBaseInfo","FindUser","0526")
Query FindUser(desc) As websys.Query(ROWSPEC = "id:%String,name:%String")
{
}

ClassMethod FindUserExecute(ByRef qHandle As %Binary, desc) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s id=0
    f  s id=$O(^SSU("SSUSR",id)) q:id=""  d
    .s name=$p(^SSU("SSUSR",id),"^",2)
    .S Initials=$p(^SSU("SSUSR",id),"^",1)
    .s name=name_"("_Initials_")"
    .q:(desc'="")&&(name'[desc)
    .s ^CacheTemp(repid,ind)=$lb(id,name)
    .s ind=ind+1
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// w ##class(web.DHCCRM.GetBaseInfo).GetUser("")
ClassMethod GetUser(UserDesc)
{
    s NowLoc=%session.Get("LOGON.CTLOCID")
    
    i UserDesc'="" d
    .s UserDesc=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserDesc),-1)
    s json=##class(dhc.ca.cache.comm.JsonObj).%New()
    s jsonTitle="RowID^Name"
    s count=0
    f  s UserDesc=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserDesc)) q:(UserDesc="")  d 
    .s RowID=0
    .f  s RowID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserDesc,RowID)) q:(RowID="")  d
    ..s Name=$p(^SSU("SSUSR",RowID),"^",2)
    ..s DepLoc=$p(^SSU("SSUSR",RowID),"^",4)
    ..q:(DepLoc'=$g(^DHCCRMSetting("LocId")))&&($d(^DHCCRMSetting("LocId")))
    ..s OtherLocSub=0,OtherLocStr=""
    ..f  s OtherLocSub=$o(^SSU("SSUSR",RowID,"OTHLL",OtherLocSub)) q:OtherLocSub=""  d
    ...s OtherLoc=$p(^SSU("SSUSR",RowID,"OTHLL",OtherLocSub),"^",1)
    ...s OtherLocStr=OtherLocStr_"^"_OtherLoc
    ..s OtherLocStr=OtherLocStr_"^"_DepLoc_"^"
    ..q:OtherLocStr'[("^"_NowLoc_"^")&&('$d(^DHCCRMSetting("LocId")))
    ..s Name=..Replace(Name, $C(13), "")
    ..s Name=..Replace(Name, $C(9), "")
    ..s Name=..Replace(Name, $C(10), "")
    ..s Initails=$p(^SSU("SSUSR",RowID),"^",1)
    ..s tmp=RowID_"^"_Name_"("_Initails_")"
    ..d json.InsertRowData(tmp)
    ..s count=count+1
    s jsonStr = json.getJsonData(jsonTitle,count)
    k json
    q jsonStr
}

// w ##class(web.DHCCRM.GetBaseInfo).GetQTICD()

ClassMethod GetQTICD(ICDDesc)
{
    n (ICDDesc)
    s json=##class(dhc.ca.cache.comm.JsonObj).%New()
    s jsonTitle="RowID^Name"
    s count=0
    s qtid=0
    f  s qtid=$o(^User.DHCCRMQTDiseaseD(qtid)) q:qtid=""  d
    .s Code=$lg(^User.DHCCRMQTDiseaseD(qtid),2)
    .s Name=$lg(^User.DHCCRMQTDiseaseD(qtid),3)
    .s tmp=qtid_"^"_Name
    .d json.InsertRowData(tmp)
    .s count=count+1
    s jsonStr = json.getJsonData(jsonTitle,count)
    k json
    q jsonStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.GetBaseInfo","FindICD","")
Query FindICD(ICDDesc) As websys.Query(ROWSPEC = "id:%String,name:%String")
{
}

ClassMethod FindICDExecute(ByRef qHandle As %Binary, ICDDesc) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s id=0
    f  s id=$O(^MRC("ID",id)) q:id=""  d
    .s name=$p(^MRC("ID",id),"^",2)
    .q:(ICDDesc'="")&&(name'[ICDDesc)
    .s ^CacheTemp(repid,ind)=$lb(id,name)
    .s ind=ind+1
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

// w ##class(web.DHCCRM.GetBaseInfo).GetICD("")

ClassMethod GetICD(ICDDesc)
{
    n (ICDDesc)
    ;i ICDDesc="" q "{results:0,rows:[{}]}"
    s Job=$J
    k ^TEMPCRM(Job)
    s json=##class(dhc.ca.cache.comm.JsonObj).%New()
    s jsonTitle="RowID^Name"
    s count=0
    i ICDDesc'="" d
    .s ICDDesc=$ZCVT(ICDDesc,"U")
    i ICDDesc'="" d
    .s ADesc=$o(^MRC("ID",0,"ALIAS",ICDDesc),-1)
    .f  s ADesc=$o(^MRC("ID",0,"ALIAS",ADesc)) q:(ADesc="")||(ADesc'[ICDDesc)  d
    ..s ICDID=0
    ..f  s ICDID=$o(^MRC("ID",0,"ALIAS",ADesc,ICDID)) q:ICDID=""  d
    ...q:$D(^TEMPCRM(Job,ICDID))
    ...s ^TEMPCRM(Job,ICDID)=""
    ...s Name=$p(^MRC("ID",ICDID),"^",2)
    ...s tmp=ICDID_"^"_Name
    ...d json.InsertRowData(tmp)
    ...s count=count+1
    .s ADesc=$o(^MRC("ID",0,"Desc",ICDDesc),-1)
    .f  s ADesc=$o(^MRC("ID",0,"Desc",ADesc)) q:(ADesc="")||(ADesc'[ICDDesc)  d
    ..s ICDID=0
    ..f  s ICDID=$o(^MRC("ID",0,"Desc",ADesc,ICDID)) q:ICDID=""  d
    ...q:$D(^TEMPCRM(Job,ICDID))
    ...s ^TEMPCRM(Job,ICDID)=""
    ...s Name=$p(^MRC("ID",ICDID),"^",2)
    ...s tmp=ICDID_"^"_Name
    ...d json.InsertRowData(tmp)
    ...s count=count+1
    s jsonStr = json.getJsonData(jsonTitle,count)
    k json
    q jsonStr
}

ClassMethod Replace(Strings, Str, Rep) As %String
{
    q $TR(Strings, Str, Rep)
}

/// w ##class(web.DHCCRM.GetBaseInfo).GetWard(0,20,"")
ClassMethod GetWard(start, limit, CTLocDesc As %Library.String = "")
{
   
    s start=$G(start)
    s limit=$G(limit)
    s rs=##class(%ResultSet).%New("web.DHCCRM.GetBaseInfo:SearchWard")
    d rs.Execute(CTLocDesc)
    s count=0
    s mess=""
    s topnum=start+limit
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        
        s RowId=rs.Get("CTLOC_RowId")
        s Code=rs.Get("CTLOC_Code")
        s Desc=rs.Get("CTLOC_Desc")
        
        i (mess'="") s mess=mess_","
        //RowID^Name
        s mess=mess_"{""RowID"":"_""""_RowId_""""
        s mess=mess_","_"""Name"":"_""""_Desc_""""
        s mess=mess_"}"
    }        
    s mess="["_mess_"]"

    s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"

    q mess
}

/// w ##class(web.DHCCRM.GetBaseInfo).GetLoc(0,20,"")
ClassMethod GetLoc(start, limit, CTLocDesc As %Library.String = "")
{
    s CTLocDesc=$zcvt($zcvt(CTLocDesc,"I","URL"),"I","UTF8")
    
    i CTLocDesc="" q "{results:0,rows:[{}]}"
    s start=$G(start)
    s limit=$G(limit)
    s rs=##class(%ResultSet).%New("web.DHCCRM.GetBaseInfo:SearchCTLoc")
    d rs.Execute(CTLocDesc)
    s count=0
    s mess=""
    s topnum=start+limit
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        
        s RowId=rs.Get("CTLOC_RowId")
        s Code=rs.Get("CTLOC_Code")
        s Desc=rs.Get("CTLOC_Desc")
        
        i (mess'="") s mess=mess_","
        //RowID^Name
        s mess=mess_"{""RowID"":"_""""_RowId_""""
        s mess=mess_","_"""Name"":"_""""_Desc_""""
        s mess=mess_"}"
    }        
    s mess="["_mess_"]"

    s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"

    q mess
}

Query SearchCTLoc(Desc As %String = "") As %Query(ROWSPEC = "CTLOC_Code:%String,CTLOC_Desc:%String, CTLOC_RowId:%String")
{
}

ClassMethod SearchCTLocExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
 
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    i Desc'=""  s Desc=$ZCVT(Desc,"U")
    s CTRowID=0
    f  s CTRowID=$o(^CTLOC(CTRowID))  q:CTRowID=""  d
    .s CTLOCDesc=$p($g(^CTLOC(CTRowID)),"^",2)
    .s CTLOCDesc=$ZCVT(CTLOCDesc,"U")
    .s CTLOCDesc=..Replace(CTLOCDesc, $C(13), "")
    .s CTLOCDesc=..Replace(CTLOCDesc, $C(9), "")
    .s CTLOCDesc=..Replace(CTLOCDesc, $C(10), "")
    .s CTLOCCode=$p($g(^CTLOC(CTRowID)),"^",1)
    .s CTLOCCode=..Replace(CTLOCCode, $C(13), "")
    .s CTLOCCode=..Replace(CTLOCCode, $C(9), "")
    .s CTLOCCode=..Replace(CTLOCCode, $C(10), "")
    .;q:'($d(^PAC("ADMLOC",0,"AdmType","I",CTRowID)))
    .q:(Desc'="")&&(CTLOCDesc'[Desc)
    .s DateFrom=$p($g(^CTLOC(CTRowID)),"^",24)
    .q:(DateFrom'="")&&(DateFrom>+$h)
    .s DateTo=$p($g(^CTLOC(CTRowID)),"^",25)
    .q:(DateTo'="")&&(DateTo<+$h)
    .d OutputRow

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(CTLOCCode,CTLOCDesc,CTRowID)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchCTLocExecute ]
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

ClassMethod SearchCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchCTLocExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query SearchWard(Loc As %String = "") As %Query(ROWSPEC = "CTLOC_Desc:%String,CTLOC_RowId:%String")
{
}

ClassMethod SearchWardExecute(ByRef qHandle As %Binary, Loc As %String = "") As %Status
{
 
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
   
   s CTLOCID=0
   f  s CTLOCID=$O(^CTLOC(CTLOCID)) q:CTLOCID=""  d
   .q:(Loc'="")&&(Loc'=CTLOCID)
   .s childsub=0  
   .f  s childsub=$O(^CTLOC(CTLOCID,"LINK",childsub)) q:childsub=""  d
   ..s LinkLocID=$P(^CTLOC(CTLOCID,"LINK",childsub),"^",1)
   ..s WardID=0  
   ..f  s WardID=$O(^PAWARD(0,"WARD_LocationDR",LinkLocID,WardID)) Q:WardID=""  d
   ...s Desc=$P(^PAWARD(WardID),"^",2)
   ...s Desc=$ZCVT(Desc,"U")
   ...s Desc=..Replace(Desc, $C(13), "")
   ...s Desc=..Replace(Desc, $C(9), "")
   ...s Desc=..Replace(Desc, $C(10), "")
   ...d OutputRowWard

   Set qHandle=$lb(0,repid,0)
   Quit $$$OK

OutputRowWard
    set Data=$lb(Desc,WardID)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchWardExecute ]
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

ClassMethod SearchWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchWardExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Storage Default
{
<Data name="GetBaseInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCRM.GetBaseInfoD</DataLocation>
<DefaultData>GetBaseInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCCRM.GetBaseInfoD</IdLocation>
<IndexLocation>^web.DHCCRM.GetBaseInfoI</IndexLocation>
<StreamLocation>^web.DHCCRM.GetBaseInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
