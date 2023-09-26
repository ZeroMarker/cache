/// 对外接口模块列表
Class CT.DOC.Interface.AccessModule Extends (%Persistent, User.Abstract) [ SqlTableName = AccessModule ]
{

Index IdxCode On ModuleCode;

Index IdxDesc On ModuleDesc;

/// 模块代码
Property ModuleCode As %String(COLLATION = "Exact", MAXLEN = 99) [ Required, SqlColumnNumber = 2, SqlFieldName = Module_Code ];

/// 模块描述
Property ModuleDesc As %String(COLLATION = "Exact", MAXLEN = 99) [ Required, SqlColumnNumber = 3, SqlFieldName = Module_Desc ];

/// 开始日期
Property ModuleStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Module_StDate ];

/// 结束日期
Property ModuleEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Module_EndDate ];

/// 模块级扩展数据,厂家模块启用的时候控制必填
Property ModuleExtStr As %String(MAXLEN = 9999) [ SqlColumnNumber = 6, SqlFieldName = Module_ExtStr ];

Storage Default
{
<Data name="CT.DOC.Interface.AccessModuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModuleCode</Value>
</Value>
<Value name="3">
<Value>ModuleDesc</Value>
</Value>
<Value name="4">
<Value>ModuleStDate</Value>
</Value>
<Value name="5">
<Value>ModuleEndDate</Value>
</Value>
<Value name="6">
<Value>ModuleExtStr</Value>
</Value>
</Data>
<DataLocation>^CT.DOC.Interface.AccessModuleD</DataLocation>
<DefaultData>CT.DOC.Interface.AccessModuleDefaultData</DefaultData>
<IdLocation>^CT.DOC.Interface.AccessModuleD</IdLocation>
<IndexLocation>^CT.DOC.Interface.AccessModuleI</IndexLocation>
<SqlRowIdName>Module_Rowid</SqlRowIdName>
<StreamLocation>^CT.DOC.Interface.AccessModuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
