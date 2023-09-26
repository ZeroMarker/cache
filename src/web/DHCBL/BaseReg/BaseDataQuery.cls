Class web.DHCBL.BaseReg.BaseDataQuery Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod CredTypeQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CredTypeQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CredTypeQueryExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
	
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
	;^PAC("CARD",{CRT_RowID})
	 f  s myBMRowid=$o(^PAC("CARD",myBMRowid)) q:(myBMRowid="")  d
	.s active=$p(^PAC("CARD",myBMRowid,"DHC"),"^",1)
	.q:active'="Y"
	.s def=$p(^PAC("CARD",myBMRowid, "DHC"),"^",2)
	.s mydes=$p(^PAC("CARD",myBMRowid),"^", 2)		;Desc
	.b
	.d BuildData
	
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildData
		Set Data=$ListBuild(myBMRowid, mydes)	
		Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	q
}

ClassMethod CredTypeQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CredTypeQueryExecute ]
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

ClassMethod FindLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindLocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocExecute(ByRef QHandle As %Binary, Loc As %String, HospitalDr As %String = "") As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.DHCBL.BaseReg.BaseDataQuery","FindLoc","zl")
	Set repid=$I(^CacheTemp)
	s ind=1
	s Loc=$ZCVT(Loc,"U")
	s LocTypeStr="O^E" 
	for i=1:1:$l(LocTypeStr,"^") d
	.s LocType=$p(LocTypeStr,"^",i)
	.s rowid=0 f  s rowid=$o(^PAC("ADMLOC",0,"AdmType",LocType,rowid)) q:rowid=""  d
	..s CTDesc=$p($g(^CTLOC(rowid)),"^",2)
	..s CTDesc=$ZCVT(CTDesc,"U")
	..if CTDesc["-" s CTDesc=$P(CTDesc,"-",2)
	..s CTCode=$p($g(^CTLOC(rowid)),"^",1)
	..s HospitalID=$p($g(^CTLOC(rowid)),"^",22)
	..q:((HospitalDr'="")&&(HospitalID'=HospitalDr))
	..;用作放助记码的地方
	..s CTContactName=$p($g(^CTLOC(rowid)),"^",43)
	..s CTContactName=$ZCVT(CTContactName,"U")
	..;w CTDesc_","_CTContactName_","_(CTContactName'[(Loc))_","_(CTDesc'[(Loc)),!
	..Q:(Loc'="")&&((CTDesc'[(Loc))&&(CTContactName'[(Loc)))
	..Do OutputRow
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(rowid,CTDesc_"-"_CTContactName,CTCode,CTContactName)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (CTDesc,CTCode,rowid,CTContactName)=""
	quit
}

ClassMethod FindLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetClinicStr() As %String
{
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.DHCBL.BaseReg.BaseDataQuery:RBCClinicGroup")
	do rset.Execute()
	
	set row=0
	While (rset.Next()) {
		set ret=rset.GetData(1)_"$c(2)"_rset.GetData(2)
	    i ret1="" s ret1=ret
	    e  s ret1=ret_"$c(1)"_ret1
		
	}
	d rset.Close()
	Q ret1
}

ClassMethod GetDocLoc(UserId As %String) As %String
{
	s ret1=""
	s depStr=##class(web.DHCBL.BaseReg.BaseDataQuery).GetOPDeptStr(UserId)
	s doStr=""

	for i=1:1:$L(depStr,"$c(1)")
	{
	    s row=$p(depStr,"$c(1)",i)
		s depid=$p(row,"$c(2)",1)
		s depid=$p(depid,"^",2)
			  
		s docStr=##class(web.DHCRBResSession).GetResDocBroker("")
		S rset=##class(%ResultSet).%New("web.DHCRBResSession:FindResDoc")
		
		d rset.Execute(depid)
		While (rset.Next()) {
		s DocDesc=rset.GetData(1)
		s DocCode=rset.GetData(2)
		s DocID=rset.GetData(3)
		s DocOtherName=""
		i DocID'="" d 
		.i $d(^CTPCP(DocID,3)) s DocOtherName=$p(^CTPCP(DocID,3),"^",28)
		i DocOtherName'="" s DocDesc=DocDesc_"-"_DocOtherName
		s ret="D^"_DocID_"$c(2)"_DocDesc
	
	    i doStr="" s doStr=ret
	    e  s doStr=doStr_"$c(1)"_ret
	    }
		d rset.Close()
	}
 b
	q doStr_"$c(1)"_depStr
}

ClassMethod GetOPDeptStr(UserId As %String) As %String
{
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.DHCOPAdmReg:OPDeptList")
	do rset.Execute(UserId)
	
	set row=0
	While (rset.Next()) {
		set RowId=rset.GetData(1)
		set DepGroupDR=$P(^CTLOC(RowId),"^",19)
		if (DepGroupDR'="") {
			i '$d(CacheTemp($J,"OPRegDepGroup",DepGroupDR)) {
				s CacheTemp($J,"OPRegDepGroup",DepGroupDR)=RowId
			}else{
				s CacheTemp($J,"OPRegDepGroup",DepGroupDR)=CacheTemp($J,"OPRegDepGroup",DepGroupDR)_"$c(2)"_RowId
			}
		}else {
			set ret="D^"_rset.GetData(1)_"$c(2)"_rset.GetData(2)_"-"_rset.GetData(3)
		   
		   
		    i ret1="" s ret1=ret
		    e  s ret1=ret_"$c(1)"_ret1
		}
	}
	i $d(CacheTemp($J,"OPRegDepGroup")) {
		s DepGroupDR=0  f  s DepGroupDR=$O(CacheTemp($J,"OPRegDepGroup",DepGroupDR)) Q:DepGroupDR=""  d
		.Q:'$D(^RBC("DEP",DepGroupDR))
		.s DepGroupDesc=$P(^RBC("DEP",DepGroupDR),"^",2)
		.s LocRowIdStr=CacheTemp($J,"OPRegDepGroup",DepGroupDR)
		.s FirstLocRowId=$P(LocRowIdStr,"$c(2)",1)
		.s CTAlias=$P(^CTLOC(FirstLocRowId),"^",43)
		.s DepGroupData="D^"_LocRowIdStr_"$c(2)"_DepGroupDesc_"-"_CTAlias
		.i ret1="" s ret1=DepGroupData
		.e  s ret1=ret1_"$c(1)"_DepGroupData
	}
	d rset.Close()
	
	Q ret1
}

ClassMethod QueryAllBaTachPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllBaTachPersonExecute ]
{
		Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAllBaTachPersonExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
	
 Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Do result.Prepare("SELECT %ID,Birth,CardNo,CredNo,CredType,Name,SexDesc,UserDR,CreatCardFlag FROM SQLUSER.DHC_TMPBatchPersonInfo where UserDR=?")
	Do result.Execute(%session.Get("LOGON.USERID"))
	For  Quit:'result.Next()  Do
	.Set Data=$ListBuild(result.Data("ID"), result.Data("Birth"),result.Data("CardNo"),result.Data("CredNo"),result.Data("CredType"),result.Data("Name"),result.Data("SexDesc"),result.Data("UserDR"),result.Data("CreatCardFlag"))	
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1

	
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryAllBaTachPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllBaTachPersonExecute ]
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

ClassMethod QueryOccupationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOccupationExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryOccupationExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
	
	s myBMRowid=0
	s mydes=""
	s myval=""
	;^PAC("CARD",{CRT_RowID})
	 f  s myBMRowid=$o(^CT("OCC",myBMRowid)) q:(myBMRowid="")  d
	.s mydes=$p(^CT("OCC",myBMRowid),"^", 2)		;Desc
	.s mydes1=$P(mydes,"-",2)
	.i mydes1'="" d
	..s myalias=$P(mydes,"-",1)
	..s mydes=mydes1_"-"_myalias
	.b
	.d BuildData
	
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildData
		Set Data=$ListBuild(myBMRowid, mydes)	
		Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	q
}

