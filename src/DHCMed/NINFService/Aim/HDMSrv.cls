Class DHCMed.NINFService.Aim.HDMSrv Extends (%RegisteredObject, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.HDMSrv","QueryHDMByCR","2011-4-5","2012-5-29")
Query QueryHDMByCR(DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "RepCtloc:%String,TotalInf:%String,UricInfRate:%String,AVPipeRate:%String,TrachealCutRate:%String,BrethMachineRate:%String")
{
}

ClassMethod QueryHDMByCRExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String) As %Status
{
 
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 
 	Set:DateFrom["-" DateFrom=$zdh(DateFrom, 3)         //日期格式转换
	Set:DateTo["-" DateTo=$zdh(DateTo, 3)
 
	Set:DateFrom["/" DateFrom=$zdh(DateFrom, 4)
	Set:DateTo["/" DateTo=$zdh(DateTo, 4)
   
    k ^CACHETMP("QueryHDMByCR")
 	set preturn=""
 	s sDate=DateFrom-1
 	 
 	for  set sDate=$o(^DHCMed.CR.ReportI("DateLoc",sDate)) q:((sDate="")||(sDate>DateTo))  d      ///通过索引遍历找到
 	.set RepCtloc=""
 	.for  set RepCtloc=$o(^DHCMed.CR.ReportI("DateLoc",sDate,RepCtloc)) q:RepCtloc=""  d
 	..s rowid=""
 	..for  set rowid=$o(^DHCMed.CR.ReportI("DateLoc",sDate,RepCtloc,rowid)) q:rowid=""  d
 	...set ^CACHETMP("QueryHDMByCR",RepCtloc,rowid)=""
 	
 	
 	set TotalInf="0"                 //某科室医院感染总人数
 	set TotalUricInf="0"             //某科室泌尿道感染总人数
    set TotalAVInf="0"               //某科室动静脉感染总人数
 	set TotalTrachealCutInf="0"      //某科室气管切开肺部感染总人数
 	set TotalBrethMachineInf="0"     //某科室呼吸机肺部感染总人数
 	set UricRate="0"
 	set AVRate="0"
 	set TrachealCutRate="0"
 	set BrethMachineRate="0"
 	set HosInfNum="0"
 	
 	set tTotalInf="0"                 
 	set tTotalUricInf="0"             
    set tTotalAVInf="0"      
 	set tTotalTrachealCutInf="0"  
 	set tTotalBrethMachineInf="0"
 	set tUricRate="0"
 	set tAVRate="0"
 	set tTrachealCutRate="0"
 	set tBrethMachineRate="0"
 	set tHosInfNum="0"
 	
 	set Ctloc=""
 	set RepCtloc=""
 	f  set RepCtloc=$o(^CACHETMP("QueryHDMByCR",RepCtloc)) q:RepCtloc=""  d
 	.f  s rowid=$o(^CACHETMP("QueryHDMByCR",RepCtloc,rowid)) q:rowid=""  d
	..s obj=##class(DHCMed.CR.Report).%OpenId(rowid)
	..q:'$IsObject(obj)
	..set EpisodeID=""
	..b //001
	..set EpisodeID=obj.EpisodeID
	..b //002
	..set CtLocDR=$p(^PAADM(EpisodeID),"^",4)
	..b //003
	..quit:CtLocDR=""
	..set HDMRowid=$o(^DHCMed.NINF.Aim.HDMI("CRReportDR"," "_rowid,""),-1)
	..set preturn=##class(DHCMed.NINF.Aim.HDM).GetObjById(HDMRowid)
	..q:'$IsObject(preturn) 
	..if ((preturn.IfInfection="存在")&(preturn.InfType="医院感染")) d
	...set HosInfNum=$i(^CACHETMP("QueryHDMByCR",CtLocDR,"HosInfNum"))
	..set InfType=preturn.InfType
	..set IfInfection=preturn.IfInfection
	..set HosInfPos=preturn.HosInfPos
	..set UricPipe=preturn.UricPipe
	..set AVPipe=preturn.AVPipe
	..set TrachealCut=preturn.TrachealCut
	..set BrethMachine=preturn.BrethMachine 
	..q:IfInfection'="存在"
	..q:InfType'="医院感染"
	..if ((HosInfPos["泌尿道")&(UricPipe="有")) d
	...s tmpUricPipe=$i(^CACHETMP("QueryHDMByCR",CtLocDR,"HDM","UricNum"))
	..if ((HosInfPos["动静脉")&(AVPipe="有")) d
	...set tmpAVPipe=$i(^CACHETMP("QueryHDMByCR",CtLocDR,"HDM","AVNum")) 
	..if ((HosInfPos["呼吸道")&(TrachealCut="有")) d
	...set tmpTrachealCut=$i(^CACHETMP("QueryHDMByCR",CtLocDR,"HDM","TrachealCutNum"))
	..if ((HosInfPos["呼吸道")&(BrethMachine="有")) d
	...set tmpBrethMachine=$i(^CACHETMP("QueryHDMByCR",CtLocDR,"HDM","BrethMachineNum"))
	
	s RepCtloc="1"
	for  set RepCtloc=$o(^CACHETMP("QueryHDMByCR",RepCtloc)) Quit:RepCtloc=""  d
	.set TotalInf=$g(^CACHETMP("QueryHDMByCR",RepCtloc,"HosInfNum"))
	.set TotalUricInf=$g(^CACHETMP("QueryHDMByCR",RepCtloc,"HDM","UricNum"))
	.set TotalAVInf=$g(^CACHETMP("QueryHDMByCR",RepCtloc,"HDM","AVNum"))
	.set TotalTrachealCutInf=$g(^CACHETMP("QueryHDMByCR",RepCtloc,"HDM","TrachealCutNum"))
	.set TotalBrethMachineInf=$g(^CACHETMP("QueryHDMByCR",RepCtloc,"HDM","BrethMachineNum"))
	.set:((TotalUricInf>0)&(TotalInf>0)) UricRate=$fn((TotalUricInf)/TotalInf*100,"",2)_"%" 
    .set:((TotalAVInf>0)&(TotalInf>0)) AVRate=$fn((TotalAVInf)/TotalInf*100,"",2)_"%"
    .set:((TotalTrachealCutInf>0)&(TotalInf>0)) TrachealCutRate=$fn((TotalTrachealCutInf)/TotalInf*100,"",2)_"%"
    .set:((TotalBrethMachineInf>0)&(TotalInf>0)) BrethMachineRate=$fn((TotalBrethMachineInf)/TotalInf*100,"",2)_"%"
	.set tTotalInf=tTotalInf+TotalInf
	.set tTotalUricInf=tTotalUricInf+TotalUricInf
	.set tTotalAVInf=tTotalAVInf+TotalAVInf
	.set tTotalTrachealCutInf=tTotalTrachealCutInf+TotalTrachealCutInf
	.set tTotalBrethMachineInf=tTotalBrethMachineInf+TotalBrethMachineInf	
	.set RepCtlocDesc=""
	.if +RepCtloc'=0 d
	..s LocObj=##class(DHCMed.Base.Ctloc).GetObjById(+RepCtloc)
	..q:'$IsObject(LocObj)
	..s RepCtlocDesc=LocObj.Descs
	..s:RepCtlocDesc["-" RepCtlocDesc=$p(RepCtlocDesc,"-",2)
	.q:RepCtlocDesc=""
	.set $li(data,1)=RepCtlocDesc
	.set $li(data,2)=TotalInf
	.set $li(data,3)=+TotalUricInf_"/"_UricRate
	.set $li(data,4)=+TotalAVInf_"/"_AVRate
	.set $li(data,5)=+TotalTrachealCutInf_"/"_TrachealCutRate
	.set $li(data,6)=+TotalBrethMachineInf_"/"_BrethMachineRate
	.set ^CacheTemp(repid,ind)=data
    .set ind=ind+1
    
    set:((tTotalUricInf>0)&(tTotalInf>0)) tUricRate=$fn((tTotalUricInf)/tTotalInf*100,"",2)_"%" 
    set:((tTotalAVInf>0)&(tTotalInf>0)) tAVRate=$fn((tTotalAVInf)/tTotalInf*100,"",2)_"%"
    set:((tTotalTrachealCutInf>0)&(tTotalInf>0)) tTrachealCutRate=$fn((tTotalTrachealCutInf)/tTotalInf*100,"",2)_"%"
    set:((tTotalBrethMachineInf>0)&(tTotalInf>0)) tBrethMachineRate=$fn((tTotalBrethMachineInf)/tTotalInf*100,"",2)_"%"
    
    set tRepCtlocDesc="全院"
	set $li(data,1)=tRepCtlocDesc
	set $li(data,2)=tTotalInf
	set $li(data,3)=+tTotalUricInf_"/"_tUricRate
	set $li(data,4)=+tTotalAVInf_"/"_tAVRate
	set $li(data,5)=+tTotalTrachealCutInf_"/"_tTrachealCutRate
	set $li(data,6)=+tTotalBrethMachineInf_"/"_tBrethMachineRate
	set ^CacheTemp(repid,ind)=data
    set ind=ind+1
	q $$$OK
}

ClassMethod QueryHDMByCRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHDMByCRExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryHDMByCRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHDMByCRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
