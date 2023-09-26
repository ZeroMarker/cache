Class web.DHCBL.CARD.CardPATRegConfig Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod Insert(SearchMasFlag As %String, SetFocusElement As %String, PatMasFlag As %String, CardRefFlag As %String, AccManageFLag As %String, ParseTag As %String, Country As %String, Province As %String, City As %String, Nation As %String, IsNotStructAddress As %String = "") As %String
{
	TStart
	set config=##class(User.DHCCardPATRegConfig).%New()
	set config.CPRSearchMasFlag=SearchMasFlag
	set config.CPRSetFocusElement=SetFocusElement
	set config.CPRPatMasFlag=PatMasFlag
	set config.CPRCardRefFlag=CardRefFlag
	set config.CPRAccManageFLag=AccManageFLag
	set config.CPRParseTag=ParseTag
	set config.CPRDefaultCountryDR = Country
	set config.CPRDefaultNationDR = Nation
	set config.CPRDefaultProvinceDR = Province
	set config.CPRDefaultCityDR =City
    set config.CPRIsNotStructAddressFLag=IsNotStructAddress
	set sc=config.%Save()
		If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit -100
	}
	TCommit
	
	Quit config.%Id()
}

ClassMethod Update(RowID As %String, SearchMasFlag As %String, SetFocusElement As %String, PatMasFlag As %String, CardRefFlag As %String, AccManageFLag As %String, ParseTag As %String, Country As %String, Province As %String, City As %String, Nation As %String, IsNotStructAddress As %String = "") As %String
{
	TStart
	set config=##class(User.DHCCardPATRegConfig).%OpenId(RowID)
	set config.CPRSearchMasFlag=SearchMasFlag
	set config.CPRSetFocusElement=SetFocusElement
	set config.CPRPatMasFlag=PatMasFlag
	set config.CPRCardRefFlag=CardRefFlag
	set config.CPRAccManageFLag=AccManageFLag
	set config.CPRParseTag=ParseTag
	set config.CPRDefaultCountryDR = Country
	set config.CPRDefaultNationDR = Nation
	set config.CPRDefaultProvinceDR = Province
	set config.CPRDefaultCityDR =City
    set config.CPRIsNotStructAddressFLag=IsNotStructAddress
	set sc=config.%Save()
		If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit -100
	}
	TCommit
	
	Quit config.%Id()
}

ClassMethod Delete(RowId As %String) As %String
{
	TStart
	set sc=##class(User.DHCCardPATRegConfig).%DeleteId(RowId)
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit -100
	}
	TCommit
	Quit 1
}

ClassMethod GetCardPatRegConfig() As %String
{
	set Returnvalue=""
	set RowID=""
	set RowID=$order(^DHCCARDPATREGCONFIG(RowID))
	while(RowID '="")
	{
		set Returnvalue=RowID_"^"_$get(^DHCCARDPATREGCONFIG(RowID))
		set RowID=$order(^DHCCARDPATREGCONFIG(RowID))
	}
	quit Returnvalue
}

Query CardPatRegConfigQuery() As %SQLQuery(CONTAINID = 1)
{
SELECT CPR_RowID AS ID,CPR_SearchMasFlag AS SearchMasFlag,
CPR_SetFocusElement AS SetFocusElement,
CPR_PatMasFlag As PatMasFlag,CPR_CardRefFlag As CardRefFlag,
CPR_AccManageFLag As AccManageFLag,CPR_ParseTag AS ParseTag 
FROM SQLUSER.DHC_CardPATRegConfig
}

Query CardPatRegConfigQueryT(HospId As %String = "") As %Query(ROWSPEC = "ID:%String,SearchMasFlag:%String,SetFocusElement:%String,PatMasFlag:%String,CardRefFlag:%String,AccManageFlag:%String,ParseTag:%String,DefualtCoury:%String,DefualtCouryDR:%String,DefualtNation:%String,DefualtNationDR:%String,DefualtProvince:%String,DefualtProvinceDR:%String,DefualtCity:%String,DefualtCityDR:%String,CPRIsNotStructAddressFLag:%String,CPRHospDR:%String,Hosp:%String,CPRCardRegMustFillIn:%String,CPRCardRegJumpSeq:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCBL.CARD.CardPATRegConfig","CardPatRegConfigQueryT")
ClassMethod CardPatRegConfigQueryTExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	set RowID =""
 	Set RowID=$Order(^DHCCARDPATREGCONFIG(RowID))
 	while(RowID'="")
	{
		set SearchMasFlag=$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",1)
		set SetFocusElement=$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",2)
		set PatMasFlag=$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",3)
		set CardRefFlag =$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",4)
		set AccManageFlag=$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",5)
		set ParseTag=$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",6)
		//set DefualtCoury=$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",7)
		set DefualtCoury=$s(+$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",7)'=0:$p($g(^CT("COU",$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",7))),"^",2),1:"")
		set DefualtCouryDR=$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",7)
		//set DefualtNation=$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",8)
		set DefualtNation=$s(+$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",8)'=0:$p($g(^CT("NAT",$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",8))),"^",2),1:"")
		set DefualtNationDR=$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",8)
		//set DefualtProvince=$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",9)
		set DefualtProvince =$s(+$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",9)'=0:$p($g(^CT("PROV",$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",9))),"^",2),1:"")
		set DefualtProvinceDR=$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",9)
		//set DefualtCity =$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",10)
		set DefualtCity=$s(+$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",10)'=0:$p($g(^CT("CIT",$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",10))),"^",2),1:"")
		set DefualtCityDR=$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",10)
		set CPRIsNotStructAddressFLag=$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",17)
		set HospDr=$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",18)
		if (HospId="")||((HospDr=HospId)&&(HospId'="")) {
			if (HospDr'=""){
				set Hosp=$p($g(^CT("HOSP",HospDr)),"^",2)	
			}else{
				set Hosp=""
			}
			set CPRCardRegMustFillIn=$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",19)
			set CPRCardRegJumpSeq=$piece($Get(^DHCCARDPATREGCONFIG(RowID)),"^",20)
			
			set Data=$ListBuild(RowID,SearchMasFlag,SetFocusElement,PatMasFlag,CardRefFlag,AccManageFlag,ParseTag,DefualtCoury,DefualtCouryDR,DefualtNation,DefualtNationDR,DefualtProvince,DefualtProvinceDR,DefualtCity,DefualtCityDR,CPRIsNotStructAddressFLag,CPRHospDR,Hosp,CPRCardRegMustFillIn,CPRCardRegJumpSeq)
			Set ^CacheTemp(repid,ind)=Data
	 		Set ind=ind+1
 		}
 		Set RowID=$Order(^DHCCARDPATREGCONFIG(RowID))
 	}
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod CardPatRegConfigQueryTClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardPatRegConfigQueryTExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CardPatRegConfigQueryTFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardPatRegConfigQueryTExecute ]
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

