/// 性别数据处理类
Class CIS.AN.BL.Sex Extends %RegisteredObject
{

/// 获取男性对应性别数据
/// w ##class(CIS.AN.BL.Sex).Male().Code
ClassMethod Male() As CT.AN.Sex
{
	set rowId=$O(^CT.AN.SexI("ICode"," "_$ZCVT("Male","U"),""))
	if rowId'="" quit ##class(CT.AN.Sex).%OpenId(rowId)
	else  quit ..Unknown()
}

/// 获取女性对应性别数据
/// w ##class(CIS.AN.BL.Sex).Female().Code
ClassMethod Female() As CT.AN.Sex
{
	set rowId=$O(^CT.AN.SexI("ICode"," "_$ZCVT("Female","U"),""))
	if rowId'="" quit ##class(CT.AN.Sex).%OpenId(rowId)
	else  quit ..Unknown()
}

/// 获取未知性别对应性别数据
/// w ##class(CIS.AN.BL.Sex).Unknown().Code
ClassMethod Unknown() As CT.AN.Sex
{
	set rowId=$O(^CT.AN.SexI("ICode"," "_$ZCVT("Unknown","U"),""))
	if rowId'="" quit ##class(CT.AN.Sex).%OpenId(rowId)
	else  quit ""
}

/// 初始化
/// d ##class(CIS.AN.BL.Sex).Initiate()
ClassMethod Initiate() As %Status
{
	set rowId=$O(^CT.AN.SexI("ICode"," "_$ZCVT("Male","U"),""))
	if rowId=""
	{
		set instance=##class(CT.AN.Sex).%New()
		set instance.Code="Male"
		set instance.Description="男"
		set instance.ActiveDate=$ZDH("2021-12-20",3)
		set instance.Gender="M||Male"
		do instance.%Save()
	}
	
	set rowId=$O(^CT.AN.SexI("ICode"," "_$ZCVT("Female","U"),""))
	if rowId=""
	{
		set instance=##class(CT.AN.Sex).%New()
		set instance.Code="Female"
		set instance.Description="女"
		set instance.ActiveDate=$ZDH("2021-12-20",3)
		set instance.Gender="F||Female"
		do instance.%Save()
	}
	
	set rowId=$O(^CT.AN.SexI("ICode"," "_$ZCVT("Unknown","U"),""))
	if rowId=""
	{
		set instance=##class(CT.AN.Sex).%New()
		set instance.Code="Unknown"
		set instance.Description="未知"
		set instance.ActiveDate=$ZDH("2021-12-20",3)
		set instance.Gender="U||Unknown"
		do instance.%Save()
	}
	
	quit $$$OK
}

}
