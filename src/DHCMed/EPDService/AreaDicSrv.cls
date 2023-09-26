/// 名称: DHCMed.EPDService.AreaDicSrv
/// 描述: 省市县乡维护
/// 编写者：likai
/// 编写日期: 2012-08-23
Class DHCMed.EPDService.AreaDicSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Creator：     likai
/// CreatDate：   2012-08-26
/// Description:  获取省市县乡字典列表
/// Table：       DHCMed.EPD.AreaDic
/// Input：       aParentID,aIsActive
/// Return：      %String
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.AreaDicSrv","QryAreaDic","","1")
Query QryAreaDic(aParentID As %String, aIsActive As %Boolean) As %Query(ROWSPEC = "RowID:%String,Code:%String,LongDesc:%String,ShortDesc:%String,IsActive:%String,IsActiveDesc:%String")
{
}

ClassMethod QryAreaDicExecute(ByRef qHandle As %Binary, aParentID As %String, aIsActive As %Boolean) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aParentID="" aParentID=1
	Set:aParentID=0 aParentID=1
	
	Set objParent=##Class(DHCMed.EPD.AreaDic).GetObjById(aParentID)
	Quit:'$IsObject(objParent) $$$OK
	Set ParentCode=objParent.Code
	
	If ParentCode="0" {
		Set ParentCode=""
	} ElseIf ParentCode="00000000" {
		Set ParentCode=""
	} ElseIf $e(ParentCode,3,8)="000000" {
		Set ParentCode=$e(ParentCode,1,2)
	} ElseIf $e(ParentCode,5,8)="0000" {
		Set ParentCode=$e(ParentCode,1,4)
	} ElseIf $e(ParentCode,7,8)="00" {
		Set ParentCode=$e(ParentCode,1,6)
	} Else {
		Set ParentCode=ParentCode
	}
	
	For indDic=1:1:99 {
		Set Code=indDic
		Set:$l(Code)<2 Code="0"_Code
		Set Code=ParentCode_Code
		If $l(Code)=2 {
			Set Code=Code_"000000"
		} ElseIf $l(Code)=4 {
			Set Code=Code_"0000"
		} ElseIf $l(Code)=6 {
			Set Code=Code_"00"
		} Else {
			Set Code=Code
		}
		
		Set RowID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_Code,0))
		Continue:RowID=""
		Set objArea=##Class(DHCMed.EPD.AreaDic).GetObjById(RowID)
		Continue:'$IsObject(objArea)
		Set ShortDesc=objArea.ShortDesc
		Set LongDesc=objArea.LongDesc
		Set Code=objArea.Code
		Set IsActive=objArea.IsActive
		Continue:(aIsActive'="")&&(aIsActive'=IsActive)
		Set IsActiveDesc=$s(IsActive=1:"是",1:"否")
		
		Set Data=$lb(RowID,Code,LongDesc,ShortDesc,IsActive,IsActiveDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryAreaDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAreaDicExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAreaDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAreaDicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	// if there are no more rows, finish fetching
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	// fetch row
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##Class(DHCMed.EPDService.AreaDicSrv).GetAreaDics()
ClassMethod GetAreaDics(aProvince As %String, aCity As %String, aCounty As %String, aVillage As %String) As %String
{
	new (aProvince, aCity, aCounty, aVillage)
	set return=""
	
	if aProvince'="" {
		set objArea=##Class(DHCMed.EPD.AreaDic).GetObjById(aProvince)
		if $IsObject(objArea){
			set Province=objArea.ShortDesc
		}
	}
	
	if aCity'="" {
		set objArea=##Class(DHCMed.EPD.AreaDic).GetObjById(aCity)
		if $IsObject(objArea){
			set City=objArea.ShortDesc
		}
	}
	
	if aCounty'="" {
		set objArea=##Class(DHCMed.EPD.AreaDic).GetObjById(aCounty)
		if $IsObject(objArea){
			set County=objArea.ShortDesc
		}
	}
	
	if aVillage'="" {
		set objArea=##Class(DHCMed.EPD.AreaDic).GetObjById(aVillage)
		if $IsObject(objArea){
			set Village=objArea.ShortDesc
		}
	}
	set return=aProvince_$c(1)_$g(Province)_$c(1)_aCity_$c(1)_$g(City)_$c(1)_aCounty_$c(1)_$g(County)_$c(1)_aVillage_$c(1)_$g(Village)
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-09-29
/// Description:  通过地址获取省市县乡
/// Table：       DHCMed.EPD.AreaDic
/// Input：       地址
/// Return：      拆分的字典项
/// w ##class(DHCMed.EPDService.AreaDicSrv).GetAddress("北京 朝阳 十八里店乡某某某村10号")
ClassMethod GetAddress(Address As %String) As %String
{
	New (Address)
	Set return=""
	Set Address=$tr(Address," ","")
	Quit:Address="" return
	
	Set (ProvinceDr,ProvinceDesc)=""
	Set (CityDr,CityDesc)=""
	Set (CountyDr,CountyDesc)=""
	Set (VillageDr,VillageDesc,VillageTxt)=""
	
	//省匹配
	Set ParentCode=""
	For indMatchType=1:1:2 {					//1:全匹配 2:模糊匹配(不带省/市/县/乡关键字) add by mayanpeng 2021-12-29
		Quit:(ProvinceDr'="")&&(ProvinceDesc'="")
		
		For indProvince=1:1:99 {
			Set ProvinceCode=indProvince
			Set:$l(ProvinceCode)<2 ProvinceCode="0"_ProvinceCode
			
			Set ID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_ProvinceCode_"000000",0))
			Continue:ID=""
			Set obj=##Class(DHCMed.EPD.AreaDic).GetObjById(ID)
			Continue:'$IsObject(obj)
			Set IsActive=obj.IsActive
			Continue:IsActive'=1
			Set ShortDesc=obj.ShortDesc
			Set ShortDesc=$tr(ShortDesc," ","")
			
			If (indMatchType=1)&&($e(Address,1,$l(ShortDesc))=ShortDesc) {
				Set ProvinceDr=ID
				Set ProvinceDesc=ShortDesc
				Set ParentCode=ProvinceCode
				Set Address=$p(Address,ShortDesc,2)
				Quit
			} 
			If (indMatchType=2) {
				Set ShortDesc2=ShortDesc
				If $e(ShortDesc2,*,*)="省" {
					Set ShortDesc2=$e(ShortDesc2,1,*-1)
				} ElseIf $e(ShortDesc2,*,*)="市" {
					Set ShortDesc2=$e(ShortDesc2,1,*-1)
				}
				If $e(Address,1,$l(ShortDesc2))=ShortDesc2 {
					Set ProvinceDr=ID
					Set ProvinceDesc=ShortDesc
					Set ParentCode=ProvinceCode
					Quit
				}
			}
		}
	}
	//市匹配，省允许为空
	For indMatchType=1:1:2 {			//1:全匹配 2:模糊匹配(不带省/市/县/乡关键字)
		Quit:(CityDr'="")&&(CityDesc'="")
		
		For indProvince=1:1:99 {
			Set ProvinceCode=indProvince
			Set:$l(ProvinceCode)<2 ProvinceCode="0"_ProvinceCode
			Continue:($l(ParentCode)>=2)&&($e(ParentCode,1,2)'=ProvinceCode)
			
			For indCity=1:1:99 {
				Set CityCode=indCity
				Set:$l(CityCode)<2 CityCode="0"_CityCode
				
				Set ID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_ProvinceCode_CityCode_"0000",0))
				Continue:ID=""
				Set obj=##Class(DHCMed.EPD.AreaDic).GetObjById(ID)
				Continue:'$IsObject(obj)
				Set IsActive=obj.IsActive
				Continue:IsActive'=1
				Set ShortDesc=obj.ShortDesc
				Set ShortDesc=$tr(ShortDesc," ","")
				
				If (indMatchType=1)&&(Address[ShortDesc) {
					Set CityDr=ID
					Set CityDesc=ShortDesc
					Set ParentCode=ProvinceCode_CityCode
					Set Address=$p(Address,ShortDesc,2)
					Quit
				}
				If (indMatchType=2) {
					Set ShortDesc2=ShortDesc
					If $e(ShortDesc2,*,*)="市" {
						Set ShortDesc2=$e(ShortDesc2,1,*-1)
					} ElseIf $e(ShortDesc2,*,*)="区" {
						Set ShortDesc2=$e(ShortDesc2,1,*-1)
					}
					If Address[ShortDesc2 {
						Set CityDr=ID
						Set CityDesc=ShortDesc
						Set ParentCode=ProvinceCode_CityCode
						Set Address=$p(Address,ShortDesc2,2)
						Quit
					}
				}
			}
		}
	}
	If (CityDr'="")&&(ProvinceDr="") {
		Set ID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_$e(ParentCode,1,2)_"000000",0))
		If ID'="" {
			Set obj=##Class(DHCMed.EPD.AreaDic).GetObjById(ID)
			If $IsObject(obj){
				Set ProvinceDr=ID
				Set ProvinceDesc=obj.ShortDesc
			}
		}
	}
	//县匹配，省不允许为空，市允许为空
	If ProvinceDr'="" {
		Set ProvinceCode=$e(ParentCode,1,2)
		For indMatchType=1:1:2 {				//1:全匹配 2:模糊匹配(不带省/市/县/乡关键字)
			Quit:(CountyDr'="")&&(CountyDesc'="")
			
			For indCity=1:1:99 {
				Set CityCode=indCity
				Set:$l(CityCode)<2 CityCode="0"_CityCode
				Continue:($l(ParentCode)>=4)&&($e(ParentCode,3,4)'=CityCode)
				
				For indCounty=1:1:99 {
					Set CountyCode=indCounty
					Set:$l(CountyCode)<2 CountyCode="0"_CountyCode
					
					Set ID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_ProvinceCode_CityCode_CountyCode_"00",0))
					Continue:ID=""
					Set obj=##Class(DHCMed.EPD.AreaDic).GetObjById(ID)
					Continue:'$IsObject(obj)
					Set IsActive=obj.IsActive
					Continue:IsActive'=1
					Set ShortDesc=obj.ShortDesc
					Set ShortDesc=$tr(ShortDesc," ","")
					
					If (indMatchType=1)&&(Address[ShortDesc) {
						Set CountyDr=ID
						Set CountyDesc=ShortDesc
						Set ParentCode=ProvinceCode_CityCode_CountyCode
						Set Address=$p(Address,ShortDesc,2)
						Quit
					} 
					If (indMatchType=2) {
						Set ShortDesc2=ShortDesc
						If $e(ShortDesc2,*,*)="市" {
							Set ShortDesc2=$e(ShortDesc2,1,*-1)
						} ElseIf $e(ShortDesc2,*,*)="区" {
							Set ShortDesc2=$e(ShortDesc2,1,*-1)
						} ElseIf $e(ShortDesc2,*,*)="县" {
							Set ShortDesc2=$e(ShortDesc2,1,*-1)
						}
						If Address[ShortDesc2 {
							Set CountyDr=ID
							Set CountyDesc=ShortDesc
							Set ParentCode=ProvinceCode_CityCode_CountyCode
							Set Address=$p(Address,ShortDesc2,2)
							Quit
						}
					}
				}
			}
		}
	}
	If (CountyDr'="")&&(CityDr="") {
		Set ID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_$e(ParentCode,1,4)_"0000",0))
		If ID'="" {
			Set obj=##Class(DHCMed.EPD.AreaDic).GetObjById(ID)
			If $IsObject(obj){
				Set CityDr=ID
				Set CityDesc=obj.ShortDesc
			}
		}
	}
	//乡匹配，省市县都不允许为空
	If CountyDr'="" {
		Set ProvinceCode=$e(ParentCode,1,2)
		Set CityCode=$e(ParentCode,3,4)
		Set CountyCode=$e(ParentCode,5,6)
		
		For indMatchType=1:1:2 {				//1:全匹配 2:模糊匹配(不带省/市/县/乡关键字)
			Quit:(VillageDr'="")&&(VillageDesc'="")
			
			For indVillage=1:1:99 {
				Set VillageCode=indVillage
				Set:$l(VillageCode)<2 VillageCode="0"_VillageCode
				
				Set ID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_ProvinceCode_CityCode_CountyCode_VillageCode,0))
				Continue:ID=""
				Set obj=##Class(DHCMed.EPD.AreaDic).GetObjById(ID)
				Continue:'$IsObject(obj)
				Set IsActive=obj.IsActive
				Continue:IsActive'=1
				Set ShortDesc=obj.ShortDesc
				Set ShortDesc=$tr(ShortDesc," ","")
				
				If (indMatchType=1)&&(Address[ShortDesc) {
					Set VillageDr=ID
					Set VillageDesc=ShortDesc
					Set VillageTxt=$p(Address,ShortDesc,2)
					Quit
				}
				If (indMatchType=2) {
					Set ShortDesc2=ShortDesc
					If ShortDesc2["乡" {
						Set ShortDesc2=$e(ShortDesc2,1,*-1)
					} ElseIf ShortDesc2["镇" {
						Set ShortDesc2=$e(ShortDesc2,1,*-1)
					} ElseIf ShortDesc2["街道" {
						Set ShortDesc2=$e(ShortDesc2,1,*-2)
					} ElseIf ShortDesc2["社区" {
						Set ShortDesc2=$e(ShortDesc2,1,*-2)
					} ElseIf ShortDesc2["办事处" {
						Set ShortDesc2=$e(ShortDesc2,1,*-3)
					}
					
					If Address[ShortDesc2 {
						Set VillageDr=ID
						Set VillageDesc=ShortDesc
						Set VillageTxt=$p(Address,ShortDesc2,2)
						Quit
					}
				}
			}
		}
	}
	
	Set return=ProvinceDr_"^"_ProvinceDesc_"^"_CityDr_"^"_CityDesc_"^"_CountyDr_"^"_CountyDesc_"^"_VillageDr_"^"_VillageDesc_"^"_VillageTxt
	Quit return
}

Storage Default
{
<Data name="AreaDicSrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPDService.AreaDicSrvD</DataLocation>
<DefaultData>AreaDicSrvDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.EPDService.AreaDicSrvD</IdLocation>
<IndexLocation>^DHCMed.EPDService.AreaDicSrvI</IndexLocation>
<StreamLocation>^DHCMed.EPDService.AreaDicSrvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
