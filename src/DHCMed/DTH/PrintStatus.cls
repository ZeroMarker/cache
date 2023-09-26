/// 名称:DHCMed.DTH.PrintStatus
/// 描述: 打印状态记录表
/// 编写者：liulan
/// 编写日期: 2013-03-23
Class DHCMed.DTH.PrintStatus Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.DTH.Report [ Cardinality = parent, Inverse = ChildPrintStatus ];

/// 操作日期
Property OpeDate As %Date;

/// 操作时间
Property OpeTime As %Time;

/// 操作人员  填报告人
Property OpeUserDR As %String(TRUNCATE = 1);

/// 登录科室
Property CtlocId As %String(TRUNCATE = 1);

/// 是否打印
Property PrintFlag As %String(TRUNCATE = 1);

/// 打印形式 Code=1 二联打印 Code=2 三联打印
Property Code As %String(TRUNCATE = 1);

/// 补打医生  打印人ID  授权人Code
Property UserID As %String(TRUNCATE = 1);

/// 三联打印次数
Property PrintNum As %String(TRUNCATE = 1);

/// 二联打印次数
Property TPrintNum As %String(TRUNCATE = 1);

/// 重复打印原因
Property ResumeText As %String(MAXLEN = 500, TRUNCATE = 1);

/// 是否授权
Property GrantFlag As %String(TRUNCATE = 1);

/// w ##Class(DHCMed.DTH.PrintStatus).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCMed.DTH.PrintStatus
{
	new (aId)
	set return=""
	quit:aId="" return
	set obj=##class(DHCMed.DTH.PrintStatus).%OpenId(aId)
	if $IsObject(obj) {
		set return=obj
		do obj.%Close()
	}
	quit return
}

Storage Default
{
<Data name="ChildPrintStatus">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OpeDate</Value>
</Value>
<Value name="3">
<Value>OpeTime</Value>
</Value>
<Value name="4">
<Value>OpeUserDR</Value>
</Value>
<Value name="5">
<Value>PrintNumber</Value>
</Value>
<Value name="6">
<Value>CtlocID</Value>
</Value>
<Value name="7">
<Value>PrintFlag</Value>
</Value>
<Value name="8">
<Value>CtlocId</Value>
</Value>
<Value name="9">
<Value>resumeText</Value>
</Value>
<Value name="10">
<Value>UserID</Value>
</Value>
<Value name="11">
<Value>Code</Value>
</Value>
<Value name="12">
<Value>PrintNum</Value>
</Value>
<Value name="13">
<Value>TwoPrintNum</Value>
</Value>
<Value name="14">
<Value>TPrintNum</Value>
</Value>
<Value name="15">
<Value>ResumeText</Value>
</Value>
<Value name="16">
<Value>GrantFlag</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildPrintStatus")</DataLocation>
<DefaultData>ChildPrintStatus</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildPrintStatus")</IdLocation>
<IndexLocation>^DHCMed.DTHi("REP")("ChildPrintStatus")</IndexLocation>
<StreamLocation>^DHCMed.DTH.PrintStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
