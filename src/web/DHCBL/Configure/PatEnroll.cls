Class web.DHCBL.Configure.PatEnroll Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor, web.DHCBL.Configure.Preferences) [ ClassType = "", CompileAfter = web.DHCBL.Configure.Preferences, Inheritance = right, ProcedureBlock ]
{

/// 应用名称
Parameter ParaAppKey = "E";

/// 应用子名称
Parameter ParaAppSubKey = "Card";

/// 类名称
Parameter EntityClassName = "web.DHCEntity.Configure.PatEnroll";

Parameter EntityClassNameDisplay = "web.DHCEntity.Configure.PatEnrollDisplay";

/*Query GetCardTypeList() As %SQLQuery(CONTAINID = 1)
{
select CTD_RowID, CTD_Desc 
from SQLUser.DHC_CardTypeDef
where CTD_ActiveFlag='IE' and
(((CTD_DateFrom<=+$H)and (CTD_DateFrom is not null)) or (CTD_DateFrom is null)) and
(((CTD_DateTo>+$h)and (CTD_DateTo is not null)) or (CTD_DateTo is null))
order by CTD_RowID
}*/
/// //
/// //获取卡类型列表
/// //d ##class(%ResultSet).RunQuery("web.DHCBL.Configure.PatEnroll","GetCardTypeList")
Query GetCardTypeList(HospID As %String) As websys.Query(CONTAINID = 0, ROWSPEC = "CTD_RowID:%String,CTD_Desc:%String")
{
}

/// /d ##class(%ResultSet).RunQuery("web.DHCBL.Configure.PatEnroll","GetCardTypeList","zkcs")
ClassMethod GetCardTypeListExecute(ByRef QHandle As %Binary, HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set index=1
	s id=0
	for{
		s id=$o(^DHCCARDTYPEDef(id))
		Quit:id=""
		s CardDesc=$p(^DHCCARDTYPEDef(id),"^",2)
		s CTDActiveFlag=$p(^DHCCARDTYPEDef(id),"^",11)
		s CTDDateFrom=$p(^DHCCARDTYPEDef(id),"^",9)
		continue:(CTDDateFrom'="")&&(CTDDateFrom>+$h)
		s CTDDateTo=$p(^DHCCARDTYPEDef(id),"^",10)
		continue:(CTDDateTo'="")&&(CTDDateTo<=..%SysDate())
		continue:CTDActiveFlag'="IE"
		continue:(HospID'="")&&("N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_CardTypeDef",id,HospID))
		d OutputRow
	}
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	Set ^CacheTemp(repid,index)=$lb(id,CardDesc)
	Set index=index+1
	quit
}

/// /获得患者有效的患者列表
Query GetPatTypeList() As %SQLQuery(CONTAINID = 1)
{
select SS_RowID, SS_Desc 
from SQLUser.CT_SocialStatus 
order by SS_RowID
}

ClassMethod DTOTransObjForDisplay(DTObj As %ObjectHandle) As %ObjectHandle
{
	q:('$IsObject(DTObj)) DTObj
	b	;
	s myDisObj=##class(web.DHCEntity.Configure.PatEnrollDisplay).%New()
	s myDisObj.AccManageFLag = DTObj.AccManageFLag
	s myDisObj.CardRefFlag = DTObj.CardRefFlag
	s myDisObj.DefaultCardTypeDR = DTObj.DefaultCardTypeDR
	s myDisObj.DefaultCityDR = DTObj.DefaultCityDR
	i myDisObj.DefaultCityDR'=""{
		s myDisObj.DefaultCityDesc = $p($g(^CT("CIT",myDisObj.DefaultCityDR)),"^",2)
	}
	s myDisObj.DefaultIDEquipDR = DTObj.DefaultIDEquipDR
	s myDisObj.DefaultCountryDR = DTObj.DefaultCountryDR
	if DTObj.DefaultCountryDR'=""{
		s myDisObj.DefaultCountryDesc = $p($g(^CT("COU",DTObj.DefaultCountryDR)),"^",2)
	}
	s myDisObj.DefaultNationDR = DTObj.DefaultNationDR
	if DTObj.DefaultNationDR'="" {
		s myDisObj.DefaultNationDesc = $p($g(^CT("NAT",DTObj.DefaultNationDR)),"^",2)
	}
	s myDisObj.DefaultPatTypeDR = DTObj.DefaultPatTypeDR
	s myDisObj.DefaultProvinceDR = DTObj.DefaultProvinceDR
	i DTObj.DefaultProvinceDR'="" {
		s myDisObj.DefaultProvinceDesc = $p($g(^CT("PROV",DTObj.DefaultProvinceDR)),"^",2)
	}
	s myDisObj.DefaultSexDR = DTObj.DefaultSexDR
	s myDisObj.PatMasFlag = DTObj.PatMasFlag
	
	
	;s myDisObj.CardTypeList = DTObj.CardTypeList
	;s myDisObj.PatTypeList = DTObj.PatTypeList
	
	q myDisObj
}

ClassMethod GetSelectCardTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSelectCardTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSelectPatTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSelectPatTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSelectCardTypeListExecute(ByRef qHandle As %Binary, ObjectType As %String = "", ObjectReference As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCBL.Configure.PatEnroll","GetSelectCardTypeList","U","6")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	;s ^TMPSelPatType=$lb(ObjectType, ObjectReference)
	
	s (myValue, myDisValue)=""
	s myDataObj=..DHCGetObjectByReference(ObjectType, ObjectReference)
	if ('$IsObject(myDataObj)){
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	s mylistCount=myDataObj.CardTypeList.Count()
	
	f i=1:1:mylistCount  d
	.s myCardTypeDR=myDataObj.CardTypeList.GetAt(i)
	.;^CT("SS",myPatTypeDR)
	.s myDisValue=$p(^DHCCARDTYPEDef(myCardTypeDR),"^",2)
	.s myValue=myCardTypeDR
	.Do OutputRowSCTObj
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowSCTObj
	set Data=$lb(myValue, myDisValue)
	Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod GetSelectPatTypeListExecute(ByRef qHandle As %Binary, ObjectType As %String, ObjectReference As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCBL.Configure.PatEnroll","GetSelectPatTypeList","U","6")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	;s ^TMPSelPatType=$lb(ObjectType, ObjectReference)
	
	s (myValue, myDisValue)=""
	s myDataObj=..DHCGetObjectByReference(ObjectType, ObjectReference)
	if ('$IsObject(myDataObj)){
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	s mylistCount=myDataObj.PatTypeList.Count()
	
	f i=1:1:mylistCount  d
	.s myPatTypeDR=myDataObj.PatTypeList.GetAt(i)
	.;^CT("SS",myPatTypeDR)
	.s myDisValue=$p(^CT("SS",myPatTypeDR),"^",2)
	.s myValue=myPatTypeDR
	.Do OutputRowLObj
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLObj
	set Data=$lb(myValue, myDisValue)
	Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod GetSelectCardTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSelectCardTypeListExecute ]
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

ClassMethod GetSelectPatTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSelectPatTypeListExecute ]
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

ClassMethod GetWaitSelCardTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWaitSelCardTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetWaitSelPatTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWaitSelPatTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
	Quit $$$OK
}

ClassMethod GetWaitSelCardTypeListExecute(ByRef qHandle As %Binary, ObjectType As %String = "", ObjectReference As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCBL.Configure.PatEnroll","GetWaitSelCardTypeList","U","6")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	;s ^TMPSelPatType=(ObjectType11212_","_ ObjectReference1)
	
	s myObjFlag=0
	s (myValue, myDisValue)=""
	s myDataObj=..DHCGetObjectByReference(ObjectType, ObjectReference)
	if ($IsObject(myDataObj)){
		s myObjFlag=1
	}
	;s mylistCount=myDataObj.CardTypeList.Count()
	
	;f i=1:1:mylistCount  d
	
	s myCardTypeDR=0
	f  s myCardTypeDR=$o(^DHCCARDTYPEDef(myCardTypeDR))  q:(myCardTypeDR="")  d
	.s myDisValue=$p(^DHCCARDTYPEDef(myCardTypeDR),"^",2)
	.s CTDActiveFlag=$p(^DHCCARDTYPEDef(myCardTypeDR),"^",11)
	.q:CTDActiveFlag'="IE"
	.s myDateTo=+$p(^DHCCARDTYPEDef(myCardTypeDR),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<=..%SysDate()))			;失效日
	.s myDateFrom=+$p(^DHCCARDTYPEDef(myCardTypeDR),"^", 9)		;CTD_DateFrom
	.q:((+myDateFrom'=0)&(myDateFrom>+$h))			;生效日
	.s myValue=myCardTypeDR
	.s myFindFlag=0
	.i +myObjFlag d
	..s myListCount=myDataObj.CardTypeList.Count()
	..f myIdx=1:1:myListCount q:(+myFindFlag)  d
	...i myDataObj.CardTypeList.GetAt(myIdx)=myCardTypeDR d
	....s myFindFlag=1
	.q:(+myFindFlag)
	.Do OutputRowWSCTObj
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowWSCTObj
	set Data=$lb(myValue, myDisValue)
	Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod GetWaitSelCardTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWaitSelCardTypeListExecute ]
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

ClassMethod GetWaitSelPatTypeListExecute(ByRef qHandle As %Binary, ObjectType As %String = "", ObjectReference As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	;d ##class(%ResultSet).RunQuery("web.DHCBL.Configure.PatEnroll","GetWaitSelPatTypeList","U","6")
	s ind=1
	s ret=0
	;s ^TMPSelPatType=$lb(ObjectType, ObjectReference)
	
	s (myValue, myDisValue)=""
	s myDataObj=..DHCGetObjectByReference(ObjectType, ObjectReference)
	s myObjFlag=0
	if ($IsObject(myDataObj)){
		;Set qHandle=$lb(0,repid,0) 
		;Quit $$$OK
		s myObjFlag=1
	}
	
	s myPatTypeDR=0
	f  s myPatTypeDR=$o(^CT("SS",myPatTypeDR)) q:(myPatTypeDR="")  d
	.;^CT("SS",myPatTypeDR)
	.s myDisValue=$p(^CT("SS",myPatTypeDR),"^",2)
	.s myValue=myPatTypeDR
	.s myFindFlag=0
	.i +myObjFlag d
	..s myListCount=myDataObj.PatTypeList.Count()
	..f myIdx=1:1:myListCount q:(+myFindFlag)  d
	...i myDataObj.PatTypeList.GetAt(myIdx)=myPatTypeDR d
	....s myFindFlag=1
	.q:(+myFindFlag)
	.Do OutputRowObj
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowObj
	set Data=$lb(myValue, myDisValue)
	Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod GetWaitSelPatTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWaitSelPatTypeListExecute ]
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

Query GetSelectCardTypeList(ObjectType As %String = "", ObjectReference As %String = "") As %Query(ROWSPEC = "CTD_RowID:%String,CTD_Desc:%String")
{
}

Query GetSelectPatTypeList(ObjectType As %String, ObjectReference As %String) As %Query(ROWSPEC = "SS_RowID:%String,SS_Desc:%String")
{
}

Query GetWaitSelCardTypeList(ObjectType As %String = "", ObjectReference As %String = "") As %Query(ROWSPEC = "CTD_RowID:%String,CTD_Desc:%String")
{
}

Query GetWaitSelPatTypeList(ObjectType As %String = "", ObjectReference As %String = "") As %Query(ROWSPEC = "SS_RowID:%String,SS_Desc:%String")
{
}

ClassMethod FindPreferencesExecute(ByRef qHandle As %Binary, ObjectType As %String = "", ObjectReference As %String = "", HospID As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCBL.Configure.PatEnroll","FindPreferences","U","")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	;s ^TMPSelPatType=$lb(ObjectType, ObjectReference)
	
	s Type=0
	for{
		s Type=$o(^User.DHCPreferencesI("UqIndex",Type))
		Quit:Type=""
		continue:(ObjectType'="")&&($tr(Type," ","")'=ObjectType)
		s Reference=0
		for{
			s Reference=$o(^User.DHCPreferencesI("UqIndex",Type,Reference))
			Quit:Reference=""
			continue:(ObjectReference'="")&&(ObjectReference'=$tr(Reference," ",""))
			s Rowid=0
			for{
				s Rowid=$o(^User.DHCPreferencesI("UqIndex",Type,Reference," E"," CARD",Rowid))
				Quit:Rowid=""
				
				s ReferenceId=$tr(Reference," ","")
				s ObjectTypeDesc=$tr(Type," ","")
				s TypeReference=""
				if ObjectTypeDesc="L"{
					s ObjectTypeDesc="科室"	
					continue:'$d(^CTLOC(ReferenceId))
					continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",ReferenceId,HospID)
					s TypeReference=$p(^CTLOC(ReferenceId),"^",2)
					if TypeReference["-" s TypeReference=$p(TypeReference,"-",2)
				}elseif(ObjectTypeDesc="U"){
					s ObjectTypeDesc="用户"	
					continue:'$d(^SSU("SSUSR",ReferenceId))
					continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",ReferenceId,HospID)
					s TypeReference=$p(^SSU("SSUSR",ReferenceId),"^",2)	
				}elseif(ObjectTypeDesc="G"){
					s ObjectTypeDesc="安全组"	
					continue:'$d(^SSU("SSGRP",ReferenceId))
					continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_Group",ReferenceId,HospID)
					s TypeReference=$p(^SSU("SSGRP",ReferenceId),"^",1)	
				}elseif(ObjectTypeDesc="H"){
					continue:ReferenceId'=HospID
					s ObjectTypeDesc="医院"	
					continue:'$d(^CT("HOSP",ReferenceId))
					//continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Hospital",ReferenceId,HospID)
					s TypeReference=$p(^CT("HOSP",ReferenceId),"^",2)		
				}
				
				//s TypeReference=$tr(ObjectReference," ","")
				s myDataObj=..DHCGetDataObjectByRowID(Rowid)
				s PatMasFlag=myDataObj.PatMasFlag
				s CardRefFlag=myDataObj.CardRefFlag
				s AccManageFLag=myDataObj.AccManageFLag
				s DefaultCountryDR=myDataObj.DefaultCountryDR
				s DefaultCountryDesc=""
				if DefaultCountryDR'=""{
					s DefaultCountryDesc=$p($g(^CT("COU",DefaultCountryDR)),"^",2)
				}
				s DefaultProvinceDR=myDataObj.DefaultProvinceDR
				s DefaultProvinceDesc=""
				if DefaultProvinceDR'=""{
					s DefaultProvinceDesc = $p($g(^CT("PROV",DefaultProvinceDR)),"^",2)	
				}
				s DefaultCityDR=myDataObj.DefaultCityDR
				s DefaultCityDesc=""
				if DefaultCityDR'=""{
					s DefaultCityDesc=$p($g(^CT("CIT",DefaultCityDR)),"^",2)	
				}
				s DefaultNationDR=myDataObj.DefaultNationDR
				s DefaultNationDesc=""
				if DefaultNationDR'=""{
					s DefaultNationDesc= $p($g(^CT("NAT",DefaultNationDR)),"^",2)	
				}
				s DefaultPatTypeDR=myDataObj.DefaultPatTypeDR
				s DefaultPatTypeDesc=""
				if DefaultPatTypeDR'=""{
					s DefaultPatTypeDesc=$p(^CT("SS",DefaultPatTypeDR),"^",2)	
				}
				s DefaultCardTypeDR=myDataObj.DefaultCardTypeDR
				s DefaultCardTypeDesc=""
				if DefaultCardTypeDR'=""{
					s DefaultCardTypeDesc=$p(^DHCCARDTYPEDef(DefaultCardTypeDR),"^",2)	
				}
				s DefaultIDEquipDR=myDataObj.DefaultIDEquipDR
				s DefaultIDEquipDesc=""
				if DefaultIDEquipDR'=""{
					s DefaultIDEquipDesc=$p($g(^DHCCARDHARDCOM("MANAGER",DefaultIDEquipDR)),"^",2)
				}
				s CardTypeStr=""
	
				s CardTypelistCount=myDataObj.CardTypeList.Count()
	
				f i=1:1:CardTypelistCount  d
				.s myCardTypeDR=myDataObj.CardTypeList.GetAt(i)
				.Quit:+myCardTypeDR=0
				.s CardDesc=$p(^DHCCARDTYPEDef(myCardTypeDR),"^",2)
				.if CardTypeStr="" do
				..s CardTypeStr=CardDesc
				.else  do
				..s CardTypeStr=CardTypeStr_","_CardDesc
	
				s PatTypeStr=""
				s PatTypelistCount=myDataObj.PatTypeList.Count()
	
				f i=1:1:PatTypelistCount  d
				.s myPatTypeDR=myDataObj.PatTypeList.GetAt(i)
				.Quit:+myPatTypeDR=0
				.s PatTypeDesc=$p(^CT("SS",myPatTypeDR),"^",2)	
				.if PatTypeStr="" do
				..s PatTypeStr=PatTypeDesc
				.else  do
				..s PatTypeStr=PatTypeStr_","_PatTypeDesc
				do OutputRowSCTObj
			}
		}
	}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowSCTObj
	set Data=$lb(Rowid,ObjectTypeDesc,TypeReference,PatMasFlag,AccManageFLag,CardRefFlag,DefaultCountryDesc,DefaultProvinceDesc,DefaultCityDesc,DefaultNationDesc,DefaultCardTypeDesc,DefaultIDEquipDesc,DefaultPatTypeDesc,CardTypeStr,PatTypeStr)
	Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod FindPreferencesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPreferencesExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPreferencesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPreferencesExecute ]
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

