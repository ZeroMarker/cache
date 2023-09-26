/// <H3>监控结果汇总表</H3>
/// <H4>作者：李阳</H4>
/// <H4>创建日期：2012-06-15<H4>
Class DHCMed.CC.CtlSummary Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 就诊号
Property EpisodeID As %Integer;

/// 日期
Property ActDate As %Date;

/// 主题ID
Property SubjectID As %Integer;

/// 触发项目数量
Property ItemNumber As %Integer;

/// 触发项目总分
Property TotalScore As %Float;

/// 绝对项目触发数量
Property AbsoluteAmount As %Integer;

/// 敏感项目触发数量
Property SensitiveAmount As %Integer;

/// 特异性项目触发数量
Property SpecificityAmount As %Integer;

/// 有效状态  0--未通知医师   1--已通知医师   9--排除
Property Status As %Integer;

/// 处理人（处理此信息的医师ID）
Property ProcessUser As %Integer;

/// 处理日期（通知医师或排除此结果的日期）
Property ProcessDate As %Date;

/// 处理时间（通知医师或排除此结果的时间）
Property ProcessTime As %Time;

/// 关联SummaryID
/// 处理多条记录的问题(同时监控出多条记录,记录最后一条记录的SummaryID)
Property LnkSummaryID As %Integer;

/// 记录日期、主题索引
Index IndexSubjectRecDate On (ActDate, SubjectID);

/// EpisodeID,SubjectID索引
Index IndexEpisodeSubject On (EpisodeID, SubjectID);

Index IndexEpisodeSubjectActDate On (EpisodeID, SubjectID, ActDate) [ Unique ];

/// <H3>功能：通过ID获取对象的实例</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>id</B>：<B>DHCMed.CC.CtlSummary</B>对象的%Id()值，即RowID</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果程序运行成功返回对象实例，否则返回空字符串
ClassMethod GetObjById(id As %String) As DHCMed.CC.CtlSummary
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.CtlSummary).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.CtlSummary).%OpenId(+id)
	if obj'="" do obj.%Close()
	set return=obj
	quit return
}

/// <H3>功能：通过ID删除指定对象</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>id</B>：DHCMed.CC.CtlSummary对象的%Id()值，即RowID</LI>
/// </OL>
/// <H4>返回值:</H4>
///  成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.CC.CtlSummary).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// <H3>功能：清空某一天的监控摘要记录</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>FromDate</B>：开始日期</LI>
/// <LI><B>ToDate</B>：结束日期</LI>
/// <LI><B>SubjectID</B>：监控主题ID，DHCMed.CC.Subject  %Id()</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果运行成功，返回字符串 OK
/// <H4>备注</H4>
/// <OL>
/// <LI>各日期字段允许的格式包括：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY</LI>
/// <LI>各时间字段允许的格式包括：（1）Cache的时间格式，（2）HH:MM:SS格式</LI>
/// </OL>
ClassMethod ClearData(aFromDate As %String, aToDate As %String, aSubjectID As %String, aEpisodeID As %String) As %String
{
	New (aFromDate,aToDate,aSubjectID,aEpisodeID)
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Quit:(aFromDate="")||(aToDate="") ""
	
	For tmpDate=aFromDate:1:aToDate {
		Set RowID=""
		For {
			Set RowID=$o(^DHCMed.CC.CtlResultI("Summary","IndexSubjectRecDate",tmpDate,aSubjectID,RowID))
			Quit:RowID=""
			
			Set objSummary=..GetObjById(RowID)
			Continue:'$IsObject(objSummary)
			Continue:(aEpisodeID'="")&&(aEpisodeID'=objSummary.EpisodeID)
			
			Set flg=##class(DHCMed.CC.CtlSummary).DeleteById(RowID)
		}
	}
	
	Quit "OK"
}

