Class web.DHCPE.PreManager Extends %Persistent
{

/// w ##class(web.DHCPE.PreManager).OutMainHISUI("2020-09-10","","Return")
ClassMethod OutMainHISUI(Month As %String = "", LocID As %String = "", OutFlag As %String = "")
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
 	
 	s TabInfo=""
 	if (OutFlag="Return") {
	 	s TabInfo=TabInfo_"<TABLE class=PreManager id='PreManager' height=100% width=100% border=0 cellspacing='0' cellpadding='0' style='white-space:normal; word-break:break-all;'>"
		s TabInfo=TabInfo_"<tr class='datagrid-header' headerCls='panel-header-gray' style='width:26px; height:30px; margin-top: 0px;'>"
		s TabInfo=TabInfo_"<td>周一</td>"
		s TabInfo=TabInfo_"<td>周二</td>"	
		s TabInfo=TabInfo_"<td>周三</td>"
		s TabInfo=TabInfo_"<td>周四</td>"
		s TabInfo=TabInfo_"<td>周五</td>"	
		s TabInfo=TabInfo_"<td>周六</td>"
		s TabInfo=TabInfo_"<td>周日</td>"		
		s TabInfo=TabInfo_"</tr>"
 	} else {
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
 	}
	d ClearInfo
	
	f Date=StartDate:1:EndDate
 	{	
 		s Week=$ZD(Date,10)
 		i Week=0 s Week=7
		s DateStr=##class(websys.Conversions).DateLogicalToHtml(Date)
		s Flag=1
		s PLIST(Week)=DateStr
		if (OutFlag="Return") {
			s TabInfo=TabInfo_"<tr>"
			i Week=7 d
			.f ind=1:1:Week d
			..s TabInfo=TabInfo_..OutLinkHISUI(PLIST(ind),LocID)
			.d ClearInfo
			s TabInfo=TabInfo_"</tr>"
		} else {
			w "<tr>"
			i Week=7 d
			.f ind=1:1:Week d
			..w ..OutLinkHISUI(PLIST(ind),LocID)
			.d ClearInfo
			w "</tr>"
		}
	
 	}
 	if (OutFlag="Return") {
 		if Flag=1 {
		 	f ind=1:1:7 d
			.s TabInfo=TabInfo_..OutLinkHISUI(PLIST(ind),LocID)
	 	}
	 	s TabInfo=TabInfo_"</TABLE>"
	} else {
		if Flag=1 {
			f ind=1:1:7 d
			.w ..OutLinkHISUI(PLIST(ind),LocID)
		}
		w "</TABLE>"
	}
 	
	q TabInfo
	
ClearInfo
	s Flag=0
	s (PLIST(1),PLIST(2),PLIST(3),PLIST(4),PLIST(5),PLIST(6),PLIST(7))=""
	q
}

