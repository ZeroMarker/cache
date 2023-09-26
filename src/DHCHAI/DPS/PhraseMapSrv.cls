/// 名称: DHCHAI.DPS.PhraseMapSrv
/// 描述: 常用短语对照相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-07-24
Class DHCHAI.DPS.PhraseMapSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-08-22
/// Description:  自动更新常用短语对照
/// Table：       DHCHAI.DP.PhraseMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap()
ClassMethod SavePhraseMap(aInputStr As %String, aSCode As %String) As %String
{
	New (aInputStr,aSCode)
	Set return=0
	Quit:(aInputStr="")||(aSCode="") return
	
	Set TypeCode   = $p(aInputStr,"^",1)
	Set PhraseCode = $p(aInputStr,"^",2)
	Set PhraseDesc = $p(aInputStr,"^",3)
	Quit:(TypeCode="")||(PhraseCode="") return
	
	Set objPhraseType=##class(DHCHAI.DP.PhraseType).GetObjByCodeDesc(TypeCode,"")
	Quit:'$IsObject(objPhraseType) return
	Set PhraseTypeID=objPhraseType.%Id()
	Set DicTypeCode=objPhraseType.BTDicType
	
	Set objPhraseMap=##class(DHCHAI.DP.PhraseMap).GetObjByCode(aSCode,PhraseTypeID,PhraseCode)
	If '$IsObject(objPhraseMap) {
		Set MapDicID=""
		Set objMapDic=##class(DHCHAI.BT.Dictionary).GetObjByCode(DicTypeCode,PhraseCode)
		Set:$IsObject(objMapDic) MapDicID=objMapDic.%Id()
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=""
		Set $p(InputStr,"^",2)=PhraseCode
		Set $p(InputStr,"^",3)=PhraseDesc
		Set $p(InputStr,"^",4)=PhraseTypeID
		Set $p(InputStr,"^",5)=MapDicID
		Set $p(InputStr,"^",6)=aSCode
		Set $p(InputStr,"^",7)=1
		Set $p(InputStr,"^",8)=""
		Set $p(InputStr,"^",9)=""
		Set $p(InputStr,"^",10)=""
		Set return=##class(DHCHAI.DP.PhraseMap).Update(InputStr,"^")
	} Else {
		Set return=objPhraseMap.%Id()
	}
	
	Quit return
}

/// Creator:     zhoubo
/// CreatDate:   2017-07-25
/// Description: 查询常用短语对照列表
/// Table:       DHCHAI.DP.PhraseMap
/// Input:
/// Return:      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.PhraseMapSrv","QryPhraseTypeMap")
Query QryPhraseTypeMap() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,PhraseTypeDr:%String,PhraseTypeCode:%String,PhraseTypeDesc:%String,MapDicDr:%String,MapDicCode:%String,MapDicDesc:%String,SCode:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryPhraseTypeMapExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.PhraseMapD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.PhraseMap).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set Code = obj.BTCode
	 	Set Desc = obj.BTDesc
	 	If $IsObject(obj.BTTypeDr) {
			Set PhraseTypeDr = obj.BTTypeDr.%Id()
			Set PhraseTypeCode = obj.BTTypeDr.BTCode
			Set PhraseTypeDesc = obj.BTTypeDr.BTDesc
		} Else {
			Set PhraseTypeDr = "",PhraseTypeCode = "",PhraseTypeDesc = ""
		}
		If $IsObject(obj.BTMapDicDr) {
			Set MapDicDr = obj.BTMapDicDr.%Id()
			Set MapDicCode = obj.BTMapDicDr.BTCode
			Set MapDicDesc = obj.BTMapDicDr.BTDesc
		} Else {
			Set MapDicDr = "",MapDicCode = "",MapDicDesc = ""
		}
	 	Set SCode = obj.BTSCode
		Set IsActive = obj.BTIsActive
		Set ActDate = obj.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime = obj.BTActTime
		Set:ActTime'="" ActTime = $zt(ActTime,1)
		Set ActUser = obj.BTActUser
		
		set Data=$lb(xID,Code,Desc,PhraseTypeDr,PhraseTypeCode,PhraseTypeDesc,MapDicDr,MapDicCode,MapDicDesc,SCode,IsActive,ActDate,ActTime,ActUser)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryPhraseTypeMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPhraseTypeMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPhraseTypeMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPhraseTypeMapExecute ]
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

