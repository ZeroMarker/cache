/// 关联电子病历数据项
Class DHCWMR.FP.DataItemLnk Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.FP.DataItem [ Cardinality = parent, Inverse = ChildLnk ];

/// 模板单元/元数据
Property DILItemDr As DHCWMR.MQ.DataItems;

/// 关联项目 索引
Index IndexItemDr On DILItemDr [ Unique ];

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-28
/// Description:  根据ID取数据项关联
/// Table：       DHCWMR.FP.DataItemLnk
/// Input：       ID:    DHCWMR.FP.DataItemLnk.ID
/// Return：      返回Object
/// w ##class(DHCWMR.FP.DataItemLnk).GetObjById(1||1)
ClassMethod GetObjById(aId As %String) As DHCWMR.FP.DataItemLnk
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.FP.DataItemLnk).%ExistsId(aId) return
	set obj=##Class(DHCWMR.FP.DataItemLnk).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-28
/// Description:  更新数据项关联
/// Table：       DHCWMR.FP.DataItemLnk
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.FP.DataItemLnk).Update("1^^1","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	new (aInputStr,aSeparate)
	set return=0
	quit:aInputStr="" return
	
	set ParRef    = $p(aInputStr,aSeparate,1)
	set ChildSub  = $p(aInputStr,aSeparate,2)
	set ItemDr    = $p(aInputStr,aSeparate,3)
	quit:(ParRef="")||(ItemDr="") return
	
	set objItem=##Class(DHCWMR.MQ.DataItems).GetObjById(ItemDr)
	quit:'$IsObject(objItem) return
	set objParref=##class(DHCWMR.FP.DataItem).GetObjById(ParRef)
	quit:'$IsObject(objParref) return
	
	if ChildSub="" {
		set obj=##class(DHCWMR.FP.DataItemLnk).%New()
	}else{
		set ID=ParRef_"||"_ChildSub
		set obj=##class(DHCWMR.FP.DataItemLnk).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.Parref       = objParref
	set obj.DILItemDr    = objItem
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
/// CreatDate：   2014-08-28
/// Description:  删除数据项关联
/// Table：       DHCWMR.FP.DataItemLnk
/// Input：       Id
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCWMR.FP.DataItemLnk).%DeleteId(Id)
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
<Value>DILItemDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("L")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("L")</IdLocation>
<IndexLocation>^DHCWMR.FP.DataItemI("DIL")</IndexLocation>
<StreamLocation>^DHCWMR.FP.DataItemLnkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
