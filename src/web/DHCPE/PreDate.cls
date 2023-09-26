/// 选取预约日期
Class web.DHCPE.PreDate Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod OutMainHISUI(Month As %String = "", LocID As %String = "", PreIADMID As %String = "", ExpStr As %String = "")
{
    i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    i Month="" d
    .s Month=+$H
    e  d
    .s Month=##class(websys.Conversions).DateHtmlToLogical(Month)
    s DateStr=$zd(Month,3)
    s DateStr=$E(DateStr,0,8)
    s StartDateStr=DateStr_"01"
    s StartDate=$zdh(StartDateStr,3)
    s EndDate=StartDate+32
    s DateStr=$zd(EndDate,3)
    s DateStr=$E(DateStr,0,8)
    s EndDateStr=DateStr_"01"
    s EndDate=$zdh(EndDateStr,3)
    s EndDate=EndDate-1
    w "<TABLE class=PreManager id='PreManager' height=100% width=100% border=0 cellspacing='0' cellpadding='0' style='white-space:normal; word-break:break-all;'>"
    w "<tr class='datagrid-header' headerCls='panel-header-gray' style='width:26px; height:30px; margin-top: 0px;'>"
    w "<td>周一</td>"
    w "<td>周二</td>" 
    w "<td>周三</td>"
    w "<td>周四</td>"
    w "<td>周五</td>" 
    w "<td>周六</td>"
    w "<td>周日</td>"     
    w "</tr>"
    d ClearInfo
    f Date=StartDate:1:EndDate
    {   
        s Week=$ZD(Date,10)
        i Week=0 s Week=7
        s DateStr=##class(websys.Conversions).DateLogicalToHtml(Date)
        s Flag=1
        s PLIST(Week)=DateStr
        w "<tr>"
        i Week=7 d
        .w ..OutLinkHISUI(PLIST(1),LocID,PreIADMID,ExpStr)
        .w ..OutLinkHISUI(PLIST(2),LocID,PreIADMID,ExpStr)
        .w ..OutLinkHISUI(PLIST(3),LocID,PreIADMID,ExpStr)
        .w ..OutLinkHISUI(PLIST(4),LocID,PreIADMID,ExpStr)
        .w ..OutLinkHISUI(PLIST(5),LocID,PreIADMID,ExpStr)
        .w ..OutLinkHISUI(PLIST(6),LocID,PreIADMID,ExpStr)
        .w ..OutLinkHISUI(PLIST(7),LocID,PreIADMID,ExpStr)  
        .d ClearInfo
        w "</tr>"   
        
    }
    if Flag=1 d
        .w ..OutLinkHISUI(PLIST(1),LocID,PreIADMID,ExpStr)
        .w ..OutLinkHISUI(PLIST(2),LocID,PreIADMID,ExpStr)
        .w ..OutLinkHISUI(PLIST(3),LocID,PreIADMID,ExpStr)
        .w ..OutLinkHISUI(PLIST(4),LocID,PreIADMID,ExpStr)
        .w ..OutLinkHISUI(PLIST(5),LocID,PreIADMID,ExpStr)
        .w ..OutLinkHISUI(PLIST(6),LocID,PreIADMID,ExpStr)
        .w ..OutLinkHISUI(PLIST(7),LocID,PreIADMID,ExpStr)
ClearInfo
    s Flag=0
    s (PLIST(1),PLIST(2),PLIST(3),PLIST(4),PLIST(5),PLIST(6),PLIST(7))=""
    q
}

