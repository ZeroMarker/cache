Import SQLUser

Class web.DHCMedEpidemicApp Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 121;

ClassMethod QueryByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryByDateExecute(ByRef qHandle As %Binary, cDateFrom As %String, cDateTo As %String, cDep As %String, cLoc As %String, cStatus As %String, cPlace As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

    //s ^CacheTemp("1")=cDateFrom_"/"_cDateTo_"/"_cDep_"/"_cLoc_"/"_cStatus_"/"_cPlace
    //s:cDateFrom'="" cDateFrom=$zd($zdh(cDateFrom,4),3)
    //s:cDateTo'="" cDateTo=$zd($zdh(cDateTo,4),3)
	//s:cDateFrom["/" cDateFrom=$zdh(cDateFrom)
	//s:cDateTo["/" cDateTo=$zdh(cDateTo)
	s:cDateFrom'="" cDateFrom=$zd(cDateFrom,3)
	s:cDateTo'="" cDateTo=$zd(cDateTo,3)
	q:(cDateFrom="")!(cDateTo="") $$$OK
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s Ret=$$Query^DHCMedEpidemicApp(cDateFrom,cDateTo,cDep,cLoc,cStatus,cPlace)
	zn CurrentNS
	q:+Ret<0 $$$OK
	s iCount=+Ret
	s JIndex=$p(Ret,"^",2)
	f IndexApp=0:1:iCount d
	.zn MEDDATA
	.s s=$$GetDataByIndex^DHCMedEpidemicApp(JIndex,IndexApp)
	.s sPat=$$GetPatInfo^DHCMedBase(+$p(s,"^",2))
	.s MepdRowid=""
	.s iSubCount=$$GetAppSub^DHCMedEpidemicApp(+$p(s,"^",1))
	.i iSubCount'<0  d
	..s TempSub=$p(PLIST(iSubCount),$c(1),1)
	..;w !,TempSub
	..s MepdRowid=$p(TempSub,"^",10)
	.;w !,"---  "_MepdRowid
	.zn CurrentNS
	.d BuildData
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildData      
	;set Data=$lb(id,code,desc,Fpfl,Lb)	
	set Data=$lb("")
	s:$p(s,"^",4)'="" $p(s,"^",4)=##class(web.DHCMedDictoryCtl).GetByTypeCode("EpidemicPatientType",$p(s,"^",4))
	s:$p(s,"^",15)'="" $p(s,"^",15)=##class(web.DHCMedDictoryCtl).GetByTypeCode("EpidemicEvaluationType",$p(s,"^",15))
	s:$p(s,"^",7)'="" $p(s,"^",7)=##class(web.DHCMedDictoryCtl).GetByTypeCode("EpidemicDiagnoseEvaluation",$p(s,"^",7))
	s:$p(s,"^",8)'="" $p(s,"^",8)=##class(web.DHCMedDictoryCtl).GetByTypeCode("EpidemicReportEvaluation",$p(s,"^",8))
	s:$p(s,"^",9)'="" $p(s,"^",9)=##class(web.DHCMedDictoryCtl).GetByTypeCode("EpidemicQualityEvaluation",$p(s,"^",9))
	
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild) 	
 	s $li(Data,$l(s,"^")+1)=$p(sPat,$c(2),1)    //Name
 	s $li(Data,$l(s,"^")+2)=MepdRowid    //MepdRowid
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByDateExecute ]
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

Query QueryByDate(cDateFrom As %String, cDateTo As %String, cDep As %String, cLoc As %String, cStatus As %String, cPlace As %String) As %Query(ROWSPEC = "MEARowid:%String,MEAPapmiDR:%String,MEAMICDR:%String,MEAPlace:%String,MEACtlocDR:%String,MEADutyUserDR:%String,MEADiagnose:%String,MEAReport:%String,MEANature:%String,MEAUserDR:%String,MEADate:%String,MEATime:%String,MEADemo:%String,MEAOccDate:%String,MEAAppStatus:%String,MEAName:%String,MepdRowid:%String")
{
}

