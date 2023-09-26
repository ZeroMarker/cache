/// ///Creator：      chenjiang
/// ///CreatDate：    2018-10-31
/// ///Description:： 检验检查状态字典表
/// ///Table：        SqlUser.Ens_StatusCode
/// ///Input：      
/// ///Output：   
/// ///Return：    
/// ///Others： 
/// 
Class User.EnsStatusCode Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Ens_StatusCode ]
{

/// 状态代码
Property ESCCode As %String(COLLATION = "EXACT", MAXLEN = 32767) [ Required, SqlFieldName = ESC_Code ];

/// 状态描述
Property ESCDesc As %String(COLLATION = "EXACT", MAXLEN = 32767) [ Required, SqlFieldName = ESC_Desc ];

/// 有效标志（Y:启用；N:停用）
Property ESCEffectiveFlag As %String(COLLATION = "EXACT", MAXLEN = 32767) [ SqlFieldName = ESC_EffectiveFlag ];

/// 生效开始日期(有效标志的优先级高于开始、截止日期）
Property ESCStartDate As %Date [ SqlFieldName = ESC_StartDate ];

/// 生效截止日期(有效标志的优先级高于开始、截止日期）
Property ESCEndDate As %Date [ SqlFieldName = ESC_EndDate ];

/// 注释
Property ESCNote As %String(MAXLEN = 32767) [ SqlFieldName = ESC_Note ];

Index IndexESCCode On ESCCode [ PrimaryKey, Type = index, Unique ];

Index IndexEffectiveESCode On (ESCEffectiveFlag, ESCCode);

Storage Default
{
<Data name="EnsStatusCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="8">
<Value>ESCCode</Value>
</Value>
<Value name="9">
<Value>ESCDesc</Value>
</Value>
<Value name="10">
<Value>ESCEffectiveFlag</Value>
</Value>
<Value name="11">
<Value>ESCStartDate</Value>
</Value>
<Value name="12">
<Value>ESCEndDate</Value>
</Value>
<Value name="13">
<Value>ESCNote</Value>
</Value>
</Data>
<DataLocation>^Code.ENS.EnsStatusCodeD</DataLocation>
<DefaultData>EnsStatusCodeDefaultData</DefaultData>
<IdLocation>^Code.ENS.EnsStatusCodeD</IdLocation>
<IndexLocation>^Code.ENS.EnsStatusCodeI</IndexLocation>
<StreamLocation>^Code.ENS.EnsStatusCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
