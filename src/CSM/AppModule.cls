/// 模块表
Class CSM.AppModule Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxParentID On ParentID;

/// 所属应用程序ID
Property ApplicationID As %Integer [ Required ];

/// 模块/栏目名称当ParentID为0为模块名称
Property CName As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 功能模块ID号
/// Property ModuleID As %Integer [ Required ];
/// 模块/栏目目录名
Property Directory As %String(MAXLEN = 255, TRUNCATE = 1);

/// 模块Icon位置
Property Icon As %String(MAXLEN = 255, TRUNCATE = 1);

/// 是否为系统模块1:是0:否如为系统则无法修改
Property IsSystem As %String(MAXLEN = 1, TRUNCATE = 1);

/// 当前所在排序级别支持双层99级菜单
Property OrderLevel As %String(MAXLEN = 4, TRUNCATE = 1);

/// 模块编码Parent为0,则为Sxx,否则为SxxMxx
Property PageCode As %String(MAXLEN = 6, TRUNCATE = 1) [ Required ];

/// 所属父级模块ID与ModuleID关联,0为顶级
Property ParentID As %Integer [ Required ];

/// 模块状态：正常1/关闭0
Property Status As %String(MAXLEN = 1, TRUNCATE = 1);

Property ReflectClassName As %String(MAXLEN = 100, TRUNCATE = 1);

Property Visible As %String(MAXLEN = 1, TRUNCATE = 1) [ InitialExpression = "1", Required ];

Index IdxAppID On ApplicationID;

Storage Default
{
<Data name="AppModuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ApplicationID</Value>
</Value>
<Value name="3">
<Value>ModuleID</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>Directory</Value>
</Value>
<Value name="6">
<Value>PageCode</Value>
</Value>
<Value name="7">
<Value>ParentID</Value>
</Value>
<Value name="8">
<Value>OrderLevel</Value>
</Value>
<Value name="9">
<Value>IsSystem</Value>
</Value>
<Value name="10">
<Value>Icon</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
<Value name="12">
<Value>ReflectClassName</Value>
</Value>
<Value name="13">
<Value>Visible</Value>
</Value>
</Data>
<DataLocation>^CSM.AppModuleD</DataLocation>
<DefaultData>AppModuleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.AppModuleD</IdLocation>
<IndexLocation>^CSM.AppModuleI</IndexLocation>
<StreamLocation>^CSM.AppModuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
