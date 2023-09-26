/// 名称: DHCHAI.BTS.DicTypeSrv
/// 描述: 字典类型相关服务
/// 编写者：pylian
/// 编写日期: 2017-03-23
Class DHCHAI.BTS.DicTypeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-03-23
/// Description:  查询字典类型
/// Table：       DHCHAI.BT.DicType
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.DicTypeSrv","QryDicType")
Query QryDicType() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod QryDicTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.BT.DicTypeD(xID))
		Quit:xID=""
		
		Set objDic = ##class(DHCHAI.BT.DicType).GetObjById(xID)
		Continue:'$Isobject(objDic)
		
		Set Code = objDic.BTCode
		Set Desc = objDic.BTDesc
				
		Set Data = $lb(xID,Code,Desc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryDicTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicTypeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDicTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicTypeExecute ]
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
/// CreatDate：   2017-03-22
/// Description:  根据类型代码查询字典
/// Table：       DHCHAI.BT.DicType
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.DicTypeSrv","QryTypeByCode","LocType")
Query QryTypeByCode(aCode As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod QryTypeByCodeExecute(ByRef qHandle As %Binary, aCode As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.BT.DicTypeI("IdxofCode",aCode,xID))
		Quit:xID=""
	
		Set objDicType = ##class(DHCHAI.BT.DicType).GetObjById(xID)
		Continue:'$Isobject(objDicType)
		
		Set Code = objDicType.BTCode
		Set Desc = objDicType.BTDesc
				
		Set Data = $lb(xID,Code,Desc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryTypeByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTypeByCodeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTypeByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTypeByCodeExecute ]
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
/// CreatDate：   2017-03-23
/// Description:  根据类型代码查询字典
/// Table：       DHCHAI.BT.DicType,DHCHAI.BT.Dictionary
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.DicTypeSrv","QryDicByCode","LocType")
Query QryDicByCode(aCode As %String) As %Query(ROWSPEC = "ID:%String,DicCode:%String,DicDesc:%String,TypeCode:%String,TypeDesc:%String,IndNo:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod QryDicByCodeExecute(ByRef qHandle As %Binary, aCode As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aCode="" $$$OK
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.BT.DicTypeI("IdxofCode",aCode,xID))
		Quit:xID=""
	
		Set objDicType = ##class(DHCHAI.BT.DicType).GetObjById(xID)
		Continue:'$isobject(objDicType)
		Set TypeCode = objDicType.BTCode
		Set TypeDesc = objDicType.BTDesc
		
		Set xDicCode=0	
		For {
			Set xDicCode=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",xID,xDicCode))
			Quit:xDicCode=""
			Set xDicID=0	
			For {
				Set xDicID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",xID,xDicCode,xDicID))
				Quit:xDicID=""
				Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(xDicID)
				Continue:'$Isobject(objDic)
				
				Set DicCode  = objDic.BTCode	   
			    Set DicDesc  = objDic.BTDesc	
			    Set IndNo    = objDic.BTIndNo
			    Set IsActive = objDic.BTIsActive	
                Set IsActive=$s(IsActive=1:"是",1:"否")
				Set Data=$lb(xDicID,DicCode,DicDesc,TypeCode,TypeDesc,IndNo,IsActive)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryDicByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicByCodeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDicByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicByCodeExecute ]
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
/// CreatDate：   2017-03-24
/// Description:  导入基础字典类别
/// w ##Class(DHCHAI.BTS.DicTypeSrv).ImportDicType("","^")
ClassMethod ImportDicType(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return

	Set Code    = $p(aInputStr,aSeparate,2)
	Set Desc    = $p(aInputStr,aSeparate,3)
	
	Set TypeRowID=""
	Set TypeID=0
	For {
		Set TypeID=$o(^DHCHAI.BT.DicTypeI("IdxofCode",Code,TypeID))
		Quit:TypeID=""
		Set objDicType=##class(DHCHAI.BT.DicType).GetObjById(TypeID)
		Continue:'$IsObject(objDicType)
		Set TypeRowID=TypeID
	}	
	Set InputStr=TypeRowID_aSeparate_Code_aSeparate_Desc
	Set return=##Class(DHCHAI.BT.DicType).Update(InputStr,aSeparate)
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-03-24
/// Description:  删除基础字典类别
/// w ##Class(DHCHAI.BTS.DicTypeSrv).DeleteDicType("LocCate")
ClassMethod DeleteDicType(aTypeCode As %String) As %String
{
	New (aTypeCode)
	Set return=-1
	Quit:aTypeCode="" return
	
	Set $ZT="DeleteDicTypeErr"
	
	Set xTypeID=0
	For {
		Set xTypeID = $o(^DHCHAI.BT.DicTypeI("IdxofCode",aTypeCode,xTypeID))
		Quit:xTypeID=""

		Set xCode=0
		For {
			Set xCode =$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",xTypeID,xCode))
			Quit:xCode=""
		   
			Set xDicID=0
			For {
				Set xDicID =$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",xTypeID,xCode,xDicID))
				Quit:xDicID=""
			
				Set flg=##class(DHCHAI.BT.Dictionary).DeleteById(xDicID)
			}
		}
	
		Set flg=##class(DHCHAI.BT.DicType).DeleteById(xTypeID)
		
	}
	Set return=1
	Quit return
	
DeleteDicTypeErr
	Write "Error:"_$ZError,!
	Quit -999
}

/// Creator：     pylian
/// CreatDate：   2017-03-23
/// Description:  查询字典类型
/// Table：       DHCHAI.BT.DicType
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.DicTypeSrv","QrySortDicType")
Query QrySortDicType() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod QrySortDicTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Kill arrDicType
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.BT.DicTypeD(xID))
		Quit:xID=""
		
		Set objDic=##class(DHCHAI.BT.DicType).GetObjById(xID)
		Continue:'$Isobject(objDic)
		
		Set Code = objDic.BTCode
		Set Desc = objDic.BTDesc
				
		Set Data = $lb(xID,Code,Desc)
		Set arrDicType(Desc_xID)=Data
	}
	Set xDesc=""
	For {
		Set xDesc=$o(arrDicType(xDesc))
		Quit:xDesc=""
		Set Data=$g(arrDicType(xDesc))
		Continue:Data=""
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill arrDicType
	
	Quit $$$OK
}

ClassMethod QrySortDicTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySortDicTypeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySortDicTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySortDicTypeExecute ]
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

}