ClassMethod QueryOccupationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOccupationExecute ]
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

ClassMethod RBCClinicGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RBCClinicGroupExecute ]
{
	Set repid=$li(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod RBCClinicGroupExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s desc=""
	s desc=$O(^RBC("CLGRP",0,"Desc",desc))
	while(desc'="")
	{
	  s idStr=""
	  s rowid=""
	  s Desc=""
	  s rowid=$O(^RBC("CLGRP",0,"Desc",desc,rowid))	
	  while(rowid'="")
	  {
		 s dateTo=$p($g(^RBC("CLGRP",rowid)),"^",4)
		 if (dateTo'="")&&(dateTo<+$h){
			 s rowid=$O(^RBC("CLGRP",0,"Desc",desc,rowid))	
			 continue 
		 }
		 s Desc=$p($g(^RBC("CLGRP",rowid)),"^",2)
		 i idStr="" d
		 .s idStr=rowid
		 e  d
		 .s idStr=idStr_$C(3)_ rowid
		 s rowid=$O(^RBC("CLGRP",0,"Desc",desc,rowid))	
	  }
	  if (idStr=""){
		  s desc=$O(^RBC("CLGRP",0,"Desc",desc))
		  continue  
	  }
 s Data=$lb(idStr,Desc)  
 S ^CacheTemp(repid,ind)=Data
 S ind=ind+1
	  s desc=$O(^RBC("CLGRP",0,"Desc",desc))
		
	} 
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod RBCClinicGroupFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RBCClinicGroupExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod clinicRight(clinincId As %String, UserId As %String)
{
}

ClassMethod test()
{
	 Set rs=##Class(%ResultSet).%New("web.DHCBL.BaseReg.BaseDataQuery:RBCClinicGroup")
	 d rs.Execute()
}

Query CredTypeQuery() As %Query(ROWSPEC = "RowID:%String,Desc:%String")
{
}

Query FindLoc(Loc As %String, HospitalDr As %String = "") As %Query(ROWSPEC = "rowid:%String,Desc:%String,Hidden:%String,Alias:%String") [ SqlProc ]
{
}

Query QueryAllBaTachPerson() As %Query(ROWSPEC = "ID:%String,Birth:%String,CardNo:%String,CredNo:%String,CredType:%String,Name:%String,SexDesc:%String,UserDR:%String,CreatCardFlag:%String")
{
}

Query QueryAllBaTachPerson1(usid As %String) As %SQLQuery(CONTAINID = 1)
{
 SELECT %ID,Birth,CardNo,CredNo,CredType,Name,SexDesc,UserDR,CreatCardFlag FROM SQLUSER.DHC_TMPBatchPersonInfo where UserDR=6
}

Query QueryOccupation() As %Query(ROWSPEC = "ID:%String,Desc:%String")
{
}

Query RBCClinicGroup() As %Query(ROWSPEC = "code:%String,desc:%String")
{
}

Query RBCClinicGroupQuery() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Desc:%String")
{
 SELECT %ID,CLGRP_Desc FROM SQLUSER.RBC_ClinicGroup
}

/*Query RBCSessionTypeQuery() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Desc:%String")
{
 SELECT %ID,SESS_Desc FROM SQLUSER.RBC_SessionType where 
 (SESS_DateFrom<=+$h and SESS_DateFrom<>"")
 and (SESS_DateTo>+$h and SESS_DateTo<>"")
 union
 SELECT %ID,SESS_Desc FROM SQLUSER.RBC_SessionType where 
 (SESS_DateFrom<=+$h and SESS_DateTo is null)
 union
 SELECT %ID,SESS_Desc FROM SQLUSER.RBC_SessionType where 
 (SESS_DateTo>+$h and SESS_DateFrom is null)
}*/
Query RBCSessionTypeQuery(HospID As %String = "") As websys.Query(ROWSPEC = "ID:%String,Desc:%String")
{
}

ClassMethod RBCSessionTypeQueryExecute(ByRef qHandle As %Binary, HospID As %String = "") As %Status
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ID=0
    for {
	    s ID=$o(^RBC("SESS",ID)) Q:ID=""
	    continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_SessionType",ID,HospID)
	    s Desc=$p(^RBC("SESS",ID),"^",2)
	    s SESSDateFrom=$p(^RBC("SESS",ID),"^",6)
	    continue:(SESSDateFrom'="")&&(SESSDateFrom>+$h)
	    s SESSDateTo=$p(^RBC("SESS",ID),"^",7)
	    continue:(SESSDateTo'="")&&(SESSDateTo<=..%SysDate())
	    d OutPutRow1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRow1
	set Data=$lb($g(ID),$g(Desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/*Query SeviceQuery(RegServiceGroupRowId As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Desc:%String")
{
	SELECT ARCIM_RowId,ARCIM_Desc FROM SQLUSER.ARC_ItmMast where ARCIM_ServiceGroup_DR=:RegServiceGroupRowId
}*/
Query SeviceQuery(RegServiceGroupRowId As %String, HospID As %String = "") As websys.Query(ROWSPEC = "ID:%String,Desc:%String")
{
}

ClassMethod SeviceQueryExecute(ByRef qHandle As %Binary, RegServiceGroupRowId As %String, HospID As %String = "") As %Status
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	Set repid=$I(^CacheTemp)
    Set ind=1
    &SQL(DECLARE ARCItmMast CURSOR FOR
    SELECT ARCIM_RowId,ARCIM_Desc INTO :ID,:Desc FROM SQLUSER.ARC_ItmMast 
    where ARCIM_ServiceGroup_DR=:RegServiceGroupRowId)
    &SQL(OPEN ARCItmMast)
    For  &SQL(FETCH ARCItmMast) QUIT:SQLCODE  do
    .Q:##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ID,HospID)="N"
    .s datefrom=$p($g(^ARCIM(+ID,1,1)),"^",13)
	.s dateto=$p($g(^ARCIM(+ID,1,7)),"^",1)
	.q:datefrom>$h
	.q:((dateto'="")&&(dateto<$h))
	.s RegType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ID, HospID)
	.q:RegType="NotRegFee"
	.d OutPutRow    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRow
	set Data=$lb($g(ID),$g(Desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

Query SeviceQueryAll(RegServiceGroupRowId As %String, HospID As %String = "") As websys.Query(ROWSPEC = "ID:%String,Desc:%String")
{
}

ClassMethod SeviceQueryAllExecute(ByRef qHandle As %Binary, RegServiceGroupRowId As %String, HospID As %String = "") As %Status
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	Set repid=$I(^CacheTemp)
    Set ind=1
    &SQL(DECLARE ARCItmMast CURSOR FOR
    SELECT ARCIM_RowId,ARCIM_Desc INTO :ID,:Desc FROM SQLUSER.ARC_ItmMast 
    where ARCIM_ServiceGroup_DR=:RegServiceGroupRowId)
    &SQL(OPEN ARCItmMast)
    For  &SQL(FETCH ARCItmMast) QUIT:SQLCODE  do
    .Q:##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ID,HospID)="N"
    .s datefrom=$p($g(^ARCIM(+ID,1,1)),"^",13)
	.s dateto=$p($g(^ARCIM(+ID,1,7)),"^",1)
	.q:datefrom>$h
	.q:((dateto'="")&&(dateto<$h))
	.s RegType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ID, HospID)
	.;q:RegType="NotRegFee"
	.d OutPutRow    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRow
	set Data=$lb($g(ID),$g(Desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

}