Query FindPreferences(ObjectType As %String = "", ObjectReference As %String = "", HospID As %String = "") As %Query(ROWSPEC = "ID:%String,ObjectType:%String,ObjectTypeReference:%String,PatMasFlag:%String,AccManageFLag:%String,CardRefFlag:%String,DefaultCountryDesc:%String,DefaultProvinceDesc:%String,DefaultCityDesc:%String,DefaultNationDesc:%String,DefaultCardTypeDesc:%String,DefaultIDEquipDesc:%String,DefaultPatTypeDesc:%String,CardTypeList:%String,PatTypeList:%String")
{
}

ClassMethod GetObjectTypeDataExecute(ByRef qHandle As %Binary, ObjectType As %String = "", desc As %String = "", HospID As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCBL.Configure.PatEnroll","GetObjectTypeData","U","")
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	;s ^TMPSelPatType=$lb(ObjectType, ObjectReference)
	s:HospID="" HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	if ObjectType="U"{
		Set rs=##Class(%ResultSet).%New("web.DHCBL.Configure.PrefParas:GetUser")
 		Set Status=rs.Execute(desc)
		If 'Status Quit
	 	While rs.Next() {
		 	Set Desc=rs.GetData(1)  
		 	Set Id=rs.GetData(5)
		 	continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",Id,HospID)
		 	Set Code=rs.GetData(2)
		 	do OutputRowSCTObj
	 	}
	}elseif ObjectType="L"{
		i $g(desc)'="" s desc=$$ALPHAUP^SSUTIL4(desc)
		s len=$l(desc)
	    s ctlocrowid=0 for {
		    s ctlocrowid=$o(^CTLOC(ctlocrowid)) q:ctlocrowid=""  d
		    continue:'$d(^CTLOC(ctlocrowid))
		    s locHospId=$p(^CTLOC(ctlocrowid),"^",22)
		    continue:(locHospId'=HospID)&(locHospId'="")&(HospID'="")
		    s LocActiveFrom=+$p($g(^CTLOC(ctlocrowid)),"^",24)
			s LocActiveTo=+$p($g(^CTLOC(ctlocrowid)),"^",25)
			continue:((LocActiveFrom'=0)&&(LocActiveFrom>+$h))||((LocActiveTo<+$h)&&(LocActiveTo'=0))
		    s ctlocdesc=$p(^CTLOC(ctlocrowid),"^",2)
		    s desc1=$$ALPHAUP^SSUTIL4(ctlocdesc)
		    s desc1=$e(desc1,1,len)
		    continue:##class(web.DHCOPAdmReg).CheckLocDesc(ctlocrowid,desc)'=1
			continue:($P(^CTLOC(ctlocrowid),"^",14)'="Y")
		    s Desc=ctlocdesc
		    s Id=ctlocrowid
		    s Code=$p(^CTLOC(Id),"^",1)
		    do OutputRowSCTObj
		}
	}elseif ObjectType="G"{
		Set rs=##Class(%ResultSet).%New("web.DHCBL.Configure.PrefParas:GetGroup")
 		Set Status=rs.Execute(desc)
		If 'Status Quit
	 	While rs.Next() {
		 	Set Desc=rs.GetData(1)  
		 	Set Id=rs.GetData(2)
		 	continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_Group",Id,HospID)
			s ActiveFlag=$p(^SSU("SSGRP",Id),"^",151)
			continue:ActiveFlag="N"
		 	Set Code=Id
		 	do OutputRowSCTObj
	 	}	
	}elseif ObjectType="H"{
		//Set rs=##Class(%ResultSet).%New("web.DHCBL.Configure.PrefParas:GetHospital")
		Set rs=##Class(%ResultSet).%New("web.DHCBL.BDP.BDPMappingHOSP:GetHospDataForCombo")
 		Set Status=rs.Execute("",desc,"Doc_Reg_CardRegDef","")
		If 'Status Quit
	 	While rs.Next() {
		 	Set Desc=rs.GetData(2)  //排班记录id
		 	Set Id=rs.GetData(1)
		 	//continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Hospital",Id,HospID)
		 	Set Code=$p(^CT("HOSP",Id),"^",1) //rs.GetData(3)
		 	do OutputRowSCTObj
	 	}	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowSCTObj
	set Data=$lb(Id,Desc,Code)
	Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod GetObjectTypeDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetObjectTypeDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetObjectTypeDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetObjectTypeDataExecute ]
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

Query GetObjectTypeData(ObjectType As %String = "", desc As %String = "", HospID As %String = "") As %Query(ROWSPEC = "Id:%String,Desc:%String,Code:%String")
{
}

/// w ##class(web.DHCBL.Configure.PatEnroll).GetObjectTypeDataById(66)
ClassMethod GetObjectTypeDataById(RowId As %String)
{
	s Type=$list(^User.DHCPreferencesD(RowId),3)
	s Reference=$list(^User.DHCPreferencesD(RowId),4)
	s ReferenceId=$tr(Reference," ","")
	s ObjectType=$tr(Type," ","")
	s TypeReference=""
	if ObjectType="L"{
		s TypeReference=$p(^CTLOC(ReferenceId),"^",2)
		if TypeReference["-" s TypeReference=$p(TypeReference,"-",2)
	}elseif(ObjectType="U"){
		s TypeReference=$p(^SSU("SSUSR",ReferenceId),"^",2)	
	}elseif(ObjectType="G"){	
		s TypeReference=$p(^SSU("SSGRP",ReferenceId),"^",1)	
	}elseif(ObjectType="H"){
		s TypeReference=$p(^CT("HOSP",ReferenceId),"^",2)		
	}
				
	//s TypeReference=$tr(ObjectReference," ","")
	s myDataObj=..DHCGetDataObjectByRowID(RowId)
	s PatMasFlag=myDataObj.PatMasFlag
	s CardRefFlag=myDataObj.CardRefFlag
	s AccManageFLag=myDataObj.AccManageFLag
	s DefaultCountryDR=myDataObj.DefaultCountryDR
	s DefaultCountryDesc=""
	if DefaultCountryDR'=""{
		s DefaultCountryDesc=$p($g(^CT("COU",DefaultCountryDR)),"^",2)
	}
	s DefaultProvinceDR=myDataObj.DefaultProvinceDR
	s DefaultProvinceDesc=""
	if DefaultProvinceDR'=""{
		s DefaultProvinceDesc = $p($g(^CT("PROV",DefaultProvinceDR)),"^",2)	
	}
	s DefaultCityDR=myDataObj.DefaultCityDR
	s DefaultCityDesc=""
	if DefaultCityDR'=""{
		s DefaultCityDesc=$p($g(^CT("CIT",DefaultCityDR)),"^",2)	
	}
	s DefaultNationDR=myDataObj.DefaultNationDR
	s DefaultNationDesc=""
	if DefaultNationDR'=""{
		s DefaultNationDesc= $p($g(^CT("NAT",DefaultNationDR)),"^",2)	
	}
	s DefaultPatTypeDR=myDataObj.DefaultPatTypeDR
	s DefaultPatTypeDesc=""
	if DefaultPatTypeDR'=""{
		s DefaultPatTypeDesc=$p(^CT("SS",DefaultPatTypeDR),"^",2)	
	}
	s DefaultCardTypeDR=myDataObj.DefaultCardTypeDR
	s DefaultCardTypeDesc=""
	if DefaultCardTypeDR'=""{
		s DefaultCardTypeDesc=$p(^DHCCARDTYPEDef(DefaultCardTypeDR),"^",2)	
	}
	s DefaultIDEquipDR=myDataObj.DefaultIDEquipDR
	s DefaultIDEquipDesc=""
	if DefaultIDEquipDR'=""{
		s DefaultIDEquipDesc=$p(^DHCCARDHARDCOM("MANAGER",DefaultIDEquipDR),"^",2)
	}
	s CardTypeStr=""
	
	s CardTypelistCount=myDataObj.CardTypeList.Count()
	
	s CardTypeArr=[]
	f i=1:1:CardTypelistCount  d
	.s myCardTypeDR=myDataObj.CardTypeList.GetAt(i)
	.b ;1212
	.Quit:+myCardTypeDR=0
	.s CardDesc=$p(^DHCCARDTYPEDef(myCardTypeDR),"^",2)
	.do CardTypeArr.%Push(myCardTypeDR)
	
	s PatTypeStr=""
	s PatTypelistCount=myDataObj.PatTypeList.Count()
	s PatTypeArr=[]
	f i=1:1:PatTypelistCount  d
	.s myPatTypeDR=myDataObj.PatTypeList.GetAt(i)
	.Quit:+myPatTypeDR=0
	.s PatTypeDesc=$p(^CT("SS",myPatTypeDR),"^",2)	
	.do PatTypeArr.%Push(myPatTypeDR)
	
	s JsonObj={}
	s JsonObj.ObjectType=ObjectType
	s JsonObj.ObjectData=TypeReference
	s JsonObj.ObjectDataId=ReferenceId
	s JsonObj.PatMasFlag=PatMasFlag
	s JsonObj.AccManageFLag=AccManageFLag
	s JsonObj.CardRefFlag=CardRefFlag
	s JsonObj.Country=DefaultCountryDesc
	s JsonObj.DefaultCountryDR=DefaultCountryDR
	s JsonObj.Province=DefaultProvinceDesc
	s JsonObj.DefaultProvinceDR=DefaultProvinceDR
	s JsonObj.DefaultCityDR=DefaultCityDR
	s JsonObj.City=DefaultCityDesc
	s JsonObj.Nation=DefaultNationDesc
	s JsonObj.DefaultNationDR=DefaultNationDR
	s JsonObj.DefaultCardTypeDR=DefaultCardTypeDR
	s JsonObj.DefaultIDEquipDR=DefaultIDEquipDR
	s JsonObj.DefaultPatTypeDR=DefaultPatTypeDR
	s JsonObj.PatTypeList=PatTypeArr
	s JsonObj.CardTypeList=CardTypeArr
	
	Quit JsonObj.%ToJSON()
}

/// w ##class(web.DHCBL.Configure.PatEnroll).Delete(62)
ClassMethod Delete(RowID As %String) As %String
{
	&sql(Delete from SQLUSER.DHC_Preferences Where ID=:RowID)
	Quit SQLCODE
}

}
