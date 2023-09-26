/// 名称: DHCMA.Util.IO.SyncHisSrv
/// 描述: 系统基础数据 提供接口服务
/// 编写者：zhufei
/// 编写日期: 2019-01-17
Class DHCMA.Util.IO.SyncHisSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      zhufei
/// CreatDate：    2019-01-17
/// Description:   查询用户字典
/// Table：        SS_User
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncHisSrv","GetSSUserDic","")
Query GetSSUserDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Password:%String,LocID:%String,CareProvID:%String,IsActive:%String")
{
}

ClassMethod GetSSUserDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildSSUserData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^SSU("SSUSR",xID))
			Quit:xID=""
			
			Do BuildSSUserData(xID)
		}
	}
	Quit $$$OK
 	
BuildSSUserData(xID)
	Set tmp=$g(^SSU("SSUSR",xID))
	Quit:tmp=""
	Set Code=$p(tmp,"^",1)
	Set Desc=$p(tmp,"^",2)
	Set Password=$p(tmp,"^",3)
	Set LocID=$p(tmp,"^",4)
	Set CareProvID=$p(tmp,"^",14)
	Set DateFrom=$p(tmp,"^",96)
	Set DateTo=$p(tmp,"^",97)
	Set IsActive=1
	Set:(DateFrom'="")&(DateFrom>+$h) IsActive=0
	Set:(DateTo'="")&(DateTo<+$h) IsActive=0
	
	set Data=$lb(xID,Code,Desc,Password,LocID,CareProvID,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetSSUserDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSSUserDicExecute ]
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

ClassMethod GetSSUserDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSSUserDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      zhufei
/// CreatDate：    2019-01-17
/// Description:   查询安全组字典
/// Table：        SS_Group
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncHisSrv","GetSSGroupDic","")
Query GetSSGroupDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetSSGroupDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildSSGroupData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^SSU("SSGRP",xID))
			Quit:xID=""
			
			Do BuildSSGroupData(xID)
		}
	}
	Quit $$$OK
 	
BuildSSGroupData(xID)
	Set tmp=$g(^SSU("SSGRP",xID))
	Quit:tmp=""
	Set Desc=$p(tmp,"^",1)
	Set IsActive=1
	
	set Data=$lb(xID,Desc,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetSSGroupDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSSGroupDicExecute ]
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

ClassMethod GetSSGroupDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSSGroupDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      zhufei
/// CreatDate：    2019-01-17
/// Description:   查询科室字典
/// Table：        CT_Loc
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncHisSrv","GetLocDic","")
Query GetLocDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Type:%String,HospID:%String,IsActive:%String")
{
}

ClassMethod GetLocDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildLocData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^CTLOC(xID))
			Quit:xID=""
			
			Do BuildLocData(xID)
		}
	}
	Quit $$$OK
 	
BuildLocData(xID)
	Set tmp=$g(^CTLOC(xID))
	Quit:tmp=""
	Set Code=$p(tmp,"^",1)
	Set Desc=$p(tmp,"^",2)
	Set Type=$p(tmp,"^",13)
	Set Type=$s(Type="E":"E",Type="W":"W",Type="O":"O",1:"")
	Set HospID=$p(tmp,"^",22)
	Set DateFrom=$p(tmp,"^",24)
	Set DateTo=$p(tmp,"^",25)
	Set IsActive=1
	Set:(DateFrom'="")&(DateFrom>+$h) IsActive=0
	Set:(DateTo'="")&(DateTo<+$h) IsActive=0
	
	set Data=$lb(xID,Code,Desc,Type,HospID,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetLocDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocDicExecute ]
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

ClassMethod GetLocDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      zhufei
/// CreatDate：    2019-01-17
/// Description:   查询医院字典
/// Table：        CT_Hospital
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncHisSrv","GetHospDic","")
Query GetHospDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String,DefHospDR:%String,DefHospCode:%String,DefHospDesc:%String,DefHospIsActive:%String")
{
}

ClassMethod GetHospDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildHospData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^CT("HOSP",xID))
			//Set xID=$o(^SSU("SSUSR",xID))
			Quit:xID=""
			
			Do BuildHospData(xID)
		}
	}
	Quit $$$OK
 	
