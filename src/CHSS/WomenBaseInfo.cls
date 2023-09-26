Class CHSS.WomenBaseInfo Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = WomanRowId, SqlTableName = WomenBaseInfo ]
{

/// ﻿个人档案主键
Property PersonRowIdParref As CHSS.PersonHealthRecordMain;

/// 姓名
Property PersonName As %String(MAXLEN = 60, TRUNCATE = 1);

/// 拼音码
Property SpellCode As %String(MAXLEN = 30, TRUNCATE = 1);

/// 妇女年龄
Property WoAge As %String(MAXLEN = 5, TRUNCATE = 1);

/// 妇女生日
Property Birth As %Date;

/// 围产手册号
Property WomanHandBookCode As %String(MAXLEN = 30, TRUNCATE = 1);

/// 工作单位
Property WorkUnit As %String(MAXLEN = 50, TRUNCATE = 1);

/// 电话
Property TelPhone As %String(MAXLEN = 12, TRUNCATE = 1);

/// 移动电话
Property CellPhone As %String(MAXLEN = 11, TRUNCATE = 1);

/// 电子邮箱
Property Email As %String(MAXLEN = 50, TRUNCATE = 1);

/// 户口地址
Property ResidenceAddress As %String(MAXLEN = 100, TRUNCATE = 1);

/// 婚后地址
Property AfMaAddress As %String(MAXLEN = 100, TRUNCATE = 1);

/// 产后地址
Property AftBeAddress As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否准备服药
Property bDose As %String(MAXLEN = 5, TRUNCATE = 1);

/// 身份证号
Property IdCard As %String(MAXLEN = 20, TRUNCATE = 1);

/// 卡号
Property Card As %String(MAXLEN = 30, TRUNCATE = 1);

/// 卡类型
Property CardType As %String(MAXLEN = 50, TRUNCATE = 1);

/// 住院号
Property InHosCode As %String(MAXLEN = 50, TRUNCATE = 1);

/// 丈夫姓名
Property HusbandName As %String(MAXLEN = 20, TRUNCATE = 1);

/// 丈夫生日
Property HusbandBirth As %Date;

/// 丈夫工作单位
Property HusbandWorkUnit As %String(MAXLEN = 50, TRUNCATE = 1);

/// 丈夫电话
Property HusbandTele As %String(MAXLEN = 12, TRUNCATE = 1);

/// 丈夫移动电话
Property HusbandMobTele As %String(MAXLEN = 11, TRUNCATE = 1);

/// 丈夫电子邮箱
Property HusbandEmail As %String(MAXLEN = 50, TRUNCATE = 1);

/// 建册时间
Property EBPeriod As CHSS.DictWomenBookTime;

/// 建册时间详述
Property EBPeriodDes As %String(MAXLEN = 20, TRUNCATE = 1);

/// 建册日期
Property EBTime As %Date;

/// 建册单位全称
Property EBunit As %String(MAXLEN = 30, TRUNCATE = 1);

/// 建册单位级别--D
/// Property EBunitRank As %String(MAXLEN = 30);
/// 建册单位级别详述
/// Property EBUNRaRemark As %String(MAXLEN = 30);
/// 是否建过本册
Property EBbefore As %String(MAXLEN = 5, TRUNCATE = 1);

/// 建册次数
Property EBnum As %Integer;

/// 前次编号
Property EBfrontCode As %Integer;

/// 填表人
Property FinishTable As %String(MAXLEN = 60, TRUNCATE = 1);

/// 录入人
Property Operator As User.SSUser;

/// 录入日期
Property OperateDate As %Date;

/// 收回标识
Property FinishIdentifier As %String(MAXLEN = 5, TRUNCATE = 1);

/// 社区编码
Property CommunityCode As %String(MAXLEN = 50, TRUNCATE = 1);

Index PersonRowIdParrefIndex On PersonRowIdParref;

Index CommunityCodeIndex On CommunityCode;

//插入之后 往CHSS.CommunityWorkStaNum 里插入数据

Trigger AfterInsert [ Event = INSERT, Time = AFTER ]
{
    Set WomanRowId = {WomanRowId} 
    Set CommunityCode = {CommunityCode} 
    Set OperateDate = {OperateDate}  
    d ##class(CHSSWeb.CommStaTriggerService).RecordInsert("WomenBaseInfo",WomanRowId,CommunityCode,OperateDate)
}

//修改之前 往CHSS.CommunityWorkStaNum 里更新数据

Trigger BeforeUpdate [ Event = UPDATE ]
{
  
    Set WomanRowId = {WomanRowId} 
    Set CommunityCode = {CommunityCode} 
    Set OperateDate = {OperateDate} 
    d ##class(CHSSWeb.CommStaTriggerService).RecordUpdate("WomenBaseInfo",WomanRowId,CommunityCode,OperateDate)
}

//删除之前 CHSS.CommunityWorkStaNum 里删除数据

Trigger BeforeDelete [ Event = DELETE ]
{
  
    Set WomanRowId = {WomanRowId} 
    Set CommunityCode = {CommunityCode} 
    Set OperateDate = {OperateDate} 
    d ##class(CHSSWeb.CommStaTriggerService).RecordDelete("WomenBaseInfo",WomanRowId,CommunityCode,OperateDate)
}

Method %OnBeforeSave(insert As %Boolean) As %Status [ Private ]
{
	s $zt="Error"
	i insert'=1 d
    .Set WomanRowId = %this.%Id()   
    .Set CommunityCode = %this.CommunityCode
    .Set OperateDate = %this.OperateDate
    .d ##class(CHSSWeb.CommStaTriggerService).RecordUpdate("WomenBaseInfo",WomanRowId,CommunityCode,OperateDate)
	Quit $$$OK
Error
 	Quit $$$OK
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private ]
{
	s $zt="Error"
	i insert=1 d 
	.Set WomanRowId = %this.%Id()    
    .Set CommunityCode = %this.CommunityCode
    .Set OperateDate = %this.OperateDate
    .d ##class(CHSSWeb.CommStaTriggerService).RecordInsert("WomenBaseInfo",WomanRowId,CommunityCode,OperateDate)
	Quit $$$OK
Error
 	Quit $$$OK
}

/// [Previously private]
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status
{
	S $zt="Error"
 
	S tmpFamily= ##class(CHSS.WomenBaseInfo).%Open(oid) 
	Set WomanRowId = %this.%Id()   
    Set CommunityCode = tmpFamily.CommunityCode  
    Set OperateDate = tmpFamily.OperateDate 
    d ##class(CHSSWeb.CommStaTriggerService).RecordDelete("WomenBaseInfo",WomanRowId,CommunityCode,OperateDate)

	Quit $$$OK
Error
 	Quit $$$OK
}

Storage Default
{
<Data name="WomenBaseInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AfMaAddress</Value>
</Value>
<Value name="3">
<Value>AftBeAddress</Value>
</Value>
<Value name="4">
<Value>Birth</Value>
</Value>
<Value name="5">
<Value>Card</Value>
</Value>
<Value name="6">
<Value>CardType</Value>
</Value>
<Value name="7">
<Value>CellPhone</Value>
</Value>
<Value name="8">
<Value>CommunityCode</Value>
</Value>
<Value name="9">
<Value>EBPeriod</Value>
</Value>
<Value name="10">
<Value>EBPeriodDes</Value>
</Value>
<Value name="11">
<Value>EBTime</Value>
</Value>
<Value name="12">
<Value>EBUNRaRemark</Value>
</Value>
<Value name="13">
<Value>EBbefore</Value>
</Value>
<Value name="14">
<Value>EBfrontCode</Value>
</Value>
<Value name="15">
<Value>EBnum</Value>
</Value>
<Value name="16">
<Value>EBunit</Value>
</Value>
<Value name="17">
<Value>EBunitRank</Value>
</Value>
<Value name="18">
<Value>Email</Value>
</Value>
<Value name="19">
<Value>FinishIdentifier</Value>
</Value>
<Value name="20">
<Value>FinishTable</Value>
</Value>
<Value name="21">
<Value>HusbandBirth</Value>
</Value>
<Value name="22">
<Value>HusbandEmail</Value>
</Value>
<Value name="23">
<Value>HusbandMobTele</Value>
</Value>
<Value name="24">
<Value>HusbandName</Value>
</Value>
<Value name="25">
<Value>HusbandTele</Value>
</Value>
<Value name="26">
<Value>HusbandWorkUnit</Value>
</Value>
<Value name="27">
<Value>IdCard</Value>
</Value>
<Value name="28">
<Value>InHosCode</Value>
</Value>
<Value name="29">
<Value>OperateDate</Value>
</Value>
<Value name="30">
<Value>Operator</Value>
</Value>
<Value name="31">
<Value>PersonName</Value>
</Value>
<Value name="32">
<Value>PersonRowIdParref</Value>
</Value>
<Value name="33">
<Value>ResidenceAddress</Value>
</Value>
<Value name="34">
<Value>SpellCode</Value>
</Value>
<Value name="35">
<Value>TelPhone</Value>
</Value>
<Value name="36">
<Value>WoAge</Value>
</Value>
<Value name="37">
<Value>WomanHandBookCode</Value>
</Value>
<Value name="38">
<Value>WorkUnit</Value>
</Value>
<Value name="39">
<Value>bDose</Value>
</Value>
</Data>
<DataLocation>^CHSS.WomenBaseInfoD</DataLocation>
<DefaultData>WomenBaseInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.WomenBaseInfoD</IdLocation>
<IndexLocation>^CHSS.WomenBaseInfoI</IndexLocation>
<StreamLocation>^CHSS.WomenBaseInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