ClassMethod QueryAppSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryAppSubExecute(ByRef qHandle As %Binary, EpdaRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	;s MepdaRowid="1"
	//s ^CacheTemp("wuqk")=EpdaRowid
	q:EpdaRowid="" $$$OK
	
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$GetAppSub^DHCMedEpidemicApp(EpdaRowid)
	zn CurrentNS
    q:ret<0 $$$OK
    
    s s0="辅检类型^辅检号^项目代码^项目名称^项目结果^审核日期^审核时间^医嘱日期^医嘱时间^医嘱科室^医嘱部门^医嘱人代码^医嘱人姓名^临床诊断^诊断日期^诊断时间^诊断科室^诊断部门^诊断人代码^诊断人姓名^传染病报告^发病日期^诊断日期^死亡日期^报告日期^报告时间^报告科室^报告部门^报告人代码^报告人姓名^死亡^死亡日期^报告日期^时间^科室^部门^报告人代码^姓名^手术"
    s s1=PLIST(0)
    s s2=""
    s:ret>0 s2=PLIST(ret)
    ;d BuildListData
    d ..Buildsub(repid,ind,s0,s1,s2)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	/*
BuildListData      
    s s1=$$BuildOutString(s1)
    s s2=$$BuildOutString(s2)
    f i=1:1:$l(s0,"^") d
    .set Data=$lb($p(s0,"^",i),$p(s1,"^",i),$p(s2,"^",i))
    .Set ^CacheTemp(repid,ind)=Data
 	.Set ind=ind+1
 	q
BuildOutString(s)
   n (s)
   s sOut=""
   q:s="" sOut
   s subInfo=$p(s,$c(1),1)
   s OrdInfo=$p(s,$c(1),2)  
   s sMIFC=$p(s,$c(1),3)
   s sMRDIA=$p(s,$c(1),4)
   s EPDInfo=$p(s,$c(1),5)
   s DeathInfo=$p(s,$c(1),6)
   ;w !,sMRDIA
   
   s $p(sOut,"^",1 )=$p(sMIFC,"^",2)            ///辅检类型d
   s:$p(sOut,"^",1)'="" $p(sOut,"^",1)=##class(web.DHCMedDictoryCtl).GetByTypeCode("EpidemicWatchItemType",$p(sOut,"^",1))
   s $p(sOut,"^",2 )=$p(subInfo,"^",3)            ///辅检号            
   s $p(sOut,"^",3 )=$p($p(sMIFC,"^",3),"||",1)            ///项目代码          
   s $p(sOut,"^",4 )=$p(sMIFC,"^",4)            ///项目名称          
   s $p(sOut,"^",5 )=$p(subInfo,"^",5)            ///项目结果          
   s $p(sOut,"^",6 )=$p(subInfo,"^",6)            ///审核日期          
   s $p(sOut,"^",7 )=$p(subInfo,"^",7)            ///审核时间          
   s $p(sOut,"^",8 )=$p(OrdInfo,$c(2),4)            ///医嘱日期          
   s $p(sOut,"^",9 )=$p(OrdInfo,$c(2),5)            ///医嘱时间          
   s $p(sOut,"^",10)=$p(OrdInfo,$c(2),7)            ///医嘱科室          
   s $p(sOut,"^",11)=$p($p(OrdInfo,$c(2),7),"/",2)            ///医嘱部门          
   s $p(sOut,"^",12)=$p(OrdInfo,$c(2),6)            ///医嘱人代码        
   s $p(sOut,"^",13)=$p($p(OrdInfo,$c(2),6),"/",3)            ///医嘱人姓名        
   s $p(sOut,"^",14)=$p($p(sMRDIA,$c(2),5),"/",3)            ///临床诊断          
   s $p(sOut,"^",15)=$p(sMRDIA,$c(2),8)            ///诊断日期          
   s $p(sOut,"^",16)=$p(sMRDIA,$c(2),9)            ///诊断时间          
   s $p(sOut,"^",17)=$p(sMRDIA,$c(2),3)            ///诊断科室          
   s $p(sOut,"^",18)=$p($p(sMRDIA,$c(2),3),"/",2)            ///诊断部门          
   s $p(sOut,"^",19)=$p($p(sMRDIA,$c(2),6),"/")           ///诊断人代码        
   s $p(sOut,"^",20)=$p($p(sMRDIA,$c(2),6),"/",2)           ///诊断人姓名        
   s $p(sOut,"^",21)=""            ///传染病报告        
   s $p(sOut,"^",22)=$p(EPDInfo,"^",8)            ///发病日期          
   s $p(sOut,"^",23)=$p(EPDInfo,"^",10)            ///诊断日期          
   s $p(sOut,"^",24)=$p(EPDInfo,"^",12)            ///死亡日期          
   s $p(sOut,"^",25)=$p(EPDInfo,"^",17)            ///报告日期          
   s $p(sOut,"^",26)=$p(EPDInfo,"^",18)            ///报告时间          
   s $p(sOut,"^",27)=$p(EPDInfo,"^",13)            ///报告科室          
   s $p(sOut,"^",28)=$p($p(EPDInfo,"^",13),"/",2)            ///报告部门          
   s $p(sOut,"^",29)=$p($p(EPDInfo,"^",16),"/",2)            ///报告人代码        
   s $p(sOut,"^",30)=$p($p(EPDInfo,"^",16),"/",3)            ///报告人姓名        
   s $p(sOut,"^",31)=""            ///死亡              
   s $p(sOut,"^",32)=$p(DeathInfo,"^",41)            ///死亡日期          
   s $p(sOut,"^",33)=$p(DeathInfo,"^",47)            ///报告日期          
   s $p(sOut,"^",34)=$p(DeathInfo,"^",48)            ///时间              
   s $p(sOut,"^",35)=$p(DeathInfo,"^",58)            ///科室              
   s $p(sOut,"^",36)=$p($p(DeathInfo,"^",58),"/",2)            ///部门              
   s $p(sOut,"^",37)=$p($p(DeathInfo,"^",46),"/",2)            ///报告人代码        
   s $p(sOut,"^",38)=$p($p(DeathInfo,"^",46),"/",3)            ///姓名              
   s $p(sOut,"^",39)=""            ///手术   
   q sOut
   */
}

