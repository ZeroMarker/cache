/// 用户页面配置表
/// Desc:存储用户在前端页面配置的显示项
/// Creator:	Lina
/// CreateDate:	2016-12-22
Class EMRmeta.UserPageConfig Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index LoginUserIDIndex On (LoginUserID, LoginUserLocID) [ Unique ];

/// 登录用户ID
Property LoginUserID As %String(TRUNCATE = 1);

/// 登录用户名
Property LoginUserName As %String(TRUNCATE = 1);

/// 登录用户科室ID
Property LoginUserLocID As %String(TRUNCATE = 1);

/// 住院病历-导航页面病历目录的视图显示配置,EMRmeta.CategoryViewDisplay的ViewDisplayId
Property ViewDisplay As %String(TRUNCATE = 1);

/// 住院病历-资源区检验页签的查询按钮配置
Property LisRadio As %String(TRUNCATE = 1);

/// 住院病历-资源区检查页签的查询按钮配置
Property PacsRadio As %String(TRUNCATE = 1);

/// 门诊病历页面宽度比例
Property OPDisplay As %String(TRUNCATE = 1);

/// 门诊病历页面缩放比例
Property OPScaling As %String(TRUNCATE = 1);

Storage Default
{
<Data name="UserPageConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LoginUserID</Value>
</Value>
<Value name="3">
<Value>LoginUserName</Value>
</Value>
<Value name="4">
<Value>LoginUserLocID</Value>
</Value>
<Value name="5">
<Value>ViewDisplay</Value>
</Value>
<Value name="6">
<Value>LisRadio</Value>
</Value>
<Value name="7">
<Value>PacsRadio</Value>
</Value>
<Value name="8">
<Value>OPDisplay</Value>
</Value>
<Value name="9">
<Value>OPScaling</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.UserPageConfigD</DataLocation>
<DefaultData>UserPageConfigDefaultData</DefaultData>
<IdLocation>^DHCEMRM.UserPageConfigD</IdLocation>
<IndexLocation>^DHCEMRM.UserPageConfigI</IndexLocation>
<StreamLocation>^DHCEMRM.UserPageConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