/// d ##class(web.DHCPE.PreManager).OutLinkHISUI("2014-12-19","53")
ClassMethod OutLinkHISUI(DateStr As %String = "", LocID As %String = "")
{
	i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
	i DateStr=""{
		 q "<td></td>"
		
	}
	s lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreManager&DateStr="_DateStr
	s Date=##class(websys.Conversions).DateHtmlToLogical(DateStr)
	s Job=$J
	//当天日期所有设置过的主场信息
	s PreHomeID=""
	f  s PreHomeID=$O(^User.DHCPEPreHomeInfoI("PGADMHomeDateIndex",Date,PreHomeID)) q:PreHomeID=""  d
	.s PreGADMID=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),2)
	.s CurType=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),11)
	.i CurType="G" d  ;团体主场
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PGADM",PreGADMID)
	.e  d  ;合同主场
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("Contract",PreGADMID)
	.q:LocFlag="1"
	.s MNum=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),5)  ;男
	.s FNum=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),6)  ;女
	.s ^TempDHCPEPreManager(Job,CurType,PreGADMID,"M")=MNum
	.s ^TempDHCPEPreManager(Job,CurType,PreGADMID,"F")=FNum

	s AdmTime=""
	f  s AdmTime=$o(^DHCPEIADM(0,"AdmDateTime",Date,AdmTime)) q:AdmTime=""  d
	.s AdmID=""
	.f  s AdmID=$O(^DHCPEIADM(0,"AdmDateTime",Date,AdmTime,AdmID)) q:AdmID=""  d
	..s Status=$P($g(^DHCPEIADM(AdmID)),"^",8)
	..q:(Status'="ARRIVED")&&(Status'="REGISTERED")
	..q:(Date<+$H)&&(Status'="ARRIVED")
	..s PreADMID=$P($g(^DHCPEIADM(AdmID)),"^",4)
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PreADMID)
	..q:LocFlag="1"
	..s GADMID=$P($g(^DHCPEPreIADM(PreADMID)),"^",2)
	..s PIBIID=$P($g(^DHCPEPreIADM(PreADMID)),"^",1)
	..s Sex=$P($g(^DHCPEPreIBI(PIBIID)),"^",3)
	..s SexStr="M"
	..;s:Sex=$P($G(^DHCPESetting("DHCPE","DefPatientType")),"^",4) SexStr="F"
	..s:Sex=$P($g(^DHCPESetting("DHCPE","DefPatientType",LocID)),"^",4) SexStr="F"
	..s VIPLevel=$P($g(^DHCPEPreIADM(PreADMID)),"^",18)
	..;i VIPLevel="" s VIPLevel=$G(^DHCPEVIPLevel("VIPapprove"))
	..i VIPLevel="" s VIPLevel=##class(web.DHCPE.CT.VIPLevel).GetDefaultVIP(LocID) //获取科室默认的VIP等级(多院区)
	..i $D(^User.DHCPENetPreRecordI("NPRPreIADMIndex"," "_PreADMID)) d  ;网上人数
	...s PreType="Net"  //网上预约的
	..e  d
	...s PreType="His"  //his现场办理的
	..i GADMID="" d  ;个人
	...s GADMID="I"
	...s CurType="NULL"
	..e  d
	...s CurHomeID=##class(web.DHCPE.PreHome).GetHomeIDByGADM(GADMID,Date)
	...i CurHomeID="" d  ;非团体主场
	....s CurType="NULL"
	....s HomeDesc = ##class(web.DHCPE.PreHome).GetHomeFlag(GADMID,"G")
	....i HomeDesc'=""  do
	.....s GADMID="O"  ;过期主场里面
	....e  do
	.....s GADMID="G"  ;普通主场
	...e  d
	....s CurType=$LG(^User.DHCPEPreHomeInfoD(CurHomeID),11)
	....s GADMID=$LG(^User.DHCPEPreHomeInfoD(CurHomeID),2)
	..i $D(^TempDHCPEPreManager(Job,CurType,GADMID)) d
	...s i=$I(^TempDHCPEPreManagerRecord(Job,CurType,GADMID,SexStr,PreType)) ;主场已预约人数
	..e  d
	...q:VIPLevel=""
	...s i=$I(^TempDHCPEPreManagerRecord(Job,GADMID,VIPLevel,SexStr,PreType)) ;非主场已预约人数
	
	
	s PreInfo=""
	s VIP=""
	f  s VIP=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,VIP)) q:VIP=""  d
	.;s Desc=$P(^DHCPEVIPLevel("VIP",VIP),"^",2)
	.s Desc=$lg($g(^CT.PE.VIPLevelD(VIP)),3) //VIP描述（多院区）
	.s Type=""
	.f  s Type=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,VIP,Type)) q:Type=""  d
	..s VIPDesc=Desc
	..s:Type="I" VIPDesc=Desc_"个人"
	..s:Type="G" VIPDesc=Desc_"团体"
	..s Num=##class(web.DHCPE.PreTemplate).GetRecordNum(LocID,Date,VIP,Type)
	..q:Num=""
	..s MaleNum = $p(Num,"-",1)
	..s FemaleNum = $p(Num,"-",2)
	..i (((MaleNum="")||(MaleNum=0))&&((FemaleNum="")||(FemaleNum=0))) quit
	..s MaleOneInfo="",FemaleOneInfo="",OneInfo=""

	
	..i Type="O"  do
	...s MNum=0
	...s FNum=0
	...s RecordId = ""
	...f  s RecordId = $o(^User.DHCPENetPreRecordI("PreDateIndex",Date,RecordId)) q:RecordId=""  do
	....s loc = $lg(^User.DHCPENetPreRecordD(RecordId),17)
	....q:(loc'=LocID)
	....s datetype = $lg(^User.DHCPENetPreRecordD(RecordId),22)
	....q:(datetype'=Type)
	....s RecordStatus = $LG(^User.DHCPENetPreRecordD(RecordId),7)
	....q:(RecordStatus'=0)&&(RecordStatus'=1)&&(RecordStatus'=4)&&(RecordStatus'=5)
	....s sex = $lg(^User.DHCPENetPreRecordD(RecordId),4)
	....i sex = 1  do  ;女
	.....s FNum = FNum + 1
	....i sex = 2  do  ;男
	.....s MNum = MNum + 1
	
	..e  do
	...s MNum=0
	...s FNum=0
	...s RecordId = ""
	...f  s RecordId = $o(^User.DHCPENetPreRecordI("PreDateIndex",Date,RecordId)) q:RecordId=""  do
	....s Preiadm = $lg(^User.DHCPENetPreRecordD(RecordId),2)
	....q:(Preiadm'="")
	....s loc = $lg(^User.DHCPENetPreRecordD(RecordId),17)
	....q:(loc'=LocID)
	....s level = $lg(^User.DHCPENetPreRecordD(RecordId),16)
	....q:(level'=Desc)
	....s datetype = $lg(^User.DHCPENetPreRecordD(RecordId),22)
	....q:(datetype'=Type)
	....s RecordStatus = $lg(^User.DHCPENetPreRecordD(RecordId),7)
	....q:(RecordStatus'=0)&&(RecordStatus'=1)&&(RecordStatus'=4)&&(RecordStatus'=5)
	....s sex = $lg(^User.DHCPENetPreRecordD(RecordId),4)
	....i sex = 1  do
	.....s FNum = FNum + 1
	....i sex = 2  do
	.....s MNum = MNum + 1
	
	
	..s MPreNum=+$G(^TempDHCPEPreManagerRecord(Job,Type,VIP,"M","Net"))+MNum
	..s FPreNum=+$G(^TempDHCPEPreManagerRecord(Job,Type,VIP,"F","Net"))+FNum
	
	..;s MPreNum=+$G(^TempDHCPEPreManagerRecord(Job,Type,VIP,"M","Net"))
	..;s FPreNum=+$G(^TempDHCPEPreManagerRecord(Job,Type,VIP,"F","Net"))
	
	
	..s MaleOneInfo=VIPDesc_"(男)："_MaleNum_"-<font color=red>"_MPreNum_"</font>"
	..s FemaleOneInfo=VIPDesc_"(女)："_FemaleNum_"-<font color=red>"_FPreNum_"</font>"
	..i Type="O"  do
	...s MPreNum=+$G(^TempDHCPEPreManagerRecord(Job,Type,1,"M","His"))
	...s FPreNum=+$G(^TempDHCPEPreManagerRecord(Job,Type,1,"F","His"))
	..e  do
	...s MPreNum=+$G(^TempDHCPEPreManagerRecord(Job,Type,VIP,"M","His"))
	...s FPreNum=+$G(^TempDHCPEPreManagerRecord(Job,Type,VIP,"F","His"))
	..s MaleOneInfo=MaleOneInfo_"-<font color=blue>"_MPreNum_"</font>"
	..s FemaleOneInfo=FemaleOneInfo_"-<font color=blue>"_FPreNum_"</font>"
	..i MaleOneInfo'="" s OneInfo=MaleOneInfo
	..i FemaleOneInfo'=""  do
	...i OneInfo'="" s OneInfo=OneInfo_"<br>"_FemaleOneInfo
	...e  d
	....s OneInfo=FemaleOneInfo
	
	..i PreInfo="" d
	...s PreInfo=OneInfo
	..e  d
	...s PreInfo=PreInfo_"<br>"_OneInfo
	
	s Type=""
	f  s Type=$O(^TempDHCPEPreManager(Job,Type)) q:Type=""  d
	.s GADM=""
	.f  s GADM=$O(^TempDHCPEPreManager(Job,Type,GADM)) q:GADM=""  d
	..i Type="G" d
	...s GBaseInfoID=$P(^DHCPEPreGADM(GADM),"^",1)
	...s GDesc=$P(^DHCPEPreGBI(GBaseInfoID),"^",2)
	...s GDesc="<font color=green>"_GDesc_"</font>"
	..e  d
	...s GDesc=$LG(^User.DHCPEContractD(GADM),3)
	...s GDesc="<font color=green>H-"_GDesc_"</font>"
	..s MaleNum=$G(^TempDHCPEPreManager(Job,Type,GADM,"M"))
	..s MPreNum=+$G(^TempDHCPEPreManagerRecord(Job,GADM,"M","Net"))
	..s MaleOneInfo=GDesc_"(男)："_MaleNum_"-<font color=red>"_MPreNum_"</font>"
	..s FaleNum=$G(^TempDHCPEPreManager(Job,Type,GADM,"F"))
	..s FPreNum=+$G(^TempDHCPEPreManagerRecord(Job,GADM,"F","Net"))
	..s FemaleOneInfo=GDesc_"(女)："_FaleNum_"-<font color=red>"_FPreNum_"</font>"
	..s MPreNum=+$G(^TempDHCPEPreManagerRecord(Job,GADM,"M","His"))
	..s MaleOneInfo=MaleOneInfo_"-<font color=blue>"_MPreNum_"</font>"
	..s FPreNum=+$G(^TempDHCPEPreManagerRecord(Job,GADM,"F","His"))
	..s FemaleOneInfo=FemaleOneInfo_"-<font color=blue>"_FPreNum_"</font>"
	
	..i PreInfo="" d
	...s PreInfo=MaleOneInfo_"<br>"_FemaleOneInfo
	..e  d
	...s PreInfo=PreInfo_"<br>"_MaleOneInfo_"<br>"_FemaleOneInfo
	k ^TempDHCPEPreManagerRecord
	k ^TempDHCPEPreManager
	//q "<td valign=top><font color = red size=4pt><a href="_lnk_" target='_blank' >"_DateStr_"</a></font><br>"_PreInfo_"</td>"
    q "<td valign=top ondblclick='ShowPreManagerInfo(this)' id='"_DateStr_"'><font color = blue size=4pt>"_DateStr_"</font><br>"_PreInfo_"</td>"
}

/// w ##class(web.DHCPE.PreManager).UpdatePreManager(597,1,"普通团体(女)")
ClassMethod UpdatePreManager(ID, Num, GADMDesc)
{
	;Str  "2012-05-31^GADM^Num"
	s Type=$P(ID,"^",2)
	s ID=$P(ID,"^",1)
	i Type="H"
	{
		s obj=##class(User.DHCPEPreHomeInfo).%OpenId(ID)
		s PreGADMID=obj.PGADMDr
		s ADMType=obj.PGADMType
		s PreGADMID=PreGADMID_"^"_ADMType
		s Date=obj.PGADMHomeDate
		s Date=$ZD(Date,4)
		q ##class(web.DHCPE.PreHome).UpdateMethod(PreGADMID,ID,Date,Date,Num)

	}
	s obj=##class(User.DHCPEPreManager).%OpenId(ID)
	s MaleNum="",FemaleNum=""
	i ((Num="")||(Num="-")) do
	.s MaleNum="",FemaleNum=""
	e  do
	.s MaleNum=$p(Num,"-",1),FemaleNum=$p(Num,"-",2)
	
	s obj.PMNumMale=MaleNum
	s obj.PMNumFemale=FemaleNum
	s sc=obj.%Save()
	d obj.%Close()
	
	s SubCount=0
	s TemplateSub = ""
	f  s TemplateSub = $o(^User.DHCPEPreManagerD(ID,"PMTimeChild",TemplateSub)) q:TemplateSub=""  do
	.s SubCount=SubCount+1
	
	s a=1
	s TemplateSub = ""
	f  s TemplateSub = $o(^User.DHCPEPreManagerD(ID,"PMTimeChild",TemplateSub)) q:TemplateSub=""  do
	.s SubId = ID_"||"_TemplateSub
	.s subObj=##class(User.DHCPEPreTimeManager).%OpenId(SubId)
	.i (a#SubCount=1) s subObj.PTMNumMale=((MaleNum\SubCount)+(MaleNum#SubCount)),subObj.PTMNumFemale=((FemaleNum\SubCount)+(FemaleNum#SubCount))
	.i (a#SubCount'=1) s subObj.PTMNumMale=(MaleNum\SubCount),subObj.PTMNumFemale=(FemaleNum\SubCount)
	.s scSub=subObj.%Save()
	.d subObj.%Close()
	.s a=a+1
	
	
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

/*
ClassMethod Replace(OldDate, NewDate)
{
	i OldDate'="" s OldDate=##class(websys.Conversions).DateHtmlToLogical(OldDate)
    i NewDate'="" s NewDate=##class(websys.Conversions).DateHtmlToLogical(NewDate)
	s LocID=%session.Get("LOGON.CTLOCID")
	&SQL(Update Sqluser.DHC_PE_PreManager set PM_Date=:NewDate where PM_Date=:OldDate and PM_Loc_DR=:LocID)
	d ##class(web.DHCPE.PreHome).Replace(OldDate, NewDate)
	q SQLCODE
}

// d ##class(web.DHCPE.PreManager).Create("2014-12-13","14/12/2014",1)

ClassMethod Create(OldDate, NewDate, UserID)
{
	i OldDate'="" s OldDate=##class(websys.Conversions).DateHtmlToLogical(OldDate)
    i NewDate'="" s NewDate=##class(websys.Conversions).DateHtmlToLogical(NewDate)
	b ;OldDate NewDate
	s Date=+$H
	s Time=$P($H,",",2)
	s LocID=%session.Get("LOGON.CTLOCID")
	//&SQL(insert into Sqluser.DHC_PE_PreManager (PM_Date,PM_Num_Male,PM_Num_Female,PM_Loc_DR,PM_VIPLevel,PM_Type,PM_UpdateDate,PM_UpdateTime,PM_UpdateUser_DR) select :NewDate,PM_Num_Male,PM_Num_Female,PM_Loc_DR,PM_VIPLevel,PM_Type,:Date,:Time,:UserID from Sqluser.DHC_PE_PreManager where PM_Date=:OldDate)
	s VIP=""
	f  s VIP=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,OldDate,VIP)) q:VIP=""  d
	.s Type=""
	.f  s Type=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,OldDate,VIP,Type)) q:Type=""  d
	..s PreManagerID=""
	..f  s PreManagerID=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,OldDate,VIP,Type,PreManagerID)) q:PreManagerID=""  d
	...s obj=##class(User.DHCPEPreManager).%OpenId(PreManagerID)
	...s NewObj=##class(User.DHCPEPreManager).%New()
	...s NewObj.PMDate=NewDate
	...s NewObj.PMGADMDR=obj.PMGADMDR
	...s NewObj.PMLocDR=obj.PMLocDR
	...s NewObj.PMNum=obj.PMNum
	...s NewObj.PMNumFemale=obj.PMNumFemale
	...s NewObj.PMNumMale=obj.PMNumMale
	...s NewObj.PMType=obj.PMType
	...s NewObj.PMUpdateDate=Date
	...s NewObj.PMUpdateTime=Time
	...d NewObj.PMUpdateUserDRSetObjectId(UserID)
	...s NewObj.PMVIPLevel=obj.PMVIPLevel
	...s ChildLength=obj.PMTimeChild.Count()
	...f i=1:1:ChildLength d
	....s OldChild=obj.PMTimeChild.GetAt(i)
	....s NewChild=##class(User.DHCPEPreTimeManager).%New()
	....s NewChild.PTMEndTime=OldChild.PTMEndTime
	....s NewChild.PTMNum=OldChild.PTMNum
	....s NewChild.PTMNumFemale=OldChild.PTMNumFemale
	....s NewChild.PTMNumMale=OldChild.PTMNumMale
	....s NewChild.PTMStartTime=OldChild.PTMStartTime
	....d NewObj.PMTimeChild.Insert(NewChild)
	...s sc=NewObj.%Save()
	...b:$$$ISERR(sc)  ;Err
	...d obj.%Close()
	...d NewObj.%Close()
	d ##class(web.DHCPE.PreHome).Create(OldDate, NewDate, UserID)
	q 0
}
*/
ClassMethod Replace(OldDate, NewDate)
{
	i OldDate'="" s OldDateNew=##class(websys.Conversions).DateHtmlToLogical(OldDate)
    i NewDate'="" s NewDateNew=##class(websys.Conversions).DateHtmlToLogical(NewDate)
	s LocID=%session.Get("LOGON.CTLOCID")
	&SQL(Update Sqluser.DHC_PE_PreManager set PM_Date=:NewDateNew where PM_Date=:OldDateNew and PM_Loc_DR=:LocID)
	d ##class(web.DHCPE.PreHome).Replace(OldDate, NewDate)
	q SQLCODE
}

// d ##class(web.DHCPE.PreManager).Create("2020-09-03","2020-09-02",13811)

ClassMethod Create(OldDate, NewDate, UserID)
{
	i OldDate'="" s OldDateNew=##class(websys.Conversions).DateHtmlToLogical(OldDate)
    i NewDate'="" s NewDateNew=##class(websys.Conversions).DateHtmlToLogical(NewDate)
	b ;OldDate NewDate
	s Date=+$H
	s Time=$P($H,",",2)
	s LocID=%session.Get("LOGON.CTLOCID")
	
	//&SQL(insert into Sqluser.DHC_PE_PreManager (PM_Date,PM_Num_Male,PM_Num_Female,PM_Loc_DR,PM_VIPLevel,PM_Type,PM_UpdateDate,PM_UpdateTime,PM_UpdateUser_DR) select :NewDate,PM_Num_Male,PM_Num_Female,PM_Loc_DR,PM_VIPLevel,PM_Type,:Date,:Time,:UserID from Sqluser.DHC_PE_PreManager where PM_Date=:OldDate)
	s VIP=""
	f  s VIP=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,NewDateNew,VIP)) q:VIP=""  d
	.s Type=""
	.f  s Type=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,NewDateNew,VIP,Type)) q:Type=""  d
	..q:$D(^User.DHCPEPreManagerI("LocDateIndex",LocID,OldDate,VIP,Type))  	//已存在的不再创建
	..s PreManagerID=""
	..f  s PreManagerID=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,NewDateNew,VIP,Type,PreManagerID)) q:PreManagerID=""  d
	...b ;PreManagerID
	...s obj=##class(User.DHCPEPreManager).%OpenId(PreManagerID)
	...s NewObj=##class(User.DHCPEPreManager).%New()
	...s NewObj.PMDate=OldDateNew
	...s NewObj.PMGADMDR=obj.PMGADMDR
	...s NewObj.PMLocDR=obj.PMLocDR
	...s NewObj.PMNum=obj.PMNum
	...s NewObj.PMNumFemale=obj.PMNumFemale
	...s NewObj.PMNumMale=obj.PMNumMale
	...s NewObj.PMType=obj.PMType
	...s NewObj.PMUpdateDate=Date
	...s NewObj.PMUpdateTime=Time
	...d NewObj.PMUpdateUserDRSetObjectId(UserID)
	...s NewObj.PMVIPLevel=obj.PMVIPLevel
	...s ChildLength=obj.PMTimeChild.Count()
	...f i=1:1:ChildLength d
	....s OldChild=obj.PMTimeChild.GetAt(i)
	....s NewChild=##class(User.DHCPEPreTimeManager).%New()
	....s NewChild.PTMEndTime=OldChild.PTMEndTime
	....s NewChild.PTMNum=OldChild.PTMNum
	....s NewChild.PTMNumFemale=OldChild.PTMNumFemale
	....s NewChild.PTMNumMale=OldChild.PTMNumMale
	....s NewChild.PTMStartTime=OldChild.PTMStartTime
	....d NewObj.PMTimeChild.Insert(NewChild)
	...s sc=NewObj.%Save()
	...b:$$$ISERR(sc)  ;Err
	...d obj.%Close()
	...d NewObj.%Close()
	d ##class(web.DHCPE.PreHome).Create(OldDate, NewDate, UserID)
	q 0
}

/// d ##class(web.DHCPE.PreManager).TestObj()
ClassMethod TestObj()
{
	s obj=##class(User.DHCPEPreManager).%OpenId(2)
	w obj.%DeleteId(2)
	s sc=obj.%Save()
	w $System.Status.DisplayError(sc)
}

ClassMethod JudgeArriveNum(PreIADM)
{
	s Flag=0
	s GID=$P(^DHCPEPreIADM(PreIADM),"^",2)
	s Num=0
	s Date=+$H
	i GID="" d
	.s NumID=$O(^User.DHCPEPreManagerI("DateADMIndex"," "_Date," 0",0))
	.q:NumID=""
	.s Num=$LG(^User.DHCPEPreManagerD(NumID),4)
	.s Flag=1
	e  d
	.s NumID=$O(^User.DHCPEPreManagerI("DateADMIndex"," "_Date," "_GID,0))
	.q:NumID=""
	.s Num=$LG(^User.DHCPEPreManagerD(NumID),4)
	.s Flag=1
	s ArrivedNum=..GetArrivedNum(Date,GID)
	s OverNum=(ArrivedNum+1)-Num
	i OverNum>0 q "1^"_OverNum
	q 0
}

ClassMethod GetArrivedNum(Date, GID)
{
	s ArrivedNum=0
	s Time=""
	f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:Time=""  d
	.s ID=0
	.s ID=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time,ID)) q:ID=""  d
	..s Status=$P(^DHCPEIADM(ID),"^",8)
	..q:Status'="ARRIVED"  ;不是到达的退出
	..s CurGID=$P(^DHCPEIADM(ID),"^",2)
	..q:GID'=CurGID ;和当前团体不一致退出
	..s ArrivedNum=ArrivedNum+1
	q ArrivedNum
}

