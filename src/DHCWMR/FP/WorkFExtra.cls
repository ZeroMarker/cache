/// 模板项目定义
Class DHCWMR.FP.WorkFExtra Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.FP.WorkFItem [ Cardinality = parent, Inverse = ChildExtra ];

/// 附加项
Property EIItem As DHCWMR.FP.ExtraItem;

/// 显示顺序
Property EIIndex As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否必填项
Property EIIsNeed As %Boolean;

/// 数据项绑定
Property EIDataItem As DHCWMR.FP.DataItem;

/// 初始值
Property EIInitVal As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property EIIsActive As %Boolean;

/// 备注
Property EIResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexItemNo On (Parref As Exact, EIIndex As Exact);

Index IndexItemDr On (Parref As Exact, EIItem As Exact);

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-29
/// Description:  根据ID取模板项目
/// Table：       DHCWMR.FP.WorkFExtra
/// Input：       ID:    DHCWMR.FP.WorkFExtra.ID
/// Return：      返回Object
/// w ##class(DHCWMR.FP.WorkFExtra).GetObjById(1||1)
ClassMethod GetObjById(id As %String) As DHCWMR.FP.WorkFExtra
{
	new (id)
	set return=""
	quit:id="" return
	
	set obj=##Class(DHCWMR.FP.WorkFExtra).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-29
/// Description:  更新模板项目
/// Table：       DHCWMR.FP.WorkFExtra
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.FP.WorkFExtra).Update("1^^1^101^1^30^1^1^测试","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	new (aInputStr,aSeparate)
	set return=0
	quit:aInputStr="" return
	
	set ParRef    = $p(aInputStr,aSeparate,1)
	set ChildSub  = $p(aInputStr,aSeparate,2)
	set EIItem    = $p(aInputStr,aSeparate,3)
	set EIIndex   = $p(aInputStr,aSeparate,4)
	set DataItem  = $p(aInputStr,aSeparate,5)
	set InitVal   = $p(aInputStr,aSeparate,6)
	Set IsNeed    = $p(aInputStr,aSeparate,7)
	Set IsActive  = $p(aInputStr,aSeparate,8)
	Set Resume    = $p(aInputStr,aSeparate,9)
	
	Quit:(ParRef="")||(EIItem="") return
	
	Set objEIItem = ##class(DHCWMR.FP.ExtraItem).GetObjById(EIItem)
	Quit:'$IsObject(objEIItem)
	
	Set objDataItem = ##class(DHCWMR.FP.DataItem).GetObjById(DataItem)
	
	if ChildSub="" {
		set obj=##class(DHCWMR.FP.WorkFExtra).%New()
	}else{
		set ID=ParRef_"||"_ChildSub
		set obj=##class(DHCWMR.FP.WorkFExtra).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.Parref      = ##class(DHCWMR.FP.WorkFItem).GetObjById(ParRef)
	set obj.EIItem      = objEIItem
	set obj.EIIndex     = +EIIndex
	set obj.EIDataItem  = objDataItem
	set obj.EIIsNeed    = IsNeed
	Set obj.EIInitVal   = InitVal
	Set obj.EIIsActive  = IsActive
	Set obj.EIResume    = Resume
	
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

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-29
/// Description:  删除模板项目
/// Table：       DHCWMR.FP.WorkFExtra
/// Input：       Id
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCWMR.FP.WorkFExtra).%DeleteId(Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=1
	}
	quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EIItem</Value>
</Value>
<Value name="3">
<Value>EIIndex</Value>
</Value>
<Value name="4">
<Value>EIIsNeed</Value>
</Value>
<Value name="5">
<Value>EIDataItem</Value>
</Value>
<Value name="6">
<Value>EIInitVal</Value>
</Value>
<Value name="7">
<Value>EIIsActive</Value>
</Value>
<Value name="8">
<Value>EIResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("E")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("E")</IdLocation>
<IndexLocation>^DHCWMR.FP.WorkFExtraI("WFE")</IndexLocation>
<StreamLocation>^DHCWMR.FP.WorkFExtraS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
