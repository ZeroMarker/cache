/// 名称: DHCHAI.IRS.PDCAModSrv
/// 描述: PDCA模板服务
/// 编写者：ShenC
/// 编写日期: 2022-08-22
Class DHCHAI.IRS.PDCAModSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2022-08-22
/// Description:  查询PDCA模板列表
/// Table：       DHCHAI.IR.PDCAMod
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.PDCAModSrv","QryPDCAModBase","1")
Query QryPDCAModBase(aIsActive As %String = "") As %Query(ROWSPEC = "Count:%String,ModID:%String,ModCode:%String,ModName:%String,IsActive:%String,ModResume:%String") [ SqlProc ]
{
}

ClassMethod QryPDCAModBaseExecute(ByRef qHandle As %Binary, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//序号
	Set Count=0
	
	Set xCode=""
	For{
		Set xCode=$o(^CT.MA.HAI.IR.PDCAModI("IndexCode",xCode))
		Quit:xCode=""
		
		Set xID=""
		For{
			Set xID=$o(^CT.MA.HAI.IR.PDCAModI("IndexCode",xCode,xID))
			Quit:xID=""
			
			Set PAModData=$g(^CT.MA.HAI.IR.PDCAModD(xID))
			Continue:PAModData=""
			
			Set ModName			=$lg(PAModData,3)		//模板名称
			Set IsActive		=$lg(PAModData,4)		//是否有效
			//过滤无效数据
			Continue:(aIsActive="1")&&(IsActive'="1")
			Set ModResume		=$lg(PAModData,5)		//模板备注
			
			//序号
			Set Count=Count+1
	
			Set Data=$lb(Count,xID,xCode,ModName,IsActive,ModResume)  
	   		Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryPDCAModBaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPDCAModBaseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPDCAModBaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPDCAModBaseExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2022-09-09
/// Description:  查询PDCA模板扩展项目
/// Table：       DHCHAI.IR.PDCAModExt
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.PDCAModSrv","QryPDCAExpTypeExt","")
Query QryPDCAExpTypeExt(aRegID As %String = "", aTypeID As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String,DatID:%String,DatCode:%String,DatDesc:%String,DicID:%String,DicCode:%String,DicDesc:%String,IsRequired:%String") [ SqlProc ]
{
}

ClassMethod QryPDCAExpTypeExtExecute(ByRef qHandle As %Binary, aRegID As %String = "", aTypeID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aRegID="" $$$OK
		
	Set xCode=""
	For{
		Set xCode=$o(^CT.MA.HAI.IR.PDCAModI("Ext","IndexCode",aRegID,xCode))
		Quit:xCode=""
		
		Set xID=0
		For{
			Set xID=$o(^CT.MA.HAI.IR.PDCAModI("Ext","IndexCode",aRegID,xCode,xID))
			Quit:xID=""
			
			Set ExtData=$g(^CT.MA.HAI.IR.PDCAModD(aRegID,"Ext",xID))
			Continue:ExtData=""
			Set Code 	  = $lg(ExtData,2)	 		//代码  
	    	Set Desc 	  = $lg(ExtData,3)	   		//名称
	    	Set TypeID 	  = $lg(ExtData,4)	   		//项目分类->ID
	    	//过滤项目类别
	    	Continue:(aTypeID'="")&&(TypeID'=aTypeID)
			If (TypeID'=""){	
				Set DicData=$g(^DHCHAI.BT.DictionaryD(TypeID))
	   			Continue:DicData=""
	   			Set TypeCode = $lg(DicData,2)		//项目分类->Code
				Set TypeDesc = $lg(DicData,3)		//项目分类->Desc
	    	}	
	    	Set DatID 	  = $lg(ExtData,5)	   		//数据格式->ID
			If (DatID'=""){	
				Set DicData=$g(^DHCHAI.BT.DictionaryD(DatID))
	   			Continue:DicData="" 
	   			Set DatCode = $lg(DicData,2)		//项目分类->Code
				Set DatDesc = $lg(DicData,3)		//项目分类->Desc
	    	}
	    	Set DicID 	  = $lg(ExtData,6)	   		//关联字典->ID
	    	If (DicID'=""){	
				Set DicData=$g(^DHCHAI.BT.DictionaryD(DicID))
	   			Continue:DicData="" 
	   			Set DicTypeCode = $lg(DicData,2)	//关联字典->Code
				Set DicTypeDesc = $lg(DicData,3)	//关联字典->Desc
	    	}
	    	
	    	Set IsRequired = $lg(ExtData,7)	   		//是否必填
	    	
			Set Data=$lb(aRegID_"||"_xID,Code,Desc,TypeID,TypeCode,TypeDesc,DatID,DatCode,DatDesc,DicID,DicCode,DicDesc,IsRequired)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryPDCAExpTypeExtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPDCAExpTypeExtExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPDCAExpTypeExtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPDCAExpTypeExtExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2022-09-09
/// Description:  查询PDCA模板扩展
/// Table：       DHCHAI.IR.PDCAModExt
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.PDCAModSrv","QryPDCAExpType","")
Query QryPDCAExpType(aRegID As %String = "") As %Query(ROWSPEC = "DicID:%String,DicCode:%String,DicDesc:%String") [ SqlProc ]
{
}

ClassMethod QryPDCAExpTypeExecute(ByRef qHandle As %Binary, aRegID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aRegID="" $$$OK
		
	Set xType=""
	For{
		Set xType=$o(^CT.MA.HAI.IR.PDCAModI("Ext","IndexType",aRegID,xType))
		Quit:xType=""
		
		Set DicData=$g(^DHCHAI.BT.DictionaryD(xType))
	   	Continue:DicData="" 
	   	Set DicCode = $lg(DicData,2)
		Set DicDesc = $lg(DicData,3)
			
		Set Data=$lb(xType,DicCode,DicDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryPDCAExpTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPDCAExpTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPDCAExpTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPDCAExpTypeExecute ]
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
