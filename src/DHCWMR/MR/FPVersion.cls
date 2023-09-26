/// 名称 : DHCWMR.MR.FPVersion
/// 说明 : 住院病案首页版本表
Class DHCWMR.MR.FPVersion Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildData As DHCWMR.MR.FPVersionData [ Cardinality = children, Inverse = Parref ];

/// 代码
Property VCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property VDesc As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexCode On VCode [ Unique ];

/// Creator：     SHP
/// Date：        2015-10-10
/// Description:  根据ID取住院病案首页版本
/// Table：       DHCWMR.MR.FPVersion
/// Input：       Id : DHCWMR.MR.FPVersion.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MR.FPVersion).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MR.FPRangeData
{
	new (aId)
	quit:'##class(DHCWMR.MR.FPVersion).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MR.FPVersion).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     SHP
/// Date：        2015-10-10
/// Description:  更新错误代码表数据
/// Table：       DHCWMR.MR.FPErrCode
/// Input：       InputStr ：ID^Code^Desc
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.MR.FPErrCode).Update("^^","^")
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
		Set obj=##class(DHCWMR.MR.FPVersion).%New()
	} Else {
		Set obj=##class(DHCWMR.MR.FPVersion).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.VCode     = Code
	Set obj.VDesc     = Desc
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
<Value>VCode</Value>
</Value>
<Value name="3">
<Value>VDesc</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MR.FPVersionD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.MR.FPVersionD</IdLocation>
<IndexLocation>^DHCWMR.MR.FPVersionI</IndexLocation>
<StreamLocation>^DHCWMR.MR.FPVersionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
