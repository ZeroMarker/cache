Class DHCMed.NINFService.Aim.InfSSISrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// ssi送检率、病原体统计  
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.InfSSISrv","QryPathDrug","2011-04-05","2012-09-29")                                                                                                                                              
Query QryPathDrug(DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "LocDesc:%String,surgeryClass:%String,surgeryClassCount:%String,InfNum:%String,InfRate:%String,PathCheckNum:%String,PathCheckRate:%String,ObjectCode1Num:%String,ObjectCode2Num:%String,ObjectCode3Num:%String,ObjectCode4Num:%String") [ SqlProc ]
{
}

ClassMethod QryPathDrugExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String) As %Status
{
                                                                                                                                                                                                                                                                                                                                                                                          
	Set repid=$I(^CacheTemp)                                                                                                                                                                                                                                                                                                                                                                     
	Set qHandle=$lb(0,repid,0)                                                                                                                                                                                                                                                                                                                                                                   
 	Set ind=1                                                                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                                                  
 	Set:DateFrom["-" DateFrom=$zdh(DateFrom, 3)         //日期格式转换                                                                                                                                                                                                                                                                                                                           
	Set:DateTo["-" DateTo=$zdh(DateTo, 3)                                                                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                                                                               
	Set:DateFrom["/" DateFrom=$zdh(DateFrom, 4)                                                                                                                                                                                                                                                                                                                                                  
	Set:DateTo["/" DateTo=$zdh(DateTo, 4)                                                                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                                                
    k ^CACHETMP("QryPathDrug")                                                                                                                                                                                                                                                                                                                                                                 
 	s sDate=DateFrom-1                                                                                                                                                                                                                                                                                                                                                                           
 	for  set sDate=$o(^DHCMed.CR.ReportI("DateLoc",sDate)) q:((sDate="")||(sDate>DateTo))  d      ///通过索引遍历找到                                                                                                                                                                                                                                                                            
 	.set RepCtloc=""                                                                                                                                                                                                                                                                                                                                                                             
 	.for  set RepCtloc=$o(^DHCMed.CR.ReportI("DateLoc",sDate,RepCtloc)) q:RepCtloc=""  d                                                                                                                                                                                                                                                                                                         
 	..s RowID=""                                                                                                                                                                                                                                                                                                                                                                                 
 	..for  set RowID=$o(^DHCMed.CR.ReportI("DateLoc",sDate,RepCtloc,RowID)) q:RowID=""  d                                                                                                                                                                                                                                                                                                        
 	...s RepObj=##class(DHCMed.CR.Report).%OpenId(RowID)                                                                                                                                                                                                                                                                                                                                         
 	...q:'$IsObject(RepObj)                                                                                                                                                                                                                                                                                                                                                                      
 	...set EpisodeID=RepObj.EpisodeID                                                                                                                                                                                                                                                                                                                                                            
 	...set SSIDR=$o(^DHCMed.NINF.Aim.SSII("CRReportDR"," "_RowID,""),-1)                                                                                                                                                                                                                                                                                                                              
 	...Quit:SSIDR=""
 	...set SSIObj=##class(DHCMed.NINF.Aim.SSI).GetObjById(SSIDR)                                                                                                                                                                                                                                                                                                                                      
 	...Quit:'$IsObject(SSIObj)                                                                                                                                                                                                                                                                                                                                                                   
 	...set LocDR=$p(^PAADM(EpisodeID),"^",4)                                                                                                                                                                                                                                                                                                                                                     
 	...Quit:LocDR=""                                                                                                                                                                                                                                                                                                                                                                             
 	...set surgeryClass=SSIObj.surgeryClass                                                                                                                                                                                                                                                                                                                                                    
 	...set:surgeryClass'="" Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass))                                                                                                                                                                                                                                                                                                                    
 	...set IfHosInf="否"
 	...set:$d(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID)) IfHosInf="是"                                                                                                                                                                                                                                                                                                                                                            
 	...set:IfHosInf="是" Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,"InfCount"))  
 	...set InfPos1Object1=SSIObj.InfPos1Object1
 	...set InfPos1Object2=SSIObj.InfPos1Object2   
 	...set InfPos1Object3=SSIObj.InfPos1Object3   
 	...set InfPos2Object1=SSIObj.InfPos2Object1   
 	...set InfPos2Object2=SSIObj.InfPos2Object2   
 	...set InfPos2Object3=SSIObj.InfPos2Object3   
 	...set InfPos3Object1=SSIObj.InfPos3Object1   
 	...set InfPos3Object2=SSIObj.InfPos3Object2   
 	...set InfPos3Object3=SSIObj.InfPos3Object3   
 	...set InfPos1Object1=SSIObj.InfPos1Object1                                                                                                                                                                                                                                                                                               
 	...set:InfPos1PathDate1'="" Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,"PathCount"))                                                                                                                                                                                                                                                                                   
	...set:InfPos1PathDate2'="" Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,"PathCount"))                                                                                                                                                                                                                                                                                   
	...set:InfPos1PathDate3'="" Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,"PathCount"))                                                                                                                                                                                                                                                                                   
	...set:InfPos2PathDate1'="" Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,"PathCount"))                                                                                                                                                                                                                                                                                   
	...set:InfPos2PathDate2'="" Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,"PathCount"))                                                                                                                                                                                                                                                                                   
	...set:InfPos2PathDate3'="" Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,"PathCount"))                                                                                                                                                                                                                                                                                   
	...set:InfPos3PathDate1'="" Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,"PathCount"))                                                                                                                                                                                                                                                                                   
	...set:InfPos3PathDate2'="" Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,"PathCount"))                                                                                                                                                                                                                                                                                   
	...set:InfPos3PathDate3'="" Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,"PathCount"))                                                                                                                                                                                                                                                                                   
	...set DrugList=$lb("大肠埃希氏菌","腐生葡萄球菌","表皮葡萄球菌","粪肠球菌")                                                                                                                                                                                                                                                                                                                 
    //...set InfPos1Object1=SSIObj.InfPos1Object1                                                                                                                                                                                                                                                                                                                                
	...set:InfPos1Object1'="" ObjectCode=$LisTFind(DrugList,InfPos1Object1)                                                                                                                                                                                                                                                                                                                      
	...set:ObjectCode>0 Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,ObjectCode))                                                                                                                                                                                                                                                                                            
	//...set InfPos1Object2=SSIObj.InfPos1Object2                                                                                                                                                                                                                                                                                                                                                  
	...set:InfPos1Object2'="" ObjectCode=$LisTFind(DrugList,InfPos1Object2)                                                                                                                                                                                                                                                                                                                      
	...set:ObjectCode>0 Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,ObjectCode))                                                                                                                                                                                                                                                                                            
	//...set InfPos1Object3=SSIObj.InfPos1Object3                                                                                                                                                                                                                                                                                                                                                  
	...set:InfPos1Object3'="" ObjectCode=$LisTFind(DrugList,InfPos1Object3)                                                                                                                                                                                                                                                                                                                      
	...set:ObjectCode>0 Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,ObjectCode))                                                                                                                                                                                                                                                                                            
	//...set InfPos2Object1=SSIObj.InfPos2Object1                                                                                                                                                                                                                                                                                                                                                  
	...set:InfPos2Object1'="" ObjectCode=$LisTFind(DrugList,InfPos2Object1)                                                                                                                                                                                                                                                                                                                      
	...set:ObjectCode>0 Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,ObjectCode))                                                                                                                                                                                                                                                                                            
	//...set InfPos2Object2=SSIObj.InfPos2Object2                                                                                                                                                                                                                                                                                                                                                  
	...set:InfPos2Object2'="" ObjectCode=$LisTFind(DrugList,InfPos2Object2)                                                                                                                                                                                                                                                                                                                      
	...set:ObjectCode>0 Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,ObjectCode))                                                                                                                                                                                                                                                                                            
	//...set InfPos2Object3=SSIObj.InfPos2Object3                                                                                                                                                                                                                                                                                                                                                  
	...set:InfPos2Object3'="" ObjectCode=$LisTFind(DrugList,InfPos2Object3)                                                                                                                                                                                                                                                                                                                      
	...set:ObjectCode>0 Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,ObjectCode))                                                                                                                                                                                                                                                                                            
	//...set InfPos3Object1=SSIObj.InfPos3Object1                                                                                                                                                                                                                                                                                                                                                  
	...set:InfPos3Object1'="" ObjectCode=$LisTFind(DrugList,InfPos3Object1)                                                                                                                                                                                                                                                                                                                      
	...set:ObjectCode>0 Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,ObjectCode))                                                                                                                                                                                                                                                                                            
	//...set InfPos3Object2=SSIObj.InfPos3Object2                                                                                                                                                                                                                                                                                                                                                  
	...set:InfPos3Object2'="" ObjectCode=$LisTFind(DrugList,InfPos3Object2)                                                                                                                                                                                                                                                                                                                      
	...set:ObjectCode>0 Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,ObjectCode))                                                                                                                                                                                                                                                                                            
	//...set InfPos3Object3=SSIObj.InfPos3Object3                                                                                                                                                                                                                                                                                                                                                  
	...set:InfPos3Object3'="" ObjectCode=$LisTFind(DrugList,InfPos3Object3)                                                                                                                                                                                                                                                                                                                      
	...set:ObjectCode>0 Tmp=$i(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,ObjectCode))                                                                                                                                                                                                                                                                                            
	                                                                                                                                                                                                                                                                                                                                                                                             
	                                                                                                                                                                                                                                                                                                                                                                                             
	set LocDR=""                                                                                                                                                                                                                                                                                                                                                                                 
	                                                                                                                                                                                                                                                                                                                                                                                             
	for  set LocDR=$o(^CACHETMP("QryPathDrug",LocDR)) q:LocDR=""  d                                                                                                                                                                                                                                                                                                                              
	.set (ObjectCode1Num,ObjectCode2Num,ObjectCode3Num,PathCheckRate,ObjectCode4Num,InfRate,PathCheckNum)=""                                                                                                                                                                                                                                                                                     
	.set LocDesc=$p(^CTLOC(LocDR),"^",2)                                                                                                                                                                                                                                                                                                                                                         
	.set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)                                                                                                                                                                                                                                                                                                                                                   
	.set surgeryClass=""                                                                                                                                                                                                                                                                                                                                                                         
	.set surgeryClassCount=""                                                                                                                                                                                                                                                                                                                                                                    
	.set InfNum=""                                                                                                                                                                                                                                                                                                                                                                               
	.for  set surgeryClass=$o(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass))  d                                                                                                                                                                                                                                                                                                     
	..set surgeryClassCount=$g(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass))                                                                                                                                                                                                                                                                                                       
	..set InfNum=$g(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,"InfCount"))                                                                                                                                                                                                                                                                                                       
	..set:(InfNum>0)&(surgeryClassCount>0) InfRate=$fn(InfNum/surgeryClassCount*100,"",2)_"%"                                                                                                                                                                                                                                                                                                    
	..set PathCheckNum=$g(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,"PathCount"))                                                                                                                                                                                                                                                                                                
	..set:(PathCheckNum>0)&(InfNum>0) PathCheckRate=$fn(PathCheckNum/InfNum*100,"",2)_"%"                                                                                                                                                                                                                                                                                                        
	..set ObjectCode=""                                                                                                                                                                                                                                                                                                                                                                          
	..for  set ObjectCode=$o(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,ObjectCode)) q:ObjectCode=""  d                                                                                                                                                                                                                                                                           
	...set:ObjectCode="1" ObjectCode1Num=$g(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,ObjectCode))                                                                                                                                                                                                                                                                               
	...set:ObjectCode="2" ObjectCode2Num=$g(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,ObjectCode))                                                                                                                                                                                                                                                                               
	...set:ObjectCode="3" ObjectCode3Num=$g(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,ObjectCode))                                                                                                                                                                                                                                                                               
	...set:ObjectCode="4" ObjectCode4Num=$g(^CACHETMP("QryPathDrug",LocDR,"surgeryClass",surgeryClass,ObjectCode))                                                                                                                                                                                                                                                                               
	...set Data=$lb(LocDesc,surgeryClass,surgeryClassCount,InfNum,InfRate,PathCheckNum,PathCheckRate,ObjectCode1Num,ObjectCode2Num,ObjectCode3Num,ObjectCode4Num)                                                                                                                                                                                                                                              
    ...set ^CacheTemp(repid,ind)=data                                                                                                                                                                                                                                                                                                                                                          
    ...set ind=ind+1                                                                                                                                                                                                                                                                                                                                                                           
	q $$$OK
}

