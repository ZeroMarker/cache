Import SQLUser

Class web.DHCCRM.SetPlan Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod MRBaseList(BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum, start, limit)
{
    s start=$G(start)
    s limit=$G(limit)
         
    s rs=##class(%ResultSet).%New("web.DHCCRM.SetPlan:SearchMRBase") 
    d rs.Execute(BeginDate,EndDate,LocID,ICD,RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType,FindCheck,YuanQuID,PatInDate,PatLocNum)
 
    s count=0
    s mess=""
    s topnum=start+limit
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        s mrmrid=rs.Get("mrmrid")
        s mrname=rs.Get("mrname")
        s mrgender=rs.Get("mrgender")
        s mrage=rs.Get("mrage")
        s mradmdate=rs.Get("mradmdate")
        s mrdisdate=rs.Get("mrdisdate")
        s mrdisroom=rs.Get("mrdisroom")
        s mrdisdiagname=rs.Get("mrdisdiagname")
        s mradm=rs.Get("mradm")
        s mRegno=rs.Get("mRegno")
        s mrcardid=rs.Get("mrcardid")
        s mrtel=rs.Get("mrtel")
        s mraddress=rs.Get("mraddress")
        s docname=rs.Get("docname")
        s LocDesc=rs.Get("LocDesc")
        i (mess'="") s mess=mess_","
        s mess=mess_"{""mrmrid"":"_""""_mrmrid_""""
        s mess=mess_","_"""mrname"":"_""""_mrname_""""
        s mess=mess_","_"""mrgender"":"_""""_mrgender_""""
        s mess=mess_","_"""mrage"":"_""""_mrage_""""
        s mess=mess_","_"""mrcardid"":"_""""_mrcardid_""""
        s mess=mess_","_"""mradmdate"":"_""""_mradmdate_""""
        s mess=mess_","_"""mrdisdate"":"_""""_mrdisdate_""""
        s mess=mess_","_"""mrdisroom"":"_""""_mrdisroom_""""
        s mess=mess_","_"""mrdisdiagname"":"_""""_mrdisdiagname_""""
        s mess=mess_","_"""mradm"":"_""""_mradm_""""
        s mess=mess_","_"""mRegno"":"_""""_mRegno_""""
        s mess=mess_","_"""mtype"":"_""""_"出院"_""""
        s mess=mess_","_"""mrtel"":"_""""_mrtel_""""
        s mess=mess_","_"""mraddress"":"_""""_mraddress_""""
        s mess=mess_","_"""docname"":"_""""_docname_""""
        s mess=mess_","_"""LocDesc"":"_""""_LocDesc_""""
        s mess=mess_"}"
        
    }        
 s mess="["_mess_"]"
 s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"

 q mess
}

ClassMethod MRBaseListEI(BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum, start, limit)
{
    s start=$G(start)
    s limit=$G(limit)
         
    s rs=##class(%ResultSet).%New("web.DHCCRM.SetPlan:SearchMRBaseEI") 
    d rs.Execute(BeginDate,EndDate,LocID,ICD,RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType,FindCheck,YuanQuID,PatInDate,PatLocNum)
 
    s count=0
    s mess=""
    s topnum=start+limit
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        s mrmrid=rs.Get("mrmrid")
        s mrname=rs.Get("mrname")
        s mrgender=rs.Get("mrgender")
        s mrage=rs.Get("mrage")
        s mradmdate=rs.Get("mradmdate")
        s mrdisdate=rs.Get("mrdisdate")
        s mrdisroom=rs.Get("mrdisroom")
        s mrdisdiagname=rs.Get("mrdisdiagname")
        s mradm=rs.Get("mradm")
        s mRegno=rs.Get("mRegno")
        s mrcardid=rs.Get("mrcardid")
        s mrtel=rs.Get("mrtel")
        s mraddress=rs.Get("mraddress")
        s docname=rs.Get("docname")
        
        i (mess'="") s mess=mess_","
        s mess=mess_"{""mrmrid"":"_""""_mrmrid_""""
        s mess=mess_","_"""mrname"":"_""""_mrname_""""
        s mess=mess_","_"""mrgender"":"_""""_mrgender_""""
        s mess=mess_","_"""mrage"":"_""""_mrage_""""
        s mess=mess_","_"""mrcardid"":"_""""_mrcardid_""""
        s mess=mess_","_"""mradmdate"":"_""""_mradmdate_""""
        s mess=mess_","_"""mrdisdate"":"_""""_mrdisdate_""""
        s mess=mess_","_"""mrdisroom"":"_""""_mrdisroom_""""
        s mess=mess_","_"""mrdisdiagname"":"_""""_mrdisdiagname_""""
        s mess=mess_","_"""mradm"":"_""""_mradm_""""
        s mess=mess_","_"""mRegno"":"_""""_mRegno_""""
        s mess=mess_","_"""mtype"":"_""""_"急诊留观"_""""
        s mess=mess_","_"""mrtel"":"_""""_mrtel_""""
        s mess=mess_","_"""mraddress"":"_""""_mraddress_""""
        s mess=mess_","_"""docname"":"_""""_docname_""""
        
        s mess=mess_"}"
        
    }        
 s mess="["_mess_"]"
 s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"

 q mess
}

ClassMethod MRBaseListEO(BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum, start, limit)
{
    s start=$G(start)
    s limit=$G(limit)
         
    s rs=##class(%ResultSet).%New("web.DHCCRM.SetPlan:SearchMRBaseEO") 
    d rs.Execute(BeginDate,EndDate,LocID,ICD,RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType,FindCheck,YuanQuID,PatInDate,PatLocNum)
 
    s count=0
    s mess=""
    s topnum=start+limit
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        s mrmrid=rs.Get("mrmrid")
        s mrname=rs.Get("mrname")
        s mrgender=rs.Get("mrgender")
        s mrage=rs.Get("mrage")
        s mradmdate=rs.Get("mradmdate")
        s mrdisdate=rs.Get("mrdisdate")
        s mrdisroom=rs.Get("mrdisroom")
        s mrdisdiagname=rs.Get("mrdisdiagname")
        s mradm=rs.Get("mradm")
        s mRegno=rs.Get("mRegno")
        s mrcardid=rs.Get("mrcardid")
        s mrtel=rs.Get("mrtel")
        s mraddress=rs.Get("mraddress")
        s docname=rs.Get("docname")
        
        i (mess'="") s mess=mess_","
        s mess=mess_"{""mrmrid"":"_""""_mrmrid_""""
        s mess=mess_","_"""mrname"":"_""""_mrname_""""
        s mess=mess_","_"""mrgender"":"_""""_mrgender_""""
        s mess=mess_","_"""mrage"":"_""""_mrage_""""
        s mess=mess_","_"""mrcardid"":"_""""_mrcardid_""""
        s mess=mess_","_"""mradmdate"":"_""""_mradmdate_""""
        s mess=mess_","_"""mrdisdate"":"_""""_mrdisdate_""""
        s mess=mess_","_"""mrdisroom"":"_""""_mrdisroom_""""
        s mess=mess_","_"""mrdisdiagname"":"_""""_mrdisdiagname_""""
        s mess=mess_","_"""mradm"":"_""""_mradm_""""
        s mess=mess_","_"""mRegno"":"_""""_mRegno_""""
        s mess=mess_","_"""mtype"":"_""""_"急诊非留观"_""""
        s mess=mess_","_"""mrtel"":"_""""_mrtel_""""
        s mess=mess_","_"""mraddress"":"_""""_mraddress_""""
        s mess=mess_","_"""docname"":"_""""_docname_""""
        
        s mess=mess_"}"
        
    }        
 s mess="["_mess_"]"
 s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"

 q mess
}

/// w ##class(web.DHCCRM.SetPlan).MRBaseListI("","","","","","","","","","","","","",0,20)
ClassMethod MRBaseListI(BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum, start, limit)
{
    s start=$G(start)
    s limit=$G(limit)
    
    s rs=##class(%ResultSet).%New("web.DHCCRM.SetPlan:SearchMRBaseI") 
    d rs.Execute(BeginDate,EndDate,LocID,ICD,RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType,FindCheck,YuanQuID,PatInDate,PatLocNum)
 
    s count=0
    s mess=""
    s topnum=start+limit
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        s mrmrid=rs.Get("mrmrid")
        s mrname=rs.Get("mrname")
        s mrgender=rs.Get("mrgender")
        s mrage=rs.Get("mrage")
        s mradmdate=rs.Get("mradmdate")
        s mrdisdate=rs.Get("mrdisdate")
        s mrdisroom=rs.Get("mrdisroom")
        s mrdisdiagname=rs.Get("mrdisdiagname")
        s mradm=rs.Get("mradm")
        s mRegno=rs.Get("mRegno")
        s mrcardid=rs.Get("mrcardid")
        s mrtel=rs.Get("mrtel")
        s mraddress=rs.Get("mraddress")
        s docname=rs.Get("docname")
        i (mess'="") s mess=mess_","
        s mess=mess_"{""mrmrid"":"_""""_mrmrid_""""
        s mess=mess_","_"""mrname"":"_""""_mrname_""""
        s mess=mess_","_"""mrgender"":"_""""_mrgender_""""
        s mess=mess_","_"""mrage"":"_""""_mrage_""""
        s mess=mess_","_"""mrcardid"":"_""""_mrcardid_""""
        s mess=mess_","_"""mradmdate"":"_""""_mradmdate_""""
        s mess=mess_","_"""mrdisdate"":"_""""_mrdisdate_""""
        s mess=mess_","_"""mrdisroom"":"_""""_mrdisroom_""""
        s mess=mess_","_"""mrdisdiagname"":"_""""_mrdisdiagname_""""
        s mess=mess_","_"""mradm"":"_""""_mradm_""""
        s mess=mess_","_"""mRegno"":"_""""_mRegno_""""
        s mess=mess_","_"""mtype"":"_""""_"在院"_""""
        s mess=mess_","_"""mrtel"":"_""""_mrtel_""""
        s mess=mess_","_"""mraddress"":"_""""_mraddress_""""
        s mess=mess_","_"""docname"":"_""""_docname_""""
        s mess=mess_"}"
        
    }        
 s mess="["_mess_"]"
 s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"

 q mess
}

/// w ##class(web.DHCCRM.SetPlan).MRBaseListO("","","","","","","","","","","","","","","",0,20)
ClassMethod MRBaseListO(BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum, start, limit)
{
    s start=$G(start)
    s limit=$G(limit)
         
    s rs=##class(%ResultSet).%New("web.DHCCRM.SetPlan:SearchMRBaseO") 
    d rs.Execute(BeginDate,EndDate,LocID,ICD,RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType,FindCheck,YuanQuID,PatInDate,PatLocNum)
 
    s count=0
    s mess=""
    s topnum=start+limit
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        s mrmrid=rs.Get("mrmrid")
        s mrname=rs.Get("mrname")
        s mrgender=rs.Get("mrgender")
        s mrage=rs.Get("mrage")
        s mradmdate=rs.Get("mradmdate")
        s mrdisdate=rs.Get("mrdisdate")
        s mrdisroom=rs.Get("mrdisroom")
        s mrdisdiagname=rs.Get("mrdisdiagname")
        s mradm=rs.Get("mradm")
        s mRegno=rs.Get("mRegno")
        s mrcardid=rs.Get("mrcardid")
        i (mess'="") s mess=mess_","
        s mess=mess_"{""mrmrid"":"_""""_mrmrid_""""
        s mess=mess_","_"""mrname"":"_""""_mrname_""""
        s mess=mess_","_"""mrgender"":"_""""_mrgender_""""
        s mess=mess_","_"""mrage"":"_""""_mrage_""""
        s mess=mess_","_"""mrcardid"":"_""""_mrcardid_""""
        s mess=mess_","_"""mradmdate"":"_""""_mradmdate_""""
        s mess=mess_","_"""mrdisdate"":"_""""_mrdisdate_""""
        s mess=mess_","_"""mrdisroom"":"_""""_mrdisroom_""""
        s mess=mess_","_"""mrdisdiagname"":"_""""_mrdisdiagname_""""
        s mess=mess_","_"""mradm"":"_""""_mradm_""""
        s mess=mess_","_"""mRegno"":"_""""_mRegno_""""
        s mess=mess_","_"""mtype"":"_""""_"门诊"_""""
        s mess=mess_"}"
        
    }        
 s mess="["_mess_"]"
 s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"

 q mess
}