ClassMethod OutLinkHISUI(DateStr As %String = "", LocID As %String = "", PreIADMID As %String = "", ExpStr As %String = "")
{
    i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
    i DateStr=""{
         q "<td></td>"
        
    }

    s ret=""
    s UserFlag=0
    s Date=##class(websys.Conversions).DateHtmlToLogical(DateStr)
    s IDDate=##class(websys.Conversions).DateLogicalToHtml(Date)
    s Str=DateStr
    i Date<$H
    {
        s Str=DateStr_"<br><font color=red>不可用</font>"
        i Str["不可用" s UserFlag=1
        e  s UserFlag=0

        s ret="<td valign=top ondblclick='SetPreDate(this)' id='0^"_IDDate_"^"_UserFlag_"'><br>"_Str_"</td>"
        q ret
    }
    i PreIADMID'="" d
    .s PreGADM=$P(^DHCPEPreIADM(PreIADMID),"^",2)
    .s PIBI=$P(^DHCPEPreIADM(PreIADMID),"^",1)
    .s CurSex=$P(^DHCPEPreIBI(PIBI),"^",3)
    .s CurVIP=$P(^DHCPEPreIADM(PreIADMID),"^",18)
    e  d
    .s PreGADM=$P(ExpStr,"^",3)
    .s CurSex=$P(ExpStr,"^",1)
    .s CurVIP=$P(ExpStr,"^",2)
    //s:CurVIP="" CurVIP=$G(^DHCPEVIPLevel("VIPapprove"))
    //s LevelDesc=$P(^DHCPEVIPLevel("VIP",CurVIP),"^",2)
    s:CurVIP="" CurVIP=##class(web.DHCPE.CT.VIPLevel).GetDefaultVIP(LocID)
    s LevelDesc=$lg($g(^CT.PE.VIPLevelD(CurVIP)),3) 
    
    s HPosition=6
    s Position=12  ;女
    //s:CurSex=$P($G(^DHCPESetting("DHCPE","DefPatientType")),"^",3) Position=11
   // s:CurSex=$P($G(^DHCPESetting("DHCPE","DefPatientType")),"^",3) HPosition=5
    s:CurSex=$P($G(^DHCPESetting("DHCPE","DefPatientType",LocID )),"^",3) Position=11
	s:CurSex=$P($G(^DHCPESetting("DHCPE","DefPatientType",LocID )),"^",3) HPosition=5

    s PreMID=""
    s PreNum=0
    i PreGADM'="" d ;团队的
    .s LastHomeID=##class(web.DHCPE.PreHome).GetLastHomeIDByGADM(PreGADM)
    .i LastHomeID'="" d
    ..s PreType="O"
    ..s LastHomeDate=$LG(^User.DHCPEPreHomeInfoD(LastHomeID),10)
    ..i LastHomeDate<Date d  ;过期主场
    ...s PreMID=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,CurVIP,"O",""))
    ..e  d  ;当天的主场人数
    ...s PreType="H"
    ...s HomeID=##class(web.DHCPE.PreHome).GetHomeIDByGADM(PreGADM,Date)
    ...i HomeID'="" d
    ....s PreNum=$LG(^User.DHCPEPreHomeInfoD(HomeID),HPosition)
    .e  d  ;普通团体
    ..s PreType="G"
    ..s PreMID=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,CurVIP,"G",""))
    e  d ;个人
    .s PreType="I"
    .s PreMID=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,CurVIP,"I",""))
    i PreMID'="" d
    .s PreNum=$LG(^User.DHCPEPreManagerD(PreMID),Position)
   	
   	i PreNum="" s PreNum=0
    s HadPreNum=0
    
    s AdmTime=""
    f  s AdmTime=$o(^DHCPEIADM(0,"AdmDateTime",Date,AdmTime)) q:AdmTime=""  d
    .s AdmID=""
    .f  s AdmID=$O(^DHCPEIADM(0,"AdmDateTime",Date,AdmTime,AdmID)) q:AdmID=""  d
    ..s Status=$P($g(^DHCPEIADM(AdmID)),"^",8)
    ..q:(Status'="ARRIVED")&&(Status'="REGISTERED")
    ..s PreADMID=$P(^DHCPEIADM(AdmID),"^",4)
    ..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PreADMID)
    ..q:LocFlag="1"
    ..s GADMID=$P($g(^DHCPEPreIADM(PreADMID)),"^",2)
    ..s LastHomeID=##class(web.DHCPE.PreHome).GetLastHomeIDByGADM(GADMID)
    ..q:(PreType="I")&&(GADMID'="")
    ..q:((PreType="O")||(PreType="G"))&&(GADMID="") ;过期主场、普通主场、非团体人员退出
    ..q:(PreType="H")&&(GADMID'=PreGADM)  ;主场的，非本团体的退出
    ..q:(PreType="G")&&(LastHomeID'="") ;普通团体，设置过主场的退出
    ..s QFlag=0
    ..i PreType="O" d
    ...s LastHomeDate=$LG(^User.DHCPEPreHomeInfoD(LastHomeID),10)
    ...i (LastHomeDate+1)>Date d
    ...s QFlag=1
    ..q:QFlag=1
    ..s PIBIID=$P($g(^DHCPEPreIADM(PreADMID)),"^",1)
    ..s Sex=$P($g(^DHCPEPreIBI(PIBIID)),"^",3)
    ..q:Sex'=CurSex
    ..s VIPLevel=$P($g(^DHCPEPreIADM(PreADMID)),"^",18)
    ..;i VIPLevel="" s VIPLevel=$G(^DHCPEVIPLevel("VIPapprove"))
    ..i VIPLevel="" s VIPLevel=##class(web.DHCPE.CT.VIPLevel).GetDefaultVIP(LocID)
    ..q:VIPLevel'=CurVIP
    ..s HadPreNum=HadPreNum+1
    
    i (HadPreNum+1)>PreNum d
    .s Str=DateStr_"<br><font color=red>不可用</font>"_"-"_PreNum_"-"_HadPreNum
    .i Str["不可用" s UserFlag=1
    .e  s UserFlag=0
    .s ret="<td valign=top ondblclick='SetPreDate(this)' id='0^"_IDDate_"^"_UserFlag_"'><br>"_Str
    
    e  d
    .s Str=DateStr_"<br><font color=#017bce>可用</font>"_"-"_PreNum_"-"_HadPreNum
    .i Str["不可用" s UserFlag=1
    .e  s UserFlag=0
    .s ret="<td valign=top ondblclick='SetPreDate(this)' id='1^"_IDDate_"^"_UserFlag_"'><br>"_Str
    
    i PreMID'=""
    {  
    s Sub=0,RealPreTime=""
    f  s Sub=$O(^User.DHCPEPreManagerD(PreMID,"PMTimeChild",Sub)) q:Sub=""  d
    .s ID=PreMID_"||"_Sub
    .s ListInfo=^User.DHCPEPreManagerD(PreMID,"PMTimeChild",Sub)
    .s StartTime=$LG(ListInfo,2)
    .s EndTime=$LG(ListInfo,3)
    .s HadPreTimeNum=..GetPreTimeNum(Date,StartTime,EndTime,CurSex,CurVIP,PreType,PreGADM)
    .s RealPreTime=StartTime+HadPreTimeNum
    .s StartTime=$zt(StartTime,2)
    .s EndTime=$zt(EndTime,2)
    .s PreTimeNum=$LG(ListInfo,HPosition)
    .i (PreTimeNum-HadPreTimeNum)>=1 d
    ..
    ..s ret=ret_"<div><input class='hisui-radio' type='radio' label='"_StartTime_"-"_EndTime_"' name='PreTime' value="_RealPreTime_"></div>"
    }
    s ret=ret_"</td>"
    q ret
}

ClassMethod GetPreTimeNum(nDate, nStartTime, nEndTime, CurSex, CurVIP, PreType, PreGADM)
{
    
    s nHadPreTimeNum=0
    f AdmTime=nStartTime:1:nEndTime d
    .s AdmID=""
    .f  s AdmID=$O(^DHCPEIADM(0,"AdmDateTime",nDate,AdmTime,AdmID)) q:AdmID=""  d
    ..s Status=$P($g(^DHCPEIADM(AdmID)),"^",8)
    ..q:(Status'="ARRIVED")&&(Status'="REGISTERED")
    ..s PreADMID=$P($g(^DHCPEIADM(AdmID)),"^",4)
    ..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PreADMID)
    ..q:LocFlag="1"
    ..s GADMID=$P($g(^DHCPEPreIADM(PreADMID)),"^",2)
    ..s LastHomeID=##class(web.DHCPE.PreHome).GetLastHomeIDByGADM(GADMID)
    ..q:(PreType="I")&&(GADMID'="")
    ..q:((PreType="O")||(PreType="G"))&&(GADMID="") ;过期主场、普通主场、非团体人员退出
    ..q:(PreType="H")&&(GADMID'=PreGADM)  ;主场的，非本团体的退出
    ..q:(PreType="G")&&(LastHomeID'="") ;普通团体，设置过主场的退出
    ..s QFlag=0
    ..i PreType="O" d
    ...s LastHomeDate=$LG(^User.DHCPEPreHomeInfoD(LastHomeID),10)
    ...i (LastHomeDate+1)>nDate d
    ...s QFlag=1
    ..q:QFlag=1
    ..s PIBIID=$P($g(^DHCPEPreIADM(PreADMID)),"^",1)
    ..s Sex=$P($g(^DHCPEPreIBI(PIBIID)),"^",3)
    ..q:Sex'=CurSex
    ..s LocID=$p($g(^DHCPEPreIADM(PreADMID)),"^",26)
    ..s VIPLevel=$P($g(^DHCPEPreIADM(PreADMID)),"^",18)
    ..;i VIPLevel="" s VIPLevel=$G(^DHCPEVIPLevel("VIPapprove"))
    ..i VIPLevel="" s VIPLevel=##class(web.DHCPE.CT.VIPLevel).GetDefaultVIP(LocID)
    ..q:VIPLevel'=CurVIP
    ..s nHadPreTimeNum=nHadPreTimeNum+1
    q nHadPreTimeNum
}

Query FindPreDate(Month As %String = "", PreIADMID As %String = "") As %Query(ROWSPEC = "TZ1:%String,TZ2:%String,TZ3:%String,TZ4:%String,TZ5:%String,TZ6:%String,TZ7:%String")
{
}

ClassMethod FindPreDateExecute(ByRef qHandle As %Binary, Month As %String = "", PreIADMID As %String = "") As %Status
{
    ;d ##class(%ResultSet).RunQuery("web.DHCPE.PreManager","FindPreDate",62607)
    Set repid=$I(^CacheTemp)
    s ind=1
    i Month="" d
    .s Month=+$H
    e  d
    .s Month=##class(websys.Conversions).DateHtmlToLogical(Month)
    s DateStr=##class(websys.Conversions).DateLogicalToHtml(Month)
    s DateStr=$E(DateStr,0,8)
    s StartDateStr=DateStr_"01"
    s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDateStr)
    s EndDate=StartDate+32
    s DateStr=##class(websys.Conversions).DateLogicalToHtml(EndDate)
    s DateStr=$E(DateStr,0,8)
    s EndDateStr=DateStr_"01"
    s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDateStr)
    s EndDate=EndDate-1
    d ClearInfo
    f Date=StartDate:1:EndDate
    {   
        s Week=$ZD(Date,10)
        i Week=0 s Week=7
        s DateStr=##class(websys.Conversions).DateLogicalToHtml(Date)
        s Flag=1
        s PLIST(Week)=DateStr
        i Week=7 d
        .d FindAreaBuild
        .d ClearInfo
    }
    d:Flag=1 FindAreaBuild
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
ClearInfo
    s Flag=0
    s (PLIST(1),PLIST(2),PLIST(3),PLIST(4),PLIST(5),PLIST(6),PLIST(7))=""
    q
FindAreaBuild      
    set Data=$lb(PLIST(1),PLIST(2),PLIST(3),PLIST(4),PLIST(5),PLIST(6),PLIST(7))
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod FindPreDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPreDateExecute ]
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

ClassMethod FindPreDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPreDateExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(web.DHCPE.PreDate).OutLink("2014-12-19","53")
ClassMethod OutLink(DateStr, LocID, PreIADMID, ExpStr As %String = "")
{
    i DateStr=""{
         w ""
         q
    }
    s Date=##class(websys.Conversions).DateHtmlToLogical(DateStr)
    s IDDate=##class(websys.Conversions).DateLogicalToHtml(Date)
    s Str=DateStr
    i Date<$H
    {
        s Str=DateStr_"<br><font color=red>不可用</font>"
        w "<button type='button' onclick=SetPreDate(this) id='0^"_IDDate_"'>"_Str_"</button>"
        q
    }
    i PreIADMID'="" d
    .s PreGADM=$P(^DHCPEPreIADM(PreIADMID),"^",2)
    .s PIBI=$P(^DHCPEPreIADM(PreIADMID),"^",1)
    .s CurSex=$P(^DHCPEPreIBI(PIBI),"^",3)
    .s CurVIP=$P(^DHCPEPreIADM(PreIADMID),"^",18)
    e  d
    .s PreGADM=""
    .s CurSex=$P(ExpStr,"^",1)
    .s CurVIP=$P(ExpStr,"^",2)
    s:CurVIP="" CurVIP=$G(^DHCPEVIPLevel("VIPapprove"))
    s LevelDesc=$P(^DHCPEVIPLevel("VIP",CurVIP),"^",2)
    s HPosition=6
    s Position=12  ;女
    //s:CurSex=$P($G(^DHCPESetting("DHCPE","DefPatientType")),"^",4) Position=11
    //s:CurSex=$P($G(^DHCPESetting("DHCPE","DefPatientType")),"^",4) HPosition=5
    s:CurSex=$P($G(^DHCPESetting("DHCPE","DefPatientType",LocID)),"^",4) Position=11
	s:CurSex=$P($G(^DHCPESetting("DHCPE","DefPatientType",LocID)),"^",4) HPosition=5

    s PreMID=""
    s PreNum=0
    i PreGADM'="" d ;团队的
    .s LastHomeID=##class(web.DHCPE.PreHome).GetLastHomeIDByGADM(PreGADM)
    .i LastHomeID'="" d
    ..s PreType="O"
    ..s LastHomeDate=$LG(^User.DHCPEPreHomeInfoD(LastHomeID),10)
    ..i LastHomeDate<Date d  ;过期主场
    ...s PreMID=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,CurVIP,"O",""))
    ..e  d  ;当天的主场人数
    ...s PreType="H"
    ...s HomeID=##class(web.DHCPE.PreHome).GetHomeIDByGADM(PreGADM,Date)
    ...i HomeID'="" d
    ....s PreNum=$LG(^User.DHCPEPreHomeInfoD(HomeID),HPosition)
    .e  d  ;普通团体
    ..s PreType="G"
    ..s PreMID=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,CurVIP,"G",""))
    e  d ;个人
    .s PreType="I"
    .s PreMID=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,CurVIP,"I",""))
    i PreMID'="" d
    .s PreNum=$LG(^User.DHCPEPreManagerD(PreMID),Position)
    
    s HadPreNum=0
    
    s AdmTime=""
    f  s AdmTime=$o(^DHCPEIADM(0,"AdmDateTime",Date,AdmTime)) q:AdmTime=""  d
    .s AdmID=""
    .f  s AdmID=$O(^DHCPEIADM(0,"AdmDateTime",Date,AdmTime,AdmID)) q:AdmID=""  d
    ..s Status=$P(^DHCPEIADM(AdmID),"^",8)
    ..q:(Status'="ARRIVED")&&(Status'="REGISTERED")
    ..q:(Date<+$H)&&(Status'="ARRIVED")
    ..s PreADMID=$P(^DHCPEIADM(AdmID),"^",4)
    ..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PreADMID)
    ..q:LocFlag="1"
    ..s GADMID=$P(^DHCPEPreIADM(PreADMID),"^",2)
    ..s LastHomeID=##class(web.DHCPE.PreHome).GetLastHomeIDByGADM(GADMID)
    ..q:(PreType="I")&&(GADMID'="")
    ..q:((PreType="O")||(PreType="G"))&&(GADMID="") ;过期主场、普通主场、非团体人员退出
    ..q:(PreType="H")&&(GADMID'=PreGADM)  ;主场的，非本团体的退出
    ..q:(PreType="G")&&(LastHomeID'="") ;普通团体，设置过主场的退出
    ..s QFlag=0
    ..i PreType="O" d
    ...s LastHomeDate=$LG(^User.DHCPEPreHomeInfoD(LastHomeID),10)
    ...i (LastHomeDate+1)>Date d
    ...s QFlag=1
    ..q:QFlag="1"
    ..s PIBIID=$P(^DHCPEPreIADM(PreADMID),"^",1)
    ..s Sex=$P(^DHCPEPreIBI(PIBIID),"^",3)
    ..q:Sex'=CurSex
    ..s VIPLevel=$P(^DHCPEPreIADM(PreADMID),"^",18)
    ..i VIPLevel="" s VIPLevel=$G(^DHCPEVIPLevel("VIPapprove"))
    ..q:VIPLevel'=CurVIP
    ..s HadPreNum=HadPreNum+1
    i PreType="I"
    {
        s RecordId = ""
        f  s RecordId = $o(^User.DHCPENetPreRecordI("PreDateIndex",Date,RecordId)) q:RecordId=""  do
        .s Preiadm = $lg(^User.DHCPENetPreRecordD(RecordId),2)
        .q:(Preiadm'="")
        .s Sex=$lg(^User.DHCPENetPreRecordD(RecordId),4)
        .q:Sex'=CurSex
        .s loc = $lg(^User.DHCPENetPreRecordD(RecordId),17)
        .q:(loc'=LocID)
        .s level = $lg(^User.DHCPENetPreRecordD(RecordId),16)
        .q:(level'=LevelDesc)
        .s HadPreNum=HadPreNum+1
    }
    i (HadPreNum+1)>PreNum d
    .s Str=DateStr_"<br><font color=red>不可用</font>"_"-"_PreNum_"-"_HadPreNum
    .w "<button type='button' onclick=SetPreDate(this) id='0^"_IDDate_"'>"_Str_"</button>"
    e  d
    .s Str=DateStr_"<br><font color=#017bce>可用</font>"_"-"_PreNum_"-"_HadPreNum
    .w "<button type='button' onclick=SetPreDate(this) id='1^"_IDDate_"'>"_Str_"</button>"
}

ClassMethod GetDefaultDate(LocID, PreIADMID, ExpStr As %String = "")
{
    i PreIADMID'="" d
    .s PreGADM=$P(^DHCPEPreIADM(PreIADMID),"^",2)
    .s PIBI=$P(^DHCPEPreIADM(PreIADMID),"^",1)
    .s CurSex=$P(^DHCPEPreIBI(PIBI),"^",3)
    .s CurVIP=$P(^DHCPEPreIADM(PreIADMID),"^",18)
    e  d
    .s PreGADM=""
    .s CurSex=$P(ExpStr,"^",1)
    .s CurVIP=$P(ExpStr,"^",2)
    s:CurVIP="" CurVIP=$G(^DHCPEVIPLevel("VIPapprove"))
    s LevelDesc=$P(^DHCPEVIPLevel("VIP",CurVIP),"^",2)
    /*
    i LevelDesc[("VIP")
    {
        q $ZD(+$H,4)
    }
    */
    s HPosition=6
    s Position=12  ;女
    //s:CurSex=$P($G(^DHCPESetting("DHCPE","DefPatientType")),"^",3) Position=11
    //s:CurSex=$P($G(^DHCPESetting("DHCPE","DefPatientType")),"^",3) HPosition=5
    s:CurSex=$P($G(^DHCPESetting("DHCPE","DefPatientType",LocID)),"^",3) Position=11
	s:CurSex=$P($G(^DHCPESetting("DHCPE","DefPatientType",LocID)),"^",3) HPosition=5

    
    s DefaultDate=""
    s Date=+$H-1
    f  s Date=$o(^DHCPEIADM(0,"AdmDateTime",Date)) q:(Date="")||(DefaultDate'="")  d
    .s HadPreNum=0
    .s PreMID=""
    .s PreNum=0
    .i PreGADM'="" d ;团队的
    ..i $D(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",PreGADM)) d  ;设置过主场
    ...s PreType="O"
    ...s LastHomeDate=$O(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",PreGADM,""),-1)  ;最后一个主场日期
    ...i LastHomeDate<Date d  ;过期主场
    ....s PreMID=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,CurVIP,"O",""))
    ...e  d  ;当天的主场人数
    ....s PreType="H"
    ....s HomeID=$O(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",PreGADM,Date,""))
    ....i HomeID'="" d
    .....s PreNum=$LG(^User.DHCPEPreHomeInfoD(HomeID),HPosition)
    ..e  d  ;普通团体
    ...s PreType="G"
    ...s PreMID=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,CurVIP,"G",""))
    .e  d ;个人
    ..s PreType="I"
    ..s PreMID=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,CurVIP,"I",""))
    .i PreMID'="" d
    ..s PreNum=$LG(^User.DHCPEPreManagerD(PreMID),Position)
    .q:+PreNum=0
    .s AdmTime=""
    .f  s AdmTime=$o(^DHCPEIADM(0,"AdmDateTime",Date,AdmTime)) q:AdmTime=""  d
    ..s AdmID=""
    ..f  s AdmID=$O(^DHCPEIADM(0,"AdmDateTime",Date,AdmTime,AdmID)) q:AdmID=""  d
    ...s Status=$P(^DHCPEIADM(AdmID),"^",8)
    ...q:(Status'="ARRIVED")&&(Status'="REGISTERED")
    ...q:(Date<+$H)&&(Status'="ARRIVED")
    ...s PreADMID=$P(^DHCPEIADM(AdmID),"^",4)
    ...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PreADMID)
    ...q:LocFlag="1"
    ...s GADMID=$P(^DHCPEPreIADM(PreADMID),"^",2)
    ...q:(PreType="I")&&(GADMID'="")
    ...q:((PreType="O")||(PreType="G"))&&(GADMID="") ;过期主场、普通主场、非团体人员退出
    ...q:(PreType="H")&&(GADMID'=PreGADM)  ;主场的，非本团体的退出
    ...q:(PreType="G")&&($D(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",GADMID))) ;普通团体，设置过主场的退出
    ...s QFlag=0
    ...i PreType="O" d
    ....s LastHomeDate=$O(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",GADMID,""),-1)
    ....i (LastHomeDate+1)>Date d
    ....s QFlag=1
    ...q:QFlag="1"
    ...s PIBIID=$P(^DHCPEPreIADM(PreADMID),"^",1)
    ...s Sex=$P(^DHCPEPreIBI(PIBIID),"^",3)
    ...q:Sex'=CurSex
    ...s VIPLevel=$P(^DHCPEPreIADM(PreADMID),"^",18)
    ...i VIPLevel="" s VIPLevel=$G(^DHCPEVIPLevel("VIPapprove"))
    ...q:VIPLevel'=CurVIP
    ...s HadPreNum=HadPreNum+1
    .i PreType="I" d
    ..s RecordId = ""
    ..f  s RecordId = $o(^User.DHCPENetPreRecordI("PreDateIndex",Date,RecordId)) q:RecordId=""  do
    ...s Preiadm = $lg(^User.DHCPENetPreRecordD(RecordId),2)
    ...q:(Preiadm'="")
    ...s Sex=$lg(^User.DHCPENetPreRecordD(RecordId),4)
    ...q:Sex'=CurSex
    ...s loc = $lg(^User.DHCPENetPreRecordD(RecordId),17)
    ...q:(loc'=LocID)
    ...s level = $lg(^User.DHCPENetPreRecordD(RecordId),16)
    ...q:(level'=LevelDesc)
    ...s HadPreNum=HadPreNum+1
    .i HadPreNum<PreNum d
    ..s DefaultDate=Date
    s:DefaultDate'="" DefaultDate=##class(websys.Conversions).DateLogicalToHtml(DefaultDate)
    s:DefaultDate="" DefaultDate=##class(websys.Conversions).DateLogicalToHtml(+$h)
    q DefaultDate
}

}