BuildHospData(xID)
	Set tmp=$g(^CT("HOSP",xID))
	Quit:tmp=""
	Set Code=$p(tmp,"^",1)
	Set Desc=$p(tmp,"^",2)
	Set DateFrom=$p(tmp,"^",9)
	Set DateTo=$p(tmp,"^",10)
	Set IsActive=1
	Set:(DateFrom'="")&(DateFrom>+$h) IsActive=0
	Set:(DateTo'="")&(DateTo<+$h) IsActive=0
	
	//默认医院
	Set (DefHospDR,DefHospCode,DefHospDesc,DefHospIsActive)=""
	Set DefHospDR=$p($g(^CT("HOSP",xID)),"^",41)				//默认医院	20210719 yankai
	If DefHospDR'="" {
		Set DefHospCode=$p($g(^CT("HOSP",DefHospDR)),"^",1)		//默认医院信息	
		Set DefHospDesc=$p($g(^CT("HOSP",DefHospDR)),"^",2)
		Set DefDateFrom=$p($g(^CT("HOSP",DefHospDR)),"^",9)
		Set DefDateTo=$p($g(^CT("HOSP",DefHospDR)),"^",10)
		Set DefHospIsActive=1
		Set:(DefDateFrom'="")&(DefDateFrom>+$h) DefHospIsActive=0
		Set:(DefDateTo'="")&(DefDateTo<+$h) DefHospIsActive=0
	}Else{														//如果默认医院为空，则显示空
		Set DefHospDR=""		//xID
		Set DefHospCode=""		//Code
		Set DefHospDesc=""		//Desc
		Set DefHospIsActive=""	//IsActive										
	}
	
	set Data=$lb(xID,Code,Desc,IsActive,DefHospDR,DefHospCode,DefHospDesc,DefHospIsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetHospDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospDicExecute ]
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

ClassMethod GetHospDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      zhufei
/// CreatDate：    2019-01-17
/// Description:   查询医护人员字典
/// Table：        CT_CareProv
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncHisSrv","GetCareProvDic","")
Query GetCareProvDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,TypeCode:%String,IsActive:%String")
{
}

ClassMethod GetCareProvDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildCareProvData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^CTPCP(xID))
			Quit:xID=""
			
			Do BuildCareProvData(xID)
		}
	}
	Quit $$$OK
 	
BuildCareProvData(xID)
	Set tmp=$g(^CTPCP(xID,1))
	Quit:tmp=""
	Set Code=$p(tmp,"^",1)
	Set Desc=$p(tmp,"^",2)
	Set TypeDr=$p(tmp,"^",4)
	Set TypeCode=$p($g(^CT("CPT",+TypeDr)),"^",4)
	Set TypeCode=$s(TypeCode="DOCTOR":"D",TypeCode="NURSE":"N",1:"")
	Set IsActive=$p(tmp,"^",9)
	Set IsActive=$s(IsActive["Y":1,1:0)
	
	set Data=$lb(xID,Code,Desc,TypeCode,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetCareProvDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCareProvDicExecute ]
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

ClassMethod GetCareProvDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCareProvDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      zhufei
/// CreatDate：    2019-01-17
/// Description:   查询性别字典
/// Table：        CT_Sex
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncHisSrv","GetCTSexDic","")
Query GetCTSexDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetCTSexDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildCTSexData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^CT("SEX",xID))
			Quit:xID=""
			
			Do BuildCTSexData(xID)
		}
	}
	Quit $$$OK
 	
