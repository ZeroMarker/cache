/// Creator:谷雪萍
/// CreatDate:2021-07-01
/// Description：基础数据平台配置：cdss科室用户权限配置
/// Table：User.BDPCDSSDeptUserAut
Class User.BDPCDSSDeptUserAut Extends (%Persistent, User.Abstract)
{

/// 科室id
Property DeptDR As User.CTLoc [ Required ];

/// 关联用户id
Property UserDR As User.SSUser;

/// 更新时间
Property CreateDate As %TimeStamp;

/// 更新人员
Property CreateUser As User.SSUser;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// cdss服务代码
Property CDSSServiceCode As %String(MAXLEN = 999);

Index DeptUserAutIndex On (DeptDR, UserDR);

Index ServiceDeptUserIndex On (CDSSServiceCode, DeptDR, UserDR);

Storage Default
{
<Data name="BDPCDSSDeptUserAutDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DeptDR</Value>
</Value>
<Value name="3">
<Value>UserDR</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateUser</Value>
</Value>
<Value name="6">
<Value>Remarks</Value>
</Value>
<Value name="7">
<Value>CDSSServiceCode</Value>
</Value>
</Data>
<DataLocation>^User.BDPCDSSDeptUserAutD</DataLocation>
<DefaultData>BDPCDSSDeptUserAutDefaultData</DefaultData>
<IdLocation>^User.BDPCDSSDeptUserAutD</IdLocation>
<IndexLocation>^User.BDPCDSSDeptUserAutI</IndexLocation>
<StreamLocation>^User.BDPCDSSDeptUserAutS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
