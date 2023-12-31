/// 名称: DHCHAI.IRS.OccExpTypeSrv
/// 描述: 院感公共模板类型定义服务
/// 编写者: zhoubo
/// 编写日期: 2022-10-11
Class DHCHAI.IRS.ComTemplateDefSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-10-11
/// Description:  查询公共模板类型
/// Table：       DHCHAI.IR.ComTemplateDef
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.ComTemplateDefSrv","QryComTempType","","1")
Query QryComTempType(aActive As %String = "", aRegTypeID As %String = "") As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,IsActive:%String,IsActDesc:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryComTempTypeExecute(ByRef qHandle As %Binary, aActive As %String = "", aRegTypeID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
		
	Set xID=0	
	For {
		Set xID=$o(^CT.MA.HAI.IR.ComTemplateDefD(xID))
		Quit:xID=""
		
		Continue:(aRegTypeID'="")&&(aRegTypeID'=xID)
		Set objExpType = ##class(DHCHAI.IR.ComTemplateDef).GetObjById(xID)
		Continue:'$Isobject(objExpType)
		Set Code 	  = objExpType.BTCode	   
	    Set Desc 	  = objExpType.BTDesc	   	
	    Set IsActive  = objExpType.BTIsActive
	    Continue:(aActive'="")&&(aActive'=IsActive)
		Set IsActDesc = $s(IsActive=1:"是",1:"否")
	    Set Resume    = objExpType.BTResume
	 
		Set Data=$lb(xID,Code,Desc,IsActive,IsActDesc,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}	
	
	Quit $$$OK
}

ClassMethod QryComTempTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryComTempTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryComTempTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryComTempTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     zhoubo
/// CreatDate：   2022-10-11
/// Description:  查询公共模板类型扩展项目分类
/// Table：       DHCHAI.IR.OccExpTypeExt
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.ComTemplateDefSrv","QryExpRegType","1")
Query QryExpRegType(aRegTypeID As %String) As %Query(ROWSPEC = "TypeID:%String,TypeCode:%String,TypeDesc:%String,IndNo:%String") [ SqlProc ]
{
}

ClassMethod QryExpRegTypeExecute(ByRef qHandle As %Binary, aRegTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aRegTypeID="") $$$OK
	//定义临时Global
	Set NIndex="QryExpRegType"
	Kill ^TMP($zn,$j,NIndex)
	
	Set xTypeID=0	
	For {
		Set xTypeID=$o(^CT.MA.HAI.IR.ComTemplateDefI("EXT","IndexType",aRegTypeID,xTypeID))
		Quit:xTypeID=""
	   
	    Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(xTypeID)
	    Continue:'$Isobject(objDic)
		Set TypeCode = objDic.BTCode
		Set TypeDesc = objDic.BTDesc
        Set IndNo    = objDic.BTIndNo
        Set:IndNo="" IndNo="999-"_TypeCode
        //存储数据
        Set Data=$lb(xTypeID,TypeCode,TypeDesc,IndNo)
        Set ^TMP($zn,$j,NIndex,"IndNo",IndNo)=Data
	}
	//按排序码输出数据
	Set xIndNo=""
	For{
		Set xIndNo=$o(^TMP($zn,$j,NIndex,"IndNo",xIndNo))
		Quit:xIndNo=""
		
		Set Data=$g(^TMP($zn,$j,NIndex,"IndNo",xIndNo))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryExpRegTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExpRegTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryExpRegTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExpRegTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     zhoubo
/// CreatDate：   2022-10-11
/// Description:  查询公共模板类型扩展项目
/// Table：       DHCHAI.IR.ComTempDefExt
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.ComTemplateDefSrv","QryComTempTypeExt","1",875)
Query QryComTempTypeExt(aTypeID As %String, aExtTypeID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String,DatID:%String,DatCode:%String,DatDesc:%String,DicID:%String,DicCode:%String,DicDesc:%String,IsRequired:%String") [ SqlProc ]
{
}

ClassMethod QryComTempTypeExtExecute(ByRef qHandle As %Binary, aTypeID As %String, aExtTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aTypeID="" $$$OK
		
	Set xCode=""
	For{
		Set xCode=$o(^CT.MA.HAI.IR.ComTemplateDefI("EXT","IndexCode",aTypeID,xCode))
		Quit:xCode=""
		
		Set xID=0
		For{
			Set xID=$o(^CT.MA.HAI.IR.ComTemplateDefI("EXT","IndexCode",aTypeID,xCode,xID))
			Quit:xID=""
			
			Set ExtID=aTypeID_"||"_xID
			Set objEXT = ##class(DHCHAI.IR.ComTempDefExt).GetObjById(ExtID)
			Continue:'$Isobject(objEXT)
			Set Code 	  = objEXT.BTCode	   
	    	Set Desc 	  = objEXT.BTDesc
	    	Set IsRequired = objEXT.BTIsRequired
	    	Set (TypeID,TypeCode,TypeDesc) = ""
			If $IsObject(objEXT.BTExtType) {	
				Set TypeID =  objEXT.BTExtType.%Id()  
				Set TypeCode = objEXT.BTExtType.BTCode
				Set TypeDesc = objEXT.BTExtType.BTDesc
	    	}	
	    	Continue:(aExtTypeID'="")&&(aExtTypeID'=TypeID)
	    	Set (DatID,DatCode,DatDesc) = ""
			If $IsObject(objEXT.BTDatType) {	
				Set DatID =  objEXT.BTDatType.%Id()  
				Set DatCode = objEXT.BTDatType.BTCode
				Set DatDesc = objEXT.BTDatType.BTDesc
	    	}
	    	Set (DicID,DicCode,DicDesc) = ""
			If $IsObject(objEXT.BTDicType) {	
				Set DicTypeID =  objEXT.BTDicType.%Id()  
				Set DicTypeCode = objEXT.BTDicType.BTCode
				Set DicTypeDesc = objEXT.BTDicType.BTDesc
				Set objDic=##class(DHCHAI.BT.Dictionary).GetObjByCode("BPDicType",DicTypeCode)
				If $IsObject(objDic) {
					Set DicID =  objDic.%Id()  
					Set DicCode = objDic.BTCode
					Set DicDesc = objDic.BTDesc
				}
	    	}
			Set Data=$lb(ExtID,Code,Desc,TypeID,TypeCode,TypeDesc,DatID,DatCode,DatDesc,DicID,DicCode,DicDesc,IsRequired)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryComTempTypeExtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryComTempTypeExtExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryComTempTypeExtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryComTempTypeExtExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     zhoubo
/// CreatDate：   2022-10-11
/// Description:  根据项目分类查询模板扩展项目
/// Table：       DHCHAI.IR.ComTempDefExt
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.ComTemplateDefSrv","QryExtByType","1","562")
Query QryExtByType(aTypeID As %String, aExtTypeID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String,DatID:%String,DatCode:%String,DatDesc:%String,DicID:%String,DicCode:%String,DicDesc:%String,IsRequired:%String") [ SqlProc ]
{
}

ClassMethod QryExtByTypeExecute(ByRef qHandle As %Binary, aTypeID As %String, aExtTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aTypeID="")||(aExtTypeID="") $$$OK
	//定义临时Global
	Set NIndex="QryExtByType"
	Kill ^TMP($zn,$j,NIndex)
	
	Set xID=0	
	For {
		Set xID=$o(^CT.MA.HAI.IR.ComTemplateDefI("EXT","IndexType",aTypeID,aExtTypeID,xID))
		Quit:xID=""
		
		Set ExtID=aTypeID_"||"_xID
		Set objEXT = ##class(DHCHAI.IR.ComTempDefExt).GetObjById(ExtID)
		Continue:'$Isobject(objEXT)
		Set Code 	  = objEXT.BTCode	   
	    Set Desc 	  = objEXT.BTDesc
	    Set IsRequired = objEXT.BTIsRequired
	   
	    Set (TypeID,TypeCode,TypeDesc) = ""
		If $IsObject(objEXT.BTExtType) {	
			Set TypeID =  objEXT.BTExtType.%Id()  
			Set TypeCode = objEXT.BTExtType.BTCode
			Set TypeDesc = objEXT.BTExtType.BTDesc
	    }	
	    Set (DatID,DatCode,DatDesc) = ""
		If $IsObject(objEXT.BTDatType) {	
			Set DatID =  objEXT.BTDatType.%Id()  
			Set DatCode = objEXT.BTDatType.BTCode
			Set DatDesc = objEXT.BTDatType.BTDesc
	    }
	    Set (DicID,DicCode,DicDesc) = ""
		If $IsObject(objEXT.BTDicType) {	
			Set DicTypeID =  objEXT.BTDicType.%Id()  
			Set DicTypeCode = objEXT.BTDicType.BTCode
			Set DicTypeDesc = objEXT.BTDicType.BTDesc
			Set objDic=##class(DHCHAI.BT.Dictionary).GetObjByCode("BPDicType",DicTypeCode)
			If $IsObject(objDic) {
				Set DicID =  objDic.%Id()  
				Set DicCode = objDic.BTCode
				Set DicDesc = objDic.BTDesc
			}
	    }
	    
		Set Data=$lb(ExtID,Code,Desc,TypeID,TypeCode,TypeDesc,DatID,DatCode,DatDesc,DicID,DicCode,DicDesc,IsRequired)
		//按Code排序
		Set IndCode=Code
		Set:IndCode="" IndCode="999999"
		Set ^TMP($zn,$j,NIndex,"IndCode",IndCode)=Data
	}
	//按排序码输出数据
	Set xIndCode=""
	For{
		Set xIndCode=$o(^TMP($zn,$j,NIndex,"IndCode",xIndCode))
		Quit:xIndCode=""
		
		Set Data=$g(^TMP($zn,$j,NIndex,"IndCode",xIndCode))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryExtByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExtByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryExtByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExtByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

}
