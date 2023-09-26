/// 名称 : DHCWMR.MR.FPVersionData
/// 说明 : 住院病案首页版本内容
Class DHCWMR.MR.FPVersionData Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.MR.FPVersion [ Cardinality = parent, Inverse = ChildData ];

/// 代码
Property VDCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property VDDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 类型
Property VDType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 值域
Property VDRange As %String(MAXLEN = 100, TRUNCATE = 1);

/// 顺序号
Property VDNumber As %String(MAXLEN = 100, TRUNCATE = 1);

/// 说明
Property VDResume As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexNumber On (Parref, VDNumber);

Index IndexCode On (Parref, VDCode);

/// Creator：     SHP
/// Date：        2015-10-10
/// Description:  更新错误代码表数据
/// Table：       DHCWMR.MR.FPErrCode
/// Input：       InputStr ：ID^Code^Desc^Type^Range^Number^Resume
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.MR.FPVersionData).Update("1^^1^1^1^1^1^1","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String = "^") As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set Child=$p(aInputStr,aSeparate,2)
	Set Code=$p(aInputStr,aSeparate,3)
	Set Desc=$p(aInputStr,aSeparate,4)
	Set Type=$p(aInputStr,aSeparate,5)
	Set Range=$p(aInputStr,aSeparate,6)
	Set Number=$p(aInputStr,aSeparate,8)
	Set Resume=$p(aInputStr,aSeparate,7)
	
	Quit:(Parref="")||(Code="")||(Desc="")||(Number="") return
	
	Set objParref=##class(DHCWMR.MR.FPVersion).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	If Child="" {
		Set obj=##class(DHCWMR.MR.FPVersionData).%New()
	} Else {
		Set obj=##class(DHCWMR.MR.FPVersionData).%OpenId(Parref_"||"_Child)
	}
	Quit:'$IsObject(obj) return
	
	set obj.Parref     = objParref
	Set obj.VDCode     = Code
	Set obj.VDDesc     = Desc
	set obj.VDType     = Type
	set obj.VDRange    = Range
	set obj.VDNumber   = Number
	set obj.VDResume   = Resume
	b ;
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

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VDCode</Value>
</Value>
<Value name="3">
<Value>VDDesc</Value>
</Value>
<Value name="4">
<Value>VDType</Value>
</Value>
<Value name="5">
<Value>VDRange</Value>
</Value>
<Value name="6">
<Value>VDNumber</Value>
</Value>
<Value name="7">
<Value>VDResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DATA")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("DATA")</IdLocation>
<IndexLocation>^DHCWMR.MR.FPVersionI("DATA")</IndexLocation>
<StreamLocation>^DHCWMR.MR.FPVersionDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
