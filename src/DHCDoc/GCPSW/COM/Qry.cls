/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 公共Query
Class DHCDoc.GCPSW.COM.Qry Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 查询药理项目
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.COM.Qry","QryGCP")
Query QryGCP(inDesc = "", UserID = "") As %Query(ROWSPEC = "id,code,desc")
{
}

ClassMethod QryGCPExecute(ByRef qHandle As %Binary, inDesc = "", UserID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id=0
 	f  s id=$o(^DHCDocPP(id)) q:id=""  d
 	.s code=$p(^DHCDocPP(id),"^",1)
 	.s desc=$p(^DHCDocPP(id),"^",2)
 	.s endDate=$p(^DHCDocPP(id),"^",13)
 	.s startDate=$p(^DHCDocPP(id),"^",11)
 	.q:(startDate'="")&&(startDate>+$h)
 	.q:(endDate'="")&&(endDate<+$H)
 	.q:(inDesc'="")&&(desc'[inDesc)
 	.s status=$p(^DHCDocPP(id),"^",16)
 	.q:(status'="N")&&(status'="V")&&(status'="C")
 	.s flag=##class(DHCDoc.GCPSW.COM.Func).IsPITeam(UserID,id,1)
 	.;q:flag=0
 	
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(id,code,desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryGCPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGCPExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGCPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGCPExecute ]
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

/// CTOR: QP
/// DATE: 2020-09-09
/// DESC: 查询性别
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.COM.Qry","QrySex")
Query QrySex() As %Query(ROWSPEC = "id,code,desc")
{
}

ClassMethod QrySexExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id=0
 	f  s id=$o(^CT("SEX",id)) q:id=""  d
 	.s code=$p(^CT("SEX",id),"^",1)
 	.s desc=$p(^CT("SEX",id),"^",2)
 	.q:(desc'["男")&&(desc'["女")
 	.s dateFrom=$p(^CT("SEX",id),"^",4)
 	.s dateTo=$p(^CT("SEX",id),"^",5)
 	.q:(dateFrom'="")&&(dateFrom>+$h)
 	.q:(dateTo'="")&&(dateTo<+$H)
 	.d output2
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output2
	Set Data=$lb(id,code,desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QrySexClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySexExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySexFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySexExecute ]
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

/// CTOR: QP
/// DATE: 2020-09-15
/// DESC: 查询医嘱项
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.COM.Qry","FindMasterItem")
Query FindMasterItem(arcimdesc As %String = "", InType As %String = "", HospId = "") As %Query(ROWSPEC = "ArcimDesc:%String,ArcimDR:%String,factor,stock")
{
}

ClassMethod FindMasterItemExecute(ByRef qHandle As %Binary, arcimdesc As %String = "", InType As %String = "", HospId = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    i (arcimdesc'="") s arcimdesc=$$ALPHAUP^SSUTIL4(arcimdesc)    
    //i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..;Q:##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast",ArcimDR,HospId)="N"
	..s Flag=0
	..s factor="",stock=""
	..q:$g(^ARCIM(ArcimID,ArcimSubID,1))=""
	..s dateFrom=$p($p(^ARCIM(ArcimID,ArcimSubID,1),"^",13),",",1)
	..s dateTo=$p($g(^ARCIM(ArcimID,ArcimSubID,7)),"^",1)
	..s h=+$h
	..s OrderOnItsOwn = $p($g(^ARCIM(ArcimID,ArcimSubID,7)),"^",13)
	..q:OrderOnItsOwn="N"
	..q:OrderOnItsOwn=""
	..q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
	..s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	..s OutArcimDesc=ArcimDesc
	..s ArcimDesc=$$ALPHAUP^SSUTIL4(ArcimDesc)   
	..i ArcimDesc[arcimdesc s Flag=1
	..s itemDr=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",10)
    ..q:itemDr=""
    ..s orderType=$p(^ARC("IC",itemDr),"^",7)
    ..Q:(InType'="")&&(InType'=orderType)
	..i Flag=0  d
	...s AlisDR=""
	...f  s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,AlisDR)) q:AlisDR=""  d
	....s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	....i AlisDesc[arcimdesc s Flag=1
	..i Flag=1 d output3
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output3
	set Data=$lb(OutArcimDesc,ArcimDR,factor,stock)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      liuzf
/// CreatDate：    20150619
/// Description:： 根据审核日期查询结果
/// Table：         
/// Input：         审核日期开始SttDate，结束EndDate
/// Output：        OrdRowID,OrdName,项目代码,项目名称,缩写,结果,单位,标志,参考范围
/// Return：无  
/// d ##Class(%ResultSet).RunQuery("LabService.TSResult","QryTCResultByAuthDate","2019-01-01","2019-01-03")
Query QryTCResultByAuthDate(SttDate As %String, EndDate As %String) As %Query(ROWSPEC = "OrdName:%String,TSName:%String,TCCode:%String,TCName:%String,TCSyn:%String,Result:%String,TCUnit:%String,ResultFlag:%String,RefRanges:%String,Sensitive:%String,WarnFlag:%String,tcDetails:%String,SenResult:%String")
{
}

ClassMethod QryTCResultByAuthDateExecute(ByRef qHandle As %Binary, SttDate As %String, EndDate As %String) As %Status
{
	Set repid=$i(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	s SttDate=$g(SttDate),EndDate=$g(EndDate)
	S SttDate=$ZDH(SttDate,3),EndDate=$ZDH(EndDate,3)
	
	f CurDate=SttDate:1:EndDate {
		s LabNo="" 
		f  {
			S LabNo=$o(^TEPIi("AUTHORISED",CurDate,LabNo)) 
			Q:LabNo=""  
			s OrdId=""
			f {
				 s OrdId=$o(^OEORD(0,"EpisNo",LabNo,OrdId))
				 q:OrdId=""
				 s OrdSub=""
				 f {
					s OrdSub=$o(^OEORD(0,"EpisNo",LabNo,OrdId,OrdSub)) 
					q:OrdSub=""
					s OrderRowID=OrdId_"||"_OrdSub
	  				s ItmMastDr=$p($g(^OEORD(OrdId,"I",OrdSub,1)),"^",2)
					s OrdName=$p(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1),"^",2)
					///直接Query版本
				    Set rset = ##class(%ResultSet).%New("web.DHCLabReportForLis:QueryOrderResult")
				    Set sc = rset.Execute(OrderRowID)
				    s colCount=rset.GetColumnCount()
				    While(rset.Next())
				    {
				        f i=1:1:colCount 
				        { 	
					     	s $li(Data,i)=rset.GetData(i)
				        }
				        Set ind=ind+1
				        Set ^CacheTemp(repid,ind)=$lb(OrderRowID,OrdName)_Data
				    }					 
				 }
			}
		}
	}

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QryTCResultByAuthDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTCResultByAuthDateExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTCResultByAuthDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTCResultByAuthDateExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 查询药理学大类
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.COM.Qry","GetPhcCat")
Query GetPhcCat(phcatdr As %String = "") As %Query(ROWSPEC = "phcat,phcatdesc,phcatcode") [ SqlProc ]
{
}

ClassMethod GetPhcCatExecute(ByRef qHandle As %Binary, phcatdr As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    
    s ind=1
    s phcat=0
    f  s phcat=$o(^PHCC(phcat)) q:+phcat=0  d
    .;q:(phcatdr'="")&&(phcatdr'=phcat)
    .s phcatcode=$p(^PHCC(phcat),"^",1)
    .s phcatdesc=$p(^PHCC(phcat),"^",2)
    .d OutRowGetPhcCat
    
	Quit $$$OK
OutRowGetPhcCat
	set Data=$lb(phcat,phcatdesc,phcatcode)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetPhcCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhcCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish 

		Set AtEnd=1
		Set Row=""
	}
	Else {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPhcCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPhcCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 查询药理学子类
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.COM.Qry","GetPhcSubCat",65)
Query GetPhcSubCat(phcatdr As %String = "") As %Query(ROWSPEC = "id,desc,code") [ SqlProc ]
{
}

ClassMethod GetPhcSubCatExecute(ByRef qHandle As %Binary, phcatdr As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i phcatdr="" {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	   }
    s ind=1
    s phcat=0
    f  s phcat=$o(^PHCC(phcat)) q:+phcat=0  d
    .q:(phcatdr'="")&&(phcatdr'=phcat)
    .s phcatcode=$p(^PHCC(phcat),"^",1)
    .s phcatdesc=$p(^PHCC(phcat),"^",2)
    .s phcatsub=0
    .f  s phcatsub=$o(^PHCC(phcat,"SC",phcatsub)) q:phcatsub=""  d
    ..s phcatsubcode=$p(^PHCC(phcat,"SC",phcatsub),"^",1)
    ..s phcatsubdesc=$p(^PHCC(phcat,"SC",phcatsub),"^",2)
    ..s subcat=phcat_"||"_phcatsub
    ..d OutRowGetPhcSubCat
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowGetPhcSubCat
	set Data=$lb(subcat,phcatsubdesc,phcatsubcode)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetPhcSubCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhcSubCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish 

		Set AtEnd=1
		Set Row=""
	}
	Else {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPhcSubCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPhcSubCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-11-05
/// DESC: 查询转诊医生
/// IN  : 
/// OUT : 
/// EXEC: d ##Class(%ResultSet).RunQuery("web.DHCDocTransAdm","QryTransDoc","10118")
Query QryTransDoc(inDesc = "") As %Query(ROWSPEC = "jobNum,userName,defaultLocDesc,uid")
{
}

ClassMethod QryTransDocExecute(ByRef qHandle As %Binary, inDesc = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1 
    Set qHandle=$lb(0,repid,0)
    s inDesc=$zcvt(inDesc,"U")
    
    s ^TEMP("QP","QryTransDoc")=inDesc
    s uid=0
    f  s uid=$o(^SSU("SSUSR",uid)) q:uid=""  d
    .s docid=$p(^SSU("SSUSR",uid),"^",14)
    .;q:docid=""
    .s (ctpid,docType,otherName)=""
    .i docid'="" d
    ..q:'$d(^CTPCP(docid,1))
    ..s ctpid=$p(^CTPCP(docid,1),"^",4)
    .;q:ctpid=""
    .i ctpid'="" s docType=$p(^CT("CPT",ctpid),"^",4)
    .;q:docType'="DOCTOR"
    .s defaultLoc=$p(^SSU("SSUSR",uid),"^",4)
    .s defaultLocDesc=""
    .i defaultLoc'="" s defaultLocDesc=$p(^CTLOC(defaultLoc),"^",2)
	.s jobNum=$p(^SSU("SSUSR",uid),"^",1)
	.s jobNumUp=$zcvt(jobNum,"U")
	.s userName=$p(^SSU("SSUSR",uid),"^",2)
	.s userNameUp=$zcvt(userName,"U")
	.i docid'="" d
	..q:'$d(^CTPCP(docid,3))
	..s otherName=$p(^CTPCP(docid,3),"^",28)
	..s otherName=$zcvt(otherName,"U")
	.s exit=1
	.i inDesc'="" d
	..i otherName[inDesc s exit=0
	..i userNameUp[inDesc s exit=0
	..i jobNumUp[inDesc s exit=0
	.q:(exit=1)&&(inDesc'="")
    .d OutTransDocList
    
    
    
    Quit $$$OK
    
OutTransDocList
    set Data=$lb(jobNum,userName,defaultLocDesc,uid)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryTransDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTransDocExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryTransDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTransDocExecute ]
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

}
