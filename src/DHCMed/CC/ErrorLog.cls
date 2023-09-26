/// <H3>监控错误信息表</H3>
/// <H4>作者：李阳</H4>
/// <H4>创建日期：2012-06-15<H4>
Class DHCMed.CC.ErrorLog Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 错误日期
Property ErrorDate As %Date;

/// 错误时间
Property ErrorTime As %Time;

/// 主题ID
Property SubjectID As %Integer;

/// 主题项目ID
Property SubjectItemID As %Integer;

/// 错误信息
Property ErrorMessage As %String(MAXLEN = 500, TRUNCATE = 1);

/// Paadm 出错的关联Paadm
Property Paadm As %Integer;

/// <H3>功能：保存错误日志</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>InStr</B>：保存的数据，以seperator指定的分隔符分割。
/// 传入顺序是：RowID^ErrorDate^ErrorTime^Paadm^SubjectID^SubjectItemID^ErrorMessage</LI>
/// <LI><B>seperator</B>：分割符，默认是 ^</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果保存成功，返回新生成数据的RowID，否则返回错误代码（错误代码<0）
ClassMethod SaveErrorLog(ErrorDate, ErrorTime, Paadm, SubjectID, SubjectItemID, ErrorMessage) As %Integer
{
	n (ErrorDate,ErrorTime,Paadm,SubjectID,SubjectItemID,ErrorMessage)
	Set obj=##class(DHCMed.CC.ErrorLog).%New()
	Set obj.ErrorDate=ErrorDate
	Set obj.ErrorTime=ErrorTime
	Set obj.Paadm=Paadm
	Set obj.SubjectID=SubjectID
	Set obj.SubjectItemID=SubjectItemID
	Set obj.ErrorMessage=ErrorMessage
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set id=-1
	} else {
		set id=obj.%Id()
	}
	do obj.%Close()	
	Quit id
}

Storage Default
{
<Data name="ErrorLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ErrorDate</Value>
</Value>
<Value name="3">
<Value>ErrorMessage</Value>
</Value>
<Value name="4">
<Value>ErrorTime</Value>
</Value>
<Value name="5">
<Value>Paadm</Value>
</Value>
<Value name="6">
<Value>SubjectID</Value>
</Value>
<Value name="7">
<Value>SubjectItemID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC.ErrorLogD</DataLocation>
<DefaultData>ErrorLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC.ErrorLogD</IdLocation>
<IndexLocation>^DHCMed.CC.ErrorLogI</IndexLocation>
<StreamLocation>^DHCMed.CC.ErrorLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
