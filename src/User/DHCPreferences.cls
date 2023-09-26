/// 统一参数配置保存
Class User.DHCPreferences Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlTableName = DHC_Preferences ]
{

Property AppKey As %String(DISPLAYLIST = ",Enroll,Registeration,OPCharge", TRUNCATE = 1, VALUELIST = ",E,R,OPC") [ Required, SqlFieldName = AppKey ];

/// 需要各个组自己定义，不能重复
Property AppSubKey As %String(TRUNCATE = 1) [ Required, SqlFieldName = AppSubKey ];

Property CorrespondingClass As %String(TRUNCATE = 1) [ SqlFieldName = CorrespondingClass ];

Property DataSplitString As %String(TRUNCATE = 1) [ Required, SqlFieldName = DataSplitString ];

Property Data As %String(MAXLEN = 99999, TRUNCATE = 1) [ SqlFieldName = Data ];

Property ObjectReference As %String(TRUNCATE = 1) [ Required, SqlFieldName = ObjectReference ];

Property DataMapMode As %String(TRUNCATE = 1) [ SqlFieldName = DataMapMode ];

/// 优先级类别
Property ObjectType As %String(DISPLAYLIST = ",IP,User.SSUser,User.CTLoc,User.SSGroup,User.CTHospital,SITE", TRUNCATE = 1, VALUELIST = ",IP,U,L,G,H,S") [ Required, SqlFieldName = ObjectType ];

Index AppKeyIdx On (AppSubKey, AppKey);

Index UqIndex On (ObjectType, ObjectReference, AppKey, AppSubKey) [ Unique ];

Storage Default
{
<Data name="DHCPreferencesClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCPreferencesDefaultData">
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
<DataLocation>^User.DHCPreferencesD</DataLocation>
<DefaultData>DHCPreferencesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPreferencesD</IdLocation>
<IndexLocation>^User.DHCPreferencesI</IndexLocation>
<StreamLocation>^User.DHCPreferencesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
