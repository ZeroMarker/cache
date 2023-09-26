/// <H3>监控返回临床医师信息</H3>
/// <H3>创建者：李阳</H3>
/// <H3>创建日期：2012-07-12</H3>
Class DHCMed.CC.CtlFeedback Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 就诊ID
Property EpisodeID As %Integer;

/// 反馈结果汇总ID
Property CtlSummaryID As %Integer;

/// 某个监控主题
Property SubjectID As %Integer;

/// 目标科室
Property ToDepartment As %Integer;

/// 目标医师
Property ToUser As %Integer;

/// 反馈结果
Property FeedBackNote As %String(MAXLEN = 500, TRUNCATE = 1);

/// 反馈医师签名
Property FeedBackUser As %Integer;

/// 医师反馈日期
Property FeedBackDate As %Date;

/// 医师反馈时间
Property FeedBackTime As %Time;

/// 接受反馈的医师可以书写具体描述
Property ReceiveNote As %String(MAXLEN = 500, TRUNCATE = 1);

/// 接受反馈的医师签名 SSUSR表的RowID
Property ReceiveUser As %Integer;

/// 接受反馈的日期
Property ReceiveDate As %Date;

/// 接受反馈的日期
Property ReceiveTime As %Time;

/// 监控是否正确
Property ControlCorrect As %Boolean;

/// 监控错误的原因
Property ControlInCorrectReason As %String(TRUNCATE = 1);

/// 报告及时性（是否及时）
Property ReportOnTime As %Boolean;

/// 状态 0--未阅读  1--接受 2--拒绝
Property Status As %Integer;

Property ReceiveResult As %Boolean;

/// 反馈提示报告的类别：  1---医院感染报告  2---传染病报告 Add By LiYang
Property FeedBackRepType As %String(TRUNCATE = 1);

/// 自动监控汇总ID的索引， DHCMed.CC.CtlSummary 类的RowID
Index IndexSummary On CtlSummaryID;

/// 医师反馈日期、主题、状态的索引
Index IndexReceiveDate On (ReceiveDate, SubjectID, Status);

/// 发送反馈的日期、主题、状态的索引
Index IndexSendDate On (FeedBackDate, SubjectID, Status);

/// 主题、状态、接收人的索引
Index IndexStatusToUser On (SubjectID, Status, ToUser);

/// 主题、就诊ID、状态索引
Index IndexEpisodeIDStatus On (SubjectID, EpisodeID, Status);

/// 就诊ID,主题的索引
Index IndexEpisodeSubjectID On (EpisodeID, SubjectID);

