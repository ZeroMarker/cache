/// 病案编目附加信息
Class DHCWMR.FP.FPExtraItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.FP.FrontPage [ Cardinality = parent, Inverse = ChildExtra ];

/// 项目
Property EIItem As DHCWMR.FP.ExtraItem;

/// 值
Property EIValue As %String(MAXLEN = 500, TRUNCATE = 1);

/// 值（文本内容）
Property EIText As %String(MAXLEN = 500, TRUNCATE = 1);

/// 附加项
Index IndexItemDr On EIItem;

/// Creator：     zhufei
/// CreatDate：   2014-10-30
/// Description:  根据ID取编目附加信息
/// Table：       DHCWMR.FP.FPExtraItem
/// Input：       Id : DHCWMR.FP.FPExtraItem.ID
/// Return：      返回obj
/// w ##class(DHCWMR.FP.FPExtraItem).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.FP.FPExtraItem
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.FP.FPExtraItem).%ExistsId(aId) return
	set obj=##Class(DHCWMR.FP.FPExtraItem).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-10-30
/// Description:  更新编目附加信息
/// Table：       DHCWMR.FP.FPExtraItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.FP.FPExtraItem).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set FPEItemDr=$p(aInputStr,aSeparate,2)
	Set FPEValue=$p(aInputStr,aSeparate,3)
	Set FPEText=$p(aInputStr,aSeparate,4)
	Quit:(Parref="")||(FPEItemDr="") return
	
	Set objFPEItem=##class(DHCWMR.FP.ExtraItem).GetObjById(FPEItemDr)
	Quit:'$IsObject(objFPEItem) return
	
	Set objParref=##class(DHCWMR.FP.FrontPage).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	Set ChildSub=$o(^DHCWMR.FP.FrontPageI("FPE","IndexItemDr",FPEItemDr,Parref,0))
	If ChildSub="" {
		Set obj=##class(DHCWMR.FP.FPExtraItem).%New()
	}Else{
		Set obj=##class(DHCWMR.FP.FPExtraItem).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       = objParref
	Set obj.EIItem       = objFPEItem
	Set obj.EIValue      = FPEValue
	Set obj.EIText       = FPEText
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
/// CreatDate：   2014-10-30
/// Description:  删除编目附加信息
/// Table：       DHCWMR.FP.FPExtraItem
/// Input：       Id : DHCWMR.FP.FPExtraItem.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId)
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.FP.FPExtraItem).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
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
<Value>EIItem</Value>
</Value>
<Value name="3">
<Value>EIValue</Value>
</Value>
<Value name="4">
<Value>EIText</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("E")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("E")</IdLocation>
<IndexLocation>^DHCWMR.FP.FrontPageI("FPE")</IndexLocation>
<StreamLocation>^DHCWMR.FP.FPExtraItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
