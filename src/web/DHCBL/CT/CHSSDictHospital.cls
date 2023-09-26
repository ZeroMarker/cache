Class web.DHCBL.CT.CHSSDictHospital Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2015-10-8
/// Description:查询 社区类别
/// Input:desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CHSSDictHospital","GetDataForCmb1","","410000162770")
Query GetDataForCmb1(desc As %String, communityid As %String) As %Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, desc As %String, communityid As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1

		s Id = $o(^CHSS.DictHospitalI("CommunityCodeIndex",communityid,0))
		s CommunityType = $listget($g(^CHSS.DictHospitalD(Id)),5)
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s RowId=0
		for
		{
			s RowId=$o(^CHSS.DictCommunityTypeD(RowId)) q:RowId=""
			s Description=$listget($g(^CHSS.DictCommunityTypeD(RowId)),4)
			if (CommunityType="市卫生局") d
			else  if (CommunityType="县（区）卫生局") continue:((Description'="乡镇卫生院")&&(Description'="社区卫生服务中心"))
			else  continue:((Description'="社区卫生服务站")&&(Description'="村卫生所"))
			s DescriptionU=$ZCONVERT(Description,"U")
			i (DescriptionU[desc)
			{
				d OutputRowCmb1
			}
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb1
    set Data=$lb(RowId,Description)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:高姗姗
/// CreatDate:2015-10-13
/// Description:查询 上级医疗机构
/// Input:desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CHSSDictHospital","GetDataForCmb2","","410000162770")
Query GetDataForCmb2(desc As %String, communityid As %String) As %Query(ROWSPEC = "CommunityCode:%String,CommunityName:%String")
{
}

ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, desc As %String, communityid As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s RowId=0
		for
		{
			s RowId=$o(^CHSS.DictHospitalD(RowId)) q:RowId=""
			s CommunityCode=$listget($g(^CHSS.DictHospitalD(RowId)),2)
			s CommunityName=$listget($g(^CHSS.DictHospitalD(RowId)),4)
			s CommunityNameU=$ZCONVERT(CommunityName,"U")
			
			i (CommunityCode=communityid)&(CommunityNameU[desc)
			{
				d OutputRowCmb2
			}
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb2
    set Data=$lb(CommunityCode,CommunityName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:高姗姗
/// CreatDate:2015-10-13
/// Description:查询 省
/// Input:desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CHSSDictHospital","GetProvinceForCmb","")
Query GetProvinceForCmb(desc As %String) As %Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetProvinceForCmbExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s RowId=0
		for
		{
			s RowId=$o(^CHSS.DictProvinceD(RowId)) q:RowId=""
			s Description=$listget($g(^CHSS.DictProvinceD(RowId)),4)

				s DescriptionU=$ZCONVERT(Description,"U")
				i (DescriptionU[desc)
				{
					d OutputRowCmb3
				}
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb3
    set Data=$lb(RowId,Description)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetProvinceForCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetProvinceForCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:高姗姗
/// CreatDate:2015-10-14
/// Description:查询 市 县 乡 村
/// Input:desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CHSSDictHospital","GetRecordForCmb","")
Query GetRecordForCmb(TableName, RowIdParref, communityid) As %Query(ROWSPEC = "RowId:%String,Code:%String,Description:%String")
{
}

ClassMethod GetRecordForCmbExecute(ByRef qHandle As %Binary, TableName, RowIdParref, communityid) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	s sqlStr = "SELECT RowId,Code,Description FROM CHSS."_TableName_" where RowIdParref = "_RowIdParref
	;w "a"_CommunityType_"^"_TableName_"b",!
	
	if (communityid'=""){
		s Id = $o(^CHSS.DictHospitalI("CommunityCodeIndex",communityid,0))
		s CommunityType = $listget($g(^CHSS.DictHospitalD(Id)),5)
		s tempStr=..getCommunityDetail(communityid)
		;w tempStr,!
		
		i (CommunityType="县（区）卫生局")&&(TableName="DictSection") d
		..s sectionrowid=$p(tempStr,"^",3)
		..s sqlStr = "SELECT RowId,Code,Description FROM CHSS."_TableName_" where RowIdParref = "_RowIdParref_" and rowid="_sectionrowid
		..;w sqlStr,!
		i ((CommunityType="社区卫生服务中心")||(CommunityType="乡镇卫生院"))&&(TableName="DictSection") d
		..s sectionrowid=$p(tempStr,"^",3)
		..s sqlStr = "SELECT RowId,Code,Description FROM CHSS."_TableName_" where RowIdParref = "_RowIdParref_" and rowid="_sectionrowid
		..;w sqlStr,!
		i ((CommunityType="社区卫生服务中心")||(CommunityType="乡镇卫生院"))&&(TableName="DictStreet") d
		..s streetrowid=$p(tempStr,"^",4)
		..s sqlStr = "SELECT RowId,Code,Description FROM CHSS."_TableName_" where RowIdParref = "_RowIdParref_" and rowid="_streetrowid
    	..;w sqlStr,!
	}
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()

    While(result.Next()){
		s RowId = result.Data("RowId")
		s Code = result.Data("Code")
		s Description = result.Data("Description")
		d OutputRowCmb4
	}
	q $$$OK
OutputRowCmb4
    set Data=$lb(RowId,Code,Description)
    s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
    quit
}

ClassMethod GetRecordForCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRecordForCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//返回省市县的Id

ClassMethod getCommunityDetail(communitycode)
{
    s tmp=""
	s result = ##class(%Library.ResultSet).%New()

	s sqlStr = "SELECT RowId,CommunityName,SpellCode,UpCommunityCode,CommunityCodePrex,CommunityType,HospitalDR,RecordDR FROM CHSS.DictHospital where Communitycode ='"_communitycode_"'"
    
    ;w sqlStr,!

	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s Rowid = result.Data("RowId")
	s CommunityName = result.Data("CommunityName")
	s SepllCode = result.Data("SpellCode")
	s UpCommunityCode = result.Data("UpCommunityCode")
	s CommunityCodePrex = result.Data("CommunityCodePrex")
	s CommunityType = result.Data("CommunityType")
	s HospitalDR = result.Data("HospitalDR")
	s RecordDR = result.Data("RecordDR")
    s HospitalName = ""
    s ProvinceName = ""
    s CityName = ""
    s SectionName = ""
    s StreetName = ""
    s VillageName = ""
    s UpCommunityName = ""
    ;b
    i CommunityType = "省卫生厅" d
	.s ProvinceName =RecordDR
	..
    i CommunityType = "市卫生局" d
	.s tempHospital = ##class(CHSS.DictCity).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s CityName = RecordDR
	..s ProvinceName=tempHospital.RowIdParref.%Id()
    e  i (CommunityType = "县（区）卫生局") d
	.s tempHospital = ##class(CHSS.DictSection).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s SectionName = RecordDR
	..s tempSection=tempHospital.RowIdParref
	..i tempSection'="" d
	...s CityName=tempSection.%Id()
	
	...i tempSection.RowIdParref'="" d
	....s ProvinceName=tempSection.RowIdParref.%Id()
	e  i ((CommunityType = "乡镇卫生院")||(CommunityType = "社区卫生服务中心")) d
	.s tempHospital = ##class(CHSS.DictStreet).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s StreetName = RecordDR
	..
	..s SectionId=tempHospital.RowIdParref.%Id()
	..i SectionId '= "" d
	...s tempSection=##class(CHSS.DictSection).%OpenId(SectionId)
	...s SectionName=SectionId
	...
	...s CityId=tempSection.RowIdParref.%Id()
	...i CityId '= "" d
	....s tempCity=##class(CHSS.DictCity).%OpenId(CityId)
	....s CityName=CityId
	....
	....s ProvinceId=tempCity.RowIdParref.%Id()
	....s tempProvince=##class(CHSS.DictProvince).%OpenId(ProvinceId)
	....s ProvinceName=ProvinceId
	e  i ((CommunityType = "村卫生所")||(CommunityType = "社区卫生服务站")) d
	.s VillageName=RecordDR
	.s tempHospital = ##class(CHSS.DictVillage).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s HospitalName = tempHospital.Description
	..s streetId = tempHospital.RowIdParref.%Id()
	..s tempStreet=##class(CHSS.DictStreet).%OpenId(streetId)
	..s StreetName=streetId
	..
	..s SectionId=tempStreet.RowIdParref.%Id()
	..s tempSection=##class(CHSS.DictSection).%OpenId(SectionId)
	..s SectionName=SectionId
	..
	..s CityId=tempSection.RowIdParref.%Id()
	..s tempCity=##class(CHSS.DictCity).%OpenId(CityId)
	..s CityName=CityId
	..
	..s ProvinceId=tempCity.RowIdParref.%Id()
	..s tempProvince=##class(CHSS.DictProvince).%OpenId(ProvinceId)
	..s ProvinceName=ProvinceId
	s tmp=ProvinceName_"^"_CityName_"^"_SectionName_"^"_StreetName_"^"_VillageName
	}
	d result.Close()
    k json
	q tmp
}

/// Creator:高姗姗
/// CreatDate:2015-10-15
/// Description:获取 当前行政地区
/// Input:desc
/// Other:w ##class("web.DHCBL.CT.CHSSDictHospital").GetCurrentCommunity("410000162770")
ClassMethod GetCurrentCommunity(CommunityCode As %String) As %String
{
	s Id = $o(^CHSS.DictHospitalI("CommunityCodeIndex",CommunityCode,0))
	s CommunityType = $listget($g(^CHSS.DictHospitalD(Id)),5)
	s result=##class(%Library.ResultSet).%New()
	s sqlStr = ""
	i CommunityType = "村卫生所" d
	.s sqlStr = " select RowId as VillageDR,Code as VillageCode,Description as VillageName,RowIdParref as StreetDR,RowIdParref->Code as StreetCode, RowIdParref->Description as StreetName,RowIdParref->RowIdParref as SectionDR,RowIdParref->RowIdParref->Code as SectionCode,RowIdParref->RowIdParref->Description as SectionName,RowIdParref->RowIdParref->RowIdParref as CityDR,RowIdParref->RowIdParref->RowIdParref->Code as CityCode,RowIdParref->RowIdParref->RowIdParref->Description as CityName,RowIdParref->RowIdParref->RowIdParref->RowIdParref as ProvinceDR,RowIdParref->RowIdParref->RowIdParref->RowIdParref->Code as ProvinceCode,RowIdParref->RowIdParref->RowIdParref->RowIdParref->Description as ProvinceName from CHSS.DictVillage where RowId in ( select RecordDR from CHSS.DictHospital where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	e  i CommunityType = "社区卫生服务中心" d
	.s sqlStr = " select RowId as StreetDR,Code as StreetCode,Description as StreetName,RowIdParref as SectionDR,RowIdParref->Code as SectionCode,RowIdParref->Description as SectionName,RowIdParref->RowIdParref as CityDR,RowIdParref->RowIdParref->Code as CityCode,RowIdParref->RowIdParref->Description as CityName,RowIdParref->RowIdParref->RowIdParref as ProvinceDR,RowIdParref->RowIdParref->RowIdParref->Code as ProvinceCode,RowIdParref->RowIdParref->RowIdParref->Description as ProvinceName from CHSS.DictStreet where RowId in ( select RecordDR from CHSS.DictHospital where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	e  i CommunityType = "社区卫生服务站" d
	.s sqlStr = " select RowId as VillageDR,Code as VillageCode,Description as VillageName,RowIdParref as StreetDR,RowIdParref->Code as StreetCode, RowIdParref->Description as StreetName,RowIdParref->RowIdParref as SectionDR,RowIdParref->RowIdParref->Code as SectionCode,RowIdParref->RowIdParref->Description as SectionName,RowIdParref->RowIdParref->RowIdParref as CityDR,RowIdParref->RowIdParref->RowIdParref->Code as CityCode,RowIdParref->RowIdParref->RowIdParref->Description as CityName,RowIdParref->RowIdParref->RowIdParref->RowIdParref as ProvinceDR,RowIdParref->RowIdParref->RowIdParref->RowIdParref->Code as ProvinceCode,RowIdParref->RowIdParref->RowIdParref->RowIdParref->Description as ProvinceName from CHSS.DictVillage where RowId in ( select RecordDR from CHSS.DictHospital where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	e  i CommunityType = "乡镇卫生院" d
	.s sqlStr = " select RowId as StreetDR,Code as StreetCode,Description as StreetName,RowIdParref as SectionDR,RowIdParref->Code as SectionCode,RowIdParref->Description as SectionName,RowIdParref->RowIdParref as CityDR,RowIdParref->RowIdParref->Code as CityCode,RowIdParref->RowIdParref->Description as CityName,RowIdParref->RowIdParref->RowIdParref as ProvinceDR,RowIdParref->RowIdParref->RowIdParref->Code as ProvinceCode,RowIdParref->RowIdParref->RowIdParref->Description as ProvinceName from CHSS.DictStreet where RowId in ( select RecordDR from CHSS.DictHospital where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	e  i CommunityType = "县（区）卫生局" d
	.s sqlStr =" select null as StreetDR,null as StreetCode, null as StreetName, RowId as SectionDR, Code as SectionCode,Description as SectionName,RowIdParref as CityDR, RowIdParref->Code as CityCode,RowIdParref->Description as CityName,RowIdParref->RowIdParref as ProvinceDR,RowIdParref->RowIdParref->Code as ProvinceCode,RowIdParref->RowIdParref->Description as ProvinceName "
	.s sqlStr =sqlStr_" from CHSS.DictSection where RowId in ( select RecordDR from CHSS.DictHospital "
	.s sqlStr =sqlStr_" where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	e  i CommunityType = "市卫生局" d
	.s sqlStr =" select null as StreetDR,null as StreetCode, null as StreetName, null as SectionDR, null as SectionCode,null as SectionName,RowId as CityDR, Code as CityCode,Description as CityName,RowIdParref as ProvinceDR,RowIdParref->Code as ProvinceCode,RowIdParref->Description as ProvinceName "
	.s sqlStr =sqlStr_" from CHSS.DictCity where RowId in ( select RecordDR from CHSS.DictHospital "
	.s sqlStr =sqlStr_" where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	e  i CommunityType = "省卫生厅" d
	.s sqlStr =" select null as StreetDR,null as StreetCode,null as StreetName,null as SectionDR,null as SectionCode,null as SectionName,null as CityDR, "
	.s sqlStr =sqlStr_" null as CityCode,null as CityName,RowId as ProvinceDR,Code as ProvinceCode,Description as ProvinceName from CHSS.DictProvince where RowId in ( select RecordDR from CHSS.DictHospital "
	.s sqlStr =sqlStr_" where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
    
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s str=""
    While(result.Next()){
		s VillageDR = ""
		s VillageName = ""
		if (CommunityType="村卫生所")
		{
			s VillageDR = result.Data("VillageDR")
			s VillageName = result.Data("VillageName")	
		}
		elseif (CommunityType="社区卫生服务站")
		{
			s VillageDR = result.Data("VillageDR")
			s VillageName = result.Data("VillageName")	
		}
		s StreetDR = result.Data("StreetDR")
		s SectionDR = result.Data("SectionDR")
		s CityDR = result.Data("CityDR")
		s ProvinceDR = result.Data("ProvinceDR")
	
		s StreetName = result.Data("StreetName")
		s SectionName = result.Data("SectionName")
		s CityName = result.Data("CityName")
		s ProvinceName = result.Data("ProvinceName")
		
		s str="{ProvinceName:'"_ProvinceName_"',CityName:'"_CityName_"',SectionName:'"_SectionName_"',StreetName:'"_StreetName_"',VillageName:'"_VillageName_"',ProvinceDR:'"_ProvinceDR_"',CityDR:'"_CityDR_"',SectionDR:'"_SectionDR_"',StreetDR:'"_StreetDR_"',VillageDR:'"_VillageDR_"'}"    
		//s str="{""ProvinceName"":"""_ProvinceName_""",""CityName"":"""_CityName_""",""SectionName"":"""_SectionName_""",""StreetName"":"""_StreetName_""",""VillageName"":"""_VillageName_""",""ProvinceDR"":"""_ProvinceDR_""",""CityDR"":"""_CityDR_""",""SectionDR"":"""_SectionDR_""",""StreetDR"":"""_StreetDR_""",""VillageDR"":"""_VillageDR_"""}"   
		//s str="{success:true,data:["_str_"]}"  
	}
	q str
}

/// Creator：高姗姗
/// CreatDate: 2015-10-19
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	
	s re=##class(web.DHCBL.CT.CTHospital).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		Ts
		s pobj = ##class(User.CTHospital).%OpenId(id)
		s RowId = $o(^CHSS.DictHospitalI("HospitalIndex",id,0))
		s cobj = ##class(CHSS.DictHospital).%OpenId(RowId)
		s eobj = ##class(web.Entity.CT.CHSSDictHospital).%New()
		
		s eobj.RowId=RowId
		s eobj.HOSPCode = pobj.HOSPCode
		s eobj.HOSPDesc = pobj.HOSPDesc
		s eobj.HOSPDateFrom=pobj.HOSPDateFrom
   		s eobj.HOSPDateTo=pobj.HOSPDateTo
    	s eobj.HOSPMandatoryRefHospital=pobj.HOSPMandatoryRefHospital
    	s eobj.CommunityCode=cobj.CommunityCode
    	s eobj.CommunityName=cobj.CommunityName
    	s eobj.UpCommunityCode=cobj.UpCommunityCode
    	s eobj.CommunityType=cobj.CommunityType
    	s eobj.HospitalDR=cobj.HospitalDR.%Id()
   	 	s eobj.RecordDR=cobj.RecordDR

		s sc=##class(User.CTHospital).%DeleteId(id)
		s scc=##class(CHSS.DictHospital).%DeleteId(RowId)
		if $$$ISOK(scc)
		{
			tc
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Hospital","User.CTHospital","医院",id,eobj.HOSPDesc,"D",eobj)
			s result = "{success:'true',info:'删除成功！'}"
		}
		else
		{
			tro
			s result = "{success:'false',info:'"_$zconvert(scc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医院","web.DHCBL.CT.CHSSDictHospital","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(scc,"O","JS")
		}
	}
	
	q result
}

/// Function:双击时显示弹出窗口的信息
/// CreateDate:2015-10-15
/// Other:w ##class("web.DHCBL.CT.CHSSDictHospital").OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.CTHospital).%OpenId(id)
	s RowId = $o(^CHSS.DictHospitalI("HospitalIndex",id,0))
	s cobj = ##class(CHSS.DictHospital).%OpenId(RowId)
	s eobj = ##class(web.Entity.CT.CHSSDictHospital).%New()
	s eobj.RowId=RowId
	s eobj.HOSPCode = pobj.HOSPCode
	s eobj.HOSPDesc = pobj.HOSPDesc
	;s:pobj.HOSPDateFrom'="" eobj.HOSPDateFrom=$zd(pobj.HOSPDateFrom)
	;s:pobj.HOSPDateTo'="" eobj.HOSPDateTo=$zd(pobj.HOSPDateTo)
	s:pobj.HOSPDateFrom'="" eobj.HOSPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.HOSPDateFrom)
    s:pobj.HOSPDateTo'="" eobj.HOSPDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.HOSPDateTo)
    s:pobj.HOSPMandatoryRefHospital="Y" eobj.HOSPMandatoryRefHospital="true"
    s eobj.CommunityCode=cobj.CommunityCode
    s eobj.CommunityName=cobj.CommunityName
    s eobj.UpCommunityCode=cobj.UpCommunityCode
    s eobj.CommunityType=cobj.CommunityType
    s eobj.HospitalDR=cobj.HospitalDR.%Id()
    //s eobj.RecordDR=cobj.RecordDR
    s RecordDR=$listget($g(^CHSS.DictHospitalD(RowId)),7)
    if (RecordDR=$c(0)) {s RecordDR=""} 
    s eobj.RecordDR = RecordDR
	
	s HospitalName = ""
    s ProvinceName = ""
    s CityName = ""
    s SectionName = ""
    s StreetName = ""
    s UpCommunityName = ""
    if (eobj.RecordDR'=""){
    	i eobj.CommunityType = "省卫生厅" d
		.s tempHospital = ##class(CHSS.DictProvince).%OpenId(eobj.RecordDR)
		.i tempHospital '= "" d
		..s HospitalName = tempHospital.Description
		..
   		 i eobj.CommunityType = "市卫生局" d
		.s tempHospital = ##class(CHSS.DictCity).%OpenId(eobj.RecordDR)
		.i tempHospital '= "" d
		..s HospitalName = tempHospital.Description
		..s ProvinceId=tempHospital.RowIdParref.%Id()
		..s tempProvince=##class(CHSS.DictProvince).%OpenId(ProvinceId)
		..s ProvinceName=tempProvince.Description
		.s HospitalName=HospitalName
		e  i (eobj.CommunityType = "县（区）卫生局") d
		.s tempHospital = ##class(CHSS.DictSection).%OpenId(eobj.RecordDR)
		.i tempHospital '= "" d
		..s HospitalName = tempHospital.Description
		..s tempSection=tempHospital.RowIdParref
		..i tempSection'="" d
		...s CityName=tempSection.Description
		...i tempSection.RowIdParref'="" d
		....s ProvinceName=tempSection.RowIdParref.Description
		.s HospitalName=HospitalName
		.
		e  i ((eobj.CommunityType = "乡镇卫生院")||(eobj.CommunityType = "社区卫生服务中心")) d
		.s tempHospital = ##class(CHSS.DictStreet).%OpenId(eobj.RecordDR)
		.i tempHospital '= "" d
		..s HospitalName = tempHospital.Description
		..
		..s SectionId=tempHospital.RowIdParref.%Id()
		..i SectionId '= "" d
		...s tempSection=##class(CHSS.DictSection).%OpenId(SectionId)
		...s SectionName=tempSection.Description
		...
		...s CityId=tempSection.RowIdParref.%Id()
		...i CityId '= "" d
		....s tempCity=##class(CHSS.DictCity).%OpenId(CityId)
		....s CityName=tempCity.Description
		....
		....s ProvinceId=tempCity.RowIdParref.%Id()
		....s tempProvince=##class(CHSS.DictProvince).%OpenId(ProvinceId)
		....s ProvinceName=tempProvince.Description
		.s HospitalName=SectionName_HospitalName
		e  i ((eobj.CommunityType = "村卫生所")||(eobj.CommunityType = "社区卫生服务站")) d
		.s tempHospital = ##class(CHSS.DictVillage).%OpenId(eobj.RecordDR)
		.i tempHospital '= "" d
		..s HospitalName = tempHospital.Description
		..s streetId = tempHospital.RowIdParref.%Id()
		..s tempStreet=##class(CHSS.DictStreet).%OpenId(streetId)
		..s StreetName=tempStreet.Description
		..
		..s SectionId=tempStreet.RowIdParref.%Id()
		..s tempSection=##class(CHSS.DictSection).%OpenId(SectionId)
		..s SectionName=tempSection.Description
		..
		..s CityId=tempSection.RowIdParref.%Id()
		..s tempCity=##class(CHSS.DictCity).%OpenId(CityId)
		..s CityName=tempCity.Description
		..
		..s ProvinceId=tempCity.RowIdParref.%Id()
		..s tempProvince=##class(CHSS.DictProvince).%OpenId(ProvinceId)
		..s ProvinceName=tempProvince.Description
	
		.s HospitalName=StreetName_HospitalName_UpCommunityName
		.i HospitalName=""  s HospitalName =""
	}
	s eobj.Record=HospitalName
	
    d cobj.%Close()
    d pobj.%Close()
	s str = eobj.JsonS()
	s str = "{data:["_str_"]}"
	q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 蔡昊哲 
/// CreateDate:2012-12-13
/// Table:CT_Hospital   
/// Other:w ##class("web.DHCBL.CT.CHSSDictHospital").FormValidate("6732","410000001234","tetete")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT("HOSP",0,"Code",code))
	s:desc'="" flagd=$d(^CT("HOSP",0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT("HOSP",0,"Code",code,0))
		s:desc'="" idd=$o(^CT("HOSP",0,"Desc",desc,0))
		if (desc="")
		{
			if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		elseif (code="")
		{
			if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator：高姗姗
/// CreatDate: 2015-10-15
/// Description：保存修改内容
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.CT.CHSSDictHospital) As %String
{
	
	s result = ""
	if $IsObject(eobj)
	{
		;s:eobj.HOSPDateFrom'="" eobj.HOSPDateFrom=$zdh(eobj.HOSPDateFrom,15)  //转换日期
		;s:eobj.HOSPDateTo'="" eobj.HOSPDateTo=$zdh(eobj.HOSPDateTo,15)      //转换日期
		s:eobj.HOSPDateFrom'="" eobj.HOSPDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HOSPDateFrom)  //转换日期
		s:eobj.HOSPDateTo'="" eobj.HOSPDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HOSPDateTo)     //转换日期
		s flag=..FormValidate(eobj.HospitalDR,eobj.HOSPCode,eobj.HOSPDesc)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
		}
		else
		{
			if (eobj.HospitalDR=""){
				s cobj=##class(CHSS.DictHospital).%New()
				s obj=##class(User.CTHospital).%New()
			}else{
				s cobj=##class(CHSS.DictHospital).%OpenId(eobj.RowId)
				s obj=##class(User.CTHospital).%OpenId(eobj.HospitalDR)

				s bobj = ##class(web.Entity.CT.CHSSDictHospital).%New()
				s bobj.RowId = eobj.RowId
				s bobj.HOSPCode = obj.HOSPCode
				s bobj.HOSPDesc = obj.HOSPDesc
				s bobj.HOSPDateFrom= obj.HOSPDateFrom
				s bobj.HOSPDateTo = obj.HOSPDateTo
				s bobj.HOSPMandatoryRefHospital = obj.HOSPMandatoryRefHospital
				s bobj.CommunityCode=cobj.CommunityCode
				s bobj.CommunityName=cobj.CommunityName
				s bobj.UpCommunityCode=cobj.UpCommunityCode
				s bobj.CommunityType=cobj.CommunityType
				s bobj.HospitalDR=cobj.HospitalDR
				s bobj.RecordDR=cobj.RecordDR	
			}
	
			s obj.HOSPCode = eobj.HOSPCode                      
			s obj.HOSPDesc= eobj.HOSPDesc   
			s obj.HOSPDateFrom=eobj.HOSPDateFrom       
			s obj.HOSPDateTo=eobj.HOSPDateTo
			s:eobj.HOSPMandatoryRefHospital="" eobj.HOSPMandatoryRefHospital="N"
			s obj.HOSPMandatoryRefHospital=eobj.HOSPMandatoryRefHospital 
			s sc=obj.%Save()
			d cobj.HospitalDRSetObjectId(obj.%Id())
			d obj.%Close()
			
			s cobj.CommunityCode=eobj.CommunityCode
			s cobj.CommunityName=eobj.CommunityName
			s cobj.UpCommunityCode=eobj.UpCommunityCode
			s cobj.CommunityType=eobj.CommunityType
			s cobj.RecordDR=eobj.RecordDR	
			
			s scc=cobj.%Save()
			d cobj.%Close()
			If $$$ISOK(scc){
				s id = cobj.%Id()
				s result = "{success:'true',id:'"_obj.%Id()_"'}" //返回RowId
				d:eobj.RowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CHSS.DictHospital","CHSS.DictHospital","医疗机构",id,eobj.CommunityName,"A",eobj)
				d:eobj.RowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CHSS.DictHospital","CHSS.DictHospital","医疗机构",eobj.RowId,eobj.CommunityName,"U",eobj,bobj)
			}else{
				s result = "{success:'false',errorinfo:'"_$zconvert(scc,"O","JS")_"'}"   //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗机构","web.DHCBL.CT.CHSSDictHospital","SaveData",eobj)
				s ^ERRORLOGINFO(logid)=$zconvert(scc,"O","JS")  
			}
		}	
	}	
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

ClassMethod k() As %String
{
	k ^CT("HOSP")
	k ^CHSS.DictHospitalD
	k ^CHSS.DictHospitalI
	k ^CHSS.DictProvinceD
	k ^CHSS.DictProvinceI
	k ^CHSS.DictCityD
	k ^CHSS.DictCityI
	k ^CHSS.DictSectionD
	k ^CHSS.DictSectionI
	k ^CHSS.DictStreetD
	k ^CHSS.DictStreetI
	k ^CHSS.DictVillageD
	k ^CHSS.DictVillageI
	q 1
}

/// 去掉字符串末尾的空格
ClassMethod trim(str) As %String
{
	While($e(str,*)=" ")
	{
		s str=$e(str,1,*-1)
	}
	q str
}

/// w ##class(web.DHCBL.CT.CHSSDictHospital).ImportExcel("医疗机构","1113#东营区文汇街道社区卫生服务中心3#0001#乡镇卫生院#泰山区文汇街道社区卫生服务中心#0002")
/// w ##class(web.DHCBL.CT.CHSSDictHospital).ImportExcel("省","0001#山东省#")
/// w ##class(web.DHCBL.CT.CHSSDictHospital).ImportExcel("市(地区)","0001#东营市#0001")
/// w ##class(web.DHCBL.CT.CHSSDictHospital).ImportExcel("县(区)","0001#东营区#0001")
/// w ##class(web.DHCBL.CT.CHSSDictHospital).ImportExcel("乡(镇街道办事处)","0002#文汇街道#0001")
/// w ##class(web.DHCBL.CT.CHSSDictHospital).ImportExcel("村(街路弄)","0001#海通路#0002")
/// 0 失败，1修改/新增，2 数据相同 不操作
ClassMethod ImportExcel(sheetname, datastr) As %String
{
	s result =0
	q:datastr="" 0
	if (sheetname["医疗机构") //CHSS.DictHospital
	{
		s CommunityCode=$p(datastr,"#",1)
		s CommunityName=$p(datastr,"#",2)
		s UpCommunityCode=$p(datastr,"#",3)
		s CommunityType=$p(datastr,"#",4)
		s Hospital=$p(datastr,"#",5)
		s Record=$p(datastr,"#",6)
		
		q:Hospital="" result
		s Hospital1=..trim(Hospital)
		s HospitalDR=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Hospital1),0))
		
		s RecordDR=""
		if (Record'=""){
			s:(CommunityType="市卫生局") RecordDR=$o(^CHSS.DictCityI("CodeIndex",Record,0))
			s:(CommunityType="县（区）卫生局") RecordDR=$o(^CHSS.DictSectionI("CodeIndex",Record,0))
			s:(CommunityType="乡镇卫生院") RecordDR=$o(^CHSS.DictStreetI("CodeIndex",Record,0))
			s:(CommunityType="社区卫生服务中心") RecordDR=$o(^CHSS.DictStreetI("CodeIndex",Record,0))
			s:(CommunityType="社区卫生服务站") RecordDR=$o(^CHSS.DictVillageI("CodeIndex",Record,0))
			s:(CommunityType="村卫生所") RecordDR=$o(^CHSS.DictVillageI("CodeIndex",Record,0))
		}

		if (HospitalDR'="")
		{
			///判断是否和原数据一样，一样则不修改
			s id=$o(^CHSS.DictHospitalI("CommunityCodeIndex",CommunityCode,0)) 
			s oCommunityCode="",oCommunityName="",oUpCommunityCode="",oCommunityType="",oHospitalDR="",oRecordDR=""	
			if (id'=""){
				s oCommunityCode=$listget($g(^CHSS.DictHospitalD(id)),2) 
				s oCommunityName=$listget($g(^CHSS.DictHospitalD(id)),4) 
				s oUpCommunityCode=$listget($g(^CHSS.DictHospitalD(id)),9) 
				s oCommunityType=$listget($g(^CHSS.DictHospitalD(id)),5) 
				s oHospitalDR=$listget($g(^CHSS.DictHospitalD(id)),6)  
				s oRecordDR=$listget($g(^CHSS.DictHospitalD(id)),7) 
			}
			s cstrnew="{list:[{CommunityCode:"""_CommunityCode_""",CommunityName:"""_CommunityName_""",UpCommunityCode:"""_UpCommunityCode_""",CommunityType:"""_CommunityType_""",HospitalDR:"""_HospitalDR_""",RecordDR:"""_RecordDR_"""}]}"
   			s cstrold="{list:[{CommunityCode:"""_oCommunityCode_""",CommunityName:"""_oCommunityName_""",UpCommunityCode:"""_oUpCommunityCode_""",CommunityType:"""_oCommunityType_""",HospitalDR:"""_oHospitalDR_""",RecordDR:"""_oRecordDR_"""}]}"
   			if (cstrnew=cstrold)
   			{
	   			s result=2 ///跳过修改	   		
   			}
   			else
   			{
	   			///修改
	   			s eobj=##class(web.Entity.CT.CHSSDictHospital).%New()
   				s eobj.RowId=id
   				s eobj.CommunityCode=$p(datastr,"#",1)
   				s eobj.CommunityName=$p(datastr,"#",2)
   				s eobj.UpCommunityCode=$p(datastr,"#",3)
   				s eobj.CommunityType=$p(datastr,"#",4)
   				s eobj.RecordDR=RecordDR
   				s eobj.HOSPCode=$p(datastr,"#",1)
				s eobj.HOSPDesc=$p(datastr,"#",5)
  				s eobj.HOSPDateFrom=$tr($zd((+$H),3),"-","/")

   				s estr=##class(web.DHCBL.CT.CHSSDictHospital).SaveData(eobj)
   				if (estr["success:'true'")
				{
   					 s result=1  					
				}
				if (estr["success:'false'")
				{
					s result=0				
					s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
				}
   			}
   				
		}
		else
		{
			s eobj=##class(web.Entity.CT.CHSSDictHospital).%New()
   			s eobj.RowId=""
			s eobj.CommunityCode=$p(datastr,"#",1)
			s eobj.CommunityName=$p(datastr,"#",2)
			s eobj.UpCommunityCode=$p(datastr,"#",3)
			s eobj.CommunityType=$p(datastr,"#",4)
			s eobj.RecordDR=RecordDR
			s eobj.HospitalDR=""
			s eobj.HOSPCode=$p(datastr,"#",1)
			s eobj.HOSPDesc=$p(datastr,"#",5)
  			s eobj.HOSPDateFrom=$tr($zd((+$H),3),"-","/")

			s estr=##class(web.DHCBL.CT.CHSSDictHospital).SaveData(eobj)
			if (estr["success:'true'")
			{
				s result=1	 
			}
			if (estr["success:'false'")
			{
				s result=0
				s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
			}	
		}
	}
	
	
	if (sheetname["省") //CHSS.DictProvince
	{
		s Code=$p(datastr,"#",1)
		s Description=$p(datastr,"#",2)
		s RowIdParref=$p(datastr,"#",3)
		s flag=$d(^CHSS.DictProvinceI("CodeIndex",Code))

		if (flag=0)
		{
			s obj=##class(CHSS.DictProvince).%New()
   			s obj.Code=Code
			s obj.Description=Description
			s obj.RowIdParref=RowIdParref
		
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				s result=1	 
				s estr = "{success:'true',id:'"_obj.%Id()_"'}" 
			}else{
				s result=0
				s estr = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}" 
				s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
			}
		}
	}
	
	if (sheetname["市(地区)") //CHSS.DictCity
	{
		s Code=$p(datastr,"#",1)
		s Description=$p(datastr,"#",2)
		s CodeParref=$p(datastr,"#",3)
		s flag=$d(^CHSS.DictCityI("CodeIndex",Code))

		if (flag=0)
		{
			s obj=##class(CHSS.DictCity).%New()
   			s obj.Code=Code
			s obj.Description=Description
			s:CodeParref'="" RowIdParref= $o(^CHSS.DictProvinceI("CodeIndex",CodeParref,0))
			s:CodeParref="" RowIdParref=""
			d obj.RowIdParrefSetObjectId(RowIdParref)
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				s result=1	
				s estr = "{success:'true',id:'"_obj.%Id()_"'}" 
			}else{
				s result=0
				s estr = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}" 
				s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
			}
		}
	}
	
	if (sheetname["县(区)") //CHSS.DictSection
	{
		s Code=$p(datastr,"#",1)
		s Description=$p(datastr,"#",2)
		s CodeParref=$p(datastr,"#",3)
		s flag=$d(^CHSS.DictSectionI("CodeIndex",Code))

		if (flag=0)
		{
			s obj=##class(CHSS.DictSection).%New()
   			s obj.Code=Code
			s obj.Description=Description
			s:CodeParref'="" RowIdParref= $o(^CHSS.DictCityI("CodeIndex",CodeParref,0))
			s:CodeParref="" RowIdParref=""
			d obj.RowIdParrefSetObjectId(RowIdParref)
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				s result=1	
				s estr = "{success:'true',id:'"_obj.%Id()_"'}" 
			}else{
				s result=0
				s estr = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}" 
				s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
			}
		}
	}
	
	if (sheetname["乡(镇街道办事处)") //CHSS.DictStreet
	{
		s Code=$p(datastr,"#",1)
		s Description=$p(datastr,"#",2)
		s CodeParref=$p(datastr,"#",3)
		s flag=$d(^CHSS.DictStreetI("CodeIndex",Code))
		if (flag=0)
		{
			s obj=##class(CHSS.DictStreet).%New()
   			s obj.Code=Code
			s obj.Description=Description
			s:CodeParref'="" RowIdParref= $o(^CHSS.DictSectionI("CodeIndex",CodeParref,0))
			s:CodeParref="" RowIdParref=""
			d obj.RowIdParrefSetObjectId(RowIdParref)
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				s result=1	
				s estr = "{success:'true',id:'"_obj.%Id()_"'}" 
			}else{
				s result=0
				s estr = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}" 
				s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
			}
		}
	}
	
	if (sheetname["村(街路弄)") //CHSS.DictVillage
	{
		s Code=$p(datastr,"#",1)
		s Description=$p(datastr,"#",2)
		s CodeParref=$p(datastr,"#",3)
		s flag=$d(^CHSS.DictVillageI("CodeIndex",Code))

		if (flag=0)
		{
			s obj=##class(CHSS.DictVillage).%New()
   			s obj.Code=Code
			s obj.Description=Description
			s:CodeParref'="" RowIdParref= $o(^CHSS.DictStreetI("CodeIndex",CodeParref,0))
			s:CodeParref="" RowIdParref=""
			d obj.RowIdParrefSetObjectId(RowIdParref)
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				s result=1	
				s estr = "{success:'true',id:'"_obj.%Id()_"'}" 
			}else{
				s result=0
				s estr = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}" 
				s ^ERROR(sheetname,$p(datastr,"#",1),$p(datastr,"#",2))=datastr_"&&"_estr
			}
		}
	}
	q result
}

}
