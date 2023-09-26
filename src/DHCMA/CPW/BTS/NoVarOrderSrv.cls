/// 名称: DHCMA.CPW.BTS.NoVarOrderSrv
/// 描述: 非变异医嘱 服务类
/// 编写者：zqy
/// 编写日期: 2023-04-18
Class DHCMA.CPW.BTS.NoVarOrderSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zqy
/// CreatDate：   2023-04-18
/// Description:  医嘱大类
/// Table：      
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.NoVarOrderSrv","QryOrCatDesc","")
Query QryOrCatDesc(q As %String = "", aHospID As %String = "") As %Query(ROWSPEC = "BTID:%String,BTDesc:%String")
{
}

ClassMethod QryOrCatDescExecute(ByRef qHandle As %Binary, q As %String = "", aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set Desc=""
	For{
		Set Desc=$o(^OEC("ORCAT",0,"Desc",Desc))
		Quit:Desc=""
		Continue:(q'="")&&(Desc'[q)
		Set xID=""
		For{
			Set xID=$o(^OEC("ORCAT",0,"Desc",Desc,xID))
			Quit:xID=""
			Set Data=$lb(xID,Desc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryOrCatDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOrCatDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOrCatDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOrCatDescExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zqy
/// CreatDate：   2023-04-18
/// Description:  医嘱子类
/// Table：      
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.NoVarOrderSrv","QryICDesc","")
Query QryICDesc(q As %String = "", aHospID As %String = "") As %Query(ROWSPEC = "BTID:%String,BTDesc:%String")
{
}

ClassMethod QryICDescExecute(ByRef qHandle As %Binary, q As %String = "", aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set Desc=""
	For{
		Set Desc=$o(^ARC("IC",0,"Desc",Desc))
		Quit:Desc=""
		Continue:(q'="")&&(Desc'[q)
		Set xID=""
		For{
			Set xID=$o(^ARC("IC",0,"Desc",Desc,xID))
			Quit:xID=""
			Set Data=$lb(xID,Desc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryICDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDescExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zqy
/// CreatDate：   2023-04-18
/// Description:  医嘱项目
/// Table：      
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.NoVarOrderSrv","QryArcimDesc","wss","2")
Query QryArcimDesc(q As %String = "", aHospID As %String) As %Query(ROWSPEC = "BTID:%String,BTDesc:%String")
{
}

ClassMethod QryArcimDescExecute(ByRef qHandle As %Binary, q As %String = "", aHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Set Array=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("DHCMA.CPW.BTS.LinkArcimSrv","QryArcimByAlias",q,aHospID)
	
	For Index=1:1:Array.Count() {
		Set Info=Array.GetAt(Index)
		Set ID=Info.GetAt("ArcimID")
		Set Desc=Info.GetAt("ArcimDesc")
		Set Data=$lb(ID,Desc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryArcimDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryArcimDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryArcimDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryArcimDescExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zqy
/// CreatDate：   2023-04-18
/// Description:  查询维护的医嘱
/// Table：       DHCMA.CPW.BT.NoVarOrder
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.NoVarOrderSrv","QryNoVarOrder","","H","2!!1")
Query QryNoVarOrder(q As %String = "", aLevel As %String, aLevelType As %String) As %Query(ROWSPEC = "BTID:%String,BTDesc:%String,BTType:%String,BTLevelType:%String")
{
}

ClassMethod QryNoVarOrderExecute(ByRef qHandle As %Binary, q As %String = "", aLevel As %String, aLevelType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aLevel="")||(aLevelType="") $$$OK
	Set Len=$l(aLevelType,",")
	For index=1:1:Len{
		Set xLevelType=$p(aLevelType,",",index)
		Continue:xLevelType=""
		Set xARCType=""
	 	For {
			Set xARCType        = $o(^DHCMA.CPW.BT.NoVarOrderI("IdxofLType",aLevel,xLevelType,xARCType))
			Quit:xARCType=""
			Set xID=""
	 		For {
				Set xID        = $o(^DHCMA.CPW.BT.NoVarOrderI("IdxofLType",aLevel,xLevelType,xARCType,xID))
				Quit:xID=""
			 	Set obj        = ##class(DHCMA.CPW.BT.NoVarOrder).GetObjById(xID)
			 	Continue:'$IsObject(obj)
			 	Set ARCID       = obj.BTARCID
			 	if (obj.BTARCType="M"){
				 	Set ARCInfo = ##class(DHCMA.CPW.BTS.LinkArcimSrv).GetArcimInfoById(ARCID)
			 		Set ArcimDesc = $p(ARCInfo,"^",20)  //医嘱名
				}elseif(obj.BTARCType="G"){
					Set ArcimDesc = $p(^OEC("ORCAT",ARCID),"^",2)
				}elseif(obj.BTARCType="C"){
					Set ArcimDesc = $p(^ARC("IC",ARCID),"^",2)
				}
				 	
			 	if (aLevel="H"){
					Set:xLevelType'["!!" xLevelType=xLevelType_"!!1"
					Set Typeobj=##class(DHCMA.Util.EP.Hospital).GetObjByOID(xLevelType)
				}elseif (aLevel="L"){
					Set:xLevelType'["!!" xLevelType=xLevelType_"!!1"
					Set Typeobj=##class(DHCMA.Util.EP.Location).GetObjByOID(xLevelType)
				}elseif (aLevel="T"){
					Set Typeobj=##class(DHCMA.CPW.BT.PathType).GetObjById(xLevelType)
				}elseif (aLevel="P"){
					Set Typeobj=##class(DHCMA.CPW.BT.PathMast).GetObjById(xLevelType)
				}
				Quit:'$IsObject(Typeobj) 
				Set LevelTypeDesc=Typeobj.BTDesc
				Continue:(q'="")&&((ArcimDesc'[q)&&(LevelTypeDesc'[q))
				Set ARCType=obj.BTARCType
				Set ARCType=$Case(ARCType,"G":"医嘱大类","C":"医嘱子类","M":"医嘱项")
				Set Data=$lb(xID,ArcimDesc,ARCType,LevelTypeDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
		 	}
	 	}
		
	}

	Quit $$$OK
}

ClassMethod QryNoVarOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNoVarOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNoVarOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNoVarOrderExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