ClassMethod QueryAppSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppSubExecute ]
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

Query QueryAppSub(EpdaRowid As %String) As %Query(ROWSPEC = "Title:%String,FirstRow:%String,LastRow:%String")
{
}

ClassMethod Buildsub(repid, ind, s0, s1, s2)
{
	      
    s s1=..BuildOutStrings(s1)
    s s2=..BuildOutStrings(s2)
    f i=1:1:$l(s0,"^") d
    .set Data=$lb($p(s0,"^",i),$p(s1,"^",i),$p(s2,"^",i))
    .Set ^CacheTemp(repid,ind)=Data
 	.Set ind=ind+1
 	q
}

ClassMethod BuildOutStrings(s)
{
	
   n (s)
   s sOut=""
   q:s="" sOut
   s subInfo=$p(s,$c(1),1)
   s OrdInfo=$p(s,$c(1),2)  
   s sMIFC=$p(s,$c(1),3)
   s sMRDIA=$p(s,$c(1),4)
   s EPDInfo=$p(s,$c(1),5)
   s DeathInfo=$p(s,$c(1),6)
   
   s $p(sOut,"^",1 )=$p(sMIFC,"^",2)            ///辅检类型d
   s:$p(sOut,"^",1)'="" $p(sOut,"^",1)=##class(web.DHCMedDictoryCtl).GetByTypeCode("EpidemicWatchItemType",$p(sOut,"^",1))
   s $p(sOut,"^",2 )=$p(subInfo,"^",3)            ///辅检号            
   s $p(sOut,"^",3 )=$p($p(sMIFC,"^",3),"||",1)            ///项目代码          
   s $p(sOut,"^",4 )=$p(sMIFC,"^",4)            ///项目名称          
   s $p(sOut,"^",5 )=$p(subInfo,"^",5)            ///项目结果          
   s $p(sOut,"^",6 )=$p(subInfo,"^",6)            ///审核日期          
   s $p(sOut,"^",7 )=$p(subInfo,"^",7)            ///审核时间          
   s $p(sOut,"^",8 )=$p(OrdInfo,$c(2),4)            ///医嘱日期          
   s $p(sOut,"^",9 )=$p(OrdInfo,$c(2),5)            ///医嘱时间          
   s $p(sOut,"^",10)=$p(OrdInfo,$c(2),7)            ///医嘱科室          
   s $p(sOut,"^",11)=$p($p(OrdInfo,$c(2),7),"/",2)            ///医嘱部门          
   s $p(sOut,"^",12)=$p(OrdInfo,$c(2),6)            ///医嘱人代码        
   s $p(sOut,"^",13)=$p($p(OrdInfo,$c(2),6),"/",3)            ///医嘱人姓名        
   s $p(sOut,"^",14)=$p($p(sMRDIA,$c(2),5),"/",3)            ///临床诊断          
   s $p(sOut,"^",15)=$p(sMRDIA,$c(2),8)            ///诊断日期          
   s $p(sOut,"^",16)=$p(sMRDIA,$c(2),9)            ///诊断时间          
   s $p(sOut,"^",17)=$p(sMRDIA,$c(2),3)            ///诊断科室          
   s $p(sOut,"^",18)=$p($p(sMRDIA,$c(2),3),"/",2)            ///诊断部门          
   s $p(sOut,"^",19)=$p($p(sMRDIA,$c(2),6),"/")           ///诊断人代码        
   s $p(sOut,"^",20)=$p($p(sMRDIA,$c(2),6),"/",2)           ///诊断人姓名        
   s $p(sOut,"^",21)=""            ///传染病报告        
   s $p(sOut,"^",22)=$p(EPDInfo,"^",9)            ///发病日期          
   s $p(sOut,"^",23)=$p(EPDInfo,"^",11)            ///诊断日期          
   s $p(sOut,"^",24)=$p(EPDInfo,"^",13)            ///死亡日期          
   s $p(sOut,"^",25)=$p(EPDInfo,"^",18)            ///报告日期          
   s $p(sOut,"^",26)=$p(EPDInfo,"^",19)            ///报告时间          
   s $p(sOut,"^",27)=$p(EPDInfo,"^",14)            ///报告科室          
   s $p(sOut,"^",28)=$p($p(EPDInfo,"^",14),"/",2)            ///报告部门          
   s $p(sOut,"^",29)=$p($p(EPDInfo,"^",17),"/",2)            ///报告人代码        
   s $p(sOut,"^",30)=$p($p(EPDInfo,"^",17),"/",3)            ///报告人姓名        
   s $p(sOut,"^",31)=""            ///死亡              
   s $p(sOut,"^",32)=$p(DeathInfo,"^",41)            ///死亡日期          
   s $p(sOut,"^",33)=$p(DeathInfo,"^",47)            ///报告日期          
   s $p(sOut,"^",34)=$p(DeathInfo,"^",48)            ///时间              
   s $p(sOut,"^",35)=$p(DeathInfo,"^",58)            ///科室              
   s $p(sOut,"^",36)=$p($p(DeathInfo,"^",58),"/",2)            ///部门              
   s $p(sOut,"^",37)=$p($p(DeathInfo,"^",46),"/",2)            ///报告人代码        
   s $p(sOut,"^",38)=$p($p(DeathInfo,"^",46),"/",3)            ///姓名              
   s $p(sOut,"^",39)=""            ///手术   
   q sOut
}

}