ClassMethod DeletePreManager(ID)
{
	&SQL(Delete From Sqluser.DHC_PE_PreManager where ID=:ID)
	q SQLCODE
}

Query FindPreManager(Month As %String = "") As %Query(ROWSPEC = "TZ1:%String,TZ2:%String,TZ3:%String,TZ4:%String,TZ5:%String,TZ6:%String,TZ7:%String")
{
}

ClassMethod FindPreManagerExecute(ByRef qHandle As %Binary, Month As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.PreManager","FindPreManager",62607)
	Set repid=$I(^CacheTemp)
 	s ind=1
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

ClassMethod FindPreManagerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPreManagerExecute ]
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

ClassMethod FindPreManagerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPreManagerExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindPreManagerByDate(DateStr As %String = "") As %Query(ROWSPEC = "TID:%String,TNum:%String,TGADMID:%String,TGADMDesc:%String,TType:%String,TRemark:%String")
{
}

ClassMethod FindPreManagerByDateExecute(ByRef qHandle As %Binary, DateStr As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.PreManager","FindPreManagerByDate","2012-06-21")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s LocID=%session.Get("LOGON.CTLOCID")
 	s DateStr=%request.Get("DateStr")
 	i +DateStr=0{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s Date=##class(websys.Conversions).DateHtmlToLogical(DateStr)
 	s TType="M"
 	s VIP=""
	f  s VIP=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,VIP)) q:VIP=""  d
	.s Desc=$P(^DHCPEVIPLevel("VIP",VIP),"^",2)
	.s Type=""
	.f  s Type=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,VIP,Type)) q:Type=""  d
	..s TGADMDesc=Desc
	..s:Type="I" TGADMDesc=Desc_"个人"
	..s:Type="G" TGADMDesc=Desc_"团体"
	..s TID=##Class(web.DHCPE.PreTemplate).GetRecordID(LocID,Date,VIP,Type)
	
	..s MaleNum = $LG(^User.DHCPEPreManagerD(TID),11)
	..s FemaleNum = $LG(^User.DHCPEPreManagerD(TID),12)
	..i ((MaleNum'="")||(FemaleNum'="")) do
	...s TNum = MaleNum_"-"_FemaleNum
	...s TRemark=""
	...d FindPreManagerBuild
	s TType="H"
	s PreHomeID=""
	f  s PreHomeID=$O(^User.DHCPEPreHomeInfoI("PGADMHomeDateIndex",Date,PreHomeID)) q:PreHomeID=""  d
	.s PreGADMID=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),2)
	.s OldType=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),11)
	.i OldType="G" d
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PGADM",PreGADMID)
	..s GBaseInfoID=$P(^DHCPEPreGADM(PreGADMID),"^",1)
	..s TGADMDesc=$P(^DHCPEPreGBI(GBaseInfoID),"^",2)
	.e  d
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("Contract",PreGADMID)
	..s TGADMDesc=$LG(^User.DHCPEContractD(PreGADMID),3)
	.q:LocFlag="1"
	
	.s MNum=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),5)  ;男
	.s FNum=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),6)  ;女
	.s TGADMID=PreGADMID
	.s TID=PreHomeID
	.s TNum=MNum_"-"_FNum
	.s TRemark=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),12)
	.d FindPreManagerBuild
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ClearInfoDate
	s (TID,TNum,TGADMID,TGADMDesc,TRemark)=""
	q
