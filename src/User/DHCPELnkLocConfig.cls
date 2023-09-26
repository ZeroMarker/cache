/// 体检关联业务科室对照表
Class User.DHCPELnkLocConfig Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_LnkLocConfig ]
{

Parameter ClassName = "User.DHCPELnkLocConfig";

/// 关联业务
Property LLCLnkAppDR As User.DHCPELnkAppConfig [ SqlFieldName = LLC_LnkAppDR ];

/// 关联业务科室 指向CT_Loc
Property LLCLocDR As %String [ SqlFieldName = LLC_LocDR ];

/// 科室(健康体检中心) 指向CT_Loc
Property LLCLnkLocDR As %String [ SqlFieldName = LLC_LnkLocDR ];

/// 激活
Property LLCActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = LLC_Active ];

/// 是否审核通过
Property LLCCheck As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = LLC_Check ];

/// 更新日期
Property LLCUpdateDate As %Date [ SqlFieldName = LLC_UpdateDate ];

/// 更新时间
Property LLCUpdateTime As %Time [ SqlFieldName = LLC_UpdateTime ];

/// 更新人 指向SS_User
Property LLCUpdateUserDR As %String [ SqlFieldName = LLC_UpdateUserDR ];

/// 关联业务+关联业务科室+科室 索引
Index IdxOfLnkAppLoc On (LLCLnkAppDR, LLCLocDR, LLCLnkLocDR);

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LLCLnkAppDR</Value>
</Value>
<Value name="3">
<Value>LLCLocDR</Value>
</Value>
<Value name="4">
<Value>LLCLnkLocDR</Value>
</Value>
<Value name="5">
<Value>LLCActive</Value>
</Value>
<Value name="6">
<Value>LLCCheck</Value>
</Value>
<Value name="7">
<Value>LLCUpdateDate</Value>
</Value>
<Value name="8">
<Value>LLCUpdateTime</Value>
</Value>
<Value name="9">
<Value>LLCUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^CF.PE.LnkLocConfigD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.LnkLocConfigD</IdLocation>
<IndexLocation>^CF.PE.LnkLocConfigI</IndexLocation>
<StreamLocation>^User.DHCPELnkLocConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
