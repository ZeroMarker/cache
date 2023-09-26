/// 名称：DHCMA.Util.BTS.AreaIODicMapSrv
/// 描述：省市县乡字典对照服务
/// 编写者：pylian
/// 编写日期: 2021-01-15
Class DHCMA.Util.BTS.AreaIODicMapSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2021-01-15
/// Description:  查询省市县乡字典数据类型
/// Table：       DHCMA.Util.BT.AreaIODictionary       
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.BTS.AreaIODicMapSrv","QryAreaSource")
Query QryAreaSource() As %Query(ROWSPEC = "ind:%String,Source:%String") [ SqlProc ]
{
}

ClassMethod QryAreaSourceExecute(ByRef qHandle As %Binary, aSource As %String, aAlias As %String, aIsActive As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xSource = ""
	For {
		Set xSource = $o(^CF.MA.Util.BT.AreaIODictionaryI("IndexSrcIDCode",xSource))
		Quit:xSource=""
        Set Source =$tr(xSource," ","")
    	Set Data = $lb(ind,Source)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryAreaSourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAreaSourceExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAreaSourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAreaSourceExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-01-15
/// Description:  查询省市县乡字典接口数据
/// Table：       DHCMA.Util.BT.AreaIODictionary       
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.BTS.AreaIODicMapSrv","QryAreaIODic","")
Query QryAreaIODic(aSource As %String, aAlias As %String, aIsActive As %String = "1") As %Query(ROWSPEC = "ID:%String,Source:%String,IDCode:%String,Code:%String,Desc:%String,IsActive:%String,IsActDesc:%String") [ SqlProc ]
{
}

ClassMethod QryAreaIODicExecute(ByRef qHandle As %Binary, aSource As %String, aAlias As %String, aIsActive As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aSource="" $$$OK
	Set xIDCode = ""
	For {
		Set xIDCode = $o(^CF.MA.Util.BT.AreaIODictionaryI("IndexSrcIDCode"," "_$ZCVT(aSource,"U"),xIDCode))
		Quit:xIDCode=""

		Set xID = ""
		For {
			Set xID = $o(^CF.MA.Util.BT.AreaIODictionaryI("IndexSrcIDCode"," "_$ZCVT(aSource,"U"),xIDCode,xID))
			Quit:xID=""

			Set AreaDic = $g(^CF.MA.Util.BT.AreaIODictionaryD(xID))
			Continue:AreaDic=""
			Set IDCode=$lg(AreaDic,3)
			Set Code=$lg(AreaDic,4)
			Set Desc=$lg(AreaDic,5)
			Continue:(aAlias'="")&&(Desc'[aAlias)
			Set IsActive=$lg(AreaDic,6)
			Continue:(aIsActive'="")&&(aIsActive'=IsActive)
        	Set IsActDesc=$s(IsActive=1:"是",1:"否")
        	 
        	Set Data = $lb(xID,aSource,IDCode,Code,Desc,IsActive,IsActDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
            
	   	}
	}
	Quit $$$OK
}

ClassMethod QryAreaIODicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAreaIODicExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAreaIODicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAreaIODicExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-01-15
/// Description:  查询省市县乡字典对照数据
/// Table：       DHCMA.Util.BT.AreaIOMapping
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.BTS.AreaIODicMapSrv","QryAreaIOMap")
Query QryAreaIOMap(aAlias As %String, aIsActive As %String = "1") As %Query(ROWSPEC = "ID:%String,SrcID:%String,SrcCode:%String,SrcDesc:%String,IsActive:%String,IsActDesc:%String,Source:%String,TargetID:%String,TargetCode:%String,TargetDesc:%String") [ SqlProc ]
{
}

ClassMethod QryAreaIOMapExecute(ByRef qHandle As %Binary, aAlias As %String, aIsActive As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^CF.MA.Util.BT.AreaIOMappingD(xID))
		Quit:xID=""
		
		Set objMap = ##class(DHCMA.Util.BT.AreaIOMapping).GetObjById(xID)
		Continue:'$Isobject(objMap)
		Continue:'$Isobject(objMap.BTTargetDr)
		
		Set SrcID = objMap.BTSrcID
		Set SrcCode = objMap.BTSrcCode
		Set SrcDesc = objMap.BTSrcDesc
 		Set IsActive = objMap.BTIsActive
		Continue:(aIsActive'="")&&(aIsActive'=IsActive)
    	Set IsActDesc=$s(IsActive=1:"是",1:"否")
    	Set TargetID = objMap.BTTargetDr.%Id()
    	Set objAreaDic = ##class(DHCMA.Util.BT.AreaIODictionary).GetObjById(TargetID)
		Continue:'$Isobject(objAreaDic)			
		Set Source = objAreaDic.BTSource
		Set TargetCode = objAreaDic.BTCode
		Set TargetDesc = objAreaDic.BTDesc
        Continue:(aAlias'="")&&(SrcDesc'[aAlias)&&(TargetDesc'[aAlias)
 
    	Set Data = $lb(xID,SrcID,SrcCode,SrcDesc,IsActive,IsActDesc,Source,TargetID,TargetCode,TargetDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1          
	   
	}
	Quit $$$OK
}

ClassMethod QryAreaIOMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAreaIOMapExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAreaIOMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAreaIOMapExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-01-15
/// Description:  查询省市县乡字典接口及对照数据
/// Table：       DHCMA.Util.BT.AreaIODictionary 、DHCMA.Util.BT.AreaIOMapping      
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.BTS.AreaIODicMapSrv","QryAreaIODicMap","HIS地址","","","")
Query QryAreaIODicMap(aSource As %String, aAlias As %String, aIsActive As %String = "1", aIsMap As %String = "") As %Query(ROWSPEC = "DicID:%String,Source:%String,IDCode:%String,Code:%String,Desc:%String,IsActive:%String,IsActDesc:%String,MapID:%String,SrcID:%String,SrcCode:%String,SrcDesc:%String") [ SqlProc ]
{
}

ClassMethod QryAreaIODicMapExecute(ByRef qHandle As %Binary, aSource As %String, aAlias As %String, aIsActive As %String = "1", aIsMap As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aSource="" $$$OK
	Set xIDCode = ""
	For {
		Set xIDCode = $o(^CF.MA.Util.BT.AreaIODictionaryI("IndexSrcIDCode"," "_$ZCVT(aSource,"U"),$ZCVT(xIDCode,"U")))
		Quit:xIDCode=""

		Set xDicID = ""
		For {
			Set xDicID = $o(^CF.MA.Util.BT.AreaIODictionaryI("IndexSrcIDCode"," "_$ZCVT(aSource,"U"),$ZCVT(xIDCode,"U"),xDicID))
			Quit:xDicID=""
		
			Set objAreaDic = ##class(DHCMA.Util.BT.AreaIODictionary).GetObjById(xDicID)
			Continue:'$Isobject(objAreaDic)
			
			Set IDCode = objAreaDic.BTIDCode
			Set Code   = objAreaDic.BTCode
			Set Desc   = objAreaDic.BTDesc
			Set IsActive = objAreaDic.BTIsActive
			Continue:(aIsActive'="")&&(aIsActive'=IsActive)
        	Set IsActDesc=$s(IsActive=1:"是",1:"否")
        	
        	Set (xMapID,SrcID,SrcCode,SrcDesc)=""
        	Set xMapID = $o(^CF.MA.Util.BT.AreaIOMappingI("IdxofTargetDr",xDicID,xMapID))
        	If (xMapID'="") {
				Set objMap = ##class(DHCMA.Util.BT.AreaIOMapping).GetObjById(xMapID)
				Continue:'$Isobject(objMap)
				Continue:'$Isobject(objMap.BTTargetDr)
				
				Set SrcID = objMap.BTSrcID
				Set SrcCode = objMap.BTSrcCode
				Set SrcDesc = objMap.BTSrcDesc
		    }
		    Continue:(aIsMap=1)&&(xMapID="")   //已对照
		    Continue:(aIsMap=0)&&(xMapID'="")  //未对照
 		    Continue:((aAlias'="")&&(Desc'[aAlias)&&(SrcDesc'[aAlias))
		    
		   	Set Data = $lb(xDicID,aSource,IDCode,Code,Desc,IsActive,IsActDesc,xMapID,SrcID,SrcCode,SrcDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	   	}
	}
	Quit $$$OK
}

ClassMethod QryAreaIODicMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAreaIODicMapExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAreaIODicMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAreaIODicMapExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-01-15
/// Description:  同步his地址
/// Table：       CT_Province、CT_City、CT_CityArea、CT_Address
/// Return：      正常：处理数据条数
/// w ##Class(DHCMA.Util.BTS.AreaIODicMapSrv).SynHISAreaDic()
ClassMethod SynHISAreaDic() As %String
{
	Set return=0
	Set Count=0
	
	Set xProvID=""
	For {
		Set xProvID=$o(^CT("PROV",xProvID))   //省  ^CT("PROV")
		Quit:xProvID=""
		Set Province=$g(^CT("PROV",xProvID))
		Continue:Province=""
		Set ProvCode =$p(Province,"^",1)
		Set ProvDesc =$p(Province,"^",2)
		Continue:ProvDesc=""
	
		Set InputStr=""
		Set InputStr=InputStr_"^"_"HIS地址"
		Set InputStr=InputStr_"^"_xProvID_"||"_ProvCode
		Set InputStr=InputStr_"^"_ProvCode
		Set InputStr=InputStr_"^"_ProvDesc
		Set InputStr=InputStr_"^"_1
		Set Flg = ##Class(DHCMA.Util.BT.AreaIODictionary).Update(InputStr,"^")	
		If (Flg>0) {
			Set Count=Count+1
		}
		
		Set xCityCode=""
		For {
			Set xCityCode=$o(^CT("CIT",0,"ProvCode",xProvID,$ZCVT(xCityCode,"U")))   //市
			Quit:xCityCode=""
			Set xCityID=""
			For {
				Set xCityID=$o(^CT("CIT",0,"ProvCode",xProvID,$ZCVT(xCityCode,"U"),xCityID))   
				Quit:xCityID=""
				Set CityInfo=$g(^CT("CIT",xCityID))
				Continue:CityInfo=""
				Set CityCode =$p(CityInfo,"^",1)
				Set CityDesc =$p(CityInfo,"^",2)
				Continue:CityDesc=""
			
				Set InputStr=""
				Set InputStr=InputStr_"^"_"HIS地址"
				Set InputStr=InputStr_"^"_xCityID_"||"_CityCode
				Set InputStr=InputStr_"^"_CityCode
				Set InputStr=InputStr_"^"_CityDesc
				Set InputStr=InputStr_"^"_1
				Set Flg = ##Class(DHCMA.Util.BT.AreaIODictionary).Update(InputStr,"^")
				If (Flg>0) {
					Set Count=Count+1
				}
				
				Set xAreaCode=""
				For {
					Set xAreaCode=$o(^CT("CITAREA",0,"CityCode",xCityID,$ZCVT(xAreaCode,"U")))   //县/区
					Quit:xAreaCode=""
					Set xAreaID=""
					For {
						Set xAreaID=$o(^CT("CITAREA",0,"CityCode",xCityID,$ZCVT(xAreaCode,"U"),xAreaID))   
						Quit:xAreaID=""
						Set AreaInfo=$g(^CT("CITAREA",xAreaID))
						Continue:AreaInfo=""
						Set AreaCode =$p(AreaInfo,"^",1)
						Set AreaDesc =$p(AreaInfo,"^",2)
						Continue:AreaDesc=""
						
						Set InputStr=""
						Set InputStr=InputStr_"^"_"HIS地址"
						Set InputStr=InputStr_"^"_xAreaID_"||"_AreaCode
						Set InputStr=InputStr_"^"_AreaCode
						Set InputStr=InputStr_"^"_AreaDesc
						Set InputStr=InputStr_"^"_1
						Set Flg = ##Class(DHCMA.Util.BT.AreaIODictionary).Update(InputStr,"^")	
						If (Flg>0) {
							Set Count=Count+1
						}
						
						Set xAddressID=""
						For {
							Set xAddressID=$o(^CT("ADD",0,"CityArea",xAreaID,xAddressID))   //详细地址
							Quit:xAddressID=""
							
							Set Address=$g(^CT("ADD",xAddressID))
							Continue:Address=""
							Set AddressCode =$p(Address,"^",1)
							Set AddressDesc =$p(Address,"^",2)
							Continue:AddressDesc=""
								
							Set InputStr=""
							Set InputStr=InputStr_"^"_"HIS地址"
							Set InputStr=InputStr_"^"_xAddressID_"||"_AddressCode
							Set InputStr=InputStr_"^"_AddressCode
							Set InputStr=InputStr_"^"_AddressDesc
							Set InputStr=InputStr_"^"_1
							Set Flg = ##Class(DHCMA.Util.BT.AreaIODictionary).Update(InputStr,"^")	
							
							If (Flg>0) {
								Set Count=Count+1
							}

						}
					}
				}
					
			}
		}	
	}
	
	Set return=Count
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-01-15
/// Description:  同名自动匹配对照规则
/// Table：       DHCMA.Util.BT.AreaIODictionary、DHCMA.Util.BT.AreaIOMapping、DHCMed.SS.AreaDic
/// Input：		  aSource：数据来源
/// Return：      正常：处理数据条数
/// w ##Class(DHCMA.Util.BTS.AreaIODicMapSrv).SynMapDic("HIS地址")
ClassMethod SynMapDic(aSource As %String) As %String
{
	New (aSource)
	Set return=""
	Quit:(aSource="") return

	Set Count=0
	Set xID=""
	For {
		Set xID=$o(^DHCMed.SS.AreaDicD(xID))
		Quit:xID=""
		Set AreaDic=$g(^DHCMed.SS.AreaDicD(xID))
		Continue:AreaDic=""
		Set Code=$lg(AreaDic,2)
		Set ShortDesc=$lg(AreaDic,3)
		Set LongDesc=$lg(AreaDic,4)
		Set IsActive=$lg(AreaDic,9)
		Continue:IsActive'=1				

		Set xDicID = 0	
		Set xDicID = $o(^CF.MA.Util.BT.AreaIODictionaryI("IndexSrcDesc"," "_$ZCVT(aSource,"U")," "_LongDesc,xDicID))
		Continue:xDicID=""
	
		Set AreaInfo=$g(^CF.MA.Util.BT.AreaIODictionaryD(xDicID))
		Continue:AreaInfo=""
		Continue:$lg(AreaInfo,6)'=1
        Continue:$d(^CF.MA.Util.BT.AreaIOMappingI("IdxofTargetDr",xDicID)) //已经对照不再对照						
		Set InputStr=""
		Set InputStr=InputStr_"^"_xID
		Set InputStr=InputStr_"^"_Code
		Set InputStr=InputStr_"^"_ShortDesc
		Set InputStr=InputStr_"^"_xDicID
		Set InputStr=InputStr_"^"_1
		Set flg=##class(DHCMA.Util.BT.AreaIOMapping).Update(InputStr,"^")
        If flg>0{
			Set Count=Count+1
		}
	    
    }
    
    Set return=Count
	Quit return
}

}
