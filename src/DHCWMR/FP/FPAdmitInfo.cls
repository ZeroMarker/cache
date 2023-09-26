/// 病案编目就诊信息
Class DHCWMR.FP.FPAdmitInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.FP.FrontPage [ Cardinality = parent, Inverse = ChildAdmit ];

/// 代码
Property AICode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 值
Property AIValue As %String(MAXLEN = 500, TRUNCATE = 1);

/// 索引代码
Index IndexParCode On (Parref, AICode);

/// Creator：     zhufei
/// CreatDate：   2017-03-06
/// Description:  根据ID取编目就诊信息
/// Table：       DHCWMR.FP.FPAdmitInfo
/// Input：       Id : DHCWMR.FP.FPAdmitInfo.ID
/// Return：      返回obj
/// w ##class(DHCWMR.FP.FPAdmitInfo).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.FP.FPAdmitInfo
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.FP.FPAdmitInfo).%ExistsId(aId) return
	set obj=##Class(DHCWMR.FP.FPAdmitInfo).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-03-06
/// Description:  更新编目就诊信息
/// Table：       DHCWMR.FP.FPAdmitInfo
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.FP.FPAdmitInfo).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set AICode=$p(aInputStr,aSeparate,2)
	Set AIValue=$p(aInputStr,aSeparate,3)
	Quit:(Parref="")||(AICode="") return
	
	Set objParref=##class(DHCWMR.FP.FrontPage).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	Set ChildSub=$o(^DHCWMR.FP.FrontPageI("FPA","IndexParCode",Parref," "_$zcvt(AICode,"U"),0))
	If ChildSub="" {
		Set obj=##class(DHCWMR.FP.FPAdmitInfo).%New()
	}Else{
		Set obj=##class(DHCWMR.FP.FPAdmitInfo).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref       = objParref
	Set obj.AICode       = AICode
	Set obj.AIValue      = AIValue
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
/// CreatDate：   2017-03-06
/// Description:  删除编目就诊信息
/// Table：       DHCWMR.FP.FPAdmitInfo
/// Input：       Id : DHCWMR.FP.FPAdmitInfo.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId)
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.FP.FPAdmitInfo).%DeleteId(aId)
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
<Value>AICode</Value>
</Value>
<Value name="3">
<Value>AIValue</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("A")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("A")</IdLocation>
<IndexLocation>^DHCWMR.FP.FrontPageI("FPA")</IndexLocation>
<StreamLocation>^DHCWMR.FP.FPAdmitInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