ClassMethod QryPathDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathDrugExecute ]
{
                                                                                                                                                                                                                                                                                                                                                                                            
	Set repid=$LIST(qHandle,2)                                                                                                                                                                                                                                                                                                                                                                   
 	Kill ^CacheTemp(repid)                                                                                                                                                                                                                                                                                                                                                                       
	Quit $$$OK
}

ClassMethod QryPathDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathDrugExecute ]
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

/// 医院手术切口类型感染率统计
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.HDMSrv","QryCutTypeInf","2011-4-5","2012-5-29")
Query QryCutTypeInf(DateFrom As %String, DateTo As %String, DPLocDR As %String) As %Query(ROWSPEC = "LocDesc:%String,surgeryClass:%String,surgeryClassCount:%String,Level1Count:%String,Level1Inf:%String,Level1InfRate:%String,Level2Count:%String,Level2Inf:%String,Level2InfRate:%String,Level3Count:%String,Level3Inf:%String,Level3InfRate:%String,Level4Count:%String,Level4Inf:%String,Level4InfRate:%String")
{
}

ClassMethod QryCutTypeInfExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, DPLocDR As %String) As %Status
{
 
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 
 	Set:DateFrom["-" DateFrom=$zdh(DateFrom, 3)         //日期格式转换
	Set:DateTo["-" DateTo=$zdh(DateTo, 3)
 
	Set:DateFrom["/" DateFrom=$zdh(DateFrom, 4)
	Set:DateTo["/" DateTo=$zdh(DateTo, 4)
   
    k ^CACHETMP("QryCutTypeInf")
 	s sDate=DateFrom-1 
 	for  set sDate=$o(^DHCMed.CR.ReportI("DateLoc",sDate)) q:((sDate="")||(sDate>DateTo))  d      ///通过索引遍历找到
 	.set RepCtloc=""
 	.for  set RepCtloc=$o(^DHCMed.CR.ReportI("DateLoc",sDate,RepCtloc)) q:RepCtloc=""  d
 	..s RowID=""
 	..for  set RowID=$o(^DHCMed.CR.ReportI("DateLoc",sDate,RepCtloc,RowID)) q:RowID=""  d
 	...s RepObj=##class(DHCMed.CR.Report).%OpenId(RowID)
 	...q:'$IsObject(RepObj)
 	...set EpisodeID=RepObj.EpisodeID
 	...Quit:EpisodeID=""
 	...set SSIDR=$o(^DHCMed.NINF.Aim.SSII("CRReportDR"," "_RowID,""),-1)
 	...set SSIObj=##class(DHCMed.NINF.Aim.SSI).GetObjByID(SSIDR)
 	...Quit:'$IsObject(SSIObj)
 	...set LocDR=$p(^PAADM(EpisodeID),"^",4)
 	...Quit:LocDR=""
 	...quit:((DPLocDR'="")&&(LocDR'=DPLocDR))
 	...set surgeryClass=SSIObj.surgeryClass
 	...set Tmp=$i(^CACHETMP("QryCutTypeInf",LocDR,"surgeryClass",surgeryClass))
 	...set CutLevel=SSIObj.CutLevel
 	...set Tmp=$i(^CACHETMP("QryCutTypeInf",LocDR,"surgeryClass",surgeryClass,"CutLevel",CutLevel))
 	...set IfHosInf="否"
 	...set:$d(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID)) IfHosInf="是"
 	...set:IfHosInf="是" Tmp=$i(^CACHETMP("QryCutTypeInf",LocDR,"surgeryClass",surgeryClass,"CutLevel",CutLevel,"InfCount"))
 	
 	set LocDR=""
 	set (Level1Count,Level1Inf,Level2Count,Level2Inf,Level3Count,Level3Inf,Level4Count,Level4Inf)=""
 	set (Level1InfRate,Level2InfRate,Level3InfRate,Level4InfRate)="0"
 	for  set LocDR=$o(^CACHETMP("QryCutTypeInf",LocDR)) q:LocDR=""  d
 	.set LocDesc=$p(^CTLOC(LocDR),"^",2)
 	.set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
 	.set surgeryClass=""
 	.set surgeryClassCount=""
 	.for  set surgeryClass=$o(^CACHETMP("QryCutTypeInf",LocDR,"surgeryClass",surgeryClass))  d
 	..set surgeryClassCount=$g(^CACHETMP("QryCutTypeInf",LocDR,"surgeryClass",surgeryClass))
 	..set CutLevel=""
 	..for  set CutLevel=$o(^CACHETMP("QryCutTypeInf",LocDR,"surgeryClass",surgeryClass,"CutLevel",CutLevel))  d
	...set:CutLevel="I" Level1Count=$g(^CACHETMP("QryCutTypeInf",LocDR,"surgeryClass",surgeryClass,"CutLevel",CutLevel))
 	...set:CutLevel="I" Level1Inf=$g(^CACHETMP("QryCutTypeInf",LocDR,"surgeryClass",surgeryClass,"CutLevel",CutLevel,"InfCount"))
 	...set:CutLevel="II" Level2Count=$g(^CACHETMP("QryCutTypeInf",LocDR,"surgeryClass",surgeryClass,"CutLevel",CutLevel))
 	...set:CutLevel="II" Level2Inf=$g(^CACHETMP("QryCutTypeInf",LocDR,"surgeryClass",surgeryClass,"CutLevel",CutLevel,"InfCount"))
 	...set:CutLevel="III" Level3Count=$g(^CACHETMP("QryCutTypeInf",LocDR,"surgeryClass",surgeryClass,"CutLevel",CutLevel))
 	...set:CutLevel="III" Level3Inf=$g(^CACHETMP("QryCutTypeInf",LocDR,"surgeryClass",surgeryClass,"CutLevel",CutLevel,"InfCount"))
 	...set:CutLevel="IV" Level4Count=$g(^CACHETMP("QryCutTypeInf",LocDR,"surgeryClass",surgeryClass,"CutLevel",CutLevel))
 	...set:CutLevel="IV" Level4Inf=$g(^CACHETMP("QryCutTypeInf",LocDR,"surgeryClass",surgeryClass,"CutLevel",CutLevel,"InfCount"))
 	...set:((Level1Inf>0)&(Level1Count>0)) Level1InfRate=$fn(Level1Inf/Level1Count*100,"",2)_"%"
 	...set:((Level2Inf>0)&(Level2Count>0)) Level2InfRate=$fn(Level2Inf/Level2Count*100,"",2)_"%"
 	...set:((Level3Inf>0)&(Level3Count>0)) Level3InfRate=$fn(Level3Inf/Level3Count*100,"",2)_"%"
 	...set:((Level4Inf>0)&(Level4Count>0)) Level4InfRate=$fn(Level4Inf/Level4Count*100,"",2)_"%"
 	...set Data=$lb(LocDesc,surgeryClass,surgeryClassCount,Level1Count,Level1Inf,Level1InfRate,Level2Count,Level2Inf,Level2InfRate,Level3Count,Level3Inf,Level3InfRate,Level4Count,Level4Inf,Level4InfRate)
	...set ^CacheTemp(repid,ind)=data
    ...set ind=ind+1
	q $$$OK
}

ClassMethod QryCutTypeInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCutTypeInfExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCutTypeInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCutTypeInfExecute ]
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
