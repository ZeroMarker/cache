/// Creater:wangpf
/// Descriptions:多语言
/// Date:2022-11-25
Class CT.DHCINM.Set.MgLang Extends %Persistent
{

/// 菜单类型
Property LangMenuType As %String [ SqlColumnNumber = 2, SqlFieldName = Lang_MenuType ];

/// 菜单代码
Property LangMenuCode As %String [ SqlColumnNumber = 3, SqlFieldName = Lang_MenuCode ];

/// 类型 M:菜单描述 B:Button L:Label
Property LangType As %String [ SqlColumnNumber = 4, SqlFieldName = Lang_Type ];

/// 代码
Property LangCode As %String [ Required, SqlColumnNumber = 5, SqlFieldName = Lang_Code ];

/// 语言类型
Property LangSubType As CT.DHCINM.Set.MgSysParamSub [ SqlColumnNumber = 6, SqlFieldName = Lang_SubType ];

/// 描述
Property LangDesc As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Lang_Desc ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 8, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = Create_Time ];

Index MenuCode On (LangMenuType, LangMenuCode, LangCode);

Index MenuSubType On (LangMenuType, LangMenuCode, LangSubType, LangType);

Index UniqueKey On (LangMenuType, LangMenuCode, LangType, LangCode, LangSubType);

Storage Default
{
<Data name="MgLangDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LangMenuType</Value>
</Value>
<Value name="3">
<Value>LangMenuCode</Value>
</Value>
<Value name="4">
<Value>LangType</Value>
</Value>
<Value name="5">
<Value>LangCode</Value>
</Value>
<Value name="6">
<Value>LangSubType</Value>
</Value>
<Value name="7">
<Value>LangDesc</Value>
</Value>
<Value name="8">
<Value>Creator</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
<Value name="10">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^CT.DHCINM.Set.MgLangD</DataLocation>
<DefaultData>MgLangDefaultData</DefaultData>
<IdLocation>^CT.DHCINM.Set.MgLangD</IdLocation>
<IndexLocation>^CT.DHCINM.Set.MgLangI</IndexLocation>
<StreamLocation>^CT.DHCINM.Set.MgLangS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