FindPreManagerBuild      
	set Data=$lb(TID,TNum,TGADMID,TGADMDesc,TType,TRemark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPreManagerByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPreManagerByDateExecute ]
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

ClassMethod FindPreManagerByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPreManagerByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(web.DHCPE.PreManager).OutLink("2014-12-19","53")
ClassMethod OutLink(DateStr, LocID)
{
	i DateStr=""{
		 w ""
		 q
	}
	//s DefPatientType=$g(^DHCPESetting("DHCPE","DefPatientType"))
	s DefPatientType=$g(^DHCPESetting("DHCPE","DefPatientType",LocID))
	s lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreManager&DateStr="_DateStr
	s Date=##class(websys.Conversions).DateHtmlToLogical(DateStr)
	s Job=$J
	//当天日期所有设置过的主场信息
	s PreHomeID=""
	f  s PreHomeID=$O(^User.DHCPEPreHomeInfoI("PGADMHomeDateIndex",Date,PreHomeID)) q:PreHomeID=""  d
	.s PreGADMID=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),2)
	.s CurType=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),11)
	.i CurType="G" d  ;团体主场
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PGADM",PreGADMID)
	.e  d  ;合同主场
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("Contract",PreGADMID)
	.q:LocFlag="1"
	.s MNum=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),5)  ;男
	.s FNum=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),6)  ;女
	.s ^TempDHCPEPreManager(Job,CurType,PreGADMID,"M")=MNum
	.s ^TempDHCPEPreManager(Job,CurType,PreGADMID,"F")=FNum

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
	..s PIBIID=$P(^DHCPEPreIADM(PreADMID),"^",1)
	..s Sex=$P(^DHCPEPreIBI(PIBIID),"^",3)
	..s SexStr="M"
	..;s:Sex=$P($G(^DHCPESetting("DHCPE","DefPatientType")),"^",4) SexStr="F"
	..s:Sex=$P($G(^DHCPESetting("DHCPE","DefPatientType",LocID)),"^",4) SexStr="F"
	..s VIPLevel=$P(^DHCPEPreIADM(PreADMID),"^",18)
	..i VIPLevel="" s VIPLevel=$G(^DHCPEVIPLevel("VIPapprove"))
	..i $D(^User.DHCPENetPreRecordI("NPRPreIADMIndex"," "_PreADMID)) d  ;网上人数
	...s PreType="Net"  //网上预约的
	..e  d
	...s PreType="His"  //his现场办理的
	..i GADMID="" d  ;个人
	...s GADMID="I"
	...s CurType="NULL"
	..e  d
	...s CurHomeID=##class(web.DHCPE.PreHome).GetHomeIDByGADM(GADMID,Date)
	...i CurHomeID="" d  ;非团体主场
	....s CurType="NULL"
	....s HomeDesc = ##class(web.DHCPE.PreHome).GetHomeFlag(GADMID,"G")
	....i HomeDesc'=""  do
	.....s GADMID="O"  ;过期主场里面
	....e  do
	.....s GADMID="G"  ;普通主场
	...e  d
	....s CurType=$LG(^User.DHCPEPreHomeInfoD(CurHomeID),11)
	....s GADMID=$LG(^User.DHCPEPreHomeInfoD(CurHomeID),2)
	..i $D(^TempDHCPEPreManager(Job,CurType,GADMID)) d
	...s i=$I(^TempDHCPEPreManagerRecord(Job,CurType,GADMID,SexStr,PreType)) ;主场已预约人数
	..e  d
	...q:VIPLevel=""
	...s i=$I(^TempDHCPEPreManagerRecord(Job,GADMID,VIPLevel,SexStr,PreType)) ;非主场已预约人数
	
	
	s PreInfo=""
	s VIP=""
	f  s VIP=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,VIP)) q:VIP=""  d
	.s Desc=$P(^DHCPEVIPLevel("VIP",VIP),"^",2)
	.s Type=""
	.f  s Type=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,VIP,Type)) q:Type=""  d
	..s VIPDesc=Desc
	..s:Type="I" VIPDesc=Desc_"个人"
	..s:Type="G" VIPDesc=Desc_"团体"
	..s Num=##class(web.DHCPE.PreTemplate).GetRecordNum(LocID,Date,VIP,Type)
	..q:Num=""
	..s MaleNum = $p(Num,"-",1)
	..s FemaleNum = $p(Num,"-",2)
	..i (((MaleNum="")||(MaleNum=0))&&((FemaleNum="")||(FemaleNum=0))) quit
	..s MaleOneInfo="",FemaleOneInfo="",OneInfo=""

	
	..i Type="O"  do
	...s MNum=0
	...s FNum=0
	...s RecordId = ""
	...f  s RecordId = $o(^User.DHCPENetPreRecordI("PreDateIndex",Date,RecordId)) q:RecordId=""  do
	....s loc = $lg(^User.DHCPENetPreRecordD(RecordId),17)
	....q:(loc'=LocID)
	....s datetype = $lg(^User.DHCPENetPreRecordD(RecordId),22)
	....q:(datetype'=Type)
	....s RecordStatus = $LG(^User.DHCPENetPreRecordD(RecordId),7)
	....q:(RecordStatus'=0)&&(RecordStatus'=1)&&(RecordStatus'=4)&&(RecordStatus'=5)
	....s sex = $lg(^User.DHCPENetPreRecordD(RecordId),4)
	....i sex = $p(DefPatientType,"^",4)  do  ;女
	.....s FNum = FNum + 1
	....i sex = $p(DefPatientType,"^",2)  do  ;男
	.....s MNum = MNum + 1
	
	..e  do
	...s MNum=0
	...s FNum=0
	...s RecordId = ""
	...f  s RecordId = $o(^User.DHCPENetPreRecordI("PreDateIndex",Date,RecordId)) q:RecordId=""  do
	....s Preiadm = $lg(^User.DHCPENetPreRecordD(RecordId),2)
	....q:(Preiadm'="")
	....s loc = $lg(^User.DHCPENetPreRecordD(RecordId),17)
	....q:(loc'=LocID)
	....s level = $lg(^User.DHCPENetPreRecordD(RecordId),16)
	....q:(level'=Desc)
	....s datetype = $lg(^User.DHCPENetPreRecordD(RecordId),22)
	....q:(datetype'=Type)
	....s RecordStatus = $lg(^User.DHCPENetPreRecordD(RecordId),7)
	....q:(RecordStatus'=0)&&(RecordStatus'=1)&&(RecordStatus'=4)&&(RecordStatus'=5)
	....s sex = $lg(^User.DHCPENetPreRecordD(RecordId),4)
	....i sex = $p(DefPatientType,"^",4)  do
	.....s FNum = FNum + 1
	....i sex = $p(DefPatientType,"^",2)  do
	.....s MNum = MNum + 1
	
	
	..s MPreNum=+$G(^TempDHCPEPreManagerRecord(Job,Type,VIP,"M","Net"))+MNum
	..s FPreNum=+$G(^TempDHCPEPreManagerRecord(Job,Type,VIP,"F","Net"))+FNum
	
	..;s MPreNum=+$G(^TempDHCPEPreManagerRecord(Job,Type,VIP,"M","Net"))
	..;s FPreNum=+$G(^TempDHCPEPreManagerRecord(Job,Type,VIP,"F","Net"))
	
	
	..s MaleOneInfo=VIPDesc_"(男):"_MaleNum_"-<font color=red>"_MPreNum_"</font>"
	..s FemaleOneInfo=VIPDesc_"(女):"_FemaleNum_"-<font color=red>"_FPreNum_"</font>"
	..i Type="O"  do
	...s MPreNum=+$G(^TempDHCPEPreManagerRecord(Job,Type,1,"M","His"))
	...s FPreNum=+$G(^TempDHCPEPreManagerRecord(Job,Type,1,"F","His"))
	..e  do
	...s MPreNum=+$G(^TempDHCPEPreManagerRecord(Job,Type,VIP,"M","His"))
	...s FPreNum=+$G(^TempDHCPEPreManagerRecord(Job,Type,VIP,"F","His"))
	..s MaleOneInfo=MaleOneInfo_"-<font color=blue>"_MPreNum_"</font>"
	..s FemaleOneInfo=FemaleOneInfo_"-<font color=blue>"_FPreNum_"</font>"
	..i MaleOneInfo'="" s OneInfo=MaleOneInfo
	..i FemaleOneInfo'=""  do
	...i OneInfo'="" s OneInfo=OneInfo_"<br>"_FemaleOneInfo
	...e  d
	....s OneInfo=FemaleOneInfo
	
	..i PreInfo="" d
	...s PreInfo=OneInfo
	..e  d
	...s PreInfo=PreInfo_"<br>"_OneInfo
	
	s Type=""
	f  s Type=$O(^TempDHCPEPreManager(Job,Type)) q:Type=""  d
	.s GADM=""
	.f  s GADM=$O(^TempDHCPEPreManager(Job,Type,GADM)) q:GADM=""  d
	..i Type="G" d
	...s GBaseInfoID=$P(^DHCPEPreGADM(GADM),"^",1)
	...s GDesc=$P(^DHCPEPreGBI(GBaseInfoID),"^",2)
	...s GDesc="<font color=green>"_GDesc_"</font>"
	..e  d
	...s GDesc=$LG(^User.DHCPEContractD(GADM),3)
	...s GDesc="<font color=green>H-"_GDesc_"</font>"
	..s MaleNum=$G(^TempDHCPEPreManager(Job,Type,GADM,"M"))
	..s MPreNum=+$G(^TempDHCPEPreManagerRecord(Job,GADM,"M","Net"))
	..s MaleOneInfo=GDesc_"(男):"_MaleNum_"-<font color=red>"_MPreNum_"</font>"
	..s FaleNum=$G(^TempDHCPEPreManager(Job,Type,GADM,"F"))
	..s FPreNum=+$G(^TempDHCPEPreManagerRecord(Job,GADM,"F","Net"))
	..s FemaleOneInfo=GDesc_"(女):"_FaleNum_"-<font color=red>"_FPreNum_"</font>"
	..s MPreNum=+$G(^TempDHCPEPreManagerRecord(Job,GADM,"M","His"))
	..s MaleOneInfo=MaleOneInfo_"-<font color=blue>"_MPreNum_"</font>"
	..s FPreNum=+$G(^TempDHCPEPreManagerRecord(Job,GADM,"F","His"))
	..s FemaleOneInfo=FemaleOneInfo_"-<font color=blue>"_FPreNum_"</font>"
	
	..i PreInfo="" d
	...s PreInfo=MaleOneInfo_"<br>"_FemaleOneInfo
	..e  d
	...s PreInfo=PreInfo_"<br>"_MaleOneInfo_"<br>"_FemaleOneInfo
	k ^TempDHCPEPreManagerRecord
	k ^TempDHCPEPreManager
	w "<font color = red size=4pt><a href="_lnk_" target='_blank' >"_DateStr_"</a></font><br>"_PreInfo
}

/// d ##class(web.DHCPE.PreManager).OutPreItemNum("07/06/2016")
ClassMethod OutPreItemNum(Date As %String = "")
{
	//s:Date[("-") Date=$ZDH(Date,3)
	//s:Date[("/") Date=$ZDH(Date,4)
	s:Date'="" Date=##class(websys.Conversions).DateHtmlToLogical(Date)
	
	s:Date="" Date=$H
	s Job=$J
	k ^TempDHCPEPreItemNum(Job,Date)
	k ^TempDHCPEPreItem(Job,Date)
	//取体检系统中的项目数量
	s Time=""
	f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:Time=""  d
	.s IADM=0
	.f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADM)) q:IADM=""  d
	..s Status=$P(^DHCPEIADM(IADM),"^",8)
	..q:Status="CANCELPE"
	..s PIADM=$P(^DHCPEIADM(IADM),"^",4)
	..s ItemMastID=""
	..f  s ItemMastID=$O(^DHCPECTDataEx("DHCPEStationOrder","PreNum",ItemMastID)) q:ItemMastID=""  d
	...s ItemSub=0
	...f  s ItemSub=$O(^DHCPEPreIADM(0,"ItmMast",ItemMastID,PIADM,ItemSub)) q:(ItemSub="")  d
	....s ItemStat=$P(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub),"^",16)
	....q:ItemStat'="1"
	....s Num=$I(^TempDHCPEPreItemNum(Job,Date,ItemMastID))
	//取网上预约项目的数量
	s SetsID=""
	f  s SetsID=$O(^User.DHCPENetPreRecordI("DateSetsIndex",Date,SetsID)) q:SetsID=""  d
	.s SetsItemID=##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet(SetsID)
	.s SetsItemID="^"_SetsItemID_"^"
	.s NetPreID=""
	.f  s NetPreID=$O(^User.DHCPENetPreRecordI("DateSetsIndex",Date,SetsID,NetPreID)) q:NetPreID=""  d
	..s Status=$LG(^User.DHCPENetPreRecordD(NetPreID),7)
	..q:Status'="0"
	..s ItemMastID=""
	..f  s ItemMastID=$O(^DHCPECTDataEx("DHCPEStationOrder","PreNum",ItemMastID)) q:ItemMastID=""  d
	...i SetsItemID[("^"_ItemMastID_"^") d
	....s Num=$I(^TempDHCPEPreItemNum(Job,Date,ItemMastID))
	//根据站点顺序排序
	s ItemMastID=""
	f  s ItemMastID=$O(^TempDHCPEPreItemNum(Job,Date,ItemMastID)) q:ItemMastID=""  d
	.s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ItemMastID, 0))
	.s STSort=""
	.s:STRowId'="" STSort=$p(^DHCPEST(STRowId),"^",9)
	.s:STSort="" STSort="99999999"
	.s:STRowId="" STRowId="99999999"
	.s ^TempDHCPEPreItem(Job,Date,STSort,STRowId,ItemMastID)=^TempDHCPEPreItemNum(Job,Date,ItemMastID)
	//输出信息
	s ret=""
	s STSort=""
	f  s STSort=$O(^TempDHCPEPreItem(Job,Date,STSort)) q:STSort=""  d
	.s STRowId=""
	.f  s STRowId=$O(^TempDHCPEPreItem(Job,Date,STSort,STRowId)) q:STRowId=""  d
	..s ItemMastID=""
	..f  s ItemMastID=$O(^TempDHCPEPreItem(Job,Date,STSort,STRowId,ItemMastID)) q:ItemMastID=""  d
	...s ArcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ItemMastID)
	...s PreNum=^DHCPECTDataEx("DHCPEStationOrder","PreNum",ItemMastID)
	...s HadPreNum=^TempDHCPEPreItem(Job,Date,STSort,STRowId,ItemMastID)
	...s OneInfo=ArcimDesc_"^"_PreNum_"^"_HadPreNum
	...i ret="" d
	....s ret=OneInfo
	...e  d
	....s ret=ret_"%"_OneInfo
	k ^TempDHCPEPreItemNum(Job,Date)
	k ^TempDHCPEPreItem(Job,Date)
	q ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreManager","FindPreItemNum","2022-02-18")
Query FindPreItemNum(Date As %String = "", LocID As %String = "") As %Query(ROWSPEC = "TItemName:%String,TPreNum:%String,THadPreNum:%String,TPreWNum:%String")
{
}

ClassMethod FindPreItemNumExecute(ByRef qHandle As %Binary, Date As %String = "", LocID As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
	
	s:Date'="" Date=##class(websys.Conversions).DateHtmlToLogical(Date)
	s:Date="" Date=$H
	
	s Job=$J
	k ^TempDHCPEPreItemNum(Job,Date)
	k ^TempDHCPEPreItem(Job,Date)
	
	//取体检系统中的项目数量
	s Time=""
	f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:Time=""  d
	.s IADM=0
	.f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADM)) q:IADM=""  d
	..s Status=$P(^DHCPEIADM(IADM),"^",8)
	..q:Status="CANCELPE"
	..s PIADM=$P(^DHCPEIADM(IADM),"^",4)
	..s LocID=$P($g(^DHCPEPreIADM(PIADM)),"^",26) //就诊科室ID
	..s ItemSub=0
	..f  s ItemSub=$o(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub)) q:ItemSub=""  d
	...s ItemStat=$P($g(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub)),"^",16)
	...q:ItemStat'="1"
	...s ItemMastID=$P($g(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub)),"^",1)
	.../***多院区  start***/
	...s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemMastID,LocID)
    ...q:StatOrderID="" 
    ...s SOSID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderID,0))
    ...q:SOSID'="" 
    ...s PreNum=$lg($g(^CF.PE.StationOrderSetD(SOSID)),17) //限额
    ...q:PreNum=""
    .../***多院区  end***/
	...s Num=$I(^TempDHCPEPreItemNum(Job,Date,ItemMastID))
	/*
	..s ItemMastID=""
	..f  s ItemMastID=$O(^DHCPECTDataEx("DHCPEStationOrder","PreNum",ItemMastID)) q:ItemMastID=""  d
	...s ItemSub=0
	...f  s ItemSub=$O(^DHCPEPreIADM(0,"ItmMast",ItemMastID,PIADM,ItemSub)) q:(ItemSub="")  d
	....s ItemStat=$P(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub),"^",16)
	....q:ItemStat'="1"
	....s Num=$I(^TempDHCPEPreItemNum(Job,Date,ItemMastID))
	*/
	//取网上预约项目的数量
	s SetsID=""
	f  s SetsID=$O(^User.DHCPENetPreRecordI("DateSetsIndex",Date,SetsID)) q:SetsID=""  d
	.s SetsItemID=##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet(SetsID)
	.s SetsItemID="^"_SetsItemID_"^"
	.s NetPreID=""
	.f  s NetPreID=$O(^User.DHCPENetPreRecordI("DateSetsIndex",Date,SetsID,NetPreID)) q:NetPreID=""  d
	..s Status=$LG(^User.DHCPENetPreRecordD(NetPreID),7)
	..q:Status'="0"
	../***多院区  start***/
    ..s StatOrderID=""
    ..f  s StatOrderID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderID)) q:StatOrderID=""  d
    ...s ItemMastID=$p($g(^DHCPEST(+StatOrderID,"O",$p(StatOrderID,"||",2))),"^",1)
    ...s SOSID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderID,0))
    ...q:SOSID=""
    ...s PreNum=$lg($g(^CF.PE.StationOrderSetD(SOSID)),17) //限额
    ...q:PreNum=""
    ...i SetsItemID[("^"_ItemMastID_"^") d
	....s Num=$I(^TempDHCPEPreItemNum(Job,Date,ItemMastID))
    ../***多院区  end***/
    
	/*
	..s ItemMastID=""
	..f  s ItemMastID=$O(^DHCPECTDataEx("DHCPEStationOrder","PreNum",ItemMastID)) q:ItemMastID=""  d
	...i SetsItemID[("^"_ItemMastID_"^") d
	....s Num=$I(^TempDHCPEPreItemNum(Job,Date,ItemMastID))
	*/
	//根据站点顺序排序
	s ItemMastID=""
	f  s ItemMastID=$O(^TempDHCPEPreItemNum(Job,Date,ItemMastID)) q:ItemMastID=""  d
	.;s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ItemMastID, 0))
	.s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemMastID,LocID)
    .q:StatOrderID=""
    .s STRowId=$p(StatOrderID,"||",1)
	.s STSort=""
	.;s:STRowId'="" STSort=$p(^DHCPEST(STRowId),"^",9)
	./***多院区 start***/
	.s STSetID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,STRowId,0))
	.q:STSetID=""
    .s STSort=$lg($g(^CF.PE.StationSetD(STSetID)),9) //报告顺序
	./***多院区 end***/
	
	.s:STSort="" STSort="99999999"
	.;s:STRowId="" STRowId="99999999"
	.s ^TempDHCPEPreItem(Job,Date,STSort,STRowId,ItemMastID)=^TempDHCPEPreItemNum(Job,Date,ItemMastID)
	//输出信息
	s ret=""
	s STSort=""
	f  s STSort=$O(^TempDHCPEPreItem(Job,Date,STSort)) q:STSort=""  d
	.s STRowId=""
	.f  s STRowId=$O(^TempDHCPEPreItem(Job,Date,STSort,STRowId)) q:STRowId=""  d
	..s ItemMastID=""
	..f  s ItemMastID=$O(^TempDHCPEPreItem(Job,Date,STSort,STRowId,ItemMastID)) q:ItemMastID=""  d
	...s ArcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ItemMastID,"A",LocID)
	...;s PreNum=^DHCPECTDataEx("DHCPEStationOrder","PreNum",ItemMastID)
	.../***多院区  start***/
	...s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemMastID,LocID)
    ...q:StatOrderID="" 
    ...s SOSID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderID,0))
    ...s PreNum=""
    ...i SOSID'="" s PreNum=$lg($g(^CF.PE.StationOrderSetD(SOSID)),17) //限额
    .../***多院区  end***/
	...s HadPreNum=^TempDHCPEPreItem(Job,Date,STSort,STRowId,ItemMastID)
	...s OneInfo=ArcimDesc_"^"_PreNum_"^"_HadPreNum
	...i ret="" d
	....s ret=OneInfo
	...e  d
	....s ret=ret_"%"_OneInfo
	
	i ret'="" d
	.s Length=$L(ret,"%")
	.f i=1:1:Length  d
	..s OneInfo=$P(ret,"%",i)
	..s PreNum=$P(OneInfo,"^",2)
	..s TItemName=$P(OneInfo,"^",1)
	..s TPreNum=$P(PreNum,"-",1)
	..s TPreWNum=$P(PreNum,"-",2)
	..s THadPreNum=$P(OneInfo,"^",3)
	..Do OutputPreItemNum
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    	 
OutputPreItemNum
    k ^TempDHCPEPreItemNum(Job,Date)
	k ^TempDHCPEPreItem(Job,Date) 
	set Data=$lb(TItemName,TPreNum,THadPreNum,TPreWNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPreItemNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPreItemNumExecute ]
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

ClassMethod FindPreItemNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPreItemNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// creator:xy
/// creatdate:2020-9-9
/// description:判断该日期下是否有预约信息
/// d ##class(web.DHCPE.PreManager).IsExsistPreManager()
ClassMethod IsExsistPreManager(Date As %String = "", UserID As %String = "", LocID As %String = "")
{
	s flag=0
	q:Date="" flag
	
	i Date'="" s Date=##class(websys.Conversions).DateHtmlToLogical(Date)
	s VIP=""
	f  s VIP=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,VIP)) q:VIP=""  d
	.s Type=""
	.f  s Type=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,VIP,Type)) q:Type=""  d
	..s PreManagerID=""
	..f  s PreManagerID=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,VIP,Type,PreManagerID)) q:(PreManagerID="")||(flag=1)  d
	...i PreManagerID'="" s flag=1
	q flag
}

Storage Default
{
<Data name="PreManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.PreManagerD</DataLocation>
<DefaultData>PreManagerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.PreManagerD</IdLocation>
<IndexLocation>^web.DHCPE.PreManagerI</IndexLocation>
<StreamLocation>^web.DHCPE.PreManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
