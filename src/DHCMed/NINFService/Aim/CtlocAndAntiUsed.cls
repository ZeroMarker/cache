/// 名称: DHCMed.NINFService.Aim.HDMReasonSta1Srv
/// 编写者：zgz
Class DHCMed.NINFService.Aim.CtlocAndAntiUsed Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.CtlocAndAntiUsed","QueryHDMByCR","2011-04-05","2012-10-29")
Query QueryHDMByCR(DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "RepCtlocDesc:%String,CheckingCount:%String,CheckedCount:%String,AntiUsedCount:%String,AntiUsedRate:%String,AntiProPhyCount:%String,AntiToCount:%String,AntiProPhyToCount:%String,SendRate:%String,StrainsCount:%String,AntiOneUsedCount:%String,AntiTwoUsedCount:%String,AntiThreeUsedCount:%String,AntiFourUsedCount:%String,AntiUPFourUsedCount:%String") [ SqlProc ]
{
}

ClassMethod QueryHDMByCRExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^CACHETMP("QueryHDMByCR")
 	Set:DateFrom["-" DateFrom=$zdh(DateFrom, 3)         //日期格式转换
	Set:DateTo["-" DateTo=$zdh(DateTo, 3)
	Set:DateFrom["/" DateFrom=$zdh(DateFrom, 4)
	Set:DateTo["/" DateTo=$zdh(DateTo, 4)
	set preturn=""
 	set sDate=DateFrom-1
 	
 	
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
	.s ^CACHETMP("QueryHDMByCR",LocID,rowid)=""
	
	/*
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
			 	set ^CACHETMP("QueryHDMByCR",RepCtloc,rowid)=""
			   }
		    }
	}
	*/
	set CheckingCount="0"
	set CheckedCount="0"
	set AntiUsedCount="0"
	set AntiUsedRate="0"            ///抗菌用药人数
	set AntiProPhyCount="0"         ///预防用药人数
	set AntiToCount="0"             ///治疗用药人数
	set AntiProPhyToCount="0"       ///预防加治疗用药人数
	set HosStrainsCount="0"         ///医院感染病原体数 
	set SocStrainsCount="0"         ///社区感染病原体
	set SendCount="0"               ///送检数
	set SendRate="0"                ///送检率
	set StrainsCount="0"            ///病原体数
	set AntiOneUsedCount="0"        ///单联
	set AntiTwoUsedCount="0"        ///二联
	set AntiThreeUsedCount="0"      ///三联
	set AntiFourUsedCount="0"       ///四联
	set AntiUPFourUsedCount="0"    ///四联以上
	set TotalSendCount="0"
	set TotalSendRate="0"
	set TotalStrainsCount="0" 
	set TotalCheckingCount="0"
	set TotalCheckedCount="0"
	set TotalAntiUsedCount="0"
	set TotalAntiProPhyCount="0"
	set TotalAntiToCount="0"
    set TotalAntiProPhyToCount="0"
    set TotalAntiOneUsedCount="0"
    set TotalAntiTwoUsedCount="0"
    set TotalAntiThreeUsedCount="0"
    set TotalAntiFourUsedCount="0"
    set TotalAntiUPFourUsedCount="0"
    set TotalAntiUsedRate="0"
 
    ///取出存入数据，对数据进行操作
    set RepCtloc=""
 	for {
	 	 set RepCtloc=$o(^CACHETMP("QueryHDMByCR",RepCtloc))
	 	 quit:RepCtloc="" 
	 	 for {
		 	 set rowid=$o(^CACHETMP("QueryHDMByCR",RepCtloc,rowid)) 
		 	 q:rowid=""  
	         set obj=##class(DHCMed.CR.Report).%OpenId(rowid)
             quit:'$IsObject(obj)
             set EpisodeID=""
	         set EpisodeID=obj.EpisodeID
	         set CtLocDR=$p(^PAADM(EpisodeID),"^",4)
	         quit:CtLocDR=""
	         set HDMRowid=$o(^DHCMed.NINF.Aim.HDMI("CRReportDR"," "_rowid,""),-1)
	         set preturn=##class(DHCMed.NINF.Aim.HDM).GetObjById(HDMRowid)
	         Continue:'$IsObject(preturn)
	         set CheckedNum=$i(^CACHETMP("QueryHDMByCR",CtLocDR,"CheckedNum")) ///实查人数查询
	         set AntiUsed=preturn.AntiUsed
	         set Aim=preturn.Aim
	         set UniteDrug=preturn.UniteDrug
	         set HosInfObj=preturn.HosInfObj
	         set SocInfObj=preturn.SocInfObj
	         set IfInfection=preturn.IfInfection
	         set InfType=preturn.InfType
	         if (AntiUsed="是" ){ 
	         	set tmpAntiUsedCount=$i(^CACHETMP("QueryHDMByCR",CtLocDR,"HDM","AntiUsedNum")) 
	         	if (Aim["预防用药"){
	         		set tmpAntiProPhyCount=$i(^CACHETMP("QueryHDMByCR",CtLocDR,"HDM","AntiProPhyNum"))
	         		} 
	         	if (Aim["治疗用药") {
	         		set tmpAntiToCount=$i(^CACHETMP("QueryHDMByCR",CtLocDR,"HDM","AntiToNum"))
	 	     		}
	 	     	if ((Aim["预防用药")&(Aim["治疗用药")) {
	         		set tmpAntiProPhyToCount=$i(^CACHETMP("QueryHDMByCR",CtLocDR,"HDM","AntiProPhyToNum"))
	         		if ((HosInfObj="")&(SocInfObj="")){ 
	         			quit 
	         			}
	         			if ((HosInfObj'="")||(SocInfObj'="")){ 
	         				set tmpSendCount=$i(^CACHETMP("QueryHDMByCR",CtLocDR,"HDM","SendNum")) 
	         			if ((InfType="社区感染")&(SocInfObj'="")){
		         			set SocStrainsCount=$length(SocInfObj,",")
		         				}
		       	 		if ((InfType="医院感染")&(HosInfObj'="")){
		         			set HosStrainsCount=$length(HosInfObj,",")
		         				}
	         				}
	 	     			}
	 	     	if (UniteDrug="0" ){ 
	         		 quit  
	         		}		
	 	     	if (UniteDrug="1" ){ 
	         		set tmpAntiOneUsedCount=$i(^CACHETMP("QueryHDMByCR",CtLocDR,"HDM","AntiOneUsedNum")) 
	         		}	
	         	if (UniteDrug="2" ){ 
	         		set tmpAntiTwoUsedCount=$i(^CACHETMP("QueryHDMByCR",CtLocDR,"HDM","AntiTwoUsedNum"))
	         		}
	         	if (UniteDrug="3" ){ 
	         		set tmpAntiThreeUsedCount=$i(^CACHETMP("QueryHDMByCR",CtLocDR,"HDM","AntiThreeUsedNum")) 
	         		}
	         	if (UniteDrug="4" ){ 
	         		set tmpAntiFourUsedCount=$i(^CACHETMP("QueryHDMByCR",CtLocDR,"HDM","AntiFourUsedNum"))
	         		}
	         	if (UniteDrug="5" ){ 
	         		set tmpAntiUPFourUsedCount=$i(^CACHETMP("QueryHDMByCR",CtLocDR,"HDM","AntiUPFourUsedNum"))
	         		}
	     		}
	     }
	}
		 	 
		 	 
	set RepCtloc=""
    for  {
	      set RepCtloc=$o(^CACHETMP("QueryHDMByCR",RepCtloc)) 
		  quit:RepCtloc="" 
		  set CheckedCount=$g(^CACHETMP("QueryHDMByCR",RepCtloc,"CheckedNum"))
		  set AntiUsedCount=$g(^CACHETMP("QueryHDMByCR",RepCtloc,"HDM","AntiUsedNum"))
		  set AntiProPhyCount=$g(^CACHETMP("QueryHDMByCR",RepCtloc,"HDM","AntiProPhyNum")) 
		  set AntiToCount=$g(^CACHETMP("QueryHDMByCR",RepCtloc,"HDM","AntiToNum"))
	 	  set AntiProPhyToCount=$g(^CACHETMP("QueryHDMByCR",RepCtloc,"HDM","AntiProPhyToNum"))
		  set AntiOneUsedCount=$g(^CACHETMP("QueryHDMByCR",RepCtloc,"HDM","AntiOneUsedNum"))
		  set AntiTwoUsedCount=$g(^CACHETMP("QueryHDMByCR",RepCtloc,"HDM","AntiTwoUsedNum"))
		  set AntiThreeUsedCount=$g(^CACHETMP("QueryHDMByCR",RepCtloc,"HDM","AntiThreeUsedNum"))
		  set AntiFourUsedCount=$g(^CACHETMP("QueryHDMByCR",RepCtloc,"HDM","AntiFourUsedNum"))
		  set AntiUPFourUsedCount=$g(^CACHETMP("QueryHDMByCR",RepCtloc,"HDM","AntiUPFourUsedNum"))
		  set SendCount=$g(^CACHETMP("QueryHDMByCR",RepCtloc,"HDM","SendNum"))
		  set StrainsCount=SocStrainsCount+HosStrainsCount
		  set:((CheckedCount>0)&(CheckingCount>0)) CheckedRate=$fn((CheckedCount)/CheckingCount*100,"",2)_"%"
		  set:((CheckedCount>0)&(AntiUsedCount>0)) AntiUsedRate=$fn((AntiUsedCount)/CheckedCount*100,"",2)_"%"
		  set:((SendCount>0)&(AntiProPhyToCount>0)) SendRate=$fn((SendCount)/AntiProPhyToCount*100,"",2)_"%" 
		  set TotalCheckingCount=TotalCheckingCount+CheckingCount
		  set TotalCheckedCount=TotalCheckedCount+CheckedCount
		  set TotalAntiUsedCount=TotalAntiUsedCount+AntiUsedCount
		  set TotalAntiProPhyCount=TotalAntiProPhyCount+AntiProPhyCount
		  set TotalAntiToCount=TotalAntiToCount+AntiToCount
		  set TotalAntiProPhyToCount=TotalAntiProPhyToCount+AntiProPhyToCount
		  set TotalAntiOneUsedCount=TotalAntiOneUsedCount+AntiOneUsedCount
		  set TotalAntiTwoUsedCount=TotalAntiTwoUsedCount+AntiTwoUsedCount
		  set TotalAntiThreeUsedCount=TotalAntiThreeUsedCount+AntiThreeUsedCount
		  set TotalAntiFourUsedCount=TotalAntiFourUsedCount+AntiFourUsedCount
		  set TotalAntiUPFourUsedCount=TotalAntiUPFourUsedCount+AntiUPFourUsedCount
		  set TotalSendCount=TotalSendCount+SendCount
		  set TotalStrainsCount=TotalStrainsCount+StrainsCount
		  
		  
		  set RepCtlocDesc=""
	      if (+RepCtloc'=0) {
	          s LocObj=##class(DHCMed.Base.Ctloc).GetObjById(+RepCtloc)
	          q:'$IsObject(LocObj)
	          s RepCtlocDesc=LocObj.Descs
			  s:RepCtlocDesc["-" RepCtlocDesc=$p(RepCtlocDesc,"-",2)
	          }
		  q:RepCtlocDesc=""
		  set $li(data,1)=RepCtlocDesc
		  set $li(data,2)=CheckingCount
		  set $li(data,3)=CheckedCount
		  set $li(data,4)=AntiUsedCount
		  set $li(data,5)=AntiUsedRate
		  set $li(data,6)=AntiProPhyCount
		  set $li(data,7)=AntiToCount
		  set $li(data,8)=AntiProPhyToCount
		  set $li(data,9)=SendRate
		  set $li(data,10)=StrainsCount
		  set $li(data,11)=AntiOneUsedCount
		  set $li(data,12)=AntiTwoUsedCount
		  set $li(data,13)=AntiThreeUsedCount
		  set $li(data,14)=AntiFourUsedCount
		  set $li(data,15)=AntiUPFourUsedCount
		  set ^CacheTemp(repid,ind)=data
    	  set ind=ind+1
		  }
	set:((TotalCheckedCount>0)&(TotalCheckingCount>0)) TotalCheckedRate=$fn((TotalCheckedCount)/TotalCheckingCount*100,"",2)_"%"
	set:((TotalCheckedCount>0)&(TotalAntiUsedCount>0)) TotalAntiUsedRate=$fn((TotalAntiUsedCount)/TotalCheckedCount*100,"",2)_"%"
	set:((TotalSendCount>0)&(TotalAntiProPhyToCount>0)) TotalSendRate=$fn((TotalSendCount)/TotalAntiProPhyToCount*100,"",2)_"%" 
    			
    set TotalRepCtlocDesc="全院"
	set $li(data,1)=TotalRepCtlocDesc
	set $li(data,2)=TotalCheckingCount
	set $li(data,3)=TotalCheckedCount
	set $li(data,4)=TotalAntiUsedCount
	set $li(data,5)=TotalAntiUsedRate
	set $li(data,6)=TotalAntiProPhyCount
	set $li(data,7)=TotalAntiToCount
	set $li(data,8)=TotalAntiProPhyToCount
	set $li(data,9)=TotalSendRate
	set $li(data,10)=TotalStrainsCount
	set $li(data,11)=TotalAntiOneUsedCount
	set $li(data,12)=TotalAntiTwoUsedCount
	set $li(data,13)=TotalAntiThreeUsedCount
	set $li(data,14)=TotalAntiFourUsedCount
	set $li(data,15)=TotalAntiUPFourUsedCount
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
 	If ind="" {							// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {							// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 										// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<Data name="CtlocAndAntiUsedDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFService.Aim.CtlocAndAntiD</DataLocation>
<DefaultData>CtlocAndAntiUsedDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFService.Aim.CtlocAndAnti</IdLocation>
<IndexLocation>^DHCMed.NINFService.Aim.CtlocAndAntiI</IndexLocation>
<StreamLocation>^DHCMed.NINFService.Aim.CtlocAndAntiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
