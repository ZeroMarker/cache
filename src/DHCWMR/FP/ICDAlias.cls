/// 诊断别名表
Class DHCWMR.FP.ICDAlias Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.FP.ICDDx [ Cardinality = parent, Inverse = ChildAlias ];

/// 诊断库版本
Property IAVCode As DHCWMR.FP.ICDVersion;

/// 别名
Property IAAlias As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexAlias On (IAVCode, IAAlias);

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-28
/// Description:  根据ID取诊断别名表
/// Table：       DHCWMR.FP.ICDAlias
/// Input：       ID:    DHCWMR.FP.ICDAlias.ID
/// Return：      返回Object
/// w ##class(DHCWMR.FP.ICDAlias).GetObjById(1||1)
ClassMethod GetObjById(id As %String) As DHCWMR.FP.ICDAlias
{
	new (id)
	set return=""
	quit:id="" return
	
	set obj=##Class(DHCWMR.FP.ICDAlias).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-28
/// Description:  更新诊断别名表
/// Table：       DHCWMR.FP.ICDAlias
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.FP.ICDAlias).Update("1^^Test","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	new (aInputStr,aSeparate)
	set return=0
	quit:aInputStr="" return
	
	set ParRef   = $p(aInputStr,aSeparate,1)
	set ChildSub = $p(aInputStr,aSeparate,2)
	set IAAlias  = $p(aInputStr,aSeparate,3)
	quit:(ParRef="")||(IAAlias="") return
	
	set objParref=##class(DHCWMR.FP.ICDDx).GetObjById(ParRef)
	quit:'$IsObject(objParref) return
	set objVersion=objParref.IDVCode
	set VerId=objVersion.%Id()
	
	if ChildSub="" {
		set ChildSub=$o(^DHCWMR.FP.ICDDxI("IA","IndexAlias",VerId," "_$zcvt(IAAlias,"U"),ParRef,0))
	}
	
	if ChildSub="" {
		set obj=##class(DHCWMR.FP.ICDAlias).%New()
	}else{
		set ID=ParRef_"||"_ChildSub
		set obj=##class(DHCWMR.FP.ICDAlias).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.Parref   = objParref
	set obj.IAVCode  = objVersion
	set obj.IAAlias  = IAAlias
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
/// Description:  删除诊断别名表
/// Table：       DHCWMR.FP.ICDAlias
/// Input：       Id
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCWMR.FP.ICDAlias).%DeleteId(Id)
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
<Value>IAAlias</Value>
</Value>
<Value name="3">
<Value>IAVCode</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("A")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("A")</IdLocation>
<IndexLocation>^DHCWMR.FP.ICDDxI("IA")</IndexLocation>
<StreamLocation>^DHCWMR.FP.ICDAliasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
