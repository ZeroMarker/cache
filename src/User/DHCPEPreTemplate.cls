Class User.DHCPEPreTemplate Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_PreTemplate ]
{

Parameter ClassName = "User.DHCPEPreTemplate";

/// 体检科室
Property PTLocDR As User.CTLoc [ Required, SqlFieldName = PT_Loc_DR ];

/// 周几,不设置即为不上班
Property PTWeekNum As %Integer [ Required, SqlFieldName = PT_WeekNum ];

/// VIP等级
Property PTVIPLevel As %Integer [ Required, SqlFieldName = PT_VIPLevel ];

/// I:个人、G:单位、A:所有
Property PTType As %String(MAXLEN = 1) [ Required, SqlFieldName = PT_Type ];

/// 限制人数、空不限制
Property PTNum As %Integer [ SqlFieldName = PT_Num ];

/// 限制人数、空不限制_男
Property PTNumMale As %Integer [ SqlFieldName = PT_Num_Male ];

/// 限制人数、空不限制_女
Property PTNumFemale As %Integer [ SqlFieldName = PT_Num_Female ];

/// 更新日期
Property PTUpdateDate As %Date [ Required, SqlFieldName = PT_UpdateDate ];

/// 更新时间
Property PTUpdateTime As %Time [ Required, SqlFieldName = PT_UpdateTime ];

/// 更新人
Property PTUpdateUserDR As User.SSUser [ Required, SqlFieldName = PT_UpdateUser_DR ];

/// 根据科室、周几索引
Index LocWeekNumIndex On (PTLocDR, PTWeekNum, PTVIPLevel, PTType As AlphaUp);

Relationship PTTimeChild As User.DHCPEPreTimeTemplate [ Cardinality = children, Inverse = PTTParRef ];

Storage Default
{
<Data name="DHCPEPreTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PTLocDR</Value>
</Value>
<Value name="3">
<Value>PTWeekNum</Value>
</Value>
<Value name="4">
<Value>PTVIPLevel</Value>
</Value>
<Value name="5">
<Value>PTType</Value>
</Value>
<Value name="6">
<Value>PTNum</Value>
</Value>
<Value name="7">
<Value>PTUpdateDate</Value>
</Value>
<Value name="8">
<Value>PTUpdateTime</Value>
</Value>
<Value name="9">
<Value>PTUpdateUserDR</Value>
</Value>
<Value name="10">
<Value>PTNumMale</Value>
</Value>
<Value name="11">
<Value>PTNumFemale</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEPreTemplateD</DataLocation>
<DefaultData>DHCPEPreTemplateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEPreTemplateD</IdLocation>
<IndexLocation>^User.DHCPEPreTemplateI</IndexLocation>
<StreamLocation>^User.DHCPEPreTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
