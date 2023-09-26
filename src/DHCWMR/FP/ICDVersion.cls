/// 诊断库定义
Class DHCWMR.FP.ICDVersion Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property IVCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property IVDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property IVResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexCode On IVCode [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2014-08-27
/// Description:  取诊断库定义
/// Table：       DHCWMR.FP.ICDVersion
/// Input：       Id : DHCWMR.FP.ICDVersion.ID
/// Return：      返回obj
/// w ##class(DHCWMR.FP.ICDVersion).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.FP.ICDVersion
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.FP.ICDVersion).%ExistsId(aId) return
	set obj=##Class(DHCWMR.FP.ICDVersion).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-10
/// Description:  根据代码取诊断库定义
/// Table：       DHCWMR.FP.ICDVersion
/// Input：       Code : DHCWMR.FP.ICDVersion.Code
/// Return：      返回obj
/// w ##class(DHCWMR.FP.ICDVersion).GetObjByCode("D01")
ClassMethod GetObjByCode(aCode As %String) As DHCWMR.FP.ICDVersion
{
	new (aCode)
	set return=""
	quit:aCode="" return
	set ID=$o(^DHCWMR.FP.ICDVersionI("IndexCode"," "_aCode,0))
	quit:ID="" return
	set return=..GetObjById(ID)
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-27
/// Description:  更新诊断库定义
/// Table：       DHCWMR.FP.ICDVersion
/// Input：       InputStr ：记录信息（1ID、2代码、3描述、4备注）
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.FP.ICDVersion).Update("^02^手术库^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID       = $p(aInputStr,aSeparate,1)
	Set Code   = $p(aInputStr,aSeparate,2)
	Set Desc   = $p(aInputStr,aSeparate,3)
	Set Resume = $p(aInputStr,aSeparate,4)
	Quit:(Code="")||(Desc="") return
	
	//set:ID="" ID=$o(^DHCWMR.FP.ICDVersionI("IndexCode"," "_$zcvt(Code,"U"),0))
	Quit:(ID="")&&($o(^DHCWMR.FP.ICDVersionI("IndexCode"," "_$zcvt(Code,"U"),0))) -100
	If ID="" {
		Set obj=##class(DHCWMR.FP.ICDVersion).%New()
	}Else{
		Set obj=##class(DHCWMR.FP.ICDVersion).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IVCode   = Code
	Set obj.IVDesc   = Desc
	Set obj.IVResume = Resume
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

/// Creator：     zhufei
/// CreatDate：   2014-08-27
/// Description:  删除诊断库定义
/// Table：       DHCWMR.FP.ICDVersion
/// Input：       Id
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.FP.ICDVersion).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.FP.ICDVersion).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-28
/// Description:  查询诊断库
/// Table：       DHCWMR.FP.ICDVersion
/// Input：      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCWMR.FP.ICDVersion","QryICDVersion","")
Query QryICDVersion() As %Query(ROWSPEC = "Id:%String,Code:%String,Desc:%String,Resume:%String")
{
}

ClassMethod QryICDVersionExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xId = ""
 	For {
	 	Set xId = $o(^DHCWMR.FP.ICDVersionD(xId))
	 	Quit:xId=""
	 	
	 	Set objVersion = ##class(DHCWMR.FP.ICDVersion).GetObjById(xId)
	 	Quit:'$IsObject(objVersion)
	 	
	 	Set Id         = objVersion.%Id()
	 	Set Code       = objVersion.IVCode
	 	Set Desc       = objVersion.IVDesc
	 	Set Resume     = objVersion.IVResume
	 	
	 	Set Data = $LB(Id,Code,Desc,Resume)
	 	Set ^CacheTemp(repid,ind) = Data
	 	Set ind = ind + 1
 	}
 	
	Quit $$$OK
}

ClassMethod QryICDVersionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDVersionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDVersionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDVersionExecute ]
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
<Value>IVCode</Value>
</Value>
<Value name="3">
<Value>IVDesc</Value>
</Value>
<Value name="4">
<Value>IVResume</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.FP.ICDVersionD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.FP.ICDVersionD</IdLocation>
<IndexLocation>^DHCWMR.FP.ICDVersionI</IndexLocation>
<StreamLocation>^DHCWMR.FP.ICDVersionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