/// <H3>功能：通过ID获取对象的实例</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>id</B>：<B>DHCMed.CC.CtlFeedback</B>对象的%Id()值，即RowID</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果程序运行成功返回对象实例，否则返回空字符串
ClassMethod GetObjById(id As %String) As DHCMed.CC.CtlFeedback
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.CtlFeedback).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.CtlFeedback).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// <H3>功能：通过ID删除指定对象</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>id</B>：DHCMed.CC.CtlFeedback对象的%Id()值，即RowID</LI>
/// </OL>
/// <H4>返回值:</H4>
///  成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.CC.CtlFeedback).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// <H3>功能：记录新反馈记录</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>InStr</B>：保存的数据，以seperator指定的分隔符分割。
/// 传入顺序是：RowID^EpisodeID^CtlSummaryID^SubjectID^ToDepartment^ToUser^FeedBackNote^FeedBackUser^FeedBackDate^FeedBackTime^Status^FeedBackRepType</LI>
/// <LI><B>seperator</B>：分割符，默认是 ^</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果保存成功，返回新生成数据的RowID，否则返回错误代码（错误代码<0）
/// <H4>备注</H4>
/// <OL>
/// <LI>各日期字段允许的格式包括：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY</LI>
/// <LI>各时间字段允许的格式包括：（1）Cache的时间格式，（2）HH:MM:SS格式</LI>
/// </OL>
ClassMethod RecordNewFeedback(InStr As %String, seperator As %String = "^") As %String
{
	n (InStr,seperator)
	set id=0
	set ID=$p(InStr,seperator,1)	
	if ID="" {
		set obj=##class(DHCMed.CC.CtlFeedback).%New()
		} 
	else {
		set obj=##class(DHCMed.CC.CtlFeedback).%OpenId(ID)
		}
	set obj.EpisodeID=$p(InStr,seperator,2) 
	set obj.CtlSummaryID=$p(InStr,seperator,3) /// 反馈结果汇总ID
	set obj.SubjectID=$p(InStr,seperator,4) /// 某个监控主题
	set obj.ToDepartment=$p(InStr,seperator,5) /// 目标科室
	set obj.ToUser=$p(InStr,seperator,6) /// 目标医师
	set obj.FeedBackNote=$p(InStr,seperator,7) /// 反馈结果
	set obj.FeedBackUser=$p(InStr,seperator,8) /// 反馈医师签名
	Set tmpDate=$p(InStr,seperator,9)
	Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
	Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
	Set:tmpDate="" tmpDate=+$h
	set obj.FeedBackDate=tmpDate /// 医师反馈日期
	Set tmpTime=$p(InStr,seperator,10)	
	Set:tmpTime[":" tmpTime=$zth(tmpTime,1)
	Set:tmpTime="" tmpTime=$p($h,",",2)
	set obj.FeedBackTime=tmpTime /// 医师反馈时间
	Set obj.Status=0 //医师未阅读
	Set obj.FeedBackRepType=$p(InStr,seperator,11)
	set sc=obj.%Save()
	
	//更改汇总记录的状态
	Set objSummary=##class(DHCMed.CC.CtlSummary).%OpenId(obj.CtlSummaryID)
	if $IsObject(objSummary)
	{
		Set objSummary.Status=1 // 1代表 已通知医师
		Set objSummary.ProcessDate=+$h
		Set objSummary.ProcessTime=$p($h,",",2)
		Set objSummary.ProcessUser=obj.FeedBackUser
		Do objSummary.%Save()
		Do objSummary.%Close()
		Set objSummary=""
	}
	
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

/// <H3>功能：更新反馈记录的医师反馈部分</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>InStr</B>：保存的数据，以seperator指定的分隔符分割。
/// 传入顺序是：RowID^ReceiveNote^ReceiveUser^ReceiveDate^ReceiveTime^Status</LI>
/// <LI><B>seperator</B>：分割符，默认是 ^</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果保存成功，返回新生成数据的RowID，否则返回错误代码（错误代码<0）
/// <H4>备注</H4>
/// <OL>
/// <LI>各日期字段允许的格式包括：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY</LI>
/// <LI>各时间字段允许的格式包括：（1）Cache的时间格式，（2）HH:MM:SS格式</LI>
/// </OL>
ClassMethod UpdateReceiveFeedBack(InStr As %String, seperator As %String = "^") As %String
{
	new (InStr,seperator)
	set id=0
	set ID=$p(InStr,seperator,1)	
	if ID="" {
		set obj=##class(DHCMed.CC.CtlFeedback).%New()
		} 
	else {
		set obj=##class(DHCMed.CC.CtlFeedback).%OpenId(ID)
		}
	set obj.ReceiveNote=$p(InStr,seperator,2) /// 接受反馈的医师可以书写具体描述
	set obj.ReceiveUser=$p(InStr,seperator,3) /// 接受反馈的医师签名
	Set tmpDate=$p(InStr,seperator,4)
	Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
	Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
	Set:tmpDate="" tmpDate=+$h	
	set obj.ReceiveDate=tmpDate /// 接受反馈的日期
	Set tmpTime=$p(InStr,seperator,5)
	Set:tmpTime[":" tmpTime=$zth(tmpTime,1)
	Set:tmpTime="" tmpTime=$p($h,",",2)	
	set obj.ReceiveTime=tmpTime /// 接受反馈的时间
	Set obj.Status=$p(InStr,seperator,6)
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

ClassMethod UpdateAllReceiveFeedBack(InStr As %String, Seperator As %String = "^") As %String
{
	new (InStr,Seperator)
	set ID=$p(InStr,Seperator,1)	
	set objFeedBack=##class(DHCMed.CC.CtlFeedback).%OpenId(ID)
	Do objFeedBack.%Close()
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.CC.CtlResultI("CtlFeedback","IndexEpisodeSubjectID",objFeedBack.EpisodeID,objFeedBack.SubjectID,RowID))
		Quit:RowID=""
		set obj=##class(DHCMed.CC.CtlFeedback).%OpenId(ID)
		Continue:$IsObject(obj)=0
		Do obj.%Close()
		Continue:obj.FeedBackDate>objFeedBack.FeedBackDate //只更新之前的反馈信息
		Continue:obj.Status'=0 //只更新等待处理的记录
		set obj.ReceiveNote=$p(InStr,Seperator,2) /// 接受反馈的医师可以书写具体描述
		set obj.ReceiveUser=$p(InStr,Seperator,3) /// 接受反馈的医师签名
		Set tmpDate=$p(InStr,Seperator,4)
		Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
		Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
		Set:tmpDate="" tmpDate=+$h	
		set obj.ReceiveDate=tmpDate /// 接受反馈的日期
		Set tmpTime=$p(InStr,Seperator,5)
		Set:tmpTime[":" tmpTime=$zth(tmpTime,1)
		Set:tmpTime="" tmpTime=$p($h,",",2)	
		set obj.ReceiveTime=tmpTime /// 接受反馈的时间
		Set obj.Status=$p(InStr,Seperator,6)
		set sc=obj.%Save()		
	}
	quit objFeedBack.%Id()
}

Storage Default
{
<Data name="CtlFeedbackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>CtlSummaryID</Value>
</Value>
<Value name="4">
<Value>SubjectID</Value>
</Value>
<Value name="5">
<Value>ToDepartment</Value>
</Value>
<Value name="6">
<Value>ToUser</Value>
</Value>
<Value name="7">
<Value>FeedBackNote</Value>
</Value>
<Value name="8">
<Value>FeedBackUser</Value>
</Value>
<Value name="9">
<Value>FeedBackDate</Value>
</Value>
<Value name="10">
<Value>FeedBackTime</Value>
</Value>
<Value name="11">
<Value>ReceiveNote</Value>
</Value>
<Value name="12">
<Value>ReceiveUser</Value>
</Value>
<Value name="13">
<Value>ReceiveDate</Value>
</Value>
<Value name="14">
<Value>ReceiveTime</Value>
</Value>
<Value name="15">
<Value>ReceiveResult</Value>
</Value>
<Value name="16">
<Value>ControlCorrect</Value>
</Value>
<Value name="17">
<Value>ControlInCorrectReason</Value>
</Value>
<Value name="18">
<Value>ReportOnTime</Value>
</Value>
<Value name="19">
<Value>Status</Value>
</Value>
<Value name="20">
<Value>FeedBackRepType</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC.CtlResultD("CtlFeedback")</DataLocation>
<DefaultData>CtlFeedbackDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC.CtlResultD("CtlFeedback")</IdLocation>
<IndexLocation>^DHCMed.CC.CtlResultI("CtlFeedback")</IndexLocation>
<StreamLocation>^DHCMed.CC.CtlFeedbackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
