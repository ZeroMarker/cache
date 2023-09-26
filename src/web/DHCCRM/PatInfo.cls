Import SQLUser

Class web.DHCCRM.PatInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetHiddenDetail(id)
{
    s fusdst=0,detail=""
    f  s fusdst=$o(^DHCCRMFUS(+id,"SD",$p(id,"||",2),"SDS",$p(id,"||",3),"SDST",fusdst)) q:fusdst=""  d
    .s Code=$p(^DHCCRMFUS(+id,"SD",$p(id,"||",2),"SDS",$p(id,"||",3),"SDST",fusdst),"^",1)
    .s fusid=0
    .f  s fusid=$o(^DHCCRMFUS(0,"SD_Code",Code,fusid)) q:fusid=""  d
    ..s sub=$o(^DHCCRMFUS(0,"SD_Code",Code,fusid,0))
    ..q:fusid'=+id
    ..i detail=""  s detail=fusid_"||"_sub
    ..e  s detail=detail_"^"_fusid_"||"_sub
    q detail
}

ClassMethod SaveLogin(extnumber, groupid, agentid)
{
    s NowUser=%session.Get("LOGON.USERID")
    s ^DHCCRMData("Login",NowUser)=extnumber_"^"_groupid_"^"_agentid
    
    q ""
}

ClassMethod GetLogin()
{
    s NowUser=%session.Get("LOGON.USERID")
    q $g(^DHCCRMData("Login",NowUser))
}

/// w ##class(web.DHCCRM.PatInfo).GetPatInfo("","","","","","",0,20)
ClassMethod GetPatInfo(patno, patname, patdisdiag, startdate, enddate, FollowFlag, start, limit, Loc, Condition As %String = "", TelNo As %String = "", ZSCondition As %String = "")
{
    s start=$G(start)
    s limit=$G(limit)
    
    s rs=##class(%ResultSet).%New("web.DHCCRM.PatInfo:SearchPatInfo") 
    d rs.Execute(patno,patname,patdisdiag,startdate,enddate,FollowFlag,Loc,Condition,TelNo,ZSCondition)
 
    s count=0
    s mess=""
    s topnum=start+limit
    
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        s papmino=rs.Get("papmino")
        s mrname=rs.Get("mrname")
        s mrgender=rs.Get("mrgender")
        s mrbirthday=rs.Get("mrbirthday")
        s admdate=rs.Get("admdate")
        s admdiag=rs.Get("admdiag")
        s mrid=rs.Get("mrid")
        s disdiag=rs.Get("disdiag")
        s disdate=rs.Get("disdate")
        s admroom=rs.Get("admroom")
        s disroom=rs.Get("disroom")
        s mrtel=rs.Get("mrtel")
        s mraddress=rs.Get("mraddress")
        s paytype=rs.Get("paytype")
        s Subjects=rs.Get("Subjects")
        s paadm=rs.Get("paadm")
        s followup=rs.Get("followup")
        s papmidead=rs.Get("papmidead")
        s papmiid=rs.Get("papmiid")
        s mrcardid=rs.Get("mrcardid")
        s LinkCondition=rs.Get("LinkCondition")
        s DocName=rs.Get("DocName")
        s DocIf=rs.Get("DocIf")
        s DocResult=rs.Get("DocResult")
        s CRMDate=rs.Get("CRMDate")
        s pattype=rs.Get("pattype")
        i (mess'="") s mess=mess_","
        s mess=mess_"{""PAPMINo"":"_""""_papmino_""""
        s mess=mess_","_"""MRNAME"":"_""""_mrname_""""
        s mess=mess_","_"""MRGENDER"":"_""""_mrgender_""""
        s mess=mess_","_"""MRBIRTHDAY"":"_""""_mrbirthday_""""
        s mess=mess_","_"""MRADMDATE"":"_""""_admdate_""""
        s mess=mess_","_"""MRADMDIAG"":"_""""_admdiag_""""
        s mess=mess_","_"""MRMRID"":"_""""_mrid_""""
        s mess=mess_","_"""MRDISMAINDIAGNAME"":"_""""_disdiag_""""
        s mess=mess_","_"""MRDISDATE"":"_""""_disdate_""""
        s mess=mess_","_"""MRADMROOM"":"_""""_admroom_""""
        s mess=mess_","_"""MRDISROOM"":"_""""_disroom_""""
        s mess=mess_","_"""MRORGTEL"":"_""""_mrtel_""""
        s mess=mess_","_"""MRORGADDRESS"":"_""""_mraddress_""""
        s mess=mess_","_"""Subjects"":"_""""_Subjects_""""
        s mess=mess_","_"""PAADM"":"_""""_paadm_""""
        s mess=mess_","_"""FollowUp"":"_""""_followup_""""
        s mess=mess_","_"""DeadCondition"":"_""""_papmidead_""""
        s mess=mess_","_"""papmiid"":"_""""_papmiid_""""
        s mess=mess_","_"""mrcardid"":"_""""_mrcardid_""""
        s mess=mess_","_"""LinkCondition"":"_""""_LinkCondition_""""
        s mess=mess_","_"""DocName"":"_""""_DocName_""""
        s mess=mess_","_"""DocIf"":"_""""_DocIf_""""
        s mess=mess_","_"""DocResult"":"_""""_DocResult_""""
        s mess=mess_","_"""CRMDate"":"_""""_CRMDate_""""
        s mess=mess_","_"""pattype"":"_""""_pattype_""""
        s mess=mess_"}"
    }        
 s mess="["_mess_"]"
 s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"

 q mess
}

