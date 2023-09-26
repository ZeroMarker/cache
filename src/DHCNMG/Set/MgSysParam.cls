/// creator:xbl
/// createdate:20170808
/// desc:系统参数设置
Class DHCNMG.Set.MgSysParam Extends %Persistent
{

Relationship ChildSub As DHCNMG.Set.MgSysParamSub [ Cardinality = children, Inverse = Parref ];

/// 代码
Property ParamCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Param_Code ];

/// 描述
Property ParamDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Param_Desc ];

/// 说明
Property ParamRemark As %String(MAXLEN = 10000) [ SqlColumnNumber = 4, SqlFieldName = Param_Remark ];

/// 启用状态
Property ParamStatus As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = Param_Status ];

/// 关联项目
Property ParamLink As DHCNMG.Set.MgSysParamSub [ SqlColumnNumber = 6, SqlFieldName = Param_Link ];

Index Code On ParamCode [ Unique ];

Index Link On ParamLink;

Storage Default
{
<Data name="MgSysParamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ParamCode</Value>
</Value>
<Value name="3">
<Value>ParamDesc</Value>
</Value>
<Value name="4">
<Value>ParamRemark</Value>
</Value>
<Value name="5">
<Value>ParamStatus</Value>
</Value>
<Value name="6">
<Value>ParamLink</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Set.MgSysParamD</DataLocation>
<DefaultData>MgSysParamDefaultData</DefaultData>
<IdLocation>^DHCNMG.Set.MgSysParamD</IdLocation>
<IndexLocation>^DHCNMG.Set.MgSysParamI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgSysParamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
