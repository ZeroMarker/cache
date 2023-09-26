Class web.DHCPE.NetPre.PreFind Extends %Persistent
{

Query SerchPreInfo(StartDate As %String = "", EndDate As %String = "", VIPLevel As %String = "", LocID As %String = "", UserID As %String = "", CSPName As %String = "") As %Query(ROWSPEC = "TDate:%String,TPreTime:%String,TNetINum:%String,THisINum:%String,THisGNum:%String,TVIPID:%String,TVIPDesc:%String,TTemplateNum:%String,TNetToHisNum:%String")
{
}

ClassMethod SerchPreInfoExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", VIPLevel As %String = "", LocID As %String = "", UserID As %String = "", CSPName As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i (StartDate="")&&(EndDate="") 
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	i StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate) 
 	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
 	i StartDate="" s StartDate=1
 	i EndDate="" s EndDate=+$H+10
 	
 	s Job=UserID
 	
 	k ^TempDHCPEPreInfoFind(Job)
 	s Date=StartDate-1
 	f  s Date=$O(^DHCPEPreIADM(0,"BookDateTime",Date)) q:(Date="")||(Date>EndDate)  d
 	.s Date2="" 
 	.f  s Date2=$O(^DHCPEPreIADM(0,"BookDateTime",Date,Date2)) q:(Date2="")  d
 	..s Time=""
 	..f  s Time=$O(^DHCPEPreIADM(0,"BookDateTime",Date,Date2,Time)) q:(Time="")  d
	...s ID=""
	...f  s ID=$O(^DHCPEPreIADM(0,"BookDateTime",Date,Date2,Time,ID)) q:ID=""  d
	....s Status=$P($g(^DHCPEPreIADM(ID)),"^",8)
	....q:Status="CANCELPE"
	....s ReCheckFlag=$P($g(^DHCPEPreIADM(ID)),"^",28)  
	....q:ReCheckFlag'="N"
	....s CurLoc=$P($g(^DHCPEPreIADM(ID)),"^",26)
	....q:CurLoc'=LocID
	....s CurVIP=$P($g(^DHCPEPreIADM(ID)),"^",18)
	....q:(CurVIP'=VIPLevel)&&(VIPLevel'="")
	....q:CurVIP=""
	....s GID=$P($g(^DHCPEPreIADM(ID)),"^",2)
	....s:GID="" GIType="I"
	....s:GID'="" GIType="G"
	....s PreNumID=##class(web.DHCPE.PreTemplate).GetRecordID(LocID,Date,CurVIP,GIType)
	....;q:PreNumID=""
	....s TimeInfo=##class(web.DHCPE.NetPre.GetPreInfo).GetTimeInfo(PreNumID,Time)
	....s RecordNum=$P(TimeInfo,"^",2)
	....s TimeInfo=$P(TimeInfo,"^",1)
	....s:TimeInfo="" TimeInfo="无时段"
	....s ^TempDHCPEPreInfoFind(Job,Date,TimeInfo,CurVIP,"RecordNum")=RecordNum
	....s i=$I(^TempDHCPEPreInfoFind(Job,Date,TimeInfo,CurVIP,GIType))
	....;s ^TempDHCPEPreInfoFind(Job,Date,TimeInfo,CurVIP,GIType,ID)=""
	....;s ^TempDHCPEPreInfoFind(Job,Date,TimeInfo,CurVIP,GIType,ID)=$zd(Date,3)_"("_..GetWeekDesc($zd(Date,3))_") "_TimeInfo
	....s ^TempDHCPEPreInfoFind(Job,Date,TimeInfo,CurVIP,GIType,ID)=##class(websys.Conversions).DateLogicalToHtml(Date)_"("_..GetWeekDesc(Date,CSPName)_") "  //_TimeInfo
	....;s HisNum=HisNum+1
 	
 	
 	s Date=StartDate-1
 	f  s Date=$O(^User.DHCPENetPreRecordI("PreDateIndex", Date)) q:(Date="")||(Date>EndDate)  d
 	.s ID=0
	.f  s ID=$O(^User.DHCPENetPreRecordI("PreDateIndex", Date,ID)) q:ID=""  d
	..s PaiedFlag=$LG(^User.DHCPENetPreRecordD(ID),15)
	..q:PaiedFlag="1"
	..q:PaiedFlag="3"
	..s Status=$LG(^User.DHCPENetPreRecordD(ID),7)
	..;q:(Status'=0)&&(Status'=1)
	..q:((Status=6)||(Status=2))
	..s CurLoc=$LG(^User.DHCPENetPreRecordD(ID),17)
	..q:CurLoc'=LocID
	..s CurVIP=$LG(^User.DHCPENetPreRecordD(ID),16)
	..;s CurVIP=##class(web.DHCPE.VIPLevel).GetVIPIDByDesc(CurVIP)
	..s CurVIP=##class(web.DHCPE.CT.HISUICommon).GetVIPIDByDesc(CurVIP)
	..q:(CurVIP'=VIPLevel)&&(VIPLevel'="")
	..s PreTime=$LG(^User.DHCPENetPreRecordD(ID),18)
	..s GIType="I"
	..s PreNumID=##class(web.DHCPE.PreTemplate).GetRecordID(LocID,Date,CurVIP,GIType)
	..;q:PreNumID=""
	..s TimeInfo=##class(web.DHCPE.NetPre.GetPreInfo).GetTimeInfo(PreNumID,PreTime)
	..s RecordNum=$P(TimeInfo,"^",2)
	..s TimeInfo=$P(TimeInfo,"^",1)
	..s:TimeInfo="" TimeInfo="无时段"
	..s ^TempDHCPEPreInfoFind(Job,Date,TimeInfo,CurVIP,"RecordNum")=RecordNum
	..s:Status=0 i=$I(^TempDHCPEPreInfoFind(Job,Date,TimeInfo,CurVIP,"NetNum"))
	..;s:Status=0 ^TempDHCPEPreInfoFind(Job,Date,TimeInfo,CurVIP,"NetNum",ID)=""
	..;s:Status=0 ^TempDHCPEPreInfoFind(Job,Date,TimeInfo,CurVIP,"NetNum",ID)=$zd(Date,3)_"("_..GetWeekDesc($zd(Date,3))_") "_TimeInfo
	..s:Status=0 ^TempDHCPEPreInfoFind(Job,Date,TimeInfo,CurVIP,"NetNum",ID)=##class(websys.Conversions).DateLogicalToHtml(Date)_"("_..GetWeekDesc(Date,CSPName)_") "   //_TimeInfo 
	..s:Status'=0 j=$I(^TempDHCPEPreInfoFind(Job,Date,TimeInfo,CurVIP,"NetToHisNum"))
	..;s:Status'=0 ^TempDHCPEPreInfoFind(Job,Date,TimeInfo,CurVIP,"NetToHisNum",ID)=""
	..;s:Status'=0 ^TempDHCPEPreInfoFind(Job,Date,TimeInfo,CurVIP,"NetToHisNum",ID)=$zd(Date,3)_"("_..GetWeekDesc($zd(Date,3))_") "_TimeInfo
	..s:Status'=0 ^TempDHCPEPreInfoFind(Job,Date,TimeInfo,CurVIP,"NetToHisNum",ID)=##class(websys.Conversions).DateLogicalToHtml(Date)_"("_..GetWeekDesc(Date,CSPName)_") "  //_TimeInfo

	s (NetINum,NetToHisNum,HisINum,HisGNum,TemplateNum)=0
	s Date=""
	f  s Date=$O(^TempDHCPEPreInfoFind(Job,Date)) q:Date=""  d
	.;s TDate=$ZD(Date,3)
	.s TDate=##class(websys.Conversions).DateLogicalToHtml(Date) 
	.s WeekDesc=..GetWeekDesc(Date,CSPName)
	.s TDate=TDate_"("_WeekDesc_")"
	.s TPreTime=""
	.f  s TPreTime=$O(^TempDHCPEPreInfoFind(Job,Date,TPreTime)) q:TPreTime=""  d
	..s VIPID=""
	..f  s VIPID=$O(^TempDHCPEPreInfoFind(Job,Date,TPreTime,VIPID)) q:VIPID=""  d
	...;s TVIPDesc=$P(^DHCPEVIPLevel("VIP",VIPID),"^",2)
	...s TVIPDesc=$lg($g(^CT.PE.VIPLevelD(VIPID)),3) //VIP描述（多院区）
 	...s TNetINum=$G(^TempDHCPEPreInfoFind(Job,Date,TPreTime,VIPID,"NetNum"))
 	...s NetINum=NetINum+TNetINum
 	...s TNetToHisNum=$G(^TempDHCPEPreInfoFind(Job,Date,TPreTime,VIPID,"NetToHisNum"))
 	...s NetToHisNum=NetToHisNum+TNetToHisNum
 	...s THisINum=$G(^TempDHCPEPreInfoFind(Job,Date,TPreTime,VIPID,"I"))
 	...s HisINum=HisINum+THisINum
 	...s THisGNum=$G(^TempDHCPEPreInfoFind(Job,Date,TPreTime,VIPID,"G"))
 	...s HisGNum=HisGNum+THisGNum
 	...s TTemplateNum=$G(^TempDHCPEPreInfoFind(Job,Date,TPreTime,VIPID,"RecordNum"))
 	...s TemplateNum=TemplateNum+TTemplateNum
 	...d FindBuild
 	s (TDate,TPreTime,TVIPDesc)=""
 	s TNetINum=NetINum
 	s THisINum=HisINum
 	s THisGNum=HisGNum
 	s TTemplateNum=TemplateNum
 	s TNetToHisNum=NetToHisNum
 	i TTemplateNum=0 s TTemplateNum=""
 	i TNetINum=0 s TNetINum=""
 	i THisINum=0 s THisINum=""
 	i THisGNum=0 s THisGNum=""
 	i TNetToHisNum=0 s TNetToHisNum=""
 	s TPreTime="合计"
 	d FindBuild

 	;k ^TempDHCPEPreInfoFind(Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

FindBuild 
	/***翻译 start***/
    i $d(TVIPDesc) set TVIPDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",TVIPDesc,"VLDesc","cls")
    i ((CSPName'="")&&(TPreTime'="")) set TPreTimeEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,TPreTime)
    /***翻译 close***/     
	set Data=$lb(TDate,TPreTimeEng,TNetINum,THisINum,THisGNum,VIPID,TVIPDesc,TTemplateNum,TNetToHisNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SerchPreInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchPreInfoExecute ]
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
 	// , PatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String, CONTEXT As %String
 	// Save QHandlePatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

