/// 编目附加项目定义
Class DHCWMR.FP.ExtraItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码（标准编码）
Property EICode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 代码2（标准编码,对应字典ID存储代码）
Property EICode2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property EIDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 类型（数值N、文本T、字典D、是否B）
Property EIType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 字典代码
Property EIDicCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property EIResume As %String(MAXLEN = 500, TRUNCATE = 1);

Property IsActive As %String(MAXLEN = 500, TRUNCATE = 1);

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-27
/// Description:  取编目附加项目
/// Table：       DHCWMR.FP.ExtraItem
/// Input：       ID : DHCWMR.FP.ExtraItem.ID
/// Return：      返回obj
/// w ##class(DHCWMR.FP.ExtraItem).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.FP.ExtraItem
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.FP.ExtraItem).%ExistsId(aId) return
	set obj=##Class(DHCWMR.FP.ExtraItem).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-27
/// Description:  更新编目附加项目
/// Table：       DHCWMR.FP.ExtraItem
/// Input：       InputStr ：记录信息（1ID、2代码、3描述、4类型、5字典代码、6备注）
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.FP.ExtraItem).Update("1^P00020000^医疗付费方式^D^^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID       = $p(aInputStr,aSeparate,1)
	Set Code     = $p(aInputStr,aSeparate,2)
	Set Desc     = $p(aInputStr,aSeparate,3)
	Set TypeID   = $p(aInputStr,aSeparate,4)
	Set TypeCode = ""
	Set objType=##class(DHCWMR.SS.Dictionary).GetObjById(TypeID)
	If $IsObject(objType){
		Set TypeCode=objType.SDCode
	}
	Set DicID    = $p(aInputStr,aSeparate,5)
	Set DicCode  = ""
	Set objDic=##class(DHCWMR.SS.Dictionary).GetObjById(DicID)
	If $IsObject(objDic){
		Set DicCode=objDic.SDCode
	}
	Set Resume   = $p(aInputStr,aSeparate,6)
	Quit:(TypeCode="") return
	Quit:(TypeCode="D")&&(DicCode="") return
	
	If ID="" {
		Set obj=##class(DHCWMR.FP.ExtraItem).%New()
	}Else{
		Set obj=##class(DHCWMR.FP.ExtraItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EICode   = Code
	Set obj.EIDesc   = Desc
	Set obj.EIType   = TypeCode
	Set obj.EIDicCode= DicCode
	Set obj.EIResume = Resume
	Set obj.IsActive = 1
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-27
/// Description:  删除编目附加项目
/// Table：       DHCWMR.FP.ExtraItem
/// Input：       DHCWMR.FP.ExtraItem.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.FP.ExtraItem).DeleteById(2)
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.FP.ExtraItem).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-31
/// Description:  查询模板附加项字典
/// Table：       DHCWMR.FP.ExtraItem
/// Input：       无
/// Return：      ROWSPEC...
/// D ##class(%ResultSet).RunQuery("DHCWMR.FP.ExtraItem","QryExtraItem")
Query QryExtraItem() As %Query(ROWSPEC = "ItemID:%String,ItemCode:%String,ItemDesc:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String,DicID:%String,DicCode:%String,DicDesc:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryExtraItemExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=""
 	For {
	 	Set xID=$o(^DHCWMR.FP.ExtraItemD(xID))
	 	Quit:xID=""
	 	
	 	Set objItem=##class(DHCWMR.FP.ExtraItem).GetObjById(xID)
	 	Continue:'$IsObject(objItem)
	 	Set IsActive=objItem.IsActive
	 	Continue:IsActive'=1
	 	
	 	Set ItemID=objItem.%Id()
	 	Set ItemCode=objItem.EICode
	 	Set ItemDesc=objItem.EIDesc
	 	Set TypeCode=objItem.EIType
	 	Set TypeID="",TypeDesc=""
	 	If TypeCode'="" {
		 	Set objType=##class(DHCWMR.SS.Dictionary).GetByTypeCode("DATATYPE",TypeCode,0)
		 	If $IsObject(objType){
		 		Set TypeID = objType.%Id()
		 		Set TypeDesc = objType.SDDesc
		 	}
	 	}
	 	Set DicCode=objItem.EIDicCode
	 	Set DicID="",DicDesc=""
 		If DicCode'="" {
	 		Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeCode("SYS",DicCode,0)
		 	If $IsObject(objDic){
			 	Set DicID = objDic.%Id()
			 	Set DicDesc = objDic.SDDesc
		 	}
	 	}
	 	Set Resume=objItem.EIResume
	 	
	 	Set Data=$lb(ItemID,ItemCode,ItemDesc,TypeID,TypeCode,TypeDesc,DicID,DicCode,DicDesc,Resume)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
 	}
 	
 	Quit $$$OK
}

ClassMethod QryExtraItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExtraItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryExtraItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExtraItemExecute ]
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

// w ##class(DHCWMR.FP.ExtraItem).UpdateByExcel("^4^预期归还时间^^D")

ClassMethod UpdateByExcel(aInputs As %String)
{
	New (aInputs)
	Set return=0
	Quit:aInputs="" return
	
	Set ID       = $p(aInputs,"^",1)
	Set Code     = $p(aInputs,"^",2)
	Set Desc     = $p(aInputs,"^",3)
	Set DicCode  = $p(aInputs,"^",4)
	Set TypeCode = $p(aInputs,"^",5)
	
	If ID="" {
		Set obj=##class(DHCWMR.FP.ExtraItem).%New()
	}Else{
		Set obj=##class(DHCWMR.FP.ExtraItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EICode   = Code
	Set obj.EIDesc   = Desc
	Set obj.EIType   = TypeCode
	Set obj.EIDicCode= DicCode
	Set obj.EIResume = ""
	Set obj.IsActive = 1
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit 1
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EICode</Value>
</Value>
<Value name="3">
<Value>EIDesc</Value>
</Value>
<Value name="4">
<Value>EIType</Value>
</Value>
<Value name="5">
<Value>EIDicCode</Value>
</Value>
<Value name="6">
<Value>EIResume</Value>
</Value>
<Value name="7">
<Value>EICode2</Value>
</Value>
<Value name="8">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.FP.ExtraItemD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.FP.ExtraItemD</IdLocation>
<IndexLocation>^DHCWMR.FP.ExtraItemI</IndexLocation>
<StreamLocation>^DHCWMR.FP.ExtraItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
