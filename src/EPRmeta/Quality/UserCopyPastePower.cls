Class EPRmeta.Quality.UserCopyPastePower Extends %Persistent
{

Index UserIDIndex On UserID [ Unique ];

//用户ID

Property UserID As %String(TRUNCATE = 1);

//科室ID

Property SSGroupID As %String(TRUNCATE = 1);

//阶段性禁止复制、粘贴权限

//禁止开始日期

Property StartDate As %Date;

//禁止开始时间

Property StartTime As %Time;

//禁止结束日期

Property EndDate As %Date;

//禁止结束时间

Property EndTime As %Time;

//是否永久禁止

Property Foreverban As %String(TRUNCATE = 1);

//是否用户拥有复制粘贴权限

Property IsAllowCopyPaste As %String(TRUNCATE = 1);

Storage Default
{
<Data name="UserCopyPastePowerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>SSGroupID</Value>
</Value>
<Value name="4">
<Value>StartDate</Value>
</Value>
<Value name="5">
<Value>StartTime</Value>
</Value>
<Value name="6">
<Value>EndDate</Value>
</Value>
<Value name="7">
<Value>EndTime</Value>
</Value>
<Value name="8">
<Value>Foreverban</Value>
</Value>
<Value name="9">
<Value>IsAllowCopyPaste</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.UserCopyPastePowerD</DataLocation>
<DefaultData>UserCopyPastePowerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.UserCopyPastePowerD</IdLocation>
<IndexLocation>^DHCEPRM.UserCopyPastePowerI</IndexLocation>
<StreamLocation>^DHCEPRM.UserCopyPastePowerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
