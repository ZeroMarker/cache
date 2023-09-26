/// 名称: DHCMed.NINFService.Aim.HDMReasonSta1Srv
/// 编写者：zgz
Class DHCMed.NINFService.Aim.DengRenAmount Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.DengRenAmount","QueryHDMByCR","2011-10-05","2012-10-29")
Query QueryHDMByCR(DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "RepCtlocDesc:%String,CheckedCount:%String,InfCount:%String,UricPipeCount:%String,UricPipeRate:%String,UricPipeInfCount:%String,UricPipeInfRate:%String,UricPipeInf48Count:%String,AVPipeCount:%String,AVPipeRate:%String,AVPipeInfCount:%String,AVPipeInfRate:%String,AVPipeInf48Count:%String,TrachealCutCount:%String,TrachealCutRate:%String,TrachealCutInfCount:%String,TrachealCutInfRate:%String,TrachealCutInf48Count:%String,BrethMachineCount:%String,BrethMachineRate:%String,BrethMachineInfCount:%String,BrethMachineInfRate:%String,BrethMachineInf48:%String,BloodDialysisCount:%String,BloodDialysisRate:%String") [ SqlProc ]
{
}

ClassMethod QueryHDMByCRExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^CACHETMPONE("QueryHDMByCR")
 	Set:DateFrom["-" DateFrom=$zdh(DateFrom, 3)         //日期格式转换
	Set:DateTo["-" DateTo=$zdh(DateTo, 3)
	Set:DateFrom["/" DateFrom=$zdh(DateFrom, 4)
	Set:DateTo["/" DateTo=$zdh(DateTo, 4)
	set preturn=""
	
	s HDMEPRProjectID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("INFHDMCRReportID","")
	q:HDMEPRProjectID="" $$$OK
	
	q:'$d(^DHCMed.CR.ReportI("IndexProjectID"," "_HDMEPRProjectID)) $$$OK
	s rowid=""
	f  s rowid=$o(^DHCMed.CR.ReportI("IndexProjectID"," "_HDMEPRProjectID,rowid)) q:rowid=""  d
	.s str=##class(DHCMed.CR.Report).GetById(rowid)
	.q:str=""
	.s EpisodeID=$p(str,"^",4)
	.q:EpisodeID=""
	.s RepDate=$p(str,"^",7)
	.q:RepDate=""
	.s:RepDate["-" RepDate=$zdh(RepDate,3)
	.q:(RepDate<DateFrom)||(RepDate>DateTo)
	.s LocID=$p(^PAADM(EpisodeID),"^",4)
	.q:LocID=""
	.s ^CACHETMPONE("QueryHDMByCR",LocID,rowid)=""
	
	/*
 	set sDate=DateFrom-1
    //录入数据
 	for 
 	{   set sDate=$o(^DHCMed.CR.ReportI("DateLoc",sDate)) 
 	    quit:((sDate="")||(sDate>DateTo))
	 	set RepCtloc=""
	 	for {   
	 	    set RepCtloc=$o(^DHCMed.CR.ReportI("DateLoc",sDate,RepCtloc))
	 	    quit:RepCtloc="" 
		 	set rowid=""
		 	for {   
		 	    set rowid=$o(^DHCMed.CR.ReportI("DateLoc",sDate,RepCtloc,rowid)) 
		 	    quit:rowid=""
			 	set ^CACHETMPONE("QueryHDMByCR",RepCtloc,rowid)=""
			   }
		    }
	}
	*/
	
	set CheckedCount="0"
	set InfCount="0"
	set UricPipeCount="0"
	set UricPipeRate="0"
	set UricPipeInfCount="0"
	set UricPipeInfRate="0"
	set UricPipeInf48Count="0"
	set AVPipeCount="0"
	set AVPipeRate="0"
	set AVPipeInfCount="0"
	set AVPipeInfRate="0"
	set AVPipeInf48Count="0"
	set TrachealCutCount="0"
	set TrachealCutRate="0"
	set TrachealCutInfCount="0"
	set TrachealCutInfRate="0"
	set TrachealCutInf48Count="0"
	set BrethMachineCount="0"
	set BrethMachineRate="0"
	set BrethMachineInfCount="0"
	set BrethMachineInfRate="0"
	set BrethMachineInf48Count="0"
	set BloodDialysisCount="0"
	set BloodDialysisRate="0"
	set TotalCheckedCount="0"
	set TotalInfCount="0"
	set TotalUricPipeCount="0"
	set TotalUricPipeRate="0"
	set TotalUricPipeInfCount="0"
	set TotalUricPipeInfRate="0"
	set TotalUricPipeInf48Count="0"
	set TotalAVPipeCount="0"
	set TotalAVPipeRate="0"
	set TotalAVPipeInfCount="0"
	set TotalAVPipeInfRate="0"
	set TotalAVPipeInf48Count="0"
	set TotalTrachealCutCount="0"
	set TotalTrachealCutRate="0"
	set TotalTrachealCutInfCount="0"
	set TotalTrachealCutInfRate="0"
	set TotalTrachealCutInf48Count="0"
	set TotalBrethMachineCount="0"
	set TotalBrethMachineRate="0"
	set TotalBrethMachineInfCount="0"
	set TotalBrethMachineInfRate="0"
	set TotalBrethMachineInf48Count="0"
	set TotalBloodDialysisCount="0"
	set TotalBloodDialysisRate="0"
	
	
	
	set RepCtloc=""
 	for {
	 	 set RepCtloc=$o(^CACHETMPONE("QueryHDMByCR",RepCtloc))
	 	 quit:RepCtloc="" 
	 	 for {
		 	 set rowid=$o(^CACHETMPONE("QueryHDMByCR",RepCtloc,rowid)) 
		 	 q:rowid=""  
	         set obj=##class(DHCMed.CR.Report).%OpenId(rowid)
             quit:'$IsObject(obj)
             set EpisodeID=""
	         set EpisodeID=obj.EpisodeID
	         quit:$g(^PAADM(EpisodeID))=""
	         set CtLocDR=$p(^PAADM(EpisodeID),"^",4)
	         quit:CtLocDR=""
	         set HDMRowid=$o(^DHCMed.NINF.Aim.HDMI("CRReportDR"," "_rowid,""),-1)
	         quit:HDMRowid=""
	         set preturn=##class(DHCMed.NINF.Aim.HDM).GetObjById(HDMRowid)
	         Continue:'$IsObject(preturn)
	         set CheckedNum=$i(^CACHETMPONE("QueryHDMByCR",CtLocDR,"CheckedNum")) ///实查人数查询
	         if (preturn.IfInfection="存在"){                               
		         set InfNum=$i(^CACHETMPONE("QueryHDMByCR",CtLocDR,"InfNum")) ///感染人数查询
	           		}
	         set IfInfection=preturn.IfInfection
	         set InfType=preturn.InfType
	         set HosInfPos=preturn.HosInfPos
	         set UricPipe=preturn.UricPipe
	         set UricPipeInf48=preturn.UricPipeInf48
	         set AVPipe=preturn.AVPipe
	         set AVPipeInf48=preturn.AVPipeInf48
	         set TrachealCut=preturn.TrachealCut
	         set TrachealCutInf48=preturn.TrachealCutInf48
	         set BrethMachine=preturn.BrethMachine
	         set BrethMachineInf48=preturn.BrethMachineInf48
	         set BloodDialysis=preturn.BloodDialysis
	         
	         q:IfInfection'="存在"
			 q:InfType'="医院感染"
			 if (HosInfPos["泌尿道"){
			 	set tmpUricPipeInfNum=$i(^CACHETMPONE("QueryHDMByCR",CtLocDR,"HDM","UricPipeInfNum"))
			    if (UricPipe="有"){
				    set tmpUricPipeNum=$i(^CACHETMPONE("QueryHDMByCR",CtLocDR,"HDM","UricPipeNum"))
			    		}
				if (UricPipeInf48="有"){
					set tmpUricPipeInf48Num=$i(^CACHETMPONE("QueryHDMByCR",CtLocDR,"HDM","UricPipeInf48Num"))
			 			}
			 		}
			 if (HosInfPos["动静脉"){
			 	set tmpAVPipeInfNum=$i(^CACHETMPONE("QueryHDMByCR",CtLocDR,"HDM","AVPipeInfNum"))
			    if (AVPipe="有"){
				    set tmpAVPipeNum=$i(^CACHETMPONE("QueryHDMByCR",CtLocDR,"HDM","AVPipeNum"))
			    		}
				if (AVPipeInf48="有"){
					set tmpAVPipeInf48Num=$i(^CACHETMPONE("QueryHDMByCR",CtLocDR,"HDM","AVPipeInf48Num"))
						}
			 		}
			 if (HosInfPos["呼吸道"){
			 	set tmpTrachealCutInfNum=$i(^CACHETMPONE("QueryHDMByCR",CtLocDR,"HDM","TrachealCuteInfNum"))
			    if (TrachealCut="有"){
				    set tmpTrachealCutNum=$i(^CACHETMPONE("QueryHDMByCR",CtLocDR,"HDM","TrachealCutNum"))
			    		}
				if (TrachealCutInf48="有"){
					set tmpTrachealCutInf48Num=$i(^CACHETMPONE("QueryHDMByCR",CtLocDR,"HDM","TrachealCutInf48Num"))
						}
			 	}
			 if (HosInfPos["呼吸道"){
			 	set tmpBrethMachineInfNum=$i(^CACHETMPONE("QueryHDMByCR",CtLocDR,"HDM","BrethMachineInfNum"))
			    if (BrethMachine="有"){
				    set tmpBrethMachineNum=$i(^CACHETMPONE("QueryHDMByCR",CtLocDR,"HDM","BrethMachineNum"))
			    		}
				if (BrethMachineInf48="有"){
					set tmpBrethMachineInf48Num=$i(^CACHETMPONE("QueryHDMByCR",CtLocDR,"HDM","BrethMachineInf48Num"))
						}
			 	}
			 if (BloodDialysis="有"){
					set tmpBloodDialysisNum=$i(^CACHETMPONE("QueryHDMByCR",CtLocDR,"HDM","BloodDialysisNum"))
						}
						
	 	 	}
	 	 }		
						
	set RepCtloc=""
    for  {
	      set RepCtloc=$o(^CACHETMPONE("QueryHDMByCR",RepCtloc)) 
		  quit:RepCtloc="" 
		  set CheckedCount=$g(^CACHETMPONE("QueryHDMByCR",RepCtloc,"CheckedNum"))
		  set InfCount=$g(^CACHETMPONE("QueryHDMByCR",RepCtloc,"InfNum")) 
		  set UricPipeInfCount=$g(^CACHETMPONE("QueryHDMByCR",RepCtloc,"HDM","UricPipeInfNum"))
	 	  set UricPipeCount=$g(^CACHETMPONE("QueryHDMByCR",RepCtloc,"HDM","UricPipeNum"))
		  set UricPipeInf48Count=$g(^CACHETMPONE("QueryHDMByCR",RepCtloc,"HDM","UricPipeInf48Num"))
		  set AVPipeInfCount=$g(^CACHETMPONE("QueryHDMByCR",RepCtloc,"HDM","AVPipeInfNum")) 
		  set AVPipeCount=$g(^CACHETMPONE("QueryHDMByCR",RepCtloc,"HDM","AVPipeNum")) 
		  set AVPipeInf48Count=$g(^CACHETMPONE("QueryHDMByCR",RepCtloc,"HDM","AVPipeInf48Num")) 
		  set TrachealCutInfCount=$g(^CACHETMPONE("QueryHDMByCR",RepCtloc,"HDM","TrachealCutInfNum")) 
		  set TrachealCutCount=$g(^CACHETMPONE("QueryHDMByCR",RepCtloc,"HDM","TrachealCutNum")) 
		  set TrachealCutInf48Count=$g(^CACHETMPONE("QueryHDMByCR",RepCtloc,"HDM","TrachealCutInf48Num")) 
		  set BrethMachineInfCount=$g(^CACHETMPONE("QueryHDMByCR",RepCtloc,"HDM","BrethMachineInfNum")) 
		  set BrethMachineCount=$g(^CACHETMPONE("QueryHDMByCR",RepCtloc,"HDM","BrethMachineNum")) 
		  set BrethMachineInf48Count=$g(^CACHETMPONE("QueryHDMByCR",RepCtloc,"HDM","BrethMachineInf48Num")) 
		  set BloodDialysisCount=$g(^CACHETMPONE("QueryHDMByCR",RepCtloc,"HDM","BloodDialysisNum"))  
		  set:((UricPipeCount>0)&(CheckedCount>0)) UricPipeRate=$fn((UricPipeCount)/CheckedCount*100,"",2)_"%" 
		  set:((UricPipeInfCount>0)&(InfCount>0)) UricPipeInfRate=$fn((UricPipeInfCount)/InfCount*100,"",2)_"%"
    	  set:((AVPipeCount>0)&(CheckedCount>0)) AVPipeRate=$fn((AVPipeCount)/CheckedCount*100,"",2)_"%" 
    	  set:((AVPipeInfCount>0)&(InfCount>0)) AVPipeInfRate=$fn((AVPipeInfCount)/InfCount*100,"",2)_"%"
    	  set:((TrachealCutCount>0)&(CheckedCount>0)) TrachealCutRate=$fn((TrachealCutCount)/CheckedCount*100,"",2)_"%"
    	  set:((TrachealCutInfCount>0)&(InfCount>0)) TrachealCutInfRate=$fn((TrachealCutInfCount)/InfCount*100,"",2)_"%"
    	  set:((BrethMachineCount>0)&(CheckedCount>0)) BrethMachineRate=$fn((BrethMachineCount)/CheckedCount*100,"",2)_"%"
    	  set:((BrethMachineInfCount>0)&(InfCount>0)) BrethMachineInfRate=$fn((BrethMachineInfCount)/InfCount*100,"",2)_"%" 
		  set:((BloodDialysisCount>0)&(CheckedCount>0)) BloodDialysisRate=$fn((BloodDialysisCount)/CheckedCount*100,"",2)_"%"
		  set TotalCheckedCount=TotalCheckedCount+CheckedCount
		  set TotalInfCount=TotalInfCount+InfCount
		  set TotalUricPipeInfCount=TotalUricPipeInfCount+UricPipeInfCount
		  set TotalUricPipeCount=TotalUricPipeCount+UricPipeCount
		  set TotalUricPipeInf48Count=TotalUricPipeInf48Count+UricPipeInf48Count
		  set TotalAVPipeCount=TotalAVPipeCount+AVPipeCount
		  set TotalAVPipeInfCount=TotalAVPipeInfCount+AVPipeInfCount
		  set TotalUricPipeInf48Count=TotalUricPipeInf48Count+UricPipeInf48Count
		  set TotalTrachealCutCount=TotalTrachealCutCount+TrachealCutCount
		  set TotalTrachealCutInfCount=TotalTrachealCutInfCount+TrachealCutInfCount
		  set TotalTrachealCutInf48Count=TotalTrachealCutInf48Count+TrachealCutInf48Count
		  set TotalBrethMachineCount=TotalBrethMachineCount+BrethMachineCount
		  set TotalBrethMachineInfCount=TotalBrethMachineInfCount+BrethMachineInfCount
		  set TotalBrethMachineInf48Count=TotalBrethMachineInf48Count+BrethMachineInf48Count
		  set TotalBloodDialysisCount=TotalBloodDialysisCount+BloodDialysisCount
		  
		  set RepCtlocDesc=""
	      if (+RepCtloc'=0) {
	          s LocObj=##class(DHCMed.Base.Ctloc).GetObjById(+RepCtloc)
	          q:'$IsObject(LocObj)
	          s RepCtlocDesc=LocObj.Descs
			  s:RepCtlocDesc["-" RepCtlocDesc=$p(RepCtlocDesc,"-",2)
	          }
		  q:RepCtlocDesc=""
		  set $li(data,1)=RepCtlocDesc
		  set $li(data,2)=CheckedCount
		  set $li(data,3)=InfCount
		  set $li(data,4)=UricPipeCount
		  set $li(data,5)=UricPipeRate
		  set $li(data,6)=UricPipeInfCount
		  set $li(data,7)=UricPipeInfRate
		  set $li(data,8)=UricPipeInf48Count
		  set $li(data,9)=AVPipeCount
		  set $li(data,10)=AVPipeRate
		  set $li(data,11)=AVPipeInfCount
		  set $li(data,12)=AVPipeInfRate
		  set $li(data,13)=AVPipeInf48Count
		  set $li(data,14)=TrachealCutCount
		  set $li(data,15)=TrachealCutRate
		  set $li(data,16)=TrachealCutInfCount
		  set $li(data,17)=TrachealCutInfRate
		  set $li(data,18)=TrachealCutInf48Count
		  set $li(data,19)=BrethMachineCount
		  set $li(data,20)=BrethMachineRate
		  set $li(data,21)=BrethMachineInfCount
		  set $li(data,22)=BrethMachineInfRate
		  set $li(data,23)=BrethMachineInf48Count
		  set $li(data,24)=BloodDialysisCount
		  set ^CacheTemp(repid,ind)=data
    	  set ind=ind+1
		  }

	set:((TotalUricPipeCount>0)&(TotalCheckedCount>0)) TotalUricPipeRate=$fn((TotalUricPipeCount)/TotalCheckedCount*100,"",2)_"%" 
	set:((TotalUricPipeInfCount>0)&(TotalInfCount>0)) TotalUricPipeInfRate=$fn((TotalUricPipeInfCount)/TotalInfCount*100,"",2)_"%"
    set:((TotalAVPipeCount>0)&(TotalCheckedCount>0)) TotalAVPipeRate=$fn((TotalAVPipeCount)/TotalCheckedCount*100,"",2)_"%" 
    set:((TotalAVPipeInfCount>0)&(TotalInfCount>0)) TotalAVPipeInfRate=$fn((TotalAVPipeInfCount)/TotalInfCount*100,"",2)_"%"
    set:((TotalTrachealCutCount>0)&(TotalCheckedCount>0)) TotalTrachealCutRate=$fn((TotalTrachealCutCount)/TotalCheckedCount*100,"",2)_"%"
    set:((TotalTrachealCutInfCount>0)&(TotalInfCount>0)) TotalTrachealCutInfRate=$fn((TotalTrachealCutInfCount)/TotalInfCount*100,"",2)_"%"
    set:((TotalBrethMachineCount>0)&(TotalCheckedCount>0)) TotalBrethMachineRate=$fn((TotalBrethMachineCount)/TotalCheckedCount*100,"",2)_"%"
    set:((TotalBrethMachineInfCount>0)&(TotalInfCount>0)) TotalBrethMachineInfRate=$fn((TotalBrethMachineInfCount)/TotalInfCount*100,"",2)_"%" 
	set:((TotalBloodDialysisCount>0)&(TotalCheckedCount>0)) TotalBloodDialysisRate=$fn((TotalBloodDialysisCount)/TotalCheckedCount*100,"",2)_"%"
	
			 
	set TotalRepCtlocDesc="全院"
	set $li(data,1)=TotalRepCtlocDesc
	set $li(data,2)=TotalCheckedCount
	set $li(data,3)=TotalInfCount
	set $li(data,4)=TotalUricPipeCount
	set $li(data,5)=TotalUricPipeRate
	set $li(data,6)=TotalUricPipeInfCount
	set $li(data,7)=TotalUricPipeInfRate
	set $li(data,8)=TotalUricPipeInf48Count
	set $li(data,9)=TotalAVPipeCount
	set $li(data,10)=TotalAVPipeRate
	set $li(data,11)=TotalAVPipeInfCount
	set $li(data,12)=TotalAVPipeInfRate
	set $li(data,13)=TotalAVPipeInf48Count
	set $li(data,14)=TotalTrachealCutCount
	set $li(data,15)=TotalTrachealCutRate
	set $li(data,16)=TotalTrachealCutInfCount
	set $li(data,17)=TotalTrachealCutInfRate
	set $li(data,18)=TotalTrachealCutInf48Count
	set $li(data,19)=TotalBrethMachineCount
	set $li(data,20)=TotalBrethMachineRate
	set $li(data,21)=TotalBrethMachineInfCount
	set $li(data,22)=TotalBrethMachineInfRate
	set $li(data,23)=TotalBrethMachineInf48Count
	set $li(data,24)=TotalBloodDialysisCount
	set ^CacheTemp(repid,ind)=data
    set ind=ind+1		 	
 
	Quit $$$OK
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

Storage Default
{
<Data name="DengRenAmountDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFService.Aim.DengRenAmountD</DataLocation>
<DefaultData>DengRenAmountDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFService.Aim.DengRenAmountD</IdLocation>
<IndexLocation>^DHCMed.NINFService.Aim.DengRenAmountI</IndexLocation>
<StreamLocation>^DHCMed.NINFService.Aim.DengRenAmountS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
