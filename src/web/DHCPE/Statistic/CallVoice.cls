Class web.DHCPE.Statistic.CallVoice Extends %Persistent
{

/// Creator：      sxt
/// CreateDate：   2019-11-12
/// Description:：获取体检者真正用时
/// Table：       DHC_PE_AdmRoomRecord,  DHC_PE_AdmRecordManager,DHC_PE_IADM
/// Input：       BeginDate,EndDate
/// Output：      RegNo:登记号,Name:姓名,ArrivedTime:到达时间,RecPaperTime:收表时间,SumTime:体检总时间,CrmAdm:体检就诊号
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.CallVoice","CallVoiceStatistic","2019-11-27","2019-11-27","304")                       
Query CallVoiceStatistic(BeginDate As %Library.String = "", EndDate As %Library.String = "", CurLoc As %String = "") As %Query(ROWSPEC = "RegNo:%String,Name:%String,ArrivedTime:%String,RecPaperTime:%String,SumTime:%String,CrmAdm:%String,Now:%String") [ SqlProc ]
{
}

ClassMethod CallVoiceStatisticExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, CurLoc As %String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ((BeginDate="")&(EndDate=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i BeginDate="" s BeginDate=0
	i EndDate="" s EndDate=+$H
	s PEType="^ARRIVED^RECPAPER^"
	
	s Date=BeginDate-1
	f  s Date=$O(^User.DHCPEAdmRecordManagerI("AdmDateTypeIndex",Date)) q:(Date>EndDate)||(Date="")  d
	.s PIADM=""
	.f  s PIADM=$O(^User.DHCPEAdmRecordManagerI("AdmDateTypeIndex",Date,"ARRIVED",PIADM)) q:PIADM=""  d
	..s Status=$p(^DHCPEPreIADM(PIADM),"^",8)
	..q:Status'="ARRIVED"
	..q:(##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM,CurLoc)=1)
	..s PreIBI=$p(^DHCPEPreIADM(PIADM),"^",1)
	..s IADM=$o(^DHCPEIADM(0,"CRMADM",PIADM,0))
	..q:IADM=""
	..s PAADM=$p(^DHCPEIADM(IADM),"^",1)
	..s RegNo=$p(^DHCPEPreIBI(PreIBI),"^",1)
	..s Name=$p(^DHCPEPreIBI(PreIBI),"^",2)
	..s ArrivedTime="",RecPaperTime="",SumTime="-"
	..s ID=$o(^User.DHCPEAdmRecordManagerI("AdmTypeIndex",PIADM,"ARRIVED",""),-1)
	..i ID'="" d
	...s ArrivedDate=$lg(^User.DHCPEAdmRecordManagerD(ID),3)
	...s ArrivedTime=$lg(^User.DHCPEAdmRecordManagerD(ID),5)
	..s RecID=$o(^User.DHCPEAdmRecordManagerI("AdmTypeIndex",PIADM,"RECPAPER",""),-1)
	..i (RecID'="")&&($d(^DHCPEDataEx("ConfirmRecPaper",PIADM))) d
	...s RecPaperDate=$lg(^User.DHCPEAdmRecordManagerD(RecID),3)
	...s RecPaperTime=$lg(^User.DHCPEAdmRecordManagerD(RecID),5)
	..i (ArrivedTime'="")&&(RecPaperTime'="")&&(ArrivedDate=RecPaperDate)&&($D(^User.DHCPEAdmRoomRecordI("AdmIndex"," "_PAADM)))  d
	...s SumTime=RecPaperTime-ArrivedTime
	...s SumTime=##class(websys.Conversions).TimeLogicalToHtml(SumTime)
	...s SumTime=$p(SumTime,":",1)_"时"_$p(SumTime,":",2)_"分"_$p(SumTime,":",3)_"秒"
	..s:(ArrivedTime'="") ArrivedTime=##class(websys.Conversions).DateLogicalToHtml(ArrivedDate)_"  "_##class(websys.Conversions).TimeLogicalToHtml(ArrivedTime)
	..s:(RecPaperTime'="") RecPaperTime=##class(websys.Conversions).DateLogicalToHtml(RecPaperDate)_"  "_##class(websys.Conversions).TimeLogicalToHtml(RecPaperTime)
	..d OutVoiceStatisticInfo
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutVoiceStatisticInfo
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	set Data=$lb(RegNo,Name,ArrivedTime,RecPaperTime,SumTime,PIADM,Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CallVoiceStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CallVoiceStatisticExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	if ind=""
	{
		Set AtEnd=1
		Set Row=""		
	}
	  Else 
	{
		Set Row=^CacheTemp(repid,ind)
		}
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod CallVoiceStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CallVoiceStatisticExecute ]
{
	Set repid=$LIST(qHandle,2)
	kill ^cacheTemp(repid)
	Quit $$$OK
}

/// Creator：      sxt
/// CreateDate：   2019-11-12
/// Description:：获取体检者真正用时
/// Table：       DHC_PE_AdmRoomRecord,  DHC_PE_AdmRecordManager
/// Input：       CRMADM:DHC_PE_PreIADM 的RowID
/// Output：      RoomDesc:诊室名,BeginTime:开始时间,EndTime:结束时间,SumTime:用时
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.CallVoice","DetailStatistic","23127")                       
Query DetailStatistic(CRMADM As %Library.String = "") As %Query(ROWSPEC = "RoomDesc:%String,BeginTime:%String,EndTime:%String,SumTime:%String") [ SqlProc ]
{
}

ClassMethod DetailStatisticExecute(ByRef qHandle As %Binary, CRMADM As %String) As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^DHCPERecord("CallVoiceDetailStatistic",1)=CRMADM
 	i (CRMADM="")
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	s IADM=$o(^DHCPEIADM(0,"CRMADM",CRMADM,0))
 	i (IADM="")
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s PAADM=$p(^DHCPEIADM(IADM),"^",1)
 	i (PAADM="")
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s status=""
 	f  s status=$o(^User.DHCPEAdmRoomRecordI("AdmIndex"," "_PAADM,status)) q:(status="")  d
 	.s ID=""
 	.f  s ID=$o(^User.DHCPEAdmRoomRecordI("AdmIndex"," "_PAADM,status,ID)) q:(ID="")  d
 	..s TimeIn="",TimeOut="",TimeSum="-"
 	..s TimeIn=$zt($lg(^User.DHCPEAdmRoomRecordD(ID),4))
 	..q:(TimeIn="")
 	..s TimeOut=$zt($lg(^User.DHCPEAdmRoomRecordD(ID),5))
 	..s RoomDR=$lg(^User.DHCPEAdmRoomRecordD(ID),6)
 	..q:(RoomDR="")
 	..s RoomDesc=$lg(^User.DHCPEAreaD(+RoomDR,"ChildRoom",$p(RoomDR,"||",2)),3)
 	..i TimeOut'="" d
 	...s TimeSum=$zth(TimeOut)-$zth(TimeIn)
 	...s TimeSum=$zt(TimeSum)
 	...s TimeSum=$p(TimeSum,":",1)_"时"_$p(TimeSum,":",2)_"分"_$p(TimeSum,":",3)_"秒"
 	..d OutWorkStatisticInfoDetail
	

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWorkStatisticInfoDetail
	set Data=$lb(RoomDesc,TimeIn,TimeOut,TimeSum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod DetailStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DetailStatisticExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	if ind=""
	{
		Set AtEnd=1
		Set Row=""		
	}
	  Else 
	{
		Set Row=^CacheTemp(repid,ind)
		}
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod DetailStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DetailStatisticExecute ]
{
	Set repid=$LIST(qHandle,2)
	kill ^cacheTemp(repid)
	Quit $$$OK
}

/// Creator：      sxt
/// CreateDate：   2019-11-12
/// Description:：获取医生检查用时
/// Table：       DHC_PE_AdmRoomRecord
/// Input：       BeginDate,EndDate,UserDR:查询用户
/// Output：      DocName:医生名,DocDR:医生ID,RoomName:诊室名,RoomDR:诊室ID,PersonCount:检查人数,SumTime:总用时,AvgTime:平均用时
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.CallVoice","CallVoiceDocStatistic","2019-12-10","2019-12-31","11849","304")                       
Query CallVoiceDocStatistic(BeginDate As %Library.String = "", EndDate As %Library.String = "", CurUser As %Library.String = "", CurLoc As %Library.String = "") As %Query(ROWSPEC = "DocName:%String:医生名,DocDR:%String:医生ID,RoomName:%String:诊室名,RoomDR:%String:诊室ID,PersonCount:%String:检查人数,SumTime:%String:总用时,AvgTime:%String:平均用时,Now:%String:时间") [ SqlProc ]
{
}

ClassMethod CallVoiceDocStatisticExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", CurUser As %Library.String = "", CurLoc As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ((BeginDate="")&(EndDate=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i BeginDate="" s BeginDate=0
	i EndDate="" s EndDate=+$H
	k ^TMPDHCPECallVoiceDocStatistic(CurUser)
	
	s Date=BeginDate-1
	f  s Date=$O(^User.DHCPEAdmRoomRecordI("UserRoomIndex",Date)) q:(Date>EndDate)||(Date="")  d
	.s User=""
	.f  s User=$o(^User.DHCPEAdmRoomRecordI("UserRoomIndex",Date,User)) q:(User="")  d
	..s Room=""
	..f  s Room=$o(^User.DHCPEAdmRoomRecordI("UserRoomIndex",Date,User,Room)) q:(Room="")  d
	...s RealRoom=$tr(Room," ","")
	...s SPAADM=""
	...f  s SPAADM=$o(^User.DHCPEAdmRoomRecordI("UserRoomIndex",Date,User,Room,SPAADM)) q:(SPAADM="")  d
	....s PAADM=$tr(SPAADM," ","")
	....q:(##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM,CurLoc)=1)
	....s ID=""
	....f  s ID=$o(^User.DHCPEAdmRoomRecordI("UserRoomIndex",Date,User,Room,SPAADM,ID)) q:(ID="")  d
	.....s TimeIn="",TimeOut="",OneTimeSum="-"
 	.....s TimeIn=$zt($lg(^User.DHCPEAdmRoomRecordD(ID),4))
 	.....s TimeOut=$zt($lg(^User.DHCPEAdmRoomRecordD(ID),5))
	.....q:(TimeIn="")||(TimeOut="")
 	.....s OneTimeSum=$zth(TimeOut)-$zth(TimeIn)
 	.....s i=$i(^TMPDHCPECallVoiceDocStatistic(CurUser,"Count",User,RealRoom))
 	.....s ^TMPDHCPECallVoiceDocStatistic(CurUser,"SumTime",User,RealRoom)=$g(^TMPDHCPECallVoiceDocStatistic(CurUser,"SumTime",User,RealRoom))+OneTimeSum
 	.....
 	s User=""
 	f  s User=$o(^TMPDHCPECallVoiceDocStatistic(CurUser,"Count",User)) q:(User="")  d
 	.s UserName=$p($g(^SSU("SSUSR",User)),"^",2)
 	.s Room=""
 	.f  s Room=$o(^TMPDHCPECallVoiceDocStatistic(CurUser,"Count",User,Room)) q:(Room="")  d
 	..s SumTime=$g(^TMPDHCPECallVoiceDocStatistic(CurUser,"SumTime",User,Room))
 	..s Count=+$g(^TMPDHCPECallVoiceDocStatistic(CurUser,"Count",User,Room))
 	..q:(Count=0)
 	..s RoomDesc=$lg(^User.DHCPEAreaD(+Room,"ChildRoom",$p(Room,"||",2)),3)
 	..s Day=SumTime/86400
 	..s AvgTime=$fn(SumTime/Count,"",0)
 	..s AvgTime=$zt(AvgTime)
 	..s DayDesc=$p(Day,".",1)
 	..s Time=SumTime#86400
 	..s TimeDesc=$zt(Time)
 	..i (DayDesc'="")&&(DayDesc'=0) d
 	...s SumTime=DayDesc_"天"_TimeDesc
 	..e  d
 	...s SumTime=TimeDesc
 	..d OutWorkStatisticCallVoiceDoc
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWorkStatisticCallVoiceDoc
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	set Data=$lb(UserName,User,RoomDesc,Room,Count,SumTime,AvgTime,Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CallVoiceDocStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CallVoiceDocStatisticExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	if ind=""
	{
		Set AtEnd=1
		Set Row=""		
	}
	  Else 
	{
		Set Row=^CacheTemp(repid,ind)
		}
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod CallVoiceDocStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CallVoiceDocStatisticExecute ]
{
	Set repid=$LIST(qHandle,2)
	kill ^cacheTemp(repid)
	Quit $$$OK
}

/// Creator：      sxt
/// CreateDate：   2019-11-12
/// Description:：获取医生检查用时
/// Table：       DHC_PE_AdmRoomRecord
/// Input：       BeginDate,EndDate,DocDR:医生ID,RoomDR:诊室ID,RoomDesc:诊室名,DocName:医生名
/// Output：      RegNo:姓名,Name:姓名，TimeIn:开始时间,TimeOut:结束时间,OneTimeSum:用时
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.CallVoice","CallVoiceDocDetail","2019-11-12","2019-11-13",923,"1||1","3楼内科","体检前台")                       
Query CallVoiceDocDetail(BeginDate As %Library.String = "", EndDate As %Library.String = "", DocDR As %Library.String = "", RoomDR As %Library.String = "", CurLoc As %Library.String = "") As %Query(ROWSPEC = "RegNo:%String,Name:%String,TimeIn:%String,TimeOut:%String,OneTimeSum:%String,UserName:%String,RoomDesc:%String") [ SqlProc ]
{
}

ClassMethod CallVoiceDocDetailExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", DocDR As %Library.String = "", RoomDR As %Library.String = "", CurLoc As %Library.String = "") As %Status
{
 
 	s ^DHCPETEST("CallVoiceDocDetail")=BeginDate_"^"_EndDate_"^"_DocDR_"^"_RoomDR_"^"_CurLoc
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ((BeginDate="")&(EndDate=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i BeginDate="" s BeginDate=+$H-30
	i EndDate="" s EndDate=+$H
	
	s Date=BeginDate-1
	f  s Date=$O(^User.DHCPEAdmRoomRecordI("UserRoomIndex",Date)) q:(Date>EndDate)||(Date="")  d
	.s User=""
	.f  s User=$o(^User.DHCPEAdmRoomRecordI("UserRoomIndex",Date,User)) q:(User="")  d
	..q:(DocDR'=User)
	..s UserName=$p($g(^SSU("SSUSR",User)),"^",2)
	..s Room=""
	..f  s Room=$o(^User.DHCPEAdmRoomRecordI("UserRoomIndex",Date,User,Room)) q:(Room="")  d
	...s RealRoom=$tr(Room," ","")
	...q:(RoomDR'=RealRoom)
	...s RoomDesc=$lg(^User.DHCPEAreaD(+RealRoom,"ChildRoom",$p(RealRoom,"||",2)),3)
	...s SPAADM=""
	...f  s SPAADM=$o(^User.DHCPEAdmRoomRecordI("UserRoomIndex",Date,User,Room,SPAADM)) q:(SPAADM="")  d
	....s PAADM=$tr(SPAADM," ","")
	....q:(##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM,CurLoc)=1)
	....s BaseInfo=##class(web.DHCPE.Statistic.WorkStatistic).GetBaseInfo("PAADM",PAADM)
	....s Reg=$p(BaseInfo,"^",1)
	....s Name=$p(BaseInfo,"^",2)
	....s ID=""
	....f  s ID=$o(^User.DHCPEAdmRoomRecordI("UserRoomIndex",Date,User,Room,SPAADM,ID)) q:(ID="")  d
	.....s TimeIn="",TimeOut="",OneTimeSum="-"
	.....s TimeIn=$zt($lg(^User.DHCPEAdmRoomRecordD(ID),4))
 	.....s TimeOut=$zt($lg(^User.DHCPEAdmRoomRecordD(ID),5))
	.....q:(TimeIn="")||(TimeOut="")
	.....s OneTimeSum=$zth(TimeOut)-$zth(TimeIn)
 	.....s OneTimeSum=$zt(OneTimeSum)
 	.....d StatisticCallVoiceDocDetail
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
StatisticCallVoiceDocDetail
	set Data=$lb(Reg,Name,TimeIn,TimeOut,OneTimeSum,UserName,RoomDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CallVoiceDocDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CallVoiceDocDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	if ind=""
	{
		Set AtEnd=1
		Set Row=""		
	}
	  Else 
	{
		Set Row=^CacheTemp(repid,ind)
		}
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod CallVoiceDocDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CallVoiceDocDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	kill ^cacheTemp(repid)
	Quit $$$OK
}

Storage Default
{
<Data name="CallVoiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.Statistic.CallVoiceD</DataLocation>
<DefaultData>CallVoiceDefaultData</DefaultData>
<IdLocation>^web.DHCPE.Statistic.CallVoiceD</IdLocation>
<IndexLocation>^web.DHCPE.Statistic.CallVoiceI</IndexLocation>
<StreamLocation>^web.DHCPE.Statistic.CallVoiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
