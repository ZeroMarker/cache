/// <H3>自动监控触发过滤条件</H3>
/// <H4>创建者：李阳</H4>
Class DHCMed.CC.CtlFilterRule Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 主题ID
Property SubjectID As %Integer;

/// 包括 绝对项目 （包含一个就报警）
Property IncludeAbsolute As %Boolean;

/// 敏感性项目触发数量
Property MinSensitiveCount As %Integer;

/// 特异性项目触发数量
Property MinSpecificityCount As %Integer;

/// 触发分数（单次触发分数）
Property MinScore As %Float;

/// 累计触发分数
Property TotalScore As %Float;

/// 累计已提示分数
Property TotalNoticedScore As %Float;

/// 主题ID索引
Index IndexSubject On SubjectID [ Unique ];

/// <H3>功能：通过ID获取对象的实例</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>id</B>：<B>DHCMed.CC.CtlFilterRule</B>对象的%Id()值，即RowID</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果程序运行成功返回对象实例，否则返回空字符串
ClassMethod GetObjById(id As %String) As DHCMed.CC.CtlFilterRule
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.CtlFilterRule).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.CtlFilterRule).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// 
/// <H3>功能：通过监控主题ID查询筛选标准</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>id</B>：<B>DHCMed.CC.SubjectItm</B>对象的%Id()值，即RowID</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果程序运行成功返回对象实例，否则返回空字符串
ClassMethod GetObjBySubjectID(SubjectID As %Integer) As DHCMed.CC.CtlFilterRule
{
	n (SubjectID)
	Set RowID=$o(^DHCMed.CCi("FilterRule","IndexSubject",+SubjectID,""))
	Set obj=""
	Set:RowID'="" obj=..GetObjById(RowID)
	Quit obj
}

/// <H3>功能：通过ID删除指定对象</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>id</B>：DHCMed.CC.CtlFilterRule对象的%Id()值，即RowID</LI>
/// </OL>
/// <H4>返回值:</H4>
///  成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.CC.CtlFilterRule).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// <H3>功能：保存监控筛查规则记录</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>InStr</B>：保存的数据，以seperator指定的分隔符分割。
/// 传入顺序是：RowID^EpisodeID^IncludeAbsolute^MinSensitiveCount^MinSpecificity^MinScore^TotalScore^^^^</LI>
/// <LI><B>seperator</B>：分割符，默认是 ^</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果保存成功，返回新生成数据的RowID，否则返回错误代码（错误代码<0）
ClassMethod Update(InStr As %String, seperator As %String = "^") As %String
{
	new (InStr,seperator)
	set id=0
	set ID=$p(InStr,seperator,1)	
	if ID="" {
		set obj=##class(DHCMed.CC.CtlFilterRule).%New()
		} 
	else {
		set obj=##class(DHCMed.CC.CtlFilterRule).%OpenId(ID)
		}
	set obj.SubjectID=$p(InStr,seperator,2)
	set obj.IncludeAbsolute=$p(InStr,seperator,3)
	set obj.MinSensitiveCount=$p(InStr,seperator,4)
	set obj.MinSpecificityCount=$p(InStr,seperator,5)
	set obj.MinScore=$p(InStr,seperator,6)
	Set obj.TotalScore=$p(InStr,seperator,7)
	Set obj.TotalNoticedScore=$p(InStr,seperator,8)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

Storage Default
{
<Data name="CtlFilterRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubjectID</Value>
</Value>
<Value name="3">
<Value>IncludeAbsolute</Value>
</Value>
<Value name="4">
<Value>MinSensitiveCount</Value>
</Value>
<Value name="5">
<Value>MinSpecificityCount</Value>
</Value>
<Value name="6">
<Value>MinScore</Value>
</Value>
<Value name="7">
<Value>TotalScore</Value>
</Value>
<Value name="8">
<Value>TotalNoticedScore</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC("FilterRule")</DataLocation>
<DefaultData>CtlFilterRuleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC("FilterRule")</IdLocation>
<IndexLocation>^DHCMed.CCi("FilterRule")</IndexLocation>
<StreamLocation>^DHCMed.CC.CtlResultS("FilterRule")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