/// w ##class(web.DHCCRM.SetPlan).MRBaseListU("","","","","","","","","","","",0,20)
ClassMethod MRBaseListU(BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, start, limit)
{
    s start=$G(start)
    s limit=$G(limit)
         
    s rs=##class(%ResultSet).%New("web.DHCCRM.SetPlan:SearchMRBaseU") 
    d rs.Execute(BeginDate,EndDate,LocID,ICD,RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType)
 
    s count=0
    s mess=""
    s topnum=start+limit
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        s mrmrid=rs.Get("mrmrid")
        s mrname=rs.Get("mrname")
        s mrgender=rs.Get("mrgender")
        s mrage=rs.Get("mrage")
        s mradmdate=rs.Get("mradmdate")
        s mrdisdate=rs.Get("mrdisdate")
        s mrdisroom=rs.Get("mrdisroom")
        s mrdisdiagname=rs.Get("mrdisdiagname")
        s mradm=rs.Get("mradm")
        s mRegno=rs.Get("mRegno")
        s mrcardid=rs.Get("mrcardid")
        i (mess'="") s mess=mess_","
        s mess=mess_"{""mrmrid"":"_""""_mrmrid_""""
        s mess=mess_","_"""mrname"":"_""""_mrname_""""
        s mess=mess_","_"""mrgender"":"_""""_mrgender_""""
        s mess=mess_","_"""mrage"":"_""""_mrage_""""
        s mess=mess_","_"""mrcardid"":"_""""_mrcardid_""""
        s mess=mess_","_"""mradmdate"":"_""""_mradmdate_""""
        s mess=mess_","_"""mrdisdate"":"_""""_mrdisdate_""""
        s mess=mess_","_"""mrdisroom"":"_""""_mrdisroom_""""
        s mess=mess_","_"""mrdisdiagname"":"_""""_mrdisdiagname_""""
        s mess=mess_","_"""mradm"":"_""""_mradm_""""
        s mess=mess_","_"""mRegno"":"_""""_mRegno_""""
        s mess=mess_","_"""mtype"":"_""""_"本院职工"_""""
        s mess=mess_"}"
        
    }        
 s mess="["_mess_"]"
 s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"

 q mess
}

/// w ##class(web.DHCCRM.SetPlan).FUPlanList(0,20)
ClassMethod FUPlanList(BeginDate, EndDate, start, limit)
{
    s start=$G(start)
    s limit=$G(limit)
    s rs=##class(%ResultSet).%New("web.DHCCRM.SetPlan:SearchFUPlan") 
    d rs.Execute(BeginDate,EndDate)
 
    s count=0
    s mess=""
    s topnum=start+limit
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        s FUPSubject=rs.Get("FUPSubject")
        s FUPFUDate=rs.Get("FUPFUDate")
        s FUPFUUserDR=rs.Get("FUPFUUserDR")
        s FUPPAADM=rs.Get("FUPPAADM")
        s PAPMINO=rs.Get("PAPMINO")
        s PAPMIName=rs.Get("PAPMIName")
        s EndDate=rs.Get("EndDate")
        
        
        i (mess'="") s mess=mess_","
        s mess=mess_"{""FUPSubject"":"_""""_FUPSubject_""""
        s mess=mess_","_"""FUPPAADM"":"_""""_FUPPAADM_""""
        s mess=mess_","_"""FUPFUDate"":"_""""_FUPFUDate_""""
        s mess=mess_","_"""FUPFUUser"":"_""""_FUPFUUserDR_""""
        s mess=mess_","_"""PAPMINO"":"_""""_PAPMINO_""""
        s mess=mess_","_"""PAPMIName"":"_""""_PAPMIName_""""
        s mess=mess_","_"""EndDate"":"_""""_EndDate_""""
        s mess=mess_"}"
    }        
 s mess="["_mess_"]"
 s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 q mess
}

/// D ##class(%ResultSet).RunQuery("web.DHCCRM.SetPlan","SearchMRBase","2015-02-09","2015-02-09","","","","","","","","","","","","","")                                                                                                                          
Query SearchMRBase(BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum) As %Query(ROWSPEC = "mrmrid:%String,mrname:%String,mrgender:%String,mrage:%String,mradmdate:%String,mrdisdate:%String,mrdisroom:%String,mrdisdiagname:%String,mradm:%String,mRegno:%String,mrcardid:%String,mrtel:%String,mraddress:%String,docname:%String,LocDesc:%String,mtype:%String")
{
}

ClassMethod SearchMRBaseExecute(ByRef qHandle As %Binary, BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1

    i FindCheck="" s FindCheck="false"
    s ICD=##class(web.DHCPE.DHCPECommon).UnEscape(ICD)
    s PatName=##class(web.DHCPE.DHCPECommon).UnEscape(PatName)
    i BeginDate="" s BeginDate=+$h-7
    else  s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
    i EndDate="" s EndDate=+$h
    else  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    s RealLocId=$p(LocID,"^",1)
    s CXWardId=$p(LocID,"^",2)
    s user=%session.Get("LOGON.USERID")
    k ^DHCPETMPLocNum(user)
    f chgdate=BeginDate:1:EndDate d
    .s paadm=0
    .f  s paadm=$o(^PAADMi("DischDate",chgdate,paadm)) q:paadm=""  d
    ..s papmiid=$p(^PAADM(paadm),"^",1)
    ..s papmino=$p(^PAPER(papmiid,"PAT",1),"^",1) //登记号
    ..s pttype=$P($g(^PAADM(paadm)),"^",2)
    ..q:pttype'="I" //住院病人
    ..i RegNo'=""  s AllRegNo=..RegNoMask(RegNo)
    ..s mrmrid=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(paadm,pttype,.ErrMsg) ;$p(^PAPER(papmiid,"PAT",1),"^",22) //病案
    ..q:(mrmrid="")
    ..q:(RegNo'="")&&(RegNo'=papmino)&&(RegNo'=mrmrid)&&(AllRegNo'=papmino)
    ..s mrname=$p(^PAPER(papmiid,"ALL"),"^",1)
    ..q:(PatName'="")&&(mrname'[PatName)
    ..s mrgender=$p(^PAPER(papmiid,"ALL"),"^",7)
    ..q:(PatSexID'="")&&(PatSexID'= mrgender)
    ..s Dead=""
    ..s DeadFlag=$p(^PAPER(papmiid,"ALL"),"^",12)
    ..i DeadFlag="Y" s Dead="(死亡)"
    ..;q:DeadFlag="Y"
    ..i mrgender'="" s mrgender=$p(^CT("SEX",mrgender),"^",2)
    ..s mrgender=mrgender_Dead
    ..s mrbirthday=$p(^PAPER(papmiid,"ALL"),"^",6)
    ..i mrbirthday'="" s mrbirthday=##class(web.DHCLCNUREXCUTE).CalAge(mrbirthday,$P($g(^PAADM(paadm)),"^",6))
    ..s Age=$P(mrbirthday,"Y",1)_"岁" 
    ..s:(Age="0岁") Age=##class(web.DHCBillInterface).GetPapmiAge(papmiid,paadm)
    ..i Age["天" s PatAgeFrom=PatAgeFrom*365,PatAgeTo=PatAgeTo*365
    ..s mrcardid=$p(^PAPER(papmiid,"ALL"),"^",9)
    ..q:(+PatAgeFrom'="0")&&(+PatAgeFrom>+Age)
    ..q:(+PatAgeTo'="0")&&(+PatAgeTo<+Age)
    ..s admdate=$P($g(^PAADM(paadm)),"^",6) //入院日期
    ..i admdate'="" s mradmdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
    ..s disdate=+##class(web.DHCDischargeHistory).GetDischargeDateTime(paadm)
    ..i disdate=0 s disdate=chgdate //出院日期
    ..i disdate'="" s disdate=##class(websys.Conversions).DateLogicalToHtml(disdate)
    ..s mainmr=$p(^PAADM(paadm),"^",61)
    ..q:($d(^DHCCRMFUP(0,"FUP_PAADM",paadm)))&&(FindCheck="false")
    ..q:('$d(^DHCCRMFUP(0,"FUP_PAADM",paadm)))&&(FindCheck="true")
    ..s mrsub=0,diagnos="",diagcode=""
    ..f  s mrsub=$o(^MR(mainmr,"DIA",mrsub)) q:mrsub=""  d
    ...s ICDCode=$p(^MR(mainmr,"DIA",mrsub),"^",1)
    ...q:ICDCode=""
    ...s ICDDesc=$p(^MRC("ID",ICDCode),"^",2)
    ...i diagnos="" s diagnos=ICDDesc
    ...e  s diagnos=diagnos_"/"_ICDDesc
    ...s diagcode=diagcode_"^"_ICDCode
    ..s disdiag=diagnos
    ..s disdiag=..GetAllMDiagnos(paadm)
    ..s ICDStr=""
    ..s QTFlag=0
    ..i ICD'="" d
    ...s icdid=0
    ...f  s icdid=$o(^User.DHCCRMQTICDRelateI("QTRQTDDRIndex",ICD,icdid)) q:icdid=""  d
    ....s icddr=$lg(^User.DHCCRMQTICDRelateD(icdid),3)
    ....i (diagcode_"^")[("^"_icddr_"^") s QTFlag=1
    ..;q:(ICD'="")&&(QTFlag=0)
    ..q:(ICD'="")&&(diagcode'[ICD)
    ..s mrtel=$p(^PAPER(papmiid,"PER",1),"^",11)
    ..s mraddress=$g(^PAPER(papmiid,"PER","ADD"))
    ..s mrcd=$p(^MR(mainmr,"PRO",1),"^",10)
    ..i mrcd'="" s admroom=$p(^PAC("DISCON",mrcd),"^",2)
    ..s admdoc=$p(^PAADM(paadm),"^",9)
    ..i +admdoc'=0 s docname=$p(^CTPCP(admdoc,1),"^",2)
    ..s disroomdr=$p(^PAADM(paadm),"^",4)
    ..s HospDr=$p(^CTLOC(disroomdr),"^",22)
    ..q:(YuanQuID'="")&&(YuanQuID'=HospDr)
    ..q:(RealLocId'="")&&(RealLocId'=disroomdr)
    ..i disroomdr'="" s LocDesc=$p($p(^CTLOC(disroomdr),"^",2),"-",2)
    ..i LocDesc="" s LocDesc=$p(^CTLOC(disroomdr),"^",2)
    ..s admWard=$p(^PAADM(paadm),"^",70)
    ..q:(CXWardId'="")&&(CXWardId'=admWard)
    ..s mrdisroom=$p($p(^PAWARD(admWard),"^",2),"-",2)
    ..i mrdisroom="" s mrdisroom=$p(^PAWARD(admWard),"^",2)
    ..s mrdisroom=mrdisroom_"("_(chgdate-admdate)_"天)"
    ..s minPatInDate=$p(PatInDate,"^",1)
    ..s maxPatInDate=$p(PatInDate,"^",2)
    ..q:(minPatInDate'="")&&(minPatInDate>(chgdate-admdate))
    ..q:(maxPatInDate'="")&&(maxPatInDate<(chgdate-admdate))
    ..s ^DHCPETMPLocNum(user,disroomdr)=$g(^DHCPETMPLocNum(user,disroomdr))+1
    ..q:(PatLocNum'="")&&($g(^DHCPETMPLocNum(user,disroomdr))>PatLocNum)
    ..;s ^DHCPETMPLocNum(user,admWard,(chgdate-admdate),paadm)=mrmrid_"^"_mrname_"^"_mrgender_"^"_Age_"^"_mradmdate_"^"_disdate_"^"_mrdisroom_"^"_disdiag_"^"_paadm_"^"_papmino_"^"_mrcardid_"^"_mrtel_"^"_mraddress_"^"_docname_"^"_LocDesc
    ..Do OutputRow
    /*
    s Loc=..GetLastLoc()
    
    f  s Loc=$o(^DHCPETMPLocNum(user,Loc)) q:Loc=""  d
    .s Num="",loop=0
    .f  s Num=$o(^DHCPETMPLocNum(user,Loc,Num),-1) q:Num=""  d
    ..s adm=0
    ..f  s adm=$o(^DHCPETMPLocNum(user,Loc,Num,adm)) q:adm=""  d
    ...s mrmrid=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",1)
    ...s mrname=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",2)
    ...s mrgender=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",3)
    ...s Age=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",4)
    ...s mradmdate=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",5)
    ...s disdate=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",6)
    ...s mrdisroom=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",7)
    ...s disdiag=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",8)
    ...s paadm=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",9)
    ...s papmino=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",10)
    ...s mrcardid=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",11)
    ...s mrtel=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",12)
    ...s mraddress=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",13)
    ...s docname=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",14)
    ...s LocDesc=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",15)
    ...q:(PatInDate'="")&&(PatInDate>Num)
    ...s loop=loop+1
    ...q:(PatLocNum'="")&&(loop>PatLocNum)
    ...
    ...d OutputRow
    
    s Loc=..GetLastLoc()
    i (Loc=0)
    {Set qHandle=$lb(0,repid,0)
    Quit $$$OK}
    s Loc=0
    
    f  s Loc=$o(^DHCPETMPLocNum(user,Loc)) q:(Loc="")||(Loc>..GetLastLoc())  d
    .s Num="",loop=0
    .f  s Num=$o(^DHCPETMPLocNum(user,Loc,Num),-1) q:Num=""  d
    ..s adm=0
    ..f  s adm=$o(^DHCPETMPLocNum(user,Loc,Num,adm)) q:adm=""  d
    ...s mrmrid=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",1)
    ...s mrname=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",2)
    ...s mrgender=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",3)
    ...s Age=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",4)
    ...s mradmdate=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",5)
    ...s disdate=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",6)
    ...s mrdisroom=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",7)
    ...s disdiag=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",8)
    ...s paadm=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",9)
    ...s papmino=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",10)
    ...s mrcardid=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",11)
    ...s mrtel=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",12)
    ...s mraddress=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",13)
    ...s docname=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",14)
    ...s LocDesc=$p($g(^DHCPETMPLocNum(user,Loc,Num,adm)),"^",15)
    ...q:(PatInDate'="")&&(PatInDate>Num)
    ...s loop=loop+1
    ...q:(PatLocNum'="")&&(loop>PatLocNum)
    ...
    ...d OutputRow
    */
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    
    set Data=$lb(mrmrid,mrname,mrgender,Age,mradmdate,disdate,mrdisroom,disdiag,paadm,papmino,mrcardid,mrtel,mraddress,docname,LocDesc,"出院")
    
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchMRBaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchMRBaseExecute ]
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

ClassMethod SearchMRBaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchMRBaseExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetLastLoc()
{
    s patloc=0
    s lastid=$o(^DHCCRMFUP(""),-1)
    q:lastid="" 0
    s paadm=$p(^DHCCRMFUP(lastid),"^",1)
    s patloc=$p(^PAADM(paadm),"^",70)
    q patloc
}

/// w ##class(web.DHCCRM.SetPlan).GetAllMDiagnos(440)
ClassMethod GetAllMDiagnos(Adm) As %String
{
  q:Adm="" ""
  s diagdes=""
  s mradm=$P(^PAADM(Adm),"^",61)
  s mcl=0  
  f  s mcl=$O(^MR(mradm,"DIA",mcl)) q:(mcl="")  d
  .s prefix=$P(^MR(mradm,"DIA",mcl,1),"^",26)
  .s desc=$g(^MR(mradm,"DIA",mcl,"DES",1))
  .s diag=""
  .s icddr=$P(^MR(mradm,"DIA",mcl),"^",1)
  .i icddr'="" s diag=$P(^MRC("ID",icddr),"^",2)
  .i diagdes="" s diagdes=prefix_diag_desc
  .e  s diagdes=diagdes_";"_prefix_diag_desc
  q diagdes
}

/// D ##class(%ResultSet).RunQuery("web.DHCCRM.SetPlan","SearchMRBaseI","","","","","","","","","","","","","")                                                                                                                          
Query SearchMRBaseI(BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum) As %Query(ROWSPEC = "mrmrid:%String,mrname:%String,mrgender:%String,mrage:%String,mradmdate:%String,mrdisdate:%String,mrdisroom:%String,mrdisdiagname:%String,mradm:%String,mRegno:%String,mrcardid:%String,mrtel:%String,mraddress:%String,docname:%String,mtype")
{
}

ClassMethod SearchMRBaseIExecute(ByRef qHandle As %Binary, BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    s PatName=##class(web.DHCPE.DHCPECommon).UnEscape(PatName)
    i BeginDate="" s BeginDate=+$h-30
    else  s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
    i EndDate="" s EndDate=+$h
    else  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    s RealLocId=$p(LocID,"^",1)
    s user=%session.Get("LOGON.USERID")
    k ^DHCPETMPLocNum(user)
    s WardID=""
    f  s WardID=$o(^PAADMi("CurrWard",WardID)) q:WardID=""  d
    .s roomID=""
    .f  s roomID=$o(^PAADMi("CurrWard",WardID,roomID)) q:roomID=""  d
    ..s paadm=0
    ..f  s paadm=$o(^PAADMi("CurrWard",WardID,roomID,paadm)) q:paadm=""  d  
    ...s papmiid=$P(^PAADM(paadm),"^",1)
    ...s papmino=$p(^PAPER(papmiid,"PAT",1),"^",1) //登记号
    ...i RegNo'=""  s AllRegNo=..RegNoMask(RegNo)
    ...s pttype=$P($g(^PAADM(paadm)),"^",2)
    ...q:pttype'="I" //住院病人
    ...q:($d(^DHCCRMFUP(0,"FUP_PAADM",paadm)))&&(FindCheck="false")
    ...q:('$d(^DHCCRMFUP(0,"FUP_PAADM",paadm)))&&(FindCheck="true")
    ...s ward=$P($g(^PAADM(paadm)),"^",70)
    ...i ward'="" d
    ....s ward=$P(ward,$c(1))
    ....s Tword=$p($g(^PAWARD(ward)),"^",2)
    ....s Tword=$p(Tword,"-",2)
    ....i Tword="" s Tword=$p($g(^PAWARD(ward)),"^",2)
    ...s visit=$P($g(^PAADM(paadm)),"^",20)
    ...q:visit'="A" //在院
    ...s mrmrid=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(paadm,pttype,.ErrMsg) ;$p($g(^PAPER(papmiid,"PAT",1)),"^",22) //住院号
    ...q:(RegNo'="")&&(RegNo'=papmino)&&(RegNo'=mrmrid)&&(AllRegNo'=papmino)
    ...s papmino=$p(^PAPER(papmiid,"PAT",1),"^",1) //登记号
    ...s admdate=+##class(web.DHCDischargeHistory).GetAdminDateTime(paadm)
    ...i admdate=0 s admdate=$P($g(^PAADM(paadm)),"^",6) //入院日期
    ...q:((admdate'="")&&(admdate<BeginDate))||((admdate'="")&&(admdate>EndDate))
    ...i admdate'="" s mradmdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
    ...s mrname=$p(^PAPER(papmiid,"ALL"),"^",1)
    ...q:(mrname'=PatName)&&(PatName'="")
    ...s mrgender=$p(^PAPER(papmiid,"ALL"),"^",7)
    ...q:(PatSexID'="")&&(PatSexID'= mrgender)
    ...i mrgender'="" s mrgender=$p(^CT("SEX",mrgender),"^",2)
    ...s Dead=""
    ...s DeadFlag=$p(^PAPER(papmiid,"ALL"),"^",12)
    ...i DeadFlag="Y" s Dead="(死亡)"
    ...q:DeadFlag="Y"
    ...s mrgender=mrgender_Dead
    ...s mrbirthday=$p(^PAPER(papmiid,"ALL"),"^",6)
    ...i mrbirthday'="" s mrbirthday=##class(web.DHCLCNUREXCUTE).CalAge(mrbirthday,$P($g(^PAADM(paadm)),"^",6))
    ...s Age=$P(mrbirthday,"Y",1)_"岁"
    ...s:(Age="0岁") Age=##class(web.DHCBillInterface).GetPapmiAge(papmiid,paadm)
    ...i Age["天" s PatAgeFrom=PatAgeFrom*365,PatAgeTo=PatAgeTo*365
    ...q:(+PatAgeFrom'=0)&&(+PatAgeFrom>+Age)
    ...q:(+PatAgeTo'=0)&&(+PatAgeTo<+Age)
    ...s mrcardid=$p(^PAPER(papmiid,"ALL"),"^",9)
    ...s bed=$P($g(^PAADM(paadm)),"^",73)
    ...if bed'=""  s bed=$p(^PAWARD($p(bed,"||",1),"BED",$p(bed,"||",2)),"^",1)
    ...s disdiag=bed //..GetAllMDiagnos(paadm)
    ...s depid=$P($g(^PAADM(paadm)),"^",4)
    ...s HospDr=$p(^CTLOC(depid),"^",22)
    ...q:(YuanQuID'="")&&(YuanQuID'=HospDr)
    ...q:(RealLocId'="")&&(RealLocId'=depid)
    ...s disdate=Tword
    ...i depid'="" d
    ....s Tdepname=$p($g(^CTLOC(depid)),"^",2)
    ....s Tdepname=$p(Tdepname,"-",2)
    ....i Tdepname="" s Tdepname=$p($g(^CTLOC(depid)),"^",2)
    ...s mrdisroom=Tdepname
    ...s mrtel=$p(^PAPER(papmiid,"PER",1),"^",11)
    ...s mraddress=$g(^PAPER(papmiid,"PER","ADD"))
    ...s admdoc=$p(^PAADM(paadm),"^",9)
    ...i +admdoc'=0 s docname=$p(^CTPCP(admdoc,1),"^",2)
    ...s ^DHCPETMPLocNum(user,depid)=$g(^DHCPETMPLocNum(user,depid))+1
    ...q:(PatLocNum'="")&&($g(^DHCPETMPLocNum(user,depid))>PatLocNum)
    ...d OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(mrmrid,mrname,mrgender,Age,mradmdate,disdate,mrdisroom,disdiag,paadm,papmino,mrcardid,mrtel,mraddress,docname,"在院")
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchMRBaseIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchMRBaseIExecute ]
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

ClassMethod SearchMRBaseIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchMRBaseIExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCCRM.SetPlan","SearchMRBaseO","","","","","","","","","","","","","","","")                                                                                                                          
Query SearchMRBaseO(BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum) As %Query(ROWSPEC = "mrmrid:%String,mrname:%String,mrgender:%String,mrage:%String,mradmdate:%String,mrdisdate:%String,mrdisroom:%String,mrdisdiagname:%String,mradm:%String,mRegno:%String,mrcardid:%String,mtype:%String")
{
}

ClassMethod SearchMRBaseOExecute(ByRef qHandle As %Binary, BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1

    s PatName=##class(web.DHCPE.DHCPECommon).UnEscape(PatName)
    i BeginDate="" s BeginDate=+$h-1
    else  s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
    i EndDate="" s EndDate=+$h
    else  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    s RealLocId=$p(LocID,"^",1)
    s EndDate=BeginDate //门诊数据量巨大，只查询一天
    f chgdate=BeginDate:1:EndDate d
    .s paadm=0
    .f  s paadm=$o(^PAADMi("PAADM_AdmDate",chgdate,paadm))  q:paadm=""  d
    ..s papmiid=$P(^PAADM(paadm),"^",1)
    ..s pttype=$P($g(^PAADM(paadm)),"^",2)
    ..q:pttype'="O" //门诊病人
    ..s disdate=chgdate
    ..s visit=$P($g(^PAADM(paadm)),"^",20)
    ..q:visit'="A" //就诊
    ..q:(RealLocId'="")&&(RealLocId'=$P($g(^PAADM(paadm)),"^",4))
    ..s mrmrid=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(paadm,pttype,.ErrMsg) ;$p($g(^PAPER(papmiid,"PAT",1)),"^",22) //住院号
    ..s papmino=$p(^PAPER(papmiid,"PAT",1),"^",1) //登记号
    ..q:(RegNo'=papmino)&&(RegNo'="")
    ..q:($d(^DHCCRMFUP(0,"FUP_PAADM",paadm)))&&(FindCheck="false")
    ..q:('$d(^DHCCRMFUP(0,"FUP_PAADM",paadm)))&&(FindCheck="true")
    ..s admdate=chgdate //入院日期
    ..i admdate'="" s mradmdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
    ..s mrname=$p(^PAPER(papmiid,"ALL"),"^",1)
    ..q:(PatName'="")&&(mrname'[PatName)
    ..s mrgender=$p(^PAPER(papmiid,"ALL"),"^",7)
    ..q:(PatSexID'="")&&(PatSexID'= mrgender)
    ..i mrgender'="" s mrgender=$p(^CT("SEX",mrgender),"^",2)
    ..s mrbirthday=$p(^PAPER(papmiid,"ALL"),"^",6)
    ..i mrbirthday'="" s mrbirthday=##class(web.DHCLCNUREXCUTE).CalAge(mrbirthday,$P($g(^PAADM(paadm)),"^",6))
    ..s Age=$P(mrbirthday,"Y",1)_"岁"
    ..s:(Age="0岁") Age=##class(web.DHCBillInterface).GetPapmiAge(papmiid,paadm)
    ..i Age["天" s PatAgeFrom=PatAgeFrom*365,PatAgeTo=PatAgeTo*365
    ..s mrcardid=$p(^PAPER(papmiid,"ALL"),"^",9)
    ..q:(+PatAgeFrom'="0")&&(+PatAgeFrom>+Age)
    ..q:(+PatAgeTo'="0")&&(+PatAgeTo<+Age)
    ..s depcodeid=$p(^PAADM(paadm),"^",4)
    ..s HospDr=$p(^CTLOC(depcodeid),"^",22)
    ..q:(YuanQuID'="")&&(YuanQuID'=HospDr)
    ..s mrdisroom=$p($P(^CTLOC(depcodeid),"^",2),"-",2)
    ..i mrdisroom="" s mrdisroom=$P(^CTLOC(depcodeid),"^",2)
    ..s ctpcpdr=$p(^PAADM(paadm),"^",9)
    ..q:ctpcpdr=""
    ..s ctdesc=$p($g(^CTPCP(ctpcpdr,1)),"^",2)
    ..s disdate=ctdesc
    ..s subrowid=0
    ..s papmidiagnose=""
    ..s mrrowid=$p(^PAADM(paadm),"^",61)
    ..f  s subrowid=$o(^MR(mrrowid,"DIA",subrowid)) q:subrowid=""  d //循环
    ...s diagid=$p(^MR(mrrowid,"DIA",subrowid),"^",1) 
    ...if (diagid'="")&&($d(^MRC("ID",diagid))=11) d
    .... s papmidiagnose=papmidiagnose_"/"_$p(^MRC("ID",diagid),"^",2) //取诊断的描述追加
    ...s paadmmrdesc=$p($g(^MR(mrrowid,"DIA",subrowid,"DES",1)),"^",1)
    ...s papmidiagnose=papmidiagnose_"/"_paadmmrdesc
    ..s disdiag=..GetAllMDiagnos(paadm)
	..q:(ICD'="")&&(disdiag'[$p(^MRC("ID",ICD),"^",2))
    ..s jz="初诊"
    ..s admre=$p($g(^PAADM(paadm)),"^",56)
    ..if (admre="R") s jz="门诊复诊"
    ..s FirstAdm=$p($g(^PAADM(paadm)),"^",72)
    ..i FirstAdm="F" s jz="初诊"
    ..e  i FirstAdm="R" s jz="出院复诊"
    ..s TransAdm=$p($g(^PAADM(paadm,"DHC")),"^",5)
    ..i TransAdm="Y" s jz="转诊"
    
    ..d OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(jz,mrname,mrgender,Age,mradmdate,disdate,mrdisroom,disdiag,paadm,papmino,mrcardid,"门诊")
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchMRBaseOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchMRBaseOExecute ]
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

ClassMethod SearchMRBaseOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchMRBaseOExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCCRM.SetPlan","SearchMRBaseU","","","","","","","","","","","")                                                                                                                          
Query SearchMRBaseU(BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType) As %Query(ROWSPEC = "mrmrid:%String,mrname:%String,mrgender:%String,mrage:%String,mradmdate:%String,mrdisdate:%String,mrdisroom:%String,mrdisdiagname:%String,mradm:%String,mRegno:%String,mrcardid:%String")
{
}

ClassMethod SearchMRBaseUExecute(ByRef qHandle As %Binary, BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1

    s PatName=##class(web.DHCPE.DHCPECommon).UnEscape(PatName)
    i BeginDate="" s BeginDate=+$h
    else  s BeginDate=$Zdh(BeginDate,3)
    i EndDate="" s EndDate=+$h
    else  s EndDate=$Zdh(EndDate,3)
    f chgdate=BeginDate:1:EndDate d
    .s paadm=0
    .f  s paadm=$o(^PAADMi("PAADM_AdmDate",chgdate,paadm))  q:paadm=""  d
    ..s papmiid=$P(^PAADM(paadm),"^",1)
    ..s pttype=$P($g(^PAADM(paadm)),"^",2)
    ..s SSRowid=0,BYRowId=""
    ..f  s SSRowid=$o(^CT("SS",SSRowid)) q:SSRowid=""  d
    ...s SSDesc=$p(^CT("SS",SSRowid),"^",2)
    ...i SSDesc["本院" s BYRowId=BYRowId_"^"_SSRowid
    ..s BYRowId=BYRowId_"^"
    ..s typeid=$p(^PAPER(papmiid,"PER",1),"^",10)
    ..q:BYRowId'[("^"_typeid_"^")
    ..s Tword=""
    ..s ward=$P($g(^PAADM(paadm)),"^",70)
    ..i ward'="" d
    ...s ward=$P(ward,$c(1))
    ...s Tword=$p($g(^PAWARD(ward)),"^",2)
    ...s Tword=$p(Tword,"-",2)
    ..s disdate=Tword
    ..s visit=$P($g(^PAADM(paadm)),"^",20)
    ..q:visit'="A" //就诊
    ..s mrmrid=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(paadm,pttype,.ErrMsg) ;$p($g(^PAPER(papmiid,"PAT",1)),"^",22) //住院号
    ..s papmino=$p(^PAPER(papmiid,"PAT",1),"^",1) //登记号
    ..s admdate=$P($g(^PAADM(paadm)),"^",6) //入院日期
    ..i admdate'="" s mradmdate=$zd(admdate,3)
    ..s mrname=$p(^PAPER(papmiid,"ALL"),"^",1)
    ..q:(mrname'=PatName)&&(PatName'="")
    ..s mrgender=$p(^PAPER(papmiid,"ALL"),"^",7)
    ..q:(PatSexID'="")&&(PatSexID'= mrgender)
    ..i mrgender'="" s mrgender=$p(^CT("SEX",mrgender),"^",2)
    ..s mrbirthday=$p(^PAPER(papmiid,"ALL"),"^",6)
    ..i mrbirthday'="" s mrbirthday=##class(web.DHCLCNUREXCUTE).CalAge(mrbirthday,$P($g(^PAADM(paadm)),"^",6))
    ..s Age=$P(mrbirthday,"Y",1)_"岁"
    ..s:(Age="0岁") Age=##class(web.DHCBillInterface).GetPapmiAge(papmiid,"",$ZD(+$H,3),$Zt($p($H,",",2)))
    ..q:(RegNo'=papmino)&&(RegNo'="")
    ..s mrcardid=$p(^PAPER(papmiid,"ALL"),"^",9)
    ..s bed=$P($g(^PAADM(paadm)),"^",73)
    ..if bed'=""  s bed=$p(^PAWARD($p(bed,"||",1),"BED",$p(bed,"||",2)),"^",1)
    ..s disdiag=bed
    ..s depid=$P($g(^PAADM(paadm)),"^",4)
    ..q:(LocID'="")&&(LocID'=depid)
    ..i depid'="" d
    ...s Tdepname=$p($g(^CTLOC(depid)),"^",2)
    ...s Tdepname=$p(Tdepname,"-",2)
    ..s mrdisroom=Tdepname
    ..d OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(mrmrid,mrname,mrgender,Age,mradmdate,disdate,mrdisroom,disdiag,paadm,papmino,mrcardid)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchMRBaseUFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchMRBaseUExecute ]
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

ClassMethod SearchMRBaseUClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchMRBaseUExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query SearchFUPlan(BeginDate, EndDate, fuperson As %String = "") As %Query(ROWSPEC = "FUPPAADM:%String,FUPSubject:%String,FUPFUDate:%String,FUPFUUserDR:%String,PAPMINO:%String,PAPMIName:%String,EndDate:%String")
{
}

ClassMethod SearchFUPlanExecute(ByRef qHandle As %Binary, BeginDate, EndDate, fuperson) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    i BeginDate="" s BeginDate=""
    else  s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
    i EndDate="" s EndDate=""
    else  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    s Subs=$p(fuperson,"^",2)
    s fuperson=$p(fuperson,"^",1)
    s fuprowid=0
    f  s fuprowid=$o(^DHCCRMFUP(fuprowid)) q:fuprowid=""  d
    .s FUPPAADM=$p(^DHCCRMFUP(fuprowid),"^",1)
    .s PAPMIDR=$P(^PAADM(FUPPAADM),"^",1)
    .q:PAPMIDR=""
    .s PAPMINO=$P(^PAPER(PAPMIDR,"PAT",1),"^",1)
    .s PAPMIName=$P(^PAPER(PAPMIDR,"ALL"),"^",1)
    .s FUPSubjectDR=$p(^DHCCRMFUP(fuprowid),"^",2)
	.q:(Subs'="")&&(Subs'[FUPSubjectDR)
    .s FUPSubject=$p($g(^DHCCRMFUS(FUPSubjectDR)),"^",2)
    .s FUPFUDate=$p(^DHCCRMFUP(fuprowid),"^",3)
    .q:(BeginDate'="")&&(BeginDate'=FUPFUDate)
    .;q:$o(^DHCCRMQR(0,"QR_FUP_DR",fuprowid,0))
    .i FUPFUDate'="" s FUPFUDate=$ZD(FUPFUDate,3)
    .s FUPFUUserDR=$p(^DHCCRMFUP(fuprowid),"^",5)
    .q:(fuperson'="")&&(fuperson'=FUPFUUserDR)
    .i FUPFUUserDR'="" s FUPFUUserDR=$p(^SSU("SSUSR",FUPFUUserDR),"^",2)
    .s PTUser=$p(^DHCCRMFUP(fuprowid),"^",13)
    .i FUPFUUserDR="" s FUPFUUserDR=PTUser
    .s FUPEndDate=$p(^DHCCRMFUP(fuprowid),"^",12)
    .q:(EndDate'="")&&(FUPEndDate'=EndDate)
    .i FUPEndDate'="" s FUPEndDate=$ZD(FUPEndDate,3)
    .Do OutputRow

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(FUPPAADM,FUPSubject,FUPFUDate,FUPFUUserDR,PAPMINO,PAPMIName,FUPEndDate)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchFUPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchFUPlanExecute ]
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

ClassMethod SearchFUPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchFUPlanExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod RegNoMask(RegNo)
{
    s length=+$G(^DHCCRMSetting("DHCCRM","RegNoLength"))
    i length=0 s length=10
    s ZeroStr=$E("00000000000000000000000000",1,length)
    s RegNo=$E(ZeroStr,1,length-$l(RegNo))_RegNo
    q RegNo
}

/// 撤销计划
/// w ##class(web.DHCCRM.SetPlan).CanSetPlan(PAADM)
ClassMethod CanSetPlan(PAADM)
{
    q ""
    q:('$d(^DHCCRMFUP(0,"FUP_PAADM",PAADM))) ""
    &SQL(Delete From sqluser.DHC_CRM_FUPlan where FUP_PAADM_DR=:PAADM)
    q SQLCODE
}

/// w ##class(web.DHCCRM.SetPlan).SetPrePlan(PAADM) PAADM:PAADM ADMType:病人类型（严重程度，由医院定，做几次随访用的）,UserID:UserID
ClassMethod SetPrePlan(PAADM)
{
    ;q ""  ;2013-12-02  begin  
    s patienttype="",deathflag=""
    q:(PAADM="") ""
    q:($d(^DHCCRMFUP(0,"FUP_PAADM",PAADM))) ""
    s UserID=$p(^CTPCP($p(^PAADM(PAADM),"^",9),1),"^")   ; CODE    ;$p(^CTPCP($p(^PAADM(PAADM),"^",9),1),"^",2)
    s UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserID),0))
    s CurDate=+$H
    S CurDate2=$zd(CurDate,3)
    q:(+CurDate2="63187")
    s patienttype=##class(web.DHCSETIMAGE).PatientType(PAADM)
    s deathflag=$p(patienttype,"^",4)
    q:(deathflag=1) ""
    //q:("2013-12-31"=CurDate2)
    ;($p(CurDate,"-",2)="12")&&($p(CurDate,"-",3)="31")
    ;s CurDate=$zd(CurDate,3)
    ;w !,CurDate
    d ..SetPlan(PAADM,"7",UserID,CurDate,CurDate+10)
    d ..SetPlan(PAADM,"2","",CurDate+11,"")
    i (..IfIll(PAADM))||(..IfOperation(PAADM)="2")  d
    .d ..SetPlan(PAADM,"7",UserID,CurDate+11,CurDate+30)
    .d ..SetPlan(PAADM,"2","",CurDate+31,"")
    .d ..SetPlan(PAADM,"7",UserID,CurDate+31,CurDate+60)
    .d ..SetPlan(PAADM,"2","",CurDate+61,"")
    .s Flag=1
    i (..IfOperation(PAADM)="1")  d
    .d ..SetPlan(PAADM,"7",UserID,CurDate+11,CurDate+30)
    .d ..SetPlan(PAADM,"2","",CurDate+31,"")
    .
    b
    q ""
}

ClassMethod IfOperation(PAADM)
{
    s Flag=0
    s ID=0
    f  s ID=$o(^DHCANOPArrange(0,"Adm",PAADM,ID)) Q:(ID="")  d
    .s ANAID=$p($g(^DHCANOPArrange(ID)),"^",2)
    .s chl=$P(ANAID,"||",2)
    .s subchl=0
    .f  s subchl=$O(^OR(PAADM,"ANA",chl,"OP",subchl)) q:(subchl="")  d
    ..s ancoplId=$p($g(^OR(PAADM,"ANA",chl,"OP",subchl,"DHC")),"^",1)
    ..i ancoplId'="" s ancopldesc=$p(^DHCANC("OPLevel",ancoplId),"^",2)
    ..s:(Flag<1)&&(ancopldesc["中") Flag="1"
    ..s:(Flag<2)&&(ancopldesc["大") Flag="2"
    
    
    q Flag
}

ClassMethod IfIll(PAADM)
{
    s Flag=0
    s OeordID=$o(^OEORD(0,"Adm",PAADM,0))
    s Sub=0
    f  s Sub=$o(^OEORD(OeordID,"I",Sub)) q:(Sub="")  d
    .s ITMID=$p($g(^OEORD(OeordID,"I",Sub,1)),"^",2)
    .s:((ITMID="9400||1")||(ITMID="9701||1")) Flag=1
    .
    
    q Flag
}

// w ##class(web.DHCCRM.SetPlan).SetPlan("389737^390529^391094","1","1313","2011-10-14")

ClassMethod SetPlan(PAADMStr, FUSRowIdStr, FUSUser, FUSDate, PatientType, FUSEndDate, PTUser, fudays, funums)
{
  i FUSDate="" s FUSDate=+$h
  e  s FUSDate=$zdh(FUSDate,3)
  i fudays="" s fudays=1
  i funums="" s funums=1
  s PAADMLength=$l(PAADMStr,"^")
  s Flag=0
  for k=1:1:PAADMLength
    {
        s PAADM=$p(PAADMStr,"^",k)
    
        for j=1:1:$l(FUSRowIdStr,"^")
        { 
            s FSURowID=$p(FUSRowIdStr,"^",j)
            i $d(^DHCCRMFUP(0,"FUP_PAADM_Subject_Date",PAADM,FSURowID,FUSDate)) d
            .s PAPMI=+^PAADM(PAADM)
            .s Name=$p($g(^PAPER(PAPMI,"ALL")),"^",1)
            .s Flag=1
        }
    }
 
  i Flag=1 w "{""success"":""false"",""info"":""添加失败!"_Name_"已有此日期此问卷计划!"_"""}"
  q:Flag=1 ""
  
  
  
  
  
  TSTART
  
  s PAADMLength=$l(PAADMStr,"^")
  s SQLCODE=0
  s Time=""
  for k=1:1:PAADMLength
  {
        s PAADM=$p(PAADMStr,"^",k)
    
        for j=1:1:$l(FUSRowIdStr,"^")
        { 
            for m=1:1:funums
            {
                s FSURowID=$p(FUSRowIdStr,"^",j)
                
                i (FUSDate'="")&&(FUSDate["-") s Date=$ZDH(FUSDate,3)+((m-1)*fudays)
                e  s Date=FUSDate+((m-1)*fudays)
                i (FUSEndDate'="")&&(FUSEndDate["-") s EndDate=$ZDH(FUSEndDate,3)
                e  s EndDate=FUSEndDate
                s Time=$p($h,",",2)
                
                &SQL(insert into sqluser.DHC_CRM_FUPlan (FUP_PAADM_DR,FUP_Subject_DR,FUP_FUUser_DR,FUP_FUDate,FUP_FUTime,FUP_PatientType,FUP_EndDate,FUP_User,FUP_ContactInfo) values(:PAADM,:FSURowID,:FUSUser,:Date ,:Time,:PatientType,:EndDate,:PTUser,null))
            }
   
        }
    }

    i SQLCODE
    {
            TROLLBACK
            w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
    }
    
    TCOMMIT

    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":"_%ROWID_"}"
    q ""
}

/// D ##class(%ResultSet).RunQuery("web.DHCCRM.SetPlan","SearchMRBase","","","","","","","","","",3270877)                                                                                                                          
Query SearchMRBaseEI(BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum) As %Query(ROWSPEC = "mrmrid:%String,mrname:%String,mrgender:%String,mrage:%String,mradmdate:%String,mrdisdate:%String,mrdisroom:%String,mrdisdiagname:%String,mradm:%String,mRegno:%String,mrcardid:%String,mrtel:%String,mraddress:%String,docname:%String,mtype:%String")
{
}

ClassMethod SearchMRBaseEIExecute(ByRef qHandle As %Binary, BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    s PatName=##class(web.DHCPE.DHCPECommon).UnEscape(PatName)
    i BeginDate="" s BeginDate=+$h-30
    else  s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
    i EndDate="" s EndDate=+$h
    else  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    s user=%session.Get("LOGON.USERID")
    k ^DHCPETMPLocNum(user)
    s RealLocId=$p(LocID,"^",1)
    s WardID=""
    f  s WardID=$o(^PAADMi("CurrWard",WardID)) q:WardID=""  d
    .s roomID=""
    .f  s roomID=$o(^PAADMi("CurrWard",WardID,roomID)) q:roomID=""  d
    ..s paadm=0
    ..f  s paadm=$o(^PAADMi("CurrWard",WardID,roomID,paadm)) q:paadm=""  d  
    ...s papmiid=$P(^PAADM(paadm),"^",1)
    ...s papmino=$p(^PAPER(papmiid,"PAT",1),"^",1) //登记号
    ...i RegNo'=""  s AllRegNo=..RegNoMask(RegNo)
    ...s pttype=$P($g(^PAADM(paadm)),"^",2)
    ...q:pttype'="E" //急诊病人
    ...q:($d(^DHCCRMFUP(0,"FUP_PAADM",paadm)))&&(FindCheck="false")
    ...q:('$d(^DHCCRMFUP(0,"FUP_PAADM",paadm)))&&(FindCheck="true")
    ...s ward=$P($g(^PAADM(paadm)),"^",70)
    ...i ward'="" d
    ....s ward=$P(ward,$c(1))
    ....s Tword=$p($g(^PAWARD(ward)),"^",2)
    ....s Tword=$p(Tword,"-",2)
    ....i Tword="" s Tword=$p($g(^PAWARD(ward)),"^",2)
    ...s visit=$P($g(^PAADM(paadm)),"^",20)
    ...q:visit'="A" //在院
    ...s mrmrid=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(paadm,pttype,.ErrMsg) ;$p($g(^PAPER(papmiid,"PAT",1)),"^",22) //住院号
    ...q:(RegNo'="")&&(RegNo'=papmino)&&(RegNo'=mrmrid)&&(AllRegNo'=papmino)
    ...s papmino=$p(^PAPER(papmiid,"PAT",1),"^",1) //登记号
    ...s admdate=$P($g(^PAADM(paadm)),"^",6) //入院日期
    ...q:((admdate'="")&&(admdate<BeginDate))||((admdate'="")&&(admdate>EndDate))
    ...i admdate'="" s mradmdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
    ...s mrname=$p(^PAPER(papmiid,"ALL"),"^",1)
    ...q:(mrname'=PatName)&&(PatName'="")
    ...s mrgender=$p(^PAPER(papmiid,"ALL"),"^",7)
    ...q:(PatSexID'="")&&(PatSexID'= mrgender)
    ...i mrgender'="" s mrgender=$p(^CT("SEX",mrgender),"^",2)
    ...s Dead=""
    ...s DeadFlag=$p(^PAPER(papmiid,"ALL"),"^",12)
    ...i DeadFlag="Y" s Dead="(死亡)"
    ...;q:DeadFlag="Y"
    ...s mrgender=mrgender_Dead
    ...s mrbirthday=$p(^PAPER(papmiid,"ALL"),"^",6)
    ...i mrbirthday'="" s mrbirthday=##class(web.DHCLCNUREXCUTE).CalAge(mrbirthday,$P($g(^PAADM(paadm)),"^",6))
    ...s Age=$P(mrbirthday,"Y",1)_"岁"
    ...s:(Age="0岁") Age=##class(web.DHCBillInterface).GetPapmiAge(papmiid,paadm)
    ...i Age["天" s PatAgeFrom=PatAgeFrom*365,PatAgeTo=PatAgeTo*365
    ...s mrcardid=$p(^PAPER(papmiid,"ALL"),"^",9)
    ...q:(+PatAgeFrom'="0")&&(+PatAgeFrom>+Age)
    ...q:(+PatAgeTo'="0")&&(+PatAgeTo<+Age)
    ...s bed=$P($g(^PAADM(paadm)),"^",73)
    ...if bed'=""  s bed=$p(^PAWARD($p(bed,"||",1),"BED",$p(bed,"||",2)),"^",1)
    ...s disdiag=bed //..GetAllMDiagnos(paadm)
    ...s depid=$P($g(^PAADM(paadm)),"^",4)
    ...s HospDr=$p(^CTLOC(depid),"^",22)
    ...q:(YuanQuID'="")&&(YuanQuID'=HospDr)
    ...q:(RealLocId'="")&&(RealLocId'=depid)
    ...s disdate=Tword
    ...i depid'="" d
    ....s Tdepname=$p($g(^CTLOC(depid)),"^",2)
    ....s Tdepname=$p(Tdepname,"-",2)
    ....i Tdepname="" s Tdepname=$p($g(^CTLOC(depid)),"^",2)
    ...s mrdisroom=Tdepname
    ...s mrtel=$p(^PAPER(papmiid,"PER",1),"^",11)
    ...s mraddress=$g(^PAPER(papmiid,"PER","ADD"))
    ...s admdoc=$p(^PAADM(paadm),"^",9)
    ...i admdoc'="" s docname=$p(^CTPCP(admdoc,1),"^",2)
    ...s ^DHCPETMPLocNum(user,depid)=$g(^DHCPETMPLocNum(user,depid))+1
    ...q:(PatLocNum'="")&&($g(^DHCPETMPLocNum(user,depid))>PatLocNum)
    ...d OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(mrmrid,mrname,mrgender,Age,mradmdate,disdate,mrdisroom,disdiag,paadm,papmino,mrcardid,mrtel,mraddress,docname,"急诊留观")
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchMRBaseEIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchMRBaseEIExecute ]
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

ClassMethod SearchMRBaseEIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchMRBaseEIExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCCRM.SetPlan","SearchMRBaseEO","","","","","","","","","","","")                                                                                                                          
Query SearchMRBaseEO(BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum) As %Query(ROWSPEC = "mrmrid:%String,mrname:%String,mrgender:%String,mrage:%String,mradmdate:%String,mrdisdate:%String,mrdisroom:%String,mrdisdiagname:%String,mradm:%String,mRegno:%String,mrcardid:%String,mtype:%String")
{
}

ClassMethod SearchMRBaseEOExecute(ByRef qHandle As %Binary, BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1

    s PatName=##class(web.DHCPE.DHCPECommon).UnEscape(PatName)
    i BeginDate="" s BeginDate=+$h
    else  s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
    i EndDate="" s EndDate=+$h
    else  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    f chgdate=BeginDate:1:EndDate d
    .s paadm=0
    .f  s paadm=$o(^PAADMi("PAADM_AdmDate",chgdate,paadm))  q:paadm=""  d
    ..s papmiid=$P(^PAADM(paadm),"^",1)
    ..s pttype=$P($g(^PAADM(paadm)),"^",2)
    ..q:pttype'="E" //急诊病人
    ..s disdate=chgdate
    ..s visit=$P($g(^PAADM(paadm)),"^",20)
    ..q:visit'="A" //就诊
    ..s mrmrid=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(paadm,pttype,.ErrMsg) ;$p($g(^PAPER(papmiid,"PAT",1)),"^",22) //住院号
    ..s papmino=$p(^PAPER(papmiid,"PAT",1),"^",1) //登记号
    ..q:($d(^DHCCRMFUP(0,"FUP_PAADM",paadm)))&&(FindCheck="false")
    ..q:('$d(^DHCCRMFUP(0,"FUP_PAADM",paadm)))&&(FindCheck="true")
    ..s admdate=chgdate //入院日期
    ..i admdate'="" s mradmdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
    ..s mrname=$p(^PAPER(papmiid,"ALL"),"^",1)
    ..q:(PatName'="")&&(mrname'[PatName)
    ..s mrgender=$p(^PAPER(papmiid,"ALL"),"^",7)
    ..q:(PatSexID'="")&&(PatSexID'= mrgender) 
    ..i mrgender'="" s mrgender=$p(^CT("SEX",mrgender),"^",2)
    ..s mrbirthday=$p(^PAPER(papmiid,"ALL"),"^",6)
    ..i mrbirthday'="" s mrbirthday=##class(web.DHCLCNUREXCUTE).CalAge(mrbirthday,$P($g(^PAADM(paadm)),"^",6))
    ..s Age=$P(mrbirthday,"Y",1)_"岁"
    ..s:(Age="0岁") Age=##class(web.DHCBillInterface).GetPapmiAge(papmiid,paadm)
    ..i Age["天" s PatAgeFrom=PatAgeFrom*365,PatAgeTo=PatAgeTo*365
    ..q:(+PatAgeFrom'="0")&&(+PatAgeFrom>+Age)
    ..q:(+PatAgeTo'="0")&&(+PatAgeTo<+Age)
    ..q:(RegNo'=papmino)&&(RegNo'="")
    ..s mrcardid=$p(^PAPER(papmiid,"ALL"),"^",9)
    ..s depcodeid=$p(^PAADM(paadm),"^",4)
    ..s HospDr=$p(^CTLOC(depcodeid),"^",22)
    ..q:(YuanQuID'="")&&(YuanQuID'=HospDr)
    ..s mrdisroom=$p($P(^CTLOC(depcodeid),"^",2),"-",2)
    ..i mrdisroom="" s mrdisroom=$P(^CTLOC(depcodeid),"^",2)
    ..s ctpcpdr=$p(^PAADM(paadm),"^",9)
    ..s ctdesc=$p($g(^CTPCP(ctpcpdr,1)),"^",2)
    ..s disdate=ctdesc
    ..s subrowid=0
    ..s papmidiagnose=""
    ..s mrrowid=$p(^PAADM(paadm),"^",61)
    ..f  s subrowid=$o(^MR(mrrowid,"DIA",subrowid)) q:subrowid=""  d //循环
    ...s diagid=$p(^MR(mrrowid,"DIA",subrowid),"^",1) 
    ...if (diagid'="")&&($d(^MRC("ID",diagid))=11) d
    .... s papmidiagnose=papmidiagnose_"/"_$p(^MRC("ID",diagid),"^",2) //取诊断的描述追加
    ...s paadmmrdesc=$p($g(^MR(mrrowid,"DIA",subrowid,"DES",1)),"^",1)
    ...s papmidiagnose=papmidiagnose_"/"_paadmmrdesc
    ..s disdiag=..GetAllMDiagnos(paadm)
	..q:(ICD'="")&&(disdiag'[$p(^MRC("ID",ICD),"^",2))
    ..s jz="初诊"
    ..s admre=$p($g(^PAADM(paadm)),"^",56)
    ..if (admre="R") s jz="门诊复诊"
    ..s FirstAdm=$p($g(^PAADM(paadm)),"^",72)
    ..i FirstAdm="F" s jz="初诊"
    ..e  i FirstAdm="R" s jz="出院复诊"
    ..s TransAdm=$p($g(^PAADM(paadm,"DHC")),"^",5)
    ..i TransAdm="Y" s jz="转诊"
    
    ..d OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(jz,mrname,mrgender,Age,mradmdate,disdate,mrdisroom,disdiag,paadm,papmino,mrcardid,"急诊非留观")
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchMRBaseEOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchMRBaseEOExecute ]
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

ClassMethod SearchMRBaseEOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchMRBaseEOExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod ExportPlan(BeginDate, EndDate)
{
    i BeginDate="" s BeginDate=+$h
    else  s BeginDate=$Zdh(BeginDate,3)
    i EndDate="" s EndDate=+$h
    else  s EndDate=$Zdh(EndDate,3)
    s UserID=%session.Get("LOGON.USERID")
    s ExportName="DHCCRMPlan"
    k ^TempDHCCRMExportCommon(UserID,"UserName")
    k ^TempDHCCRMExportCommon(UserID,ExportName)
    s fuprowid=0,ind=0
    f  s fuprowid=$o(^DHCCRMFUP(fuprowid)) q:fuprowid=""  d
    .q:$o(^DHCCRMQR(0,"QR_FUP_DR",fuprowid,0))
    .s FUPPAADM=$p(^DHCCRMFUP(fuprowid),"^",1)
    .s PAPMIDR=$P($g(^PAADM(FUPPAADM)),"^",1)
    .q:PAPMIDR=""
    .s PAPMINo=$P(^PAPER(PAPMIDR,"PAT",1),"^",1)
    .s PAPMIName=$P(^PAPER(PAPMIDR,"ALL"),"^",1)
    .s Sex=$p($g(^CT("SEX",$p($g(^PAPER(PAPMIDR,"ALL")),"^",7))),"^",2)
    .s Birth=$p($g(^PAPER(PAPMIDR,"ALL")),"^",6)
    .s Age=##class(web.DHCLCNUREXCUTE).CalAge(Birth,+$h)
    .s Age=$P(Age,"Y",1)
    .i Age'="0" s Age=Age_"岁"
    .s:(Age="0") Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIDR,"",$ZD(+$H,3),$Zt($p($H,",",2))) 
    .s LocId=$p(^PAADM(FUPPAADM),"^",4)
    .i LocId'="" s Loc=$p(^CTLOC(LocId),"^",2)
    .s Ward=$p($g(^PAADM(FUPPAADM)),"^",70)
    .q:(Ward="")
    .s WardDesc=$p($p(^PAWARD(Ward),"^",2),"-",2)
    .s Tel=$p(^PAPER(PAPMIDR,"PER",1),"^",11)
    .s Tel2=$p($g(^PAPER(PAPMIDR,"PER",4)),"^",21)
    .s SID=$p(^DHCCRMFUP(fuprowid),"^",2)
    .s FUPSubject=$p($g(^DHCCRMFUS(SID)),"^",2)
    .s FUPFUDate=$p(^DHCCRMFUP(fuprowid),"^",3)
    .q:BeginDate>FUPFUDate
    .s FupEndDate=$p(^DHCCRMFUP(fuprowid),"^",12)
    .q:EndDate<FupEndDate
    .s rydate=$P($g(^PAADM(FUPPAADM)),"^",6) //入院日期
    .s cydate=$P($g(^PAADM(FUPPAADM)),"^",17) //出院日期
    .s zytianshu=+(cydate-rydate)
    .i zytianshu<1 s zytianshu=""
    .s ExportDescStr=""
    .s FUPFUUserDR=$p(^DHCCRMFUP(fuprowid),"^",5)
    .i FUPFUUserDR'="" s UserName=$p(^SSU("SSUSR",FUPFUUserDR),"^",2)
    .s PTUser=$p(^DHCCRMFUP(fuprowid),"^",13)
    .i FUPFUUserDR="" s UserName=PTUser
    .s ind=ind+1
    .q:(UserName="")
    .s ^TempDHCCRMExportCommon(UserID,"UserName",UserName)=1
    .s ^TempDHCCRMExportCommon(UserID,ExportName,UserName,ind)=fuprowid_"^"_PAPMINo_"^"_PAPMIName_"^"_Sex_"^"_Age_"^"_zytianshu_"^"_Loc_"^"_WardDesc_"^"_Tel_";"_Tel2
    q 0
}

ClassMethod GetUserName()
{
    s ret=""
    s User=%session.Get("LOGON.USERID")
    s uname=""
    f  s uname=$o(^TempDHCCRMExportCommon(User,"UserName",uname)) q:uname=""  d
    .i ret="" s ret=uname
    .e  s ret=ret_"^"_uname
    q ret
}

ClassMethod GetOneExportInfo(ID, Type, UserName)
{
    s User=%session.Get("LOGON.USERID")
    s RetID=$O(^TempDHCCRMExportCommon(User,Type,UserName,ID))
    i ID="" d
    .s RetInfo=..GetExportTitle(Type)
    e  d
    .s RetInfo=$G(^TempDHCCRMExportCommon(User,Type,UserName,ID))
    
    q RetID_"^"_RetInfo
}

/// w ##class(web.DHCCRM.SetPlan).GetExportTitle("DHCCRMDetail")
ClassMethod GetExportTitle(Type)
{
    s SID=4,Sequence=0,ExportDescStr="",ExportDetailStr=""
    f  s Sequence=$o(^DHCCRMFUS(0,"SD_Sequence",SID,Sequence)) q:Sequence=""  d
    .s DID=0
    .f  s DID=$o(^DHCCRMFUS(0,"SD_Sequence",SID,Sequence,DID)) q:DID=""  d
    ..q:'$d(^DHCCRMFUS(SID,"SD",DID))
    ..s Active=$p(^DHCCRMFUS(SID,"SD",DID),"^",7)
    ..q:Active="N"
    ..s DetailID=SID_"||"_DID
    ..s Code=$p(^DHCCRMFUS(SID,"SD",DID),"^",1)
    ..s Desc=$p(^DHCCRMFUS(SID,"SD",DID),"^",2)
    ..s SDType=$p(^DHCCRMFUS(SID,"SD",DID),"^",3)
    ..i SDType'="D" s ExportDetailStr=ExportDetailStr_"^"_DetailID
    ..s SelTextStr=""
    ..i SDType="S" d
    ...s SDSSequence=0,i=1
    ...f  s SDSSequence=$o(^DHCCRMFUS(0,"SDS_Sequence",SID,DID,SDSSequence)) q:SDSSequence=""  d
    ....s SDSSub=0
    ....f  s SDSSub=$o(^DHCCRMFUS(0,"SDS_Sequence",SID,DID,SDSSequence,SDSSub)) q:SDSSub=""  d
    .....s SelText=$p(^DHCCRMFUS(SID,"SD",DID,"SDS",SDSSub),"^",1)
    .....s SelTextStr=SelTextStr_"("_i_")"_SelText
    .....s i=i+1
    ...s ExportDesc=Desc_SelTextStr
    ..i SDType="D" d
    ...s SDSSequence=0,i=1
    ...f  s SDSSequence=$o(^DHCCRMFUS(0,"SDS_Sequence",SID,DID,SDSSequence)) q:SDSSequence=""  d
    ....s SDSSub=0
    ....f  s SDSSub=$o(^DHCCRMFUS(0,"SDS_Sequence",SID,DID,SDSSequence,SDSSub)) q:SDSSub=""  d
    .....s SelText=$p(^DHCCRMFUS(SID,"SD",DID,"SDS",SDSSub),"^",1)
    .....i SelTextStr="" s SelTextStr=Desc_"("_i_")"_SelText
    .....e  s SelTextStr=SelTextStr_"^"_Desc_"("_i_")"_SelText
    .....s ExportDetailStr=ExportDetailStr_"^"_DetailID_"$"_SelText
    .....s i=i+1
    ...s ExportDesc=SelTextStr
    ..i (SDType="N")||(SDType="T") d
    ...s ExportDesc=Desc
    .s ExportDescStr=ExportDescStr_"^"_ExportDesc
    q:Type="DHCCRMPlan" "计划ID^序号^姓名^性别^年龄^住院天数^科室^病房^联系电话^未成功联系原因说明"_ExportDescStr
    q:Type="DHCCRMDetail" "计划ID^序号^姓名^性别^年龄^住院天数^科室^病房^联系电话^未成功联系原因说明"_ExportDetailStr
}

ClassMethod KillDataGlobal()
{
    s User=%session.Get("LOGON.USERID")
    k ^DHCCRMImportInfo("Import",User)
    q 0
}

ClassMethod CreateDataGol(InString, iLoop)
{
    q:iLoop=2 0
    s User=%session.Get("LOGON.USERID")
    i iLoop=1 s ^DHCCRMImportInfo("Import",User,"DetailID")=InString
    q:iLoop=1 0
    
    s PlanId=$p(InString,"^",1)
    s PAADM=$p($g(^DHCCRMFUP(PlanId)),"^",1)
    q:(PAADM="") 0
    s PAPMI=$P($g(^PAADM(PAADM)),"^",1)
    q:(PAPMI="") "-1"
    s ^DHCCRMImportInfo("Import",User,"QRecord",PlanId)="^"_PlanId_"^"_PAADM_"^"_PAPMI_"^"_"Hang"_"^"_+$H_"^"_$p($H,",",2)_"^"_User_"^"_""
    
    s Link=$p(InString,"^",10)
    i Link'="" d
    .s linkdesc=""
    .&sql(select FUP_ContactDesc into :linkdesc from DHC_CRM_FUPlan where FUP_RowId=:PlanId)
    .q:linkdesc'=""
    .s ret=##class(web.DHCCRM.FUSubject).SetLinkFlag(PlanId,1,Link)
    
    s DetailIDStr=$g(^DHCCRMImportInfo("Import",User,"DetailID"))
    s RealResult="",Template="",RealResultTmp="",TemplateTmp=""
    f i=11:1:31 d
    .s TmpDetailId=$p(DetailIDStr,"^",i)
    .s DetailId=$p(TmpDetailId,"$",1)
    .s Result=$p(InString,"^",i)
    .s Type=$p(^DHCCRMFUS(+DetailId,"SD",$p(DetailId,"||",2)),"^",3)
    .i Type="S" d
    ..i +Result'=0 d
    ...s RealResult=$p(^DHCCRMFUS(+DetailId,"SD",$p(DetailId,"||",2),"SDS",1),"^",1)
    ...s Template=Result
    ..e  s RealResult=Result,Template=""
    .i Type="D" d
    ..s ResultStr=$p(TmpDetailId,"$",2)
    ..i Result="" s ResultStr="",BeiZhuResult=""
    ..e  s BeiZhuResult="@"_Result
    ..s RealResultTmp=RealResultTmp_"$"_ResultStr 
    ..s TemplateTmp=TemplateTmp_"$"_BeiZhuResult
    ..s RealResult=RealResultTmp
    ..s Template=TemplateTmp
    .i (Type="N")||(Type="T") d
    ..s RealResult=Result
    ..s Template=""
    .s ^DHCCRMImportInfo("Import",User,"QRecord",PlanId,"QRecordDetail",$p(DetailId,"||",2))="^^"_+DetailId_"^"_DetailId_"^"_RealResult_"^"_Template_"^"_+$H_"^"_$p($H,",",2)_"^"_""_"^"_PlanId
    q 0
}

ClassMethod ImportDataByGol()
{
    
    s User=%session.Get("LOGON.USERID")
    TSTART
    s Sort=0
    i '$d(^DHCCRMImportInfo("Import")) 
    {
    TROLLBACK
    q "-1"
    }
    s SQLCODE="-1",QRecordID=0
    f  s Sort=$o(^DHCCRMImportInfo("Import",User,"QRecord",Sort)) q:Sort=""  d
    .s PlanId=$p(^DHCCRMImportInfo("Import",User,"QRecord",Sort),"^",1)
    .s QRecord=$g(^DHCCRMImportInfo("Import",User,"QRecord",Sort))
    .k QRecordLIST
    .f i=1:1:$l(QRecord,"^") d
    ..s QRecordLIST(i)=$P(QRecord,"^",i)
    .k QRecordLIST(1)
    .&SQL(Insert Into DHC_CRM_QRecord values :QRecordLIST())
    .s QRecordID=%ROWID
    .s DetailSort=0
    .f  s DetailSort=$o(^DHCCRMImportInfo("Import",User,"QRecord",Sort,"QRecordDetail",DetailSort)) q:DetailSort=""  d
    ..s QRecordDetail=$g(^DHCCRMImportInfo("Import",User,"QRecord",Sort,"QRecordDetail",DetailSort))
    ..k QRecordDetailLIST
    ..f i=1:1:$l(QRecordDetail,"^") d
    ...s QRecordDetailLIST(i)=$P(QRecordDetail,"^",i)
    ..k QRecordDetailLIST(1)
    ..k QRecordDetailLIST(2)
    ..s QRecordDetailLIST(0)=QRecordID
    ..&SQL(Insert Into DHC_CRM_QRecordDetail values :QRecordDetailLIST())
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE_"Detail^"_QRecordID
    }
    TCOMMIT
    q SQLCODE
}

/// w ##class(web.DHCCRM.SetPlan).GetLastMonthWard()
ClassMethod GetLastMonthWard()
{
    s NowMonth=+$p($zd(+$h,3),"-",2)
    s NowYear=+$p($zd(+$h,3),"-",1)
    s LastMonth=NowMonth-1
    s LastYear=NowYear
    i LastMonth=0 s LastMonth=12,LastYear=NowYear-1
    s WardDesc=""
    s PlanID=0
    f  s PlanID=$o(^DHCCRMFUP(PlanID)) q:(PlanID="")  d
    .s Date=$p($g(^DHCCRMFUP(PlanID)),"^",3)
    .s PlanMonth=+$p($zd(Date,3),"-",2)
    .q:PlanMonth'=LastMonth
    .s PlanYear=+$p($zd(Date,3),"-",1)
    .q:PlanYear'=LastYear
    .s PAADM=$p($g(^DHCCRMFUP(PlanID)),"^",1)
    .s Ward=$p($g(^PAADM(PAADM)),"^",70)
    .q:Ward=""
    .s WardDesc=$p($p(^PAWARD(Ward),"^",2),"-",2)
    i WardDesc="" s WardDesc="血液肿瘤内科病房(西院)"
    q WardDesc
}

ClassMethod IsRepeat(WardStr)
{
    q:WardStr="" 0
    s WardDesc=..GetLastMonthWard()
    q:WardStr[WardDesc 1
    
    q 0
}

ClassMethod CreateICDDataGol(InString)
{
    
    s User=%session.Get("LOGON.USERID")
    s ICDId=$p(InString,"^",1)
    q:(ICDId="") 0
    s FUSId=$p(InString,"^",2)
    q:(FUSId="") 0
    s ^DHCCRMImportICDInfo("Import",User,"ICD",ICDId)=FUSId
    q 0
}

ClassMethod CreateICDDataGolDZ(InString)
{
    s User=%session.Get("LOGON.USERID")
    s ICDId=$p(InString,"^",2)
    s DZCode=$p(InString,"^",1)
    q:DZCode="" 0
    q:ICDId="" 0
    s DZRowId=""
    q:'$d(^User.DHCCRMQTDiseaseI("QTDCodeIndex"," "_DZCode)) 0
    s DZRowId=$o(^User.DHCCRMQTDiseaseI("QTDCodeIndex"," "_DZCode,0))   
    q:DZRowId=""
    s ^DHCCRMImportICDInfo("Import",User,"ICD",ICDId)=DZRowId
    q 0
}

ClassMethod ImportICDDataByGolDZ()
{
    s SQLCODE=0
    s User=%session.Get("LOGON.USERID")
    TSTART
    s Sort=0
    f  s Sort=$o(^DHCCRMImportICDInfo("Import",User,"ICD",Sort)) q:Sort=""  d
    .s FUSId=$g(^DHCCRMImportICDInfo("Import",User,"ICD",Sort))
    .s ICDId=Sort
    .s ICDCode=$p(^MRC("ID",ICDId),"^",1)
    .s ICDDesc=$p(^MRC("ID",ICDId),"^",2)
    .&SQL(Insert Into DHC_CRM_QTICDRelate (QTR_QTDDR,QTR_ICDDR) VALUES (:FUSId,:ICDId))
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE_"ICDR^"_%ROWID
    }
    TCOMMIT
    q SQLCODE
}

ClassMethod ImportICDDataByGol()
{
    
    s User=%session.Get("LOGON.USERID")
    TSTART
    s SQLCODE="-1",RowID=0
    s Sort=0,RowID=0
    f  s Sort=$o(^DHCCRMImportICDInfo("Import",User,"ICD",Sort)) q:Sort=""  d
    .s FUSId=$g(^DHCCRMImportICDInfo("Import",User,"ICD",Sort))
    .q:(FUSId="")
    .s ICDId=Sort
    .q:(ICDId="")
    .q:'$d(^MRC("ID",ICDId))
    .s ICDCode=$p(^MRC("ID",ICDId),"^",1)
    .q:(ICDCode="")
    .s ICDDesc=$p(^MRC("ID",ICDId),"^",2)
    .q:(ICDDesc="")
    .&SQL(Insert Into DHC_CRM_FUSDiseases (sdis_parref,sdis_code,sdis_desc,sdis_mrcid_dr) VALUES (:FUSId,:ICDCode,:ICDDesc,:ICDId))
    .s RowID=%ROWID
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE_"ICD^"_RowID
    }
    TCOMMIT
    q SQLCODE
}

ClassMethod KillICDDataGlobal()
{
    s User=%session.Get("LOGON.USERID")
    k ^DHCCRMImportICDInfo("Import",User)
    q 0
}

ClassMethod CreateLocDataGol(InString)
{
    
    s User=%session.Get("LOGON.USERID")
    s LocId=$p(InString,"^",1)
    q:LocId="" 0
    s FUSId=$p(InString,"^",2)
    q:FUSId="" 0
    s ^DHCCRMImportLocInfo("Import",User,"Loc",LocId)=FUSId
    q 0
}

ClassMethod ImportLocDataByGol()
{
    
    s User=%session.Get("LOGON.USERID")
    TSTART
    s Sort=0
    f  s Sort=$o(^DHCCRMImportLocInfo("Import",User,"Loc",Sort)) q:Sort=""  d
    .s FUSId=$g(^DHCCRMImportLocInfo("Import",User,"Loc",Sort))
    .q:FUSId=""
    .s LocId=Sort
    .q:'$d(^CTLOC(LocId))
    .s LocCode=$p(^CTLOC(LocId),"^",1)
    .s LocDesc=$p(^CTLOC(LocId),"^",2)
    .&SQL(Insert Into DHC_CRM_FUSLoc (SL_ParRef,SL_Code,SL_Desc,SL_Loc_Dr) VALUES (:FUSId,:LocCode,:LocDesc,:LocId))
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE_"Loc^"_%ROWID
    }
    TCOMMIT
    q SQLCODE
}

ClassMethod KillLocDataGlobal()
{
    s User=%session.Get("LOGON.USERID")
    k ^DHCCRMImportLocInfo("Import",User)
    q 0
}

ClassMethod CreateAnonymous(id)
{
    s SQLCODE=0
    s date=+$h
    s time=$p($h,",",2)

    &sql(INSERT INTO dhc_crm_fuplan (FUP_PAADM_DR,fup_subject_dr,fup_fudate,fup_futime,fup_fuuser_dr) VALUES (null,:id,:date,:time,null))
    
    q %ROWID
}

/// w ##class(web.DHCCRM.SetPlan).MRBaseListO("","","","","","","","","","","","","",0,20)
ClassMethod MRBaseListH(BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, start, limit)
{
    s start=$G(start)
    s limit=$G(limit)
    ;s start=0
    ;s limit=20  
    s rs=##class(%ResultSet).%New("web.DHCCRM.SetPlan:SearchMRBaseH") 
    d rs.Execute(BeginDate,EndDate,LocID,ICD,RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType,FindCheck,YuanQuID)
 
    s count=0
    s mess=""
    s topnum=start+limit
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        
        s mrmrid=rs.Get("mrmrid")
        s mrname=rs.Get("mrname")
        s mrgender=rs.Get("mrgender")
        s mrage=rs.Get("mrage")
        s mradmdate=rs.Get("mradmdate")
        s mrdisdate=rs.Get("mrdisdate")
        s mrdisroom=rs.Get("mrdisroom")
        s mrdisdiagname=""
        s mrdisdiagname=rs.Get("mrdisdiagname")
        ;s ^ydtest(count,1)=mrdisdiagname
        s mradm=rs.Get("mradm")
        s mRegno=rs.Get("mRegno")
        s mrcardid=rs.Get("mrcardid")
        s mrtel=rs.Get("mrtel")
        i (mess'="") s mess=mess_","
        s mess=mess_"{""mrmrid"":"_""""_mrmrid_""""
        s mess=mess_","_"""mrname"":"_""""_mrname_""""
        s mess=mess_","_"""mrtel"":"_""""_mrtel_""""
        s mess=mess_","_"""mrgender"":"_""""_mrgender_""""
        s mess=mess_","_"""mrage"":"_""""_mrage_""""
        s mess=mess_","_"""mrcardid"":"_""""_mrcardid_""""
        s mess=mess_","_"""mradmdate"":"_""""_mradmdate_""""
        s mess=mess_","_"""mrdisdate"":"_""""_mrdisdate_""""
        s mess=mess_","_"""mrdisroom"":"_""""_mrdisroom_""""
        s mess=mess_","_"""mrdisdiagname"":"_""""_mrdisdiagname_""""
        s mess=mess_","_"""mradm"":"_""""_mradm_""""
        s mess=mess_","_"""mRegno"":"_""""_mRegno_""""
        s mess=mess_","_"""mtype"":"_""""_"体检中心"_""""
        s mess=mess_"}"
        
    }        
 s mess="["_mess_"]"
 s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"

 q mess
}

/// D ##class(%ResultSet).RunQuery("web.DHCCRM.SetPlan","SearchMRBaseH","","","","","","","","","","","","","")                                                                                                                          
Query SearchMRBaseH(BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum) As %Query(ROWSPEC = "mrmrid:%String,mrname:%String,mrgender:%String,mrage:%String,mradmdate:%String,mrdisdate:%String,mrdisroom:%String,mrdisdiagname:%String,mradm:%String,mRegno:%String,mrcardid:%String,mrtel:%String")
{
}

ClassMethod SearchMRBaseHExecute(ByRef qHandle As %Binary, BeginDate, EndDate, LocID, ICD, RegNo, PatName, PatSexID, PatAgeFrom, PatAgeTo, PAADM, PatientType, FindCheck, YuanQuID, PatInDate, PatLocNum) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1

    s PatName=##class(web.DHCPE.DHCPECommon).UnEscape(PatName)
    i BeginDate="" s BeginDate=+$h
    else  s BeginDate=$Zdh(BeginDate,3)
    i EndDate="" s EndDate=+$h
    else  s EndDate=$Zdh(EndDate,3)
    
    f chgdate=BeginDate:1:EndDate d
    .s paadm=0
    .f  s paadm=$o(^PAADMi("PAADM_AdmDate",chgdate,paadm))  q:paadm=""  d
    ..s papmiid=$P(^PAADM(paadm),"^",1)
    ..s pttype=$P($g(^PAADM(paadm)),"^",2)
    ..q:pttype'="H" //门诊病人
    ..s disdate=chgdate
    ..s visit=$P($g(^PAADM(paadm)),"^",20)
    ..q:visit'="A" //就诊
    ..s mrmrid=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(paadm,pttype,.ErrMsg) ;$p($g(^PAPER(papmiid,"PAT",1)),"^",22) //住院号
    ..s papmino=$p(^PAPER(papmiid,"PAT",1),"^",1) //登记号
    ..q:(RegNo'=papmino)&&(RegNo'="")
    ..q:($d(^DHCCRMFUP(0,"FUP_PAADM",paadm)))&&(FindCheck="false")
    ..q:('$d(^DHCCRMFUP(0,"FUP_PAADM",paadm)))&&(FindCheck="true")
    ..s admdate=chgdate //入院日期
    ..s mrtel=""
    ..s mrtel=$p(^PAPER(papmiid,"PER",1),"^",11)
    ..i admdate'="" s mradmdate=$zd(admdate,3)
    ..s mrname=$p(^PAPER(papmiid,"ALL"),"^",1)
    ..q:(PatName'="")&&(mrname'[PatName)
    ..s mrgender=$p(^PAPER(papmiid,"ALL"),"^",7)
    ..q:(PatSexID'="")&&(PatSexID'= mrgender)
    ..i mrgender'="" s mrgender=$p(^CT("SEX",mrgender),"^",2)
    ..s mrbirthday=$p(^PAPER(papmiid,"ALL"),"^",6)
    ..i mrbirthday'="" s mrbirthday=##class(web.DHCLCNUREXCUTE).CalAge(mrbirthday,$P($g(^PAADM(paadm)),"^",6))
    ..s Age=$P(mrbirthday,"Y",1)_"岁"
    ..s:(Age="0岁") Age=##class(web.DHCBillInterface).GetPapmiAge(papmiid,paadm)
    ..s mrcardid=$p(^PAPER(papmiid,"ALL"),"^",9)
    ..q:(+PatAgeFrom'="0")&&(+PatAgeFrom>+Age)
    ..q:(+PatAgeTo'="0")&&(+PatAgeTo<+Age)
    ..s depcodeid=$p(^PAADM(paadm),"^",4)
    ..s HospDr=$p(^CTLOC(depcodeid),"^",22)
    ..q:(YuanQuID'="")&&(YuanQuID'=HospDr)
    ..s mrdisroom=$p($P(^CTLOC(depcodeid),"^",2),"-",2)
    ..s ctpcpdr=$p(^PAADM(paadm),"^",9)
    ..q:ctpcpdr=""
    ..s ctdesc=$p($g(^CTPCP(ctpcpdr,1)),"^",2)
    ..s disdate=ctdesc
    ..s subrowid=0
    ..s papmidiagnose=""
    ..s mrrowid=$p(^PAADM(paadm),"^",61)
    ..f  s subrowid=$o(^MR(mrrowid,"DIA",subrowid)) q:subrowid=""  d //循环
    ...s diagid=$p(^MR(mrrowid,"DIA",subrowid),"^",1) 
    ...if (diagid'="")&&($d(^MRC("ID",diagid))=11) d
    .... s papmidiagnose=papmidiagnose_"/"_$p(^MRC("ID",diagid),"^",2) //取诊断的描述追加
    ...s paadmmrdesc=$p($g(^MR(mrrowid,"DIA",subrowid,"DES",1)),"^",1)
    ...s papmidiagnose=papmidiagnose_"/"_paadmmrdesc
    ..s disdiag=..GetAllMDiagnos(paadm)
    ..s jz="体检"
    ..d OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(jz,mrname,mrgender,Age,mradmdate,disdate,mrdisroom,disdiag,paadm,papmino,mrcardid,mrtel)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchMRBaseHFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchMRBaseHExecute ]
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

ClassMethod SearchMRBaseHClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchMRBaseHExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SetPlanHISUI(PAADMStr, FUSRowIdStr, FUSUser, FUSDate, PatientType, FUSEndDate, PTUser, fudays, funums)
{
  i FUSDate="" s FUSDate=+$h
  e  s FUSDate=##class(websys.Conversions).DateHtmlToLogical(FUSDate)
  i FUSEndDate'="" s FUSEndDate=##class(websys.Conversions).DateHtmlToLogical(FUSEndDate)
  i fudays="" s fudays=1
  i funums="" s funums=1
  s PAADMLength=$l(PAADMStr,"^")
  s Flag=0
  for k=1:1:PAADMLength
    {
        s PAADM=$p(PAADMStr,"^",k)
    
        for j=1:1:$l(FUSRowIdStr,"^")
        { 
            s FSURowID=$p(FUSRowIdStr,"^",j)
            i $d(^DHCCRMFUP(0,"FUP_PAADM_Subject_Date",PAADM,FSURowID,FUSDate)) d
            .s PAPMI=+^PAADM(PAADM)
            .s Name=$p($g(^PAPER(PAPMI,"ALL")),"^",1)
            .s Flag=1
        }
    }
 
  q:Flag=1 Name_"已有此日期此问卷计划!"
  
  
  
  
  
  TSTART
  
  s PAADMLength=$l(PAADMStr,"^")
  s SQLCODE=0
  s Time=""
  for k=1:1:PAADMLength
  {
        s PAADM=$p(PAADMStr,"^",k)
    
        for j=1:1:$l(FUSRowIdStr,"^")
        { 
            for m=1:1:funums
            {
                s FSURowID=$p(FUSRowIdStr,"^",j)
                s Date=FUSDate+((m-1)*fudays)
                s EndDate=FUSEndDate
                s Time=$p($h,",",2)
                
                &SQL(insert into sqluser.DHC_CRM_FUPlan (FUP_PAADM_DR,FUP_Subject_DR,FUP_FUUser_DR,FUP_FUDate,FUP_FUTime,FUP_PatientType,FUP_EndDate,FUP_User,FUP_ContactInfo) values(:PAADM,:FSURowID,:FUSUser,:Date ,:Time,:PatientType,:EndDate,:PTUser,null))
            }
   
        }
    }

    i SQLCODE
    {
            TROLLBACK
            q SQLCODE
    }
    
    TCOMMIT

    q SQLCODE
}

}
