/// 名称 : DHCWMR.MR.FPRangeData
/// 说明 : 住院病案首页值域内容
Class DHCWMR.MR.FPRangeData Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.MR.FPRange [ Cardinality = parent, Inverse = ChildData ];

/// 代码
Property RDCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property RDDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院ID（指向CT_Hospital）
/// 公共字典设为0
/// 主要是为了处理集团化医院字典不统一的情况
Property RDHospID As %Integer;

Index IndexCode On (Parref, RDHospID, RDCode);

Index IndexDesc On (Parref, RDHospID, RDDesc);

/// Creator：     zhufei
/// CreatDate：   2015-08-27
/// Description:  根据ID取住院病案首页值域内容
/// Table：       DHCWMR.MR.FPRangeData
/// Input：       Id : DHCWMR.MR.FPRangeData.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MR.FPRangeData).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MR.FPRangeData
{
	new (aId)
	quit:'##class(DHCWMR.MR.FPRangeData).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MR.FPRangeData).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  更新住院病案首页值域内容
/// Table：       DHCWMR.MR.FPRangeData
/// Input：       InputStr ：Parref^ChildSub^Code^Desc^HospID
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.MR.FPRangeData).Update("1^^aaa^bbb^1","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String = "^") As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set Code=$p(aInputStr,aSeparate,3)
	Set Desc=$p(aInputStr,aSeparate,4)
	Set HospID=+$p(aInputStr,aSeparate,5)
	Quit:(Parref="")||(Code="")||(Desc="") return
	
	Set objParref=##class(DHCWMR.MR.FPRange).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ChildSub="" {
		Set obj=##class(DHCWMR.MR.FPRangeData).%New()
	} Else {
		Set obj=##class(DHCWMR.MR.FPRangeData).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref     = objParref
	Set obj.RDCode     = Code
	Set obj.RDDesc     = Desc
	Set obj.RDHospID   = HospID
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
/// Description:  删除住院病案首页值域内容
/// Table：       DHCWMR.MR.FPRangeData
/// Input：       Id : DHCWMR.MR.FPRangeData.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MR.FPRangeData).%DeleteId(aId)
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
<Value>RDCode</Value>
</Value>
<Value name="3">
<Value>RDDesc</Value>
</Value>
<Value name="4">
<Value>RDHospID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DATA")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("DATA")</IdLocation>
<IndexLocation>^DHCWMR.MR.FPRangeI("DATA")</IndexLocation>
<StreamLocation>^DHCWMR.MR.FPRangeDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