BuildCTSexData(xID)
	Set tmp=$g(^CT("SEX",xID))
	Quit:tmp=""
	Set Code=$p(tmp,"^",1)
	Set Desc=$p(tmp,"^",2)
	Set DateFrom=$p(tmp,"^",4)
	Set DateTo=$p(tmp,"^",5)
	Set IsActive=1
	Set:(DateFrom'="")&(DateFrom>+$h) IsActive=0
	Set:(DateTo'="")&(DateTo<+$h) IsActive=0
	
	set Data=$lb(xID,Code,Desc,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetCTSexDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTSexDicExecute ]
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

ClassMethod GetCTSexDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTSexDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      zhufei
/// CreatDate：    2019-01-17
/// Description:   查询民族字典
/// Table：        CT_Nation
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncHisSrv","GetCTNationDic","")
Query GetCTNationDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetCTNationDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildCTNationData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^CT("NAT",xID))
			Quit:xID=""
			
			Do BuildCTNationData(xID)
		}
	}
	Quit $$$OK
 	
BuildCTNationData(xID)
	Set tmp=$g(^CT("NAT",xID))
	Quit:tmp=""
	Set Code=$p(tmp,"^",1)
	Set Desc=$p(tmp,"^",2)
	Set IsActive=1
	
	set Data=$lb(xID,Code,Desc,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetCTNationDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTNationDicExecute ]
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

ClassMethod GetCTNationDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTNationDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      zhufei
/// CreatDate：    2019-01-17
/// Description:   查询国籍字典
/// Table：        CT_Country
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncHisSrv","GetCTCountryDic","")
Query GetCTCountryDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetCTCountryDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildCTCountryData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^CT("COU",xID))
			Quit:xID=""
			
			Do BuildCTCountryData(xID)
		}
	}
	Quit $$$OK
 	
BuildCTCountryData(xID)
	Set tmp=$g(^CT("COU",xID))
	Quit:tmp=""
	Set Code=$p(tmp,"^",1)
	Set Desc=$p(tmp,"^",2)
	Set IsActive=$p(tmp,"^",3)
	Set IsActive=$s(IsActive="Y":1,1:0)
	Set DateFrom=$p(tmp,"^",4)
	Set DateTo=$p(tmp,"^",5)
	Set:(DateFrom'="")&(DateFrom>+$h) IsActive=0
	Set:(DateTo'="")&(DateTo<+$h) IsActive=0
	
	set Data=$lb(xID,Code,Desc,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetCTCountryDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTCountryDicExecute ]
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

ClassMethod GetCTCountryDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTCountryDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      zhufei
/// CreatDate：    2019-01-17
/// Description:   查询婚姻状况字典
/// Table：        CT_Marital
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncHisSrv","GetCTMaritalDic","")
Query GetCTMaritalDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetCTMaritalDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildCTMaritalData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^CT("MAR",xID))
			Quit:xID=""
			
			Do BuildCTMaritalData(xID)
		}
	}
	Quit $$$OK
 	
BuildCTMaritalData(xID)
	Set tmp=$g(^CT("MAR",xID))
	Quit:tmp=""
	Set Code=$p(tmp,"^",1)
	Set Desc=$p(tmp,"^",2)
	Set DateFrom=$p(tmp,"^",4)
	Set DateTo=$p(tmp,"^",5)
	Set IsActive=1
	Set:(DateFrom'="")&(DateFrom>+$h) IsActive=0
	Set:(DateTo'="")&(DateTo<+$h) IsActive=0
	
	set Data=$lb(xID,Code,Desc,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetCTMaritalDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTMaritalDicExecute ]
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

ClassMethod GetCTMaritalDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTMaritalDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      zhufei
/// CreatDate：    2019-01-17
/// Description:   查询职业字典
/// Table：        CT_Occupation
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncHisSrv","GetCTOccupationDic","")
Query GetCTOccupationDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetCTOccupationDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildCTOccupationData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^CT("OCC",xID))
			Quit:xID=""
			
			Do BuildCTOccupationData(xID)
		}
	}
	Quit $$$OK
 	