/// <H3>功能：保存监控结果摘要记录</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>InStr</B>：保存的数据，以seperator指定的分隔符分割。
/// 传入顺序是：RowID^EpisodeID^ActDate^SubjectID^ItemNumber^TotalScore^Status^ProcessUser^ProcessDate^ProcessTime</LI>
/// <LI><B>seperator</B>：分割符，默认是 ^</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果保存成功，返回新生成数据的RowID，否则返回错误代码（错误代码<0）
/// <H4>备注</H4>
/// <OL>
/// <LI>各日期字段允许的格式包括：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY，如果未指明，则系统自动填入当前日期</LI>
/// <LI>各时间字段允许的格式包括：（1）Cache的时间格式，（2）HH:MM:SS格式，如果未指明，则系统自动填入当前时间</LI>
/// </OL>
ClassMethod Update(InStr As %String, seperator As %String = "^") As %String
{
	new (InStr,seperator)
	set id=0
	set ID=$p(InStr,seperator,1)	
	if ID="" {
		set obj=##class(DHCMed.CC.CtlSummary).%New()
		} 
	else {
		set obj=##class(DHCMed.CC.CtlSummary).%OpenId(ID)
		}
	set obj.EpisodeID=$p(InStr,seperator,2)
	Set tmpDate=$p(InStr,seperator,3)
	Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
	Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
	set obj.ActDate=tmpDate
	set obj.SubjectID=$p(InStr,seperator,4)
	set obj.ItemNumber=$p(InStr,seperator,5)
	set obj.TotalScore=$p(InStr,seperator,6)
	set obj.Status=$p(InStr,seperator,7)
	set obj.ProcessUser=+$p(InStr,seperator,8)
	set obj.ProcessDate=+$p(InStr,seperator,9)
	set obj.ProcessTime=+$p(InStr,seperator,10)
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

/// <H3>功能：拒绝汇总记录的提示，排除该记录</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>RowID</B>：DHCMed.CC.CtlSummary对象的%Id()值，即RowID</LI>
/// <LI><B>UserID</B>：SSUSR表的Rowid</LI>
/// </OL>
/// <H4>返回值:</H4>
///  成功：返回DHCMed.CC.CtlSummary对象的%Id()值，失败：返回<0的代码
ClassMethod RejectSummary(RowID, UserID)
{
		n (RowID, UserID)
		Set obj=##class(DHCMed.CC.CtlSummary).%OpenId(RowID)
		Quit:$IsObject(obj)=0 -1
		Set obj.Status=9
		Set obj.ProcessDate=+$h
		Set obj.ProcessTime=$p($h,",",2)
		Set obj.ProcessUser=UserID
		Set ret=obj.%Save()
		Do obj.%Close()
		Quit obj.%Id()
}

/// <H3>功能：处理关联Summary状态</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>SummaryID</B>：DHCMed.CC.CtlSummary对象的%Id()值，即RowID</LI>
/// <LI><B>LnkSummaryIDs</B>：DHCMed.CC.CtlSummary对象的%Id()值，即RowID 多值逗号分隔</LI>
/// </OL>
/// <H4>返回值:</H4>
///  成功：返回0或1，失败：返回<0的代码
/// w ##Class(DHCMed.CC.CtlSummary).ProcessLnkSummary("818","818,428,33")
ClassMethod ProcessLnkSummary(SummaryID As %String, LnkSummaryIDs As %String) As %String
{
	New (SummaryID, LnkSummaryIDs)
	Set return=0
	Quit:(SummaryID="")||(LnkSummaryIDs="") return
	Quit:SummaryID=LnkSummaryIDs return
	
	Set return=-1
	Set objSummary=..GetObjById(SummaryID)
	Quit:'$IsObject(objSummary) return
	
	Set return=1
	For ind=1:1:$l(LnkSummaryIDs,",") {
		Set lnkSummaryID=$p(LnkSummaryIDs,",",ind)
		Continue:lnkSummaryID=""
		
		Set obj=##class(DHCMed.CC.CtlSummary).%OpenId(lnkSummaryID)
		Continue:'$IsObject(obj)
		Set obj.Status=objSummary.Status
		Set obj.ProcessDate=objSummary.ProcessDate
		Set obj.ProcessTime=objSummary.ProcessTime
		Set obj.ProcessUser=objSummary.ProcessUser
		Set sc=obj.%Save()
		If $system.Status.IsError(sc) {     //检查Save是否成功
	   		//Do $system.OBJ.DisplayError(sc)
	   		Set return=-2
		}
		Do obj.%Close()
	}
	
	Quit return
}

Storage Default
{
<Data name="CtlSummaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActDate</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>ItemNumber</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>SubjectID</Value>
</Value>
<Value name="7">
<Value>TotalScore</Value>
</Value>
<Value name="8">
<Value>HasAbsolute</Value>
</Value>
<Value name="9">
<Value>AbsoluteAmount</Value>
</Value>
<Value name="10">
<Value>SensitiveAmount</Value>
</Value>
<Value name="11">
<Value>SpecificityAmount</Value>
</Value>
<Value name="12">
<Value>ProcessUser</Value>
</Value>
<Value name="13">
<Value>ProcessDate</Value>
</Value>
<Value name="14">
<Value>ProcessTime</Value>
</Value>
<Value name="15">
<Value>LnkSummaryID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC.CtlResultD("Summary")</DataLocation>
<DefaultData>CtlSummaryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC.CtlResultD("Summary")</IdLocation>
<IndexLocation>^DHCMed.CC.CtlResultI("Summary")</IndexLocation>
<StreamLocation>^DHCMed.CC.CtlSummaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
