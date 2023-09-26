Class web.DHCDoc.OP.PatConfigQuery Extends DHCDoc.Util.RegisteredObject [ ClassType = "" ]
{

/// d ##class(%ResultSet).RunQuery("epr.DHCDocOrderEntry","GetLocICD","1")
/// d ##class(%ResultSet).RunQuery("epr.PrefeencesQuery","FindOETabList")
/// d ##class(%ResultSet).RunQuery("web.UDHCJFIntBill","ordsubcatlookup","","","2")
/// d ##class(%ResultSet).RunQuery("web.UDHCJFIntBill","ordcatlookup","")
/// d ##class(%ResultSet).RunQuery("web.DHCMRDiagnosNew","DiagTemplateDetailList","235")
/// d ##class(%ResultSet).RunQuery("web.DHCMRDiagnosNew","DiagTemplateList","600")
/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","PatientInfo")
/// w ##class(web.DHCDoc.OP.PatConfigQuery).GessCardType("1")
ClassMethod GessCardType(cardValue As %String)
{
	s count=0
	s myTypeID=0
	s myDataFlag=0
	s json="["
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myDateFrom=+$p(^DHCCARDTYPEDef(myTypeID),"^", 9)		;CTD_DateFrom
	.q:((+myDateFrom'=0)&(myDateFrom>+$h))			;生效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s myFindFlag=1
	.i +myDataFlag  d
	..s myFindFlag=myPEObj.FindCardTypeByDR(myTypeID)
	..i myPEObj.DefaultCardTypeDR=myTypeID  d
	...s mySelFlag=1
	.q:(+myFindFlag=0)
	.s checkdValue= ..CheckCardValue(myTypeID,cardValue)
	.b ;3
	.q:checkdValue=""
	.s cfRowId=$o(^DHCCARDi("CF",0,"CardNo",checkdValue,""))
	.s papmiNo=$p(^DHCCARD("CF",cfRowId),"^",6)
	.i count>0 s json=json_","  
	.s json=json_"{""cardTypeId"":"""_myTypeID_""",""cardDesc"":"""_mydes_""",""checkdValue"":"""_checkdValue_""",""papmiNo"":"""_papmiNo_""",""myval"":"""_myval_"""}"
	//.s json=json_"{""cardTypeId"":"""_myTypeID_""",""cardDesc"":"""_mydes_""",""checkdValue"":"""_checkdValue_""",""papmiNo"":"""_papmiNo_"""}"
	.s count=count+1
	q json_"]"
}

// d ##class(DHCDoc.OP.PatientList).CheckCardValue("1","1")

ClassMethod CheckCardValue(cardTypeId As %String, cardValue As %String) As %String [ Private ]
{
	q:( (cardTypeId="") || ('$d(^DHCCARDTYPEDef(cardTypeId))) ) ""
	s ls=^DHCCARDTYPEDef(cardTypeId)
	s len=$p(ls,"^",17)
	for i=$l(cardValue)+1:1:len {
		s cardValue="0"_cardValue
	}
	if '$d(^DHCCARDi("CF",0,"CardNo",cardValue)) s cardValue=""
	q cardValue
}

/// creator:宋春莉
/// date:2016-08-02
/// desc:有效卡列表
/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.AjaxInterface","ReadCardTypeList")
/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","ReadCardTypeList","12")
Query ReadCardTypeList(cardValue As %String) As %Query(ROWSPEC = "CardTypeDesc:%String,checkdValue:%String,CardTypeValue:%String,DefaultFlag:%String")
{
}

ClassMethod ReadCardTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadCardTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod ReadCardTypeListExecute(ByRef qHandle As %Binary, cardValue As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.AjaxInterface","ReadCardTypeList")
	;Set repid=$I(^CacheTemp)
	;If $g(ind)="" Set ind=1
	
 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	
	
	s ^ml("data")=cardValue
	s myTypeID=0
	s myDataFlag=0
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myDateFrom=+$p(^DHCCARDTYPEDef(myTypeID),"^", 9)		;CTD_DateFrom
	.q:((+myDateFrom'=0)&(myDateFrom>+$h))			;生效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s myFindFlag=1
	.i +myDataFlag  d
	..s myFindFlag=myPEObj.FindCardTypeByDR(myTypeID)
	..i myPEObj.DefaultCardTypeDR=myTypeID  d
	...s mySelFlag=1
	.q:(+myFindFlag=0)
	.s checkdValue= ..CheckCardValue(myTypeID,cardValue)
	.q:checkdValue=""
	.Do OutputRow123
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow123
     s ^tmpscl("data12",ind)=myval
     set Data=$lb(mydes,checkdValue,myval,mySelFlag)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	 quit
}

ClassMethod ReadCardTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadCardTypeListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

/*ClassMethod GetOPDeptStr(UserId As %String, AdmType As %String) As %String
{
	;w ##class(web.DHCDoc.OP.PatConfigQuery).GetOPDeptStr(298,"O")
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.DHCOPAdmReg:OPDeptList")
	do rset.Execute(UserId,AdmType)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		set RowId=rset.GetData(1)
		s DepGroupDR=""
		;set DepGroupDR=$P(^CTLOC(RowId),"^",19)
		if (DepGroupDR'="") {
			i '$d(CacheTemp($J,"OPRegDepGroup",DepGroupDR)) {
				s CacheTemp($J,"OPRegDepGroup",DepGroupDR)=RowId
			}else{
				s CacheTemp($J,"OPRegDepGroup",DepGroupDR)=CacheTemp($J,"OPRegDepGroup",DepGroupDR)_$C(2)_RowId
			}
		}else {
			set Deptdesc=$p(rset.GetData(2),"-",2)
			if $l(Deptdesc,"-")>1 set Deptdesc=$p(Deptdesc,"-",2)
			set Alias=rset.GetData(3)
			if Alias="" Set Alias=$p(rset.GetData(2),"-",1)
			set ret=rset.GetData(1)_$C(1)_Deptdesc_"-"_Alias  //guorongyong 2008-03-20
			;set ret=rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
		    i ret1="" s ret1=ret
		    e  s ret1=ret_"^"_ret1
		    b ;1
		}
	}
	
	i $d(CacheTemp($J,"OPRegDepGroup")) {
		s DepGroupDR=0  f  s DepGroupDR=$O(CacheTemp($J,"OPRegDepGroup",DepGroupDR)) Q:DepGroupDR=""  d
		.Q:'$D(^RBC("DEP",DepGroupDR))
		.s DepGroupDesc=$P(^RBC("DEP",DepGroupDR),"^",2)
		.s LocRowIdStr=CacheTemp($J,"OPRegDepGroup",DepGroupDR)
		.s FirstLocRowId=$P(LocRowIdStr,$C(2),1)
		.s CTAlias=$P(^CTLOC(FirstLocRowId),"^",43)
		.s DepGroupData=LocRowIdStr_$C(1)_DepGroupDesc_"-"_CTAlias
		.i ret1="" s ret1=DepGroupData
		.e  s ret1=ret1_"^"_DepGroupData
		.b ;2
	}
	
	d rset.Close()
	Q ret1
}
*/
/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","GetOPDeptStr",298,"O")
Query GetOPDeptStr(UserId As %String, AdmType As %String) As %Query(ROWSPEC = "ID:%String,DESC:%String,Alias:%String") [ SqlProc ]
{
}

ClassMethod GetOPDeptStrExecute(ByRef qHandle As %Binary, UserId As %String, AdmType As %String, Alias As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	Set rset=##class(%ResultSet).%New("web.DHCOPAdmReg:OPDeptList")
	do rset.Execute(UserId,AdmType)
	Set columns = rset.GetColumnCount()
	set row=0
	s ID=""
	s DESC=""
	s Alias=""
	While (rset.Next()) {
		set RowId=rset.GetData(1)
		s DepGroupDR=""
		;set DepGroupDR=$P(^CTLOC(RowId),"^",19)
		if (DepGroupDR'="") {
			i '$d(CacheTemp($J,"OPRegDepGroup",DepGroupDR)) {
				s CacheTemp($J,"OPRegDepGroup",DepGroupDR)=RowId
			   }
			else{
				s CacheTemp($J,"OPRegDepGroup",DepGroupDR)=CacheTemp($J,"OPRegDepGroup",DepGroupDR)_$C(2)_RowId
		    }
		}
		else {
			set Deptdesc=rset.GetData(2) //$p(rset.GetData(2),"-",2)
			//if $l(Deptdesc,"-")>1 set Deptdesc=$p(Deptdesc,"-",2)
			set Alias=rset.GetData(3)
			if Alias="" Set Alias=$p(rset.GetData(2),"-",1)
			set ID=rset.GetData(1)
			set DESC=Deptdesc //Alias_"-"_Deptdesc
			;set DESC=Deptdesc_Alias
			d OutputRow122
			;set ret=rset.GetData(1)_$C(1)_Deptdesc_"-"_Alias  //guorongyong 2008-03-20
			;set ret=rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
		   ; i ret1="" s ret1=ret
		   ; e  s ret1=ret_"^"_ret1
		}
	}
	
	i $d(CacheTemp($J,"OPRegDepGroup")) {
		s DepGroupDR=0  f  s DepGroupDR=$O(CacheTemp($J,"OPRegDepGroup",DepGroupDR)) Q:DepGroupDR=""  d
		.Q:'$D(^RBC("DEP",DepGroupDR))
		.s DepGroupDesc=$P(^RBC("DEP",DepGroupDR),"^",2)
		.s LocRowIdStr=CacheTemp($J,"OPRegDepGroup",DepGroupDR)
		.s FirstLocRowId=$P(LocRowIdStr,$C(2),1)
		.s CTAlias=$P(^CTLOC(FirstLocRowId),"^",43)
		.s DepGroupData=LocRowIdStr_$C(1)_DepGroupDesc //_"-"_CTAlias
		.i ret1="" s ret1=DepGroupData
		.e  s ret1=ret1_"^"_DepGroupData
	}
	
	quit $$$OK
	
OutputRow122
	set Data=$lb(ID,DESC,Alias)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOPDeptStrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPDeptStrExecute ]
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

ClassMethod GetOPDeptStrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPDeptStrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCOPAdmReg).FindDocMarkStr(600,63)
ClassMethod FindDocMarkStr(UserID As %String, LocID As %String) As %String
{
	s ^Tempzong("FindMarkStr")=UserID_","_LocID
	Q:((UserID="")||(LocID="")) ""
	s DocID=$P(^SSU("SSUSR",UserID),"^",14)
	Q:DocID="" ""
	s Ret=""
	s DHCMarkRowID=0 
	f  s DHCMarkRowID=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocID,DHCMarkRowID))  Q:DHCMarkRowID=""  d
	.s FindFlag=0
	.s ID="" f  s ID=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocID,DHCMarkRowID,ID)) Q:(ID="")||(FindFlag=1)  d
	..s MarkDepId=$list(^User.DHCMarkDocD(ID),4)
	..i MarkDepId=LocID s FindFlag=1
	.Q:FindFlag=0
	.s ResRowID=$O(^RB("RES",0,"CTPCP",DHCMarkRowID,LocID,0))
	.Q:ResRowID=""
	.s ScheSt=$p(^RB("RES",ResRowID),"^",6)
	.Q:ScheSt'="Y"
	.s MarkDesc=$p($g(^CTPCP(DHCMarkRowID,1)),"^",2)
	.if Ret=""  s Ret=DHCMarkRowID_$C(1)_MarkDesc
	.else  s Ret=Ret_"^"_DHCMarkRowID_$C(1)_MarkDesc
	Q Ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","FindDocMarkStr",298,"361")
/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","FindDocMarkStr",600,63)
Query FindDocMarkStr(UserId As %String, LocID As %String) As %Query(ROWSPEC = "ID:%String,DESC:%String,ResRowID:%String") [ SqlProc ]
{
}

ClassMethod FindDocMarkStrExecute(ByRef qHandle As %Binary, UserID As %String, LocID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	s ^Tempzong("FindMarkStr")=UserID_","_LocID
	Q:((UserID="")||(LocID="")) $$$OK
	Set langid=..%LanguageID()
	s DocID=$P(^SSU("SSUSR",UserID),"^",14)
	Q:DocID="" $$$OK
	s ID=DocID,DESC=$p($g(^CTPCP(DocID,1)),"^",2)
	Set DESC= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",DESC,langid)
	s ResRowID=$$GetResRowID(DocID,LocID)
	d OutputRow121
	
	s Ret=""
	s DHCMarkRowID=0 
	f  s DHCMarkRowID=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocID,DHCMarkRowID))  Q:DHCMarkRowID=""  d
	.Q:DHCMarkRowID=DocID
	.s FindFlag=0
	.s ID="" f  s ID=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocID,DHCMarkRowID,ID)) Q:(ID="")||(FindFlag=1)  d
	..s MarkDepId=$list(^User.DHCMarkDocD(ID),4)
	..i MarkDepId=LocID s FindFlag=1
	.Q:FindFlag=0	
	.s MarkDesc=$p($g(^CTPCP(DHCMarkRowID,1)),"^",2)
	.s ResRowID=$$GetResRowID(DHCMarkRowID,LocID)
	.Q:ResRowID=""
	.s ID=DHCMarkRowID
	.s DESC=MarkDesc
	.Set DESC= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",DESC,langid)
	.s ResRowID=$$GetResRowID(DHCMarkRowID,LocID)
	.s RapidASRowId=##class(web.DHCRBApptSchedule).GetAvailRA(ResRowID,+$H,"","")
	.i RapidASRowId'="" 
	.d OutputRow121
	Quit $$$OK
OutputRow121
	set Data=$lb(ID,DESC,ResRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
GetResRowID(CTPCPDR,LocID)
	s FindResRowID=""
	s ResRowID=0
	for {
		s ResRowID=$o(^RB("RES",0,"CTPCP",CTPCPDR,LocID,ResRowID)) Q:(ResRowID="")||(FindResRowID'="")
		s ScheSt=$p(^RB("RES",ResRowID),"^",6)
		continue:ScheSt'="Y"
		s DateFrom=$p(^RB("RES",ResRowID),"^",22)
		continue:(DateFrom'="")&&(DateFrom>+$h)
		s DateTo=$p(^RB("RES",ResRowID),"^",23)
		continue:(DateTo'="")&&(DateTo<=..%SysDate())
		s FindResRowID=ResRowID
	}
	Q FindResRowID
}

ClassMethod FindDocMarkStrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocMarkStrExecute ]
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

ClassMethod FindDocMarkStrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocMarkStrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query PatientInfo() As %Query(ROWSPEC = "ID:%String,DisplayItem:%String,Code:%String,DisplayNum:%String,ExecuteCode:%String,Style:%String,Link:%String,Operator:%String,OprDate:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod PatientInfoExecute(ByRef qHandle As %Binary) As %Status
{

 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	set sqlStr ="select ID,DisplayItem,Code,DisplayNum,ExecuteCode,Style,Link,Operator,OprDate,IsActive from SQLUser.DocCFPatientInfo ORDER BY DisplayNum"
	s resultStr=##class(%Library.ResultSet).%New()
	d resultStr.Prepare(sqlStr)
	d resultStr.Execute()
	While(resultStr.Next()){
		s ID=resultStr.Data("ID")
		s DisplayItem  = resultStr.Data("DisplayItem")
		s Code = resultStr.Data("Code")
		s DisplayNum = resultStr.Data("DisplayNum")
		s ExecuteCode = resultStr.Data("ExecuteCode")
		s Style = resultStr.Data("Style")
        s Link = resultStr.Data("Link") 
        s Operator  = resultStr.Data("Operator")
		s OprDate = resultStr.Data("OprDate")
		s IsActive = resultStr.Data("IsActive")
	d OutputRow12
	}
	
	quit $$$OK
	
OutputRow12	
	set Data=$lb(ID,DisplayItem,Code,DisplayNum,ExecuteCode,Style,Link,Operator,OprDate,IsActive)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PatientInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PatientInfoExecute ]
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

ClassMethod PatientInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PatientInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","StreamlineInfo")
Query Streamline() As %Query(ROWSPEC = "ID:%String,ItemID:%String,ItemName:%String,ItemClick:%String,ConditionalExpre:%String,StrLink:%String,DisplayNum:%String,Operator:%String,OprDate:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod StreamlineExecute(ByRef qHandle As %Binary) As %Status
{

 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	set sqlStr ="select ID,ItemID,ItemName,ItemClick,ConditionalExpre,StrLink,DisplayNum,Operator,OprDate,IsActive from SQLUser.DocCFStreamlineInfo ORDER BY DisplayNum"
	s resultStr=##class(%Library.ResultSet).%New()
	d resultStr.Prepare(sqlStr)
	d resultStr.Execute()
	While(resultStr.Next()){
		s ID=resultStr.Data("ID")
		s ItemID = resultStr.Data("ItemID")
		s ItemName = resultStr.Data("ItemName")
		s ItemClick = resultStr.Data("ItemClick")
		s ConditionalExpre = resultStr.Data("ConditionalExpre")
		s StrLink = resultStr.Data("StrLink")
		s DisplayNum = resultStr.Data("DisplayNum")
        s Operator  = resultStr.Data("Operator")
		s OprDate = resultStr.Data("OprDate")
		s IsActive = resultStr.Data("IsActive")
	d OutputRow11
	}
	
	quit $$$OK
	
OutputRow11	
	set Data=$lb(ID,ItemID,ItemName,ItemClick,ConditionalExpre,StrLink,DisplayNum,Operator,OprDate,IsActive)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod StreamlineFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StreamlineExecute ]
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

ClassMethod StreamlineClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StreamlineExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","FindOrd","","cs","","","","","")
ClassMethod FindOrdExecute(ByRef qHandle As %Binary, OrdType As %String, OrdAlias As %String, OrdDesc As %String, OrdSubType As %String, ArcimRowid As %String, AllOrdSets As %String, OrdSetsAlias As %String) As %Status
{
	;w !,OrdType_","_OrdAlias_","_OrdDesc_","_OrdSubType_","_ArcimRowid_","_AllOrdSets_","_OrdSetsAlias
	Set repid=$I(^CacheTemp)
	kill ^TMP("UDHCJFOrdPriceSearch")
	If $g(ind)="" Set ind=1
	s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",itmname="",itmnum="",itmprice="",ordchildtype="",OrdAlias1="",DrgGdesc="" ,ordExternalCode="", ordExternalDesc=""
	s ORCATDesc=$$ALPHAUP^SSUTIL4(OrdType)
	s ORSUBCATDesc=$$ALPHAUP^SSUTIL4(OrdSubType)
	s OrdNameDesc=$g(OrdDesc)
	s OrdAliasDesc=$$ALPHAUP^SSUTIL4(OrdAlias)
	
	s DepHospID="" ;  $G(%session.Data("LOGON.HOSPID"))
	k ArrArc
	;s DepHospID=##class(web.UDHCHospitalGroup).GetDefHospitalInfoByLocID(DepID)
	//s OrdAliasDesc=$g(OrdAlias)
	;yyx 2009-09-21 查询医嘱套的所有医嘱项
	if AllOrdSets="on" d
	.s ARCosRowID="0"
	.f  s ARCosRowID=$o(^ARCOS(ARCosRowID)) q:ARCosRowID=""  d
	..s Count=0
	..d ..GetAllOrderSetItem(ARCosRowID)
	;yyx 2009-09-21 如果医嘱套的别名不为空，则按照医嘱套的别名查询医嘱项
    s OrdSetsAlias=$$ALPHAUP^SSUTIL4(OrdSetsAlias)
	i OrdSetsAlias'="" d
	.s OrdSetsAlias=OrdSetsAlias
	.s OldOrdSetsAlias=OrdSetsAlias
	.s AliasText=$o(^ARC("ALIAS",0,"Desc",OldOrdSetsAlias),-1)
	.;s LastAlias=LastAlias_" "
	.f  s AliasText=$o(^ARC("ALIAS",0,"Desc",AliasText)) q:(AliasText="")!(AliasText'[OldOrdSetsAlias)  d
	..s ALiasDesc=""
	..f  s ALiasDesc=$o(^ARC("ALIAS",0,"Desc",AliasText,ALiasDesc))  q:ALiasDesc=""  d
	...s AliasRowID=""
	...f  s AliasRowID=$o(^ARC("ALIAS",0,"Desc",AliasText,ALiasDesc,AliasRowID))  q:AliasRowID=""  d
	....q:$d(^ARC("ALIAS",AliasRowID))=0
	....s AliasType=$p(^ARC("ALIAS",AliasRowID),"^",5)
	....q:AliasType'="ARCOS"
	....s ARCOSRowID=$p(^ARC("ALIAS",AliasRowID),"^",2)
	....s Count=0
	....d ..GetAllOrderSetItem(ARCOSRowID)
	
	//s OrdAliasDesc=$$ALPHAUP^SSUTIL4(OrdAlias)
	if (ORSUBCATDesc'="")&(OrdNameDesc="")&(OrdAliasDesc="") do 
	.s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
	.s arcsubcat=""  f  s arcsubcat=$o(^ARCIM(0,"ARCIC_DR",arcsubcat)) q:arcsubcat=""  d
	..;s oeccat=$p(^ARC("IC",arccat),"^",8)
	..q:(arcsubcat'=ORSUBCATRowId)
	..s arcrow="0" f  s arcrow=$o(^ARCIM(0,"ARCIC_DR",arcsubcat,arcrow)) q:arcrow=""  d
	...s sub=$o(^ARCIM(0,"ARCIC_DR",arcsubcat,arcrow,""))
	...s arcitmrow=arcrow_"||"_sub
	...q:arcitmrow=""
	...q:$d(ArrArc(arcitmrow))
	...s ArrArc(arcitmrow)=arcitmrow
	...s arcitmrow=$g(arcitmrow)
	...s i=0
	...s text=""
	...s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	....i text'=""  d
	.....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	....e  d
	.....s text=$p(^ARC("ALIAS",aid),"^",6)
	...s OrdAlias1=$g(text)
    ...s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	...s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	...i DrgFormRowid'="" d
	....s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...i DrgMastRowid'="" d
	....i $d(^PHCD(DrgMastRowid,4)) d
	.....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	.....i DrgGdr'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	...s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	...s ordprice2=$j($p(tmpprice,"^",1),3,2)
	...q:$d(^ARCIM(arcrow,sub))=0
	...s ordname2=$p(^ARCIM(arcrow,sub,1),"^",2)
	...s ordOnItOwn=$p(^ARCIM(arcrow,sub,7),"^",13)
    ...q:$g(ordOnItOwn)="N"
	...s ordExternalCode=""
	...;s ordExternalCode=$p($g(^ARCIM(arcrow,sub,"EXT",1)),"^",4)
	...s ordExternalDesc=""
	...;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1) 
	...s chl="" f  s chl=$o(^ARCIM(+arcrow,sub,"EXT",chl)) q:chl=""  d
	....s tod=$p($g(^ARCIM(+arcrow,sub,"EXT",chl)),"^",2)
	....q:(tod'="")&(tod<+$h)
	....s ordExternalCode=$p($g(^ARCIM(+arcrow,sub,"EXT",chl)),"^",4)
	...s ordcode=$p(^ARCIM(arcrow,sub,1),"^",1)
	...s lei=$p(^ARCIM(arcrow,sub,1),"^",10)
	...i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	...s daleicode=$p(^ARC("IC",lei),"^",8)
	...i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	...s flag=0
	...s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	....s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	.....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc=""
	.....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	.....q:(OLTEndDate<=..%SysDate())&&($g(OLTEndDate)'="")
	.....s TariffDR=$p($g(^DHCOLT(OLTRowId)),"^",2)
	.....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	.....q:TariffDR=""
	.....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	.....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	.....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	.....s flag=flag+1
	.....do OutputRow
	if (ORCATDesc'="")&(OrdNameDesc="")&(OrdAliasDesc="") do 
	.s ORCATRowId=$o(^OEC("ORCAT",0,"Desc",ORCATDesc,""))
	.s arccat=""  f  s arccat=$o(^ARCIM(0,"ARCIC_DR",arccat)) q:arccat=""  d
	..s oeccat=$p(^ARC("IC",arccat),"^",8)
	..q:(oeccat'=ORCATRowId)
	..s arcrow="0" f  s arcrow=$o(^ARCIM(0,"ARCIC_DR",arccat,arcrow)) q:arcrow=""  d
	...s sub=$o(^ARCIM(0,"ARCIC_DR",arccat,arcrow,""))
	...s ORSUBCATRowId=""
	...i ORSUBCATDesc'="" s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
	...s arcitmcat=$p(^ARCIM(arcrow,sub,1),"^",10)
	...q:((arcitmcat'=ORSUBCATRowId)&(ORSUBCATRowId'=""))
	...s arcitmrow=arcrow_"||"_sub
	...q:$d(ArrArc(arcitmrow))
	...s ArrArc(arcitmrow)=arcitmrow
	...s arcitmrow=$g(arcitmrow)
	...s i=0
	...s text=""
	...s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	....i text'=""  d
	.....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	....e  d
	.....s text=$p(^ARC("ALIAS",aid),"^",6)
	...s OrdAlias1=$g(text)
    ...s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	...s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	...i DrgFormRowid'="" d
	....s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...i DrgMastRowid'="" d
	....i $d(^PHCD(DrgMastRowid,4)) d
	.....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	.....i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	...s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	...s ordprice2=$j($p(tmpprice,"^",1),3,2)
	...s ordname2=$p(^ARCIM(arcrow,1,1),"^",2)
	...s ordOnItOwn=$p(^ARCIM(arcrow,1,7),"^",13)
    ...q:$g(ordOnItOwn)="N"
	...s ordExternalCode=""
	...;s ordExternalCode=$p($g(^ARCIM(arcrow,1,"EXT",1)),"^",4)
	...s ordExternalDesc=""
	...;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	...s chl="" f  s chl=$o(^ARCIM(+arcrow,1,"EXT",chl)) q:chl=""  d
	....s tod=$p($g(^ARCIM(+arcrow,1,"EXT",chl)),"^",2)
	....q:(tod'="")&(tod<+$h)
	....s ordExternalCode=$p($g(^ARCIM(+arcrow,1,"EXT",chl)),"^",4)
	...s ordcode=$p(^ARCIM(arcrow,1,1),"^",1)
	...s lei=$p(^ARCIM(arcrow,1,1),"^",10)
	...i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	...s daleicode=$p(^ARC("IC",lei),"^",8)
	...i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	...s flag=0
	...s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	....s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	.....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="" ,ordExternalCode="", ordExternalDesc=""
	.....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	.....q:(OLTEndDate<=..%SysDate())&&($g(OLTEndDate)'="")
	.....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	.....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	.....q:TariffDR=""
	.....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	.....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	.....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	.....s flag=flag+1
	.....do OutputRow
	e  if (ORCATDesc="")&(OrdNameDesc'="")&(OrdAliasDesc="") do
	.s OrdNameDesc=$g(OrdNameDesc)
	.s id1="0" f  s id1=$o(^ARCIM(id1)) q:id1=""  d
	..s id2="0" f  s id2=$o(^ARCIM(id1,id2)) q:id2=""  d
	...Q:'($d(^ARCIM(id1,id2,1)))
	...s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	...q:(ordname2'[OrdNameDesc)
	...s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	...s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
    ...q:$g(ordOnItOwn)="N"
	...s lei=$p(^ARCIM(id1,id2,1),"^",10)
	...i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	...s daleicode=$p(^ARC("IC",lei),"^",8)
	...i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	...s arcitmrow=id1_"||"_id2
	...q:$d(ArrArc(arcitmrow))
	...s ArrArc(arcitmrow)=arcitmrow
	...s arcitmrow=$g(arcitmrow)
	...s i=0
	...s text=""
	...s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	....i text'=""  d
	.....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	....e  d
	.....s text=$p(^ARC("ALIAS",aid),"^",6)
	...s OrdAlias1=$g(text)
	...s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	...s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	...i DrgFormRowid'="" d
	....s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...i DrgMastRowid'="" d
	....i $d(^PHCD(DrgMastRowid,4)) d
	.....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	.....i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	...s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	...s ordprice2=$j($p(tmpprice,"^",1),3,2)
	...s ordExternalCode=""
	...s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	....s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	....q:(tod'="")&(tod<+$h)
	....s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
	...s flag=0
	...s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	....s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	.....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="" ,ordExternalCode="", ordExternalDesc=""
	.....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	.....q:(OLTEndDate<=..%SysDate())&&($g(OLTEndDate)'="")
	.....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	.....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	.....q:TariffDR=""
	.....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	.....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	.....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	.....s flag=flag+1
	.....do OutputRow
	e  if (ORCATDesc="")&(OrdNameDesc="")&(OrdAliasDesc'="") do 
	.k ^CHHTEMP("ALIASBJ")
	.s OrdAliasDesc=$g(OrdAliasDesc)
	.s tempOrdAlias=""
	.s id="0" f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
	..s symbo=0
	..s text=$p(^ARC("ALIAS",id),"^",6)
	..s text=$$ALPHAUP^SSUTIL4(text)
	..q:(text '[ OrdAliasDesc)
	..s arcitmrow=$p(^ARC("ALIAS",id),"^",1)
	..q:arcitmrow=""
	..q:$d(ArrArc(arcitmrow))
	..s ArrArc(arcitmrow)=arcitmrow
	..;s ^lgl("sbo",id)=arcitmrow
	..q:arcitmrow=""
	..//q:tempOrdAlias=arcitmrow
	..//i tempOrdAlias'=arcitmrow s tempOrdAlias=arcitmrow
	..s id1=$p(arcitmrow,"||",1)
	..s id2=$p(arcitmrow,"||",2)
	..q:$d(^ARCIM(id1,id2,1))=0
	..s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	..s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	..s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
    ..q:$g(ordOnItOwn)="N"
	..s ordExternalCode=""
	..;s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	..s ordExternalDesc=""
	..;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	..s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	...s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	...q:(tod'="")&(tod<+$h)
	...s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
	..s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	...//s ^CHHTEMP("ALIASBJ",id,i)=arcitmrow_"^"_$p(^CHHTEMP("ALIASBJ",i),"^",1)
	...i arcitmrow=$p(^CHHTEMP("ALIASBJ",i),"^",1)  s symbo=1  
	..q:symbo=1 
	..s ^CHHTEMP("ALIASBJ",id)=arcitmrow_"^"_ordname2
	..s lei=$p(^ARCIM(id1,id2,1),"^",10)
	..i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	..s daleicode=$p(^ARC("IC",lei),"^",8)
	..i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	..s text=""
	..s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	...i text'=""  d
	....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	...e  d
	....s text=$p(^ARC("ALIAS",aid),"^",6)
	..s OrdAlias1=$g(text)
	..s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	..s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	..i DrgFormRowid'="" d
	...s DrgMastRowid=$p(DrgFormRowid,"||",1)
	..i DrgMastRowid'="" d
	...i $d(^PHCD(DrgMastRowid,4)) d
	....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	....i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	..s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	..s ordprice2=$j($p(tmpprice,"^",1),3,2)
	..s flag=0
	..s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	...s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",ordExternalCode="", ordExternalDesc=""
	....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	....q:(OLTEndDate<=..%SysDate())&&($g(OLTEndDate)'="")
	....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	....q:TariffDR=""
	....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	....s flag=flag+1
	....do OutputRow  	
	e  if (ORCATDesc'="")&(OrdNameDesc'="")&(OrdAliasDesc="") do
    .s ORCATRowId=$o(^OEC("ORCAT",0,"Desc",ORCATDesc,""))
	.s arccat=""  f  s arccat=$o(^ARCIM(0,"ARCIC_DR",arccat)) q:arccat=""  d
	..s oeccat=$p(^ARC("IC",arccat),"^",8)
	..q:(oeccat'=ORCATRowId)
	..s arcrow="0" f  s arcrow=$o(^ARCIM(0,"ARCIC_DR",arccat,arcrow)) q:arcrow=""  d
	...s arcitmrow=arcrow_"||"_1
	...s arcitmrow=$g(arcitmrow)
	...q:arcitmrow=""
	...q:$d(ArrArc(arcitmrow))
	...s ArrArc(arcitmrow)=arcitmrow
	...s i=0
	...s text=""
	...s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	....i text'=""  d
	.....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	....e  d
	.....s text=$p(^ARC("ALIAS",aid),"^",6)
	...s OrdAlias1=$g(text)
    ...s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	...s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	...i DrgFormRowid'="" d
	....s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...i DrgMastRowid'="" d
	....i $d(^PHCD(DrgMastRowid,4)) d
	.....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	.....i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	...s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	...s ordprice2=$j($p(tmpprice,"^",1),3,2)
	...s ordname2=$p(^ARCIM(arcrow,1,1),"^",2)
	...s ordOnItOwn=$p(^ARCIM(arcrow,1,7),"^",13)
    ...q:$g(ordOnItOwn)="N"
	...s ordExternalCode=""
	...;s ordExternalCode=$p($g(^ARCIM(arcrow,1,"EXT",1)),"^",4)
	...s ordExternalDesc=""
	...;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)  
	...s chl="" f  s chl=$o(^ARCIM(+arcrow,1,"EXT",chl)) q:chl=""  d
	....s tod=$p($g(^ARCIM(+arcrow,1,"EXT",chl)),"^",2)
	....q:(tod'="")&(tod<+$h)
	....s ordExternalCode=$p($g(^ARCIM(+arcrow,1,"EXT",chl)),"^",4)
	...q:(ordname2'[OrdNameDesc)
	...s ordcode=$p(^ARCIM(arcrow,1,1),"^",1)
	...s lei=$p(^ARCIM(arcrow,1,1),"^",10)
	...i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	...s daleicode=$p(^ARC("IC",lei),"^",8)
	...i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	...s flag=0
	...s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	....s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	.....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",ordExternalCode="", ordExternalDesc=""
	.....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	.....q:(OLTEndDate<=..%SysDate())&&($g(OLTEndDate)'="")
	.....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	.....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	.....q:TariffDR=""
	.....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	.....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	.....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	.....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	.....s flag=flag+1
	.....do OutputRow
	e  if (ORCATDesc'="")&(OrdNameDesc="")&(OrdAliasDesc'="") do 
    .k ^CHHTEMP("ALIASBJ")
	.s OrdAliasDesc=$g(OrdAliasDesc)
	.s tempOrdAlias=""
	.s id="0" f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
	..s symbo=0
	..s text=$p(^ARC("ALIAS",id),"^",6)
	..s text=$$ALPHAUP^SSUTIL4(text)
	..q:(text '[ OrdAliasDesc)
	..s arcitmrow=$p(^ARC("ALIAS",id),"^",1)
	..q:arcitmrow=""
	..q:$d(ArrArc(arcitmrow))
	..s ArrArc(arcitmrow)=arcitmrow
	..//q:tempOrdAlias=arcitmrow
	..//i tempOrdAlias'=arcitmrow s tempOrdAlias=arcitmrow
	..s id1=$p(arcitmrow,"||",1)
	..s id2=$p(arcitmrow,"||",2)
	..q:$d(^ARCIM(id1,id2,1))=0
	..s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	..s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	..s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
	..q:$g(ordOnItOwn)="N" 
	..s ordExternalCode=""
	..;s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	..s ordExternalDesc=""
	..;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	..s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	...s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	...q:(tod'="")&(tod<+$h)
	...s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
	..s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	...//s ^CHHTEMP("ALIASBJ",id,i)=arcitmrow_"^"_$p(^CHHTEMP("ALIASBJ",i),"^",1)
	...i arcitmrow=$p(^CHHTEMP("ALIASBJ",i),"^",1)  s symbo=1  
	..q:symbo=1 
	..s ^CHHTEMP("ALIASBJ",id)=arcitmrow_"^"_ordname2
	..s lei=$p(^ARCIM(id1,id2,1),"^",10)
	..i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	..s daleicode=$p(^ARC("IC",lei),"^",8)
	..i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	..q:ordtype2'=ORCATDesc
	..s text=""
	..s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	...i text'=""  d
	....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	...e  d
	....s text=$p(^ARC("ALIAS",aid),"^",6)
	..s OrdAlias1=$g(text)
	..s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	..s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	..i DrgFormRowid'="" d
	...s DrgMastRowid=$p(DrgFormRowid,"||",1)
	..i DrgMastRowid'="" d
    ...i $d(^PHCD(DrgMastRowid,4)) d
	....s DrgGdr=$p(^PHCD(DrgMastRowid,4),"^",1)
	....i DrgGdr'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	..s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	..s ordprice2=$j($p(tmpprice,"^",1),3,2)
	..s flag=0
	..s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	...s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",  ordExternalCode="",ordExternalDesc=""
	....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	....q:(OLTEndDate<=..%SysDate())&&($g(OLTEndDate)'="")
	....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	....q:TariffDR=""
	....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	....s flag=flag+1
	....do OutputRow    
	e  if (ORCATDesc'="")&(OrdNameDesc'="")&(OrdAliasDesc'="") do 
    .k ^CHHTEMP("ALIASBJ")
	.s OrdAliasDesc=$g(OrdAliasDesc)
	.s tempOrdAlias=""
	.s id="0" f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
	..s symbo=0
	..s text=$p(^ARC("ALIAS",id),"^",6)
	..s text=$$ALPHAUP^SSUTIL4(text)
	..q:(text '[ OrdAliasDesc)
	..s arcitmrow=$p(^ARC("ALIAS",id),"^",1)
	..q:arcitmrow=""
	..q:$d(ArrArc(arcitmrow))
	..s ArrArc(arcitmrow)=arcitmrow
	..//q:tempOrdAlias=arcitmrow
	..//i tempOrdAlias'=arcitmrow s tempOrdAlias=arcitmrow
	..s id1=$p(arcitmrow,"||",1)
	..s id2=$p(arcitmrow,"||",2)
	..q:$d(^ARCIM(id1,id2,1))=0
	..s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	..s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	..s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
    ..q:$g(ordOnItOwn)="N"
	..s ordExternalCode=""
	..;s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	..s ordExternalDesc=""
	..;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	..s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	...s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	...q:(tod'="")&(tod<+$h)
	...s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
	..q:(ordname2'[OrdNameDesc)
	..s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	...//s ^CHHTEMP("ALIASBJ",id,i)=arcitmrow_"^"_$p(^CHHTEMP("ALIASBJ",i),"^",1)
	...i arcitmrow=$p(^CHHTEMP("ALIASBJ",i),"^",1)  s symbo=1  
	..q:symbo=1 
	..s ^CHHTEMP("ALIASBJ",id)=arcitmrow_"^"_ordname2
	..s lei=$p(^ARCIM(id1,id2,1),"^",10)
	..i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	..s daleicode=$p(^ARC("IC",lei),"^",8)
	..i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	..q:ordtype2'=ORCATDesc
	..s text=""
	..s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	...i text'=""  d
	....s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	...e  d
	....s text=$p(^ARC("ALIAS",aid),"^",6)
	..s OrdAlias1=$g(text)
	..s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	..s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	..i DrgFormRowid'="" d
	...s DrgMastRowid=$p(DrgFormRowid,"||",1)
	..i DrgMastRowid'="" d
	...i $d(^PHCD(DrgMastRowid,4)) d
	....s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	....i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	..s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",DepHospID)
	..s ordprice2=$j($p(tmpprice,"^",1),3,2)
	..s flag=0
	..s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate)) q:OLTStartDate=""  d
	...s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",arcitmrow,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	....if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",ordExternalCode="", ordExternalDesc=""
	....s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	....q:(OLTEndDate<=..%SysDate())&&($g(OLTEndDate)'="")
	....s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	....s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	....q:TariffDR=""
	....s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	....s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	....s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	....s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	....s flag=flag+1
	....do OutputRow 
	e  if (ArcimRowid'="") do
	.q:$d(ArrArc(ArcimRowid))
	.s ArrArc(ArcimRowid)=ArcimRowid
	.s id1=$p(ArcimRowid,"||",1)
	.s id2=$p(ArcimRowid,"||",2)
	.q:$d(^ARCIM(id1,id2,1))=0
	.s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	.s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	.s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
    .q:$g(ordOnItOwn)="N"
	.s ordExternalCode=""
	.;s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	.s ordExternalDesc=""
	.;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	.;s ordExternalCode=""
	.s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	..s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	..q:(tod'="")&(tod<+$h)
	..s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
	.s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	.s lei=$p(^ARCIM(id1,id2,1),"^",10)
	.i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	.s daleicode=$p(^ARC("IC",lei),"^",8)
	.i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	.s text=""	
	.s text=""
	.s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",ArcimRowid,aid))  q:aid=""  d
	..i text'=""  d
	...s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	..e  d
	...s text=$p(^ARC("ALIAS",aid),"^",6)
	.s OrdAlias1=$g(text)
	.s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	.s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
	.i DrgFormRowid'="" d
	..s DrgMastRowid=$p(DrgFormRowid,"||",1)
	.i DrgMastRowid'="" d
	..i $d(^PHCD(DrgMastRowid,4)) d
	...s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	...i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	.s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimRowid,+$H,"","","","",DepHospID)
	.s ordprice2=$j($p(tmpprice,"^",1),3,2)
	.s flag=0
	.s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",OLTStartDate)) q:OLTStartDate=""  d
	..s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	...if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",ordExternalCode="", ordExternalDesc=""
	...s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	...q:(OLTEndDate<=..%SysDate())&&($g(OLTEndDate)'="")
	...s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	...s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	...q:TariffDR=""
	...s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	...s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	...s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	...s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	...s flag=flag+1
	...do OutputRow 
	//e  do OutputRow 
	Set qHandle=$lb(0,repid,0)
    quit $$$OK
OutputRow
	set tjob=$j
    if $g(ordname2)="" {
	    set ordExternalCode="" ,ordExternalDesc=""
    }
    s ordname2=##class(web.DHCDocUtil).EvalJSON(ordname2)
    s itmname=##class(web.DHCDocUtil).EvalJSON(itmname)
    s DrgGdesc=##class(web.DHCDocUtil).EvalJSON(DrgGdesc)
    ;set InusTarInfo=##class(web.DHCINSUPort).GetInusTarInfo(TariffDR)
    s InusTarInfo=""
    set InusTarInfo=$case(InusTarInfo,1:"甲",2:"乙",3:"丙","":"")
    if InusTarInfo'="" s itmname="("_InusTarInfo_")"_itmname
    set Data=$lb(ordcode,ordname2,ordtype2,ordprice2,arcitmrow,itmname,itmnum,itmprice,ordchildtype,OrdAlias1,DrgGdesc,itmcode,ordExternalCode,ordExternalDesc,tjob)
 	Set ^CacheTemp(repid,ind)=Data
 	//Set ^TMP("UDHCJFOrdPriceSearch",$j,ind)=$g(ordcode)_"^"_$g(ordname2)_"^"_$g(ordtype2)_"^"_$g(ordprice2)_"^"_$g(arcitmrow)_"^"_$g(itmname)_"^"_$g(itmnum)_"^"_$g(itmprice)_"^"_$g(ordchildtype)_"^"_$g(OrdAlias1)_"^"_$g(DrgGdesc)_"^"_$g(itmcode)_"^"_$g(ordExternalCode)_"^"_$g(ordExternalDesc)
 	Set ^TMP("UDHCJFOrdPriceSearch",$j,ind)=$g(ordcode)_"^"_$g(ordname2)_"^"_$g(ordtype2)_"^"_$g(ordprice2)_"^"_$g(arcitmrow)_"^"_$g(itmname)_"^"_$g(itmnum)_"^"_$g(itmprice)_"^"_$g(ordchildtype)_"^"_$g(OrdAlias1)_"^"_$g(DrgGdesc)_"^"_$g(itmcode)_"^"_$g(ordExternalCode)_"^"_$g(ordExternalDesc)
 	Set ind=ind+1
	
	quit
}

ClassMethod getnum(itmjs As %Library.String = "", itmjsex As %Library.String = "", jj)
{
  s gnum=$o(^TMP("UDHCJFOrdPriceSearch",jj,""),-1)
  q gnum
}

ClassMethod getdata(itmjs As %Library.String = "", itmjsex As %Library.String = "", jj, num)
{
    
	s str=^TMP("UDHCJFOrdPriceSearch",jj,num)
	q str
}

ClassMethod killdata(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
    
	kill ^TMP("UDHCJFOrdPriceSearch")
}

ClassMethod getpath(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

ClassMethod FindOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrdExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindOrd(OrdType As %String, OrdAlias As %String, OrdDesc As %String, OrdSubType As %String, ArcimRowid As %String, AllOrdSets As %String, OrdSetsAlias As %String) As %Query(ROWSPEC = "TOrdCode:%String,TOrdName:%String,TOrdType:%String,TOrdPrice:%String,TArcim:%String,Titmname:%String,Titmnum:%String,Titmprice:%String,TOrdChildType:%String,TOrdAlias:%String,DrgGdesc:%String,Titmcode:%String,TOrdExternalCode:%String,TOrdExternalDesc:%String,Tjob:%String,TOrdSetName:%String,TARCOSItemQty:%String")
{
}

ClassMethod GetAllOrderSetItem(ARCOSRowid As %String)
{
   
	q:$g(ARCOSRowid)=""  
	s ARCOSDateRowid=..GetOrderSetDate(ARCOSRowid) 
	q:'ARCOSDateRowid  
	s ARCOSDesc=$p(^ARCOS(ARCOSRowid),"^",2)
	d ..GetOrderSetItem(ARCOSRowid,ARCOSDateRowid)
	;下面是调出医嘱套里的医嘱套?属于嵌套调用
	;s it=0 f  s it=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"OS",it)) q:it=""  s s=^(it) d
	.;d ..GetAllOrderSetItem(+s)
	Q 0
}

ClassMethod GetOrderSetItem(ARCOSRowid As %String, ARCOSDateRowid As %String) As %String
{
	s allQty=0
	s ARCOSPrice=0
	s item=0 f  s item=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item)) q:item=""  s s=^(item) d
	.s ARCIMRowid=$p(s,"^",1)
	.s Count=Count+1
    .i Count>1 s ARCOSDesc=""
	.q:..ValARCItem(ARCIMRowid)
	.s ARCOSItemQty=$p(s,"^",2)
	.if ARCOSItemQty="" s ARCOSItemQty=1
	.;s count=$o(^TMP("ARCOI",$j,""),-1)+1
	.d ..GetArcimInfo(ARCIMRowid)
	Q 0
}

ClassMethod GetOrderSetDate(ARCOSRowid As %String)
{
	s DATE=$g(DATE) s:'DATE DATE=..%SysDate()
	s ord=+$g(ARCOSRowid) q:'ARCOSRowid 0 
	s dfrom=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",.1+DATE),-1) q:'dfrom 0
	s drow=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",dfrom,"")) q:'drow 0
	s dto=$p($g(^ARCOS(ARCOSRowid,"DATE",drow)),"^",2) i dto,dto<DATE q 0
	q drow
}

ClassMethod GetArcimInfo(ArcimRowid)
{
	if (ArcimRowid'="") do
	.q:$d(ArrArc(ArcimRowid))
	.s ArrArc(ArcimRowid)=ArcimRowid
	.s arcitmrow=ArcimRowid ;add hujunbin 15.2.11
	.s id1=$p(ArcimRowid,"||",1)
	.s id2=$p(ArcimRowid,"||",2)
	.q:$d(^ARCIM(id1,id2,1))=0
	.s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	.s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
	.s ordOnItOwn=$p(^ARCIM(id1,id2,7),"^",13)
    .;q:$g(ordOnItOwn)="N"  //Hw 2009-09-26
	.s ordExternalCode=""
	.;s ordExternalCode=$p($g(^ARCIM(id1,id2,"EXT",1)),"^",4)
	.s ordExternalDesc=""
	.;i ordExternalCode'="" s ordExternalDesc=$p($g(^TTAB("TS",$g(ordExternalCode))),"\",1)
	.s chl="" f  s chl=$o(^ARCIM(+id1,id2,"EXT",chl)) q:chl=""  d
	..s tod=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",2)
	..q:(tod'="")&(tod<+$h)
	..s ordExternalCode=$p($g(^ARCIM(+id1,id2,"EXT",chl)),"^",4)
	.s i=0 f  s i=$o(^CHHTEMP("ALIASBJ",i)) q:i=""  d
	.s lei=$p(^ARCIM(id1,id2,1),"^",10)
	.i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	.s daleicode=$p(^ARC("IC",lei),"^",8)
	.i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	.s text=""
	.s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",ArcimRowid,aid))  q:aid=""  d
	..i text'=""  d
	...s text=text_"/"_$p(^ARC("ALIAS",aid),"^",6)
	..e  d
	...s text=$p(^ARC("ALIAS",aid),"^",6)
	.s OrdAlias1=$g(text)
	.s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	.s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
	.i DrgFormRowid'="" d
	..s DrgMastRowid=$p(DrgFormRowid,"||",1)
	.i DrgMastRowid'="" d
	..i $d(^PHCD(DrgMastRowid,4)) d
	...s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	...i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	.s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimRowid,+$H,"","","","",DepHospID)
	.s ordprice2=$j($p(tmpprice,"^",1),3,2)
	.s ARCOSPrice=ARCOSPrice+(ordprice2*ARCOSItemQty) //Hw 
	.s allQty=allQty+1
	.i ($o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item))="")&&(allQty'=1) s ARCOSDesc=ARCOSPrice
	.s flag=0
	.s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",OLTStartDate)) q:OLTStartDate=""  d
	..s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	...if flag'=0 s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",ordchildtype="",OrdAlias1="",DrgGdesc="",ordExternalCode="", ordExternalDesc="",ARCOSDesc="",ARCOSItemQty=""
	...s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	...q:(OLTEndDate<=..%SysDate())&&($g(OLTEndDate)'="")
	...s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	...s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	...q:TariffDR=""
	...s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	...s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	...s itmpricetmp=##class(web.UDHCJFPRICE).GetItmPrice(TariffDR,+$H,"","","",DepHospID)
	...s itmprice=$j($p(itmpricetmp,"^",1),3,2)
	...s flag=flag+1
	...do OutputRow1
    Set qHandle=$lb(0,repid,0)
    quit $$$OK
OutputRow1
    
    s OrdAlias1=##class(web.DHCDocUtil).EvalJSON(OrdAlias1)
    //i OrdAlias1["/" b //12
	set tjob=$j
    if $g(ordname2)="" set ordExternalCode="" ,ordExternalDesc=""
    s ordname2=##class(web.DHCDocUtil).EvalJSON(ordname2)
    s itmname=##class(web.DHCDocUtil).EvalJSON(itmname)
    set Data=$lb(ordcode,ordname2,ordtype2,ordprice2,arcitmrow,itmname,itmnum,itmprice,ordchildtype,OrdAlias1,DrgGdesc,itmcode,ordExternalCode,ordExternalDesc,tjob,ARCOSDesc,ARCOSItemQty)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ^TMP("UDHCJFOrdPriceSearch",$j,ind)=$g(ordcode)_"^"_$g(ordname2)_"^"_$g(ordtype2)_"^"_$g(ordprice2)_"^"_$g(arcitmrow)_"^"_$g(itmname)_"^"_$g(itmnum)_"^"_$g(itmprice)_"^"_$g(ordchildtype)_"^"_$g(OrdAlias1)_"^"_$g(DrgGdesc)_"^"_$g(itmcode)_"^"_$g(ordExternalCode)_"^"_$g(ordExternalDesc)_"^"_$g(ARCOSDesc)_"^"_$g(ARCOSItemQty) //Hw
 	Set ind=ind+1
	quit
}

ClassMethod ValARCItem(ARCIMRowid As %String) As %String
{
	;validate if arcim is active 0-active,1-not active
	s datefrom=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",13)
	s dateto=$p($g(^ARCIM(+ARCIMRowid,1,7)),"^",1)
	i datefrom>$h q 1
	i dateto,dateto<$h q 1
	q 0
}

ClassMethod FindCurrenAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCurrenAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCurrenAdmExecute(ByRef qHandle As %Binary, Papmino As %String, LocID As %String, UserID As %String) As %Status
{
	s ^RP("Papmino")=Papmino
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	;If LocID="" Set LocID=%session.Get("LOGON.CTLOCID")
	;If UserID="" Set UserID=%session.Get("LOGON.USERID")
	If LocID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	If UserID="" Set qHandle=$lb(0,repid,0) Quit $$$OK	
	s CareId=..GetCareDrByUserID(UserID)
	i CareId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	//s UserID="1335"
	//s LocID="152"
	s AdmType=""
	s index=0
	s IsEmergency=##class(web.DHCOPAdmReg).IsEmergency(LocID)
	if IsEmergency="1" s AdmType="E"
	if (AdmType'="E"){
	s rset=##class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
	do rset.Execute(LocID,UserID,"","",Papmino,"",+$H,+$H,"","on")
	while (rset.Next()) {
		s SeqNo=rset.GetData(28)
		s RegNo=rset.GetData(4)
		s AdmID=rset.GetData(2)
		s PatName=rset.GetData(5)
		s PatSex=rset.GetData(7)
		s PatAge=rset.GetData(35)
		s RegDoctor=rset.GetData(22)
		s TimeRange=rset.GetData(41)
		s PAAdmReason=rset.GetData(20)
		s PAAdmDep=rset.GetData(11)
		s PAAdmType=rset.GetData(13)
		s TPoliticalLevel=rset.GetData(39)
		s TSecretLevel=rset.GetData(40)
		s index=index+1
		d OutputRow3
	}
	}
	else{
	s rset=##class(%ResultSet).%New("web.DHCDocEmergencyPatientList:FindLocDocCurrentAdm")
	do rset.Execute(LocID,UserID,"","",Papmino,"","","","","")
	while (rset.Next()) {
		s SeqNo=rset.GetData(28)
		s RegNo=rset.GetData(4)
		s AdmID=rset.GetData(2)
		s PatName=rset.GetData(5)
		s PatSex=rset.GetData(7)
		s PatAge=rset.GetData(35)
		s RegDoctor=rset.GetData(22)
		s TimeRange=rset.GetData(41)
		s PAAdmReason=rset.GetData(20)
		s PAAdmDep=rset.GetData(11)
		s PAAdmType=rset.GetData(13)
		s TPoliticalLevel=rset.GetData(39)
		s TSecretLevel=rset.GetData(40)
		s index=index+1
		d OutputRow3
	}
		
		}
	d rset.Close()
	d rset.Close()
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(SeqNo,RegNo,AdmID,PatName,PatSex,PatAge,RegDoctor,TimeRange,PAAdmReason,PAAdmDep,PAAdmType,TPoliticalLevel,TSecretLevel,index)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindCurrenAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurrenAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
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

/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","FindCurrenAdm","","63","600")
Query FindCurrenAdm(Papmino As %String, LocID As %String, UserID As %String) As %Query(ROWSPEC = "SeqNo:%String,RegNo:%String,AdmID:%String,PatName:%String,PatSex:%String,PatAge:%String,RegDoctor:%String,TimeRange:%String,PAAdmReason:%String,PAAdmDep:%String,PAAdmType:%String,TPoliticalLevel:%String,TSecretLevel:%String,index:%String")
{
}

ClassMethod GetCareDrByUserID(UserID As %String) As %String
{
	q:UserID="" ""
	s CareId=$P($G(^SSU("SSUSR",UserID)),"^",14)
	q CareId
}

/// w ##class(web.DHCDoc.OP.PatConfigQuery).GetOPDeptStr("O")
ClassMethod GetOPDeptStr(AdmType As %String = "O", LocId As %String = "") As %String
{
	;w ##class(web.DHCDocTransfer).GetOPDeptStr("O")
	Set langid=..%LanguageID()
	s rset=##class(%ResultSet).%New("web.DHCDocTransfer:OPDeptList")
	s ret=""
	i AdmType=""  s AdmType="O"
	do rset.Execute(AdmType)
	while (rset.Next()) {
		s CTDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",rset.GetData(2),langid)
		i ret=""  s ret=rset.GetData(1)_$C(1)_CTDesc_"-"_rset.GetData(3)
		e  s ret=ret_"^"_rset.GetData(1)_$C(1)_CTDesc_"-"_rset.GetData(3)
	}	
	d rset.Close()
	if (ret=""){
		s ctlocId=LocId
		if (ctlocId'=""){
			s CTDesc=$p($g(^CTLOC(ctlocId)),"^",2)
			s CTDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",CTDesc,langid)
			s CTAlias=$P(^CTLOC(ctlocId),"^",43)
			s ret=ctlocId_$C(1)_CTDesc_"-"_CTAlias
		}
	}
	q ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","GetOPDeptStrTransfer","O")
Query GetOPDeptStrTransfer(AdmType As %String = "O") As %Query(ROWSPEC = "ID:%String,DESC:%String,Alias:%String") [ SqlProc ]
{
}

ClassMethod GetOPDeptStrTransferExecute(ByRef qHandle As %Binary, AdmType As %String = "O") As %Status
{
 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	If $g(ind)="" Set ind=1
	s rset=##class(%ResultSet).%New("web.DHCDocTransfer:OPDeptList")
	s ret=""
	i AdmType=""  s AdmType="O"
	do rset.Execute(AdmType)
	while (rset.Next()) {
        s ID=rset.GetData(1)
	    s DESC=rset.GetData(2)
	    s Alias=rset.GetData(3)
	    d OutputRow1222
		}
	
	quit $$$OK
	
OutputRow1222
	set Data=$lb(ID,DESC,Alias)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOPDeptStrTransferFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPDeptStrTransferExecute ]
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

ClassMethod GetOPDeptStrTransferClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPDeptStrTransferExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// /// w ##class(web.DHCDoc.OP.PatConfigQuery).GetDocStr("")
ClassMethod GetDocStr(DepRowId As %String) As %String
{
	;w ##class(web.DHCDocTransfer).GetDocStr(152)
	s rset=##class(%ResultSet).%New("web.DHCDocTransfer:OPDocList")
	s ret=""
	do rset.Execute(DepRowId)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(1)_"$c(2)"_rset.GetData(2)
		e  s ret=ret_"$c(1)"_rset.GetData(1)_"$c(2)"_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

ClassMethod OPDocListExecute(ByRef qHandle As %Binary, DepRowId As %String, LocID As %String, UserID As %String) As %Status
{
	;lxz去掉不必要的限制出诊type在转诊的时候判断 根据需要排班标志过滤不需要显示所有医生。因为不会有出诊
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	s ^yjy(28)=DepRowId
	i DepRowId="" 	Set qHandle=$lb(0,repid,0)	Quit $$$OK
	;s UserID=%session.Get("LOGON.USERID")
	;s LocID=%session.Get("LOGON.CTLOCID")
	i UserID'="" s CareId=..GetCareDrByUserID(UserID)
	i CareId=""   Set qHandle=$lb(0,repid,0)	Quit $$$OK
	s ResRowId=""
	f  s ResRowId=$o(^RB("RES",0,"CTLOC",DepRowId,ResRowId)) q:ResRowId=""  d
	.s DocId=$p($G(^RB("RES",ResRowId)),"^",2)
	.s DocDesc=$p($G(^RB("RES",ResRowId)),"^",17)
	.s ScheSt=$p(^RB("RES",ResRowId),"^",6)
	.Q:(ScheSt'="Y")  
	.s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime()
	.s AvailAS=##class(web.DHCRBApptSchedule).GetAvailRA(ResRowId,+$H,"",TRRowId)
	.Q:AvailAS="" 
	.Do OutputRow2
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(DocId,DocDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod OPDocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPDocListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
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

/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.PatConfigQuery","OPDocList","63","63","600")
Query OPDocList(DepRowId As %String, LocID As %String, UserID As %String) As %Query(ROWSPEC = "DocId:%String,DocDesc:%String")
{
}

/// creator:m马琳
/// date:2016-08-22
/// desc:根据安全组得到开始菜单
/// input:StartTMENU 开始菜单
/// w ##class(web.DHCDoc.OP.PatConfigQuery).GetStartTMENU()
ClassMethod GetStartTMENU(GroupID As %String) As %String
{
	;n (GroupID)
	s StartTMENU=""
	s StartWFRowid=##class(epr.GroupSettings).GetStartPage(GroupID)
    s MainMenuRowid=##class(epr.GroupSettings).GetMainMenu(GroupID)
    if (StartWFRowid'="")&(MainMenuRowid'="") {
	    s Obj=##class(websys.WorkFlow).%OpenId(StartWFRowid)
	    ;s FirstItemDesc=$p(Obj.NamesGet(),"|")
	    s WorkFlowItemID=Obj.WorkFlowItems.GetAt(1).ItemGetObjectId()
	    d Obj.%Close()
	    if WorkFlowItemID'="" {
		    s WFIObj=##class(websys.WorkFlowItemDefinition).%OpenId(WorkFlowItemID)
		    s ComponentID=WFIObj.ComponentGetObjectId()
		    s Url=WFIObj.Url
		    d WFIObj.%Close()
		    if ComponentID'="" {
			    s LoopMenu=0
			    for {
				    s LoopMenu=$O(^websys.MenuI("SubMenuOf1",MainMenuRowid,LoopMenu))
				    q:LoopMenu=""
				    s LMObj=##class(websys.Menu).%OpenId(LoopMenu)
				    s LinkComponentID=LMObj.LinkComponentGetObjectId()
				    s LinkUrl=LMObj.LinkUrl
				    s WorkFlowID=LMObj.WorkFlowGetObjectId()
				    d LMObj.%Close()
				    ;1.按菜单关联的组件找
				    if ComponentID=LinkComponentID s StartTMENU=LoopMenu_"^"_LinkUrl Q
				    ;2.如菜单未关联组件,按配置的工作流下的组件找
				    if (WorkFlowID'="") {
					    s SubWFObj=##class(websys.WorkFlow).%OpenId(WorkFlowID)
					    s SubFirstWFI=SubWFObj.WorkFlowItems.GetAt(1)
					    if $IsObject(SubFirstWFI) {
					    	if ComponentID=SubFirstWFI.Item.ComponentGetObjectId() s StartTMENU=LoopMenu_"^"_LinkUrl Q
					    }
				    }
			    }
		    }
		    ;w ",StartTMENU1="_StartTMENU_",Url="_Url_",ComponentID="_ComponentID_",MainMenuRowid="_MainMenuRowid
		    if (StartTMENU="")&&(Url'="") {
			    s LoopMenu=0
			    for {
				    s LoopMenu=$O(^websys.MenuI("SubMenuOf1",MainMenuRowid,LoopMenu))
				    q:LoopMenu=""
				    s LMObj=##class(websys.Menu).%OpenId(LoopMenu)
				    s LinkComponentID=LMObj.LinkComponentGetObjectId()
				    s LinkUrl=LMObj.LinkUrl
				    d LMObj.%Close()
				    if Url=LinkUrl s StartTMENU=LoopMenu_"^"_LinkUrl Q
			    }
		    }
	    }
    }
    
    Q StartTMENU
    //q "563^opdoc.outpatientlist.csp"
}

ClassMethod GetDefaultResource(RBResRowIdStr As %String, UserID As %String) As %String
{
	s SelfRBAS="",OtherRBAS="",OtherMarkRBASCount=0
	Q:RBResRowIdStr="" SelfRBAS
	s DocID=$P(^SSU("SSUSR",UserID),"^",14)
	for i=1:1:$l(RBResRowIdStr,"^") {
		s ResRowID=$p(RBResRowIdStr,"^",i)
		s LocID=$p(^RB("RES",ResRowID),"^",1)
		s ResCTPCPDR=$p(^RB("RES",ResRowID),"^",2)
		s RapidASRowId=##class(web.DHCRBApptSchedule).GetAvailRA(ResRowID,+$H,"","")
		if RapidASRowId'="" {
			if (ResCTPCPDR=DocID) s SelfRBAS=ResCTPCPDR Q
			else  s OtherMarkRBASCount=OtherMarkRBASCount+1,OtherRBAS=ResCTPCPDR
		}
	}
	Q:SelfRBAS'="" SelfRBAS
	Q:(OtherMarkRBASCount=1) OtherRBAS
	Q:OtherMarkRBASCount>0 ""
	;医生号别对照-是否默认
	s DefaultReg = ##class(DHCDoc.DHCDocConfig.CommonFunction).GetDefaultReg(UserID,LocID)
	Q DefaultReg
}

}
