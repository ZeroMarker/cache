/// 名称 : DHCWMR.MR.FPErrCode
/// 说明 : 住院病案首页错误代码
Class DHCWMR.MR.FPErrCode Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property EDCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property EDDesc As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexCode On EDCode [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  根据ID取值错误代码
/// Table：       DHCWMR.MR.FPErrCode
/// Input：       Id : DHCWMR.MR.FPErrCode.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MR.FPErrCode).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MR.FPErrCode
{
	new (aId)
	quit:'##class(DHCWMR.MR.FPErrCode).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MR.FPErrCode).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  根据代码取值错误代码
/// Table：       DHCWMR.MR.FPErrCode
/// Input：       aCode : DHCWMR.MR.FPErrCode.EDCode
/// Return：      返回Object
/// w ##class(DHCWMR.MR.FPErrCode).GetObjByCode("-999")
ClassMethod GetObjByCode(aCode As %String) As DHCWMR.MR.FPErrCode
{
	new (aCode)
	set return=""
	quit:aCode="" return
	set ID=$o(^DHCWMR.MR.FPErrCodeI("IndexCode"," "_aCode,0))
	quit:ID="" return
	set return=..GetObjById(ID)
	quit return
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
		Set obj=##class(DHCWMR.MR.FPErrCode).%New()
	} Else {
		Set obj=##class(DHCWMR.MR.FPErrCode).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EDCode     = Code
	Set obj.EDDesc     = Desc
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
<Value>EDCode</Value>
</Value>
<Value name="3">
<Value>EDDesc</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MR.FPErrCodeD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.MR.FPErrCodeD</IdLocation>
<IndexLocation>^DHCWMR.MR.FPErrCodeI</IndexLocation>
<StreamLocation>^DHCWMR.MR.FPErrCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
