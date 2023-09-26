/// 体检超级用户授权表
Class User.DHCPEPowerSuperUser Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_PowerSuperUser ]
{

Parameter ClassName = "User.DHCPEPowerSuperUser";

/// 用户
Property PSUUserDR As %String [ SqlFieldName = PSU_UserDR ];

/// 安全组
Property PSUGroupDR As %String [ SqlFieldName = PSU_GroupDR ];

/// 权限分类
Property PSUPowerType As %String(DISPLAYLIST = ",超级,科室组,科室", TRUNCATE = 1, VALUELIST = ",S,G,L") [ SqlFieldName = PSU_PowerType ];

/// 是否有效授权
Property PSUEffPower As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = PSU_EffPower ];

/// 更新日期
Property PSUUpdateDate As %Date [ SqlFieldName = PSU_UpdateDate ];

/// 更新时间
Property PSUUpdateTime As %Time [ SqlFieldName = PSU_UpdateTime ];

/// 更新人 指向SS_User
Property PSUUpdateUserDR As %String [ SqlFieldName = PSU_UpdateUserDR ];

/// 用户+安全组 索引
Index IdxOfUserGrp On (PSUUserDR, PSUGroupDR);

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PSUUserDR</Value>
</Value>
<Value name="3">
<Value>PSUGroupDR</Value>
</Value>
<Value name="4">
<Value>PSUPowerType</Value>
</Value>
<Value name="5">
<Value>PSUEffPower</Value>
</Value>
<Value name="6">
<Value>PSUUpdateDate</Value>
</Value>
<Value name="7">
<Value>PSUUpdateTime</Value>
</Value>
<Value name="8">
<Value>PSUUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^CF.PE.PowerSuperUserD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.PowerSuperUserD</IdLocation>
<IndexLocation>^CF.PE.PowerSuperUserI</IndexLocation>
<StreamLocation>^User.DHCPEPowerSuperUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
