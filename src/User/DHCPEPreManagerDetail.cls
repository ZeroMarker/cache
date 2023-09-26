/// Descript:项目预约限额管理子表 记录多个条件---全程医疗
/// Creator:wangguoying
Class User.DHCPEPreManagerDetail Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_PreManagerDetail ]
{

Parameter ClassName = "User.DHCPEPreManagerDetail";

Relationship PMEDParRef As User.DHCPEPreManagerExt [ Cardinality = parent, Inverse = PMEDetail ];

/// 条件下限
Property PMEDMinVal As %Decimal [ SqlColumnNumber = 2, SqlFieldName = PMED_MinVal ];

/// 条件上限
Property PMEDMaxVal As %Decimal [ SqlColumnNumber = 3, SqlFieldName = PMED_MaxVal ];

/// 限额数量
Property PMEDNum As %Integer [ SqlColumnNumber = 4, SqlFieldName = PMED_Num ];

/// 更新人
Property PMEDUpdateUserDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = PMED_UpdateUser_DR ];

/// 操作日期
Property PMEDUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PMED_UpdateDate ];

/// 更新时间
Property PMEDUpdateTime As %Time [ SqlColumnNumber = 7, SqlFieldName = PMED_UpdateTime ];

Storage Default
{
<Data name="DHCPEPreManagerDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PMEDMinVal</Value>
</Value>
<Value name="3">
<Value>PMEDMaxVal</Value>
</Value>
<Value name="4">
<Value>PMEDNum</Value>
</Value>
<Value name="5">
<Value>PMEDUpdateUserDR</Value>
</Value>
<Value name="6">
<Value>PMEDUpdateDate</Value>
</Value>
<Value name="7">
<Value>PMEDUpdateTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("PMEDetail")</DataLocation>
<DefaultData>DHCPEPreManagerDetailDefaultData</DefaultData>
<IdLocation>^User.DHCPEPreManagerExtC("PMEDetail")</IdLocation>
<IndexLocation>^User.DHCPEPreManagerDetailI</IndexLocation>
<StreamLocation>^User.DHCPEPreManagerDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
