/// 病案号码类型关联“科室、医院”条件设置
Class DHCWMR.SS.NoTypeLnk Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.SS.NoType [ Cardinality = parent, Inverse = ChildLnk ];

/// 关联医院
Property NTLHospID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 关联科室
Property NTLLocID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 关联病人类型("MrNoType")
Property NTLPatType As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexLocID On (Parref, NTLLocID);

Index IndexHospID On (Parref, NTLHospID);

Index IndexPatType On (Parref, NTLPatType);

/// Creator：     liyi
/// CreatDate：   2014-08-20
/// Description:  取病案号码类型关联
/// Table：       DHCWMR.SS.NoTypeLnk
/// Input：       Id : DHCWMR.SS.NoTypeLnk.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.NoTypeLnk).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.NoTypeLnk
{
	new (aId)
	quit:'##class(DHCWMR.SS.NoTypeLnk).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.NoTypeLnk).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2014-08-27
/// Description:  更新病案号码类型关联
/// Table：       DHCWMR.SS.NoTypeLnk
/// Input：       InputStr : Parref^ID^NTLHospID^NTLLocID^NTLPatType
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set HospID=$p(aInputStr,aSeparate,3)
	Set LocID=$p(aInputStr,aSeparate,4)
	Set PatType=$p(aInputStr,aSeparate,5)
	Quit:(Parref="") return
	Quit:(HospID="")||(LocID="") return
	
	Set objParref=##class(DHCWMR.SS.NoType).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ChildSub="" {
		Set obj=##class(DHCWMR.SS.NoTypeLnk).%New()
	} Else {
		Set obj=##class(DHCWMR.SS.NoTypeLnk).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref     = objParref
	Set obj.NTLHospID  = HospID
	Set obj.NTLLocID   = LocID
	Set obj.NTLPatType = PatType
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-08-20
/// Description:  删除病案号码类型关联
/// Table：       DHCWMR.SS.NoTypeLnk
/// Input：       Id : DHCWMR.SS.NoTypeLnk.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.NoTypeLnk).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator：     liyi
/// CreatDate：   2014-08-27
/// Description:  查询病案号码类型关联科室
/// Table：       DHCWMR.SS.NoTypeLnk
/// Input：       NoTypeID : DHCWMR.SS.NoType.ID 号码类型
/// Return：      返回Query
/// Debug:		  D ##class(%ResultSet).RunQuery("DHCWMR.SS.NoTypeLnk","QryNoTpLocList","1||4")
Query QryNoTpLocList(aNoTypeID As %String) As %Query(ROWSPEC = "ID:%String,LocID:%String,LocDesc:%String,HospID:%String,HospDesc:%String")
{
}

ClassMethod QryNoTpLocListExecute(ByRef qHandle As %Binary, aNoTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aNoTypeID="") $$$OK
 	
 	Set xSub=0
 	For {
	 	Set xSub=$o(^DHCWMR.SS.MrTypeD(+aNoTypeID,"NT",+$p(aNoTypeID,"||",2),"L",xSub))
	 	Quit:xSub=""
	 	
	 	Set objNoTpLnk=##class(DHCWMR.SS.NoTypeLnk).GetObjById(aNoTypeID_"||"_xSub)
	 	Continue:'$IsObject(objNoTpLnk)
	 	Set ID = aNoTypeID_"||"_xSub
	 	Set LocID=objNoTpLnk.NTLLocID
	 	Continue:LocID=""
	 	Set LocDesc=$p($g(^CTLOC(LocID)),"^",2)
	 	Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	 	Set HospID=objNoTpLnk.NTLHospID
	 	Set:HospID'="" HospDesc = $p($g(^CT("HOSP",+HospID)),"^",2)
		Set Data=$lb(ID,LocID,LocDesc,HospID,HospDesc)
		Set ^CacheTemp(repid,ind)=Data
       Set ind=ind+1
	}

	Quit $$$OK
}

ClassMethod QryNoTpLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNoTpLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNoTpLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNoTpLocListExecute ]
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

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NTLLocID</Value>
</Value>
<Value name="3">
<Value>NTLHospID</Value>
</Value>
<Value name="4">
<Value>NTLPatType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("L")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("L")</IdLocation>
<IndexLocation>^DHCWMR.SS.MrTypeI("MNTL")</IndexLocation>
<StreamLocation>^DHCWMR.SS.NoTypeLnkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
