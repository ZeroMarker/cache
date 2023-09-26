Class User.DHCPEPreManager Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_PreManager ]
{

Parameter ClassName = "User.DHCPEPreManager";

/// 体检日期
Property PMDate As %Date [ Required, SqlFieldName = PM_Date ];

/// 团体ID
Property PMGADMDR As %String [ SqlFieldName = PM_GADM_DR ];

/// 限制人数
Property PMNum As %Integer [ SqlFieldName = PM_Num ];

/// 限制人数_男
Property PMNumMale As %Integer [ SqlFieldName = PM_Num_Male ];

/// 限制人数_女
Property PMNumFemale As %Integer [ SqlFieldName = PM_Num_Female ];

/// 体检科室
Property PMLocDR As User.CTLoc [ Required, SqlFieldName = PM_Loc_DR ];

/// VIP等级
Property PMVIPLevel As %Integer [ Required, SqlFieldName = PM_VIPLevel ];

/// I：个人G：团体A：所有
Property PMType As %String(MAXLEN = 1) [ Required, SqlFieldName = PM_Type ];

/// 更新日期
Property PMUpdateDate As %Date [ Required, SqlFieldName = PM_UpdateDate ];

/// 更新时间
Property PMUpdateTime As %Time [ Required, SqlFieldName = PM_UpdateTime ];

/// 更新人
Property PMUpdateUserDR As User.SSUser [ Required, SqlFieldName = PM_UpdateUser_DR ];

/// 日期团体索引
Index DateADMIndex On (PMDate, PMGADMDR) [ Unique ];

/// 科室日期索引
Index LocDateIndex On (PMLocDR, PMDate, PMVIPLevel, PMType As Alphaup);

/// 时间段子表
Relationship PMTimeChild As User.DHCPEPreTimeManager [ Cardinality = children, Inverse = PTMParRef ];

Storage Default
{
<Data name="DHCPEPreManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PMDate</Value>
</Value>
<Value name="3">
<Value>PMGADMDR</Value>
</Value>
<Value name="4">
<Value>PMNum</Value>
</Value>
<Value name="5">
<Value>PMLocDR</Value>
</Value>
<Value name="6">
<Value>PMVIPLevel</Value>
</Value>
<Value name="7">
<Value>PMType</Value>
</Value>
<Value name="8">
<Value>PMUpdateDate</Value>
</Value>
<Value name="9">
<Value>PMUpdateTime</Value>
</Value>
<Value name="10">
<Value>PMUpdateUserDR</Value>
</Value>
<Value name="11">
<Value>PMNumMale</Value>
</Value>
<Value name="12">
<Value>PMNumFemale</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEPreManagerD</DataLocation>
<DefaultData>DHCPEPreManagerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEPreManagerD</IdLocation>
<IndexLocation>^User.DHCPEPreManagerI</IndexLocation>
<StreamLocation>^User.DHCPEPreManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
