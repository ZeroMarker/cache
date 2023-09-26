/// 病案收费项对照表
Class DHCWMR.MF.FeeItemSub Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.MF.FeeItem [ Cardinality = parent, Inverse = ChildFIS ];

/// HIS收费项(指向DHC_TarItem)
Property FISTarItemDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 开始日期
Property FISSttDate As %Date;

/// 结束时间
Property FISEndDate As %Date;

/// 病案类型(指向DHCWMR.SS.MrType,多值#分隔)
Property FISMrTpIDs As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院列表(指向CT_Hospital,多值#分隔)
Property FISHospIDs As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property FISResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexTarItemDr On (Parref, FISTarItemDr);

/// Creator:          李毅
/// CreateDate:       2015-07-21
/// Description:      根据ID取病案收费项对照
/// OperationTable:   DHCWMR.MF.FeeItemSub
/// Input:            Id : DHCWMR.MF.FeeItemSub.ID
/// Output:           返回Object
/// w ##Class(DHCWMR.MF.FeeItemSub).GetObjById(21)
ClassMethod GetObjById(aId As %String) As DHCWMR.MF.FeeItemSub
{
	new (aId)
	quit:'##class(DHCWMR.MF.FeeItemSub).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MF.FeeItemSub).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator:      李毅
/// CreateDate:   2015-07-21
/// Description:  更新病案收费项对照
/// Table：       DHCWMR.MF.FeeItemSub
/// Input：       InputStr : %Id^FeeItemDr^FISTarItemDr^FISSttDate^FISEndDate^FISMrTpIDs^FISHospIDs^FISResume
///               Separate ：分隔符
/// Return：      返回新纪录的%Id()值
/// w ##class(DHCWMR.MF.FeeItemSub).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set FeeItemDr=$p(aInputStr,aSeparate,2)
	Set TarItemDr=$p(aInputStr,aSeparate,3)
	
	Set SttDate  =$p(aInputStr,aSeparate,4)
	;Set:SttDate["/" SttDate=$zdh(SttDate,4)
	;Set:SttDate["-" SttDate=$zdh(SttDate,3)
	Set:SttDate'="" SttDate=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(SttDate)
	Set:SttDate'="" SttDate=+SttDate
	
	Set EndDate	 =$p(aInputStr,aSeparate,5)
	;Set:EndDate["/" EndDate=$zdh(EndDate,4)
	;Set:EndDate["-" EndDate=$zdh(EndDate,3)
	Set:EndDate'="" EndDate=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(EndDate)
	Set:EndDate'="" EndDate=+EndDate
	
	Set MrTpIDs	 =$p(aInputStr,aSeparate,6)
	Set HospIDs	 =$p(aInputStr,aSeparate,7)
	Set Resume	 =$p(aInputStr,aSeparate,8)
	Quit:((FeeItemDr="")||(TarItemDr="")) return
	
	Set objFeeItem = ##class(DHCWMR.MF.FeeItem).GetObjById(FeeItemDr)
	Quit:'$IsObject(objFeeItem) return
	
	Set tID=""
	Set ChildSub=$o(^DHCWMR.MF.FeeItemI("FIS","IndexTarItemDr",FeeItemDr," "_TarItemDr,0))
	Set:ChildSub'="" tID=FeeItemDr_"||"_ChildSub
	If ID="" {
		Set ID=tID
	} Else {
		Quit:ID'=tID -100
	}
	
	If ID="" {
		Set obj=##class(DHCWMR.MF.FeeItemSub).%New()
	} Else {
		Set obj=##class(DHCWMR.MF.FeeItemSub).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref	  		= objFeeItem
	Set obj.FISTarItemDr	= TarItemDr
	Set obj.FISSttDate		= SttDate
	Set obj.FISEndDate		= EndDate
	Set obj.FISMrTpIDs		= MrTpIDs
	Set obj.FISHospIDs		= HospIDs
	Set obj.FISResume		= Resume
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

/// Creator:      李毅
/// CreateDate:   2015-07-21
/// Description:  删除病案收费项对照
/// Table：       DHCWMR.MF.FeeItemSub
/// Input：       Id : DHCWMR.MF.FeeItemSub.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MF.FeeItemSub).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator：     李毅
/// CreatDate：   2015-07-28
/// Description:  查询HIS收费项
/// Table：       DHC_TarItem
/// Input：       
/// output:       HIS收费项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCWMR.MF.FeeItemSub","QryTarItem","钠石")
Query QryTarItem(aTarIDesc As %String) As %Query(ROWSPEC = "ID:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod QryTarItemExecute(ByRef qHandle As %Binary, aTarIDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	Set xDesc = ""
	For {
		Set xDesc = $o(^DHCTARI(0,"Desc",xDesc))
		Quit:xDesc=""
		Continue:((aTarIDesc'="")&&('(xDesc[aTarIDesc)))
		Set xID = ""
		For {
			Set xID = $o(^DHCTARI(0,"Desc",xDesc,xID))
			Quit:xID=""
			
			Set StartDate = $p($g(^DHCTARI(xID)),"^",11)
			Set EndDate   = $p($g(^DHCTARI(xID)),"^",12)
			Continue:((EndDate'="")&&(EndDate<+$h))
			
			Set Data = $lb(xID,xDesc)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryTarItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTarItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTarItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTarItemExecute ]
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

/// Creator：     liyi
/// CreatDate：   2015-07-28
/// Description:  根据收费项对照ID查询配置医院列表
/// Table：       DHCWMR.MF.FeeItemSub、CT_Hosptial
/// Input：       aFeeItemSubID ：DHCWMR.MF.FeeItemSub.ID
/// Return：      返回Query
/// D ##class(%ResultSet).RunQuery("DHCWMR.MF.FeeItemSub","QryFISHospList","1||1")
Query QryFISHospList(aFeeItemSubID As %String) As %Query(ROWSPEC = "HospID:%String,HospDesc:%String,IsChecked:%String")
{
}

ClassMethod QryFISHospListExecute(ByRef qHandle As %Binary, aFeeItemSubID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aFeeItemSubID="" $$$OK
 	
 	Set objFeeItemSub = ##class(DHCWMR.MF.FeeItemSub).GetObjById(aFeeItemSubID)
 	Quit:'$IsObject(objFeeItemSub) $$$OK
	Set HospIDs=objFeeItemSub.FISHospIDs
	Set HospIDs="#"_HospIDs_"#"
 	
 	Set xID=0
	For {
		Set xID=$o(^CT("HOSP",xID))
		Quit:xID=""
		
		Set HospID=xID
		Set HospDesc=$p($g(^CT("HOSP",xID)),"^",2)
		Set tmpHospID="#"_HospID_"#"
		Set IsChecked=$s(HospIDs[tmpHospID:1,1:0)
		Set Data=$lb(HospID,HospDesc,IsChecked)
    	Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
 	
	Quit $$$OK
}

ClassMethod QryFISHospListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFISHospListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFISHospListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFISHospListExecute ]
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

/// Creator：     liyi
/// CreatDate：   2015-07-28
/// Description:  根据收费项对照ID查询配置病案类型列表
/// Table：       DHCWMR.MF.FeeItemSub、DHCWMR_SS.MrType
/// Input：       aFeeItemSubID ：DHCWMR.MF.FeeItemSub.ID
/// Return：      返回Query
/// D ##class(%ResultSet).RunQuery("DHCWMR.MF.FeeItemSub","QryFISMrTypeList","1||1")
Query QryFISMrTypeList(aFeeItemSubID As %String) As %Query(ROWSPEC = "ID:%String,MrTypeDesc:%String,IsChecked:%String")
{
}

ClassMethod QryFISMrTypeListExecute(ByRef qHandle As %Binary, aFeeItemSubID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aFeeItemSubID="" $$$OK
 	
 	Set objFeeItemSub = ##class(DHCWMR.MF.FeeItemSub).GetObjById(aFeeItemSubID)
 	Quit:'$IsObject(objFeeItemSub) $$$OK
 	
	Set MrTypeIDs=objFeeItemSub.FISMrTpIDs
	Set MrTypeIDs="#"_MrTypeIDs_"#"
 	Set xID=0
	For {
		Set xID=$o(^DHCWMR.SS.MrTypeD(xID))
		Quit:xID=""
		
		Set ID=xID
		Set objMrType = ##class(DHCWMR.SS.MrType).GetObjById(ID)
		Continue:'$IsObject(objMrType)
		
		Set MrTypeDesc = objMrType.MTDesc
		Set tmpMrTypeID="#"_ID_"#"
		Set IsChecked=$s(MrTypeIDs[tmpMrTypeID:1,1:0)
		Set Data=$lb(ID,MrTypeDesc,IsChecked)
    	Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryFISMrTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFISMrTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFISMrTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFISMrTypeListExecute ]
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
<Value>FISTarItemDr</Value>
</Value>
<Value name="3">
<Value>FISSttDate</Value>
</Value>
<Value name="4">
<Value>FISEndDate</Value>
</Value>
<Value name="5">
<Value>FISMrTpIDs</Value>
</Value>
<Value name="6">
<Value>FISHospIDs</Value>
</Value>
<Value name="7">
<Value>FISResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("FIS")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("FIS")</IdLocation>
<IndexLocation>^DHCWMR.MF.FeeItemI("FIS")</IndexLocation>
<StreamLocation>^DHCWMR.MF.FeeItemSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