/// Creator:     pylian
/// CreatDate:   2017-08-15
/// Description: 查询常用短语对照列表(维护使用)
/// Table:       DHCHAI.DP.PhraseMap
/// Input:       aTypeID:DHCHAI.DP.PhraseType.ID
/// Return:      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.PhraseMapSrv","QryPhraseMapByType","")
Query QryPhraseMapByType(aTypeID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,PhraseTypeDr:%String,PhraseTypeCode:%String,PhraseTypeDesc:%String,MapDicDr:%String,MapDicCode:%String,MapDicDesc:%String,SCode:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryPhraseMapByTypeExecute(ByRef qHandle As %Binary, aTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
    Quit:aTypeID="" $$$OK
    
    Set xSCode=""
    For {
	 	Set xSCode=$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",xSCode))
	 	Quit:xSCode=""
	
	 	Set xCode=""
	 	For {
		 	Set xCode=$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",xSCode,aTypeID,xCode))
		 	Quit:xCode=""
		 	
		 	Set xID=0
		 	For {
			 	Set xID=$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",xSCode,aTypeID,xCode,xID))
			 	Quit:xID=""
		 		
			 	Set obj=##class(DHCHAI.DP.PhraseMap).GetObjById(xID)
			 	Continue:'$IsObject(obj)
			 	
			 	Set Code = obj.BTCode
			 	Set Desc = obj.BTDesc
			 	If $IsObject(obj.BTTypeDr) {
					Set PhraseTypeDr = obj.BTTypeDr.%Id()
					Set PhraseTypeCode = obj.BTTypeDr.BTCode
					Set PhraseTypeDesc = obj.BTTypeDr.BTDesc
				} Else {
					Set PhraseTypeDr = "",PhraseTypeCode = "",PhraseTypeDesc = ""
				}
				If $IsObject(obj.BTMapDicDr) {
					Set MapDicDr = obj.BTMapDicDr.%Id()
					Set MapDicCode = obj.BTMapDicDr.BTCode
					Set MapDicDesc = obj.BTMapDicDr.BTDesc
				} Else {
					Set MapDicDr = "",MapDicCode = "",MapDicDesc = ""
				}
			 	Set SCode = obj.BTSCode
				Set IsActive = obj.BTIsActive
				Set ActDate = obj.BTActDate
				Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
				Set ActTime = obj.BTActTime
				Set:ActTime'="" ActTime = $zt(ActTime,1)
				Set ActUser = obj.BTActUser
				Continue:Code["||"
				set Data=$lb(xID,Code,Desc,PhraseTypeDr,PhraseTypeCode,PhraseTypeDesc,MapDicDr,MapDicCode,MapDicDesc,SCode,IsActive,ActDate,ActTime,ActUser)
		        Set ^CacheTemp(repid,ind)=Data
		        Set ind=ind+1
			}
	 	}
    }
	Quit $$$OK
}

ClassMethod QryPhraseMapByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPhraseMapByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPhraseMapByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPhraseMapByTypeExecute ]
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

/// Creator:     zhoubo
/// CreatDate:   2017-07-25
/// Description: 查询常用短语对应的标准字典列表（下拉框用）
/// Table:       DHCHAI.DP.PhraseMap
/// Input:
/// Return:      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.PhraseMapSrv","QryDicByPhraseTypeID","5")
Query QryDicByPhraseTypeID(aPTypeID As %String) As %Query(ROWSPEC = "ID:%String,DicCode:%String,DicDesc:%String,TypeCode:%String,TypeDesc:%String,IndNo:%String,IsActive:%String,IsActDesc:%String") [ SqlProc ]
{
}

ClassMethod QryDicByPhraseTypeIDExecute(ByRef qHandle As %Binary, aPTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set objPType=##class(DHCHAI.DP.PhraseType).GetObjById(aPTypeID)
	Quit:'$IsObject(objPType) $$$OK
	Set BTDicType=objPType.BTDicType
	Quit:BTDicType="" $$$OK
	Set objType=##class(DHCHAI.BT.DicType).GetObjByCode(BTDicType)
	Quit:'$IsObject(objType) $$$OK
	Set TypeID=objType.%Id()
 	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeID,xCode))
		Quit:xCode=""
		
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeID,xCode,xID))
			Quit:xID=""
			
			Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(xID)
			Continue:'$Isobject(objDic)
			
			Set DicCode  = objDic.BTCode
		    Set DicDesc  = objDic.BTDesc	
		    Set TypeCode="",TypeDesc=""
		    If $Isobject(objDic.BTTypeDr){
			    Set TypeCode=objDic.BTTypeDr.BTCode
			    Set TypeDesc=objDic.BTTypeDr.BTDesc
		    }
		    Set IndNo    = objDic.BTIndNo
		    Set IsActive = objDic.BTIsActive
	        Set IsActDesc=$s(IsActive=1:"是",1:"否")
			Set Data=$lb(xID,DicCode,DicDesc,TypeCode,TypeDesc,IndNo,IsActive,IsActDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryDicByPhraseTypeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicByPhraseTypeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDicByPhraseTypeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicByPhraseTypeIDExecute ]
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

/// Creator：     liutao
/// CreatDate：   2023-01-06
/// Description:  自动保存编目或首页常用短语对照
/// Table：       DHCHAI.DP.PhraseMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DPS.PhraseMapSrv).SaveMRPhraseMap()
ClassMethod SaveMRPhraseMap(aInputStr As %String, aSCode As %String) As %String
{
	New (aInputStr,aSCode)
	Set return=0
	Quit:(aInputStr="")||(aSCode="") return
	
	Set TypeCode      = $p(aInputStr,"^",1)
	Set PhraseCode    = $p(aInputStr,"^",2)
	Set PhraseDesc    = $p(aInputStr,"^",3)
	
	Quit:(TypeCode="")||(PhraseCode="") return
	
	Set objPhraseType=##class(DHCHAI.DP.PhraseType).GetObjByCodeDesc(TypeCode,"")
	Quit:'$IsObject(objPhraseType) return
	Set PhraseTypeID=objPhraseType.%Id()
	Set DicTypeCode=objPhraseType.BTDicType
	
	Set objPhraseMap=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(aSCode,TypeCode,PhraseDesc)
	If (objPhraseMap'="") {
		Set MapDicID=""
		Set MapDicID=$p(objPhraseMap,"^",1)
		Quit:MapDicID="" return
		Set InputStr=""
		Set $p(InputStr,"^",1)=""
		Set $p(InputStr,"^",2)=PhraseCode
		Set $p(InputStr,"^",3)=PhraseDesc
		Set $p(InputStr,"^",4)=PhraseTypeID
		Set $p(InputStr,"^",5)=MapDicID
		Set $p(InputStr,"^",6)="OPS01"
		Set $p(InputStr,"^",7)=1
		Set $p(InputStr,"^",8)=""
		Set $p(InputStr,"^",9)=""
		Set $p(InputStr,"^",10)=""
	
		Set return=##class(DHCHAI.DP.PhraseMap).Update(InputStr,"^")
	}
	Quit return
}

}