ClassMethod SaveByJson(RowId As %String, JsonStr As %String)
{
	s ^dhcInsertByJson=JsonStr
	s jsonObj={}
	s jsonObj=jsonObj.%FromJSON(JsonStr)
	s HospDr=""
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCCardPATRegConfig")
	s myCount = myobj.Properties.Count()
	k PLIST
	s myParList=""
	f i=1:1:myCount {
		s mypropobj=myobj.Properties.GetAt(i)
		s PropertyName=mypropobj.Name
		continue:jsonObj.%GetTypeOf(PropertyName)="unassigned" 
		s val=jsonObj.%Get(PropertyName)
		if (mypropobj.Name="CPRHospDR"){
			s HospDr=val
		}
		s dataType=mypropobj.Type
		if dataType="%Library.Date"{
			s val=..%ZDH(val)	
		}
		s sqlNum=mypropobj.SqlColumnNumber
		s PLIST(sqlNum)=val
	}
	if '$d(PLIST) Quit -1
	if RowId=""{
		&sql(select count(*) into :count from SQLUSER.DHC_CardPATRegConfig where CPR_Hosp_DR=:HospDr) 
		Q:count>0 "Repeat"
		&sql(insert into SQLUSER.DHC_CardPATRegConfig values :PLIST())
	}else{
		&sql(select count(*) into :count from SQLUSER.DHC_CardPATRegConfig where CPR_Hosp_DR=:HospDr and CPR_RowID<>:RowId) 
		Q:count>0 "Repeat"
		&sql(update SQLUSER.DHC_CardPATRegConfig values :PLIST() where CPR_RowID=:RowId)
	}
	Quit SQLCODE
}

/// w ##class(web.DHCBL.CARD.CardHardComManager).GetDataJson(13,^dhcGetCardTypeDataJson)
ClassMethod GetDataJson(RowId As %String, jsonFiledStr As %String)
{
	s ^dhcGetCardTypeDataJson=jsonFiledStr
	&sql(select * into :PLIST() from SQLUSER.DHC_CardPATRegConfig where CPR_RowID=:RowId)
	if SQLCODE'=0 Quit ""
	s jsonFiled=##class(%Library.DynamicObject).%FromJSON(jsonFiledStr)
	s jsonData={}
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCCardPATRegConfig")
	s myCount = myobj.Properties.Count()
	//k PLIST
	s myParList=""
	f i=1:1:myCount {
		s mypropobj=myobj.Properties.GetAt(i)
		s PropertyName=mypropobj.Name
		s dataType=mypropobj.Type
		continue:jsonFiled.%GetTypeOf(PropertyName)="unassigned" 
		s sqlNum=mypropobj.SqlColumnNumber
		continue:sqlNum=""
		s val=$g(PLIST(sqlNum))
		if dataType="%Library.Date"{
			s val=..%ZD(val)
		}
		
		s filedName=jsonFiled.%Get(PropertyName)
		do jsonData.%Set(filedName,val)
	}
	s jsonData.Country=""
	if jsonData.CountryId'=""{
		s jsonData.Country=$p($g(^CT("COU",jsonData.CountryId)),"^",2)	
	}
	s jsonData.Province=""
	if jsonData.ProvinceId'=""{
		s jsonData.Province=$p($g(^CT("PROV",jsonData.ProvinceId)),"^",2)	
	}
	s jsonData.City=""
	if jsonData.CityId'=""{
		s jsonData.City=$p($g(^CT("CIT",jsonData.CityId)),"^",2)	
	}
	s jsonData.Nation=""
	if jsonData.NationId'=""{
		s jsonData.Nation=$p($g(^CT("NAT",jsonData.NationId)),"^",2)	
	}
	s jsonData.CPRHospDR=""
	if jsonData.CPRHospDR'=""{
		s jsonData.Hosp=$p($g(^CT("HOSP",jsonData.CPRHospDR)),"^",2)	
	}
	
	Quit jsonData.%ToJSON()
}

/// w ##class(web.DHCBL.CARD.CardPATRegConfig).GetCardRegDOMCache(2)
ClassMethod GetCardRegDOMCache(HospId As %String) As %String
{
	Q $g(^DHCDocConfig("CardRegDOMCache",HospId))
}

}
