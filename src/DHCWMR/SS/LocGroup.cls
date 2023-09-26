/// 科室分组（工作组）维护
Class DHCWMR.SS.LocGroup Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 科室代码(CT_Loc.ID)
Property LGDeptCode As %String(TRUNCATE = 1);

/// 科室描述
Property LGDeptDesc As %String(TRUNCATE = 1);

/// 科室/病区（E/W）
Property LGLocType As %String(TRUNCATE = 1);

/// 科室组(多值|分割)
Property LGLocGroup As %String(MAXLEN = 500, TRUNCATE = 1);

/// 备注
Property LGResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 科室代码 索引
Index IndexDeptCode On LGDeptCode As Exact;

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  根据ID取科室分组
/// Table：       DHCWMR.SS.LocGroup
/// Input：       Id : DHCWMR.SS.LocGroup.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.LocGroup).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.LocGroup
{
	new (aId)
	quit:'##class(DHCWMR.SS.LocGroup).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.LocGroup).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  更新科室分组
/// Table：       DHCWMR.SS.LocGroup
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.SS.LocGroup).Update("^9^内三科^E^内科^^^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	new (aInputStr,aSeparate)
	set return=0
	quit:aInputStr="" return
	
	set ID       = $p(aInputStr,aSeparate,1)
	set DeptCode = $p(aInputStr,aSeparate,2)
	set DeptDesc = $p(aInputStr,aSeparate,3)
	set LocType  = $p(aInputStr,aSeparate,4)
	set LocGroup = $p(aInputStr,aSeparate,5)
	set Resume   = $p(aInputStr,aSeparate,6)
	quit:(LocType="")||(DeptCode="") return
	
	//数据唯一性判断
	set:ID="" ID=$o(^DHCWMR.SS.LocGroupI("IndexDeptCode",$zcvt(DeptCode,"U"),0))
	
	if ID="" {
		set obj=##class(DHCWMR.SS.LocGroup).%New()
	}else{
		set obj=##class(DHCWMR.SS.LocGroup).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.LGDeptCode = DeptCode
	set obj.LGDeptDesc = DeptDesc
	set obj.LGLocType  = LocType
	set obj.LGLocGroup = LocGroup
	set obj.LGResume   = Resume
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  删除科室分组
/// Table：       DHCWMR.SS.LocGroup
/// Input：       Id : DHCWMR.SS.LocGroup.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId)
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.LocGroup).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-12-03
/// Description:  根据科室类型+科室ID取科室分组
/// Table：       DHCWMR.SS.LocGroup
/// Input：       科室类型 LocType  E/W
///               科室ID   LocID
/// Return：      返回科室分组
/// w ##class(DHCWMR.SS.LocGroup).GetLocGrpByLocID(1)
ClassMethod GetLocGrpByLocID(aLocType As %String, aLocID As %String) As %String
{
	new (aLocType,aLocID)
	set return="其他科"
	quit:(aLocType="")||(aLocID="") return
	
	set ID=$o(^DHCWMR.SS.LocGroupI("IndexDeptCode",$zcvt(aLocID,"U"),0))
	quit:ID="" return
	set obj=##class(DHCWMR.SS.LocGroup).GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj.LGLocGroup
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-31
/// Description:  添加科室组维护
/// Table：       DHCWMR.SS.LocGroup
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.SS.LocGroup).AddLocGrpCfg("106^482","^")
ClassMethod AddLocGrpCfg(aInputStr As %String, aSeparate As %String) As %String
{
	new (aInputStr,aSeparate)
	set return=0
	quit:aInputStr="" return
	
	set DeptCode = $p(aInputStr,aSeparate,1)
	set LocGrpDic = $p(aInputStr,aSeparate,2)
	quit:(DeptCode="")||(LocGrpDic="") return
	
	set ID=$o(^DHCWMR.SS.LocGroupI("IndexDeptCode",$zcvt(DeptCode,"U"),0))
	quit:ID="" return
	
	set obj=##class(DHCWMR.SS.LocGroup).%OpenId(ID)
	quit:'$IsObject(obj) return
	set LocGrpStr = obj.LGLocGroup
	set LocGrpList=""
	for indGrp=1:1:$l(LocGrpStr,"|") {
		set xLocGrp=$p(LocGrpStr,"|",indGrp)
		continue:xLocGrp=""
		continue:xLocGrp=LocGrpDic
		set LocGrpList=LocGrpList_"|"_xLocGrp
	}
	set LocGrpList=LocGrpList_"|"_LocGrpDic
	set:LocGrpList'="" LocGrpList=$e(LocGrpList,2,$l(LocGrpList))
	set obj.LGLocGroup = LocGrpList
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-31
/// Description:  删除科室组维护
/// Table：       DHCWMR.SS.LocGroup
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.SS.LocGroup).DelLocGrpCfg("","^")
ClassMethod DelLocGrpCfg(aInputStr As %String, aSeparate As %String) As %String
{
	new (aInputStr,aSeparate)
	set return=0
	quit:aInputStr="" return
	
	set DeptCode = $p(aInputStr,aSeparate,1)
	set LocGrpDic = $p(aInputStr,aSeparate,2)
	quit:(DeptCode="")||(LocGrpDic="") return  //修复bug 6510
	
	set ID=$o(^DHCWMR.SS.LocGroupI("IndexDeptCode",$zcvt(DeptCode,"U"),0))
	quit:ID="" return
	
	set obj=##class(DHCWMR.SS.LocGroup).%OpenId(ID)
	quit:'$IsObject(obj) return
	set LocGrpStr = obj.LGLocGroup
	set LocGrpList=""
	for indGrp=1:1:$l(LocGrpStr,"|") {
		set xLocGrp=$p(LocGrpStr,"|",indGrp)
		continue:xLocGrp=""
		continue:xLocGrp=LocGrpDic
		set LocGrpList=LocGrpList_"|"_xLocGrp
	}
	set:LocGrpList'="" LocGrpList=$e(LocGrpList,2,$l(LocGrpList))
	set obj.LGLocGroup = LocGrpList
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LGDeptCode</Value>
</Value>
<Value name="3">
<Value>LGDeptDesc</Value>
</Value>
<Value name="4">
<Value>LGLocType</Value>
</Value>
<Value name="5">
<Value>LGLocGroup</Value>
</Value>
<Value name="6">
<Value>LGResume</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.LocGroupD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.LocGroupD</IdLocation>
<IndexLocation>^DHCWMR.SS.LocGroupI</IndexLocation>
<StreamLocation>^DHCWMR.SS.LocGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
