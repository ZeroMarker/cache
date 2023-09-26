Class CHSSWeb.HISInterface.WomenBaseInfo Extends %Persistent
{

/// ﻿个人档案主键
Property PersonRowIdParref As %Integer;

Property WomanRowId As %Integer;

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
Property EBPeriod As %Integer;

Property EBPeriodName As %String;

/// 建册时间详述
Property EBPeriodDes As %String(MAXLEN = 20, TRUNCATE = 1);

/// 建册日期
Property EBTime As %Date;

/// 建册单位全称
Property EBunit As %String(MAXLEN = 30, TRUNCATE = 1);

/// 是否建过本册
Property EBbefore As %String(MAXLEN = 5, TRUNCATE = 1);

/// 建册次数
Property EBnum As %Integer;

/// 前次编号
Property EBfrontCode As %Integer;

/// 填表人
Property FinishTable As %String(MAXLEN = 60, TRUNCATE = 1);

/// 录入人
Property Operator As %Integer;

Property OperatorName As %String;

/// 录入日期
Property OperateDate As %Date;

/// 收回标识
Property FinishIdentifier As %String(MAXLEN = 5, TRUNCATE = 1);

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
<Value>EBPeriod</Value>
</Value>
<Value name="9">
<Value>EBPeriodDes</Value>
</Value>
<Value name="10">
<Value>EBTime</Value>
</Value>
<Value name="11">
<Value>EBbefore</Value>
</Value>
<Value name="12">
<Value>EBfrontCode</Value>
</Value>
<Value name="13">
<Value>EBnum</Value>
</Value>
<Value name="14">
<Value>EBunit</Value>
</Value>
<Value name="15">
<Value>Email</Value>
</Value>
<Value name="16">
<Value>FinishTable</Value>
</Value>
<Value name="17">
<Value>HusbandBirth</Value>
</Value>
<Value name="18">
<Value>HusbandEmail</Value>
</Value>
<Value name="19">
<Value>HusbandMobTele</Value>
</Value>
<Value name="20">
<Value>HusbandName</Value>
</Value>
<Value name="21">
<Value>HusbandTele</Value>
</Value>
<Value name="22">
<Value>HusbandWorkUnit</Value>
</Value>
<Value name="23">
<Value>IdCard</Value>
</Value>
<Value name="24">
<Value>InHosCode</Value>
</Value>
<Value name="25">
<Value>OperateDate</Value>
</Value>
<Value name="26">
<Value>Operator</Value>
</Value>
<Value name="27">
<Value>PersonName</Value>
</Value>
<Value name="28">
<Value>PersonRowIdParref</Value>
</Value>
<Value name="29">
<Value>ResidenceAddress</Value>
</Value>
<Value name="30">
<Value>SpellCode</Value>
</Value>
<Value name="31">
<Value>TelPhone</Value>
</Value>
<Value name="32">
<Value>WoAge</Value>
</Value>
<Value name="33">
<Value>WomanHandBookCode</Value>
</Value>
<Value name="34">
<Value>WorkUnit</Value>
</Value>
<Value name="35">
<Value>bDose</Value>
</Value>
<Value name="36">
<Value>EBPeriodName</Value>
</Value>
<Value name="37">
<Value>OperatorName</Value>
</Value>
<Value name="38">
<Value>FinishIdentifier</Value>
</Value>
<Value name="39">
<Value>WomanRowId</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HISIn6F2.WomenBaseInfoD</DataLocation>
<DefaultData>WomenBaseInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HISIn6F2.WomenBaseInfoD</IdLocation>
<IndexLocation>^CHSSWeb.HISIn6F2.WomenBaseInfoI</IndexLocation>
<StreamLocation>^CHSSWeb.HISIn6F2.WomenBaseInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
