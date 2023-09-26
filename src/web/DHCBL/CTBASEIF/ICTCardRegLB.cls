Class web.DHCBL.CTBASEIF.ICTCardRegLB Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 利用表名称和条件查找数据
ClassMethod ReadBaseData(TabName As %String, QueryInfo As %String = "") As %String
{
	;w ##class(web.DHCBL.CTBASEIF.ICTCardRegLB).ReadBaseData("CTLocalityType",1)
	s TabName=$ZCONVERT($g(TabName),"U")
	s HospId=%session.Data("LOGON.HOSPID")
	Set langid=..%LanguageID()
	b
	s myrtn=""
	i (TabName="CTCITY"){
		s myPrvDR=$p(QueryInfo,"^",1)
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadCTCityInfo(myPrvDR)
	}elseif(TabName="CTCOUNTRY"){
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadCTCountryInfo()
	}elseif(TabName="CTLOCALITYTYPE"){
		s myAreaDR=$p(QueryInfo,"^",1)
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadCTLocalityType(myAreaDR)
		b ;
	}elseif(TabName="CTNATION"){
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadCTNationInfo()
		s HospCodeNode="HospDr_"_HospId
		s SortNation=$g(^DHCDocCardConfig(HospCodeNode,"SortNation"))
		if SortNation'="" {
			s SortTab="User.CTNation"
			s myrtn=$$GetSortItem(myrtn, SortTab, SortNation)
		}
	}elseif(TabName=$ZCONVERT("CTProvince","U")){
		s myCountryDR=$p(QueryInfo,"^",1)
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadCTProvinceInfo(myCountryDR)
	}elseif(TabName=$ZCONVERT("CTRelation","U")){
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadCTRelationInfo()
		s HospCodeNode="HospDr_"_HospId
		s SortNation=$g(^DHCDocCardConfig(HospCodeNode,"SortRelation"))
		if SortNation'="" {
			s SortTab="User.CTRelation"
			s myrtn=$$GetSortItem(myrtn, SortTab, SortNation)
		}
	}elseif(TabName="CTOCCUPATION"){
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadOccupationInfo()
		s HospCodeNode="HospDr_"_HospId
		s SortNation=$g(^DHCDocCardConfig(HospCodeNode,"SortOccupation"))
		if SortNation'="" {
			s SortTab="User.CTOccupation"
			s myrtn=$$GetSortItem(myrtn, SortTab, SortNation)
		}
	}elseif(TabName="CTZIP"){
		s ProvinceDR=$p(QueryInfo,"^",1)
		s CityDR=$p(QueryInfo,"^",2)
		s CityAreaDR=$p(QueryInfo,"^",3)
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadZipInfo(ProvinceDR,CityDR,CityAreaDR)
	}elseif(TabName="ARCINSURANCETYPE"){
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadInsuranceInfo()
	}elseif(TabName="PACADMREASON"){
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadAdmReasonInfo(QueryInfo)
	}elseif(TabName="CTHEALTHCAREPROVIDER"){
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadHealthCareProviderInfo()
	}elseif(TabName="CTHEALTHCAREREGION"){
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadHealthCareRegionInfo()
	}elseif(TabName="CTMARITAL"){
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadCTMaritalInfo()
		s HospCodeNode="HospDr_"_HospId
		s SortNation=$g(^DHCDocCardConfig(HospCodeNode,"SortMarital"))
		if SortNation'="" {
			s SortTab="User.CTMarital"
			s myrtn=$$GetSortItem(myrtn, SortTab, SortNation)
		}
	}elseif(TabName="CTCITYAREA"){
		s CityDR=$p(QueryInfo,"^",1)
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadCTAreaInfo(CityDR)
	}elseif(TabName="POLITICALLEVEL"){
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadPoliticalLevelInfo()
	}elseif(TabName="SECRETLEVEL"){
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadSecretLevelInfo()
	}elseif(TabName="HCPDR"){
		s myrtn=##class(web.DHCBL.CTBASE.CTCardRegLB).ReadHCPDRInfo(HospId)
	}elseif(TabName=""){
	}
	if (QueryInfo'="")&&($l(QueryInfo,"^")>=4){
		s index=1
		s type=$p(QueryInfo,"^",4)
		if (type="HUIJSON"){
			q:myrtn="" "[]"
			s json="["
			for i=1:1:$l(myrtn,"$c(1)"){
				s onemyrtn=$p(myrtn,"$c(1)",i)
				s id=$p(onemyrtn,"$c(2)",1)
				s text=$p(onemyrtn,"$c(2)",2)
				s default=$p(onemyrtn,"$c(2)",3)
				s AliasStr=$p(onemyrtn,"$c(2)",4)
				continue:id=""
				if (TabName="CTCOUNTRY"){
					if (text["-") s text=$p(text,"-",2)
					s default=0 //
				}elseif(TabName="CTNATION"){
				}else{
					if (text["-") s text=$p(text,"-",1)
				}
				if (TabName="CTPROVINCE"){
					s item=$p(QueryInfo,"^",5)
					if (item'="ProvinceInfoLookUpRowID"){ //取省份时,非省(现住)不进行数据默认
						s default=0
					}
				}
				s OneJsonData="{""text"":"""_$g(text)_""",""id"":"""_$g(id)_""",""AliasStr"":"""_$g(AliasStr)_""""
				i default=1 s OneJsonData=OneJsonData_",""selected"":true"
				s OneJsonData=OneJsonData_"}"
				i index=1 {
					s json=json_OneJsonData
				}else{
					s json=json_","_OneJsonData
				}
				s index=index+1
			}
			s json=json_"]"  
			q json
		}
	}
	
	q myrtn
	
GetSortItem(InfoStr, SortTab, SortType)
	;create 20200925 by yuanlei
	;数据排序；配置：患者主索引管理->注册配置->基础数据排序
	k ^TmpSortItem("GetSortItem",$j)
	s Index=0
	s InfoStrLen=$l(InfoStr,"$c(1)")
	for ll=1:1:InfoStrLen {
		s OneInfoStr=$p(InfoStr,"$c(1)",ll)
		s ID=$p(OneInfoStr,"$c(2)",1)
		continue:ID=""
		s SortNo=##class(web.DHCBL.BDP.BDPSort).GetSortNum(SortTab,SortType,ID)
		s SortNo=$case($l(SortNo),0:"999",1:"00"_SortNo,2:"0"_SortNo,:SortNo)
		s Index=Index+1
		s ^TmpSortItem("GetSortItem",$j," "_SortNo,Index)=OneInfoStr
	}
	
	s RtnInfoStr=""
	s l1="" f {
		s l1=$o(^TmpSortItem("GetSortItem",$j,l1))
		q:l1=""
		s l2="" f {
			s l2=$o(^TmpSortItem("GetSortItem",$j,l1,l2))
			q:l2=""
			s Info=$g(^TmpSortItem("GetSortItem",$j,l1,l2))
			if RtnInfoStr="" s RtnInfoStr=Info
			else  s RtnInfoStr=RtnInfoStr_"$c(1)"_Info
		}
	}
	k ^TmpSortItem("GetSortItem",$j)
	q RtnInfoStr
}

/// /新的现地址
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CTBASEIF.ICTCardRegLB","admaddressNewlookup","dh")
Query admaddressNewlookup(desc As %String) As %Query(ROWSPEC = "provdesc:%String,provid:%String,AddressIDStr:%String")
{
}

ClassMethod admaddressNewlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admaddressNewlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod admaddressNewlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    s desc=$$ALPHAUP^SSUTIL4(desc)
    If $g(ind)="" Set ind=1
	s provdesc="",rowid="0"
	s CurSearchDesc=##class(ext.util.String).ToChineseSpell(desc)
	s CurSearchDesc=$$ALPHAUP^SSUTIL4(CurSearchDesc)
	s ChineseDescFlag=##class(web.DHCBL.CTBASEIF.ICTCardRegLB).CheckHaveChinese(desc)
	;i $l(CurSearchDesc)>1 s SearchDesc=$e(CurSearchDesc,1,$l(CurSearchDesc)-1)
	;e  s SearchDesc=CurSearchDesc
	//q:CurSearchDesc="" ""
	kill ^||tmpAddressSearch($j)
	i CurSearchDesc="" {
		;此字段数据量太大,不支持无条件查询
		/*
		s rowid=0
		for {
			s rowid=$o(^CT("ADD",rowid))  q:rowid=""
			s provdesc=$p(^CT("ADD",rowid),"^",2)
			s SearchCode=$p(^CT("ADD",rowid),"^",8)
			s provdesc=$$ALPHAUP^SSUTIL4(provdesc)
			s SearchCode=$$ALPHAUP^SSUTIL4(SearchCode)
			d OutputRow8New
		}
		*/
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	for Node="SearchCode","Desc"{
	    s OverFlag=0
	    s Code=$O(^CT("ADD",0,Node,desc),-1)
	    s LastCode=Code
	    for{
		    s Code=$O(^CT("ADD",0,Node,Code)) Q:(LastCode=""!OverFlag)&((Code="")!(Code=LastCode))
		    if Code="" s OverFlag=1 continue
		    continue:Code'[desc
		    s rowid=0 for{
			    s rowid=$O(^CT("ADD",0,Node,Code,rowid)) Q:rowid=""
			    s ActiveFrom=$p(^CT("ADD",rowid),"^",9),ActiveTo=$p(^CT("ADD",rowid),"^",10)
			    continue:((ActiveFrom'="")&&(ActiveFrom>+$h))!((ActiveTo'="")&&(ActiveTo<+$h))
			    s provdesc=$p(^CT("ADD",rowid),"^",2)
			    d OutputRow8New
			 	Q:ind>800
			}
			Q:ind>800
	   }
    }
    if (CurSearchDesc'=desc) {
	    for Node="SearchCode","Desc"{
		    s OverFlag=0
		    s Code=$O(^CT("ADD",0,Node,CurSearchDesc),-1)
		    s LastCode=Code
		    for{
			    s Code=$O(^CT("ADD",0,Node,Code)) Q:(LastCode=""!OverFlag)&((Code="")!(Code=LastCode))
			    if Code="" s OverFlag=1 continue
			    continue:Code'[CurSearchDesc
			    continue:(Node="SearchCode")&&(Code'[desc)
			    s rowid=0 for{
				    s rowid=$O(^CT("ADD",0,Node,Code,rowid)) Q:rowid=""
				    s ActiveFrom=$p(^CT("ADD",rowid),"^",9),ActiveTo=$p(^CT("ADD",rowid),"^",10)
				    continue:((ActiveFrom'="")&&(ActiveFrom>+$h))!((ActiveTo'="")&&(ActiveTo<+$h))
				    s provdesc=$p(^CT("ADD",rowid),"^",2)
				    d OutputRow8New
				 	Q:ind>800
				}
				Q:ind>800
		   }
	   }
	}
	///简拼检索
	if (ChineseDescFlag'="Y") {
	    for Node="SearchCode","Desc"{
		    s OverFlag=0
		    s Code=$O(^CT("ADD",0,"SearchCode",CurSearchDesc),-1)
		    s LastCode=Code
		    for{
			    s Code=$O(^CT("ADD",0,Node,Code)) Q:(LastCode=""!OverFlag)&((Code="")!(Code=LastCode))
			    if Code="" s OverFlag=1 continue
			    
			    s PinYin= ##class(DHCDoc.Util.Base).GetCNCODE(Code,3,"")
			    continue:PinYin=""
			    continue:(PinYin'[desc)
			    
			    s rowid=0 for{
				    s rowid=$O(^CT("ADD",0,Node,Code,rowid)) Q:rowid=""
				    s ActiveFrom=$p(^CT("ADD",rowid),"^",9),ActiveTo=$p(^CT("ADD",rowid),"^",10)
				    continue:((ActiveFrom'="")&&(ActiveFrom>+$h))!((ActiveTo'="")&&(ActiveTo<+$h))
				    s provdesc=$p(^CT("ADD",rowid),"^",2)
				    d OutputRow8New
				 	Q:ind>800
				}
				Q:ind>800
		   }
	   }
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
	;如果是汉字走描述索引,因为汉字很多是重拼音首字母
	i CurSearchDesc'=desc {
		s CurSearchDesc=desc
		;1. 找汉字全匹配
		s rowid=0
		for {
			s rowid=$o(^CT("ADD",0,"Desc",CurSearchDesc,rowid))  q:rowid=""
			s provdesc=$p(^CT("ADD",rowid),"^",2)
			s SearchCode=$p(^CT("ADD",rowid),"^",8)
			s provdesc=$$ALPHAUP^SSUTIL4(provdesc)
			s SearchCode=$$ALPHAUP^SSUTIL4(SearchCode)
			d OutputRow8New
		}
		
		;3. 按汉字前匹配检索
		s LoopSearchDesc=CurSearchDesc
		for {
			s LoopSearchDesc=$o(^CT("ADD",0,"Desc",LoopSearchDesc))  q:LoopSearchDesc=""
			quit:$e(LoopSearchDesc,1,$l(CurSearchDesc))'=CurSearchDesc
			continue:LoopSearchDesc'[CurSearchDesc
			s rowid=0
			for {
				s rowid=$o(^CT("ADD",0,"Desc",LoopSearchDesc,rowid))  q:rowid=""
				s provdesc=$p(^CT("ADD",rowid),"^",2)
				s SearchCode=$p(^CT("ADD",rowid),"^",8)
				s provdesc=$$ALPHAUP^SSUTIL4(provdesc)
				s SearchCode=$$ALPHAUP^SSUTIL4(SearchCode)
				d OutputRow8New
			}
		
		}
		
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	;1. 找拼音码全匹配
	s rowid=0
	for {
		s rowid=$o(^CT("ADD",0,"SearchCode",CurSearchDesc,rowid))  q:rowid=""
		s provdesc=$p(^CT("ADD",rowid),"^",2)
		s SearchCode=$p(^CT("ADD",rowid),"^",8)
		s provdesc=$$ALPHAUP^SSUTIL4(provdesc)
		s SearchCode=$$ALPHAUP^SSUTIL4(SearchCode)
		d OutputRow8New
	}
	;2. 找别名表全匹配
	s rowid=""
	for{
		s rowid=$o(^User.BDPAliasI("AliasRef","CT_Address",CurSearchDesc,rowid))
		q:rowid=""
		if '$d(^CT("ADD",rowid)) continue
		s provdesc=$p(^CT("ADD",rowid),"^",2)
		s SearchCode=$p(^CT("ADD",rowid),"^",8)
		s provdesc=$$ALPHAUP^SSUTIL4(provdesc)
		s SearchCode=$$ALPHAUP^SSUTIL4(SearchCode)
		d OutputRow8New
	}
	;3. 按拼音前匹配检索
	s LoopSearchDesc=CurSearchDesc
	for {
		s LoopSearchDesc=$o(^CT("ADD",0,"SearchCode",LoopSearchDesc))  q:LoopSearchDesc=""
		quit:$e(LoopSearchDesc,1,$l(CurSearchDesc))'=CurSearchDesc
		continue:LoopSearchDesc'[CurSearchDesc
		s rowid=0
		for {
			s rowid=$o(^CT("ADD",0,"SearchCode",LoopSearchDesc,rowid))  q:rowid=""
			s provdesc=$p(^CT("ADD",rowid),"^",2)
			s SearchCode=$p(^CT("ADD",rowid),"^",8)
			s provdesc=$$ALPHAUP^SSUTIL4(provdesc)
			s SearchCode=$$ALPHAUP^SSUTIL4(SearchCode)
			d OutputRow8New
		}
		
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow8New
    s ActiveFrom=$p(^CT("ADD",rowid),"^",9)
    s ActiveTo=$p(^CT("ADD",rowid),"^",10)
    quit:(ActiveFrom'="")&&(ActiveFrom>+$h)
    quit:(ActiveTo'="")&&(ActiveTo<=..%SysDate())
	quit:$d(^||tmpAddressSearch($j,rowid))
    set ^||tmpAddressSearch($j,rowid)=""
    Set langid=..%LanguageID()
    Set provdesc = ##class(User.CTAddress).GetTranByDesc("CTADDDesc",provdesc,langid)
    s ProvinceDR=$p(^CT("ADD",rowid),"^",3)
    s CityDR=$p(^CT("ADD",rowid),"^",4)
    s CityAreaDR=$p(^CT("ADD",rowid),"^",5)
    s CommunityDR=$p(^CT("ADD",rowid),"^",6)
    s CTADDStreetDR=$p(^CT("ADD",rowid),"^",7)
    s CountryDR=""
    if (ProvinceDR'=""){
	    s CountryDR = ##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultCountry()
		s CTRegionDr=$P(^CT("PROV",ProvinceDR),"^",3)
		if (CTRegionDr'=""){
			s CountryDR =$P(^CT("RG",CTRegionDr),"^",4)
		}
	}
    
    
    s AddressIDStr=CountryDR_"^"_ProvinceDR_"^"_CityDR_"^"_CityAreaDR_"^"_CommunityDR_"^"_CTADDStreetDR
    
	set Data=$lb(provdesc,rowid,AddressIDStr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admaddressNewlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admaddressNewlookupExecute ]
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

/// /通过新地址id获取省市县街道27912
/// /##class(web.DHCBL.CTBASEIF.ICTCardRegLB).GetOlddress(50)
ClassMethod GetOlddress(AddressNewID)
{
	///^CT("ADD",rowid)
	///CTADDProvinceDR //省
	s CTCountryRowId="",CTCountryDesc=""
	s CTADDProvinceDR=$p(^CT("ADD",AddressNewID),"^",3)
	s provdesc=""
	i CTADDProvinceDR'="" d
	.s provdesc=$p(^CT("PROV",CTADDProvinceDR),"^",2)
	.s:provdesc["-" provdesc=$p(provdesc,"-",2)
	.s CTRegionRowid=$p(^CT("PROV",CTADDProvinceDR),"^",3)
	.i CTRegionRowid'="" d
	..s CTCountryRowId=$p(^CT("RG",CTRegionRowid),"^",4) //国家 id
	..i CTCountryRowId'="" s CTCountryDesc=$p(^CT("COU",CTCountryRowId),"^",2)
	
	
	///CTADDCityDR //市
	s CTADDCityDR=$p(^CT("ADD",AddressNewID),"^",4)
	s citydesc=""
	if (CTADDCityDR'="") d
	.s citydesc=$p(^CT("CIT",CTADDCityDR),"^",2)
	.s:citydesc["-" citydesc=$p(citydesc,"-",2)
	///CTADDCityAreaDR //区/县
	s CTADDCityAreaDR=$p(^CT("ADD",AddressNewID),"^",5)
	s ctdesc=""
	i CTADDCityAreaDR'="" d
	.i ($d(^CT("CITAREA",CTADDCityAreaDR))'=0) d
	..s ctdesc=$p(^CT("CITAREA",CTADDCityAreaDR),"^",2)
	..s:ctdesc["-" ctdesc=$p(ctdesc,"-",2)
	b ;
	///Street //街道
	s Street=$p(^CT("ADD",AddressNewID),"^",7)
	s StreetDesc=""
	i Street'="" d
	.s StreetDesc=$p(^CT("LOCTYPE",Street),"^",2)
	.s:StreetDesc["-" StreetDesc=$p(StreetDesc,"-",2)
	
	///Community //社区
	s Community=$p(^CT("ADD",AddressNewID),"^",7)
	s CTZipDesc=""
	if CTADDCityDR'="" d
	.s CTZipDesc=##class(web.UDHCJFBaseCommon).GetCTZipDesc(CTADDCityDR,CTADDCityAreaDR)
	q provdesc_"^"_CTADDProvinceDR_"^"_citydesc_"^"_CTADDCityDR_"^"_ctdesc_"^"_CTADDCityAreaDR_"^"_StreetDesc_"^"_Street_"^"_CTZipDesc_"^"_CTCountryRowId_"^"_CTCountryDesc
}

/// /通过新地址id获取省市县街道27912
/// /##class(web.DHCBL.CTBASEIF.ICTCardRegLB).GetNewdress(5,"","")
ClassMethod GetNewdress(prov, city, CityArea)
{
	///^CT("ADD",rowid)^CT("ADD",0,"Desc",,)
	///CTADDProvinceDR //省
	s rtn=""
	q:prov="" ""
	s AddressNewID=""
	f  s AddressNewID=$o(^CT("ADD",AddressNewID)) q:AddressNewID=""  d
	.s CTADDProvinceDR=$p(^CT("ADD",AddressNewID),"^",3)
	.q:CTADDProvinceDR'=prov
	.s rtn=AddressNewID
	.s CTADDCityDR=$p(^CT("ADD",AddressNewID),"^",4)
	.q:CTADDCityDR'=city
	.s rtn=AddressNewID
	.s CTADDCityAreaDR=$p(^CT("ADD",AddressNewID),"^",5)
	.q:CTADDCityAreaDR'=CityArea
	.s rtn=AddressNewID
	q rtn
}

/// 通过省、市、区id获取邮编
/// ##class(web.DHCBL.CTBASEIF.ICTCardRegLB).GetPostCodeByPCA(5,"","")
ClassMethod GetPostCodeByPCA(Prov, City, CityArea)
{
	s PostCode=""
	if (Prov="")!(City="")!(CityArea="") q PostCode
	;^CT("ZIP",0,"Prov",{CTZIP_Province_DR},{CTZIP_RowId}) 
	s ZipID=0 f {
		s ZipID=$o(^CT("ZIP",0,"Prov",Prov,ZipID))
		q:ZipID=""
		s CityDr=$p(^CT("ZIP",ZipID),"^",6)
		continue:CityDr'=City
		s CityAreaDr=$p(^CT("ZIP",ZipID),"^",7)
		continue:CityAreaDr'=CityArea
		s PostCode=$p(^CT("ZIP",ZipID),"^",1)
	}
	q PostCode
}

/// ##class(web.DHCBL.CTBASEIF.ICTCardRegLB).GetCommunityDesc(26)
ClassMethod GetCommunityDesc(AddrStr, Split)
{
	q:AddrStr="" ""
	q:Split="" ""
	s CommunityDesc=$P(AddrStr,Split,2)
	q CommunityDesc
}

/// w ##class(web.DHCBL.CTBASEIF.ICTCardRegLB).GetEDUJsonInfo()
ClassMethod GetEDUJsonInfo()
{
	s EDURowId=0
	s json="["
  	f {
	   	s EDURowId=$o(^CT("EDU",EDURowId))
	   	q:EDURowId=""
	   	
	    s EDUCode=$p($g(^CT("EDU",EDURowId)),"^",1)
	    s EDUDesc=$p($g(^CT("EDU",EDURowId)),"^",2)
  		s Active=$p($g(^CT("EDU",EDURowId)),"^",5)
  		continue:Active'="Y"
  		s DateActiveFrom=$p($g(^CT("EDU",EDURowId)),"^",6)
  		s DateActiveTo=$p($g(^CT("EDU",EDURowId)),"^",7)
  		continue:(DateActiveFrom>+$h)&&(DateActiveFrom'="")
 		continue:(DateActiveTo<+$h)&&(DateActiveTo'="")
  		s OneJsonData="{""text"":"""_$g(EDUDesc)_""",""id"":"""_$g(EDURowId)_""""
		s OneJsonData=OneJsonData_"}"
		s json=$Case(json,"[":json_OneJsonData,:json_","_OneJsonData)
		
	}
	s json=json_"]"  
	q json
}

/// w ##class(web.DHCBL.CTBASEIF.ICTCardRegLB).GetLANJsonInfo()
ClassMethod GetLANJsonInfo()
{
	s LANRowId=0
	s json="["
  	f {
	   	s LANRowId=$o(^SS("LAN",LANRowId))
	   	q:LANRowId=""
	   	
	    //s EDUCode=$p($g(^CT("LAN",LANRowId)),"^",1)
	    s LANDesc=$p($g(^SS("LAN",LANRowId)),"^",2)
  		s Active=$p($g(^SS("LAN",LANRowId)),"^",3)
  		continue:Active'="Y"
  		s DateActiveFrom=$p($g(^SS("LAN",LANRowId)),"^",4)
  		s DateActiveTo=$p($g(^SS("LAN",LANRowId)),"^",5)
  		continue:(DateActiveFrom>+$h)&&(DateActiveFrom'="")
 		continue:(DateActiveTo<+$h)&&(DateActiveTo'="")
  		s OneJsonData="{""text"":"""_$g(LANDesc)_""",""id"":"""_$g(LANRowId)_""""
		s OneJsonData=OneJsonData_"}"
		s json=$Case(json,"[":json_OneJsonData,:json_","_OneJsonData)
		
	}
	s json=json_"]"  
	q json
}

/// w ##class(web.DHCBL.CTBASEIF.ICTCardRegLB).GetLANJsonInfo()
ClassMethod GetDefLanByCountry(CountryID)
{
	q:CountryID="" ""
	s CTCOULanguageDR=$p($g(^CT("COU",CountryID)),"^",6)
	q CTCOULanguageDR
}

/// 判断是否存在汉字
/// w ##class(web.DHCBL.CTBASEIF.ICTCardRegLB).CheckHaveChinese("中 国")
ClassMethod CheckHaveChinese(desc)
{
	q:desc="" ""
	s len = $l(desc)
	s HZFlag=""
	for i = 1 : 1 : len {
		q:HZFlag="Y"
		s char = $e(desc, i)
		s flag=##class(Util.StringUtils).IsChinese(char)
		i flag=1 s HZFlag="Y"
	}
	q HZFlag
}

}