/// w ##class(web.DHCCRM.PatInfo).GetFURecord()
ClassMethod GetFURecord(fusrowid)
{
    s rs=##class(%ResultSet).%New("web.DHCCRM.PatInfo:SearchFURecord") 
    d rs.Execute(fusrowid)
 
    s count=0
    s mess=""
    while (rs.Next())
    {
        s count=count+1
        s sdrowid=rs.Get("sdrowid")
        s defaultval=rs.Get("defaultval")
    
        i (mess'="") s mess=mess_","
        s mess=mess_"{""SDRowId"":"_""""_sdrowid_""""
        s mess=mess_","_"""SDSTextVal"":"_""""_defaultval_""""
        s mess=mess_"}"
    }
    s mess="["_mess_"]"
    s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
    q mess
}

ClassMethod UpdateTel(personid, NewTel)
{
    q:NewTel=""
    q:personid=""
    &sql(Update pa_person set PAPER_TelH=:NewTel where PAPER_RowId=:personid)
    q SQLCODE
}

/// w ##class(web.DHCCRM.PatInfo).GroupFlag(1,178)
/// 判断子问卷可读的是不是已随访
ClassMethod GroupFlag(FUP, Group)
{
    
    s adm=$p(^DHCCRMFUP(FUP),"^",1)
    s parbject=$p(^DHCCRMFUP(FUP),"^",2)
    s fupdate=$p(^DHCCRMFUP(FUP),"^",3) //父主题的随访日期
    s pid=0,followup="",CRMDate=""
    f  s pid=$o(^DHCCRMFUP(0,"FUP_PAADM",adm,pid)) q:pid=""  d
    .s bject=$p(^DHCCRMFUP(pid),"^",2)
    .s parent=$p(^DHCCRMFUS(bject),"^",9)
    .q:(bject'=parbject)&&(parent="") //没有子主题的就是本主题
    .q:(parent'=parbject)&&(parent'="") //只看本主题的子主题
    .s subfupdate=$p(^DHCCRMFUP(pid),"^",3) //子主题的随访日期
    .q:subfupdate'=fupdate
    .s sgid=0
    .f  s sgid=$o(^User.DHCCRMFUSGroupI("SGSubjectIndex",bject,sgid))  q:sgid=""  d
    ..s FusGroup=$lg(^User.DHCCRMFUSGroupD(sgid),3)
    ..q:FusGroup'=Group
    ..s Write=$lg(^User.DHCCRMFUSGroupD(sgid),5)
    ..i Write="Y" d
    ...s qrrowid=$o(^DHCCRMQR(0,"QR_FUP_DR",pid,0))
    ...i qrrowid'=""  d 
    ....s followup="true"
    ....s CRMDate=$p(^DHCCRMQR(qrrowid),"^",5)
    ....s CRMDate=$zd(CRMDate)
    q followup_"^"_CRMDate
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.PatInfo","SearchPatInfo","","","","","","","","","","","")
Query SearchPatInfo(patno, patname, patdisdiag, startdate, enddate, FollowFlag As %String = "false", OutHosLoc As %String = "", Condition As %String = "false", TelNo, ZSCondition As %String = "false") As %Query(ROWSPEC = "papmino:%String,mrname:%String,mrgender:%String,mrbirthday:%String,admdate:%String,admdiag:%String,mrid:%String,disdiag:%String,disdate:%String,admroom:%String,disroom:%String,mrtel:%String,mraddress:%String,paytype:%String,Subjects:%String,paadm:%String,followup:%String,papmidead:%String,papmiid:%String,mrcardid:%String,LinkCondition:%String,DocName:%String,DocIf:%String,DocResult:%String,CRMDate:%String,fuprowid:%String,deadflag:%String,fusrowid:%String,fupDate:%String,pattype:%String")
{
}

ClassMethod SearchPatInfoExecute(ByRef qHandle As %Binary, patno, patname, patdisdiag, startdate, enddate, FollowFlag, OutHosLoc As %String = "", Condition, TelNo, ZSCondition) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    i startdate'=""  s startdate=##class(websys.Conversions).DateHtmlToLogical(startdate)
    i enddate'=""  s enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
    i startdate=""  s startdate=0
    i enddate="" d
    .i startdate>+$H  s enddate=startdate
    .i startdate<=+$H  s enddate=+$H
    s UserID=%session.Get("LOGON.USERID")
    s Group=%session.Get("LOGON.GROUPDESC")
    s GroupID=%session.Get("LOGON.GROUPID")
    s DocIf="",DocResult=""
    i FollowFlag=""  s FollowFlag="false"
    s paadm=0,qrrowid="",DocName="",CRMDate=""
    s fusDate=startdate-1
    f  s fusDate=$o(^DHCCRMFUP(0,"FUP_FUDate",fusDate)) q:(fusDate="")||(fusDate>enddate)  d
    .
    .s fuprowid=0
    .f  s fuprowid=$o(^DHCCRMFUP(0,"FUP_FUDate",fusDate,fuprowid)) q:fuprowid=""  d
    ..s fusrowid=$p(^DHCCRMFUP(fuprowid),"^",2)
    ..s ParSub=$p(^DHCCRMFUS(fusrowid),"^",9)  // 父层
    
    ..q:ParSub'="" //子问卷不显示
    
    ..s fusUser=$p(^DHCCRMFUP(fuprowid),"^",5)
    ..;q:fusUser'=UserID //随访人过滤
    ..s LinkCondition=$p($g(^DHCCRMFUP(fuprowid)),"^",9)
    ..s LinkNum=$p($g(^DHCCRMFUP(fuprowid)),"^",7)
    ..s paadm=$p($g(^DHCCRMFUP(fuprowid)),"^",1)
    ..s groupflag=..GroupFlag(fuprowid,GroupID)
    ..i groupflag'="^"  d 
    ...s followup="true"
    ...s CRMDate=$p(groupflag,"^",2)
    ..e  d 
    ...s followup="false"
    ..s LinkInfo=$p(^DHCCRMFUP(fuprowid),"^",14)
    ..q:(Condition="true")&&(LinkInfo'="L")
    ..q:(ZSCondition="true")&&(LinkInfo'="Z")
    ..q:(Condition="false")&&(ZSCondition="false")&&(LinkInfo'="")
    ..q:FollowFlag'=followup //退出不符合随访标识
    
    ..i followup="true" s SFFlag="true"
    ..e  s SFFlag=""
    ..s Subjects=fusrowid_"^"_fuprowid
    ..s papmiid=$p(^PAADM(paadm),"^",1)
    ..s pattype=$p(^PAADM(paadm),"^",2)
    ..i pattype="I" s pattype="住院"
    ..i pattype="O" s pattype="门诊"
    ..i pattype="E" s pattype="急诊"
    ..i pattype="H" s pattype="体检"
    ..s papmino=$p(^PAPER(papmiid,"PAT",1),"^",1) //登记号
    ..s papmidead=$p($g(^DHCCRMFUP(fuprowid)),"^",8) //死亡情况
    ..i papmidead="Y" s papmidead="true"
    ..e  s papmidead=""
    ..s deadflag=""
    ..i papmidead="true" s deadflag="死亡"
    ..i patno'=""  s Allpatno=..RegNoMask(patno)
    ..s pttype=$P($g(^PAADM(paadm)),"^",2)
    ..s mrmrid=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(paadm,pttype,.ErrMsg) ;$p(^PAPER(papmiid,"PAT",1),"^",22) //病案
    ..q:(patno'="")&&(patno'=papmino)&&(patno'=mrmrid)&&(Allpatno'=papmino)
    ..s mrname=$p(^PAPER(papmiid,"ALL"),"^",1)
    ..q:(patname'="")&&(mrname'[patname)
    ..s mrgender=$p(^PAPER(papmiid,"ALL"),"^",7)
    ..i mrgender'="" s mrgender=$p(^CT("SEX",mrgender),"^",2)
    ..s mrbirthday=$p(^PAPER(papmiid,"ALL"),"^",6)
    ..i mrbirthday'="" s mrbirthday=##class(web.DHCLCNUREXCUTE).CalAge(mrbirthday,$P($g(^PAADM(paadm)),"^",6))
    ..s mrbirthday=$P(mrbirthday,"Y",1)_"岁" 
    ..s:(mrbirthday="0岁") mrbirthday=##class(web.DHCBillInterface).GetPapmiAge(papmiid,paadm)
    ..s mrcardid=$p(^PAPER(papmiid,"ALL"),"^",9)
    ..s admdate=$P($g(^PAADM(paadm)),"^",6) //入院日期
    ..i admdate'="" s admdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
    ..s disdate=$P($g(^PAADM(paadm)),"^",17) //出院日期
    ..i disdate'="" s disdate=##class(websys.Conversions).DateLogicalToHtml(disdate)
    ..s mainmr=$p(^PAADM(paadm),"^",61)
    ..
    ..s mrsub=0,diagnos="",diagcode=""
    ..f  s mrsub=$o(^MR(mainmr,"DIA",mrsub)) q:mrsub=""  d
    ...s ICDCode=$p(^MR(mainmr,"DIA",mrsub),"^",1)
    ...q:ICDCode=""
    ...s ICDDesc=$p(^MRC("ID",ICDCode),"^",2)
    ...i diagnos="" s diagnos=ICDDesc
    ...e  s diagnos=diagnos_"/"_ICDDesc
    ...i diagcode="" s diagcode=ICDCode
    ...e  s diagcode=diagcode_"/"_ICDCode
    ..s disdiag=##class(web.DHCCRM.SetPlan).GetAllMDiagnos(paadm) //diagnos
    ..q:(patdisdiag'="")&&(diagcode'[patdisdiag)
    ..s mrtel=$p(^PAPER(papmiid,"PER",1),"^",11)
    ..q:(TelNo'="")&&(mrtel'[TelNo)
    ..s mraddress=$g(^PAPER(papmiid,"PER","ADD",1))
    ..s mrcd=$p(^MR(mainmr,"PRO",1),"^",10)
    ..i mrcd'="" s admroom=$p(^PAC("DISCON",mrcd),"^",2)
    ..s admdoc=$p(^PAADM(paadm),"^",9)
    ..i admdoc'="" s admdiag=$p(^CTPCP(admdoc,1),"^",2)
    ..
    ..s disroomdr=$p(^PAADM(paadm),"^",4)
    ..q:(OutHosLoc'="")&&(OutHosLoc'=disroomdr)
    ..i disroomdr'="" s disroom=$p(^CTLOC(disroomdr),"^",2)
    ..s admDocDr=$p(^PAADM(paadm),"^",9)
    ..s DocName=""
    ..i admDocDr'="" s DocName=$p(^CTPCP(admDocDr,1),"^",2)
    ..s DocIf=$p(..GetDoc(paadm,$g(fusDate)),"^",1)
    ..s DocResult=$p(..GetDoc(paadm,$g(fusDate)),"^",2)
    ..s paytype=""
    ..s fupDate=$zd(fusDate,3)
    ..Do OutputRow
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    
    set Data=$lb(papmino,mrname,mrgender,mrbirthday,admdate,admdiag,mrmrid,disdiag,disdate,admroom,disroom,mrtel,mraddress,paytype,Subjects,paadm,SFFlag,papmidead,papmiid,mrcardid,LinkCondition,DocName,DocIf,DocResult,CRMDate,fuprowid,deadflag,fusrowid,fupDate,pattype)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPatInfoExecute ]
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

ClassMethod SearchPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPatInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCCRM.PatInfo).GetDoc("28629","63126")
ClassMethod GetDoc(PAADM, Date)
{
    s Result=""
    s ID=0,followup=""
    f  s ID=$o(^DHCCRMFUP(0,"FUP_PAADM",PAADM,ID)) Q:ID=""  d
    .s DateEnd=$p($g(^DHCCRMFUP(ID)),"^",4)
    .q:(DateEnd'=(Date-1))||(DateEnd="")
    .s qrrowid=$o(^DHCCRMQR(0,"QR_FUP_DR",ID,0))
    .i qrrowid'="" s followup="是"
    .e  s followup="否"
    q:(followup="") "^"
    s Result=followup
    q:(Result="否") Result_"^"
    i (ID'="")  d
    .s Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR","7||1",ID,0))
    .s Result=Result_"^"_$p($g(^DHCCRMQR(ID,"Detail",Sub)),"^",3)
    q Result_"^"
}

ClassMethod RegNoMask(RegNo)
{
    s length=+$G(^DHCCRMSetting("DHCCRM","RegNoLength"))
    i length=0 s length=10
    s ZeroStr=$E("00000000000000000000000000",1,length)
    s RegNo=$E(ZeroStr,1,length-$l(RegNo))_RegNo
    q RegNo
}

// 选择默认

Query SearchFURecord(fusrowid) As %Query(ROWSPEC = "sdrowid:%String,defaultval:%String")
{
}

ClassMethod SearchFURecordExecute(ByRef qHandle As %Binary, fusrowid) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    s SDSub=0
    f  s SDSub=$o(^DHCCRMFUS(fusrowid,"SD",SDSub)) q:SDSub=""  d
    .s SDSSub=0,defaultval=""
    .f  s SDSSub=$o(^DHCCRMFUS(fusrowid,"SD",SDSub,"SDS",SDSSub)) q:SDSSub=""  d
    ..s textval=$p(^DHCCRMFUS(fusrowid,"SD",SDSub,"SDS",SDSSub),"^",1)
    ..s default=$p(^DHCCRMFUS(fusrowid,"SD",SDSub,"SDS",SDSSub),"^",3)
    ..i default="Y" s defaultval=textval
    .s sdrowid=fusrowid_"||"_SDSub
    .Do OutputRow

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(sdrowid,defaultval)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchFURecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchFURecordExecute ]
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

ClassMethod SearchFURecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchFURecordExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCCRM.PatInfo).SaveFURecord()
ClassMethod SaveFURecord(paadm, fuprowid, qrrowid, furresult)
{
    s Job=$J
    k ^TempDHCCRM(Job,"FUSave")
    s InfoLength=$L(furresult,"$")
    s SQLCODE=0
    For i = 1:1:InfoLength 
    {
        s OneInfo=$p(furresult,"$",i)
        s DetailID=$p(OneInfo,"^",1)
        s DetailID=$p(DetailID,"||",1,2)
        s Result=$p(OneInfo,"^",2)
        s TemplateDesc=$p(OneInfo,"^",3)
        i $G(^TempDHCCRM(Job,"FUSave",DetailID,"Result"))="" d
        .s ^TempDHCCRM(Job,"FUSave",DetailID,"Result")=Result
        .s ^TempDHCCRM(Job,"FUSave",DetailID,"TemplateDesc")=TemplateDesc
        e  d
        .s ^TempDHCCRM(Job,"FUSave",DetailID,"Result")=$G(^TempDHCCRM(Job,"FUSave",DetailID,"Result"))_";"_Result
        .s ^TempDHCCRM(Job,"FUSave",DetailID,"TemplateDesc")=$G(^TempDHCCRM(Job,"FUSave",DetailID,"TemplateDesc"))_";"_TemplateDesc
    }
    TSTART
    i +qrrowid=0
    {
        s PLIST(2)="" //PlanID
        s PLIST(3)=paadm //PAADM
        s PLIST(4)="" //PAPMI
        s PLIST(5)="Hang"
        s PLIST(6)=+$H
        s PLIST(7)=$p($H,",",2)
        s PLIST(8)=%session.Get("LOGON.USERID") //User
        s PLIST(9)="" //Demo
        &SQL(Insert Into DHC_CRM_QRecord values :PLIST())
        i SQLCODE
        {
            TROLLBACK
            w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
        }
        s qrrowid=%ROWID
    }
    s DetailID=""
    f  s DetailID=$o(^TempDHCCRM(Job,"FUSave",DetailID)) q:(DetailID="")||(SQLCODE'=0)  d
    .k PLIST
    .s PLIST(3)=+DetailID
    .s PLIST(4)=DetailID
    .s PLIST(5)=$G(^TempDHCCRM(Job,"FUSave",DetailID,"Result"))
    .s PLIST(6)=$G(^TempDHCCRM(Job,"FUSave",DetailID,"TemplateDesc"))
    .s PLIST(7)=+$H
    .s PLIST(8)=$p($h,",",2)
    .s PLIST(9)=%session.Get("LOGON.USERID")
    .s PLIST(10)=fuprowid
    .s Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR",DetailID,qrrowid,0))
    .i Sub>0 d
    ..s QRDRowID=qrrowid_"||"_Sub
    ..&SQL(Update DHC_CRM_QRecordDetail values :PLIST() where QRD_RowId=:QRDRowID)
    .e  d
    ..s PLIST(0)=qrrowid
    ..&SQL(Insert Into DHC_CRM_QRecordDetail values :PLIST())
    i SQLCODE
    {
        TROLLBACK
        w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
    }
    TCOMMIT
    
    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":"_qrrowid_"}"
    
    q ""
}

ClassMethod SaveSound(savefile, telfup)
{
    s SQLCODE=0
    
    &sql(update DHC_CRM_FUPlan set FUP_RadioFile=:savefile where FUP_RowId=:telfup)

    q SQLCODE
}

ClassMethod GetSound(telfup)
{
    s ret=""
    &sql(select FUP_RadioFile into :ret from DHC_CRM_FUPlan where FUP_RowId=:telfup)
    q ret
}

ClassMethod SaveStartTime(telfup)
{
    s SQLCODE=0
    s NowDate=$p($h,",",2)
    &sql(update DHC_CRM_FUPlan set FUP_FURadioStartTime=:NowDate where FUP_RowId=:telfup)

    q SQLCODE
}

ClassMethod SaveEndTime(telfup)
{
    s SQLCODE=0
    s NowDate=$p($h,",",2)
    &sql(update DHC_CRM_FUPlan set FUP_FURadioEndTime=:NowDate where FUP_RowId=:telfup)

    q SQLCODE
}

ClassMethod GetRadioTime(telfup)
{
    s time=0
    s StartTime=0,EndTime=0
    &sql(select FUP_FURadioStartTime,FUP_FURadioEndTime into :StartTime,:EndTime from DHC_CRM_FUPlan where FUP_RowId=:telfup)
    s time=EndTime-StartTime
    q time
}

ClassMethod ISRelated(Code, fus)
{
    s RelateFlag=0
    s fusd=0
    f  s fusd=$o(^DHCCRMFUS(fus,"SD",fusd)) q:fusd=""  d
    .s fusds=0
    .f  s fusds=$o(^DHCCRMFUS(fus,"SD",fusd,"SDS",fusds)) q:fusds=""  d
    ..s fusdst=0
    ..s DefaltC=$p(^DHCCRMFUS(fus,"SD",fusd,"SDS",fusds),"^",3)
    ..s Relate=$p(^DHCCRMFUS(fus,"SD",fusd,"SDS",fusds),"^",6)
    ..;f  s fusdst=$o(^DHCCRMFUS(fus,"SD",fusd,"SDS",fusds,"SDST",fusdst)) q:fusdst=""  d
    ..;.s Relate=$p(^DHCCRMFUS(fus,"SD",fusd,"SDS",fusds,"SDST",fusdst),"^",1)
    ..i (Relate[Code)&&(DefaltC="N")  s RelateFlag=1
    q RelateFlag
}

ClassMethod GetRecord(FUPlanID) As %String
{
 s RecordID=""
 s RecordID=$o(^DHCCRMQR(0,"QR_FUP_DR",FUPlanID,0))
 Q RecordID
}

ClassMethod SetDetailGlobalBySubject(PlanID)
{
    
    s Job=$J
    k ^TMPDHCCRMQuestion(Job)
    
    s SID=$p(^DHCCRMFUP(PlanID),"^",2)
    s FUSName=$p(^DHCCRMFUS(SID),"^",2)
    s RecordID=..GetRecord(PlanID)
    s Sequence=0
    f  s Sequence=$o(^DHCCRMFUS(0,"SD_Sequence",SID,Sequence)) q:Sequence=""  d
    .s DID=0
    .f  s DID=$o(^DHCCRMFUS(0,"SD_Sequence",SID,Sequence,DID)) q:DID=""  d
    ..q:'$d(^DHCCRMFUS(SID,"SD",DID))
    ..s Active=$p(^DHCCRMFUS(SID,"SD",DID),"^",7)
    ..q:Active="N"
    ..s BeginDate=$p(^DHCCRMFUS(SID,"SD",DID),"^",8)
    ..q:(BeginDate'="")&&(BeginDate>+$H)
    ..s EndDate=$p(^DHCCRMFUS(SID,"SD",DID),"^",9)
    ..q:(EndDate'="")&&(EndDate<+$H)
    ..s ID=SID_"||"_DID
    ..s Code=$p(^DHCCRMFUS(SID,"SD",DID),"^",1)
    ..s Desc=$p(^DHCCRMFUS(SID,"SD",DID),"^",2)
    ..s Type=$p(^DHCCRMFUS(SID,"SD",DID),"^",3)
    ..q:((Type="S")&&($o(^DHCCRMFUS(SID,"SD",DID,"SDS",0))=""))
    ..s Unit=$p(^DHCCRMFUS(SID,"SD",DID),"^",4)
    ..s Explain=$p(^DHCCRMFUS(SID,"SD",DID),"^",5)
    ..s Sex=$p(^DHCCRMFUS(SID,"SD",DID),"^",6) //男M 女F 不限N
    ..s Required=$p(^DHCCRMFUS(SID,"SD",DID),"^",10)
    
    ..s ParentDr=$p(^DHCCRMFUS(SID,"SD",DID),"^",12)
    ..i +ParentDr=0 s ParentDr=1
    ..s ParentName=$p(^DHCCRMFUS(SID,"SD",DID),"^",13)
    ..s ElementNum=+$p(^DHCCRMFUS(SID,"SD",DID),"^",14)
    ..s ShowFlag=1
    ..s:..ISRelated(ID,SID) ShowFlag=0
    ..s PAADM=$p(^DHCCRMFUP(PlanID),"^",1)
    ..s PAPMI=$p(^PAADM(PAADM),"^",1)
    ..s SexDr=$p(^PAPER(PAPMI,"ALL"),"^",7)
    ..s SexCode=$p(^CT("SEX",SexDr),"^",1) //男1 女2 
    ..i SexCode="1" s SexCode="M"
    ..i SexCode="2" s SexCode="F"
    ..q:(Sex'="N")&&(Sex'=SexCode)
    ..s ^TMPDHCCRMQuestion(Job,"Subject",SID,ParentDr)=FUSName
    ..//                                                      1ID     2描述   3类型      4必选         5提示     6提示类型 7单位   8 性别 9关联外部代码  10显示列数      11 备注  12是否显示 13结果值
    ..s ^TMPDHCCRMQuestion(Job,"Detail",SID,ParentDr,Sequence,DID)=ID_"^"_Desc_"^"_Type_"^"_Required_"^"_""_"^"_""_"^"_Unit_"^"_Sex_"^"_""_"^"_ElementNum_"^"_""_"^"_ShowFlag_"^"
    ..d ..SetOptionGlobalByDetail(Job, SID, DID, RecordID, PlanID, ParentDr, Sequence)
    q Job
}

ClassMethod DetailIsChecked(SSID, RecordID, FUPRowId)
{
    s SID=+SSID
    s DID=$p(SSID,"||",2)
    s SSub=$p(SSID,"||",3)
    s Desc=$p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",1)
    s value=""
    i RecordID="" {
        q $p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",3)
        ;i RecordID="" s valuestr=..GetOldResult(FUPRowId,SID_"||"_DID),value=$p(valuestr,"^",1)  //q $p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",3)
    } else {
        s Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR",SID_"||"_DID,RecordID,0))
        q:Sub="" "N"
        s value=$p(^DHCCRMQR(RecordID,"Detail",Sub),"^",3)
    }

    q:value="" "N"
    s value=$p(value,"@")
    s value="$"_value_"$"
    s Desc="$"_Desc_"$"
    q:$L(value,Desc)>1 "Y"
    
    q "N"
}

ClassMethod GetBeiZhu(SSID, RecordID)
{
    
    s SID=+SSID
    s DID=$p(SSID,"||",2)
    s SSub=$p(SSID,"||",3)
    i RecordID="" q "" //$p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",3)
    s Desc=$p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",1)
    s Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR",SID_"||"_DID,RecordID,0))
    q:Sub="" "" //$p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",3)
    s value=$p(^DHCCRMQR(RecordID,"Detail",Sub),"^",3)
    s Template=$p(^DHCCRMQR(RecordID,"Detail",Sub),"^",4)
    s value=$p(value,"@")
    s tmpstr=$p(value,Desc,1)
    s num=$l(tmpstr,"$")
    q $p(Template,"$",num)
}

ClassMethod SetOptionGlobalByDetail(Job, SID, DID, RecordID, FUPRowId, ParentDr, DSequence)
{
    s TxtFlag=1
    s ResultFlag=0   //是否已填写答案标记  已填写答案时，默认值无效
    
    s Type=$p(^DHCCRMFUS(SID,"SD",DID),"^",3)
    
    s Sequence=0
    f  s Sequence=$o(^DHCCRMFUS(0,"SDS_Sequence",SID,DID,Sequence)) q:Sequence=""  d
    .s SSub=0
    .f  s SSub=$o(^DHCCRMFUS(0,"SDS_Sequence",SID,DID,Sequence,SSub)) q:SSub=""  d
    ..s SSID= SID_"||"_DID_"||"_SSub
    ..s TxtFlag=0
    ..s Desc=$p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",1)
    ..s Default=..DetailIsChecked(SSID,RecordID,FUPRowId)
    ..s DVlaue=..GetBeiZhu(SSID,RecordID)
    ..;i DVlaue'="" s DVlaue=$p(DVlaue,"@",2)
    ..s Unit=$p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",2)
    ..s AddDesc=$p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",5)
    ..s Realvalue=""
    ..i RecordID'=""  d
    ...s Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR",SID_"||"_DID,RecordID,0))
    ...q:Sub=""
    ...i ((Type="DT")||(Type="DN")) d
    ....s Default="Y"
    ....s value=$p(^DHCCRMQR(RecordID,"Detail",Sub),"^",3)
    ....s TemplateDesc=$p(^DHCCRMQR(RecordID,"Detail",Sub),"^",4)
    ....f TemIndex=1:1:$l(TemplateDesc,"$") d
    .....q:$p(TemplateDesc,"$",TemIndex)'=SSID
    .....s Realvalue=$p(value,"$",TemIndex)
    .....s ResultFlag=1
    ...e  d
    ....s value=$p(^DHCCRMQR(RecordID,"Detail",Sub),"^",3)
    ....s value=$p(value,"@")
    ....s value="$"_value_"$"
    ....s CSDesc="$"_Desc_"$"
    ....i $L(value,CSDesc)>1 d
    .....s Realvalue=$p(^DHCCRMQR(RecordID,"Detail",Sub),"^",3)
    .....s ResultFlag=1
    ..s LinkDetail=$p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",6)
    ..s ExclusiveDetail=$p(^DHCCRMFUS(SID,"SD",DID,"SDS",SSub),"^",7)
    ..   //                                                             1 描述            2 默认值    3 性别  4 结果          5 备注          6 关联问题ID    7 互斥问题ID  8 InputFlag   9 已填写答案标记
    ..s ^TMPDHCCRMQuestion(Job,"Option",SID,ParentDr,DSequence,Sequence,SSID)=Desc_"^"_Default_"^"_"N"_"^"_Realvalue_"^"_DVlaue_"^"_LinkDetail_"^"_ExclusiveDetail_"^"_AddDesc_"^"_ResultFlag_"^"_Unit

    i (TxtFlag=1)&&(RecordID'="") d
    .s Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR",SID_"||"_DID,RecordID,0))
    .q:Sub="" 
    .s TxtValue=$p(^DHCCRMQR(RecordID,"Detail",Sub),"^",3)
    .i TxtValue'="" d 
    ..s $P(^TMPDHCCRMQuestion(Job,"Detail",SID,ParentDr,DSequence,DID),"^",12)=1
    ..s $P(^TMPDHCCRMQuestion(Job,"Detail",SID,ParentDr,DSequence,DID),"^",13)=TxtValue
}

ClassMethod OutSurveyToWeb(Job, FuplanID, SubjectOrder, Flag = "0", SizeJSON = "")
{
    s QuesID=$p(^DHCCRMFUP(FuplanID),"^",2)
    s SubjectId=QuesID
    q:'$d(^TMPDHCCRMQuestion(Job,"Subject",QuesID,SubjectOrder))
    s SubjectDesc=$P(^TMPDHCCRMQuestion(Job,"Subject",QuesID,SubjectOrder),"^",1)
    s SubjectRemark=""
    s Title=SubjectDesc
    
    s SizeCss=""
    i SizeJSON'=""
    {
        s SizeObj={}.%FromJSON(SizeJSON)    
        i SizeObj.height'=""   s SizeCss=SizeCss_"height:"_SizeObj.height_";"
        i SizeObj.width'=""    s SizeCss=SizeCss_"width:"_SizeObj.width_";"
    }
    w "<div id='QuesSubjectPanel' class='hisui-panel' data-options='headerCls:""panel-header-gray"", iconCls:""icon-paper"",collapsible:false,' style='padding:10px 0px 10px 10px;"_SizeCss_" '"
    w " title='"_Title_"' >"

    d ..OutDetailToWeb(Job, QuesID, SubjectOrder,Flag)
    
    w "</div>"
    i Flag="0"
    {
        w "<div style='text-align:center' class='mt15'>"
        s PreOrder=$O(^TMPDHCCRMQuestion(Job,"Subject",QuesID,SubjectOrder),-1)
        s NextOrder=$O(^TMPDHCCRMQuestion(Job,"Subject",QuesID,SubjectOrder))
        i PreOrder'="" d
        .w "<a style='margin:0px 40px;width:110px;' id='PrePage' href='#' onclick='page_OnClick("_FuplanID_","_PreOrder_","_Job_ ","_SubjectOrder_ ",-1)'  data-options=""iconCls:'icon-w-arrow-left'"" class='hisui-linkbutton'>上一页</a>"
        i NextOrder'="" d
        .w "<a style='margin:0px 40px;width:110px;' id='NextPage' href='#' onclick='page_OnClick("_FuplanID_","_NextOrder_","_Job_ ","_SubjectOrder_",1)' data-options=""iconCls:'icon-w-arrow-right'"" class='hisui-linkbutton'>下一页</a>"
        e  d
        .w "<a style='margin:0px 40px;width:110px;' id='Save' href='#' onclick='page_OnClick("_FuplanID_","""_NextOrder_""","_Job_ ","_SubjectOrder_",2)' data-options=""iconCls:'icon-w-save'"" class='hisui-linkbutton'>保存</a>"
        w "</div>"
    }
}

ClassMethod OutDetailToWeb(Job, QuesID, Child, Flag = "0")
{

    s i=0
    
    s CurRemark=""
    s PFlag=0  ;备注标记
    s DetailOrder=""
    f  s DetailOrder=$O(^TMPDHCCRMQuestion(Job,"Detail",QuesID,Child,DetailOrder)) q:DetailOrder=""  d
    .s DetailSub=""
    .f  s DetailSub=$O(^TMPDHCCRMQuestion(Job,"Detail",QuesID,Child,DetailOrder,DetailSub)) q:DetailSub=""  d
    ..s DetailData=$G(^TMPDHCCRMQuestion(Job,"Detail",QuesID,Child,DetailOrder,DetailSub))
    ..s DetailRemark=$P(DetailData,"^",11)
    
    ..i (DetailRemark'="")&&(DetailRemark'=CurRemark) d
    ...w:PFlag=1 "</div>"
    ...s CurRemark=DetailRemark
    ...w "<div class='hisui-panel detail_remark' data-options='headerCls:""panel-header-card-gray""'  title='"_DetailRemark_"'>"
    ...s PFlag=1
    
    ..i (DetailRemark="")&&(CurRemark'="") d
    ...s CurRemark=""
    ...w "</div>"
    ...s PFlag=0 
    
    ..s i=i+1
    ..s Display="block"
    ..s ShowFlag=$P(DetailData,"^",12)
    ..s:ShowFlag=0 Display="none"
    ..s DetailId=$P(DetailData,"^",1)
    ..s DetailDesc=$P(DetailData,"^",2)
    ..s DetailType=$P(DetailData,"^",3)
    ..s Required=$P(DetailData,"^",4)
    ..s RequiredStr=""
    ..s:Required="Y" RequiredStr="data-options='required:true'"
    ..s DetailUnit=$P(DetailData,"^",7)
    ..s TextValue=$P(DetailData,"^",13)
    ..s ShowNum=$P(DetailData,"^",10)
    ..s LinkId=QuesID_"||"_Child_"||"_DetailSub
    ..s AreaText=TextValue
    ..s:TextValue'="" TextValue="value='"_TextValue_"'"
    
    ..w "<div style='margin-top:2px;' >"  ;每个问题外层DIV
    ..w "<table id='tab_"_DetailId_"' style='margin-top: 2px;display:"_Display_";'>"
    ..;第一行
    ..w "<tr>"
    ..w "<td style='text-align: left; font-weight: bold;  width: 800px;'>"
    ..w:Required="Y" "<label style='color:red'>*&nbsp;</label>"
    ..w DetailDesc_"</td>"
    ..w "<td style='width: 140px;'><span id='spn_"_DetailId_"' title='"_i_"' style='display:none; float: left;color: red;'>请选择相应答案</span>"
    ..w "<input type='hidden' id='queAnswerFlag_"_DetailId_"' name='queAnswerFlag' value='"_Required_"' style='width: 45px;'/>"
    ..w "<input type='hidden' id='detailType_"_DetailId_"' name='detailType' value='"_DetailType_"' style='width: 45px;'/>"
    ..w "</td></tr>"                                            
    ..;第二行
    ..w "<tr>"
    ..w "<td colspan='2'>"
    ..w "<table style='word-break:break-all; border: 0px solid red;width:100%'>"
    ..w "<tr style='height: 25px;'>" ;内容区域tr
    
    ..s ReadOnly=""
    ..s:Flag=1 ReadOnly="readonly"
    
    ..s Disabled=""
    ..s:Flag=1 Disabled="disabled"
    
    ..i DetailType="T"  d ;说明型
    ...w "<td style='padding-left: 10px;'><textarea rows='4' name='"_LinkId_"' style='width:100%' "_ReadOnly_" class='hisui-validatebox textbox' id='input_"_DetailId_"'"
    ...w " onblur='txt_onblur("""_DetailId_""");'>"_AreaText
    ...w "</textarea></td>"
    
    ..else  if DetailType="N"  d ;数值型 
    ...w "<td style='padding-left: 10px;'><input name='"_LinkId_"' class='hisui-numberbox textbox' data-options='min:0' "_RequiredStr_" "_Disabled_"  "_TextValue_" id='input_"_DetailId_"'"
    ...w " onblur='txt_onblur("""_DetailId_""");'"
    ...w "/><span style='margin-left:5px;'>"_DetailUnit_ "</span></td>"
    
    ..else  if DetailType="DA"  d ;日期型
    ...w "<td style='padding-left: 10px;'><input type='text' class='hisui-datetimebox textbox' "_Disabled_" " _TextValue_" name='"_LinkId_"' id='input_"_DetailId_"'"
    ...w " onblur='txt_onblur("""_DetailId_""");'"
    ...w "data-options='onChange:function() { onChangeDateTime("""_DetailId_""");}'"
    ...w "/></td>"
    
    
    
    ..else  d ;选择型 单选/多选    DT  多文本 需要增加下
    ...s RadioNum=0
    ...s CheckNum=0
    ...s TextNum=0
    ...s OPOrder=""
    ...f  s OPOrder=$O(^TMPDHCCRMQuestion(Job,"Option",QuesID,Child,DetailOrder,OPOrder)) q:OPOrder=""  d
    ....s OptionId=""
    ....f  s OptionId=$O(^TMPDHCCRMQuestion(Job,"Option",QuesID,Child,DetailOrder,OPOrder,OptionId)) q:OptionId=""  d
    .....s:DetailType="S" RadioNum=RadioNum+1
    .....s:DetailType="D" CheckNum=CheckNum+1
    .....s:DetailType="DT" TextNum=TextNum+1
    .....s:DetailType="DN" TextNum=TextNum+1
    .....s OptionData=$G(^TMPDHCCRMQuestion(Job,"Option",QuesID,Child,DetailOrder,OPOrder,OptionId))
    .....s OptionDesc=$P(OptionData,"^",1)
    .....s OptionDefalVal=$P(OptionData,"^",2)
    .....s OptionResult=$P(OptionData,"^",4)
    .....s OptionNote=$P(OptionData,"^",5)
    .....s LinkDetailId=$P(OptionData,"^",6)
    .....s ExclusiveDetailId=$P(OptionData,"^",7)
    .....s InputFlag=$P(OptionData,"^",8)
    .....s ResultFlag=$P(OptionData,"^",9)
    .....s Unit=$P(OptionData,"^",10)
    
    .....i ((DetailType="DT")||(DetailType="DN")) d  // 多文本
    ......i 1=1 d //OptionDefalVal="Y" d
    .......w "<td><div style='border: 0px solid red; margin-left: 5px;'>"
    .......w "<label for='"_LinkId_"~"_OptionId_"~"_OptionDesc_"~'>"_OptionDesc_"&emsp;</label>"
    .......s inputClass="hisui-validatebox"
    .......s:DetailType="DN" inputClass="hisui-numberbox textbox"
    .......w "<input type='text' class='"_inputClass_"' "_Disabled_" name='text_"_DetailId_"' id='"_LinkId_"~"_OptionId_"~"_OptionDesc_"~' value='"_OptionResult_"'"
    .......w " onblur='mtxts_onblur("""_DetailId_""","""_LinkId_"~"_OptionId_"~"_OptionDesc_"~"");'/>"
    .......w "<span style='margin-left:5px;'>"_Unit_ "</span></div></td>"
    
    .....e  d
    ......s Checked=""
    ......i ((OptionResult'="")&&(OptionResult'="N"))||((OptionDefalVal="Y")&&(ResultFlag=0)) d
    .......s:DetailType="S" Checked=",checked:true"
    .......s:DetailType="D" Checked="Checked='Checked'"
    
    ......w "<td><div style='border: 0px solid red; padding-left: 10px;'>"
    ......;w:DetailType'="D" "<label style='cursor:pointer;'>"
    ......i DetailType="S"  d ;单选型
    .......w "<input type='radio' class='hisui-radio' label='"_OptionDesc_"' "_Disabled_" name='rad_"_DetailId_"' id='"_LinkId_"~"_OptionId_"~"_OptionDesc_"~'" 
    .......w " value='"_LinkId_"~"_OptionId_"~"_OptionDesc_"~'"
    .......w "data-options='onCheckChange:function(event,value){radQuestion_onclick(this, """_LinkDetailId_""", """_ExclusiveDetailId_""", """_DetailId_""");} "_Checked_ " ' "
    .......w " />"
    .......i InputFlag="Y"  d ;允许备注
    ........w "<input type='text' class='hisui-validatebox textbox' "_Disabled_" id='optionNote_"_LinkId_"~"_OptionId_"' name='resultNote' value='"_OptionNote_"'style='width: 70px;margin-left:10px;"
    ........i Checked'=""  w "display:inline;'"
    ........e  w "display:none;'"
    ........w "/>"
    
    ......e  i DetailType="D"  d ;多选型
    .......w "<input type='checkbox' class='hisui-checkbox' "_Disabled_" name='chk_"_DetailId_"' id='"_LinkId_"~"_OptionId_"~"_OptionDesc_"~'" 
    .......w " value='"_LinkId_"~"_OptionId_"~"_OptionDesc_"~'"
    .......w "data-options='onCheckChange:function(event,value){chkQustion_onclick(this,"""_DetailId_""");}'"
    .......w Checked_" label='"_OptionDesc_"'/>"
    .......i InputFlag="Y"  d ;允许备注
    ........w "<input type='text' class='hisui-validatebox textbox' "_Disabled_" id='optionNote_"_LinkId_"~"_OptionId_"' name='resultNote' value='"_OptionNote_"'style='width: 70px;margin-left:10px;"
    ........i Checked'=""  w "display:inline;'"
    ........e  w "display:none;'"
    ........w "/>"
    ........w Unit
    ......i Checked'=""  d   
    .......w "<script type='text/javascript'>"
    .......w "addQueAnswerFlagValue("""_LinkId_"~"_OptionId_"~"_OptionDesc_"~"","""_DetailId_""");"
    .......w "</script>"
    ......w "<span style='margin-left:5px;'>"_Unit_"</span>"
    ......w "</div></td>"
    .....i +ShowNum=0 s ShowNum=1
    .....i (((RadioNum#ShowNum=0)&&(RadioNum'=0))||((CheckNum#ShowNum=0)&&(CheckNum'=0))||((TextNum#ShowNum=0)&&(TextNum'=0)))&&($O(^TMPDHCCRMQuestion(Job,"Option",QuesID,Child,DetailOrder,OPOrder))'="") d
    ......w "</tr><tr height='25px'>"
    .....e  i (((RadioNum#ShowNum'=0))||((CheckNum#ShowNum'=0)))&&($O(^TMPDHCCRMQuestion(Job,"Option",QuesID,Child,DetailOrder,OPOrder))="") d  
    ......s tdNum=0
    ......s:DetailType="S" tdNum=5-(RadioNum#ShowNum)
    ......s:DetailType="D" tdNum=5-(CheckNum#ShowNum)
    ......s:DetailType="DT" tdNum=5-(TextNum#ShowNum)
    ......s:DetailType="DN" tdNum=5-(TextNum#ShowNum)
    ......f k=1:1:tdNum  d
    .......w "<td><div style='border: 0px solid red; margin-left: 5px;'></div></td>"  ;补齐
    
    ..w "</tr>"  ;内容区域tr
    ..w "</table>"  
    ..w "</td>"
    
    ..w "</tr>"  ;第二行的tr                                                            
    ..w "</table>"                                                          
    ..w "</td>"
    ..w "</tr>"
    ..w "</table>"
    ..W "</DIV>"
    w:PFlag=1 "</div>"
}

/// w ##class(web.DHCCRM.PatInfo).SaveSurveyResult(9268,22)
ClassMethod SaveSurveyResult(Job, QuesID)
{
    q:'$D(^TMPDHCCRMQuestion(Job,"Result")) "-1^进程无效"
    q:(QuesID="")||('$D(^TMPDHCCRMQuestion(Job,"Result",QuesID))) "-2^问题ID无效"
    
    s ResultList=""
    s SubOrder=""
    f  s SubOrder=$O(^TMPDHCCRMQuestion(Job,"Result",QuesID,SubOrder))  q:SubOrder=""  d
    .s ResultStr=$G(^TMPDHCCRMQuestion(Job,"Result",QuesID,SubOrder))
    .q:ResultStr=""
    .s:ResultList'="" ResultList=ResultList_"@"_ResultStr
    .s:ResultList="" ResultList=ResultStr
    q:ResultList="" "-4^结果集合为空"
    
    s PlanID=QuesID
    s OldID=$o(^DHCCRMQR(0,"QR_FUP_DR",QuesID,0))
    s PAADM=$p(^DHCCRMFUP(PlanID),"^",1)
    s PAPMI=$p(^PAADM(PAADM),"^",1)
    s User=%session.Get("LOGON.USERID")
    
    s SQLCODE=0
    s InfoLength=$L(ResultList,"@")
    
    For i = 1:1:InfoLength 
    {
        s OneInfo=$p(ResultList,"@",i)
        s DetailID=$p(OneInfo,"~",1)
        s DetailID=$p(DetailID,"||",1)_"||"_$p(DetailID,"||",3)
        s Result=$p(OneInfo,"~",3)
        s TemplateDesc=$p(OneInfo,"~",4)
        s Type=$p(^DHCCRMFUS(+DetailID,"SD",$p(DetailID,"||",2)),"^",3)
        s Sort=$p(^DHCCRMFUS(+DetailID,"SD",$p(DetailID,"||",2)),"^",11)
        i Sort="" s Sort="999999"
        i $G(^TMPDHCCRMQuestion(Job,"FUSave",Sort,DetailID,"Result"))="" d
        .s ^TMPDHCCRMQuestion(Job,"FUSave",Sort,DetailID,"Result")=Result
        .i ((Type="DT")||(Type="DN")) d
        ..s ^TMPDHCCRMQuestion(Job,"FUSave",Sort,DetailID,"TemplateDesc")=$p(OneInfo,"~",2)
        .e  d
        ..s ^TMPDHCCRMQuestion(Job,"FUSave",Sort,DetailID,"TemplateDesc")=TemplateDesc
        e  d
        .s ^TMPDHCCRMQuestion(Job,"FUSave",Sort,DetailID,"Result")=$G(^TMPDHCCRMQuestion(Job,"FUSave",Sort,DetailID,"Result"))_"$"_Result
        .i ((Type="DT")||(Type="DN")) d
        ..s ^TMPDHCCRMQuestion(Job,"FUSave",Sort,DetailID,"TemplateDesc")=$G(^TMPDHCCRMQuestion(Job,"FUSave",Sort,DetailID,"TemplateDesc"))_"$"_$p(OneInfo,"~",2)
        .e  d
        ..s ^TMPDHCCRMQuestion(Job,"FUSave",Sort,DetailID,"TemplateDesc")=$G(^TMPDHCCRMQuestion(Job,"FUSave",Sort,DetailID,"TemplateDesc"))_"$"_TemplateDesc
    }
    
    TSTART
    i +OldID=0
    {
        s PLIST(2)=PlanID
        s PLIST(3)=PAADM //PAADM
        s PLIST(4)=PAPMI //PAPMI
        s PLIST(5)="Hang"
        s PLIST(6)=+$H
        s PLIST(7)=$p($H,",",2)
        s PLIST(8)=User //User
        s PLIST(9)="" //Demo
        &SQL(Insert Into DHC_CRM_QRecord values :PLIST())
        i SQLCODE
        {
            TROLLBACK
            q SQLCODE_"main"
        }
        s OldID=%ROWID
    }
    
    s Sort=0
    f  s Sort=$o(^TMPDHCCRMQuestion(Job,"FUSave",Sort)) q:(Sort="")||(SQLCODE'=0)  d 
    .s DetailID=""
    .f  s DetailID=$o(^TMPDHCCRMQuestion(Job,"FUSave",Sort,DetailID)) q:(DetailID="")||(SQLCODE'=0)  d
    ..k PLIST
    ..s PLIST(3)=+DetailID
    ..s PLIST(4)=DetailID
    ..s PLIST(5)=$G(^TMPDHCCRMQuestion(Job,"FUSave",Sort,DetailID,"Result"))
    ..s PLIST(6)=$G(^TMPDHCCRMQuestion(Job,"FUSave",Sort,DetailID,"TemplateDesc"))
    ..s PLIST(7)=+$H
    ..s PLIST(8)=$p($h,",",2)
    ..s PLIST(9)=User
    ..s PLIST(10)=PlanID
    ..s Sub=$o(^DHCCRMQR(0,"QRD_SubjectDetail_DR",DetailID,OldID,0))
    ..i Sub>0 d
    ...s QRDRowID=OldID_"||"_Sub
    ...&SQL(Update DHC_CRM_QRecordDetail values :PLIST() where QRD_RowId=:QRDRowID)
    ..e  d
    ...s PLIST(0)=OldID
    ...&SQL(Insert Into DHC_CRM_QRecordDetail values :PLIST())
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE_"Detail^"_OldID
    }
    TCOMMIT
    
    
   
    k ^TMPDHCCRMQuestion(Job)
    q SQLCODE
}

ClassMethod SetCurResultGlobal(Job, QuesID, SubjectOrder, ResulList)
{
    s ^TMPDHCCRMQuestion(Job,"Result",QuesID,SubjectOrder)=ResulList
    s Delimter="~"
    s RowDel="@"
    s Len=$l(ResulList,RowDel)
    q:ResulList="" 0
    s LinkList=""  //需要修改答案标记的问题
    f i=1:1:Len  d
    .s StrResult=$p(ResulList,RowDel,i)
    .s LinkId=$p(StrResult,Delimter,1)
    .s OptionId=$p(StrResult,Delimter,2)
    .s Result=$p(StrResult,Delimter,3)
    .s ResultNote=$p(StrResult,Delimter,4)
    .i OptionId'=""  d
    ..s OptionOrder=$p(^DHCCRMFUS(+OptionId,"SD",$p(OptionId,"||",2),"SDS",$p(OptionId,"||",3)),"^",4)
    ..s $P(^TMPDHCCRMQuestion(Job,"Option",+LinkId,$P(LinkId,"||",2),$P(LinkId,"||",3),OptionOrder,OptionId),"^",4)=Result
    ..
    .e   d
    ..s $P(^TMPDHCCRMQuestion(Job,"Detail",+LinkId,$P(LinkId,"||",2),$P(LinkId,"||",3)),"^",13)=Result
    

    q 0
}

/// w ##class(web.DHCCRM.PatInfo).GetChildQuestion(4)
/// return:子问卷的计划id
ClassMethod GetChildQuestion(fupid)
{
    q:fupid="" ""
    s Job=$J
    k ^TMPDHCCRMQuestion(Job)
    s subject=$p(^DHCCRMFUP(fupid),"^",2)
    s mLevel=$p(^DHCCRMFUS(subject),"^",8)
    i mLevel="" s mLevel=1
    s paadm=$p(^DHCCRMFUP(fupid),"^",1)
    s fupdate=$p(^DHCCRMFUP(fupid),"^",3)
    s childsubject=""
    s RowId=0
    f  s RowId=$o(^DHCCRMFUS(RowId)) q:RowId=""  d
    .s subData=$g(^DHCCRMFUS(RowId))
    .s Active=$p(subData,"^",7) 
    .q:Active'="Y"
    .s ParSub=$p(subData,"^",9)  // 父层
    .q:(subject'=ParSub)&&(ParSub'="")
    .q:(subject'=RowId)&&(ParSub="")
    .s Read="",Write=""
    .s fusgroup=""
    .f  s fusgroup=$o(^User.DHCCRMFUSGroupI("SGSubjectIndex",RowId,fusgroup)) q:fusgroup=""  d
    ..s Group=$lg(^User.DHCCRMFUSGroupD(fusgroup),3)
    ..q:Group'=%session.Get("LOGON.GROUPID")
    ..s Read=$lg(^User.DHCCRMFUSGroupD(fusgroup),4)
    ..s Write=$lg(^User.DHCCRMFUSGroupD(fusgroup),5)
    .q:Read'="Y" //不可读
    .s Code=$p(subData,"^",1)
    .s Desc=$p(subData,"^",2)
    .s Level=$p(subData,"^",8)
    .i Level="" s Level=1
    .
    .s ^TMPDHCCRMQuestion(Job,Level)=RowId_"^"_Write
    
    s childfupstr=""
    s iLevel=0
    f  s iLevel=$o(^TMPDHCCRMQuestion(Job,iLevel)) q:iLevel=""  d
    .s ichildsub=$p($g(^TMPDHCCRMQuestion(Job,iLevel)),"^",1)
    .q:ichildsub=""
    .s childfup=""
    .f  s childfup=$o(^DHCCRMFUP(0,"FUP_PAADMSubject_DR",paadm,ichildsub,childfup)) q:childfup=""  d
    ..s childfupdate=$p(^DHCCRMFUP(childfup),"^",3)
    ..q:childfupdate'=fupdate
    ..s iWrite=$p($g(^TMPDHCCRMQuestion(Job,iLevel)),"^",2)
    ..i childfupstr="" s childfupstr=childfup_"@"_iLevel_"@"_iWrite
    ..e  s childfupstr=childfupstr_"^"_childfup_"@"_iLevel_"@"_iWrite
    i childfupstr="" s childfupstr=fupid_"@"_mLevel
    q childfupstr
}

}
