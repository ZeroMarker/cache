/// 名称 : DHCWMR.MR.FPErrorLog
/// 说明 : 住院病案首页错误日志
Class DHCWMR.MR.FPErrorLog Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 错误代码指针
Property ELErrDr As DHCWMR.MR.FPErrCode;

/// 内容
Property ELText As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 错误
Property ELError As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 主记录指针
Property ELFpDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 日期
Property ELDate As %Date;

/// 时间
Property ELTime As %Time;

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  保存错误日志
/// Table：       DHCWMR.MR.FPErrorLog
/// Input：       aInputStr ：错误日志="代码^内容^错误^主记录ID"
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.MR.FPErrorLog).Save("-999","","AAA","")
ClassMethod Save(aErrCode As %String, aErrText As %String, aError As %String, aFpID As %String) As %String
{
	New (aErrCode,aErrText,aError,aFpID)
	Set return=0
	Quit:(aErrCode="")||(aError="") return
	
	Set objErr=##class(DHCWMR.MR.FPErrCode).GetObjByCode(aErrCode)
	Quit:'$IsObject(objErr) return
	
	Set obj=##class(DHCWMR.MR.FPErrorLog).%New()
	
	Set obj.ELErrDr  = objErr
	Set obj.ELText   = aErrText
	Set obj.ELError  = aError
	Set obj.ELFpDr   = aFpID
	Set obj.ELDate   = +$h
	Set obj.ELTime   = $p($h,",",2)
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
<Value>ELErrDr</Value>
</Value>
<Value name="3">
<Value>ELDate</Value>
</Value>
<Value name="4">
<Value>ELTime</Value>
</Value>
<Value name="5">
<Value>ELText</Value>
</Value>
<Value name="6">
<Value>ELError</Value>
</Value>
<Value name="7">
<Value>ELFpDr</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MR.FPErrorLogD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.MR.FPErrorLogD</IdLocation>
<IndexLocation>^DHCWMR.MR.FPErrorLogI</IndexLocation>
<StreamLocation>^DHCWMR.MR.FPErrorLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
