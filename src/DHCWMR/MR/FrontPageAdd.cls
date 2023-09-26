/// 名称 : DHCWMR.MR.FrontPageAdd
/// 说明 : 住院病案首页附页内容及扩展内容【P7】
Class DHCWMR.MR.FrontPageAdd Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.MR.FrontPage [ Cardinality = parent, Inverse = ChildAdd ];

/// 代码
Property PACode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property PADesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 值
Property PAValue As %String(MAXLEN = 500, TRUNCATE = 1);

/// 属性
Property PAProperty As %String(MAXLEN = 100, TRUNCATE = 1);

/// 关联代码
Property PALinkCode As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexCode On (Parref, PACode);

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  取附页内容及扩展内容
/// Table：       DHCWMR.MR.FrontPageAdd
/// Input：       Id : DHCWMR.MR.FrontPageAdd.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MR.FrontPageAdd).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MR.FrontPageAdd
{
	new (aId)
	quit:'##class(DHCWMR.MR.FrontPageAdd).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MR.FrontPageAdd).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  保存附页内容及扩展内容
/// Table：       DHCWMR.MR.FrontPageAdd
/// Input：       InputStr ：附页内容及扩展内容="..."
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.MR.FrontPageAdd).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	
	Set objParref=##class(DHCWMR.MR.FrontPage).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ChildSub="" {
		Set obj=##class(DHCWMR.MR.FrontPageAdd).%New()
	} Else {
		Set obj=##class(DHCWMR.MR.FrontPageAdd).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref         = objParref
	Set obj.PACode         = $p(aInputStr,aSeparate,3)  //代码
	Set obj.PADesc         = $p(aInputStr,aSeparate,4)  //名称
	Set obj.PAValue        = $p(aInputStr,aSeparate,5)  //值
	Set obj.PAProperty     = $p(aInputStr,aSeparate,6)  //属性
	Set obj.PALinkCode     = $p(aInputStr,aSeparate,7)  //关联代码
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
/// Description:  删除附页内容及扩展内容
/// Table：       DHCWMR.MR.FrontPageAdd
/// Input：       Id : DHCWMR.MR.FrontPageAdd.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MR.FrontPageAdd).%DeleteId(aId)
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
<Value>PACode</Value>
</Value>
<Value name="3">
<Value>PADesc</Value>
</Value>
<Value name="4">
<Value>PAValue</Value>
</Value>
<Value name="5">
<Value>PAProperty</Value>
</Value>
<Value name="6">
<Value>PALinkCode</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ADD")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ADD")</IdLocation>
<IndexLocation>^DHCWMR.MR.FrontPageI("ADD")</IndexLocation>
<StreamLocation>^DHCWMR.MR.FrontPageAddS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