ClassMethod SerchPreInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchPreInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

/// debug:d ##class(%ResultSet).RunQuery("web.DHCPE.NetPre.PreFind","SerchPreDetail","2022-03-03(周四)","I","无时段","1")
Query SerchPreDetail(DateInfo As %String = "", DetailType As %String = "", TimeInfo As %String = "", VIPDesc As %String = "") As %Query(ROWSPEC = "TName:%String,TSex:%String,TAge:%String,TIDCard:%String,TTel:%String,TOrdEnt:%String,TDatetime:%String,TPACCardType:%String")
{
}

ClassMethod SerchPreDetailExecute(ByRef qHandle As %Binary, DateInfo As %String = "", DetailType As %String = "", TimeInfo As %String = "", VIPDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Job=%session.Get("LOGON.USERID")
 	;s ^TempDHCPEPreInfoFind(Job,Date,TimeInfo,CurVIP,GIType,ID)=""
	s DateInfo=%request.Get("DateInfo")
	s DateInfo=$P(DateInfo,"(",1)
	s CurDate=""
	s:DateInfo'="" CurDate=##class(websys.Conversions).DateHtmlToLogical(DateInfo)
	s TimeInfo=%request.Get("TimeInfo")
	s:TimeInfo="合计" TimeInfo=""
	//s VIPDesc=##class(web.DHCPE.VIPLevel).GetVIPIDByDesc(VIPDesc)
	s Date=""
	f  s Date=$O(^TempDHCPEPreInfoFind(Job,Date)) q:Date=""  d
	.q:(CurDate'="")&&(Date'=CurDate)
	.s TimeIndex=""
	.f  s TimeIndex=$O(^TempDHCPEPreInfoFind(Job,Date,TimeIndex)) q:TimeIndex=""  d
	..q:(TimeInfo'="")&&(TimeInfo'=TimeIndex)
	..s VIPDescIndex=""
	..f  s VIPDescIndex=$O(^TempDHCPEPreInfoFind(Job,Date,TimeIndex,VIPDescIndex)) q:VIPDescIndex=""  d
	...q:(VIPDesc'="")&&(VIPDesc'=VIPDescIndex)
	...s DetailTypeIndex=""
	...f  s DetailTypeIndex=$O(^TempDHCPEPreInfoFind(Job,Date,TimeIndex,VIPDescIndex,DetailTypeIndex)) q:DetailTypeIndex=""  d
	....q:(DetailType'="")&&(DetailType'=DetailTypeIndex)
	....s ID=""
	....f  s ID=$O(^TempDHCPEPreInfoFind(Job,Date,TimeIndex,VIPDescIndex,DetailTypeIndex,ID)) q:ID=""  d
	.....i DetailTypeIndex[("Net") d
	......s Info=^User.DHCPENetPreRecordD(ID)
	......s TOrdEnt=$LG(Info,8)
	......i TOrdEnt'="" s TOrdEnt=$P($g(^ARCOS(TOrdEnt)),"^",2)
	......s TName=$LG(Info,3)
	......s TSex=$LG(Info,4)
	......s:TSex'="" TSex=$P(^CT("SEX",TSex),"^",2)
	......;s TAge=$LG(Info,5)
	......s dob=$LG(Info,26)
	......i dob'="" s dob=##class(websys.Conversions).DateLogicalToHtml(dob)
	......s TAge=##class(web.DHCDocCommon).GetAgeDescNew(dob,"")
	......s TIDCard=$LG(Info,6)
	......s PACCardCode=$LG(Info,21)
	......s PACCardType=""
	......i PACCardCode'="" d
	.......s PACCardID=$o(^PAC("CARD",0,"Code",PACCardCode,0))
	.......s PACCardType=$p($g(^PAC("CARD",PACCardID)),"^",2)

	......s TTel=$LG(Info,19)
	......;s TDatetime=DateInfo_" "_TimeInfo   //wbg20140526
	......s TDatetime=$g(^TempDHCPEPreInfoFind(Job,Date,TimeIndex,VIPDescIndex,DetailTypeIndex,ID))
	......d FindBuild
	.....e  d
	......s BaseID=$P(^DHCPEPreIADM(ID),"^",1)
	......;s TOrdEnt=##class(web.DHCPE.PreIADM).GetOrdEntByPIAdm(ID)
	......S TOrdEnt=##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(ID)
	......s Info=^DHCPEPreIBI(BaseID)
	......s TName=$P(Info,"^",2)
	......s TSex=$P(Info,"^",3)
	......s:TSex'="" TSex=$P(^CT("SEX",TSex),"^",2)
	......s TAge=$P(Info,"^",4)
	......;s:TAge'="" TAge=$P(##class(web.DHCLCNUREXCUTE).CalAge(TAge,+$H),"Y",1)
	......s:TAge'="" TAge=##class(web.DHCDocCommon).GetAgeDescNew($zd(TAge,3),"")
	......s TIDCard=$P(Info,"^",9)
	......S PACCardType=""
	......S PACCardID=$P($G(^PAPER($o(^PAPERi("PAPMI_PatNo",$P(Info,"^",1),0)),"PAT",3)),"^",7)
	......I PACCardID'=""  S PACCardType=$p($g(^PAC("CARD",PACCardID)),"^",2)
	......s TTel=$P(Info,"^",8)
	......;s TDatetime=DateInfo_" "_TimeInfo  //wbg20140526
	......s TDatetime=$g(^TempDHCPEPreInfoFind(Job,Date,TimeIndex,VIPDescIndex,DetailTypeIndex,ID))
	......d FindBuild
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

FindBuild   
   	/***翻译 start***/
	set TSex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",TSex,"CTSEXDesc","cls")
	set PACCardType=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCCredType",PACCardType,"CRTDesc","cls")
	/***翻译 end***/
	set Data=$lb(TName,TSex,TAge,TIDCard,TTel,TOrdEnt,TDatetime,PACCardType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SerchPreDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchPreDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

ClassMethod SerchPreDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchPreDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod GetWeekDesc(Date, CSPName As %String = "")
{
	s WeekNum=$ZD(Date,10)
	s WeekDesc=""
	s:WeekNum=1 WeekDesc="周一"
	s:WeekNum=2 WeekDesc="周二"
	s:WeekNum=3 WeekDesc="周三"
	s:WeekNum=4 WeekDesc="周四"
	s:WeekNum=5 WeekDesc="周五"
	s:WeekNum=6 WeekDesc="周六"
	s:WeekNum=0 WeekDesc="周日"
	i ((CSPName'="")&&(WeekDesc'="")) set WeekDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,WeekDesc)
	q WeekDesc
}

ClassMethod SendPreMessageTask()
{
	;d ##class(web.DHCPE.NetPre.PreFind).SendPreMessageTask()
	s Date=+$H+1
	d ##class(web.DHCPE.NetPre.PreFind).SendPreMessage(Date,53)
}

ClassMethod SendPreMessage(Date, LocID)
{
	;d ##class(web.DHCPE.NetPre.PreFind).SendPreMessage(63250,53)
	//s MessageTemplate="[Name]您好,请与"_$ZD(Date,3)_"，[TimeInfo]携带有效证件来协和医院体检中心体检"
	//s MessageTemplate="[Name]您好,您已成功预约[TimeInfo]到北京协和医院健康医学部（东院区）体检,为了您体检的真实准确，请您认真阅读体检注意事项并携带有效证件按约定时间到协和医院健康医学部（东院区）办理手续 。感谢您对北京协和医院健康医学部的信任与支持。祝您健康！咨询电话：69159883"
	s MessageTemplate="[Name]您好,您已成功预约[TimeInfo]到北京协和医院健康医学部（东院区）体检,为了确保您的检查结果准确，请您认真阅读体检注意事项并携带有效证件按约定时间到协和医院健康医学部（东院区）办理手续 。感谢您对北京协和医院健康医学部的信任与支持。祝您健康！咨询电话：69159883"

	s DateStr=$ZD(Date,3)
	
	s Date2="" 
 	f  s Date2=$O(^DHCPEPreIADM(0,"BookDateTime",Date,Date2)) q:(Date2="")  d
 	.s Time=""
 	.f  s Time=$O(^DHCPEPreIADM(0,"BookDateTime",Date,Date2,Time)) q:(Time="")  d
	..s ID=""
	..f  s ID=$O(^DHCPEPreIADM(0,"BookDateTime",Date,Date2,Time,ID)) q:ID=""  d
	...s Status=$P(^DHCPEPreIADM(ID),"^",8)
	...q:(Status="CANCELPE")||(Status="ARRIVED")
	...s CurLoc=$P(^DHCPEPreIADM(ID),"^",26)
	...q:CurLoc'=LocID
	...s CurVIP=$P(^DHCPEPreIADM(ID),"^",18)
	...s GID=$P(^DHCPEPreIADM(ID),"^",2)
	...s:GID="" GIType="I"
	...s:GID'="" GIType="G"
	...s PreNumID=##class(web.DHCPE.PreTemplate).GetRecordID(LocID,Date,CurVIP,GIType)
	...;q:PreNumID=""
	...s TimeInfo=##class(web.DHCPE.NetPre.GetPreInfo).GetTimeInfo(PreNumID,Time)
	...s RecordNum=$P(TimeInfo,"^",2)
	...s TimeInfo=$P(TimeInfo,"^",1)
	...s:TimeInfo'="" TimeInfo=$P(TimeInfo,"-",1) ;_"之间"
	...s BaseID=$P(^DHCPEPreIADM(ID),"^",1)
	...s Info=^DHCPEPreIBI(BaseID)
	...s Name=$P(Info,"^",2)
	...s Tel=$P(Info,"^",8)
	...s:Tel="" Tel=$P(Info,"^",6)
	...s:Tel="" Tel=$P(Info,"^",7)
	...s RegNo=$P(Info,"^",1)
	...s Sex=$P(Info,"^",3)
	...s:Sex'="" Sex=$P(^CT("SEX",Sex),"^",2)
	...s MessageType="HisPre"
	...;d SendMessage
	s ID=0
	f  s ID=$O(^User.DHCPENetPreRecordI("PreDateIndex", Date,ID)) q:ID=""  d
	.s PaiedFlag=$LG(^User.DHCPENetPreRecordD(ID),15)
	.q:PaiedFlag="1"
	.s Status=$LG(^User.DHCPENetPreRecordD(ID),7)
	.q:(Status'=0)
	.s CurLoc=$LG(^User.DHCPENetPreRecordD(ID),17)
	.q:CurLoc'=LocID
	.s CurVIP=$LG(^User.DHCPENetPreRecordD(ID),16)
	.s CurVIP=##class(web.DHCPE.VIPLevel).GetVIPIDByDesc(CurVIP)
	.s PreTime=$LG(^User.DHCPENetPreRecordD(ID),18)
	.s GIType="I"
	.s PreNumID=##class(web.DHCPE.PreTemplate).GetRecordID(LocID,Date,CurVIP,GIType)
	.;q:PreNumID=""
	.s TimeInfo=##class(web.DHCPE.NetPre.GetPreInfo).GetTimeInfo(PreNumID,PreTime)
	.s RecordNum=$P(TimeInfo,"^",2)
	.s TimeInfo=$P(TimeInfo,"^",1)
	.s:TimeInfo'="" TimeInfo=$P(TimeInfo,"-",1) ;_"之间"
	.s Name=$LG(^User.DHCPENetPreRecordD(ID),3)
	.s Tel=$LG(^User.DHCPENetPreRecordD(ID),19)
	.s RegNo=$LG(^User.DHCPENetPreRecordD(ID),2)
	.s Sex=$LG(^User.DHCPENetPreRecordD(ID),4)
	.s:Sex'="" Sex=$P(^CT("SEX",Sex),"^",2)
	.s MessageType="NetPre"
	.d SendMessage
	q
SendMessage
	//s Message=##class(web.DHCPE.Public.Setting).Replace(MessageTemplate,"[Name]",Name)
	//2014年3月4日上午8.30-9：00
	s CurDateStr=$P(DateStr,"-",1)_"年"_$P(DateStr,"-",2)_"月"_$P(DateStr,"-",3)_"日"_TimeInfo
	s Message=##class(web.DHCPE.Public.Setting).Replace(MessageTemplate,"[TimeInfo]",CurDateStr)
	s InfoStr=RegNo_"^"_Tel_"^"_Message_"^"_MessageType_"^"_+$H_"^"_""_"^"_ID_"^"
	s ExpStr=Name_"^"_Sex
	d ##class(web.DHCPE.Message.Main).SaveSendMessage(InfoStr,ExpStr)
	;InfoStr  RegNo^Telephone^Content^Type^ExpectSendDate^UserID^SourceID^SendMessageID
	;ExpStr Name^性别
	
	
	q
}

Storage Default
{
<Data name="PreFindDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.NetPre.PreFindD</DataLocation>
<DefaultData>PreFindDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.NetPre.PreFindD</IdLocation>
<IndexLocation>^web.DHCPE.NetPre.PreFindI</IndexLocation>
<StreamLocation>^web.DHCPE.NetPre.PreFindS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
