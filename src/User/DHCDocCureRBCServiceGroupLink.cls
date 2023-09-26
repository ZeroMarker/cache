Class User.DHCDocCureRBCServiceGroupLink Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = DHC_DocCureRBCServiceGroupLink ]
{

/// 服务组组ID
Property LinkGroupId As User.DHCDocCureRBCServiceGroupSet [ SqlColumnNumber = 2, SqlFieldName = Link_GroupId ];

/// 关联服务组组ID
Property LinkLinkGroupId As User.DHCDocCureRBCServiceGroupSet [ SqlColumnNumber = 3, SqlFieldName = Link_LinkGroupId ];

/// 插入日期
Property LinkDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Link_Date ];

/// 插入时间
Property LinkTime As %Time [ SqlColumnNumber = 5, SqlFieldName = Link_Time ];

/// 所属院区
Property LinkHospDR As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = Link_Hosp_DR ];

Index LinkGroupIndex On (LinkGroupId, LinkLinkGroupId);

Index LinkHospGroupIndex On (LinkHospDR, LinkGroupId, LinkLinkGroupId);

Storage Default
{
<Data name="DHCDocCureRBCServiceGroupLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LinkGroupId</Value>
</Value>
<Value name="3">
<Value>LinkLinkGroupId</Value>
</Value>
<Value name="4">
<Value>LinkDate</Value>
</Value>
<Value name="5">
<Value>LinkTime</Value>
</Value>
<Value name="6">
<Value>LinkHospDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocCureSGLinkD</DataLocation>
<DefaultData>DHCDocCureRBCServiceGroupLinkDefaultData</DefaultData>
<IdLocation>^User.DHCDocCureSGLinkD</IdLocation>
<IndexLocation>^User.DHCDocCureSGLinkI</IndexLocation>
<StreamLocation>^User.DHCDocCureSGLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
