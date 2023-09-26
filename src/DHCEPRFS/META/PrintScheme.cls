/// Desc:打印方案
/// Creator:Candyxu
/// Createdate:20130504
Class DHCEPRFS.META.PrintScheme Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// PDF打印方案名称
Property SchemeName As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// PDF打印方案名称描述
Property SchemeDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 方案所含项目串
Property SchemeItems As %String(MAXLEN = 50000, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 是否默认
Property IsDefault As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 创建者用户ID
Property CreateUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// 创建者用户ID
Property ModifyUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 8 ];

/// 创建时间
Property CreateTime As %Time [ SqlColumnNumber = 9 ];

/// 修改日期
Property ModifyDate As %Date [ SqlColumnNumber = 10 ];

/// 修改时间
Property ModifyTime As %Time [ SqlColumnNumber = 11 ];

/// 方案排序
Property SchemeOrder As %Integer [ SqlColumnNumber = 12 ];

/// 是否默认生成方案
Property IsCreate As %String(TRUNCATE = 1) [ SqlColumnNumber = 13 ];

/// 方案类型 -  PRINT打印方案，CREATE生成方案， VIEW浏览方案
Property SchemeType As %String(TRUNCATE = 1) [ SqlColumnNumber = 14 ];

/// 方案默认勾选项目串
Property CheckItems As %String(MAXLEN = 5000, TRUNCATE = 1) [ SqlColumnNumber = 15 ];

/// 是否可用
Property IsAvailable As %String(TRUNCATE = 1) [ SqlColumnNumber = 16 ];

/// 辅助项目，目前是用来配合关联就诊使用，对关联就诊的浏览、打印通过辅助项目来配置
Property SchemeSubItems As %String(MAXLEN = 50000, TRUNCATE = 1) [ SqlColumnNumber = 17 ];

/// 方案默认勾选辅助项目串
Property CheckSubItems As %String(MAXLEN = 5000, TRUNCATE = 1) [ SqlColumnNumber = 18 ];

Index IdxSchemeOrder On SchemeOrder;

Index IdxSchemeName On SchemeName;

Index IdxIsDefault On IsDefault;

Index IdxIsCreate On IsCreate;

Index IdxDefaultType On (SchemeType, IsDefault);

Storage Default
{
<Data name="PrintSchemeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SchemeName</Value>
</Value>
<Value name="3">
<Value>SchemeDesc</Value>
</Value>
<Value name="4">
<Value>SchemeItems</Value>
</Value>
<Value name="5">
<Value>IsDefault</Value>
</Value>
<Value name="6">
<Value>CreateUserID</Value>
</Value>
<Value name="7">
<Value>ModifyUserID</Value>
</Value>
<Value name="8">
<Value>CreateDate</Value>
</Value>
<Value name="9">
<Value>CreateTime</Value>
</Value>
<Value name="10">
<Value>ModifyDate</Value>
</Value>
<Value name="11">
<Value>ModifyTime</Value>
</Value>
<Value name="12">
<Value>SchemeOrder</Value>
</Value>
<Value name="13">
<Value>IsCreate</Value>
</Value>
<Value name="14">
<Value>SchemeType</Value>
</Value>
<Value name="15">
<Value>CheckItems</Value>
</Value>
<Value name="16">
<Value>IsAvailable</Value>
</Value>
<Value name="17">
<Value>SchemeSubItems</Value>
</Value>
<Value name="18">
<Value>CheckSubItems</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.PrintSchemeD</DataLocation>
<DefaultData>PrintSchemeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.PrintSchemeD</IdLocation>
<IndexLocation>^DHCEPRFS.META.PrintSchemeI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.PrintSchemeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
