/// 名称 : DHCMed.FBD.ReportPat
/// 描述 : 病人基本信息
Class DHCMed.FBD.ReportPat Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 患者姓名
Property RPPatName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 性别(描述)
Property RPSex As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出生日期
Property RPBirthday As %Date;

/// 身份证号
Property RPPersonalID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 民族(描述)
Property RPNation As %String(MAXLEN = 100, TRUNCATE = 1);

/// 门诊病案号
Property RPOPNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 住院病案号
Property RPIPNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// Creator：     zhaoyu
/// CreatDate：   2014-11-19
/// Description:  取病人基本信息对象(不需要修改的内容不存储)
/// Table：       DHCMed.FBD.ReportPat
/// Input：       Id : DHCMed.FBD.ReportPat.ID
/// Return：      返回Object
/// w ##class(DHCMed.FBD.ReportPat).GetPatObj(aInputStr,"^")
ClassMethod GetPatObj(aInputStr As %String, aSeparate As %String) As DHCMed.FBD.ReportPat
{
	New (aInputStr,aSeparate)
	
	Set obj=##class(DHCMed.FBD.ReportPat).%New()
	Set obj.RPPatName = $p(aInputStr,aSeparate,1)
	Set obj.RPSex = $p(aInputStr,aSeparate,2)
	//Set obj.RPBirthday = $p(aInputStr,aSeparate,3)
	Set Birthday = $p(aInputStr,aSeparate,3)
	Set:Birthday'="" Birthday=##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(Birthday)
	Set obj.RPBirthday = Birthday
	Set obj.RPPersonalID = $p(aInputStr,aSeparate,4)
	Set obj.RPNation = $p(aInputStr,aSeparate,5)
	Set obj.RPOPNo = $p(aInputStr,aSeparate,6)
	Set obj.RPIPNo = $p(aInputStr,aSeparate,7)
	Do obj.%Close()
	
	Quit obj
}

Storage Default
{
<Data name="ReportPatState">
<Value name="1">
<Value>RPPatName</Value>
</Value>
<Value name="2">
<Value>RPSex</Value>
</Value>
<Value name="3">
<Value>RPBirthday</Value>
</Value>
<Value name="4">
<Value>RPPersonalID</Value>
</Value>
<Value name="5">
<Value>RPNation</Value>
</Value>
<Value name="6">
<Value>RPOPNo</Value>
</Value>
<Value name="7">
<Value>RPIPNo</Value>
</Value>
</Data>
<State>ReportPatState</State>
<StreamLocation>^DHCMed.FBD.ReportPatS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
