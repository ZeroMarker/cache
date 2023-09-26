/// 名称:EMRmeta.plugin.DefaultFontStyle
/// 描述:存储病历默认字体
/// 编写日期: 2020-12-10
Class EMRmeta.plugin.DefaultFontStyle Extends %Persistent
{

Index IdxHospitalIDIndex On HospitalID;

/// 院区ID %session.Get("LOGON.HOSPID")
Property HospitalID As %String(MAXLEN = 50);

/// 病历默认字体,格式参照系统参数SetDefaultFontStyle('fontFamily':'宋体','fontSize':'12pt','lineSpace':'1.5','fontSpace':'0')
Property FontStyle As %String(MAXLEN = 10000);

Storage Default
{
<Data name="DefaultFontStyleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospitalID</Value>
</Value>
<Value name="3">
<Value>FontStyle</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DefaultFontStyleD</DataLocation>
<DefaultData>DefaultFontStyleDefaultData</DefaultData>
<IdLocation>^DHCEMRM.DefaultFontStyleD</IdLocation>
<IndexLocation>^DHCEMRM.DefaultFontStyleI</IndexLocation>
<StreamLocation>^DHCEMRM.DefaultFontStyleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
