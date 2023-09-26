/// 参数配置表
Class DHCWMR.SS.Config Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 键
Property SCKey As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property SCKeyDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 值
Property SCVal As %String(MAXLEN = 500, TRUNCATE = 1);

/// 值说明
Property SCValDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院指针(指向CT_Hospital)
Property SCHospID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property SCResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexKeyHosp On (SCKey, SCHospID) [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2014-08-13
/// Description:  取配置信息
/// Table：       DHCWMR.SS.Config
/// Input：       Id : DHCWMR.SS.Config.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.Config).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.Config
{
	new (aId)
	quit:'##class(DHCWMR.SS.Config).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.Config).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2014-08-13
/// Description:  更新配置信息
/// Table：       DHCWMR.SS.Config
/// Input：       InputStr ：记录信息（1ID、2键、3键描述、4值、5值描述、6医院ID、7备注）
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##Class(DHCWMR.SS.Config).Update("^TescCode^测试^^^^0^^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	new (aInputStr,aSeparate)
	set return=0
	quit:(aInputStr="") return
	
	set ID=$p(aInputStr,aSeparate,1)
	set CfgKey=$p(aInputStr,aSeparate,2)
	set CfgKeyDesc=$p(aInputStr,aSeparate,3)
	set HospID=+$p(aInputStr,aSeparate,6)
	quit:(CfgKey="")||(CfgKeyDesc="") return
	
	set return=-100
	set xID=$o(^DHCWMR.SS.ConfigI("IndexKeyHosp"," "_$zcvt(CfgKey,"U")," "_HospID,0))
	quit:(xID'="")&&(xID'=ID) return
	
	if ID="" {
		set obj=##class(DHCWMR.SS.Config).%New()
	} else {
		set obj=##class(DHCWMR.SS.Config).%OpenId(ID)
	}
	set obj.SCKey=CfgKey
	set obj.SCKeyDesc=CfgKeyDesc
	set obj.SCVal=$p(aInputStr,aSeparate,4)
	set obj.SCValDesc=$p(aInputStr,aSeparate,5)
	set obj.SCHospID=HospID
	set obj.SCResume=$p(aInputStr,aSeparate,7)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-13
/// Description:  删除配置信息
/// Table：       DHCWMR.SS.Config
/// Input：       Id : DHCWMR.SS.Config.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.SS.Config).DeleteById()
ClassMethod DeleteById(aId)
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.Config).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-13
/// Description:  通过代码取配置信息
/// Table：       DHCWMR.SS.Config
/// Input：       Key,HospID
/// Return：      成功：返回值，失败：返回空
/// w ##Class(DHCWMR.SS.Config).GetValByKey("","")
ClassMethod GetValByKey(aKey As %String, aHospID As %String) As %String
{
	new (aKey,aHospID)
	set return=""
	quit:aKey="" return
	
	set aHospID=" "_$g(aHospID) //Modified By LiYang 2014-09-11 索引节点前面有空格
	set ID=$o(^DHCWMR.SS.ConfigI("IndexKeyHosp"," "_$ZCVT(aKey,"U"),aHospID,0))
	set obj=##class(DHCWMR.SS.Config).GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj.SCVal
	
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SCKey</Value>
</Value>
<Value name="3">
<Value>SCKeyDesc</Value>
</Value>
<Value name="4">
<Value>SCVal</Value>
</Value>
<Value name="5">
<Value>SCValDesc</Value>
</Value>
<Value name="6">
<Value>SCHospID</Value>
</Value>
<Value name="7">
<Value>SCResume</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.ConfigD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.ConfigD</IdLocation>
<IndexLocation>^DHCWMR.SS.ConfigI</IndexLocation>
<StreamLocation>^DHCWMR.SS.ConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
