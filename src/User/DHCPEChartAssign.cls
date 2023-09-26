/// 科室体检医生维护
Class User.DHCPEChartAssign Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_ChartAssign ]
{

Parameter ClassName = "User.DHCPEChartAssign";

Relationship ChildDtl As User.DHCPEChartAssignDtl [ Cardinality = children, Inverse = ParRef ];

/// 科室（医生所属科室） 指向CT_Loc
Property CALocDR As %String [ Required, SqlFieldName = CA_LocDR ];

/// 体检医生/总检医生 指向SS_User
Property CADocDR As %String [ Required, SqlFieldName = CA_DocDR ];

/// 安全组 指向SS_Group
Property CASSGrpDR As %String [ SqlFieldName = CA_SSGrpDR ];

/// 是否住院医生
Property CAInDoc As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = CA_InDoc ];

/// 作废标记
Property CANoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = CA_NoActive ];

/// 更新日期
Property CAUpdateDate As %Date [ SqlFieldName = CA_UpdateDate ];

/// 更新时间
Property CAUpdateTime As %Time [ SqlFieldName = CA_UpdateTime ];

/// 更新人 指向SS_User
Property CAUpdateUserDR As %String [ SqlFieldName = CA_UpdateUserDR ];

/// 科室+体检医生/总检医生+安全组 索引
Index IdxOfLocDocSSGrp On (CALocDR, CADocDR, CASSGrpDR);

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CALocDR</Value>
</Value>
<Value name="3">
<Value>CADocDR</Value>
</Value>
<Value name="4">
<Value>CASSGrpDR</Value>
</Value>
<Value name="5">
<Value>CAInDoc</Value>
</Value>
<Value name="6">
<Value>CANoActive</Value>
</Value>
<Value name="7">
<Value>CAUpdateDate</Value>
</Value>
<Value name="8">
<Value>CAUpdateTime</Value>
</Value>
<Value name="9">
<Value>CAUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^CF.PE.ChartAssignD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.ChartAssignD</IdLocation>
<IndexLocation>^CF.PE.ChartAssignI</IndexLocation>
<StreamLocation>^User.DHCPEChartAssignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
