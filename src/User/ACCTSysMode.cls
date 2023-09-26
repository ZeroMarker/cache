/// 例:药品管理
Class User.ACCTSysMode Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = ACCT_SysMode ]
{

Property ModCode As %String(MAXLEN = 20) [ Required, SqlFieldName = mod_code ];

Property ModName As %String(MAXLEN = 50) [ Required, SqlFieldName = mod_name ];

Property IsAutoVouch As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ SqlFieldName = is_auto_vouch ];

Index PKModeCode On ModCode [ Unique ];

Storage Default
{
<Data name="ACCTSysModeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IsAutoVouch</Value>
</Value>
<Value name="3">
<Value>ModCode</Value>
</Value>
<Value name="4">
<Value>ModName</Value>
</Value>
</Data>
<DataLocation>^User.ACCTSysModeD</DataLocation>
<DefaultData>ACCTSysModeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTSysModeD</IdLocation>
<IndexLocation>^User.ACCTSysModeI</IndexLocation>
<StreamLocation>^User.ACCTSysModeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
