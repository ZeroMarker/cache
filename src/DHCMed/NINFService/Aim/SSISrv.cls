Class DHCMed.NINFService.Aim.SSISrv Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

///  d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.SSISrv","QuerySSIByCR","2011-4-5","2012-5-29")
Query QuerySSIByCR(DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "RepCtloc:%String,InfCount:%String,InfRate:%String,ShInciCount:%String,ShInciRate:%String,DeepWoundCount:%String,DeepWoundRate:%String,OrganLacCount:%String,OrganLacRate:%String")
{
}

ClassMethod QuerySSIByCRExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	k ^CACHETMP("SSIByCR")
 	Set:DateFrom["-" DateFrom=$zdh(DateFrom, 3)         //日期格式转换
	Set:DateTo["-" DateTo=$zdh(DateTo, 3)
	Set:DateFrom["/" DateFrom=$zdh(DateFrom, 4)
	Set:DateTo["/" DateTo=$zdh(DateTo, 4)
	set preturn=""
 	set sDate=DateFrom-1
    //录入数据
 	for {
	 	set sDate=$o(^DHCMed.CR.ReportI("DateLoc",sDate)) 
 	    quit:((sDate="")||(sDate>DateTo))
	 	set RepCtloc=""
	 	for {   
	 	    set RepCtloc=$o(^DHCMed.CR.ReportI("DateLoc",sDate,RepCtloc))
	 	    quit:RepCtloc="" 
		 	set rowid=""
		 	for {   
		 	    set rowid=$o(^DHCMed.CR.ReportI("DateLoc",sDate,RepCtloc,rowid))
		 	    quit:rowid=""
			 	set ^CACHETMP("SSIByCR",RepCtloc,rowid)=""
			   }
		    }
	}
	
	///对数据进性操作
	set CheckedCount="0"                   ///实际检查人数
	set InfCount="0"                       ///感染人数
	set InfRate="0"                         
	set ShInciCount="0"                    ///表浅切口感染人数
	set ShInciRate="0"
	set DeepWoundCount="0"                 ///深部切口感染人数
	set DeepWoundRate="0"
	set OrganLacCount="0"                  ///器官腔隙感染人数
	set OrganLacRate="0"
	set TotalCheckedCount="0"          
	set TotalInfCount="0"            
	set TotalInfRate="0"
	set TotalShInciCount="0"
	set TotalShInciRate="0"
	set TotalDeepWoundCount="0"
	set TotalDeepWoundRate="0"
	set TotalOrganLacCount="0"
	set TotalOrganLacRate="0"
	
	set RepCtloc=""
 	for {
	 	 set RepCtloc=$o(^CACHETMP("SSIByCR",RepCtloc))
	 	 quit:RepCtloc="" 
	 	 for {
		 	 set rowid=$o(^CACHETMP("SSIByCR",RepCtloc,rowid)) 
		 	 q:rowid=""  
	         set obj=##class(DHCMed.CR.Report).%OpenId(rowid)
             quit:'$IsObject(obj)
             set EpisodeID=""
	         set EpisodeID=obj.EpisodeID
	         set CtLocDR=$p(^PAADM(EpisodeID),"^",4)
	         quit:CtLocDR=""
	         set SSIRowid=$o(^DHCMed.INF.SSII("CRReportDRIndex"," "_rowid,""),-1)
	         set preturn=##class(DHCMed.INF.SSI).GetObjById(SSIRowid)
	         Continue:'$IsObject(preturn)
	         set tmpChecked=$i(^CACHETMP("SSIByCR",CtLocDR,"CheckedNum")) ///实查人数查询
	         if (preturn.IfHosInf="是")
	         {                               
		          set InfNum=$i(^CACHETMP("SSIByCR",CtLocDR,"InfNum")) ///感染人数查询
	          	 	}
	         set IfHosInf=preturn.IfHosInf
	         set InfPos1=preturn.InfPos1
	         set surgeryClass=preturn.surgeryClass
	         q:IfHosInf'="是"
	       	 set ^CACHETMP("SSIByCR",CtLocDR,"SSI","surgeryClassNum")=surgeryClass
			 if (InfPos1["表浅切口"){
	         	set tmpShInci=$i(^CACHETMP("SSIByCR",CtLocDR,"SSI","ShInciNum")) 
	         		}
	         if (InfPos1["深部切口"){ 
	         	set tmpDeepWound=$i(^CACHETMP("SSIByCR",CtLocDR,"SSI","DeepWoundNum"))
	         		} 
	         if (InfPos1["器官腔隙"){
	         	set tmpOrganLac=$i(^CACHETMP("SSIByCR",CtLocDR,"SSI","OrganLacNum"))
	 	     		}
		 	 }
 		}
	set RepCtloc=""
    for {
	      set RepCtloc=$o(^CACHETMP("SSIByCR",RepCtloc)) 
		  quit:RepCtloc="" 
		  set CheckedCount=$g(^CACHETMP("SSIByCR",RepCtloc,"CheckedNum"))
		  set surgeryClass=$g(^CACHETMP("SSIByCR",CtLocDR,"SSI","surgeryClasssNum"))
		  set InfCount=$g(^CACHETMP("SSIByCR",RepCtloc,"InfNum")) 
		  set ShInciCount=$g(^CACHETMP("SSIByCR",RepCtloc,"SSI","ShInciNum"))
	 	  set DeepWoundCount=$g(^CACHETMP("SSIByCR",RepCtloc,"SSI","DeepWoundNum"))
		  set OrganLacCount=$g(^CACHETMP("SSIByCR",RepCtloc,"SSI","OrganLacNum")) 
		  set:((InfCount>0)&(CheckedCount>0)) InfRate=$fn((InfCount)/CheckedCount*100,"",2)_"%" 
    	  set:((ShInciCount>0)&(InfCount>0)) ShInciRate=$fn((ShInciCount)/InfCount*100,"",2)_"%"
    	  set:((DeepWoundCount>0)&(InfCount>0)) DeepWoundRate=$fn((DeepWoundCount)/InfCount*100,"",2)_"%"
		  set:((OrganLacCount>0)&(InfCount>0)) OrganLacRate=$fn((OrganLacCount)/InfCount*100,"",2)_"%"
		  set TotalCheckedCount=TotalCheckedCount+CheckedCount
		  set TotalInfCount=TotalInfCount+InfCount
		  set TotalShInciCount=TotalShInciCount+ShInciCount
		  set TotalDeepWoundCount=TotalDeepWoundCount+DeepWoundCount
		  set TotalOrganLacCount=TotalOrganLacCount+OrganLacCount
		  set RepCtlocDesc=""
	      if (+RepCtloc'=0) {
	          s LocObj=##class(DHCMed.Base.Ctloc).GetObjById(+RepCtloc)
	          q:'$IsObject(LocObj)
	          s RepCtlocDesc=LocObj.Descs
			  s:RepCtlocDesc["-" RepCtlocDesc=$p(RepCtlocDesc,"-",2)
	          }
		  q:RepCtlocDesc=""
		  
		  set $li(data,1)=RepCtlocDesc
		  set $li(data,2)=surgeryClass
		  set $li(data,3)=InfCount
		  set $li(data,4)=InfRate
		  set $li(data,5)=ShInciCount
		  set $li(data,6)=ShInciRate
		  set $li(data,7)=DeepWoundCount
		  set $li(data,8)=DeepWoundRate
		  set $li(data,9)=OrganLacCount
		  set $li(data,10)=OrganLacRate
		  set ^CacheTemp(repid,ind)=data
    	  set ind=ind+1
		  }
	set:((TotalInfCount>0)&(TotalCheckedCount>0)) TotalInfRate=$fn((TotalInfCount)/TotalCheckedCount*100,"",2)_"%" 
    set:((TotalShInciCount>0)&(TotalInfCount>0)) TotalShInciRate=$fn((TotalShInciCount)/TotalInfCount*100,"",2)_"%"
    set:((TotalDeepWoundCount>0)&(TotalInfCount>0)) TotalDeepWoundRate=$fn((TotalDeepWoundCount)/TotalInfCount*100,"",2)_"%"
	set:((TotalOrganLacCount>0)&(TotalInfCount>0)) TotalOrganLacRate=$fn((TotalOrganLacCount)/TotalInfCount*100,"",2)_"%"
    			
    set $li(data,1)=RepCtlocDesc
    set $li(data,2)=surgeryClass
    set $li(data,3)=InfCount
	set $li(data,4)=InfRate
	set $li(data,5)=ShInciCount
	set $li(data,6)=ShInciRate
	set $li(data,7)=DeepWoundCount
	set $li(data,8)=DeepWoundRate
	set $li(data,9)=OrganLacCount
	set $li(data,10)=OrganLacRate
	               
	Quit $$$OK
}

ClassMethod QuerySSIByCRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySSIByCRExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QuerySSIByCRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySSIByCRExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				                 // if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				                // fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	                                       // Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2012-08-15
/// Description:  查询一段时间内出院患者的手术患者感染率
/// Table：       DHCMed.NINFService.Aim.SSISrv
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.SSISrv","QrySSIInfRate","2012-01-01","2012-10-10")
Query QrySSIInfRate(DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "OperName:%String,TotalPatNum:%String,InfNum:%String,InfNumRate:%String,OutsideCut:%String,OutsideCutRate:%String,DeepCut:%String,DeepCutRate:%String,Lacuna:%String,LacunaRate:%String") [ SqlProc ]
{
}

ClassMethod QrySSIInfRateExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:DateFrom="" $$$OK
	q:DateTo="" $$$OK
	
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateFrom["/" DateFrom=$zdh(DateFrom,1)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s:DateTo["/" DateTo=$zdh(DateTo,1)
	
	s SSIEPRProjectID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("SSIEPRProjectID","")
	q:SSIEPRProjectID="" $$$OK
	
	k ^CacheTemp("DHCMedQrySSIInfRate")
	
	s InfPatNum=0,InfIOpeNum=0,InfWJNum=0

    Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引	
	f DischDate=DateFrom:1:DateTo d
    .s Paadm=0
	.f  s Paadm=$o(^PAADMi(DischDateIndex,DischDate,Paadm)) q:Paadm=""  d
	..s AdmInfo=$g(^PAADM(Paadm))
	..q:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
	..q:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
	..//Continue:$d(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",Paadm))  //招回病人不算出院
	..s DepartmentID=$p(AdmInfo,"^",4)
	..q:DepartmentID=""
	..;s ^CacheTemp("DHCMedQrySSIInfRate",DepartmentID,"PAADM",Paadm)=""
	..q:'$d(^DHCMed.CR.ReportI("EpisodeID"," "_Paadm))
	..s RepID=""
	..f  s RepID=$o(^DHCMed.CR.ReportI("EpisodeID"," "_Paadm,RepID)) q:RepID=""  d
	...s PrjID=$li(^DHCMed.CR.ReportD(RepID),3)
	...s RepStatus=$li(^DHCMed.CR.ReportD(RepID),5)
	...q:PrjID'=SSIEPRProjectID		//该报告不是SSI医院感染病例监测报告
	...q:(RepStatus="R")||(RepStatus="S")	//删除或退回报告数据不计算
	...q:'$d(^DHCMed.NINF.Aim.SSII("CRReportDR"," "_RepID))
	...s SSIRepID=$o(^DHCMed.NINF.Aim.SSII("CRReportDR"," "_RepID,""),-1)
	...q:SSIRepID=""
	...s obj=##class(DHCMed.NINF.Aim.SSI).GetObjById(SSIRepID)
	...q:'$IsObject(obj)
	...s OperName=obj.surgeryName
	...q:OperName=""
	...s ^CacheTemp("DHCMedSSIOperName",OperName,"PAADM",Paadm)=""
	
	s (tTotalPatNum,tInfNum,tInfRate,tOutsideCut,tOutsideCutRate,tDeepCut,tOutsideCutRate,tLacuna,tLacunaRate)=0
	s OperName=""
	f  s OperName=$o(^CacheTemp("DHCMedSSIOperName",OperName)) q:OperName=""  d
	.;总人数，感染人数，感染率，表浅切口人数，表浅切口感染率，深部切口人数，深部切口感染率，器官或腔隙切口人数，器官或腔隙感染率
	.s (TotalPatNum,InfNum,InfRate,OutsideCut,OutsideCutRate,DeepCut,OutsideCutRate,Lacuna,LacunaRate)=0
	.s Paadm=""
	.f  s Paadm=$o(^CacheTemp("DHCMedSSIOperName",OperName,"PAADM",Paadm)) q:Paadm=""  d
	..s TotalPatNum=TotalPatNum+1	//总人数
	
	..q:'$d(^DHCMed.NINFi("InfRep",0,"IndexPaadm",Paadm))
	..s InfNum=InfNum+1		//感染人数 
	..s RepID=""
	..f  s RepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",Paadm,RepID)) q:RepID=""  d
	...q:'$d(^DHCMed.NINF("InfRep",RepID))
	...s obj=##class(DHCMed.NINF.Rep.InfReport).GetObjById(RepID)
	...q:'$IsObject(obj)
	...s ReportStatus=obj.ReportStatus
	...q:'$IsObject(ReportStatus)
	...s ReportStatusCode=ReportStatus.Code
	...q:(ReportStatusCode=0)||(ReportStatus=5)	//删除或退回报告不计算
	...s SubID=""
	...f  s SubID=$o(^DHCMed.NINF("InfRep",RepID,"InfPos",SubID)) q:SubID=""  d
	....s SubObj=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(RepID_"||"_SubID)
	....q:'$IsObject(SubObj)
	....s InfPos=SubObj.InfPos
	....q:'$IsObject(InfPos)
	....s InfPosDesc=InfPos.IPDesc
	....q:InfPosDesc=""
	....i InfPosDesc["表浅" d
	.....s OutsideCut=OutsideCut+1
	....e  i InfPosDesc["深部" d
	.....s DeepCut=DeepCut+1
	....e  i (InfPosDesc["器官")||(InfPosDesc["腔隙")  d
	.....s Lacuna=Lacuna+1
	
	.s:(TotalPatNum>0)&&(InfNum>0) InfRate=$fn((InfNum/TotalPatNum)*100,"",2)_"%" //感染率
	.s:(InfNum>0)&&(OutsideCut>0) OutsideCutRate=$fn((OutsideCut/InfNum)*100,"",2)_"%" //表浅切口感染率
	.s:(InfNum>0)&&(DeepCut>0) DeepCutRate=$fn((DeepCut/InfNum)*100,"",2)_"%" //深部切口感染率
	.s:(InfNum>0)&&(Lacuna>0) LacunaRate=$fn((Lacuna/InfNum)*100,"",2)_"%" //器官或腔隙感染率
	
	.s tTotalPatNum=tTotalPatNum+TotalPatNum
	.s tInfNum=tInfNum+InfNum
	.s tOutsideCut=tOutsideCut+OutsideCut
	.s tDeepCut=tDeepCut+DeepCut
	.s tLacuna=tLacuna+Lacuna
	
	.s Data=$lb(OperName,TotalPatNum,InfNum,InfRate,OutsideCut,OutsideCutRate,DeepCut,DeepCutRate,Lacuna,LacunaRate)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	
	s:(tTotalPatNum>0)&&(tInfNum>0) tInfRate=$fn((tInfNum/tTotalPatNum)*100,"",2)_"%" //感染率
	s:(tInfNum>0)&&(tOutsideCut>0) tOutsideCutRate=$fn((tOutsideCut/tInfNum)*100,"",2)_"%" //表浅切口感染率
	s:(tInfNum>0)&&(tDeepCut>0) tDeepCutRate=$fn((tDeepCut/tInfNum)*100,"",2)_"%" //深部切口感染率
	s:(tInfNum>0)&&(tLacuna>0) tLacunaRate=$fn((tLacuna/tInfNum)*100,"",2)_"%" //器官或腔隙感染率
	
	s Data=$lb("合计",tTotalPatNum,tInfNum,tInfRate,tOutsideCut,tOutsideCutRate,tDeepCut,tDeepCutRate,tLacuna,tLacunaRate)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QrySSIInfRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySSIInfRateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySSIInfRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySSIInfRateExecute ]
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

ClassMethod GetPipeDaysInfo(sDate As %String, eDate As %String, LocID As %String, EpisodeID As %String, PipeType As %String) As %String
{
	n (sDate,eDate,LocID,EpisodeID,PipeType)
	
	s ret=""

	q:(sDate="")||(sDate="") ret
	
	s sDate=$p(sDate," ",1)
	s eDate=$p(eDate," ",1)
	s sDate=$zdh(sDate,3)
	s eDate=$zdh(eDate,3)
	
	f i=sDate:1:eDate d
	.s ^CacheTemp("DHCMedQrySSIInfRate",LocID,"PAADM",EpisodeID,PipeType,i)=""
	
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2012-08-18
/// Description:  查询一段时间内出院患者的手术患者感染率
/// Table：       DHCMed.NINFService.Aim.SSISrv
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.SSISrv","QrySSIOpeTypeInfRate","2012-01-01","2012-10-10")
Query QrySSIOpeTypeInfRate(DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "LocDesc:%String,OpeType:%String,RepNum:%String,Cut1Num:%String,Cut1InfNum:%String,Cut1InfRate:%String,Cut2Num:%String,Cut2InfNum:%String,Cut2InfRate:%String,Cut3Num:%String,Cut3InfNum:%String,Cut3InfRate:%String") [ SqlProc ]
{
}

ClassMethod QrySSIOpeTypeInfRateExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:DateFrom="" $$$OK
	q:DateTo="" $$$OK
	
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateFrom["/" DateFrom=$zdh(DateFrom,1)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s:DateTo["/" DateTo=$zdh(DateTo,1)
	
	s SSIEPRProjectID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("SSIEPRProjectID","")
	q:SSIEPRProjectID="" $$$OK
	
	k ^CacheTemp("DHCMedSSIOperType")
	
	s InfPatNum=0,InfIOpeNum=0,InfWJNum=0

    Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引	
	f DischDate=DateFrom:1:DateTo d
    .s Paadm=0
	.f  s Paadm=$o(^PAADMi(DischDateIndex,DischDate,Paadm)) q:Paadm=""  d
	..s AdmInfo=$g(^PAADM(Paadm))
	..q:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
	..q:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
	..//Continue:$d(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",Paadm))  //招回病人不算出院
	..s DepartmentID=$p(AdmInfo,"^",4)
	..q:DepartmentID=""
	..;s ^CacheTemp("DHCMedSSIOperType",DepartmentID,"PAADM",Paadm)=""
	..q:'$d(^DHCMed.CR.ReportI("EpisodeID"," "_Paadm))
	..s RepID=""
	..f  s RepID=$o(^DHCMed.CR.ReportI("EpisodeID"," "_Paadm,RepID)) q:RepID=""  d
	...s PrjID=$li(^DHCMed.CR.ReportD(RepID),3)
	...s RepStatus=$li(^DHCMed.CR.ReportD(RepID),5)
	...q:PrjID'=SSIEPRProjectID		//该报告不是SSI医院感染病例监测报告
	...q:(RepStatus="R")||(RepStatus="S")	//删除或退回报告数据不计算
	...q:'$d(^DHCMed.NINF.Aim.SSII("CRReportDR"," "_RepID))
	...s SSIRepID=$o(^DHCMed.NINF.Aim.SSII("CRReportDR"," "_RepID,""),-1)
	...q:SSIRepID=""
	...s obj=##class(DHCMed.NINF.Aim.SSI).GetObjById(SSIRepID)
	...q:'$IsObject(obj)
	...s surgeryClass=obj.surgeryClass	//手术类型：急诊、择期
	...q:surgeryClass=""
	...s ^CacheTemp("DHCMedSSIOperType",DepartmentID,"OpeType",surgeryClass,"CRRep",RepID)=""
	
	s (TRepNum,TCut1Num,TCut1InfNum,TCut1InfRate,TCut2Num,TCut2InfNum,TCut2InfRate,TCut3Num,TCut3InfNum,TCut3InfRate)=0
	s DepID=""
	f  s DepID=$o(^CacheTemp("DHCMedSSIOperType",DepID)) q:DepID=""  d
	.s OpeTypeList=$lb("急诊","择期")
	.f i=1:1:$ll(OpeTypeList) d
	..s (RepNum,Cut1Num,Cut1InfNum,Cut1InfRate,Cut2Num,Cut2InfNum,Cut2InfRate,Cut3Num,Cut3InfNum,Cut3InfRate)=0
	..s OpeType=$li(OpeTypeList,i)
	..i $d(^CacheTemp("DHCMedSSIOperType",DepID,"OpeType",OpeType)) d
	...s RepID=""
	...f  s RepID=$o(^CacheTemp("DHCMedSSIOperType",DepID,"OpeType",OpeType,"CRRep",RepID))  q:RepID=""  d
	....s str=##class(DHCMed.CR.Report).GetById(RepID)
	....q:str=""
	....s EpisodeID=$p(str,"^",4)
	....q:'$d(^DHCMed.NINF.Aim.SSII("CRReportDR"," "_RepID))
	....s SSIRepID=$o(^DHCMed.NINF.Aim.SSII("CRReportDR"," "_RepID,""),-1)
	....q:SSIRepID=""
	....s obj=##class(DHCMed.NINF.Aim.SSI).GetObjById(SSIRepID)
	....q:'$IsObject(obj)
	....s CutLevel=obj.CutLevel	//切口类型：I、II、III
	....q:CutLevel=""
	....s RepNum=RepNum+1
	....i (CutLevel="I")||(CutLevel="Ｉ") d
	.....s Cut1Num=Cut1Num+1
	.....s:$d(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID)) Cut1InfNum=Cut1InfNum+1
	....i (CutLevel="II")||(CutLevel="Ⅱ") d
	.....s Cut2Num=Cut2Num+1
	.....s:$d(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID)) Cut2InfNum=Cut2InfNum+1
	....i (CutLevel="III")||(CutLevel="Ⅲ") d
	.....s Cut3Num=Cut3Num+1
	.....s:$d(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID)) Cut3InfNum=Cut3InfNum+1
	
	..s TRepNum=TRepNum+RepNum
	..s TCut1Num=TCut1Num+Cut1Num
	..s TCut1InfNum=TCut1InfNum+Cut1InfNum
	..s TCut2Num=TCut2Num+Cut2Num
	..s TCut2InfNum=TCut2InfNum+Cut2InfNum
	..s TCut3Num=TCut3Num+Cut3Num
	..s TCut3InfNum=TCut3InfNum+Cut3InfNum
	
	..s:(Cut1Num>0)&&(Cut1InfNum>0) Cut1InfRate=$fn((Cut1InfNum/Cut1Num)*100,"",2)_"%"
	..s:(Cut2Num>0)&&(Cut2InfNum>0) Cut2InfRate=$fn((Cut2InfNum/Cut2Num)*100,"",2)_"%"
	..s:(Cut3Num>0)&&(Cut3InfNum>0) Cut3InfRate=$fn((Cut3InfNum/Cut3Num)*100,"",2)_"%"
	
	..s LocDesc=$p($g(^CTLOC(DepID)),"^",2)
    ..s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)	//科室
    
	..s Data=$lb(LocDesc,OpeType,RepNum,Cut1Num,Cut1InfNum,Cut1InfRate,Cut2Num,Cut2InfNum,Cut2InfRate,Cut3Num,Cut3InfNum,Cut3InfRate)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
	
	..s:(TCut1Num>0)&&(TCut1InfNum>0) TCut1InfRate=$fn((TCut1InfNum/TCut1Num)*100,"",2)_"%"
	..s:(TCut2Num>0)&&(TCut2InfNum>0) TCut2InfRate=$fn((TCut2InfNum/TCut2Num)*100,"",2)_"%"
	..s:(TCut3Num>0)&&(TCut3InfNum>0) TCut3InfRate=$fn((TCut3InfNum/TCut3Num)*100,"",2)_"%"
	
	
	s Data=$lb("全院","急诊/择期",TRepNum,TCut1Num,TCut1InfNum,TCut1InfRate,TCut2Num,TCut2InfNum,TCut2InfRate,TCut3Num,TCut3InfNum,TCut3InfRate)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QrySSIOpeTypeInfRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySSIOpeTypeInfRateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySSIOpeTypeInfRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySSIOpeTypeInfRateExecute ]
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

Storage Default
{
<Data name="SSISrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFService.Aim.SSISrvD</DataLocation>
<DefaultData>SSISrvDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFService.Aim.SSISrvD</IdLocation>
<IndexLocation>^DHCMed.NINFService.Aim.SSISrvI</IndexLocation>
<StreamLocation>^DHCMed.NINFService.Aim.SSISrvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
