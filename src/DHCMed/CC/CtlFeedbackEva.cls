/// <H3>干预评估</H3>
Class DHCMed.CC.CtlFeedbackEva Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 反馈ID
Property FeedbackID As %Integer;

/// 准确性
Property IsCorrect As %Boolean;

/// 错误原因 建议使用字典
Property InCorrectReason As %String(TRUNCATE = 1);

/// 报告是否及时  1--按时上报 2--未及时上报 3--漏报
Property ReportOnTime As %Integer;

/// 备注
Property ResumeText As %String(TRUNCATE = 1);

/// 更新用户
Property UpdateUser As %Integer;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 反馈ID的索引【唯一索引】
Index IndexFeedbackID On FeedbackID [ Unique ];

/// <H3>功能：通过ID获取对象的实例</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>id</B>：<B>DHCMed.CC.CtlFeedback</B>对象的%Id()值，即RowID</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果程序运行成功返回对象实例，否则返回空字符串
ClassMethod GetObjById(id As %String) As DHCMed.CC.CtlFeedbackEva
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.CtlFeedbackEva).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.CtlFeedbackEva).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// <H3>功能：通过FeedBackID获取对象的实例</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>FeedBackID</B>：<B>DHCMed.CC.CtlFeedback</B>对象的%Id()值，即RowID</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果程序运行成功返回对象实例，否则返回空字符串
ClassMethod GetObjByFeedBackID(FeedBackID As %String) As DHCMed.CC.CtlFeedbackEva
{
	New (FeedBackID)
	Set return=""
	Set ID=$o(^DHCMed.CC.CtlResultI("CtlFeedbackEva","IndexFeedbackID",FeedBackID,""))
	Quit:ID="" return
	Set obj=##class(DHCMed.CC.CtlFeedbackEva).%OpenId(ID)
	Do obj.%Close()
	Set return=obj	
	Quit return
}

/// <H3>功能：通过ID删除指定对象</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>id</B>：DHCMed.CC.CtlFeedbackEva对象的%Id()值，即RowID</LI>
/// </OL>
/// <H4>返回值:</H4>
///  成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.CC.CtlFeedbackEva).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// <H3>功能：记录新干预评估记录</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>InStr</B>：保存的数据，以seperator指定的分隔符分割。
/// 传入顺序是：RowID^FeedbackID^IsCorrect^InCorrectReason^ReportOnTime^ResumeText^UpdateUser^UpdateDate^UpdateTime^</LI>
/// <LI><B>seperator</B>：分割符，默认是 ^</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果保存成功，返回新生成数据的RowID，否则返回错误代码（错误代码<0）
/// <H4>备注</H4>
/// <OL>
/// <LI>各日期字段允许的格式包括：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY</LI>
/// <LI>各时间字段允许的格式包括：（1）Cache的时间格式，（2）HH:MM:SS格式</LI>
/// </OL>
ClassMethod Update(InStr As %String, seperator As %String = "^") As %String
{
	new (InStr,seperator)
	set id=0
	set ID=$p(InStr,seperator,1)	
	Set FeedBackID=$p(InStr,seperator,2)
	Set:((ID="")&&(FeedBackID'="")) ID=$o(^DHCMed.CC.CtlResultI("CtlFeedbackEva","IndexFeedbackID",FeedBackID,""))
	if ID="" {
		set obj=##class(DHCMed.CC.CtlFeedbackEva).%New()
		} 
	else {
		set obj=##class(DHCMed.CC.CtlFeedbackEva).%OpenId(ID)
		}
	set obj.FeedbackID=$p(InStr,seperator,2) 
	set obj.IsCorrect=$p(InStr,seperator,3) /// 是否准确
	set obj.InCorrectReason=$p(InStr,seperator,4) /// 不准确原因
	set obj.ReportOnTime=$p(InStr,seperator,5) /// 按时上报 
	set obj.ResumeText=$p(InStr,seperator,6) /// 备注
	set obj.UpdateUser=$p(InStr,seperator,7) /// 更新人
	Set tmpDate=$p(InStr,seperator,8)
	Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
	Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
	Set:tmpDate="" tmpDate=+$h
	set obj.UpdateDate=tmpDate /// 更新日期
	Set tmpTime=$p(InStr,seperator,9)	
	Set:tmpTime[":" tmpTime=$zth(tmpTime,1)
	Set:tmpTime="" tmpTime=$p($h,",",2)
	set obj.UpdateTime=tmpTime /// 更新时间
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

/// w ##Class(DHCMed.CC.CtlFeedbackEva).ProcessFeedbackEva("^1^0^6176^1^手术室^","^","1,2,3,4")
ClassMethod ProcessFeedbackEva(InStr As %String, seperator As %String = "^", LnkFeedBackIDs As %String) As %String
{
	New (InStr,seperator,LnkFeedBackIDs)
	Set return=0
	Set currFeedBackID=$p(InStr,seperator,2)
	Set return=..Update(InStr,seperator)
	If return>0 {
		//处理重复记录
		For ind=1:1:$l(LnkFeedBackIDs,",") {
			Set FeedBackID=$p(LnkFeedBackIDs,",",ind)
			Continue:FeedBackID=""
			Continue:FeedBackID=currFeedBackID
			Set $p(InStr,seperator,2)=FeedBackID
			Set flg=..Update(InStr,seperator)
		}
	}
	Quit return
}

Storage Default
{
<Data name="CtlFeedbackEvaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FeedbackID</Value>
</Value>
<Value name="3">
<Value>IsCorrect</Value>
</Value>
<Value name="4">
<Value>InCorrectReason</Value>
</Value>
<Value name="5">
<Value>ReportOnTime</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
<Value name="7">
<Value>UpdateUser</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC.CtlResultD("CtlFeedbackEva")</DataLocation>
<DefaultData>CtlFeedbackEvaDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC.CtlResultD("CtlFeedbackEva")</IdLocation>
<IndexLocation>^DHCMed.CC.CtlResultI("CtlFeedbackEva")</IndexLocation>
<StreamLocation>^DHCMed.CC.CtlResultS("CtlFeedbackEva")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
