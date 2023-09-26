Class EPRmeta.CentralizedPrint.CentralizedPrintScheme Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 集中打印方案名称
Property SchemeName As %String(TRUNCATE = 1);

/// 集中打印方案名称描述
Property SchemeDesc As %String(TRUNCATE = 1);

/// 方案所含项目串
Property SchemeItems As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 是否默认
Property IsDefault As %String(TRUNCATE = 1);

/// 创建者用户ID
Property CreateUserID As %String(TRUNCATE = 1);

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 修改日期
Property ModifyDate As %Date;

/// 修改时间
Property ModifyTime As %Time;

/// 方案排序
Property SchemeOrder As %Integer;

/// 是否PDF生成方案
Property IsPDF As %String(TRUNCATE = 1);

Index IdxSchemeOrder On SchemeOrder;

Index IdxSchemeName On SchemeName;

Index IdxIsDefault On IsDefault;

Index IdxIsPDF On IsPDF;

Storage Default
{
<Data name="CentralizedPrintSchemeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SchemeDesc</Value>
</Value>
<Value name="3">
<Value>SchemeItems</Value>
</Value>
<Value name="4">
<Value>SchemeName</Value>
</Value>
<Value name="5">
<Value>IsDefault</Value>
</Value>
<Value name="6">
<Value>CreateUserID</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
<Value name="9">
<Value>ModifyDate</Value>
</Value>
<Value name="10">
<Value>ModifyTime</Value>
</Value>
<Value name="11">
<Value>SchemeOrder</Value>
</Value>
<Value name="12">
<Value>IsPDF</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.CentralizedPrintSchemeD</DataLocation>
<DefaultData>CentralizedPrintSchemeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.CentralizedPrintSchemeD</IdLocation>
<IndexLocation>^DHCEPRM.CentralizedPrintSchemeI</IndexLocation>
<StreamLocation>^DHCEPRM.CentralizedPrintSchemeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
