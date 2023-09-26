/// VIP等级字典
Class User.DHCPEVIPLevel Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, User.Abstract) [ Inheritance = right, SqlTableName = DHC_PE_VIPLevel ]
{

Parameter ClassName = "User.DHCPEVIPLevel";

/// VIP等级代码
Property VLCode As %String [ Required, SqlFieldName = VL_Code ];

/// VIP等级
Property VLDesc As %String [ Required, SqlFieldName = VL_Desc ];

/// 作废标记
Property VLNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = VL_NoActive ];

/// 更新日期
Property VLUpdateDate As %Date [ SqlFieldName = VL_UpdateDate ];

/// 更新时间
Property VLUpdateTime As %Time [ SqlFieldName = VL_UpdateTime ];

/// 更信人 指向SS_User
Property VLUpdateUserDR As %String [ SqlFieldName = VL_UpdateUserDR ];

/// VIP等级代码 索引
Index IdxOfCode On VLCode [ Unique ];

/// VIP等级描述 索引
Index IdxOfDesc On VLDesc [ Unique ];

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VLCode</Value>
</Value>
<Value name="3">
<Value>VLDesc</Value>
</Value>
<Value name="4">
<Value>VLNoActive</Value>
</Value>
<Value name="5">
<Value>VLUpdateDate</Value>
</Value>
<Value name="6">
<Value>VLUpdateTime</Value>
</Value>
<Value name="7">
<Value>VLUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^CT.PE.VIPLevelD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.PE.VIPLevelD</IdLocation>
<IndexLocation>^CT.PE.VIPLevelI</IndexLocation>
<StreamLocation>^User.DHCPEVIPLevelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
