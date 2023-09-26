Class web.DHCCRM.CRMQuery Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMQuery","SearchUser")
Query SearchUser(UserNo) As %Query(ROWSPEC = "RowID:%String,Initails:%String,Name:%String") [ SqlProc ]
{
}

ClassMethod SearchUserExecute(ByRef qHandle As %Binary, UserNo) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    i UserNo=""
    {
        Set qHandle=$lb(0,repid,0)
        q $$$OK
    }
    s Desc=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserNo),-1)
    f  s Desc=$o(^SSU("SSUSR",0,"SSUSR_Initials",Desc)) q:(Desc="")||(Desc'[UserNo)  d
    .s RowID=0
    .f  s RowID=$o(^SSU("SSUSR",0,"SSUSR_Initials",Desc,RowID)) q:(RowID="")  d
    ..s Name=$p(^SSU("SSUSR",RowID),"^",2)
    ..s Initails=$p(^SSU("SSUSR",RowID),"^",1)
    ..Do OutputRow
    
    s Desc=$o(^SSU("SSUSR",0,"SSUSR_Name",UserNo),-1)
    f  s Desc=$o(^SSU("SSUSR",0,"SSUSR_Name",Desc)) q:(Desc="")||(Desc'[UserNo)  d
    .s RowID=0
    .f  s RowID=$o(^SSU("SSUSR",0,"SSUSR_Name",Desc,RowID)) q:(RowID="")  d
    ..s Name=$p(^SSU("SSUSR",RowID),"^",2)
    ..s Initails=$p(^SSU("SSUSR",RowID),"^",1)
    ..Do OutputRow
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(RowID,Initails,Name)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchUserExecute ]
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

ClassMethod SearchUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchUserExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMQuery","SearchFusb")
Query SearchFusb() As %Query(ROWSPEC = "RowId:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod SearchFusbExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1

    s RowId=0
    f  s RowId=$o(^DHCCRMFUS(RowId)) q:RowId=""  d
    .s Code=$p(^DHCCRMFUS(RowId),"^",1)
    .s Desc=$p(^DHCCRMFUS(RowId),"^",2)
    .s Limit=$p(^DHCCRMFUS(RowId),"^",4)
    .s Begin=$p(^DHCCRMFUS(RowId),"^",5)
    .s End=$p(^DHCCRMFUS(RowId),"^",6)
    .q:(Limit="Y")&&(Begin'="")&&(Begin>+$h)
    .q:(Limit="Y")&&(End'="")&&(End<+$h)
    .Do OutputRow
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(RowId,Desc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchFusbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchFusbExecute ]
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

ClassMethod SearchFusbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchFusbExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMQuery","SearchQRecord","2021-07-01","2022-07-15","")
Query SearchQRecord(BeginDate, EndDate, UserNo) As %Query(ROWSPEC = "qrrowid:%String,FUPDR:%String,PAADMDR:%String,PAPMIDR:%String,Status:%String,UpdateDate:%String,UpdateTime:%String,UserDR:%String,UserName:%String,LinkDesc:%String,FUPDemo:%String,papmidead:%String,LinkNum:%Integer,PatientType:%String") [ SqlProc ]
{
}

ClassMethod SearchQRecordExecute(ByRef qHandle As %Binary, BeginDate, EndDate, UserNo) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    

    i BeginDate="" s BeginDate=+$h
    e  s BeginDate=$zdh(BeginDate,3)
    i EndDate="" s EndDate=+$h
    e  s EndDate=$zdh(EndDate,3)
    s Qdate=BeginDate-1
    f  s Qdate=$o(^DHCCRMFUP(0,"FUP_FUDate",Qdate)) q:(Qdate>EndDate)||(Qdate="")  d
    .s FUPDR=0
    .f  s FUPDR=$o(^DHCCRMFUP(0,"FUP_FUDate",Qdate,FUPDR)) q:FUPDR=""  d
    ..s PAADMDR=$p($g(^DHCCRMFUP(FUPDR)),"^",1)
    ..s FUPDemo=$p($g(^DHCCRMFUP(FUPDR)),"^",6)
    ..s LinkNum=$p($g(^DHCCRMFUP(FUPDR)),"^",7)
    ..s papmidead=$p($g(^DHCCRMFUP(FUPDR)),"^",8)
    ..s LinkDesc=$p($g(^DHCCRMFUP(FUPDR)),"^",14)
    ..s PatientType=$p($g(^DHCCRMFUP(FUPDR)),"^",11)
    ..s UserName=""
    ..s UserDR=$p(^DHCCRMFUP(FUPDR),"^",17)
    ..i UserDR'="" s UserName=$p(^SSU("SSUSR",UserDR),"^",2)
    ..s qrrowid=$o(^DHCCRMQR(0,"QR_FUP_DR",FUPDR,0))
    ..s (PAPMIDR,Status,UpdateDate,UpdateTime)=""
    ..i qrrowid'="" d
    ...s UserDR=$p(^DHCCRMQR(qrrowid),"^",7)
    ...s UserName=$p(^SSU("SSUSR",UserDR),"^",2)
    ...s Status=$p(^DHCCRMQR(qrrowid),"^",4)
    ...s PAPMIDR=$p(^DHCCRMQR(qrrowid),"^",3)
    ..q:UserName=""
    ..Do OutputRow

    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(qrrowid,FUPDR,PAADMDR,PAPMIDR,Status,UpdateDate,UpdateTime,UserDR,UserName,LinkDesc,FUPDemo,papmidead,LinkNum,PatientType)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchQRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchQRecordExecute ]
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

ClassMethod SearchQRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchQRecordExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMQuery","SearchQRecordDetail","2013-11-14","2013-11-14","5","")
Query SearchQRecordDetail(BeginDate, EndDate, Subject, IsSatisfaction, LOC As %String) As %Query(ROWSPEC = "qrrowid:%String,QRDSubjectDetailDR:%String,FusbName:%String,Result1:%String,Result2:%String,Result3:%String") [ SqlProc ]
{
}

ClassMethod SearchQRecordDetailExecute(ByRef qHandle As %Binary, BeginDate, EndDate, Subject, IsSatisfaction, LOC As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    if (Subject="") s Subject=4
    i BeginDate="" s BeginDate=+$h
    e  s BeginDate=$zdh(BeginDate,3)
    i EndDate="" s EndDate=+$h
    e  s EndDate=$zdh(EndDate,3)
    
    
    s qrrowid=0
    f  s qrrowid=$o(^DHCCRMQR(0,"QRD_Subject_DR",Subject,qrrowid)) q:qrrowid=""  d
    
    .s FUPDR=$p(^DHCCRMQR(qrrowid),"^",1)
    .s LinkNum=$p($g(^DHCCRMFUP(FUPDR)),"^",7)
    .q:(LinkNum>=3)
    
    .s PAADM=$p(^DHCCRMQR(qrrowid),"^",2)
    .s CTLOC=$p(^PAADM(PAADM),"^",4)
    .q:(LOC'="")&&(LOC'=CTLOC)
    .s QRDSub=0
    .f  s QRDSub=$o(^DHCCRMQR(0,"QRD_Subject_DR",Subject,qrrowid,QRDSub)) q:QRDSub=""  d
    ..s QRDSubjectDetailDR=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",2)
    ..q:QRDSubjectDetailDR=""
    ..s QRDDate=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",5)
    ..q:QRDDate>EndDate
    ..q:QRDDate<BeginDate
    ..
    ..s FusbName=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",2)
    ..s QRDSubjectDetailResult=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",3)
    ..q:QRDSubjectDetailResult=""
    ..s Result=$p(QRDSubjectDetailResult,"$",1)
    ..s Result1="",Result2="",Result3=""
    ..i (Result="满意") s Result1="Y"
    ..s Result1="Y"
    ..i (Result="较满意") s Result2="Y"
    ..i (Result="不满意") s Result3="Y"
    ..i (IsSatisfaction="MY")&&(Result2="Y") s Result1="Y",Result2=""
    ..i (IsSatisfaction="BMY")&&(Result2="Y") s Result3="Y",Result2=""
    ..Do OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(qrrowid,QRDSubjectDetailDR,FusbName,Result1,Result2,Result3)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchQRecordDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchQRecordDetailExecute ]
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

ClassMethod SearchQRecordDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchQRecordDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query SearchIPAADM(BeginDate, EndDate) As %Query(ROWSPEC = "TLoc:%String,TADMNum:%String,TSussces:%String,TDocPercent:%String,TPerNum:%String,TSatisPercent:%String,Mum1:%String,Mum2:%String,Mum3:%String,Mum4:%String") [ SqlProc ]
{
}

ClassMethod SearchIPAADMExecute(ByRef qHandle As %Binary, BeginDate, EndDate) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    ;w !,BeginDate_"E"_EndDate
    i BeginDate="" s BeginDate=+$h
    ;e  s BeginDate=$zdh(BeginDate,3)
    i EndDate="" s EndDate=+$h
    ;e  s EndDate=$zdh(EndDate,3)
    s UserID=%session.Get("LOGON.USERID")
    s ExportName="DHCCRMSta"
    k ^TempDHCPEExportCommon
    
    
    k ^DHCCRMStatistics
    s Job=$j
    d CreatData
    
    s CTDesc="",ALLNum="",SescussNum="",DocPercent="",PerCount="",SatisPercent=""
    s CTLOC=0,Num1=0,Num2=0,Num3=0,Num4=0
    f  s CTLOC=$o(^DHCCRMStatistics(Job,CTLOC)) q:(CTLOC="")  d
    .s CTDesc=$p(^CTLOC(CTLOC),"^",2)
    .;w !,CTLOC_"@@"_CTDesc
    .s ALLNum=$g(^DHCCRMStatistics(Job,CTLOC,"ALL"))
    .s SescussNum=$g(^DHCCRMStatistics(Job,CTLOC,"Secseccs"))
    .s:(+$g(^DHCCRMStatistics(Job,CTLOC,"Secseccs"))'=0) DocPercent=$g(^DHCCRMStatistics(Job,CTLOC,"Doc"))/$g(^DHCCRMStatistics(Job,CTLOC,"Secseccs"))*100
    .s:(+$g(^DHCCRMStatistics(Job,CTLOC,"Secseccs"))'=0) PerCount=$g(^DHCCRMStatistics(Job,CTLOC,"AllCount"))/$g(^DHCCRMStatistics(Job,CTLOC,"Secseccs"))
    .s:(+$g(^DHCCRMStatistics(Job,CTLOC,"Secseccs"))'=0) SatisPercent=($g(^DHCCRMStatistics(Job,CTLOC,"Secseccs"))-$g(^DHCCRMStatistics(Job,CTLOC,"NoSatis")))/$g(^DHCCRMStatistics(Job,CTLOC,"Secseccs"))*100
    .
    .s:($g(^DHCCRMStatistics(Job,CTLOC,"Secseccs"))="") DocPercent=""  ;$g(^DHCCRMStatistics(Job,CTLOC,"Doc"))/$g(^DHCCRMStatistics(Job,CTLOC,"Secseccs"))*100
    .s:($g(^DHCCRMStatistics(Job,CTLOC,"Secseccs"))="") PerCount=""  ;$g(^DHCCRMStatistics(Job,CTLOC,"AllCount"))/$g(^DHCCRMStatistics(Job,CTLOC,"Secseccs"))
    .s:($g(^DHCCRMStatistics(Job,CTLOC,"Secseccs"))="") SatisPercent=""  ;($g(^DHCCRMStatistics(Job,CTLOC,"Secseccs"))-$g(^DHCCRMStatistics(Job,CTLOC,"NoSatis")))/$g(^DHCCRMStatistics(Job,CTLOC,"Secseccs"))*100
    .
    .s Num1=$g(^DHCCRMStatistics(Job,CTLOC,"Num1"))
    .s Num2=$g(^DHCCRMStatistics(Job,CTLOC,"Num2"))
    .s Num3=$g(^DHCCRMStatistics(Job,CTLOC,"Num3"))
    .s Num4=$g(^DHCCRMStatistics(Job,CTLOC,"Num4"))
    .Do OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
CreatData
    /*
    s QRecordID=0
    f  s QRecordID=$o(^DHCCRMQR(QRecordID)) q:(QRecordID="")  d
    .s Date=$p(^DHCCRMQR(QRecordID),"^",5)*/
    
    s PlanID=0
    f  s PlanID=$o(^DHCCRMFUP(PlanID)) q:(PlanID="")  d
    .s Date=$p($g(^DHCCRMFUP(PlanID)),"^",3)
    .s SubDR=$p($g(^DHCCRMFUP(PlanID)),"^",2)
    .s PAADM=$p($g(^DHCCRMFUP(PlanID)),"^",1)
    .q:(SubDR'="2")
    .q:(EndDate<Date)||(Date<BeginDate)
    .;s PAADM=$p(^DHCCRMQR(QRecordID),"^",2)
    .s LOC=$p(^PAADM(PAADM),"^",4)
    .;q:(LOC'=47)
    .s ^DHCCRMStatistics(Job,LOC,"ALL")=$g(^DHCCRMStatistics(Job,LOC,"ALL"))+1
    .q:('$d(^DHCCRMQR(0,"QR_FUP_DR",PlanID)))
    .s QRecordID=$o(^DHCCRMQR(0,"QR_FUP_DR",PlanID,0))
    .;s PlanID=$p(^DHCCRMQR(QRecordID),"^")
    .q:($p(^DHCCRMFUP(PlanID),"^",6)="联系不上")
    .
    .s ^DHCCRMStatistics(Job,LOC,"Secseccs")=$g(^DHCCRMStatistics(Job,LOC,"Secseccs"))+1
    .s DocResultSub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR","2||15",QRecordID,0))
    .q:(DocResultSub="")
    .s DocResult=$p($g(^DHCCRMQR(QRecordID,"Detail",DocResultSub)),"^",3)  ;2||15
    .s SatisSub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR","2||11",QRecordID,0))
    .s SatisResult=$p($g(^DHCCRMQR(QRecordID,"Detail",SatisSub)),"^",3)
    .s Count=0
    .s:("非常满意$$$"=SatisResult) Count=100
    .s:("非常满意$$$"=SatisResult) ^DHCCRMStatistics(Job,LOC,"Num1")=$g(^DHCCRMStatistics(Job,LOC,"Num1"))+1
    .s:("满意$$"=SatisResult) Count=80
    .s:("满意$$"=SatisResult) ^DHCCRMStatistics(Job,LOC,"Num2")=$g(^DHCCRMStatistics(Job,LOC,"Num2"))+1
    .s:("基本满意$"=SatisResult)||("较满意$"=SatisResult) Count=60
    .s:("基本满意$"=SatisResult)||("较满意$"=SatisResult) ^DHCCRMStatistics(Job,LOC,"Num3")=$g(^DHCCRMStatistics(Job,LOC,"Num3"))+1
    .s:("不满意"=SatisResult) Count=40
    .s:("不满意"=SatisResult) ^DHCCRMStatistics(Job,LOC,"Num4")=$g(^DHCCRMStatistics(Job,LOC,"Num4"))+1
    .;w !,SatisResult_"&&"_Count
    .s:("不满意"=SatisResult) ^DHCCRMStatistics(Job,LOC,"NoSatis")=$g(^DHCCRMStatistics(Job,LOC,"NoSatis"))+1
    .s:(DocResult="是$") ^DHCCRMStatistics(Job,LOC,"Doc")=$g(^DHCCRMStatistics(Job,LOC,"Doc"))+1
    .s ^DHCCRMStatistics(Job,LOC,"AllCount")=$g(^DHCCRMStatistics(Job,LOC,"AllCount"))+Count
    
    
    
    

OutputRow
    s DocPercent=$p(($g(DocPercent)*100),".")
    s DocPercent=DocPercent/100
    s SatisPercent=$p(($g(SatisPercent)*100),".")
    s SatisPercent=SatisPercent/100
    s PerCount=$p(($g(PerCount)*100),".")
    s PerCount=PerCount/100
    set Data=$lb(CTDesc,ALLNum,SescussNum,DocPercent,PerCount,SatisPercent,Num1,Num2,Num3,Num4)
    s ^TempDHCPEExportCommon(UserID,ExportName,ind)=$g(CTDesc)_"^"_$g(ALLNum)_"^"_$g(SescussNum)_"^"_$g(DocPercent)_"^"_$g(PerCount)_"^"_$g(SatisPercent)_"^"_$g(Num1)_"^"_$g(Num2)_"^"_$g(Num3)_"^"_$g(Num4)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchIPAADMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchIPAADMExecute ]
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

ClassMethod SearchIPAADMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchIPAADMExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query SearchAdvice(BeginDate, EndDate, LOC) As %Query(ROWSPEC = "Name:%String,LocDesc:%String,SatisResult:%String,ItemT1:%String,ItemT2:%String,ItemT3:%String,ItemT4:%String,ItemT5:%String,ItemT6:%String,ItemT7:%String") [ SqlProc ]
{
}

ClassMethod SearchAdviceExecute(ByRef qHandle As %Binary, BeginDate, EndDate, LOC) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    ;w !,BeginDate_"E"_EndDate
    i BeginDate="" s BeginDate=+$h
    ;e  s BeginDate=$zdh(BeginDate,3)
    i EndDate="" s EndDate=+$h
    ;e  s EndDate=$zdh(EndDate,3)
    s UserID=%session.Get("LOGON.USERID")
    s ExportName="DHCCRMAdv"
    k ^TempDHCPEExportCommon
    ; 2||14
    k ^DHCCRMAdvTemp
    
    s QRecordID=0
    f  s QRecordID=$o(^DHCCRMQR(QRecordID)) q:(QRecordID="")  d
    .s Date=$p(^DHCCRMQR(QRecordID),"^",5)
    .q:(EndDate<Date)||(Date<BeginDate)
    .s PAADM=$p(^DHCCRMQR(QRecordID),"^",2)
    .s PAT=$p(^PAADM(PAADM),"^")
    .s Name=$p(^PAPER(PAT,"ALL"),"^")
    .s CTLoc=$p(^PAADM(PAADM),"^",4)
    .q:(CTLoc'=LOC)&&(LOC'="")
    .s LocDesc=$p(^CTLOC(CTLoc),"^",2)
    .s SatisSub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR","2||14",QRecordID,0))
    .;q:(SatisSub="")
    .s item1Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR","2||16",QRecordID,0))
    .s item2Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR","2||17",QRecordID,0))
    .s item3Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR","2||18",QRecordID,0))
    .s item4Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR","2||19",QRecordID,0))
    .s item5Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR","2||20",QRecordID,0))
    .s item6Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR","2||21",QRecordID,0))
    .s item7Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR","2||22",QRecordID,0))
    .i SatisSub'="" s SatisResult=$p($g(^DHCCRMQR(QRecordID,"Detail",SatisSub)),"^",3)
    .//q:(SatisResult="")
    .i item1Sub'="" s item1=$p($g(^DHCCRMQR(QRecordID,"Detail",item1Sub)),"^",3)
    .i item2Sub'="" s item2=$p($g(^DHCCRMQR(QRecordID,"Detail",item2Sub)),"^",3)
    .i item3Sub'="" s item3=$p($g(^DHCCRMQR(QRecordID,"Detail",item3Sub)),"^",3)
    .i item4Sub'="" s item4=$p($g(^DHCCRMQR(QRecordID,"Detail",item4Sub)),"^",3)
    .i item5Sub'="" s item5=$p($g(^DHCCRMQR(QRecordID,"Detail",item5Sub)),"^",3)
    .i item6Sub'="" s item6=$p($g(^DHCCRMQR(QRecordID,"Detail",item6Sub)),"^",3)
    .i item7Sub'="" s item7=$p($g(^DHCCRMQR(QRecordID,"Detail",item7Sub)),"^",3)
    .s ^DHCCRMAdvTemp("Loc",CTLoc,QRecordID)=$g(Name)_"^"_$g(LocDesc)_"^"_$g(SatisResult)_"^"_$g(item1)_"^"_$g(item2)_"^"_$g(item3)_"^"_$g(item4)_"^"_$g(item5)_"^"_$g(item6)_"^"_$g(item7)
    
    
    s CTLOC=0
    f  s CTLOC=$o(^DHCCRMAdvTemp("Loc",CTLOC)) q:(CTLOC="")  d
    .s id=0,i=0,m=0
    .f  s id=$o(^DHCCRMAdvTemp("Loc",CTLOC,id)) q:(id="")  d
    ..s i=i+1
    .f  s id=$o(^DHCCRMAdvTemp("Loc",CTLOC,id)) q:(id="")  d
    ..s Result1=$p($g(^DHCCRMAdvTemp("Loc",CTLOC,id)),"^",1)
    ..s Result2=$p($g(^DHCCRMAdvTemp("Loc",CTLOC,id)),"^",2)
    ..s Result3=$p($g(^DHCCRMAdvTemp("Loc",CTLOC,id)),"^",3)
    ..s ItemT1=$p($g(^DHCCRMAdvTemp("Loc",CTLOC,id)),"^",4)
    ..s ItemT2=$p($g(^DHCCRMAdvTemp("Loc",CTLOC,id)),"^",5)
    ..s ItemT3=$p($g(^DHCCRMAdvTemp("Loc",CTLOC,id)),"^",6)
    ..s ItemT4=$p($g(^DHCCRMAdvTemp("Loc",CTLOC,id)),"^",7)
    ..s ItemT5=$p($g(^DHCCRMAdvTemp("Loc",CTLOC,id)),"^",8)
    ..s ItemT6=$p($g(^DHCCRMAdvTemp("Loc",CTLOC,id)),"^",9)
    ..s ItemT7=$p($g(^DHCCRMAdvTemp("Loc",CTLOC,id)),"^",10)
    ..//s i=i+1
    ..i (Result3="") d
    ...s m=m+1
    ..i (i=m) d
    ...s Result3="无"
    ..i (Result3'="") d
    ...d OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

    
    

OutputRow
    
    set Data=$lb(Result1,Result2,Result3,ItemT1,ItemT2,ItemT3,ItemT4,ItemT5,ItemT6,ItemT7)
    s ^TempDHCPEExportCommon(UserID,ExportName,ind)=$g(Result1)_"^"_$g(Result2)_"^"_$g(Result3)_"^"_$g(ItemT1)_"^"_$g(ItemT2)_"^"_$g(ItemT3)_"^"_$g(ItemT4)_"^"_$g(ItemT5)_"^"_$g(ItemT6)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchAdviceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchAdviceExecute ]
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

ClassMethod SearchAdviceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchAdviceExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

///     
/// Creator：      ch
/// CreatDate：    2012-06-8
/// Description:： 解析科室
/// Table：       CT_Loc
/// Input：       ""
/// Output：     Wardid,WardCode,WardDesc
/// Return：      
/// Others:      d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMQuery","QueryLoc")
Query QueryLoc() As %Query(ROWSPEC = "mLocId:%String,mLocCode:%String,mLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryLocExecute(ByRef qHandle As %Binary) As %Status
{
    ;n (qHandle) 
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1,flag=1
    s Locid=""
    f  s Locid=$O(^CTLOC(Locid)) Q:Locid=""  d
    .s mLocCode=$P($G(^CTLOC(Locid)),"^",1)
    .s mLocDesc=$P($g(^CTLOC(Locid)),"^",2)
    .s mLocId=$G(Locid)
    .q:'$d(^PAC("ADMLOC",0,"AdmType","I",Locid))
    .;Q:WardActive="N"
    .;i WardDesc["-" s WardDesc=$P(WardDesc,"-",2)
    .;Q:WardDesc["停用"
    .d OutPutWard
    Quit $$$OK
OutPutWard
    s Data=$lb(mLocId,mLocCode,mLocDesc)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod QueryLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocExecute ]
{
    ;n (qHandle)
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocExecute ]
{
    ;n (qHandle,Row,AtEnd)
    ;n (Row,AtEnd)
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

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMQuery","SearchQRecordYiJian","2014-01-01","")
Query SearchQRecordYiJian(BeginDate, EndDate) As %Query(ROWSPEC = "ind:%String,disdate:%String,QRDDate:%String,CTDesc:%String,mrname:%String,mrmrid:%String,disdiag:%String,mrtel:%String,FKInfo:%String,BYInfo:%String,UserName:%String") [ SqlProc ]
{
}

ClassMethod SearchQRecordYiJianExecute(ByRef qHandle As %Binary, BeginDate, EndDate) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    i BeginDate="" s BeginDate=+$h
    e  s BeginDate=$zdh(BeginDate,3)
    i EndDate="" s EndDate=+$h
    e  s EndDate=$zdh(EndDate,3)
    
    s Subject=4
    s qrrowid=0,CTDesc="",BYInfo="",FKInfo=""
    f  s qrrowid=$o(^DHCCRMQR(0,"QRD_Subject_DR",Subject,qrrowid)) q:qrrowid=""  d
    .s FUPDR=$p(^DHCCRMQR(qrrowid),"^",1)
    .s UserID=$p(^DHCCRMQR(qrrowid),"^",7)
    .s UserName=$p(^SSU("SSUSR",UserID),"^",2)
    .s LinkNum=$p($g(^DHCCRMFUP(FUPDR)),"^",7)
    .q:(LinkNum>=3)
    .s PAADM=$p(^DHCCRMQR(qrrowid),"^",2)
    .s CTLOC=$p(^PAADM(PAADM),"^",4)
    .i CTLOC'="" s CTDesc=$p(^CTLOC(CTLOC),"^",2)
    .s disdate=$P($g(^PAADM(PAADM)),"^",17) //出院日期
    .i disdate'="" s disdate=$zd(disdate,3)
    .s papmiid=$p(^PAADM(PAADM),"^",1)
    .s pttype=$P($g(^PAADM(PAADM)),"^",2)
    .s mrmrid=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(PAADM,pttype,.ErrMsg)  // $p(^PAPER(papmiid,"PAT",1),"^",22) //住院号
    .s mrname=$p(^PAPER(papmiid,"ALL"),"^",1)
    .s disdiag=##class(web.DHCCRM.SetPlan).GetAllMDiagnos(PAADM) //diagnos
    .s mrtel=$p(^PAPER(papmiid,"PER",1),"^",11)
    .s QRDSub=0
    .f  s QRDSub=$o(^DHCCRMQR(0,"QRD_Subject_DR",Subject,qrrowid,QRDSub)) q:QRDSub=""  d
    ..s QRDSubjectDetailDR=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",2)
    ..q:QRDSubjectDetailDR=""
    ..s QRDDate=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",5)
    ..q:QRDDate>EndDate
    ..q:QRDDate<BeginDate
    ..i QRDDate'="" s QRDDate=$zd(QRDDate,3)
    ..s FusbName=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",2)
    ..s QRDSubjectDetailResult=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",3)
    ..s QRDSubjectDetailId=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",2)
    ..s DetailName=$p(^DHCCRMFUS(+QRDSubjectDetailId,"SD",$p(QRDSubjectDetailId,"||",2)),"^",2)
    ..i DetailName="表扬信息" s BYInfo=QRDSubjectDetailResult
    ..i DetailName="反馈意见" s FKInfo=QRDSubjectDetailResult
    .Do OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(ind,disdate,QRDDate,CTDesc,mrname,mrmrid,disdiag,mrtel,FKInfo,BYInfo,UserName)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchQRecordYiJianFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchQRecordYiJianExecute ]
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

ClassMethod SearchQRecordYiJianClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchQRecordYiJianExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 按问卷答题情况判断手术科室和非手术科室
/// 出院患者满意度：第五题选择“是”为手术科室，“否”为非手术科室
ClassMethod IsSSKS(qrrowid)
{
    s QRDSub=0,Flag=""
    f  s QRDSub=$o(^DHCCRMQR(0,"QRD_Subject_DR",4,qrrowid,QRDSub)) q:QRDSub=""  d
    .s QRDSubjectDetailDR=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",2)
    .s Result=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",3)
    .s Template=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",4)
    .s Template=$p(Template,"$",1)
    .s FenShu=$p(Template,"@",1)
    .i QRDSubjectDetailDR="4||5" d
    ..i $p(Result,"$",1)'="" s Flag="SSKS"
    ..i Result'["$" s Flag="FSSKS"
    q Flag
}

/// Creator:wangbigan
/// 判断是手术科室还是非手术科室
ClassMethod PanduanSSKS1(LocId)
{
     s Flag=""
     ;if LocId="87"||"13"||"15"||"18"||"19"||"20"||"21"||"23"||"24"||"25"||"26"||"27"||"28"||"45"||"543"||"50"||"1609"||"552"  s Flag="FSSKS"
     if (LocId="30")||(LocId="31")||(LocId="33")||(LocId="34")||(LocId="36")||(LocId="37")||(LocId="40")||(LocId="41")||(LocId="42")||(LocId="43")||(LocId="44")||(LocId="46")||(LocId="47")||(LocId="48")||(LocId="1594")||(LocId="1595")||(LocId="1597")||(LocId="1598")||(LocId="1600")||(LocId="1606")||(LocId="1599")  s Flag="SSKS"
     else  if (LocId="87")||(LocId="13")||(LocId="15")||(LocId="18")||(LocId="19")||(LocId="20")||(LocId="21")||(LocId="23")||(LocId="24")||(LocId="25")||(LocId="26")||(LocId="27")||(LocId="28")||(LocId="45")||(LocId="543")||(LocId="50")||(LocId="1609")||(LocId="552")||(LocId="1603")||(LocId="1601")||(LocId="1602")||(LocId="1596")||(LocId="1604")||(LocId="51")  s Flag="FSSKS"
           else  s Flag="QTKS"
     q Flag
}

/// Creator:wangbigan
/// 判断是手术科室还是非手术科室
ClassMethod PanduanSSKS(Depid)
{
     s Flag=""
     if (Depid="20")||(Depid="21")||(Depid="22")||(Depid="23")||(Depid="24")||(Depid="25")||(Depid="28")||(Depid="29")||(Depid="31")||(Depid="32")||(Depid="33")||(Depid="35")||(Depid="38")||(Depid="27")||(Depid="125")  s Flag="SSKS"
     else  if (Depid="121")||(Depid="6")||(Depid="8")||(Depid="9")||(Depid="10")||(Depid="11")||(Depid="12")||(Depid="13")||(Depid="14")||(Depid="15")||(Depid="16")||(Depid="17")||(Depid="18")||(Depid="34")||(Depid="39")||(Depid="40")||(Depid="43")||(Depid="41")  s Flag="FSSKS"
           else  s Flag="QTKS"
     q Flag
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMQuery","SearchXHQRecord","2015-01-01","2015-02-10")
Query SearchXHQRecord(BeginDate, EndDate, CTType) As %Query(ROWSPEC = "PAADM:%String,PatNo:%String,LocId:%String,LocDesc:%String,SDId:%String,SDShunXu:%Integer,SDName:%String,Result:%String,FenShu:%Integer,BeiZhu:%String,Departdr:%Integer,Department:%String") [ SqlProc ]
{
}

ClassMethod SearchXHQRecordExecute(ByRef qHandle As %Binary, BeginDate, EndDate, CTType) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    i BeginDate="" s BeginDate=+$h
    e  s BeginDate=$zdh(BeginDate,3)
    i EndDate="" s EndDate=+$h
    e  s EndDate=$zdh(EndDate,3)
    s Subject=4
    
    s qrrowid=0
    f  s qrrowid=$o(^DHCCRMQR(0,"QRD_Subject_DR",Subject,qrrowid)) q:qrrowid=""  d
    .s FUPDR=$p(^DHCCRMQR(qrrowid),"^",1)
    .s LinkNum=$p($g(^DHCCRMFUP(FUPDR)),"^",7)
    .q:(LinkNum>=1) //联系不上
    
    .s FupDate=$p($g(^DHCCRMFUP(FUPDR)),"^",3)
    .q:FupDate>EndDate
    .q:FupDate<BeginDate
    .s PAADM=$p(^DHCCRMQR(qrrowid),"^",2)
    .s papmiid=$p(^PAADM(PAADM),"^",1)
    .s PatNo=$p(^PAPER(papmiid,"PAT",1),"^",1) 
    .s LocId=$p(^PAADM(PAADM),"^",4)
    .S Departdr=$P(^CTLOC(LocId),"^",19)
    .s RealType=..PanduanSSKS(Departdr)
    .s Department=$P(^RBC("DEP",Departdr),"^",2)  //科室组 addwbg
    .q:(CTType="MZKS")&&(RealType="FSSKS")
    .q:(CTType="SSKS")&&(RealType="FSSKS")
    .q:(CTType="FSSKS")&&(RealType="SSKS")
    .s LocDesc=$p($p(^CTLOC(LocId),"^",2),"-",2)
    .s QRDSub=0
    .f  s QRDSub=$o(^DHCCRMQR(0,"QRD_Subject_DR",Subject,qrrowid,QRDSub)) q:QRDSub=""  d
    ..s QRDSubjectDetailDR=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",2)
    ..q:QRDSubjectDetailDR=""
    ..q:(CTType="SSKS")&&(QRDSubjectDetailDR="4||8")
    ..q:(CTType="MZKS")&&(QRDSubjectDetailDR'="4||8")
    ..q:(CTType="YYKS")&&(QRDSubjectDetailDR'="4||14")
    ..s QRDDate=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",5)
    ..;q:QRDDate>EndDate
    ..;q:QRDDate<BeginDate
    ..s SDId=QRDSubjectDetailDR
    ..s SDName=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",2)
    ..s SDType=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",3)
    ..q:(CTType'="YYKS")&&(SDType="N")
    ..q:SDType="T"
    ..q:SDType="D"
    ..s SDShunXu=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",11)
    ..s Result=""
    ..s Result=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",3)
    ..q:Result=""
    ..s Result=$p(Result,"$",1)
    ..s Template=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",4)
    ..s FenShu=""
    ..s Template=$p(Template,"$",1)
    ..q:$p(Template,"@",1)=""
    ..s FenShu=+$p(Template,"@",1)*10
    ..s BeiZhu=$p(Template,"@",2)
    ..
    ..Do OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(PAADM,PatNo,LocId,LocDesc,SDId,SDShunXu,SDName,Result,FenShu,BeiZhu,Departdr,Department)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchXHQRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchXHQRecordExecute ]
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

ClassMethod SearchXHQRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchXHQRecordExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 各科室满意度调查详细数据
/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMQuery","SearchXHQRecordDetail","2015-01-01","2015-02-28","45")
Query SearchXHQRecordDetail(BeginDate, EndDate, Depdr, WardId, PatID, PatName) As %Query(ROWSPEC = "PAADM:%Integer,PatNo:%String,binganno:%String,mrname:%String,mrtel:%String,LocId:%Integer,LocDesc:%String,LocWard:%String,SDId:%Integer,SDShunXu:%Integer,SDName:%String,Result:%String,FenShu:%String,BeiZhu:%String,Departdr:%Integer,Department:%String") [ SqlProc ]
{
}

ClassMethod SearchXHQRecordDetailExecute(ByRef qHandle As %Binary, BeginDate, EndDate, Depdr, WardId, PatID, PatName) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    i BeginDate="" s BeginDate=+$h
    e  s BeginDate=$zdh(BeginDate,3)
    i EndDate="" s EndDate=+$h
    e  s EndDate=$zdh(EndDate,3)
    s Subject=4
    
    s qrrowid=0
    f  s qrrowid=$o(^DHCCRMQR(0,"QRD_Subject_DR",Subject,qrrowid)) q:qrrowid=""  d
    .s FUPDR=$p(^DHCCRMQR(qrrowid),"^",1)
    .s LinkNum=$p($g(^DHCCRMFUP(FUPDR)),"^",7)
    .q:(LinkNum>=1) //联系不上
    .s FupDate=$p($g(^DHCCRMFUP(FUPDR)),"^",3)
    .q:FupDate>EndDate
    .q:FupDate<BeginDate
    .s PAADM=$p(^DHCCRMQR(qrrowid),"^",2)
    .s papmiid=$p(^PAADM(PAADM),"^",1)
    .s pttype=$P($g(^PAADM(PAADM)),"^",2)
    .s binganno=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(PAADM,pttype,.ErrMsg)  // $p(^PAPER(papmiid,"PAT",1),"^",22)
    .s mrname=$p(^PAPER(papmiid,"ALL"),"^",1)
    .q:(mrname'=PatName)&&(PatName'="")
    .s mrtel=$p(^PAPER(papmiid,"PER",1),"^",11)
    .s PatNo=$p(^PAPER(papmiid,"PAT",1),"^",1)
    .q:(PatNo'=PatID)&&(PatID'="")
    .s LocId=$p(^PAADM(PAADM),"^",4)
    .S Departdr=$P(^CTLOC(LocId),"^",19)
    .q:(Departdr'=Depdr)&&(Depdr'="")
    .s Department=$P(^RBC("DEP",Departdr),"^",2)  //科室组 addwbg
    .s LocWardID=$p(^PAADM(PAADM),"^",70)
    .q:(LocWardID'=WardId)&&(WardId'="")
    .s LocWard=$p(^PAWARD(LocWardID),"^",2)
    .s LocDesc=$p($p(^CTLOC(LocId),"^",2),"-",2)
    .s QRDSub=0
    .f  s QRDSub=$o(^DHCCRMQR(0,"QRD_Subject_DR",Subject,qrrowid,QRDSub)) q:QRDSub=""  d
    ..s QRDSubjectDetailDR=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",2)
    ..q:QRDSubjectDetailDR=""
    ..s QRDDate=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",5)
    ..;q:QRDDate>EndDate
    ..;q:QRDDate<BeginDate
    ..s SDId=QRDSubjectDetailDR
    ..s SDName=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",2)
    ..s SDType=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",3)
    ..s SDShunXu=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",11)
    ..s Result=""
    ..s Result=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",3)
    ..s Template=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",4)
    ..i SDType="D" d
    ...s DResult=""
    ...f i=1:1:$l(Result,"$") d
    ....s TmpResult=$p(Result,"$",i)
    ....q:TmpResult=""
    ....s TmpBeiZhuStr=$p(Template,"$",i)
    ....s TmpBeiZhu=$p(TmpBeiZhuStr,"@",2)
    ....i TmpBeiZhu'="" s TmpBeiZhu="("_TmpBeiZhu_")"
    ....i DResult="" s DResult=TmpResult_TmpBeiZhu
    ....e  s DResult=DResult_";"_TmpResult_TmpBeiZhu
    ...s Result=DResult
    ..s Result=$p(Result,"$",1)
    ..q:Result=""
    ..s FenShu=""
    ..s Template=$p(Template,"$",1)
    ..i $p(Template,"@",1)="" s FenShu=Result
    ..e  s FenShu=+$p(Template,"@",1)*10
    ..i SDType="N" s FenShu=+FenShu*10
    ..s BeiZhu=$p(Template,"@",2)
    ..Do OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(PAADM,PatNo,binganno,mrname,mrtel,LocId,LocDesc,LocWard,SDId,SDShunXu,SDName,Result,FenShu,BeiZhu,Departdr,Department)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchXHQRecordDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchXHQRecordDetailExecute ]
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

ClassMethod SearchXHQRecordDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchXHQRecordDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMQuery","SearchXHQRecordLocBack","2015-02-01","2015-02-28","30")
Query SearchXHQRecordLocBack(BeginDate, EndDate, Depdr) As %Query(ROWSPEC = "PAADM:%String,PatNo:%String,binganno:%String,mrname:%String,mrtel:%String,LocId:%String,LocDesc:%String,LocWard:%String,SDId:%String,SDShunXu:%Integer,SDName:%String,Result:%String,FenShu:%Integer,BeiZhu:%String,Month:%Integer,Monthdesc:%String,Departdr:%Integer,Department:%String") [ SqlProc ]
{
}

ClassMethod SearchXHQRecordLocBackExecute(ByRef qHandle As %Binary, BeginDate, EndDate, Depdr) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    i BeginDate="" s BeginDate=+$h
    e  s BeginDate=$zdh(BeginDate,3)
    i EndDate="" s EndDate=+$h
    e  s EndDate=$zdh(EndDate,3)
    s Subject=4
    
    s qrrowid=0
    f  s qrrowid=$o(^DHCCRMQR(0,"QRD_Subject_DR",Subject,qrrowid)) q:qrrowid=""  d
    .s FUPDR=$p(^DHCCRMQR(qrrowid),"^",1)
    .s LinkNum=$p($g(^DHCCRMFUP(FUPDR)),"^",7)
    .q:(LinkNum>=1) //联系不上
    .s FupDate=$p($g(^DHCCRMFUP(FUPDR)),"^",3)
    .q:FupDate>EndDate
    .q:FupDate<BeginDate
    .s Month=..GetMonth(FupDate)
    .s Monthdesc=$E(Month,1,4)_"年"_$E(Month,5,6)_"月"
    .s PAADM=$p(^DHCCRMQR(qrrowid),"^",2)
    .s papmiid=$p(^PAADM(PAADM),"^",1)
    .
    .s pttype=$P($g(^PAADM(PAADM)),"^",2)
    .s binganno=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(PAADM,pttype,.ErrMsg) ;$p(^PAPER(papmiid,"PAT",1),"^",22)
    .
    .s mrname=$p(^PAPER(papmiid,"ALL"),"^",1)
    .s mrtel=$p(^PAPER(papmiid,"PER",1),"^",11)
    .s PatNo=$p(^PAPER(papmiid,"PAT",1),"^",1) 
    .s LocId=$p(^PAADM(PAADM),"^",4)
    .S Departdr=$P(^CTLOC(LocId),"^",19)
    .q:(Departdr'=Depdr)&&(Depdr'="")
    .s Department=$P(^RBC("DEP",Departdr),"^",2)  //科室组 addwbg
    .;q:(CTLocId'="")&&(CTLocId'=LocId)
    .s LocWard=$p(^PAWARD($p(^PAADM(PAADM),"^",70)),"^",2)
    .s LocDesc=$p($p(^CTLOC(LocId),"^",2),"-",2)
    .s QRDSub=0
    .f  s QRDSub=$o(^DHCCRMQR(0,"QRD_Subject_DR",Subject,qrrowid,QRDSub)) q:QRDSub=""  d
    ..s QRDSubjectDetailDR=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",2)
    ..q:QRDSubjectDetailDR=""
    ..s QRDDate=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",5)
    ..
    ..;q:QRDDate>EndDate
    ..;q:QRDDate<BeginDate
    ..s SDId=QRDSubjectDetailDR
    ..s SDName=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",2)
    ..s SDCode=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",1)
    ..q:SDCode=3014
    ..s SDType=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",3)
    ..q:(SDType="D")||(SDType="T") //||(SDType="N")
    ..s SDShunXu=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",11)
    ..s Result=""
    ..s Result=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",3)
    ..s Result=$p(Result,"$",1)
    ..s Template=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",4)
    ..s FenShu=0
    ..s Template=$p(Template,"$",1)
    ..q:(SDType="S")&&($p(Template,"@",1)="")
    ..s FenShu=+$p(Template,"@",1)*10
    ..i SDType="N" s FenShu=+Result*10
    ..s BeiZhu=$p(Template,"@",2)
    ..Do OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(PAADM,PatNo,binganno,mrname,mrtel,LocId,LocDesc,LocWard,SDId,SDShunXu,SDName,Result,FenShu,BeiZhu,Month,Monthdesc,Departdr,Department)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchXHQRecordLocBackFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchXHQRecordLocBackExecute ]
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

ClassMethod SearchXHQRecordLocBackClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchXHQRecordLocBackExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 输出最后一道多选题结果
/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMQuery","SearchXHQPatOpinionBack","2015-01-01","2015-02-28","45")
Query SearchXHQPatOpinionBack(BeginDate, EndDate, Depdr, Year, Quarter) As %Query(ROWSPEC = "Cluster:%String") [ SqlProc ]
{
}

ClassMethod SearchXHQPatOpinionBackExecute(ByRef qHandle As %Binary, BeginDate, EndDate, Depdr, Year, Quarter) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    
    i BeginDate="" s BeginDate=+$h
    e  s BeginDate=$zdh(BeginDate,3)
    i EndDate="" s EndDate=+$h
    e  s EndDate=$zdh(EndDate,3)

    if (Year'="")&&(Quarter'="")  d 
    .s LSId=$G(^User.DHCCRMLocScoreI("LSDepYearQIndex",Depdr,Year,Quarter))
    .if LSId=""  d PutYSSJ
    .else  d
    ..s TaBeiZhu=$list($g(^User.DHCCRMLocScoreD(LSId)),7)
    ..d OutputRow
    else  d PutYSSJ

PutYSSJ     
    
    k ^TempCRMStat
    s Subject=4
    s qrrowid=0
    f  s qrrowid=$o(^DHCCRMQR(0,"QRD_Subject_DR",Subject,qrrowid)) q:qrrowid=""  d
    .s FUPDR=$p(^DHCCRMQR(qrrowid),"^",1)
    .s LinkNum=$p($g(^DHCCRMFUP(FUPDR)),"^",7)
    .q:(LinkNum>=1) //联系不上
    .s FupDate=$p($g(^DHCCRMFUP(FUPDR)),"^",3)
    .q:FupDate>EndDate
    .q:FupDate<BeginDate
    .s Month=..GetMonth(FupDate)
    .s PAADM=$p(^DHCCRMQR(qrrowid),"^",2)
    .s papmiid=$p(^PAADM(PAADM),"^",1)
    .
    .s pttype=$P($g(^PAADM(PAADM)),"^",2)
    .s binganno=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(PAADM,pttype,.ErrMsg)  // $p(^PAPER(papmiid,"PAT",1),"^",22)
    .
    .s mrname=$p(^PAPER(papmiid,"ALL"),"^",1)
    .s mrtel=$p(^PAPER(papmiid,"PER",1),"^",11)
    .s PatNo=$p(^PAPER(papmiid,"PAT",1),"^",1) 
    .s LocId=$p(^PAADM(PAADM),"^",4)
    .S Departdr=$P(^CTLOC(LocId),"^",19)
    .q:(Departdr'=Depdr)&&(Depdr'="")
    .s Department=$P(^RBC("DEP",Departdr),"^",2)  //科室组 addwbg
    .s LocWarddr=$p(^PAADM(PAADM),"^",70)
    .;s LocWard=$p(^PAWARD(LocWarddr),"^",2)
    .s QRDSub=0
    .f  s QRDSub=$o(^DHCCRMQR(0,"QRD_Subject_DR",Subject,qrrowid,QRDSub)) q:QRDSub=""  d
    ..s QRDSubjectDetailDR=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",2)
    ..q:QRDSubjectDetailDR=""
    ..s QRDDate=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",5)
    ..
    ..;q:QRDDate>EndDate
    ..;q:QRDDate<BeginDate
    ..s SDId=QRDSubjectDetailDR
    ..s SDName=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",2)
    ..s SDType=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",3)
    ..q:SDType'="D"
    ..;q:SDType="T"
    ..s SDShunXu=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",11)
    ..s TaResult=""
    ..s TaResult=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",3)
    ..s Template=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",4)
    ..;s DResult=""
    ..f i=1:1:$l(TaResult,"$") d
    ...s TmpResult=$p(TaResult,"$",i)
    ...q:TmpResult=""
    ...s ^TempCRMStat("Result",LocWarddr,papmiid)=TmpResult_";"_$G(^TempCRMStat("Result",LocWarddr,papmiid))
    ...s ^TempCRMStat("Result",LocWarddr,papmiid,"paadm")=binganno
    ...s TmpBeiZhuStr=$p(Template,"$",i)
    ...s TmpBeiZhu=$p(TmpBeiZhuStr,"@",2)
    ...q:(TmpBeiZhu="")||(TmpBeiZhu="无")||(TmpBeiZhu="无。")
    ...s ^TempCRMStat("BeiZhu",LocWarddr,papmiid)=TmpBeiZhu_";"_$G(^TempCRMStat("BeiZhu",LocWarddr,papmiid))
    d OutputRow
    
    /*
    ...i TmpBeiZhu'="" s TmpBeiZhu="("_TmpBeiZhu_")"
    ...i DResult="" s DResult=TmpResult_TmpBeiZhu
    ...e  s DResult=DResult_";"_TmpResult_TmpBeiZhu
    ..s Result=DResult
    ..s Result=$p(Result,"$",1)
    ..s FenShu=0
    ..s Template=$p(Template,"$",1)
    ..q:(SDType="S")&&($p(Template,"@",1)="")
    ..;s FenShu=+$p(Template,"@",1)*10
    ..;i SDType="N" s FenShu=+Result*10
    ..s BeiZhu=$p(Template,"@",2)
    ..Do OutputRow
    */
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
   
    s LocWarddr="",Cluster=""
    f  s LocWarddr=$O(^TempCRMStat("Result",LocWarddr)) q:LocWarddr=""  d
    .s papmiid="",Ret=""
    .f  s papmiid=$O(^TempCRMStat("Result",LocWarddr,papmiid)) q:papmiid=""  d
    ..s binganno=$g(^TempCRMStat("Result",LocWarddr,papmiid,"paadm"))  //$p(^PAPER(papmiid,"PAT",1),"^",22)
    ..s mrname=$p(^PAPER(papmiid,"ALL"),"^",1)
    ..s PatNo=$p(^PAPER(papmiid,"PAT",1),"^",1)
    ..s Result=$G(^TempCRMStat("Result",LocWarddr,papmiid))
    ..s TaBeiZhu=$G(^TempCRMStat("BeiZhu",LocWarddr,papmiid))
    ..s LocWard=$P($p(^PAWARD(LocWarddr),"^",2),"-",2)
    ..s Ret=PatNo_"，"_binganno_"，"_mrname_"，"_LocWard_"，"_Result_TaBeiZhu
    ..s Cluster=Ret_$C(13)_Cluster
    set Data=$lb(Cluster)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchXHQPatOpinionBackFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchXHQPatOpinionBackExecute ]
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

ClassMethod SearchXHQPatOpinionBackClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchXHQPatOpinionBackExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 输出最后一道多选题结果的备注信息
/// 要求：全部描述信息，不要选项内容
/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMQuery","ColletXHPatOpinion","2014-12-01","2015-02-28","45","","")
Query ColletXHPatOpinion(BeginDate, EndDate, Depdr, Year, Quarter) As %Query(ROWSPEC = "TaBeiZhu:%String") [ SqlProc ]
{
}

ClassMethod ColletXHPatOpinionExecute(ByRef qHandle As %Binary, BeginDate, EndDate, Depdr, Year = "", Quarter = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    i BeginDate="" s BeginDate=+$h
    e  s BeginDate=$zdh(BeginDate,3)
    i EndDate="" s EndDate=+$h
    e  s EndDate=$zdh(EndDate,3)
    

    s Subject=4
    s qrrowid=0
    f  s qrrowid=$o(^DHCCRMQR(0,"QRD_Subject_DR",Subject,qrrowid)) q:qrrowid=""  d
    .s FUPDR=$p(^DHCCRMQR(qrrowid),"^",1)
    .s LinkNum=$p($g(^DHCCRMFUP(FUPDR)),"^",7)
    .q:(LinkNum>=1) //联系不上
    .s FupDate=$p($g(^DHCCRMFUP(FUPDR)),"^",3)
    .q:FupDate>EndDate
    .q:FupDate<BeginDate
    .s Month=..GetMonth(FupDate)
    .s PAADM=$p(^DHCCRMQR(qrrowid),"^",2)
    .s papmiid=$p(^PAADM(PAADM),"^",1)
    .s pttype=$P($g(^PAADM(PAADM)),"^",2)
    .s binganno=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(PAADM,pttype,.ErrMsg)  //$p(^PAPER(papmiid,"PAT",1),"^",22)
    .s mrname=$p(^PAPER(papmiid,"ALL"),"^",1)
    .s mrtel=$p(^PAPER(papmiid,"PER",1),"^",11)
    .s PatNo=$p(^PAPER(papmiid,"PAT",1),"^",1) 
    .s LocId=$p(^PAADM(PAADM),"^",4)
    .S Departdr=$P(^CTLOC(LocId),"^",19)
    .q:(Departdr'=Depdr)&&(Depdr'="")
    .s Department=$P(^RBC("DEP",Departdr),"^",2)  //科室组 addwbg
    .;q:(CTLocId'="")&&(CTLocId'=LocId)
    .s LocWard=$p(^PAWARD($p(^PAADM(PAADM),"^",70)),"^",2)
    .s LocDesc=$p($p(^CTLOC(LocId),"^",2),"-",2)
    .s QRDSub=0
    .f  s QRDSub=$o(^DHCCRMQR(0,"QRD_Subject_DR",Subject,qrrowid,QRDSub)) q:QRDSub=""  d
    ..s QRDSubjectDetailDR=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",2)
    ..q:QRDSubjectDetailDR=""
    ..s QRDDate=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",5)
    ..s SDId=QRDSubjectDetailDR
    ..s SDName=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",2)
    ..s SDType=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",3)
    ..q:SDType'="D"
    ..s SDShunXu=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",11)
    ..s TaResult=""
    ..s TaResult=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",3)
    ..s Template=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",4)
    ..f i=1:1:$l(TaResult,"$") d
    ...s TmpResult=$p(TaResult,"$",i)
    ...q:TmpResult=""
    ...s TmpBeiZhuStr=$p(Template,"$",i)
    ...s TmpBeiZhu=$p(TmpBeiZhuStr,"@",2)
    ...q:(TmpBeiZhu="无")||(TmpBeiZhu="无。")
    ...s TaBeiZhu=TmpBeiZhu_";"_$G(TaBeiZhu)
    d OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    
    set Data=$lb(TaBeiZhu)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod ColletXHPatOpinionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ColletXHPatOpinionExecute ]
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

ClassMethod ColletXHPatOpinionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ColletXHPatOpinionExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetMonth(Date)
{
    q +($p($zd(Date,3),"-",1)_$p($zd(Date,3),"-",2))
}

/// 科室信息获取
/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMQuery","GetAdmCtloc") 
ClassMethod GetAdmCtlocExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    s ADMLRowId=""
    f  s ADMLRowId=$o(^PAC("ADMLOC",ADMLRowId)) q:ADMLRowId=""  d
    .s AdmType=$p(^PAC("ADMLOC",ADMLRowId),"^",1)
    .q:(AdmType'="I")
    .s ctprowid=$p($G(^PAC("ADMLOC",ADMLRowId)),"^",2)
    .q:ctprowid=""
    .s code=$p(^CTLOC(ctprowid),"^",1) 
    .s desc=$p(^CTLOC(ctprowid),"^",2)
    .q:desc["停用"
    .S Departdr=$P(^CTLOC(ctprowid),"^",19)
    .s Department=$P(^RBC("DEP",Departdr),"^",2)  //科室组 addwbg
    .d OutputAdmLoc

    q $$$OK 

OutputAdmLoc
    
    if AdmType="I" s Type="住院科室"
    s Data=$lb(ctprowid,desc,Type,Departdr,Department)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetAdmCtlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmCtlocExecute ]
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

ClassMethod GetAdmCtlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmCtlocExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetAdmCtloc() As %Query(ROWSPEC = "CTLOCID:%Integer,desc:%String,Type:%String,Departdr:%Integer,Department:%String") [ SqlProc ]
{
}

/// 科室病房信息获取
/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMQuery","GetAdmlocward")   
Query GetAdmlocward() As %Query(ROWSPEC = "CTLOCID:%String,desc:%String,WardID:%Integer,WardDesc:%String,Type:%String") [ SqlProc ]
{
}

ClassMethod GetAdmlocwardExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    s ADMLRowId=""
    f  s ADMLRowId=$o(^PAC("ADMLOC",ADMLRowId)) q:ADMLRowId=""  d
    .s AdmType=$p(^PAC("ADMLOC",ADMLRowId),"^",1)
    .q:(AdmType="H")||(AdmType="O")||(AdmType="E")
    .s CTLOCID=$p($G(^PAC("ADMLOC",ADMLRowId)),"^",2)
    .q:CTLOCID=""
    .s code=$p(^CTLOC(CTLOCID),"^",1) 
    .s desc=$p(^CTLOC(CTLOCID),"^",2)
    .q:desc["停用"
    .if $P(desc,"-",2)'="" s desc=$P(desc,"-",2)
    .s childsub=0  f  s childsub=$O(^CTLOC(CTLOCID,"LINK",childsub)) q:childsub=""  d
    ..s LinkLocID=$P(^CTLOC(CTLOCID,"LINK",childsub),"^",1)
    ..s WardID=0  f  s WardID=$O(^PAWARD(0,"WARD_LocationDR",LinkLocID,WardID)) Q:WardID=""  d
    ...s value=WardID
    ...s WardDesc=$P(^PAWARD(WardID),"^",2)
    ...if $P(WardDesc,"-",2)'="" s WardDesc=$P(WardDesc,"-",2)
    ...;s retval=CTLOCID_":"_desc_":"_value_":"_WardDesc
    ...d OutputAdmLoc

    q $$$OK 

OutputAdmLoc
    
    if AdmType="I" s Type="住院科室"
    s Data=$lb(CTLOCID,desc,WardID,WardDesc,Type)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetAdmlocwardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmlocwardExecute ]
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

ClassMethod GetAdmlocwardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmlocwardExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 按季度出科室反馈表
/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMQuery","GetLocScore","45","2015","1")
Query GetLocScore(Depdr, RYear, RQuarter) As %Query(ROWSPEC = "Departid:%Integer,Year:%Integer,Quarter:%Integer,Avgscore:%Float,Quadesc:%String,n:%Integer") [ SqlProc ]
{
}

ClassMethod GetLocScoreExecute(ByRef qHandle As %Binary, Depdr, RYear, RQuarter) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    IF (Depdr="")||(RYear="")||(RQuarter="")  D
    .S Departid=0,Year=0,Quarter=0,Avgscore=0,Quadesc=0 
    .d OutputLocScore
    else  d
    .s Quarter=RQuarter,Year=RYear
    .f n=1:1:5  d
    ..s id="",Totalscore=0,i=0
    ..f  s id=$o(^User.DHCCRMLocScoreI("LSYearQuarterIndex",Year,Quarter,id),-1) q:(id="")||(i>=3)  d
    ...s Departid=$list($g(^User.DHCCRMLocScoreD(id)),8)
    ...Q:Depdr'=Departid
    ...;b ;id
    ...s score=$list($g(^User.DHCCRMLocScoreD(id)),6)
    ...s Totalscore=Totalscore+score,i=i+1
    ..s:i'=0 Avgscore=Totalscore/i
    ..s Quadesc=Year_"年第"_Quarter_"季度"
    ..;b  ;Avgscore
    ..d OutputLocScore
    ..s Quarter=Quarter-1
    ..if Quarter=0  s Quarter=4,Year=Year-1
    
    q $$$OK 

    /*
    .f  s Quarter=$o(^User.DHCCRMLocScoreI("LSYearQuarterIndex",Year,Quarter)) q:(Quarter="")  d
    ..s Quarter=RQuarter
    ..s Num=Num+1
    ..;b ;Quarter
    ..s id=0,i=0,Totalscore=0
    ..f  s id=$o(^User.DHCCRMLocScoreI("LSYearQuarterIndex",Year,Quarter,id)) q:id=""  d
    ...s locid=$list($g(^User.DHCCRMLocScoreD(id)),2)
    ...Q:CTLocId'=locid
    ...s score=$list($g(^User.DHCCRMLocScoreD(id)),6)
    ...s Totalscore=Totalscore+score
    ...s i=i+1
    ..s Avgscore=Totalscore/i
    */
   
OutputLocScore
    s Data=$lb(Departid,Year,Quarter,Avgscore,Quadesc,n)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetLocScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocScoreExecute ]
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

ClassMethod GetLocScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocScoreExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMQuery","SearchDYQRecord","2015-03-01","2015-03-02","","")
Query SearchDYQRecord(BeginDate, EndDate, CTLocId, DetailId) As %Query(ROWSPEC = "PAADM:%String,LocId:%String,LocDesc:%String,SDId:%String,SDShunXu:%Integer,SDName:%String,Result:%String,FenShu:%Integer,QRDDate:%String") [ SqlProc ]
{
}

ClassMethod SearchDYQRecordExecute(ByRef qHandle As %Binary, BeginDate, EndDate, CTLocId, DetailId) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    i BeginDate="" s BeginDate=+$h
    e  s BeginDate=$zdh(BeginDate,3)
    i EndDate="" s EndDate=+$h
    e  s EndDate=$zdh(EndDate,3)
    s Subject=2
    
    s qrrowid=0
    f  s qrrowid=$o(^DHCCRMQR(0,"QRD_Subject_DR",Subject,qrrowid)) q:qrrowid=""  d
    .s FUPDR=$p(^DHCCRMQR(qrrowid),"^",1)
    .q:($p(^DHCCRMFUP(FUPDR),"^",6)="联系不上")
    .s FupDate=$p($g(^DHCCRMFUP(FUPDR)),"^",3)
    .s PAADM=$p(^DHCCRMQR(qrrowid),"^",2)
    .s LocId=$p(^PAADM(PAADM),"^",4)
    .q:(CTLocId'="")&&(CTLocId'=LocId)
    .s LocDesc=$p($p(^CTLOC(LocId),"^",2),"-",2)
    .s QRDSub=0
    .f  s QRDSub=$o(^DHCCRMQR(0,"QRD_Subject_DR",Subject,qrrowid,QRDSub)) q:QRDSub=""  d
    ..s QRDSubjectDetailDR=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",2)
    ..q:QRDSubjectDetailDR=""
    ..s QRDDate=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",5)
    ..q:QRDDate>EndDate
    ..q:QRDDate<BeginDate
    ..s QRDDate=$zd(QRDDate,3)
    ..s SDId=QRDSubjectDetailDR
    ..q:(DetailId'="")&&(DetailId'=SDId)
    ..s SDName=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",2)
    ..s SDType=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",3)
    ..q:SDType="T"
    ..s SDShunXu=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",11)
    ..q:SDShunXu>15
    ..s Active=$p(^DHCCRMFUS(+QRDSubjectDetailDR,"SD",$p(QRDSubjectDetailDR,"||",2)),"^",7)
    ..q:Active'="Y"
    ..s Result=$p(^DHCCRMQR(qrrowid,"Detail",QRDSub),"^",3)
    ..s Result=$tr(Result,"$","")
    ..s FenShu=0
    ..i Result["满意" s FenShu=100
    ..i Result["基本满意" s FenShu=80
    ..i Result["不满意" s FenShu=0
    ..Do OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(PAADM,LocId,LocDesc,SDId,SDShunXu,SDName,Result,FenShu,QRDDate)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchDYQRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchDYQRecordExecute ]
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

ClassMethod SearchDYQRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchDYQRecordExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 取DHCCRMLocScore表里的科室季度得分
/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMQuery","GetLocQuarterScore","34","2015","1")
Query GetLocQuarterScore(DepType, Year, Quarter, Depdr) As %Query(ROWSPEC = "Departid:%String,Department:%String,Avgscore:%Integer") [ SqlProc ]
{
}

ClassMethod GetLocQuarterScoreExecute(ByRef qHandle As %Binary, DepType, Year, Quarter, Depdr) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    s Avgscore="",Departid=""
    IF (Year="")||(Quarter="")  D
    .S Departid=0,Year=0,Quarter=0,Avgscore=0
    .d OutLocScore
    else  d
    .s Departid=""
    .f  s Departid=$o(^User.DHCCRMLocScoreI("LSDepYearQIndex",Departid)) q:(Departid="")  d
    ..q:(Depdr=Departid)&&(Depdr'="")
    ..s RealType=..PanduanSSKS(Departid)
    ..;q:(DepType="MZKS")&&(RealType="FSSKS")
    ..q:(DepType="SSKS")&&(RealType'="SSKS")
    ..q:(DepType="FSSKS")&&(RealType'="FSSKS")
    ..s Department=$P(^RBC("DEP",Departid),"^",2)
    ..s id="",Totalscore=0
    ..f  s id=$o(^User.DHCCRMLocScoreI("LSDepYearQIndex",Departid,Year,Quarter,id)) q:id=""  d
    ...s score=$list($g(^User.DHCCRMLocScoreD(id)),6)
    ...s Totalscore=Totalscore+score
    ..s Avgscore=Totalscore/3
    ..d OutLocScore
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
OutLocScore
    set Data=$lb(Departid,Department,Avgscore)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetLocQuarterScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocQuarterScoreExecute ]
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

ClassMethod GetLocQuarterScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocQuarterScoreExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
