/// 统一参数配置保存
Class User.BDPPreferences Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock, SqlTableName = BDP_Preferences ]
{

/// 1. 系统级别授权定义	==SYS
/// 2. 界面元素有效性授权定义==Element
/// 3. 基础数据授权定义	==BaseData
Property AppKey As %String(DISPLAYLIST = ",SYS,Element,BaseData,Translation", TRUNCATE = 1, VALUELIST = ",SYS,E,BD,T") [ Required, SqlFieldName = AppKey ];

/// 1. 系统级别授权定义含有： 1.1 菜单定义 Menu；1.2 
/// 2. 界面元素有效性授权定义, 保存对应的功能名称,对应的User.BDPExecutables表的Code
/// 3. 基础数据授权定义, 对应的表名称：CTLoc,SSUser等
Property AppSubKey As %String(TRUNCATE = 1) [ Required, SqlFieldName = AppSubKey ];

/// 授权数据对应解析类
Property CorrespondingClass As %String(TRUNCATE = 1) [ SqlFieldName = CorrespondingClass ];

/// 数据的存储格式: XML、 JSON等格式
Property DataSplitString As %String(TRUNCATE = 1) [ Required, SqlFieldName = DataSplitString ];

/// / 授权存储的数据
Property Data As %String(MAXLEN = 99999, TRUNCATE = 1) [ SqlFieldName = Data ];

/// User或者Loc或者Group或者Hospital或者SITE对应的 数据，即对应表的RowID或者对应的代码等
Property ObjectReference As %String(TRUNCATE = 1) [ Required, SqlFieldName = ObjectReference ];

Property DataMapMode As %String(TRUNCATE = 1) [ SqlFieldName = DataMapMode ];

/// 优先级类别
Property ObjectType As %String(DISPLAYLIST = ",IP,User.SSUser,User.CTLoc,User.SSGroup,User.CTHospital,SITE", TRUNCATE = 1, VALUELIST = ",IP,U,L,G,H,S") [ Required, SqlFieldName = ObjectType ];

Index AppKeyIdx On (AppSubKey, AppKey);

Index UqIndex On (ObjectType, ObjectReference, AppKey, AppSubKey) [ Unique ];

Storage Default
{
<Data name="BDPPreferencesClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BDPPreferencesDefaultData">
<Value name="1">
<Value>AppKey</Value>
</Value>
<Value name="2">
<Value>AppSubKey</Value>
</Value>
<Value name="3">
<Value>ObjectType</Value>
</Value>
<Value name="4">
<Value>ObjectReference</Value>
</Value>
<Value name="5">
<Value>DataSplitString</Value>
</Value>
<Value name="6">
<Value>CorrespondingClass</Value>
</Value>
<Value name="7">
<Value>Data</Value>
</Value>
<Value name="8">
<Value>DataMapMode</Value>
</Value>
</Data>
<DataLocation>^User.BDPPreferencesD</DataLocation>
<DefaultData>BDPPreferencesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPPreferencesD</IdLocation>
<IndexLocation>^User.BDPPreferencesI</IndexLocation>
<StreamLocation>^User.BDPPreferencesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