BuildCTOccupationData(xID)
	Set tmp=$g(^CT("OCC",xID))
	Quit:tmp=""
	Set Code=$p(tmp,"^",1)
	Set Desc=$p(tmp,"^",2)
	Set DateFrom=$p(tmp,"^",3)
	Set DateTo=$p(tmp,"^",4)
	Set IsActive=1
	Set:(DateFrom'="")&(DateFrom>+$h) IsActive=0
	Set:(DateTo'="")&(DateTo<+$h) IsActive=0
	
	set Data=$lb(xID,Code,Desc,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetCTOccupationDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTOccupationDicExecute ]
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

ClassMethod GetCTOccupationDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTOccupationDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      zhufei
/// CreatDate：    2019-01-17
/// Description:   查询医疗付费方式字典
/// Table：        CT_SocialStatus
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncHisSrv","GetCTSocialStatusDic","")
Query GetCTSocialStatusDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetCTSocialStatusDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildCTSocialStatusData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^CT("SS",xID))
			Quit:xID=""
			
			Do BuildCTSocialStatusData(xID)
		}
	}
	Quit $$$OK
 	
BuildCTSocialStatusData(xID)
	Set tmp=$g(^CT("SS",xID))
	Quit:tmp=""
	Set Code=$p(tmp,"^",1)
	Set Desc=$p(tmp,"^",2)
	Set IsActive=1
	
	set Data=$lb(xID,Code,Desc,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetCTSocialStatusDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTSocialStatusDicExecute ]
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

ClassMethod GetCTSocialStatusDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTSocialStatusDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      pylian
/// CreatDate：    2020-05-15
/// Description:   查询证件类型
/// Table：       
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncHisSrv","GetPACCardTypeDic","")
Query GetPACCardTypeDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetPACCardTypeDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildCardTypeDicData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^PAC("CARD",xID))
			Quit:xID=""
			
			Do BuildCardTypeDicData(xID)
		}
	}
	Quit $$$OK
 	
BuildCardTypeDicData(xID)

	Set tmp=$g(^PAC("CARD",xID))
	Quit:tmp=""
	Set Code=$p(tmp,"^",1)
	Set Desc=$p(tmp,"^",2)
	Set DateFrom=$p(tmp,"^",3)
	Set DateTo=$p(tmp,"^",4)
	Set IsActive=1
	Set:(DateFrom'="")&(DateFrom>+$h) IsActive=0
	Set:(DateTo'="")&(DateTo<+$h) IsActive=0
	
	set Data=$lb(xID,Code,Desc,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetPACCardTypeDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPACCardTypeDicExecute ]
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

ClassMethod GetPACCardTypeDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPACCardTypeDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      pylian
/// CreatDate：    2020-05-15
/// Description:   查询关系
/// Table：        CT_Relation
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncHisSrv","GetCTRelationDic","")
Query GetCTRelationDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetCTRelationDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildCTRelationData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^CT("RLT",xID))
			Quit:xID=""
			
			Do BuildCTRelationData(xID)
		}
	}
	Quit $$$OK
 	
BuildCTRelationData(xID)
	Set tmp=$g(^CT("RLT",xID))
	Quit:tmp=""
	Set Code=$p(tmp,"^",1)
	Set Desc=$p(tmp,"^",2)
	Set DateFrom=$p(tmp,"^",3)
	Set DateTo=$p(tmp,"^",4)
	Set IsActive=1
	Set:(DateFrom'="")&(DateFrom>+$h) IsActive=0
	Set:(DateTo'="")&(DateTo<+$h) IsActive=0
	
	set Data=$lb(xID,Code,Desc,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetCTRelationDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTRelationDicExecute ]
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

ClassMethod GetCTRelationDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTRelationDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      pylian
/// CreatDate：    2020-05-15
/// Description:   查询学历
/// Table：        CT_Education
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncHisSrv","GetCTEducationDic","")
Query GetCTEducationDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetCTEducationDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildCTEducationData(aID)
	} Else {
		Set xID=0
		For {
			Set xID=$o(^CT("EDU",xID))
			Quit:xID=""
			
			Do BuildCTEducationData(xID)
		}
	}
	Quit $$$OK
 	
BuildCTEducationData(xID)
	Set tmp=$g(^CT("EDU",xID))
	Quit:tmp=""
	Set Code=$p(tmp,"^",1)
	Set Desc=$p(tmp,"^",2)
	Set IsActive=1
	
	set Data=$lb(xID,Code,Desc,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetCTEducationDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTEducationDicExecute ]
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

ClassMethod GetCTEducationDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTEducationDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
