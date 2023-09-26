/// 名称: DHCMed.NINFService.Aim.HDMReasonSta1Srv
/// 编写者：zgz
Class DHCMed.NINFService.Aim.HDMReasonSta1Srv Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.HDMReasonSta1Srv","QueryHDMByCR2","2012-4-1","2012-5-29","","")
Query QueryHDMByCR2(DateFrom As %String, DateTo As %String, Ctloc As %String, InfType As %String) As %Query(ROWSPEC = "Ctloc:%String,patNum:%String,UricPipeCount:%String,UricRate:%String,AVPipeCount:%String,AVRate:%String,TrachealCutCount:%String,TrachealCutRate:%String, BrethMachineCount:%String, BrethMachineRate:%String, BloodDialysisCount:%String,BloodDialysisRate:%String") [ SqlProc ]
{
}

ClassMethod QueryHDMByCR2Execute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, Ctloc As %String, InfType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set:DateFrom["-" DateFrom=$zdh(DateFrom, 3)         //日期格式转换
	Set:DateTo["-" DateTo=$zdh(DateTo, 3)
	Set:DateFrom["/" DateFrom=$zdh(DateFrom, 4)
	Set:DateTo["/" DateTo=$zdh(DateTo, 4)
    
    
    k ^TMP("QueryHDMByCR2")
    set preturn=""
    s sDate=DateFrom-1
 	for  set sDate=$o(^DHCMed.CR.ReportI("DateLoc",sDate)) q:((sDate="")||(sDate>DateTo))  d
	.set RepCtloc=""
	.for  set RepCtloc=$o(^DHCMed.CR.ReportI("DateLoc",sDate,RepCtloc)) q:RepCtloc=""  d 
	..set rowid=""
    ..for  set rowid=$o(^DHCMed.CR.ReportI("DateLoc",sDate,RepCtloc,rowid)) quit:rowid=""  d 
	...set ^TMP("QueryHDMByCR2",RepCtloc,rowid)=""
	 
	 
	 set UricRate="0"
	 set AVRate="0"
	 set TrachealCutRate="0"
	 set BreachMachineRate="0"
	 set BloodDialysisRate="0"
	 set UricPipeCount="0" 
	 set AVPipeCount="0"
	 set TrachealCutCount="0"
	 set BrethMachineCount="0"
     set BloodDialysisCount="0"  //某科室泌尿管插管率
	 set AVNum="0"                      //某科室动静脉插管人数
	 set AVrate="0"                     //某科室动静脉插管率
	 set TrachealCutNum="0"             //某科室气管切开人数
	 set TrachealCutRate="0"            //某科室气管切开率
	 set BrethMachineNum="0"           //某科室使用呼吸机人数
	 set BrethMachineRate="0"          //某科室呼吸机使用率
	 set BloodDialysisNum="0"           //某科室血透人数
	 set BloodDialysisRate="0"          //某科室血液透析率
	 set Ctloc=""
 	 set (rowid,HDMRowid,IfInfection,RepCtloc,InfType,HosInfPos,UricPipe,AVPipe,TrachealCut,BrethMachine,BloodDialysis)=""
 	 set RepCtloc=""
 	 f  set RepCtloc=$o(^TMP("QueryHDMByCR2",RepCtloc)) q:RepCtloc=""  d
 	 .f  set rowid=$o(^TMP("QueryHDMByCR2",RepCtloc,rowid)) q:rowid=""   d   
	 ..s obj=##class(DHCMed.CR.Report).%OpenId(rowid)
	 ..q:'$IsObject(obj)
	 ..set EpisodeID=""
	 ..set EpisodeID=obj.EpisodeID
	 ..s CtLocDR=$p(^PAADM(EpisodeID),"^",4)
	 ..set HDMRowid=$o(^DHCMed.NINF.HDMI("CRReportDR"," "_rowid,""),-1)
	 ..s preturn=##class(DHCMed.NINF.HDM).GetObjById(HDMRowid)
	 ..s patNum=$i(^TMP("QueryHDMByCR2",CtLocDR,"patNum"))
	 ..q:'$IsObject(preturn)
	 ..s InfType=preturn.InfType
	 ..s IfInfection=preturn.IfInfection
	 ..s HosInfPos=preturn.HosInfPos
	 ..s UricPipe=preturn.UricPipe
	 ..s AVPipe=preturn.AVPipe
	 ..s TrachealCut=preturn.TrachealCut
	 ..s BrethMachine=preturn.BrethMachine
	 ..s BloodDialysis=preturn.BloodDialysis
	 ..q:IfInfection'="存在"
	 ..q:InfType'="医院感染"
	 ..if ((HosInfPos["泌尿道")&(UricPipe="有")) d
	 ...s tmpUricPipe=$i(^TMP("QueryHDMByCR2",CtLocDR,"HDM","UricNum"))
	 ..if ((HosInfPos["动静脉")&(AVPipe="有")) d
	 ...set tmpAVPipe=$i(^TMP("QueryHDMByCR2",CtLocDR,"HDM","AVNum"))
	 ..if ((HosInfPos["呼吸道")&(TrachealCut="有")) d
	 ...set tmpTrachealCut=$i(^TMP("QueryHDMByCR2",CtLocDR,"HDM","TrachealCutNum"))
	 ..if ((HosInfPos["呼吸道")&(BrethMachine="有")) d
	 ...set tmpBrethMachine=$i(^TMP("QueryHDMByCR2",CtLocDR,"HDM","BrethMachineNum"))
	 ..if ((HosInfPos["动静脉")&(BloodDialysis="有")) d
	 ...set tmpBloodDialysis=$i(^TMP("QueryHDMByCR2",CtLocDR,"HDM","BloodDialysisNum"))
	 s RepCtloc=""
	 for  set RepCtloc=$o(^TMP("QueryHDMByCR2",RepCtloc)) Quit:RepCtloc=""  d
	 .set patNum=$g(^TMP("QueryHDMByCR2",RepCtloc,"patNum"))
	 .set UricPipeCount=$g(^TMP("QueryHDMByCR2",RepCtloc,"HDM","UricNum"))
	 .set AVPipeCount=$g(^TMP("QueryHDMByCR2",RepCtloc,"HDM","AVNum"))
	 .set TrachealCutCount=$g(^TMP("QueryHDMByCR2",RepCtloc,"HDM","TrachealCutNum"))
	 .set BrethMachineCount=$g(^TMP("QueryHDMByCR2",RepCtloc,"HDM","BrethMachineNum"))
	 .set BloodDialysisCount=$g(^TMP("QueryHDMByCR2",RepCtloc,"HDM","BloodDialysisNum"))
     .set:((UricPipeCount>0)&(patNum>0)) UricRate=$fn((UricPipeCount)/patNum*100,"",2)_"%" 
     .set:((AVPipeCount>0)&(patNum>0)) AVRate=$fn((AVPipeCount)/patNum*100,"",2)_"%"
     .set:((TrachealCutCount>0)&(patNum>0)) TrachealCutRate=$fn((TrachealCutCount)/patNum*100,"",2)_"%"
     .set:((BrethMachineCount>0)&(patNum>0)) BreachMachineRate=$fn((BrethMachineCount)/patNum*100,"",2)_"%"
     .set:((BloodDialysisCount>0)&(patNum>0)) BloodDialysisRate=$fn((BloodDialysisCount)/patNum*100,"",2)_"%"
     .set $li(data,1)=Ctloc
	 .set $li(data,2)=patNum
	 .set $li(data,3)=UricPipeCount
	 .set $li(data,4)=UricRate
	 .set $li(data,5)=AVPipeCount
	 .set $li(data,6)=AVRate
	 .set $li(data,7)=TrachealCutCount
	 .set $li(data,8)=TrachealCutRate
	 .set $li(data,9)=BrethMachineCount
	 .set $li(data,10)=BreachMachineRate
	 .set $li(data,11)=BloodDialysisCount
	 .set $li(data,12)=BloodDialysisRate
	 
	 .set ^CacheTemp(repid,ind)=data
     .set ind=ind+1
	 Quit $$$OK
}

ClassMethod QueryHDMByCR2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHDMByCR2Execute ]
{
   
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
	Quit $$$OK
}

ClassMethod QueryHDMByCR2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHDMByCR2Execute ]
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
	Quit $$$OK
}

Storage Default
{
<Data name="HDM2SrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFService.Aim.HDMReasonSta1SrvD</DataLocation>
<DefaultData>HDM2SrvDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFService.Aim.HDMReasonSta1SrvD</IdLocation>
<IndexLocation>^DHCMed.NINFService.Aim.HDMReasonSta1SrvI</IndexLocation>
<StreamLocation>^DHCMed.INFService.Aim.HDMSrvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
