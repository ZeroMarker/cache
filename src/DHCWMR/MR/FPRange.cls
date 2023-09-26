/// 名称 : DHCWMR.MR.FPRange
/// 说明 : 住院病案首页值域定义
Class DHCWMR.MR.FPRange Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildData As DHCWMR.MR.FPRangeData [ Cardinality = children, Inverse = Parref ];

/// 代码
Property RCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property RDesc As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexCode On RCode [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2015-08-27
/// Description:  根据ID取住院病案首页值域定义
/// Table：       DHCWMR.MR.FPRange
/// Input：       Id : DHCWMR.MR.FPRange.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MR.FPRange).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MR.FPRange
{
	new (aId)
	quit:'##class(DHCWMR.MR.FPRange).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MR.FPRange).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  更新住院病案首页值域定义
/// Table：       DHCWMR.MR.FPRange
/// Input：       InputStr ：ID^Code^Desc
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.MR.FPRange).Update("^AA^CCCC","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String = "^") As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set Code=$p(aInputStr,aSeparate,2)
	Set Desc=$p(aInputStr,aSeparate,3)
	Quit:(Code="")||(Desc="") return
	
	If ID="" {
		Set obj=##class(DHCWMR.MR.FPRange).%New()
	} Else {
		Set obj=##class(DHCWMR.MR.FPRange).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.RCode     = Code
	Set obj.RDesc     = Desc
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

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  删除住院病案首页值域定义
/// Table：       DHCWMR.MR.FPRange
/// Input：       Id : DHCWMR.MR.FPRange.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MR.FPRange).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RCode</Value>
</Value>
<Value name="3">
<Value>RDesc</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MR.FPRangeD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.MR.FPRangeD</IdLocation>
<IndexLocation>^DHCWMR.MR.FPRangeI</IndexLocation>
<StreamLocation>^DHCWMR.MR.FPRangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
